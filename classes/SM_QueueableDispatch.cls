//=========================================================================================
//      Date: 08/14/2018     
// Developer: Tom Barrett
//   Purpose: This class acts as a dispatch for all functionality that uses the Queuable
//            capabilities of Apex.  It provides the ability to chunk the named credentials
//            (sandboxes) and pass them to the callout routines.  This chunking approach 
//            provides the ability to avoid timeout limits.  This is achieved by utilizing
//            Queuable apex.
//            
// LIMITATIONS: Because Queuable apex run's in a seperate thread and the design approach
//              for emailing results, there is no way to execute the email routine after
//              processing from the seperate thread is complete.  However, by design,
//              the email will provide specific information to the recipient if processing
//              was not completed at the time the email logic was called.  This detection
//              is communicated clearly in the email so the recipient can log in and confirm
//              successful completion by looking directly at the SM_Log records.
// 
// EXAMPLES TO CALL THIS CLASS DIRECTLY FROM THE ANONYMOUS WINDOW.
// 
// Deactivate User: Set<Id> DeactivateUserIds = new Set<Id>{'0050m0000010YWb'};
//                  SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Deactivate_User, DeactivateUserIds);
// 
//     Create User: Set<Id> ActivateUserIds = new Set<Id>{'0050m0000010YWb'};
//                  SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Provision_User, ActivateUserIds);
//                  
//   Profile Audit: SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Profile_Audit);// 
// 
//=========================================================================================
//                                 Update History
// Date       Developer     	Tag     Description
//=========================================================================================
//
//=========================================================================================
public class SM_QueueableDispatch {     
    private static Boolean GetEmailGroupingOnce = false; 
    private static Boolean GetProdInfoOnce = false;
    private static String EmailGrouping;
    private static SM_Support.ModuleName ModuleName;
    private static Set<Id> UserIdSet = new Set<Id>();   
            
    public static void dispatch(SM_Support.ModuleName MN, Set<Id> UIds) { 
        System.debug('---SM_QueueableDispatch.Dispatch (MN, UIds)---'); 
    	ModuleName = MN;
        UserIdSet = UIds;
        doWork();        
    }    
    
    public static void dispatch(SM_Support.ModuleName MN) { 
        System.debug('---SM_QueueableDispatch.Dispatch (MN)---');
    	ModuleName = MN;
        doWork();
    }
    
