/*===================================================================================================
* Date         : 04/17/2018
* Developer    : Laveen Kattela
* Purpose      : This class is used for Both Pre-sales and Post sales functionality which 
*                get called from Process , Sub Process trigger handlers to create tasks records 
*
*                All this methods are created as a part of US-1513 , US-462 and US- 362
*                1.updateSubProcessStatus() -  Method is to update Sub porcess status to complete 
*                                              when all task are completed
*                2.createWorkPlantask - To create all the workplan task underneath sub process 
*                3.updateTotalTaskCount - updating total no of count in subprocess level when task  
*                                         are created
*====================================================================================================
*                                 Update History
*                                 ---------------
* Date         Developer     Tag   Description
*============+============+=====+=============================================================================
* 05/05/2018 | Laveen     | T01 | Initial version 
* 05/20/2018 | Asif K     | T02 | US463. Updated code to calculate the count of tasks in Incomplete
*                                 Status i.e., Status not equal to Complete or Not Required
* 05/31/2018 | Asif K     | T03 | US463. Updated code to calculate the count of tasks for which the
*                                 SLA is broken
* 06/07/2018 | Arshia     | T04 | Updating Task Description in Task Name
* 06/12/2018 | Satya      | T05 | Commented since the field is getting updated with tasks count from 
*                                 another method - updateSubProcessStatus
* 08/02/2018 | Satya      | T06 | Check rules while generating workplan tasks from WP Template records
* 08/22/2018 | Arshia     | T07 | Update Sub-process status to 'Not Required' when all tasks are 'Not Required' US3856
* 08/22/2018 | Rajesh     | T08 | Added Missing fields in implementation query and inner query for template query.
             | Nagandla   |         
* 10/31/2018 | Gayathri   | T09 | Added conditions to update the sub process status to 
                                        -Not Started when all the tasks under it are not started
                                        -In Progress when some tasks under it are started.
* 10/31/2018 | Gayathri   | T10 | Updating Account and AccountId fields in workplan task from Implementation 
                                  while creating instead of Process builder 'AIA Link Account' and 
                                  workflow rule 'AIA Update AccountID__c Field' resp. to avoid 
                                  multiple entry in trigger
* 04/15/2019 | Satya      | T11 | Commented out the System.debug statements inside for loops
*============+============+=====+=============================================================================*/  

