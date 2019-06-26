/*=========================================================================================
 * Date         : 10/21/2014
 * Developer    : Ken Gill
 * Purpose      : This is a core class for the EGP module and implements the business layer 
 *                logic for EGP processing. This includes processing inputs passed from the 
 *                Contact Trigger where EGP user provisioning actions are initiated and 
 *                communicating with the remote EGP portal by wrapping the EGPProxy class 
 *                (which implements low level web service request/response construction).
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/21/14  |  KG    | Initial Version                                         
 * 11/23/14  |  KG    | Implement EGP Account Update requests. EGPAccountUpdate can be triggered
 *           |        | either by Account or Opportunity triggers and only applies to most current (newest)
 *           |        | effective date sold opportunity on an Account
 * 1/11/15   |  KG    | Add checks to only send EGP updates if the Opportunity system is Nasco or Facets and the Group ID
 *           |        | is not empty. If GroupID is empty, no update is sent
 * 1/14/15   |  KG    | Added checks in the processAccountOpportunityUpdateChanges() and processAccountUpdateChanges()
 *           |        | methods to detect EGP specific field changes and only generate EGP outbound messages for fields
 *           |        | that include:
 *           |        | Account fields: Name, Owner FirstName, LastName, Email
 *           |        | Opportunty fields: System__c, NASCO_Acct_ID__c, Facets_Grp_Num__c, 
 *           |        |                    Risk_Non_Risk__c, FullServiceProducer__c, 
 *           |        |                    GeneralProducer__c, Enrollment__c 
 * 4/10/15   | KG     | If you modify an account (EGP related fields like account name) and the related 
 *           |        | Sold opportunity has a missing group id, the system SFDC still tries to send an
 *           |        | EGP update across to Employer portal. The business rule is not to send an update
 *           |        | if  group id is missing. 
 *           |        |
 *           |        | Added method applyRules_EGP_OpportunityUpdate() to codify the business rule and 
 *           |        | invoke it from buildEGPAccountUpdateRequestData(List<Opportunity>)
 * 10/06/2015| TPB    | Added code to include the Opportunity.Effective_Date__c 
 *           |        |
 * 07/25/2016| KG     | Update code to support AiA Opportunity Record Type split from 51+ and AIA 200+
 *                    | And added a utility method named getRecordTypeIds to encapsulate references to 
 *                    | recordtypeid in a single place.
 * 02/14/2018| Sajitha | T01| Added API Gateway change using Named Credential 
 *=======================================================================================================
 */


public with sharing class EGPService {

public class EGPException extends Exception {}

public static String egpEndPointURL;
public static String egpClientCertificateName;
public static String egpRequestTimeout;
public static String egpSFDCSupportEmailAddress = 'SFDCTeam@CareFirst.com';
public static String egpPortalSupportEmailAddress = 'ep_tech_support@carefirst.com';
public static Boolean isInitialized = false;

public static String environmentModuleName = 'EGP Integration';
public static String environmentCommonModuleName = 'Common';
public static String environmentVariableName_egpSFDCSupportEmailAddress = 'SFDC_Support_Email';
public static String environmentVariableName_egpPortalSupportEmailAddress = 'EGP_Support_Email';
//T01 START
/*public static String environmentVariableName_egpEndPointURL = 'EGP_EndPoint';
public static String environmentVariableName_egpClientCertificateName = 'EGP_ClientCertificateName';*/ 
//T01 END
public static String environmentVariableName_egpRequestTimeout = 'RequestTimeout';
public static List<String> environmentVariableNames = new List<String>();


// one time initialization block when EGPService class is first loaded
static {
    EGPService.environmentModuleName = 'EGP Integration';
    EGPService.environmentVariableNames = new List<String>();
  //T01 Start 
  /*EGPService.environmentVariableNames.add ( EGPService.environmentVariableName_egpEndPointURL );
    EGPService.environmentVariableNames.add ( EGPService.environmentVariableName_egpClientCertificateName );*/ 
 //T01 END
    EGPService.environmentVariableNames.add ( EGPService.environmentVariableName_egpSFDCSupportEmailAddress );
    EGPService.environmentVariableNames.add ( EGPService.environmentVariableName_egpPortalSupportEmailAddress );
    EGPService.environmentVariableNames.add ( EGPService.environmentVariableName_egpRequestTimeout );
                                                         
    EGPService.loadConfigurationFromEnvironmentVariables();
}


/*************************************************************************************
 * Purpose   : This method loads EGP integration related configuration variables when either: 
 *             1. This class is first loaded and automatically called from the static initializer block  
 *             2. OR when the EGP configuration settings are modified through the EnvironmentVariables tab which 
 *             triggers EnvironmentVariableTrigger which calls this method to reload env vars.
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
public static void loadConfigurationFromEnvironmentVariables() {
    
    System.debug('Loading EGPService environment variables');
//  Map<String, EnvironmentVariable__c> envVarMap = EnvironmentVariables.getEnvironmentVariablesForModule(EGPService.environmentModuleName);
    
    Map<String, EnvironmentVariable__c> envVarMap = new Map<String,EnvironmentVariable__c>();
    EnvironmentVariables.getEnvironmentVariablesForModule(EGPService.environmentModuleName, envVarMap);
    EnvironmentVariables.getEnvironmentVariablesForModule(EGPService.environmentCommonModuleName, envVarMap);
    
    if(envVarMap.isEmpty()) {
        System.debug('Error: No EGP related environment variables configured in EnvironmentVariable__c table. Retrieved envVarMap=' + String.valueOf(envVarMap));
        EGPService.isInitialized = false;
        return;
    }
    String value;
    //T01 START - Deprecated as part of Named credentials implementation  
    /*String value =  (envVarMap.get(EGPService.environmentVariableName_egpEndPointURL)).Value__c;
    if(String.isNotBlank(value)) { EGPService.egpEndPointURL = value;}
    System.debug( 'egpEndPointURL=' + value);
    
    value = (envVarMap.get(EGPService.environmentVariableName_egpClientCertificateName)).Value__c;
    if( String.isNotBlank(value)) EGPService.egpClientCertificateName = value;
    System.debug( 'egpClientCertificateName=' + value); */
	//T01 END
    
    value = (envVarMap.get(EGPService.environmentVariableName_egpSFDCSupportEmailAddress)).Value__c;
    if( String.isNotBlank(value)) EGPService.egpSFDCSupportEmailAddress = value;
    System.debug( 'egpSFDCSupportEmailAddress=' + value);
    
    value = (envVarMap.get(EGPService.environmentVariableName_egpPortalSupportEmailAddress)).Value__c;
    if( String.isNotBlank(value)) EGPService.egpPortalSupportEmailAddress = value;
    System.debug( 'egpPortalSupportEmailAddress=' + value);
    
    value = (envVarMap.get(EGPService.environmentVariableName_egpRequestTimeout)).Value__c;
    if( String.isNotBlank(value)) EGPService.egpRequestTimeout = value;
    System.debug( 'egpRequestTimeout=' + value);

    EGPService.isInitialized = true;
}