    private static void doWork() {        
        System.debug('---SM_QueueableDispatch.DoWork---');
    	Boolean PossibleMultipleTriggers = false;
        Integer ChunkLoopCount = 1;  
        Integer TotalLoopCount = 1;
        Integer NCchunkSize = 0;
        String SandboxName = '';  
        
        SM_Support sms = new SM_Support(); 
        
        //Most of the use cases are to initialize from the SM_User_Trigger class
        //where SM_Wrapper is instantiated and propogated down to this class.
        //However, we initialize the SM_Wrappers class here just in case the 
        //SM_QueuableDispatch class called directly and not via the SM_User_Trigger_Logic class.  
        SM_Wrappers wrp = new SM_Wrappers();
        
        //Bypass module checks
        //The first three checks are also in the SM_User_Trigger class and if called properly 
        //(only from the trigger) the trigger will never reach this class but it can't hurt 
        //to have an extra belt and suspender should this class be called directly.
        if (!SM_Wrappers.SandboxManagerEnabled) return;           

        if (ModuleName == SM_Support.ModuleName.Deprovision_User) if (!SM_Wrappers.DeactivateUsersEnabled) return;        
        if (ModuleName == SM_Support.ModuleName.Provision_User) if (!SM_Wrappers.ProvisionUsersEnabled) return;        
        if (ModuleName == SM_Support.ModuleName.Profile_Audit) if (!SM_Wrappers.ProfileAuditEnabled) return;      
        
        Integer NCchunkSetting = SM_Wrappers.NCchunkSetting;
        Decimal EmailLogDelay = SM_Wrappers.EmailLogDelay;
        Map<String, String> NamedCredentialToSandboxNameMap = sms.NamedCredentialToSandboxNameMap;
        List<NamedCredential> NCcompleteList = sms.NamedCredentialList;
        List<NamedCredential> NCsubList = new List<NamedCredential>();
        List<String> RecipientList = SM_Wrappers.EmailThatSMmoduleExecutedList;
        List<String> ProfileAuditProfileList = SM_Wrappers.ProfileAuditProfileList;
        List<String> ProvisionSandboxLimitList = SM_Wrappers.ProvisionSandboxLimitList; 
        List<String> DeprovisionSandboxLimitList = SM_Wrappers.DeprovisionSandboxLimitList; 
        List<String> ProfileAuditSandboxLimitList = SM_Wrappers.ProfileAuditSandboxLimitList; 
		List<NamedCredential> NCchunkList = new List<NamedCredential>();        
        Set<Id> JobIdSet = new Set<Id>();     
        
        //We only want to get a unique millisecond value once per context execution.
        //So even if there are multiple triggers (more than 200 records) we only 
        //get the value once by using the Once boolean value.
        if (!GetEmailGroupingOnce) {
            //Get milliseconds
            EmailGrouping = String.valueOf(System.currentTimeMillis());
            GetEmailGroupingOnce = true;
        }  
     
        //Have to loop through Named Credentials to get a reduced list based on 
        //the Custom Metadata Types data from record 'NC_Chunk_Setting'.
        for (NamedCredential nc : NCcompleteList) {
            SandboxName = NamedCredentialToSandboxNameMap.get(nc.DeveloperName); 
            if (ModuleName == SM_Support.ModuleName.Deprovision_User) { 
                if (!Test.isRunningTest() && !DeprovisionSandboxLimitList.isEmpty() && !DeprovisionSandboxLimitList.contains(SandboxName.toLowerCase())) Continue;            
            } else if (ModuleName == SM_Support.ModuleName.Provision_User) {
                //Skip logic 
                if (!Test.isRunningTest() && !ProvisionSandboxLimitList.isEmpty() && !ProvisionSandboxLimitList.contains(SandboxName.toLowerCase())) Continue;     
            } else if (ModuleName == SM_Support.ModuleName.Profile_Audit) {
                //Skip logic 
                if (!Test.isRunningTest() && !ProfileAuditSandboxLimitList.isEmpty() && !ProfileAuditSandboxLimitList.contains(SandboxName.toLowerCase())) Continue;                 
            }
            NCsubList.add(nc);
        }             

        //Calculate the NCchunkSize
        if (NCchunkSetting == 1) NCchunkSize = 1;
        if (NCchunkSetting >= NCsubList.size()) NCchunkSize = NCsubList.size();
        if (NCchunkSetting < NCsubList.size()) NCchunkSize = NCchunkSetting;		
        
        //Ok, now that we got the calculated NCchunkSize lets loop through the 
        //NCsubList and chuck/group together the Named Credentials/sandboxes
        //and call the expected Callout Module.
        for (NamedCredential nc : NCsubList) {  
       		NCchunkList.add(nc); 
            //First condition drops us inside the IF statement when the Chunk Setting and loop count
            //match basically collecting 4 sandboxes/NC loop comes around one more time and the right 
            //side of the IF statement is TRUE which picks up the last sandbox (5th one) and sends
            //it to the callout class.
            If (ChunkLoopCount == NCchunkSize || TotalLoopCount == NCsubList.size()) {    
            	if (ModuleName == SM_Support.ModuleName.Deprovision_User) {					                  
                    SM_DUcallout DUcallout = new SM_DUcallout(NCchunkList, UserIdSet, EmailGrouping);  
                    Id jobId = System.enqueueJob(DUcallout);                     
                    JobIdSet.add(JobId);
                } else if (ModuleName == SM_Support.ModuleName.Provision_User) {
                	SM_PUcallout PUcallout = new SM_PUcallout(NCchunkList, UserIdSet, EmailGrouping);
                    Id JobId = System.enqueueJob(PUcallout);
                    JobIdSet.add(JobId);
                } else if (ModuleName == SM_Support.ModuleName.Profile_Audit) {
                	SM_PAcallout PAcallout = new SM_PAcallout(NCchunkList, EmailGrouping, GetProdInfoOnce);
                    Id JobId = System.enqueueJob(PAcallout);
                    JobIdSet.add(JobId);
                    GetProdInfoOnce = true;
                }
				//Reset count so and clear the list so we can 
				//chunk up the next group of Named Credentials (NC).
                ChunkLoopCount = 0; 
                NCchunkList.clear();
            } 
            ChunkLoopCount++;
            TotalLoopCount++;
        }     
        
        //Finally read the logs and send out the email with the module activity by calling the SM_Email class.
        if (UserIdSet.size() == 200) PossibleMultipleTriggers = true;
        SM_Email Email = new SM_Email(RecipientList, ProfileAuditProfileList, EmailGrouping, JobIdSet, ModuleName, PossibleMultipleTriggers, EmailLogDelay);
        Id jobId = System.enqueueJob(Email); 
    }
}