/********************************************************************************
 ********************************************************************************    
 *	Class            : BrokerExpressRequestGenerator
 *	Author		     : Acumen Solutions: Alejandro Olivas
 *	Version History  : 1.0
 *	Creation         : 06/17/11
 *	Description      : This class dynamically generates the SOAP request sent
 *					   the Broker Express WSDL
 *
 *  9/3/15  Ken Gill  Added effective date element to the method generateGeneralDetailsSection()
 *                     in support the HIX722 project requirement to send effective date. The element
 *                    is <sfdc:ProposedEffectiveDate>
 *
 ********************************************************************************
 ********************************************************************************/
public with sharing class BrokerExpressRequestGenerator {

	public String transactionId { get;set; }
	private Datetime timeofSubmit;

	private Map<String, EnvironmentVariable__c> environmentVars;
	private Map<String, String> fieldVals;

	public BrokerExpressRequestGenerator(String transactionId, Datetime timeofSubmit) {
		this.transactionId = transactionId;
		this.timeofSubmit = timeofSubmit;
	}

	/**
	 * Builds an HTTP SOAP request from the opportunity's data
	 */
	public Dom.Document submitSOAPRequest(BrokerExpressValidation validation,
		Map<String, EnvironmentVariable__c> vars) {
		environmentVars = vars;
		fieldVals = validation.brokerExpressFieldVals;
		Dom.Document doc = null;
		//currTime = DateTime.now();
		//transactionId = String.valueOf(currTime.getTime());

		try {
			HttpRequest request = new HttpRequest();
        	request.setHeader('content-type', 'text/xml');
        	request.setEndpoint(environmentVars.get('Endpoint').value__c);
        	request.setMethod(environmentVars.get('RequestMethod').value__c);
        	request.setTimeout(Integer.valueof(environmentVars.get('RequestTimeout').value__c));
        		// KG 11/1/14 - Add client certificate for new 2-way SSL authentication between SFDC and BrokerExpress system
        	request.setClientCertificateName(environmentVars.get('ClientCertificateName').value__c);

			String soapMessage = generateSOAPRequestBody();
			System.debug('**** REQUEST = ' + soapMessage);

         	// Set SOAP message
        	request.SetBody(soapMessage);

        	// Make a call out
        	Http httpCallout = new Http();
        	HttpResponse response = new HttpResponse();
        	if ( !Test.isRunningTest() ) {
        		response = httpCallout.send(request);
        	} else {
				// create fake response for test purposes
				response.setStatusCode(200);
				response.setBody(createSuccessResponse('PR-16981'));
        	}
			System.debug('**** RESPONSE = ' + response);

         	// Process Response
        	doc = new Dom.Document();
        	String responseBody = response.getBody();
        	doc.load(responseBody);
 			System.debug('**** RESPONSE BODY = ' + responseBody);

		} catch (CalloutException c) {
			String error = 'Callout exception at the time of making the ' +
				'web service call: <strong>' + c.getMessage() + '</strong>' +
				'<br/><br/>Please contact a system administrator.';
			ApexPages.Message msg = 
				new ApexPages.Message(ApexPages.Severity.ERROR, error);
			ApexPages.addMessage(msg);
			ApexPages.addMessages(c);
		} catch (Exception e) {
			ApexPages.addMessages(e);
		}
		return doc;
	}

	/**
	 * Generates the SOAP request body to make a web service call to broker express 
	 */
	private String generateSOAPRequestBody() {
		String soapReq = '<soapenv:Envelope'; 
		soapReq += generateSOAPEndPointInfo();
		soapReq += generateSOAPHeader();
		soapReq += generateSOAPBody();
		soapReq += '</soapenv:Envelope>';
		System.debug('***** soap request = ' + soapReq);
		return soapReq;
	}

	/**
	 * Generates the end-points section
	 */
	private String generateSOAPEndPointInfo() {
		String soapEnvelope = ' ';
		soapEnvelope += 'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ';
		soapEnvelope += 'xmlns:eaih="http://carefirst.com/LoadGSA/EAIHeader" ';
		soapEnvelope += 'xmlns:par="http://www.tibco.com/namespaces/bc/2002/04/partyinfo.xsd" ';
		soapEnvelope += 'xmlns:sfdc="http://www.carefirst.com/BrokerExpress/LoadGSA/SFDC">';
		return soapEnvelope;
	}

	/**
	 * Generates the header for a SOAP request
	 */
	private String generateSOAPHeader() {
		String soapHeader = '<soapenv:Header>';
		soapHeader += generateSOAPHeaderEndPointBinding();
		soapHeader += generateSOAPHeaderPartyInfo();
		soapHeader += '</soapenv:Header>';
		return soapHeader;
	}

	/**
	 * Generates the Endpoint Binding sub-section of the SOAP header request
	 */
	private String generateSOAPHeaderEndpointBinding() {
		String sourceID = 'SFDC00000';
		String sourceName = 'SFDC';
		String eventType = 'Initial';
		String version = '1.0';

		String endPointBinding = '<eaih:Header>';
		endPointBinding +=    '<SourceId>' + sourceID + '</SourceId>';
		endPointBinding +=    '<SourceName>' + sourceName + '</SourceName>';
		endPointBinding +=    '<TransactionID>' + transactionId + '</TransactionID>';
		endPointBinding +=    '<Environment>' + environmentVars.get('Environment').value__c + '</Environment>';
		endPointBinding +=    '<EventType>' + eventType + '</EventType>';
		endPointBinding +=    '<Version>' + version + '</Version>';
		endPointBinding +=    '<Timestamp>' + String.valueOf(timeofSubmit) + '</Timestamp>';
		endPointBinding += '</eaih:Header>';
		return endPointBinding;
	}

	/**
	 * Generates the Party Info sub-section of the SOAP header request
	 */
	private String generateSOAPHeaderPartyInfo() {
		String domain = 'zz';
		String fromName = 'SFDC00000';
		String toName = '080';
		
		String operationId = 'LoadProspectPortType/LoadProspectPortTypeEndpointBinding/LoadProspect';
		String syncReqResponse = 'syncRequestResponse';

		String partyInfo = '<par:PartyInfo>';
		partyInfo += '<from>';
		partyInfo += 	'<domain>' + domain + '</domain>';
		partyInfo += 	'<name>' + fromName + '</name>';
		partyInfo += '</from>';

		partyInfo += '<to>';
		partyInfo += 	'<domain>' + domain + '</domain>';
		partyInfo += 	'<name>' + toName + '</name>';
		partyInfo += '</to>';

		partyInfo += '<operationID>' + operationId + '</operationID>';
		partyInfo += '<operationType>' + syncReqResponse + '</operationType>';
		partyInfo += '<transactionID>' + transactionId + '</transactionID>';

		partyInfo += '</par:PartyInfo>';
		return partyInfo;
	}

	/**
	 * Generates the SOAP request's general body structure
	 */
	private String generateSOAPBody() {
		String soapBody = '';
		soapBody += '<soapenv:Body>';
		soapBody += 	'<sfdc:ProspectInfo>';
		soapBody += 		generateGeneralDetailsSection();
		soapBody += 		generateAddressSection();
		soapBody += 		generateFirmExecutiveSection();
		soapBody += 		generateGroupAdminSection();
		soapBody += 		'<sfdc:LeadRepNumber>' + fieldVals.get('LeadRepNumber') + '</sfdc:LeadRepNumber>';
		soapBody += 		generateDBESection();
		soapBody += 		'<sfdc:OpportunityId>' + fieldVals.get('OpportunityId') + '</sfdc:OpportunityId>';
		soapBody += 		'<sfdc:AccountId>'  + fieldVals.get('AccountId') + '</sfdc:AccountId>';
		soapBody += 	'</sfdc:ProspectInfo>';
		soapBody += '</soapenv:Body>';
		return soapBody;
	}

	/**
	 * Generates the account and opportunity's general details section of the SOAP request
	 */
	private String generateGeneralDetailsSection() {
		String oppDetails = '<sfdc:ProspectName>' + fieldVals.get('ProspectName') + '</sfdc:ProspectName>';
		oppDetails += '<sfdc:SIC>' + fieldVals.get('SIC') + '</sfdc:SIC>';
		oppDetails += '<sfdc:MarketSeg>' + fieldVals.get('MarketSeg') + '</sfdc:MarketSeg>';
		
		// The Account's EIN is an optional field to send to Broker Express
		String ein = fieldVals.get('EIN');
		if ( ein != null ) {
			oppDetails += '<sfdc:EIN>' + ein + '</sfdc:EIN>';
		}

		oppDetails += '<sfdc:TotEmpSize>' + fieldVals.get('TotEmpSize') + '</sfdc:TotEmpSize>';
		// kg 9.3.15: Add effective date field for HIX-722 project
		oppDetails += '<sfdc:ProposedEffectiveDate>' + fieldVals.get('Effective_Date__c') + '</sfdc:ProposedEffectiveDate>';
		
		return oppDetails;		
	}

	/**
	 * Generates the account's billing addres section of the SOAP request
	 */
	private String generateAddressSection() {
		String address = '';
		address += '<sfdc:Address>';
		// Check if the account has an address line 1 (optional field)
		if ( fieldVals.get('Line1') != null ) {
			address += 	  '<sfdc:Line1>' + fieldVals.get('Line1') + '</sfdc:Line1>';
		}

		// Check if the account has an address line 2 (optional field)
		if ( fieldVals.get('Line2') != null ) {
			address +=    '<sfdc:Line2>' + fieldVals.get('Line2') + '</sfdc:Line2>';
		}

		// Check if the account has an address line 3 (optional field)
		if ( fieldVals.get('Line3') != null ) {
			address += 	  '<sfdc:Line3>' + fieldVals.get('Line3') + '</sfdc:Line3>';
		}

		// Check if the account's address contains a city (optional field)
		if ( fieldVals.get('City') != null ) {
			address +=    '<sfdc:City>' + fieldVals.get('City') + '</sfdc:City>';
		}

		// Check if the account's address contains a county (optional field)
		if ( fieldVals.get('County') != null ) {
			address +=    '<sfdc:County>' + fieldVals.get('County') + '</sfdc:County>';
		}

		address +=    '<sfdc:State>' + fieldVals.get('State') + '</sfdc:State>';
		address +=    '<sfdc:ZipCode>';
		address += 		  '<sfdc:Zip>' + fieldVals.get('Zip') + '</sfdc:Zip>';

		// Check if the account's address contains a zip code extension
		if ( fieldVals.get('AddOn') != null ) {
			address +=    	  '<sfdc:AddOn>' + fieldVals.get('AddOn') + '</sfdc:AddOn>';
		}
		address +=    '</sfdc:ZipCode>';
		address += '</sfdc:Address>';
		return address;
	}

	/**
	 * Generates the account's firm executive contact's SOAP request section
	 */
	private String generateFirmExecutiveSection() {		
		String firstName = fieldVals.get('firmExecFirstName');
		String lastName = fieldVals.get('firmExecLastName');
		String email = fieldVals.get('firmExecEmail');
		String phone = fieldVals.get('firmExecPhone');

		// Check if the contact exists, the email field is the only required address
		boolean contactExists = email != null;

		String firmExec = '';
		// Do not create this section if a firm executive contact was not found
		if ( contactExists ) {
			firmExec += '<sfdc:FirmExecutive>';
			if ( firstName != null ) {
				firmExec += 	'<sfdc:FirstName>' + firstName + '</sfdc:FirstName>';
			}
			if ( lastName != null ) {
				firmExec += 	'<sfdc:LastName>' + lastName + '</sfdc:LastName>';
			}
				// if a contact exists, an email must be availalble
				firmExec += 	'<sfdc:Email>' + email + '</sfdc:Email>';
			if ( phone != null ) {
				firmExec += 	'<sfdc:Phone>' + phone + '</sfdc:Phone>';
			}
			firmExec += '</sfdc:FirmExecutive>';
		}
		return firmExec;
	}

	/**
	 * Generates the account's group admin contact's SOAP request section
	 */
	private String generateGroupAdminSection() {
		String firstName = fieldVals.get('groupAdminFirstName');
		String lastName = fieldVals.get('groupAdminLastName');
		String email = fieldVals.get('groupAdminEmail');
		String phone = fieldVals.get('groupAdminPhone');

		// Check if the contact exists, the email field is the only required address
		boolean contactExists = email != null;

		String groupAdmin = '';
		// Do not create this section if a group admin contact was not found
		if ( contactExists ) {
			groupAdmin += '<sfdc:GroupAdmin>';
			if ( firstName != null ) {
				groupAdmin += 	'<sfdc:FirstName>' + firstName + '</sfdc:FirstName>';
			}
			if ( lastName != null ) {
				groupAdmin += 	'<sfdc:LastName>' + lastName + '</sfdc:LastName>';
			}
			// If a contact exists, an email address must be present
			groupAdmin += 	'<sfdc:Email>' + email + '</sfdc:Email>';
			if ( phone != null ) {
				groupAdmin += 	'<sfdc:Phone>' + phone + '</sfdc:Phone>';
			}
			groupAdmin += '</sfdc:GroupAdmin>';
		}
		return groupAdmin;
	}

	/**
	 * Generates the account's DBE SOAP request section
	 */
	private String generateDBESection() {
		String dbe = '';
		dbe += '<sfdc:DBE>';
		dbe += 	   '<sfdc:DBEorWHInd>' + fieldVals.get('DBEorWHInd') + '</sfdc:DBEorWHInd>';
		dbe += 	   '<sfdc:DBEorWHName>' + fieldVals.get('DBEorWHName') + '</sfdc:DBEorWHName>';
		dbe += '</sfdc:DBE>';
		return dbe;
	}

	/**
	 * Simulate the creation of a submit to broker express success response
	 */
	private String createSuccessResponse(String prospectId) {
		String xml = 
			//'<?xml version="1.0" encoding="UTF-8"?>' +
			'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
				'<SOAP-ENV:Body>' +
					'<ns0:GSAServiceResponse xmlns:ns0="http://www.carefirst.com/schemas/LoadGSA/Response.xsd">' +
						'<ns0:ProspectId>' + prospectId + '</ns0:ProspectId>' +
						'<ns0:StatusCode>1</ns0:StatusCode>' +
						'<ns0:StatusDesc>Prospect Created Sucessfully with the status New</ns0:StatusDesc>' +
					'</ns0:GSAServiceResponse>' +
				'</SOAP-ENV:Body>' +
			'</SOAP-ENV:Envelope>';
		return xml;
	}

}