/*************************************************************************************
 * Purpose   : This is a asynchronous version of the loadConfigurationFromEnvironmentVariables()  
 *             method that can be called from a trigger
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
@future
public static void reloadConfigurationFromEnvironmentVariables() {
     EGPService.loadConfigurationFromEnvironmentVariables();
}


    // -----------------------------------------------------------------------//
    //                         EGP Manage User methods                                                
    // -----------------------------------------------------------------------// 


/*************************************************************************************
 * Purpose   : This method is called by the before insert/update ContactTriggerHandler and implements 
 *             the business rule that any Account can only have one Account.Contact designated as EGP 
 *             Portal Admin i.e EGP Admin checkbox is checked(true).
 *             Two checks are performed:
 *             1. An input batch of Contact updates does not have multiple EGP admins set for the same account
 *             2. An input batch Contact cannot be designated as EGP admin if there is an already existing Contact with EGPPortal Admin set
 *             If either of the above 2 conditions exist resulting in a business rule violation, the submitted Contact record updates fails.
 *             
 *             This implementation is derived from the old implementation of EmployerGroupPortal class.
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
public static void validateSubmittedEGPUpdates() {
    
       Map<id, Contact> chkAccountMap = new Map<id, Contact>();
       Map<id, String> accNames = new Map<id, String>();
        Set<id> accIds = new Set<id>(); 

        // Input working set of Contact records to validate
        // NOTE: cast needed if using Trigger.* outside Trigger definition
        List<Contact> newContactList = (List<Contact>) Trigger.new;
        Map<Id,Contact> oldContactMap = (Map<Id,Contact>) Trigger.oldMap;
        
        List<Contact> contactsWithEGP = new List<Contact>();
        for( Contact c : newContactList) {
            // for new Contacts, only process EGP provisioning if EGP flag is set
            if( Trigger.isInsert && (c.Employer_Group_Portal__c == false))
                continue; 
            if( c.Employer_Group_Portal__c == true && String.isBlank(c.FirstName) == true) {
                c.addError('Contact first name can not be empty if provisioning them as an Employer Group Portal Administrator. Please update the first name and try again.');
                continue;
            }
            if( c.Employer_Group_Portal__c == true) contactsWithEGP.add( c);     
        }
     
        // build Set of account ids to build map of account ids
        for ( Contact c : contactsWithEGP ) {
            accIds.add(c.AccountId);    
        }
        
        // build Map of account Ids and names to be used to get account name using the accIds created above
        //String acct51recordTypeID = QueryBase.getRecordTypeID( 'Account', 'X51');
        List<String> recordTypeIds = getRecordTypeIds('Account');
        for ( Account a : [ SELECT id, Name FROM ACCOUNT WHERE recordTypeID IN :recordTypeIds AND Id IN :accIds ] ) {
            accNames.put(a.id,a.Name);   
        }
        
        // Loop through contacts to determine if there are duplicate EGP assigned contacts in the list or 
        // if one already exists on the database for the associated account.  
        // If not then allow the record to be saved; otherwise set the error.
        for (  Contact c : contactsWithEGP ) {
            if ( Trigger.isInsert || (c.Employer_Group_Portal__c != oldContactMap.get(c.id).Employer_Group_Portal__c) ) {        
                if ( chkAccountMap.containsKey(c.AccountId) && c.Employer_Group_Portal__c ) {                  
                    c.addError('An Employer Group Portal Contact in the current batch is already assigned to Account \'' + accNames.get(c.AccountId) + '\'.');
                } else {
                    if ( c.Employer_Group_Portal__c )
                        chkAccountMap.put(c.AccountId, c);   
                }
            }
        }    
        
        //String contact51recordTypeID = QueryBase.getRecordTypeID( 'Contact', 'X51');
        recordTypeIds = getRecordTypeIds('Contact');
        
        for ( Contact c : [ SELECT AccountId, Account.Name FROM Contact WHERE recordTypeID IN :recordTypeIds AND AccountId IN :chkAccountMap.keySet() AND Employer_Group_Portal__c = TRUE ] ) {
            Contact newContact = chkAccountMap.get(c.AccountId);
            newContact.addError('An Employer Group Portal Contact is already assigned to Account \'' + c.Account.Name + '\'.');
        }   
    
}

// this method is called after input validations for duplicate EGP contacts have been performed.
// At this point, the input Contact list is known to not have any duplicate EGP contacts on the same account. This method 
// builds the request data by calling a supporting method and then passes the list to a future method which
// takes care of making the web service callout to push updates to the EGP system
//

public static void processManageUserChanges(List<Contact> contacts, Map<Id,Contact> oldContactsMap) {
    
    List<Contact> contactsWithEGP = new List<Contact>();
    
    Contact oldContact;
    for( Contact c : contacts) {
            // for new Contacts, only process EGP provisioning if EGP flag is set
            if( Trigger.isInsert && (c.Employer_Group_Portal__c == false))
                continue; 
                
            if( Trigger.isUpdate) {
            // ignore EGP processing if no change to EGP flag for contact
            oldContact = oldContactsMap.get(c.Id); 
            if( oldContact == null) continue;
            
            if( c.Employer_Group_Portal__c == oldContact.Employer_Group_Portal__c) 
                continue;    
            }
            
            contactsWithEGP.add(c);
        }
    
    List<EGPManageUserRequest> builtRequests = EGPService.buildEGPManageUserRequestData ( contactsWithEGP);
    
    // first use JSON library class to serialize the List of request objects since a future method can only accept arguments of primitive/List of primitive types
    String serializedList = JSON.serialize( builtRequests);
    
    // now send the Stringified built requests using an asynchronous future method
    // this is necessary because this code is executed in a Trigger context and makes web service callouts 
    // that are not allowed to be invoked synchronously. Doing so would generate an Exception
    EGPService.sendEGPManageUserRequestsInFuture( serializedList);
    
}

public static List<EGPManageUserRequest> buildEGPManageUserRequestData( List<Contact> contacts) {

    List<EGPManageUserRequest> requests = new List<EGPManageUserRequest>();
    EGPManageUserRequest requestObject; 

    for( Contact c:  contacts) {
        requestObject = buildEGPManageUserRequestData(c);  
        if( requestObject.isValid()) {
            requests.add( requestObject );
        } else {
            // there was an error in constructing the EGPManageUserRequest
            System.debug('Error constructing EGPManageUserRequest. Request data=' + String.valueOf(requestObject));
            // log to Integration log as input validation error
            Integration.log( requestObject);
        }
    }
    
    return requests;
}

public static EGPManageUserRequest buildEGPManageUserRequestData (Contact c) {
    system.debug('*************8inside');
    EGPManageUserRequest request = new EGPManageUserRequest(c);
    
    // query related records and populate request fields
    Map<String,String> relatedRecords = new Map<String,String>();
    request.relatedRecords = relatedRecords;
    
    Boolean requestDataComplete = true;

    System.debug('Building EGPManagerUserRequest with input Contact ID = ' + c.ID); 
    
    
    Contact contact;
    Account account;
    Opportunity opportunity;
    String userErrorMessage;
    String technicalErrorMessage;
    String message;
    
    //String contact51recordTypeID = QueryBase.getRecordTypeID( 'Contact', 'X51');
    List<String> recordTypeIds = getRecordTypeIds('Contact');
     system.debug('**contact'+contact);
    try {
    contact = [select id, FirstName, Employer_Group_Portal__c, LastName, Email, AccountId, Account.Name from Contact where 
               recordTypeID IN :recordTypeIds AND id =:c.ID];
    system.debug('**contact'+contact);
    if(contact == null) {
        userErrorMessage = 'No Contact found matching contact ID=' + c.ID + '.<br/> Error Code=' + request.transactionID + '. Please contact an administrator. ';
        technicalErrorMessage = 'Query: select id, FirstName, Employer_Group_Portal__c, LastName, Email, AccountId, Account.Name from Contact where recordTypeID IN :' + String.ValueOf(recordTypeIds) + 'AND id =' + c.ID;
        message= userErrorMessage + ' <br/> ' + technicalErrorMessage;
        System.debug( message);
        request.msgData = message;
        request.result = IntegrationMessage.STATUS_ERROR;
        request.setIsValid(false);
        c.addError(userErrorMessage, false);
        return request;
    }
    // the relatedRecords Map will hold associated records used to create the request
    // It has entries keyed off of class name e.g.   'Contact' => Serialized(List<Contact>),  'Opportunity' => Serialized( List<Opportunity>) etc.
    // NOTE: the String.valueOf(contact).split(':')[0] is a way to get class name from an SObject instance to create the map key
    
    
    relatedRecords.put( String.valueOf(contact).split( ':')[0], String.valueOf(contact));
    System.debug('Related Contact details:'+ String.valueOf(contact));

    //String acct51recordTypeID = QueryBase.getRecordTypeID( 'Account', 'X51');
    recordTypeIds = getRecordTypeIds('Account');
    account =[SELECT id ,name ,type, owner.firstname ,owner.Lastname ,owner.Email 
              FROM Account 
              WHERE recordTypeID IN :recordTypeIds AND  id=:contact.AccountId];
              
    if(account == null) {
        userErrorMessage = 'No Account found for account name= ' + contact.Account.Name + '.<br/> Error Code=' + request.transactionID + '.<br/> Please contact an administrator. ';
        technicalErrorMessage = 'Query: SELECT Id ,name ,type, owner.firstname ,owner.Lastname ,owner.Email FROM Account WHERE recordTypeID =' + String.valueOf(recordTypeIds) + ' AND id=' + contact.AccountID;
        message= userErrorMessage + ' <br/> ' + technicalErrorMessage;
        
        System.debug( message );
        request.msgData = message;
        request.result = IntegrationMessage.STATUS_ERROR;
        request.setIsValid(false);
        c.addError(userErrorMessage, false);
        return request;
    }
    
    relatedRecords.put( String.valueOf(account).split( ':')[0], String.valueOf(account));
    System.debug('Related Account details:'+ String.valueOf(account));

        
    String accountId = account.Id;
    
    // The following Opportunity select DML is based on the Opportunity selection logic discussed and documented in the document
    //  Sprint20 Folder/EGP Provisioning_Opportunity Selection Criteria.docx
    //
    //String opp51recordTypeID = QueryBase.getRecordTypeID( 'Opportunity', 'X51'); 
    recordTypeIds = getRecordTypeIds('Opportunity');
    String opportunityQuery = 
     'Select Id, Account.Name, Name, Type, StageName, Effective_Date__c, ' +
     'System__c, Risk_Non_Risk__c, Enrollment__c, Facets_Grp_Num__c, ' +
     'NASCO_Acct_ID__c, Market_Segment_New__c, Contract_End_Date__c FROM Opportunity a WHERE ' +
     'recordTypeID IN :recordTypeIds' + 
     ' AND AccountID = :accountId' +
     ' AND Effective_Date__c <= TODAY ' +
     ' AND Contract_End_Date__c >= Today ' +
     ' AND StageName = \'Sold\' ' +
     ' AND System__c INCLUDES (\'Facets\',\'Nasco\')' +
     ' ORDER BY Effective_date__c DESC';

     List<Opportunity> opps = Database.query( opportunityQuery);
     if (opps.size() >= 1) {
        opportunity = opps.get(0);
        relatedRecords.put( String.valueOf(opportunity).split( ':')[0], String.valueOf(opps));
        System.debug('Related Opportunity details:'+ String.valueOf(opps));
    } else {
        // if no opportunities, the request cannot be built and an error message should be provided
        userErrorMessage = 'Account \'' + account.Name + '\' has no related Opportunities';
        userErrorMessage +=
        '<br/>This operation requires the Account to have at least one Opportunity that meets all these conditions:' +
        '<ul>' +
        '<li>  Opportunity Stage is SOLD </li>' +
        '<li>  Contract End Date is Today or in the Future </li>' +
        '<li>  Effective Date is Today or in the Past </li>' +
        '<li>  System is Facets or NASCO </li>' +
        '</ul>';
        userErrorMessage += 'Error Code=' + request.transactionID;
        
        String query =  opportunityQuery.replaceAll( ':accountId', accountId);
        technicalErrorMessage = ' Query: ' + query; 
        message= userErrorMessage + '\n' + technicalErrorMessage;
        
        System.debug( message );
        request.msgData = message;
        request.result = IntegrationMessage.STATUS_ERROR;
        
        // 2nd parameter in c.addError() tells it not to escape the message so we can use html tagsrequest.setIsValid(false);
        c.addError(userErrorMessage, false);    
        
        return request;
    }
         
                         
    request.setIsValid(requestDataComplete);
    
    } catch ( Exception e) {
     
     requestDataComplete = false;
     request.result = IntegrationMessage.STATUS_ERROR;
     
     request.setIsValid( requestDataComplete);
     c.addError( e.getMessage());
     return request;
    
    }
    // if Employer group portal check box is enabled we are sending following values 
    
    request.action =  contact.Employer_Group_Portal__c ?  EGPManageUserRequest.CREATE : EGPManageUserRequest.TERMINATE;
    
    request.contactFirstName = contact.FirstName;
    request.contactLastName = contact.LastName;
    request.contactEmail = contact.Email;
    request.accountName = account.Name;
    request.accountOwnerFirstName = account.Owner.FirstName;
    request.accountOwnerLastName = account.Owner.LastName;
    request.accountOwnerEmail =  account.Owner.Email;
    request.accountType = account.Type;
    request.opportunityFacets =opportunity.Facets_Grp_Num__c +':'+opportunity.NASCO_Acct_ID__c;
        
    // BEGIN ADD TPB 10/06/2015 
    // Format as YYYY-MM-DD
    DateTime EffectiveDate = Datetime.newInstance(Opportunity.Effective_Date__c.year(), Opportunity.Effective_Date__c.month(), Opportunity.Effective_Date__c.day());
    request.OpportunityEffectiveDate = EffectiveDate.format('yyyy-MM-dd');    
    // END ADD TPB 10/06/2015

    EGPServiceProxy.group_element ge=new EGPServiceProxy.group_element();

   if(opportunity.System__c != null && (opportunity.System__c).toLowerCase().contains('Nasco'.toLowerCase())) {
        ge.groupId=opportunity.NASCO_Acct_ID__c;
        ge.enrollmentPlatform ='Nasco';
    }else if(opportunity.System__c != null && (opportunity.System__c).toLowerCase().contains('Facets'.toLowerCase())) {
        ge.groupId=opportunity.Facets_Grp_Num__c;
        ge.enrollmentPlatform ='Facets';
    } 
        
    request.groups.add(ge);
    request.opportunitySystem = opportunity.System__c;
    request.opportunityEnrollmentPlatform = opportunity.Enrollment__c;
    
    // 12/16/14 - KG: Per clarification from EGP team, the business rules are ( From: Business analyst Sachin Kumar)
    // Self Funded = ASO = ASO Indicator=Y
    // Full Insured = Risk = ASO Indicator=N
    request.ASOIndicator = opportunity.Risk_Non_Risk__c == 'Risk' ? 'N' : 'Y';    
    
    // log actual request data that is sent in the EGP Request to the other side
    // BEGIN ADD TPB 10/06/2015 - added OpportunityEffectiveDate below
    request.msgData = 
    'action=' + request.action + 
    ',contactFirstName=' +  request.contactFirstName + 
    ',contactLastName=' + request.contactLastName +
    ',contactEmail=' +  request.contactEmail +
    ',accountName=' + request.accountName + 
    ',accountOwnerFirstName=' + request.accountOwnerFirstName + 
    ',accountOwnerLastName=' + request.accountOwnerLastName + 
    ',accountOwnerEmail=' + request.accountOwnerEmail + 
    ',accountType=' + request.accountType +
    ',opportunityFacets=' + request.opportunityFacets +
    ',groups=' + String.valueOf(request.groups) +
    ',opportunitySystem=' + request.opportunitySystem  +
    ',opportunityEnrollmentPlatform=' +request.opportunityEnrollmentPlatform  +
    ',VendorEffectiveDate=' + request.OpportunityEffectiveDate +    
    ',ASOIndicator=' +    request.ASOIndicator; 

    
    request.relatedData = String.valueOf( request.relatedRecords);  
    // IntegrationMessage stores relatedRecords as a String which is logged to Integration log
    
    
    request.result = IntegrationMessage.STATUS_SUCCESS; 
    return request;
}

@future (callout=true)
 public static void sendEGPManageUserRequestsInFuture( String serializedRequests) { 
    // rehydrate the request list from the serialized input string representation to type List<EGPManageUserRequest>
    List<EGPManageUserRequest> builtRequests = (List<EGPManageUserRequest>) JSON.deSerialize( serializedRequests, List<EGPManageUserRequest>.class);
    
    // send each request one at a time over the web service since the WS only supports single Contact at a time updates
    // This is not governor limit efficient.
    // TBD: Future enhancement - request multi-contact update interface on WS and update this implementation at that time.
    for( EGPManageUserRequest request: builtRequests) {
        EGPService.sendSingleEGPManageUserRequest( request);
    }
} 

public static void sendSingleEGPManageUserRequest( EGPManageUserRequest request) {
    
EGPManageUserResponse response = new EGPManageUserResponse(request);

try {
    EGPServiceProxy.SalesForceEndpoint1  service = EGPService.getService();
   
    EGPServiceProxy.manageUserResponse_element  proxyResponse = 
        service.ManageUser( EGPManageUserRequest.ENTITY_EMPLOYER,   // String constant. Web service always expects this fixed string
                EGPManageUserRequest.submittedById,                 // String constant. 
                request.action,                                     // CREATE or TERMINATE
                request.contactFirstName,
                request.contactLastName,
                request.contactEmail,
                request.accountName,
                request.groups,
                request.accountOwnerFirstName,
                request.accountOwnerLastName,
                request.accountOwnerEmail,
                request.opportunityEnrollmentPlatform,
                request.OpportunityEffectiveDate,
                request.ASOIndicator                
                );  
                
    response.status = IntegrationMessage.STATUS_SUCCESS;
    response.statusCode = proxyResponse.statusCode;
    response.statusDescription = proxyResponse.statusDescription;
    if( (response.statusCode).startsWith('Err') ) {
        sendEGPErrorNotification( request, response);
    }
    response.setIsValid(true);
    
    } catch (Exception e) {
    response.status = IntegrationMessage.STATUS_ERROR;
    response.statusCode = IntegrationMessage.REMOTE_ERROR;
    response.statusDescription = 'Exception type= ' + e.getTypeName() + ' , message= ' + e.getMessage();
    response.setIsValid(false);
    sendEGPErrorNotification(  request, response);
    }

    response.msgData = 'Remote response fields status=' + response.status + 
                        ', statusCode=' + response.statusCode + 
                        ', statusDescription= ' + response.statusDescription;
    response.relatedData = 'None.';
    
        // log request to integration log 
        // these calls need to happen after the web service callout to the external EGP portal system
        // otherwise you get an exception message "System.CalloutException: You have uncommitted work pending"
        // because integration log records have not been committed
    Integration.log (request);
    Integration.log( response);

}

// --------------------------------------------------------------------------------------------------------//
//                         EGP Account Update methods
//
// The EGP Portal Manage Account update web service accepts any changes made on either Account object or
// the newest SOLD related opportunitiy if one exists. This means that both the Account and Opportunity
// triggers are an entry point for invoking the Account update webservice.                                                
// --------------------------------------------------------------------------------------------------------// 

/*************************************************************************************
 * Purpose   : This method is called by the before insert/update AccountTriggerHandler and implements 
 *             business rules on Account object updates. 
 *             Currently this method is a future placeholder in case there is a requirement to validate before
 *             record updates are committed to the DB. 
 *
 * Parameters: None
 * Return    : None
 *************************************************************************************/

