/*=========================================================================================
 * Date     : 11/6/15
 * Developer    : Ken Gill
 * Purpose      :  
 * 
 * The FCI_CreateCaseRequest object is a data object that includes all the field needed by 
 * the FCI_FacetsService to send a create Facets case request.  It takes a Salesforce Case
 * object as constructor input and extracts key fields from the Case record. In addition it 
 * provides various mappings from Salesforce to Facets codes as well as provides hardcoded 
 * values that are required by the interface but are not related to the input SF Case record. 
 * 
 * It extends FCI_Message which extends IntegrationMessage so it can be logged by the 
 * Integration log framework.  
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/6/15   |  KG    | Initial Version    
 * 8/22/16   |  KG    | Modify call to FCI_Util.mapCaseTypeToFacetsCustomerIndicator near line 155 to use 
 *           |        | RecordType.Name instead of Case_Type__c which is deprecated with the introduction
 *           |        | of RecordTypes for each SBU case type as part of Member Case/Communities implementation 
 *           |        | (RTs Introduced by: A.Ojha)                                  
 * 2/21/2017 |  AO    | Updated the validation Critera to include Contact_Type__c  as a required field
 *           |        | for a case to be submitted to facets
 * 05/03/17  |  KG    | Line 378: To address production issue of Member Cases Missing Facets Case ID ( Story B-03936), 
 *           |        | the Eligibility Product Category / Product__c / field is being made not required
 *           |        | 
 *           |        | 
 *=========================================================================================
 */

