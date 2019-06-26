/*=========================================================================================
 * Date     : 11/6/15
 * Developer    : Ken Gill
 * Purpose      :  
 * 
 * This class provides the main entry point for the Facets integration functionality 
 * for the rest of the application. It supports 4 main use cases - 1) Creating a Facets Case,
 * 2) Updating a Facets case based on changes to the Salesforce record 3) Processing 
 * Updates from Facets to the local Salesforce case record and 4) Loading the integration 
 * config parameters from EnvironmentVariables__c custom object.
 * 
 * 
 * 
 * The Facets case id is the common linking ID field that ties the Salesforce and Facets
 * records for a Case. The Facets updates include the Facets Case Id to identify the record to 
 * be updated. The Salesforce outbound messages also use Facets Case Id to identify the case 
 * in Facets.
 * 
 * UC1: Create Facets Case is triggered from the Submit To Facets button click on the Case
 * detail page view for cases sent as Open (Routed to Facets). For local (94%) cases, the 
 * CreateCase method is invoked via CaseTriggerHandler when a SF Case is closed.
 * 
 * UC2: Update Facets case is invoked via trigger CaseTriggerHandler after update event.
 * UC3: Process Updates from Facets is triggered when the SOAP API receives a Case update 
 * which invokes the CaseHandlerTrigger/CaseCommentHandler triggers 
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/6/15   |  KG    | Initial Version                                         
 *           |        | 
 * 11/15/16  |  KG    | Updated method handleCaseUpdate at line 592 - method handleCaseUpdate() - to use recordFlagging in a 
 *           |        | trigger recursion scenario (trigger fires,then workflow fires trigger again). This was
 *           |        | The trigger recursion caused a production issue where a future call to createFacetsCase was sent
 *           |        | twice causing duplication Facets cases to be created for a single SF case.
 *           |        | The solution uses a static map to mark records already processed in the same transaction
 *           |        | /trigger context and the logic is encapsulated in the trigger framework base class TriggerHandler.cls. 
 *  2/3/2018  |  Sree Uma Ponnoju  |US616-Added API Gateway change using Named Credential         |        | 
 *=========================================================================================
 */

public with sharing class FCI_FacetsService {

public class FCI_Exception extends Exception {}

//US616-Deprecated variables related to username/password/cert as part of Named credentials implementation
/*public static String fciUserName = '';
public static String fciUserPassword = '';
public static String fciClientCertificateName;*/
//US616-END CHANGE
public static String fciEndPointURL;
public static String fciRequestTimeout = '120000';
public static String fciSFDCSupportEmailAddress = 'kirat.gill@carefirst.com';
public static String fciFacetsSupportEmailAddress = 'kirat.gill@carefirst.com';

public static Boolean isInitialized = false;

public static String environmentModuleName = 'FCI Integration';
public static String environmentCommonModuleName = 'Common';
public static String environmentVariableName_fciSFDCSupportEmailAddress = 'SFDC_Support_Email';
public static String environmentVariableName_fciFacetsSupportEmailAddress = 'FCI_Support_Email';
public static String environmentVariableName_fciRequestTimeout = 'RequestTimeout';
//US616-Deprecated environment variables related to username/password/url/cert as part of Named credentials implementation
/*public static String environmentVariableName_fciEndPointURL = 'FCI_EndPoint';
public static String environmentVariableName_fciClientCertificateName = 'FCI_ClientCertificateName';
public static String environmentVariableName_fciUserName = 'FCI_UserName';
public static String environmentVariableName_fciUserPassword = 'FCI_UserPassword';*/
//US616 END Change
public static List<String> environmentVariableNames = new List<String>();

public static Map<String,String> facetsSubjectCodeToPicklistMapping = null;
public static Map<String,String> facetsCategoryCodeToPicklistMapping = null;
   


// one time initialization block when FCI_FacetsService class is first loaded
static {
    System.debug('FCI_FacetsService: static initializer block loading');
    FCI_FacetsService.environmentModuleName = 'FCI Integration';
    FCI_FacetsService.environmentVariableNames = new List<String>();
    FCI_FacetsService.environmentVariableNames.add ( FCI_FacetsService.environmentVariableName_fciSFDCSupportEmailAddress );
    FCI_FacetsService.environmentVariableNames.add ( FCI_FacetsService.environmentVariableName_fciFacetsSupportEmailAddress );
    FCI_FacetsService.environmentVariableNames.add ( FCI_FacetsService.environmentVariableName_fciRequestTimeout );
    //US616-Deprecated environment variables related to username/password/url/cert as part of Named credentials implementation
    /*FCI_FacetsService.environmentVariableNames.add ( FCI_FacetsService.environmentVariableName_fciUserName);
    FCI_FacetsService.environmentVariableNames.add ( FCI_FacetsService.environmentVariableName_fciUserPassword);
    FCI_FacetsService.environmentVariableNames.add ( FCI_FacetsService.environmentVariableName_fciEndPointURL );
    FCI_FacetsService.environmentVariableNames.add ( FCI_FacetsService.environmentVariableName_fciClientCertificateName );*/
    //US616-END Change                                                     
    FCI_FacetsService.loadConfigurationFromEnvironmentVariables();
    
    // Static initializer for Facets Subject and Category code to picklist value mappings
    if( facetsSubjectCodeToPicklistMapping == null) {
        facetsSubjectCodeToPicklistMapping = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = Case.Facets_Subject__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pe : ple) {
            facetsSubjectCodeToPicklistMapping.put( pe.getValue().subString(0,4), pe.getValue());
        } 
    }
    
    if( facetsCategoryCodeToPicklistMapping == null) {
        facetsCategoryCodeToPicklistMapping = new Map<String,String>();
        DescribeFieldResult fieldResult2 = Case.Facets_Category__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        for( Schema.PicklistEntry pe : ple2) {
            facetsCategoryCodeToPicklistMapping.put( pe.getValue().subString(0,4), pe.getValue());
        } 
    }           
}   // end static initializer
    

