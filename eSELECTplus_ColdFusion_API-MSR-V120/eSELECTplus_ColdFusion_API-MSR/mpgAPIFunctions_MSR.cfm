<cfscript>

function formTrack2PurchaseArray( orderid, amount, pan, expdate, track2, poscode ) {
	txnArray = arrayNew(1);
	txnArray[1] = "track2_purchase";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = pan;
	txnArray[5] = expdate;
	txnArray[6] = track2;
	txnArray[7] = poscode;
	return txnArray;
}

function formTrack2PreauthArray( orderid, amount, pan, expdate, track2, poscode ) {
	txnArray = arrayNew(1);
	txnArray[1] = "track2_preauth";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = pan;
	txnArray[5] = expdate;
	txnArray[6] = track2;
	txnArray[7] = poscode;
	return txnArray;
}

function formTrack2CompletionArray( orderid, compamount, txnnumber ) {
	txnArray = arrayNew(1);
	txnArray[1] = "track2_completion";
	txnArray[2] = orderid;
	txnArray[3] = compamount;
	txnArray[4] = txnnumber;
	return txnArray;
}

function formTrack2PurchaseCorrectionArray( orderid, txnnumber ) {
	txnArray = arrayNew(1);
	txnArray[1] = "track2_purchasecorrection";
	txnArray[2] = orderid;
	txnArray[3] = txnnumber;
	return txnArray;
}

function formTrack2RefundArray( orderid, amount, txnnumber ) {
	txnArray = arrayNew(1);
	txnArray[1] = "track2_refund";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = txnnumber;
	return txnArray;
}

function formTrack2IndRefundArray( orderid, amount, pan, expdate, track2, poscode ) {
	txnArray = arrayNew(1);
	txnArray[1] = "track2_ind_refund";
	txnArray[2] = orderid;
	txnArray[3] = amount;
	txnArray[4] = pan;
	txnArray[5] = expdate;
	txnArray[6] = track2;
	txnArray[7] = poscode;
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

</cfscript>