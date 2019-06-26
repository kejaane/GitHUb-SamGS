/********************************************************************************
 ********************************************************************************    
 *	Class            : SubmitToBrokerExpress
 *	Author		     : Acumen Solutions: Alejandro Olivas
 *	Version History  : 1.0
 *	Creation         : 06/17/11
 *	Description      : This class is responsible for creating the HTTP request
 *					   to invoke Broker Express and subsequently parsing the
 *					   web service's response and performing the necessary
 * 					   business logic based on the response. This class is also 
 *					   responsible for handling errors and unexpected situations.
 ********************************************************************************
 *---------------------------------------------------------------------------------------------
 *                      ----===[ HISTORY ]===---
 * Date        Developer        Description
 *---------------------------------------------------------------------------------------------
 *
 * 11/21/2014 Ken Gill          Added additional validation to reject proposed opportunities older than 180 days
 *                              being submitted to Broker Express
 ********************************************************************************/
public with sharing class SubmitToBrokerExpress {

    public Opportunity opp { get;set; }
	public boolean environmentVarsPresent { get;set; }

    private Set<String> requiredSOAPVars;
    private Datetime currTime;

    public SubmitToBrokerExpress(ApexPages.StandardController stdController) {
        opp =
            [SELECT Id, BE_Prospect_ID__c FROM Opportunity 
             WHERE ID =: stdController.getRecord().Id];
        environmentVarsPresent = true;
        setRequiredSOAPVars();
    }

	/**
	 * This function handles the event that occurs after the "Submit to BE"
	 * button is clicked, it performs data and environment variable validations
	 * and upon successful validation creates an HTTP SOAP request and makes
	 * a webservice call to Broker Express it then takes the response and 
	 * parses it to update Salesforce and notify the user of success or failure
	 */
	public PageReference submitToBrokerExpress() {
		PageReference pageRef = null;
		try {
			Map<String, EnvironmentVariable__c> soapVars = getBrokerExpressEnvironmentVars();
			if ( validateEnvironmentVarsPresent(soapVars) ) {
				// Generate the transaction ID
				currTime = DateTime.now();
				String transactionId = String.valueOf(currTime.getTime());

				// Validate the data
				BrokerExpressValidation validation = 
					new BrokerExpressValidation(opp.Id, transactionId);
				validation.validateData();
				if ( validation.validRequest ) {
					pageRef = processRequest(validation, transactionId, soapVars);
				} else {
					String errorMessage = '<h1><font color="blue">Your request can not be sent to ' +
						'Broker Express at this time because of the following reason(s):</font></h1><br/><br/>';

					// if fields missing: add missing message
					if ( validation.fieldsMissing ) {
						errorMessage += '<h1><font color="black">The following fields are ' +
							'missing:</font></h1><br/>';
						errorMessage += validation.missingFieldsMessage;
						errorMessage += '<br/>';
					}

					// if the opportunity is dead or sold
					if ( validation.oppStageError ) {
						errorMessage += '<h1><font color="black">This opportunity is not ' +
							'proposed:</font></h1><br/>';
						errorMessage += validation.oppStageErrorMessage;
						errorMessage += '<br/>';					
					}
					
					// KG 11/20/14: if the proposed opportunity is more than 180 days old
					if ( validation.oppProposedMoreThan180DaysAgoError ) {
						errorMessage += '<h1><font color="black">This opportunity is too old </font></h1><br/>';
						errorMessage += validation.oppProposedMoreThan180DaysAgoErrorMessage;
						errorMessage += '<br/>';					
					}
					

					// if the opportunity has already been submitted
					if ( validation.duplicateError ) {
						errorMessage += '<h1><font color="black">Duplicate opportunity:' +
							'</font></h1><br/>';
						errorMessage += validation.duplicateErrorMessage;
						errorMessage += '<br/>';
					}

					// if other errors show here
					if ( validation.validationErrors ) {
						errorMessage += '<h1><font color="black">The following fields contain ' +
							'validation errors:</font></h1><br/>';
						errorMessage += validation.validationErrorMessage;
						errorMessage += '<br/>';					
					}

					errorMessage += '<h1><font color="blue">Please fix the errors above and ' +
						'resubmit your request.</font><h1/>';
					ApexPages.Message msg = 
						new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
					ApexPages.addMessage(msg);
				}
			}
		} catch (Exception e) {
			pageRef = null;
			ApexPages.addMessages(e);
		}
        return pageRef;
	}

	/**
	 * Process the SOAP request and response with Broker Express
	 */
	private PageReference processRequest(BrokerExpressValidation validation,
			String transactionId, Map<String, EnvironmentVariable__c> soapVars) {
		PageReference pageRef = null;
		if ( !validation.prospectIdFromLookup ) {

			BrokerExpressRequestGenerator req = 
				new BrokerExpressRequestGenerator(transactionId, currTime);
			Dom.Document response = req.submitSOAPRequest(validation, soapVars);

			if ( response != null ) {
				//String transactionId = req.transactionId;

				// Parse the response
				BrokerExpressResponseHandler handler = 
					new BrokerExpressResponseHandler(opp, transactionId);
				handler.parseResponse(response);

				if ( !handler.successResponse ) {
					String errorMessage = 
						'<h1><font color="blue">Your request can not be sent to ' +
						'Broker Express at this time because of the following ' +
						'reason(s):</font></h1><br/><br/>';
					errorMessage += handler.errorMessage;
					errorMessage += 
						'</br></br><h1><font color="blue">Please fix the errors ' +
						'above and resubmit your request.</font><h1/>';

					// There was an error in the response
					ApexPages.Message msg = 
						new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
					ApexPages.addMessage(msg);
				} else {
    	    		// Redirect the user back to the opportunity detail page when no errors
	        		pageRef = new PageReference('/' + opp.Id);
	        		pageRef.setRedirect(true);
				}
			}
		} else {
    		// There was an error at some point in time, where the opportunity was 
    		// successfully processed by Broker Express and returned a valid prospect ID
    		// but was never saved to the opportunity in Salesforce. At this point the
    		// prospect id was retrieved from the prospect id look up table and the
    		// opportunity was populated with it, returning the user to the opportunity
    		// detail page for the operation to appear smoothly
    		pageRef = new PageReference('/' + opp.Id);
    		pageRef.setRedirect(true);
		}
		return pageRef;
	}

	/**
	 * Verifies that the necessary environment variables, such as the WSDL endpoint etc,
	 * required to generate the HTTP request are present at the time of invoking the
	 * Submit to BE button on the opportunity detail page
	 * @TODO: a nice feature to have would be to send an email to the system admins
	 * if any of these issues are encountered.
	 */
	private boolean validateEnvironmentVarsPresent(Map<String, EnvironmentVariable__c> soapVars) {
		boolean environmentVarsPresent = true;
		Set<String> reqVars = requiredSOAPVars.clone();
		String errorMessage = '<h1><font color="blue">Your request can not be sent to ' +
				'Broker Express for the following reason:</font></h1><br/><br/>';

		if ( soapVars.isEmpty() ) {
 			environmentVarsPresent = false;
			errorMessage += '<strong>All ' + requiredSOAPVars.size() + 
				' environment variables are missing:</strong><br/>';
		} else if ( soapVars.size() != requiredSOAPVars.size() ) {
			environmentVarsPresent = false;
			// Remove the environment variables found to keep the ones missing
			for ( EnvironmentVariable__c var : soapVars.values() ) {
				reqVars.remove(var.Variable_Name__c);
			}
			errorMessage += '<strong>The following environment variables are missing:</strong><br/>';
		}

		// Complete building the error message if one was found 
		if ( !environmentVarsPresent ) {
			// Add to the message the remaining/missing environment variables
			for ( String varName : reqVars ) {
				errorMessage += '<font color="red">' + varName + '</font><br/>';
			}

			errorMessage +=
				'<br/><h1><font color="blue">Please contact a system admin.</font><h1/>';
			ApexPages.Message msg = 
				new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
			ApexPages.addMessage(msg);
		}
		return environmentVarsPresent;
	}

	/**
	 * Creates a set containing the names of the required environment variables used
	 * for creating the HTTP SOAP request. These values are hard-coded because they are
	 * used in the code to generate the SOAP request, the environment variable object's 
	 * variable name fields under the Broker Express module must be kept in sync with
	 * this list here.
	 */
	private void setRequiredSOAPVars() {
		requiredSOAPVars = new Set<String>{
			'Endpoint', 
			'RequestMethod', 
			'RequestTimeout', 
			'Environment',
			'ClientCertificateName'	// KG 11/1/14 : Added to enable SSL client certificate authentication 
		};
	}

	/**
	 * Gets the Broker Express environment variables in an easily accessible map
	 */
	 /* KG 10/27/14 - Replaced this implementation with a new one below. Limitations of this code:
	    1. The filter AND clause is unnecessary and effectively prevents non 'Required' env vars from ever being used making them 
	       of no use whatsoever even if configured in EnvironmentVariable__c table
	    2. Does not allow for common module variables
	private Map<String, EnvironmentVariable__c> getBrokerExpressEnvironmentVars() {
		Map<String, EnvironmentVariable__c> soapVars = new Map<String, EnvironmentVariable__c>();
		for ( List<EnvironmentVariable__c> vars : [SELECT Variable_Name__c, Value__c, Module__c, IsEncrypted__c 
			 FROM EnvironmentVariable__c WHERE Module__c =: 'Broker Express'
			 AND Variable_Name__c IN: requiredSOAPVars ] ) {

			for ( EnvironmentVariable__c currVar : vars ) {
				soapVars.put(currVar.Variable_Name__c, currVar);
			}
		}
		return soapVars;
	}
	
	*/

	/**
	 * Gets the Broker Express environment variables in an easily accessible map
	 * New Implementation ( KG 10/27/14): 
	 * 1. Combine query on Module__c = 'BrokerExpress' and 'Common'
	 * 2. Remove AND filter clause
	 */
	
		private Map<String, EnvironmentVariable__c> getBrokerExpressEnvironmentVars() {
		Map<String, EnvironmentVariable__c> soapVars = new Map<String, EnvironmentVariable__c>();
		for ( List<EnvironmentVariable__c> vars : [SELECT Variable_Name__c, Value__c, Module__c, IsEncrypted__c 
			 									  FROM EnvironmentVariable__c WHERE Module__c IN ('Broker Express', 'Common')] 
	        ) {
				for ( EnvironmentVariable__c currVar : vars ) {
					soapVars.put(currVar.Variable_Name__c, currVar);
			}
		}
		return soapVars;
	}
	
	

}