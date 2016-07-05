<!-- ***************************************************************************************
* Name:				CF_mpgAPI_CF5
* File:				mpgAPI_CF5.cfm
* Created:			Mar. 18, 2005
* Last Modified:	Nov 11, 2012
*						- Added Partial Auth functionality
* Version:			2.5.2 (adaptation of eSelect_CF5.cfm file)
* Author:			Christian Malek (Moneris Solutions)
* Description:		CF_mpgAPI_CF5 is a custom CFML tag that processes credit card
* 					transactions through the Moneris Solutions eSelect Plus gateway.
* Attributes:		REQUIRED:
*						host = gateway URL.
*						store_id (string) = id to identify unique store.
*						api_token (string) = unique per store.
*						txn_array (array) = array of transaction parameters.
*					OPTIONAL:
*						cust_info_array (array) = array of array of level 3 data;
*							((billing.first_name, .last_name, .company_name, .address,
*									.city, .province, .postal_code, .country,
*									.phone_number, .fax, .tax1, .tax2,
*									.tax3, .shipping_cost),
*							(shipping.first_name, .last_name, .company_name, .address,
*									.city, .province, .postal_code, .country,
*									.phone_number, .fax, .tax1, .tax2,
*									.tax3, .shipping_cost),
*							(email.email),
*							(instructions.instruction),
*							(item.name, .quantity, .product_code, .extended_amount)+)
*						cust_id (string) = optional user defined data.
*						recur (array) = array of recurring transaction parameters;
*							(recur_unit, start_now, start_date, num_recurs, period, recur_amount)
*                       avs_info_array (array) = array of avs values;
*                           (avs_street_number, avs_street_name, avs_zipcode)
*                       cvd_info_array (array) = array of cvd values;
*                           (cvd_indicator, cvd_value)
* Outputs:			response_struct (structore) = structure of response data.
*************************************************************************************** -->
<cfif (NOT isDefined( "attributes.host" ))>
	<cfthrow type="Custom.Tag.mpgAPI_CF5" message="Host URL not defined for CF_mpgAPI_CF5 tag!">
<cfelseif (NOT isDefined( "attributes.store_id" ))>
	<cfthrow type="Custom.Tag.mpgAPI_CF5" message="Store ID not defined for CF_mpgAPI_CF5 tag!">
<cfelseif (NOT isDefined( "attributes.api_token" ))>
	<cfthrow type="Custom.Tag.mpgAPI_CF5" message="API Token not defined for CF_mpgAPI_CF5 tag!">
<cfelseif (isDefined( "attributes.status_check" ))>
	<cfset status = attributes.status_check>
<cfelseif (NOT isDefined( "attributes.txn_array" )) OR (NOT isArray( attributes.txn_array ))>
	<cfthrow type="Custom.Tag.mpgAPI_CF5" message="Transaction Array not passed properly for CF_mpgAPI_CF5 tag!">
</cfif>

<cfif isDefined( "attributes.cust_info_array" )>
	<cfset custinfo = attributes.cust_info_array>
	<cfif (NOT isArray(custinfo))>
		<cfthrow type="Custom.Tag.mpgAPI_CF5" message="cust_info_array is not an array for CF_mpgAPI_CF5 tag!">
	<cfelse>
		<cfloop from=1 to=#arrayLen(custinfo)# index=i>
			<cfif (NOT isArray(custinfo[i]))>
				<cfthrow type="Custom.Tag.mpgAPI_CF5" message="cust_info_array not defined properly for CF_mpgAPI_CF5 tag!">
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<cfif isDefined( "attributes.recur" )>
	<cfset recur = attributes.recur>
	<cfif (NOT isArray(recur))>
		<cfthrow type="Custom.Tag.mpgAPI_CF5" message="recur is not an array for CF_mpgAPI_CF5 tag!">
	</cfif>
</cfif>

<cfif isDefined("attributes.avs_info_array")>
	<cfset avsinfo = attributes.avs_info_array>
    <cfif (NOT isArray(avsinfo))>
        <cfthrow type="Custom.Tag.mpgAPI_CF5" message="avs_info_array is not an array for CF_mpgAPI_CF5 tag!">
        </cfif>
</cfif>

<cfif isDefined("attributes.cvd_info_array")>
    <cfset cvdinfo = attributes.cvd_info_array>
    <cfif (NOT isArray(cvdinfo))>
        <cfthrow type="Custom.Tag.mpgAPI_CF5" message="cvd_info_array is not an array for CF_mpgAPI_CF5 tag!">
        </cfif>
