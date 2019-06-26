/*=========================================================================================
 * Date         : 9/1/16
 * Developer    : Ken Gill
 * Purpose      :  
 * 
 * This class provides a service layer for the rest of the application to access functionality of
 * the Facets Member service which provides details on subscriber and member summary details and 
 * their eligibilities for multiple product lines. This class supports the implementation of Member
 * cases by providing selection lists of members by a given subscriber and their underlying eligibilities
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 09/01/16  |  KG    | Initial Version                                         
 * 09/15/16  |  KG    | Plan description for Member eligibilities is not populated by the Member
 *           |        | service at origin. Implemented a change to populate plan descriptions from 
 *           |        | the Subscriber eligibility detail segment which receives the plan descriptions
 * 10/27/16  |  KG    | Production Issue Fix. Case Number 00006630- Sometimes member information is not displayed for certain
 *           |        | subscriber IDs. Cause - subscriber eligibilities not always returned by the Member Service. 
 *           |        | Implemented a check on subscriber eligibilities before attempting to iterate to avoid null pointer exception. 
 * 12/8/16   |  KG    | Set SubscriberEligibility Indicator by rolling up individual member product eligbilities when processing the 
 *           |        | MEPE (Member Process Elgilibyty) segment.
 * 12/13/16  |  KG    | Defect ID : Modify termination date to blank if it is '12/31/9999'. 106725 User is able to view the Termination date value as "12/31/9999" in Salesforce where empty value is displaying in facets
 * 12/13/16  |  KG    | Introduce a map ProductCategoryDescriptionByCategoryMap<String,String> to populate category description field based on category code (Defect ID: 106351)
 * 2/9/17    |  KG    | Implementation of Eligibility Roll up Indicator based on all eligibilites for a Group where eligibilty is not terminated (i.e. eligTermDate is blank (treated as today)
 *           |        | or future (based on parsing mm/dd/yyyy string).  
 *           |        | Rollup Algorithm:
 *           |        |     Default rollup = 'N' // not eligible
 *           |        | 
 *           |        |     if (Group is Terminated) 
 *           |        |           rollup = 'N' // not eligible
 *           |        |           rollup calculation complete! 
 *           |        |     else
 *           |        |   
 *           |        |     for (all Eligibilites where MemberProcessEligibility.memProcessEligTermDate is blank/future)
 *           |        |        if( memProcessEligInd == Y) rollup = Y;
 * 3/6/17    |  KG    | Defect 110462 Fix: Introduced globalPlanIdToDescriptionMap<String,String>. This contains plan descriptions and is passed to the method mergeCurrentAndHistoricalEligibilities
 *           |        | 
 * 2/3/2018  |  Sree Uma Ponnoju  |US616-Added API Gateway change using Named Credential     
 *=========================================================================================
 */

public with sharing class MSI_MemberService {

public class MSI_Exception extends Exception {}


public static String msiEndPointURL;
public static String msiRequestTimeout = '120000';
public static String msiSFDCSupportEmailAddress = 'kirat.gill@carefirst.com';
public static String msiFacetsSupportEmailAddress = 'kirat.gill@carefirst.com';
//US616-Deprecated variables related to username/password/cert as part of Named credentials implementation
/*public static String msiUserName = '';
public static String msiUserPassword = '';
public static String msiClientCertificateName;*/
//US616-END CHANGE
public static Boolean isInitialized = false;

public static String environmentModuleName = 'MSI Integration';
public static String environmentCommonModuleName = 'Common';
public static String environmentVariableName_msiSFDCSupportEmailAddress = 'SFDC_Support_Email';
public static String environmentVariableName_msiFacetsSupportEmailAddress = 'MSI_Support_Email';
//US616-Deprecated variables related using username/password/cert/url as part of Named credentials implementation
/*public static String environmentVariableName_msiEndPointURL = 'MSI_EndPoint';
public static String environmentVariableName_msiClientCertificateName = 'MSI_ClientCertificateName';
public static String environmentVariableName_msiUserName = 'MSI_UserName';
public static String environmentVariableName_msiUserPassword = 'MSI_UserPassword';*/
//US616-END CHANGE
public static String environmentVariableName_msiRequestTimeout = 'RequestTimeout';
public static List<String> environmentVariableNames = new List<String>();
 


// one time initialization block when MSI_MemberService class is first loaded
static {
    System.debug('MSI_MemberService: static initializer block loading');
    MSI_MemberService.environmentModuleName = 'MSI Integration';
    MSI_MemberService.environmentVariableNames = new List<String>();
    //US616-Deprecated variables related using username/password/cert/url as part of Named credentials implementation
    /*MSI_MemberService.environmentVariableNames.add ( MSI_MemberService.environmentVariableName_msiEndPointURL );
    MSI_MemberService.environmentVariableNames.add ( MSI_MemberService.environmentVariableName_msiClientCertificateName );
    MSI_MemberService.environmentVariableNames.add ( MSI_MemberService.environmentVariableName_msiUserName);
    MSI_MemberService.environmentVariableNames.add ( MSI_MemberService.environmentVariableName_msiUserPassword);*/
    //US616-END CHANGE
    MSI_MemberService.environmentVariableNames.add ( MSI_MemberService.environmentVariableName_msiSFDCSupportEmailAddress );
    MSI_MemberService.environmentVariableNames.add ( MSI_MemberService.environmentVariableName_msiFacetsSupportEmailAddress );
    MSI_MemberService.environmentVariableNames.add ( MSI_MemberService.environmentVariableName_msiRequestTimeout );
    
                                                         
    MSI_MemberService.loadConfigurationFromEnvironmentVariables();
               
}   // end static initializer
    

public static Map<String,String> ProductCategoryDescriptionByCategoryMap = new Map<String,String> {
    'D' => 'Dental Product',
    'H' => 'HSA Product', 
    'M' => 'Medical Product',
    'R' => 'Prescription Drug Product' ,
    'P' => 'Maternity Product', 
    'V' => 'Vision Product', 
    'E' => 'Pediatric Dental (Embedded)',
    'W' => 'Pediatric Vision (Embedded)'
};


public static Map<String,String> globalPlanIdToDescriptionMap = new Map<String,String>();

// Group terminated status related Constants
public static String UNAVAILABLE = 'Unavailable';
public static String TERMINATED = 'Terminated';
public static String ACTIVE = 'Active';


/*************************************************************************************
 * Purpose   : This method loads MSI integration related configuration variables when either: 
 *             1. This class is first loaded and automatically called from the static initializer block  
 *             2. OR when the MSI configuration settings are modified through the EnvironmentVariables tab which 
 *             triggers EnvironmentVariableTrigger which calls this method to reload env vars.
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
public static void loadConfigurationFromEnvironmentVariables() {
    
    System.debug('Loading MSI_MemberService environment variables');    
    Map<String, EnvironmentVariable__c> envVarMap = new Map<String,EnvironmentVariable__c>();
    EnvironmentVariables.getEnvironmentVariablesForModule(MSI_MemberService.environmentModuleName, envVarMap);
    EnvironmentVariables.getEnvironmentVariablesForModule(MSI_MemberService.environmentCommonModuleName, envVarMap);
    
    if(envVarMap.isEmpty()) {
        System.debug('Error: No MSI related environment variables configured in EnvironmentVariable__c table. Retrieved envVarMap=' + String.valueOf(envVarMap));
        MSI_MemberService.isInitialized = false;
        return;
    }
    String value;
    //US616-Deprecated as part of Named credentials implementation          
    /*value =  (envVarMap.get(MSI_MemberService.environmentVariableName_msiEndPointURL)).Value__c;
    if(String.isNotBlank(value)) { MSI_MemberService.msiEndPointURL = value;}
    System.debug( 'msiEndPointURL=' + value);
    
    value = (envVarMap.get(MSI_MemberService.environmentVariableName_msiClientCertificateName)).Value__c;
    if( String.isNotBlank(value)) MSI_MemberService.msiClientCertificateName = value;
    System.debug( 'msiClientCertificateName=' + value);
    
    value = (envVarMap.get(MSI_MemberService.environmentVariableName_msiUserName)).Value__c;
    if( String.isNotBlank(value)) MSI_MemberService.msiUserName = value;
    System.debug( 'msiUserName=' + value);

    value = (envVarMap.get(MSI_MemberService.environmentVariableName_msiUserPassword)).Value__c;
    if( String.isNotBlank(value)) MSI_MemberService.msiUserPassword = value;
    System.debug( 'msiUserPassword=' + value);*/
    //US616-END Change
    value = (envVarMap.get(MSI_MemberService.environmentVariableName_msiSFDCSupportEmailAddress)).Value__c;
    if( String.isNotBlank(value)) MSI_MemberService.msiSFDCSupportEmailAddress = value;
    System.debug( 'msiSFDCSupportEmailAddress=' + value);
    
    value = (envVarMap.get(MSI_MemberService.environmentVariableName_msiFacetsSupportEmailAddress)).Value__c;
    if( String.isNotBlank(value)) MSI_MemberService.msiFacetsSupportEmailAddress = value;
    System.debug( 'msiFacetsSupportEmailAddress=' + value);
    
    value = (envVarMap.get(MSI_MemberService.environmentVariableName_msiRequestTimeout)).Value__c;
    if( String.isNotBlank(value)) MSI_MemberService.msiRequestTimeout = value;
    System.debug( 'msiRequestTimeout=' + value);
   

    MSI_MemberService.isInitialized = true;
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
     MSI_MemberService.loadConfigurationFromEnvironmentVariables();
}

