<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfset mytime = TimeFormat(Now(), 'hh:mm:ss')>
	<cfset myday = DateFormat(Now(),'mmddyyyy')>
	<cfset OrderID = '#myday##mytime#'>

	<cfscript>
		order_id = 'RES_PREAUTH_' & OrderID;
		data_key = "AuivOCNcf3Qz3rJMkZee94I0Z";
		amount = "1.00";
		cavv = "CAACBSARdkFgGTc0mBF2AAAAAAA=";  //Obtained from acs txn
		myTxn = formResCavvPreauthCCArray( data_key, order_id, amount, cavv );

		//if sent will be submitted, otherwise cust_id from profile will be used
		cust_id = "customer 2";

		//Optional
		dynamic_descriptor = "descriptor 1";

		//Expdate (YYMM) is only needed for hosted tokenization - see below for proper request
		expdate = "1511";
	</cfscript>

	<!---for Permanent Token--->
	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" cust_id="#cust_id#" dynamic_descriptor="#dynamic_descriptor#">

	<!--- With ExpDate for hosted tokenization
	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" cust_id="#cust_id#" expdate="#expdate#" dynamic_descriptor="#dynamic_descriptor#">
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

		writeoutput("<br> DataKey: "            & response_struct['DataKey']);
		writeoutput("<br> ResSuccess: "         & response_struct['ResSuccess']);
		writeoutput("<br> PaymentType: "        & response_struct['PaymentType']);

		writeoutput("<br>----------Resolver Data-------------------");
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