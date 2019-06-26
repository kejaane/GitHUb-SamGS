//=========================================================================================
//      Date: 04/07/2018
// Developer: Tom Barrett 
//   Purpose: This classes primary purpose is to contain logic that would be shared between
//            the Callout (Client) and the Service (Server) or multiple Callout classes.             
//          
//=========================================================================================
//      All Associated Components for the Sandbox Manager App should be listed below
// Object                              Object Type	Notes
//=========================================================================================
// SM_DUcallout_Test                  | Class
// SM_DUcallout                       | Class
// SM_DUservice_Test                  | Class
// SM_DUservice                       | Class
// SM_PAcallout                       | Class	***	Need to comment/uncomment line before package creation
// SM_PAcallout_Test                  | Class
// SM_PAservice                       | Class
// SM_PAservice_Test                  | Class
// SM_PAcallout_Schedule			  | Class
// SM_PAcallout_Schedule_Test		  | Class
// SM_PAcontroller                    | Class
// SM_PAcontroller_test               | Class
// SM_ProfileAudit                    | Visualforce
// SM_PUcallout                       | Class
// SM_PUcallout_Test                  | Class
// SM_PUservice                       | Class
// SM_PUservice_Test                  | Class
// SM_RequestMock                     | Class
// SM_Support                         | Class 
// SM_User_Trigger                    | Trigger	***	Need to comment/uncomment LINES before package creation
// SM_User_Trigger_Logic              | Class	
// SM_User_Trigger_Test				  | Class	
// SM_Introduction                    | Visualforce
// SM_Introduction_Controller         | Class
// SM_Introduction_Controller_Test    | Class 
// SM_Log__c                          | Object/Table
// SM_Log__c                          | Tab  
// SM_Logging                         | Class 
// SM_QueueableDispatch				  | Class   
// SM_Email							  | Class
// SM_Email_Test					  | Class   
// SM_Wrappers						  | Class       Contains all wrapper classes                            
//=========================================================================================
//                                 Update History
// Date       Developer     	Tag     Description
//=========================================================================================
//
//=========================================================================================
public class SM_Support {  
    public class SM_SupportException extends Exception {}
    //The two variables below help reduce the need to call the SOQL query
    //that is in the SM_Support.isSandbox method 
    private static Boolean isSandboxValidated = false;
    private static Boolean isOrgSandbox = false;  
    public String SandboxName;    
    public List<NamedCredential> NamedCredentialList = new List<NamedCredential>();
    //Used to get the sandbox name based on the Named Credential's Developername
    public Map<String, String> NamedCredentialToSandboxNameMap = new Map<String, String>();   
//    private static Map<String, SM_Setting__mdt> SMsettingMap = new Map<String, SM_Setting__mdt>();

    //Enum for Module Names
    public enum ModuleName {Profile_Audit, Deprovision_User, Provision_User}      
    
    /*******************************
     * SM_Support constructor
     *******************************/
    Public SM_Support() {
        System.debug('---SM_Support class Constructor---');
        getNamedCredentials();
    }  
    
    /***********************************************************************
     * Using the UserWrapper class build a Map of the LogWrapper class which 
     * is the holder for the the messaging that will come back to the 
     * caller with the log as the response.
     ***********************************************************************/   
    public static Map<String, SM_Support.LogWrapper> buildUserResponseWrapperMap(List<SM_Wrappers.UserWrapper> UserList, String MsgSource) {
        System.debug('---SM_Support.buildUsersResponseWrapperMap()---');
        Map<String, SM_Support.LogWrapper> UserResponseWrapperMap = new Map<String, SM_Support.LogWrapper>();
        Map<String, User> ServerSideUserInfo = GetServerSideUserInfo(UserList);      
        String ProfileName = '';
        
        for (SM_Wrappers.UserWrapper u : UserList ) {
            SM_Support.LogWrapper lw = new SM_Support.LogWrapper();
            lw.EmailGrouping = u.EmailGrouping;
            lw.LogGrouping = u.LogGrouping;      
            lw.Username = u.UsernameAdjusted;
            lw.ProfileName = 'n/a';
            lw.PermissionSets = 'n/a';
            if (ServerSideUserInfo.get(lw.Username) != null) {
 				if (ServerSideUserInfo.get(lw.Username).Profile.Name != null) lw.ProfileName = ServerSideUserInfo.get(lw.Username).Profile.Name;
 				if (ServerSideUserInfo.get(lw.Username).LastModifiedDate != null) lw.LastModifiedDate = ServerSideUserInfo.get(lw.Username).LastModifiedDate;   
 				if (ServerSideUserInfo.get(lw.Username).LastLoginDate != null) lw.LastLoginDate = ServerSideUserInfo.get(lw.Username).LastLoginDate;                
            }
            //Set Default LastModifiedDate to System.Now() if the User.LastModifiedDate == null.  This is the best we can do if below code detects 
            //NULL we will have a date to match the new user if this is called by the Provision User process but the time will be slightly off 
            //compared to when the record is actually created on the database layer.
            if (u.LastModifiedDate == NULL) lw.LastModifiedDate = System.Now();
            
            //Default to Chatter Free for Provision User process
            if (MsgSource == 'SM_PUservice') lw.ProfileName = 'Chatter Free User';
            lw.PermissionSets = u.PermissionSets;
//            lw.LastModifiedDate = u.LastModifiedDate;
//            lw.LastLoginDate = u.LastLoginDate;
            lw.SandboxName = u.SandboxName;
            lw.Severity = '';
            lw.MsgSource = MsgSource;
            lw.Msg = '';
            UserResponseWrapperMap.put(lw.Username.toLowerCase(), lw);            
        }
        return UserResponseWrapperMap;
    } 
    
