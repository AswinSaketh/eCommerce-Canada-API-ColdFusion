<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">


	<cfset mytime = TimeFormat(Now(), 'hhmmss')>
	<cfset myday = DateFormat(Now(),'mmddyyyy')>
	<cfset OrderID = '#myday##mytime#'>


	<cfscript>
	order_id = "cfm5-201" & OrderID;

	bill = arrayNew(1);
	bill = setBilling( "bfname", "blname", "bCompany Name", "baddress", "bcity", "bprovince", "bpostal", "bcountry", "bphone1", "bfax" , "btax1", "btax2", "btax3", "bshipping_cost" );

	ship = arrayNew(1);
	ship = setShipping( "sfname", "slname", "sCompany Name", "saddress", "scity", "sprovince", "spostal", "scountry", "sphone1", "sfax" , "stax1", "stax2", "stax3", "sshipping_cost" );

	email = arrayNew(1);
	email = setEmail( "myemail@email.com" );

	instructions = arrayNew(1);
	instructions = setInstructions( "Make it so!" );

	item1 = arrayNew(1);
	item1 = setItem( "prodname1", "15", "prodcode1", "extamount1" );
	item2 = arrayNew(1);
	item2 = setItem( "prodname2", "25", "prodcode2", "extamount2" );

	custInfo = arrayNew(1);
	custInfo[1] = bill;
	custInfo[2] = ship;
	custInfo[3] = email;
	custInfo[4] = instructions;
	custInfo[5] = item1;
	custInfo[6] = item2;

	myTxn = formPreauthArray( order_id, "43.02", "5454545454545454", "1511", "7" );
	</cfscript>


	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" cust_info_array="#custInfo#">


	<cfscript>
		//Receipt
		writeoutput("<br> ReceiptID: " 	        & response_struct['ReceiptID']);
		writeoutput("<br> ReferenceNum: "       & response_struct['ReferenceNum']);
		writeoutput("<br> ResponseCode: "       & response_struct['ResponseCode']);
		writeoutput("<br> ISO: " 		        & response_struct['ISO']);
		writeoutput("<br> AuthCode: " 	        & response_struct['AuthCode']);
		writeoutput("<br> TransTime: "	        & response_struct['TransTime']);
		writeoutput("<br> TransDate: " 	        & response_struct['TransDate']);
		writeoutput("<br> TransType: "          & response_struct['TransType']);
		writeoutput("<br> Complete: "           & response_struct['Complete']);
		writeoutput("<br> Message: "            & response_struct['Message']);
		writeoutput("<br> TransAmount: "        & response_struct['TransAmount']);
		writeoutput("<br> CardType: "           & response_struct['CardType']);
		writeoutput("<br> TransID: "            & response_struct['TransID']);
		writeoutput("<br> TimedOut: "           & response_struct['TimedOut']);
		writeoutput("<br> RecurSuccess: "       & response_struct['RecurSuccess']);
		writeoutput("<br> CorporateCard: "      & response_struct['CorporateCard']);
		writeoutput("<br> IsVisaDebit: "        & response_struct['IsVisaDebit']);
		writeoutput("<br> RecurUpdateSuccess: " & response_struct['RecurUpdateSuccess']);

		writeoutput("<br> AvsResultCode: "      & response_struct['AvsResultCode']);
		writeoutput("<br> CvdResultCode: "      & response_struct['CvdResultCode']);
		writeoutput("<br> CavvResultCode: "     & response_struct['CavvResultCode']);
	</cfscript>


<cfcatch type="Custom.Tag.mpgAPI_CF5">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>
<cfcatch type="Any">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>

</cftry>