<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfscript>
		//will return both the full & masked card number
		data_key = "MyzQeGpP3yTWbGpMsvtpHsbIi";
		myTxn = formResLookupFullArray( data_key );
	</cfscript>

	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#">

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

		writeoutput("<br> DataKey: "            & response_struct['DataKey']);
		writeoutput("<br> ResSuccess: "         & response_struct['ResSuccess']);
		writeoutput("<br> PaymentType: "        & response_struct['PaymentType']);

		writeoutput("<br>----------Resolver Data-------------------");
		writeoutput("<br> CustId: "             & resolve_data_response_struct['cust_id']);
		writeoutput("<br> Phone: "              & resolve_data_response_struct['phone']);
		writeoutput("<br> Email: "              & resolve_data_response_struct['email']);
		writeoutput("<br> Note: "               & resolve_data_response_struct['note']);
		writeoutput("<br> Pan: "          		& resolve_data_response_struct['pan']);
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