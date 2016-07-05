<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfset mytime = TimeFormat(Now(), 'hh:mm:ss')>
	<cfset myday = DateFormat(Now(),'mmddyyyy')>
	<cfset OrderID = '#myday##mytime#'>

	<cfscript>
		order_id = "RES_PURCH_" & OrderID;
		data_key = "92T94412l1c0LJ45oMqm7m5";
		amount = "1.00";
		crypt_type = "1";
		myTxn = formResPurchaseCCArray( data_key, order_id, amount, crypt_type );

		//if sent will be submitted, otherwise cust_id from profile will be used
		cust_id = "customer 2";
	</cfscript>

	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" cust_id="#cust_id#" dynamic_descriptor = "descriptor1">

	<cfscript>
		keyArray = structKeyArray(response_struct);

		for( i=1; i LTE arrayLen(keyArray); i=i+1 )
		{
			if( (keyArray[i] eq "ResolveData") and (arrayLen(response_struct['ResolveData']) GT 0))
			{
				j=1;
				writeoutput("<br>*******************************************************************");
				writeoutput("<br><br>ResolveData");
				writeoutput("<br>----------------------------------------------------------------------");
				resolveDataKeyArray = structKeyArray(resolver_response_struct[j]);

				for( k=1; k LTE arrayLen(resolveDataKeyArray); k=k+1)
				{
					if (structFind(resolver_response_struct[j], resolveDataKeyArray[k]) IS NOT "")
					{
						writeoutput( "<br>" & resolveDataKeyArray[k] & " is:_________" & structFind(resolver_response_struct[j], resolveDataKeyArray[k]) );
					}
				}

				writeoutput("<br>*******************************************************************");
			}
			else
			{
				if (structFind(response_struct, keyArray[i]) IS NOT "")
				{
					writeoutput( "<br>" & keyArray[i] & " is:_________" & structFind(response_struct, keyArray[i]) );
				}
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