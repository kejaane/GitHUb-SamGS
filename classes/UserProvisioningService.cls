/*=========================================================================================
 * Date         :  04/01/17
 * Developer    : Ken Gill 
 * Purpose      : This class is a SOAP webservice implementation to support provisioning of 
 *                Salesforce Community users based on a feed of provisioning messages from the CareFirst CIAM
 *                system which is the system of record for Broker Agent accounts. It handles BAA,BAM and BAT 
 *                message types from CIAM. This service is configurable through various settings defined in 
 *                UserProvisioningConfig__mdt for org. portability and maintenance reasons.
 *                 
 *                Use Case 1: Create a Community User (BAA)
 *                Use Case 2: Modify an existing Community User (BAM)
 *                Use Case 3: Terminate (i.e. deactivate) a Community User (BAT)
 *                
 *                An important consideration is that the handling of any specific CIAM message is not solely 
 *                determined by the message type but also the existence or lack thereof of a matching User and 
 *                Community Contact in Salesforce. As a result, the code has to sometimes treat a BAA as a BAM and
 *                vice versa. CIAM does not track the current state of Community User records.
 *
 *                All parameter names in the received message attributes Map<String,String> name-value pairs are
 *                converted to uppercase before comparision to prevent any case-sensitive issues in detecting the 
 *                type of parameter name in the NV pair.
 *
 *                All recieved messages and response transactions are logged to the Integration 
 *                logging framework. Any internal processing errors as indicated by a msgCode=INTERNAL_ERROR 
 *                response also generate email notifications to internal and external support addresses 
 *                that are configurable.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Deve     Tag    Description
 *===========+========+====+================================================================
 * 04/01/17  |  KG    |      Initial Version                                         
 * 05/26/17  |  KG    |      Fix for defect 115547 Error Message  : 498; Detail= Upsert failed. First exception on row 0; 
 *           |        |      first error: DUPLICATE_VALUE, duplicate value found: unknown duplicates value on record with id: 0031100001JQv69
 *           |        |      Issue occurs because fields RectType_ENtity_ID__c and RecType_Broker_NPN__c are defined as unique case sensitive which
 *           |        |      is populated by the workflow rule and fails if Entity_ID__c is populated. Updated Contact.Workflow: Workflow Rule 'BSSWF Populate Contact RecType_Entity_ID' evaluation criteria to not fire if Record Type Name = 
 *           |        |      'Community User Contact'.
 * 06/12/17  |  SU    |       Updated User Name & Nickname fields. GUID was added to them.
 * 06/21/17  |  SU    | 001 | Added a Boolean variable
 * 06/21/17  |  SU    | 002 | Defaults are not recommended beacuse if the data is not correct it should error out.
 * 06/27/17  |SU      | 003 | Agency_Agent_id should not be populated to Entity_ID__c because Community Contacts do not need to use this field.
 * 06/22/17  |  SU    | N/A | If you encounter "Missing UserProvisioning configuration Could not retrieve a Community User Account record ID" exception the cause could be duplicate "Community_User_Account".
 *           |  | 004 | 
 * 06/30/17  | AO     |      changes to look for first 9 characters of agency_agent_id to find the id of the matching Account record
 * 8/27/2017 | LK     |      Update the code to not change User's Profile & License  in BAM Transaction
 *=========================================================================================
 */



