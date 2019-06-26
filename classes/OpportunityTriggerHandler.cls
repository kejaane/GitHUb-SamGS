/*==================================================================================================================
* Date         : 10/21/2014
* Developer    : Ken Gill
* Purpose      : This class is the extension point of the Trigger Framework for adding 
*                Opportunity trigger handler.
*==================================================================================================================
*  Update History
*  ---------------
* Date       | Developer  | Tag |       Description
*============+============+========================================================================================
* 11/17/2014 |  KG        |     | Initial Version                                         
* 12/18/2015 |  TPB       |     | Added functionality to update the account.type field based
*                                 on the latest opportunity.stage
* 9/12/2016  | Ahilesh    |     | Updated functionality to check NPN availability on brokers/agencies associated to the opportunity
* 12/09/2016 | Asif K     | T01 | Moved method createImplementation to a different class AIA_Opportunity_Helper.
*                                 Changed method references of createImplementation to method refer the class 
*                                 AIA_Opportunity_Helper.
* 12/09/2016 | Asif K     | T02 | Added new methods checkStageChange, processUnderwriterUpdate and
*                                 processWorkplanStages in order to remove code from beforeUpdate, afterupdate
* 12/20/2016 | Satya      |     | Removed LUMINX from the OR condition to check the NPN null condition
* 3/24/2017  | Satya      | T03 | Added recursive check for after update trigger evenet
* 10/12/2017 | Goutham R  | T04 | Added method in Beforeinsert/update to check if AccountTeamMember is available 
*                                 before inserting and before updating a 200+ Opportunity US230.
* 9/12/2017  | Satya      | T05 | Added methods for workplan tasks assignment
* 9/12/2017  | Satya      | T06 | Added a method call to Send Notification to all the team members when the 
                                  opportunity is updated
* 4/16/2018  | Gayathri   | T07 | Commented the WP task related functionalities as part of US209
* 4/18/2018  | Laveen     | T08 | Added a new method to create Pre sales process records on opp creation us-1513
* 10/31/2018 | Chaithra   | T10 | Deactivated OpportunityProcessor trigger and concatinated it with this class 
*============+============+=====+==================================================================================
*/