/*************************************************************************************
 * Purpose   : This method loads FCI integration related configuration variables when either: 
 *             1. This class is first loaded and automatically called from the static initializer block  
 *             2. OR when the FCI configuration settings are modified through the EnvironmentVariables tab which 
 *             triggers EnvironmentVariableTrigger which calls this method to reload env vars.
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
public static void loadConfigurationFromEnvironmentVariables() {
    
    System.debug('Loading FCI_FacetsService environment variables');    
    Map<String, EnvironmentVariable__c> envVarMap = new Map<String,EnvironmentVariable__c>();
    EnvironmentVariables.getEnvironmentVariablesForModule(FCI_FacetsService.environmentModuleName, envVarMap);
    EnvironmentVariables.getEnvironmentVariablesForModule(FCI_FacetsService.environmentCommonModuleName, envVarMap);
    
    if(envVarMap.isEmpty()) {
        System.debug('Error: No FCI related environment variables configured in EnvironmentVariable__c table. Retrieved envVarMap=' + String.valueOf(envVarMap));
        FCI_FacetsService.isInitialized = false;
        return;
    }
    String value;
    //US616-Deprecated as part of Named credentials implementation     
    /*String value =  (envVarMap.get(FCI_FacetsService.environmentVariableName_fciEndPointURL)).Value__c;
    if(String.isNotBlank(value)) { FCI_FacetsService.fciEndPointURL = value;}
    FCI_FacetsService.fciEndPointURL = 'https://servicestt.carefirst.com/SITBFSI/eProxy/service/Facets-SalesForce';  //AG
    System.debug( 'fciEndPointURL=' + value);
    
    value = (envVarMap.get(FCI_FacetsService.environmentVariableName_fciClientCertificateName)).Value__c;
    if( String.isNotBlank(value)) FCI_FacetsService.fciClientCertificateName = value;
    System.debug( 'fciClientCertificateName=' + value);
    
    value = (envVarMap.get(FCI_FacetsService.environmentVariableName_fciUserName)).Value__c;
    if( String.isNotBlank(value)) FCI_FacetsService.fciUserName = value;
    System.debug( 'fciUserName=' + value);

    value = (envVarMap.get(FCI_FacetsService.environmentVariableName_fciUserPassword)).Value__c;
    if( String.isNotBlank(value)) FCI_FacetsService.fciUserPassword = value;
    System.debug( 'fciUserPassword=' + value);*/
    //US616-END Change
    value = (envVarMap.get(FCI_FacetsService.environmentVariableName_fciSFDCSupportEmailAddress)).Value__c;
    if( String.isNotBlank(value)) FCI_FacetsService.fciSFDCSupportEmailAddress = value;
    System.debug( 'fciSFDCSupportEmailAddress=' + value);
    
    value = (envVarMap.get(FCI_FacetsService.environmentVariableName_fciFacetsSupportEmailAddress)).Value__c;
    if( String.isNotBlank(value)) FCI_FacetsService.fciFacetsSupportEmailAddress = value;
    System.debug( 'fciFacetsSupportEmailAddress=' + value);
    
    value = (envVarMap.get(FCI_FacetsService.environmentVariableName_fciRequestTimeout)).Value__c;
    if( String.isNotBlank(value)) FCI_FacetsService.fciRequestTimeout = value;
    System.debug( 'fciRequestTimeout=' + value);

    FCI_FacetsService.isInitialized = true;
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
     FCI_FacetsService.loadConfigurationFromEnvironmentVariables();
}


/*************************************************************************************
 * Purpose   : Asynchronous version of create Facets case function suitable for invocation
 *             from triggers  
 *             
 * Parameters: String string_FCI_CreateCaseRequest - a serialized JSON version of the FCI_CreateCaseRequest
 *             object as future methods can only accept primitive types as arguments.
 *
 * Return    : None
 *************************************************************************************/

@future(callout=true)
public static void sendFuture_FCI_CreateCaseRequest( String string_FCI_CreateCaseRequest) {
    FCI_FacetsService.send_FCI_CreateCaseRequest( (FCI_CreateCaseRequest) JSON.deserialize( string_FCI_CreateCaseRequest, FCI_CreateCaseRequest.class));
}

/*************************************************************************************
 * Purpose   : Synchronous (blocking) version of CreateCase in Facets functionality 
 *             
 * Parameters: FCI_CreateCaseRequest request - the request object with detailed fields captured
 *             from the Salesforce Case record
 *
 * Return    : FCI_CreateCaseResponse - a response object that describes the result of the operation
 *             returned by the Facets service remote endpoint.
 *************************************************************************************/