/*
    public class Member {
        public String firstName { get; set;}
        public String lastName { get; set;}
        public String relationship { get; set;}     // Enum 01-09 
        public String memberID { get; set;}
        public String memberContrivedKey {get; set;}
        public String age { get; set;}
        public String dateOfBirth { get; set;}
        public String street { get; set;}
        public String city { get; set;}
        public String state { get; set;}
        public String country { get; set;}
        public String zipCode { get; set;}
        public String phone { get; set;}
        
    
    // Eligibility information
    
        public String description { get; set;}
        public String product { get; set;}
        public String planID { get; set;}
        public String planDescription { get; set;}
        public Date effectiveDate { get; set;}
        public Date terminateDate { get; set;}
    }

     public Map<String,MSI_MemberSummaryResponse.Member> memberDetailsMap { get; set;}

    // Subscriber Fields
     public String subscriberID { get; set;}
     public String subscriberContrivedKey {get; set; }
     
     public String groupID { get; set;}
     public String groupName {get; set;}
     public String groupContrivedKey {get; set; }
     public String subscriberLastName {get; set;}
     public String subscriberFirstName {get; set;}
     public String subscriberCity {get; set;}
     public String subscriberState {get; set;}
     public String subscriberZip {get; set;}
     
     public String subOrgEffectiveDate {get; set;}
     */

