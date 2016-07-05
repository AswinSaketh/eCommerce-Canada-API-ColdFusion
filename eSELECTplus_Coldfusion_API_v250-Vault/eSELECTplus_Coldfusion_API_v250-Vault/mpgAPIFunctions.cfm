<cfscript>

function setAvsInfo(avs_street_number, avs_street_name, avs_zipcode) {
    avsInfoArray = arrayNew(1);
    avsInfoArray[1] = avs_street_number;
    avsInfoArray[2] = avs_street_name;
    avsInfoArray[3] = avs_zipcode;
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

function formCompletionArray( orderid, compamount, txnnumber, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "completion";
	txnArray[2] = orderid;
	txnArray[3] = compamount;
	txnArray[4] = txnnumber;
	txnArray[5] = crypttype;
	return txnArray;
}

function formPurchaseCorrectionArray( orderid, txnnumber, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "purchasecorrection";
	txnArray[2] = orderid;
	txnArray[3] = txnnumber;
	txnArray[4] = crypttype;
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

function formResAddCCArray( cust_id, phone, email, note, pan, expdate, crypt_type ) {
	txnArray = arrayNew(1);
	txnArray[1] = "res_add_cc";
	txnArray[2] = cust_id;
	txnArray[3] = phone;
	txnArray[4] = email;
	txnArray[5] = note;
	txnArray[6] = pan;
	txnArray[7] = expdate;
	txnArray[8] = crypt_type;
	return txnArray;
}

function formResUpdateCCArray( data_key ) {
	txnArray = arrayNew(1);
	txnArray[1] = "res_update_cc";
	txnArray[2] = data_key;
	return txnArray;
}

function formResDeleteArray( data_key ) {
	txnArray = arrayNew(1);
	txnArray[1] = "res_delete";
	txnArray[2] = data_key;
	return txnArray;
}

function formResIscorporatecardArray( data_key ) {
	txnArray = arrayNew(1);
	txnArray[1] = "res_iscorporatecard";
	txnArray[2] = data_key;
	return txnArray;
}

function formResLookupFullArray( data_key ) {
	txnArray = arrayNew(1);
	txnArray[1] = "res_lookup_full";
	txnArray[2] = data_key;
	return txnArray;
}

function formResLookupMaskedArray( data_key ) {
	txnArray = arrayNew(1);
	txnArray[1] = "res_lookup_masked";
	txnArray[2] = data_key;
	return txnArray;
}

function formResGetExpiringArray( ) {
	txnArray = arrayNew(1);
	txnArray[1] = "res_get_expiring";
	return txnArray;
}

function formResPurchaseCCArray( data_key, orderid, amount, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "res_purchase_cc";
	txnArray[2] = data_key;
	txnArray[3] = orderid;
	txnArray[4] = amount;
	txnArray[5] = crypttype;
	return txnArray;
}

function formResPreauthCCArray( data_key, orderid, amount, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "res_preauth_cc";
	txnArray[2] = data_key;
	txnArray[3] = orderid;
	txnArray[4] = amount;
	txnArray[5] = crypttype;
	return txnArray;
}

function formResIndRefundCCArray( data_key, orderid, amount, crypttype ) {
	txnArray = arrayNew(1);
	txnArray[1] = "res_ind_refund_cc";
	txnArray[2] = data_key;
	txnArray[3] = orderid;
	txnArray[4] = amount;
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



</cfscript>