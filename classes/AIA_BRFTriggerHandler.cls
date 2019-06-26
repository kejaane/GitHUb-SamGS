/****************************************************************************************************************************
 *  Class            : AIA_BRFTriggerHandler
 *  Author           : Rajesh Pennam
 *  Version History  : 1.0
 *  Creation         : 05/09/16
 *  Description      : This class will have the logic for trigger (BRF Trigger). If the BRF form is
 *                     created from Proposal Request form then the Opportunity of the PRF will be 
 *                     populated to the Opportunity of BRF  
 *
 *  Modification Log:
 * ---------------------------------------------------------------------------------------------------------------------------
 *  Author          Date-Modified      Tag      Description of Change
 * ---------------------------------------------------------------------------------------------------------------------------
 * Rajesh Pennam     05/09/2016                 Initial Creation
 * Asif Kutagulla    11/16/2016        T01      Add changes to exclude validation rule for users enabled with permission set 
 *                                              Skip BRF Validation Rules 
 * Sree Harsha       03/15/2017        T02      Added check in ValidateSoldBRF method to check if Request type is Off-Cycle - 
                                                Administrative Change then don't need signed or unsigned quote to mark BRF as sold.
 * Sree Harsha       03/17/2017        T03      Added code to call method updateStatus from class AIA_BRFTriggerHelper. 
 * Bill Dodson       03/03/2017        T04      Add call to AIA_AdjustmentSummaryUtils.populateAdjustmentSummary in after update.   
 *                                              Add flags so that adjustment records not created on recursion. 
 * Asif Kutagulla    04/22/2017        T05      Added recursion check for method calls in beforeupdate method  
 * Bill Dodson       04/25/2017        T06      Modify afterUpdate to send all BRF records to adjustment summary.
 * Sree Harsha       05/15/2017        T07      Change of error message
 * Bill Dodson       07/19/2017        T08      Generate Adjustment Summary records for Sold BRFs.
 * Bill Dodson       08/03/2017        T08      Disable Adjustment Summary record creation.
 * Raviteja          13/10/2017      | T10 |    Commented code as part of US 209
 * Goutham Rapolu    10/12/2017        T011     Added method to check if AccountTeamMember is available before inserting/Updating Benefit Request Form. US230
 * Goutham Rapolu    10/12/2017        T012     Updated beforeUpdateTeamMember method to AIA_Verify_AccountTeamMember.
 *                                              so commented beforeUpdateTeamMember method.
 * Goutham Rapolu    12/21/2017      | T13 |    US 510 Call ARC Approval once Salesmanagement is Approved for Off Cycle request Type.
  * satya             9/12/2017      |T14 |     Added methods for workplan tasks assignment
  * satya             6/11/2018      |T15 |     Commented the workplan task method since we no longer has Wplans for pre-sale
 *****************************************************************************************************************************/

public class AIA_BRFTriggerHandler  extends TriggerHandler {
public Static Boolean beforeUpdateRecursive=false;
 public static string Inserts = 'Insert';
    Public static string Updates = 'Update';
    public static string BrfRec = 'Benfit_Request_Form__c';
@TestVisible public Static Boolean AfterUpdateRecursive=false; // T04 added TestVisible.
public Static Boolean AfterinsertRecursive=false;
public Static Boolean hasSkipBRFVRs_CustPerm = CF_CustomPermissionsReader_Helper.Permissions.skipBRFVRs;//T01 
@TestVisible private static Boolean adjustmentPreviouslyCalled = false; // T04
private static Boolean otherTriggersRunning = false; // T04

   
     public AIA_BRFTriggerHandler() {}


  
        /* context override */
    protected override void beforeInsert() {
        otherTriggersRunning = true; // T04
        //if(checkRecursive.runOnce())//T05 begin
        //{
        updateSeniorManagement((list<Benfit_Request_Form__c>) trigger.new);
        AIA_BRFTriggerHelper.populateBrokerNamefromOpptyconRole((list<Benfit_Request_Form__c>) trigger.new,(Map<id,Benfit_Request_Form__c>) trigger.oldMap);
        AIA_BRFTriggerHelper.accountNameUpdate((list<Benfit_Request_Form__c>) trigger.new,(Map<id,Benfit_Request_Form__c>) trigger.oldMap);
       //T012 - START -
       // AIA_BRFTriggerHelper.beforeUpdateTeamMember((list<Benfit_Request_Form__c>) trigger.new);
       //T012 - END -
       //T011 - START -
        AIA_BRFTriggerHelper.AIA_Verify_AccountTeamMember((list<Benfit_Request_Form__c>) trigger.new);
       //T011 - END -  
        AIA_BRFTriggerHelper.updateStatus((list<Benfit_Request_Form__c>) trigger.new); //T03
        AIA_BRFTriggerHelper.soldStatusCheck((list<Benfit_Request_Form__c>) trigger.new); 
        AIA_BRFTriggerHelper.PopulateRxcarveout((list<Benfit_Request_Form__c>) trigger.new ,(Map<id,Benfit_Request_Form__c>) trigger.newMap);
        AIA_BRFTriggerHelper.updateJurisdiction((list<Benfit_Request_Form__c>) trigger.new);
       // }
        otherTriggersRunning = false; // T04
    }
    