public static MSI_MemberSummaryResponse getMemberDetails( MSI_MemberSummaryRequest request) {
    MSI_MemberSummaryResponse response = null;
    Boolean notifySupportTeam = false;
    
    try {
        MSI_MemberServiceProxy.OperationsOfMemberEndpoint1 service = MSI_MemberService.getService();
        MSI_MemberServiceProxy.memberSummaryRequestMessage_MemberSummaryRequest_element requestElement = 
                new MSI_MemberServiceProxy.memberSummaryRequestMessage_MemberSummaryRequest_element();
         
        requestElement.subscriberID = request.subscriberID ;
        requestElement.memberSuffix= request.memberSuffix;
        requestElement.groupID = request.groupID;
        requestElement.asOfDate= request.asOfDate;
        requestElement.returnRecord= request.returnRecord;
         
        MSI_MemberServiceProxy.memberSummaryResponseMessage_element proxyResponse =
                              service.GetMemberSummary(requestElement);
                              
        System.debug( proxyResponse);
        System.debug( 'JSON proxyresponse =' + JSON.serialize(proxyResponse));  // to capture response for mock object
        System.debug('Received response from MSI service: ' + String.valueOf(proxyResponse));  
                      
        // Note: this response log message should be created after callout otherwise you will get a callout exception 
        // message 'You have uncommitted work pending. Please commit or rollback before calling out'
        response = new MSI_MemberSummaryResponse(request);                    
        response.status = IntegrationMessage.STATUS_SUCCESS;    // default
        response.statusCode = proxyResponse.StatusBlock.statusCode;
        response.statusDescription = '';
        response.setIsValid(true);
    
        Integer resultCode = Integer.valueOf(proxyResponse.StatusBlock.statusCode.trim());
        if( resultCode != 0) {  
            // Parse Error (Fault Message) Error code response from the remote system
            response.status = IntegrationMessage.REMOTE_ERROR;
            String statusDescription = '';              
            // proxyResponse.StatusBlock.Message is only set if there is an error
            for(Integer i=0; i < proxyResponse.StatusBlock.Message.size(); i++) {
                MSI_MemberServiceProxy.StatusBlock_Message_element element = proxyResponse.StatusBlock.Message[i];
                statusDescription = + 'mesgCode=' + element.mesgCode + ', mesgDesc=' + element.mesgDesc + ' ; ';
            }
            response.statusDescription = statusDescription;
            response.setIsValid(false);
            System.debug('Error response from MSI service: ' + statusDescription);
            notifySupportTeam = true;       
        } else {        
            // Parse success response from MSI system
            response = new MSI_MemberSummaryResponse( request );
            MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_element[] summarySections = proxyResponse.MemberSummaryResponse;
            System.debug('number of summarysections=' + summarySections.size());
            
            if( summarySections != null && summarySections.size() > 0 ) {
                for( MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_element summary : summarySections ) {
                        MSI_MemberService.processSubscriberSummarySection( response, summary );             
                }
            }
                // Retrieve Historical Eligibilities and Merge them into current eligibilities received from MemberSummary service invocation
            MSI_MemberService.mergeCurrentAndHistoricalEligibilities( response, MSI_MemberService.getHistoricalEligibilities( request.subscriberID), globalPlanIdToDescriptionMap );
            MSI_MemberSummaryResponse.flattenEligibilityMaps( response );
            
            // debug
            for( MSI_MemberSummaryResponse.Subscriber subscriber : response.subscriberByGroupMap.values() ) {
                for( MSI_MemberSummaryResponse.Member member : subscriber.memberDetailsMap.values() ) {
                    System.debug('flattened map ' + JSON.serializePretty( member.flatEligibilityMap ));
                }
            }
            
            response.statusDescription= 'Response: ' + JSON.serializePretty(response).abbreviate(8192);     // limit to field size 
            MSI_MemberService.prettyPrint(response);    // will log the formatted response to System.debug log
        }                           
                          
    } catch (Exception e) {
        response = new MSI_MemberSummaryResponse(request);
        response.status = IntegrationMessage.STATUS_ERROR;
        response.statusCode = IntegrationMessage.REMOTE_ERROR;
        response.statusDescription = 'Exception type= ' + e.getTypeName() + ' , message= ' + e.getMessage();
        response.setIsValid(false);
        System.debug('Exception encountered. Request=' + request.toString() + ';  Response=' + response);
        notifySupportTeam = true;
    } // end try-catch

    // Email generation
    if(notifySupportTeam) {
        // sendFCIErrorNotification(request, response); //TODO
    }
    response.msgData = 'Remote response: status=' + response.status + 
                       ', statusCode=' + response.statusCode + 
                       ', statusDescription= ' + response.statusDescription;
    response.relatedData = '';
    
    // log request and response messages to Integration log 
    // Note: if called from a context where a database transaction (record update) is happening, these calls need to happen after the web service callout to the external system
    // otherwise you get an exception message "System.CalloutException: You have uncommitted work pending"
    // because integration log records have not been committed
    Integration.log (request);
    Integration.log( response);    
    return response;
}