</cfif>

<cfif (isDefined( "attributes.dynamic_descriptor" ))>
	<cfset dynamic_descriptor = attributes.dynamic_descriptor>
</cfif>

<cfscript>
//function to return the value of the XML node in the response
function getNodeValueByName(XML, nodeName) {
	start = findNoCase("<" & nodeName & ">",XML,1);
	start = start + len(nodeName) + 2;
	end = findNoCase("</" & nodeName & ">",XML,1);
  if (end LTE start) {
  return "";
 }
	return mid(XML,start,end-start);
}
</cfscript>

<cfscript>
//populate all the required fields
gatewayHost = attributes.host;
storeId = attributes.store_id;
apiToken = attributes.api_token;

if( isDefined("attributes.status_check") )
{
	status = attributes.status_check;
}

txnArray = arrayNew(1);
txnArray = attributes.txn_array;
if( isDefined("attributes.cust_info_array") ) {
	custInfoArray = arrayNew(1);
	custInfoArray = attributes.cust_info_array;
}
recurTxn = 0;
if( isDefined("attributes.avs_info_array") ) {
        avsInfoArray = arrayNew(1);
        avsInfoArray = attributes.avs_info_array;
}
if( isDefined("attributes.cvd_info_array") ) {
        cvdInfoArray = arrayNew(1);
        cvdInfoArray = attributes.cvd_info_array;
}

if( isDefined("attributes.dynamic_descriptor") )
{
	dynamic_descriptor = attributes.dynamic_descriptor;
}

requiredArray = arrayNew(1);