public with sharing class FCI_CreateCaseRequest extends FCI_Message {

    // Facets task status codes.
    public static String FacetsStatus_CLOSED = 'CL';
    public static String FacetsStatus_OPEN = 'OP';

    // Map of Case.Origin => Facets.CSSC.CALLIN_METHOD table. Src document: Project 51 Sharepoint: Facets - Fields List with Lookup Values.xlsx
    public static Map<String,String>  caseOriginToFacetsCallingMethodMap = new Map<String,String> {
        'Email' => '6',
        'Web' => 'W',
        'Phone' => '1',
        'Phone Conversation' => '1',
        'Email Thread' => '6',
        'In-Person Conversation' => '5',
        'Correspondence' => '3',
        'Email: Broker Sales MD' => '6',
        'Email: Broker Sales 4' => '6',
        'Email: Retro activity Request' => '6',
        'Email: SBC Project' => '6',
        'Email: BCS Specialist' => '6',
        'Email: Small Medium Group' => '6',
        'Email: Royal' => '6',
        'Email: Indigo' => '6',
        'Email: Ocean' => '6',
        'Email: Sapphire' => '6',
        'Email: Sky' => '6',
        'Email: Teal' => '6',
        'Email: Compliance' => '6'  
    };
    
     // used for IntegrationLog logging related records used to build request data
    public Map<String,String> relatedRecords { get; set; }  

    public String serviceRepId   { get; set; }  // Carefirst network id of case owner. Mapped to CSTK.taskPrimaryUserId
    public String serviceRepEmail { get; set; } // Service Rep is the case owner.
    public String groupID        { get; set; }  // src: Case.GroupID,  mapsto: ??. Not a required field.
    public String facetsCategory { get; set; }      // maps to Case.Facets_Category
    public String facetsCategoryCode { get; set; }  // maps to CSTK.taskCategory; derived from Case.Facets_Category
    public String facetsStatus   { get; set; }  // maps to CSTK.taskSubject; Case.Facets_Subject
    public String facetsSubject  { get; set; }  // maps to Case.Facets_Subject
    public String facetsSubjectCode {get;set;}  // maps to CSTK.taskSubject; derived from Case.Facets_Subject
    public String facetsReasonCode {get;set;}   // maps to CSTK.ReasonClassification
    
    public String subject        { get; set; }  // maps to CSTK.taskCategory; Case.Facets_Category
    public String description    { get; set; }  // Case.Description => CSTK.taskSummary 
    public String status         { get; set; }  // Case.Status => CSTK.taskStatus 
    public Datetime dateTimeOpened { get;set; } // maps to CSTK.taskInputDateTime
    public Datetime dateTimeClosed { get;set; } // maps to CSTK.taskCloseDate
    public DateTime dateTimeReceived {get; set;}  // maps to CSTK.taskReceivedDate
    public DateTime dateTimeLastUpdated {get; set;} // maps to CSTK.taskLastUpdateDateTime
    public String notes {get;set;}          // maps to CSWN.taskNotes; Source: Case.?
    public String contactLastName {get;set;}
    public String contactFirstName {get;set;}
    public String contactTitle {get;set;}
    public String contactAddressLine1 {get;set;}
    public String contactAddressLine2 {get;set;}
    public String contactCity {get;set;}
    public String contactState {get;set;}
    public String contactCountry {get;set;}
    public String contactZip {get;set;}
    public String contactPhone {get;set;}
    public String contactFax {get;set;}
    public String contactEmail {get;set;}
    public String callingMethod {get;set;} 
    public String resolutionReason {get;set;}   // src: Case.Resolution_Reason__c => CSTK.taskNotes ( description + "delimiter" + resolutionReason)
                                                // per decision to concat res. reason to case desription re: 10/12/15 Email Preston,Ken,Vinish
    //public String reasonClassification {get;set;}  
    
    public String caseComments {get;set;}   // Current implementation combines all case comments into one string

    public String callerResponse {get;set;}     // Holds Broker_ID__c field; maps to CSSC.callerResponse

    // hard coded fields
 
    public String callerType {get; set;}
    public String satisfactionLevel {get;set;}
    public String disclaimerInd {get;set;}
    public String contactMemberRelationship {get;set;}
    public String groupContrivedKey {get;set;}
    public String memberContrivedKey {get;set;}
    public String customerIndicator {get;set;}
    public String productCategory {get;set;}
    public String taskInputMethod {get;set;}
    public String nextReviewInterval {get;set;}
    public String subGroupContrivedKey {get;set;}
    public String subscriberContrivedKey {get;set;}
    public String inputUserSiteCode {get;set;}
    public String taskPageType {get;set;}
    // CSWV fields
    public String subAddrLine1 {get;set;}
    public String subAddrLine2 {get;set;}
    public String subZip {get;set;}
    public String subDOB {get;set;}
    public String subGroup {get;set;}
    public String subscriberId {get;set;}
    //CSWC fields
    public String mcpdSource {get;set;}
    
    
            
    public Case caseObject {get;set; }  // related Case
    public Id  caseId { get;set; }
    

    // no-arg constructor. Useful for unit testing to allow setting field values without requiring a case object
    // calling code sets each field individually
    public FCI_CreateCaseRequest() {
     super();
     this.msgType = IntegrationMessage.REQUEST;
     this.isValid = true;   // by default
     setHardCodedFields();   
    }
    
    public FCI_CreateCaseRequest( Case c) {
     super();
     this.msgType = IntegrationMessage.REQUEST;
     if( c == null || !String.isBlank(c.Facets_case_ID__c)) {
        this.isValid = false;
        System.debug('Received a null Case argument or Facets Case ID already exists to FCI_CreateCaseRequest(Case c) constructor');
        return;
     }
     
     this.isValid = true;   // by default

     caseObject = c;
     caseID = c.Id;
     customerIndicator = FCI_Util.mapCaseTypeToFacetsCustomerIndicator( c.RecordType.Name); // KG:replaced c.Case_Type__c as part of recordtypes introduction (see header comment)
     callerType = FCI_Util.mapContactTypeToFacetsCallerType( c.Contact_Type__c);
     groupID = c.New_Group_ID__c;
     if(String.isBlank(groupID)) {
        groupID = c.Group_ID__c;
     }
     
     callerResponse = c.Broker_ID__c;
     
     // Set Service rep ID if the case owner is a User (not a Queue)    
     if( caseObject.Owner.Type == 'User') {
        User u = [ select Id, FirstName, LastName, Username, Email, Facets_User_ID__c from User where Id = :caseObject.OwnerId];
        serviceRepEmail = u.Email;
        if( String.isBlank(u.Facets_User_ID__c)) {
            System.debug('Warning: FCI_CreateCaseRequest: User record does not have a Facets User ID set. No ServiceRepID will be sent, Facets will create case with default userid $SFUser. User: firstname=' + u.FirstName + ', lastname=' + u.LastName + ',username=' + u.userName);            
        } else {
            serviceRepId = u.Facets_User_ID__c; 
        }
     }
     
     facetsCategory = c.Facets_Category__c;
     facetsCategoryCode = get4LetterPrefixCode( c.Facets_Category__c);
     facetsStatus = c.Facets_Status__c;
     facetsSubject = c.Facets_Subject__c;
     facetsSubjectCode = get4LetterPrefixCode( c.Facets_Subject__c);
     facetsReasonCode = get4LetterPrefixCode( c.Reason__c);
     satisfactionLevel = c.Facets_Satisfaction_Level__c;
     subject = c.Subject;
     description = '\n====Description====\n' + c.description;
     status = c.Status;

     resolutionReason =  (!String.isBlank(c.Resolution_Reason__c) 
                         ? '\n====Resolution====\n' + c.Resolution_Reason__c  :    '\n' );
                         
     contactLastName = c.Contact.LastName;
     contactFirstName = c.Contact.FirstName;
     contactTitle = c.Contact.Salutation;
     contactCity = c.Contact.MailingCity;
     contactState = c.Contact.MailingState;
     contactCountry = c.Contact.MailingCountry;
     contactZip = c.Contact.MailingPostalCode;
     contactAddressLine1 = c.Contact.MailingStreet;
     contactAddressLine2 = contactCity + ', ' + contactState + ' ' + contactZip;
     contactPhone = c.Contact.Phone;
     contactFax = c.Contact.Fax;
     contactEmail = c.Contact.Email;
     callingMethod = mapCaseOriginToFacetsCallingMethod( c.Origin);
     dateTimeOpened = c.CreatedDate;
     dateTimeClosed = c.ClosedDate;
     dateTimeReceived = c.Received_Date__c;
     dateTimeLastUpdated = c.LastModifiedDate; // System generated field, standard on every SF record
     
     // Combine case comments into formatted string
     caseComments = '\n====Case Comments====\n';
     if( c.CaseComments != null &&  !c.CaseComments.IsEmpty()) {
        for( CaseComment cc : c.CaseComments) {
            caseComments += (  '[' + cc.LastModifiedDate.format('MM/dd/yyyy hh:mm a z') + ', ' + cc.CreatedBy.FirstName + ' ' + cc.CreatedBy.LastName + '] ' + 
                (cc.IsPublished ? 'Customer Visible ' : '') + 'Comment: ' + cc.CommentBody) + '\n';
        }
     } 
    setMemberCaseFields( c );                         
    setHardCodedFields();
    }

    // Set fields specific to member case
    private void setMemberCaseFields(Case c) {
        if( customerIndicator != 'M') return;   // Don't set Member case fields if case type as is not Member case
 
        contactMemberRelationship = 'M';    // ?? Other values? TODO
        groupContrivedKey = c.GroupContrivedKey__c;
        memberContrivedKey = c.MemberContrivedKey__c;
        productCategory = c.E_Product_Category__c;
        subGroupContrivedKey = '';
        subscriberContrivedKey = c.SubscriberContrivedKey__c;       
    }
    
    // common fields that don't change are hardcoded
    private void setHardCodedFields() {
        // hard coded fields 
        if( customerIndicator != 'M') 
            contactMemberRelationship = 'O';    
        
        disclaimerInd = 'N';
        taskInputMethod = 'E';  // tells Facets the case was created via an External interface (Facets TIBCO webservice API) not from Facets program UI.
        nextReviewInterval = '1';
        inputUserSiteCode='1';
        taskPageType = 'NC';    // tell Facets to create a No Call (NC) task
        
        // CSWC fields
        subAddrLine1 = '9809 West Springs Drive Apt 803';
        subAddrLine2= '';
        subZip = '21043';
        subDOB = '07/01/1980';
        subGroup='9905';
        mcpdSource='CT2A';
     }
 
    // validate Facets create case request
    public FCI_Validation validateRequest() {
        FCI_Validation validation = new FCI_Validation();
        validation.isValid = true;  // default
        
        //  do validations
        validateCommonRequestFields( validation );
        if( customerIndicator == 'G') validateGroupCaseTypeRequest (validation);
        if( customerIndicator == 'N') validateNonMemberCaseTypeRequest (validation);
        if( customerIndicator == 'M') validateMemberCaseTypeRequest (validation);
        if( customerIndicator == 'S') validateSubscriberCaseTypeRequest (validation);
                                        
        if(!validation.isValid) {
            // add a message telling the user all required fields so they do not have to iterate multiple times to figure out all required fields
            validation.addFieldValidationError('Facets Required Fields:', 
                                               'Group ID or New Group ID, Broker Service Team, SLA Category, Market Segment, Facets Category, Facets Subject, Subject, Description, Status, Contact First or Last Name, Contact Type, Created Date, Received Date'  );
            if( ApexPages.currentPage() != null ) {
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, validation.getValidationMessagesAsHTML()));
            }                                                   
        }  
        return validation;
    }
     @TestVisible
     private void validateCommonRequestFields( FCI_Validation validation) {

        if( !String.isBlank(caseObject.Facets_case_ID__c)) {
            validation.addFieldValidationError('Facets Case ID', 'Case has already been submitted to Facets. Facets case id=' + caseObject.Facets_case_ID__c); 
            validation.isValid = false;
        }
      
        if( !String.isBlank(status) && status.startsWith('Closed')) {
            return;      // the remaining validations are only for a case being routed to Facets to be worked there
        }
        
        // Enforce required fields consistent with validation rule ECSE003. Failing to require these fields will 
        // prevent the case status from being changed to 'Routed To Facets' when the request completes and the case facetsCaseId and status needs to be updated to Routed to Facets.
        if(String.isBlank(caseObject.Broker_Service_Team__c)) {
            validation.addFieldValidationError('Broker Service Team', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
        if(String.isBlank(caseObject.SLA_Category__c)) {
            validation.addFieldValidationError('SLA Category', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }

        // Enforce fields required by Facets System       
        if(String.isBlank(facetsCategory)) {
            validation.addFieldValidationError('Facets Category', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
        if(String.isBlank(facetsSubject)) {
            validation.addFieldValidationError('Facets Subject', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
        if(String.isBlank(subject)) {
            validation.addFieldValidationError('Subject', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
        if(String.isBlank(description)) {
            validation.addFieldValidationError('Description', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
        if(String.isBlank(status)) {
            validation.addFieldValidationError('Status', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
        if(String.isBlank(contactLastName) && String.isBlank(contactFirstName) ){
            validation.addFieldValidationError('Contact First, Last Name', 'At least one of Contact first or last name fields is required field and cannot be blank'); 
            validation.isValid = false;     
        }
        
        // AO Changes Begin 02/21/2017
        if(String.isBlank(callerType)) {
            validation.addFieldValidationError('Contact Type', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
 
        //AO Changes End 02/21/2017
        if(dateTimeOpened == null) {
            validation.addFieldValidationError('Created Date', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
        if(dateTimeReceived == null) {
            validation.addFieldValidationError('Received Date', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }       
     }
     @TestVisible
     private void validateGroupCaseTypeRequest(FCI_Validation validation) {
        // Require Group ID
        if(String.isBlank(caseObject.Group_ID__c) && String.isBlank(caseObject.New_Group_ID__C) ) {
            validation.addFieldValidationError('Group ID, New Group ID', 'At least one of Group ID or New Group ID fields is required, both cannot be blank'); 
            validation.isValid = false;
        }      
     }
     
     // check any required fields for Member cases
     @TestVisible
     private void validateMemberCaseTypeRequest(FCI_Validation validation) {
        // Enforce fields required by Facets System       
        
        if(String.isBlank(customerIndicator)) {
            validation.addFieldValidationError('Customer Indicator', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
        
        if(String.isBlank(contactMemberRelationship)) {
            validation.addFieldValidationError('Contact Member Relationship', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
               
        if(String.isBlank(groupContrivedKey)) {
            validation.addFieldValidationError('Group Contrived Key', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
               
        if(String.isBlank(memberContrivedKey)) {
            validation.addFieldValidationError('Member Contrived Key', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
         
        /* To address production issue of Member Cases Missing Facets Case ID ( Story B-03936), the Eligibility Product
        Category / Product__c / field is being made not required - KG 5/3/17
               
        if(String.isBlank(productCategory)) {
            validation.addFieldValidationError('Eligiblility Product Category', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }
        */
               
        if(String.isBlank(subscriberContrivedKey)) {
            validation.addFieldValidationError('Subscriber Contrived Key', 'Is a required field and cannot be blank'); 
            validation.isValid = false;
        }   
     }

     // check any required fields for Non-Member cases     
     private void validateNonMemberCaseTypeRequest(FCI_Validation validation) {
        
     }
     @TestVisible
     private void validateSubscriberCaseTypeRequest(FCI_Validation validation) {
        
     }
     
    // Map Case Origin to Facets Callin Method  
    private String mapCaseOriginToFacetsCallingMethod(String caseOrigin) {  
        String mapping =  caseOriginToFacetsCallingMethodMap.get(caseOrigin);
        return mapping == null ? 'W' : mapping; // W default if caseOrigin value not found in map
    }

    // Map 4 letter Subject/Category codes to Picklist value. This map is built during initialization
    public static Map<String,String> facetsSubjectCodeToPicklistMapping = null;
    public static Map<String,String> facetsCategoryCodeToPicklistMapping = null;
    
    private String mapFacetsSubjectCodeToPicklistValue(String subjectCode) {
        return facetsSubjectCodeToPicklistMapping.get(subjectCode);     
    }

    private String mapFacetsCategoryCodeToPicklistValue(String categoryCode) {
        return facetsCategoryCodeToPicklistMapping.get(categoryCode);       
    }

    // Return the first 4 letters of a String. Used to extract codes from Subject/Category picklists which have the code in the first 4 letters e.g. 'MELG-Member Eligibility'
    public String get4LetterPrefixCode(String s) { return s == null? null : s.subString(0,4); }

    // Date formatting utility methods to generate Facets API required Date string formats
    public String getDateTimeAsMMDDYYYY(Datetime dt) { return  dt == null ? null  : dt.format('MM/dd/yyyy');  } 
    public String getDateTimeOpenedAsMMDDYYYY() { return getDateTimeAsMMDDYYYY( dateTimeOpened); } 
    public String getDateTimeClosedAsMMDDYYYY() { return getDateTimeAsMMDDYYYY( dateTimeClosed); } 
    public String getDateTimeReceivedAsMMDDYYYY() { return getDateTimeAsMMDDYYYY( dateTimeReceived); } 
    public String getDateTimeLastUpdatedAsMMDDYYYY() { return getDateTimeAsMMDDYYYY( dateTimeLastUpdated); } 

    // SF Case Status mapped to Facets Status values
    // replace with mapCaseStatusToFacetsStatus(String caseStatus)
    public String getMappedStatus() {
    String facetsMappedStatus = FCI_CreateCaseRequest.FacetsStatus_CLOSED;  // default
   
    // startsWithIgnoreCase() covers all variations of Closed status - 'Closed', 'Closed - Placed in future sprint', 'Closed - Resolved'       
    if( status.startsWithIgnoreCase('Closed')) {
        facetsMappedStatus = FCI_Util.FacetsStatus_CLOSED;
    }
    else {
        facetsMappedStatus = FCI_Util.FacetsStatus_OPEN;
   }   
   return facetsMappedStatus;      
   }
              
}