public static FCI_CreateCaseResponse send_FCI_CreateCaseRequest( FCI_CreateCaseRequest request) {
    
    FCI_CreateCaseResponse response = null;
    Boolean notifySupportTeam = false;
    
    try {
        FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1 service = FCI_FacetsService.getService();

        FCI_FacetsServiceProxy.CreateCaseRequest_element requestElement = new FCI_FacetsServiceProxy.CreateCaseRequest_element();
        requestElement.CSSC = new FCI_FacetsServiceProxy.CSSC_element();
        requestElement.CSCI = new FCI_FacetsServiceProxy.CSCI_element();
        requestElement.CSTK = new FCI_FacetsServiceProxy.CSTK_element();
        requestElement.CSWN = new FCI_FacetsServiceProxy.CSWN_element();
        requestElement.CSWV = new FCI_FacetsServiceProxy.CSWV_element();
        requestElement.CSWC = new FCI_FacetsServiceProxy.CSWC_element();
        requestElement.CSWR = new FCI_FacetsServiceProxy.CSWR_element();
        requestElement.NCASF = new FCI_FacetsServiceProxy.NCASF_element();
        
    // populate request elements from input argument

    //---------CSSC-----------------------
        requestElement.CSSC.callertype =  request.callerType;
        requestElement.CSSC.callingMethod = request.callingMethod;
        requestElement.CSSC.satisfactionLevel = request.satisfactionLevel;
        requestElement.CSSC.disclaimerInd =     request.disclaimerInd;
        requestElement.CSSC.callerResponse = request.callerResponse;    // holds Case.Broker_ID__c


    //---------CSCI-----------------------
        requestElement.CSCI.custSrvcID= null;
        requestElement.CSCI.contactLastName= request.contactLastName;
        requestElement.CSCI.contactFirstName= request.contactFirstName;
        requestElement.CSCI.contactMI= null;
        requestElement.CSCI.contactTitle= request.contactTitle;
        requestElement.CSCI.contactMemRela= request.contactMemberRelationship;
        requestElement.CSCI.contactLang= null;
        requestElement.CSCI.contactSSN= null;
        requestElement.CSCI.groupContrivedKey= request.groupContrivedKey;
        requestElement.CSCI.contactAddress= request.contactAddressLine1;
        requestElement.CSCI.contactAddress2= request.contactAddressLine2;
        requestElement.CSCI.contactAddress3= null;
        requestElement.CSCI.contactCity= request.contactCity;
        requestElement.CSCI.contactState= request.contactState;
        requestElement.CSCI.contactZip= request.contactZip;
        requestElement.CSCI.contactCounty= null;
        requestElement.CSCI.contactCountryCode= request.contactCountry;
        requestElement.CSCI.contactPhone= request.contactPhone;
        requestElement.CSCI.contactPhoneExt= null;
        requestElement.CSCI.contactFax= request.contactFax;
        requestElement.CSCI.contactFaxExt= null;
        requestElement.CSCI.contactEmail= request.contactEmail;


    //---------CSTK-----------------------
        requestElement.CSTK.custSrvcID = null;
        requestElement.CSTK.taskSeqNo = '0';
        requestElement.CSTK.customerID = request.groupID;
        requestElement.CSTK.customerIND = request.customerIndicator; 
        requestElement.CSTK.productCategory = request.productCategory;
        requestElement.CSTK.taskCategory = request.facetsCategoryCode; // 4-digit Category code derived off picklist value first 4-chars
        requestElement.CSTK.taskAssignedUserID = null;
        requestElement.CSTK.taskAssingeDept = null;
        requestElement.CSTK.taskInputUserID = null;
        requestElement.CSTK.taskInputMethod = request.taskInputMethod;
        requestElement.CSTK.taskInputUserDept = null;
        requestElement.CSTK.taskLastUpdateUserID = null;
        requestElement.CSTK.taskInputDateTime = request.getDateTimeOpenedAsMMDDYYYY();
        requestElement.CSTK.taskReceivedDate = request.getDateTimeReceivedAsMMDDYYYY();
        requestElement.CSTK.taskLastUpdateTime = request.getDateTimeLastUpdatedAsMMDDYYYY();
        requestElement.CSTK.taskNextReviewInterval = '1';
        requestElement.CSTK.taskNextReviewDate = null;
        requestElement.CSTK.taskCloseDate = request.getDateTimeClosedAsMMDDYYYY();
        requestElement.CSTK.taskPrimaryUserID = request.serviceRepId;
        requestElement.CSTK.taskStatus = request.getMappedStatus();     // SF Case Status mapped to Facets Status values
        requestElement.CSTK.groupContrivedKey = request.groupContrivedKey;
        requestElement.CSTK.memberContrivedKey = request.memberContrivedKey;    // for Member Cases. N/A for Group cases
        requestElement.CSTK.familyLinkID = null;
        requestElement.CSTK.providerID = null;
        requestElement.CSTK.subGroupContrivedKey = request.subGroupContrivedKey;
        requestElement.CSTK.subscriberContrivedKey = request.subscriberContrivedKey;
        requestElement.CSTK.inputUserSiteCode = request.inputUserSiteCode;
        requestElement.CSTK.taskPriority = null;
        requestElement.CSTK.taskSubject = request.facetsSubjectCode;    // 4-digit Subject code derived off picklist value first 4-chars
        requestElement.CSTK.taskSummary = request.subject;  // Salesforce Case Subject line
        requestElement.CSTK.taskAboutType = null;
        requestElement.CSTK.complainInd = null;
        requestElement.CSTK.reasonClassification = request.facetsReasonCode; 
        requestElement.CSTK.taskClassification = null;
        requestElement.CSTK.taskProofOfClosure = FCI_Util.mapCaseStatusToProofOfClosureCode(request.Status);
        requestElement.CSTK.taskPageType = request.taskPageType;


    //---------CSWN-----------------------
        requestElement.CSWN.custSrvcID = null;
        requestElement.CSWN.taskSeqNo = '0';
        requestElement.CSWN.taskNotes = request.description +
                                        request.caseComments +
                                        request.resolutionReason;
                                        
                                        // Decision to concatenate Case description + Resolution comment re: Email 10/12/15 - Preston,Ken,Vinish

    //---------CSWV-----------------------
        requestElement.CSWV.taskSequenceNo = '0';
        requestElement.CSWV.subName = null;
        requestElement.CSWV.subAddrLine1 = request.subAddrLine1;
        requestElement.CSWV.subAddrLine2 = request.subAddrLine2;
        requestElement.CSWV.subAddrLine3 = null;
        requestElement.CSWV.subCity = null;
        requestElement.CSWV.subState = null;
        requestElement.CSWV.subZip = request.subZip;
        requestElement.CSWV.subPhone = null;
        requestElement.CSWV.subFAX = null;
        requestElement.CSWV.subDOB = request.subDOB;
        requestElement.CSWV.subGender = null;
        requestElement.CSWV.subSSN = null;
        requestElement.CSWV.subGroup = request.subGroup;
        requestElement.CSWV.subSubgroup = null;
        requestElement.CSWV.Subscriberid = request.subscriberId;
        requestElement.CSWV.memName = null;
        requestElement.CSWV.memAddrLine1 = null;
        requestElement.CSWV.memAddrLine2 = null;
        requestElement.CSWV.memAddrLine3 = null;
        requestElement.CSWV.memCity = null;
        requestElement.CSWV.memState = null;
        requestElement.CSWV.memZip = null;
        requestElement.CSWV.memHomePhone = null;
        requestElement.CSWV.memFax = null;
        requestElement.CSWV.memBirthDate = null;
        requestElement.CSWV.memGender = null;
        requestElement.CSWV.memSSN = null;

    //---------CSWC-----------------------
        requestElement.CSWC.custSrvcID= null;
        requestElement.CSWC.taskSeqNo= '0';
        requestElement.CSWC.mcpdSource= request.mcpdSource;
        requestElement.CSWC.tag1= null;
        requestElement.CSWC.value1= null;
        requestElement.CSWC.tag2= null;
        requestElement.CSWC.value2= null;
        requestElement.CSWC.tag3= null;
        requestElement.CSWC.value3= null;
        requestElement.CSWC.tag4= null;
        requestElement.CSWC.value4= null;
        requestElement.CSWC.tag5= null;
        requestElement.CSWC.value5= null;
        requestElement.CSWC.tag6= null;
        requestElement.CSWC.value6= null;
        requestElement.CSWC.tag7= null;
        requestElement.CSWC.value7= null;
        requestElement.CSWC.tag8= null;
        requestElement.CSWC.value8= null;
        requestElement.CSWC.tag9= null;
        requestElement.CSWC.value9= null;
        requestElement.CSWC.tag10= null;
        requestElement.CSWC.value10= null;
        requestElement.CSWC.tag11= null;
        requestElement.CSWC.value11= null;
        requestElement.CSWC.tag12= null;
        requestElement.CSWC.value12= null;
        requestElement.CSWC.tag13= null;
        requestElement.CSWC.value13= null;
        requestElement.CSWC.tag14= null;
        requestElement.CSWC.value14= null;
        requestElement.CSWC.tag15= null;
        requestElement.CSWC.value15= null;
        requestElement.CSWC.tag16= null;
        requestElement.CSWC.value16= null;
        requestElement.CSWC.tag17= null;
        requestElement.CSWC.value17= null;
        requestElement.CSWC.tag18= null;
        requestElement.CSWC.value18= null;
        requestElement.CSWC.tag19= null;
        requestElement.CSWC.value19= null;
        requestElement.CSWC.tag20= null;
        requestElement.CSWC.value20= null;


    //---------CSWR-----------------------
        requestElement.CSWR.processMode= null;
        requestElement.CSWR.applyRule= null;
        requestElement.CSWR.returnLevel= null;
        requestElement.CSWR.customerInd= null;

    //---------NCASF-----------------------
        requestElement.NCASF.caseOwnerEmailID= request.serviceRepEmail;

    //-------- Send request and process response--------------------------------

        System.Debug('CSTK.taskPrimaryUserID : ' + requestElement.CSTK.taskPrimaryUserID);
        
        FCI_FacetsServiceProxy.createCaseResponseMessage_element proxyResponse
           = service.CreateCase( requestElement );
        System.debug('Received response from Facets service: ' + String.valueOf(proxyResponse.CreateCaseResponse));  

        /*
        These definitions are included here (source:FCI_FacetsServiceProxy.cls) to help understand 
        the nested objects of the response object 
        public class createCaseResponseMessage_element {
            public FCI_FacetsServiceProxy.StatusBlock_element StatusBlock;
            public FCI_FacetsServiceProxy.CreateCaseResponse_element CreateCaseResponse;
         }          
        public class createCaseResponseMessage_element {
            proxyResponse.StatusBlock;
            proxyResponse.CreateCaseResponse
        }           
        public class StatusBlock_element {
            public String statusCode;
            public FCI_FacetsServiceProxy.Message_element[] Message;
            public class Message_element {
            public String mesgCode;
            public String mesgDesc;
        }
        public class CreateCaseResponse_element {
            public String itemTicketNo;
            public String itemStatus;
            public String custSrvcID;
         */
            
        // Note: this response log message should be created after callout otherwise you will get a callout exception 
        // message 'You have uncommitted work pending. Please commit or rollback before calling out'
        response = new FCI_CreateCaseResponse(request);
                    
        response.status = IntegrationMessage.STATUS_SUCCESS;    // default
        response.statusCode = proxyResponse.StatusBlock.statusCode;
        response.statusDescription = '';
        response.setIsValid(true);
    
        Integer resultCode = Integer.valueOf(proxyResponse.StatusBlock.statusCode.trim());
        if( resultCode != 0) {  
            // Error code response from the remote system
            response.status = IntegrationMessage.REMOTE_ERROR;
            String statusDescription = '';              
            // proxyResponse.StatusBlock.Message is only set if there is an error
            for(Integer i=0; i < proxyResponse.StatusBlock.Message.size(); i++) {
                FCI_FacetsServiceProxy.Message_element element = proxyResponse.StatusBlock.Message[i];
                statusDescription = + 'mesgCode=' + element.mesgCode + ', mesgDesc=' + element.mesgDesc + ' ; ';
            }
            response.statusDescription = statusDescription;
            response.setIsValid(false);
            System.debug('Error response from Facets service: ' + statusDescription);
            notifySupportTeam = true;       
        } else {   
            // Successful response from remote system       
            response.itemTicketNo = proxyResponse.CreateCaseResponse.itemTicketNo;
            response.itemStatus =   proxyResponse.CreateCaseResponse.itemStatus;
            response.facetsCaseId = proxyResponse.CreateCaseResponse.custSrvcID;
            System.debug('Received response from Facets service: ' + String.valueOf(proxyResponse.CreateCaseResponse));  
            try {
                // update case with received facets case Id
                if( ! String.isBlank(response.facetsCaseId)) {
                  // if a Open case was sent to Facets, then facetsCaseId and Status needs to be updated
                  if( request.getMappedStatus().equals(FCI_CreateCaseRequest.FacetsStatus_OPEN)  ) {
                    Case c = new Case( Id = request.caseId, Facets_case_ID__c  = response.facetsCaseId, Status = 'Routed to Facets', Facets_Status__c = 'Open');
                    update c;
                  }
                  // if a Closed case was sent to Facets for archival, then only facetsCaseId needs to be updated
                  if(request.getMappedStatus().equals(FCI_CreateCaseRequest.FacetsStatus_CLOSED)) {
                    Case c = new Case( Id = request.caseId, Facets_case_ID__c  = response.facetsCaseId, Status = request.Status, Facets_Status__c = 'Closed');
                    update c;                   
                  }
                  
                }
            } catch(Exception e) {
                String s = 'Exception encountered while trying to update case. Case ID=' + (request.caseId != null? request.caseId : '') +', message=' + e.getMessage();
                response.status = IntegrationMessage.STATUS_ERROR;
                response.statusCode = IntegrationMessage.SOURCE_ERROR;
                response.statusDescription = s;
                System.debug(s);        
                response.setIsValid(false);             
            }
            String s = 'Successfully updated Case Id ' + request.caseId + ' with with Facets_case_ID__c=' + response.facetsCaseId;
            response.status = IntegrationMessage.STATUS_SUCCESS;
            response.statusCode = IntegrationMessage.STATUS_SUCCESS;
            response.statusDescription = s;
            System.debug(s);        
            response.setIsValid(true);
        }
    } catch (Exception e) {
        response = new FCI_CreateCaseResponse(request);
        response.status = IntegrationMessage.STATUS_ERROR;
        response.statusCode = IntegrationMessage.REMOTE_ERROR;
        response.statusDescription = 'Exception type= ' + e.getTypeName() + ' , message= ' + e.getMessage();
        response.setIsValid(false);
        System.debug('Exception encountered. Request=' + request.toString() + ';  Response=' + response);
        notifySupportTeam = true;
    } // end try-catch

    // Email generation
    if(notifySupportTeam) 
      sendFCIErrorNotification(request, response);
    
    response.msgData = 'Remote response: status=' + response.status + 
                       ', statusCode=' + response.statusCode + 
                       ', statusDescription= ' + response.statusDescription;
   
    response.relatedData =  String.isBlank(request.caseId) ? 'None.' : '<a href="/' + request.caseId + '" target="_blank">Related Case Record</a>';
    
    // log request and response messages to Integration log 
    // Note: if called from a context where a database transaction (record update) is happening, these calls need to happen after the web service callout to the external EGP portal system
    // otherwise you get an exception message "System.CalloutException: You have uncommitted work pending"
    // because integration log records have not been committed
    Integration.log (request);
    Integration.log( response);
    
    return response;
}


