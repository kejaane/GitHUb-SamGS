/*==========================================================================================
 * Date         : 04/18/2018
 * Developer    : Laveen Kattela
 * Purpose      : This class is the extension point of the Trigger Framework for 
 *                Sub Process trigger handlers.  
 *==========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date        Developer    Tag     Description
 *============+============+=====+==========================================================
 * 04/26/2018 | Gayathri   | T01 | Added a method call to update Actual SLA
 * 04/30/2018 | Laveen     | T02 | Added a method to update workplan Tasks and Update process 
 *                                 status as a part of US-1513 and 462
 * 06/05/2018 | Gayathri   | T03 | Added a method call to update workplan task status as per Defect 39387
 * 10/21/2018 | Gayathri   | T04 | Added a method call to update Implementation fields as part od US5425
 *============+============+=====+==========================================================
 */
public without sharing class SubProcessTriggerHandler extends TriggerHandler {
    
    public static Boolean beforeInsertRun = true;
    public static Boolean afterInsertRun = true;
    public static Boolean beforeUpdateRun = true;
    public static Boolean afterUpdateRun = true;
    
    
    //T01 -- Start
    AIA_SubProcessTriggerHelper subProcess_Helper = new AIA_SubProcessTriggerHelper();
    
    protected override void beforeInsert() {
    
        if(beforeInsertRun){
        subProcess_Helper.updateActualSLA(Trigger.New);//Method call to update Actual SLA
        beforeInsertRun = false;
        }
    }
    
    protected override void beforeUpdate() {
            //T02-start
        if(beforeUpdateRun){
        AIA_SubProcessController.fieldUpdateOnModification(Trigger.New);
        //T02 - End
        subProcess_Helper.updateActualSLA(Trigger.New);//Method call to update Actual SLA
        beforeUpdateRun = false;
        }
    }
    //T01 -- End
    
    protected override void afterInsert() {
      if(afterInsertRun){
          AIA_WorkPlanController.createWorkPlantask(Trigger.New,True);
          afterInsertRun = false;
      }
    }
    
    protected override void afterUpdate()
    {
       if(afterUpdateRun){
       afterUpdateRun = false;
       
       //T02 - start
       //Method to update task status
        AIA_SubProcessController.updateWorkPlanTaskStatus(Trigger.New, (Map<Id,Sub_Process__c>)Trigger.OldMap,True); 
       
       //T03--Start
       //Method to update task status when sub process changes from Not required to In progress
       AIA_SubProcessController.workplanTaskStatusUpdate(Trigger.New, (Map<Id,Sub_Process__c>)Trigger.OldMap);
       //T03--End
       
       //Method to update Process Status completion
       AIA_SubProcessController.updateProcessOnSubProcessCompletion(Trigger.New, (Map<Id,Sub_Process__c>)Trigger.OldMap,True);
       
       //T04 -- Start
       //Method to update Implementation fields 'BD Not Required' and 'GS Not Required'    
       subProcess_Helper.updateImpFields(Trigger.New, (Map<Id,Sub_Process__c>)Trigger.OldMap);
       //T04 -- End
       }

       //T02 - End
    }

}