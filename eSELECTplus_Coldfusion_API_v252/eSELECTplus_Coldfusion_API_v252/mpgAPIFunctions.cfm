<cfscript>

function setAvsInfo(avs_street_number, avs_street_name, avs_zipcode, avs_email, avs_hostname, avs_browser, avs_shiptocountry, avs_shipmethod, avs_merchprodsku, avs_custip, avs_custphone) {
    avsInfoArray = arrayNew(1);
    avsInfoArray[1] = avs_street_number;
    avsInfoArray[2] = avs_street_name;
    avsInfoArray[3] = avs_zipcode;
    avsInfoArray[4] = avs_email;
    avsInfoArray[5] = avs_hostname;
    avsInfoArray[6] = avs_browser;
    avsInfoArray[7] = avs_shiptocountry;
    avsInfoArray[8] = avs_shipmethod;
    avsInfoArray[9] = avs_merchprodsku;
    avsInfoArray[10] = avs_custip;
    avsInfoArray[11] = avs_custphone;
    return avsInfoArray;
}

function setCvdInfo(cvd_indicator, cvd_value) {
    cvdInfoArray = arrayNew(1);
    cvdInfoArray[1] = cvd_indicator;
    cvdInfoArray[2] = cvd_value;
    return cvdInfoArray;
}

function formIDebitPurchaseArray( orderid, amount, idebittrack2 ) {
	txnArray = arrayNew(1);
	txnArray[1] = "idebit_purchase";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = idebittrack2;
	return txnArray;
}

function formIDebitRefundArray( orderid, amount, txnnumber ) {
	txnArray = arrayNew(1);
	txnArray[1] = "idebit_refund";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = txnnumber;
	return txnArray;
}

function formPurchaseReversalArray( orderid, amount ) {
	txnArray = arrayNew(1);
	txnArray[1] = "purchase_reversal";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	return txnArray;
}

function formRefundReversalArray( orderid, amount ) {
	txnArray = arrayNew(1);
	txnArray[1] = "refund_reversal";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	return txnArray;
}

function formCavvPurchaseArray( orderid, amount, pan, expdate, cavv ) {
	txnArray = arrayNew(1);
	txnArray[1] = "cavv_purchase";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = pan;
	txnArray[5] = expdate;
	txnArray[6] = cavv;
	return txnArray;
}

function formCavvPreauthArray( orderid, amount, pan, expdate, cavv ) {
	txnArray = arrayNew(1);
	txnArray[1] = "cavv_preauth";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = pan;
	txnArray[5] = expdate;
	txnArray[6] = cavv;
	return txnArray;
}

function formPurchaseArray( orderid, amount, pan, expdate, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "purchase";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = pan;
	txnArray[5] = expdate;
	txnArray[6] = crypttype;
	return txnArray;
}

function formPreauthArray( orderid, amount, pan, expdate, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "preauth";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = pan;
	txnArray[5] = expdate;
	txnArray[6] = crypttype;
	return txnArray;
}

function formCompletionArray( orderid, compamount, txnnumber, crypttype, shipindicator ) {
	txnArray = arrayNew(1);
	txnArray[1] = "completion";
	txnArray[2] = orderid;
	txnArray[3] = compamount;
	txnArray[4] = txnnumber;
	txnArray[5] = crypttype;
	txnArray[6] = shipindicator;
	return txnArray;
}

function formPurchaseCorrectionArray( orderid, txnnumber, crypttype, shipindicator ) {
	txnArray = arrayNew(1);
	txnArray[1] = "purchasecorrection";
	txnArray[2] = orderid;
	txnArray[3] = txnnumber;
	txnArray[4] = crypttype;
	txnArray[5] = shipindicator;
	return txnArray;
}


function formRefundArray( orderid, amount, txnnumber, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "refund";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = txnnumber;
	txnArray[5] = crypttype;
	return txnArray;
}

function formIndRefundArray( orderid, amount, pan, expdate, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "ind_refund";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = pan;
	txnArray[5] = expdate;
	txnArray[6] = crypttype;
	return txnArray;
}

function formBatchCloseArray( ecr ) {
	txnArray = arrayNew(1);
	txnArray[1] = "batchclose";
	txnArray[2] = ecr;
	return txnArray;
}

function formBatchCloseAllArray() {
	txnArray = arrayNew(1);
	txnArray[1] = "batchcloseall";
	return txnArray;
}

function formOpenTotalsArray( ecr ) {
	txnArray = arrayNew(1);
	txnArray[1] = "opentotals";
	txnArray[2] = ecr;
	return txnArray;
}

function formRecurUpdateArray( orderid ) {
	txnArray = arrayNew(1);
	txnArray[1] = "recur_update";
	txnArray[2] = orderid;
	return txnArray;
}

function formReauthArray( orderid, origorderid, txnnumber, amount, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "reauth";
	txnArray[2] = orderid;
	txnArray[3] = origorderid;
	txnArray[4] = txnnumber;
	txnArray[5] = amount;
	txnArray[6] = crypttype;
	return txnArray;
}

