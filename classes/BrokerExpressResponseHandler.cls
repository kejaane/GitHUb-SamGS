/********************************************************************************
 ********************************************************************************    
 *	Class            : BrokerExpressResponseHandler
 *	Author		     : Acumen Solutions: Alejandro Olivas
 *	Version History  : 1.0
 *	Creation         : 06/24/11
 *	Description      : This class processes the responses from Broker Express
 ********************************************************************************
 ********************************************************************************/
public with sharing class BrokerExpressResponseHandler {

	public Opportunity opp { get;set; }
	public String transactionId { get;set; }
	public boolean successResponse { get;set; }
	public String errorMessage { get;set; }

	public BrokerExpressResponseHandler(Opportunity opp, String transactionId) {
		this.opp = opp;
		this.transactionId = transactionId;
		this.successResponse = true;
		this.errorMessage = '';
	}

	/**
	 * This is the main entry point which parses a broker express response
	 */
	public void parseResponse(Dom.Document doc) {
		try {
			Dom.Xmlnode root = doc.getRootElement();
			Dom.Xmlnode body = XmlParser.getElementsByTagName(root, 'Body');
			Dom.Xmlnode gsa = XmlParser.getElementsByTagName(body, 'GSAServiceResponse');
			Dom.Xmlnode prospectId = XmlParser.getElementsByTagName(gsa, 'ProspectId');

			// Check if the "ProspectId" tag is found, if so this is a succesful response
			if ( prospectId != null ) {
				updateOpportunity(prospectId);
				logSuccessfulTransaction(prospectId.getText());
			} else {
				// The response returned contained the "Faults" tag, 
				// determine the type of error
				Dom.Xmlnode faults = XmlParser.getElementsByTagName(gsa, 'Faults');
				if ( faults != null ) {
					parseFaultResponse(faults);
				} else {
					// Found an unexpected response
					errorMessage = 'Broker Express returned an unexpected ' +
						'response.';
					successResponse = false;
				}
			}
		//} catch(XmlException e) {
			//errorMessage = 'Broker Express returned an unexpected response. ' +
				//'Parsing error [' + e.getMessage() + ']';
			//successResponse = false;
		} catch(NullPointerException n) {
			errorMessage = 'Null pointer Exception [ ' + n.getStackTraceString() + ']';
			successResponse = false;
		}
	}

	/**
	 * Parses a successful Broker Express hand shake response and updates the
	 * opportunity with the BE prospect Id.
	 */
	private void updateOpportunity(Dom.Xmlnode prospectId) {
		opp.BE_Prospect_ID__c = prospectId.getText();
		database.update(opp);
	}

	/**
	 * Logs a successful transaction to the BE Prospect ID look up table
	 */
	private void logSuccessfulTransaction(String prospectId) {
		try {
			BE_Prospect_Lookup__c transactionLog = 
				[SELECT Transaction_Id__c, Opportunity_ID__c, BE_Prospect_ID__c 
				 FROM BE_Prospect_Lookup__c 
				 WHERE Opportunity_ID__c =: opp.Id
				 AND BE_Prospect_ID__c =: ''];

			// Add the BE prospect ID to the previously errored transaction log record
			transactionLog.BE_Prospect_ID__c = prospectId;
			update transactionLog;
		} catch (Exception e) {
			ApexPages.addMessages(e);
		}
	}

	/**
	 * Parses a fault response and determines whether the fault error is a duplicate
	 * opportunity fault or a failure fault, then handles each scenario
	 */
	private void parseFaultResponse(Dom.Xmlnode faultRoot) {
		successResponse = false;
		Dom.Xmlnode[] faults = faultRoot.getChildElements();
		if ( faults.size() == 1 ) {
			parseSingleFault(faults[0]);
		} else if ( faults.size() > 1 ) {
			parseMultipleFaults(faults);
		} else {
			// Found an unexpected response
			errorMessage = 'Broker Express returned an unexpected fault response.';
			successResponse = false;
		}
	}

	/**
	 * Parses the SOAP error responses containing a single fault message
	 */
	private void parseSingleFault(Dom.Xmlnode fault) {
		processSOAPFaults(fault);
	}

	/**
	 * Parses the SOAP error responses containing multiple fault messages
	 */
	private void parseMultipleFaults(Dom.Xmlnode[] faults) {
		for ( Dom.XmlNode fault : faults ) {
			processSOAPFaults(fault);
		}
	}

	/**
	 * Checks the error look up table to get the user friendly error message
	 * based on the GSA code and logs the SOAP fault in the integration
	 * error log table
	 */
	private void processSOAPFaults(Dom.XmlNode fault) {
		Dom.Xmlnode faultCode = XmlParser.getElementsByTagName(fault, 'faultCode');
		Dom.Xmlnode faultMsg = XmlParser.getElementsByTagName(fault, 'faultMsg');

		processDuplicateProspectNumberFault(faultCode.getText(), faultMsg.getText());
		// Check if the successful response flag was reset (meaning the one off
		// scenario occurred so we simply update the opportunity with the 
		// BE prospect ID coming back from the response) if not log the error
		if ( !successResponse ) {
			errorMessage = faultMsg.getText();
			logIntegrationError(faultCode, faultMsg);
		}
	}

	/**
	 * Processes the edge case scenario where a response is returned with a
	 * duplicate BE prospect ID message but the opportunity object does not 
	 * have a BE prospect ID associated to it. This function will add the ID
	 * to the opportunity and the lookup table. 
	 */
	private void processDuplicateProspectNumberFault(String faultCode, String faultMsg) { 
		if ( faultCode.equals('GSA201') && faultMsg.contains('Duplicate') ) {
			// Check if this a the error scenario where the request timed out
			// of that the browser window was closed
			if ( opp.BE_Prospect_ID__c == null ) {
				try {
					// Reset the successful response flag to redirect back to the opp page
					successResponse = true;
					Integer startIndex = faultMsg.indexOf('PR-');
					Integer lastIndex = faultMsg.length();

					String beProspectId = faultMsg.substring(startIndex, lastIndex);
					opp.BE_Prospect_ID__c = beProspectId;
					update opp;

					logSuccessfulTransaction(beProspectId);
				} catch (Exception e) {
					successResponse = false;
					errorMessage = e.getMessage();
				}
			}
		}		
	}

	/**
	 * Logs intergation errors (Integration Error Log table)
	 */
	private void logIntegrationError(Dom.Xmlnode faultCode, Dom.Xmlnode faultMsg) {
		// Log the integration error message
		Integration_Err_Log__c errorLog = new Integration_Err_Log__c();
		errorLog.Err_Code__c = faultCode.getText();
		errorLog.Err_Message__c = faultMsg.getText();
		errorLog.Err_Time__c = Datetime.now();
		errorLog.Err_Type__c = 3.0; // 3 = ERROR
		errorLog.Source__c = 'SFDC';
		errorLog.Source_ID__c = opp.Id;
		errorLog.Target_ID__c = transactionId;
		errorLog.Target_System__c = 'Broker Express';
		insert errorLog;
	}

}