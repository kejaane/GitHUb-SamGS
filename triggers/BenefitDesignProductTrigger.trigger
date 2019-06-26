//=========================================================================================
//      Date: 03/07/2017
// Developer: Bill Dodson
//   Purpose: All AIA Benefit Design Product trigger events start here
//            It's purpose is to handle all trigger events in the handler.
//=========================================================================================
// Update History
// Date       Developer      Description
//=========================================================================================
// 03/07/17  |  Bill Dodson    | Initial Version  
//=========================================================================================
trigger BenefitDesignProductTrigger on AIA_Benefit_Design_Product__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
new AIA_BenefitDesignProductTriggerHandler().run();
}