switch( txnArray[1] ) {
	case "idebit_purchase": {
		if( isDefined( "attributes.cust_id" ) ) {
			requiredArray = listToArray("order_id,cust_id,amount,idebit_track2");
			ArrayInsertAt( txnArray, 3, attributes.cust_id );
		}
		else {
			requiredArray = listToArray("order_id,amount,idebit_track2");
		}
		optFields = true;
		break;
	}
	case "idebit_refund": {
		requiredArray = listToArray("order_id,amount,txn_number");
		optFields = false;
		break;
	}
	case "purchase_reversal": {
		requiredArray = listToArray("order_id,amount");
		optFields = false;
		break;
	}
	case "refund_reversal": {
		requiredArray = listToArray("order_id,amount");
		optFields = false;
		break;
	}
	case "cavv_purchase": {
		if( isDefined( "recur" ) ) {
			recurTxn = 1;
		}
		if( isDefined( "attributes.cust_id" ) ) {
			requiredArray = listToArray("order_id,cust_id,amount,pan,expdate,cavv");
			ArrayInsertAt( txnArray, 3, attributes.cust_id );
		}
		else {
			requiredArray = listToArray("order_id,amount,pan,expdate,cavv");
		}
		optFields = true;
		break;
	}
	case "cavv_preauth": {
		if( isDefined( "attributes.cust_id" ) ) {
			requiredArray = listToArray("order_id,cust_id,amount,pan,expdate,cavv");
			ArrayInsertAt( txnArray, 3, attributes.cust_id );
		}
		else {
			requiredArray = listToArray("order_id,amount,pan,expdate,cavv");
		}
		optFields = true;
		break;
	}
	case "purchase": {
		if( isDefined( "recur" ) ) {
			recurTxn = 1;
		}
		if( isDefined( "attributes.cust_id" ) ) {
			requiredArray = listToArray("order_id,cust_id,amount,pan,expdate,crypt_type");
			ArrayInsertAt( txnArray, 3, attributes.cust_id );
		}
		else {
			requiredArray = listToArray("order_id,amount,pan,expdate,crypt_type");
		}
		optFields = true;
		break;
	}
	case "preauth": {
		if( isDefined( "attributes.cust_id" ) ) {
			requiredArray = listToArray("order_id,cust_id,amount,pan,expdate,crypt_type");
			ArrayInsertAt( txnArray, 3, attributes.cust_id );
		}
		else {
			requiredArray = listToArray("order_id,amount,pan,expdate,crypt_type");
		}
		optFields = true;
		break;
	}
	case "card_verification": {
		requiredArray = listToArray("order_id,pan,expdate,crypt_type");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = true;
		break;
	}
	case "reauth": {
		requiredArray = listToArray("order_id,orig_order_id,txn_number,amount,crypt_type");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = true;
		break;
	}
	case "completion": {
		requiredArray = listToArray("order_id,comp_amount,txn_number,crypt_type,ship_indicator");
		optFields = false;
		break;
	}
	case "purchasecorrection": {
		requiredArray = listToArray("order_id,txn_number,crypt_type,ship_indicator");
		optFields = false;
		break;
	}
	case "refund": {
		requiredArray = listToArray("order_id,amount,txn_number,crypt_type");
		optFields = false;
		break;
	}
	case "ind_refund": {
	    if( isDefined( "attributes.cust_id" ) ) {
		    requiredArray = listToArray("order_id,cust_id,amount,pan,expdate,crypt_type");
		    ArrayInsertAt( txnArray, 3, attributes.cust_id );
		}
		else {
			requiredArray = listToArray("order_id,amount,pan,expdate,crypt_type");
	    }
		optFields = false;
		break;
	}
    case "batchclose": {
		requiredArray = listToArray("ecr_number");
		optFields = false;
		break;
	}
	case "batchcloseall": {
		requiredArray = listToArray("");
		optFields = false;
		break;
	}
	case "opentotals": {
		requiredArray = listToArray("ecr_number");
		optFields = false;
		break;
	}
	case "recur_update": {
		requiredArray[1]="order_id";
		elementCount = 2;

		if( isDefined( "attributes.cust_id" ) ) {
			requiredArray[elementCount] = "cust_id";
			elementCount = elementCount +1;
			txnArray[elementCount] = attributes.cust_id;
		}
		if( isDefined( "attributes.pan" ) ) {
			requiredArray[elementCount] = "pan";
			elementCount = elementCount +1;
			txnArray[elementCount] = attributes.pan;
		}
		if( isDefined( "attributes.expdate" ) ) {
			requiredArray[elementCount] = "expdate";
			elementCount = elementCount +1;
			txnArray[elementCount] = attributes.expdate;
		}
		if( isDefined( "attributes.recur_amount" ) ) {
			requiredArray[elementCount] = "recur_amount";
			elementCount = elementCount +1;
			txnArray[elementCount] = attributes.recur_amount;
		}
		if( isDefined( "attributes.add_num_recurs" ) ) {
			requiredArray[elementCount] = "add_num_recurs";
			elementCount = elementCount +1;
			txnArray[elementCount] = attributes.add_num_recurs;
		}
		if( isDefined( "attributes.total_num_recurs" ) ) {
			requiredArray[elementCount] = "total_num_recurs";
			elementCount = elementCount +1;
			txnArray[elementCount] = attributes.total_num_recurs;
		}
		if( isDefined( "attributes.hold" ) ) {
			requiredArray[elementCount] = "hold";
			elementCount = elementCount +1;
			txnArray[elementCount] = attributes.hold;
		}
		if( isDefined( "attributes.terminate" ) ) {
			requiredArray[elementCount] = "terminate";
			elementCount = elementCount +1;
			txnArray[elementCount] = attributes.terminate;
		}
		optFields = false;
		break;
	}
	default: {
		//Throw exception here.
		break;
	}
}


/*************************************************************
**************************************************************
** Loop through all of the required fields for this			**
** trans_type.  If any of the fields have not been supplied **
** then we populate our errorArray which will in turn throw **
** a custom error message									**
**************************************************************
*************************************************************/
for(i=2; i LTE arrayLen(requiredArray)+1; i=i+1) {
	"#requiredArray[i-1]#" = txnArray[i];
}


/**************************************************************
 **************************************************************
 ** Begin generating our XML file.  We first loop through	 **
 ** and add all of the required attributes based on the 		 **
 ** trans_type that is being used.  Then we check to see if  **
 ** the optional attributes are even applicable, if they are,**
 ** then we append any optional variables there were sent in **
 **************************************************************
 **************************************************************/
//we now begin the creation of the XML document
//the standard data that is required will all types of transactions
xml = "<?xml version=""1.0"" standalone=""yes""?>";
xml = xml & "<request>";
xml = xml & "<store_id>" & storeId & "</store_id>";
xml = xml & "<api_token>" & apiToken & "</api_token>";

if (isDefined("attributes.status_check") )
{
	xml = xml & "<status_check>" & status & "</status_check>";
}

//open the tag for the transaction type
xml = xml & "<" & txnArray[1] & ">";