public static void validateSubmittedAccountUpdates() {
        // NOTE: cast needed if using Trigger.* outside Trigger definition
        List<Account> newAccountList = (List<Account>) Trigger.new;
        Map<Id,Account> oldAccountMap = (Map<Id,Account>) Trigger.oldMap;
        
        // Insert filter logic here
        // If none, the input new Account list is assigned to selectedAccounts list
        List<Account> selectedAccounts = newAccountList;
}


/*************************************************************************************
 * Purpose   : This method is called by the before insert/update OpportunityTriggerHandler and implements 
 *             business rules on Opportunity object updates. 
 *             Currently this method is a future placeholder in case there is a requirement to validate before
 *             record updates are committed to the DB. 
 *
 * Parameters: None
 * Return    : None
 *************************************************************************************/
public static void validateSubmittedOpportunityUpdates() {
        // NOTE: cast needed if using Trigger.* outside Trigger definition
        List<Opportunity> newOpportunityList = (List<Opportunity>) Trigger.new;
        Map<Id,Opportunity> oldOpportunityMap = (Map<Id,Opportunity>) Trigger.oldMap;
         // Insert filter logic here
        // If none, the input new Account list is assigned to selectedAccounts list
        List<Opportunity> selectedOpportunities = newOpportunityList;
}

