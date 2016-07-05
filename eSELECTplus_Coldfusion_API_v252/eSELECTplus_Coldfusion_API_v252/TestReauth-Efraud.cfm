<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">


	<cfset mytime = TimeFormat(Now(), 'hhmmss')>
	<cfset myday = DateFormat(Now(),'mmddyyyy')>
	<cfset OrderID = '#myday##mytime#'>


	<cfscript>
	order_id = "cfm5-401" & OrderID;

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

	myTxn = formReauthArray( order_id, "original_order_id", "123_45-6", "1.00", "7" );

	</cfscript>


	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" avs_info_array="#avsInfo#" cvd_info_array="#cvdInfo#">


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