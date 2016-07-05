<cftry>

	<cfinclude template="mpgAPIFunctions.cfm">

	
	<cfscript>
	dutyAmount = "1.00";
	shipToPosCode = "M8X 2W8";
	shipFromPosCode = "M1K 2Y7";
	desCouCode = "Canada";
	vatRefNum = "VAT12345";
	purchA = formPurchAArray( dutyAmount, shipToPosCode, shipFromPosCode, desCouCode, vatRefNum );

	itemComCode = "CC01";
	itemDescription = "CC01 descr";
	itemQuantity = "1";
	itemUom = "EA";
	unitCost = "1.01";
	vatTaxAmt = "0";
	vatTaxRate = "0";
	discountAmt = "0";
	purchL = formPurchLArray( itemComCode, "null", itemDescription, itemQuantity, itemUom, unitCost, vatTaxAmt, vatTaxRate, discountAmt );

	productCode = "VP02";
	itemDescription = "VP02";
	itemQuantity = "2";
	itemUom = "EA";
	unitCost = "2.35";
	vatTaxAmt = "0";
	vatTaxRate = "0";
	discountAmt = "0";
	purchL = addPurchLArray( purchL, "null", productCode, itemDescription, itemQuantity, itemUom, unitCost, vatTaxAmt, vatTaxRate, discountAmt );

	productCode = "Freight/Shipping";
	itemDescription = "Freight/Shipping";
	itemQuantity = "1";
	itemUom = "EA";
	unitCost = "1.69";
	vatTaxAmt = "0.21";
	vatTaxRate = "7.00";
	discountAmt = "0";
	purchL = addPurchLArray( purchL, "null", productCode, itemDescription, itemQuantity, itemUom, unitCost, vatTaxAmt, vatTaxRate, discountAmt );

	itemComCode = "VP04";
	itemDescription = "VP04 descr";
	itemQuantity = "4";
	itemUom = "CMT";
	unitCost = "3.34";
	vatTaxAmt = "0.94";
	vatTaxRate = "7.00";
	discountAmt = "0";
	purchL = addPurchLArray( purchL, itemComCode, "null", itemDescription, itemQuantity, itemUom, unitCost, vatTaxAmt, vatTaxRate, discountAmt );

	productCode = "Discount";
	itemDescription = "Discount";
	itemQuantity = "1";
	itemUom = "EA";
	unitCost = "0.23";
	vatTaxAmt = "0";
	vatTaxRate = "0";
	discountAmt = "0.23";
	purchL = addPurchLArray( purchL, "null", productCode, itemDescription, itemQuantity, itemUom, unitCost, vatTaxAmt, vatTaxRate, discountAmt );

	myTxn = formVSPurchALArray( "cfm5-40107132004120959", "403192-5-1" );
	</cfscript>


	<CF_mpgAPI_CF5 host="https://esqa.moneris.com:43924/level23/level23servlet" store_id="moneris" api_token="hurgle" txn_array="#myTxn#" purchA_array="#purchA#" purchL_array="#purchL#">


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