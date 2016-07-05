<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<CF_mpgAPI_CF5 host="https://esqa.moneris.com:43924/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#formBatchCloseArray( "66002163" )#">

	<cfscript>
	keyArray = arrayNew(1);
	keyArray = structKeyArray(response_struct);
	for( i=1; i LTE arrayLen(keyArray); i=i+1 ) {
		writeoutput( "<br>" & keyArray[i] & " is:_________" & structFind(response_struct, keyArray[i]) );
	}
	</cfscript>

<cfcatch type="Custom.Tag.mpgAPI_CF5">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>
<cfcatch type="Any">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>

</cftry>