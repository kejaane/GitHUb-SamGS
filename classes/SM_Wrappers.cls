//=========================================================================================
//      Date: 11/02/2018
// Developer: Tom Barrett
//   Purpose: This wrapper class currently has two wrapper classes.  One for the User record
//            and the other for the custom metadata type setttings.
//            Any future wrappers need should be create in this class unless it makes sense
//            not to.
// 
// Limitations: Max of 9,999 users can be processed.  This is controlled by the SOQL query;
//              however, other governor limits could reduce this number.  governor limits
//              suchs as timeouts, for example.                
//=========================================================================================
//                                 Update History
// Date       Developer         Tag     Description
//=========================================================================================
//                               
//=========================================================================================
public class SM_Wrappers {    
    public class SM_WrappersException extends Exception {}
    
    public Map<String, UserWrapper> UserWrapperMap = new Map<String, UserWrapper>();
    public Map<String, SettingWrapper> SettingWrapperMap = new Map<String, SettingWrapper>();

    /***************************************************
     * SM_Setting__mdt usage variables declaration.    
     * These variables support the GetSettings method.
     * The variables are used by number classes
     * Enabled or Disabled detection of SM and modules
     ***************************************************/   
    public static Boolean SandboxManagerEnabled = false;
    public static Boolean DeactivateUsersEnabled = false;
    public static Boolean ProvisionUsersEnabled = false;
    public static Boolean ProfileAuditEnabled = false;
    //Used in SM_DUcallout class to determine what sandboxes to deprovision users in
    public static List<String> DeprovisionSandboxLimitList = new List<String>();
    //List of email addresses that receive emails from module activity that occurs
    public static List<String> EmailThatSMmoduleExecutedList = new List<String>();
    //Used in SM_PUcallout class to determine what sandboxes to do user provision in
    public static List<String> ProvisionSandboxLimitList = new List<String>();
    //Used in the SM_Log__c record deletion process
    //Default 0 means no deletion will occur
    public static Integer DayToStartDeletion = 0;
    //Used to audit what users have the certain profiles
    public static List<String> ProfileAuditProfileList = new List<String>();
    //Used for which Sandboxes are processed for the PA_callout module
    public static List<String> ProfileAuditSandboxLimitList = new List<String>();
    //Timeout Setting for callouts - default is 10 seconds (10,000 milliseconds)
    public static integer Timeout = 10000;
    //Default NCchunkSetting = 1 if value is blank on the custom metadata record
    public static Integer NCchunkSetting = 1;
    //Controls the delay that occurs prior to the SM_Email class actually starts
    //reading the SM_Log__c so that we can ensure the Queueable code completed
    //the writes to the log table.
    public static Decimal EmailLogDelay = 10;
    //Used to determine if you want to exclude the log record from the PA process
    public static Boolean ExcludeFrozenUsersEnabled = false;

    public SM_Wrappers() {
        getSettings();
    }    
    
    public void getUsers(Set<id> UserIds) {
        System.debug('---SM_Wrappers.GetUsers(Set<id> UserIds)---');       
        //Populate UserWrapperMap from the User object      
        for (User u : [SELECT id, Username, FirstName, LastName, Email, Alias, isActive, 
                              Profile.Name, FederationIdentifier, LastModifiedDate, 
                              LastLoginDate, SM_Bypass_SM_Deprovision__c                  
                       FROM User
                       WHERE id in :UserIds
                       ORDER BY Username LIMIT 9999]) {
         
            UserWrapper uw = new UserWrapper();
            uw.SandboxName = '';
            uw.Username = u.Username.toLowerCase();
            uw.UsernameAdjusted = '';
            uw.FirstName = u.FirstName;
            uw.LastName = u.LastName;
            uw.Email = u.Email;
            uw.Alias = u.Alias;
            uw.isActive = u.isActive;
            uw.FederationIdentifier = u.FederationIdentifier;
            uw.ProfileName = u.Profile.Name;                    
            uw.PermissionSets = 'n/a';
            uw.LastModifiedDate = u.LastModifiedDate;
            uw.LastLoginDate = u.LastLoginDate;
            uw.BypassSMDeprovision = u.SM_Bypass_SM_Deprovision__c;
            UserWrapperMap.put(u.Username,uw); 
        }
    }        
    
