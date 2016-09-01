<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">


	<cfscript>
	myTxn = formRefundArray( "cfm5-00102272015014055", "1.00", "760178-0_10", "7" );
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
	</cfscript>


<cfcatch type="Custom.Tag.mpgAPI_CF5">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>
<cfcatch type="Any">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>

</cftry>