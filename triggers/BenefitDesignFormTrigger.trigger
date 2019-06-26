//=========================================================================================
//      Date: 03/07/2017
// Developer: Bill Dodson
//   Purpose: All AIA Benefit Design Form trigger events start here
//            It's purpose is to handle all trigger events in the handler.
//=========================================================================================
// Update History
// Date       Developer      Description
//=========================================================================================
// 03/30/17  |  Bill Dodson    | Initial Version  
//=========================================================================================
trigger BenefitDesignFormTrigger on AIA_Benefit_Design_Form__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    new AIA_BenefitDesignFormTriggerHandler().run();
}