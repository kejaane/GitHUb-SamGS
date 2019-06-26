/*=========================================================================================================
* Date         : 09/15/2017 
* Developer    : Satya Phani Tirumalasetti
* Purpose      : This class is a helper class for WorkplanTaskTriggerHandler with methods for various 
*                functionalities
*===========================================================================================================
*                                 Update History
*                                 ---------------
* Date      | Developer  | Tag  | Description
*===========+============+======+===========================================================================
* 09/15/2017| Satya T    |      | Initial Version                                         
* 09/18/2017| Asif K     | T01  | Adding method to calculate difference between workplan task actual SLA
* 04/26/2018| Gayathri P | T02  | Adding methods to calculate Account team role of the owner and 
                                  Task due date in workplan task and updated Actual SLA day calculation 
                                  with respect to SLA day type 
* 06/06/2018| Gayathri P | T03  | updated the method to populate Task due date based on Total days to 
                                  complete the task
* 06/06/2018| Satya      | T04  | Added methods as a part of US1728, to change status of dependent tasks
*                                 as per the status of primary tasks, if marked as not-required/not-started. 
* 08/26/2018| Rajesh 	 | T05	| Added new fields to implementation query 
			  Nagandla      
* 10/29/2018| Gayathri P | T06  | Added a method to replace a workflow rule to update Task Start date and 
								  Task Assigned date
* 10/31/2018| Gayathri P | T07  | Added a size check for a map to avoid method call when the map is empty.
*===========+============+======+===========================================================================
*/

