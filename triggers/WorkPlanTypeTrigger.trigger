//=========================================================================================
//      Date: 07/22/2016
// Developer: Sandeep S (LK)
//   Purpose: All AIA_Workplan_Type__c trigger events start here
//            It's purpose is to handle all AIA_Workplan_Type__c trigger events
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
// 07/23/16  |  Sandeep                             | Initial Version  
// 10/17/2017|  Raviteja Vadapalli  |   T-01        | Commented lines as per US 209 and trigger can be inactivated
//=========================================================================================


trigger WorkPlanTypeTrigger on AIA_Workplan_Type__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    /* T-01 - start
    if(Trigger.IsBefore && Trigger.isDelete){    
        new AIA_WorkplanTypeTriggerHandler().run();
    }
    T-01 - end */ 
    
}