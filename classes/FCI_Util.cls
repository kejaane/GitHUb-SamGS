/*=========================================================================================
 * Date		: 11/6/15
 * Developer	: Ken Gill
 * Purpose   	:  
 * 
 *               Utility methods used by various classes of the FCI_*Integration* package.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/6/15   |  KG    |	Initial Version      
 * 8/22/16   |  KG    | Modify CaseDetailsQuerySOQL to retrieve RecordType.Name instead of Case_Type__c 
 *           |        | which is deprecated with the introduction of RecordTypes for each SBU case type 
 *           |        | as part of Member Case/Communities implementation (RTs Introduced by: A.Ojha)                                  
 *   	     |        | Also modify CustomerIndicatorMap to include values for RecordTypeNames. Kept old 
 *   	     |        | map values for backward compatibility and marked deprecated in map declaration.
 * 8/28/16   |  KG    | Added fields M_Id__c, E_Product_Category__c, GroupContrivedKey__c, SubscriberContrivedKey__c, MemberContrivedKey__c
 *   	     |        | to CaseDetailsSOQL query string to retrieve member related fields as part of Member Cases integration implementation
 *   	     |        | 
 *=========================================================================================
 */
public with sharing class FCI_Util {

		// Facets task status codes.
	public static String FacetsStatus_CLOSED = 'CL';
	public static String FacetsStatus_OPEN = 'OP';

	public static String mapCaseStatusToProofOfClosureCode( String caseStatus) {
	   String facetsMappedStatus = FCI_Util.FacetsStatus_CLOSED;	// default
	   if( caseStatus.startsWithIgnoreCase('Closed')) {
		facetsMappedStatus = FCI_Util.FacetsStatus_CLOSED;
	   }
	   else {
	   	facetsMappedStatus = FCI_Util.FacetsStatus_OPEN;
	   }	   
	   // Proof of Closure Codes:  POC1 - Open, POC2 - Closed
	   String proofOfClosureCode =  facetsMappedStatus == FCI_Util.FacetsStatus_CLOSED ? 'POC2' : 'POC1';
	   return proofOfClosureCode;	   		
	}

	// Map of case recordtype name to Facets customer indicator.
   public static Map<String,String> customerIndicatorMap = new Map<String,String> {
   		'Member' => 'M',   		// Deprecated 8/22/16 w/introduction of RecordTypes for different case types instead of using Case_Type__c custom field
   		'Non-Member' => 'N',	// Deprecated 8/22/16 ...
   		'Group' => 'G',			// Deprecated 8/22/16 ...
   		
   		'Member Case' => 'M',
   		'Non-Member Case' => 'N',
   		'Group Case' => 'G'   		   		   		   		
   	};
   	
   public static String mapCaseTypeToFacetsCustomerIndicator( String caseType ) {
   	if( String.isBlank(caseType) || String.isBlank( customerIndicatorMap.get(caseType)) ) {
   	 String message = 'Invalid caseType received :' + caseType;
   	 System.debug(message);
   	 throw new FCI_FacetsService.FCI_Exception( message );
   	}  	
   	return customerIndicatorMap.get( caseType );
   }
   
   public static String mapContactTypeToFacetsCallerType( String contactType ) {
   	return get4LetterPrefixCode( contactType );
   }


    // Return the first 4 letters of a String. Used to extract codes from Subject/Category picklists which have the code in the first 4 letters e.g. 'MELG-Member Eligibility'
    public static String get4LetterPrefixCode(String s) { return s == null? null : s.subString(0,4); }

    // Date formatting utility methods to generate Facets API required Date string formats
    public static String getDateTimeAsMMDDYYYY(Datetime dt) { return  dt == null ? null  : dt.format('MM/dd/yyyy');  } 
	
	// Utility methods to compute changed fields on Case contact
	public static Map<String,String> getContactChangeFields(Contact newVersion, Contact oldVersion) {
		// detect if a contact has been replaced or modified. If the second argument is null, it means Contact was replaced 
		// else it means existing Contact was modified
		Map<String,String> updateFields = new Map<String,String>();
		if( oldVersion == null) {
			
			Contact c = [ select Id, Entity_ID__c, FirstName, LastName, Phone, Email, Fax, Salutation, MailingStreet, MailingCity, MailingState,
			                     MailingCountry, MailingPostalCode from Contact where Id = :newVersion.Id ];
			System.debug('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxBroker COntact entity id = ' + c.Entity_ID__c);                   
				// Caller Contact details
			// Case Contact Entity ID need not be sent. 7/28/16
			// updateFields.put('CSCI_BrokerID', String.isBlank(c.Entity_ID__c) ? ' ' : c.Entity_ID__c);
			
			updateFields.put('CSCI_contactFirstName', String.isBlank(c.FirstName) ? ' ' : c.FirstName);
			updateFields.put('CSCI_contactLastName', String.isBlank(c.LastName) ? ' ' : c.LastName);
			updateFields.put('CSCI_contactPhone', String.isBlank(c.Phone) ? ' ' : c.Phone);
			updateFields.put('CSCI_contactEmail', String.isBlank(c.Email) ? ' ' : c.Email);
			updateFields.put('CSCI_contactFax', String.isBlank(c.Fax) ? ' ' : c.Fax);
			updateFields.put('CSCI_contactSalutation', String.isBlank(c.Salutation) ? ' ' : c.Salutation);
			updateFields.put('CSCI_contactMailingStreet', String.isBlank(c.MailingStreet) ? ' ' : c.MailingStreet);
			updateFields.put('CSCI_contactMailingCity', String.isBlank(c.MailingCity) ? ' ' : c.MailingCity);
			updateFields.put('CSCI_contactMailingState', String.isBlank(c.MailingState) ? ' ' : c.MailingState);
			updateFields.put('CSCI_contactMailingCountry', String.isBlank(c.MailingCountry) ? ' ' : c.MailingCountry);
			updateFields.put('CSCI_contactMailingPostalCode', String.isBlank(c.MailingPostalCode) ? ' ' : c.MailingPostalCode);
			System.debug('contact changed updates' + String.valueOf(updateFields));
			return updateFields;
		}
		
		// If we got here, it means fields of existing contact were modified so new and old contact argument refers to same contact person
		
		// Case Contact Entity ID need not be sent. 7/28/16
		/*if( !String.isBlank(newVersion.Entity_ID__c )  && ! newVersion.Entity_ID__c.equals(oldVersion.Entity_ID__c)) {
			updateFields.put('CSCI_BrokerID', String.isBlank(newVersion.Entity_ID__c) ? ' ' : newVersion.Entity_ID__c);
		}*/
		
		if( !String.isBlank(newVersion.FirstName )  && ! newVersion.FirstName.equals(oldVersion.FirstName)) {
			updateFields.put('CSCI_contactFirstName', String.isBlank(newVersion.FirstName) ? ' ' : newVersion.FirstName);
		}
		if( !String.isBlank(newVersion.LastName )  && ! newVersion.LastName.equals(oldVersion.LastName)) {
			updateFields.put('CSCI_contactLastName', String.isBlank(newVersion.LastName) ? ' ' : newVersion.LastName);
		}
		if( !String.isBlank(newVersion.Phone )  && ! newVersion.Phone.equals(oldVersion.Phone)) {
			updateFields.put('CSCI_contactPhone', String.isBlank(newVersion.Phone) ? ' ' : newVersion.Phone);
		}
		if( !String.isBlank(newVersion.Email )  && ! newVersion.Email.equals(oldVersion.Email)) {
			updateFields.put('CSCI_contactEmail', String.isBlank(newVersion.Email) ? ' ' : newVersion.Email);
		}
		if( !String.isBlank(newVersion.Fax )  && ! newVersion.Fax.equals(oldVersion.Fax)) {
			updateFields.put('CSCI_contactFax', String.isBlank(newVersion.Fax) ? ' ' : newVersion.Fax);
		}
		if( !String.isBlank(newVersion.Salutation )  && ! newVersion.Salutation.equals(oldVersion.Salutation)) {
			updateFields.put('CSCI_contactSalutation', String.isBlank(newVersion.Salutation) ? ' ' : newVersion.Salutation);
		}
		if( !String.isBlank(newVersion.MailingStreet )  && ! newVersion.MailingStreet.equals(oldVersion.MailingStreet)) {
			updateFields.put('CSCI_contactMailingStreet', String.isBlank(newVersion.MailingStreet) ? ' ' : newVersion.MailingStreet);
		}
		if( !String.isBlank(newVersion.MailingCity )  && ! newVersion.MailingCity.equals(oldVersion.MailingCity)) {
			updateFields.put('CSCI_contactMailingCity', String.isBlank(newVersion.MailingCity) ? ' ' : newVersion.MailingCity);
		}
		if( !String.isBlank(newVersion.MailingState )  && ! newVersion.MailingState.equals(oldVersion.MailingState)) {
			updateFields.put('CSCI_contactMailingState', String.isBlank(newVersion.MailingState) ? ' ' : newVersion.MailingState);
		}
		if( !String.isBlank(newVersion.MailingCountry )  && ! newVersion.MailingCountry.equals(oldVersion.MailingCountry)) {
			updateFields.put('CSCI_contactMailingCountry', String.isBlank(newVersion.MailingCountry) ? ' ' : newVersion.MailingCountry);
		}
		if( !String.isBlank(newVersion.MailingPostalCode )  && ! newVersion.MailingPostalCode.equals(oldVersion.MailingPostalCode)) {
			updateFields.put('CSCI_contactMailingPostalCode', String.isBlank(newVersion.MailingPostalCode) ? ' ' : newVersion.MailingPostalCode);
		}

		System.debug('Broker Agent contact odification updates' + String.valueOf(updateFields));
		return updateFields;
	}
	
	public static Map<String,String> getContactChangeFields( Contact newContact) {
		return FCI_Util.getContactChangeFields( newContact, null);
	}

	// NOTE: In the following SOQL, Case_Type__c is Deprecated with introduction of RecordTypes for different cases types 8/22/16 KG '                    Case_Type__c, ' +	
	public static String CaseDetailsQuerySOQL =
	'SELECT              Id, ' +
	'                    RecordType.Name, ' +
	'                    Contact_Type__c, ' +
	'                    Group_ID__c,Facets_Category__c, ' +
	'                    Facets_Status__c, Facets_Subject__c, ' +
	'                    Reason__c, ' +
	'                    Subject, Description, ' +
	'                    Status, ' +
	'                    Origin,' +
	'                    Resolution_Reason__c,' +
	'                    Group_Name__c,' +
	'                    New_Group_ID__c,' +
	'                    Broker_Service_Team__c,' +
	'                    Broker_Agent__c,' + 
	'                    Broker_ID__c,' +
	'                    SLA_Category__c,' +
	'                    Facets_Satisfaction_Level__c,' +
	'                    Market_Segment__c,' +
	'                    Contact.LastName, Contact.FirstName,' +
	'                    ContactId,' +
	'                    Contact.Salutation,Contact.MailingCity,' +
	'                    Contact.MailingState, Contact.MailingCountry,' +
	'                    Contact.MailingPostalCode, Contact.MailingStreet,' +
	'                    Contact.Phone, Contact.Fax,Contact.Email,' +
	                    // -------------------------------------------------------------------------------------------
						// Added Member Case related fields to query as part of Member Cases implementation KG 8/29/16
	'                    M_Id__c, E_Product_Category__c, GroupContrivedKey__c, SubscriberContrivedKey__c, MemberContrivedKey__c,' +
						// -------------------------------------------------------------------------------------------
	'                    OwnerId, Owner.Type,' +
	'                    CreatedDate,' +
	'                    ClosedDate,' +
	'                    Received_Date__c,' +
	'                    LastModifiedDate, ' +
	'                    Facets_case_ID__c,' +
	'                    (SELECT Id, IsPublished,LastModifiedDate, CreatedBy.FirstName, CreatedBy.LastName, CommentBody FROM CaseComments ' +
	'                            WHERE NOT ( CreatedBy.FirstName = \'Facets\' AND CreatedBy.LastName = \'Integration\') ' +
	'                            ORDER BY LastModifiedDate ASC)        ' +
	'            FROM Case ' +
	'             WHERE ID ';

	public static Case getCaseDetailsById( Id caseId) {
		return Database.query( CaseDetailsQuerySOQL + '= \'' + caseId + '\'');
	}
	
	public static List<Case> getCaseDetailsByIdSet( Set<Id> idSet) {
		return Database.query( CaseDetailsQuerySOQL + ' IN :idSet');
	}
	
	public static List<Case> getCaseDetailsByIdList( List<Id> idList) {
		return getCaseDetailsByIdSet( new Set<Id>(idList));
	}
	
	// Given a list of recordType Names, return a list of corresponding recordTypeIds
	 
	public static Set<String> getRecordTypeIds( String sObjectType, String[] recordTypeNames ) {
	Set<String> rtIdList = new Set<String>();

	if( String.isBlank(sObjectType) || recordTypeNames == null || recordTypeNames.isEmpty())
		return rtIdList;	// empty

	for( String s : recordTypeNames) 
		rtIdList.add( QueryBase.getRecordTypeID( sObjectType, s));

	return rtIdList;
	}
	
	public static Set<String> getSBUCaseRecordTypeIds() {
		    return FCI_Util.getRecordTypeIds('Case', new List<String> {'SBU_Group_Case', 'SBU_Member_Case', 'SBU_Non_Member_Case'  });		
	}


}