//loop through the required fields for the given transaction type
for( i=1; i LTE arrayLen(requiredArray); i=i+1 ) {
	xml = xml & "<" & requiredArray[i] & ">";
	xml = xml & evaluate(requiredArray[i]);
	xml = xml & "</" & requiredArray[i] & ">";
}

if (isDefined("attributes.dynamic_descriptor") )
{
	xml = xml & "<dynamic_descriptor>" & dynamic_descriptor & "</dynamic_descriptor>";
}

//check to see if we have any optional AVS fields
//optionals are only used in the purchase and preauth
if( isDefined("attributes.avs_info_array") ) {
    if( optFields EQ true ) {
        //open the optional avs_info tag
        xml = xml & "<avs_info>";


        avsInfoNameArray = listToArray( "avs_street_number,avs_street_name,avs_zipcode,avs_email,avs_hostname,avs_browser,avs_shiptocountry,avs_shipmethod,avs_merchprodsku,avs_custip,avs_custphone" );



		//Form avs info.
		 for( i=1; i LTE arrayLen(avsInfoNameArray); i=i+1 ) {
			xml = xml & "<" & avsInfoNameArray[i] & ">" & avsInfoArray[i] & "</" & avsInfoNameArray[i] & ">";
		}

		//close the optional avs_info tag
		xml = xml & "</avs_info>";
	}
}

//check to see if we have any optional CVD fields
//optionals are only used in the purchase and preauth
if( isDefined("attributes.cvd_info_array") ) {
    if( optFields EQ true ) {
        //open the optional cvd_info tag
        xml = xml & "<cvd_info>";


        cvdInfoNameArray = listToArray( "cvd_indicator,cvd_value" );



		//Form cvd info.
		 for( i=1; i LTE arrayLen(cvdInfoNameArray); i=i+1 ) {
			xml = xml & "<" & cvdInfoNameArray[i] & ">" & cvdInfoArray[i] & "</" & cvdInfoNameArray[i] & ">";
		}

		//close the optional cvd_info tag
		xml = xml & "</cvd_info>";
	}
}

//check to see if we should even bother looking for the optional fields
//optionals are only used in the purchase and preauth
if( isDefined("attributes.cust_info_array") ) {
	if( optFields EQ true ) {
		//open the optional cust_info tag
		xml = xml & "<cust_info>";

		billingArray = listToArray( "first_name,last_name,company_name,address,city,province,postal_code,country,phone_number,fax,tax1,tax2,tax3,shipping_cost" );
		shippingArray = listToArray( "first_name,last_name,company_name,address,city,province,postal_code,country,phone_number,fax,tax1,tax2,tax3,shipping_cost" );
		emailArray = listToArray( "email" );
		instructionsArray = listToArray( "instructions" );
		itemArray = listToArray( "name,quantity,product_code,extended_amount" );

		//Form billing info.
		xml = xml & "<billing>";
		for( i=1; i LTE arrayLen(billingArray); i=i+1 ) {
			xml = xml & "<" & billingArray[i] & ">" & custInfoArray[1][i] & "</" & billingArray[i] & ">";
		}
		xml = xml & "</billing>";

		//Form shipping info.
		xml = xml & "<shipping>";
		for( i=1; i LTE arrayLen(shippingArray); i=i+1 ) {
			xml = xml & "<" & shippingArray[i] & ">" & custInfoArray[2][i] & "</" & shippingArray[i] & ">";
		}
		xml = xml & "</shipping>";

		//Form email info.
		xml = xml & "<email>" & custInfoArray[3][1] & "</email>";

		//Form instructions info.
		xml = xml & "<instructions>" & custInfoArray[4][1] & "</instructions>";

		//Form item info.
		for( i=5; i LTE arrayLen(custInfoArray); i=i+1 ) {
			xml = xml & "<item>";
			for( j=1; j LTE arrayLen(itemArray); j=j+1 ) {
				xml = xml & "<" & itemArray[j] & ">" & custInfoArray[i][j] & "</" & itemArray[j] & ">";
			}
			xml = xml & "</item>";
		}

		//close the optiona cust_info tag
		xml = xml & "</cust_info>";
	}
}

//check for the optional cust_id value



