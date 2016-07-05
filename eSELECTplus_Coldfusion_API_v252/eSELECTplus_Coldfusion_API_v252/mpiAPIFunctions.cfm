<cfscript>
function formTxnArray( xid, amount, pan, expdate, MD, merchantUrl, accept, userAgent ) {
	txnArray = arrayNew(1);
	txnArray[1] = "txn";
	txnArray[2] = xid;
	txnArray[3] = amount;
	txnArray[4] = pan;
	txnArray[5] = expdate;
	txnArray[6] = MD;
	txnArray[7] = merchantUrl;
	txnArray[8] = accept;
	txnArray[9] = userAgent;
	return txnArray;
}

function formAcsArray( PaRes, MD ) {
	txnArray = arrayNew(1);
	txnArray[1] = "acs";
	txnArray[2] = PaRes;
	txnArray[3] = MD;
	return txnArray;
}

function getMDComponent( md, pos ) {
	mark_pos = 0;
	
	for( i=1; i LTE pos; i=i+1 ) {
		mark_pos = Find( ";", md, mark_pos + 1 );
	}
	
	num_of_char = Find( ";", md, mark_pos + 1 ) - mark_pos;
	return Mid( md, mark_pos + 1, num_of_char - 1 );
}

function getMPIInlineForm() {
	str = '<html><head><title>Title for Page</title></head>
<SCRIPT LANGUAGE="Javascript"> <!--
function OnLoadEvent()
{
document.downloadForm.submit();
}
-->
</SCRIPT> 
<body onload="OnLoadEvent()">
<form name="downloadForm" action="' & response_struct['ACSUrl'] &
'" method="POST">
<noscript>
<br>
<br>
<center>
<h1>Processing your 3-D Secure Transaction</h1>
<h2>
JavaScript is currently disabled or is not supported
by your browser.<br>
<h3>Please click on the Submit button to continue
the processing of your 3-D secure
transaction.</h3>
<input type="submit" value="Submit">
</center>
</noscript>
<input type="hidden" name="PaReq" value="' & response_struct['PaReq'] & '">
<input type="hidden" name="MD" value="' & response_struct['MD'] & '">
<input type="hidden" name="TermUrl" value="' & response_struct['TermUrl'] &'">
</form>
</body>
</html>';

	return str;  
}

function getMpiSuccess() {
	return response_struct['success'];
}

function getMpiMessage() {
	return response_struct['message'];
}

function getMpiCavv() {
	return response_struct['cavv'];
}
</cfscript>