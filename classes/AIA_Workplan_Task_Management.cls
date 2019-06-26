/*=================================================================================================================
* Date         : 09/11/2017
* Developer    : Satya Tirumalasetti
* Purpose      : This class is used to create workplan tasks when the conditions/rules are satisfied 
*============+================+=====+=============================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 09/21/2017 | Satya          |     | Initial Version
* 04/20/2018 | Satya          | T01 | Done as a part of 1514 US. Changed the conditions from task generation to 
*                                     updating the tasks when rules and dependent tasks are satisfied depending 
*                                     upon the criteria
* 05/10/2018 | Gayathri       | T02 | Updating the start date of the sub process as per US 182.
* 10/29/2018 | Paritosh       | T03 | Defect fix to handle optionally created tasks 
* 10/29/2018 | Paritosh       | T04 | Enhancement to cascade not required status on multiple levels
* 10/31/2018 | Gayathri       | T05 | Added a Map to add all the tasks to be updated to replace three update 
                                      statements in task
* 02/01/2019 | Satya          | T06 | Changed reference from standard AccountTeamMmeber to Custom Object
* 03/29/2019 | Phani          | T07 | Fixed the code to rectify the defect related to AccountId misamtch
* 04/13/2019 | Satya          | T08 | Added filter condition to reduce number of records  returned
*===========+============+========================================================================================
*/

