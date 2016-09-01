<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfset mytime = TimeFormat(Now(), 'hhmmss')>
	<cfset myday = DateFormat(Now(),'mmddyyyy')>
	<cfset OrderID = '#myday##mytime#'>


	<cfscript>

	order_id = "cf11m" & OrderID;

// Declaring AVS values

			avs_street_number = "2345";
			avs_street_name = "Dundas Street West";
		    avs_zipcode = "M1M2E2";
		    avs_email = "test@host.com";
		    avs_hostname = "hostname";
		    avs_browser = "Mozilla";
		    avs_shiptocountry = "Canada";
		    avs_shipmethod = "shipping";
		    avs_merchprodsku = "123456";
		    avs_custip = "192.168.0.1";
		    avs_custphone = "5556667777";

		// Declaring CVD values

		    cvd_indicator = "0";
		    cvd_value = "333";

		    avsInfo = setAvsInfo(avs_street_number, avs_street_name, avs_zipcode, avs_email, avs_hostname, avs_browser, avs_shiptocountry, avs_shipmethod, avs_merchprodsku, avs_custip, avs_custphone);
    	cvdInfo = setCvdInfo(cvd_indicator, cvd_value);

	myTxn = formPurchaseArray( order_id, "10.30", "4242424242424242", "1511", "7" );
	</cfscript>


<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" avs_info_array="#avsInfo#" cvd_info_array="#cvdInfo#">


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