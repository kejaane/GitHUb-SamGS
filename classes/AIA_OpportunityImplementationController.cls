/*===================================================================================================
* Date         : 05/05/2018
* Developer    : Laveen Kattela
* Purpose      : This class is used to create Pre/Post sales process related functionality which 
*                get called from AIA_SubProcessController, Process,subprocess trigger handler
*
*                All this methods are created as a part of US-1513,US-362 and US-462
*                1.createPreSalesProcess() -  Method is used to create process records for pre-sales 
*                                               
*                2.createPrePostSalesSubProcess() - Method is used to create subprocess for pre/post-sales functionality
*                                           
*                3.createPrePostSalesSubProcess- Method is used to create process records for post-sales
*                
*                
*===================================================================================================
*                                 Update History
*                                 ---------------
* Date       Developer            Tag   Description
*===========+===================+=====+====================================================================
*  05/05/2018 | Laveen          | T01 | Initial version
*  04/15/2019 | Satya           | T02 | Commented debug statement 
*===========+============+=====+===================================================================*/  
public without sharing class AIA_OpportunityImplementationController {
    
    
    public static final String  Status_Completed    = 'Completed';
    Public static final String  Status_In_Progress  = 'In-Progress';
    public static final String  Status_Not_Required = 'Not Required';
    public static final String  Status_Not_Started  = 'Not Started';
    public static final String  UsedFor_Post_Sales  = 'Post-Sales';
    public static final String  UsedFor_Pre_Sales  = 'Pre-Sales';
    
    
    /*This method is used to create Process recprds when opp is created
     * based on respective opplist as input parameter
     //Commented as part of US-1836
     Public static void createPreSalesProcess(List<Opportunity> oppList, Boolean Isinsert)
     {
       if(Isinsert)
       {
        List<Process_Type__c> processTypeList = new List<Process_Type__c>();
        List<Process__c> processList = new List<Process__c>();
        Id opptwohundredplusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId; // Record Id for the 200+ Opportunity
        //query all the process type records to create run time porcess records
        processTypeList = [select Id,Name,Active__c ,External_Id__c,Process_Condition__c,Process_Name__c,Stage__c ,
                                    Process_Name_Picklist__c,Used_For__c,Status__c,Sequence_Number__c,
                           Version__c,Number_of_Sub_Processes__c 
                           from Process_Type__c where Active__c = true and Used_For__c =: UsedFor_Pre_Sales limit 100];  
        system.debug('processTypeList'+processTypeList);
        
        system.debug('processTypeList'+processTypeList.size());
        if(!processTypeList.isEmpty())
        {
            for(Opportunity opp: oppList)    
            {
                for(Process_Type__c proctyp : processTypeList)    
                {
                    //Checking if its pre-sales and 200+ opp
                    if(proctyp.Used_For__c == UsedFor_Pre_Sales && opp.RecordTypeId == opptwohundredplusId && proctyp.Active__c == True)  
                    {
                        Process__c process     = new Process__c();
                        process.Active__c      = proctyp.Active__c;
                        process.Process_Name__c =  proctyp.Process_Name__c;
                        process.ownerId         = System.Label.AIA_SpmssUser;
                        //process.ownerId         = AIA_WorkPlanController.fetchuserInformation();
                        process.Stage__c       =  proctyp.Stage__c;
                        process.Used_For__c    = proctyp.Used_For__c;
                        process.Version__c     = proctyp.Version__c;
                        process.Status__c      = Status_Not_Started;
                        process.Sequence_Number__c = proctyp.Sequence_Number__c;
                        process.Opportunity__c = opp.Id;
                        system.debug('Process_Type__c'+proctyp.Id);
                        process.Process_Type__c = proctyp.Id;
                        processList.add(process);
                        system.debug('processList'+processList);
                        
                    }
                }
            }
            system.debug('processList'+processList);
            
            if(!processList.isEmpty())
                
            {
                try{
                    insert processList;   //Creating all process records for Pre-sales
                } 
                catch (Exception e)
                {    
                AIA_Utils util=new AIA_Utils(); util.logException(e);   
                }
            }
        }         
    }
    }
   */
    
    
   /*This generic method is to create subprocess for both pre/post sales as a part of US-362 functionality 
     * based on respective process and sub prcoess as input parameter
     */ 
    
    public static Sub_Process__c createPrePostSalesSubProcess(Sub_Process_Type__c subproc , Map<Id,Process__c> processMap)
    {
     //system.debug('Insidesubprocess');T02
     Sub_Process__c sbprocess  = new Sub_Process__c();  
     sbprocess.Used_For__c     = subproc.Used_For__c ;
     sbprocess.Active__c       = subproc.Active__c;
     sbprocess.Stage__c        = subproc.Stage__c;
     //making status as not required for tw0 subprocess stage based on US-362 requirment 
     if(subproc.Stage__c == AIA_Constants.SETUP_MAGELLAN   || subproc.Stage__c == AIA_Constants.CREATE_MICROSITE )
     {
        sbprocess.Status__c = Status_Not_Required ;
     }
     else
     {
     sbprocess.Status__c  = Status_Not_Started ;   
     }
     sbprocess.All_Tasks_Must_Be_Completed_c__c = subproc.All_Tasks_Must_Be_Completed__c;
     if(processMap.get(subproc.Process_Type__c).Opportunity__c != null)
     sbprocess.Opportunity__c     = processMap.get(subproc.Process_Type__c).Opportunity__c; //In pre-sales - populating the opp id on Sub process 
     sbprocess.Sub_Process_Type__c = subproc.Id;
     sbprocess.Sequence_Number__c = subproc.Sequence_Number__c;
     sbprocess.Process__c         = processMap.get(subproc.Process_Type__c).Id;  
     sbprocess.Implementation__c  = processMap.get(subproc.Process_Type__c).Implementation__c;
     return sbprocess;
    }
    
    
    /*This method is used to create Process records when IMP status goes to IN-Progress 
     * based on respective IMPlist as input parameter
     */
     Public static void createPostSalesProcess(List<AIA_Implementation__c> implist, Map <Id,AIA_Implementation__c> impMap)
    {
        List<Process_Type__c> processTypeList = new List<Process_Type__c>();
        List<Process__c> processList = new List<Process__c>();
        //querining all the process type rercords to create the run time process records
        processTypeList = [select Id,Name,Active__c ,External_Id__c,Stage__c,Process_Condition__c,Process_Name__c,Process_Name_Picklist__c,Used_For__c,
                            Number_of_Sub_Processes__c, Status__c,Sequence_Number__c, Version__c 
                           from Process_Type__c where Used_For__c =: UsedFor_Post_Sales  ];  
        
        //system.debug('processTypeList12'+processTypeList);
        
        
        if(!processTypeList.isEmpty())
        {
            for(AIA_Implementation__c imp: implist)    
            {
                for(Process_Type__c proctyp : processTypeList)    
                {
                    //Checking if its post sales and status of Imp status equals IN progress and Old statust to new status check
                    if(proctyp.Used_For__c == UsedFor_Post_Sales && imp.Status__c == Status_In_Progress && 
                        impMap.get(imp.Id).Status__c != imp.Status__c && proctyp.Active__c == True)
                    {
                        Process__c process     = new Process__c();
                        process.Active__c      = proctyp.Active__c;
                        process.Process_Name__c =  proctyp.Process_Name__c;
                        process.Number_of_Sub_processes_c__c=  proctyp.Number_of_Sub_Processes__c;
                        process.Stage__c       =  proctyp.Stage__c;
                        process.Used_For__c    = proctyp.Used_For__c;
                        process.Version__c     = proctyp.Version__c;
                        process.Status__c      = Status_Not_Started;
                        process.ownerId         = System.Label.AIA_SpmssUser;
                       // process.ownerId         = AIA_WorkPlanController.fetchuserInformation();
                        process.Sequence_Number__c = proctyp.Sequence_Number__c;
                        process.Implementation__c = imp.Id;
                        // process.Opportunity__c = imp.opportunity__c;
                        //system.debug('Process_Type__c'+proctyp.Id);
                        process.Process_Type__c = proctyp.Id;
                        processList.add(process);
                        //system.debug('processList'+processList);
                    }
                    
                }
            }
        }
        
        if(!processList.isEmpty())
            
        {
            try{
                insert processList;  //Creating all the process records for Post- sales
            }
            catch (Exception e)
            {     
                AIA_Utils util=new AIA_Utils(); util.logException(e);   
            }
        }
    }         
    
   

}