    /****************************
     * Gets the SM_Settings__mdt
     ****************************/
    private void getSettings() {
        System.debug('---SM_Wrappers.GetSettings()---');  
        
        //Populate SettingWrapperMap from SM_Setting__mdt
        for(SM_Setting__mdt sm : [SELECT QualifiedApiName, Text_Area_255__c, Checkbox__c, Number__c
                                  FROM SM_Setting__mdt]) {                                 
            //Setup some defaults
            SettingWrapper sw = new SettingWrapper();
            sw.QualifiedApiNameSetting = sm.QualifiedApiName;
            sw.TextArea255Setting = '';
            sw.CheckboxSetting = false;
            sw.NumberSetting = 0;                                      
                                      
            //Begin setting variables based on custom metadata type data           
            if (sm.QualifiedApiName == 'Email_That_SM_Module_Executed' && sm.Text_Area_255__c != NULL) {
                sw.TextArea255Setting = sm.Text_Area_255__c;
            }    
            
            if (sm.QualifiedApiName == 'Sandbox_Manager') {
                sw.CheckboxSetting = sm.Checkbox__c;
            }
            
            if (sm.QualifiedApiName == 'Deactivate_Users') {
                sw.CheckboxSetting = sm.Checkbox__c;
            }
    
            if (sm.QualifiedApiName == 'Deprovision_Sandbox_Limit_List' && Test.isRunningTest()) sm.Text_Area_255__c = 'TestBox';
            if (sm.QualifiedApiName == 'Deprovision_Sandbox_Limit_List' && sm.Text_Area_255__c != NULL) {
                sw.TextArea255Setting = sm.Text_Area_255__c.toLowerCase();
            }  
            
            if (sm.QualifiedApiName == 'Provision_Users') {
                sw.CheckboxSetting = sm.Checkbox__c;
            }

            if (sm.QualifiedApiName == 'Provision_Sandbox_Limit_List' && Test.isRunningTest()) sm.Text_Area_255__c = 'TestBox';                                      
            if (sm.QualifiedApiName == 'Provision_Sandbox_Limit_List' && sm.Text_Area_255__c != NULL) {
                sw.TextArea255Setting = sm.Text_Area_255__c.toLowerCase();
            }  
            
            if (sm.QualifiedApiName == 'Log_Deletion' && sm.Number__c != NULL ) {
                sw.NumberSetting = sm.Number__c.intValue();
            }
            
            if (sm.QualifiedApiName == 'Profile_Audit') {
                sw.CheckboxSetting = sm.Checkbox__c;    
            }
            
            if (sm.QualifiedApiName == 'Profile_Audit_Sandbox_Limit_List' && Test.isRunningTest()) sm.Text_Area_255__c = 'TestBox';                             
            if (sm.QualifiedApiName == 'Profile_Audit_Sandbox_Limit_List' && sm.Text_Area_255__c != NULL) {
                sw.TextArea255Setting = sm.Text_Area_255__c.toLowerCase();
            }    
            
            if (sm.QualifiedApiName == 'Profile_Audit_Profile_List' && sm.Text_Area_255__c != NULL) {
                sw.TextArea255Setting = sm.Text_Area_255__c.toLowerCase();            
            }     
                                      
            //Set the default if not populated on the Profile_Audit_Profile_List record.                       
            if (sm.QualifiedApiName == 'Profile_Audit_Profile_List' && (sm.Text_Area_255__c == NULL || sm.Text_Area_255__c == '' || Test.isRunningTest())) {
                sw.TextArea255Setting = 'System Administrator';            
            }              
                                      
            //If Timeout is NULL/Blank or zero at the SM_Setting__mdt then the default is set to 10.
            //The next if condition will set it to 10,000 which is equal to 10 seconds.                        
            if (sm.QualifiedApiName == 'Timeout' && (sm.Number__c == NULL || sm.Number__c == 0 || Test.isRunningTest())) {
                //Convert to milliseconds
                sw.NumberSetting = 10;
            }                                        
            if (sm.QualifiedApiName == 'Timeout' && sm.Number__c != NULL) {
                //Convert to milliseconds
                sw.NumberSetting = sm.Number__c.intValue() * 1000;
                
            }             
                                      
            if (sm.QualifiedApiName == 'NC_Chunk_Setting' && sm.Number__c != NULL) {
                sw.NumberSetting = sm.Number__c.intValue();
            }     
            
            if (sm.QualifiedApiName == 'Email_Log_Delay' && sm.Number__c != NULL) {
                sw.NumberSetting = sm.Number__c.intValue();
            }

            if (sm.QualifiedApiName == 'Profile_Audit_Exclude_Frozen_Users') {
                sw.CheckboxSetting = sm.Checkbox__c;
            }                                      
                                      
            SettingWrapperMap.put(sm.QualifiedApiName, sw); 
        } 
        SetSettingsVariables();
    }
    
