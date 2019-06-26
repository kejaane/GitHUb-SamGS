/********************************************************************************
 ********************************************************************************    
 *  Class            : BrokerExpressValidation
 *  Author           : Acumen Solutions: Alejandro Olivas
 *  Version History  : 1.0
 *  Creation         : 06/20/11
 *  Description      : 
 ********************************************************************************
 ********************************************************************************
 *---------------------------------------------------------------------------------------------
 *                      ----===[ HISTORY ]===---
 * Date        Developer        Description
 *---------------------------------------------------------------------------------------------
 * 11/30/2012 Varun Nagarajan   Modified code where Business__c and Market_Segment__c 
 *                              fields have been replaced with Business_Type__c, Division__c 
 *                              and Market_Segment_New__c to match today's world requirements 
 *                              at CareFirst. 
 * 12/22/2012 Varun Nagarajan   Underwriting Entity field has been included in the SOQL query
 *                              and the If statement condition for submission of an opportunity 
 *                              record to Broker express has been updated accordingly. 
 * 11/21/2014 Ken Gill          Added additional validation to reject proposed opportunities older than 180 days
 *                              being submitted to Broker Express
 * 08/25/2015 Ken Gill          Updated validateGeneralDetails() to support following additional market segments that should be allowed to be sent
 *                              to Broker Express as part of HIX-722 project requirements:  
 *                              51-100 ACA, 101-199 New Mid-Market or Hybrid LG GF & SG ACA
 *                              Also updated the validation error message to include Market Segment in else {} clause and actual received values to aid 
 *                              troubleshooting when send requests to Broker Express fail due to validation errors.
 * 09/03/2015 Ken Gill          Modified method validateGeneralDetailsFields() to add validation for opportunity
 *                              Effective date (field: Effective_Date__c). 
 *								Updated constructor SOQL to retrieve Effective_Date__c field value
 *                              Related changes in BrokerExpressRequestGenerator method generateGeneralDetailsSection()
 *                              where the new XML element <sfdc:ProposedEffectiveDate> for effective date is added to the request XML that goes to 
 *                              BrokerExpress
 * 11/23/15   Ken Gill          Reverted the changes made for HIX validations for market segements retaining only the original 51-199 market segment. Modified 
                                method validateGeneralDetailsFields. Removed effective date & market segment based checks for new segments.
 * 
 *
 ***********************************************************************************************
 */
 
