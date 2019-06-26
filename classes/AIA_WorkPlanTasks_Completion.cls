/*=================================================================================================================
* Date         : 09/11/2017
* Developer    : Satya Tirumalasetti
* Purpose      : This class is used to complete workplan tasks when the conditions are satisfied 
*============+================+=====+=============================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 09/21/2017 | Satya          |     | Initial Version
* 10/26/2018 | Paritosh       | T01 | Added SOQL clause for not required
*===========+============+========================================================================================
*/
public without sharing class AIA_WorkPlanTasks_Completion{ 
    
    public static final String TaskName = 'Manual / SF should auto close this task';
    public static final String TaskCriteria = 'Task Completion Criteria';
    public static final String Equals = 'Equal To';
    public static final String NotEquals = 'Not Equal To';
    public static final String Completed = 'Completed';
    public static final String NotRequired = 'Not Required';
    
    /*This method is used to complete the workplan tasks when the completion Rules of its associated workplan task template are satisfied*/
    public void completionWorkplanTasksForSObject(String dmlEvent,list<sObject> lstSobjs, String strObjectType){
        system.debug(Logginglevel.ERROR ,'Entered Completion method wp'); 
        Map<id,Workplan_Task__c> mapWT_ToCreate = new Map<id,Workplan_Task__c>();
        list<Workplan_Task__c> lstToCreate = new list<Workplan_Task__c>();
       // list<Workplan_Task__c> WPTtoComplete = new list<Workplan_Task__c>();
        Set<string> WptId = new Set<string>();
        Boolean RulesPassed = False;
        Boolean RulesRequired = False;
        id objId;
        set<string> Idset = new set<string>();
        
        
        try{
            
            //Loop through all the records in trigger context and get their Id's
            for(sObject s:lstSobjs) {Idset.add(s.id);}
            
            //system.debug('@@Idset'+Idset);
            
            //Get the workplan task record present in the trigger context where status is not completed
            //T01
            for(Workplan_Task__c Wp :[select id,Workplan_Task_Template__c from Workplan_Task__c where RelatedObjectId__c IN :Idset and Status__c != :Completed AND Status__c!=:NotRequired])
            {
                
                WptId.add(Wp.Workplan_Task_Template__c);
                
            }
            
            //system.debug('@@WptId'+WptId);
            //get the associated WorkPlan Task Template of the workplan tasks.
            //T01
            for(Workplan_Task_Template__c wtt : [SELECT Status__c, Description__c,Task_Type__c, Task_Creation_Criteria_Expression__c,Task_Completion_Expression__c, Task_Owner__c,
                                                 Related_Object_API_Name__c,
                                                 (SELECT Field_API_Name__c, Operation__c, Value__c,Rule_Number__c,Criteria_Type__c,Object_API_Name__c
                                                  FROM Workplan_Task_Rules__r 
                                                  WHERE Criteria_Type__c = :TaskCriteria),
                                                 (select id,Status__c,Workplan_Task_Template__c,Opportunity__c from Workplan_Tasks__r where Status__c != :Completed AND Status__c!=:NotRequired
                                                  AND RelatedObjectId__c IN :Idset) 
                                                 FROM Workplan_Task_Template__c 
                                                 WHERE id IN :WptId AND Task_Type__c =:TaskName  AND (Task_Completion_Expression__c !='')])
            {
                //system.debug('@@workplantemplates to complete--'+ wtt.Workplan_Task_Rules__r);
                list<Workplan_Task__c> WPTtoComplete = new list<Workplan_Task__c>();
                for(Workplan_Task__c Ws :wtt.Workplan_Tasks__r) { WPTtoComplete.add(Ws);}
                //system.debug('@@tasks to complete--'+WPTtoComplete.size());
                //system.debug('@@tasks to complete--'+WPTtoComplete);
                
                for(sObject sobjectRec : lstSobjs){                     
                    //If task completion rules are present, check whether conditions are satisfied to complete the tasks.
                    Map<String,Boolean> ruleMap = new Map<String,Boolean>();
                    //system.debug('@@wtt.Workplan_Task_Rules__r'+wtt.Workplan_Task_Rules__r);
                    if(!wtt.Workplan_Task_Rules__r.isEmpty()){
                    //system.debug('@@wtt.Workplan_Task_Rules__r'+wtt.Workplan_Task_Rules__r);
                        for(Workplan_Task_Rules__c wptr : wtt.Workplan_Task_Rules__r) {
                        if(!(wptr.Object_API_Name__c != wtt.Related_Object_API_Name__c) ){
                            RulesRequired = True;
                        //system.debug('@@wptr'+wptr);
                            if(wptr.Operation__c == Equals) {
                                if(wptr.Value__c == String.valueOf(sobjectRec.get(wptr.Field_API_Name__c))) {
                                    RulesPassed = True;
                                }
                                else {
                                    RulesPassed = False;
                                }
                            }
                            else if(wptr.Operation__c == NotEquals) {
                                if(wptr.Value__c != sobjectRec.get(wptr.Field_API_Name__c)) {
                                    RulesPassed = True;
                                }
                                else {
                                    RulesPassed = False;
                                }
                            }
                            ruleMap.put(String.valueOf(wptr.Rule_Number__c),RulesPassed);
                         }
                         else {
                                    RulesPassed = False;
                              }
                        }
                    } 
                    
                    //If all workplan task rules conditions are satisfied, check whether the task completion expression is satisfied or not                    
                    if(!ruleMap.isEmpty() && String.isNotBlank(wtt.Task_Completion_Expression__c) && RulesRequired) {
                    //system.debug('@@wtt.Task_Completion_Expression__c'+wtt.Task_Completion_Expression__c);
                         AIA_WorkplanTask_RulesCriteria RC = new AIA_WorkplanTask_RulesCriteria();
                        //RulesPassed = AIA_WorkplanTask_RulesCriteria.checkCritetia(ruleMap,wtt.Task_Completion_Expression__c);
                        RulesPassed = RC.checkCritetia(ruleMap,wtt.Task_Completion_Expression__c);
                    
                    //system.debug('@@RulesPassedafter'+RulesPassed);
                    }
                    //If all rules passed, mark the status of workplan task as completed.
                    if(RulesPassed ) {    
                        for(Workplan_Task__c wt : WPTtoComplete){
                            Workplan_Task__c wt1 = new Workplan_Task__c(Id = wt.id);
                            wt1.Status__c = Completed;
                            mapWT_ToCreate.put(wt1.id,wt1);
                            //system.debug('@@listofcreation'+ mapWT_ToCreate);
                        } 
                    }
                    
                    //reset variable
                    RulesPassed = False;
                    RulesRequired = False;
                }   
                
                
            }
            //system.debug('@@lsWT_ToCreate'+mapWT_ToCreate);
            //system.debug('@@listsize'+ mapWT_ToCreate.size());
                //Insert the lsit.
                if(!mapWT_ToCreate.isEmpty()) 
                { 
                    lstToCreate.addall(mapWT_ToCreate.values());
                    system.debug(Logginglevel.ERROR ,'Entered Completion method wp upsert 1'); 
                    upsert lstToCreate; 
                }
        } 
        catch(Exception e){AIA_Utils util=new AIA_Utils();util.logException(e);system.debug('exc'+e); }
            }
    
    
    /*This method is used to complete the AIA Documents workplan tasks when the completion Rules of its associated workplan task template are satisfied*/ 
    public void completionWorkplanTasksForAIADocument(String dmlEvent,list<AIA_Document__c> lstSobjs, String strObjectType){
        system.debug(Logginglevel.ERROR ,'Entered Completion method aia doc wp'); 
        List<Workplan_Task__c> WPTtoComplete = new List<Workplan_Task__c>();
        Boolean RulesPassed = False;
        Set<string> lstWPT = new Set<string>();
        Set<string> docidlst = new Set<string>();
        List<AIA_Document__c> doclst1 = new List<AIA_Document__c>();
        string idToMap;
        Set<ID> idAIADocSet = new Set<ID>();
        Set<ID> wttID = new Set<ID>();
        Set<ID> wtID = new Set<ID>();
        map<string,id> mapStrToID = new map<string,id>();
        
        try{
            
            //Get all the records in the trigger context and add them to a list
            for (AIA_Document__c doc : lstSobjs){docidlst.add(doc.id);}
            //system.debug('@@docidlst--'+docidlst);
            
            //Get all the AIA Documents and for each doc, check from where it was created and assign that record ID to a string                
            for (AIA_Document__c doclst :[select id,opportunity__c,Benefit_Request_Form__r.opportunity__c,Benefit_Design__c,Benefit_Design_Form__c,
                                          Benefit_Design_Product__c,Proposed_Products__c,Proposal_Request_Form__c,Implementation__c,
                                          Benefit_Design_Form__r.Benefit_Design__r.Implementation__c,Benefit_Design_Product__r.Benefit_Design__r.Implementation__c,
                                          Benefit_Design__r.Implementation__c,Proposal_Request_Form__r.opportunity__c,Proposed_Products__r.Benefit_Request_Form__r.opportunity__c
                                          from AIA_Document__c where id IN :docidlst])
            {
                if(!string.isBlank(doclst.Proposed_Products__c )){idAIADocSet.add(doclst.Proposed_Products__r.Benefit_Request_Form__r.opportunity__c);}
                else if(!string.isBlank(doclst.Benefit_Request_Form__c )){idAIADocSet.add(doclst.Benefit_Request_Form__r.opportunity__c );}
                else if(!string.isBlank(doclst.Benefit_Design_Product__c )){idAIADocSet.add(doclst.Benefit_Design_Product__r.Benefit_Design__r.Implementation__c);}
                else if(!string.isBlank(doclst.Benefit_Design_Form__c )){idAIADocSet.add(doclst.Benefit_Design_Form__r.Benefit_Design__r.Implementation__c);}
                else if(!string.isBlank(doclst.Benefit_Design__c )){idAIADocSet.add(doclst.Benefit_Design__r.Implementation__c );}
                else if(!string.isBlank(doclst.Implementation__c)){idAIADocSet.add(doclst.Implementation__c);}
                else if(!string.isBlank(doclst.opportunity__c)){idAIADocSet.add(doclst.opportunity__c);}
                else if(!string.isBlank(doclst.Proposal_Request_Form__c )){idAIADocSet.add(doclst.Proposal_Request_Form__r.opportunity__c );}
                
                
            }
            
            //system.debug('idAIADocSet--'+idAIADocSet);
            //Get all work plan tasks from the opportunity/implementation
            //T01
            for (Workplan_Task__c Wp : [SELECT id,Status__c,Workplan_Task_Template__c,Opportunity__c,RelatedObjectId__c,Implementation__c,Description__c  from Workplan_Task__c
                                         WHERE (Opportunity__c IN :idAIADocSet OR Implementation__c IN :idAIADocSet) AND Task_Type__c = :TaskName AND Status__c!=:NotRequired])
            {
                wttID.add(Wp.Workplan_Task_Template__c);
                wtID.add(Wp.id);
            }
            //system.debug('@@wtID-'+wtID);
            system.debug('@@wttID-'+wttID);
            //get list of all work plan task templates for the combination of Object API Name and dml event
            for(Workplan_Task_Template__c wtt : [SELECT Status__c, Description__c, Task_Creation_Criteria_Expression__c, Task_Owner__c,
                                                 Task_Owner_Type__c,Task_Completion_Expression__c,
                                                 (SELECT Field_API_Name__c, Operation__c, Value__c,Rule_Number__c  
                                                  FROM Workplan_Task_Rules__r 
                                                  WHERE Criteria_Type__c = :TaskCriteria AND Object_API_Name__c = :strObjectType),
                                                 (select id,Status__c,Workplan_Task_Template__c,Opportunity__c,RelatedObjectId__c,Description__c from Workplan_Tasks__r
                                                  WHERE id IN :wtID AND Status__c != :Completed AND Status__c!=:NotRequired) 
                                                 FROM Workplan_Task_Template__c 
                                                 WHERE id IN :wttID])
            {
            
                for(sObject newSobject : lstSobjs){
                Map<String,Boolean> ruleMap = new Map<String,Boolean>();
                //system.debug('@@wtt-'+wtt);
                //system.debug('@@wtt.Workplan_Task_Rules__r-'+wtt.Workplan_Task_Rules__r);
                //check if the rules are satisfied to mark task as completed
                 if(!wtt.Workplan_Task_Rules__r.isEmpty()){
                    for(Workplan_Task_Rules__c wptr : wtt.Workplan_Task_Rules__r) {
                           //system.debug('@@wptr-'+wptr);
                            if(wptr.Operation__c == Equals) {
                                if(wptr.Value__c == String.valueOf(newSobject.get(wptr.Field_API_Name__c))) {
                                    RulesPassed = True;
                                }else {
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
                     //system.debug('@@RulesPassed' + RulesPassed);
                     //system.debug('@rulemapp-'+ruleMap);
                 }
                 
                 if(!ruleMap.isEmpty() && String.isNotBlank(wtt.Task_Completion_Expression__c)){
                  AIA_WorkplanTask_RulesCriteria RC = new AIA_WorkplanTask_RulesCriteria();
                 //system.debug('@@wtt.Task_Completion_Expression__c' + wtt.Task_Completion_Expression__c);
                       // RulesPassed = AIA_WorkplanTask_RulesCriteria.checkCritetia(ruleMap,wtt.Task_Completion_Expression__c);
                       RulesPassed = RC.checkCritetia(ruleMap,wtt.Task_Completion_Expression__c);
                        //system.debug('@@RulesPassed2' + RulesPassed);
                 }  
                    if(RulesPassed){
                       for(Workplan_Task__c wpt :wtt.Workplan_Tasks__r){
                           wpt.Status__c = Completed;
                           WPTtoComplete.add(wpt); //If completed, add  them to the list to update
                           
                       }
                    } 
                  RulesPassed = False;                  
                }
                
            }
            
            //If list is not empty, upsert the list
            if(!WPTtoComplete.isEmpty()) {
                upsert WPTtoComplete; 
               }  
        }catch(Exception e){AIA_Utils util=new AIA_Utils();util.logException(e);system.debug('exce'+e); }    }

}