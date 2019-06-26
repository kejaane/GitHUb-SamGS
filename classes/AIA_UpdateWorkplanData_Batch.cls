global class AIA_UpdateWorkplanData_Batch implements Database.Batchable<sObject>{
    
    global final String Query;

    global AIA_UpdateWorkplanData_Batch(String inputQuery){
        Query = inputQuery; 
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        list<workplan_task__c> lstTask = new list<workplan_task__c>();
        for(workplan_task__c tsk : (list<workplan_task__c>)scope){
    		lstTask.add(tsk);
        }        
		database.update(lstTask,false);
    }
    
    global void finish(Database.BatchableContext BC){
    }
}