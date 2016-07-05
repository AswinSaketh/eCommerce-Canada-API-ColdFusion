<!-- ***************************************************************************************
* Name:				VBVStore
* File:				VBVStore.cfm
* Created:			Nov. 7, 2003
* Last Modified:	Nov. 14, 2003
*						- Added support for Cavv transactions with Recur
*						- Added support for getMPISuccess & getMPIMessage functions.
* Version:			1.1
* Author:			Phet Chai (Moneris Solutions)
* Description:		VBVStore is ColdFusion template containing a sample store that implements
*					the Moneris ColdFusion API with VBV support.  This sample demonstrates a
*					complete VBV transaction; from processing the VBV portion via the 
*					Moneris Solutions MPI gateway through to the financial portion
*					via the eSelect Plus MPG gateway.
*************************************************************************************** -->

<cftry>

	<cfif isDefined('Form.charge_total')>
		<cfinclude template="mpiAPIFunctions.cfm">
	
		<cfset mytime = TimeFormat(Now(), 'hh:mm:ss')>
		<cfset myday = DateFormat(Now(),'yyyy-mm-dd')>
		<cfset txnID = '#myday#__#mytime#'>

		<cfscript>
		MD = Form.order_id & ";" & Form.charge_total & ";" & Form.pan & ";" & Form.expiry_date & ";";
		myTxn = formTxnArray( txnID, Form.charge_total, Form.pan, Form.expiry_date, MD, "https://www.yourDomain.com/VBVStore.cfm", CGI.HTTP_ACCEPT, CGI.HTTP_USER_AGENT );
		</cfscript>

		<CF_mpiAPI_CF5 host="https://esqa.moneris.com:43924/mpi/servlet/MpiServlet" store_id="moneris" api_token="hurgle" txn_array="#myTxn#">

		<cfif getMPISuccess() EQ "true">
			<cfoutput>
			#getMPIInlineForm()#
			</cfoutput>
		<cfelse>
			<cfscript>
			//Not VBV Transaction, send regular financial transaction with crypt type 6 here to indicate Merchant is VBV enrolled.
			//The following debug code shows response data.
			keyArray = arrayNew(1);
			keyArray = structKeyArray(response_struct);
			for( i=1; i LTE arrayLen(keyArray); i=i+1 ) {
				writeoutput( "<br>" & keyArray[i] & " is:_________" & structFind(response_struct, keyArray[i]) );
			}
			</cfscript>
		</cfif>
	<cfelseif isDefined('Form.PaRes')>
		<cfinclude template="mpiAPIFunctions.cfm">
		
		<cfscript>
		order_id = getMDComponent( Form.MD, 0 );
		charge_total = getMDComponent( Form.MD, 1 );
		pan = getMDComponent( Form.MD, 2 );
		expiry_date = getMDComponent( Form.MD, 3 );
		
		myAcs = formAcsArray( Form.PaRes, Form.MD );
		</cfscript>
		
		<CF_mpiAPI_CF5 host="https://esqa.moneris.com:43924/mpi/servlet/MpiServlet" store_id="moneris" api_token="hurgle" txn_array="#myAcs#">

		<cfif getMPISuccess() EQ "true">
			<cfinclude template="mpgAPIFunctions.cfm">
			
			<cfscript>
			//VBV PIN has been authenticated, send financial transaction with CAVV value.
			cavv = getMpiCavv();
			myTxn = formCavvPurchaseArray( order_id, charge_total, pan, expiry_date, cavv );
			myRecur = formRecurArray( "month", "true", "2003/11/30", "4", "1", "14.50" );
			</cfscript>
			
			<CF_mpgAPI_CF5 host="https://esqa.moneris.com:43924/gateway2/servlet/MpgRequest" store_id="moneris" api_token="hurgle" txn_array="#myTxn#" cust_id="custiddata" recur="#myRecur#">

			<cfscript>
			keyArray = arrayNew(1);
			keyArray = structKeyArray(response_struct);
			for( i=1; i LTE arrayLen(keyArray); i=i+1 ) {
				writeoutput( "<br>" & keyArray[i] & " is:_________" & structFind(response_struct, keyArray[i]) );
			}
			</cfscript>
		<cfelse>
			<cfscript>
			//Authentication of cardholder by financial institution failed.  Respond to this appropriately here.
			//The following debug code shows response data.
			writeoutput( "<h3>Your VBV PIN authentication has failed!</h3><br><br>" );
			keyArray = arrayNew(1);
			keyArray = structKeyArray(response_struct);
			for( i=1; i LTE arrayLen(keyArray); i=i+1 ) {
				writeoutput( "<br>" & keyArray[i] & " is:_________" & structFind(response_struct, keyArray[i]) );
			}
			</cfscript>
		</cfif>
	<cfelse>
		<!-- Initial page to collect payment info from customer. -->
		<html>
		<head><title>VBV Test Transaction</title>
		</head>
		<body>
		<h3>VBV Transaction Test Page</h3>
		<form action="https://www.yourDomain.com//VBVStore.cfm" method="post">
		<table>
			<tr>
				<td align="right">Order ID:</td>
				<td><input type=text name="order_id" value="pur00001"></td>
			</tr>
			<tr>
				<td align="right">Credit Card Number:</td>
				<td><input type="text" name="pan" value="5454545454545454"></td>
			</tr>
			<tr>
				<td align="right">Expiry Date:</td>
				<td><input type="text" name="expiry_date" value="0512"></td>
			</tr>
			<tr>
				<td align="right">Charge Total:</td>
				<td><input type="text" name="charge_total" value="99.00"></td>
			</tr>
			<tr>
				<td><input type="submit" value="Submit"></td>
			</tr>
		</table>
		</form>
		</body>
		</html>
	</cfif>


<cfcatch type="Custom.Tag.mpiAPI_CF5">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>
<cfcatch type="Custom.Tag.mpgAPI_CF5">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>
<cfcatch type="Any">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch>

</cftry>