public static void processSubscriberSummarySection( MSI_MemberSummaryResponse response, MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_element summary) {
    

            MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberClassDetails_element[] SubscriberClassDetailsList = summary.SubscriberClassDetails;     
            MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberEligibilityDetails_element[] SubscriberEligibilityDetailsList = summary.SubscriberEligibilityDetails;       
            MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberAddressDetails_element[] SubscriberAddressDetailsList = summary.SubscriberAddressDetails;       
            MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberSubGroupDetails_element[] SubscriberSubGroupDetailsList = summary.SubscriberSubGroupDetails;        
            MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberSalaryDetails_element[] SubscriberSalaryDetailsList = summary.SubscriberSalaryDetails;  
            MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberRateModifier_element[] SubscriberRateModifierList = summary.SubscriberRateModifier;     
            MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberRateRecordTypeDetails_element[] SubscriberRateRecordTypeDetailsList = summary.SubscriberRateRecordTypeDetails;      
            MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_element[] MemberDetailsList = summary.MemberDetails;        
            MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_AdditionalDetails_element AdditionalDetailsList = summary.AdditionalDetails;
    
            MSI_MemberSummaryResponse.Subscriber subscriber = new MSI_MemberSummaryResponse.Subscriber();
                    
            // process Subscriber response fields
            subscriber.subscriberID = summary.subscriberID;
            subscriber.subscriberContrivedKey = summary.subscriberContrivedKey;
            subscriber.groupID = summary.groupID;
            subscriber.groupName = summary.grpName;
            subscriber.groupContrivedKey = summary.groupContrivedKey;
            subscriber.subscriberLastName = summary.subLastName;
            subscriber.subscriberFirstName = summary.subFirstName;
            subscriber.subscriberStreetAddress1 = summary.SubscriberAddressDetails[0].subAddrLine1;
            subscriber.subscriberStreetAddress2 = summary.SubscriberAddressDetails[0].subAddrLine2;
            subscriber.subscriberStreetAddress3 = summary.SubscriberAddressDetails[0].subAddrLine3;     
            subscriber.subscriberCity =  summary.SubscriberAddressDetails[0].subCity;
            subscriber.subscriberState =  summary.SubscriberAddressDetails[0].subState;
            subscriber.subscriberZip =  summary.SubscriberAddressDetails[0].subZip;
            subscriber.subOrgEffectiveDate = summary.subOrgEffDate;
            
            
            System.debug('Processed Subscriber summary details');
            
            // process proxy response SubscriberEligibility details
            MSI_MemberSummaryResponse.Eligibility sElig;
            Map<String, MSI_MemberSummaryResponse.Eligibility> subEligibilityMap = new Map<String, MSI_MemberSummaryResponse.Eligibility>();
            
            // Since the Member Eligibility segment does not contain plan descriptions, save the ones in Subscriber Eligibilities for populating plan
            // description in Member Eligibility details later
            Map<String,String> planIdToDescriptionMap = new Map<String,String>();
            
            // Note: Sometimes the Member Service does not return any Subscriber eligibilities. Check for null before attempting to process
            // Production Issue Fix. See log entry. KG 10/27/16
            if( SubscriberEligibilityDetailsList != null) {
                
                for( MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberEligibilityDetails_element e : SubscriberEligibilityDetailsList) {
                    sElig = new MSI_MemberSummaryResponse.Eligibility();
                    sElig.effectiveDate = e.subEligEffDate;
                    sElig.seqDate = e.subEligSeqDate;
                    sElig.typex = e.subEligType;
                    sElig.typeDescription = e.subEligTypeDesc;
                    sElig.productCategory = e.productCatagory;
                    if( sElig.productCategory != null) {
                        sElig.productCategoryDescription =  MSI_MemberService.ProductCategoryDescriptionByCategoryMap.get( sElig.productCategory);
                    } else {
                        sElig.productCategoryDescription = '';
                    }
                    
                    sElig.classPlanID = e.classPlanID;
                    sElig.planDescription = e.planDesc;
                    
                    // populate plan description map
                    if( !String.isBlank( sElig.classPlanID) && !String.isBlank( sElig.planDescription ) ) {
                        planIdToDescriptionMap.put( sElig.classPlanID, sElig.planDescription);
                        globalPlanIdToDescriptionMap.put( sElig.classPlanID, sElig.planDescription);
                    }
                        
                    sElig.planDescription = e.planDesc;
                    sElig.familyID = e.subEligFamilyID;
                    sElig.reasonCode = e.subEligRsnCode;
                    sElig.voidIndicator = e.subEligVoidInd;
                    subEligibilityMap.put( sElig.classPlanID, sElig);   // subscriber eligibility map indexed by classPlanID
                }
                System.debug('Processed Subscriber Eligibility Details List');
                
            } else {
                System.debug('No Subscriber Eligibility Details were received to process');
            }
            
            subscriber.subEligibilityMap = subEligibilityMap;

            //---------------------------------------------------------------------------
            // process proxy response MemberSummary & Elgilibility details      
            Map<String,MSI_MemberSummaryResponse.Member> memberDetailsMap = new Map<String,MSI_MemberSummaryResponse.Member>();     
            MSI_MemberSummaryResponse.Member member = null;

            // KG 12/8/16 - Roll up eligbility indicator. Default is 'N' No. In the member process eligbility for loop further below, this roll up variable
            // is updated by looking at each member eligbility.
            String rollUpEligibilityIndicator = 'N';    // default is N. If any inidividual member eligiblity is Y, it will be changed to Y.
            String isGroupTerminated = MSI_MemberService.isGroupTerminated( subscriber.groupID );
            if( isGroupTerminated == MSI_MemberService.UNAVAILABLE ) rollupEligibilityIndicator = MSI_MemberService.UNAVAILABLE;
                                                    
            for( MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_element memberDetail : MemberDetailsList ) {
                member = new MSI_MemberSummaryResponse.Member();
                member.firstName = memberDetail.memFirstName;
                member.lastName = memberDetail.memLastName;
                member.memberSuffix = memberDetail.memberSuffix;
                member.relationship = memberDetail.memRelationship; // relationship code 00-09
                member.relationshipDescription = memberDetail.memRelationshipDesc;
                member.relationshipCode = memberDetail.relationshipCode;
                member.relationshipCodeDesc = memberDetail.relationshipCodeDesc;
                member.memberID = memberDetail.memSSN;   
                member.memberContrivedKey = memberDetail.memberContrivedKey;
                member.dateOfBirth = memberDetail.memDOB;
                
                // address info not available on member detail - same as Subscriber per Facets Team/Maruthi Mudiyur
                member.streetAddress1 = summary.SubscriberAddressDetails[0].subAddrLine1;   
                member.streetAddress2 = summary.SubscriberAddressDetails[0].subAddrLine2;    
                member.streetAddress3 = summary.SubscriberAddressDetails[0].subAddrLine3;    
                member.city = summary.SubscriberAddressDetails[0].subCity;
                member.state = summary.SubscriberAddressDetails[0].subState;
                member.zipCode = summary.SubscriberAddressDetails[0].subZip;
                member.phone = memberDetail.memWorkPhone;
                            
                //--------------process MEEL segment--------------------
                // This segment is used to create 2 maps - (a) of classPlanID to =>eligType and (b) =>eligTypeDescription
                // these maps are used for eligType and eligTypeDescription population when processing MEPE (Member Process Eligibilitity) based on their
                // classPlanID field
                // Note: if there are no MEEL segments returned, it is possible some eligibilities may not be populated with eligType,eligDesc
                // when processing MEPE segment elements
                //
                Map<String,String>  classPlanToEligTypeMap = new Map<String,String>();
                Map<String,String>  classPlanToEligTypeDescMap = new Map<String,String>();
                
                if(memberDetail.MemberEligibilityDetails !=null) {
                 for(MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_MemberEligibilityDetails_element meel : memberDetail.MemberEligibilityDetails) {
                    if( !String.isBlank(meel.classPlanID) && !String.isBlank(meel.memEligType) ) 
                        classPlanToEligTypeMap.put( meel.classPlanID, meel.memEligType);
                        
                    if( !String.isBlank(meel.classPlanID) && !String.isBlank(meel.memEligTypeDesc) ) 
                        classPlanToEligTypeDescMap.put( meel.classPlanID, meel.memEligTypeDesc);                
                 } 
                }                              
                //----------------------------------------------------------------
                MSI_MemberSummaryResponse.Eligibility me; 
                
                for( MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_MemberProcessEligibilityDetails_element eligibility : memberDetail.MemberProcessEligibilityDetails) {             
                    me = new MSI_MemberSummaryResponse.Eligibility();
                    
                        // if not already set, create a List<> to hold eligibilities for each class plan ID
                        // this list will be used to add current and then historical eligilbilities for the member for each classplan id for which
                        // it has an eligibility
                    if( member.eligibilityMap.get( eligibility.classPlanID) == null) {
                        member.eligibilityMap.put( eligibility.classPlanID, new List<MSI_MemberSummaryResponse.Eligibility>());
                    }
                    
                    me.typex = (String) classPlanToEligTypeMap.get(eligibility.classPlanID);
                    me.typeDescription = (String) classPlanToEligTypeDescMap.get(eligibility.classPlanID);          
                    me.effectiveDate = eligibility.memProcessEligEffDate;
                    me.terminationDate = eligibility.memProcessEligTermDate;
                    if( !String.isBlank( me.terminationDate) && me.terminationDate.indexOf( '12/31/9999') != -1  )
                        me.terminationDate = '';    // Defect ID : 106725 User is able to view the Termination date value as "12/31/9999" in Salesforce where empty value is displaying in facets
                    
                    
                    me.memProcessEligInd = eligibility.memProcessEligInd;
                    
                    // Roll up eligibility indicator. 
                    // If group status is UKNOWN, roll up eligibility = Unknown
                    // If gorup statis is TERMINATED, roll up eligibliity = N
                    // If group status is ACTIVE, roll up = logical OR of member eligibilities i.e. it is Y if even one member elig is 'Y'.  
                    // If even one member eligbility is a 'Y', the roll up is 'Y'. Roll up is 'N' only if all individual eligbilities
                    // are 'N'. Blank value is treated as  a 'N' i.e. No
                    Date termDate = convertFacetsDateToSFDate( eligibility.memProcessEligTermDate );
                    if(    isGroupTerminated == MSI_MemberService.ACTIVE  
                        && Date.today() <= termDate     // only process eligibilities with a blank (not-termiatned) or future termination date 
                        && 'Y'.equals (me.memProcessEligInd) 
                        )
                            rollUpEligibilityIndicator = 'Y';
                                        
                    me.memProcessEligIndDesc = eligibility.memProcessEligIndDesc;
                    me.classPlanID = eligibility.classPlanID;
                    me.planDescription = planIdToDescriptionMap.get( me.classPlanID );  // use classPlanID to description map from subscriber eligibility segment
                    me.classId = eligibility.classId;
                    me.productID = eligibility.productID;
                    me.productDesc = eligibility.productDesc;
                    me.productCategory = eligibility.productCategory;   
                    
                    if( me.productCategory != null) {
                        me.productCategoryDescription =  MSI_MemberService.ProductCategoryDescriptionByCategoryMap.get( me.productCategory);
                    } else {
                        me.productCategoryDescription = '';
                    }
                    
                    List<MSI_MemberSummaryResponse.Eligibility> eligibilityListForCurrentClassPlanID = member.eligibilityMap.get( me.classPlanID);
                    eligibilityListForCurrentClassPlanID.add( me );
                    
                    // TBD: remove - not map value is a list not a single eligiblity to accomodate adding historicaleligbilitiles. 
                    // member.eligibilityMap.put( me.classPlanID, me);  
                }
                //------ add built Member to map
                //MSI_MemberSummaryResponse.flattenEligibilityMap( member );
                //System.debug( 'Flattened elig member: ' + JSON.serializePretty( member ) );
                memberDetailsMap.put( member.memberID, member);         
            }
            
            subscriber.memberDetailsMap = memberDetailsMap;
            System.debug( 'Setting subscriber.subEligibilityIndicator = ' + rollUpEligibilityIndicator);
            subscriber.subEligibilityIndicator = rollUpEligibilityIndicator;
            response.addSubscriber ( subscriber );          
}


