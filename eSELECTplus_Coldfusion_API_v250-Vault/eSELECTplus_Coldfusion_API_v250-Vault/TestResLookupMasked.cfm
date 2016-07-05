<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfscript>
		//will only return the masked card number
		data_key = "BBIXZ61nTr2idCiuI8VYIwd";
		myTxn = formResLookupMaskedArray( data_key );
	</cfscript>

	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#">

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