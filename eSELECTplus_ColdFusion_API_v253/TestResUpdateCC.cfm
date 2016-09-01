<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<cfscript>
		data_key = "AuivOCNcf3Qz3rJMkZee94I0Z";
		myTxn = formResUpdateCCArray( data_key );

		cust_id = "customer 22";
		phone = "999-888-7777";
		email = "your@email.com";
		note = "hey there";
		pan = "4242424254545454";
		expdate = "1810";
		crypt_type = "1";

		// Declaring AVS values
		avs_street_number = "12";
		avs_street_name = "hello world2";
		avs_zipcode = "98765";

		//Method 1:
		//you can either build the full avs_info array with all the fields present
		//this will update all of the fields within avs_info

		avsInfo = setAvsInfo(avs_street_number, avs_street_name, avs_zipcode);

		//Method 2:
		//or, you can build a struct to only pass the fields you wish to update

		avsInfoStruct = StructNew();
		//will update the zipcode with the new data
		StructInsert( avsInfoStruct, "avs_zipcode", avs_zipcode);

		//will remove the street number
		StructInsert( avsInfoStruct, "avs_street_number", avs_street_number);
	</cfscript>

	<!--- Method 1: passing the full array	--->
	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" cust_id="#cust_id#" phone="#phone#" email="#email#" note="#note#" pan="#pan#" expdate="#expdate#" crypt_type="#crypt_type#" avs_info_array="#avsInfo#">


	<!--- Method 2: passing the struct with appropriate fields
	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#myTxn#" cust_id="#cust_id#" phone="#phone#" email="#email#" note="#note#" pan="#pan#" expdate="#expdate#" crypt_type="#crypt_type#" avs_info_struct="#avsInfoStruct#">
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