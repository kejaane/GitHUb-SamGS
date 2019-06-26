//=========================================================================================
//      Date: 06/05/2016
// Developer: Laveen Kattela (LK)
//   Purpose: All Workplan_Stage__c trigger events start here
//            It's purpose is to handle all Workplan_Stage__c trigger events
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
// 04/27/16  |  LK    | Initial Version  
// 10/17/2017|  Raviteja Vadapalli  |   T-01      | Commented lines as per US 209
//=========================================================================================


trigger WorkplanStageTrigger on Workplan_Stage__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
//new AIA_WorkplanStageTriggerHandler().run();
}