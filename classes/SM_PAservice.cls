//=========================================================================================
//      Date: 07/22/2018
// Developer: Tom Barrett (TPB)
//   Purpose: This class is the class that is part of the Sandbox Manager App.                
//            This class's caller is SM_PAcallout.provisionUsers().
//            This class must be in each destination org (sandbox) that is expected to be
//            managed by the Sandbox Manager App.
//            This class uses the SM_Support.isSandbox() method to safeguard 
//            against executing in a production org as this class should only execute
//            in a sandbox.
//            
//=========================================================================================
//                                 Update History
// Date       Developer     Tag     Description
//=========================================================================================
//
//=========================================================================================
@RestResource(urlMapping='/SM_PAservice/*')
global with sharing class SM_PAservice {    
    public static Map<String, SM_Support.LogWrapper> ResponseWrapperMap = new Map<String, SM_Support.LogWrapper>();
    
    @HttpPost
    global static void DoProfileAudit() { 
        System.debug('---SM_PAservice.DoProfileAudit()---');        
        //If we are not running in a sandbox then get out quickly!
        if(!SM_Support.isSandbox()) return;
        //This called just to instantiate its public static variables  
        SM_Wrappers wrp = new SM_Wrappers();
        List<String> UsernameList = new List<String>();         
        RestRequest req = RestContext.request;       
        RestResponse res = RestContext.response;        
        //De-serializing the incoming request which contains the content of the SM_Wrapper class
        SM_Wrappers deserializedWrappers = (SM_Wrappers) JSON.deserialize(req.requestBody.toString(), SM_Wrappers.class);
        //Put the conent back into an instance of the SM_Wrappers class
        //we can get to the UserWrapperMap content
        SM_Wrappers dw = deserializedWrappers;         
        List<String> ProfileAuditProfileList = new List<String>();
        String ProfileNames = dw.SettingWrapperMap.get('Profile_Audit_Profile_List').TextArea255Setting;    
        Boolean ExcludeFrozenUsers = dw.SettingWrapperMap.get('Profile_Audit_Exclude_Frozen_Users').CheckboxSetting;
        //remove space after comma if it exists to that the split function works as expected            
        ProfileNames = ProfileNames.replace(', ', ',');
        ProfileAuditProfileList = ProfileNames.split(',');             
        //Set the default if not populated on the Profile_Audit_Profile_List record.
        if (ProfileAuditProfileList.isEmpty()) ProfileAuditProfileList.add('System Administrator'); 
                
        //Get user dummy record (see caller for details)
        String SandboxName = dw.UserWrapperMap.values()[0].SandboxName;
        String EmailGrouping = dw.UserWrapperMap.values()[0].EmailGrouping;
        String LogGrouping = dw.UserWrapperMap.values()[0].LogGrouping;
        
        List<SM_Support.LogWrapper> LogWrapperList = new List<SM_Support.LogWrapper>();
        //Get list of users that match the ProfileAuditList values
        LogWrapperList = SM_Support.buildLogWrapperForPA(ProfileAuditProfileList, EmailGrouping, LogGrouping+'_PA_2', SandboxName, 'SM_PAservice');        
        //Get isFrozen information and add to the isFrozen field
        LogWrapperList = SM_Support.getIsFrozen(LogWrapperList, ExcludeFrozenUsers);
        //Write to the log
        Integer DayToStartDeletion = dw.SettingWrapperMap.get('Log_Deletion').NumberSetting;  
        SM_Logging log = new SM_Logging(LogWrapperList, DayToStartDeletion, false); 
        
        //Send Response back with logged data
        String LogSerialized = JSON.serialize(LogWrapperList, true);       
        res.responseBody = Blob.valueOf(LogSerialized);
    }  
}