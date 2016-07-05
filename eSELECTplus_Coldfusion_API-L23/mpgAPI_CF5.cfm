<!-- ***************************************************************************************
* Name:				CF_mpgAPI_CF5
* File:				mpgAPI_CF5.cfm
* Created:			June 23, 2004
* Last Modified:	July 09, 2004
* 						- Added support for level 2/3 transactions.
* Version:			2.0l (adaptation of eSelect_CF5.cfm file)
* Author:			Phet Chai (Moneris Solutions)
* Description:		CF_mpgAPI_CF5 is a custom CFML tag that processes credit card
* 					transactions through the Moneris Solutions eSelect Plus gateway.
* Attributes:		REQUIRED:
*						host = gateway URL.
*						store_id (string) = id to identify unique store.
*						api_token (string) = unique per store.
*						txn_array (array) = array of transaction parameters.
*						Level 2/3 Transaction:
*							addendum1_array (array) = Additional Data detail (Mastercard);
*								( customerCode, taxAmount, freightAmount, shipToPosCode, 
*								shipFromPosCode, dutyAmount, altTaxAmtInd, altTaxAmt, 
*								desCouCode, supData, salTaxColInd )
*							addendum2_array (array) = Line Item detail (Mastercard);
*								( productCode, itemDescription, itemQuantity, itemUom, 
*								extItemAmount, discountInd, discountAmount, 
*								netGroIndForExtItemAmt, taxRateApp, taxTypeApp, taxAmount, 
*								debitCredInd, altTaxIdeAmt )
*							purchA_array (array) = Additional Data detail (Visa);
*								( dutyAmount, shipToPosCode, shipFromPosCode, desCouCode, 
*								vatRefNum )
*							purchL_array (array) = Line Item detail (Visa);
*								( itemComCode, productCode, itemDescription, itemQuantity, 
*								itemUom, unitCost, vatTaxAmt, vatTaxRate, discountAmt )
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
*						Level 2/3 Transaction:
*							gst_array (array) = GST info (Visa);
*								( order_level_gst, merchant_gst_no )
*							pst_array (array) = PST info (Visa);
*								( order_level_pst, merchant_pst_no )
*							cri_array (array) = Customer Reference Identifier info (Visa);
*								( cri )
* Outputs:			response_struct (structore) = structure of response data.
*************************************************************************************** -->
<cfif (NOT isDefined( "attributes.host" ))>
	<cfthrow type="Custom.Tag.mpgAPI_CF5" message="Host URL not defined for CF_mpgAPI_CF5 tag!">
<cfelseif (NOT isDefined( "attributes.store_id" ))>
	<cfthrow type="Custom.Tag.mpgAPI_CF5" message="Store ID not defined for CF_mpgAPI_CF5 tag!">
<cfelseif (NOT isDefined( "attributes.api_token" ))>
	<cfthrow type="Custom.Tag.mpgAPI_CF5" message="API Token not defined for CF_mpgAPI_CF5 tag!">
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

<cfif isDefined( "attributes.addendum1_array" )>
	<cfset add1 = attributes.addendum1_array>
	<cfif (NOT isArray(add1))>
		<cfthrow type="Custom.Tag.mpgAPI_CF5" message="addendum1_array is not an array for CF_mpgAPI_CF5 tag!">
	</cfif>
</cfif>

<cfif isDefined( "attributes.addendum2_array" )>
	<cfset add2 = attributes.addendum2_array>
	<cfif (NOT isArray(add2))>
		<cfthrow type="Custom.Tag.mpgAPI_CF5" message="addendum2_array is not an array for CF_mpgAPI_CF5 tag!">
	</cfif>
</cfif>

<cfif isDefined( "attributes.purchA_array" )>
	<cfset purA = attributes.purchA_array>
	<cfif (NOT isArray(purA))>
		<cfthrow type="Custom.Tag.mpgAPI_CF5" message="purchA_array is not an array for CF_mpgAPI_CF5 tag!">
	</cfif>
</cfif>

<cfif isDefined( "attributes.purchL_array" )>
	<cfset purL = attributes.purchL_array>
	<cfif (NOT isArray(purL))>
		<cfthrow type="Custom.Tag.mpgAPI_CF5" message="purchL_array is not an array for CF_mpgAPI_CF5 tag!">
	</cfif>
