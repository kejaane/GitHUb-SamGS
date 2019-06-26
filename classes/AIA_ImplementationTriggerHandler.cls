/*==================================================================================================
 * Date         : 05/31/2016
 * Developer    : chidananda Nagaaj
 * Purpose      : This class is the extension point of the Trigger Framework for 
 *                adding Implementation trigger handlers.
 *===================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       | Developer  | Tag  |   Description
 *============+============+=========================================================================
 * 05/31/16   | GN         |      | Initial Version                                         
 * 11/26/2016 | Asif K     | T01  | Added method call to update BD Revision Number & Date  
 * 03/16/2017 | Sree Harsha| T02  | Added method call to update Account Roles on Implementation 
 * 9/12/2017  | Satya      | T03  | Added methods for workplan tasks assignment
 * 4/16/2018  | Gayathri   | T04  | Commenting the lines of code related to WP type as part of US209
 * 4/30/2018  | Laveen     | T05  | Added new method to create Post Sales Process as a part of US1513
 * 05/03/2018 | Gayathri   | T06  | Added  method call to update Owner of the Implementation
 * 05/31/2018 | Gayathri   | T07  | Added method to send notification to Account team as per US1728
 * 06/12/2018 | Gayathri   | T08  | Added method call to send notification to Implementation owner US465
 * 06/29/2018 | Gayathri   | T09  | Added method call to update Active tasks to Not Required when the Implementation is completed
 * 04/16/2019 | Satya      | T10  | Extended recursion check to all methods inside  the afterUpdate event
 *============+============+=========================================================================
 */
 
public with sharing class AIA_ImplementationTriggerHandler extends TriggerHandler {

    private static Boolean beforeInsert=false;
    private static Boolean beforeUpdate=false;
    private static Boolean afterUpdate = false;
    public static string Inserts = 'Insert';
    public static string ImpRec = 'AIA_Implementation__c';
        
    protected override void afterInsert() {
        /*T04 Start
        //Chida - Added for creating the workplan stages on opp
        AIA_Workplan_Implementation wp = new AIA_Workplan_Implementation();
        wp.createWorkplanStages((List<AIA_Implementation__c>) Trigger.new,(List<AIA_Implementation__c>) Trigger.old);
        System.debug('Value of static--->'+AIA_Workplan_Implementation.i);
        //End 
        T04 End*/
        //T03---START
        //T08--Start
        AIA_ImplementationTriggerHelper.sendNotification(trigger.new);/** Method call to send notification to the Implementation owner**/
        //T08--End
        
        if(!test.isrunningtest()){
        AIA_Workplan_Task_Management wtm = new AIA_Workplan_Task_Management();
        wtm.createWorkplanTasksForSObject(Inserts, trigger.newMap, ImpRec);
        //t03---End 
        }
        
    }
 
    protected override void afterUpdate() {
    System.debug('imp afterUpdate start'+System.Limits.getQueries());
    
     /*  AIA_ImplementationTriggerHelper impHelper = new AIA_ImplementationTriggerHelper();
       impHelper.completeWPTasksstatus(trigger.new,(Map<Id,AIA_Implementation__c>) Trigger.OldMap); */
        /* T05 --- start
        * This method is used to create process records for post sales functionality when Implementation made to In-progress
        */ 
        System.debug('afterUpdate@@@@');
        if(!system.isBatch()){
        if(!afterUpdate)
        {
            afterUpdate = true;
            //T07 - Added as part of US1728 to send Notification to Account Team
            AIA_SendEmail_Notification notify = new AIA_SendEmail_Notification();
            notify.notifyAccTeamMember(trigger.new,(Map<Id,AIA_Implementation__c>) Trigger.OldMap);
            
        //}T10
        
        //T07 ---- Changes Ends
        AIA_OpportunityImplementationController.createPostSalesProcess(Trigger.New, (Map<Id,AIA_Implementation__c>) Trigger.OldMap);
        
        //T05 End
        
        
        
        
        /*T04 -- Start
        //Chida - Added for creating the workplan stages on opp
        if(AIA_Workplan_Implementation.i==1){
 -           AIA_Workplan_Implementation wp = new AIA_Workplan_Implementation();
            wp.createWorkplanStages((List<AIA_Implementation__c>) Trigger.new,(List<AIA_Implementation__c>) Trigger.old);
            System.debug('Value of static--->'+AIA_Workplan_Implementation.i);
        }
        //End 
        T04-- End */
              
        //T04 ---start
        
        AIA_Workplan_Task_Management wtm = new AIA_Workplan_Task_Management();
        wtm.createWorkplanTasksForSObject('update', trigger.newMap, 'AIA_Implementation__c');
        AIA_WorkPlanTasks_Completion WTC = new AIA_WorkPlanTasks_Completion();
        WTC.completionWorkplanTasksForSObject('Update', trigger.new, 'AIA_Implementation__c');
        
       //T04 --- end
        
        //End 
       /*T09 -- Method call to Update related active Workplan tasks when Implementation is completed*/
            AIA_ImplementationTriggerHelper.updatetaskNotRequired(trigger.new,(Map<Id,AIA_Implementation__c>) Trigger.OldMap);
        }//T10
        }      
    System.debug('imp afterUpdate end'+System.Limits.getQueries());
    }
 
    protected override void beforeInsert() {
     //if(!test.isrunningtest() ){
     if(!beforeInsert ){
        system.debug('limit IMP beforeInsert'+System.Limits.getQueries());
        AIA_Workplan_Implementation.updateImplFields((List<AIA_Implementation__c>) Trigger.new);
        AIA_ImplementationTriggerHelper.updateBD_RevNum_RevDate((List<AIA_Implementation__c>) Trigger.new);//T01
        AIA_ImplementationTriggerHelper.updateAccountRoles((List<AIA_Implementation__c>) Trigger.new); //T02  
        //T06 -- Start--Method call to update the owner of the record
        AIA_ImplementationTriggerHelper.updateOwner((List<AIA_Implementation__c>)trigger.new);
        //T06--End
        system.debug('limit IMP'+System.Limits.getQueries());
         beforeInsert=true;
     }
    }
 
    protected override void beforeUpdate() {
     //if(!test.isrunningtest() ){
     system.debug('Before update imp start---'+System.Limits.getQueries());
     if(!beforeUpdate ){
        AIA_Workplan_Implementation.updateImplFields((List<AIA_Implementation__c>) Trigger.new);
        AIA_ImplementationTriggerHelper.updateAccountRoles((List<AIA_Implementation__c>) Trigger.new); //T02  
        //1728
        system.debug('Before update imp start notify ATM---'+System.Limits.getQueries());
        AIA_SendEmail_Notification notify = new AIA_SendEmail_Notification();
        notify.notifyCompletedTasksATM(trigger.new,(Map<Id,AIA_Implementation__c>) Trigger.OldMap);
        //1728
        beforeUpdate=true; 
     }
        system.debug('Before update imp End---'+System.Limits.getQueries());
     
    }
    
}