/* 
/*************************************************************************************
 * Purpose   : This method accepts the Eligibility termination date in format returned by the 
 *             MemberSummary service 'MM/DD/YYYY' e.g. '04/01/2013'. If the input parameter facestDate
 *             does not conform to the above pattern or is blank, today's Date.today() is returned
 *             else a Date instance based on parsing the MM,DD,YYYY pieces of input Facetsdate string
 *             is created and returned.
 *
 * Parameters: String facetsDate
 *
 * Return    : Date.Today() if input is blank or non-conforming format else Date created based on mm,dd,yyyy
 *************************************************************************************/

public static Date convertFacetsDateToSFDate( String facetsDate ) {
    if (String.isBlank( facetsDate )) 
        return Date.today();
        
    String s= facetsDate;
    
    if( s.length() == 10 && s.indexOf('/') == 2 && s.lastIndexOf('/') == 5 ) {
        // it is a valid Facets date string in format 'MM/DD/YYYY'
    } else {
        System.debug( 'Invalid date received in convertFacetsDateToSFDate(): ' + s);
        return Date.today();
    }
    
    String sDate = s.substring(6,6+4) + '-' + s.substring(0,2) + '-' + s.substring(3,5) + ' 00:00:00';
    return Date.valueOf( sDate );
}

/* 
/*************************************************************************************
 * Purpose   : This method will retrieve Group active/terminated status by invoking the FacetsGroup2 webservice.
 *
 * Parameters: Group ID whose termination status is to be checked
 *
 * Return    : Will return one of 'Y' - is terminated , 
 *                                'N' - not terminated i.e. active, 
 *                                'Unavailable' (unknown - if service could not be invoked successfuly)
 *************************************************************************************/
public static String isGroupTerminated( String groupID ) {
    if( String.isBlank( groupID ) ) { 
        System.debug( 'MSI_MemberService.getGroupTerminatedStatus( String groupID ) invoked with a blank/null argument');
        return MSI_MemberService.UNAVAILABLE;
    }
    
    MSI_FacetsGroup2Request request = new MSI_FacetsGroup2Request();
    request.groupID = groupID;
    MSI_FacetsGroup2Response response = MSI_FacetsGroup2Service.getTerminatedStatusUsingHTTP( request );
    
    String returnValue;
    if( response.statusCode == IntegrationMessage.REMOTE_ERROR ) {
        returnValue = MSI_MemberService.UNAVAILABLE;
    } else {
        returnValue = response.isTerminated == true?  MSI_MemberService.TERMINATED : MSI_MemberService.ACTIVE;
    }

    return returnValue;
}


/*************************************************************************************
 * Purpose   : This is a utility method that consolidates some common setup code to get 
TBD
*/

