/*===================================================================================================
* Date         : 04/17/2018
* Developer    : Laveen Kattela
* Purpose      : This class is used to handle Post sales sub process related functionality which 
*                get called from Process,subprocess trigger handler
*
*                All this methods are created as a part of US-1513, US -362 and US-462
*                1.fieldUpdateOnModification() -  Method is to update a field called Marked as not required check box 
*                                               
*                2.createSubProcess() - Method is used to create subprocess for pre/post-sales
*                                           
*                3.updateProcessOnSubProcessCompletion - Update process status to complete
*                4.updateWorkPlanTaskStatus - to update work plan status to Not started/not required
*                
*===================================================================================================
*                                 Update History
*                                 ---------------
* Date       Developer     Tag   Description
*============+============+=====+===================================================================
* 05/05/2018 | Laveen     | T01 | Initial version 
* 06/05/2018 | Gayathri   | T02 | Added method to update workplan task status as part of Defect 39387
* 07/30/2018 | Satya      | T03 | Changed conditions for Process Enrollment subprocess to be created
*                                for all implementations
* 08/30/2018 | Rajesh     | T04 | Added logic for MARKETING_MATERIALS with Business type off cycle      
             | Nagandla   |     | and Setup
* 10/31/2018 | Gayathri   | T05 | Updates the query to fetch the fields referenced in all the workplan 
                                  task rules from implementation for evaluating the status of the workplan
* 12/27/2018 | Phani    | T06 | update necessary workplan tasks only when sub process status is changed from 
                                       Not required to In-Progress OR In-Progress to Not-Required
* 04/15/2019 | Satya      | T07 | Commented out the System.debug statements inside for loops
*===========+============+=====+===================================================================*/  
public without sharing  class AIA_SubProcessController {
    
    public static final String  Status_Completed    = 'Completed';
    Public static final String  Status_In_Progress  = 'In-Progress';
    public static final String  Status_Not_Required = 'Not Required';
    public static final String  Status_Not_Started  = 'Not Started';
    public static final String  UsedFor_Post_Sales  = 'Post-Sales';
    public static final String  UsedFor_Pre_Sales  = 'Pre-Sales';
    public static final String  STATUS_INPROGRESS  = 'In Progress';
    
    /*This method updates a check box field called marked as not required to true and false based on status changes
    * based on respective sub process as input parameter
    */
    public static void fieldUpdateOnModification(List<Sub_Process__c> subprocessList)
    {
        for(Sub_Process__c sb : subprocessList)
        {
            if(sb.Status__c == Status_Not_Required)
            {
                sb.Marked_as_Not_Required__c = True;  
            }
            else if(sb.Status__c == Status_In_Progress)
            {
                sb.Marked_as_Not_Required__c = false;   
            }
        }
    }
    
    
    /*This method handles pre-sales and Post sales creation of Sub process underneath the process based on conditions check on BRF and PP
    * based on respective process list as input parameter
    * After condition check it calls a generic subprocess creation method i.e. AIA_OpportunityImplementationController.createPrePostSalesSubProcess
    */
    Public static void createSubProcess(List<Process__c> processList , Boolean Isinsert)
    {
        if(Isinsert)
        {
            List<Sub_Process__c> subProcessList = new List<Sub_Process__c>();
            Set<Id> processids = new Set<Id>();
            Set<Id> implementationsIds = new Set<Id>();
            //Set<Id> OpportunityIds = new Set<Id>();    
            
            Map<Id,Process__c> processMap = new Map<Id,Process__c>();
            Map<Id,Process__c> processToBrfMap = new Map<Id,Process__c>();
            for(Process__c prc : processList)
            {
                /*  if(prc.Opportunity__c != null)
                {
                OpportunityIds.add(prc.Opportunity__c);
                }    */
                //system.debug('****processs'+prc);
                if(prc.Implementation__c != null)
                {    
                    
                    implementationsIds.add(prc.Implementation__c);
                }
                
                
                processids.add(prc.Process_Type__c);  
                processMap.put(prc.Process_Type__c,prc);
            }
            
            
            if(!implementationsIds.isEmpty() || implementationsIds.size() != 0)
            {  
                
                For(Process__c pc : [select Id,Process_Type__c,Implementation__r.Benefit_Request_Form__r.Request_Type__c,Implementation__r.Benefit_Request_Form__r.Funding_Arrangements__c,
                                     Implementation__r.Benefit_Request_Form__r.Count_Dental_Products__c,Implementation__r.Benefit_Request_Form__r.Accommodation__c, 
                                     Implementation__r.Account__r.Performance_Guarantee_Start_Date__c,Implementation__r.Benefit_Request_Form__r.Count_Drug_Proposed_Products__c,
                                     Implementation__r.Account__r.Performance_Guarantee_End_Date__c,Implementation__r.Opportunity__r.Business_Type__c,
                                     Implementation__r.Benefit_Request_Form__r.Count_of_Medical_Proposed_Products__c,Implementation__r.Benefit_Request_Form__r.Count_Vision_Products__c,
                                     Implementation__r.Benefit_Request_Form__r.CDH_Fund_Type_PP_COUNT__c,Implementation__r.Benefit_Request_Form__r.PP_Integrated_Carved_Out_Vendor__c,
                                     Implementation__r.Benefit_Request_Form__r.Custom_Wellness_PP__c,Implementation__r.Benefit_Request_Form__r.Integrated_DM_Wellness_PP__c
                                     from Process__c where Implementation__c In: implementationsIds])
                {
                    processToBrfMap.put(pc.Process_Type__c,pc);   
                }
            } 
            /* else if(!OpportunityIds.isEmpty() || OpportunityIds.size() != 0) 
            {
            For(Process__c pc : [select Id,Process_Type__c, Stage__c, Opportunity__c, Opportunity__r.StageName ,Opportunity__r.Business_Type__c from Process__c where Opportunity__c IN:OpportunityIds])
            {
            processToBrfMap.put(pc.Process_Type__c,pc);   
            }   
            }  */
            
            // system.debug('@@@@@processToBrfMap'+processToBrfMap);   
            
            
            //querying all the process template records to reference its sub porcesses and create in Run time which are active in active state 
            for(Sub_Process_Type__c subproc : ([select Id,Name,Active__c,All_Tasks_Must_Be_Completed__c,External_ID__c,Parent_Process_Type_Name__c,
                                                Process_Type__c,Sequence_Number__c,Stage__c,Sub_Process_Name__c,Used_For__c,Status__c
                                                from Sub_Process_Type__c 
                                                where Process_Type__c IN: processids AND Active__c = true]))
            {
                //Validating the pre-sales and creating the Subprocess records
                /* 
                if(subproc.Used_For__c == UsedFor_Pre_Sales)
                {
                if(processToBrfMap.get(subproc.Process_Type__c).Opportunity__r.StageName == AIA_Constants.OPPRFP && 
                processToBrfMap.get(subproc.Process_Type__c).Opportunity__r.Business_Type__c == AIA_Constants.OPPBUSINESSTYPENEW
                && processToBrfMap.get(subproc.Process_Type__c).Stage__c== AIA_Constants.OPPRFP)  
                {
                subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));
                } 
                else if(processToBrfMap.get(subproc.Process_Type__c).Stage__c== AIA_Constants.OPPBENEFIT_REQUEST || processToBrfMap.get(subproc.Process_Type__c).Stage__c== AIA_Constants.OPPARC_APPROVAL 
                || processToBrfMap.get(subproc.Process_Type__c).Stage__c== AIA_Constants.OPPUNDERWRITING || processToBrfMap.get(subproc.Process_Type__c).Stage__c== AIA_Constants.OPPQUOTE_DELIVERED 
                )
                {
                subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));
                }   
                
                } */
                                
                /*checking if its for post sales and based on conditions creating subprocess records
                * check subporcess stages and creating subprocess under implementation
                * Below condition based subprocess based on stages are getting created for every subprocess 
                */
                if(subproc.Used_For__c == UsedFor_Post_Sales)
                {
                    //system.debug('subproc.Stage__c'+subproc.Stage__c);//t07
                    
                    if(subproc.Stage__c == AIA_Constants.IMPLEMENTATION_PLAN  || subproc.Stage__c == AIA_Constants.GROUP_STRUCTURE  || subproc.Stage__c == AIA_Constants.BENEFIT_DESIGN_DOC   || subproc.Stage__c == AIA_Constants.EDC || subproc.Stage__c == AIA_Constants.PROCESS_ENROLLMENT
                       || subproc.Stage__c == AIA_Constants.CSR || subproc.Stage__c == AIA_Constants.CREATE_BENEFIT_CONTRACT || subproc.Stage__c == AIA_Constants.GENERATE_POST_SALE_SBCS  
                       || subproc.Stage__c == AIA_Constants.SETUP_MAGELLAN  || subproc.Stage__c == AIA_Constants.BENEFIT_SETUP || subproc.Stage__c == AIA_Constants.CREATE_MICROSITE || subproc.Stage__c == AIA_Constants.ID_CARDS || subproc.Stage__c == AIA_Constants.MYACCOUNT ) //T03 added process enrollment subprocess
                    {                        
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));  
                    }
                    /**T04-Start**/
                    // Condition for stage Marketing Materials with brf type SetUp and OffCycle
                    else if(subproc.Stage__c == AIA_Constants.MARKETING_MATERIALS && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c != '' && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c != AIA_Constants.OFF_ADMIN_CHANGE && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c != AIA_Constants.OFF_BENEFIT_CHANGE && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c != AIA_Constants.OFF_ADMIN_BENEFIT_CHANGE && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c != AIA_Constants.SETUP_ADMIN_CHANGE && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c != AIA_Constants.SETUP_BENEFIT_CHANGE && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c != AIA_Constants.SETUP_ADMIN_BENEFIT_CHANGE){
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap)); 
                    }
                    /**T04-End**/
                    //Checking conditions for specific stages and BRF request type field status values
                    else if((subproc.Stage__c == AIA_Constants.ACCOUNT_KICK_OFF_MEETING || subproc.Stage__c == AIA_Constants.PROCESS_ENROLLMENT 
                             ||  subproc.Stage__c == AIA_Constants.GENERATE_MONTHLY_INVOICES ) && 
                            processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c != '' &&    
                            (processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c == AIA_Constants.PROSPECT_OR_NEW || processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c == AIA_Constants.RENEW_AS_IS
                             || processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c == AIA_Constants.RENEWAL_ADMINISTRATIVE_CHANGES || processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c == AIA_Constants.RENEWAL_BENEFIT_CHANGES
                             || processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c == AIA_Constants.RENEWAL_ADMIN_AND_BENEFIT_CHANGES  || processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c == AIA_Constants.RENEWAL))
                    {
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));  
                    }
                    
                    //Checking if subProcess is Searchlight Healthcheck and BRF request type is New
                    else if(subproc.Stage__c == AIA_Constants.SEARCHLIGHT_HEALTHCHECK && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c != '' &&  processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c == AIA_Constants.PROSPECT_OR_NEW) 
                    {
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));  
                    }
                    
                    //checking if subprocess is Accm cnt svcs & request type values & accomodation values and finally creating subprocess
                    else if(subproc.Stage__c == AIA_Constants.ACCM_CNT_SVCS && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Accommodation__c != '' 
                            && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Accommodation__c == AIA_Constants.EMERGENCY_CONTRACEPTION_ACCOMODATION  )
                    {
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));    
                    }
                    
                    //checking if subprocess stage name equals BAA BAC ASA & funding arrangment values & request type and finally creating the subprocess
                    else if((subproc.Stage__c == AIA_Constants.BAA || subproc.Stage__c == AIA_Constants.BAC || subproc.Stage__c == AIA_Constants.ACCOUNT_FINANCIAL_CONTRACTS )
                            && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c != ''  && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Request_Type__c == AIA_Constants.PROSPECT_OR_NEW
                            && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Funding_Arrangements__c!= '' && (processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Funding_Arrangements__c == AIA_Constants.ASO ||
                                                                                                                                                       processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Funding_Arrangements__c == AIA_Constants.BOTH ))
                    {
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));    
                    }
                    
                    //Checking if subprocess is Perf Guarantee and Accont level field performance gaurentee start is not null and peformance guarentee end date is null
                    //If rule satisfies then creating the subprocess 
                    else if(subproc.Stage__c == AIA_Constants.PERF_GUARANTEE  && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Account__r.Performance_Guarantee_Start_Date__c != Null && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Account__r.Performance_Guarantee_End_Date__c == Null )
                    {
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));    
                    }
                    
                    else if(subproc.Stage__c == AIA_Constants.PP_CFL  && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Opportunity__r.Business_Type__c != '' 
                            && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Opportunity__r.Business_Type__c == AIA_Constants.OPP_BUSNIESSTYPE)
                    {
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));    
                    }
                    else if(subproc.Stage__c == AIA_Constants.SETUP_CVS   && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Count_Drug_Proposed_Products__c > 0 )         
                    {
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));    
                    }
                    else if(subproc.Stage__c == AIA_Constants.SETUP_DAVIS   && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Count_Vision_Products__c > 0 )         
                    {
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));    
                    }
                    else if(subproc.Stage__c == AIA_Constants.SETUP_FACETS_DENTAL  && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Count_Dental_Products__c > 0 )         
                    {
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));    
                    }
                    else if(subproc.Stage__c == AIA_Constants.BLUEFUND  && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.CDH_Fund_Type_PP_COUNT__c > 0 )         
                    {
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));    
                    }
                    else if(subproc.Stage__c == AIA_Constants.CARVE_OUT_RX && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.PP_Integrated_Carved_Out_Vendor__c > 0 )         
                    {
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));    
                    }
                    else if(subproc.Stage__c == AIA_Constants.BR_WELLNESS && processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Funding_Arrangements__c!= ''
                            && (processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Funding_Arrangements__c == AIA_Constants.ASO ||
                                processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Funding_Arrangements__c == AIA_Constants.BOTH )
                            && (processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Custom_Wellness_PP__c > 0 
                                || processToBrfMap.get(subproc.Process_Type__c).Implementation__r.Benefit_Request_Form__r.Integrated_DM_Wellness_PP__c > 0 ) )         
                    {
                        subProcessList.add(AIA_OpportunityImplementationController.createPrePostSalesSubProcess(subproc,processMap));    
                    }
                    //system.debug('subProcessList------'+subProcessList);//t07
                }
            }
            if(!subProcessList.isempty())
            {
                try{
                    insert subProcessList;
                }
                catch (Exception e) { AIA_Utils util=new AIA_Utils(); util.logException(e); }
            }
            
        }     
    }
    
    
    /*This method updates all the tasks for a sub process when sub process status is changed form Not required to In-Progress OR In-Progress to Not-Required
    * based on respective subprocess as input parameter
    */
    Public static void updateWorkPlanTaskStatus(List<Sub_Process__c> subprocessList , Map<Id,Sub_Process__c> oldmap, Boolean IsUpdate)
    {
        //system.debug(Logginglevel.error,'Inside Update Workplan Task Status Method');
        if(IsUpdate && !subprocessList.isEmpty())
        {
            List<Workplan_Task__c> workplantaskToUpdate = new List<Workplan_Task__c>();
            List<Workplan_Task__c> workplantaskUpdate = new List<Workplan_Task__c>();
            //looping thru all the workplan tasks assocaite to subprocesses
            for(Workplan_Task__c wt : [select Id,Status__c, Sub_Process__r.Used_For__c ,Sub_Process__c ,Sub_Process__r.Status__c , Sub_Process__r.Id 
                                       from Workplan_Task__c 
                                       where Sub_Process__c IN:subprocessList])
            {
                //checking if sub process is not required or not started and if its post sales then make the assocaited work plan task to NOT REQUIRED
                if(wt.Sub_Process__r.Status__c == Status_Not_Required && 
                   oldmap.get(wt.Sub_Process__r.Id).Status__c != wt.Sub_Process__r.Status__c &&  
                   (wt.Status__c == Status_Not_Started || wt.Status__c == STATUS_INPROGRESS) && wt.Sub_Process__r.Used_For__c == UsedFor_Post_Sales)
                {
                    wt.Status__c = Status_Not_Required;
                    workplantaskToUpdate.add(wt); //T06
                }
                //checking if sub process is In-progress or Not required and if its post sales then make the assocaited work plan task to NOT started
                else if(wt.Sub_Process__r.Status__c == Status_In_Progress && 
                        oldmap.get(wt.Sub_Process__r.Id).Status__c != wt.Sub_Process__r.Status__c &&  
                        wt.Status__c == Status_Not_Required && wt.Sub_Process__r.Used_For__c == UsedFor_Post_Sales && 
                       oldmap.get(wt.Sub_Process__r.Id).Status__c == Status_Not_Required)
                {
                    wt.Status__c = Status_Not_Started;
                     workplantaskToUpdate.add(wt); //T06
                }
                 //workplantaskToUpdate.add(wt); //T06- Commented this to update workplan tasks which satisfies above if/else if condition
                
            }
            if(!workplantaskToUpdate.isEmpty())
            {
                try
                {
                    update workplantaskToUpdate;
                    
                }
                catch (Exception e) { AIA_Utils util=new AIA_Utils(); util.logException(e); }   
            }
        }
    }
    
    
    /*This method updates process status to Complete when all its subprocess are completed
    * based on respective subprocess as input parameter
    */
    Public static void updateProcessOnSubProcessCompletion(List<Sub_Process__c> subprocessList , Map<Id,Sub_Process__c> oldmap, Boolean IsUpdate)
    {
        if(IsUpdate)
        {
            Set<Id> processIds = new set<Id>();
            List<Process__c>  processList = new List<Process__c>();
            Integer count = 0;
            
            for(Sub_Process__c sb :subprocessList)
            {
                if((sb.Status__c == Status_Completed || sb.Status__c == Status_Not_Required) &&  oldmap.get(sb.Id).Status__c != sb.Status__c)
                {
                    processIds.add(sb.Process__c);   
                }
            }
            if(!processIds.isempty())
            {
                for(Sub_Process__c subprocess : [select id, Process__r.Id , Process__r.Status__c, Process__r.Sub_Process_Count__c, Status__c from Sub_Process__c where Process__c IN:processIds])
                {
                    //system.debug('subprocess'+subprocess.Status__c);
                    if(subprocess.Status__c == Status_Completed || subprocess.Status__c == Status_Not_Required)
                    {
                        count =count +1;
                        if(subprocess.Process__r.Sub_Process_Count__c != count)
                            continue;
                        subprocess.Process__r.Status__c = Status_Completed;
                        processList.add(subprocess.Process__r);
                        count = 0;
                    }
                }
            }
            
            if(!processList.isEmpty())
            {
                try{
                    update processList; 
                }
                catch (Exception e) { AIA_Utils util=new AIA_Utils(); util.logException(e); }  
            }
        }
    }
    
    /** T02--Start--Method to update status of workplan task based on rule criteria when sub process 
    status changed to In progress from Not Required **/
    public static void workplanTaskStatusUpdate(List<Sub_Process__c> subprocessList , Map<Id,Sub_Process__c> oldmap)
    {
        //system.debug(Logginglevel.error,'Inside Workplan Task Status Update Method');
        List<Sub_Process__c> subProcessLst = new List<Sub_Process__C>();
        Set<Id> impId = new Set<Id>();
        for(Sub_Process__c subprocess: subprocessList)
        {
            if(subprocess.Status__c == Status_In_Progress && oldmap.get(subprocess.Id).Status__c == Status_Not_Required && subprocess.Used_For__c == UsedFor_Post_Sales)
            {
                impId.add(subprocess.Implementation__c);
            }
        }
        if(impId.size()>0)
        {
           //T05 Start
           /* Map<id,AIA_Implementation__c> implementationLst =new Map<id,AIA_Implementation__c>([select id,name,AIADoc_approval_status__c,BenefitDesign_Status__c,
                                                                                                BRF_Religious_Accomodation__c,Business_Type__c,GS_Status__c,
                                                                                                Risk_Type__c,oppMarketSeg__c,Settlements_status_of_AIADoc__c,Status__c 
                                                                                                from AIA_Implementation__c where Id IN : impId]);*/
          Map<id,AIA_Implementation__c> implementationLst = new Map<id,AIA_Implementation__c>([Select id,Opportunity__r.AccountID,BRF_Request_Type__c,Account__c,BRF_Funding_Arrangement__c,Claims_Settlem_Proc_Setup_Updated_Date__c,
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
          from AIA_Implementation__c where id in :impId]);
          //T05 End
          AIA_Workplan_Task_Management wtm = new AIA_Workplan_Task_Management();
          wtm.createWorkplanTasksForSObject('update', implementationLst, 'AIA_Implementation__c');
            
        }
    }
    //T02 End
}