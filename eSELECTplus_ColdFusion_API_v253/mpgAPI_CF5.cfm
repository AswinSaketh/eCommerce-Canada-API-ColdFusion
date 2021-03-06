<!--- ***************************************************************************************
* Name:				CF_mpgAPI_CF5
* File:				mpgAPI_CF5.cfm
* Created:			Mar. 18, 2005
* Last Modified:	Mar. 5, 2015
*						- Added support for expdate, ResMpiTxn, VDotMe
* Version:			2.5.3
* Author:			Moneris Solutions
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
*************************************************************************************** --->
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

<cfif (isDefined( "attributes.expdate" ))>
	<cfset expdate = attributes.expdate>
</cfif>

<cfif (isDefined( "attributes.dynamic_descriptor" ))>
	<cfset dynamic_descriptor = attributes.dynamic_descriptor>
</cfif>

<cfif (isDefined( "attributes.ship_indicator" ))>
	<cfset ship_indicator = attributes.ship_indicator>
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
//function to return an array of the same multiple XML node in the response
function getMultiNodeValueByName(XML, nodeName)
{
	startLen = 1;
	nodeArray = arrayNew(1);

	while (startLen LT (len(XML)-len(nodeName)))
	{
		start = findNoCase("<" & nodeName & ">",XML,startLen);
		if(start GT 0)
		{
			start = start + len(nodeName) + 2;
			end = findNoCase("</" & nodeName & ">",XML,startLen);
			startLen = end + len(nodeName) + 3;
			count = end-start;
			if (count LTE 0)
			{
				count = len(XML)-start;
				ArrayAppend(nodeArray, mid(XML,start,count));
				startLen = len(XML);
			}
			else
			{
				ArrayAppend(nodeArray, mid(XML,start,count));
			}
		}
		else
		{
			startLen = len(XML);
		}
	}
	return nodeArray;
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

if( isDefined("attributes.expdate") )
{
	 expdate = attributes.expdate;
}

if( isDefined("attributes.dynamic_descriptor") )
{
	dynamic_descriptor = attributes.dynamic_descriptor;
}

if( isDefined("attributes.ship_indicator") )
{
	ship_indicator = attributes.ship_indicator;
}

requiredArray = arrayNew(1);

switch( txnArray[1] ) {
	case "idebit_purchase": {
		requiredArray = listToArray("order_id,amount,idebit_track2");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}

		optFields = true;
		break;
	}
	case "idebit_refund": {
		requiredArray = listToArray("order_id,amount,txn_number");
		optFields = false;
		break;
	}
	case "cavv_purchase": {
		requiredArray = listToArray("order_id,amount,pan,expdate,cavv");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		if( isDefined( "recur" ) ) {
			recurTxn = 1;
		}

		optFields = true;
		break;
	}
	case "cavv_preauth": {
		requiredArray = listToArray("order_id,amount,pan,expdate,cavv");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = true;
		break;
	}
	case "purchase": {
		requiredArray = listToArray("order_id,amount,pan,expdate,crypt_type");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		if( isDefined( "recur" ) ) {
			recurTxn = 1;
		}
		optFields = true;
		break;
	}
	case "preauth": {
		requiredArray = listToArray("order_id,amount,pan,expdate,crypt_type");
		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
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
		requiredArray = listToArray("order_id,comp_amount,txn_number,crypt_type");
		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = false;
		break;
	}
	case "purchasecorrection": {
		requiredArray = listToArray("order_id,txn_number,crypt_type");
		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = false;
		break;
	}
	case "refund": {
		requiredArray = listToArray("order_id,amount,txn_number,crypt_type");
		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = false;
		break;
	}
	case "ind_refund": {
		requiredArray = listToArray("order_id,amount,pan,expdate,crypt_type");
		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
	    optFields = false;
		break;
	}
    case "batchclose": {
		requiredArray = listToArray("ecr_number");
		optFields = false;
		break;
	}
	case "opentotals": {
		requiredArray = listToArray("ecr_number");
		optFields = false;
		break;
	}
	case "recur_update": {
		requiredArray = listToArray("order_id");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		if( isDefined( "attributes.pan" ) ) {
			ArrayAppend(requiredArray, "pan");
			ArrayAppend(txnArray, attributes.pan);
		}
		if( isDefined( "attributes.expdate" ) ) {
			ArrayAppend(requiredArray, "expdate");
			ArrayAppend(txnArray, attributes.expdate);
		}
		if( isDefined( "attributes.recur_amount" ) ) {
			ArrayAppend(requiredArray, "recur_amount");
			ArrayAppend(txnArray, attributes.recur_amount);
		}
		if( isDefined( "attributes.add_num_recurs" ) ) {
			ArrayAppend(requiredArray, "add_num_recurs");
			ArrayAppend(txnArray, attributes.add_num_recurs);
		}
		if( isDefined( "attributes.total_num_recurs" ) ) {
			ArrayAppend(requiredArray, "total_num_recurs");
			ArrayAppend(txnArray, attributes.total_num_recurs);
		}
		if( isDefined( "attributes.hold" ) ) {
			ArrayAppend(requiredArray, "hold");
			ArrayAppend(txnArray, attributes.hold);
		}
		if( isDefined( "attributes.terminate" ) ) {
			ArrayAppend(requiredArray, "terminate");
			ArrayAppend(txnArray, attributes.terminate);
		}
		optFields = false;
		break;
	}
	case "res_add_cc": {
		requiredArray = listToArray("cust_id,phone,email,note,pan,expdate,crypt_type");
		optFields = true;
	    break;
    }
    case "res_update_cc": {
		requiredArray = listToArray("data_key");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		if( isDefined( "attributes.phone" ) ) {
			ArrayAppend(requiredArray, "phone");
			ArrayAppend(txnArray, attributes.phone);
		}
		if( isDefined( "attributes.email" ) ) {
			ArrayAppend(requiredArray, "email");
			ArrayAppend(txnArray, attributes.email);
		}
		if( isDefined( "attributes.note" ) ) {
			ArrayAppend(requiredArray, "note");
			ArrayAppend(txnArray, attributes.note);
		}
		if( isDefined( "attributes.pan" ) ) {
			ArrayAppend(requiredArray, "pan");
			ArrayAppend(txnArray, attributes.pan);
		}
		if( isDefined( "attributes.expdate" ) ) {
			ArrayAppend(requiredArray, "expdate");
			ArrayAppend(txnArray, attributes.expdate);
		}
		if( isDefined( "attributes.crypt_type" ) ) {
			ArrayAppend(requiredArray, "crypt_type");
			ArrayAppend(txnArray, attributes.crypt_type);
		}

		optFields = true;
		break;
	}
	case "res_delete": {
		requiredArray = listToArray("data_key");
		optFields = false;
		break;
	}
	case "res_iscorporatecard": {
		requiredArray = listToArray("data_key");
		optFields = false;
		break;
	}
	case "res_lookup_full": {
		requiredArray = listToArray("data_key");
		optFields = false;
		break;
	}
	case "res_lookup_masked": {
		requiredArray = listToArray("data_key");
		optFields = false;
		break;
	}
	case "res_get_expiring": {
		optFields = false;
		break;
	}
	case "res_purchase_cc": {
		requiredArray = listToArray("data_key,order_id,amount,crypt_type");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		if( isDefined( "recur" ) ) {
			recurTxn = 1;
		}
		optFields = true;
		break;
    }
    case "res_preauth_cc": {
		requiredArray = listToArray("data_key,order_id,amount,crypt_type");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}

		optFields = true;
		break;
	}
	case "res_ind_refund_cc": {
		requiredArray = listToArray("data_key,order_id,amount,crypt_type");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}

		optFields = false;
		break;
	}
	case "res_mpitxn": {
		requiredArray = listToArray("data_key,xid,amount,MD,merchantUrl,accept,userAgent");
		optFields = false;
		break;
	}
	case "res_cavv_purchase_cc": {
		requiredArray = listToArray("data_key,order_id,amount,cavv");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = true;
		break;
    }
    case "res_cavv_preauth_cc": {
		requiredArray = listToArray("data_key,order_id,amount,cavv");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = true;
		break;
	}
	case "vdotme_purchase": {
		requiredArray = listToArray("order_id,amount,callid,crypt_type");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = true;
		break;
	}
	case "vdotme_preauth": {
		requiredArray = listToArray("order_id,amount,callid,crypt_type");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = true;
		break;
	}
	case "vdotme_purchasecorrection": {
		requiredArray = listToArray("order_id,txn_number,crypt_type");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = false;
		break;
	}
	case "vdotme_refund": {
		requiredArray = listToArray("order_id,txn_number,amount,crypt_type");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = false;
		break;
	}
	case "vdotme_completion": {
		requiredArray = listToArray("order_id,comp_amount,txn_number,crypt_type");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = false;
		break;
	}
	case "vdotme_reauth": {
		requiredArray = listToArray("order_id,orig_order_id,txn_number,amount,crypt_type");

		if( isDefined( "attributes.cust_id" ) ) {
			ArrayAppend(requiredArray, "cust_id");
			ArrayAppend(txnArray, attributes.cust_id);
		}
		optFields = false;
		break;
	}
	case "vdotme_getpaymentinfo": {
		requiredArray = listToArray("callid");
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

if (isDefined("attributes.expdate") )
{
	switch (txnArray[1]) {
	 case "recur_update":
	 	break;
	 case "res_update_cc":
	 	break;
	 default: {
	 	xml = xml & "<expdate>" & expdate & "</expdate>";
	 	break;
	 }
	}
}

if (isDefined("attributes.dynamic_descriptor") )
{
	xml = xml & "<dynamic_descriptor>" & dynamic_descriptor & "</dynamic_descriptor>";
}

if ((isDefined("attributes.ship_indicator")) && (txnArray[1] EQ "completion") )
{
	xml = xml & "<ship_indicator>" & ship_indicator & "</ship_indicator>";
}


//check to see if we have any optional AVS fields
//optionals are only used in the purchase and preauth
if( isDefined("attributes.avs_info_array") ) {
    if( optFields EQ true ) {
        //open the optional avs_info tag
        xml = xml & "<avs_info>";

        avsInfoNameArray = listToArray( "avs_street_number,avs_street_name,avs_zipcode" );

		//Form avs info.
		 for( i=1; i LTE arrayLen(avsInfoNameArray); i=i+1 ) {
			xml = xml & "<" & avsInfoNameArray[i] & ">" & avsInfoArray[i] & "</" & avsInfoNameArray[i] & ">";
		}

		//close the optional avs_info tag
		xml = xml & "</avs_info>";
	}
}

if( (isDefined("attributes.avs_info_struct")) AND (optFields EQ true) )
{
	keyArray = StructKeyArray(#attributes.avs_info_struct#);

	xml = xml & "<avs_info>";
	for( i=1; i LTE ArrayLen(keyArray); i=i+1 )
	{
		xml = xml & "<" & keyArray[i] & ">";
		xml = xml & #attributes.avs_info_struct[keyArray[i]]#;
		xml = xml & "</" & keyArray[i] & ">";
	}
	xml = xml & "</avs_info>";
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

<!--- For Unix users (also works in Windows). --->
<!--- Note: commenting this out and using the COM method will cause duplicate order id error.  Something in this commented code is causing the xml to be mushed up.--->
<cfset TransactionXml = ToString(#xml#)>
<!--- cfscript>writeoutput("SendXML: " & TransactionXml);</cfscript> --->
<cfhttp method="post" url="#gatewayHost#" timeout="60" throwonerror="yes" resolveurl="yes" userAgent="ColdFusion - 2.5.3">
	<cfhttpparam name="txnXml" type="xml" value="#TransactionXml#">
</cfhttp>
<cfset responseXML = #cfhttp.fileContent#>

<!--- cfscript>writeoutput("ResponseXML: "& responseXML);</cfscript> --->

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
caller.response_struct['AvsResultCode'] = getNodeValueByName(responseXML,"AvsResultCode");
caller.response_struct['CvdResultCode'] = getNodeValueByName(responseXML,"CvdResultCode");
caller.response_struct['ITDResponse'] = getNodeValueByName(responseXML,"ITDResponse");
caller.response_struct['CorporateCard'] = getNodeValueByName(responseXML,"CorporateCard");
caller.response_struct['IsVisaDebit'] = getNodeValueByName(responseXML,"IsVisaDebit");
caller.response_struct['CavvResultCode'] = getNodeValueByName(responseXML,"CavvResultCode");
caller.response_struct['StatusCode'] = getNodeValueByName(responseXML,"status_code");
caller.response_struct['StatusMessage'] = getNodeValueByName(responseXML,"status_message");
//RecurUpdate response fields
caller.response_struct['RecurUpdateSuccess'] = getNodeValueByName(responseXML,"RecurUpdateSuccess");
caller.response_struct['NextRecurDate'] = getNodeValueByName(responseXML,"NextRecurDate");
caller.response_struct['RecurEndDate'] = getNodeValueByName(responseXML,"RecurEndDate");
//Resolver specific response fields
caller.response_struct['DataKey'] = getNodeValueByName(responseXML,"DataKey");
caller.response_struct['ResSuccess'] = getNodeValueByName(responseXML,"ResSuccess");
caller.response_struct['PaymentType'] = getNodeValueByName(responseXML,"PaymentType");
caller.response_struct['ResolveData'] = getMultiNodeValueByName(responseXML,"ResolveData");
//MPI specific response fields
caller.response_struct['MpiType'] = getNodeValueByName(responseXML,"MpiType");
caller.response_struct['MpiSuccess'] = getNodeValueByName(responseXML,"MpiSuccess");
caller.response_struct['MpiMessage'] = getNodeValueByName(responseXML,"MpiMessage");
caller.response_struct['MpiPaReq'] = getNodeValueByName(responseXML,"MpiPaReq");
caller.response_struct['MpiTermUrl'] = getNodeValueByName(responseXML,"MpiTermUrl");
caller.response_struct['MpiMD'] = getNodeValueByName(responseXML,"MpiMD");
caller.response_struct['MpiACSUrl'] = getNodeValueByName(responseXML,"MpiACSUrl");
caller.response_struct['MpiCavv'] = getNodeValueByName(responseXML,"MpiCavv");
caller.response_struct['MpiPAResVerified'] = getNodeValueByName(responseXML,"MpiPAResVerified");
//VdotMe specific fields
caller.response_struct['VDotMeInfo'] = getNodeValueByName(responseXML,"VDotMeInfo");
caller.vdotme_info_struct = structNew();
caller.vdotme_info_struct['ResponseCode'] = getNodeValueByName(responseXML,"ResponseCode");
caller.vdotme_info_struct['Message'] = getNodeValueByName(responseXML,"Message");
caller.vdotme_info_struct['CurrencyCode'] = getNodeValueByName(responseXML,"currencyCode");
caller.vdotme_info_struct['PaymentTotal'] = getNodeValueByName(responseXML,"total");
caller.vdotme_info_struct['UserFirstName'] = getNodeValueByName(responseXML,"userFirstName");
caller.vdotme_info_struct['UserLastName'] = getNodeValueByName(responseXML,"userLastName");
caller.vdotme_info_struct['UserName'] = getNodeValueByName(responseXML,"userName");
caller.vdotme_info_struct['UserEmail'] = getNodeValueByName(responseXML,"userEmail");
caller.vdotme_info_struct['EncUserId'] = getNodeValueByName(responseXML,"encUserId");
caller.vdotme_info_struct['CreationTimeStamp'] = getNodeValueByName(responseXML,"creationTimeStamp");
caller.vdotme_info_struct['NameOnCard'] = getNodeValueByName(responseXML,"nameOnCard");
caller.vdotme_info_struct['ExpirationDateMonth'] = getNodeValueByName(responseXML,"month");
caller.vdotme_info_struct['ExpirationDateYear'] = getNodeValueByName(responseXML,"year");
caller.vdotme_info_struct['BillingId'] = getNodeValueByName(responseXML,"id");
caller.vdotme_info_struct['LastFourDigits'] = getNodeValueByName(responseXML,"lastFourDigits");
caller.vdotme_info_struct['BinSixDigits'] = getNodeValueByName(responseXML,"binSixDigits");
caller.vdotme_info_struct['CardBrand'] = getNodeValueByName(responseXML,"cardBrand");
caller.vdotme_info_struct['CardType'] = getNodeValueByName(responseXML,"cardType");
BillingAddressXML = getNodeValueByName(responseXML,"billingAddress");
caller.vdotme_info_struct['BillingPersonName'] = getNodeValueByName(BillingAddressXML,"personName");
caller.vdotme_info_struct['BillingAddressLine1'] = getNodeValueByName(BillingAddressXML,"line1");
caller.vdotme_info_struct['BillingCity'] = getNodeValueByName(BillingAddressXML,"city");
caller.vdotme_info_struct['BillingStateProvinceCode'] = getNodeValueByName(BillingAddressXML,"stateProvinceCode");
caller.vdotme_info_struct['BillingPostalCode'] = getNodeValueByName(BillingAddressXML,"postalCode");
caller.vdotme_info_struct['BillingCountryCode'] = getNodeValueByName(BillingAddressXML,"countryCode");
caller.vdotme_info_struct['BillingPhone'] = getNodeValueByName(BillingAddressXML,"phone");
caller.vdotme_info_struct['BillingVerificationStatus'] = getNodeValueByName(responseXML,"verificationStatus");
caller.vdotme_info_struct['isExpired'] = getNodeValueByName(responseXML,"expired");
caller.vdotme_info_struct['BaseImageFileName'] = getNodeValueByName(responseXML,"baseImageFileName");
caller.vdotme_info_struct['Height'] = getNodeValueByName(responseXML,"height");
caller.vdotme_info_struct['Width'] = getNodeValueByName(responseXML,"width");
caller.vdotme_info_struct['IssuerBid'] = getNodeValueByName(responseXML,"issuerBid");
PartialShippingAddressXML = getNodeValueByName(responseXML,"partialShippingAddress");
caller.vdotme_info_struct['PartialShippingCountryCode'] = getNodeValueByName(PartialShippingAddressXML,"countryCode");
caller.vdotme_info_struct['PartialShippingPostalCode'] = getNodeValueByName(PartialShippingAddressXML,"postalCode");
ShippingAddressXML = getNodeValueByName(responseXML,"shippingAddress");
caller.vdotme_info_struct['ShippingPersonName'] = getNodeValueByName(ShippingAddressXML,"personName");
caller.vdotme_info_struct['ShippingAddressLine1'] = getNodeValueByName(ShippingAddressXML,"line1");
caller.vdotme_info_struct['ShippingCity'] = getNodeValueByName(ShippingAddressXML,"city");
caller.vdotme_info_struct['ShippingStateProvinceCode'] = getNodeValueByName(ShippingAddressXML,"stateProvinceCode");
caller.vdotme_info_struct['ShippingPostalCode'] = getNodeValueByName(ShippingAddressXML,"postalCode");
caller.vdotme_info_struct['ShippingCountryCode'] = getNodeValueByName(ShippingAddressXML,"countryCode");
caller.vdotme_info_struct['ShippingPhone'] = getNodeValueByName(ShippingAddressXML,"phone");
caller.vdotme_info_struct['ShippingDefault'] = getNodeValueByName(ShippingAddressXML,"default");
caller.vdotme_info_struct['ShippingId'] = getNodeValueByName(ShippingAddressXML,"id");
caller.vdotme_info_struct['ShippingVerificationStatus'] = getNodeValueByName(ShippingAddressXML,"verificationStatus");
caller.vdotme_info_struct['RiskAdvice'] = getNodeValueByName(responseXML,"Advice");
caller.vdotme_info_struct['RiskScore'] = getNodeValueByName(responseXML,"Score");
caller.vdotme_info_struct['AvsResponseCode'] = getNodeValueByName(responseXML,"avsResponseCode");
caller.vdotme_info_struct['CvvResponseCode'] = getNodeValueByName(responseXML,"cvvResponseCode");
</cfscript>

<cfscript>
if(ArrayLen(caller.response_struct['ResolveData']) GT 0)
{
	//Set the variables at the caller scope so that the calling tag has
	//access to the return variables

	caller.resolver_response_struct = structNew();

	for (i=1; i LTE ArrayLen(caller.response_struct['ResolveData']); i=i+1)
	{
		caller.resolve_data_response_struct = structNew();
		caller.resolve_data_response_struct['data_key'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"data_key");
		caller.resolve_data_response_struct['payment_type'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"payment_type");
		caller.resolve_data_response_struct['cust_id'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"cust_id");
		caller.resolve_data_response_struct['phone'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"phone");
		caller.resolve_data_response_struct['email'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"email");
		caller.resolve_data_response_struct['note'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"note");
		caller.resolve_data_response_struct['pan'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"pan");
		caller.resolve_data_response_struct['masked_pan'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"masked_pan");
		caller.resolve_data_response_struct['expdate'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"expdate");
		caller.resolve_data_response_struct['crypt_type'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"crypt_type");
		caller.resolve_data_response_struct['avs_street_number'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"avs_street_number");
		caller.resolve_data_response_struct['avs_street_name'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"avs_street_name");
		caller.resolve_data_response_struct['avs_zipcode'] = getNodeValueByName(caller.response_struct['ResolveData'][i],"avs_zipcode");

		StructInsert(caller.resolver_response_struct, i, caller.resolve_data_response_struct);
	}
}
</cfscript>