    protected override void beforeUpdate() {  
        otherTriggersRunning = true; // T04  
        //if(checkRecursive.runOnce())//T05 begin
        //{
            system.debug('trigger.new=='+trigger.new);
            system.debug('AIA_ProposedProductsHandler.firstRun =='+AIA_ProposedProductsHandler.firstRun);
            
            for(Benfit_Request_Form__c brf :(list<Benfit_Request_Form__c>)trigger.new)
            {
                system.debug('brf=='+brf );
                if(brf.Deep_clone_check__c == true)
                {
                   
                   brf.Clone_count__c += 1;
                }
                
            }
            updateSeniorManagement((list<Benfit_Request_Form__c>) trigger.new);
            AIA_BRFTriggerHelper.populateBrokerNamefromOpptyconRole((list<Benfit_Request_Form__c>) trigger.new,(Map<id,Benfit_Request_Form__c>) trigger.oldMap);
            ValidateSoldBRF((list<Benfit_Request_Form__c>) trigger.new,(Map<id,Benfit_Request_Form__c>) trigger.newmap,(Map<id,Benfit_Request_Form__c>) trigger.oldmap);
            AIA_BRFTriggerHelper.accountNameUpdate((list<Benfit_Request_Form__c>) trigger.new,(Map<id,Benfit_Request_Form__c>) trigger.oldMap);
        
            //T012 - START -
            // AIA_BRFTriggerHelper.beforeUpdateTeamMember((list<Benfit_Request_Form__c>) trigger.new);
            //T012 - END -
            //T011 - START -
            AIA_BRFTriggerHelper.AIA_Verify_AccountTeamMember((list<Benfit_Request_Form__c>) trigger.new);
            //T011 - END -
            
            AIA_BRFTriggerHelper.updateStatus((list<Benfit_Request_Form__c>) trigger.new); //T03
            AIA_BRFTriggerHelper.soldStatusCheck((list<Benfit_Request_Form__c>) trigger.new); 
        //}//T05 end
        otherTriggersRunning = false; // T04
    }
        
    
    protected override void afterInsert() {
        otherTriggersRunning = true; // T04
        ValidateSoldBRF((list<Benfit_Request_Form__c>) trigger.new,(Map<id,Benfit_Request_Form__c>) trigger.newmap,(Map<id,Benfit_Request_Form__c>) trigger.oldmap);
        updateOpportunityOnBRF((list<Benfit_Request_Form__c>) trigger.new);
        //AIA_BRFTriggerHelper.accountNameUpdate((list<Benfit_Request_Form__c>) trigger.new,(Map<id,Benfit_Request_Form__c>) trigger.oldMap);
        if(AIA_BRFTriggerHelper.BRFListForEmail != null && AIA_BRFTriggerHelper.BRFListForEmail.size()>0 && AIA_BRFTriggerHelper.accIDs != null && AIA_BRFTriggerHelper.accIDs.size()>0)
        AIA_BRFTriggerHelper.processEmail(AIA_BRFTriggerHelper.BRFListForEmail,AIA_BRFTriggerHelper.accIDs);  
        //AIA_BRFTriggerHelper.populateAdjustmentSummaryInsert((list<Benfit_Request_Form__c>) trigger.new);//satya
      /* T15 Changes//T14 --Start---
        if(!test.isrunningtest()){ 
        AIA_Workplan_Task_Management wtm = new AIA_Workplan_Task_Management();
            
        wtm.createWorkplanTasksForSObject(Inserts, trigger.newMap, BrfRec);
                    
        }
        //t14--End T15 Changes  */
        otherTriggersRunning = false; // T04
    }
    
