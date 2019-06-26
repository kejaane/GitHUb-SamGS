//===================================================================================
//Date: 02/02/2017
//Developer: Satya
//Purpose: GrouperTrigger
//=========================================================================================
// Update History
// Date         Developer               Description
//==================================================================================
//02/02/2017    Satya         Initial Development
//05/03/2017    Bill Dodson   Remove the comments to enable the trigger handler.
//==================================================================================
trigger GrouperTrigger on AIA_Grouper__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {    
    //Invokes the run method in the TriggerHandler class
    new AIA_GrouperHandler().run();
}