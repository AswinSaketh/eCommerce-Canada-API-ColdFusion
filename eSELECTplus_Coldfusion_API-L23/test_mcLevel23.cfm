<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	
	<cfscript>
	myTxn = formMCLevel23Array( "cfm5-40107122004034806", "402804-1-2" );
	
	customerCode = "ACCOUNTING OPERAT";
	taxAmount = "0.98";
	freightAmount = "0.0";
	shipToPosCode = "V6Z 2V8";
	shipFromPosCode = "V5C 3W9";
	dutyAmount = "0.0";
	altTaxAmtInd = "Y";
	altTaxAmt = "0.0";
	desCouCode = "CAN";
	supData = "MASTERCARD";
	salTaxColInd = "Y";
	addendum1 = formAddendum1Array( customerCode, taxAmount, freightAmount, shipToPosCode, shipFromPosCode, dutyAmount, altTaxAmtInd, altTaxAmt, desCouCode, supData, salTaxColInd );

	productCode = "OPTIBELT 4L1";
	itemDescription = "OPTIBELT 4L250 FHP BELT";
	itemQuantity = "2";
	itemUom = "EA";
	extItemAmount = "6.86";
	discountInd = "N";
	discountAmount = "0.0";
	netGroIndForExtItemAmt ="N";
	taxRateApp = "0.0";
	taxTypeApp = "";
	taxAmount = "0.0";
	debitCredInd = "";
	altTaxIdeAmt = "0.0";
	addendum2 = formAddendum2Array( productCode, itemDescription, itemQuantity, itemUom, extItemAmount, discountInd, discountAmount, netGroIndForExtItemAmt, taxRateApp, taxTypeApp, taxAmount, debitCredInd, altTaxIdeAmt );
	addendum2 = addAddendum2Array( addendum2, productCode, itemDescription, itemQuantity, itemUom, extItemAmount, discountInd, discountAmount, netGroIndForExtItemAmt, taxRateApp, taxTypeApp, taxAmount, debitCredInd, altTaxIdeAmt );
	</cfscript>


	<CF_mpgAPI_CF5 host="https://esqa.moneris.com:43924/level23/level23servlet" store_id="moneris" api_token="hurgle" txn_array="#myTxn#" addendum1_array="#addendum1#" addendum2_array="#addendum2#">


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