<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfscript>
		data_key = "O228v22p129cN4b2Xh2I6B9";
		myTxn = formResUpdateCCArray( data_key );

		cust_id = "customer 21";
		phone = "999-888-7777";
		email = "your@email.com";
		note = "hey there";
		pan = "4242424254545454";
		expdate = "1010";
		crypt_type = "1";

		// Declaring AVS values
		avs_street_number = "";
		avs_street_name = "";
		avs_zipcode = "98765";

		//Method 1:
		//you can either build the full avs_info array with all the fields present
		//this will update all of the fields within avs_info

		avsInfo = setAvsInfo(avs_street_number, avs_street_name, avs_zipcode);

		//Method 2:
		//or, you can build a struct to only pass the fields you wish to update

		avsInfoStruct = StructNew();
		//will update the zipcode with the new data
		StructInsert( avsInfoStruct, "avs_zipcode", avs_zipcode);

		//will remove the street number
		StructInsert( avsInfoStruct, "avs_street_number", avs_street_number);
	</cfscript>

	<!--- Method 1: passing the full array
	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="moneris" api_token="hurgle" txn_array="#myTxn#" cust_id="#cust_id#" phone="#phone#" email="#email#" note="#note#" pan="#pan#" expdate="#expdate#" crypt_type="#crypt_type#" avs_info_array="#avsInfo#">
	--->

	<!--- Method 2: passing the struct with appropriate fields --->
	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" cust_id="#cust_id#" phone="#phone#" email="#email#" note="#note#" pan="#pan#" expdate="#expdate#" crypt_type="#crypt_type#" avs_info_struct="#avsInfoStruct#">

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