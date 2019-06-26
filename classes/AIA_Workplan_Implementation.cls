/*===========================================================================================================
 * Date         : 05/31/2016
 * Developer    : Chidananda Nagaaj
 * Purpose      : This class is the extension point of the All the AIA_Implementation Trigger Framework - 
                   ImplementationTriggerHandler.. *
 *===========================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date        Developer     Tag   Description
 *============+============+=====+===========================================================================
 * 05/31/16   |  GN        |     | Initial Version                                         
 * 12/11/16   |  RP        |     | Implementation created by NCR Case will have business type "NCR"
 * 01/23/2017 |  RP        |     | Updated the logic to pull the business type only when Implementation is  
 *                                 created not at update
 * 01/26/2017 |  RP        |     | Updated the logic to update the business type field auto-population in  
 *                                 insert and values pulled from BRF instead of Opportunity
 * 06/18/2017 | Asif K     | T01 | Fixed defect:For Implementation Risk Type & Business Type are not copying
 *                                 from associated BRF in multiple sold BRF scenario
 * 04/16/2018 | Gayathri P | T02 | Commenting lines related to WP Task as per US 209.
 *============+============+=====+===========================================================================
*/

public class AIA_Workplan_Implementation
{
    private static final string BUSINESS_RISK_ERROR_MSG = 'Risk Type field is required';
    public static Integer i=1;
    
