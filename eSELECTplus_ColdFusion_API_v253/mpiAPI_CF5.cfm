<!-- ***************************************************************************************
* Name:				CF_mpiAPI_CF5
* File:				mpiAPI_CF5.cfm
* Created:			Oct. 22, 2003
* Last Modified:	Oct. 22, 2003
* Version:			1.0 (adaptation of mpgAPI_CF5.cfm file)
* Author:			Phet Chai (Moneris Solutions)
* Description:		CF_mpiAPI_CF5 is a custom CFML tag that processes VBV-enabled credit
* 					card PIN authentication transactions through the Moneris Solutions
* 					eSelect Plus MPI gateway.
* Attributes:		REQUIRED:
*						host = MPI gateway URL.
*						store_id (string) = id to identify unique store.
*						api_token (string) = unique per store.
*						txn_array (array) = array of transaction parameters.
* Outputs:			response_struct (structore) = structure of response data.
*************************************************************************************** -->
<cfif (NOT isDefined( "attributes.host" ))>
	<cfthrow type="Custom.Tag.mpiAPI_CF5" message="Host MPI URL not defined for CF_mpiAPI_CF5 tag!">
<cfelseif (NOT isDefined( "attributes.store_id" ))>
	<cfthrow type="Custom.Tag.mpiAPI_CF5" message="Store ID not defined for CF_mpiAPI_CF5 tag!">
<cfelseif (NOT isDefined( "attributes.api_token" ))>
	<cfthrow type="Custom.Tag.mpiAPI_CF5" message="API Token not defined for CF_mpiAPI_CF5 tag!">
<cfelseif (NOT isDefined( "attributes.txn_array" )) OR (NOT isArray( attributes.txn_array ))>
	<cfthrow type="Custom.Tag.mpiAPI_CF5" message="Transaction Array not passed properly for CF_mpiAPI_CF5 tag!">
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
mpiGatewayHost = attributes.host;
storeId = attributes.store_id;
apiToken = attributes.api_token;
txnArray = arrayNew(1);
txnArray = attributes.txn_array;

requiredArray = arrayNew(1);

switch( txnArray[1] ) {
	case "txn": {
		requiredArray = listToArray("xid,amount,pan,expdate,MD,merchantUrl,accept,userAgent");
		optFields = true;
		break;
	}
	case "acs": {
		requiredArray = listToArray("PaRes,MD");
		optFields = true;
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
** trans_type.												**
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
xml = "<?xml version=""1.0"" encoding=""UTF-8""?>";
xml = xml & "<MpiRequest>";
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
xml = xml & "</MpiRequest>";


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
objHTTP.open("POST", mpiGatewayHost, false);
objHTTP.setRequestHeader("Content-Type", "text/xml");
objHTTP.send(xml);

//Capture the response from the server into a local variable
responseXML = objHTTP.responseText;
*/
</cfscript>


<!-- For Unix users (also works in Windows). -->
<!-- Note: commenting this out and using the COM method will cause duplicate order id error.  Something in this commented code is causing the xml to be mushed up.-->
<cfset TransactionXml = ToString(#xml#)>
<cfhttp method="post" url="#MpiGatewayHost#" timeout="60" throwonerror="yes" resolveurl="yes" userAgent = "ColdFusion - 2.5.0">
	<cfhttpparam name="txnXml" type="xml" value="#TransactionXml#">
</cfhttp>
<cfset responseXML = #cfhttp.fileContent#>


<cfscript>
//Set the variables at the caller scope so that the calling tag has
//access to the return variables
caller.response_struct = structNew();
caller.response_struct['type'] = getNodeValueByName(responseXML,"type");
caller.response_struct['success'] = getNodeValueByName(responseXML,"success");
caller.response_struct['message'] = getNodeValueByName(responseXML,"message");
caller.response_struct['PaReq'] = getNodeValueByName(responseXML,"PaReq");
caller.response_struct['TermUrl'] = getNodeValueByName(responseXML,"TermUrl");
caller.response_struct['MD'] = getNodeValueByName(responseXML,"MD");
caller.response_struct['ACSUrl'] = getNodeValueByName(responseXML,"ACSUrl");
caller.response_struct['cavv'] = getNodeValueByName(responseXML,"cavv");
caller.response_struct['PAResVerified'] = getNodeValueByName(responseXML,"PAResVerified");
</cfscript>