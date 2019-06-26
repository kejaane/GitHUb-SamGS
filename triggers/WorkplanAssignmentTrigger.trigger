//=========================================================================================
//      Date: 05/10/2016
// Developer: Laveen Kattela (LK)
//   Purpose: All AIA_Workplan_Assignment__c trigger events start here
//            It's purpose is to handle all AIA_Workplan_Assignment__c trigger events
//=========================================================================================
//  Update History
// Date       Developer                 Description
//=========================================================================================
// 05/10/16  |  LK                  | Initial Version  
// 24/10/17  | Raviteja vadapalli   | commented as per Asif
//=========================================================================================


trigger WorkplanAssignmentTrigger on AIA_Workplan_Assignment__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    //commented as per us 210
    //new AIA_WorkplanAssignmentTriggerHandler().run();
}