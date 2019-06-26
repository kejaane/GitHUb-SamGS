//=========================================================================================
//      Date: 04/12/2018
// Developer: Tom Barrett
//   Purpose: This trigger is part of the Sandbox Manager (SM) App.  It could be made to 
//            tightly couple into the standard framework we use at CareFirst; however, that 
//            could become problematic when upgrading SM as it would have to uninstalled and 
//            reinstalled.  When doing so that could produce unforescene issues with related
//            trigger code as it would not not be part of the SM package.
//                 
//      NOTE: Before building a package don't forget to comment out and uncomment out the 
//            line mentioned below.  Forgetting to do so can produce unexpected results.  
//      ****  Currently, the only other class this is necessary is the SM_PAcallout class.                 
//=========================================================================================
//                                 Update History
// Date       Developer         Tag     Description
//=========================================================================================
//                               
//=========================================================================================
trigger SM_User_Trigger on User (after insert, after update, before update) {     
    System.debug('---SM_User_Trigger ---');
    System.debug('SM_User_Trigger.size(): ' + Trigger.size);    

    SM_Wrappers wrp = new SM_Wrappers();  

    //Uncomment prior to making a package and running in production
    //If you are testing in a sandbox the sandbox that is used to simulate 
    //production must have this line commented out while the destination
    //sandbox(s) must have this line uncommented
    if (SM_Support.isSandbox() && !Test.isRunningTest()) return;   
    
    //Master Switch to disable all Sandbox Manager 
    //functionality that are called by this trigger.
    if (!SM_Wrappers.SandboxManagerEnabled) return;     
  
    //Update User Logic to be processed in prod and callout to sandboxes  
    if (trigger.isUpdate) { 
        if (!SM_Wrappers.DeactivateUsersEnabled) return;        
        SM_User_Trigger_Logic.UsersUpdated(trigger.new, trigger.old, trigger.oldMap);
    }
        
    //Insert New User Logic to be processed in prod an callout to sandboxes
    if (trigger.isInsert) {
        if (!SM_Wrappers.ProvisionUsersEnabled) return; 
        SM_User_Trigger_Logic.UsersCreated(Trigger.new);
    } 
}