/*************************************************************************************
 * Purpose   : This method supports UC2: Update Facets case based on changes to the local
 *             Salesforce Case record. It is bulkified and is called from the CaseHandlerTrigger.
 *             It selects the updated Case records, retrieves additional fields the related Contact, Owner
 *             and CaseComment objects that so all relevant update fields can be examined for change detection. 
 *             Each individual case is delegated to the supporting processCaseUpdate() method for generating 
 *             FCI_UpdateCaseRequests.
 *             
 * Parameters: List<Case> caseList - the list of updated cases from Trigger.New
 *             Map<Id,Case> oldCaseMap - the Map of cases prior to be updated from Trigger.OldMap
 *
 * Return    : None
 *************************************************************************************/


public static void processCaseUpdates(List<Case> caseList, Map<Id,Case> oldCaseMap) {
    // only process case record types relateing to SBU Broker support. 
    // Old: SBU_Broker_Support_Internal/_External
    // New: Record types are: 'SBU_Group_Case', 'SBU_Member_Case', 'SBU_Non_Member_Case'
     
    // Deprecated 7.20.16. Now need to query all SBU Broker case record types 
    // Id recordTypeId_SBU_Broker_Support_Internal = QueryBase.getRecordtypeId('Case', 'SBU_Broker_Support_Internal');
    // New - query multiple record types for SBU cases via FCI_Util.getSBUCaseRecordTypeIds 7/20/16 KG
    Set<String> caseRecordTypeIds = FCI_Util.getSBUCaseRecordTypeIds();
    List<Id> SBU_BrokerCaseKeys = new List<Id>();   
    for( Case c: caseList) {
        if( caseRecordTypeIds.contains(c.recordTypeId) ) {
            SBU_BrokerCaseKeys.add(c.Id);
        }
    }   
    // Now you need to query the lookup object fields you need because they are not automatically populated in Trigger.new
    // Also use a Sub-query to get related case comments 
    /*
    List<Case> SBU_BrokerCases = [SELECT Id, Group_ID__c,Facets_Category__c, 
                                    Facets_Status__c, Facets_Subject__c, Reason__c,
                                    Subject, Description, 
                                    Status, 
                                    Group_Name__c,
                                    New_Group_ID__c,
                                    Broker_Service_Team__c,
                                    Broker_ID__c,
                                    SLA_Category__c,
                                    Market_Segment__c,
                                    Facets_Satisfaction_Level__c,
                                    Contact.LastName, Contact.FirstName,
                                    Contact.Salutation,Contact.MailingCity,
                                    Contact.MailingState, Contact.MailingCountry,
                                    Contact.MailingPostalCode, Contact.MailingStreet,
                                    Contact.Phone, Contact.Fax,Contact.Email,
                                    OwnerId, Owner.Type,
                                    (SELECT Id, IsPublished,LastModifiedDate, CreatedBy.FirstName, CreatedBy.LastName, 
                                            CommentBody FROM CaseComments  ORDER BY LastModifiedDate ASC), 
                                    Resolution_Reason__c,
                                    Origin,
                                    CreatedDate,
                                    ClosedDate,
                                    Received_Date__c,
                                    LastModifiedDate, 
                                    Facets_case_ID__c  FROM Case 
                                    WHERE Id IN :SBU_BrokerCaseKeys];   
                                    */
    List<Case> SBU_BrokerCases = FCI_Util.getCaseDetailsByIdList(SBU_BrokerCaseKeys);
    for(Case c: SBU_BrokerCases) {
        FCI_FacetsService.handleCaseUpdate( c, (Case) oldCaseMap.get(c.Id) );       
    }
}