function formCardVerificationArray( orderid, pan, expdate, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "card_verification";
	txnArray[2] = orderid;
	txnArray[3] = pan;
	txnArray[4] = expdate;
	txnArray[5] = crypttype;
	return txnArray;
}

function setBilling( first_name, last_name, company_name, address, city, province, postal_code, country, phone_number, fax, tax1, tax2, tax3, shipping_cost ) {
	billingArray = arrayNew(1);
	billingArray[1] = first_name;
	billingArray[2] = last_name;
	billingArray[3] = company_name;
	billingArray[4] = address;
	billingArray[5] = city;
	billingArray[6] = province;
	billingArray[7] = postal_code;
	billingArray[8] = country;
	billingArray[9] = phone_number;
	billingArray[10] = fax;
	billingArray[11] = tax1;
	billingArray[12] = tax2;
	billingArray[13] = tax3;
	billingArray[14] = shipping_cost;
	return billingArray;
}

function setShipping( first_name, last_name, company_name, address, city, province, postal_code, country, phone_number, fax, tax1, tax2, tax3, shipping_cost ) {
	shippingArray = arrayNew(1);
	shippingArray[1] = first_name;
	shippingArray[2] = last_name;
	shippingArray[3] = company_name;
	shippingArray[4] = address;
	shippingArray[5] = city;
	shippingArray[6] = province;
	shippingArray[7] = postal_code;
	shippingArray[8] = country;
	shippingArray[9] = phone_number;
	shippingArray[10] = fax;
	shippingArray[11] = tax1;
	shippingArray[12] = tax2;
	shippingArray[13] = tax3;
	shippingArray[14] = shipping_cost;
	return shippingArray;
}

function setEmail( email ) {
	emailArray = arrayNew(1);
	emailArray[1]= email;
	return emailArray;
}

function setInstructions( instruction ) {
	instructionArray = arrayNew(1);
	instructionArray[1] = instruction;
	return instructionArray;
}

function setItem( name, quantity, product_code, extended_amount ) {
	itemArray = arrayNew(1);
	itemArray[1] = name;
	itemArray[2] = quantity;
	itemArray[3] = product_code;
	itemArray[4] = extended_amount;
	return itemArray;
}

function formRecurArray( recur_unit, start_now, start_date, num_recurs, period, recur_amount ) {
	recurArray = arrayNew(1);
	recurArray[1] = recur_unit;
	recurArray[2] = start_now;
	recurArray[3] = start_date;
	recurArray[4] = num_recurs;
	recurArray[5] = period;
	recurArray[6] = recur_amount;
	return recurArray;
}

function formMCCompletionArray( orderid, compamount, txnnumber, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "mccompletion";
	txnArray[2] = orderid;
	txnArray[3] = compamount;
	txnArray[4] = txnnumber;
	txnArray[5] = crypttype;
	return txnArray;
}

function formVSCompletionArray( orderid, compamount, txnnumber, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "vscompletion";
	txnArray[2] = orderid;
	txnArray[3] = compamount;
	txnArray[4] = txnnumber;
	txnArray[5] = crypttype;
	return txnArray;
}

function formMCRefundArray( orderid, amount, txnnumber, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "mcrefund";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = txnnumber;
	txnArray[5] = crypttype;
	return txnArray;
}

function formVSRefundArray( orderid, amount, txnnumber, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "vsrefund";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = txnnumber;
	txnArray[5] = crypttype;
	return txnArray;
}

function formMCIndRefundArray( orderid, amount, pan, expdate, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "mcind_refund";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = pan;
	txnArray[5] = expdate;
	txnArray[6] = crypttype;
	return txnArray;
}

function formVSIndRefundArray( orderid, amount, pan, expdate, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "vsind_refund";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = pan;
	txnArray[5] = expdate;
	txnArray[6] = crypttype;
	return txnArray;
}

function formMCPurchaseCorrectionArray( orderid, txnnumber, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "mcpurchasecorrection";
	txnArray[2] = orderid;
	txnArray[3] = txnnumber;
	txnArray[4] = crypttype;
	return txnArray;
}

function formMCLevel23Array( orderid, txnnumber ) {
	txnArray = arrayNew(1);
	txnArray[1] = "mclevel23";
	txnArray[2] = orderid;
	txnArray[3] = txnnumber;
	return txnArray;
}

function formAddendum1Array( customer_code, tax_amount, freight_amount, ship_to_pos_code, ship_from_pos_code, duty_amount, alt_tax_amt_ind, alt_tax_amt, des_cou_code, sup_data, sal_tax_col_ind ) {
	txnArray = arrayNew(1);
	txnArray[1] = customer_code;
	txnArray[2] = tax_amount;
	txnArray[3] = freight_amount;
	txnArray[4] = ship_to_pos_code;
	txnArray[5] = ship_from_pos_code;
	txnArray[6] = duty_amount;
	txnArray[7] = alt_tax_amt_ind;
	txnArray[8] = alt_tax_amt;
	txnArray[9] = des_cou_code;
	txnArray[10] = sup_data;
	txnArray[11] = sal_tax_col_ind;
	return txnArray;
}