//form recurring transaction xml.
if( isDefined( "recur" ) AND (recurTxn EQ 1) ) {
	recurFieldArray = arrayNew(1);
	recurFieldArray = listToArray("recur_unit,start_now,start_date,num_recurs,period,recur_amount");
	xml = xml & "<recur>";
	for( i=1; i LTE arrayLen(recurFieldArray); i=i+1 ) {
		xml = xml & "<" & recurFieldArray[i] & ">";
		xml = xml & recur[i];
		xml = xml & "</" & recurFieldArray[i] & ">";
	}
	xml = xml & "</recur>";
}

//close the tag for the transaction type
xml = xml & "</" & txnArray[1] & ">";

//close the top level tag
xml = xml & "</request>";


/**************************************************************
 **************************************************************
 ** Send the data to the eSelect server using the      		 **
 ** Microsoft.xmlHttp COM object.  Because we are using		 **
 ** this method, this code is only compatible with     		 **
 ** Windows NT 4, 2000, 2003 CF Servers.					 **
 **************************************************************
 **************************************************************/
/*
objHTTP = createObject("COM","microsoft.xmlhttp");
objHTTP.open("POST", gatewayHost, false);
objHTTP.setRequestHeader("Content-Type", "text/xml");
objHTTP.send(xml);

//Capture the response from the server into a local variable
responseXML = objHTTP.responseText;
*/
</cfscript>

<!-- For Unix users (also works in Windows). -->
<!-- Note: commenting this out and using the COM method will cause duplicate order id error.  Something in this commented code is causing the xml to be mushed up.-->
<cfset TransactionXml = ToString(#xml#)>
<cfhttp method="post" url="#gatewayHost#" timeout="60" throwonerror="yes" resolveurl="yes" userAgent = "ColdFusion - 2.5.0">
	<cfhttpparam name="txnXml" type="xml" value="#TransactionXml#">
</cfhttp>
<cfset responseXML = #cfhttp.fileContent#>

<cfscript>
//Set the variables at the caller scope so that the calling tag has
//access to the return variables
caller.response_struct = structNew();
caller.response_struct['ReceiptID'] = getNodeValueByName(responseXML,"receiptID");
caller.response_struct['ReferenceNum'] = getNodeValueByName(responseXML,"referenceNum");
caller.response_struct['ResponseCode'] = getNodeValueByName(responseXML,"ResponseCode");
caller.response_struct['ISO'] = getNodeValueByName(responseXML,"ISO");
caller.response_struct['AuthCode'] = getNodeValueByName(responseXML,"AuthCode");
caller.response_struct['TransTime'] = getNodeValueByName(responseXML,"TransTime");
caller.response_struct['TransDate'] = getNodeValueByName(responseXML,"TransDate");
caller.response_struct['TransType'] = getNodeValueByName(responseXML,"TransType");
caller.response_struct['Complete'] = getNodeValueByName(responseXML,"Complete");
caller.response_struct['Message'] = getNodeValueByName(responseXML,"Message");
caller.response_struct['TransAmount'] = getNodeValueByName(responseXML,"TransAmount");
caller.response_struct['CardType'] = getNodeValueByName(responseXML,"CardType");
caller.response_struct['TransID'] = getNodeValueByName(responseXML,"TransID");
caller.response_struct['TimedOut'] = getNodeValueByName(responseXML,"TimedOut");
caller.response_struct['BankTotals'] = getNodeValueByName(responseXML,"BankTotals");
caller.response_struct['Ticket'] = getNodeValueByName(responseXML,"Ticket");
caller.response_struct['RecurSuccess'] = getNodeValueByName(responseXML,"RecurSuccess");
caller.response_struct['RecurUpdateSuccess'] = getNodeValueByName(responseXML,"RecurUpdateSuccess");
caller.response_struct['NextRecurDate'] = getNodeValueByName(responseXML,"NextRecurDate");
caller.response_struct['RecurEndDate'] = getNodeValueByName(responseXML,"RecurEndDate");
caller.response_struct['AvsResultCode'] = getNodeValueByName(responseXML,"AvsResultCode");
caller.response_struct['CvdResultCode'] = getNodeValueByName(responseXML,"CvdResultCode");
caller.response_struct['ITDResponse'] = getNodeValueByName(responseXML,"ITDResponse");
caller.response_struct['CavvResultCode'] = getNodeValueByName(responseXML,"CavvResultCode");
caller.response_struct['StatusCode'] = getNodeValueByName(responseXML,"status_code");
caller.response_struct['StatusMessage'] = getNodeValueByName(responseXML,"status_message");
</cfscript>