/*************************************************************************************
 * Purpose   : This method is called by the after update AccountTriggerHandler. It accepts
 *             a list of Accounts that have updates and after the list is filtered for relevant
 *             Account updates by the buildEGPAccountUpdateRequestData() method, it serializes 
 *             the requests and schedules them for asynchronous (future call) execution via 
 *             EGPService.sendEGPAccountUpdateRequestsInFuture()
 *
 * Parameters: List<Account> accounts - the updated Account records
 *             Map<Id,Account> oldAccountsMap - this represents the Account records with values
 *             they were updated
 * Return    : None
 *************************************************************************************/

public static void processAccountUpdateChanges(List<Account> accounts, Map<Id,Account> oldAccountsMap) {
    List<Account> selectedAccounts = new List<Account>();
 
    Account oldAccount;
    for( Account a : accounts) {
            // Filter logic
          if(EGPService.hasEGPUpdate(a, oldAccountsMap.get(a.Id)))
            selectedAccounts.add(a);
        }
     system.debug('***seltd acconts'+selectedAccounts);
    List<EGPAccountUpdateRequest> builtRequests = EGPService.buildEGPAccountUpdateRequestData (selectedAccounts);
    system.debug('***reqs'+builtRequests.size());
    if(builtRequests.size() == 0)
        return;     // no relevant EGP updates to send

    // first use JSON library class to serialize the List of request objects since a future method can only accept arguments of primitive/List of primitive types
    String serializedList = JSON.serialize( builtRequests);

    // now send the Stringified built requests using an asynchronous future method
    // this is necessary because this code is executed in a Trigger context and makes web service callouts 
    // that are not allowed to be invoked synchronously. Doing so would generate an Exception
    EGPService.sendEGPAccountUpdateRequestsInFuture( serializedList);
}


/*************************************************************************************
 * Purpose   : This method takes a list of Account objects and shortlists those accounts for which
 *             a Sold opportunity exists.
 *             Given a list of accounts from a Trigger after update event, find the accounts that are associated with 
 *             an Opportunity in stage = 'Sold' and select the newest such Opportunity. Build an EGP account update request
 *             for every such <Account,Opportunity> pair
 *
 * Parameters: List<Accounts>
 * Return    : List<EGPAccountUpdateRequest>
 *************************************************************************************/

