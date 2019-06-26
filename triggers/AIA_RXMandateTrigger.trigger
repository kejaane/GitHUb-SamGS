//=========================================================================================
//Date: 05/03/2017
//Developer: Bill Dodson
//Purpose: AIA_RXMandateTrigger, called when ever a change to an RX Mandate record is made.
//=========================================================================================
// Update History
// Date         Developer               Description
//==================================================================================
//05/03/2017    Bill Dodson         Initial Development
//==================================================================================
trigger AIA_RXMandateTrigger on AIA_RxMandate__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {    
    //Invokes the run method in the TriggerHandler class
    new AIA_RxMandateHandler().run();
}