</cfif>

<cfif isDefined( "attributes.gst_array" )>
	<cfset gst = attributes.gst_array>
	<cfif (NOT isArray(gst))>
		<cfthrow type="Custom.Tag.mpgAPI_CF5" message="gst_array is not an array for CF_mpgAPI_CF5 tag!">
	</cfif>
</cfif>

<cfif isDefined( "attributes.pst_array" )>
	<cfset pst = attributes.pst_array>
	<cfif (NOT isArray(pst))>
		<cfthrow type="Custom.Tag.mpgAPI_CF5" message="pst_array is not an array for CF_mpgAPI_CF5 tag!">
	</cfif>
</cfif>

<cfif isDefined( "attributes.cri_array" )>
	<cfset cri = attributes.cri_array>
	<cfif (NOT isArray(cri))>
		<cfthrow type="Custom.Tag.mpgAPI_CF5" message="cri_array is not an array for CF_mpgAPI_CF5 tag!">
	</cfif>
</cfif>

<cfscript>
//function to return the value of the XML node in the response
function getNodeValueByName(XML, nodeName) {
	start = findNoCase("<" & nodeName & ">",XML,1);
	start = start + len(nodeName) + 2;
	end = findNoCase("</" & nodeName & ">",XML,1);
	return mid(XML,start,end-start);
}
</cfscript>

<cfscript>
//populate all the required fields
gatewayHost = attributes.host;
storeId = attributes.store_id;
apiToken = attributes.api_token;
txnArray = arrayNew(1);
txnArray = attributes.txn_array;
if( isDefined("attributes.cust_info_array") ) {
	custInfoArray = arrayNew(1);
	custInfoArray = attributes.cust_info_array;
}
recurTxn = 0;
requiredAddendumField = false;
vsOptionalField = false;
requiredPurchALField = false;

requiredArray = arrayNew(1);