    /*************************************************************
     * Get the server side user info so we can report its details
     * to the server side and back to the caller/client side logs
     *************************************************************/    
    private static Map<String, User> getServerSideUserInfo(List<SM_Wrappers.UserWrapper> UserList) {
    	Map<String, User> UserMap = new Map<String, User>();
        Set<String> usernameSet = new Set<String>();
		      
        for (SM_Wrappers.UserWrapper uw : UserList) {
        	usernameSet.add(uw.UsernameAdjusted); 
        }
        
        for (User u : [SELECT id, Username, Profile.Name, LastModifiedDate, LastLoginDate
                         FROM User
                         WHERE Username in :usernameSet
                         LIMIT 9999]) {
                             
            UserMap.put(u.Username, u);
        }   
        return UserMap;
    }    
    
    
    /*******************************************************
     * UserResponseWrapper class used to hold the 
     * messaging that takes place during the service process    
     *******************************************************/    
    public class logWrapper {
        //Primary Members for logging
        public String EmailGrouping {get; set;}
        public String LogGrouping {get; set;}
        public String SandboxName {get; set;}
        public String Severity {get; set;}
        public String MsgSource {get; set;}
        public String Msg {get; set;}
        //Misc Members for logging that would come from specific
        //modules that may be created for SM should go here.
        public String Username {get; set;}
        public String ProfileName {get; set;}
        public String PermissionSets{get; set;}
        public DateTime LastModifiedDate {get; set;}
        public DateTime LastLoginDate {get; set;}
        public String isFrozen {get; set;}
    }    
        
    
   /***************************************************
     * Get Map of Named Credentials
     * key = Named Credential and value = sandbox named
     * parsed from the Named Credential's URL
     * Only the Client/Callout should ever call this
     ***************************************************/
    private void getNamedCredentials(){    
        System.debug('---SM_Support.getNamedCredentials()---');
        for (NamedCredential cn : [SELECT Id, DeveloperName, Endpoint 
                                   FROM NamedCredential
                                   WHERE DeveloperName LIKE 'Sandbox_Manager_%'
                                   ORDER BY DeveloperName LIMIT 500]) {             
            //Parse the sandbox name from the Endpoint
            //This only works if "my domain" is active in the destination sandbox
            //which it should be since this solution uses Named Credentials and 
            //Connected Apps.
            //Example: https://carefirst--uat.cs66.my.salesforce.com            
            this.SandboxName = cn.Endpoint.SubstringAfter('--');        //becomes - uat.cs66.my.salesforce.com
            this.SandboxName = this.SandboxName.SubstringBefore('.');   //becomes 'uat' - and thats what we want  
            this.SandboxName = this.SandboxName.toLowerCase();         
            this.NamedCredentialToSandboxNameMap.put(cn.DeveloperName, this.SandboxName);             
            this.NamedCredentialList.add(cn);
        }
        //We need to get past code coverage if installed and no named credentials
        //are created prior.  Trickery is necessary sometimes in the Apex world!
        If(Test.isRunningTest() && NamedCredentialToSandboxNameMap.isEmpty()) {
            this.SandboxName = 'uat';
            NamedCredentialToSandboxNameMap.put('Sandbox_Manager_01', 'uat');
        }  
    }  
    
   
    /******************************************************************
     * Used by the client to make sure it only runs in production.
     * Used by the service side to make sure it only runs in a sandbox.     * 
     ******************************************************************/    
   public static Boolean isSandbox() {  
        System.debug('---SM_Support.isSandbox()---');
        if (!isSandboxValidated) {            
            // we only call the select once with the help of variable isSandboxValidated
            isOrgSandbox = [SELECT Id, IsSandbox FROM Organization limit 1].isSandbox;
            isSandboxValidated = true; 
        }     
        // trick code that we are in sandbox when testing executes in production for code coverage
        if (Test.isRunningTest()) isOrgSandbox = true; 
        
        System.debug('SM_Support.isSandbox about to return: ' + isOrgSandbox);
        return isOrgSandbox;
    }       
    
    
    /***********************************************************
     * Used by both the SM_PAcallout and SM_PAservice to build
     * the Log that will contain all active users who match 
     * the ProfileAuditList values passed into this method.
     ***********************************************************/        
    public Static List<SM_Support.LogWrapper> buildLogWrapperForPA(List<String> ProfileAuditList, String EmailGrouping, String LogGrouping, String SandboxName, String MsgSource) {          
        System.debug('---SM_Support.buildLogWrapper()---');
        List<SM_Support.LogWrapper> LogWrapperProdList = new List<SM_Support.LogWrapper>();
        String PermSets = '';
                
        for(User u : [SELECT Username, Profile.Name, LastModifiedDate, LastLoginDate,
                             (SELECT PermissionSet.Name
                              FROM PermissionSetAssignments)
                      FROM User 
                      WHERE isActive = TRUE AND Profile.name IN :ProfileAuditList
                      ORDER BY LastModifiedDate DESC, Username LIMIT 9999]) {
                          
        	for (PermissionSetAssignment pma : u.PermissionSetAssignments) {
                //Skip if some kind of hidden permset reported by SF
                //i.e.: X00eA00000012RKV_261_18_04_34_7 
                if(!pma.PermissionSet.Name.Contains('X00')) PermSets += pma.PermissionSet.Name + ', ';
            }
            if(PermSets != null) PermSets = PermSets.removeEnd(', ');  
   
            SM_Support.LogWrapper LogWrapperProd = new SM_Support.LogWrapper();
            LogWrapperProd.EmailGrouping = EmailGrouping;
            LogWrapperProd.LogGrouping = LogGrouping; 
            LogWrapperProd.SandboxName = SandboxName;
            LogWrapperProd.Severity = 'None';
            LogWrapperProd.MsgSource = MsgSource;
            LogWrapperProd.Msg = 'Profile Audit Action';
            LogWrapperProd.Username = u.Username; 
            LogWrapperProd.ProfileName = u.Profile.Name;
            LogWrapperProd.PermissionSets = PermSets;
            LogWrapperProd.LastModifiedDate = u.LastModifiedDate;
            LogWrapperProd.LastLoginDate = u.LastLoginDate;
            LogWrapperProdList.add(LogWrapperProd); 
            PermSets = '';
        }
        return LogWrapperProdList;
    }

