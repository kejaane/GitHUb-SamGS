/*==========================================================================================
 * Date         : 04/18/2018
 * Developer    : Laveen Kattela
 * Purpose      : This Trigger is the entry point for Sub Process Trigger Framework which then calls extention Trigger handler
 *==========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date        Developer    Tag     Description
 *============+============+=====+==========================================================

 *============+============+=====+==========================================================
 */
trigger SubProcessTrigger on Sub_Process__c (after delete, after insert, 
                                             after undelete, after update, 
                                             before delete, before insert, before update) 
{
    if(!AIA_Utils.isTriggerBypassed('Sub_Process__c')) {    
    	new SubProcessTriggerHandler().run();
    }
}