public without sharing class AIA_WorkPlanController
{
    /* Constant declartion for Workplan task,IMP,Process,Sub porcess.Status__c which has 
    picklist value - Completed or In Progress or Not required or Not started          */
    public static final String Status_Completed    = 'Completed';
    public static final String Status_In_Progress  = 'In Progress';
    public static final String Status_Not_Required = 'Not Required';
    public static final String Status_Not_Started  = 'Not Started'; 
    public static final String Status_Blocked  = 'Blocked';//T02
    public static final String UsedFor_Post_Sales  = 'Post-Sales';
    public static final String UsedFor_Pre_Sales  = 'Pre-Sales';
    public static final String owneremail  = 'salesforcecoe@carefirst.com';
    public static final String ownername  = 'spmss process';
    public static final string Equals = 'Equal To';
    public static final string NotEquals = 'Not Equal To';
    
    /*This method creates Workan Tasks in poth Pre-sales and post sales on Opp and Imp records
    * based on respective Sub process as input parameter
    // Commented as a part of US-1836
    public static Id fetchuserInformation()
    {
    User userinfo = [select Id from user where name=:ownername and email=: owneremail LIMIT 1];
    system.debug('@@@@@userinfo'+userinfo.Id);
    return  userinfo.Id;
    
    }  */
    
    Public static void createWorkPlantask(List<Sub_Process__c> subprocessList, Boolean Isinsert)
    {
        //  Id ownerId = fetchuserInformation();
        if(Isinsert)
        {
            List<Workplan_Task__c> workplantaskList = new List<Workplan_Task__c>();
            Set<Id> subprocesstyppeids = new Set<Id>();
            Boolean RulesPassed = False;
            set<id> impIds = new set<id>();
            Map<Id,Sub_Process__c> subprocessMap = new Map<Id,Sub_Process__c>();
            for(Sub_Process__c sb : subprocessList)
            {
                subprocesstyppeids.add (sb.Sub_Process_Type__c); 
                subprocessMap.put(sb.Sub_Process_Type__c,sb);
                impIds.add(sb.Implementation__c);
            }
            /*--T08-Start--*/
            map<id,AIA_Implementation__c> impMap =new map<id,AIA_Implementation__c>([select id, GS_Status__c, 
                                                   vision_with_platform_indicator__c, BRF_Control_plan_680__c, BRF_FA__c, 
                                                   Opp_Business_Type__c, BenefitDesign_Status__c, BRF_Funding_Arrangement__c,
                                                   oppMarketSeg__c,BRF_Control_plan__c, Risk_Type__c, Backend_BRF_Effective_Date__c, 
                                                   BRF_Blue_Rewards__c, BRF_CDH__c, BRF_CDH_Type__c, BRF_Custom_Wellness__c, 
                                                   BRF_FlexLink__c, BRF_FSA_BlueFund__c, BRF_New_Dental_Products__c, BRF_New_Products__c,
                                                   Status__c, AIADoc_approval_status__c, Settlements_status_of_AIADoc__c, Business_Type__c, 
                                                   BRF_Religious_Accomodation__c, BRF_Request_Type__c,Account__c from AIA_Implementation__c 
                                                                                     where id in:impIds]);
            //system.debug('subprocessMap@@@'+subprocessMap);
            for(Workplan_Task_Template__c wt : [select Id,Acc_Team_Role_for_New_Business__c,Acc_Team_Role_for_Renewal_Business__c,Description__c,
                                                Expected_SLA__c,Number__c,Queue_Id__c,Queue_Name__c,Related_Object_API_Name__c,Send_Notification__c,SLA_Day_Type__c,
                                                SequenceNumber__c,Stage__c,Status__c,Sub_Process_Type__c,Task_Completion_Expression__c,Task_Completion_Events__c,
                                                Task_Creation_Criteria_Expression__c,Task_Creation_Events__c,Task_Owner__c,Task_Type__c,Used_For__c,Task_Generation_Criteria_Expression__c, (select id, Operation__c, Value__c, Rule_Number__c, Field_API_Name__c from Workplan_Task_Rules__r where Criteria_Type__c = 'Task Generation Criteria') 
                                                from Workplan_Task_Template__c 
                                                where Sub_Process_Type__c IN:subprocesstyppeids])
                
            {/*--T08-End--*/
                 Map<String,Boolean> ruleMap = new Map<String,Boolean>(); 
               // system.debug('wt@@@@@'+wt);
               // system.debug('wt@@@@@'+wt.Used_For__c);
                
                //executes if its a pre sales records on Opp
                /* 
                * Commented as a part of US-1836
                * if(wt.Used_For__c == UsedFor_Pre_Sales)
                {
                system.debug('insidepresales');
                Workplan_Task__c workplan = new   Workplan_Task__c();
                workplan.Description__c = wt.Description__c;
                workplan.Sequence_Number__c = wt.SequenceNumber__c;
                workplan.ownerId = System.Label.AIA_SpmssUser;
                workplan.Opportunity__c = subprocessMap.get(wt.Sub_Process_Type__c).Opportunity__c;
                // workplan.Implementation__c = subprocessMap.get(wt.Sub_Process_Type__c).Implementation__c;
                workplan.Process__c = subprocessMap.get(wt.Sub_Process_Type__c).Process__c;
                workplan.Sub_Process__c = subprocessMap.get(wt.Sub_Process_Type__c).Id;
                workplan.Workplan_Task_Template__c = wt.Id;
                workplan.SLA_Day_Type__c =  wt.SLA_Day_Type__c;
                workplan.Stage__c = wt.Stage__c;
                workplan.Total_Days_to_Complete_Task_SLA__c = wt.Expected_SLA__c;
                workplan.Status__c = Status_Not_Started;
                workplan.Opportunity_Implementation_ID__c = subprocessMap.get(wt.Sub_Process_Type__c).Opportunity__c;
                workplantaskList.add(workplan);
                }
                */
                //Executes if its a post sales records on IMP
                if(wt.Used_For__c ==  UsedFor_Post_Sales)
                {
                    //system.debug('insidepostsales');
                    Workplan_Task__c workplan = new   Workplan_Task__c();
                    //T04 - Start
                    if (wt.Description__c != null){
                    if(wt.Description__c.length() > 100)
                    {
                        workplan.Task_Name__c = wt.Description__c.substring(0,100);             
                    }else
                    {
                        workplan.Task_Name__c = wt.Description__c;              
                    }
                    }
                    //T04 - End
                    workplan.Description__c = wt.Description__c;
                    workplan.Sequence_Number__c = wt.SequenceNumber__c;
                    workplan.ownerId = System.Label.AIA_SpmssUser;
                    //workplan.ownerId = fetchuserInformation();
                    workplan.Implementation__c = subprocessMap.get(wt.Sub_Process_Type__c).Implementation__c;
                    
                    //T10 -- Start
                    workplan.Account__c = impMap.get(subprocessMap.get(wt.Sub_Process_Type__c).Implementation__c).Account__c;
                    workplan.AccountID__c =impMap.get(subprocessMap.get(wt.Sub_Process_Type__c).Implementation__c).Account__c; 
                    //T10 -- End
                    
                    workplan.Process__c = subprocessMap.get(wt.Sub_Process_Type__c).Process__c;
                    workplan.Sub_Process__c = subprocessMap.get(wt.Sub_Process_Type__c).Id;
                    workplan.Workplan_Task_Template__c = wt.Id;
                    workplan.Total_Days_to_Complete_Task_SLA__c = wt.Expected_SLA__c;
                    //workplan.Expected_Days_to_Complete__c = wt.Expected_SLA__c;
                    workplan.SLA_Day_Type__c =  wt.SLA_Day_Type__c;
                    workplan.Opportunity_Implementation_ID__c = subprocessMap.get(wt.Sub_Process_Type__c).Implementation__c;
                    workplan.Stage__c = wt.Stage__c;
                    if(subprocessMap.get(wt.Sub_Process_Type__c).Stage__c == AIA_Constants.SETUP_MAGELLAN   || subprocessMap.get(wt.Sub_Process_Type__c).Stage__c == AIA_Constants.CREATE_MICROSITE ) 
                    {
                        workplan.Status__c = Status_Not_Required ;
                    }
                    else
                    {
                        workplan.Status__c  = Status_Not_Started ;   
                    }
                    
                    //T06 changes start. Added to check rules while generating workplan tasks from WP Template records
                    if(wt.Task_Generation_Criteria_Expression__c !='' && String.isNotBlank(wt.Task_Generation_Criteria_Expression__c)){
                         if(!wt.Workplan_Task_Rules__r.isEmpty()){
                            for(Workplan_Task_Rules__c wptr : wt.Workplan_Task_Rules__r) {
                           
                                if(wptr.Operation__c == Equals) {
                                    if(impMap.containsKey(subprocessMap.get(wt.Sub_Process_Type__c).Implementation__c)){
                                        if(wptr.Value__c == String.valueOf(impMap.get(subprocessMap.get(wt.Sub_Process_Type__c).Implementation__c).get(wptr.Field_API_Name__c))) {
                                            RulesPassed = True;
                                        }
                                        else {
                                            RulesPassed = False;
                                        }
                                    }
                                }
                                else if(wptr.Operation__c == NotEquals) {
                                    if(impMap.containsKey(subprocessMap.get(wt.Sub_Process_Type__c).Implementation__c)){
                                        if(wptr.Value__c != String.valueOf(impMap.get(subprocessMap.get(wt.Sub_Process_Type__c).Implementation__c).get(wptr.Field_API_Name__c))) {
                                            RulesPassed = True;
                                        }
                                        else {
                                            RulesPassed = False;
                                        }
                                    }
                                }
                                ruleMap.put(String.valueOf(wptr.Rule_Number__c),RulesPassed);
                            }
                            
                              if(!ruleMap.isEmpty() && String.isNotBlank(wt.Task_Generation_Criteria_Expression__c)){
                                  AIA_WorkplanTask_RulesCriteria RC = new AIA_WorkplanTask_RulesCriteria();
                                  RulesPassed = RC.checkCritetia(ruleMap,wt.Task_Generation_Criteria_Expression__c);
                                }
                        }
                        
                         if(RulesPassed){
                             workplantaskList.add(workplan);
                         }
                    }
                    else {
                        workplantaskList.add(workplan);
                    }
                }
            }
            //T06 Changes End
            if(!workplantaskList.isEmpty())
            {
                insert workplantaskList;  
            }
        }
    }

    /*
     * This method updates Sub process status to Complete when all its tasks are completed
     * based on respective workplan tasks as input parameter
     */
    Public static void updateSubProcessStatus(List<Workplan_Task__c> workPlanTaskList , Map<Id,Workplan_Task__c> workplanmap, Boolean isInsert)
    {
        //system.debug(Logginglevel.ERROR ,'workPlanTaskList65'+workPlanTaskList);
        //system.debug(Logginglevel.ERROR ,'workPlanTaskList65'+workPlanTaskList.size());
        //system.debug(Logginglevel.ERROR ,'workplanmap65'+workplanmap);
        //list<Id> subrprocessId = new list<Id>();
        Set<Id> subrprocessId = new Set<Id>();
        Integer count = 0;
        List<Sub_Process__c> subprocesstoupdate = new List<Sub_Process__c>();
        List<Workplan_Task__c> workplantoUpdate = new List<Workplan_Task__c>();
        set<Process__c> setProcsToUpdate = new set<Process__c>();
        for(Workplan_Task__c wt :workPlanTaskList)
        {
            //if(isInsert || (workplanmap.ContainsKey(wt.Id) && (workplanmap.get(wt.Id).Status__c != wt.Status__c)) || wt.SLA_Broken__c)
            //{
                //system.debug('wt.Sub_Process__c'+wt.Sub_Process__c);
                subrprocessId.add(wt.Sub_Process__c);   
           // }
        }
        
        //system.debug('subrprocessId'+subrprocessId);
        //T02-map of sub process and associated workplan tasks
        map<Id,list<Workplan_Task__c>> mapSubProcID_WPtaskList = new map<Id,list<Workplan_Task__c>>();
        
        //checking if subprocess list 
        if(!subrprocessId.isEmpty())
        {
            for(Workplan_Task__c wt : [select id, Sub_Process__r.Id, Sub_Process__r.Total_Task_Count__c, Sub_Process__r.Status__c, Sub_Process__r.Process__c, 
                                              Sub_Process__r.Marked_as_Not_Required__c, Status__c,Expected_SLA__c, Actual_SLA__c, SLA_Broken__c 
                                       from Workplan_Task__c 
                                       where Sub_Process__c IN :subrprocessId])
            {
                //T02-Start
                if(mapSubProcID_WPtaskList.ContainsKey(wt.Sub_Process__r.Id)) {
                    mapSubProcID_WPtaskList.get(wt.Sub_Process__r.Id).add(wt);
                }
                else {
                    list<Workplan_Task__c> lstWPtask = new list<Workplan_Task__c>();
                    lstWPtask.add(wt);
                    mapSubProcID_WPtaskList.put(wt.Sub_Process__r.Id,lstWPtask);
                }
                //T02-End
            }//end for
            
            //T02-Start
            Integer CompletedTaskCount = 0;
            Integer NotRequiredTaskCount = 0;
            Integer BlockedTaskCount = 0;
            Integer NotStartedTaskCount = 0;
            Integer InProgressTaskCount = 0;
            Integer TotalTaskCount = 0;
            Integer slaBrokenTaskCount = 0;//T03
            Boolean subProcessMarkedNotRequired = False;
            for(Id subProcId : mapSubProcID_WPtaskList.keySet()) {
                    CompletedTaskCount = 0;
                    NotRequiredTaskCount = 0;
                    BlockedTaskCount = 0;
                    NotStartedTaskCount = 0;
                    InProgressTaskCount = 0;
                    TotalTaskCount = 0;
                    slaBrokenTaskCount = 0;//T03
                    //system.debug('subprocess id subProcId---'+subProcId); //T11 
                    
                for(Workplan_Task__c wtask : mapSubProcID_WPtaskList.get(subProcId)){
                    if(wtask.Sub_Process__r.Marked_as_Not_Required__c) { subProcessMarkedNotRequired = True; }
                    if(wtask.Status__c == Status_Completed) {
                        CompletedTaskCount++;
                    }
                    else if(wtask.Status__c == Status_Not_Required) {
                        NotRequiredTaskCount++;
                    }
                    else if(wtask.Status__c == Status_Blocked) {
                        BlockedTaskCount++;
                    }
                    else if(wtask.Status__c == Status_Not_Started) {
                        NotStartedTaskCount++;
                    }
                    else if(wtask.Status__c == Status_In_Progress) {
                        InProgressTaskCount++;
                    }
                    
                    if(wtask.SLA_Broken__c) { slaBrokenTaskCount++; } //T03
                    TotalTaskCount++;
                    
                    if(wtask.Sub_Process__r.Process__c != NULL) { setProcsToUpdate.add(new Process__c(Id=wtask.Sub_Process__r.Process__c)); }
                }//end for loop on list of task list associated with individual sub process
                
                /** Based on task status if its complete or not required - making subprocess status to complete  **
                 ** also checking the marked as not required to not equals to true for edge case scenario        **/
                Sub_Process__c spObj = new Sub_Process__c(Id=subProcId);
                spObj.AIA_Number_of_Completed_tasks__c = CompletedTaskCount;
                spObj.AIA_Number_of_Not_Required_Tasks__c = NotRequiredTaskCount;
                spObj.Number_of_Blocked_Tasks__c = BlockedTaskCount;
                spObj.Number_of_Not_Started_Tasks__c = NotStartedTaskCount;
                spObj.Number_of_In_Progress_Tasks__c = InProgressTaskCount;
                //system.debug(Logginglevel.ERROR ,'after loop completion TotalTaskCount---'+TotalTaskCount);//T11
                //system.debug(Logginglevel.ERROR ,'after loop completion TotalTaskCount completed---'+CompletedTaskCount);//T11
                //system.debug(Logginglevel.ERROR ,'after loop completion TotalTaskCount Not Required---'+NotRequiredTaskCount);//T11
                //system.debug(Logginglevel.ERROR ,'after loop completion TotalTaskCount In Progress---'+InProgressTaskCount);//T11
                //system.debug(Logginglevel.ERROR ,'after loop completion TotalTaskCount Not Started---'+NotStartedTaskCount);//T11
                spObj.Total_Task_Count__c = TotalTaskCount;
                spObj.Number_of_Tasks_SLA_Broken__c = slaBrokenTaskCount;//T03
                if((TotalTaskCount == CompletedTaskCount + NotRequiredTaskCount) 
                   && (subProcessMarkedNotRequired != True) 
                   && mapSubProcID_WPtaskList.get(subProcId)[0].Sub_Process__r.Status__c != Status_Not_Required
                   && TotalTaskCount != NotRequiredTaskCount) {
                    spObj.Status__c = Status_Completed;    
                }
                //T07-Start
                else if(TotalTaskCount == NotRequiredTaskCount){
                    spObj.Status__c = Status_Not_Required;    
                }
                //T07-End
                //T09 -- Start
                else if(TotalTaskCount == NotStartedTaskCount){
                    spObj.Status__c = Status_Not_Started;    
                }
                else
                {
                    if((InProgressTaskCount>0 || CompletedTaskCount>0))
                    spObj.Status__c = AIA_Constants.STATUS_INPROGRESS;
                }
                //T09 -- End
                
                subprocesstoupdate.add(spObj);
            }//end for loop on map of sub processes and associated list of tasks for each sub process
            //T02-End
        }//end if
        system.debug(Logginglevel.ERROR,'subprocesstoupdate'+subprocesstoupdate);
        if(!subprocesstoupdate.isEmpty())
        {
            try{
                update subprocesstoupdate; 
                list<Process__c> lstProcsToUpdate = new list<Process__c>();
                lstProcsToUpdate.addAll(setProcsToUpdate);
                if(!lstProcsToUpdate.isEmpty() && System.isBatch()) { 
                    Database.update(lstProcsToUpdate,false); 
                }
            }
            catch (Exception e)
            {               
                system.debug(Logginglevel.ERROR,'Inside wp controller catch 353');
                AIA_Utils util=new AIA_Utils(); util.logException(e);   
            }  
        }
        
    }
    
    /*
     * This method is to update the total count of task on sub porcess level
     * based on respective workplan tasks as input parameter
     */ 
    
  /* T05 CHANGES
   Public static void updateTotalTaskCount(List<Workplan_Task__c> workPlanTaskList)
    {
        
        Set<Id> subrprocessId = new set<Id>();
        List<Sub_Process__c> subprocesstoupdate = new List<Sub_Process__c>();
        Map<Id, List<Workplan_Task__c>> subprocessmap = new  Map<Id, List<Workplan_Task__c>>();
        for(Workplan_Task__c wk : workPlanTaskList)
        {
            subrprocessId.add(wk.Sub_Process__c); 
        }
        
        for(Sub_Process__c sb : [select id,(select Id,Status__c from Workplan_Tasks__r) 
                                 from Sub_Process__c 
                                 where id IN:subrprocessId])
        {
            subprocessmap.put(sb.Id, sb.Workplan_Tasks__r); 
            sb.Total_Task_Count__c = subprocessmap.get(sb.Id).size();
            subprocesstoupdate.add(sb); 
        }
        
        
        if(!subprocesstoupdate.isEmpty())
        {
            try{
                update subprocesstoupdate;
            }
            catch (Exception e)
            {               
                AIA_Utils util=new AIA_Utils(); util.logException(e);   
            }  
        }
        
    } T05 Changes End
     */
}