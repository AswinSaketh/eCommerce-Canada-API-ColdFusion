<cftry>

	<cfinclude template="mpgAPIFunctions_MSR.cfm">


	<cfscript>
	order_id = "cfmsr-001-03162009042329";
	refund_amount = "1.00";
	txn = "4857-0_7";

	myTxn = formTrack2RefundArray( order_id, refund_amount, txn);
	</cfscript>


	<CF_mpgAPI_MSR_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="intuit_sped" api_token="spedguy" txn_array="#myTxn#">


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