public with sharing class OpportunityTriggerHandler extends TriggerHandler {
    public OpportunityTriggerHandler() {}
    Id opptwohundredplusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId;  //To get 200+ recordTypeId
    Id opp51plusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('51+').RecordTypeId;  //To get 51+ recordTypeId - Ahilesh
    public static boolean firstRun = false;
    public static boolean isFirstTime = true;
    public static string Inserts = 'Insert';
    public static string Updates = 'Update';
    public static string OppRec = 'opportunity';
    public Static Boolean AfterUpdateRecursive=false;
    public Static Boolean BeforeUpdateRecursive=false;
    //T10 begins
    string RtId = querybase.getRecordtypeId('Opportunity', 'X2_50');
/* Instantiate  OpportunityProcessorManager to access its public methods in the trigger. */ 
    OpportunityProcessorManager  oppManager = new OpportunityProcessorManager();
    //T10 ends
    
    /**
    * @This Method is called when user changes from one opp recordtype to 200+ record type, and to assign workplan type to that opportunity and create the workplan stages as well  
    * @Output - List if opp with Recordtypechange, newMap and oldMap - calling methods from AIA_Workplan class for assigning the workplan type to opp,creating stages and update of stages too  
    */    
    protected override void beforeUpdate() 
    {
        if(BeforeUpdateRecursive != TRUE){
        checkStageChange();//T02
        processUnderwriterUpdate();//T02
        
         //T04 -- START --
        AIA_Opportunity_Helper OppHelper = new AIA_Opportunity_Helper();
            system.debug('chaithra oppHelper trigger.new in line 55'+trigger.new);
        OppHelper.AIA_Verify_AccountTeamMember((List<Opportunity>) Trigger.new);
        //T04 -- END --
        system.debug('chaithra oppHelper trigger.new after call'+trigger.new);
        Map<id,Opportunity> tnewMap = new Map<id,Opportunity>();        //opp Mapping for new value
        Map<id,Opportunity> toldMap = new Map<id,Opportunity>();        //opp Mapping for old value
        
        tnewMap  = (Map<id,Opportunity>)Trigger.newMap;
        toldMap  = (Map<id,Opportunity>)Trigger.oldMap;
        // To check if the NPNs of Broker/Agencies are available - @Ahilesh
        List<Opportunity> OpportunitySoldStageChange = new List<Opportunity>();                                     
        
        for(Opportunity opp:tnewMap.values()){
        if(opp.System__c != NULL) {
        //String systemName = opp.System__c;
        if(opp.StageName != toldMap.get(opp.id).StageName && opp.StageName == 'Sold' && toldMap.get(opp.id).StageName != 'Sold' && 
          (opp.RecordTypeId == opp51plusId  || opp.RecordTypeId == opptwohundredplusId ) &&
           //Satya Tirumalasetti 12/20/2016. Changed this to below line (opp.System__c == 'NASCO' || opp.System__c == 'LUMINX')
          opp.System__c.contains('NASCO') &&
           (opp.Market_Segment_New__c == '200-999' || opp.Market_Segment_New__c == '1000+')  ){
                OpportunitySoldStageChange.add(opp);          
            }
           }
        
        }
         if(OpportunitySoldStageChange != null && OpportunitySoldStageChange.size()>0){
             NPN_Check newNPN = new NPN_Check();
           newNPN.updateNPN(OpportunitySoldStageChange);
         }
         //T10 begins
         /*
 * @Purpose: Change'Lead Rep Name'when Opportunity owner changed for Opportunity with Stage='Proposal'. Also marked opportunity as Transitioned.
 * @Description : When Opportunity owner changes, if that owner is a Lead_Rep (checked in the User Record), then the 'Lead Rep Name' 
 * field in the opp record will be populated by the new owner , otherwise set to null.Also marked the opportunity as Transitioned.
 */ 
        Map<id,Opportunity> tnewMap1 = new Map<id,Opportunity>();
        Map<id,Opportunity> toldMap1 = new Map<id,Opportunity>();
        tnewMap1  = (Map<id,Opportunity>)Trigger.newMap;
        toldMap1  = (Map<id,Opportunity>)Trigger.oldMap;
        System.debug('****** Within OpportunityProcessor Trigger : Before Update ****** ');
        Set<Id> ownerIds = new Set<Id>();
         Map<Id, User > userMap = new Map<Id, User > ();
        /* looping over the Opportunity to create the set of Owner Ids*/
        for (Opportunity oppo: tnewMap1.values()){
        
            //Begin Change TPB 10/29/2014
            //system.debug('%%%%%%%%%%%%' + RtId);
            //system.debug('%%%%%%%%%%%%' + oppo.RecordtypeId);
            if ( oppo.RecordTypeId == RtId ) continue;
            
            //system.debug('%%%%%%%this thing continues at isBefore');
            //End Change TPB 10/29/2014
            
            Opportunity beforeUpdate = toldMap1.get(oppo.id);
            if(beforeUpdate.OwnerId !=  oppo.OwnerId && oppo.StageName =='Proposal'){
                ownerIds.add(oppo.OwnerId) ;
                oppo.Transitioned__c = true; 
            }
        }
        /* get the User information for the ownerIds set*/
        if(ownerIds.size()>0){
            List<User> userList = [select id , name, Lead_Rep__c from user where id in:ownerIds];
            for(User user:userList){
                userMap.put(user.id, user);
            }
        }
        /* looping over the Opportunity to update the 'Lead Rep Name'*/
        for (Opportunity oppo1:tnewMap1.values()){
        
            //Begin Change TPB 10/29/2014
            if ( oppo1.RecordTypeId == RtId ) continue;
            //End Change TPB 10/29/2014  
                  
            if(userMap.size()>0){
                if(userMap.containsKey(oppo1.OwnerId)){
                    User user = userMap.get(oppo1.OwnerId);
                    //System.debug('****** Within OpportunityProcessor Trigger : User is ****** ' + user);
                        if(user.Lead_Rep__c){
                            oppo1.Lead_Rep_Name_User__c = user.id;
                        }
                        else{
                            oppo1.Lead_Rep_Name_User__c = null;
                        }
                    
                }
            }
        }
        //T10 ends
            
            BeforeUpdateRecursive = TRUE;
        }
        
    }
    
    protected override void beforeInsert() 
    {   
         
           //T04 -- START --
        AIA_Opportunity_Helper OppHelper = new AIA_Opportunity_Helper();
        system.debug('chaithra trigger.new in before insert'+trigger.new);
        OppHelper.AIA_Verify_AccountTeamMember((List<Opportunity>) Trigger.new);
        system.debug('chaithra trigger.new in beforeinsert after call'+trigger.new);
        //T04 -- END --
        /* T07 Start
        //Laveen-Added for assigning the workplan type to respective opp
        AIA_Workplan wp = new AIA_Workplan();
        wp.assignWorkplan((List<Opportunity>) Trigger.new);     
        //End
        T07 End*/
    }
    
    protected override void afterInsert() {
    
        /*Added by Laveen 4/18/2018 for creation of Process and Sub porcess run time records on Opp creation. 
        * For 200+ Opportunity record Type
        */
        //T08 - start
         //AIA_OpportunityImplementationController.createPreSalesProcess(Trigger.New, True);
         //T08 - end
        system.debug('afterinsertisgettingcalled');
        
        
        //T05 ---start
     /*   if(!test.isrunningtest()){
           
            AIA_Workplan_Task_Management wtm = new AIA_Workplan_Task_Management();
            //T09
            wtm.createWorkplanTasksForSObject(Inserts, trigger.newMap, OppRec);
            //T09
        }*/
        if(!firstRun){
            firstRun = AIA_Opportunity_Helper.createImplementation((List<Opportunity>) Trigger.new, (Map<id,Opportunity>)Trigger.oldMap, firstRun);//T01
        }
        processAfterEGPOpportunityInsertOrUpdate();
        processAccountBasedOnLatestOppStageChange(); //Begin Add 12/18/15 TPB
        /* T07 Start
        //Laveen - Added for creating the workplan stages on opp
        AIA_Workplan wp = new AIA_Workplan();
        wp.createWorkplanStages((List<Opportunity>) Trigger.new);
        // added here b'cos -for new opp creation if opp.stage is equal to workplan stage (Sub-process)record, then that record should go In progress
        AIA_Workplan.UpdateWorkplanStages((Map<id,Opportunity>)Trigger.newMap, (Map<id,Opportunity>)Trigger.oldMap);          
        //End 
        T07 End*/              
    }
    
    protected override void afterUpdate() {
       system.debug('query limit afterUpdate start'+System.Limits.getQueries());
        if(!firstRun){
            System.debug('Entered Here multiple times@@');
            system.debug('query trigger.new'+Trigger.new);
            firstRun = AIA_Opportunity_Helper.createImplementation((List<Opportunity>) Trigger.new, (Map<id,Opportunity>)Trigger.oldMap, firstRun);//T01
               system.debug('firstRun'+firstRun);

        }
       if(isFirstTime == true){
            System.debug('Entered Here multiple times');
         //T06 -- Start
         AIA_SendEmail_Notification.sendNotificationToAccTeam(trigger.new,(Map<id,Opportunity>)Trigger.oldMap);
          //T06-- End
          //T05--Start  
          /*  if(!test.isrunningtest()){   
                
                AIA_Workplan_Task_Management wtm = new AIA_Workplan_Task_Management();
                system.debug('limit afterUpdate createWorkplanTasksForSObject'+System.Limits.getQueries());
                //T09
                wtm.createWorkplanTasksForSObject(Updates, trigger.newMap, OppRec);
                //T09
                system.debug('limit afterUpdate completionWorkplanTasksForSObject'+System.Limits.getQueries());
                AIA_WorkPlanTasks_Completion WTC = new AIA_WorkPlanTasks_Completion();
                WTC.completionWorkplanTasksForSObject(Updates, trigger.new, OppRec);
                }*/
        //T05 ---End
        //processAfterEGPOpportunityInsertOrUpdate();
          processAccountBasedOnLatestOppStageChange(); //Begin Add 12/18/15 TPB
        
        //Chida:B-02108 User can mark the Opportunity as sold (contract was awarded) 
        //if there is a Benefit Request Form marked as sold 
        system.debug('chaithra trigger value'+ trigger.new );
        AIA_Opportunity_Helper mos = new AIA_Opportunity_Helper();
        mos.AIA_Opportunity_Helper((List<Opportunity>) Trigger.new);
        //End
        
        processWorkplanStages();//T02
        
        Map<id,Opportunity> newMap = new Map<id,Opportunity>();
        Map<id,Opportunity> oldMap = new Map<id,Opportunity>(); 
        Map<id,Opportunity> tnewMap = new Map<id,Opportunity>();
        Map<id,Opportunity> toldMap = new Map<id,Opportunity>();
        
        tnewMap  = (Map<id,Opportunity>)Trigger.newMap;
        toldMap  = (Map<id,Opportunity>)Trigger.oldMap;
        // To check if the NPNs of Broker/Agencies are available - @Ahilesh
            List<Opportunity> OpportunitySoldStageChange = new List<Opportunity>(); 
            
            Set<ID> oppIds = new Set<ID>();
            List<opportunity> oppListDateUpdatedsold = new List<opportunity>();
            
            for(Opportunity opp:tnewMap.values()){
                // Check if the stage is modified to SOLD and system is NASCO
                if(opp.StageName != toldMap.get(opp.id).StageName && opp.StageName == 'Sold' && toldMap.get(opp.id).StageName != 'Sold' && 
                  (opp.RecordTypeId == opp51plusId || opp.RecordTypeId == opptwohundredplusId) &&
                  (opp.System__c.contains('NASCO'))){
                        OpportunitySoldStageChange.add(opp);          
                }
                //system.debug('opp.Effective_Date__c>>>>'+opp.Effective_Date__c+' ; toldMap.get(opp.id).Effective_Date__c'+toldMap.get(opp.id).Effective_Date__c);
                //system.debug('opp.Contract_End_Date__c>>>>'+opp.Contract_End_Date__c+' ; toldMap.get(opp.id).Contract_End_Date__c'+toldMap.get(opp.id).Contract_End_Date__c);
                if(opp.Effective_Date__c != toldMap.get(opp.id).Effective_Date__c || opp.Contract_End_Date__c != toldMap.get(opp.id).Contract_End_Date__c){
                        oppIds.add(opp.id);
                        if(opp.StageName == toldMap.get(opp.id).StageName && opp.StageName == 'Sold'){  
                            oppListDateUpdatedsold.add(opp);
                        }
                }
            }
            system.debug('oppIds>>>>'+oppIds);
            List<Opportunity_Contact_Role__c> oppContactRoleList = [Select o.Role__c, o.Primary__c,o.Opportunity__c, o.Id,o.Effective_Date__c,o.End_Date__c, o.Contact_Name__c 
                                        From Opportunity_Contact_Role__c o where o.Opportunity__c  in: oppIds];
            for(Opportunity_Contact_Role__c oppContactRole : oppContactRoleList){                    
                if(oppContactRole.Primary__c == true && oppContactRole.Role__c == 'Primary Broker'){
                    //oppContactRole.Effective_Date__c = tnewMap.get(oppContactRole.Opportunity__c).Effective_Date__c;
                    oppContactRole.End_Date__c = tnewMap.get(oppContactRole.Opportunity__c).Contract_End_Date__c;  
                }if(oppContactRole.Role__c != 'Primary Broker'){
                    oppContactRole.End_Date__c = tnewMap.get(oppContactRole.Opportunity__c).Contract_End_Date__c;
                    oppContactRole.Effective_Date__c = tnewMap.get(oppContactRole.Opportunity__c).Effective_Date__c;
                }       
            }
            system.debug('After oppContactRoleList>>>>'+oppContactRoleList);
            if(oppContactRoleList.size() > 0)
                update oppContactRoleList;
            
            List<FSP_GP__c> oppFSPGPList = [  Select o.Partner__c, o.Primary__c, o.Id, o.FSP_GP__c,o.Account__c,o.Effective_Date__c,o.End_Date__c,o.Opportunity__c 
                                        From FSP_GP__c o where o.Opportunity__c  in: oppIds];
            for(FSP_GP__c oppfspgp : oppFSPGPList){                    
                if(oppfspgp.Primary__c == true){
                    //oppfspgp.Effective_Date__c = tnewMap.get(oppfspgp.Opportunity__c).Effective_Date__c;
                    oppfspgp.End_Date__c = tnewMap.get(oppfspgp.Opportunity__c).Contract_End_Date__c;  
                }      
            }
            if(oppFSPGPList.size() > 0)
                update oppFSPGPList;
            
                    
            List<Partner__c> oppPartnerList =[Select o.Role__c, o.Opportunity__c, o.Primary__c, o.Partner__c,o.Effective_Date__c,o.End_Date__c 
                                 From Partner__c o 
                                 where o.Opportunity__c in: oppIds];
            for(Partner__c oppPrtnr : oppPartnerList){                    
                if((oppPrtnr.Primary__c == true && oppPrtnr.Role__c == 'Broker') || (oppPrtnr.Role__c != 'Broker')){
                    //oppPrtnr.Effective_Date__c = tnewMap.get(oppPrtnr.Opportunity__c).Effective_Date__c;
                    oppPrtnr.End_Date__c = tnewMap.get(oppPrtnr.Opportunity__c).Contract_End_Date__c;  
                }      
            }
            if(oppPartnerList.size() > 0)
                update oppPartnerList;
            
            // call the broker hub service
            if((OpportunitySoldStageChange != null && OpportunitySoldStageChange.size()>0) || oppListDateUpdatedsold.size()>0){
                if(!Test.isRunningTest()){
                    if(OpportunitySoldStageChange != null && OpportunitySoldStageChange.size()>0){
                        processAfterBHOpportunityUpdate(true);
                    }else if(oppListDateUpdatedsold.size()>0){
                        processAfterBHOpportunityUpdate(false);
                    }
                }
            }
          //T03-Satya Added recursive check to avoid trigger firing multiple times. This recursive check is aplied to this method, won't apply to test class related to this trigger event.
         /* if(!Test.isRunningTest()){  
          isFirstTime = false;
          } else{
          isFirstTime = true;
          }*/
          //satya - Commneted T03 AND Extended recursion check to test class also 3/25/2018
          //T10 begins
           System.debug('****** Within OpportunityProcessor Trigger : After Update ****** ');
        
/*
 * @Purpose: Change Account Owner when Opportunity owner changed for Opportunity with Stage='Proposal'. 
 * @Description : When Opportunity owner changes , the corresponding Account owner will be changed. Also the New Account owner will received 
 * an email notification for the account assignment. 
 * @ Method : Public method changeAccountOwnerForOpportunityOwnerChange() of Apex Class: OpportunityProcessorManager.cls has been implemented to hold the 
 * logic for this process. 
 *
 */ 
        Map<id,Opportunity> tnewMap1 = new Map<id,Opportunity>();
        Map<id,Opportunity> toldMap1 = new Map<id,Opportunity>();
        tnewMap1  = (Map<id,Opportunity>)Trigger.newMap;
        toldMap1  = (Map<id,Opportunity>)Trigger.oldMap;
         Set<Id> accountId = new Set<Id>();
         Map <id , Opportunity> accIdOpportunityMap = new Map< id ,Opportunity>();
         /* looping over the Opportunity to create the accountId set and accIdOpportunityMap Map */
         for (Opportunity opp: tnewMap.values()){
            Opportunity beforeUpdate = toldMap1.get(opp.id);
            if(beforeUpdate.OwnerId !=  opp.OwnerId && opp.StageName =='Proposal'){
                accountId.add(opp.AccountId);
                accIdOpportunityMap.put(opp.AccountId, opp);
            }
        }
        /* Called public method changeAccountOwnerForOpportunityOwnerChange() */  
         if(accountId.size()> 0){ 
            oppManager.changeAccountOwnerForOpportunityOwnerChange(accountId ,accIdOpportunityMap) ;
        }
/*
 * @Purpose: Clone Opportunity when Opportunity stage changes to 'Sold'and Business Type not equal to 'New'.
 * @Description : When opportunity stage changes to 'Sold', then the opportunity and its related records of - OpportunityLineItem,OpportunityContactRole,
 * OpportunityPartner will be cloned. 
 * @ Method : Public method cloneOpportunityOnOpportunityStageUpdate() of Apex Class: OpportunityProcessorManager.cls has been implemented to hold the 
 * logic for this cloning process.
 */   
 
    List<Opportunity> oppList = new List<Opportunity>();
    for (Opportunity opp: tnewMap.values()){
   
        //Begin Change TPB 10/29/2014
        system.debug('%%%%%%%%%%%% on update' +RtId);
        system.debug('%%%%%%%%%%%% on update' +opp.RecordtypeId);
        if ( opp.RecordTypeId == RtId ) continue;
        
        system.debug('%%%%%%%this thing continues at isAfter');
        //End Change TPB 10/29/2014

        Opportunity beforeUpdate = toldMap.get(opp.id);
    
        if(beforeUpdate.StageName != opp.StageName && opp.StageName =='Sold' && opp.Business_Type__c <> 'New'){
            oppList.add(opp);
        }
}
/*NOTE: As discussed with Bill on 16th Dec'10, we are restricting the clone functionality for only one record , not for bulk update. */          
        if(oppList.size()== 1){
            Opportunity oppToClone;
            for( Opportunity opp:oppList){
            
                oppToClone = opp;
            }   
            /* Called public method cloneOpportunityOnOpportunityStageUpdate() */  
            if(oppToClone != null){
                if(Trigger.isupdate && !OpportunityProcessorManager.isCloned)
                try{
                oppManager.cloneOpportunityOnOpportunityStageUpdate(oppToClone);
                }
                 catch(System.DmlException ex){
                    oppToClone.adderror(ex.getDmlMessage(0));
                 }
            }                    
        }        
        //T10 ends
          isFirstTime = false;
        }
       system.debug('query limit afterUpdate End'+System.Limits.getQueries());
        
    }
    
    protected override void afterDelete() {
        processAccountBasedOnOppDelete(); //Begin Add 12/18/15 TPB
    }
    
    protected override void AfterUnDelete() {
        processAccountBasedOnOppUnDelete(); //Begin Add 12/18/15 TPB
    }
    
    private void processAfterEGPOpportunityInsertOrUpdate() {
        if(System.isBatch()|| System.isFuture()) {
            System.debug('OpportunityTriggerHandler: Bypassing EGP Opportunity update processing when called from a batch job');
            return;
        }   
        // Note on casting below:
        // Outside a trigger, the trigger collections Trigger.new,.old have to be explicitly cast to the SOBject type
        // When working inside a trigger, this casting happens implicitly
        EGPService.processAccountOpportunityUpdateChanges(( List<Opportunity>) Trigger.new, (Map<Id,Opportunity>) Trigger.oldMap);
    }
    
    // Begin Add 12/18/15 TPB
    private void processAccountBasedOnLatestOppStageChange() {
        UpdateAccountBasedOnLatestOppStageChange.UpdateAccountTypeField((List<Opportunity>) Trigger.new, (Map<Id, Opportunity>) Trigger.oldMap);
    }
    
    private void processAccountBasedOnOppDelete() {
        UpdateAccountBasedOnLatestOppStageChange.UpdateAccountTypeField((List<Opportunity>) Trigger.old, (Map<Id, Opportunity>) Trigger.oldMap);
    }    
    
    private void processAccountBasedOnOppUnDelete() {
        UpdateAccountBasedOnLatestOppStageChange.UpdateAccountTypeField((List<Opportunity>) Trigger.new, (Map<Id, Opportunity>) Trigger.newMap);      
    } 
    // End Add 12/18/15 TPB
    
    private void processWorkplanStages() {
        /*T07 Start
        //Laveen - Added to update workplan stage Status to In progress & Start date as today wrt Opportunity Stage
        //New and Old Map values to Update Workplan Stages 
        Map<id,Opportunity> newMap = new Map<id,Opportunity>();
        Map<id,Opportunity> oldMap = new Map<id,Opportunity>(); 
        Map<id,Opportunity> tnewMap = new Map<id,Opportunity>();
        Map<id,Opportunity> toldMap = new Map<id,Opportunity>();
        
        tnewMap  = (Map<id,Opportunity>)Trigger.newMap;
        toldMap  = (Map<id,Opportunity>)Trigger.oldMap;
        
        for(Opportunity opp:tnewMap.values())
        {
            //checking the new value stageName is not equal to old one
            if(opp.StageName != toldMap.get(opp.id).StageName)
            {
                newMap.put(opp.id,opp);
                oldMap.put(opp.id,toldMap.get(opp.id));
            }
            
        }
        
        // Update Workplan Stages
        if(newMap != null && newMap.size()>0){
            AIA_Workplan.UpdateWorkplanStages(newMap,oldMap);    
        }
        // End of Laveen's code
        // T07 End*/
    }
    
    private void processUnderwriterUpdate() {
        //Chida:update underwriter in opportunity;09/16/2016
        //if there is a Benefit Request Form marked as sold 
        AIA_Opportunity_Helper UpdateTeamRole= new AIA_Opportunity_Helper();
        Map<id,Opportunity> oppOldMap=(Map<id,Opportunity>)Trigger.oldMap;
        List<Opportunity> oppNewList=(List<Opportunity>) Trigger.new;
        List<Opportunity> oppList=new List<Opportunity>();
        for(Opportunity opp:oppNewList){
            if(opp.RecordTypeId == opptwohundredplusId )
            {
                //Added Condition to check record Type
                if(oppOldMap.containsKey(opp.id)){
                    Opportunity opprt=oppOldMap.get(opp.id);
                    if(opp.Renewal_Delivery_Date_to_Sales__c!=null){
                        if(opprt.Renewal_Delivery_Date_to_Sales__c!=opp.Renewal_Delivery_Date_to_Sales__c){
                            oppList.add(opp);
                        }
                    }
                }
            }
        }
        if(oppList.size()>0)
            UpdateTeamRole.AIA_Update_Underwriter_TeamMember((List<Opportunity>) Trigger.new);
        //End
    }
    
    private void checkStageChange() {
        Map<id,Opportunity> tnewMap = new Map<id,Opportunity>();        //opp Mapping for new value
        Map<id,Opportunity> toldMap = new Map<id,Opportunity>();        //opp Mapping for old value
        
        tnewMap  = (Map<id,Opportunity>)Trigger.newMap;
        toldMap  = (Map<id,Opportunity>)Trigger.oldMap;
        
        List<Opportunity> recordTypeChange = new List<Opportunity>();       //recordTypeChange Opplist
        List<Opportunity> OpportunityStageChange = new List<Opportunity>(); //list of opp To check wheather user is allowed to change the opp stage or no
        
        //Looping opp with the newmap values
        for(Opportunity opp:tnewMap.values())
        {
            /*T07 Start
            if(opp.RecordTypeId == opptwohundredplusId && opp.RecordTypeId != toldMap.get(opp.id).RecordTypeId && opp.Workplan_Type__c == Null)
            {
                //adding all the opp with 200+ recordType,and checking the above condition
                recordTypeChange.add(opp);
            }*///T07 End
            if(opp.StageName != toldMap.get(opp.id).StageName){
                OpportunityStageChange.add(opp);          //Checking stage old and new values and adding them to opp list  
            }   
        }
        
        /*T07 Start
        //This loop is for when user changes record type to 200+ is assigning worplan Type, creating workplan stages & update on workplan stages 
        if(recordTypeChange != null && recordTypeChange.size()>0)
        {
            AIA_Workplan wp = new AIA_Workplan();
            wp.assignWorkplan(recordTypeChange);
            wp.createWorkplanStages(recordTypeChange);
            AIA_Workplan.UpdateWorkplanStages(tnewMap,toldMap);
        }
        //This loop is to check for change of opp stage and allow users accordingly     
        if(OpportunityStageChange != null && OpportunityStageChange.size()>0){
            AIA_Workplan wp = new AIA_Workplan();
            wp.OpportunityNextStageCheck(OpportunityStageChange,tnewMap,toldMap);
            
        }T07 End*/
    }       
    
            private void processAfterBHOpportunityUpdate(Boolean isOppProptoSold){
            if(System.isBatch() || System.isFuture()){
                system.debug('OpportunityTriggerHandler: Bypassing BH Opportunity update processing when called from a batch job');
                return;
            }   
            else if(isFirstTime == true){
            
                system.debug('trigger handler new >>0001 '+Trigger.new);
                if(!Test.isRunningTest()){
                    BrokerHubServiceNew.processSoldOpportunityDetails((List<Opportunity>) Trigger.new, isOppProptoSold);
                    }
                    isFirstTime = false;
           }
    }
    
}