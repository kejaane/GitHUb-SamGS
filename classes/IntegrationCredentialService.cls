/*=========================================================================================
 * Date         : 03/19/2018
 * Developer    : Mike Horne, Sree Uma Ponnoju
 * Purpose      : Creating this class, allows remote access to this API by using an endpoint
 *                URL following this pattern:
 *                https://xxxx.salesforce.com/services/apexrest/IntegrationCredential
 *                
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *============+=======+====================================================================
 * 
 *============+=======+====================================================================
 */
@RestResource(urlMapping='/IntegrationCredential/*')
global with sharing class IntegrationCredentialService
{
    
    public static ID queueablejobID;
    // Inner class used for deserializing doPost request; serializing doGet response
    public class CredentialWrapper {
        public List<Credential> credentials;
        public CredentialWrapper() {}
    }
    // Inner class defining Credential data structure - doPost request, doGet response
    @TestVisible
    public class Credential {
        public Boolean isValid;
        public String errorMsg;
        public String authProvider;
        public String accountName;
        public String label;
        public String newPassword;
        public String orgName;
        public String locationType;
        public String locationName;
        public String securityToken;
        public String serviceURL;
    }
    // inner class wrapper for global/parent doPost response
    public class CredentialUpdate {
        public List<CredentialStatus> credentialUpdates;
        public CredentialUpdate() {}
    }
    // inner class wrapper for detail doPost response
    public class CredentialStatus {
        public String message;        //  Response message element
        public String accountName;    //  Response message element
        public String status;         // Response message element
    }
    
     
    /*************************************************************************************
     * Purpose   : Allow external on-premise consumers to query for integration credentials 
     *             stored on platform and return the associated location details for those 
     *             credentials.
     *             Results are obtained via lookup using credential location custom metadata 
     *             type. 
     * Parameters: List of accounttNames to filter the response 
     * Return    : JSON formatted array of Credential object(s) 
     *************************************************************************************/   
    @HttpGet   
    global static void doGet() 
    {
        RestResponse restRes = RestContext.response;
        String jsonResponse = '';   
        String reqBody = RestContext.request.requestURI;
        RestRequest restReq  = RestContext.request; 
        restReq.requestBody = Blob.valueOf(reqBody); 
        /******LOGGING FRAMEWORK******/ 
        IntegrationRequest rq = logRequest(restReq);
        /************END************/
        
        // Process get/retrieve
        List <Credential> credList = new List <Credential>();
        System.debug('==> doGet req param: ' + restReq.params);  //../IntegrationCredential?accountName=test
        System.debug('==> doGet req body:  ' + restReq.requestBody);
        System.debug('==> doGet req uri:   ' + restReq.requestURI); //../IntegrationCredential/accountName=test
        System.debug('==> doGet req resourc' + restReq.resourcePath);
        
        try {
            //https://xxxx.salesforce.com/services/apexrest/IntegrationCredential/accountName=test
            String accountsIn = restReq.params.get('accountName');
            System.debug('==> accountIn: '+accountsIn);
            // try catch goes below
            // parameter parse to create list of account names.
            // lookup details for each account name in list
            // catch: System.NullPointerException: Attempt to de-reference a null object 
            //  and (no parameters specified) return all
            //  Note: Custom metadata type is rare case where Salesforce allows query inside of loop  
            //  due to being free (no govennor limits). Taking advantage of this behavior.
            if (accountsIn == null) {
                System.debug('No parameters specified');
                List<Org_Credential_Location_Mapping__mdt> omdList = new List<Org_Credential_Location_Mapping__mdt>();
                omdList = [select UserName__c, authProvider__c, OrgName__c, LocationType__c, LocationName__c,serviceURL__c
                             from Org_Credential_Location_Mapping__mdt];
                for (Org_Credential_Location_Mapping__mdt ocl : omdList) {
                    Credential newCred = new Credential();
                    newCred.isValid = null;
                    newCred.accountName  = ocl.userName__c;
                    newCred.authProvider = ocl.authProvider__c;
                    newCred.orgName      = ocl.orgName__c;
                    newCred.locationType = ocl.locationType__c;
                    newCred.locationName = ocl.locationName__c;
                    newCred.serviceURL   = ocl.serviceURL__c;
                    // Save new cred(s) 
                    credList.add(newCred);
                    System.debug('---added cred '+newCred);
                    System.debug('---enhanced list '+credList);
                }             
            } else {
                // Process parameters - ?accountName= to filter lookup response
                // https://xxxx.salesforce.com/services/apexrest/IntegrationCredential/accountName=test,accountName=test1
                List<string> accountNameList = accountsIn.split(',');
                System.debug('==> List size: '+accountNameList.size()+' accountNameList: '+accountNameList);

                for (String acct : accountNameList) {
                    System.debug('==> accountName: '+acct);            
                    Credential newCred = new Credential();
                    newCred.accountName = acct;
                    credList.add(newCred);
                }                 
            }
        } catch (Exception ex){
            System.debug('IntegrationCredential.doGet() error: '+ex.getMessage());
        }
        restRes.addHeader('Content-Type', 'application/json');

        CredentialWrapper credGet = new CredentialWrapper();
        credGet.credentials = credList;
        System.debug ('credGet ' + JSON.serialize( credGet, true ));
        
        jsonResponse = JSON.serialize( credGet, true ); 
        restRes.responseBody = Blob.valueOf(jsonResponse);
        restRes.statusCode = 200;  
        /*****LOGGING FRAMEWORK******/   
        logResponse(restRes, rq, restReq);
        /************END***************/        
        return;
    }    
    
    /*************************************************************************************
     * Purpose   : Allow external on-premise consumers to push updates to integration 
     *             credentials stored on platform in various locations and via multiple mechanisms.
     * Parameters: JSON formatted array of account name and password pairs  
     * Return    : JSON formatted array of result objects for each credential update processed 
     *************************************************************************************/   
    @HttpPost   
    global static void doPost() 
    {
        String jsonRequest = RestContext.request.requestBody.toString(); 
        System.debug('===> JSON request: ' + jsonRequest);
        String jsonResponse = '';        
        RestResponse restRes = RestContext.response;
        RestRequest resReq = RestContext.request;
        restRes.addHeader('Content-Type', 'application/json');
        String responseBody; 
        
        /******LOGGING FRAMEWORK******/ 
        IntegrationRequest rq = logRequest(resReq);
        /************END************/
        try {
            // Deserialize JSON request to a List of Credential objects
            CredentialWrapper deserialized = (CredentialWrapper) JSON.deserialize(jsonRequest, CredentialWrapper.class);
            List <Credential> credList = new List <Credential>();
            credList = deserialized.credentials; 
            
            // Validate fields in Credential objects to be processed
            credList = validateRequest( credList );
            System.debug('====> credentials after validateRequest' + credList);
 
            // Supplement Credential list objects with lookup details 
            credList = addLookupDetails( credList ); 
            System.debug('====> credentials after addLookUpDetails' + credList);
            
            // Process backend insert/update using Credential list
            credList = processPwdUpdates( credList );
            System.debug('====> credentials after processPwdUpdates' + credList);
            
            // Serialize JSON response using List of credentials
            jsonResponse = generatePostResponse( credList );
            restRes.responseBody = Blob.valueOf(jsonResponse);
            System.debug('=====> restRes.responseBody is ' +restRes.responseBody );
            restRes.statusCode = 200;
        }
        catch(exception ex) {
            jsonResponse = 'Request failed: Error details-' + ex.getmessage();
            restRes.responseBody = Blob.valueOf(jsonResponse);
            restRes.statusCode = 500;
        }
        
        /*****LOGGING FRAMEWORK******/  
        logResponse(restRes, rq, resReq);
        /************END***************/
        // doPost response header and body are returned via the RestContext
        return; 
    }
    
    /*************************************************************************************
     * Purpose   : Apply various validation rules on the list of JSON request objects. And mark  
     *             any credential update requests that fail the checks invalid.  
     * Parameters: List of Credential objects 
     *
     * Return    : List of Credential objects
     *************************************************************************************/   
    public static List<Credential> validateRequest( List<Credential> credList ) {
        for (Credential cred : credList) {
            cred.isValid = true;  // set pre check default to valid

            //  Validation: accountName is required.
            if (cred.accountName == null) {
                cred.isValid = false;
                cred.errorMsg = 'Validatation error: accountName is a required element';
            } 
            //  Validation: accountName value must be present.
            if (cred.isValid && String.isBlank(cred.accountName)) {
                cred.isValid = false;
                cred.errorMsg = 'Validatation error: an accountName value must be specified';
            } 
            //  Validation: Ensure newPassword is not null or blank.
            if (cred.isValid && String.isBlank( cred.newPassword )) {
                cred.isValid = false;
                cred.errorMsg = 'Validatation error: new password can not be null or blank';
            } 
        }
        return credList;
    }

    /*************************************************************************************
     * Purpose   : For each valid incoming Credential object containing an accountName, attempt 
     *             a lookup against custom metadata type records containing credential location
     *             details. Augment the Credential object with the additional details.
     *             Note: Request accountNames can result in additional Credential objects being 
     *             added to the returned list when multiple lookup records are returned.
     *             Request accountNames not found during lookup are marked invalid in Credential.
     *             Note: Limits are relaxed for SOQL queries for querying Custom Metadata
     * Parameters: List of Credential objects 
     * Return    : List of Credential objects
     *************************************************************************************/   
    public static List<Credential> addLookupDetails( List<Credential> credList ) {
        List<Org_Credential_Location_Mapping__mdt> oMdtList = 
            new List<Org_Credential_Location_Mapping__mdt>();
        List<Credential> enhCredList = new List<Credential>();
        for (Credential cred : credList) {
            if (cred.isValid) {
                oMdtList = 
                    [select UserName__c, authProvider__c, OrgName__c, LocationType__c, 
                            LocationName__c, serviceURL__c
                            from Org_Credential_Location_Mapping__mdt 
                            where UserName__c =: cred.accountName];
                //System.debug('The value of oMdtList' + oMdtList);
                //System.debug('========>' +oMdtList.isEmpty());
                if (oMdtList.isEmpty() || oMdtList == null) {
                    cred.isValid = false;
                    //cred.errorMsg = 'Lookup error, system/user account name ' + cred.accountName + ' was not found'; 
                    cred.errorMsg = 'Lookup error: User account ' + cred.accountName + ' not found or not enabled for update';     
                    //System.debug('The value of cred.errorMsg 1' + cred.errorMsg);                   
                } else {
                    Integer count = 1;  // count to iterate over the cred list 
                    Integer index = 0;  // index to point to a lookup (__mdt) result record 
                    do {
                        System.debug('---count ' + count +' index '+index);
                        System.debug('---oMdtList' + oMdtList[index]);                      
                        // for first matching record returned, update the current cred
                        // if (cred.accountName == oMdtList[index].accountName)
                        If (count == 1) {                        
                            cred.authProvider = oMdtList[index].authProvider__c;
                            cred.orgName      = oMdtList[index].orgName__c;
                            cred.locationType = oMdtList[index].locationType__c;
                            cred.locationName = oMdtList[index].locationName__c;
                            cred.serviceURL   = oMdtList[index].serviceURL__c;
                        } 
                        // else for other result records (2nd to n) create new cred and add to credList 
                        else {
                            Credential newCred = new Credential();
                            newCred.isValid      = cred.isValid;
                            newCred.newPassword  = cred.newPassword;
                            newCred.accountName  = oMdtList[index].userName__c;
                            newCred.authProvider = oMdtList[index].authProvider__c;
                            newCred.orgName      = oMdtList[index].orgName__c;
                            newCred.locationType = oMdtList[index].locationType__c;
                            newCred.locationName = oMdtList[index].locationName__c;
                            newCred.serviceURL   = oMdtList[index].serviceURL__c;
                            // Save new cred(s) for now and add all to returned list before method completes
                            enhCredList.add(newCred);
                        }
                        count++; index++;
                    } while (count < oMdtList.size()+1);  
                } // end size is zero else block    
            } // end if cred is valid 
        } // end cred itr for loop
        // Incoming JSON accountNames stored in multiple SF locations add new objects to credList
        credList.addall(enhCredList);          
        return credList;
    }
    
    /*************************************************************************************
     * Purpose   : Iterate over list of Credential objects and process password updates. 
     *             There are multiple update types, where all callouts must be completed before
     *             any DML processing should occur (to avoid uncommitted work pending exception).
     *              1-callout local to metadata wrapper mdapi to update Named Credentials
     *              2-callout remote to update credentials in other orgs - same stage only.
     *              3-DML updates to environment variables, Salesforce users, etc.
     *              4-DML to complete logging of API request and response
     * Parameters: List of Credential objects  
     * Return    : List of Credential objects 
     *************************************************************************************/ 
    public static List<Credential> processPwdUpdates( List<Credential> credList ) {        
        List<CF_Organization__mdt> CFOrgList = new List<CF_Organization__mdt>();
        CFOrgList = [SELECT OrgId__c, OrgName__c, OrgNamedCred__c, IsActive__c 
                    FROM CF_Organization__mdt]; 
        Map<Integer, CF_Organization__mdt> CFOrgMap = new Map<Integer, CF_Organization__mdt>();
        Integer a = 0;
        for (CF_Organization__mdt cfOrg : CFOrgList) {
            a++;
            CFOrgMap.put(a, cfOrg);
            //System.debug('=====> CFOrgMap' + CFOrgMap);
        }
        //Getting the current looged in Org's Name
        //by comparing the orgId from CF_Organization__mdt
        //and the user logged in orgId 
        String orgKey; 
        String currOrgId; 
        String localOrgName;
        for (Integer key : CFOrgMap.keySet()) {
            orgKey = CFOrgMap.get(key).OrgId__c;
            currOrgId = UserInfo.getOrganizationId();
            if(orgKey == currOrgId){
                localOrgName = CFOrgMap.get(key).OrgName__c;  
                System.debug('=====> localOrgName ' +localOrgName );
            }       
            
        }  
        // Convert List to a Credential Map and also create maps for each subset of updates needed   
        Map<Integer, Credential> credMap = new Map<Integer, Credential>();
        Map<Integer, Credential> remoteCalloutMap = new Map<Integer, Credential>();
        Map<Integer, Credential> localNamedCredMap = new Map<Integer, Credential>();
        Map<Integer, Credential> localEnvVarMap = new Map<Integer, Credential>();
        Map<Integer, Credential> localSalesforceUserMap = new Map<Integer, Credential>();
        Integer i = 0;        
        for (Credential cred : credList) { 
            i++;
            credMap.put(i, cred);
            //System.debug('The value of credMap' + credMap);
            if(cred.isvalid){
                if (cred.orgName == localOrgName) {
                    if (cred.locationType == 'Named Credential') {
                        localNamedCredMap.put(i, cred);                  // updates via mdapex wrapper                 
                    }
                    if (cred.authProvider == 'salesforce') {
                        localSalesforceUserMap.put(i, cred);           // updates via System.setPassword()
                    }            
                    if (cred.locationType == 'Environment Variable') { 
                        localEnvVarMap.put(i, cred);                   // updates via local DML 
                    }            
                } else {
                    remoteCalloutMap.put(i, cred);                     // updates via org to org callout
                }            
            }
        }
        System.debug('======> localNamedCredMap size ' +localNamedCredMap.size());
        if (localNamedCredMap.size() > 0) {  
            localNamedCredMap        = doNamedCredentialsUpdate(localNamedCredMap);  
                
        }
        System.debug('======> remoteCalloutMap size' +remoteCalloutMap.size());
        if (remoteCalloutMap.size() > 0) {
            Map<Integer,IntegrationCredentialService.Credential> newRemoteCalloutMap = new Map<Integer,IntegrationCredentialService.Credential>();
            //remoteCalloutMap       = doRemoteOrgUpdates(remoteCalloutMap); 
            //remoteCalloutMap       = callRemoteQueue(remoteCalloutMap);
            newRemoteCalloutMap.putAll(remoteCalloutMap);
            IntegrationCred_Remote_Queue cJob = new IntegrationCred_Remote_Queue(newRemoteCalloutMap);
            System.debug('====> Remote callout queue job: '+ cJob);
            ID cJobID = System.enqueueJob(cJob);
            System.debug('cJobID: '+cJobID);     
        }
        System.debug('======> localEnvVarMap size' +localEnvVarMap.size());
        if (localEnvVarMap.size() > 0) {
            localEnvVarMap         = doEnvVariablesUpdate(localEnvVarMap);    
        }
        System.debug('=======> localSalesforceUserMap size' +localSalesforceUserMap.size());
        if (localSalesforceUserMap.size() > 0) {
            localSalesforceUserMap = doSalesforceUsersupdate(localSalesforceUserMap);
        }        
        // Put all returned types of updates (and their statuses ) back to main credMap
        credMap.putAll(localNamedCredMap);
        credMap.putAll(remoteCalloutMap);
        credMap.putAll(localEnvVarMap);
        credMap.putAll(localSalesforceUserMap);
        System.debug('==>credMap after updates: ' + credMap);
        // Return processed map as a list
        credList = credMap.values();
        return credList;
    }
    
    /*****************************************************************************************
     * Purpose   : Iterate over the local named credentails objects map 
                   makes a callout local to metadata wrapper mdapi to update Named Credentials
                   with the new password
     * Parameters: Map of Credential objects  
     * Return    : Map of Credential objects 
    *****************************************************************************************/ 
    //@TestVisible
    
    private static Map<Integer, Credential> doNamedCredentialsUpdate(Map<Integer, Credential> m) {
        // Query for existing credential locations of this location type        
        List<NamedCredential> namedCredList = [SELECT DeveloperName, Endpoint, Id, MasterLabel, PrincipalType 
                                               FROM NamedCredential ];
        // Generate map of existing locations using lookup key available in update request
        Map<String, NamedCredential> ncMap = new Map<String, NamedCredential>();
        for (NamedCredential  nc : namedCredList) {
            ncMap.put(nc.MasterLabel, nc);            
        }  
        List<MetadataService.NamedCredential> updateNCs = new List<MetadataService.NamedCredential>();
        // Interate over request credentials
        for (Integer key : m.keySet()) {
            // Process password update 
            String requestCredKey = m.get(key).locationName; 
            //System.debug('====> requestCredKey in named cred method' +requestCredKey);
            NamedCredential existingNC = ncMap.get(requestCredKey);
            System.debug('=====> existingNC  ' +existingNC );
            Credential cred = m.get(key);
            //System.debug('The value of cred ' +cred );
            MetadataService.NamedCredential updateNC = new MetadataService.NamedCredential();
            if (existingNC == null) {
                // matching existing NC not found; set incoming cred to inValid
                cred.isValid = false;
                cred.errorMsg = 'Update error, Named Credential ' + cred.locationName + ' does not exist';
                m.put(key, cred);   // propagate error to return map
            } else {  
                updateNC.fullName      = existingNC.DeveloperName;
                updateNC.endpoint      = existingNC.Endpoint;
                updateNC.principalType = existingNC.PrincipalType;
                updateNC.protocol      = 'Password';
                updateNC.username      = cred.accountName;      // from request
                //updateNC.label         = cred.label;     // from request
                updateNC.password      = cred.newPassword;      // from request
                updateNCs.add(updateNC);
                System.debug('=========> The value of updateNCs' +updateNCs );
            }         
        }
        if(updateNCs!=null){
            IntegrationCred_MD_Callout mdapiJob = new IntegrationCred_MD_Callout(updateNCs);
            System.debug('====> metadata api Job: '+ mdapiJob);
            queueablejobID = System.enqueueJob(mdapiJob);
            System.debug('queueablejobID value is : '+queueablejobID);
           
        }
        return m;
    }    
  
    
    /*****************************************************************************************
     * Purpose   : Iterates over the local environment varaible credential objects map 
                   and process the passwords
     * Parameters: Map of Credential objects 
    *****************************************************************************************/ 
    private static Map<Integer, Credential> doEnvVariablesUpdate(Map<Integer, Credential> m) {
        // Query for existing credential locations of this type  
        List<EnvironmentVariable__c> enVarList =[Select id, name, variable_name__c, value__c  
                                                 from EnvironmentVariable__c]; 
        // Generate map of existing locations using lookup key available in update request
        Map<String, EnvironmentVariable__c> evMap = new Map<String, EnvironmentVariable__c>();
        for (EnvironmentVariable__c ev : enVarList) { 
            evMap.put(ev.Variable_Name__c, ev );           
        }        
        List<EnvironmentVariable__c> updateEVs = new List<EnvironmentVariable__c>();
        // Interate over request credentials
        for (Integer key : m.keySet()) {
            // Process password update 
            String requestCredKey = m.get(key).locationName; 
            System.debug('====> requestCredKey in env method' +requestCredKey);
            EnvironmentVariable__c existingEV = evMap.get(requestCredKey);
            System.debug('====> existingEV ' + existingEV );
            Credential cred = m.get(key);
            if (existingEV == null) {
                // matching existing EV not found; set incoming cred to inValid
                cred.isValid = false;
                cred.errorMsg = 'Update error, Environment Variable ' + cred.locationName + ' does not exist';
                m.put(key, cred);   // propagate error to return map
            } else {                        
                System.debug('==>ev to update: '+existingEV);
                existingEV.value__c = cred.newPassword;     // from request
                updateEVs.add(existingEV);
            }         
        }
        if(updateEVs!=null)
        update updateEVs;
        return m;
    }
    
    /*****************************************************************************************
     * Purpose   : Iterates over the local salesforce users credentails objects map 
                   and processes users passwords
     * Parameters: Map of Credential objects
    *****************************************************************************************/ 
    private static Map<Integer, Credential> doSalesforceUsersupdate(Map<Integer, Credential> m) {
        // Query for existing credential locations for this location type       
        List<User> userList = [SELECT Id, Username, ProfileId, IsActive 
                                 FROM User
                                 WHERE IsActive=true 
                                 AND Profile.name like 'Integration%'];
        // Generate map of existing locations using lookup key available in update request
        Map<String, User> userMap = new Map<String, User>();
        for (User u : userList) {
            userMap.put(u.Username, u);         
        }        
        // Interate over request credentials
        for (Integer key : m.keySet()) {
            // Process password update 
            String requestCredKey = m.get(key).accountName;
            System.debug('====> requestCredKey in user method' +requestCredKey);
            User user = userMap.get(requestCredKey);
            //System.debug('The value of user----' +user);
            if (user == null) {
                // user not found; set cred to inValid
                System.debug('==>user to update not found: '+requestCredKey + ' ' +user);
                Credential cred = m.get(key);
                cred.isValid = false;
                cred.errorMsg = 'Update error, User ' + cred.accountName + ' does not exist';
                m.put(key, cred);
            } else {  
                String Id = user.Id;
                String newPassword = m.get(key).newPassword;
                System.setPassword(Id, newPassword); // Id, String 
            }         
        }
        return m;
    }   
    
    /*************************************************************************************
     * Purpose   : Instantiate and populate objects to be used to return result as a JSON string
     * Parameters: List of Credential objects    
     * Return    : JSON formatted string indicating results for credential updates 
    *************************************************************************************/ 
    public static String generatePostResponse( List<Credential> credList ) {
        // Create new response wrapper and list for response CredentialStatus objects
        CredentialUpdate credUpdate = new CredentialUpdate();
        List<CredentialStatus> credResults = new List<CredentialStatus>();
        for (Credential cred : credList) {
            CredentialStatus credStatus = new CredentialStatus();
            credStatus.accountName = cred.accountName;
            if (cred.isValid) { 
                String msg = 'Password rotation at ';
                If (cred.authProvider == 'Salesforce')
                    msg = msg + 'Salesforce process user';
                else
                    msg = msg + cred.locationType + ' ' + cred.locationName;
                credStatus.status = 'Success';
                credStatus.message = msg;
            } else {
                credStatus.status = 'Error';
                credStatus.message = cred.errorMsg;
            }
            credResults.add(credStatus);
        }
        credUpdate.credentialUpdates = credResults;
        System.debug('=====> credUpdate.credentialUpdates is ' + credUpdate.credentialUpdates);
        System.debug ('======> credUpdate' + JSON.serialize( credUpdate, true ));
        return JSON.serialize( credUpdate, true );  
    } 
    
    /*************************************************************************************
    * Purpose   : Invokes IntegrationRequest class which calculates the 
                  request time stamp/the pre-callout time of HTTP request
    *Parameter  : Request body of RestContext from GET and POST methods           
    * Return    : IntegrationRequest object  
    *************************************************************************************/  
    public static IntegrationRequest logRequest(RestRequest resReq){ 
        IntegrationRequest rq;
        IntegrationResponse rs;
        rq = new IntegrationRequest(); 
        Blob reqBlob;
        String jsonReq = RestContext.request.requestBody.toString();
        rq.source = 'Client';
        rq.target = 'IntgrnCrdntial';
        rq.targetAddress = '/IntegrationCredential';
        String method = resReq.httpMethod;       
        rq.relatedData ='Log is related to the IntegrationCredentialService '+method+' request'; 
        return rq;
    }
    
    /*************************************************************************************
    * Purpose   : Invokes IntegrationResponse class to calculate the 
                  post callout time stamp and the response time
    *Parameter  : Response body of RestContext from GET and POST methods, 
                  IntegrationRequest object and request body              
    * Return    : IntegrationResponse object 
    *************************************************************************************/ 
    public static void logResponse(RestResponse restRes , IntegrationRequest rq, RestRequest restReq){    
        IntegrationResponse rs;
        Blob resblob;
        Blob reqBlob;
        //String jsonReq = RestContext.request.requestBody.toString(); 
        String jsonReq = restReq.requestBody.toString();
        System.debug('=========>' + jsonReq); 
        String method = restReq.httpMethod;
        if(method == 'GET') {
        reqBlob = Blob.valueOf(jsonReq);
        rq.msgData = jsonReq;
        } 
        //Masking the new password before logging it.        
        String newRequestBody;
        if(method == 'POST') {
            CredentialWrapper deserialized = (CredentialWrapper) JSON.deserialize(jsonReq, CredentialWrapper.class); 
            System.debug('=========> deserialized new' + deserialized);        
            List <Credential> credList = new List <Credential>();
            credList = deserialized.credentials; 
            System.debug('==>json '+jsonReq);
            System.debug('==>credList new '+credList);
            for (Credential cred : credList) {
                cred.newPassword = '**masked**';
            }
            CredentialWrapper credWrap = new CredentialWrapper();
            credWrap.credentials = credList;
            newRequestBody = JSON.serialize(credWrap, true);
            System.debug('==>requestBody after change '+newRequestBody);
            reqBlob = Blob.valueOf(newRequestBody);
            System.debug('==>newRequestBody after change '+newRequestBody);
            System.debug('==>reqBlob after change '+ reqBlob);
            rq.msgData = newRequestBody;            
        }
        rs = new IntegrationResponse(rq);
        String jsonResp = restRes.responseBody.toString();
        System.debug('======> jsonResp in logResponse' + jsonResp);
        resblob = restRes.responseBody;
        if(restRes.statusCode == 200){
            rs.responseStatus = 'Success';  
            rs.responseStatusDescription = 'The request has succeeded'; 
        }
        else{
            rs.responseStatus = 'Error'; 
            rs.responseStatusDescription = 'The request has errored'; 
        }         
        rs.msgData = jsonResp ;     
        rs.relatedData = 'Log is related to the IntegrationCredentialService '+method+' request';
        System.debug('==>reqBlob later '+ reqBlob);  
        Integration.log(rq,reqBlob);
        Integration.log(rs,resblob);        
    }  
    
}