switch( txnArray[1] ) {
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
	case "completion": case "mccompletion": case "vscompletion":  {
		requiredArray = listToArray("order_id,comp_amount,txn_number,crypt_type");
		optFields = false;
		vsOptionalField = true;
		break;
	}		
	case "purchasecorrection": case "mcpurchasecorrection": {
		requiredArray = listToArray("order_id,txn_number,crypt_type");
		optFields = false;
		break;
	}			
	case "refund": case "mcrefund": case "vsrefund": {
		requiredArray = listToArray("order_id,amount,txn_number,crypt_type");
		optFields = false;
		vsOptionalField = true;
		break;
	}			
	case "ind_refund": case "mcind_refund": case "vsind_refund": {
		requiredArray = listToArray("order_id,amount,pan,expdate,crypt_type");
		optFields = false;
		vsOptionalField = true;
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
	case "mclevel23": {
		requiredArray = listToArray("order_id,txn_number");
		requiredAddendumField = true;
		optFields = false;
		break;
	}
	case "vspurchal": {
		requiredArray = listToArray("order_id,txn_number");
		requiredPurchALField = true;
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

//open the tag for the transaction type
xml = xml & "<" & txnArray[1] & ">";

//loop through the required fields for the given transaction type
for( i=1; i LTE arrayLen(requiredArray); i=i+1 ) {
	xml = xml & "<" & requiredArray[i] & ">";
	xml = xml & evaluate(requiredArray[i]);
	xml = xml & "</" & requiredArray[i] & ">";
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

//form mclevel23 transaction xml.
if( requiredAddendumField EQ true ) {
	addendum1FieldArray = arrayNew(1);
	addendum1FieldArray = listToArray("customer_code,tax_amount,freight_amount,ship_to_pos_code,ship_from_pos_code,duty_amount,alt_tax_amt_ind,alt_tax_amt,des_cou_code,sup_data,sal_tax_col_ind");
	xml = xml & "<mc_addendum1>";
	for( i=1; i LTE arrayLen(addendum1FieldArray); i=i+1 ) {
		xml = xml & "<" & addendum1FieldArray[i] & ">";
		xml = xml & attributes.addendum1_array[i];
		xml = xml & "</" & addendum1FieldArray[i] & ">";
	}
	xml = xml & "</mc_addendum1>";
	
	addendum2FieldArray = arrayNew(1);
	addendum2FieldArray = listToArray("product_code,item_description,item_quantity,item_uom,ext_item_amount,discount_ind,discount_amount,net_gro_ind_for_ext_item_amt,tax_rate_app,tax_type_app,tax_amount,debit_credit_ind,alt_tax_ide_amt");
	l = arrayLen(attributes.addendum2_array);
	j = 1;
	while( NOT(l EQ 0) ) {
		xml = xml & "<mc_addendum2>";
		for( i=1; i LTE arrayLen(addendum2FieldArray); i=i+1 ) {
			xml = xml & "<" & addendum2FieldArray[i] & ">";
			xml = xml & attributes.addendum2_array[j];
			xml = xml & "</" & addendum2FieldArray[i] & ">";
			l = l - 1;
			j = j + 1;
		}
		xml = xml & "</mc_addendum2>";
	}
}

//form vspurchal transaction xml.
if( requiredPurchALField EQ true ) {
	purchAFieldArray = arrayNew(1);
	purchAFieldArray = listToArray("duty_amount,ship_to_pos_code,ship_from_pos_code,des_cou_code,vat_ref_num");
	xml = xml & "<purcha>";
	for( i=1; i LTE arrayLen(purchAFieldArray); i=i+1 ) {
		xml = xml & "<" & purchAFieldArray[i] & ">";
		xml = xml & attributes.purchA_array[i];
		xml = xml & "</" & purchAFieldArray[i] & ">";
	}
	xml = xml & "</purcha>";
	
	purchLFieldArray = arrayNew(1);
	purchLFieldArray = listToArray("item_com_code,product_code,item_description,item_quantity,item_uom,unit_cost,vat_tax_amt,vat_tax_rate,discount_amt");
	l = arrayLen(attributes.purchL_array);
	j = 1;
	while( NOT(l EQ 0) ) {
		xml = xml & "<purchl>";
		for( i=1; i LTE arrayLen(purchLFieldArray); i=i+1 ) {
			if( NOT(attributes.purchL_array[j] EQ "null") ) {
				xml = xml & "<" & purchLFieldArray[i] & ">";
				xml = xml & attributes.purchL_array[j];
				xml = xml & "</" & purchLFieldArray[i] & ">";
			}
			l = l - 1;
			j = j + 1;
		}
		xml = xml & "</purchl>";
	}
}

if( vsOptionalField EQ true ) {
	if( isDefined("attributes.gst_array") ) {
		gstArray = arrayNew(1);
		gstArray = attributes.gst_array;
		xml = xml & "<order_level_gst>" & gstArray[1] & "</order_level_gst>";
		xml = xml & "<merchant_gst_no>" & gstArray[2] & "</merchant_gst_no>";
	}
	if( isDefined("attributes.pst_array") ) {
		pstArray = arrayNew(1);
		pstArray = attributes.pst_array;
		xml = xml & "<order_level_pst>" & pstArray[1] & "</order_level_pst>";
		xml = xml & "<merchant_pst_no>" & pstArray[2] & "</merchant_pst_no>";
	}
	if( isDefined("attributes.cri_array") ) {
		criArray = arrayNew(1);
		criArray = attributes.cri_array;
		xml = xml & "<cri>" & criArray[1] & "</cri>";
	}
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
<cfhttp method="post" url="#gatewayHost#" timeout="60" throwonerror="yes" resolveurl="yes">
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
switch( txnArray[1] ) {
	case "mccompletion":
	case "mcrefund":
	case "mcind_refund":
	case "mcpurchasecorrection":
	case "mclevel23":
	case "vscompletion":
	case "vsrefund":
	case "vsind_refund":
	case "vspurchal": {
		caller.response_struct['CorporateCard'] = getNodeValueByName(responseXML,"CorporateCard");
		caller.response_struct['MessageId'] = getNodeValueByName(responseXML,"MessageId");
		break;
	}
	default: {
		break;
	}
}
</cfscript>