public with sharing class BrokerExpressValidation {

    public Opportunity opp { get;set; }
    public String transactionId { get;set; }

    public boolean validRequest { get;set; }
    public boolean fieldsMissing { get;set; }
    public boolean validationErrors { get;set; }
    public boolean oppStageError { get;set; }
    // KG - Validation: proposed opportunity more than 180 days old
    public boolean oppProposedMoreThan180DaysAgoError { get; set; }
    public boolean duplicateError { get;set; }
    public boolean prospectIdFromLookup { get;set; }

    public String missingFieldsMessage { get;set; }
    public String validationErrorMessage { get;set; }
    public String oppStageErrorMessage { get;set; }
    // KG - Validation: proposed opportunity more than 180 days old
    public String oppProposedMoreThan180DaysAgoErrorMessage { get; set; }
    public String duplicateErrorMessage { get;set; }

    public Map<String, String> brokerExpressFieldVals { get;set; }

//VN - 12/22/2012 
    public BrokerExpressValidation(Id oppId, String transactionId) {
    	// KG 11/20/14 : Added 'Proposal_Sent__c' to the SOQL retrieve fields to support the validation for 180 day old Proposed opportunity
    	// KG 9/3/15: Added Effective_Date__c to SOQL to support HIX-722 addition of Effective date field to message sent to BE
        opp = 
            [SELECT Id, AccountId, Account.Name, Account.NumberOfEmployees,
             Account.Sic, Account.BillingState, Account.BillingPostalCode,
             Account.EIN__c, Account.BillingStreet, Account.BillingCity, 
             Account.Billing_County_Code__c, Market_Segment_New__c, Division__c, 
             StageName, Proposal_Sent__c, Underwriting_Entity__c, Business_Type__c, 
             FullServiceProducer__c, GeneralProducer__c, Lead_Rep_Number_User__c, 
             BE_Prospect_ID__c, Effective_Date__c
             FROM Opportunity WHERE ID =: oppId];

        validRequest = true;
        fieldsMissing = false;
        validationErrors = false;
        oppStageError = false;
        oppProposedMoreThan180DaysAgoError = false; // KG - Validation: proposed opp. more than 180 day old
        duplicateError = false;
        prospectIdFromLookup = false;

        missingFieldsMessage = '';
        validationErrorMessage = '';
        oppStageErrorMessage = '';
        oppProposedMoreThan180DaysAgoErrorMessage = ''; // KG - Validation: proposed opp. more than 180 day old
        brokerExpressFieldVals = new Map<String, String>();

        this.transactionId = transactionId;
    }

    /**
     * Validation entry point, makes a call to all the data validation functions
     */
    public void validateData() {
        String oppStage = opp.StageName;
        
        // Only allow users to submit proposed opportunities
        if ( oppStage.equalsIgnoreCase('Proposal') ) {
        	// KG : Do not send opportunties proposed more than 180 days ago
        	Date proposedDate = opp.Proposal_Sent__c;
        	if( proposedDate != Null && proposedDate.daysBetween(Date.Today()) > 180) {
           	 validRequest = false;
           	 oppProposedMoreThan180DaysAgoError = true;
           	 oppProposedMoreThan180DaysAgoErrorMessage = 
           	       'You cannot submit a opportunity which was proposed more than 180 days ago </br>';       		
        	}
            // Do not submit to BE if there is a BE prospect ID already present
            else if ( opp.BE_Prospect_ID__c == null ) {
            	
                // Check if the opportunity was previously submitted, but failed
                // to write the prospect ID into salesforce i.e. legacy data
                if ( !wasPreviouslySubmitted() ) {
                    validateSalesforceIdFields();
                    validateLeadRepNumberField();
                    validateGeneralDetailsFields();
                    validateAddressFields();
                    validateFirmExecutiveFields();
                    validateGroupAdminFields();
                    validateDBEFields();
                } else {
                    // set flag to notify system that this was previously submitted
                    // and give the illusion of this being re-submitted to BE
                    prospectIdFromLookup = true;
                }
            } else {
                validRequest = false;
                duplicateError = true;
                duplicateErrorMessage = 'This opportunity has already been submitted ' +
                    'to Broker Express and contains a BE prospect ID [<strong>' + 
                    opp.BE_Prospect_ID__c + '</strong>].</br> ';
            }
        } else {
            validRequest = false;
            oppStageError = true;
            oppStageErrorMessage = 'You cannot submit an opportunity whose ' +
                'stage is <strong>' + oppStage + '</strong>. Only opportunities ' +
                'whose stage is in <strong>Proposal</strong> can be ' +
                'submitted to Broker Express</br>';
        }
    }

    /**
     * Checks the BE Prospect ID look up table to see if the opportunity with
     * a null BE Prospect ID field was previously submitted to Broker Express.
     * This scenario would happen if validation rules prevent an opportunity
     * from being saved after BE has generated a BE Prospect ID, particularly
     * with legacy data.
     */
    private boolean wasPreviouslySubmitted() {
        boolean previouslySubmitted = false;
        try {
            List<BE_Prospect_Lookup__c> resultSet = 
                [SELECT Transaction_Id__c, Opportunity_ID__c, BE_Prospect_ID__c 
                 FROM BE_Prospect_Lookup__c
                 WHERE Opportunity_ID__c =: opp.Id];
            BE_Prospect_Lookup__c prospectIdLookup = resultSet.get(0);

            // Check the look up table to see if this opportunity is located
            if ( opp.BE_Prospect_ID__c == null && 
                    prospectIdLookup.BE_Prospect_ID__c != null ) {
                opp.BE_Prospect_ID__c = prospectIdLookup.BE_Prospect_ID__c;
                database.update(opp);
                previouslySubmitted = true;
            }
        } catch(ListException l) {
            // The opportunity was not found in the lookup table. This means it is 
            // the first time the "Submit To BE" button is pressed for this 
            // opportunity, ignore and proceed as normal
        }
        return previouslySubmitted;
    }

    /** 
     * Validates that the incoming opportunity contains a valid salesforce ID
     * as well as a valid account ID. Both these fields are MANDATORY.
     * 
     * Corresponding Request Fields:
     * <sfdc:OpportunityId>006XXXXXXXXXXXX</sfdc:OpportunityId>
     * <sfdc:AccountId>001XXXXXXXXXXXX</sfdc:AccountId>  
     */
    private boolean validateSalesforceIdFields() {
        // Check the opportunity ID is not null
        if ( opp.Id != null ) {
            brokerExpressFieldVals.put('OpportunityId', opp.Id);
        }

        // Check the opportunity's associated account is not null
        if ( opp.AccountId != null ) {
            brokerExpressFieldVals.put('AccountId', opp.AccountId); // this is the main object, passing null? verify this?
        } else {
            validRequest = false;
            fieldsMissing = true;
            addMissingField('Account Id', opp.AccountId); // this is the main object, passing null? verify this?            
        }

        return validRequest;
    }

    /**
     * Validates that the opportunity contains a lead rep number. This field is MANDATORY.
     *
     * Corresponding Request Fields:
     * <sfdc:LeadRepNumber>XXXX</sfdc:LeadRepNumber>
     */
    private boolean validateLeadRepNumberField() {
        String leadRepNumber = opp.Lead_Rep_Number_User__c;
        if ( leadRepNumber != null ) {
            brokerExpressFieldVals.put('LeadRepNumber', leadRepNumber);
        } else {
            validRequest = false;
            validationErrors = true;
            String errorMsg = 'The opportunity does not have corresponding ' +
                    'Lead Rep Number.';
            addFieldValidationError(opp.Id, 'Lead Rep Number', errorMsg);
        }
        return validRequest;
    }

    /**
     * Validates a few generic fields on the opportunity itself and it's associated
     * account. All fields here are MANDATORY with the exception of the account's EIN
     * number field, this one is OPTIONAL.
     *
     * Corresponding Request Fields:
     * <sfdc:ProspectName>Account Name Goes Here</sfdc:ProspectName>
     * <sfdc:SIC>XXXX</sfdc:SIC>
     * <sfdc:MarketSeg>51-199</sfdc:MarketSeg>
     * <sfdc:EIN>XXXXXXXXX</sfdc:EIN> (OPTIONAL)
     * <sfdc:TotEmpSize>XXX</sfdc:TotEmpSize>
     */
    private boolean validateGeneralDetailsFields() {
        
        // ******** Check the mandatory fields ********
        
        // Check the opportunity's associated account's name
        if ( opp.Account.Name != null ) {
            // The account name must be less than 50 characters
            if ( opp.Account.Name.length() <= 50 ) {
                String acctName = opp.Account.Name;
                acctName = acctName.replaceAll('&', '&amp;');
                brokerExpressFieldVals.put('ProspectName', acctName);
            } else {
                validationErrors = true;
                validRequest = false;
                String errorMsg = 'The account name cannot be greater than ' +
                    '<strong>50</strong> characters';
                addFieldValidationError(opp.AccountId, 'Account Name', errorMsg);
            }
        } else {
            validRequest = false;
            fieldsMissing = true;
            addMissingField('Prospect Name', opp.AccountId);
        }

        // Check the account's SIC number field     
        if ( opp.Account.Sic != null ) { 
            // SFDC will send the 1st 4 digits of a SIC code
            String sic = String.valueOf(opp.Account.Sic);
            brokerExpressFieldVals.put('SIC', sic.substring(0,4));
        } else {
            validRequest = false;
            fieldsMissing = true;
            addMissingField('SIC Code', opp.AccountId);
        }
        
       // Check the opportunity's market segment field
        if ( opp.Market_Segment_New__c != null ) {
            // SFDC will only submit opportunities to Broker Express if 
            // Market Segment is one of '51-199' or 101-199 New Mid-Market
            // AND Division = '51-199 New Business', 
            // AND Business Type = 'NEW BUSINESS SALES' 
            // AND Underwriting Entity = 'DC' or 'MD'.

            // KGill 8/25/15: Added additional market segments that should be allowed to be sent to broker express: 51-199, 101-199 New Mid-Market


            if ( 
				 opp.Market_Segment_New__c.equalsIgnoreCase('51-199')  			
                && opp.Business_Type__c.equalsIgnoreCase('New')
                && opp.Division__c =='51-199 New Business' 
                && (opp.Underwriting_Entity__c.contains('DC')|| opp.Underwriting_Entity__c.contains('MD')))   {

                  brokerExpressFieldVals.put('MarketSeg', opp.Market_Segment_New__c);
            } else {        
                validationErrors = true;
                validRequest = false;
                String receivedValues = ' opp.Market_Segment_new__c = ' + (String.isBlank(opp.Market_Segment_New__c) ? 'null' : opp.Market_Segment_New__c) +
 			    						' opp.Business_Type__c = ' + (String.isBlank(opp.Business_Type__c) ? 'null' : opp.Business_Type__c )+
 			     						' opp.Division__c = ' + ( String.isBlank(opp.Division__c) ? 'null' : opp.Division__c) +
 			     						' opp.Underwriting_Entity__c = ' + (String.isBlank(opp.Underwriting_Entity__c) ? 'null' : opp.Underwriting_Entity__c) ;
                
                String errorMsg = 'Only Opportunities with ' +
                    '<strong>Market Segment = 51-199 </strong>' +
                    'and <strong>DIVISION = 51-199 NEW BUSINESS</strong>' + 
                    ' and <strong>BUSINESS TYPE = New </strong>' + 
                    ' and <strong>UNDERWRITING ENTITY = MD or DC</strong> can be submitted to BE.' +
                    ' Actual received values = ' + receivedValues;
                    
                addFieldValidationError(opp.Id, 'Division/Business Type/Underwriting Entity', errorMsg);
            }
        } else {
            validRequest = false;
            fieldsMissing = true;
            addMissingField('Market Segment', opp.AccountId);
        }

        // Check the account's number of employees field
        if ( opp.Account.NumberOfEmployees != null ) {
            Integer numEmp = opp.Account.NumberOfEmployees;
            // The number of employees on the account must be greater than 50
            if ( numEmp > 50 ) {
                String numEmpStr = '';
                // When greater than 9999, limit the value to this 
                if ( numEmp > 9999 ) {
                    numEmpStr = '9999';
                } else {
                    numEmpStr = String.valueOf(numEmp);
                }
                brokerExpressFieldVals.put('TotEmpSize', numEmpStr);
            } else {
                validationErrors = true;
                validRequest = false;
                String errorMsg = 'The number of employees on the opportunity\'s associated ' +
                    'account must be greater than <strong>50</strong>';
                addFieldValidationError(opp.AccountId, 'Employees', errorMsg);
            }
        } else {
            validRequest = false;
            fieldsMissing = true;
            addMissingField('Employees', opp.AccountId);
        }

		// Check Effective_Date__c field
		// KG 9.5.15 - for HIX722 project, add effective date to fields sent to BE. 
        if ( opp.Effective_Date__c != null ) {
        	
        	Date referenceDate = Date.newInstance(2016,1,1);
        	opp.Market_Segment_New__c = opp.Market_Segment_New__c == null ? '' : opp.Market_Segment_New__c; // prevent null exception
        	 

            try {
            Datetime dt = Datetime.newInstance( opp.Effective_Date__c.year(), opp.Effective_Date__c.month(), opp.Effective_Date__c.day());
            String effectiveDate = dt.format('yyyy-MM-dd');  // Note: use 'MM' not 'mm' or month will be 0 if you use 'mm'
            brokerExpressFieldVals.put('Effective_Date__c', effectiveDate);
            } catch( Exception e) {	
                validationErrors = true;
                validRequest = false;
                String errorMsg = 'Invalid opportunity Effective date <strong>' + opp.Effective_Date__c + '</strong>';
                addFieldValidationError(opp.Id, 'Effective Date', errorMsg);
            }
        } else {
            validRequest = false;
            fieldsMissing = true;
            addMissingField('Effective Date', opp.Id);
        }

        // ******** Check the optional fields ********

        // Check the account's EIN number field
        if ( opp.Account.EIN__c != null ) {
            try {
                // Remove dash characters and convert string to integer to verify
                // there aren't any other non-numeric characters
                String einStr = removeNonNumericChars(opp.Account.EIN__c);
//BEGIN CHANGE TPB 08/15/12               
                //Integer ein = Integer.valueOf(einStr);
//END CHANGE TPB 08/15/12
                // Verify that the field has no more than 9 digits
                if ( einStr.length() < 10 ) {
                    brokerExpressFieldVals.put('EIN', einStr);
                } else {
                    validationErrors = true;
                    validRequest = false;
                    String errorMsg = 'The account\'s EIN field cannot be more than ' +
                        '<strong>9</strong> digits';
                    addFieldValidationError(opp.AccountId, 'EIN #', errorMsg);
                }
            } catch (Exception e) {
                // Couldn't convert, the field value is not a number
                validationErrors = true;
                validRequest = false;
                String errorMsg = 'The account\'s EIN field must be a number';
                addFieldValidationError(opp.AccountId, 'EIN #', errorMsg);
            }
        }

        return validRequest;
    }

    /**
     * Validates the address fields on the opportunity's associated account. All 
     * address fields on the account are optional with the exception of the state
     * and 5 digit zip code which are MANDATORY.
     *
     * Corresponding Request Fields:
     * <sfdc:Line1>4700, Creek Side Cir</sfdc:Line1>
     * <sfdc:Line2>Block C</sfdc:Line2>
     * <sfdc:Line3>Suite 201</sfdc:Line3>
     * <sfdc:City>Baltimore</sfdc:City>
     * <sfdc:County>BA</sfdc:County>
     * <sfdc:State>MD</sfdc:State> (MANDATORY)
     * <sfdc:ZipCode>
     *      <sfdc:Zip>XXXXX</sfdc:Zip> (MANDATORY)
     *      <sfdc:AddOn>XXXX</sfdc:AddOn>
     * </sfdc:ZipCode>   
     */
    private boolean validateAddressFields() {

        // ******** Check the optional fields ********
        
        // Check the account's billing street for line 1, line 2 and line 3
        if ( opp.Account.BillingStreet != null ) {
            String originalAddress = opp.Account.BillingStreet;
            // Remove the carriage returns before separating the address
            originalAddress = originalAddress.replaceAll('[\n\r]', '');
            
            // Get the first 30 characters for Line 1
            if ( originalAddress.length() > 30 ) {
                String address1 = originalAddress.substring(0, 29);
                String address2 = originalAddress.substring(30, originalAddress.length());

                // Get the next 30 character for Line 2
                if ( address2.length() > 30 ) {
                    address2 = originalAddress.substring(30, 59);
                    String address3 = originalAddress.substring(60, originalAddress.length());

                    // Get the remaining characters for Line 3
                    brokerExpressFieldVals.put('Line3', address3);
                }
                brokerExpressFieldVals.put('Line1', address1);
                brokerExpressFieldVals.put('Line2', address2);
            } else {
                // Address is less than 30 characters
                brokerExpressFieldVals.put('Line1', originalAddress);
            }
        }

        // Check the account's billing city
        if ( opp.Account.BillingCity != null ) {
            if ( opp.Account.BillingCity.length() < 31 ) {
                brokerExpressFieldVals.put('City', opp.Account.BillingCity);
            } else {
                // The city name cannot be longer than 30 characters in length
                validationErrors = true;
                validRequest = false;
                String errorMsg = 'The account\'s city name cannot be longer than ' +
                    '<strong>30</strong> characters in length';
                addFieldValidationError(opp.AccountId, 'Billing City', errorMsg);
            }
        }

        // Check the account's billing county
        if ( opp.Account.Billing_County_Code__c != null ) {
            // Send only the the 2 digit county code, so get the 1st 2 letters
            String countyCode = opp.Account.Billing_County_Code__c;
            countyCode = countyCode.substring(0,2);
            brokerExpressFieldVals.put('County', countyCode);
        }


        // ******** Check the mandatory fields ********

        // Check the account's billing state
        if ( opp.Account.BillingState != null ) {
            String state = opp.Account.BillingState;
            // Verify that the state is in a 2 letter abbreviation
            if ( state.length() == 2 ) { 
                brokerExpressFieldVals.put('State', state);
            } else {
                validationErrors = true;
                validRequest = false;
                String errorMsg = 'The account\'s state is not in the correct ' +
                    '<strong>2</strong> letter abbreviation';
                addFieldValidationError(opp.AccountId, 'State', errorMsg);              
            }
        } else {
            validRequest = false;
            fieldsMissing = true;
            addMissingField('State', opp.AccountId);
        }

        // Check the account's billing zip code
        if ( opp.Account.BillingPostalCode != null ) {
            try {
                String zipCodeStr = opp.Account.BillingPostalCode;

                // Remove hyphen if zip code entered as XXXXX-XXXX
                zipCodeStr = zipCodeStr.replaceAll('-', '');
                Integer zipCode = Integer.valueOf(zipCodeStr);

                // Verify that the user typed in a 5 or 9 digit zip code
                if ( zipCodeStr.length() == 5 ) {
                    brokerExpressFieldVals.put('Zip', zipCodeStr);
                } else if ( zipCodeStr.length() == 9 ) {
                    // Get the first 5 digits as the first part of the zip code
                    brokerExpressFieldVals.put('Zip', zipCodeStr.substring(0,5));
                    // Get the remaining 4 digits as the zip code add-on
                    brokerExpressFieldVals.put('AddOn', zipCodeStr.substring(5,9));
                } else {
                    validationErrors = true;
                    validRequest = false;
                    String errorMsg = 'The account\'s postal code must be a <strong>5</strong> ' +
                        'or <strong>9</strong> digit number';
                    addFieldValidationError(opp.AccountId, 'Billing Zip/Postal Code', errorMsg);
                }
            } catch (Exception e) {
                validationErrors = true;
                validRequest = false;
                String errorMsg = 'The account\'s postal code must be a number';
                addFieldValidationError(opp.AccountId, 'Billing Zip/Postal Code', errorMsg);
            }
        } else {
            validRequest = false;
            fieldsMissing = true;
            addMissingField('Billing Zip/Postal Code', opp.AccountId);
        }
        return validRequest;
    }

    /**
     * Gets the latest created contact whose role is "Firm Executive" and
     * validates their information required to send to Broker Express
     *
     * <sfdc:FirmExecutive>
     *      <sfdc:FirstName>Mike</sfdc:FirstName>
     *      <sfdc:LastName>Smith</sfdc:LastName>
     *      <sfdc:Email>Mike@abc.com</sfdc:Email>
     *      <sfdc:Phone>1234567890</sfdc:Phone>
     * </sfdc:FirmExecutive>
     */
    private boolean validateFirmExecutiveFields() {
        try {
            OpportunityContactRole contact = 
                [SELECT Role, ContactId, Contact.FirstName, Contact.LastName,
                 Contact.Email, Contact.Phone
                 FROM OpportunityContactRole 
                 WHERE OpportunityId =: opp.Id
                 AND Role =: 'Firm Executive' 
                 ORDER BY Contact.CreatedDate DESC LIMIT 1];
            contactRoleFieldValidation(contact, 'firmExec');
        } catch (Exception e) {
            // Contact doesn't exist
        }
        return validRequest;
    }

    /**
     * Gets the latest created contact whose role is "Group Administrator" and
     * validates their information required to send to Broker Express
     *
     * <sfdc:GroupAdmin>
     *      <sfdc:FirstName>Mike</sfdc:FirstName>
     *      <sfdc:LastName>Smith</sfdc:LastName>
     *      <sfdc:Email>Mike@abc.com</sfdc:Email>
     *      <sfdc:Phone>1234567890</sfdc:Phone>
     * </sfdc:GroupAdmin>
     */
    private boolean validateGroupAdminFields() {
        try {
            OpportunityContactRole contact = 
                [SELECT Role, ContactId, Contact.FirstName, Contact.LastName,
                 Contact.Email, Contact.Phone
                 FROM OpportunityContactRole 
                 WHERE OpportunityId =: opp.Id
                 AND Role =: 'Group Administrator' 
                 ORDER BY Contact.CreatedDate DESC LIMIT 1];
            contactRoleFieldValidation(contact, 'groupAdmin');
        } catch (Exception e) {
            // Contact doesn't exist
        }
        return validRequest;
    }

    /**
     * Validates that the opportunity has either the full service producer field
     * or general producer field populated. Only one field can be populated and
     * with it the DBEorWHN fields are derived.
     * 
     * <sfdc:DBE>
     *      <sfdc:DBEorWHInd>2</sfdc:DBEorWHInd>
     *      <sfdc:DBEorWHName>BenefitMall</sfdc:DBEorWHName>
     * </sfdc:DBE>
     */
    private boolean validateDBEFields() {
        if ( opp.FullServiceProducer__c != null && opp.GeneralProducer__c != null ) {
            validationErrors = true;
            validRequest = false;
            String errorMsg = 'The opportunity requires a value in either ' +
                'the <strong>Full Service Producer</strong> field or the ' +
                '<strong>General Producer</strong> field, they cannot both contain values';
            addFieldValidationError(
                opp.Id, 'Full Service Producer or General Producer', errorMsg);
        } else {
            // There's a validation rule in place that checks that one of these two fields
            // is always populated, so we uncomment the third else.
            if ( opp.FullServiceProducer__c != null ) {
                validRequest = getDBEOrWHNName(opp.FullServiceProducer__c);
                String ind = '';
                // Determine the DBEorWHN indicator value
                if ( opp.FullServiceProducer__c.equalsIgnoreCase('Direct') ) {
                    ind = '0';
                } else {
                    ind = '1';
                }
                brokerExpressFieldVals.put('DBEorWHInd', ind);
            } else if ( opp.GeneralProducer__c != null ) {
                validRequest = getDBEOrWHNName(opp.GeneralProducer__c);
                String ind = '';
                // Determine the DBEorWHN indicator value
                if ( opp.GeneralProducer__c.equalsIgnoreCase('Direct') ) {
                    ind = '0';
                } else {
                    ind = '2';
                }
                brokerExpressFieldVals.put('DBEorWHInd', ind);
            }
        }
        return validRequest;
    }

    /**
     * Gets the proper DBEOrWHInd Broker Express requires from the FSP/GP lookup 
     * table, if a value is not found in the look up table, an error will be 
     * displayed to the user prompting them to notify a system administrator.  
     */
    private boolean getDBEOrWHNName(String fspOrGp) {
        try {
            List<FSP_GP_Lookup__c> resultSet = 
                [SELECT Tax_Id__c, OwnerId, Name, FSP_GP__c, DBE_WH__c 
                 FROM FSP_GP_Lookup__c
                 WHERE FSP_GP__c =: fspOrGp];
            String dbeOrWhnName = resultSet.get(0).DBE_WH__c;
            dbeOrWhnName = dbeOrWhnName.replaceAll('&', '&amp;');
            // Pass the value from the lookup table to Broker Express
            brokerExpressFieldVals.put('DBEorWHName', dbeOrWhnName);
        } catch(ListException l) {
            validationErrors = true;
            validRequest = false;
            validationErrorMessage = 
                '<h2><font color="red">Full Service Producer or General Producer' + 
                '</font></h2></a> - <font color="Black">The value, <strong> ' + 
                fspOrGp + '</strong>, is not found in the FSP/GP lookup table. ' +
                'Please contact your system administrator.</font><br/>';
        } catch(Exception e) {
            // Safety: to catch all other types of exceptions
        }
        return validRequest;
    }

    /**
     * Validates a contact's first name, last, email and phone number
     */
    private void contactRoleFieldValidation(OpportunityContactRole contact, String role) {
        // Check that the contact has a first name less than 20 characters
        if ( contact.Contact.FirstName != null ) {
            // Contact first name must be less than 20 characters
            if ( contact.Contact.FirstName.length() < 20 ) {
                brokerExpressFieldVals.put(role+'FirstName', contact.Contact.FirstName);
            } else {
                validationErrors = true;
                validRequest = false;
                String errorMsg = 'The contact\'s first name must be less than ' +
                    '<strong>20</strong> characters';
                addFieldValidationError(contact.Contact.Id, 'First Name', errorMsg);
            }
        }

        // Check that the contact has a last name less than 29 characters
        if ( contact.Contact.LastName != null ) {
            // Contact last name must be less than 29 characters
            if ( contact.Contact.LastName.length() < 29 ) {
                brokerExpressFieldVals.put(role+'LastName', contact.Contact.LastName);
            } else {
                validationErrors = true;
                validRequest = false;
                String errorMsg = 'The contact\'s last name must be less than ' +
                    '<strong>29</strong> characters';
                addFieldValidationError(contact.Contact.Id, 'Last Name', errorMsg);
            }
        }

        // Check that the contact's has a valid email less than 70 characters
        if ( contact.Contact.Email != null ) {
            // This is an email field on SFDC and it's impossible to add a
            // non-email value to it, therefore we only make sure it is 70 chars long
            Integer emailLength = String.valueOf(contact.Contact.Email).length();
            if ( emailLength < 71 ) {
                brokerExpressFieldVals.put(role+'Email', contact.Contact.Email);
            } else {
                validationErrors = true;
                validRequest = false;
                String errorMsg = 'The contact\'s email must be less than or ' +
                    'equal to <strong>70</strong> characters long';
                addFieldValidationError(contact.Contact.Id, 'Email', errorMsg);
            }
        }
        
        // Check that the contact's phone number is a numeric 10 digit value
        if ( contact.Contact.Phone != null ) {
            String phone = unformatPhoneNumber(contact.Contact.Phone);
            // Truncate the phone number when it includes an extension 
            if ( phone.length() > 10 ) {
                phone = phone.substring(0, 10);
            }

            // The phone number cannot be less than 10 characters   
            if ( phone.length() == 10 ) {
                brokerExpressFieldVals.put(role+'Phone', phone);
            } else {
                validationErrors = true;
                validRequest = false;
                String errorMsg = 'The contact\'s phone number must be ' +
                    '<strong>10</strong> digits long';
                addFieldValidationError(contact.Contact.Id, 'Phone', errorMsg);             
            }
        }
    }

    /**
     * Logs an error message to display to the user whenever a field validation
     * error is encountered
     */
    private void addFieldValidationError(Id missingFieldObjId, String field, String errorMsg) {
        validationErrorMessage += '<a href="/'+ missingFieldObjId +'" target="_blank">' +
            '<h2><font color="red">' + field + '</font></h2></a> - ' +
            '<font color="Black">' + errorMsg + '</font><br/>';
    }

    /**
     * Logs an error message to display to the user whenever an object is missing
     * a field required by Broker Express
     */
    private void addMissingField(String field, Id missingFieldObjId) {
          missingFieldsMessage += '<a href="/'+ missingFieldObjId +'" target="_blank">' +
            '<h2><font color="red">' + field + '</font></h2></a><br/>';
    }

    /**
     * Removes all non-numeric characters in the EIN
     */
    private String removeNonNumericChars(String ein) {
        String numericEin = '';
//BEGIN CHANGE TPB 08/15/12
        //numericEin = ein.replaceAll('[-]', '');
        numericEin = ein.replaceAll('\\D', '');
//END CHANGE TPB 08/15/12
        return numericEin;
    }

    /**
     * Unformats a telephone number and returns only the numbers
     */
    public static String unformatPhoneNumber(String formattedNumber) {
        String unFormattedNumber = '';
        formattedNumber = formattedNumber.replaceAll('[(]', '');
        formattedNumber = formattedNumber.replaceAll('[)]', '');
        formattedNumber = formattedNumber.replaceAll('[ ]', '');
        formattedNumber = formattedNumber.replaceAll('[-]', '');
        unFormattedNumber = formattedNumber.replaceAll('[.]', '');
        return unFormattedNumber;
    }


}