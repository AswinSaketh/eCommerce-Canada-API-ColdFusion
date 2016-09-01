<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	<CF_mpgAPI_CF5 host="https://esqa.moneris.com/gateway2/servlet/MpgRequest" store_id="store5" api_token="yesguy" txn_array="#formResGetExpiringArray( )#">

	<cfscript>
		keyArray = structKeyArray(resolver_response_struct);

		for( i=1; i LTE arrayLen(keyArray); i=i+1 )
		{
			resolve_data_response_struct = structNew();
			resolve_data_response_struct = structFind(resolver_response_struct, #i#);
			writeoutput("<br>----------Resolver Data-------------------");
			writeoutput("<br> DataKey: "            & resolve_data_response_struct['data_key']);
			writeoutput("<br> PaymentType: "        & resolve_data_response_struct['payment_type']);
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
		}
	</cfscript>

<cfcatch type="Custom.Tag.mpgAPI_CF5">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>
<cfcatch type="Any">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>

</cftry>