<!-- ***************************************************************************************
* Name:				CF_mpgAPI_MSR_CF5
* File:				mpgAPI_MSR_CF5.cfm
* Created:			Mar. 18, 2005
* Last Modified:	March 19, 2009
*						- Added support for eFraud (AVS and CVD validations).
						- Added support for the Recur Update transaction
						- Added MSR functions
* Version:			1.2.0
* Author:			Phet Chai / Martin Paszkowski / Spencer Lai(Moneris Solutions)
* Description:		CF_mpgAPI_CF5 is a custom CFML tag that processes credit card
* 					transactions through the Moneris Solutions eSelect Plus gateway.
* Attributes:		REQUIRED:
*						host = gateway URL.
*						store_id (string) = id to identify unique store.
*						api_token (string) = unique per store.
*						txn_array (array) = array of transaction parameters.
*					OPTIONAL:
*						cust_id (string) = optional user defined data.
* Outputs:			response_struct (structore) = structure of response data.
*************************************************************************************** -->
<cfif (NOT isDefined( "attributes.host" ))>
	<cfthrow type="Custom.Tag.mpgAPI_MSR_CF5" message="Host URL not defined">
<cfelseif (NOT isDefined( "attributes.store_id" ))>
	<cfthrow type="Custom.Tag.mpgAPI_MSR_CF5" message="Store ID not defined">
<cfelseif (NOT isDefined( "attributes.api_token" ))>
	<cfthrow type="Custom.Tag.mpgAPI_MSR_CF5" message="API Token not defined">
<cfelseif (NOT isDefined( "attributes.txn_array" )) OR (NOT isArray( attributes.txn_array ))>
	<cfthrow type="Custom.Tag.mpgAPI_MSR_CF5" message="Invalid Transaction Array">
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
txnArray = arrayNew(1);
txnArray = attributes.txn_array;

requiredArray = arrayNew(1);

switch( txnArray[1] ) {
	case "purchase": {
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
	case "completion": {
		requiredArray = listToArray("order_id,comp_amount,txn_number,crypt_type");
		optFields = false;
		break;
	}
	case "purchasecorrection": {
		requiredArray = listToArray("order_id,txn_number,crypt_type");
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
	case "track2_purchase": {
		if( isDefined("attributes.cust_id") ) {
			requiredArray = listToArray("order_id,cust_id,amount,pan,expdate,track2,pos_code");
			ArrayInsertAt( txnArray, 3, attributes.cust_id );
			}
			else {
				requiredArray = listToArray("order_id,amount,pan,expdate,track2,pos_code");
		}
		optFields = false;
		break;
	}
	case "track2_preauth": {
		if( isDefined("attributes.cust_id") ) {
			requiredArray = listToArray("order_id,cust_id,amount,pan,expdate,track2,pos_code");
			ArrayInsertAt( txnArray, 3, attributes.cust_id );
			}
			else {
				requiredArray = listToArray("order_id,amount,pan,expdate,track2,pos_code");
		}
		optFields = false;
		break;
	}
	case "track2_ind_refund": {
		if( isDefined("attributes.cust_id") ) {
			requiredArray = listToArray("order_id,cust_id,amount,pan,expdate,track2,pos_code");
			ArrayInsertAt( txnArray, 3, attributes.cust_id );
		}
		else {
			requiredArray = listToArray("order_id,amount,pan,expdate,track2,pos_code");
		}
		optFields = false;
		break;
	}
	case "track2_purchasecorrection": {
		requiredArray = listToArray("order_id,txn_number");
		optFields = false;
		break;
	}
	case "track2_completion": {
		requiredArray = listToArray("order_id,comp_amount,txn_number");
		optFields = false;
		break;
	}
	case "track2_refund": {
		requiredArray = listToArray("order_id,amount,txn_number");
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
<cfhttp method="post" url="#gatewayHost#" timeout="60" throwonerror="yes" resolveurl="yes" userAgent="ColdFusion MSR API v1.2.0">
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
</cfscript>