/*************************************************************************************
 * Purpose   : This is a singular version of handleCaseUpdates that does change detection
 *             and if applicable set up a FCI_(Create/Update)CaseRequest in a future call 
 *             to send the case to Facets.
 *             If the input Case has no prior FacetsCaseID field, that means this case has
 *             not been sent to Facets before so a CreateCase request is generated. If there is
 *             an existing FacetsCaseID value, then an UpdateCase request is generated to be sent
 *             in a Future call. The method also checks if the particular record has already been processed in 
 *             the current transaction context using the TriggerHandler.isAlreadyProcessed() methods to ensure 
 *             duplicate callouts are not sent for a single SF case record.
 *             
 * Parameters: Case newVersion - updated Salesforce Case record (Trigger.new)
 *             Case oldVersion - copy of the Salesforce Case record prior to the update (Trigger.old)
 *
 * Return    : None
 *************************************************************************************/

public static void handleCaseUpdate(Case newVersion, Case oldVersion) {
    String status = newVersion.Status;
    
    // if this case is being Closed and was not previously sent to Facets (based on no Facets Case ID), then send 
    // the case for archival purposes. (This is a 94% case that is worked locally in Salesforce)
    // check and enforce single callout for recursion scenarios using TriggerHandler.*Processed() methods
    
    if(    status.startsWith('Closed') &&  
           String.isBlank(newVersion.Facets_case_ID__c) &&
           !TriggerHandler.isAlreadyProcessed( newVersion.Id) 
       ) {
        TriggerHandler.setAlreadyProcessed( newVersion.Id, newVersion );
        // Create a Facets create case request and send it in the future
        try {

            // Create the FacetsCreateCase request 
            FCI_CreateCaseRequest request = new FCI_CreateCaseRequest(newVersion); 
            // Validate request has all required fields to create a Facets case
            
            FCI_Validation validation = request.validateRequest();  // validateRequest will only enforce GroupID required for 94% cases
            // Handle validation errors
            if( ! validation.isValid) {
                String errorMessage = validation.getValidationMessagesAsHTML();
                System.debug(errorMessage);
                // TBD: log integration message
                return;
            }
            // send request to FCI_FacetsService
            FCI_FacetsService.sendFuture_FCI_CreateCaseRequest(JSON.serialize(request));

        } catch (Exception e) {
            System.debug(e);
            // TBD: Integration Log
        }

    }
    
    // If this case has a Facets Case Id, send any relevant field updates and is currently routed to Facets 
    // then send field updates

    
      if( !String.isBlank(newVersion.Facets_case_ID__c)  ) {
        // Create a Facets create case request and send it in the future
        try {
            // Create the FacetsCreateCase request 
            FCI_UpdateCaseRequest request = new FCI_UpdateCaseRequest(newVersion, oldVersion); 
            // Validate request has all required fields to create a Facets case
            
            FCI_Validation validation = request.validateRequest();  
            // Handle validation errors
            if( ! validation.isValid) {
                String errorMessage = validation.getValidationMessagesAsHTML();
                System.debug(errorMessage);
                // TBD: log integration message
                return;
            }
            // send request to FCI_FacetsService
            FCI_FacetsService.sendFuture_FCI_UpdateCaseRequest(JSON.serialize(request));    
        } catch (Exception e) {
            System.debug(e);
            // TBD: Integration Log
        }
        
    }
    
}


/*************************************************************************************
 * Purpose   : This method will capture any new comments added locally to the Salesforce 
 *             case record and generate UpdateCase outbound requests to Facets.
 *             Because all messages to Facets service use FacetsCaseId as the case identifier
 *             this method has to query the related Case record to retrieve that field.
 *             
 * Parameters: Map<Id,CaseComment> commentMap - this is the Trigger.newMap of CaseComment Ids to 
 *             Comment Values.
 *
 * Return    : None
 *************************************************************************************/

public static void processNewCaseComments(Map<Id,CaseComment> commentMap) {
  
    Set<Id> caseCommentIds = (Set<Id>) commentMap.keySet();
    List<CaseComment> commentList = (List<CaseComment>) commentMap.values();
    
    // Select comments locally entered and filter out comments from Facets coming via SOAP API. The filtered comments will be sent as
    // updates to Facets .  
    List<CaseComment> commentsToSendUpdatesToFacets = new List<CaseComment>( 
        [SELECT Id, IsPublished,LastModifiedDate, CreatedBy.FirstName, CreatedBy.LastName, CommentBody, ParentId
         FROM CaseComment 
         WHERE (NOT ( CreatedBy.FirstName = 'Facets' AND CreatedBy.LastName = 'Integration')) AND Id IN :caseCommentIds ]
        ); 
        
    // Retrieve parent Case records to get the FacetsCaseID which is needed to create the FCI_UpdateCaseRequest message to 
    // be sent to the Facets service endpoint                       
    List<Id> commentParentCaseIds = new List<Id>();     
    for( CaseComment cc : commentsToSendUpdatesToFacets) { 
        System.debug( 'cc firstname=' + cc.CreatedBy.FirstName);
        commentParentCaseIds.add(cc.parentId); 
    }
    
    // Map of comment parent cases that have a Facets Case ID and are currently Routed To Facets
    Map<Id,Case> commentParentCaseMap = new Map<Id,Case>(
        [ SELECT Id, Facets_Case_ID__c, OwnerId 
          FROM Case 
          WHERE Id in :commentParentCaseIds AND Facets_Case_ID__c != null ]);
    
    for( CaseComment cc:  commentsToSendUpdatesToFacets) {
        Case parentCase = commentParentCaseMap.get( cc.parentId);
        // If this comment is related to a relevant parent case
        if( parentCase != null) {
            // Construct a update case request
            try {
                // Create the FacetsCreateCase request 
                FCI_UpdateCaseRequest request = new FCI_UpdateCaseRequest(cc, ((Case) commentParentCaseMap.get(cc.parentId)));
                // Validate request has all required fields to create a Facets case
                
                FCI_Validation validation = request.validateRequest();  
                // Handle validation errors
                if( ! validation.isValid) {
                    String errorMessage = validation.getValidationMessagesAsHTML();
                    System.debug(errorMessage);
                    // TBD: log integration message
                    return;
                }
                // send request to FCI_FacetsService
                FCI_FacetsService.sendFuture_FCI_UpdateCaseRequest(JSON.serialize(request));    
            } catch (Exception e) {
                System.debug(e);
                // TBD: Integration Log
            }
        }
    }   
}       