    /******************************************************************
     * This methods converts custom settings.  It takes settings with
     * comma seperated values (i.e.: Email_That_Module_Executed could 
     * have more than one email address) into lists variable holders.
     * It also, handles all other settings into variables.
     ******************************************************************/
    private void setSettingsVariables() {
        String RemoveSpaceThenSplit = '';
        String SandboxNames = ''; 
        String msg = 'Custom Error was thrown: ';
        msg += 'Either the custom metadata type SM_Setting record \'Email_That_SM_Module_Executed\' ';
        msg += 'record is missing or the value in the \'Text Area 255\' is missing!  Enter at least one email address.';
        
        SandboxManagerEnabled = SettingWrapperMap.get('Sandbox_Manager').CheckboxSetting;
        DeactivateUsersEnabled = SettingWrapperMap.get('Deactivate_Users').CheckboxSetting; 
        ProvisionUsersEnabled = SettingWrapperMap.get('Provision_Users').CheckboxSetting; 
        DayToStartDeletion = SettingWrapperMap.get('Log_Deletion').NumberSetting;        
        ProfileAuditEnabled = SettingWrapperMap.get('Profile_Audit').CheckboxSetting; 
        Timeout = SettingWrapperMap.get('Timeout').NumberSetting;  
        NCchunkSetting = SettingWrapperMap.get('NC_Chunk_Setting').NumberSetting; 
        EmailLogDelay = SettingWrapperMap.get('Email_Log_Delay').NumberSetting;  
        ExcludeFrozenUsersEnabled = SettingWrapperMap.get('Profile_Audit_Exclude_Frozen_Users').CheckboxSetting;
 
        //Begin setting variables based on 
        If (SettingWrapperMap.get('Email_That_SM_Module_Executed').TextArea255Setting != '') {
            RemoveSpaceThenSplit = SettingWrapperMap.get('Email_That_SM_Module_Executed').TextArea255Setting.replace(' ', '');  
            EmailThatSMmoduleExecutedList = RemoveSpaceThenSplit.split(',');
        } else {
            System.debug(msg);
            throw new SM_WrappersException(msg);    
        } 
        
        If (SettingWrapperMap.get('Deprovision_Sandbox_Limit_List').TextArea255Setting != '') {        
            SandboxNames  = SettingWrapperMap.get('Deprovision_Sandbox_Limit_List').TextArea255Setting.toLowerCase();
            //remove space after comma if it exists to that the split function works as expected
            SandboxNames = SandboxNames.replace(' ', '');
            DeprovisionSandboxLimitList = SandboxNames.split(',');
        } 
        
        if (SettingWrapperMap.get('Provision_Sandbox_Limit_List').TextArea255Setting != '') {
            SandboxNames  = SettingWrapperMap.get('Provision_Sandbox_Limit_List').TextArea255Setting.toLowerCase();
            //remove space after comma if it exists to that the split function works as expected
            SandboxNames = SandboxNames.replace(' ', '');
            ProvisionSandboxLimitList = SandboxNames.split(',');
        } 
        
        if (SettingWrapperMap.get('Profile_Audit_Sandbox_Limit_List').TextArea255Setting != '') {
            SandboxNames  = SettingWrapperMap.get('Profile_Audit_Sandbox_Limit_List').TextArea255Setting.toLowerCase(); 
            //remove space after comma if it exists to that the split function works as expected
            SandboxNames = SandboxNames.replace(' ', '');
            ProfileAuditSandboxLimitList = SandboxNames.split(',');
        }    
        
        if (SettingWrapperMap.get('Profile_Audit_Profile_List').TextArea255Setting != '') {
            String ProfileNames = SettingWrapperMap.get('Profile_Audit_Profile_List').TextArea255Setting;
            //remove space after comma if it exists to that the split function works as expected            
            ProfileNames = ProfileNames.replace(', ', ',');
            ProfileAuditProfileList = ProfileNames.split(',');
        }         
        //Set the default if not populated on the Profile_Audit_Profile_List record.
        if (ProfileAuditProfileList.isEmpty()) ProfileAuditProfileList.add('System Administrator');
        
        //Set variables to specifics for test classes to have consistant results.
        //Because SF does not allow CMT's to be created in a test class this is the work around
        //for consistant test class results.
        if (Test.isRunningTest()) {
            EmailThatSMmoduleExecutedList.clear();
            EmailThatSMmoduleExecutedList.add('SomeEmailAddress@SomeEmailAddress.com');            
            SandboxManagerEnabled = true;
            DeactivateUsersEnabled = true;
            ProvisionUsersEnabled = true;
            ProfileAuditProfileList.clear();
            ProfileAuditProfileList.add('System Administrator');
            Timeout = 10000;
            DayToStartDeletion = 180;
            EmailLogDelay = 10;
        }    
    }    
    
    ///////////////////////////////////////////////
    // ALL WRAPPER CLASSES SHOULD GO AT THE END  //
    // OF THIS CLASS JUST TO KEEP THEM ORGANIZED //
    ///////////////////////////////////////////////
    public class UserWrapper {
        public String EmailGrouping {get; set;}
        public String LogGrouping {get; set;}
        public String SandboxName {get; set;}        
        public String Username {get; set;}
        public String UsernameAdjusted {get; set;}
        public String FirstName {get; set;}
        public String LastName {get; set;}
        public String Email {get; set;}
        public String Alias {get; set;}
        public Boolean isActive {get; set;}
        public String FederationIdentifier {get; set;}
        public String ProfileName {get; set;}
        public String PermissionSets {get; set;}
        public DateTime LastModifiedDate {get; set;}
        public DateTime LastLogInDate {get; set;}
        public Boolean BypassSMDeprovision {get; set;}
        public String isFrozen {get; set;}
    }
    
    public class SettingWrapper {
        public String QualifiedApiNameSetting {get; set;}
        public String TextArea255Setting {get; set;}
        public Boolean CheckboxSetting {get; set;}
        public Integer NumberSetting {get; set;}           
    }
}