public static List<EGPAccountUpdateRequest> buildEGPAccountUpdateRequestData( List<Account> inputAccounts) {
    List<EGPAccountUpdateRequest> requests = new List<EGPAccountUpdateRequest>();
    EGPAccountUpdateRequest requestObject; 

    // Retrieve a map of all Accounts with Opportunities in stage='Sold' 
    // and select the newest effective date opportunity details limiting to one opportunity per account 
    // This uses a combination of a left outer join and left inner join
    // Each Account in the returned results list will have an Opportunities list with exactly 1 opportunity
    
    // Get record type 51+ Id to narrow search
    //String acct51recordTypeID = QueryBase.getRecordTypeID( 'Account', 'X51');
    //String opp51recordTypeID = QueryBase.getRecordTypeID( 'Opportunity', 'X51');

/*  
    Map<Id,Account> accountsWithNewestSoldOpportunityDB = new Map<Id,Account> (
            [ SELECT Id,
                     (SELECT Id, stageName, System__c, Risk_Non_Risk__c, FullServiceProducer__c, GeneralProducer__c, Enrollment__c 
                      FROM Opportunities WHERE recordTypeID = : opp51recordTypeID AND stageName='Sold' ORDER BY effective_date__c DESC LIMIT 1 
                     ) 
              FROM Account  
              WHERE recordTypeID = :acct51recordTypeID AND
                    Id IN 
                     (SELECT AccountID from Opportunity where recordTypeID = : opp51recordTypeID AND stageName='Sold'
                     ) 
            ]
            );
*/
    Set<Id> accountIdSet =  (new Map<Id,SObject>(inputAccounts)).keySet();
    List<String> opportunityRecordTypeIds = getRecordTypeIds('Opportunity');
    List<String> accountRecordTypeIds = getRecordTypeIds('Account');
    Map<Id,Account> accountsWithNewestSoldOpportunityDB = new Map<Id,Account> (
            [ SELECT Id, Name, Owner.FirstName, Owner.LastName, Owner.Email,
                     (SELECT Id, stageName, System__c, Risk_Non_Risk__c, FullServiceProducer__c, GeneralProducer__c, Enrollment__c, Facets_Grp_Num__c, NASCO_Acct_ID__c, Effective_Date__c 
                      FROM Opportunities WHERE recordTypeID IN :opportunityRecordTypeIds AND stageName='Sold' ORDER BY effective_date__c DESC LIMIT 1 
                     ) 
              FROM Account  
              WHERE recordTypeID IN :accountRecordTypeIds AND
                    Id IN :accountIdSet
            ]
            );
   system.debug('Num of acc'+accountsWithNewestSoldOpportunityDB);
    
    // From the inputAccounts shortlist those accounts which are in the accountsWithNewestSoldOpportunity for EGP Account update processing. 
    List<Account> filteredAccounts = new List<Account>();
    for(Account a : inputAccounts) {
        Account accountInDB = accountsWithNewestSoldOpportunityDB.get(a.Id);
        system.debug('Num of acc with opps'+accountInDB.Opportunities.size());
        if(    accountInDB <> NULL 
            && accountInDB.Opportunities <> NULL 
            && accountInDB.Opportunities.size() == 1) {
                // these next 3 lines are necessary because the trigger only gives parent id, not parent object (User/Owner) field details
                //a.Owner.FirstName = accountInDB.Owner.FirstName;
                //a.Owner.LastName = accountInDB.Owner.LastName;
                //a.Owner.Email = accountInDB.Owner.Email;
                // TEST disable - filteredAccounts.add(a);
                filteredAccounts.add(accountInDB);
        }
    }

    // Process filtered accounts to build an EGPAccountUpdateRequest    
    for( Account a: filteredAccounts) {
        // Get the related opportunity from the database not inputAccounts
        Opportunity relatedOpportunity = accountsWithNewestSoldOpportunityDB.get( a.Id).Opportunities[0];
        // if the related newest sold opportunity on this account doesn't pass business rules check for required fields, don't send
        if(! applyRules_EGP_OpportunityUpdate(relatedOpportunity) )
            continue;
        System.debug('Calling buildAccountUpdateRequestData with Account= ' + String.valueOf(a) + ', Opportunity=' + String.valueOf(relatedOpportunity)); 
        requestObject = buildEGPAccountUpdateRequestData(a, relatedOpportunity);   
        if( requestObject.isValid()) {
            requests.add( requestObject );
        } else {
            // there was an error in constructing the EGPAccountUpdateRequest
            System.debug('Error constructing EGPAccountUpdateRequest. Request data=' + String.valueOf(requestObject));
            // log to Integration log as input validation error
            Integration.log( requestObject);
        }
    }
    return requests;
}


/*************************************************************************************
 * Purpose   : This method is called by the after update OpportunityTriggerHandler. It accepts
 *             a list of Opportunities that have updates and after the list is filtered for relevant
 *             Opportunity updates by the buildEGPAccountUpdateRequestData() method, it serializes 
 *             the requests and schedules them for asynchronous (future call) execution via 
 *             EGPService.sendEGPAccountUpdateRequestsInFuture()
 *
 * Parameters: List<Opportunity> opportunities - the updated Opportunity records
 *             Map<Id,Opportunity> oldOpportunitiesMap - this represents the Opportunity record values
 *             before they were updated
 * Return    : None
 *************************************************************************************/


public static void processAccountOpportunityUpdateChanges(List<Opportunity> opportunities, Map<Id,Opportunity> oldOpportunitiesMap) {
    List<Opportunity> selectedOpportunities = new List<Opportunity>();
  system.debug('***old'+oldOpportunitiesMap);
     system.debug('***new'+opportunities);
    Opportunity oldOpportunity;
    for( Opportunity o : opportunities) {
            //
            // Insert any filter logic here
            //
            // if a new opportunity add it for processing
            if( oldOpportunitiesMap == null)
                selectedOpportunities.add(o);   
            // if update to an existing opportunity, check for EGP relevant changes
            if(oldOpportunitiesMap != null && EGPService.hasEGPUpdate(o, oldOpportunitiesMap.get(o.Id)))
                selectedOpportunities.add(o);
        }
    system.debug('**selectd opps'+selectedOpportunities);
    List<EGPAccountUpdateRequest> builtRequests = EGPService.buildEGPAccountUpdateRequestData (selectedOpportunities);
    system.debug('**build req'+builtRequests.size());
    if(builtRequests.size() == 0)
        return;     // no relevant EGP updates to send
        
    // first use JSON library class to serialize the List of request objects since a future method can only accept arguments of primitive/List of primitive types
    String serializedList = JSON.serialize( builtRequests);

    // now send the Stringified built requests using an asynchronous future method
    // this is necessary because this code is executed in a Trigger context and makes web service callouts 
    // that are not allowed to be invoked synchronously. Doing so would generate an Exception
    EGPService.sendEGPAccountUpdateRequestsInFuture( serializedList);
}


/**********************************************************************************************************************************************
 * Purpose   : This method takes a list of Opportunity objects and shortlists those Opportunities which
 *             correspond to a most current effective date Sold stage opportunity.
 *             a Sold opportunity exists.
 *
 *             The inputOpportunities are put through 2 filters to select candidates for EGPAccountUpdate processing:
 *              Filter 1: Select the stage SOLD opportunities in input list
 *              Filter 2: Compare effective date of input opportunity with newest sold opportunity effective date for same account in database.
 *                        Select if newer
 *
 *             The filtering results in the following:
 *                inputOpportunites filtered TO inputSoldOpportunities after applying Filter 1
 *                inputSoldOpportunities filtered TO inputNewestSoldOpportunities after applying Filter 2
 *                
 *             The inputNewestSoldOpportunities and related Account details (from database) are then used to construct
 *             EGPAccountUpdate requests
 *
 * Parameters: List<Opportunity> - the list of opportunity records that have updates on them
 * Return    : List<EGPAccountUpdateRequest> - request objects for those opportunities that pass filter 1 & 2
 ************************************************************************************************************************************************/