public with sharing class AIA_WorkPlanTaskTriggerHelper{
    AIA_Utils errLogExp = new AIA_Utils();
      public static final string NOTREQUIRED = 'Not Required';
      public static final string NOTSTARTED = 'Not Started';
       
    /** T01-Start - Method to update the Actual SLA of the workplan task. Method will be called in beforeupdate event **/
    public void updateActualSLAonWorkplanTask(list<Workplan_Task__c> lstWPtask){
        try{
        List<Workplan_Task__c> recordsToUpdate = new  List<Workplan_Task__c>();
        for(Workplan_Task__c wpTask : lstWPtask){
            if(wpTask.Status__c == AIA_Constants.COMPLETED_STATUS){
                wpTask.End_Date__c = system.today();
                //T02 -- Start Adding condition to check SLA day type
                if(wpTask.Start_Date__c != null && wpTask.End_Date__c != null) {
                    if(wpTask.SLA_Day_Type__c == AIA_Constants.CALENDER_TYPE)
                        wpTask.Actual_SLA__c = wpTask.Start_Date__c.daysBetween(wpTask.End_Date__c) ;
                    else
                        wpTask.Actual_SLA__c = AIA_CalculateDaysDiffExcludingHoliday.CalculateWorkingDays(wpTask.Start_Date__c, wpTask.End_Date__c);
                    recordsToUpdate.add(wpTask);
                }		               
            }
        }
        }
        catch(Exception e)
        {
          System.debug('MainERROR:' + e);
          errLogExp.logException(e);
             
        }
         //T02 -- End
    }
    /** T01-End **/
    
    public static void reevaluateTaskStatus(list<Workplan_Task__c> lstWPtask){
       set<id> idset = new set<id>();
       system.debug('Entered Method 3 reevaluateTaskStatus');
        for(Workplan_Task__c wpTask : lstWPtask){
            if(wpTask.Status__c == AIA_Constants.COMPLETED_STATUS){
                if(!string.isBlank(wpTask.Implementation__c)){
                    idset.add(wpTask.Implementation__c);
                }
            }
        }
        /*T05 - Start*/
		Map<id,AIA_Implementation__c> lstImp = new Map<id,AIA_Implementation__c>([Select id,Opportunity__r.AccountID,BRF_Request_Type__c,Account__c,BRF_Funding_Arrangement__c,Claims_Settlem_Proc_Setup_Updated_Date__c,
          Fully_Insured_Acct_1st_Bill_Release_Date__c,Status__c, Opportunity__r.StageName,
          GS_Status__c,BenefitDesign_Status__c,AIADoc_approval_status__c ,Settlements_status_of_AIADoc__c,
          oppMarketSeg__c ,WPTask_update_number__c,Business_Type__c,Risk_Type__c,
          opportunity__r.Business_Type__c,BD_approved__c,GSRF_approved__c,BRF_Blue_Rewards__c,
          Acc_Microsoft_URL_populated__c,BRF_CDH__c,BRF_CDH_Type__c,BRF_Custom_Wellness__c,
          BRF_FSA_BlueFund__c,BRF_Integrated_DM_Wellness__c,BRF_New_Dental_Products__c,Benefit_Design_Document_Uploaded__c,
          BRF_New_Products__c,BRF_New_Rx_Products__c,BRF_New_Vision_Products__c,Date_Implementation_Ended__c,
          BRF_Religious_Accomodation__c,BRF_Rx_Integration__c,BRF_Status__c,AIA_BD_Not_Required__c,AIA_GS_Doc_Not_Required__c,
		  vision_with_platform_indicator__c, BRF_Control_plan_680__c, BRF_FA__c,Opp_Business_Type__c, 
		  BRF_Control_plan__c, Backend_BRF_Effective_Date__c		  
          from AIA_Implementation__c where id in :idset]);
		  /*T05 - End*/
          //T07 Start
          if(lstImp.size()>0)
          //T07 End
          {
          AIA_Workplan_Task_Management wtm = new AIA_Workplan_Task_Management();
          if(!Test.isRunningTest()){
          wtm.createWorkplanTasksForSObject('update',lstImp, 'AIA_Implementation__c');
          }
        }
    }
    //T03 -- Start
    /**T02 -Start- Method to update Task due date -when the status is changed to In progress
                                                  -when the status changed to completed before changing to In progress
                                                  -when the user updates Total days to complete the task manually*/
    public void updateDueDate(Map<id,Workplan_Task__c> oldMap,list<Workplan_Task__c> lstWPtask){
        AIA_CalculateDaysDiffExcludingHoliday achd = new AIA_CalculateDaysDiffExcludingHoliday();
        List<Workplan_Task__c> recordsToUpdate = new List<Workplan_Task__c>();
        for(Workplan_Task__c wpTask:lstWPtask)
        {
            if(oldMap.get(wpTask.Id).Status__c != AIA_Constants.INPROGRESS_STATUS && (wpTask.Status__c == AIA_Constants.INPROGRESS_STATUS || wpTask.Status__c == 'Completed')) 
            {
              wpTask.Start_Date__c = Date.today();
            }
            if(wpTask.Total_Days_to_Complete_Task_SLA__c != null && (oldMap.get(wpTask.Id).Status__c != AIA_Constants.INPROGRESS_STATUS && (wpTask.Status__c == AIA_Constants.INPROGRESS_STATUS || wpTask.Status__c == 'Completed'))
             ||(oldMap.get(wpTask.Id).Total_Days_to_Complete_Task_SLA__c != wpTask.Total_Days_to_Complete_Task_SLA__c && wpTask.Start_Date__c != null)){
              Integer expectedSLA = Integer.valueOf(wpTask.Total_Days_to_Complete_Task_SLA__c);
              if(wpTask.SLA_Day_Type__c == AIA_Constants.CALENDER_TYPE)
              {
                   wpTask.ExpectedDate__c = wpTask.Start_Date__c.addDays(expectedSLA);
                   //Days left to complete the task
                   wpTask.AIA_SLA_Days__c = Date.today().daysBetween(wpTask.ExpectedDate__c);
               }
               else
               {
                   wpTask.ExpectedDate__c = achd.addBussinessDays(wpTask.Start_Date__c, expectedSLA);
                    //Days left to complete the task
                   wpTask.AIA_SLA_Days__c = AIA_CalculateDaysDiffExcludingHoliday.CalculateWorkingDays(Date.Today(),wpTask.ExpectedDate__c);
               }  
             }
         }
    }
    
    /** T06 Method to Update Task Start Date and Task Assignment Date**/
    public void updateTaskAssignedDate(Map<id,Workplan_Task__c> oldMap,list<Workplan_Task__c> lstWPtask)
    {
        for(Workplan_Task__c task: lstWPtask)
        {
            if(task.Status__c == AIA_Constants.INPROGRESS_STATUS && oldMap.get(task.id).Status__c != AIA_Constants.INPROGRESS_STATUS)
            {
               task.Start_Date__c = system.today(); 
            }
            
            if((task.Status__c == AIA_Constants.INPROGRESS_STATUS && oldMap.get(task.id).Status__c != AIA_Constants.INPROGRESS_STATUS) || (task.Status__c == AIA_Constants.INPROGRESS_STATUS && task.OwnerId != oldMap.get(task.id).ownerId))
            {
                task.AIA_Task_Assigned_Date__c = system.today();
            }
        }
    }
    /** T06 End**/ 
    
    //T03 -- End
    //T02 -- Method to check owner of the task on update
    /*public void updateAreaRoleonOwnerChange(Map<id,Workplan_Task__c> oldMap,list<Workplan_Task__c> lstWPtask)
    {
        List<Workplan_Task__c> recordsToUpdate = new List<Workplan_Task__C>();
        for(Workplan_Task__c wpTask:lstWPtask)
        {
            if(oldMap.get(wpTask.Id).OwnerId != wpTask.OwnerId)
            {
               recordsToUpdate.add(wpTask); 
            }
        }
        //When the owner is updated for any task, Account team role should get updated
        if(recordsToUpdate.size()>0)
        {
           updateAreaRole(recordsToUpdate); 
        }
   
    }
    
    //T02 -- Method to update Account area role with respect to the owner of the task
    public void updateAreaRole(List<Workplan_Task__c> lstWPtask)
    {
        try{
        Set<Id> ownerId = new Set<Id>();
        Map<Id,String> areaMapping = new Map<Id,String>();
        for(Workplan_Task__c wpt:lstWPtask)
        {
           ownerId.add(wpt.OwnerId);
        }
        List<AIA_Area_Manager__c> areaLst=[select id,name,Area_Manager__c,Area_Belong_to__c,Areas__c,recordTypeId 
                                           from AIA_Area_Manager__c 
                                           where Area_Manager__c IN:ownerId];
        for(AIA_Area_Manager__c area:areaLst)
        {
          areaMapping.put(area.Area_Manager__c,area.Area_Belong_to__c) ;  
        }
        for(Workplan_Task__c wpt:lstWPtask)
        {
           //wpt.AIA_Account_Team_Role__c = areaMapping.get(wpt.OwnerId);
           if(areaMapping.get(wpt.OwnerId)!=null)
                wpt.Account_Team_Role__c = areaMapping.get(wpt.OwnerId);
        }
        }
        catch(Exception e)
        {
          System.debug('MainERROR:' + e);
          errLogExp.logException(e);
        }
        
    }*/
    /** T02 -- End*/
    
    /**T04 - Changes start**/
    /*This method will be called from Workplan task trigger handler when task status changes to Not-started from Not-required
       If task staus changes, then will update a field in WPlan Task record to indicate the change*/
    public void UpdateWorkplanStatuss(map<id,Workplan_Task__c> newMapWPtask,Map<id,Workplan_Task__c> oldMap){
       system.debug(Logginglevel.ERROR ,'Entered Method 1');
       list<Workplan_Task__c> tasksToUpdate = new list<Workplan_Task__c>();
       
       //Get the list of tasks in the trigger context
       List<Workplan_Task__c> wpList = newMapWPtask.values();
        
        
       //Loop through all the tasks and get the tasks that are changed to Not-started status from not-required status.  
       for(Workplan_Task__c wp: wpList){
       if(wp.Status__c == NOTSTARTED && wp.Status__c != oldMap.get(wp.id).Status__c && oldMap.get(wp.id).Status__c == NOTREQUIRED){
           Workplan_Task__c wpt = new Workplan_Task__c(id=wp.id);
           wpt.NotStartedStatusCheck__c = true;
           tasksToUpdate.add(wpt);
           }
       } 
       
       //if the tasks ID set is not empty, then get the workplan task template of those workplan tasks
       if(!tasksToUpdate.isEmpty()){
          system.debug('Inside Workplan task helper UpdateWorkplanStatuss Update');
          update tasksToUpdate;
                             
        }
    }
     /**T04 - Changes End**/
    
    
}