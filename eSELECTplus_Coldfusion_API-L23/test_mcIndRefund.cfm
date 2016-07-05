<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">


	<cfset mytime = TimeFormat(Now(), 'hhmmss')>
	<cfset myday = DateFormat(Now(),'mmddyyyy')>
	<cfset OrderID = '#myday##mytime#'>


	<cfscript>
	order_id = "cfm5-301" & OrderID;
	myTxn = formMCIndRefundArray( order_id, "43.02", "5103100000000003", "0405", "7" );
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