public static List<EGPAccountUpdateRequest> buildEGPAccountUpdateRequestData( List<Opportunity> inputOpportunities) {
    List<EGPAccountUpdateRequest> requests = new List<EGPAccountUpdateRequest>();
    EGPAccountUpdateRequest requestObject; 
    
        // Filter 1: Select input opportunities that are 'Sold'
    List<Opportunity> inputSoldOpportunities = new List<Opportunity>();
    for( Opportunity o : inputOpportunities) {
        System.debug('input opportunity=======' + String.valueOf(o));
        // check if input opportunity passes all business rules for sending as EGP update
        if( applyRules_EGP_OpportunityUpdate(o) ) 
                // add this to the list of opportunities for which EGP update should be sent 
            inputSoldOpportunities.add(o);  
    }
    
    if(inputSoldOpportunities.size() == 0) return requests; // return empty list if no Sold opportunities
    
    // Filter 2: Select input opportunities only if they have the most recent effective date
    // Algorithm:
    // 1. Retrieve account details map for every account in database that has an opportunity with stageName='Sold' and most current effective date 
    // 2. Build related maps:  OpportunityID=>Account, OpportunityID => Opportunity
    // Note: Opportunity details are already available in input list, so only the opportunity ID and Effective_Date__c is retreived from DB for comparison purposes)
    
    // Retrieve account details map from DB for accounts with sold opportunities 
    // The following query combines a left outer join and right inner join
    // This map contains opportunity related Account Details which are used to provide Account object when calling buildEGPRequestData()
    
    //String acct51recordTypeID = QueryBase.getRecordTypeID( 'Account', 'X51');
    //String opp51recordTypeID = QueryBase.getRecordTypeID( 'Opportunity', 'X51');
    List<String> opportunityRecordTypeIds = getRecordTypeIds('Opportunity');
    List<String> accountRecordTypeIds = getRecordTypeIds('Account');
    
    Set<Id> accountIdSet = new Set<Id>();
    for( Opportunity o : inputSoldOpportunities) 
        accountIdSet.add( o.AccountID);
    
    Map<Id, Account> accountDetailsByAccountIDFromDBMap = new Map<Id,Account> (
        [  
        SELECT Id, Name, Owner.FirstName, Owner.LastName,Owner.Email,
        (SELECT Id, Effective_Date__c
                FROM Opportunities where recordTypeID IN :opportunityRecordTypeIds AND stageName = 'Sold' ORDER BY Effective_Date__c DESC LIMIT 1)
        FROM Account  
        WHERE recordTypeID IN :accountRecordTypeIds AND
              Id IN :accountIdSet
        ]
        ); 
    
/* OLD Governor limited code    
    Map<Id, Account> accountDetailsByAccountIDFromDBMap = new Map<Id,Account> (
        [  
        SELECT Id, Name, Owner.FirstName, Owner.LastName,Owner.Email,
        (SELECT Id, Effective_Date__c
                FROM Opportunities where stageName = 'Sold' ORDER BY Effective_Date__c DESC LIMIT 1)
        FROM Account  
        WHERE Id IN 
                     (SELECT AccountID from Opportunity where stageName='Sold'
                     ) 
        ]
        ); 
*/
    
    // THe following 2 maps are used in the filter logic for selecting  input opportunities for EGPAccountUpdate processing
    // Build related maps based on retrieved DB Map<Account.Id, Account> (accountDetailsByAccountIDFromDBMap).
    // Build Map<Opportunity.Id, Account>  (opportunityToAccountFromDBMap) which includes only opportunities that are stage=Closed and most recent effective date 
    Map<Id, Account> opportunityToAccountFromDBMap = new Map<Id, Account>();
    Map<Id,Opportunity> newestSoldOpportunityByAccountIdFromDBMap = new Map<Id, Opportunity>();
    for( Account a : accountDetailsByAccountIDFromDBMap.values()) {
       if( a.Opportunities.size() > 0) {    // only insert if the account had one qualifying opportunity in stage=SOLD
        opportunityToAccountFromDBMap.put( a.Opportunities[0].Id, a);
        newestSoldOpportunityByAccountIdFromDBMap.put( a.Id, a.Opportunities[0]);
        }
    }

    // Filter input opportunity list by only keeping opportunities that represent the most current sold opportunity on an account
    // Algorithm:
    // Search for input opportunity Id in the map : newestSoldOpportunityToAccountMapFrom DB 
    // if found, then the input opportunity is the latest sold for it's account and selected
    
    // Compare the input opportunity effective date with effective date of database newest sold opportunity on same account
    List<Opportunity> inputNewestSoldOpportunities = new List<Opportunity>();   
    for( Opportunity opp : inputSoldOpportunities) {
       Opportunity newestOpportunityInDB = newestSoldOpportunityByAccountIdFromDBMap.get(opp.AccountId);
 
       if( newestOpportunityInDB <> null && opp.Id == newestOpportunityInDB.Id)
          inputNewestSoldOpportunities.add(opp);
          
            // input opportunity has become newest sold opp. in that account because its effective date is more recent than existing newest sold opp in database 
       if( newestOpportunityInDB <> null  && opp.Effective_Date__c > newestOpportunityInDB.Effective_Date__c)
            inputNewestSoldOpportunities.add(opp);
    }
    
        
    // Now build the EGPAccountUpdate requests
    for(Opportunity opp: inputNewestSoldOpportunities) {
        System.debug('XXXXX opp=' + String.valueOf(opp)); 
        Account relatedAccount = opportunityToAccountFromDBMap.get(opp.Id);
        requestObject = EGPService.buildEGPAccountUpdateRequestData(relatedAccount,opp);
        if( requestObject.isValid()) {
            requests.add(requestObject);
        } else {
            // there was an error in constructing the EGPAccountUpdateRequest
            System.debug('Error constructing EGPAccountUpdateRequest. Request data=' + String.valueOf(requestObject));
            // log to Integration log as input validation error
            Integration.log( requestObject);            
        }
    }
    return requests;
}

/*
public static Opportunity getLatestSoldOpportunityByEffectiveDateForAccount( Account a) {
    List<Opportunity> opps = [ select Id from Opportunity where stageName = 'Sold' AND Account.ID = :account.Id ORDER BY Effective_Date__c DESC];
    return opps[0]; 
    
}

public static Opportunity findNewestSoldOpportunityByEffectiveDate( Account account) {
    // Include needed fields from Opportunity record
    List<Opportunity> opps = [ select Id from Opportunity where stageName = 'Sold' AND Account.ID = :account.Id ORDER BY Effective_Date__c DESC];
    return opps[0]; 
}

public static Boolean findNewestSoldOpportunityByEffectiveDate( Opportunity o) {
    List<Opportunity> opps = [ select Id from Opportunity where stageName = 'Sold' AND Account.ID = o.Account.ID ORDER BY Effective_Date__c DESC LIMIT 1];
    return opps[0]; 
}

public static Boolean isNewestSoldOpportunity( Opportunity o) {
    List<Opportunity> opps = EGPService.findNewestSoldOpportunityByEffectiveDate(o);
    // if there are no previously sold opportunities and this one is Sold, then this is the newest sold opportunity
    if( opps.size() == 0  && o.stageName == 'Sold') return true;
    // if there are other sold opportunities that exist and the input opportunity id is same as newest one by effective date in existing opps, then it is the newest one sold
    return opps[0].Id == o.Id ? true: false;    
}
*/

/*************************************************************************************
 * Purpose   : This method takes a Account, Opportunity pair. This method assumes that 
 *             The calling code ensures the pair represents an Account and the newest 
 *             (most recent) effective date Sold stage opportunity.
 *           
 *             The method picks fields from Account and Opportunity corresponding to the 
 *             the fields required to build an EGP account update request per the IAD (Interface
 *             Agreement Document) specification.
 *
 * Parameters: Account - the candidate account
 *             Opportunity - the candidate opportunity record
 *
 * Return    : List<EGPAccountUpdateRequest> - the composite request object that has the right 
 *             fields populated from the input Account, Opportunity objects
 *************************************************************************************/
 
public static EGPAccountUpdateRequest buildEGPAccountUpdateRequestData(Account account, Opportunity opportunity) {
    
    System.debug('Input account=' + String.valueOf(account) + ',   Input opportunity=' + String.valueOf(opportunity));
    EGPAccountUpdateRequest request = new EGPAccountUpdateRequest();
    
    // query related records and populate request fields
    Map<String,String> relatedRecords = new Map<String,String>();
    request.relatedRecords = relatedRecords;
    request.relatedRecords.put( 'Account',  String.valueOf(account));
    request.relatedRecords.put( 'Opportunity' , String.valueOf(opportunity));
    
    request.action =  EGPAccountUpdateRequest.UPDATE_ACTION;
    
    // insert account update fields
    request.accountName = account.Name;
    request.accountOwnerFirstName = account.Owner.FirstName;
    request.accountOwnerLastName = account.Owner.LastName;
    request.accountOwnerEmail =  account.Owner.Email;
    
    // insert opportunity update fields
    EGPServiceProxy.group_element ge=new EGPServiceProxy.group_element();
    if(opportunity.System__c != null && (opportunity.System__c).toLowerCase().contains('Nasco'.toLowerCase())){
        ge.groupId=opportunity.NASCO_Acct_ID__c;
        ge.enrollmentPlatform ='Nasco';
    }else {
        ge.groupId=opportunity.Facets_Grp_Num__c;
        ge.enrollmentPlatform ='Facets';
    }
    request.groups.add(ge);

    // 12/16/14 - KG: Per clarification from EGP team, the business rules are ( From: Business analyst Sachin Kumar)
    // Self Funded = ASO = ASO Indicator=Y
    // Full Insured = Risk = ASO Indicator=N
    request.ASOIndicator = opportunity.Risk_Non_Risk__c == 'Risk' ? 'N' : 'Y';
    request.fspName = opportunity.FullServiceProducer__c;
    request.gpName = opportunity.GeneralProducer__c;
    request.opportunityEnrollmentPlatform = opportunity.Enrollment__c;
    
    
    // BEGIN ADD TPB 10/06/2015 
    // Format as YYYY-MM-DD
    DateTime EffectiveDate = Datetime.newInstance(Opportunity.Effective_Date__c.year(), Opportunity.Effective_Date__c.month(), Opportunity.Effective_Date__c.day());
    request.OpportunityEffectiveDate = EffectiveDate.format('yyyy-MM-dd');    
    // END ADD TPB 10/06/2015  
    
    
    // log actual request data that is sent in the EGP Request to the other side
    request.msgData = 
    'action=' + request.action + 
    ',accountName=' + request.accountName + 
    ',accountOwnerFirstName=' + request.accountOwnerFirstName + 
    ',accountOwnerLastName=' + request.accountOwnerLastName + 
    ',accountOwnerEmail=' + request.accountOwnerEmail + 
    ',groups=' + String.valueOf(request.groups) +   
    ',ASOIndicator=' +    request.ASOIndicator +    
    ',fspName=' + request.fspName +
    ',gpName=' + request.gpName +
    ',opportunityEnrollmentPlatform=' +request.opportunityEnrollmentPlatform + 
    ',opportunityEffectiveDate=' + request.OpportunityEffectiveDate;
    
    request.relatedData = String.valueOf( request.relatedRecords);  
    // IntegrationMessage stores relatedRecords as a String which is logged to Integration log
    
    
    request.result = IntegrationMessage.STATUS_SUCCESS; 
    return request;
}




