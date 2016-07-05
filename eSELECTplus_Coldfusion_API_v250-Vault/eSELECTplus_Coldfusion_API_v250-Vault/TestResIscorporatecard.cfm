<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfscript>
		data_key = "9A143sx23Y2Sb426J45GXYYM8";
		myTxn = formResIscorporatecardArray( data_key );
	</cfscript>

	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#">

	<cfscript>
		keyArray = structKeyArray(response_struct);

		for( i=1; i LTE arrayLen(keyArray); i=i+1 )
		{
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