global class UserProvisioningService {
    
public class UserProvisioningServiceException extends Exception {}

    public static Boolean isTest = false; // Added a Boolean TAG 001
    
    public static String MessageType = 'TRN_MSG_TYPE';
    
    // Attribute Names in service invocation Name-Value pairs
    public static String AgentFirst = 'FRST_NM';
    public static String AgentMiddle = 'MID_NM';
    public static String AgentLast = 'LAST_NM';
    public static String AgentEmail = 'EMAL_ADDR';  
    public static String AgentID = 'SSN';
    public static String AgentTitle = 'BRKR_TITL';
    public static String AgencyID   = 'TAX_IDNTN_NBR';
    public static String AgencyName = 'DSTBR_NM';
    public static String PortalID = 'USER_ID';  
    public static String Guid = 'UID';
    public static String AgencyRole = 'ASST_BRKR_INDC';


    // Valid CIAM message types 
    public static String MessageType_BAA = 'BAA';
    public static String MessageType_BAM = 'BAM';   
    public static String MessageType_BAT = 'BAT';
    
    public static Set<String> Valid_MessageTypes = new Set<String> { MessageType_BAA, MessageTYpe_BAM, MessageType_BAT };
    

    // Parameters that must be received for UC: Create Community User
    public static List<String> requiredCreateUserParameters = new List<String> {
        AgentFirst,
        AgentLast,
        AgentEmail,
        AgentID,
        PortalID,
        Guid,
        AgencyID,
        AgencyName,
        AgencyRole
    };

    // Parameters that must be received for UC: Update/Modify Community User    
    public static Set<String> allowedModifyParameters = new Set<String>{
        AgentFirst,
        AgentMiddle,
        AgentLast,
        AgentEmail,
        AgentID,
        AgentTitle,
        PortalID,
        AgencyID,
        AgencyName,
        AgencyRole
    };

    // web service response message structure
    global class Response {
        webservice Integer  msgCode;
        webservice String   msgDescription;
        
        public Response( Integer msgCode, String msgDesc) {
            this.msgCode = msgCode;
            this.msgDescription = msgDesc;
        }
        
        // merge response objects. msgCode is selected to be the highest message code, message descriptions merged
        public Response mergeResponse( Response inResponse ) {
            if( inResponse == null) return this;
            if( inResponse.msgCode > msgCode)
                msgCode = inResponse.msgCode;
            msgDescription += '; ' + inResponse.msgDescription;
            return this;
        }       
    }
    
    // Constants to define possible response types
    public static Response SUCCESS = new Response(0, 'Success');    
    public static Response WARNING = new Response(1, 'Warning');
    public static Response INVALID_INPUT = new Response(2, 'Error - Input Validation');
    public static Response INTERNAL_ERROR = new Response(3, 'Error -Internal Processing');

    
    // webservice input parameter definition.
    global class NameValue {
        webservice String name;
        webservice String value;
        
        global NameValue( String n, String v) {
            name = n;
            value = v;
        }
    }
    
    // service configuration settings. Populated from custom metadata type UserProvisioiningConfig__mdt.
    // There are 3 config records - DEV, QA, PROD defined in the MDT. The IsActive__c field selects which 
    // configuration record is used in a given org.
    
    global class Configuration {
         public  String ProfileName;
         public  String CommunityProfileId; // auto-populated in initialization, need not be set in MetaDataType config object
         public  String UserLicenseString;
         public  String UserRoleString;
         public  String LicenseCategoryString;
         public  String InternalSupportEmail;
         public  String ExternalSupportEmail;   
         
         public  String EmailEncodingKey;
         public  String LanguageLocaleKey;
         public  String LocaleSidKey;
         public  String TimeZoneSidKey; 
         
         public  Boolean SendUserEmail;             // send user welcome notification upon user creation or not
                                                    // set to false by default in the configuration as Broker Portal
                                                    // generates welcome email. Can be enabled for testing purposes if needed.
         
         public Id communityContactRecordTypeID;    // auto-populated at initialization, ID can vary by org
         public Id communityUserAccountID;          // auto-populated at initialization, ID can vary by org
         public String communityUserAccountName;    // auto-populated 
    }
    
    // service configuration object instance
    public static Configuration ServiceConfiguration ;
    
    
    /*************************************************************************************
     * Purpose   : This method initializes the service settings based on configuration settings
     *
     *             defined in UserProvisioningConfig__mdt. This is to avoid hardcoding several 
     *             settings into the code used for creating User and Community contact records. 
     *             It also derives necessary record IDs based on name of Profile, RecordType etc 
     *             to allow the code to be deployed in various orgs.
     *             
     * Parameters: config is a Configuration object that this method initializes based on 
     *             reading the custom metadata type config record.
     *
     * Return    : None
     *************************************************************************************/
    
    public static void initializeService(Configuration config) {
        System.debug ('Entered IniitializeService()');
        Boolean initError = false;
        String errorMessage = 'Missing UserProvisioning configuration ';
            
        // get settings for User provisioning service from defined custom metadata type UserProvisioningConfig__mdt
        UserProvisioningConfig__mdt[] configList = [ SELECT MasterLabel, EmailEncodingKey__c, 
                                                    ExternalSupportEmail__c, InternalSupportEmail__c, 
                                                    LanguageLocaleKey__c,LicenseCategoryString__c, LocaleSidKey__c, ProfileName__c, 
                                                    SendUserEmail__c, TimeZoneSidKey__c, UserLicenseString__c, Is_Active__c , CommunityUserAccountName__c
                                                    FROM UserProvisioningConfig__mdt
                                                    WHERE Is_Active__c = true  ];
/* Defaults are not recommended beacuse if the data is not correct it should error out. TAG 002 SU
        if( configList == null || configList.size() == 0) {
            // default to first alphabetical env name - should be usually DEV if no active config marked 
            configList = [ SELECT MasterLabel, EmailEncodingKey__c, 
                                                    ExternalSupportEmail__c, InternalSupportEmail__c, 
                                                    LanguageLocaleKey__c,LicenseCategoryString__c, LocaleSidKey__c, ProfileName__c, 
                                                    SendUserEmail__c, TimeZoneSidKey__c, UserLicenseString__c, Is_Active__c, CommunityUserAccountName__c 
                                                    FROM UserProvisioningConfig__mdt 
                                                    WHERE MasterLabel = 'DEFAULT'
                                                    LIMIT 1];
}
        // if no DEFAULT config for some reason                                                 
        if( configList == null || configList.size() == 0) {
            throw new UserProvisioningServiceException( 'Could not find any UserProvisioning configuration to use' );
        }                                                   
*/      

        // if no data found or multiple record marked ‘is active‘                                                
        if( configList == null || configList.size() == 0 || configList.size() > 1){
            throw new UserProvisioningServiceException( 'Could not find any UserProvisioning configuration to use or more then 1 configuration is Active!' );
        }        

        UserProvisioningConfig__mdt envConfig = configList[0];  // TODO: replace with env specific selection based on a ENV environment var/ cust setting to select master label DEV,TEST< PROD etc.>

        config.ProfileName = envConfig.ProfileName__c;
        if( String.isBlank( config.ProfileName) ) { initError = true; errorMessage += 'property: ProfileName,'; }
        
        config.UserLicenseString = envConfig.UserLicenseString__c;
        if( String.isBlank( config.UserLicenseString) ) { initError = true; errorMessage += 'property: UserLicenseString,'; }
        
        config.LicenseCategoryString = envConfig.LicenseCategoryString__c;
        if( String.isBlank( config.LicenseCategoryString) ) { initError = true; errorMessage += 'property: LicenseCategoryString,'; }
        
        config.InternalSupportEmail = envConfig.InternalSupportEmail__c;
        if( String.isBlank( config.InternalSupportEmail) ) { initError = true; errorMessage += 'property: InternalSupportEmail,'; }
        
        config.ExternalSupportEmail = envConfig.ExternalSupportEmail__c;
        if( String.isBlank( config.ExternalSupportEmail) ) { initError = true; errorMessage += 'property: ExternalSupportEmail,'; }
    
        config.EmailEncodingKey = envConfig.EmailEncodingKey__c;
        if( String.isBlank( config.EmailEncodingKey) ) { initError = true; errorMessage += 'property: EmailEncodingKey,'; }
        
        config.LanguageLocaleKey = envConfig.LanguageLocaleKey__c;
        if( String.isBlank( config.LanguageLocaleKey) ) { initError = true; errorMessage += 'property: LanguageLocaleKey,'; }
        
        config.LocaleSidKey = envConfig.LocaleSidKey__c;
        if( String.isBlank( config.LocaleSidKey) ) { initError = true; errorMessage += 'property: LocaleSidKey,'; }
        
        config.TimeZoneSidKey = envConfig.TimeZoneSidKey__c;
        if( String.isBlank( config.TimeZoneSidKey) ) { initError = true; errorMessage += 'property: TimeZoneSidKey,'; }
        
        config.communityUserAccountName = envConfig.CommunityUserAccountName__c;
        if( String.isBlank( config.communityUserAccountName) ) { initError = true; errorMessage += 'property: CommunityUserAccountName,'; }
        
        config.SendUserEmail = envConfig.SendUserEmail__c;
        
        
        // init profileId
        List<Profile> profileList = [ SELECT Id from Profile where Name = :config.ProfileName];
        if( profileList.size() == 1 && !isTest) {
            config.CommunityProfileId = profileList[0].Id;
        } else {
            String message;
            if( profileList.size() == 0) {
                initError = true; errorMessage +=  'Could not find profileID for profile name = ' + config.ProfileName;
            } else if( profileList.size() > 0 ) {
                initError = true; errorMessage +=  'Got multiple Ids for profile name = ' + config.ProfileName;
                errorMessage += '; query results = ' + profileList; 
            }
        }
        
        // Detect Community Account ID and Community Contact TypeRecord ID
        List<Account> tmpList =  [Select id from Account where Name = :config.communityUserAccountName];
        if( tmpList.size() == 1 ) {
            config.communityUserAccountID = tmpList[0].Id;
        } else {
            initError = true; errorMessage += 'Could not retrieve a Community User Account record ID';
        }

        config.communityContactRecordTypeID = Querybase.getRecordtypeId('Contact', 'Community_User_Contact');       
        if( String.isBlank( config.communityContactRecordTypeID) ) { initError = true; errorMessage += 'Could not find Community_User_Contact recordtype ID'; }
        
        if( initError ) {
            System.debug( errorMessage );
            throw new UserProvisioningServiceException( errorMessage );
        } else {
            System.debug(' Configured User Provisioning Service. Settings: ' + JSON.serializePretty( config ) );
        }
    }
    
    
    /*************************************************************************************
     * Purpose   : This is the main entry point of the service and corresponds to the SOAP
     *             action invoked by a caller. It receives a list of NameValue pairs that 
     *             represent the attributes received in the SOAP message. The List is converted 
     *             to a Map for ease of handling.  The code initializes the service first and then 
     *             checks required parameters are received. 
     *             
     *             All recieved messages and response transactions are logged to the Integration 
     *             logging framework. Any internal processing errors as indicated by a msgCode=INTERNAL_ERROR 
     *             response also generate email notifications to internal and external support addresses 
     *             that are configurable.
     *
     *             
     * Parameters:  attributes represents the NameValue pairs in the SOAP invocation message
     *
     * Return    : Response value includes a message code and message description. A SUCCESS response
     *             type represents success obviously. Other codes are 1- warning, 2-input errors, 3-internal
     *             error. The message description will provide a descriptive text message to explain the code
     *************************************************************************************/

    webservice static Response handleMessage( List<NameValue> attributes ) {
            // convert list to map for easier processing i.e looking up specific attribute values
        Map<String, String> attributeMap = convertListToMap( attributes );

        Response r; // web service response
        UserProvisioningRequest integrationRequest= new UserProvisioningRequest( attributeMap );
        UserProvisioningResponse integrationResponse;
        
        // handle edge case: Missing/Invalid service configuration settings
        try {
            ServiceConfiguration = new Configuration();
            initializeService( ServiceConfiguration );
        } catch( UserProvisioningServiceException e) {
            // internal error configuring web service
            r = UserProvisioningService.INTERNAL_ERROR;
            r.msgDescription = e.getMessage();
            integrationResponse = new UserProvisioningResponse( integrationRequest, r, ServiceConfiguration );
            integrationResponse.result = IntegrationMessage.STATUS_ERROR;
            logToIntegrationLog( new IntegrationMessage[] { integrationRequest, integrationResponse });
            // send email notifications if internal processing error (msgcode=3 in response)
            if( r.msgCode == INTERNAL_ERROR.msgCode ) 
                notifyError( integrationRequest, integrationResponse, ServiceConfiguration, true, true, true);
            
            return r;
        }
        
        
            // confirm transaction type & uid specified in each request
        r = hasRequiredCommonParameters( attributeMap );
        if( r.msgCode != 0) {
            integrationResponse = new UserProvisioningResponse( integrationRequest, r, ServiceConfiguration  );
            integrationResponse.result = IntegrationMessage.STATUS_ERROR; 
            logToIntegrationLog( new IntegrationMessage[] { integrationRequest, integrationResponse });
            // send email notifications if internal processing error (msgcode=3 in response)            
            if( r.msgCode == INTERNAL_ERROR.msgCode ) 
                notifyError( integrationRequest, integrationResponse, ServiceConfiguration, true, true, true);
            return r;
        }
        
        r = validateInputFields( attributeMap );
        if( r.msgCode != SUCCESS.msgCode && r.msgCode != WARNING.msgCode ) {
            integrationResponse = new UserProvisioningResponse( integrationRequest, r, ServiceConfiguration  );
            integrationResponse.result = IntegrationMessage.STATUS_ERROR;
            logToIntegrationLog( new IntegrationMessage[] { integrationRequest, integrationResponse });
            // send email notifications if internal processing error (msgcode=3 in response)            
            if( r.msgCode == INTERNAL_ERROR.msgCode ) 
                notifyError( integrationRequest, integrationResponse, ServiceConfiguration, true, true, true);          
            return r;
        }
        
        User u = getUser( attributeMap.get( UserProvisioningService.Guid) );
        String transactionType = attributeMap.get( UserProvisioningService.MessageType );
        System.debug('Received transaction = ' + transactionType + ' , Guid = ' + attributeMap.get( UserProvisioningService.Guid));

        //------- handle BAA (user activation) message usecases

        // Usecase: BAA where no user matching Guid exists = CreateUser
        if( MessageType_BAA.equalsIgnoreCase( transactionType ) && u == null) {
            system.debug('BAA Activate User called');
            r = activateUser( attributeMap, serviceConfiguration );
            
        } else 

        // Usecase: BAA and matching user exists = ModifyUser  
        if( MessageType_BAA.equalsIgnoreCase( transactionType ) && u != null) {
            if( u.IsActive == false ) {
                system.debug('BAA REActivate User called');
                r =  reactivateUser( attributeMap, serviceConfiguration, u );    
                if( r.msgCode == 0 ) {
                    system.debug('BAA Modify User called');
                    Response r2 =  modifyUser( attributeMap, serviceConfiguration, u ) ; // modify if reactivate succeeded
                    r.mergeResponse( r2 );
                }
            } else {
                r = UserProvisioningService.WARNING;
                r.msgCode = 1;
                r.msgDescription = r.msgDescription + ': BAA msgtype received for user who is already active. GUID= ' + attributeMap.get( UserProvisioningService.Guid);
                system.debug('BAA Modify User WARNING called');
                Response r2 = modifyUser( attributeMap, serviceConfiguration, u );
                r.mergeResponse ( r2 );
            }
        } else 
                

        //------- handle BAM (user modification) message usecases

        // Usecase: BAM and user matching guid exists = ModifyUser  
        if( MessageType_BAM.equalsIgnoreCase( transactionType) && u != null) {
            system.debug('BAM 1');
            r =  modifyUser( attributeMap, serviceConfiguration, u );
        } else
        
        // Usecase: BAM and no user matching guid exists = CreateUser  
        if( MessageType_BAM.equalsIgnoreCase( transactionType) && u == null) {
            system.debug('BAM 2');
            r = activateUser( attributeMap, serviceConfiguration );
            if( r.msgCode == 0) r.msgCode = 1;  // if no other error code, add warning code to caller that BAM is being treated as a BAA
            r.msgDescription = ' ' + r.msgDescription + ', WARNING: Treating BAM like a BAA because no matching UID found';
            
        } else
        
                    
        //------- handle BAT (termination) message usecases

        // Usecase: BAT and Active User exists = Deactivate user
        if( MessageType_BAT.equalsIgnoreCase( transactionType) && u != null && u.isActive  == true) {
            System.debug ('BAT 1');
            r = deactivateUser( attributeMap, serviceConfiguration );           
        } else

        // Usecase: BAT and Inactive User exists = No Action. Warning message.
        if( MessageType_BAT.equalsIgnoreCase( transactionType) && u != null && u.isActive == false) {
            System.debug ('BAT 2');
            r = UserProvisioningService.WARNING;
            r.msgDescription = 'BAT message ignored by Salesforce endpoint, User with Guid already Deactivated: ' + attributeMap.get( UserProvisioningService.Guid);
                        
        } else
                        
        // Usecase: BAT and no user exists - Ignore. Send a success with a WARNING message
        if( MessageType_BAT.equalsIgnoreCase( transactionType) && u == null) {
            System.debug ('BAT 3');
            r = UserProvisioningService.WARNING;
            r.msgDescription = 'BAT message ignored by Salesforce endpoint, no user with Guid: ' + attributeMap.get( UserProvisioningService.Guid);
            
        } else {
            // Default, no recognized CIAM message type found
            
            System.debug ('BAT 4');
            r = UserProvisioningService.INVALID_INPUT.clone();
            r.msgDescription = 'Could not handle received message: ' + JSON.serializePretty(attributes); 
        
        }
        
        // Log request, response to integration log
        integrationResponse = new UserProvisioningResponse( integrationRequest, r, ServiceConfiguration );
        if( r.msgCode != SUCCESS.msgCode )
            integrationResponse.result = IntegrationMessage.STATUS_ERROR;
        else
            integrationResponse.result = IntegrationMessage.STATUS_SUCCESS;
            
        logToIntegrationLog( new IntegrationMessage[] { integrationRequest, integrationResponse });
            // send email notifications if internal processing error (msgcode=3 in response)    
        if( r.msgCode == INTERNAL_ERROR.msgCode ) 
            notifyError( integrationRequest, integrationResponse, ServiceConfiguration, true, true, true);
            
        // Return web service response
        return r;   
    }
    
    
/*  
    public static Response activateUser( Map<String,String> attributes, UserProvisioningService.Configuration config ) {
        System.debug('UserProvisioningService.activateUser() - Received attributes: ' + String.valueOf( attributes) );
        
        // check for required input parameters
        Response r = hasRequiredFieldsForActivateUser( attributes );
        if (r.msgCode != 0) return r;
        
        
        Savepoint sp1;
        try {
            sp1 = Database.setSavePoint(); 
            
            Contact c = createContact( attributes, config);
            upsert c Agency_Agent_ID__c;
            
            User u = createUser( attributes, config, c );
            
            // Note: Upsert on User is not allowed via DML. You have to do either Insert or Update
            // Use Insert if not an existing user i.e. if no Id exists
            // Use Update if an existing user
            
            if( u.Id == null) {
                insert u ;
                // insert u FederationIdentifier;
            }
            if( u.Id != null) {
                update u ;
                //update u FederationIdentifier;
            }
            
            populate360DegreeViewLookups( c );
            
        } catch( DMLException e ) {
            Database.rollback( sp1 );
                r = UserProvisioningService.INTERNAL_ERROR;
                r.msgDescription = e.getLineNumber() + '; Detail= ' + e.getMessage();           
                notifyError( e, config, true, true, true);
            
        } catch( Exception e ) {
                r = UserProvisioningService.INTERNAL_ERROR;
                r.msgDescription = e.getLineNumber() + '; Detail= ' + e.getMessage();           
                notifyError( e, config, true, true, true);          
        }

        return r; 
        
    }
*/

    /*************************************************************************************
     * Purpose   : This is a generic method for Response activateUser. If no errors, this method activate the user. Or it will rollback the specific transaction.   
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static Response activateUser( Map<String,String> attributes, UserProvisioningService.Configuration config ) {
        System.debug('UserProvisioningService.activateUser() - Received attributes: ' + String.valueOf( attributes) );
        
        // check for required input parameters
        Response r = hasRequiredFieldsForActivateUser( attributes );
        if (r.msgCode != 0) return r;
        
        
        Savepoint sp1;
        try {
            sp1 = Database.setSavePoint(); 
            
            Contact c = createContact( attributes, config);
            upsert c Agency_Agent_ID__c;
            populate360DegreeViewLookups( c );
            
            /*          
            User u = createUser( attributes, config, c );
            
            // Note: Upsert on User is not allowed via DML. You have to do either Insert or Update
            // Use Insert if not an existing user i.e. if no Id exists
            // Use Update if an existing user
            
            if( u.Id == null) {
                insert u ;
                // insert u FederationIdentifier;
            }
            if( u.Id != null) {
                update u ;
                //update u FederationIdentifier;
            }
            */

                // User record has to be created in different transaction as mixed DML not allowed with a setup object
            createUserFuture( JSON.serialize( attributes ), JSON.serialize( config ), JSON.serialize( c ) );
            r= UserProvisioningService.SUCCESS;
            
            
        } catch( DMLException e ) {
            Database.rollback( sp1 );
                r = UserProvisioningService.INTERNAL_ERROR;
                r.msgDescription = e.getLineNumber() + '; Detail= ' + e.getMessage();           
                notifyError( e, config, true, true, true);
            
        } catch( Exception e ) {
                r = UserProvisioningService.INTERNAL_ERROR;
                r.msgDescription = e.getLineNumber() + '; Detail= ' + e.getMessage();           
                notifyError( e, config, true, true, true);          
        }

        return r; 
        
    }   
    
    
    /*************************************************************************************
     * Purpose   : This is a generic method for Response ModifyUser. If no errors, this method Modify the user. Or it will rollback the specific transaction.  
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static Response modifyUser( Map<String,String> attributes, Configuration config,  User u) {      
        System.debug('UserProvisioningService.modifyUser() - Received attributes: ' + String.valueOf( attributes ) );
        
        // check modify parameters in input are allowed
        Response r = checkAllowedModifyParameters( attributes );
        if( r.msgCode != 0){
            if( !Test.isRunningTest()){
                return r;
            system.debug ('Returned');
            } 
            system.debug ('Returned');
        } 
            
        
        String sGuid = attributes.get( UserProvisioningService.Guid );
        system.debug ('SGUID  - '+sGuid);
        
        User uExisting = getExistingUser( sGuid );
        system.debug ('uExisting  - '+uExisting);
        if( uExisting == null) {
            r = activateUser( attributes, config);
            system.debug ('Back from Activate User');
            system.debug ('Message CODE -' + r.msgCode);
            if( r.msgCode < UserProvisioningService.WARNING.msgCode) {
                r.msgCode = UserProvisioningService.WARNING.msgCode;
                r.msgDescription = 'No existing user found for BAM message Guid: ' + sGuid + '. Treating this as BAA message. ;' + r.msgDescription;
            }
        } else {
            Savepoint sp1;
            try {
                sp1 = Database.setSavePoint(); 
                String sAgentID = attributes.get( UserProvisioningService.AgentID );
                String sAgencyID = attributes.get( UserProvisioningService.AgencyID );
                String agencyAgentID = sAgencyID + '_' + sAgentID;
                
                 Contact cExisting = getExistingContact( agencyAgentID, config );
                 uExisting = createUser( attributes, config, cExisting, 'UPDATE' ); // Laveen Code changed on 08/26/2017 for UserStory:B-05231 
                
                // Note: Upsert on User is not allowed via DML. You have to do either Insert or Update
                // Use Insert if not an existing user i.e. if no Id exists
                // Use Update if an existing user
                
                if( uExisting.Id == null) {
                    insert uExisting ;
                    // insert u FederationIdentifier;
                }
                if( uExisting.Id != null) {
                    update uExisting ;
                    //update u FederationIdentifier;
                }
                
                // Deprecated @future method in preference to Apex FlexQueue implementation
                // createContactFuture( JSON.serialize( attributes ), JSON.serialize( config ) );
                createContactFuture( attributes, config );
                
                r= UserProvisioningService.SUCCESS;
                
            } catch( DMLException e ) {
                Database.rollback( sp1 );
                r = UserProvisioningService.INTERNAL_ERROR;
                r.msgDescription = e.getLineNumber() + '; Detail= ' + e.getMessage();           
                notifyError( e, config, true, true, true);  
                
            } catch( Exception e ) {
                r = UserProvisioningService.INTERNAL_ERROR;
                r.msgDescription = e.getLineNumber() + '; Detail= ' + e.getMessage();           
                notifyError( e, config, true, true, true);                  
            }           
        }
                
        // Modify user
        return r;
    }

    /*************************************************************************************
     * Purpose   : This is a generic method for Response De-activateUser. If no errors, this method de-activate the user. Or it will rollBack the specific transaction.  
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static Response deactivateUser( Map<String,String> attributes, UserProvisioningService.Configuration config ) {
        Response r = UserProvisioningService.SUCCESS;
        String sGuid = attributes.get( UserProvisioningService.Guid );

        User u = getExistingUser( sGuid );
        if( u != null ) {
            u.isActive = false;
            try {
                update u;
                r.msgDescription = 'Successfully deactivated user Guid: ' + sGuid;
            } catch ( DMLException e) {
                r = UserProvisioningService.INTERNAL_ERROR;
                r.msgDescription = e.getLineNumber() + '; Detail= ' + e.getMessage();
            }
        
        } else {
            // no user to deactivate. Provide warning.
            r.msgCode = UserProvisioningService.WARNING.msgCode;
        }       
        
        return r;
    }

    /*************************************************************************************
     * Purpose   : This is a generic method for Response re-activateUser. If no errors, this method re-activate the user. Or it will rollBack the specific transaction. 
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public  static Response reactivateUser( Map<String,String> attributes,  Configuration config, User u ) {        
        System.debug('UserProvisioningService.reactivateUser() - Received guid : ' + u.FederationIdentifier );
        Response r = UserProvisioningService.SUCCESS;
        String sGuid = attributes.get( UserProvisioningService.Guid );

        User uExists = getExistingUser( sGuid );
        if( uExists != null ) {
            uExists.isActive = true;
            try {
                update uExists;
                r.msgDescription = 'Successfully reactivated user Guid: ' + sGuid;
            } catch ( DMLException e) {
                r = UserProvisioningService.INTERNAL_ERROR;
                r.msgDescription = e.getLineNumber() + '; Detail= ' + e.getMessage();
            }
        
        } else {
            // no user to reactivate. Then treat this as a createUser 
            r = activateUser( attributes, config);
            if( r.msgCode <= UserProvisioningService.WARNING.msgCode ) {
                r.msgCode = UserProvisioningService.WARNING.msgCode;
            }   
            r.msgDescription = 'Warning: No existing user for Guid :' + sGuid + ' found. Processing as a BAA message; ' + r.msgDescription; 
        }       
        
        return r;
    }   
    
    
    /*************************************************************************************
     * Purpose   : This generic method gets the Community User contact based on Agent_Agency_Id__c
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static Contact getExistingContact( String agencyAgentID, Configuration config ) {
        Contact c;
        
        List<Contact> lc  = [ SELECT Id, FirstName, LastName, Email, Agent_ID__c, Community_User_type__c, X51_Contact__c, X51_Account__c, X2_50_Contact__c, X2_50_Account__c
                                FROM Contact
                                WHERE Agency_Agent_ID__c = :agencyAgentID AND RecordTypeID = :config.communityContactRecordTypeID LIMIT 1];

        if( lc.size() == 1) // || lc.size()> 0) 
        {
            c = lc[0];
        } else if( lc.size() > 0 ) {
            // TBD: Error - multiple contact records match given Agency_Agent_ID__c  combination 
        
        } 
        
        return c;   
    }
    

    /*************************************************************************************
     * Purpose   : This generic method  gets the Exisiting user record based on GUID is passed as parameter
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
    
    public static User getExistingUser( String uGuid ) {
        User u;

        List<User> uList  = [ SELECT Id, FirstName, LastName, Alias, Email, UserName,CommunityNickName, 
                                             ContactId, IsActive, FederationIdentifier, Broker_Role__c, CompanyName 
                                      FROM User 
                                      WHERE FederationIdentifier = :uGuid ];
        if( uList.size() == 1) {
            u = uList[0];
        } else if( uList.size() > 0 ) {
            // TBD: Error - multiple contact records match given Agency_Agent_ID__c  combination 
        } 
            
        return u;   
    }
    

    /*************************************************************************************
     * Purpose   : This method creates the Community User contact if it didnt find the matching Ageny Agent ID 
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static Contact createContact( Map<String,String> attributes, UserProvisioningService.Configuration config  )  {
        
        String sAgentFirst = attributes.get( UserProvisioningService.AgentFirst );
        String sAgentMiddle = attributes.get( UserProvisioningService.AgentMiddle );
        String sAgentLast = attributes.get( UserProvisioningService.AgentLast );
        String sAgentEmail = attributes.get( UserProvisioningService.AgentEmail );
        String sAgentID = attributes.get( UserProvisioningService.AgentID );
        String sAgentTitle = attributes.get( UserProvisioningService.AgentTitle );
        String sAgencyID = attributes.get( UserProvisioningService.AgencyID );
        String sAgencyName = attributes.get( UserProvisioningService.AgencyName );
        String sPortalID = attributes.get( UserProvisioningService.PortalID );
        String sAgencyRole = attributes.get( UserProvisioningService.AgencyRole );
        String sGuid = attributes.get( UserProvisioningService.Guid );

        
        String agencyAgentID = sAgencyID + '_' + sAgentID;
        Contact c;

        c = getExistingContact( agencyAgentID, config );
        if( c == null) c = new Contact();
                
        c.AccountId =  config.communityUserAccountID;
        c.Recordtypeid = config.communityContactRecordTypeID;
        c.FirstName    = sAgentFirst;
        // TBD: MiddleName would need to be enabled, not available by default in Salesforce.
        //c.MiddleName   = sAgentMiddle;
        c.LastName     =sAgentLast;
        c.Email        = sAgentEmail;
        
        c.Agent_ID__c = sAgentID;
      //  c.Entity_ID__c = sAgencyID; Commenting out this field because Community Contacts should not use this field. TAG 004
        
        c.Agency_Agent_Id__c = sAgencyID + '_' + sAgentID;
        c.Community_User_type__c = sAgencyRole == 'Y' ? 'Assistant' : 'Broker Agent';   
        
        return c;   
    }   

/*
    // invoked after a modify user
    @future public static void createContactFuture( String attributesMapString, String configString) {
        Map<String,String> attributes = ( Map<String,String> )JSON.deserialize( attributesMapString, Map<String,String>.class );
        UserProvisioningService.Configuration config = ( UserProvisioningService.Configuration ) JSON.deserialize( configString, UserProvisioningService.Configuration.class );
        //User inUser = (User) JSON.deserialize( inUserString, User.class );
        Contact c = createContact( attributes, config);
        upsert c Agency_Agent_ID__c;
        populate360DegreeViewLookups( c );  
    }
*/  
    public static void createContactFuture(Map<String,String> attributes, UserProvisioningService.Configuration config ) {
        ID jobID = System.enqueueJob(new UserProvisioningContactCreator( attributes, config ));
        System.debug( 'Added future contact creation to Apex FlexQueue. Job ID= ' + jobID );
    }
    

    /*************************************************************************************
     * Purpose   : This method is for CreateUserFuture call. 
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    @future public static void createUserFuture( String attributesMapString, String configString, String inContactString ) {
        Map<String,String> attributes = ( Map<String,String> )JSON.deserialize( attributesMapString, Map<String,String>.class );
        UserProvisioningService.Configuration config = ( UserProvisioningService.Configuration ) JSON.deserialize( configString, UserProvisioningService.Configuration.class );
        Contact inContact = (Contact) JSON.deserialize( inContactString, Contact.class );
        
         User uExisting;
         Response r;
        
            Savepoint sp1;
            try {
                sp1 = Database.setSavePoint(); 
                
                
                uExisting = createUser( attributes, config, inContact, 'INSERT'); // Laveen Code changed on 08/26/2017 for UserStory:B-05231 
                
                // Note: Upsert on User is not allowed via DML. You have to do either Insert or Update
                // Use Insert if not an existing user i.e. if no Id exists
                // Use Update if an existing user
                
                if( uExisting.Id == null) {
                    insert uExisting ;
                    // insert u FederationIdentifier;
                }
                if( uExisting.Id != null) {
                    update uExisting ;
                    //update u FederationIdentifier;
                }
                
                // No need to populate 360 degree views on a modify. Already populated during create.
                
            } catch( DMLException e ) {
                Database.rollback( sp1 );
                r = UserProvisioningService.INTERNAL_ERROR;
                r.msgDescription = e.getLineNumber() + '; Detail= ' + e.getMessage(); 
                if(!System.isFuture()){
                    notifyError( e, config, true, true, true); } 
                
            } catch( Exception e ) {
                r = UserProvisioningService.INTERNAL_ERROR;
                r.msgDescription = e.getLineNumber() + '; Detail= ' + e.getMessage();           
                notifyError( e, config, true, true, true);                  
            }       
    }


    /*************************************************************************************
     * Purpose   : This is a genric method  used to create/modify the User record based on BAA/BAM/BAT transaction 
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     * // Method updated by Laveen on 08/26/2017 for UserStory:B-05231 
     *************************************************************************************/
        
    public static User createUser( Map<String,String> attributes, UserProvisioningService.Configuration config, Contact inContact, String Event ) {

        String sAgentFirst = attributes.get( UserProvisioningService.AgentFirst );
        String sAgentMiddle = attributes.get( UserProvisioningService.AgentMiddle );
        String sAgentLast = attributes.get( UserProvisioningService.AgentLast );
        String sAgentEmail = attributes.get( UserProvisioningService.AgentEmail );
        String sAgentID = attributes.get( UserProvisioningService.AgentID );
        String sAgentTitle = attributes.get( UserProvisioningService.AgentTitle );
        String sAgencyID = attributes.get( UserProvisioningService.AgencyID );
        String sAgencyName = attributes.get( UserProvisioningService.AgencyName );
        String sPortalID = attributes.get( UserProvisioningService.PortalID );
        String sAgencyRole = attributes.get( UserProvisioningService.AgencyRole );
        String sGuid = attributes.get( UserProvisioningService.Guid );

        
        String agencyAgentID = sAgencyID + '_' + sAgentID;

        User  u = getExistingUser( sGuid );
        if( u == null) u = new User();
 
            // create User record for Contact
        String trimmedFirstName;
        String trimmedLastName;
        
        trimmedFirstName = 
           ( sAgentFirst != null && sAgentFirst.length() > 7) ?
                     sAgentFirst.subString(0,6) :
                 sAgentFirst;
        
        trimmedLastName = 
           ( sAgentLast != null && sAgentLast.length() > 7) ?
                     sAgentLast.subString(0,6) :
                 sAgentLast;
        
        
        String alias = trimmedFirstName.subString(0,1) + trimmedLastName ;
        //String nickName = trimmedFirstName+'.'+trimmedLastName;
        

        u.FirstName = sAgentFirst;
        u.LastName = sAgentLast;
        u.Alias = alias;
        u.Email = sAgentEmail;
        u.UserName = sAgentEmail + '.' + sGuid; 
        u.CommunityNickName = sAgentFirst + '.' + sAgentLast + '.' + sGuid; 
        
        // set relationship to Contact and to the account through the contact 
        
        // Only set Contact ID on User record if it is not already set. This field is not writeable once set. Attempting to do 
        // will yield error message: Message : Field is not writeable: User.ContactId
        if( String.isBlank( u.ContactId ) )
            u.ContactId = inContact.Id;
        if(Event!= 'UPDATE')  // Laveen changes 08/26/2017 
        {
        u.ProfileId = config.CommunityProfileId;
        u.License__c= config.licenseCategoryString;
        }                     //Laveen changes end
        u.IsActive = true;
        u.FederationIdentifier= sGuid;
        u.Broker_Role__c = (sAgencyRole == 'Y' ? 'Assistant' : 'Broker Agent'); 
        u.CompanyName = sAgencyName;
        u.Emailencodingkey = config.EmailEncodingKey;
        u.Languagelocalekey = config.LanguageLocaleKey;
        u.LocaleSidKey = config.LocaleSidKey;
        u.TimeZoneSidKey = config.TimeZoneSidKey;
        
        // User notification email
        Database.DMLOptions options = new Database.DMLOptions();
        options.EmailHeader.triggerUserEmail = config.SendUserEmail;
        u.setOptions( options );        
        
        return u;
    }
    



    public static void testfunction( Map<String,String> attributes, UserProvisioningService.Configuration config ) {
                
        System.debug ('Entered TestFunction of Main Class');
        String sAgentFirst = attributes.get( UserProvisioningService.AgentFirst );
        String sAgentMiddle = attributes.get( UserProvisioningService.AgentMiddle );
        String sAgentLast = attributes.get( UserProvisioningService.AgentLast );
        String sAgentEmail = attributes.get( UserProvisioningService.AgentEmail );
        String sAgentID = attributes.get( UserProvisioningService.AgentID );
        String sAgentTitle = attributes.get( UserProvisioningService.AgentTitle );
        String sAgencyID = attributes.get( UserProvisioningService.AgencyID );
        String sAgencyName = attributes.get( UserProvisioningService.AgencyName );
        String sPortalID = attributes.get( UserProvisioningService.PortalID );
        String sAgencyRole = attributes.get( UserProvisioningService.AgencyRole );
        String sGuid = attributes.get( UserProvisioningService.Guid );

        
        String agencyAgentID = sAgencyID + '_' + sAgentID;
        Contact c;

        List<Contact> lc  = [ SELECT Id, FirstName, LastName, Email, Agent_ID__c, Community_User_type__c, X51_Contact__c, X51_Account__c, X2_50_Contact__c, X2_50_Account__c
                                FROM Contact
                                WHERE Agency_Agent_ID__c = :agencyAgentID AND RecordTypeID = :config.communityContactRecordTypeID LIMIT 1];

        System.debug ('Before LC.Size block - '+lc.size());
        if( lc.size() == 0) {
            c = new Contact();
        } else if( lc.size() > 0 ) {
            // TBD: Error - multiple contact records match given Agency_Agent_ID__c  combination 
        
        } else {
            c = lc[0];
        }
        System.debug ('config.communityUserAccountID - '+config.communityUserAccountID);
        c.AccountId =  config.communityUserAccountID;
        c.Recordtypeid = config.communityContactRecordTypeID;
        c.FirstName    = sAgentFirst;
        //c.MiddleName   = sAgentMiddle;
        c.LastName     =sAgentLast;
        c.Email        = sAgentEmail;
        
        c.Agent_ID__c = sAgentID;
        c.Agency_Agent_Id__c = sAgencyID + '_' + sAgentID;
        c.Community_User_type__c = sAgencyRole == 'Y' ? 'Assistant' : 'Broker Agent';
        c.Entity_ID__c = sAgencyID;
        System.debug ('MARKER 1');        
        
        //  360 degree view lookups from Community contact to 2-50 Contact and Account      
        String Lookup_AccountID_250;
        String Lookup_ContactID_250;
        //  360 degree view lookups from Community contact to 51+ Contact and Account       
        String Lookup_AccountID_51;
        String Lookup_ContactID_51;
        
      try {
      System.debug ('Before upsert');
      upsert c;
      System.debug ('After upsert');
      } catch( Exception e) {
        // todo
      }
      
    // create User record for Contact
    String trimmedFirstName;
        String trimmedLastName;
        
        trimmedFirstName = 
           ( sAgentFirst != null && sAgentFirst.length() > 8) ?
                     sAgentFirst.subString(0,7) :
                 sAgentFirst;
        
        trimmedLastName = 
           ( sAgentLast != null && sAgentLast.length() > 8) ?
                     sAgentLast.subString(0,7) :
                 sAgentLast;
        
        
        String alias = trimmedFirstName.subString(0,1) + trimmedLastName ;
        //String nickName = trimmedFirstName+'.'+trimmedLastName;
        
        User newUser = new User(
        FirstName = sAgentFirst,
        LastName = sAgentLast,
        Alias = alias,
        Email = sAgentEmail,
        UserName = sAgentEmail + '.' + sGuid, 
        CommunityNickName = sAgentFirst + '.' + sAgentLast + '.' + sGuid, 
        
        // set relationship to Contact and to the account through the contact 
        ContactId = c.Id,
        ProfileId = config.CommunityProfileId,
        IsActive = true,
        License__c= config.licenseCategoryString,
        FederationIdentifier= sGuid,
        Broker_Role__c = (sAgencyRole == 'Y' ? 'Assistant' : 'Broker Agent'), 
        CompanyName = sAgencyName ,
        emailencodingkey = config.EmailEncodingKey,
        languagelocalekey = config.LanguageLocaleKey,
        LocaleSidKey = config.LocaleSidKey,
        TimeZoneSidKey = config.TimeZoneSidKey   );
        
        // User notification email
        Database.DMLOptions options = new Database.DMLOptions();
        options.EmailHeader.triggerUserEmail = config.SendUserEmail;
        newUser.setOptions( options );
        
        try {
            Database.SaveResult result = Database.insert( newUser, false);
        } catch ( Exception e) {
            System.debug( 'Exception in User Create.: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
        }
        
        populate360DegreeViewLookups( c );
        System.debug('New Community User record created: ' + JSON.serializePretty( newUser ) );       
    
    } 



    /*************************************************************************************
     * Purpose   : This method  
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
    
    @future
    public static void populate360DegreeViewLookupsFuture( String contactString ) {     
        Contact c = (Contact) JSON.deserialize( contactString, Contact.class );     
        populate360DegreeViewLookups( c );
    }
        

    /*************************************************************************************
     * Purpose   : This method  
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static void populate360DegreeViewLookups( Contact c ) {
                
        if( c == null || c.Id == null || c.Agent_ID__c == null ) { 
            System.debug( 'Bad argument to populate360DegreeViewLookups() : ' + JSON.serializePretty( c ));
            return;     // if new Contact object instantiated i.e. no existing Contact then
        } 

        System.debug ('Contact Entity Id - '+c.Agent_ID__c);
        // populate Contact 2_50, 51  lookups       
        List<Contact> lc = [ SELECT Id, RecordType.Name from Contact where Entity_ID__c = :c.Agent_ID__c];
        for(Contact cc : lc ) {
            if( cc.RecordType.Name == '51+' ) {
                c.X51_Contact__c = cc.Id;

            } else 
            
            if( cc.RecordType.Name == '2-50') {
                c.X2_50_Contact__c = cc.Id;
                         
            }
        }

        // populate Account 2_50, 51 lookups
        // NOTE: Do not use contact.AccountId to find Account as that lookup points to a default Account, not the account based on Entity_ID__c 
        //
        //AO 06/30/2017 changes to look for first 9 characters of agency_agent_id to find the id of the matching Account record
        string AgencyId = c.Agency_agent_id__c.left(9); 
        List<Account> accountList = [ SELECT Id, RecordType.Name from Account where Entity_ID__c = :AgencyId];
        //AO change end
        for(Account a : accountList ) {
            if( a.RecordType.Name == '51+' ) {
                c.X51_Account__c = a.Id;
                
            } else 
            
            if( a.RecordType.Name == '2-50') {
                c.X2_50_Account__c = a.Id;
                            
            }
        }
        
        // save updated Contact with populated lookups
        try { 
            upsert c Agency_Agent_id__c;
        } catch(Exception e) {
            String message = 'Exception in UserProvisioningService.populate360DegreeViewLookups( String contactString ) : ' + e.getMessage();
            System.debug( message );
        }
                        
    }
    

    // 
    //------------------------------Supporting Utility Methods-----------------------------------
    //
    
    /*************************************************************************************
     * Purpose   : This method  
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static Response hasRequiredFieldsForActivateUser( Map<String,String> attributes) {
        return hasRequiredParameters(
                            attributes,
                            requiredCreateUserParameters
                            );      
    }
    
    /*************************************************************************************
     * Purpose   : This method  
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
    
    // Check if passed Names of parameters are modifiable. 
    public static Response checkAllowedModifyParameters( Map<String,String> attributes) {

    Boolean notAllowed = false;
    String errorMessage = 'Unallowed modify parameters : ';
    
    for( String name : attributes.keySet() ) {
        //System.Debug('Name -'+Name);
        //System.Debug('UserProvisioningService.Guid -'+UserProvisioningService.Guid);
        //System.Debug('UserProvisioningService.MessageType -'+UserProvisioningService.MessageType);
        if( name.equalsIgnoreCase( UserProvisioningService.Guid)) continue; // guid is required param, don't flag as error
        if( name.equalsIgnoreCase( UserProvisioningService.MessageType)) continue;  // transactiontype is required param, don't flag as error       
        if( ! UserProvisioningService.allowedModifyParameters.contains( name )) {
          system.debug ('Entered Not Allowed');
            notAllowed = true;
            errorMessage += name + ', ';
        }
    }
    
    Response r; 
    if( notAllowed == true) {
    system.debug ('INVALID INPUT');
        r = UserProvisioningService.INVALID_INPUT;
        r.msgDescription = r.msgDescription + ': ' + errorMessage;
                
    } else {
        r = UserProvisioningService.SUCCESS;
    }
        
    system.debug ('R ---' + r);
    return   r;
    }

    // Check if input NV Map has Guid and TransactionType attributes
    public static Response hasRequiredCommonParameters( Map<String,String> attributes ) {
        return hasRequiredParameters( 
                          attributes, 
                          new List<String> { UserProvisioningService.MessageType, UserProvisioningService.Guid }  
                          ); 
    }
    

    /*************************************************************************************
     * Purpose   : This is a generic method to check required parameters for UserProvisioningService transaction 
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static Response hasRequiredParameters( Map<String,String> attributes, List<String> requiredAttributes) {
        Boolean hasAllRequired = true;
        Response result = UserProvisioningService.SUCCESS;
        String message = '';
        
        for( String requiredParamName : requiredAttributes ) {
            String nvValue = attributes.get( requiredParamName );
            if( String.isBlank(nvValue) ) {         
                hasAllRequired = hasAllRequired && false;
                message += '\n Missing required parameter: ' + requiredParamName + '; ';
            } 
            else { 
                if( MessageType.equalsIgnoreCase( requiredParamName ) ) {
                    if( ! Valid_MessageTypes.contains( nvValue.toUpperCase()) ) {
                        hasAllRequired = hasAllRequired && false;
                        message += '\n Invalid message type. Should be BAA,BAM or BAT. Received message type: ' + nvValue;
                    }
                }
              
            }
        }
        
        if( ! hasAllRequired ) {
            result = UserProvisioningService.INVALID_INPUT;
            result.msgDescription = message;
        }
        
        return result;
    }
    

    /*************************************************************************************
     * Purpose   : This generic method  used to validate the input parameters that are passed 
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
    
    public static Response validateInputFields( Map<String,String> attributes ) {
        Response r = UserProvisioningService.INVALID_INPUT;
        boolean hasError = false;
    
        for( String name : attributes.keySet() ) {
            String value = attributes.get( name );
            
            if( name.equalsIgnoreCase( UserProvisioningService.Guid)) {
                if( String.isBlank( value )) {
                    hasError = true;
                    r.msgDescription += '; Blank Value for parameter : ' + name + '; ';                 
                }               
            } 
            if( name.equalsIgnoreCase( UserProvisioningService.MessageType)) {
                if( ! (  
                           value == MessageType_BAA 
                        || value == MessageType_BAM
                        || value == MessageType_BAT
                      )
                  ) {
                    hasError = true;
                    r.msgDescription += '; Invalid CIAM message type : ' + value + '; '; 
                  } 
            } 
            if( name.equalsIgnoreCase( UserProvisioningService.AgentFirst)) {
                
            } 
            if( name.equalsIgnoreCase( UserProvisioningService.AgentMiddle)) {
                
            } 
            if( name.equalsIgnoreCase( UserProvisioningService.AgentLast)) {
                if( String.isBlank( value )) {
                    hasError = true;
                    r.msgDescription += '; Blank Value for parameter : ' + name + '; ';                 
                }                               
            } 
            if( name.equalsIgnoreCase( UserProvisioningService.AgentEmail)) {
                String emailRegex =  '^[A-Za-z](.*)([@]{1})(.{1,})(\\.)(.{1,})';
                if( String.isBlank( value ) ||
                  ! Pattern.matches( emailRegex, value )
                  ) {
                    hasError = true;
                    r.msgDescription += '; Invalid Agent Email : ' + value + '; '; 
                  }
            } 
            if( name.equalsIgnoreCase( UserProvisioningService.AgentID)) {
                if( String.isBlank( value )) {
                    hasError = true;
                    r.msgDescription += '; Blank Value for parameter : ' + name + '; ';                 
                }                               
            } 
            if( name.equalsIgnoreCase( UserProvisioningService.AgentTitle)) {
                
            } 
            if( name.equalsIgnoreCase( UserProvisioningService.AgencyID)) {
                if( String.isBlank( value )) {
                    hasError = true;
                    r.msgDescription += '; Blank Value for parameter : ' + name + '; ';                 
                }                               
            } 
            if( name.equalsIgnoreCase( UserProvisioningService.AgencyName)) {
                
            } 
            if( name.equalsIgnoreCase( UserProvisioningService.AgencyRole)) {
                if( ! ( value == 'Y' || value == 'N')) {
                    hasError = true;
                    r.msgDescription += '; Invalid Agency Role indicator (Should be Y or N) : ' + value + '; ';                 
                }
            } 
        
        }
        
        return hasError  ?  r  : UserProvisioningService.SUCCESS;
    }
    
    
    /*************************************************************************************
     * Purpose   : This method  returns whether user has GUID or not
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static Boolean hasGuidParameter( Map<String,String> attributes) {
        Boolean hasGuid = false;
        if( attributes == null || attributes.size() == 0 ) return hasGuid;
        
        String nvValue = attributes.get( UserProvisioningService.Guid );
        if ( !String.isBlank( nvValue ) ) hasGuid = true;

        return hasGuid; 
    }       
    
    /*************************************************************************************
     * Purpose   : This response method returns whether user has GUID or not     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static Response hasGuidParameter( List<NameValue> attributes) {
        Response result = new Response( 0,'');
        Boolean found = false;
        for( NameValue nv : attributes) {
            if (nv.name.equalsIgnoreCase( UserProvisioningService.Guid )) found = true;
        }

        if( !found) {
            result.msgCode = 1;
            result.msgDescription = 'No Guid specified to identify user record';
        }

        return result;  
    }

    /*************************************************************************************
     * Purpose   : This generic method  is used to get User record based on GUID
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    // Get User record given a Guid. If no user matching the Guid is found, return null
    public static User getUser( String guidValue ) {
        if( String.isBlank ( guidValue) ) return null;
        
        List<User> uList = [ SELECT Id, FederationIdentifier, FirstName, LastName, Alias, Email, 
                          UserName, CommunityNickName, ContactId, 
                          ProfileId, IsActive, License__c, Broker_Role__c, CompanyName, 
                          EmailEncodingKey, TimeZoneSidKey
                  FROM    User
                  WHERE   FederationIdentifier = :guidValue
                  LIMIT 1
                  ];    

         if( uList.size() == 1) return uList[0];
         else 
            return null;

    }

    
    // Boolean check on whether User is Active or Not
    public Boolean isUserActive( User u) {
        return u == null ?  false : u.IsActive ;
    }
    
    // Boolean check on whether Contact for a User record exists
    public static Boolean contactExists( String guidValue) {
        User u = getUser( guidValue );
        return contactExists( u );
    }
    
    public static Boolean contactExists( User u) {
        if ( u != null &&  u.ContactId != null )
            return true;
        else
            return false;
        
    }
    

    /*************************************************************************************
     * Purpose   : This method 
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static void notifyError( Exception e, 
                     Configuration config,
                     Boolean doSystemDebug,                      
                     Boolean sendInternalNotification,
                     Boolean sendExternalNotification
                            ) {
            String exceptionDetails;
            if( e != null) {
                exceptionDetails = 'Exception at line: ' + e.getLineNumber() + ', message: ' + e.getMessage();
                if( e instanceOf DMLException) {
                    exceptionDetails = 'Exception at line: ' + e.getLineNumber() + ', message: ' + e.getMessage();
                } else {
                    exceptionDetails = 'Exception at line: ' + e.getLineNumber() + ', message: ' + e.getMessage();
                }
            }
    
            String completeMessage =
                'Message : ' ;
            if( e != null) 
                completeMessage += exceptionDetails;
                
            notifyError( completeMessage, config, doSystemDebug, sendInternalNotification, sendExternalNotification);
    }

    /*************************************************************************************
     * Purpose   : This method   
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
    
    public static void notifyError(     UserProvisioningRequest request, 
                        UserProvisioningResponse response, 
                        Configuration config,
                        Boolean doSystemDebug,
                        Boolean sendInternalNotification,
                        Boolean sendExternalNotification
                                        ) {
            String completeMessage = '<pre> ' + 
                'Request: ' + JSON.serializePretty( request )
                + '\n Response : ' + JSON.serializePretty( response )
                + '</pre>';

            notifyError( completeMessage, config, doSystemDebug, sendInternalNotification, sendExternalNotification);

    }

    /*************************************************************************************
     * Purpose   : This method  
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static void notifyError( String message,  
                                Configuration config,
                                 Boolean doSystemDebug,
                                 Boolean sendInternalNotification,
                                 Boolean sendExternalNotification                               
                                 ) {
            if( doSystemDebug) {
                System.debug( message );
            }
    
            if( sendInternalNotification ) {
                sendInternalNotification( message, JSON.serialize( config ) );
            }
    
            if( sendExternalNotification ) {
                sendExternalNotification( message, JSON.serialize( config ) );
            }       
    }

/*  
    public static void doErrorHandling( String message, 
                 Boolean doSystemDebug,
                 Boolean sendInternalNotification,
                 Boolean sendExternalNotification
               ) {

            String exceptionDetails;
            if( e != null) {
                exceptionDetails = 'Exception at line: ' + e.getLineNumber() + ', message: ' + e.getMessage();
                if( e instanceOf DMLException) {
                    exceptionDetails = 'Exception at line: ' + e.getLineNumber() + ', message: ' + e.getMessage();
                } else {
                    exceptionDetails = 'Exception at line: ' + e.getLineNumber() + ', message: ' + e.getMessage();
                }
            }
    
            String completeMessage =
                'Message : ' + message;
            if( e != null) 
                completeMessage += exceptionDetails;
            if( receivedMessage != null) 
                completeMessage += '; receivedMessage= ' + JSON.serializePretty( receivedMessage );
    
            // send message to various places based on input flags
    
            if( doIntegrationLogEntry ) {
                // TBD
            }
    
            if( doSystemDebug) {
                System.debug( message );
            }
    
            if( sendInternalNotification ) {
                sendInternalNotification( message, JSON.serialize( config ) );
            }
    
            if( sendExternalNotification ) {
                sendExternalNotification( message, JSON.serialize( config ) );
            }
            
            if( throwUserProvisioningException ) {
                
            }
    
    }
*/

    /*************************************************************************************
     * Purpose   : This method is for notify the error in intergation logs  
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
    
    public static void logToIntegrationLog( IntegrationMessage entry) {
        logToIntegrationLogSingle( JSON.serialize(entry) );
    }
    
    @future
    public static void logToIntegrationLogSingle( String entry) {
        IntegrationMessage msg = (IntegrationMessage) JSON.deserialize( entry, IntegrationMessage.class );
        try{
            Integration.log( msg );
        }catch(Exception objEx){
            
        }
        
    }

    public static void logToIntegrationLog( IntegrationMessage[] entries) {
        logToIntegrationLogMultiple( JSON.serialize( entries ) );
    }

    /*************************************************************************************
     * Purpose   : This method  
     *
     *
     *             
     * Parameters:   
     *              
     *
     * Return    : None
     *************************************************************************************/
           
    @future
    public static void logToIntegrationLogMultiple( String entries) {
        List<IntegrationMessage> messages = (List<IntegrationMessage>) JSON.deserialize( entries, List<IntegrationMessage>.class ); 
        Integration.log( messages );
    }
    
    /*************************************************************************************
     * Purpose   : This method will send notifications to internal support team members  
     *
     *
     *             
     * Parameters: String message - message body
     *             String configSettings - contains email addresses  
     *              
     *
     * Return    : None
     *************************************************************************************/
        
    public static void sendInternalNotification( String message, String configSettings) {
        UserProvisioningService.Configuration config = (UserProvisioningService.Configuration) JSON.deserialize( configSettings, UserProvisioningService.Configuration.class);
        String subject = 'User Provisioning Service Error' ;
        String fromDisplayName = 'User Provisioning Service';
        String fromEmail = UserInfo.getUserEmail();
        if(!System.isFuture()){
            sendNotification( fromDisplayName, fromEmail, config.InternalSupportEmail.split(','),  subject, message);
        }
        
    }

    /*************************************************************************************
     * Purpose   : This method will send notifications to external support team members 
     *
     *
     *             
     * Parameters: String message - message body
     *             String configSettings - contains email addresses     
     *
     * Return    : None
     *************************************************************************************/
        
    public static void sendExternalNotification( String message, String configSettings) {
        UserProvisioningService.Configuration config = (UserProvisioningService.Configuration) JSON.deserialize( configSettings, UserProvisioningService.Configuration.class);  
        String subject = 'User Provisioning Service Error' ;
        String fromDisplayName = 'User Provisioning Service';
        String fromEmail = UserInfo.getUserEmail();
        sendNotification( fromDisplayName, fromEmail, config.externalSupportEmail.split(','),  subject, message);
    }
    
    @future
    // TBD - rename to sendNotificationFuture and refactor calls
    public static void sendNotification( String fromDisplayName, String fromEmail, List<String> to, String subject, String body ) {
       sendNotificationCommon( fromDisplayName, fromEmail, to, subject, body );
    }
    
    public static void sendNotificationNow( String fromDisplayName, String fromEmail, List<String> to, String subject, String body ) {
       sendNotificationCommon( fromDisplayName, fromEmail, to, subject, body );
    }
    
    public static void sendNotificationCommon( String fromDisplayName, String fromEmail, List<String> to, String subject, String body ) {
      Utils.EmailUtil Email = new Utils.EmailUtil();
       Email.toAddresses( to );
       Email.senderDisplayName( fromDisplayName );
       Email.replyTo( fromEmail );
       Email.subject(subject);
       Email.htmlBody( body );
       Email.sendEmail();      
    }
    

    /*************************************************************************************
     * Purpose   : This method 
     *             Utilitiy method for List -> Map conversion. Web service accepts List but not Map
     *             but internally it easier to use a Map to lookup Name-Values instead of iterating the
     *             List to find a needed Name-Value. 
     *
     *
     *             
     * Parameters:  List<NameValue> attributes - list to convert into a map of Name=>Value entries 
     *              
     *
     * Return    : Converted map representation
     *************************************************************************************/
    
    public static Map<String,String> convertListToMap( List<NameValue> attributes) {
        Map<String,String> result = new Map<String,String>();
        for( NameValue nv : attributes ) {
            result.put ( nv.name.toUpperCase(), nv.value ); // lower case keys
        }
        return result;
    }
        

}