/*************************************************************************************
 * Purpose   : This is a future (asynchronous) method which allows the Account and 
 *             Opportunity after update trigger events to communicate updates to the 
 *             external EGP portal system. The method receives EGPAccountUpdateRequest objects 
 *             that have been serialized using JSON.serialize() (since future methods can 
 *             only except primitive data types not Objects). It then converts the serialized
 *             objects back into first class objects using the complementary JSON.deSerialize 
 *             method. Once the original objects are rehydrated, it loops over them sending 
 *             out one request via the single request version of the same method (which in 
 *             turn calls out using the EGPServiceProxy). 
 *
 * Parameters: String - serialized version of List<EGPAccountUpdateRequest> object
 * Return    : None
 *************************************************************************************/


@future (callout=true)
 public static void sendEGPAccountUpdateRequestsInFuture( String serializedRequests) {  
    // rehydrate the request list from the serialized input string representation to type List<EGPManageUserRequest>
    List<EGPAccountUpdateRequest> builtRequests = (List<EGPAccountUpdateRequest>) JSON.deSerialize(serializedRequests, List<EGPAccountUpdateRequest>.class);
    
    // send each request one at a time over the web service since the WS only supports single Contact at a time updates
    // This is not governor limit efficient.
    // TBD: Future enhancement - request multi-contact update interface on WS and update this implementation at that time.
    for( EGPAccountUpdateRequest request: builtRequests) {
        EGPService.sendSingleEGPAccountUpdateRequest(request);
    }
} 

/*************************************************************************************
 * Purpose   : This is a utility method which supports the sendEGPAccountUpdateRequest(String 
 *             serializedrequests method and it's key function is to call the EGPPortal web service
 *             via the EGPServiceProxy class. It takes care of setting up the actual request element
 *             in the format expected by EGPServiceProxy. The EGPServiceProxy class itself is generated
 *             from WSDL using the WSDL2Apex feature of Salesforce which creates Apex stub classes to
 *             enscapsulate the SOAP level marshalling/unmarshalling of inputs and outputs.
 *
 *
 * Parameters: EGPAccountUpdateRequest - the callout request data object
 * Return    : None
 *************************************************************************************/
public static void sendSingleEGPAccountUpdateRequest( EGPAccountUpdateRequest request) {
EGPAccountUpdateResponse response = new EGPAccountUpdateResponse(request);
try {
    EGPServiceProxy.SalesForceEndpoint1  service = EGPService.getService();
    EGPServiceProxy.accountUpdateResponse_element  proxyResponse = 
        service.AccountUpdate(
                EGPManageUserRequest.ENTITY_EMPLOYER,   // String constant. Web service always expects this fixed string
                EGPManageUserRequest.submittedById,     // String constant. 
                request.action,                         // UPDATE
                request.accountName,
                request.groups,
                request.ASOIndicator,
                request.fspName,
                request.gpName,
                request.accountOwnerFirstName,
                request.accountOwnerLastName,
                request.accountOwnerEmail,
                request.opportunityEnrollmentPlatform,
                request.OpportunityEffectiveDate
                );
                            
    response.status = IntegrationMessage.STATUS_SUCCESS;
    response.statusCode = proxyResponse.statusCode;
    response.statusDescription = proxyResponse.statusDescription;
    if( (response.statusCode).startsWith('Err') ) {
        sendEGPErrorNotification( request, response);
    }
    response.setIsValid(true);
    
    } catch (Exception e) {
    response.status = IntegrationMessage.STATUS_ERROR;
    response.statusCode = IntegrationMessage.REMOTE_ERROR;
    response.statusDescription = 'Exception type= ' + e.getTypeName() + ' , message= ' + e.getMessage();
    response.setIsValid(false);
    sendEGPErrorNotification(  request, response);  // TODO - update for Account  updates
    }

    response.msgData = 'Remote response fields status=' + response.status + 
                        ', statusCode=' + response.statusCode + 
                        ', statusDescription= ' + response.statusDescription;
    response.relatedData = 'None.';
    
    // log request to integration log 
    // these calls need to happen after the web service callout to the external EGP portal system
    // otherwise you get an exception message "System.CalloutException: You have uncommitted work pending"
    // because integration log records have not been committed
    Integration.log (request);
    Integration.log( response);
}

    // -----------------------------------------------------------------------//
    //                         Utility support methods                                                
    // -----------------------------------------------------------------------// 

/*************************************************************************************
 * Purpose   : This is a utility method that consolidates some common setup code to get 
 *             a callable EGPServiceProxy endpoint. It returns an instance of the web service callout
 *             EGPServiceProxy endpoint - SalesForceEndpoint1(). It takes care of configuring EGP
 *             specific parameters like the endpoint URL (which varies by environment), client certificate
 *             name to use etc. 
 *             The returned service callout object is used by the higher level methods.
 *
 *
 * Parameters: None
 * Return    : EGPServiceProxy.SalesForceEndpoint1
 *************************************************************************************/
/**public static EGPServiceProxy.SalesForceEndpoint1 getService() {
    EGPServiceProxy.SalesForceEndpoint1  service = new EGPServiceProxy.SalesForceEndpoint1();
    
    if(!EGPService.isInitialized) {  
        throw new EGPService.EGPException('EGPService is not initialized'); 
    }
    
    String clientCertificateName = EGPService.egpClientCertificateName;
    String endPointURL = EGPService.egpEndPointURL;
    // TBD: Need to provide error checking to guard againstt invalid egpRequestTimeout values e.g. non numeric 'quarter' 
    // entered on EnvironmentVariables UI editor screen - KG 2.5.15
    Integer requestTimeout = Integer.valueof(EGPService.egpRequestTimeout);
    System.debug('Using EGPService web service settings: egpClientCertificateName=' + clientCertificateName + ', egpRequestTimeout=' + requestTimeout + ', egpEndPointURL=' + endPointURL);
    
    service.clientCertName_x = clientCertificateName;
    service.timeout_x = requestTimeout;
    service.endpoint_x = endPointURL;
    return service;
}**/
/*************************************************************************************
 * Purpose   : This is a utility method that consolidates some common setup code to get 
 *             a callable EGPServiceProxy endpoint. It returns an instance of the web service callout
 *             EGPServiceProxy endpoint - SalesForceEndpoint1(). It takes care of configuring EGP
 *             specific parameters like the endpoint URL (which varies by environment), client certificate
 *             name to use etc. 
 *             The returned service callout object is used by the higher level methods.
 *
 *
 * Parameters: None
 * Return    : EGPServiceProxy.SalesForceEndpoint1
 *************************************************************************************/
//T01 START
 public static EGPServiceProxy.SalesForceEndpoint1 getService() {
    EGPServiceProxy.SalesForceEndpoint1  service = new EGPServiceProxy.SalesForceEndpoint1();
    
    if(!EGPService.isInitialized) {  
        throw new EGPService.EGPException('EGPService is not initialized'); 
    }
    
    String endPointURL = 'callout:Brokerhub_EGP_Integrations';
    
        Integer requestTimeout;
        try {
         requestTimeout = Integer.valueof(EGPService.egpRequestTimeout);
        } catch (Exception e) {
        System.debug('Error processing timeout value=' + EGPService.egpRequestTimeout + ': defaulting to 50000 (50 seconds)');
        requestTimeout = 50000;
    }
    
    service.timeout_x = requestTimeout;
    service.endpoint_x = endPointURL;
    return service;
}
//T01 END 