/*************************************************************************************
 * Purpose   : This method is invoked by ContactTriggerHandler which fires when a Contact is modified.
 *             It filters the incoming Contacts to only those contacts that are related to an SBUCase 
 *             in 'Routed To Facets' status andfor those filtered contacts, it will detect changes 
 *             to Contact fields and cause updates to be sent to Facets 
 *             integration by generating  UpdateCase outbound requests to Facets.
 *             Because all messages to Facets service use FacetsCaseId as the case identifier
 *             this method has to query the related Case record to retrieve that field.
 *             
 * Parameters: Map<Id,Contact> newContactMap - this is the Trigger.newMap of Contact Ids to 
 *             Contact Values.
 *             Map<Id,Contact> oldContactMap - this is the Trigger.oldMap of Contact Ids to
 *             Contact Values.
 *
 * Return    : None
 *************************************************************************************/

public static void processCaseContactModifications( Map<Id,Contact> newContactMap, Map<Id,Contact> oldContactMap ) {
    Set<Id> contactIds = (Set<Id>) newContactMap.keySet();
    // only process case record types SBU_Broker_Support_Internal/_External 
    //Depecreated 7.20.16. Get multiple record types for SBU Broker cases 
    //  Id recordTypeId_SBU_Broker_Support_Internal = QueryBase.getRecordtypeId('Case', 'SBU_Broker_Support_Internal');
    
    Set<String> caseRecordTypeIds = FCI_Util.getSBUCaseRecordTypeIds();
    
    // Get SBU_Broker case records related to modified Contacts
    List<Case> caseList = [ SELECT Id, Facets_Case_ID__c, OwnerId, ContactId
                          FROM Case
                          WHERE ContactId in :contactIds AND Facets_Case_ID__c != null AND recordTypeId IN :caseRecordTypeIds 
                                AND Status = 'Routed To Facets'];
    for(Case c: caseList) {
        handleCaseUpdate( c, (Contact) newContactMap.get( c.ContactId), (Contact) oldContactMap.get( c.ContactId) );
    }
}

 


/*************************************************************************************
 * Purpose   : This is a singular version of handleCaseUpdates that does change detection
 *             on the Contact for a Case and if applicable sets up a FCI_UpdateCaseRequest in a future call 
 *             to send the case to Facets.
 *             
 * Parameters: Case relatedCase - the Case record tied to the modified Contact
 *             Contact newVersion - updated Salesforce Case record (Trigger.new)
 *             Contact oldVersion - copy of the Salesforce Case record prior to the update (Trigger.old)
 *
 * Return    : None
 *************************************************************************************/

public static void handleCaseUpdate(Case relatedCase, Contact newVersion, Contact oldVersion) {
    if( relatedCase == null || String.isBlank(relatedCase.Facets_Case_ID__c) || relatedCase.ContactId != newVersion.Id) {
        System.debug('Input case is null or does not have a Facets_Case_ID__c or is not related to given Case=' 
                     + String.valueOf(relatedCase) 
                     + 'contact=' +String.valueOf(newVersion));
        return;
    } 
        
    // Create a Facets create case request and send it in the future
    try {
        // Create the FacetsCreateCase request 
        FCI_UpdateCaseRequest request = new FCI_UpdateCaseRequest(relatedCase, newVersion, oldVersion); 
        // Validate request has all required fields to create a Facets case
        
        FCI_Validation validation = request.validateRequest();  
        // Handle validation errors
        if( ! validation.isValid) {
            String errorMessage = validation.getValidationMessagesAsHTML();
            System.debug(errorMessage);
            // TBD: log integration message
            return;
        }
    // send request to FCI_FacetsService
        FCI_FacetsService.sendFuture_FCI_UpdateCaseRequest(JSON.serialize(request));    
    } catch (Exception e) {
        System.debug(e);
        // TBD: Integration Log
    }
    
}

/*************************************************************************************
 * Purpose   : Asynchronous version of update Facets case function suitable for invocation
 *             from triggers  
 *             
 * Parameters: String string_FCI_UpdateCaseRequest - a serialized JSON version of the FCI_UpdateCaseRequest
 *             object as future methods can only accept primitive types as arguments.
 *
 * Return    : None
 *************************************************************************************/

@future(callout=true)
public static void sendFuture_FCI_UpdateCaseRequest( String string_FCI_UpdateCaseRequest) {
    FCI_FacetsService.send_FCI_UpdateCaseRequest( (FCI_UpdateCaseRequest) JSON.deserialize( string_FCI_UpdateCaseRequest, FCI_UpdateCaseRequest.class));
}

/*************************************************************************************
 * Purpose   : Synchronous (blocking) version of UpdateCase in Facets functionality 
 *             
 * Parameters: FCI_UpdateCaseRequest request - the request object with detailed fields captured
 *             from the Salesforce Case record
 *
 * Return    : FCI_UpdateCaseResponse - a response object that describes the result of the operation
 *             returned by the Facets service remote endpoint.
 *************************************************************************************/

public static FCI_UpdateCaseResponse send_FCI_UpdateCaseRequest( FCI_UpdateCaseRequest request) {
    
    FCI_UpdateCaseResponse response = null;
    Boolean notifySupportTeam = false;
    
    try {
        FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1 service = FCI_FacetsService.getService();
 
        List<FCI_FacetsServiceProxy.updateCaseFields_element> updateFields = new List<FCI_FacetsServiceProxy.updateCaseFields_element>();
        Map<String,String> caseUpdates = request.getCaseUpdates();
        
        for( String fieldName : caseUpdates.keySet()) {
          FCI_FacetsServiceProxy.updateCaseFields_element updateElement = new FCI_FacetsServiceProxy.updateCaseFields_element();
          updateElement.name = fieldName;
          updateElement.value = (String) caseUpdates.get(fieldName);
          updateFields.add( updateElement);
        }
         
        FCI_FacetsServiceProxy.StatusBlock_element proxyResponse = service.UpdateCase(request.facetsCaseID, updateFields);
        
        // Note: this response log message should be created after callout otherwise you will get a callout exception 
        // message 'You have uncommitted work pending. Please commit or rollback before calling out'
        response = new FCI_UpdateCaseResponse(request);
                    
        response.status = IntegrationMessage.STATUS_SUCCESS;    // default
        response.statusCode = proxyResponse.statusCode;
        response.statusDescription = '';
        response.setIsValid(true);
    
        Integer resultCode = Integer.valueOf(proxyResponse.statusCode.trim());
        if( resultCode != 0) {  
            // Error code response from the remote system
            response.status = IntegrationMessage.REMOTE_ERROR;
            String statusDescription = '';              
            // proxyResponse.StatusBlock.Message is only set if there is an error
            for(Integer i=0; i < proxyResponse.Message.size(); i++) {
                FCI_FacetsServiceProxy.Message_element element = proxyResponse.Message[i];
                statusDescription = + 'mesgCode=' + element.mesgCode + ', mesgDesc=' + element.mesgDesc + ' ; ';
            }
            response.statusDescription = statusDescription;
            response.setIsValid(false);
            System.debug('Error response from Facets updateCase service: ' + statusDescription);
            notifySupportTeam = true;       
        } else {   
            // Successful response from remote system       
            System.debug('Received response from Facets service: ' + String.valueOf(proxyResponse));  
            String s = 'Successfully sent updates for Case ID =' + request.caseId + ', facetsCaseId=' + request.facetsCaseId + ', Updates: ' + String.valueOf(request.getCaseUpdates());
            
            // if a Facets case status change was sent, update the local Facets case status in SF record
            if( request.getCaseUpdates().get('Status') != null) {
                String newFacetsStatus = null;
                String tmp = (String) request.getCaseUpdates().get('Status');
                if( tmp.equals(FCI_CreateCaseRequest.FacetsStatus_OPEN)) 
                    newFacetsStatus = 'Open';
                else 
                    newFacetsStatus = 'Closed';
                Case c = new Case( Id = request.caseId, Facets_case_ID__c = request.facetsCaseId, Facets_Status__c = newFacetsStatus);
                update c;
            }
            
            response.status = IntegrationMessage.STATUS_SUCCESS;
            response.statusCode = IntegrationMessage.STATUS_SUCCESS;
            response.statusDescription = s;
            System.debug(s);        
            response.setIsValid(true);
        }
    } catch (Exception e) {
        response = new FCI_UpdateCaseResponse(request);
        response.status = IntegrationMessage.STATUS_ERROR;
        response.statusCode = IntegrationMessage.REMOTE_ERROR;
        response.statusDescription = 'Exception type= ' + e.getTypeName() + ' , message= ' + e.getMessage();
        response.setIsValid(false);
        System.debug('Exception encountered. Request=' + request.toString() + ';  Response=' + response);
        notifySupportTeam = true;
    } // end try-catch

    // Email generation
    if(notifySupportTeam) 
        sendFCIErrorNotification(request, response);
    
    response.msgData = 'Remote response: status=' + response.status + 
                       ', statusCode=' + response.statusCode + 
                       ', statusDescription= ' + response.statusDescription;
    response.relatedData =  String.isBlank(request.caseId) ? 'None.' : '<a href="/' + request.caseId + '" target="_blank">Related Case Record</a>';
    
    // log request and response messages to Integration log 
    // Note: if called from a context where a database transaction (record update) is happening, these calls need to happen after the web service callout to the external EGP portal system
    // otherwise you get an exception message "System.CalloutException: You have uncommitted work pending"
    // because integration log records have not been committed
    Integration.log (request);
    Integration.log( response);
    
    return response;
}