public without sharing class AIA_Workplan_Task_Management {


    /** Method used to create workplan tasks when the conditions/rules are satisfied **/
    
    public void createWorkplanTasksForSObject(String dmlEvent,Map<id,sObject> lstNewSObjects, String strObjectType){
        list<Workplan_Task__c> lstWT_ToCreate = new list<Workplan_Task__c>();
        set<id> procset = new set<id>();
        set<id> subprocset = new set<id>();
        list<Process__c> proc_toUpdate = new list<Process__c>();
        list<Sub_Process__c> subproc_toUpdadte = new list<Sub_Process__c>();
        list<Workplan_Task__c> MarkNotRequired = new list<Workplan_Task__c>();
        list<Workplan_Task__c> MarkNotStarted = new list<Workplan_Task__c>();
        benfit_request_form__c brf1;
        AIA_Document__c AIADoc;
        Opportunity Opp;
        AIA_Implementation__c IMP;
        set<string> Idset = new set<string>();
        id oppid;
        String AccountID;
        Map<id, Opportunity> OppMap = new Map<id, Opportunity>();
        Map<id, AIA_Implementation__c> implMap = new Map<id, AIA_Implementation__c>();
        Map<id, benfit_request_form__c> brfMap = new Map<id, benfit_request_form__c>();
        Map<id, AIA_Document__c> docMap = new Map<id, AIA_Document__c>();
        Map<id, AIA_Group_Structure_Request_Form__c> gsrfMap = new Map<id, AIA_Group_Structure_Request_Form__c>();
        Map<id, AIA_Benefit_Design__c> BDMap = new Map<id, AIA_Benefit_Design__c>();
        list<Workplan_Task__c> wptToNotrequired = new list<Workplan_Task__c>();
        list<Workplan_Task__c> wptToNotStarted = new list<Workplan_Task__c>();
        
        final string Equals = 'Equal To';
        final string NotEquals = 'Not Equal To';
        final string Completed = 'Completed';
        final string InProgress ='In Progress';
        final string NotRequired = 'Not Required';
        final string AutoClose = 'Automated recording of this event';
        final string NotStarted = 'Not Started';
        Final string NewVariable = 'New';
        Final string Renewal = 'Renewal';
        final string Opportunityvar = 'Opportunity';
        final string Implementationvar ='Implementation__c';
        final string Brfrecd ='Benfit_request_form__c';
        final string gsVar = 'Group_Structure_Request_Form__c';
        final string BDVar = 'Benefit_Design__c';
        final string DocVar = 'AIA_Document__c';
        final string AIADocu ='';
        final string NotCompleted = 'Not-Completed';
        final string Descvar = 'Description__c';
        final string OwnerId = 'OwnerId';
        final string TOwner = 'Task_Owner__c';
        final string ROID = 'RelatedObjectId__c';
        final string AccId = 'AccountID__c';
        final string ObjTypes = 'ObjType';
        Id opptwohundredplusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId; // Record Id for the 200+ Opportunity
        
        Map<Id,Map<String,Id>> mapAccountTeamRole =  new Map<Id,Map<String,Id>>();
        Set<ID> AccountIDSet = new Set<ID>();
        Map<string,Id> ObjtoIdMap = new Map<string,Id>();
    
        
        // Check the object present in the trigger context and get it's ID to assign it to Work Plan Tasks.
        
        if(strObjectType == AIA_Constants.Implementation){
            
            for(AIA_Implementation__c rec : [select id,Opportunity__r.AccountID,BRF_Request_Type__c,Account__c, Opportunity__r.StageName,opportunity__r.Business_Type__c 
                                             from AIA_Implementation__c 
                                             where id IN :lstNewSObjects.keyset()]){
                implMap.put(rec.id,rec);
                AccountIDSet.add(rec.Opportunity__r.AccountID); 
            }
          
        }
        
        if(strObjectType == AIA_Constants.AIADocument){                                       
            for(AIA_Document__c rec : [select id,Account__c,opportunity__c,Benefit_Request_Form__c,Benefit_Design__c,Benefit_Design_Form__c,Benefit_Design_Product__c,
                                                   Benefit_Design_Form__r.Benefit_Design__r.Implementation__c,Benefit_Design_Product__r.Benefit_Design__r.Implementation__c,
                                                   Benefit_Design__r.Implementation__c,Benefit_Request_Form__r.opportunity__c,Proposal_Request_Form__c,Implementation__c,
                                                   Proposal_Request_Form__r.opportunity__c,Proposed_Products__r.Benefit_Request_Form__r.opportunity__c,Proposed_Products__c,
                                                   opportunity__r.Business_Type__c,Implementation__r.opportunity__r.Business_Type__c,Benefit_Request_Form__r.opportunity__r.Business_Type__c,
                                                   Benefit_Design__r.Implementation__r.opportunity__r.Business_Type__c,
                                                   Benefit_Design_Form__r.Benefit_Design__r.Implementation__r.opportunity__r.Business_Type__c,
                                                   Benefit_Design_Product__r.Benefit_Design__r.Implementation__r.opportunity__r.Business_Type__c,
                                                   Proposed_Products__r.Benefit_Request_Form__r.opportunity__r.Business_Type__c,Proposal_Request_Form__r.opportunity__r.Business_Type__c
                                       from AIA_Document__c 
                                       where id IN :lstNewSObjects.keyset()]){
                docMap.put(rec.id,rec);
                AccountIDSet.add(rec.Account__c); 
            }
            
        }
        
        /* T06 -- Start */            
       /* if(!AccountIDSet.ISEMPTY()){
            for(AccountTeamMember ATM:[SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId,User.email,User.Name FROM AccountTeamMember where AccountId in:AccountIDSet AND User.isActive = true]){
                if(mapAccountTeamRole.containsKey(ATM.AccountId)){
                    mapAccountTeamRole.get(ATM.AccountId).put(ATM.TeamMemberRole,ATM.UserId);
                }else{
                    map<string,Id> userTeamroleMap = new map<string,Id>();
                    userTeamroleMap.put(ATM.TeamMemberRole,ATM.UserId);
                    mapAccountTeamRole.put(ATM.AccountId, userTeamroleMap);
                }
            } 
        }*/
        if(!AccountIDSet.ISEMPTY()){
            for(Account_Team__c ATM:[SELECT AccountAccessLevel__c,AccountId__c,Id,TeamMemberRole__c,UserId__c,UserId__r.email,UserId__r.Name FROM Account_Team__c where AccountId__c in:AccountIDSet AND UserId__r.isActive = true]){
                if(mapAccountTeamRole.containsKey(ATM.AccountId__c)){
                    mapAccountTeamRole.get(ATM.AccountId__c).put(ATM.TeamMemberRole__c,ATM.UserId__c);
                }else{
                    map<string,Id> userTeamroleMap = new map<string,Id>();
                    userTeamroleMap.put(ATM.TeamMemberRole__c,ATM.UserId__c);
                    mapAccountTeamRole.put(ATM.AccountId__c, userTeamroleMap);
                }
            } 
        }
        /*T06 -- End*/
        
        system.debug('@@mapAccountTeamRole--'+mapAccountTeamRole);
        Boolean RulesPassed = False;
        Boolean WorkPlanExist = False;
        set<Id> prepostIds = new set<id>();
        set<Id> RulesPassedTempIds = new set<id>();
        try{
            
            Map<string,string> DeptToPrimaryMap = new Map<string,string>();
            Map<string,string> DeptStatusMap = new Map<string,string>();
            Map<string,string> primarystatusMap = new Map<string,string>();
            Map<string,string> starToNotstatusMap = new Map<string,string>();
            Map<string,Workplan_Task__c> tempWptMap = new Map<string,Workplan_Task__c>();
            Set<id> allPrimaryTaskIds = new set<id>();
            set<id> idset1 = new set<id>();
            for(Workplan_Task_Template__c wtt1 : [SELECT id,Status__c, 
                                                 (Select Primary_Task__c,Dependent_Task__c from Dependent_Workplan_Tasks1__r),
                                                 (Select Primary_Task__c,Dependent_Task__c from Dependent_Workplan_Tasks__r) ,
                                                 (Select id,Status__c,Workplan_Task_Template__c,Opportunity__c,Opportunity_Implementation_ID__c,RelatedObjectId__c,Description__c from Workplan_Tasks__r where Opportunity_Implementation_ID__c in :lstNewSObjects.keyset())//T08 
                                                 from  Workplan_Task_Template__c
                                                 WHERE Related_Object_API_Name__c = :strObjectType AND Task_Creation_Events__c = :dmlEvent])                                    
            {
                //T04 store all the workplan tasks by sobjectype and sobject id
                for(Workplan_Task__c WTExist: wtt1.Workplan_Tasks__r){
                        tempWptMap.put(WTExist.Workplan_Task_Template__c+WTExist.Opportunity_Implementation_ID__c,WTExist);
                    }
                
                if(!wtt1.Dependent_Workplan_Tasks1__r.isEmpty()){
                            for(Dependent_Workplan_Task__c dwt : wtt1.Dependent_Workplan_Tasks1__r)
                            { //system.debug('<<dep Task>>'+dwt);
                              DeptToPrimaryMap.put(dwt.Dependent_Task__c,dwt.Primary_Task__c);
                              idset1.add(dwt.Primary_Task__c);
                           }       
                }
            }
            for(Workplan_Task__c wtt2 : [select id,Status__c,Workplan_Task_Template__c,Opportunity__c,RelatedObjectId__c,Opportunity_Implementation_ID__c,
                                         NotStartedStatusCheck__c
                                         from Workplan_Task__c 
                                         where Workplan_Task_Template__c in : idset1 and Opportunity_Implementation_ID__c in :lstNewSObjects.keyset()])//T08
            {
                if(wtt2.Status__c == Completed){
                    //system.debug('1cond'+wtt2.Workplan_Task_Template__c+wtt2.RelatedObjectId__c);
                    DeptStatusMap.put(wtt2.Workplan_Task_Template__c+wtt2.Opportunity_Implementation_ID__c,NotStarted);               
                }
                
                if(wtt2.Status__c == NotRequired){
                      primarystatusMap.put(wtt2.Workplan_Task_Template__c+wtt2.Opportunity_Implementation_ID__c,'NotRequired');
                   // system.debug('<<primarystatusMap>>'+primarystatusMap);
                }
                
                if(wtt2.Status__c == NotStarted && wtt2.NotStartedStatusCheck__c == true){
                    starToNotstatusMap.put(wtt2.Workplan_Task_Template__c+wtt2.Opportunity_Implementation_ID__c,'NotStarted');
                }
                //T04
                allPrimaryTaskIds.add(wtt2.id);
           }
           
           system.debug('DeptStatusMap>>'+DeptStatusMap);
           //Map<id,Map<string,string>> TemplateToDetailsMap = new Map<id,Map<string,string>>();T07
           Map<String,Map<string,string>> TemplateToDetailsMap = new Map<String,Map<string,string>>();//T07
           //Map<id,id> WorkplanTempToRecordId = new Map<id,id>();T07
            Map<String,id> WorkplanTempToRecordId = new Map<String,id>();//T07
           
            
            //get list of all work plan task templates for the combination of Object API Name and dml event
            //T04 added order by clause
            for(Workplan_Task_Template__c wtt : [SELECT Id,Status__c, Description__c, Task_Creation_Criteria_Expression__c, Task_Owner__c,
                                                 Task_Owner_Type__c,Stage__c,Acc_Team_Role_for_New_Business__c,
                                                 Acc_Team_Role_for_Renewal_Business__c, Send_Notification__c,
                                                 (SELECT Field_API_Name__c, Operation__c, Value__c,Rule_Number__c  
                                                  FROM Workplan_Task_Rules__r 
                                                  WHERE Object_API_Name__c = :strObjectType AND 
                                                  Object_DML_Event__c = :dmlEvent),
                                                 (Select Primary_Task__c,Dependent_Task__c from Dependent_Workplan_Tasks1__r)
                                                 FROM Workplan_Task_Template__c 
                                                 WHERE Related_Object_API_Name__c = :strObjectType AND Task_Creation_Events__c = :dmlEvent
                                                ORDER BY Number__c])
            {
                
           // Map<string,string> IdToDetails = new Map<string,string>();
            Id PrePostId;
            
                for(sObject newSobject : lstNewSObjects.values()){
                Map<string,string> IdToDetails = new Map<string,string>();
                    string ObjType;
                    Id sObjectId = newSobject.id;
                    
                    //T04
                    /*
                    for(Workplan_Task__c WTExist: wtt.Workplan_Tasks__r){
                        tempWptMap.put(WTExist.Workplan_Task_Template__c+WTExist.Opportunity_Implementation_ID__c,WTExist);
                        
                    }*/
                    
                    
                    //for each of the work plan task template, validate if the list of rules associated with it are passed
                    Map<String,Boolean> ruleMap = new Map<String,Boolean>();
                    if(String.isNotBlank(wtt.Task_Creation_Criteria_Expression__c)){
                        if(!wtt.Workplan_Task_Rules__r.isEmpty()){
                            for(Workplan_Task_Rules__c wptr : wtt.Workplan_Task_Rules__r) {
                           
                                if(wptr.Operation__c == Equals) {
                                    if(wptr.Value__c == String.valueOf(newSobject.get(wptr.Field_API_Name__c))) {
                                        RulesPassed = True;
                                    }
                                    else {
                                        RulesPassed = False;
                                    }
                                }
                                else if(wptr.Operation__c == NotEquals ) {
                                    if(wptr.Value__c != newSobject.get(wptr.Field_API_Name__c)) {
                                        RulesPassed = True;
                                    }
                                    else {
                                        RulesPassed = False;
                                    }
                                }
                                ruleMap.put(String.valueOf(wptr.Rule_Number__c),RulesPassed);
                            }
                        }
                        
                        //If the map is not empty, check the rules associated with the workplan task template 
                        if(!ruleMap.isEmpty() && String.isNotBlank(wtt.Task_Creation_Criteria_Expression__c)){
                       // system.debug('<<desc>>'+wtt.Description__c);
                        AIA_WorkplanTask_RulesCriteria RC = new AIA_WorkplanTask_RulesCriteria();
                           // RulesPassed = AIA_WorkplanTask_RulesCriteria.checkCritetia(ruleMap,wtt.Task_Creation_Criteria_Expression__c);
                            RulesPassed = RC.checkCritetia(ruleMap,wtt.Task_Creation_Criteria_Expression__c);
                            }
                        
                    } else {RulesPassed = True;}
                    
                    //system.debug('DeptStatusMap>>'+DeptStatusMap);
                    //system.debug('RulesPass>>'+RulesPassed);
                    
                    //If the rules passed, check whether dependent tasks are completed or not, if any dependent tasks are 
                    //present else continue with Workplan task creation
                     if(RulesPassed){
                        if(!wtt.Dependent_Workplan_Tasks1__r.isEmpty()){
                            for(Dependent_Workplan_Task__c dwt : wtt.Dependent_Workplan_Tasks1__r){
                            //system.debug('dwt>'+dwt);
                                if(primarystatusMap.containskey(''+dwt.Primary_Task__c+newSobject.id)){
                                 //system.debug(Logginglevel.ERROR ,'entered 1st cond');
                                    //T03
                                    Workplan_Task__c wpt = tempWptMap.get(''+dwt.Dependent_Task__c+newSobject.id);
                                    if (wpt!=null) {
                                        wptToNotrequired.add(wpt);
                                        //T04 If this is a primary task then add this to the not required list of primary tasks
                                        if (allPrimaryTaskIds.contains(wpt.Id)) primarystatusMap.put(''+dwt.Dependent_Task__c+newSobject.id, 'NotRequired');
                                    }
                                    RulesPassed = False;
                                   }
                                   if(starToNotstatusMap.containskey(''+dwt.Primary_Task__c+newSobject.id)){
                                    //system.debug(Logginglevel.ERROR ,'enterd 2nd cond');
                                    //T03
                                    Workplan_Task__c wpt = tempWptMap.get(''+dwt.Dependent_Task__c+newSobject.id);
                                    if (wpt!=null) wptToNotStarted.add(wpt);
                                    RulesPassed = False;
                                   }
                                   if(!DeptStatusMap.containskey(''+dwt.Primary_Task__c+newSobject.id)){
                                   //system.debug('samecond'+dwt.Primary_Task__c+newSobject.id);
                                  // system.debug('entered 3rd cond');
                                            RulesPassed = False;
                                            }
                                 if(!RulesPassed){break;}
                            }
                        }else RulesPassed = True;
                    }
                    
                    
                    //T01 changes start
                     //if all rules are passed then get the list of workplans for update. 
                    if(RulesPassed) {
                        string OwnerIdNumber;
                       // system.debug('entering passed condition>>>');
                        RulesPassedTempIds.add(wtt.Id);                     
                        Workplan_Task__c wt = new Workplan_Task__c();
                                               
                        //check the type of object in trigger context and assign the newly created workplan to respective object
                         if(strObjectType == AIA_Constants.Implementation){
                            wt.Implementation__c = newSobject.id;
                            wt.RelatedObjectId__c = newSobject.id;
                            PrePostId = newSobject.id;
                            ObjType = Implementationvar;
                            if(implMap.containsKey(newSobject.id))
                                wt.AccountID__c = implMap.get(newSobject.id).Account__c;
                                if(implMap.get(newSobject.id).opportunity__r.Business_Type__c == NewVariable)
                                {
                                    if(wt != NULL && wtt != NULL && mapAccountTeamRole.containsKey(wt.AccountID__c)) {
                                        if(mapAccountTeamRole.get(wt.AccountID__c).containsKey(wtt.Acc_Team_Role_for_New_Business__c)){
                                             OwnerIdNumber = mapAccountTeamRole.get(wt.AccountID__c).get(wtt.Acc_Team_Role_for_New_Business__c);
                                            wt.Task_Owner__c = wtt.Acc_Team_Role_for_New_Business__c;
                                        }
                                    }
                                }
                                else if(implMap.get(newSobject.id).opportunity__r.Business_Type__c == Renewal)
                                {                                    
                                    if(wt != NULL && wtt != NULL && mapAccountTeamRole.containsKey(wt.AccountID__c)) {
                                        if(mapAccountTeamRole.get(wt.AccountID__c).containsKey(wtt.Acc_Team_Role_for_Renewal_Business__c)) {
                                            OwnerIdNumber = mapAccountTeamRole.get(wt.AccountID__c).get(wtt.Acc_Team_Role_for_Renewal_Business__c);
                                            wt.Task_Owner__c = wtt.Acc_Team_Role_for_Renewal_Business__c;
                                        }
                                    }
                                }
                                
                        } else if(strObjectType == AIA_Constants.AIADocument){
                            wt.RelatedObjectId__c = newSobject.id;
                            wt.AIA_Document__c = newSobject.id;
                            ObjType = DocVar;
                            if(docMap.containsKey(newSobject.id)){
                                AIADoc = docMap.get(newSobject.id); 
                                wt.AccountID__c = AIADoc.Account__c;
                                
                                if(!String.isEmpty(AIADoc.Implementation__c)){
                                wt.Implementation__c = AIADoc.Implementation__c;
                                PrePostId = AIADoc.Implementation__c;
                                    if(AIADoc.Implementation__r.opportunity__r.Business_Type__c == NewVariable)
                                    {
                                   if(mapAccountTeamRole.get(wt.AccountID__c).containsKey(wtt.Acc_Team_Role_for_New_Business__c)){
                                         OwnerIdNumber = mapAccountTeamRole.get(wt.AccountID__c).get(wtt.Acc_Team_Role_for_New_Business__c);
                                        wt.Task_Owner__c = wtt.Acc_Team_Role_for_New_Business__c;
                                    }
                                    }else if(AIADoc.Implementation__r.opportunity__r.Business_Type__c == Renewal)
                                    {
                                        if(mapAccountTeamRole.get(wt.AccountID__c).containsKey(wtt.Acc_Team_Role_for_Renewal_Business__c)){
                                         OwnerIdNumber = mapAccountTeamRole.get(wt.AccountID__c).get(wtt.Acc_Team_Role_for_Renewal_Business__c);
                                        wt.Task_Owner__c = wtt.Acc_Team_Role_for_Renewal_Business__c;
                                      }
                                    }
                                }
                            }
                        } 
                        wt.Workplan_Task_Template__c = wtt.id;
                        //system.debug('wt >>> '+ wt  );   
                        
                        //Add the data from the workplan task tempalte to the map
                        IdToDetails.put(Descvar,wtt.Description__c);
                        IdToDetails.put(OwnerId,OwnerIdNumber);
                        IdToDetails.put(TOwner,wt.Task_Owner__c);
                        IdToDetails.put(ROID,wt.RelatedObjectId__c);
                        IdToDetails.put(AccId,wt.AccountID__c);
                        IdToDetails.put(ObjTypes,ObjType);
                       // system.debug('IdToDetails>>> '+ IdToDetails);
                         String uniqueKey = wtt.id + (String)sObjectId;//T07
                         /*T07 CHANGES START
                        if(!TemplateToDetailsMap.containsKey(wtt.id)){
                            TemplateToDetailsMap.put(wtt.Id,IdToDetails);
                        } else {
                            TemplateToDetailsMap.get(wtt.Id).putall(IdToDetails);
                        }
                       
                       WorkplanTempToRecordId.put(wtt.Id,newSobject.id);    
                    }*/
                    
                     if(!TemplateToDetailsMap.containsKey(uniqueKey)){ 
                            TemplateToDetailsMap.put(uniqueKey,IdToDetails);
                        } else {
                            TemplateToDetailsMap.get(uniqueKey).putall(IdToDetails);
                        }
                       
                       WorkplanTempToRecordId.put(uniqueKey,newSobject.id);    
                    }
                    //T07 CHANGES END
                    //reset variables
                    RulesPassed = False;
                    WorkPlanExist = False;
                    ObjtoIdMap.put(ObjTypes,sObjectId);
                    prepostIds.add(PrePostId);
                } 
               // system.debug('last TemplateToDetailsMap>>> '+ TemplateToDetailsMap);
              
            }
           
            
            //If map is not empty, get the workplan tasks and populate the field values depending upon the creteria and update the waorkplan tasks
            if(!TemplateToDetailsMap.isEmpty()){
                system.debug('map:'+TemplateToDetailsMap);
                system.debug('prepostIds:'+prepostIds);
                system.debug('RulesPassedTempIds:'+RulesPassedTempIds);
                for(Workplan_Task__c WpTask : [select id,Status__c,Workplan_Task_Template__c,Opportunity__c,Sub_Process__c,Process__c,Task_Type__c,RelatedObjectId__c,Description__c,Opportunity_Implementation_ID__c from Workplan_Task__c 
                                              where Opportunity_Implementation_ID__c IN:prepostIds AND Opportunity_Implementation_ID__c !=null AND Status__c = :NotStarted AND Workplan_Task_Template__c IN:RulesPassedTempIds]){
                    //system.debug('WpTask:'+WpTask);
                    //if rules of workplan task tempalate are satisfied  and workplan task description is same as of rules satisfied WPT, then update run time WP task
                  /*T07 CHANGES START
                    if(TemplateToDetailsMap.containskey(WpTask.Workplan_Task_Template__c) && WpTask.Description__c == TemplateToDetailsMap.get(WpTask.Workplan_Task_Template__c).get(Descvar)){
                       string value = string.valueof(TemplateToDetailsMap.get(WpTask.Workplan_Task_Template__c).get(OwnerId));
                        if(value !='' && value !=null){
                        if(WpTask.Task_Type__c == AutoClose ){
                         WpTask.Status__c = Completed;
                         WpTask.Task_Owner__c = TemplateToDetailsMap.get(WpTask.Workplan_Task_Template__c).get(TOwner);
                         WpTask.OwnerId = TemplateToDetailsMap.get(WpTask.Workplan_Task_Template__c).get(OwnerId);
                         WpTask.RelatedObjectId__c = TemplateToDetailsMap.get(WpTask.Workplan_Task_Template__c).get(ROID);
                         WpTask.AccountID__c = TemplateToDetailsMap.get(WpTask.Workplan_Task_Template__c).get(AccId);
                         WpTask.Click_the_Link__c = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/'+TemplateToDetailsMap.get(WpTask.Workplan_Task_Template__c).get(ObjTypes)+'/'+WorkplanTempToRecordId.get(WpTask.Workplan_Task_Template__c)+'/view' ;
                         procset.add(WpTask.Process__c);
                         subprocset.add(WpTask.Sub_Process__c);
                         lstWT_ToCreate.add(WpTask);
                        }else {
                           
                            WpTask.Status__c = InProgress;
                            WpTask.Task_Owner__c = TemplateToDetailsMap.get(WpTask.Workplan_Task_Template__c).get(TOwner);
                            WpTask.OwnerId = TemplateToDetailsMap.get(WpTask.Workplan_Task_Template__c).get(OwnerId);
                            WpTask.RelatedObjectId__c = TemplateToDetailsMap.get(WpTask.Workplan_Task_Template__c).get(ROID);
                            WpTask.AccountID__c = TemplateToDetailsMap.get(WpTask.Workplan_Task_Template__c).get(AccId);
                            WpTask.Click_the_Link__c = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/'+TemplateToDetailsMap.get(WpTask.Workplan_Task_Template__c).get(ObjTypes)+'/'+WorkplanTempToRecordId.get(WpTask.Workplan_Task_Template__c)+'/view' ;
                            */
                            
                            String uniqkey = WpTask.Workplan_Task_Template__c+WpTask.Opportunity_Implementation_ID__c;
                    if(TemplateToDetailsMap.containskey(uniqkey) && WpTask.Description__c == TemplateToDetailsMap.get(uniqkey).get(Descvar)){
                       string value = string.valueof(TemplateToDetailsMap.get(uniqkey).get(OwnerId));
                        if(value !='' && value !=null){
                        if(WpTask.Task_Type__c == AutoClose ){
                         WpTask.Status__c = Completed;
                         WpTask.Task_Owner__c = TemplateToDetailsMap.get(uniqkey).get(TOwner);
                         WpTask.OwnerId = TemplateToDetailsMap.get(uniqkey).get(OwnerId);
                         WpTask.RelatedObjectId__c = TemplateToDetailsMap.get(uniqkey).get(ROID);
                        WpTask.AccountID__c = TemplateToDetailsMap.get(uniqkey).get(AccId);
                         WpTask.Click_the_Link__c = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/'+TemplateToDetailsMap.get(uniqkey).get(ObjTypes)+'/'+WorkplanTempToRecordId.get(uniqkey)+'/view' ;
                        procset.add(WpTask.Process__c);
                         subprocset.add(WpTask.Sub_Process__c);
                         lstWT_ToCreate.add(WpTask);
                        }else {
                           
                            WpTask.Status__c = InProgress;
                            WpTask.Task_Owner__c = TemplateToDetailsMap.get(uniqkey).get(TOwner);
                            WpTask.OwnerId = TemplateToDetailsMap.get(uniqkey).get(OwnerId);
                            WpTask.RelatedObjectId__c = TemplateToDetailsMap.get(uniqkey).get(ROID);
                            WpTask.AccountID__c = TemplateToDetailsMap.get(uniqkey).get(AccId);
                            WpTask.Click_the_Link__c = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/'+TemplateToDetailsMap.get(uniqkey).get(ObjTypes)+'/'+WorkplanTempToRecordId.get(uniqkey)+'/view' ;
                             //T07 Changes End
                            procset.add(WpTask.Process__c);
                            subprocset.add(WpTask.Sub_Process__c);
                            lstWT_ToCreate.add(WpTask);
                            
                        }
                        }
                       
                    }
                }
            }
            
            //T05 Start
            Map<Id,Workplan_Task__c> wpTasks_To_Update = new Map<Id,Workplan_Task__c>();
            //T05 End
            if(!lstWT_ToCreate.isEmpty()) {
                //T05 Start
                //Database.update(lstWT_ToCreate,false);
                system.debug('lstWT_ToCreate@@'+ lstWT_ToCreate);
                for(Workplan_Task__c task : lstWT_ToCreate)
                {
                    wpTasks_To_Update.put(task.id,task);
                }
                //T05 End
            } 
            
            if(!procset.isEmpty()){
                list<Process__c> proclist = [select id, Status__c from Process__c where id IN :procset];
                for(Process__c plst:proclist){
                    if(plst.Status__c==NotStarted){
                        plst.Status__c = 'In-Progress';
                        proc_toUpdate.add(plst);
                    }
                }
            }
            
            if(!subprocset.isEmpty()){
                list<Sub_Process__c> subproclist = [select id, Status__c from Sub_Process__c where id IN :subprocset];
                for(Sub_Process__c splst:subproclist){
                    if(splst.Status__c==NotStarted){
                        splst.Status__c = 'In-Progress';
                        //T02-- Start -- Updating Sub process start date as part of US182
                        splst.AIA_Sub_Process_Start_date__c = System.today();
                        //T02-- End 
                        subproc_toUpdadte.add(splst);
                    }
                }
            }
            
            if(!wptToNotrequired.isEmpty()){
                for(Workplan_Task__c wt:wptToNotrequired){
                    //system.debug(Logginglevel.ERROR ,'++wt++'+wt);
                    wt.Status__c = NotRequired;
                    MarkNotRequired.add(wt);
                    wpTasks_To_Update.put(wt.id,wt);//T05
                
                }
            }
            
            if(!wptToNotStarted.isEmpty()){
                for(Workplan_Task__c wt:wptToNotStarted){
                    //system.debug('++wt++'+wt);
                    wt.Status__c = NotStarted;
                    MarkNotStarted.add(wt);
                    wpTasks_To_Update.put(wt.id,wt);//T05
                }
            }
            
            if(!proc_toUpdate.isEmpty()){
                system.debug(Logginglevel.error,'proc_toUpdate@@ 5425'+ proc_toUpdate);
                Database.update(proc_toUpdate,false);
            }
            
            if(!subproc_toUpdadte.isEmpty()){
                system.debug(Logginglevel.error,'subproc_toUpdadte@@ 5425'+ subproc_toUpdadte);
                Database.update(subproc_toUpdadte,false);
            }
            
            //T05 Start
            /*if(!MarkNotRequired.isEmpty()){
                //Database.update(MarkNotRequired,false);
            }
            
            if(!MarkNotStarted.isEmpty()){
                //Database.update(MarkNotStarted,false);
            }*/
            
            if(!wpTasks_To_Update.isEmpty())
            {
               Database.update(wpTasks_To_Update.values() ,false); 
            }
            //T05 End
            //T01 Changes End
        }
        catch(Exception e){
            system.debug('Main Error'+e.getMessage()+'Line Number'+e.getLineNumber());
            AIA_Utils util=new AIA_Utils();util.logException(e); }
            } 
}