    /*****    
    * @This Method is called from ImplementationTriggerHandler class - AfterInsert Method 
    * @This Method that allows workplan stages(Process & Sub-process records) to be created automatically on that 
    *  Implementation w.r.t Workplan type Assigned (Refer above method) 
    * @param ListImp - Input the list of Implementations 
    * @Output - Creating the Workplan stages(Process & Sub-process records) and updating the sub-process records 
    *  with their respective parent process(Hint:sub-processes roll up to a particular process)
    ******/
    public void createWorkplanStages(List<AIA_Implementation__c> listImp,list<AIA_Implementation__c> oldListImp)
    {   
        /* T02-- Start
        i++;
        System.debug('Called createWorkplanStages');
     
        //Getting the RecordTypes -Id's of - WorkPlan Type Stage object 
        // TODO: Add comments for each of the variables.
        Schema.DescribeSObjectResult WPTSdSobjres = Schema.SObjectType.Workplan_Type_Stage__c; 
        Map<String,Schema.RecordTypeInfo> WPTSRecordType = WPTSdSobjres.getRecordTypeInfosByName();
        Id ProcesswptsRtid = WPTSRecordType.get('Process').getRecordTypeId();                          //Getting the Process RecordTypeID
        Id SubProcesswptsRtid = WPTSRecordType.get('Sub-Process').getRecordTypeId();                   //Getting the Sub-Process RecordTypeID
        
        //Getting the RecordTypes -Id's of - WorkPlan Stage  object
        Schema.DescribeSObjectResult WPSdSobjres = Schema.SObjectType.Workplan_Stage__c; 
        Map<String,Schema.RecordTypeInfo> WPSRecordType = WPSdSobjres.getRecordTypeInfosByName(); 
        Id ProcesswpsRtid = WPSRecordType.get('Process').getRecordTypeId();                             //Getting the Process RecordTypeID
        Id SubProcesswpsRtid = WPSRecordType.get('Sub-Process').getRecordTypeId();                      //Getting the Sub-Process RecordTypeID
            
        // TODO: Add comment for what each of these variables stores and what it is used for
        List<AIA_Implementation__c> opplist = new List<AIA_Implementation__c>();                                                  //List of opportunities 
        Map<id,List<Workplan_Type_Stage__c>> wptidwptstagesMap = new Map<id,List<Workplan_Type_Stage__c>>();  //Map for id's and list of WorkPlan Type Stage
        Set<id> wpTypeidset = new Set<id>();                                                                  //set of id's to get opp Id's which has workplan type's
        List<Workplan_Stage__c> tocreate = new List<Workplan_Stage__c>();                                     // List to create WorkPlan Stages for output 
        Map<id,Workplan_Type_Stage__c> wptsMap = new Map<id,Workplan_Type_Stage__c>();                        // Map for workplan Type Stages and their Id's
        
        System.debug('listImp----AIA_Implementation__c-->'+listImp);
        
        // Add all AIA_Implementation__c that have a workplan type to the Opplist list
        for(AIA_Implementation__c opp: listImp)
        {
        if(oldListImp!=null){
            system.debug('@@ inside oldListImp');
        for(AIA_Implementation__c oldOpp: oldListImp){
          if(opp.Workplan_Type__c !=null && oldOpp.id==opp.id && oldOpp.Generate_Workplan_Stages__c==false && opp.Generate_Workplan_Stages__c!=false)
            {
                system.debug('@@ inside if');
                opplist.add(opp);                          //Adding all the list of opp where workplan type not equals null
                wpTypeidset.add(opp.Workplan_Type__c);     //Adding all the set of opp Id's which has workplan type's
            }
        }
        system.debug('@@ oppList'+opplist);
        system.debug('@@wpTypeIdset'+wpTypeIdset);
        }
        else{
            if(opp.Workplan_Type__c !=null){
                opplist.add(opp);                          //Adding all the list of opp where workplan type not equals null
                wpTypeidset.add(opp.Workplan_Type__c);     //Adding all the set of opp Id's which has workplan type's
            }
        }
        }
        
        // If list is not empty  --- Make changes to All ****************************check this Line***********************
        //if(wpTypeidset != null && wpTypeidset.size()>0)
        if (!wpTypeIdset.isEmpty())
        {
            //Query the particular set of workPlan type Stage id's  from above "wpTypeidset"
            List<Workplan_Type_Stage__c> wptstages=[SELECT id,RecordTypeId,Display_Order__c,Workplan_Type__c,
                                                            All_Assignments_Must_Be_Completed__c,Parent_Workplan_Type_Stage__c 
                                                    FROM Workplan_Type_Stage__c 
                                                    WHERE Workplan_Type__c IN :wpTypeidset AND 
                                                          Active__c=true ];
            // Add all Workplan Type Stages field values to Map
            wptsMap.putAll(wptstages);
            
            //Looping WorkPlan Type Stage from above list -"wptstages" and adding them to map
            for(Workplan_Type_Stage__c obj:wptstages){
                if(wptidwptstagesMap.containskey(obj.Workplan_Type__c))
                {
                    wptidwptstagesMap.get(obj.Workplan_Type__c).add(obj);                                  //Getting workplan type into Map
                }
                else{
                    wptidwptstagesMap.put(obj.Workplan_Type__c,new List<Workplan_Type_Stage__c>{obj});     // Else creating the new list of Workplan type Stages into Map
                }
            }
        }
        
        //Looping each AIA_Implementation__c,If opp contains particular Workplan type-Then creating Workplan stages underneath opp W.R.T WorkPlan type Stages  
        for(AIA_Implementation__c opp:opplist)
        {
         if(opp.Generate_Workplan_Stages__c)
         {
            If(wptidwptstagesMap.containskey(opp.Workplan_Type__c))
            {                              
                //Checking whether opp.Workplan_Type__c  is/Contains in wptidwptstagesMap or not 
                for(Workplan_Type_Stage__c wps:wptidwptstagesMap.get(opp.Workplan_Type__c))
                {      
                    //if it contains Looping WorkPlan type stages and creating Workplan stages with some Mapping
                    //Assigning the Values to Workplan stage from Workplan Type Stage
                    Workplan_Stage__c ws       = new Workplan_Stage__c();
                    ws.Opportunity__c          = opp.Opportunity__c;
                    ws.Implementation__c       = opp.id;
                    ws.Workplan_Type_Stage__c  = wps.id;
                    ws.Workplan_Type__c        = wps.Workplan_Type__c;
                    ws.Status__c               = 'Not Started';
                    ws.All_Assignments_Must_Be_Completed__c = wps.All_Assignments_Must_Be_Completed__c;
                    ws.Display_Order__c        = wps.Display_Order__c;
                    
                    //Assigning the Process RecordTypeId's of (Workplan_Type_Stage__c) to  process RecordTypeId's - WS(workplan_stage__c)
                    if(wps.RecordTypeId ==ProcesswptsRtid )
                    {
                        ws.RecordTypeId = ProcesswpsRtid ;
                    }
                    //Assigning the Sub-Process RecordTypeId's of (Workplan_Type_Stage__c) to  sub-process RecordTypeId's-(workplan stage)
                    else if(wps.RecordTypeId ==SubProcesswptsRtid )
                    {
                        ws.RecordTypeId = SubProcesswpsRtid ;
                    }
                    tocreate.add(ws);        //Adding the list of Workplan stages
                }
             }
           }
        }
        System.debug('--IsInsert-->'+Trigger.IsInsert);
        System.debug('--IsAfter-->'+Trigger.IsAfter);
        System.debug('--size of list-->'+tocreate.size());
        //Creating Workplan stage 
        //if(tocreate != null && tocreate.size()>0)
        if (!toCreate.isEmpty())
        {
            insert tocreate;
            Map<id,id> parentMap = new Map<id,id>();
            for(Workplan_Stage__c ws:tocreate)
            {
                if(ws.RecordTypeId == ProcesswpsRtid)
                {
                    parentMap.put(ws.Workplan_Type_Stage__c, ws.id);
                }
            }
            //Updating the Sub-Processes records with their parent workplan type stages
            for(Workplan_Stage__c ws:tocreate){
                if(ws.RecordTypeId == SubProcesswpsRtid  && ws.Workplan_Type_Stage__c != null && wptsMap.containskey(ws.Workplan_Type_Stage__c) )
                {
                    ws.Parent_Workplan_Stage__c = parentMap.get(wptsMap.get(ws.Workplan_Type_Stage__c).Parent_Workplan_Type_Stage__c);
                }
            }
            
            try{
                update tocreate; 
            }
            catch(Exception ex){
                System.debug(' \n CLog : '+ex.getMessage());
            }
        }
		T02 -- End*/
      }
      