/*************************************************************************************
 * Purpose   : This method processes updates from Facets system. 
 *             For Facets Subject/Category updates, it translates 4-digit Facets Subject/Category updates
 *             to the picklist value when received via the SOAP api call. The CaseTriggerHandler.beforeUpdate 
 *             event  invokes this method to do the translation before the case is committed.
 *
 *             Note: The implementation is updated to look at the UpdateSource__c field to determine if the update
 *             came via SOAP API call. The value of this field is reset so subsequent triggers (from SF UI) don't use
 *             a stale saved value
 * Parameters: List<Case> caseUpdatesFromApi - list of Cases updated
 *
 * Return    : None
 *************************************************************************************/
    
    public static void processUpdatesFromFacetsSystem( List<Case> caseUpdatesFromApi) {
        for( Case c: caseUpdatesFromApi) {
            if( ! 'API'.equals(c.UpdateSource__c)) { 
                c.UpdateSource__c = null;   // discard the received UpdateSource__c value so it does not interfere with susequent trigger firing.
                continue;
            } else {
                c.Updatesource__c = null;   // discard the received UpdateSource__c value
                System.debug( 'Received an update from the SOAP API');
            }

            // map Facets Subject changes from code to picklist value
            // keep the 4 digit length check to ensure API does not submit an invalid length code
            if( c.Facets_Subject__c != null && c.Facets_Subject__c.trim().length() == 4) {
                System.debug('Rewriting Facets Subject code=' + c.Facets_Subject__c + 'to ' + mapFacetsSubjectCodeToPicklistValue( c.Facets_Subject__c));
                c.Facets_Subject__c = mapFacetsSubjectCodeToPicklistValue( c.Facets_Subject__c);
            }                   
            // map Facets Category changes from 4-digit code to picklist value
            // keep the 4 digit length check to ensure API does not submit an invalid length code   
            if( c.Facets_Category__c != null && c.Facets_Category__c.trim().length() == 4) { 
                System.debug('Rewriting Facets Category code=' + c.Facets_Category__c + 'to ' + mapFacetsCategoryCodeToPicklistValue( c.Facets_Category__c));
                c.Facets_Category__c = mapFacetsCategoryCodeToPicklistValue( c.Facets_Category__c);             
            }    
            // map Facets Status change updates from Code to SF Picklist value
            if( c.Facets_Status__c != null && c.Facets_Status__c.trim().length() == 2) {
                String code = null;
                if(c.Facets_Status__c.equals('CL')) code = 'Closed';
                if(c.Facets_Status__c.equals('OP')) code = 'Open'; 
                if(c.Facets_Status__c.equals('RT')) code = 'Routed';    
                if(c.Facets_Status__c.equals('MD')) code = 'Mis-directed';  
                if(c.Facets_Status__c.equals('PE')) code = 'Pending';   
                
                if (code != null) {
                    System.debug('Rewriting Facets Status code=' + c.Facets_Status__c + 'to ' + code);
                    c.Facets_Status__c = code;
                }               
                
            }
            }
    }
    
    // -----------------------------------------------------------------------//
    //                         Utility support methods                                                
    // -----------------------------------------------------------------------// 

/*************************************************************************************
 * Purpose   : Translates Facets Subject 4-digit codes received via SOAP API from Facets system
 *             to the matching picklist value. Note the picklist value prefix has the same 4-digit value 
 *             
 * Parameters: String subjectCode - 4-digit Facets Subject code
 *
 * Return    : String - Picklist value from Case.Facets_Subject__c picklist field
 *************************************************************************************/

    public static String mapFacetsSubjectCodeToPicklistValue(String subjectCode) {
        return facetsSubjectCodeToPicklistMapping.get(subjectCode);     
    }

/*************************************************************************************
 * Purpose   : Translates Facets Category 4-digit codes received via SOAP API from Facets system
 *             to the matching picklist value. Note the picklist value prefix has the same 4-digit value 
 *             
 * Parameters: String categoryCode - 4-digit Facets Category code
 *
 * Return    : String - Picklist value from Case.Facets_Category__c picklist field
 *************************************************************************************/

    public static String mapFacetsCategoryCodeToPicklistValue(String categoryCode) {
        return facetsCategoryCodeToPicklistMapping.get(categoryCode);       
    }


/*************************************************************************************
 * Purpose   : US616-Deprecated as part of API Gateway Named credentials implementation
               This is a utility method that consolidates some common setup code to get 
 *             a callable FCI_FacetsServiceProxy endpoint. It returns an instance of the web service callout
 *             FCI_FacetsServiceProxy endpoint - OperationsOfFacetsSalesForceEndpoint1(). It takes care of configuring FCI
 *             specific parameters like the endpoint URL (which varies by environment), client certificate
 *             name to use etc. 
 *             The returned service callout object is used by the higher level methods.
 *
 * Parameters: None
 *
 * Return    : FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1
 *************************************************************************************/
