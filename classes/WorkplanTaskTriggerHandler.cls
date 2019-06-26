/*==================================================================================================================
* Date         : 09/18/2017
* Developer    : Asif Kutagulla
* Purpose      : This class is trigger handler for the trigger WorkplanTaskTrigger
*==================================================================================================================
*                                 Update History
*                                 ---------------
* Date          Developer         Tag    Description
*=============+=================+======+===========================================================================
* 09/18/2017  | Asif Kutagulla  |      | Initial Version
* 04/26/2018  | Gayathri P      | T01  | Added method call to update Task due date, actual 
*                                        SLA, Account team role on owner change in Workplan
*                                        Task - US197, US182
* 04/30/2018  | Laveen          | T02  | Added method call to update Task and sub porcess 
*                                        status as a part of US- 1513 and 462
* 06/06/2018  | Satya           | T03  | Added methods as a part of US1728, to change status of dependent tasks
*                                        as per the status of primary tasks, if marked as not-required/not-started. 
* 06/12/2018  | Satya           | T04  | Commented since the field is getting updated with tasks count from 
*                                        another method 
* 06/13/2018  | Asif Kutagulla  | T05  | Modified after insert method to call computation of Sub Process metrics
* 10/29/2018  | Gayathri P      | T06  | Added method call to update Task Start date in order to repalce a workflow rule
* ============+=================+======+============================================================================
*/
public  class WorkplanTaskTriggerHandler extends TriggerHandler {
    
    AIA_WorkPlanTaskTriggerHelper wpTaskHandler_obj = new AIA_WorkPlanTaskTriggerHelper();
    public static Integer afterUpdateRecursive = 0;
    public static Integer beforeUpdateRecursive = 0;
    public static Integer afterInsertRecursive = 0; 
    Public static boolean UpdateCheck = false;
    public static Integer beforeUpdateCheckInt = 0;
    protected override void beforeInsert() {
        //T01 -- Start
        if(!System.isBatch()){
            /** Method call to update Actual SLA **/
            wpTaskHandler_obj.updateActualSLAonWorkplanTask(trigger.new); 
            /** Method to update Account team role**/
            /** Commenting this method call since 'Task owner' field is created for the same purpose**/
            // wpTaskHandler_obj.updateAreaRole(trigger.new);
            // T01 -- End
        }
    }
    
    protected override void beforeUpdate() {
        system.debug('Inside before update'+beforeUpdateRecursive);
        //if(beforeUpdateRecursive<2){
        if(!System.isBatch()){
                //T06 Start
            	/** Method call to update Task Start Date**/
            	wpTaskHandler_obj.updateTaskAssignedDate((Map<id,Workplan_Task__c>)Trigger.oldMap,trigger.new);
            	//T06 End
            	            
            	//T01 -- Start
                /** Method call to update Actual SLA **/
                wpTaskHandler_obj.updateActualSLAonWorkplanTask(trigger.new); 
                
                /** Method call to update Task due date**/
                wpTaskHandler_obj.updateDueDate((Map<id,Workplan_Task__c>)Trigger.oldMap,trigger.new);
                
                
            	/**Method call to update Account team role on owner change**/
                /**Commenting this method call since 'Task owner' field is created for the same purpose**/
                //wpTaskHandler_obj.updateAreaRoleonOwnerChange((Map<id,Workplan_Task__c>)Trigger.oldMap,trigger.new);
                //T01 -- End
            }  
           // beforeUpdateRecursive++;
      // }
      
    }
    
    protected override void afterInsert() {
        system.debug('query wp start insert'+system.Limits.getQueries());
        //T02,T04 - Start
        //AIA_WorkPlanController.updateTotalTaskCount(trigger.new);
        //T02,T04 - End
        system.debug('query wp end insert'+system.Limits.getQueries());
        
        /** T05 - Start. Pass empty map since trigger.old map doesn't exist for Insert event **/
        if(afterInsertRecursive < 1) {
            //AIA_WorkPlanController.updateSubProcessStatus(trigger.new, new map<Id,Workplan_Task__c>(), True);
        }
        afterInsertRecursive++;
        /** T05 - End    **/
    }   
    
    protected override void afterUpdate() {
        System.debug('**** after update called *****');
        System.debug('**** RecursiveCheckafterUpdateRecursive ****'+afterUpdateRecursive);
        
        //T03 changes start
        //wpTaskHandler_obj.UpdateWorkplanStatus((Map<id,Workplan_Task__c>)Trigger.newMap,(Map<id,Workplan_Task__c>)Trigger.oldMap);
        //wpTaskHandler_obj.UpdateWorkplanStatusToNotRequired((Map<id,Workplan_Task__c>)Trigger.newMap,(Map<id,Workplan_Task__c>)Trigger.oldMap);
        if(!system.isBatch()){
        Integer afterUpdateCheckInt = 0;
        if(!UpdateCheck){
            wpTaskHandler_obj.UpdateWorkplanStatuss((Map<id,Workplan_Task__c>)Trigger.newMap,(Map<id,Workplan_Task__c>)Trigger.oldMap);
            afterUpdateCheckInt++ ;
            if(afterUpdateCheckInt == 2){
                UpdateCheck = true;
            }
        }
        //T03  changes ends
        
        if(afterUpdateRecursive<=2){
            
            system.debug(Logginglevel.ERROR ,'query wp start aup'+system.Limits.getQueries());
            //T02,T05 - Start //
            AIA_WorkPlanController.updateSubProcessStatus(trigger.new,(map<Id,Workplan_Task__c>)Trigger.oldMap, False);
            //T02,T05 - End 
            AIA_WorkPlanTaskTriggerHelper.reevaluateTaskStatus(trigger.new);
            system.debug('Tasks after updating status@@@'+(List<Workplan_Task__c>)trigger.new);
        	afterUpdateRecursive++;
            
            
        } }                       
        system.debug('query wp start aup'+system.Limits.getQueries());
    }
}