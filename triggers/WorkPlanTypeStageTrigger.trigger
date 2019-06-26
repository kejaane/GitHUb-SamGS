//=========================================================================================
//      Date: 07/22/2016
// Developer: Sandeep S (LK)
//   Purpose: All Workplan_Type_Stage__c trigger events start here
//            It's purpose is to handle all Workplan_Type_Stage__c trigger events
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
// 07/22/16  |  Sandeep   | Initial Version  
// 10/17/2017|  Raviteja Vadapalli  |   T-01        | Commented lines as per US 209 and trigger can be inactivated
//=========================================================================================


trigger WorkPlanTypeStageTrigger on Workplan_Type_Stage__c (before delete) {
    //T-01 -start   
    //new AIA_WorkplanTypeStageTriggerHandler().run();
    //T-01 - end
}