      public static void updateImplFields(List<AIA_Implementation__c> nlistImp){
        try{
        //Getting the RecordTypes -Id's of - Opportunity  object
        Schema.DescribeSObjectResult objResult = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> objRecordType = objResult.getRecordTypeInfosByName(); 
        Id opp200RecTypId = objRecordType.get('200+').getRecordTypeId();                         //Getting the 200+ RecordTypeID
        Id opp50RecTypId = objRecordType.get('51+').getRecordTypeId();                         //Getting the 50+ RecordTypeID
        
        //Getting the RecordTypes -Id's of - Benfit_Request_Form__c  object
        Schema.DescribeSObjectResult brfObjResult = Schema.SObjectType.Benfit_Request_Form__c; 
        Map<Id,Schema.RecordTypeInfo> brfObjRecordType = brfObjResult.getRecordTypeInfosById();
        
        //01/26/2017 @ Rajesh starts here
        map<string,Benfit_Request_Form__c> mapBrfIdWithBRF;
        set<Id> BrfIdSet = new set<Id>(); 
        //01/26/2017 @ Rajesh ends here
        
        set<Id> x200RecTypeOppIdSet = new set<Id>(); //Set of Opportunity Ids where record Type is 200+
        set<Id> otherOppIdSet = new set<Id>();      //Set of Opportunity Ids where record Type is  NOT 200+
        set<Id> oppIdSet = new set<Id>();
              
        for(AIA_Implementation__c imp : nlistImp){
            if(imp.Opportunity__c != NULL){
                oppIdSet.add(imp.Opportunity__c);
            }
        }
        map<Id,Opportunity> oppMap = new map<Id,Opportunity>([Select Id,RecordTypeId,Business_Type__c from opportunity where Id IN: oppIdSet]);
        if(oppMap != NULL && oppMap.size()> 0 ){
            for(Opportunity opp: oppMap.values()){
                if(opp.RecordTypeId == opp200RecTypId)
                    x200RecTypeOppIdSet.add(opp.Id);
                //else
                //    otherOppIdSet.add(opp.Id);
            }
        }
        
        // 01/26/2017 Rajesh Changes  starts 
        for(AIA_Implementation__c ii:nlistImp){
            BrfIdSet.add(ii.Benefit_Request_Form__c);
        }
        //Get map of BRFs-T01
        if(!BrfIdSet.isEmpty()){
            mapBrfIdWithBRF = new map<string,Benfit_Request_Form__c>([SELECT Id,Name,Request_Type__c,RecordTypeId 
                                                                      FROM Benfit_Request_Form__c 
                                                                      WHERE Id IN :BrfIdSet]);
        }
        // Rajesh Changes end 
        system.debug('mapBrfIdWithBRF=='+mapBrfIdWithBRF);
        system.debug('oppMap=='+oppMap);
        
        for(AIA_Implementation__c imp : nlistImp){
            if(oppMap!=NULL && oppMap.size()>0 && oppMap.containsKey(imp.Opportunity__c)){
                
                /* 01/23/2016 Rajesh Changes  starts + T01 */
               //@Rajesh 01/23/2016 Added If condition to make the business update only on insert and not on update
                if( !trigger.isUpdate){
                    system.debug('in if before ncr checking');
                    if(imp.Business_Type__c != 'NCR'){
                        system.debug('in if before ncr checking='+mapBrfIdWithBRF.get(imp.Benefit_Request_Form__c).Request_Type__c);
                        if(mapBrfIdWithBRF.containsKey(imp.Benefit_Request_Form__c)){
                            if(mapBrfIdWithBRF.get(imp.Benefit_Request_Form__c).Request_Type__c == 'RFP'){
                                imp.Business_Type__c =  'Prospect/New';    
                            }else if(mapBrfIdWithBRF.get(imp.Benefit_Request_Form__c).Request_Type__c == 'Renew As-is'){
                                imp.Business_Type__c =  'Renewal';    
                            }else{
                                imp.Business_Type__c =  mapBrfIdWithBRF.get(imp.Benefit_Request_Form__c).Request_Type__c;    
                            }
                        }
                    } 
                }
                // Rajesh Changes end 
                
                //if opportunity is of 200+ recordType then populate fields
                if(oppMap.get(imp.Opportunity__c).RecordTypeId == opp200RecTypId && 
                   brfObjRecordType !=NULL && 
                   brfObjRecordType.size() > 0  
                   )
                {
                    //T01
                    if(mapBrfIdWithBRF.containsKey(imp.Benefit_Request_Form__c) && 
                       brfObjRecordType.containsKey(mapBrfIdWithBRF.get(imp.Benefit_Request_Form__c).RecordTypeId))
                    {
                        imp.Risk_Type__c = brfObjRecordType.get(mapBrfIdWithBRF.get(imp.Benefit_Request_Form__c).RecordTypeId).getName();//T01
                    }
                }
                //if opportunity is of 50+ recordType then check if Risk Type is Blank n Throw error
                else if(oppMap.get(imp.Opportunity__c).RecordTypeId == opp50RecTypId && imp.Risk_Type__c == NULL){
                  imp.addError(BUSINESS_RISK_ERROR_MSG);
                }
                
            }
           /* else if(imp.Business_Type__c == NULL || imp.Risk_Type__c == NULL){
                imp.addError(BUSINESS_RISK_ERROR_MSG);
            }*/
        }
      
        }
        catch(exception e){
          system.debug('Exception in Implementation Update>> '+e.getMessage()+' -- '+e.getLineNumber());
        }
      }
        
  }