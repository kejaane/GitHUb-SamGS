/*=========================================================================================
 * Date		: 11/6/15
 * Developer	: Ken Gill
 * Purpose   	:  
 *               This class represents changes to between a new and old version of a Salesforce 
 *               case record. It assumes the SF case ID for the record is identical and limits to 
 *               checking for changes on a limited set of fields: Facets Subject, Category, SF Status,
 *               and Resolution Reason.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/6/15   |  KG    |	Initial Version                                         
 *   	     |        | 
 *=========================================================================================
 */
 
public with sharing class FCI_UpdateCaseRequest extends FCI_Message {

	 // used for logging related records used to build request data
	public Map<String,String> relatedRecords { get; set; }	

	public Id caseId {get;set;}
	public String facetsCaseId { get; set; }	
	public Case caseObject { get; set; }
	public CaseComment caseCommentObject { get; set; }
    
	Map<String,String> updateFields = new Map<String,String>();

/*************************************************************************************
 * Purpose   : Default no-arg constructor. Useful for writing test code without requiring a Case object
 *             for instantiation
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
	   
	public FCI_UpdateCaseRequest() {
	 super();
	 this.msgType = IntegrationMessage.REQUEST;
	 this.isValid = false;	// by default
	}

/*************************************************************************************
 * Purpose   : Creates an update object that represents the difference among selected fields
 *             of a Salesforce case record between old and new version of the record. The compared
 *             fields are limited to requirements defined fields for which updates should be sent to the
 *             Facets system. (Facets Subject, Facets Category, SF Status and Resolution reason)
 *             
 * Parameters: Case newVersion - modified instance of SF Case record 
 *             Case oldVersion - pre-modification baseline copy of SF Case record
 * Return    : None
 *************************************************************************************/
	
	public FCI_UpdateCaseRequest( Case newVersion, Case oldVersion) {
		super();
		this.msgType = IntegrationMessage.REQUEST;
		if( newVersion == null || oldVersion == null || String.isBlank(newVersion.Facets_case_ID__c) ) {
			this.isValid = false;
			System.debug('Received a null Case argument to FCI_UpdateCaseRequest(Case c) constructor');
			return;
		}
	
		this.isValid = true;	// by default
	 	caseObject = newVersion;
		caseID = newVersion.Id;
		facetsCaseId = newVersion.facets_case_ID__c; 
		
		String notes = ' ';
		
		if( newVersion.Description != null 
		    	&& 
		    !newVersion.Description.equals(oldVersion.Description)) {
		    	
			String header;
			if( String.isBlank(oldVersion.Description)) {
				header = '\n====Description ====\n\n';
			} else {
				header = '\n====Description Updated====\n\n';
			}
			notes = notes + header + newVersion.Description;			
		}

		if( newVersion.Resolution_Reason__c != null 
		    	&& 
		    !newVersion.Resolution_Reason__c.equals(oldVersion.Resolution_Reason__c)) {
		    	
			String header;
			if( String.isBlank(oldVersion.Resolution_Reason__c)) {
				header = '\n====Resolution ====\n\n';
			} else {
				header = '\n====Resolution Updated====\n\n';
			}
			notes = notes + header + newVersion.Resolution_Reason__c;			
		}

		if( !String.isBlank(notes)) {
			updateFields.put('Notes', notes);
		}
				
		
		if( ! newVersion.Facets_Category__c.equals(oldVersion.Facets_Category__c)) {
			updateFields.put('Category', get4LetterPrefixCode(newVersion.Facets_Category__c));
		}
		if( ! newVersion.Facets_Subject__c.equals(oldVersion.Facets_Subject__c)) {
			updateFields.put('Subject', get4LetterPrefixCode(newVersion.Facets_Subject__c));			
		}
		if( newVersion.Reason__c !=null && ! newVersion.Reason__c.equals(oldVersion.Reason__c)) {
			updateFields.put('Reason', get4LetterPrefixCode(newVersion.Reason__c));			
		}
		
		// SLA Category change detection. The related formula field Facets_Satisfaction_Level__c will hold the mapped value from Salesforce 
		// SLA Category picklist selection to Facets satisfaction level (which is what we need to send to Facets).  
		if( ! newVersion.Facets_Satisfaction_Level__c.equals(oldVersion.Facets_Satisfaction_Level__c)) {
			updateFields.put('CSSC_SLACategory', newVersion.Facets_Satisfaction_Level__c);			
		}
				
		// TBD - Clarify which status is meant by IAD
		if( ! newVersion.Status.equals(oldVersion.Status)) {
			String newFacetsStatus = 'OP';	// Default. The Facets code for Open status
			if( newVersion.Status.StartsWith('Closed')) {
				newFacetsStatus = 'CL'; 	// Code for Facets Closed status
				updateFields.put('closedDate', FCI_Util.getDateTimeAsMMDDYYYY(DateTime.now()) );
			} 
			
			updateFields.put('Status', newFacetsStatus);
			updateFields.put('POC', FCI_Util.mapCaseStatusToProofOfClosureCode(newVersion.Status));
		}
		
		// ---Start: Subject line edited  ---------------		
		if( !String.isBlank(newVersion.Subject )  && ! newVersion.Subject.equals(oldVersion.Subject)) {
			updateFields.put('Summary', newVersion.Subject);
		}
		
		// ---Start: Group lookup and Group ID manual override edit handling ---------------

		// Manually entered Group Id field changed. Group ID here refers to the Facets Account number for a Group.
		// if new field value not empty and different from previous value
		// Note - Group_ID__c (when manual entry field is used) is the Facets account number for the group
		if( !String.isBlank(newVersion.New_Group_ID__c )  && ! newVersion.New_Group_ID__c.equals(oldVersion.New_Group_ID__c)) {
			updateFields.put('groupID', newVersion.New_Group_ID__c);
		}

		// Group account lookup changed, only process this if manually entered Group_Id__c override field is empty
		// Field:Group_Name__c is a lookup field i.e. Id field
		// Group ID refers to Facets account number for a Group
		System.debug( 'newVersion.New_Group_ID__c=' + newVersion.New_Group_ID__c);
		System.debug( 'newVersion.Group_Name__c=' + newVersion.Group_Name__c);
		System.debug( 'oldVersion.Group_Name__c=' + oldVersion.Group_Name__c);
		if( String.isBlank( newVersion.New_Group_ID__c) && 
                    ( !String.isBlank(newVersion.Group_Name__c) &&  !newVersion.Group_Name__c.equals(oldVersion.Group_Name__c))) {
			Account a = [ select Id, Facets_Account_Number__c from Account where Id = :newVersion.Group_Name__c];
			updateFields.put('groupID', a.Facets_Account_Number__c);
		}

		// -----Case Owner Change ------------------------------------------------------------------
		// When case owner is changed, send the Facets User ID of the new case owner
		if( newVersion.OwnerID != oldVersion.OwnerID) {
			User u = [ Select Id, Facets_User_ID__c, Email from User where Id = :newVersion.OwnerID];
			updateFields.put('caseOwnerID', u.Facets_User_ID__c);
			updateFields.put('caseOwnerEmailID', u.Email);			
		}
				
		// -----Case Broker Agent Contact Replacement and Contact Modification handling------------------------
		
			// if Broker Agent contact was replaced with another Broker Agent contact
		if( !String.isBlank(newVersion.Broker_Agent__c) && ( newVersion.Broker_Agent__c != oldVersion.Broker_Agent__c) ) {
			Contact c = [SELECT Id, Entity_ID__c from Contact where Id = :newVersion.Broker_Agent__c ];
			if( String.isBlank(c.Entity_ID__c)) {
				System.debug( 'New Broker Contact does not have a value for EntityID populated. New Broker Agent Contact record=' + String.valueOf(c));
			} else {
			updateFields.put('CSSC_BrokerID', c.Entity_ID__c);
			}
		}
		
		//---------------------Case Broker Agent Contact Modified----------------------------------------------------------------------
			// if Broker Agent Contact was not changed but just modified, that scenario is handled by Contact trigger using the constructor 
			// version that takes the relatedCase and Contact new,old records
			
			
		//---------------------Case Contact Changed to a different Contact --------------------------------------------------
		// Note: This handles change of Case Contact to a different Contact. This is different from modifying existing Case 
		// Contact fields which is handled via ContactTriggerHandler
		if( newVersion.contactId != oldVersion.contactId) {
			updateFields.putAll( FCI_Util.getContactChangeFields( new Contact( Id = newVersion.contactId)));
		}
		
		
		//-------------------------------------------------------------------------------------------
		
		if( !updateFields.isEmpty()) {
			// Anytime there is an update, regardless of change, add lastModifiedDate as a updatefield
			updateFields.put('lastModifiedDate', FCI_Util.getDateTimeAsMMDDYYYY(DateTime.now()));
			
			// There is a relevant change to send
			// Create the update request
			System.debug('Found case updates to send to Facets=' + String.ValueOf(updateFields));
			// TBD - Create a FCI_UpdateCaseRequest and send it
			
		} else {
			System.debug('Found no eligible case updates to send to Facets');
		}					
	}

/*************************************************************************************
 * Purpose   : Constructor version that creates a new update message based on a new Case Comment
 *             being added to a Case.
 *             this
 * Parameters: CaseComment comment - a new comment added to a SF case
 *             Case parentCase - related Case on which the comment was added
 *
 * Return    : None
 *************************************************************************************/

	public FCI_UpdateCaseRequest( CaseComment comment, Case parentCase) {
	 super();
	 this.msgType = IntegrationMessage.REQUEST;
	 if( comment == null || comment.parentId == null || parentCase == null || String.isBlank(parentCase.Facets_case_ID__c) ) {
	 	this.isValid = false;
	 	System.debug('Received a null CaseComment, parent Case argument or parent Case.Facets_case_ID__c to FCI_UpdateCaseRequest(CaseComment comment) constructor');
	 	return;
	 }
	 
	 try {	 	 
	     caseObject = parentCase;
	     caseId = comment.parentId;
	     facetsCaseId = caseObject.facets_case_ID__c;
	     updateFields.put( 'Notes', comment.CommentBody);
	     this.isValid = true;
	 } catch (Exception e) {
		System.debug('Exception when executing DML to retrieve related Case from CaseComment with parentId=' + comment.parentId);
		this.isValid = false;
	 }	
	}	

/*************************************************************************************
 * Purpose   : Constructor version that creates a new update message based on a Case Contact
 *             (i.e. Broker Contact) being updated. The new (updated) and old versions of the
 *             Case's broker Contact are used to detect which fields were updated.
 *
 * Parameters: Case relatedCase - the Case record related to the Contact being modified 
 *             Contact newVersion - the new Contact record with modified fields
 *             Contact oldVersion - the old Contact record with pre-modification field values 
 *
 * Return    : None
 *************************************************************************************/
	public FCI_UpdateCaseRequest( Case relatedCase, Contact newVersion, Contact oldVersion ) {
	 super();
	 this.msgType = IntegrationMessage.REQUEST;
	 if( newVersion == null || newVersion.Id == null || relatedCase == null || String.isBlank(relatedCase.Facets_case_ID__c) ) {
	 	this.isValid = false;
	 	System.debug('Received a null or empty Case object, Contact newVersion or Case.Facets_case_ID__c to FCI_UpdateCaseRequest(Case relatedCase, Contact newVersion, Contact oldVersion) constructor');
	 	return;
	 }
	 
	 try {
	     caseObject = relatedCase;
	     caseId = relatedCase.Id;
	     facetsCaseId = caseObject.facets_case_ID__c;
	     updateFields.putAll( FCI_Util.getContactChangeFields( newVersion, oldVersion) );
	     this.isValid = true;
	 } catch (Exception e) {
		System.debug('Exception in method FCI_UpdateCaseRequest( Case relatedCase, Contact newVersion, Contact oldVersion ) = ' + e.getMessage());
		this.isValid = false;
	 }	
	}	
	
/*************************************************************************************
 * Purpose   : Boolean check method to denote if the message is valid. Does various checks on 
 *             received constructor arguments to determine if message is valid.
 *             
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
// validate Facets update case request
public FCI_Validation validateRequest() {
	FCI_Validation validation = new FCI_Validation();
	if( String.isBlank(facetsCaseID) || updateFields == null || updateFields.isEmpty()) {
		validation.isValid = false;
		validation.addFieldValidationError('Fields', 'Missing facetsCaseID or updateFields is null or empty');
		return validation;
	}
	
	validation.isValid = true; 	// default
	return validation;
}

/*************************************************************************************
 * Purpose   : Extract 4-letter prefix from given input string.
 *             
 * Parameters: String s - the string from which to extract 4-letter code.
 *
 * Return    : None
 *************************************************************************************/
	
	public String get4LetterPrefixCode(String s) { return s == null? null : s.subString(0,4); }
	
	public Map<String,String> getCaseUpdates() { return updateFields; }
	   
}