function formAddendum2Array( product_code, item_description, item_quantity, item_uom, ext_item_amount, discount_ind, discount_amount, net_gro_ind_for_ext_item_amt, tax_rate_app, tax_type_app, tax_amount, debit_credit_ind, alt_tax_ide_amt ) {
	txnArray = arrayNew(1);
	txnArray[1] = product_code;
	txnArray[2] = item_description;
	txnArray[3] = item_quantity;
	txnArray[4] = item_uom;
	txnArray[5] = ext_item_amount;
	txnArray[6] = discount_ind;
	txnArray[7] = discount_amount;
	txnArray[8] = net_gro_ind_for_ext_item_amt;
	txnArray[9] = tax_rate_app;
	txnArray[10] = tax_type_app;
	txnArray[11] = tax_amount;
	txnArray[12] = debit_credit_ind;
	txnArray[13] = alt_tax_ide_amt;
	return txnArray;
}

function addAddendum2Array( addendum2, product_code, item_description, item_quantity, item_uom, ext_item_amount, discount_ind, discount_amount, net_gro_ind_for_ext_item_amt, tax_rate_app, tax_type_app, tax_amount, debit_credit_ind, alt_tax_ide_amt ) {
	txnArray = arrayNew(1);
	txnArray = addendum2;
	arrayAppend( txnArray, product_code );
	arrayAppend( txnArray, item_description );
	arrayAppend( txnArray, item_quantity );
	arrayAppend( txnArray, item_uom );
	arrayAppend( txnArray, ext_item_amount );
	arrayAppend( txnArray, discount_ind );
	arrayAppend( txnArray, discount_amount );
	arrayAppend( txnArray, net_gro_ind_for_ext_item_amt );
	arrayAppend( txnArray, tax_rate_app );
	arrayAppend( txnArray, tax_type_app );
	arrayAppend( txnArray, tax_amount );
	arrayAppend( txnArray, debit_credit_ind );
	arrayAppend( txnArray, alt_tax_ide_amt );
	return txnArray;
}

function setPST( order_level_pst, merchant_pst_no ) {
	txnArray = arrayNew(1);
	txnArray[1] = order_level_pst;
	txnArray[2] = merchant_pst_no;
	return txnArray;
}

function setGST( order_level_gst, merchant_gst_no ) {
	txnArray = arrayNew(1);
	txnArray[1] = order_level_gst;
	txnArray[2] = merchant_gst_no;
	return txnArray;
}

function setCRI( cri ) {
	txnArray = arrayNew(1);
	txnArray[1] = cri;
	return txnArray;
}

function formVSPurchALArray( orderid, txnnumber ) {
	txnArray = arrayNew(1);
	txnArray[1] = "vspurchal";
	txnArray[2] = orderid;
	txnArray[3] = txnnumber;
	return txnArray;
}

function formPurchAArray( duty_amount, ship_to_pos_code, ship_from_pos_code, des_cou_code, vat_ref_num ) {
	txnArray = arrayNew(1);
	txnArray[1] = duty_amount;
	txnArray[2] = ship_to_pos_code;
	txnArray[3] = ship_from_pos_code;
	txnArray[4] = des_cou_code;
	txnArray[5] = vat_ref_num;
	return txnArray;
}

function formPurchLArray( item_com_code, product_code, item_description, item_quantity, item_uom, unit_cost, vat_tax_amt, vat_tax_rate, discount_amt ) {
	txnArray = arrayNew(1);
	txnArray[1] = item_com_code;
	txnArray[2] = product_code;
	txnArray[3] = item_description;
	txnArray[4] = item_quantity;
	txnArray[5] = item_uom;
	txnArray[6] = unit_cost;
	txnArray[7] = vat_tax_amt;
	txnArray[8] = vat_tax_rate;
	txnArray[9] = discount_amt;
	return txnArray;
}

function addPurchLArray( purchL, item_com_code, product_code, item_description, item_quantity, item_uom, unit_cost, vat_tax_amt, vat_tax_rate, discount_amt ) {
	txnArray = arrayNew(1);
	txnArray = purchL;
	arrayAppend( txnArray, item_com_code );
	arrayAppend( txnArray, product_code );
	arrayAppend( txnArray, item_description );
	arrayAppend( txnArray, item_quantity );
	arrayAppend( txnArray, item_uom );
	arrayAppend( txnArray, unit_cost );
	arrayAppend( txnArray, vat_tax_amt );
	arrayAppend( txnArray, vat_tax_rate );
	arrayAppend( txnArray, discount_amt );
	return txnArray;
}

</cfscript>