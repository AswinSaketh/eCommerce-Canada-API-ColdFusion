<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">


	<cfscript>
	myTxn = formMCPurchaseCorrectionArray( "cfm5-40107122004034806", "402804-1-1", "7" );
	</cfscript>


	<CF_mpgAPI_CF5 host="https://esqa.moneris.com:43924/level23/level23servlet" store_id="moneris" api_token="hurgle" txn_array="#myTxn#">


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