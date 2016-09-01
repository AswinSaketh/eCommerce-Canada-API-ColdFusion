<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfset mytime = TimeFormat(Now(), 'hh:mm:ss')>
	<cfset myday = DateFormat(Now(),'mmddyyyy')>
	<cfset OrderID = '#myday##mytime#'>

	<cfscript>
		callid = "5085035846239393724";
		myTxn = formVdotMeInfoArray( callid );

	</cfscript>

	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store2" api_token="yesguy" txn_array="#myTxn#">

	<cfscript>
		//Receipt
		writeoutput("<br> ResponseCode: "     						& vdotme_info_struct['ResponseCode']);
		writeoutput("<br> Message: "     							& vdotme_info_struct['Message']);
		writeoutput("<br> CurrencyCode: "     						& vdotme_info_struct['CurrencyCode']);
		writeoutput("<br> Total: "     								& vdotme_info_struct['PaymentTotal']);
		writeoutput("<br> UserFirstName: "    	 					& vdotme_info_struct['UserFirstName']);
		writeoutput("<br> UserLastName: "     						& vdotme_info_struct['UserLastName']);
		writeoutput("<br> UserName: "     							& vdotme_info_struct['UserName']);
		writeoutput("<br> UserEmail: "     							& vdotme_info_struct['UserEmail']);
		writeoutput("<br> EncUserId: "     							& vdotme_info_struct['EncUserId']);
		writeoutput("<br> CreationTimeStamp: "     					& vdotme_info_struct['CreationTimeStamp']);
		writeoutput("<br> NameOnCard: "     						& vdotme_info_struct['NameOnCard']);
		writeoutput("<br> ExpirationDateMonth: "     				& vdotme_info_struct['ExpirationDateMonth']);
		writeoutput("<br> ExpirationDateYear: "     				& vdotme_info_struct['ExpirationDateYear']);
		writeoutput("<br> LastFourDigits: "     					& vdotme_info_struct['LastFourDigits']);
		writeoutput("<br> BinSixDigits: "     						& vdotme_info_struct['BinSixDigits']);
		writeoutput("<br> CardBrand: "     							& vdotme_info_struct['CardBrand']);
		writeoutput("<br> CardType: "     							& vdotme_info_struct['CardType']);
		writeoutput("<br> BillingId: "     							& vdotme_info_struct['BillingId']);
		writeoutput("<br> BillingAddressPersonName: "     			& vdotme_info_struct['BillingPersonName']);
		writeoutput("<br> BillingAddressLine1: "     				& vdotme_info_struct['BillingAddressLine1']);
		writeoutput("<br> BillingAddressCity: "     				& vdotme_info_struct['BillingCity']);
		writeoutput("<br> BillingAddressStateProvinceCode: "     	& vdotme_info_struct['BillingStateProvinceCode']);
		writeoutput("<br> BillingAddressPostalCode: "     			& vdotme_info_struct['BillingPostalCode']);
		writeoutput("<br> BillingAddressCountryCode: "     			& vdotme_info_struct['BillingCountryCode']);
		writeoutput("<br> BillingAddressPhone: "     				& vdotme_info_struct['BillingPhone']);
		writeoutput("<br> VerificationStatus: "     				& vdotme_info_struct['BillingVerificationStatus']);
		writeoutput("<br> Expired: "     							& vdotme_info_struct['isExpired']);
		writeoutput("<br> BaseImageFileName: "     					& vdotme_info_struct['BaseImageFileName']);
		writeoutput("<br> Height: "     							& vdotme_info_struct['Height']);
		writeoutput("<br> Width: "    		 						& vdotme_info_struct['Width']);
		writeoutput("<br> IssuerBid: "     							& vdotme_info_struct['IssuerBid']);
		writeoutput("<br> PartialShippingAddressCountryCode: "     	& vdotme_info_struct['PartialShippingCountryCode']);
		writeoutput("<br> PartialShippingAddressPostalCode: "     	& vdotme_info_struct['PartialShippingPostalCode']);
		writeoutput("<br> ShippingAddressPersonName: "    			& vdotme_info_struct['ShippingPersonName']);
		writeoutput("<br> ShippingAddressLine1: "     				& vdotme_info_struct['ShippingAddressLine1']);
		writeoutput("<br> ShippingAddressCity: "     				& vdotme_info_struct['ShippingCity']);
		writeoutput("<br> ShippingAddressStateProvinceCode: "     	& vdotme_info_struct['ShippingStateProvinceCode']);
		writeoutput("<br> ShippingAddressPostalCode: "     			& vdotme_info_struct['ShippingPostalCode']);
		writeoutput("<br> ShippingAddressCountryCode: "     		& vdotme_info_struct['ShippingCountryCode']);
		writeoutput("<br> ShippingAddressPhone: "     				& vdotme_info_struct['ShippingPhone']);
		writeoutput("<br> ShippingAddressDefault: "     			& vdotme_info_struct['ShippingDefault']);
		writeoutput("<br> ShippingAddressId: "     					& vdotme_info_struct['ShippingId']);
		writeoutput("<br> ShippingAddressVerificationStatus: "     	& vdotme_info_struct['ShippingVerificationStatus']);
		writeoutput("<br> RiskAdvice: "     						& vdotme_info_struct['RiskAdvice']);
		writeoutput("<br> RiskScore: "     							& vdotme_info_struct['RiskScore']);
		writeoutput("<br> AvsResponseCode: "     					& vdotme_info_struct['AvsResponseCode']);
		writeoutput("<br> CvvResponseCode: "     					& vdotme_info_struct['CvvResponseCode']);
	</cfscript>

<cfcatch type="Custom.Tag.mpgAPI_CF5">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>
<cfcatch type="Any">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>

</cftry>