public static Map< String, Map<String, List<MSI_MemberSummaryResponse.Eligibility>> > getHistoricalEligibilities( String subscriberID ) {

        // Top level data structure: Map of GroupID-> Map of< MemberID, EligiblityList>
    Map< String, Map<String, List<MSI_MemberSummaryResponse.Eligibility>> > groupToMemberEligMap = 
                new Map<String,  Map<String, List<MSI_MemberSummaryResponse.Eligibility>> >();      

    MSI_MemberSummaryResponse response = null;
    Boolean notifySupportTeam = false;
   try {
        MSI_MemberServiceProxy.OperationsOfMemberEndpoint1 service = MSI_MemberService.getService();
        MSI_MemberServiceProxy.memberEligibilityRequestMessage_EligibilityRequest_element requestElement = 
                new MSI_MemberServiceProxy.memberEligibilityRequestMessage_EligibilityRequest_element();
         
        requestElement.subscriberID = subscriberID ;
        
        Date dt = Date.Today();
        dt = dt.addDays(-1);
        Datetime dtm = DateTime.newInstance( dt.year(), dt.month(), dt.day());
        
        requestElement.eligibilityEndDate = dtm.format('MM/dd/yyyy') ;
         
        MSI_MemberServiceProxy.memberEligibilityResponseMessage_element proxyResponse =
                              service.GetMemberProdElig(requestElement);
                              
        System.debug( proxyResponse);
        System.debug( 'JSON proxyresponse for MSI_MemberServiceProxy.memberEligibilityResponseMessage_element =' + JSON.serialize(proxyResponse));  // to capture response for mock object      
        System.debug('Received response from MSI service GetMemberProdElig operation: ' + String.valueOf(proxyResponse));  
        
        Integer resultCode = Integer.valueOf(proxyResponse.StatusBlock.statusCode.trim());
        if( resultCode != 0) {  
            // Parse Error (Fault Message) Error code response from the remote system
            String statusDescription = ''; 

            // proxyResponse.StatusBlock.Message is only set if there is an error
            for(Integer i=0; i < proxyResponse.StatusBlock.Message.size(); i++) {
                MSI_MemberServiceProxy.StatusBlock2_Message_element element = proxyResponse.StatusBlock.Message[i];
                statusDescription = + 'mesgCode=' + element.mesgCode + ', mesgDesc=' + element.mesgDesc + ' ; ';
                System.debug( statusDescription );
            }


            System.debug('Error response from MSI service: ' + statusDescription);
            notifySupportTeam = true;       
        } else {        
            // Parse success response from MSI system

            MSI_MemberServiceProxy.memberEligibilityResponseMessage_EligibilityResponse_element[] eligibilityList = proxyResponse.EligibilityResponse;
            System.debug('number of Eligibilities=' + eligibilityList.size());
            
            if( eligibilityList != null && eligibilityList.size() > 0 ) {


                    // temp variables
                Map<String, List<MSI_MemberSummaryResponse.Eligibility>> memberToEligMapOfLists = null;
                List<MSI_MemberSummaryResponse.Eligibility> meList = null;
                MSI_MemberSummaryResponse.Eligibility me = null;

                    // Loop-1 By Group eligibilities for a particular subscriber
                System.debug('Received group level eligibility list in response of size : ' + eligibilityList.size());

                for( MSI_MemberServiceProxy.memberEligibilityResponseMessage_EligibilityResponse_element eligibility : eligibilityList ) {
                        System.debug('Eligibility :' + eligibility);    

                        memberToEligMapOfLists = new Map<String, List<MSI_MemberSummaryResponse.Eligibility>>();
                        
                            // Loop-2 - Member Eligibility Summary by Member ID
                        System.debug( 'Processing list for GroupID : ' + eligibility.goupID );
                        for( MSI_MemberServiceProxy.memberEligibilityResponseMessage_EligibilityResponse_MemberEligibilityDetails_element memberEligibilityDetail : 
                            eligibility.MemberEligibilityDetails ) {

                            String memberID = memberEligibilityDetail.memberContrivedKey;
                            
                            meList = new List<MSI_MemberSummaryResponse.Eligibility>();
                            memberToEligMapOfLists.put( memberID, meList);

                            // Loop-3 - Process Product Eligibilities for current memberID
                            System.debug('Processing for product eligibility list for memberID = ' + memberID + ' of size= ' + memberEligibilityDetail.ProductEligibilityDetails.size());
                            for( MSI_MemberServiceProxy.memberEligibilityResponseMessage_EligibilityResponse_MemberEligibilityDetails_ProductEligibilityDetails_element memberProdEligibility : memberEligibilityDetail.ProductEligibilityDetails ) {
                                if( String.isBlank( memberProdEligibility.memProcessEligTermDate ) 
                                    || '12/31/9999'.equals(memberProdEligibility.memProcessEligTermDate) 
                                  ) 
                                    continue;   // skip gibilities with a blank termation date i.e. current/future.Only process historical/terminated elig.
                                Date ystrday = Date.Today();
                                ystrday = dt.addDays(-1);
                                Datetime dtm_ystrday = DateTime.newInstance( dt.year(), dt.month(), dt.day());
                                //system.debug('**dtm_ystrday **'+dtm_ystrday );
                        
                                Datetime currentTerminationDate = convertFacetsDateToSFDate( memberProdEligibility.memProcessEligTermDate );
                                //system.debug('**currentTerminationDate **'+currentTerminationDate);
                                if( currentTerminationDate > dtm_ystrday ) {
                                    System.debug('Discarding non-historical eligibility from received product eligibilities: ' + JSON.serializePretty( memberProdEligibility ));
                                    continue;   // ignore current and future eligibilities.
                                }
                                    
                                me = new MSI_MemberSummaryResponse.Eligibility();
                                me.effectiveDate = memberProdEligibility.memProcessEligEffDate;
                                me.terminationDate = memberProdEligibility.memProcessEligTermDate;
                                // me.seqDate = memberProdEligibility.
                                // me.typex = memberProdEligibility.    
                                // me.typeDescription = memberProdEligibility.
                                
                                me.productCategory = memberProdEligibility.productCategory;
                                me.productCategoryDescription   = MSI_MemberService.ProductCategoryDescriptionByCategoryMap.get( me.productCategory);
                                // me.productDesc = memberProdEligibility.              // TBD: Not available in response, have to get from elsewhere
                                me.productID = memberProdEligibility.productID;
                                        
                                me.classId = memberProdEligibility.classID;
                                me.classPlanID = memberProdEligibility.classPlanIdentifier;


                                //me.planDescription = memberProdEligibility.           // TBD: Not available in response. Would have to get from elsewhere
                                me.familyID = memberProdEligibility.familyIndicator;    // TBD: Confirm this field mapping
                                me.reasonCode = memberProdEligibility.explanationCode;  // TBD: Confirm field mapping
                                //me.voidIndicator = memberProdEligibility.     
                                
                                me.memProcessEligInd = memberProdEligibility.memProcessEligInd;  
                                me.memProcessEligIndDesc = memberProdEligibility.memProcessEligInd == 'Y' ? 'Eligibile' : 'Not Eligible' ;
                                /*
                                    public class memberEligibilityResponseMessage_EligibilityResponse_MemberEligibilityDetails_ProductEligibilityDetails_element 
                                        public String productCategory;
                                        public String classID;
                                        public String classPlanIdentifier;
                                        public String productID;
                                        public String memProcessEligInd;
                                        public String memProcessEligOverrideInd;
                                        public String familyIndicator;
                                        public String memProcessEligPreexistingCondInd;
                                        public String delinquencyProcessingInd;
                                        public String explanationCode;
                                        public String memEligibilityReason;
                                        public String memStatus;
                                        public String eligibilitySource;
                                        public String ineligibleCode;
                                        public String planEntryDate;
                                        public String memProcessEligEffDate;
                                        public String memProcessEligTermDate;
                                */


                                meList.add( me );
                            }   // End Loop-3
                            
                        } // End Loop-2

                            // Add Eligibilities under appropriate Group to Member map
                        if( !String.isBlank( eligibility.goupID) && groupToMemberEligMap.get( eligibility.goupID ) == null) {
                            groupToMemberEligMap.put( eligibility.goupID, memberToEligMapOfLists );

                        } else if ( groupToMemberEligMap.get( eligibility.goupID ) != null) {
                            System.debug( 'Got same GroupID in more than one entry in returned MSI_MemberServiceProxy.memberEligibilityResponseMessage_EligibilityResponse_element[] eligibilityList response');
                        }
                        
                } // End Loop-1
                    System.debug( JSON.serializePretty( groupToMemberEligMap ) );
            } // End if( eligibilityList != null && eligibilityList.size() > 0 )
           
            } // end else
           
            //MSI_MemberService.prettyPrint(response);  // will log the formatted response to System.debug log          
                          
    } catch (Exception e) {
        System.debug( 'Exception type= ' + e.getTypeName() + ' , message= ' + e.getMessage() );
        notifySupportTeam = true;
    } // end try-catch      



    return groupToMemberEligMap;
}


