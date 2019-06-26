/*=========================================================================================
 * Date      : 06/03/2016
 * Developer : Tom Barrett
 * Purpose   : This class is the extension point of the Trigger Framework for adding Task trigger handlers.
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer         Description
 *===========+============+================================================================
 * 06/03/2016  |  TPB     | Initial Version                                         
 *             |          | 
 *=============+==========+================================================================
 */
public with sharing class TaskTriggerHandler extends TriggerHandler {
    public TaskTriggerHandler() {}
    
        /* context override */
    protected override void beforeUpdate() {
        processPCMH();
    }
    
    protected override void beforeInsert() {
        processPCMH();
        processTasks();
    }
    
    protected override void afterInsert() {
       // Tasks();
    }
    
    protected override void afterUpdate() {
     
    }

    /***************************    
     * ENTER HELPER METHODS HERE     
     ***************************/
     private void processPCMH() {
         pcmh_tasks.process(trigger.new);
     }
     
     private void processTasks() {
        MIT_Tasks.UpdateDueDate(trigger.new);
     }
     
}