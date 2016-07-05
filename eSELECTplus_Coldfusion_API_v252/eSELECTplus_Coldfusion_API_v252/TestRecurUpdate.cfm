<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfscript>
	order_id = "mjr150208";
	myTxn = formRecurUpdateArray( order_id );

	cust_id = "my cust id";
	recur_amount = "1.00";
	pan = "4242424242424242";
	expdate = "1111";
	add_num = "20";
	total_num = "999";
	hold = "false";
	terminate = "false";

	</cfscript>


	<CF_mpgAPI_CF5 host="https://esqa.moneris.com:443/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" cust_id="#cust_id#" recur_amount="#recur_amount#" pan="#pan#" expdate="#expdate#" add_num_recurs="#add_num#" total_num_recurs="#total_num#" hold="#hold#" terminate="#terminate#">


	<cfscript>
	keyArray = arrayNew(1);
	keyArray = structKeyArray(response_struct);
	for( i=1; i LTE arrayLen(keyArray); i=i+1 ) {
		if (structFind(response_struct, keyArray[i]) IS NOT "")
		{
			writeoutput( "<br>" & keyArray[i] & " is:_________" & structFind(response_struct, keyArray[i]) );
		}
	}
	</cfscript>


<cfcatch type="Custom.Tag.mpgAPI_CF5">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>
<cfcatch type="Any">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>

</cftry>