/*

histroical - map of globalPlanIdToDescriptionMap

*/
public static void mergeCurrentAndHistoricalEligibilities( MSI_MemberSummaryResponse response  , 
Map< String, Map<String, List<MSI_MemberSummaryResponse.Eligibility>> > historical, Map<String,String> planDescriptionMap ) {
 
 System.debug( 'Merging historical eligibilities with current eligibilities ...');
 Map<String,MSI_MemberSummaryResponse.Subscriber> subscriberByGroupMap = response.subscriberByGroupMap;
 
 for( String groupID : subscriberByGroupMap.keySet()) {
    MSI_MemberSummaryResponse.Subscriber subscriber = subscriberByGroupMap.get( groupID );
    Map<String,MSI_MemberSummaryResponse.Member> memberDetailsMap = subscriber.memberDetailsMap;

    for( String memberID : memberDetailsMap.keySet() ) {
        
            // For a member, get classplanid->elig list map
        MSI_MemberSummaryResponse.Member member =  memberDetailsMap.get( memberID);
        String memberContrivedKey = member.memberContrivedKey;
        Map<String, List<MSI_MemberSummaryResponse.Eligibility>> currentEligibilityMap =  member.eligibilityMap;

        for( String currentClassPlanID : currentEligibilityMap.keySet() ) {
            
            // Now we have groupID, memberID, classplan ID, we can extract corresponding from historical elig map argument and add to the elig list in response
            Map<String, List<MSI_MemberSummaryResponse.Eligibility>> historicalMemberEligMap = historical.get( groupID );   // get for group, member->elig map
            if( historicalMemberEligMap == null ) { System.debug(' historicalMemberEligMap null for group ID' + groupID ); continue; }          
            System.debug( 'Serialize pretty of historicalEligMap = ' +  JSON.serializePretty( historicalMemberEligMap) );

            List<MSI_MemberSummaryResponse.Eligibility> historicalEligList = historicalMemberEligMap.get( memberContrivedKey);
            if( historicalEligList == null) {   System.debug(' historicalEligList null for member ID=' + memberID); continue; }
            
            // The historicalEligList has all historical elig for a given member. Now merge them to response current eligibilities
                    
            List<MSI_MemberSummaryResponse.Eligibility> currentEligListForClassPlanID = currentEligibilityMap.get( currentClassPlanID );
            String planDesc = null;
            for( MSI_MemberSummaryResponse.Eligibility historicalElig : historicalEligList) {
                if( historicalElig.classPlanID == currentClassPlanID ) {
                    planDesc = planDescriptionMap.get( currentClassPlanID );

                    if( !String.isBlank( planDesc) ) 
                        historicalElig.planDescription = planDesc;
                    else 
                        System.debug('Warning: Populating historical elig - Missing planDescription for classplanID= ' + currentClassPlanID);
                    
                    currentEligListForClassPlanID.add( historicalElig );
                }               
            }
        }           
    } // end for( String memberID : memberDetailsMap.keys() ) 
    
 }  // end for( String groupID : subscriberByGroupMap.keys())
    
}


/*************************************************************************************
 * Purpose   : Deprecated
               This is a utility method that consolidates some common setup code to get 
 *             a callable MSI_MemberServiceProxy endpoint. It returns an instance of the web service callout
 *             MSI_MemberServiceProxy endpoint - OperationsOfMemberEndpoint1(). It takes care of configuring MSI
 *             specific parameters like the endpoint URL (which varies by environment), client certificate
 *             name to use etc. 
 *             The returned service callout object is used by the higher level methods.
 *
 * Parameters: None
 *
 * Return    : MSI_MemberServiceProxy.OperationsOfMemberEndpoint1
 *************************************************************************************/

/*public static MSI_MemberServiceProxy.OperationsOfMemberEndpoint1 getService() {
    MSI_MemberServiceProxy.OperationsOfMemberEndpoint1  service = new MSI_MemberServiceProxy.OperationsOfMemberEndpoint1();
    
    if(!MSI_MemberService.isInitialized) {  
        throw new MSI_MemberService.MSI_Exception('MSI_MemberService is not initialized'); 
    }
    
    String clientCertificateName = MSI_MemberService.msiClientCertificateName;
    String endPointURL = MSI_MemberService.msiEndPointURL;
    
        Integer requestTimeout;
        try {
         requestTimeout = Integer.valueof(MSI_MemberService.msiRequestTimeout);
        } catch (Exception e) {
        System.debug('Error processing timeout value=' + MSI_MemberService.msiRequestTimeout + ': defaulting to 60,000 (60 seconds)');
        requestTimeout = 60000;
    }

    // The Facets service uses BASIC authentication. This code creates the authorization header
    Map<String,String> securityHeaders = new Map<String,String>();
    String username = MSI_MemberService.msiUserName;
    String password = MSI_MemberService.msiUserPassword;

    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
    securityHeaders.put( 'Authorization', authorizationHeader);


    System.debug('Using MSI_MemberService web service settings: msiClientCertificateName=' + clientCertificateName + 
                  ', msiRequestTimeout=' + requestTimeout + ', msiEndPointURL=' + endPointURL +
                  ', msiUserName=' + username + ', msiUserPassword=' + password);
    
    service.clientCertName_x = clientCertificateName;
    service.timeout_x = requestTimeout;
    service.endpoint_x = endPointURL;
    //laveen added 
    //service.clientCert_x = username ;
    //service.clientCertPasswd_x = password ;
    service.inputHttpHeaders_x = securityHeaders;
    return service;
}*/


/*************************************************************************************
 * Purpose   : This is a utility method that consolidates some common setup code to get 
 *             a callable MSI_MemberServiceProxy endpoint. It returns an instance of the web service callout
 *             MSI_MemberServiceProxy endpoint - OperationsOfMemberEndpoint1(). It takes care of configuring MSI
 *             specific parameters using Named credentials
 *             The returned service callout object is used by the higher level methods.
 *
 * Parameters: None
 *
 * Return    : MSI_MemberServiceProxy.OperationsOfMemberEndpoint1
 *************************************************************************************/
 //US616-BEGIN CHANGE
 public static MSI_MemberServiceProxy.OperationsOfMemberEndpoint1 getService() {
    MSI_MemberServiceProxy.OperationsOfMemberEndpoint1  service = new MSI_MemberServiceProxy.OperationsOfMemberEndpoint1();
    
    if(!MSI_MemberService.isInitialized) {  
        throw new MSI_MemberService.MSI_Exception('MSI_MemberService is not initialized'); 
    }
    
    //API Gateway - Named credential    
    String endPointURL = 'callout:MSIMemberService';
    
        Integer requestTimeout;
        try {
         requestTimeout = Integer.valueof(MSI_MemberService.msiRequestTimeout);
        } catch (Exception e) {
        System.debug('Error processing timeout value=' + MSI_MemberService.msiRequestTimeout + ': defaulting to 60,000 (60 seconds)');
        requestTimeout = 60000;
    }

    service.timeout_x = requestTimeout;
    service.endpoint_x = endPointURL;
    return service;
}
//END CHANGE





