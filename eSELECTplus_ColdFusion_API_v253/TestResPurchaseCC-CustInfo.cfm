<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfset mytime = TimeFormat(Now(), 'hh:mm:ss')>
	<cfset myday = DateFormat(Now(),'mmddyyyy')>
	<cfset OrderID = '#myday##mytime#'>

	<cfscript>
		order_id = "RES_PURCH_" & OrderID;
		data_key = "ot-vaoRkqlnwtiX0UKAkdIAbPTHN";
		amount = "1.00";
		crypt_type = "1";
		myTxn = formResPurchaseCCArray( data_key, order_id, amount, crypt_type );

		//if sent will be submitted, otherwise cust_id from profile will be used
		cust_id = "customer 2";

		//Optional
		dynamic_descriptor = "descriptor 1";

		//Expdate is only needed for hosted tokenization - see below for proper request
		expdate = "1511";

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

	<!---for Permanent Token--->
	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" cust_id="#cust_id#" dynamic_descriptor="#dynamic_descriptor#" cust_info_array="#custInfo#">

	<!--- With ExpDate for hosted tokenization
	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" cust_id="#cust_id#" expdate="#expdate#" dynamic_descriptor="#dynamic_descriptor#" cust_info_array="#custInfo#">
--->

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

		writeoutput("<br>----------Resolver Data-------------------");
		writeoutput("<br> DataKey: "            & response_struct['DataKey']);
		writeoutput("<br> ResSuccess: "         & response_struct['ResSuccess']);
		writeoutput("<br> PaymentType: "        & response_struct['PaymentType']);

		writeoutput("<br> CustId: "             & resolve_data_response_struct['cust_id']);
		writeoutput("<br> Phone: "              & resolve_data_response_struct['phone']);
		writeoutput("<br> Email: "              & resolve_data_response_struct['email']);
		writeoutput("<br> Note: "               & resolve_data_response_struct['note']);
		writeoutput("<br> MaskedPan: "          & resolve_data_response_struct['masked_pan']);
		writeoutput("<br> ExpiryDate: "         & resolve_data_response_struct['expdate']);
		writeoutput("<br> CryptType: "          & resolve_data_response_struct['crypt_type']);
		writeoutput("<br> AvsStreetNumber: "    & resolve_data_response_struct['avs_street_number']);
		writeoutput("<br> AvsStreetName: "      & resolve_data_response_struct['avs_street_name']);
		writeoutput("<br> AvsZipcode: "         & resolve_data_response_struct['avs_zipcode']);
	</cfscript>


<cfcatch type="Custom.Tag.mpgAPI_CF5">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>
<cfcatch type="Any">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>

</cftry>