    protected override void afterUpdate() {
        system.debug('In after update brf trigger handler');
   // if(checkRecursive.runOnce())//T05 begin
   //{
      /* T15 Changes//T14--START--
       if(!test.isrunningtest()){            
        AIA_Workplan_Task_Management wtm = new AIA_Workplan_Task_Management();
           //T15
        wtm.createWorkplanTasksForSObject(Updates, trigger.newMap, BrfRec);
           //T15
        AIA_WorkPlanTasks_Completion WTC = new  AIA_WorkPlanTasks_Completion();
        WTC.completionWorkplanTasksForSObject(Updates, trigger.new, BrfRec);
        
       } 
       //T14--END--T15 Changes */ 
       
       //T13 START
        //method call to submit for next approval
        AIA_BRFTriggerHelper.Send_For_SalesMgmt_or_ARC_or_UW_Approval((list<Benfit_Request_Form__c>) trigger.new,(Map<id,Benfit_Request_Form__c>) trigger.oldmap);
       //T13 END
     
        if(!otherTriggersRunning && !adjustmentPreviouslyCalled) { // T04 begin
            // T06, removed code that filtered records prior to call.               
            AIA_AdjustmentSummaryUtils.populateAdjustmentSummary(trigger.new, trigger.oldMap);//Bill
            System.debug('In after update brf trigger handler, returned from populateAdjustmentSummary');
            adjustmentPreviouslyCalled = true;
            // T08 Commented Code Removed
            // If the status changes to Sold then generate Adjustment Summary records.
                       
        } 
        else {
            System.debug('In after update brf trigger handler, populateAdjustmentSummary NOT called' +
                         ', otherTriggersRunning: ' + otherTriggersRunning +
                         ', adjustmentPreviouslyCalled: ' + adjustmentPreviouslyCalled);
        } // T04 end 
    //}
   } 
    /**
    * @Author : Rajesh Pennam
    * @param  : This method is used to update the oppotunity of BRF from PRF
    * @param  : List<Benfit_Request_Form__c> brflst
    * @Output : This method inserts the opportunity on BRF from PRF
    * @return the list of lineitem sobjects 
    */  
    public static List<Benfit_Request_Form__c> UpdateBRFLst = new List<Benfit_Request_Form__c>();
    public static set<Id> PRFids = new set<Id>();
    public static List<PRF__c> PRFLst = new List<PRF__c>();
     
   public static void updateOpportunityOnBRF(List<Benfit_Request_Form__c> brflst){
        for(Benfit_Request_Form__c brf: brflst){
            PRFids.add(brf.Proposal_Request_Form__c);
        }
        
        //PRF List will have the id and the Opportunity of PRF
        PRFLst = [select id,Opportunity__c from PRF__c where id IN :PRFids];
        
        //This loop makes the Opportunity of PRF to Populate to Opportunity of BRF
        for(Benfit_Request_Form__c brf: brflst){
            for(PRF__c prf: PRFLst){
                system.debug('PRF opportunity is '+prf.Opportunity__c);
                if(prf.Opportunity__c != null && brf.Proposal_Request_Form__c != null && brf.Proposal_Request_Form__c == prf.id){
                    Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
                    nbrf.id = brf.id;
                    nbrf.Proposal_Request_Form__c = prf.id;
                    nbrf.Opportunity__c = prf.Opportunity__c;
                    UpdateBRFLst.add(nbrf);
                }
            }
        }
        
        //Exception Handling
        
        try{
            if(UpdateBRFLst.size()>0 && UpdateBRFLst != null)
                update UpdateBRFLst;
        }catch(DMLException ex){
            system.debug(ex+'');
        }
    }
    