public static String prettyPrint( MSI_MemberSummaryResponse response) {
    String s = '';
    String sp = ' '; // separator - space
    String spn = '\n';  // separator - newline
    String spc = ', '; // separator - comma

    s +=
    spn + spn +
    'Response has a total of ' + response.subscriberByGroupMap.size() + ' subscriber group records' +spn;
    
    for( MSI_MemberSummaryResponse.Subscriber subscriber : response.subscriberByGroupMap.values() ) {
    // Subscriber details
    s += 
    spn + spn +
    '-------------------------------------------\n'  + 
    'Subscriber Details: \n' + spn +  
    'Subscriber ID = ' + subscriber.subscriberID + spn  + 
    'Subscriber Contrived Key = ' + subscriber.subscriberContrivedKey + spn + 
    'GroupID = ' + subscriber.groupID + spn  + 
    'Group Name = ' + subscriber.groupName+ spn  + 
    'Group Contrived Key = ' + subscriber.groupContrivedKey + spn  + 
    'Subscriber Last Name = ' + subscriber.subscriberLastName + spn  + 
    'Subscriber First Name = ' + subscriber.subscriberFirstName + spn  + 
    'Street Address1 = ' + subscriber.subscriberStreetAddress1 + spn  + 
    'Street Address2 = ' + subscriber.subscriberStreetAddress2 + spn  + 
    'Street Address 3 = ' + subscriber.subscriberStreetAddress3 + spn  + 
    'City = ' + subscriber.subscriberCity + spn  + 
    'State = ' + subscriber.subscriberState + spn  + 
    'Zip = ' + subscriber.subscriberZip + spn  + 
    'Subscriber Org. Effective Date = ' + subscriber.subOrgEffectiveDate + spn +
    'Subscriber Eligiblity Indicator = ' + subscriber.subEligibilityIndicator + spn +
    'Subscriber Original Subscriber ID = ' + subscriber.subOriginalSubscriberID
    ;
    //---------------------------
    // Subscriber Eligibilities
    s += spn + 
    'Subscriber Eligibility Details \n' +
    '-------------------------------------------\n'; 
    
    s+= 'Number of subscriber eligibilities received = ' +  subscriber.subEligibilityMap.size() + spn;
    
    for(MSI_MemberSummaryResponse.Eligibility sElig : subscriber.subEligibilityMap.values()) {
        s += 
        '[ Eligibility ] : ' +
        'effectiveDate = ' + sElig.effectiveDate + spc +
        'seqDate = ' + sElig.seqDate + spc +
        'type = ' + sElig.typex + spc +
        'typeDescription = ' + sElig.typeDescription + spc +
        'productCategory = ' + sElig.productCategory + spc +
        'productCategoryDescription = ' + sElig.productCategoryDescription + spc +
        'classPlanID = ' + sElig.classPlanID + spc +
        'planDescription = ' + sElig.planDescription + spc +
        'familyID = ' + sElig.familyID + spc +
        'reasonCode = ' + sElig.reasonCode + spc +
        'voidIndicator = ' + sElig.voidIndicator + spc +
        spn;
    }
    
    //------------------------------
    // Member Details
    s += 
    spn +
    '-----Members Information Section-----------------------\n';
    s+= 'Number of Members received = ' +  subscriber.memberDetailsMap.size() + spn;
    
    for( MSI_MemberSummaryResponse.Member member : subscriber.memberDetailsMap.values() ) {
        s +=
        '------------------------------------------------' + spn +
        '[Member summary]: ' +  
        'firstName = ' + member.firstName + spc +
        'lastName = ' + member.lastName + spc +
        'memberSuffix = ' + member.memberSuffix + spc +     
        'relationship= ' + member.relationship  + spc +
        'relationshipDescription= ' + member.relationshipDescription  + spc +
        'relationshipCode= ' + member.relationshipCode  + spc +
        'relationshipCodeDesc= ' + member.relationshipCodeDesc  + spc +                     
        'memberID = ' + member.memberID  + spc +
        'memberContrivedKey = ' + member.memberContrivedKey + spc +
        'dateOfBirth = ' + member.dateOfBirth  + spc +
        'streetAddress1 = ' + member.streetAddress1 + spc +
        'streetAddress2 = ' + member.streetAddress2  + spc +
        'streetAddress3 = ' + member.streetAddress3 + spc +
        'city = ' + member.city  + spc +
        'state = ' + member.state + spc +
        'zipCode = ' + member.zipCode  + spc +
        'phone = ' + member.phone  + 
        spn;
        
        s += 
        'Member Eligibility Details \n' +
        '-------------------------------------------\n';
        Integer totalEligibilities = 0;
        for( List<MSI_MemberSummaryResponse.Eligibility> lst : member.eligibilityMap.values() ) {
            totalEligibilities += lst.size();
        }
        
        s+= 'Number of Eligibilities received for this member = ' +  totalEligibilities + spn;      
        for( List<MSI_MemberSummaryResponse.Eligibility> lst : member.eligibilityMap.values()) {
            for( MSI_MemberSummaryResponse.Eligibility me : lst ) {
                s +=
                '[Eligibility] : '  +
                'effectiveDate =' + me.effectiveDate + spc +
                'terminationDate =' + me.terminationDate  + spc +
                'classPlanID =' + me.classPlanID  + spc +
                'classId =' + me.classId  + spc +
                'productID =' + me.productID  + spc +
                'productDesc =' + me.productDesc  + spc +
                'productCategory =' + me.productCategory  + spc +
                'productCategoryDescription = ' + me.productCategoryDescription + spc +
                'type =' + me.typex + spc +
                'typeDescription =' + me.typeDescription + spc +    
                'memProcessEligInd =' + me.memProcessEligInd + spc +    
                'memProcessEligIndDesc =' + me.memProcessEligIndDesc + spc +    
                spn;
            }
        }
    }
    
    } // end all subscriber loop
    
    System.debug( s );
    return s;
}

}