public static boolean hasEGPUpdate(Account newA, Account oldA) {
    if ( newA == null || oldA == null) {    // invalid input trapping
      System.debug('EGPService.hasEGPUpdate: Received null new or old Account');
      return false;
        }

    String newKey = newA.Name + '-' + newA.OwnerId;
    if( newA.Owner!= null) 
        newKey = newKey + '-' + newA.Owner.FirstName + '-' + newA.Owner.LastName + '-' + newA.Owner.Email;
        
    String oldKey = oldA.Name + '-' + oldA.OwnerId;
    if( oldA.Owner!= null) 
        oldKey = oldKey + '-' + oldA.Owner.FirstName + '-' + oldA.Owner.LastName + '-' + oldA.Owner.Email;

    Boolean isChanged = !newKey.equals(oldKey);
    if( isChanged) 
        System.debug('EGPService.hasEGPUpdate: egp related change detect. new Account=' +newKey +
                             '    old Account string key=' + oldKey);
    return isChanged;
}


public static boolean hasEGPUpdate(Opportunity newO, Opportunity oldO) {
    if ( newO == null || oldO == null) {    // invalid input trapping
      System.debug('EGPService.hasEGPUpdate: Received null new or old Opportunity');
      return false;
        }

    String newKey = newO.System__c + '-' + newO.NASCO_Acct_ID__c + '-' + newO.Facets_Grp_Num__c + '-' + 
            newO.Risk_Non_Risk__c + '-' + newO.FullServiceProducer__c + '-' + 
            newO.GeneralProducer__c + '-' + newO.Enrollment__c;

    String oldKey = oldO.System__c + '-' + oldO.NASCO_Acct_ID__c + '-' + oldO.Facets_Grp_Num__c + '-' + 
            oldO.Risk_Non_Risk__c + '-' + oldO.FullServiceProducer__c + '-' +
            oldO.GeneralProducer__c + '-' + oldO.Enrollment__c;

        Boolean isChanged = !newKey.equals(oldKey);
    if( isChanged) 
        System.debug('EGPService.hasEGPUpdate: egp related change detect. new Opportunity=' +newKey +
                             '    old Opportunity string key=' + oldKey);
    return isChanged;
}

/*************************************************************************************
 * Purpose   : This is a utility method Apply business rules to check an opportunity 
 *             to be a NASCO or Facets opportunity with a non-blank group #.
 *             
 *
 * Parameters: Opportunity - the opportunity object to which the rule is to be applied
 *             
 * Return    : Boolean. Returns true if the opportunity satisfies the business rule otherwise false
 *************************************************************************************/

// 
public static boolean applyRules_EGP_OpportunityUpdate( Opportunity o) {
    // Rule: Input check - opportunity object cannot be null
    if( o == null) 
        return false;
    // Rule: Stage must be Sold 
    if( o.stageName != 'Sold') {
        System.debug('Business Rule Check Failed: EGP Update -  Opportunity must be in stage=SOLD, opportunit=' + o); 
        return false;   
    }
    // Rule: System should not be blank
    String systemName = o.System__c;
    if( String.isBlank(o.System__c)) {
        System.debug('Business Rule Check Failed: EGP Update - System__c cannot be blank');
        return false;
    }   
    // Rule: System should be NASCO or Facets. Other System values should not be sent   
    Boolean isNASCO = systemName.toLowerCase().contains('Nasco'.toLowerCase());
    Boolean isFacets = systemName.toLowerCase().contains('Facets'.toLowerCase());
    if( !( isNASCO || isFacets)) {
        System.debug('Business Rule Check Failed: EGP Update - System__c should be NASCO or Facets');
        return false;               
    }
    // Rule: Group Id cannot be blank
    if( isNASCO && String.isBlank(o.NASCO_Acct_ID__c)) {
        System.debug('Business Rule Check Failed: EGP Update : Do not send EGP update if system=NASCO and NASCO Group ID is blank. Opportunity=' + String.valueOf(o));
        return false; 
    } 
    // Rule: Group Id cannot be blank
    if( !isNASCO && isFacets && String.isBlank(o.Facets_Grp_Num__c)) {
        System.debug('Business Rule Check Failed: EGP Update : Do not send EGP update if system = FACETS and Facets Group ID is blank. Opportunity=' + String.valueOf(o));
        return false; 
    }
    
    // All business rule checks passed
     return true;
}


/*************************************************************************************
 * Purpose   : This is a utility method for sending out error email notifications related to 
 *             EGPManageUser requests. It uses fields from the request and response objects to
 *             compose the message.
 *             
 *
 * Parameters: EGPManageUserRequest, EGPManageUserResponse - the request, response objects of the
 *             failing transaction
 * Return    : None
 *************************************************************************************/

public static void sendEGPErrorNotification(EGPManageUserRequest request, EGPManageUserResponse response)  {
    String subject = 'Employer Group Portal User Provisioning Error';
    String bodyText = 
    '\n The Employer Group Portal did not process the following EGP provisioning request:' +
    '\n Request = ' + String.ValueOf( request) + 
    '\n Response= ' + String.ValueOf( response);
    EGPService.sendEGPErrorNotification(subject,bodyText); 
}

/*************************************************************************************
 * Purpose   : This is a utility method for sending out error email notifications related to 
 *             EGPAccountUpdate requests. It uses fields from the request and response objects to
 *             compose the message.
 *             
 *
 * Parameters: EGPAccountUpdateRequest, EGPAccountUpdateResponse - the request, response objects of the
 *             failing transaction
 * Return    : None
 *************************************************************************************/

public static void sendEGPErrorNotification(EGPAccountUpdateRequest request, EGPAccountUpdateResponse response) {
    String subject = 'Employer Group Portal Account Update Error';
    String bodyText = 
    '\n The Employer Group Portal did not process the following EGP Account Update request:' +
    '\n Request = ' + String.ValueOf( request) + 
    '\n Response= ' + String.ValueOf( response);
    EGPService.sendEGPErrorNotification(subject,bodyText); 
    
}

/*************************************************************************************
 * Purpose   : General purpose email send method
 *             
 *
 * Parameters: String subject - subject line of message
 *             String bodyText - message text
 *
 * Return    : None
 *************************************************************************************/

public static void sendEGPErrorNotification(String subject, String bodyText) {

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String supportEmail = EGPService.egpSFDCSupportEmailAddress;    // default value in case nothing is configured in EnvironmentVariable__c
    String egpPortalEmail = EGPService.egpPortalSupportEmailAddress;
    
        // if Environment Variables have been set, use those for email addresses
        // useful for overriding in different environments  
    if(String.isNotBlank(EGPService.egpSFDCSupportEmailAddress)) 
          supportEmail = EGPService.egpSFDCSupportEmailAddress; 
          
    if(String.isNotBlank(EGPService.egpPortalSupportEmailAddress))
         egpPortalEmail = EGPService.egpPortalSupportEmailAddress;
    
    
    mail.setToAddresses(new String[] {supportEmail, egpPortalEmail});
    mail.setReplyTo(supportEmail);
    mail.setBccAddresses(new String[] {supportEmail});
    mail.setSenderDisplayName('CareFirst Salesforce System');
    mail.setSubject(subject);
                           
    mail.setPlainTextBody(bodyText);
    // send email
    Messaging.SendEmailResult[] emailresult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    system.debug(emailresult);
    
}

    // This method returns a list of the recordType Ids to be used in SELECT queries. It is a way to encapsulate
    // AIA (or future) related changes which added a new recodtype 'AIA_200' by splitting the 'X51' record type
public static List<String> getRecordTypeIds( String sObjectType ) {
    List<String> rtIdList = new List<String>();
    if('Account'.equals(sObjectType)) {
        rtIdList.add(QueryBase.getRecordTypeID( 'Account', 'X51'));             
    }
    if('Contact'.equals(sObjectType)) {
        rtIdList.add(QueryBase.getRecordTypeID( 'Contact', 'X51'));                 
    }
    if('Opportunity'.equals(sObjectType)) {
        rtIdList.add(QueryBase.getRecordTypeID( 'Opportunity', 'X51'));
        rtIdList.add(QueryBase.getRecordTypeID( 'Opportunity', 'AIA_200'));                     
    }   
    return rtIdList;
}

}  // end class