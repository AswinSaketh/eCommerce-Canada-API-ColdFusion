<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">


	<cfscript>
	myTxn = formVSCompletionArray( "cfm5-40107132004120959", "20.00", "403190-4-0", "7" );
	pst = setPST( "45", "777" );
	gst = setGST( "56", "888" );
	cri = setCRI( "abc" );
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