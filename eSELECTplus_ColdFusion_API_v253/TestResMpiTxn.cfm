<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfset mytime = TimeFormat(Now(), 'hh:mm:ss')>
	<cfset myday = DateFormat(Now(),'mmddyyyy')>
	<cfset OrderID = '#myday##mytime#'>

	<cfscript>
		data_key = "AuivOCNcf3Qz3rJMkZee94I0Z";
		xid = "22345147682532645679";
		amount = "1.00";
		MD = "orderid=" & OrderId & "data_key=" & data_key & "amount=" & amount;
		merchantUrl = "https://VBVResponseURL";
		accept = "true";
		userAgent = #CGI.HTTP_USER_AGENT#;
		myTxn = formResMpiTxnArray( data_key,xid,amount,MD,merchantUrl,accept,userAgent );

		//Expdate is only needed for temp token - hosted tokenization feature
		expdate = "1511";
	</cfscript>

	<!--- Permanent Token --->
	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#">


	<!--- With ExpDate for hosted tokenization
	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" expdate="#expdate#">
--->

	<cfscript>
		writeoutput("<br> MpiType: " 			& response_struct['MpiType']);
		writeoutput("<br> MpiSuccess: " 		& response_struct['MpiSuccess']);
		writeoutput("<br> MpiMessage: " 		& response_struct['MpiMessage']);
		writeoutput("<br> MpiPaReq: " 			& response_struct['MpiPaReq']);
		writeoutput("<br> MpiTermUrl: " 		& response_struct['MpiTermUrl']);
		writeoutput("<br> MpiMD: " 				& response_struct['MpiMD']);
		writeoutput("<br> MpiACSUrl: " 			& response_struct['MpiACSUrl']);
		writeoutput("<br> MpiCavv: " 			& response_struct['MpiCavv']);
		writeoutput("<br> MpiPAResVerified: " 	& response_struct['MpiPAResVerified']);

		//Processing VBV/MCSC
		MpiMessage = response_struct['MpiMessage'];
		if (MpiMessage EQ "Y")
		{
			writeoutput(#getMpiInLineForm()#);
		}
		else
		{
			if (MpiMessage EQ "U") {
				//merchant assumes liability for charge back (mostly corporate cards)
				//Process regular transaction with crypt_type="7"
			}
			else {
				//check VBV/MCSC guide for chargeback liability
				//Process attempted regular transaction with crypt_type="6"
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