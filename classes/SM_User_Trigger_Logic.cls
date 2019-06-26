//=========================================================================================
//      Date: 07/06/2018
// Developer: Tom Barrett
//   Purpose: This class should only be called from the SM_User_Trigger class.  It is part 
//            of the Sandbox Manager (SM) App.  It could be made to tightly couple into the 
//            standard framework we use at CareFirst; however, that could become problematic 
//            when upgrading SM as it would have to uninstalled and reinstalled.  
//            When doing so that could produce unforescene issues with related trigger code 
//            as it would not not be part of the SM package.
//=========================================================================================
//                                 Update History
// Date       Developer         Tag     Description
//=========================================================================================
//                               
//=========================================================================================
public class SM_User_Trigger_Logic {        
public static Integer TestTotalUserIdCount = 0;  
    /************************************************
     * Method used to de-provision users in sandboxes
     ************************************************/ 
    public static void usersUpdated(List<User> TriggerNewIn, List<User> TriggerOldIn, Map<id, User> TriggerOldMapIn) {     
        System.debug('---SM_User_Trigger_Logic.UsersUpdated---');
        System.debug('TriggerNewIn.size(): ' + TriggerNewIn.size());
        Set<Id> DeprovisionUserIds = new Set<Id>(); 
        Set<Id> ProvisionUserIds = new Set<Id>();        
        List<User> UsersBypassed = new List<User>();
        List<User> TriggerNew = new List<User>();
        Map<Id, User> TriggerOldMap = new Map<Id, User>();  
        
        //if the user record is being updated and it is a before trigger and the user is 
        //being deactivated and the SM_Bypass_SM_Deprovision__c is TRUE only then do we set 
        //the SM_Bypass_SM_Deprovision__c to false and log the bypass activity ELSE put the 
        //record in a list and map because that is what can be deprovisioned.        
        if (trigger.isBefore) { 
            for (Integer i = 0; i <= TriggerNewIn.size() -1; i++) {  
                //User is inactive and changed to Active and SM_Bypass_SM_Deprovision__c is TRUE
                if (TriggerNewIn[i].isActive == true && TriggerOldMapIn.get(TriggerNewIn[i].id).isActive == false && 
                          TriggerNewIn[i].SM_Bypass_SM_Deprovision__c == true && TriggerOldMapIn.get(TriggerNewIn[i].id).SM_Bypass_SM_Deprovision__c != false) {
                    TriggerNewIn[i].SM_Bypass_SM_Deprovision__c = false;
                }
                
                if (TriggerNewIn[i].isActive == false && TriggerOldMapIn.get(TriggerNewIn[i].id).isActive == true && TriggerNewIn[i].SM_Bypass_SM_Deprovision__c == true) { 
                    UsersBypassed.add(TriggerNewIn[i]);               
                } else {                
                    TriggerNew.add(TriggerNewIn[i]);               
                }
            }
            
            //Users were detected above as being Bypassed then write to the log
            if (UsersBypassed.size() > 0) {
                List<String> RecipientList = SM_Wrappers.EmailThatSMmoduleExecutedList;
                List<String> ProfileAuditProfileList = SM_Wrappers.ProfileAuditProfileList;
                SM_Support.ModuleName ModuleName = SM_Support.ModuleName.Deprovision_User;
                Decimal EmailLogDelay = SM_Wrappers.EmailLogDelay;
                Set<Id> JobIdSet = new Set<Id>();
                List<SM_Support.LogWrapper> LogWrapperList = new List<SM_Support.LogWrapper>();
                String EmailGrouping = String.valueOf(System.currentTimeMillis());
                String LogGrouping = String.valueOf(System.currentTimeMillis());
                for (User u : UsersBypassed) {
                    //Build Callout Log Record
                    SM_Support.LogWrapper LogWrapper = new SM_Support.LogWrapper(); 
                    LogWrapper.EmailGrouping = EmailGrouping;
                    LogWrapper.LogGrouping = LogGrouping + '_DU_1'; 
                    LogWrapper.SandboxName = 'Production';          
                    LogWrapper.Severity = 'None';
                    LogWrapper.MsgSource = 'SM_DUcallout(Bypassed)';
                    LogWrapper.Msg = 'Deprovision User Action was Bypassed in Sandboxes Only.  This action does not have a companion response.';
                    LogWrapper.Username = u.Username;               
                    LogWrapper.ProfileName = 'n/a';
                    LogWrapper.LastModifiedDate = u.LastModifiedDate;
                    LogWrapper.LastLoginDate = u.LastLoginDate;
                    LogWrapper.PermissionSets = 'n/a';
                    LogWrapperList.add(LogWrapper); 
                }
                SM_Logging log = new SM_Logging(LogWrapperList, SM_Wrappers.DayToStartDeletion, true); 
                Id LogjobId = System.enqueueJob(log);
                JobIdSet.add(LogJobId);
                SM_Email Email = new SM_Email(RecipientList, ProfileAuditProfileList, EmailGrouping, JobIdSet, ModuleName, false, EmailLogDelay);
                Id EmailjobId = System.enqueueJob(Email);
            }  
            return;
        }        
   

        //Update User Logic to be build a set of user id(s) only if the user's isActive field was changed
        //from true to false (deactivated).  
        if (trigger.isAfter) {              
            for (Integer i = 0; i <= TriggerNewIn.size() -1; i++) {     
                System.debug('i: ' + i);
                if (TriggerNewIn[i].isActive == false && TriggerOldMapIn.get(TriggerNewIn[i].id).isActive == true && TriggerNewIn[i].SM_Bypass_SM_Deprovision__c == false) { 
                    //Only add to the list if the user was previously active and then 
                    //deactivated so that we send only what we need to the callout.                    
                    DeprovisionUserIds.add(TriggernewIn[i].Id);               
                }
            } 
            //We cannot run the callout directly from the trigger test class due 
            //to SF errors because SF does not allow direct callouts in tests, only 
            //mocked callouts are allowed so that is why the !Test.isRunningTest is being used. 
            if (DeprovisionUserIds.size() > 0 && !Test.isRunningTest() && SM_Wrappers.DeactivateUsersEnabled) {SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Deprovision_User, DeprovisionUserIds);}   
            System.debug('SM_User_Trigger_Logic.UsersUpdated - DeprovisionUserIds.size: ' + DeprovisionUserIds.size());
        }
    }
    
    /***********************************************
     * Method used to create new users in sandboxes
     ***********************************************/    
    public static void usersCreated(List<User> userList) {
        Set<Id> CreateUserIds = new Set<Id>();
        for (User u : userList) {
            CreateUserIds.add(u.Id);
        }
        if (CreateUserIds.size() > 0 && !Test.isRunningTest() && SM_Wrappers.ProvisionUsersEnabled) {SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Provision_User,CreateUserIds);}         
        System.debug('SM_User_Trigger_Logic.UsersCreated - CreateUserIds.size: ' + CreateUserIds.size());       
    }
}