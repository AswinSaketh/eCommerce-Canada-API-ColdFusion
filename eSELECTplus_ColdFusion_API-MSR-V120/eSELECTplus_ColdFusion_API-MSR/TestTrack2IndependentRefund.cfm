<cftry>

	<cfinclude template="mpgAPIFunctions_MSR.cfm">


	<cfset mytime = TimeFormat(Now(), 'hhmmss')>
	<cfset myday = DateFormat(Now(),'mmddyyyy')>
	<cfset OrderID = '#myday##mytime#'>


	<cfscript>
	amount = "1.00";
	pan = "";
	expdate = "";
	track2 = ";4924190000004568=09121013902251544535?";
	poscode = "27";
	order_id = "cfmsr-001-" & OrderID;
	myTxn = formTrack2IndRefundArray( order_id, amount, pan, expdate, track2, poscode );
	</cfscript>


	<CF_mpgAPI_MSR_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="intuit_sped" api_token="spedguy" txn_array="#myTxn#">
	<!-- CF_mpgAPI_MSR_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="intuit_sped" api_token="spedguy" txn_array="#myTxn#" cust_id="customer1" -->


	<cfscript>
	keyArray = arrayNew(1);
	keyArray = structKeyArray(response_struct);
	for( i=1; i LTE arrayLen(keyArray); i=i+1 ) {
		writeoutput( "<br>" & keyArray[i] & " is:_________" & structFind(response_struct, keyArray[i]) );
	}
	</cfscript>


<cfcatch type="Custom.Tag.mpgAPI_MSR_CF5">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>
<cfcatch type="Any">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>

</cftry>