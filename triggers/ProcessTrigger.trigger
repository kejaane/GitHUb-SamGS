/*
=========================================================================================
 * Date         : 04/18/2018
 * Developer    : Laveen Kattela
 * Purpose      : This Trigger is the entry point for Process Trigger Framework which then 
 *                calls extention Trigger handler 
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 *  
 *===========+============+================================================================
 */
trigger ProcessTrigger on Process__c (after delete, after insert, 
                                      after undelete, after update, 
                                      before delete, before insert, before update) 
{
    if(!AIA_Utils.isTriggerBypassed('Process__c')) {    
    	new ProcessTriggerHandler().run();
    }
}