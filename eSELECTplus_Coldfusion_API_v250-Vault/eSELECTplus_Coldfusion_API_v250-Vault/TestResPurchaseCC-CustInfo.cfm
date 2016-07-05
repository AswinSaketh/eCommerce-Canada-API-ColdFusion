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

		//Declare cust_info fields
		bill = arrayNew(1);
		bill = setBilling( "bfname", "blname", "bCompany Name", "baddress", "bcity", "bprovince", "bpostal", "bcountry", "bphone1", "bfax" , "btax1", "btax2", "btax3", "bshipping_cost" );

		ship = arrayNew(1);
		ship = setShipping( "sfname", "slname", "sCompany Name", "saddress", "scity", "sprovince", "spostal", "scountry", "sphone1", "sfax" , "stax1", "stax2", "stax3", "sshipping_cost" );

		email = arrayNew(1);
		email = setEmail( "myemail@email.com" );

		instructions = arrayNew(1);
		instructions = setInstructions( "Just do it!" );

		item1 = arrayNew(1);
		item1 = setItem( "prodname1", "qnty1", "prodcode1", "extamount1" );
		item2 = arrayNew(1);
		item2 = setItem( "prodname2", "qnty2", "prodcode2", "extamount2" );

		custInfo = arrayNew(1);
		custInfo[1] = bill;
		custInfo[2] = ship;
		custInfo[3] = email;
		custInfo[4] = instructions;
		custInfo[5] = item1;
		custInfo[6] = item2;
	</cfscript>

	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" cust_id="#cust_id#" cust_info_array="#custInfo#">

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