<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfscript>

	cust_id = "customer 1";
	phone = "999-888-7777";
	email = "my@email.com";
	note = "hello world";
	pan = "5454545442424242";
	expdate = "1212";
	crypt_type = "7";

	myTxn = formResAddCCArray(cust_id, phone, email, note, pan, expdate, crypt_type);

	// Declaring AVS values

	avs_street_number = "6600";
	avs_street_name = "New York Street";
	avs_zipcode = "90210";

	avsInfo = setAvsInfo(avs_street_number, avs_street_name, avs_zipcode);
	</cfscript>


<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" avs_info_array="#avsInfo#">


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