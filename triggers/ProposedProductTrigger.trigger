//===================================================================================
//Date: 05/31/2016
//Developer: Sree Harsha Akkala
//Purpose: ProposedProductTrigger 
//=========================================================================================
// Update History
// Date         Developer                  Description
//==================================================================================
//05/31/2016    Sree Harsha Akkala  |   |  Initial Development
//5/15/2019    Rajesh Nagandla      |T01|  Added code to bypass triggers using Utils method
//==================================================================================
trigger ProposedProductTrigger on Proposed_Products__c(after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {    
    if(!AIA_Utils.isTriggerBypassed('Proposed_Products__c')) { //T01 
        //system.debug('----SMSL--->');
        //Invokes the run method in the TriggerHandler class
        new AIA_ProposedProductsHandler().run();
    }//T01
}