/*public static FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1 getService() {
    FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1  service = new FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1();
    
    if(!FCI_FacetsService.isInitialized) {  
        throw new FCI_FacetsService.FCI_Exception('FCI_FacetsService is not initialized'); 
    }
    
    String clientCertificateName = FCI_FacetsService.fciClientCertificateName;
    String endPointURL = FCI_FacetsService.fciEndPointURL;
    
        Integer requestTimeout;
        try {
         requestTimeout = Integer.valueof(FCI_FacetsService.fciRequestTimeout);
        } catch (Exception e) {
        System.debug('Error processing timeout value=' + FCI_FacetsService.fciRequestTimeout + ': defaulting to 60,000 (60 seconds)');
        requestTimeout = 60000;
    }

    // The Facets service uses BASIC authentication. This code creates the authorization header
    Map<String,String> securityHeaders = new Map<String,String>();
    String username = FCI_FacetsService.fciUserName;
    String password = FCI_FacetsService.fciUserPassword;

    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
    securityHeaders.put( 'Authorization', authorizationHeader);


    System.debug('Using FCI_FacetsService web service settings: fciClientCertificateName=' + clientCertificateName + 
                  ', fciRequestTimeout=' + requestTimeout + ', fciEndPointURL=' + endPointURL +
                  ', fciUserName=' + username + ', fciUserPassword=' + password);
    
    service.clientCertName_x = clientCertificateName;
    service.timeout_x = requestTimeout;
    service.endpoint_x = endPointURL;
    service.inputHttpHeaders_x = securityHeaders;
    return service;
}*/



/*************************************************************************************
 * Purpose   : This is a utility method that consolidates some common setup code to get 
 *             a callable FCI_FacetsServiceProxy endpoint. It returns an instance of the web service callout
 *             FCI_FacetsServiceProxy endpoint - OperationsOfFacetsSalesForceEndpoint1(). It takes care of configuring FCI
 *             specific parameters using API Gateway-Named credentials.
 *             The returned service callout object is used by the higher level methods.
 *
 * Parameters: None
 *
 * Return    : FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1
 *************************************************************************************/
 //US616-BEGIN CHANGE
 public static FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1 getService() {
    FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1  service = new FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1();
    
    if(!FCI_FacetsService.isInitialized) {  
        throw new FCI_FacetsService.FCI_Exception('FCI_FacetsService is not initialized'); 
    }
    
    String endPointURL = 'callout:FCIFacetsService';
    
        Integer requestTimeout;
        try {
         requestTimeout = Integer.valueof(FCI_FacetsService.fciRequestTimeout);
        } catch (Exception e) {
        System.debug('Error processing timeout value=' + FCI_FacetsService.fciRequestTimeout + ': defaulting to 60,000 (60 seconds)');
        requestTimeout = 60000;
    }
    
    service.timeout_x = requestTimeout;
    service.endpoint_x = endPointURL;
    return service;
}
//END CHANGE


/*************************************************************************************
 * Purpose   : This is a utility method for sending out error email notifications related to 
 *             FCI CreateCase requests. It uses fields from the request and response objects to
 *             compose the message.
 *             
 * Parameters: FCI_CreateCaseRequest, FCI_CreateCaseResponse - the request, response objects of the
 *             failing transaction
 * Return    : None
 *************************************************************************************/
public static void sendFCIErrorNotification(FCI_Message request, FCI_Message response) {
    String subject = 'Facets Integration request Error';
    String bodyText = 
    '\n The System did not process the following Facets request:' +
    '\n Request = ' + String.ValueOf( request) + 
    '\n Response= ' + String.ValueOf( response);
    FCI_FacetsService.sendFCIErrorNotification(subject,bodyText);   
    FCI_FacetsService.sendCaseOwnerErrorNotification(request, response);
}


/*************************************************************************************
 * Purpose   : This method generates a notificaion to the case owner when there is a problem sending a case to Facets
 *             
 * Parameters: String subject - subject line of message
 *             String bodyText - message text
 *
 * Return    : None
 *************************************************************************************/

public static void sendCaseOwnerErrorNotification(FCI_Message request, FCI_Message response) {
    Case caseObject;
    if( request instanceOf FCI_CreateCaseRequest) {
         caseObject = ((FCI_CreateCaseRequest) request).caseObject;
    } else {
        caseObject = ((FCI_UpdateCaseRequest) request).caseObject;
    }
    
    User u = [ select Id, FirstName, LastName, Email from User where Id = :caseObject.OwnerId];
    Case c = [ select casenumber,subject from case where Id =:caseObject.Id];

    String subject = 'Your case ' + c.caseNumber + ' could not be updated from Salesforce to Facets';
    String bodyText = 
                  'Your Salesforce Case ' + c.caseNumber +  ' could not be updated from ' +
                  'Salesforce to the Facets system due to a transmission error. The Salesforce and Facets support ' +
                  'teams have been notified about the problem. Please contact SFDC Support at SFDCSUPPORT@carefirst.com ' +
                  'if you need immediate assistance.';
   
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    String supportEmail = FCI_FacetsService.fciSFDCSupportEmailAddress; // default value in case nothing is configured in EnvironmentVariable__c
    if(String.isNotBlank(FCI_FacetsService.fciSFDCSupportEmailAddress)) { 
          supportEmail = FCI_FacetsService.fciSFDCSupportEmailAddress;
    } 
    
    List<String> emailAddresses = new List<String>();
        emailAddresses.add( u.Email);
    mail.setToAddresses(emailAddresses);
    mail.setReplyTo(supportEmail.split(',\\s*')[0]);
    mail.setSenderDisplayName('CareFirst Salesforce System');
    mail.setSubject(subject);
    mail.setPlainTextBody(bodyText);

    // send email
    Messaging.SendEmailResult[] emailresult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    System.debug('Case Owner Error notification sent to ' + u.FirstName + ' ' + u.LastName + 'at ' + u.Email + 'for Case ' + c.caseNumber + ': Subject: ' + c.subject); 
    }


/*************************************************************************************
 * Purpose   : General purpose email send method
 *             
 * Parameters: String subject - subject line of message
 *             String bodyText - message text
 *
 * Return    : None
 *************************************************************************************/
public static void sendFCIErrorNotification(String subject, String bodyText) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String supportEmail = FCI_FacetsService.fciSFDCSupportEmailAddress; // default value in case nothing is configured in EnvironmentVariable__c
    String fciTeamEmail = FCI_FacetsService.fciFacetsSupportEmailAddress;
    
    // if Environment Variables have been set, use those for email addresses
    // useful for overriding in different environments  
    
    List<String> emailAddresses = new List<String>();
    if(String.isNotBlank(FCI_FacetsService.fciSFDCSupportEmailAddress)) { 
          supportEmail = FCI_FacetsService.fciSFDCSupportEmailAddress;
          emailAddresses.addAll(supportEmail.split(',\\s*'));   // Allow multiple comma separated email addresses
    } 
          
    if(String.isNotBlank(FCI_FacetsService.fciFacetsSupportEmailAddress)) {
         fciTeamEmail = FCI_FacetsService.fciFacetsSupportEmailAddress;
         emailAddresses.addAll(fciTeamEmail.split(',\\s*'));    // Allow multiple comma separated email addresses
    }     
         
        
    //mail.setToAddresses(new String[] {supportEmail, fciTeamEmail});
    mail.setToAddresses(emailAddresses);
    mail.setReplyTo(emailAddresses[0]);
    // mail.setBccAddresses(emailAddresses);
    mail.setSenderDisplayName('CareFirst Salesforce System');
    mail.setSubject(subject);
                           
    mail.setPlainTextBody(bodyText);
    // send email
    Messaging.SendEmailResult[] emailresult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    System.debug('Support team notified :' + 'Subject:' + subject + '; Message body: ' + bodyText + '; Result: ' + emailresult);    
    }

} // end class