    /**
* @Author: Sree Harsha Akkala
* @This Method is called from BRFTrigger during insertion or updation of BRF
* @This method - The method tracks who has set the ARC approval status 
* @param -  list<Benfit_Request_Form__c> 
* @Output - Sets the Senior Management Approved by to the current user
*/    
public static void updateSeniorManagement(list<Benfit_Request_Form__c> brfList){
     for(Benfit_Request_Form__c brf:brfList){        
        if((brf.ARC_Approval_Status__c == AIA_Constants.APPROVED_BY_COMMITTEE || brf.ARC_Approval_Status__c==AIA_Constants.REJECTED_BY_COMMITTEE) &&(brf.Escalated_to_Senior_Management__c)){            
            brf.Senior_Management_Approved_By__c = userinfo.getuserId(); //Sets the seniormanagement approved by to current user
        }
        if(brf.status__c=='Sold'){
            brf.Who_Marks_Sold__c   = userinfo.getuserid(); //tracks who has set the brf to Sold(used in email alert of approval process) 
            brf.BRF_Sold_Date_field__c =   system.today();        
        }      
    }
}


/**
* @Author: Sree Harsha Akkala
* @This Method is called from BRFTrigger during insertion or updation of BRF
* @This method - The method validates when the BRF has to be set to sold
* @param -  list<Benfit_Request_Form__c> 
* @Output - Display an error message if set to sold without signed Quote or Approved Unsigned quote
*/
public static void ValidateSoldBRF(list<Benfit_Request_Form__c> newbrfList,Map<id,Benfit_Request_Form__c> newBRFMap,Map<id,Benfit_Request_Form__c> oldBRFMap){
    System.debug('Enter ValidateSoldBRF: '+'Hello');
    list<Benfit_Request_Form__c> brfList = new list<Benfit_Request_Form__c>();
    set<id> brfIdSet = new set<id>();
    for(Benfit_Request_Form__c brf:newbrfList){
        if(oldBRFMap!=null){
        if(oldBRFMap.get(brf.id).status__c=='Sold'){
                //T01 - Start - Added if check
                if(!hasSkipBRFVRs_CustPerm)
                {
                    brf.addError('The Benefit Request Form cannot be modified after it has been sold'); //T07
                }
                //T01 - End - Added if check
            }
        }
        if(brf.Status__c=='Sold'){          
        brfList.add(brf);
        brfIdSet.add(brf.id);
        }
    }
        
    list<Benfit_Request_Form__c> existingBRFList = [select id,name,ARC_Approval_Required__c, Request_Type__c,
                                                           ARC_Approval_Status__c,
                                                           (select id,name,Document_Type__c,Approval_Status__c 
                                                            from File_Net_Documents__r 
                                                            where Document_Type__c!=null) 
                                                    from Benfit_Request_Form__c 
                                                    where id in:BRFIdSet];
    system.debug('existingBRFList::'+existingBRFList);
    if(existingBRFList.size()>0){
     boolean setTOSoldForARC=false;         
        for(Benfit_Request_Form__c brf:existingBRFList){
        if(brf.ARC_Approval_Status__c =='Auto-Approved by System' || brf.ARC_Approval_Status__c =='Approved by Committee'){     
                setTOSoldForARC = true;     
            } 
            boolean setToSold=false;
            if(brf.File_Net_Documents__r.size()>0){        
                for(AIA_Document__c fd:brf.File_Net_Documents__r){
                    if((fd.Document_Type__c=='Signed Quote' ||  (fd.Document_Type__c=='Unsigned Quote' && fd.Approval_Status__c=='Approved')) ){
                        if((newBRFMap.get(brf.id).ARC_Approval_Required__c==true && (newBRFMap.get(brf.id).ARC_Approval_Status__c==AIA_Constants.APPROVED_BY_COMMITTEE || newBRFMap.get(brf.id).ARC_Approval_Status__c== 'Auto-Approved by System'))|| newBRFMap.get(brf.id).ARC_Approval_Required__c==false){
                            brf.File_Net_Doc_Id__c=fd.id;
                            newBRFMap.get(brf.id).File_Net_Doc_Id__c=fd.id;
                            setToSold=true;
                        }                       
                    }
                                       
                }
                if(!setToSold){
                    //T01 - Start - Added if check
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                         If(brf.Request_Type__c!='Off-Cycle - Administrative Change' && brf.Request_Type__c!='Set-up Change - Administrative Changes'){ //T02
                        newBRFMap.get(brf.id).addError('The Benefit Request Form must have either a signed quote or an approved unsigned quote attached to it before it can be marked as Sold.');
                        }
                    }
                    //T01 - End - Added if check
                    
                }
                    
            }
            else{                
                //T01 - Start - Added if check
                if(!hasSkipBRFVRs_CustPerm)
                {    
                    If(brf.Request_Type__c!='Off-Cycle - Administrative Change' && brf.Request_Type__c!='Set-up Change - Administrative Changes'){    //T02
                    newBRFMap.get(brf.id).addError('The Benefit Request Form must have either a signed quote or an approved unsigned quote attached to it before it can be marked as Sold.');
                    }
                }
                //T01 - End - Added if check
            }  
                if(setTOSoldForARC == false){       
                 if(!hasSkipBRFVRs_CustPerm){       
                    newBRFMap.get(brf.id).addError('The Benefit Request Form must be either Auto-Approved or Approved by Committee before it can be marked as Sold.');      
                 }
               }              
            }          
        }
    }
}