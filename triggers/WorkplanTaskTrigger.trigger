trigger WorkplanTaskTrigger on Workplan_Task__c (before insert, after insert,
                                                 before delete, after delete,   
                                                 before update, after update,
                                                 after undelete) 
{
    if(!AIA_Utils.isTriggerBypassed('Workplan_Task__c')) {
    	new WorkplanTaskTriggerHandler().run();
    }
}