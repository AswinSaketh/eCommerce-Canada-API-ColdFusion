<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">


	<cfset mytime = TimeFormat(Now(), 'hhmmss')>
	<cfset myday = DateFormat(Now(),'mmddyyyy')>
	<cfset OrderID = '#myday##mytime#'>


	<cfscript>
	order_id = "cfm5-101" & OrderID;

	bill = arrayNew(1);
	bill = setBilling( "bfname", "blname", "bCompany Name", "baddress", "bcity", "bprovince", "bpostal", "bcountry", "bphone1", "bfax" , "btax1", "btax2", "btax3", "bshipping_cost" );

	ship = arrayNew(1);
	ship = setShipping( "sfname", "slname", "sCompany Name", "saddress", "scity", "sprovince", "spostal", "scountry", "sphone1", "sfax" , "stax1", "stax2", "stax3", "sshipping_cost" );

	email = arrayNew(1);
	email = setEmail( "myemail@email.com" );

	instructions = arrayNew(1);
	instructions = setInstructions( "Make it so!" );

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

	myTxn = formPurchaseArray( order_id, "43.02", "5454545454545454", "0405", "7" );
	</cfscript>


	<CF_mpgAPI_CF5 host="https://esqa.moneris.com:43924/gateway2/servlet/MpgRequest" store_id="store1" api_token="yesguy" txn_array="#myTxn#" cust_info_array="#custInfo#">


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