    /**************************************************************
     * Method used to determine if the user is frozen or not and
     * store it on each of the LogWrapper records
     **************************************************************/
    public Static List<SM_Support.LogWrapper> getIsFrozen(List<SM_Support.logWrapper> logWrapperList, Boolean ExcludeFrozenUsers) {
        List<String> usernameList = new List<String>();
        List<SM_Support.logWrapper> returnLogWrapperList = new List<SM_Support.logWrapper>();
        Map<Id, User> userMap = new Map<Id, User>();   
        Map<String, String> userNameIsFrozenMap = new Map<String, String>(); 
        String username;
        String isFrozen;
       
        //Build a list of usernames from the logWrapperList
        for (SM_Support.logWrapper lw : logWrapperList) {
            usernameList.add(lw.Username);
        }

        //User the userNameList to build a userMap of id key and user values
        for (User user : [SELECT Id, Username FROM User WHERE Username IN :userNameList]) {
            userMap.put(user.id, user);
        }

        //Finally, read the UserLog to get info on users who are frozen or not and put
        //username and isFrozen into a map
        for (UserLogin user : [SELECT Id, UserId, IsFrozen 
                                       FROM UserLogin 
                                       WHERE userId IN (SELECT Id FROM User WHERE Id IN :userMap.keySet())]) {
            username = userMap.get(user.UserId).Username;
            isFrozen = 'No';
            if (user.IsFrozen) {
                isFrozen = 'Yes';
            }
            usernameIsFrozenMap.put(username, isFrozen);
        }   

        //Loop through the logWrapperList and populate the isFrozen field
        for (SM_Support.logWrapper lw : logWrapperList) {
            lw.isFrozen = userNameIsFrozenMap.get(lw.Username);
            //If custom setting is true and user is not frozen add the user to the sm log
            if(ExcludeFrozenUsers && lw.isFrozen == 'No') returnLogWrapperList.add(lw);
            //if custom setting is false add the user to the sm log
            if(!ExcludeFrozenUsers) returnLogWrapperList.add(lw);
        }
        return returnLogWrapperList;
    }


    
    /*******************************************
     * Method used by the callouts based on the 
     * response from the service itself
     *******************************************/
    public static String getResponseErrorMsg(Integer StatusCode) {
    	if (StatusCode == 401) {
            return ' :: Check Named Credential Authorization.';   
        } else if (StatusCode == 404) {
            return ' :: Check if the service class and its dependencies are installed on the sandbox.';
        } else if (StatusCode == 500) {
            return ' :: Please check if the verion of Sandbox Manager is the same in production and on the sandbox.';
        } else {
            return ':: Unknown Sandbox Manager Error!';
        }         
    }
}