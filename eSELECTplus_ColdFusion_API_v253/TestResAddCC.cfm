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