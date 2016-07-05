<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">


	<cfset mytime = TimeFormat(Now(), 'hhmmss')>
	<cfset myday = DateFormat(Now(),'mmddyyyy')>
	<cfset OrderID = '#myday##mytime#'>


	<cfscript>
	order_id = "cfm5-301" & OrderID;
	myTxn = formVSIndRefundArray( order_id, "43.02", "4716019111111115", "0501", "7" );
	pst = setPST( "71", "759" );
	gst = setGST( "46", "826" );
	cri = setCRI( "zzz" );
	</cfscript>


	<CF_mpgAPI_CF5 host="https://esqa.moneris.com:43924/gateway2/servlet/MpgRequest" store_id="moneris" api_token="hurgle" txn_array="#myTxn#" pst_array="#pst#" gst_array="#gst#" cri_array="#cri#">


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