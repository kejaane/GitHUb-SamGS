/*************************************************************************************************************************************************
*  Class            : AIA_BRFTriggerHelper
*  Author           : Goutham Rapolu
*  Version History  : 1.0
*  Creation         : 05/31/16
*  Description      : Notify PRF Team to Verify Zip Code-User Story --B02076 Send to Underwriting  
*
*  Modification Log:
* ----------------------------------------------------------------------------------------------------------------------------------------------
*  Author          Date-Modified      Tag      Description of Change
* ----------------------------------------------------------------------------------------------------------------------------------------------
* Goutham Rapolu     05/31/2016                Initial Creation
* Sree Harsha        11/05/2016                This method is used to check if last year's opp sold brf's proposed product has 
*                                              RX Carve Out, if yes populates Carve Out RX Approval field in new BRF
* Asif Kutagulla     11/16/2016       T01      Add changes to exclude validation rule for users enabled with permission set 
*                                              AIA Skip BRF Validation Rules  
* Asif Kutagulla     02/28/2017       T02      Added changes to include a check so that multipe sold BRF's can be created if associated Account 
*                                              has Sub-Groups. Method changed : soldStatusCheck.
* Sree Harsha        03/17/2017       T03      Added updateStatus method to update source BRF status and associate old Imp to new BRF.
* Bill Dodson        03/27/2017       T04      Remove adjustment summary code.
* Asif Kutagulla     03/28/2017       T05      Code to update Account Manager and Account Executive onto BRF record. These fields will be inturn
*                                              used to @mention in Chatter, when the BRF is ARC Approved
* Sree Harsha        03/30/2017       T06      Added logic to create Implementation record as part of story B-03470 in updateStatus method.
*                                              Also removed status values and using final constants defined in AIA Constants class.
* Sree Harsha        05/17/2017       T07     change of error message
* Goutham Rapolu     10/12/2017       T08     Added method to check if AccountTeamMember is available before inserting Benefit Request Form. US230
* Goutham Rapolu     12/21/2017       T09     US 510 Call ARC Approval once Salesmanagement is Approved for Off Cycle request Type.
* Sajitha Y          04/02/2018       T10     Commented else if conditions since there is no code present inside.
* Chaithra           05/04/2018       T11     Added condition before making source BRF Sold-Inactive.Source BRF can be made Sold Inactive only when it 
* Chaithra           07/31/2018       T12     Added missing fields in the SOQL retrieval as part of RITM0636919                                              is already in Sold State
* Arshia             09-04-2018       T13     Change Record Type for US-771
* Gayathri           12/03/2018       T14     Updated Verify account teammember to check Benefit tester and commented NASCO Benefit coder - US1730
* Gayathri           12/04/2018       T15     Commented Ancillary Analyst role check in verify account team member - US1702
* Chaithra           12/07/2018       T16     Updated verify account teammember to check vision analyst -US1702
* Phani              01/08/2019       T17     Code to avoid validation errors during BRF cloning
* Satya T            02/01/2019       T18     Replaced standard Account Team Member with Custom Account Team Member. 
*************************************************************************************************************************************************/
public with sharing class AIA_BRFTriggerHelper {
    
    //Variable Declaration 
    public static List<Benfit_Request_Form__c> BRFList = new list<Benfit_Request_Form__c>();
    public static Set<Id> oppID = new Set<ID>();
    public static Set<Id> prfID = new Set<ID>(); 
    public static Map<String,String> mapOppId = new map<String,String>(); 
    public static Map<String,String> mapprfId = new map<String,String>();
    public static Map<String,integer> mapCountForBRF = new map<String,integer>();
    public static set<String> oppIdSet = new set<String>();
    public static set<string> BRFIdSet = new set<string>();
    public static set<string> BRFIdSetErrors = new set<string>();
    public static final string STR_NEW = 'New';
    public static list<Benfit_Request_Form__c> BRFListForEmail = new list<Benfit_Request_Form__c>();
    public static set<Id> accIDs = new set<Id>();
    public static final string CENSUS_INFORMATION = 'Census Information';
    public static final string ERROR_MSG = 'The related Account is new and there is no Proposal Request Form related to this Benefit Request Form. Please attach a Census Information File to the Benefit Request Form before submitting it to Underwriting'; //T07
    public static final string NASCO_BENEFIT_CODER = 'NASCO Benefit Coder';
    public static final string BENEFACT_CODER = 'BeneFact Coder';
    //public static final string ANCILLARY_ANALYST = 'Ancillary Analyst';T16
    public static final string VISION_ANALYST='Vision Analyst';//T16
    public static final string MAST_TECH = 'MAST Tech';
    public static final string ACCOUNT_MGR = 'Account Manager';   //T05
    public static final string ACCOUNT_EXEC = 'Account Executive';//T05
    public static final string BENEFIT_TESTER = 'Benefit Tester';//T14
    public static final string BENEFIT_CODER = 'Benefit Coder';//T14
    
    public static final string ERROR1 = 'The following roles need to be defined in the Account Team before saving the Benefit Request Form:';
    public static final string ERROR2 = 'The following roles are defined multiple times in the Account Team:';
    public static final string ERROR3 = 'Please define these roles only once before saving the Benefit Request Form.';
    public static final string ERROR4 = 'You cannot create a duplicate sold Benefit Request Form';
    public static boolean hasSkipBRFVRs_CustPerm = CF_CustomPermissionsReader_Helper.Permissions.skipBRFVRs;//T01
    public static boolean IgnoreValidations = CF_CustomPermissionsReader_Helper.Permissions.ignoreVRs;//T08
    
    /**
    * @Author: Indira Das
    * @This Method is called from BRFTrigger
    * @This method - This method is to get the opportunity for all the brf getting created
    * @param -  list<Benfit_Request_Form__c>  
    * @Output -
    */
    public static void populateBrokerNamefromOpptyconRole(List<Benfit_Request_Form__c> lstBRF,Map<id,Benfit_Request_Form__c> oldBRFMap )
    {
        
        //Set of Accounts from Benefit Design
        Set<Id> opptyIdSet=new Set<Id>();
        for(Benfit_Request_Form__c brf : lstBRF)
        {
            //Get oppty.
            opptyIdSet.add(brf.Opportunity__c);
        }
        updateBRFBrokerName(lstBRF,opptyIdSet);
    }
    
    /**
    * @Author: Indira Das
    * @This Method is called from BRFTrigger
    * @This method - This method is to update the broker/consultant name based on the opportunity contact roles with role as broker.
    * @param -  list<Benfit_Request_Form__c>  , Set<Id> opptyIdSet
    * @Output -
    */
    public static void updateBRFBrokerName(List<Benfit_Request_Form__c> lstBRF,Set<Id> opptyIdSet)
    {
        List<OpportunityContactRole> oppConrRoleList= [SELECT Id, OpportunityId, ContactId, Role, IsPrimary 
                                                       FROM OpportunityContactRole 
                                                       where Role='Broker' and OpportunityId in :opptyIdSet
                                                       order by isprimary];
        
        Map<id, List<OpportunityContactRole>> mapOpptyContRole=new  Map<id, List<OpportunityContactRole>>();
        
        for(OpportunityContactRole ocr:oppConrRoleList){
            
            List<OpportunityContactRole> ocrlist= new List<OpportunityContactRole>();
            
            if(mapOpptyContRole.containsKey(ocr.OpportunityId))
                ocrlist=mapOpptyContRole.get(ocr.OpportunityId);
            
            ocrlist.add(ocr);
            mapOpptyContRole.put(ocr.OpportunityId, ocrlist) ;
        }
        
        for(Benfit_Request_Form__c brf: lstBRF){
            
            if(mapOpptyContRole.containsKey(brf.Opportunity__c))
            {
                OpportunityContactRole ocr=mapOpptyContRole.get(brf.Opportunity__c)[0];
                brf.Broker_Consultant_Name__c= ocr.ContactId;
            }
        }
        
    }
    
    /**
    * @Author: Goutham Rapolu
    * @This Method is called from BRFTrigger during insertion or updation of BRF
    * @This method - preparaing data and showing error if condition does not meet
    *                querying and storing data for sending email for 1st BRF on Opportunity and PRF 
    * @param -  list<Benfit_Request_Form__c> ,Map<id,Benfit_Request_Form__c>
    * @Output -
    */
    
    public static void accountNameUpdate(list<Benfit_Request_Form__c> newBRFList,Map<id,Benfit_Request_Form__c> oldBRFMap){
        List<ID> oppid = new List<ID>();
        for (Benfit_Request_Form__c  BRF: newBRFList) 
        { 
            oppid.add(BRF.Opportunity__c);
        }

        for (Benfit_Request_Form__c  BRF: newBRFList) 
        {  
           if(BRF.Opportunity__c != null){
                oppID.add(BRF.Opportunity__c);
            }
            system.debug('oppID>>>>>>'+oppID);
            
            if(BRF.Proposal_Request_Form__c != null){
                prfID.add(BRF.Proposal_Request_Form__c);
            }
            system.debug('prfID>>>>>>'+prfID);
            
            if(BRF.Submit_to_Underwriting__c){
                BRFIdSet.add(BRF.Id);   
            }
            system.debug('BRFIdSet>>>>>>'+BRFIdSet);
        }
        if(oppID != null && oppID.size()>0){
            for(Opportunity opp: [select id,account.id,Account.Jurisdiction__c,Business_Type__c,(SELECT id FROM Benfit_Request_Forms__r),(select Id from Proposal_Request_Forms__r) from opportunity where id=: oppID]){
                mapOppId.put(opp.id,opp.account.id);
                if(opp.Benfit_Request_Forms__r.size() == 0)
                    mapCountForBRF.put(opp.id,opp.Benfit_Request_Forms__r.size());
                if(opp.Business_Type__c == STR_NEW && opp.Proposal_Request_Forms__r.size() == 0){
                    oppIdSet.add(opp.Id);
                } 
            for (Benfit_Request_Form__c  BRF: newBRFList) 
            {
                if(opp.id == BRF.Opportunity__c && opp.Account.Jurisdiction__c == 'VA'){
                    BRFList.add(BRF);
                    system.debug('BRFList>>>>>> Inside >>>'+BRFList);
                }          
            } 
          }            
        }
        system.debug('mapOppId>>>>>>'+mapOppId);
        system.debug('mapCountForBRF>>>>>>'+mapCountForBRF);
        system.debug('oppIdSet>>>>>>'+oppIdSet);
        
        if(prfID != null && prfID.size()>0){ 
            Map<ID,Opportunity> oppMap=new Map<ID,Opportunity>([select id,(SELECT id FROM Benfit_Request_Forms__r) from Opportunity where id in (select Opportunity__c from PRF__c where id=:prfID)]);
            for(PRF__c prf: [select id,Opportunity__r.id,Opportunity__c,(SELECT id FROM Benefit_Request_Forms__r) from PRF__c where id=: prfID]){
                mapprfId.put(prf.id,prf.Opportunity__r.id);
                if(oppMap.get(prf.Opportunity__r.id).Benfit_Request_Forms__r.size()<1 && prf.Benefit_Request_Forms__r.size()<1)
                    mapCountForBRF.put(prf.id,prf.Benefit_Request_Forms__r.size());
            }
        }
        system.debug('mapprfId>>>>>>'+mapprfId);
        system.debug('mapCountForBRF>>>>>>mapprfId'+mapCountForBRF);
        
        for(Benfit_Request_Form__c  BRF: newBRFList){
            if(mapprfId != null && mapprfId.containsKey(BRF.Proposal_Request_Form__c)){
                BRF.Opportunity__c = mapprfId.get(BRF.Proposal_Request_Form__c);
                system.debug(BRF.Proposal_Request_Form__c +'>>>>>>>>'+ mapOppId.get(BRF.Proposal_Request_Form__c));
            }
        }
        
        system.debug('!!!!!!!!'+BRFIdSet);
        system.debug('********'+oppIdSet);
        if(BRFIdSet != NULL && BRFIdSet.size() >0 && oppIdSet != NULL && oppIdSet.size()>0){
            for(Benfit_Request_Form__c brfObj: [Select Id, Opportunity__c,Submit_to_Underwriting__c, (Select Id, Document_Type__c from File_Net_Documents__r where Document_Type__c =: CENSUS_INFORMATION) from Benfit_Request_Form__c where Id IN:BRFIdSet AND Opportunity__c IN:oppIdSet]){   
                system.debug('BRFIdSetErrors>>>>>>BRFIdSetErrors'+BRFIdSetErrors+'**********'+brfObj.File_Net_Documents__r.size());
                if(brfObj.File_Net_Documents__r.size() == 0){
                    BRFIdSetErrors.add(brfObj.Id);
                }
                
            } 
        }
        system.debug('BRFIdSet>>>>>>'+BRFIdSet);
        
        for(Benfit_Request_Form__c  BRF: newBRFList){
            if(BRFIdSetErrors != NULL && BRFIdSetErrors.size() >0){
                if(BRFIdSetErrors.contains(BRF.Id)){
                    //T01 - Start - Added if check
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        BRF.addError(ERROR_MSG);
                    }
                    //T01 - End - Added if check
                }
            }
        }
        
        system.debug('@@@beforeemail');
        system.debug('@@@mapCountForBRF size outside'+mapCountForBRF.size());
        if(mapCountForBRF != null && !mapCountForBRF.isEmpty()){
          system.debug('@@@mapCountForBRF size inside'+mapCountForBRF);  
          system.debug('@@@BRFList.Opportunity__c inside'+BRFList);   
            for(Benfit_Request_Form__c BRF: BRFList){
                 if(mapCountForBRF.containsKey(BRF.Opportunity__c)){
                    BRFListForEmail.add(BRF);
                    accIDs.add(BRF.Account__c);
                 }else if(mapCountForBRF.containsKey(BRF.Proposal_Request_Form__c)){
                    BRFListForEmail.add(BRF);
                    accIDs.add(BRF.Account__c);
                }
            }
        }
    }
    
    /**
    * @Author: Goutham Rapolu
    * @This Method is called from BRFTrigger
    * @This method - This method is used to send the email 
    * @param -  list<Benfit_Request_Form__c> ,Set<ID> 
    * @Output -
    */
    
    public static void processEmail(list<Benfit_Request_Form__c> newBRFList,Set<ID> accountIDs){
        
        system.debug('@@@processEmail else condition');
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        list<string> toAddresses = new list<string>();
        
        //Retrieving User name from custo label
        //String uName = system.label.AIA_User_Detail_For_Sending_Email;
      
        AIA_Workflow_Emails__c workFlowEmails = AIA_Workflow_Emails__c.getInstance();
        if(!AIA_Utils.isNullOrEmpty(workFlowEmails.AIA_BRF_Zip_Code_Validation__c))
            toAddresses.add(workFlowEmails.AIA_BRF_Zip_Code_Validation__c);

       // toAddresses.add(uName);
        //querying the account data based on accountIds
        if(accountIDs != null && accountIDs.size()>0) {
            
            Map<Id,Account> accmap = new Map<Id,Account>([select id,Account_Legal_Name__c,name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from account where id =: accountIDs]);            
            
            // storing data for email
            for (Benfit_Request_Form__c  BRF: newBRFList){
                string addr = '';  
                account acc = accmap != null && accmap.containskey(BRF.Account__c)? accmap.get(BRF.Account__c):null;
                string accName = '';
                string acclegalname = '';
                if(acc != null){
                    if(acc.BillingStreet != null)
                        addr = acc.BillingStreet+ '<br/>';
                    if(acc.BillingCity != null)
                        addr += acc.BillingCity+ '<br/>';
                    if(acc.BillingState != null) 
                        addr += acc.BillingState+ '<br/>';
                    if(acc.BillingPostalCode != null)
                        addr += acc.BillingPostalCode+ '<br/>';
                    If(acc.BillingCountry != null)
                        addr += acc.BillingCountry+ '<br/>';
                    accName = acc.name;
                    acclegalname = acc.Account_Legal_Name__c;
                }
                
                list<string> emailbodytemplate = new list<string>{accName,addr,BRF.Account_Website__c,BRF.id};
                    string msgBody =string.format(system.label.AiA_Email_Body_For_BRF,emailbodytemplate);
                
                // Create a new Email
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(toAddresses);
                mail.setSenderDisplayName('Zip Code Verification');
                mail.setSubject('Zip Code Verification for '+acclegalname);
                mail.setHTMLbody(msgBody);
                mail.setSaveAsActivity(false);
                
                // Add your email to the master list
                mails.add(mail); 
                system.debug('++toaddress++'+toAddresses);
            }
            // Send all emails in the master list
            if(!Test.isRunningTest()){
                Messaging.sendEmail(mails);
              }
        }
    }
       
    /**
    * @Author: Chidananda Nagaraj
    * @This Method is called from BRFTrigger
    * @This method - This method is used to check if sold staus is more than one, then throw error. This check is skipped if BRF's Account has Sub-Groups
    * @param -  list<Benfit_Request_Form__c>  
    * @Output - 
    */
    
    public static void soldStatusCheck(List<Benfit_Request_Form__c> lstNewBRF){
        
        Set<ID> oppSetId = new Set<ID>(); // to store opportunity ID
        Map<id,Benfit_Request_Form__c> mapCountSoldBRF = new Map<id,Benfit_Request_Form__c>(); // to store brf id and status
        Map<id,Benfit_Request_Form__c> mapBRFSubAccountStatus = new Map<id,Benfit_Request_Form__c>(); // T02-to store brf id and Sub Group Account Status
        Set<Id> brfSetId = new Set<ID>(); // to store brf Id
        List<Benfit_Request_Form__c> brfSoldList = new List<Benfit_Request_Form__c>();
        
        // Storing opportunity Id and Brf id where status is sold
        for (Benfit_Request_Form__c  BRF: lstNewBRF) 
        {
            oppSetId.add(BRF.Opportunity__c);
        }
        system.debug('oppSetId>>>'+oppSetId);
        
        //Doing query to get the BRFlist where status is sold
        if(oppSetId != null && oppSetId.size()>0){
            //T02-getting sub group account flag using for loop & prepare the list of sold brf's
            for(Benfit_Request_Form__c brf : [select id,Status__c,Opportunity__c,Account__r.Has_Sub_Groups__c,Account__c from Benfit_Request_Form__c where Opportunity__c in:oppSetId])
            {
                if(brf.Status__c == 'Sold'){
                    brfSoldList.add(brf);
                }
                mapBRFSubAccountStatus.put(brf.id,brf);
            }
        }
        system.debug('brfSoldList>>>'+brfSoldList);
        
        if(brfSoldList != null && brfSoldList.size()>0){
            for(Benfit_Request_Form__c  BRF : brfSoldList){mapCountSoldBRF.put(BRF.Opportunity__c,BRF);
            }   
        }
        system.debug('mapCountSoldBRF>>>'+mapCountSoldBRF);
        Map<Id,Benfit_Request_Form__c> oldBRFMap=(Map<Id,Benfit_Request_Form__c>)Trigger.oldMap;
        // showing the error if brf is ecist in map
        for(Benfit_Request_Form__c  BRF : lstNewBRF){
            if(mapCountSoldBRF != null && mapCountSoldBRF.containskey(BRF.Opportunity__c)){
                if(oldBRFMap!=null && oldBRFMap.containsKey(BRF.id) && oldBRFMap.get(BRF.id).Status__c!='Sold' && BRF.Status__c == 'Sold')
                {
                    system.debug('mapBRFSubAccountStatus.get(BRF.id).Account__r.Has_Sub_Groups__c==='+mapBRFSubAccountStatus.get(BRF.id).Account__r.Has_Sub_Groups__c);
                    //T01 - Start - Added if check----//T02 - Modified if condition to skip check if BRF's Account has Sub-Groups 
                    if(!hasSkipBRFVRs_CustPerm && (mapBRFSubAccountStatus.containsKey(BRF.id) && mapBRFSubAccountStatus.get(BRF.id).Account__r.Has_Sub_Groups__c == FALSE))
                    {BRF.addError(ERROR4);
                    }
                    //T01 - End - Added if check
                }
            }   
        }   
        
    }
    
    /**
    * @Author: Sree Harsha
    * @This Method is called from BRFTrigger
    * @This method - This method is used to check if last year's opp sold brf's
    *   proposed product has RX Carve Out, if yes populates a filed in new BRF
    * @param -  list<Benfit_Request_Form__c>  
    * @Output - Updates Carve Out RX Approval field in BRF
    */
    
    public static void PopulateRxcarveout(list<Benfit_Request_Form__c> newBRFList, Map<id,Benfit_Request_Form__c> newBRFMap){
        if(newBRFList.size()<2){
            List<Id> accountIdList=new List<Id> ();
            String stage='Sold';
            String BusinessType='Renewal';
            Boolean isIntegratedNI=true;
            list<opportunity> oppList = new list<Opportunity>();
            for(Benfit_Request_Form__c brfObj:newBRFList){
                accountIdList.add(brfObj.Account__c);    }    
            
            try{
                oppList= [SELECT id,Effective_Date__c 
                          FROM opportunity 
                          WHERE accountid=:accountIdList AND 
                                StageName=:stage AND 
                                RecordType.name = '200+' AND 
                                Business_Type__c =:BusinessType AND 
                                Effective_Date__c>=:Date.Today().addYears(-1)  
                          ORDER BY Effective_Date__c DESC 
                          LIMIT 1];
            }catch(exception e){}
            if(!oppList.isEmpty()){
                list<Benfit_Request_Form__c> breFormObj =[SELECT Id FROM Benfit_Request_Form__c WHERE Status__c = 'sold' and Opportunity__c =: oppList[0].id limit 1];
                if(breFormObj.size()>0){
                    List<Proposed_Products__c> ppList= [SELECT Integrated_Non_Integrated__c FROM Proposed_Products__c WHERE BRF_ID__c = :breFormObj[0].id and recordtype.name='Medical Risk' ];  //T13
                    for(Proposed_Products__c ppObj:ppList){
                        if(ppObj.Integrated_Non_Integrated__c=='Integrated - Carved-Out'){isIntegratedNI=true;
                        }
                    }
                    
                 /* Commented as part of Production Enhancement from Brandon to not send out Rx Carve Out email 08112017
                   if(isIntegratedNI){
                        for(Benfit_Request_Form__c brfObj:newBRFList){
                            brfObj.Carve_Out_RX_Approval__c = 'Pending Approval';
                        }
                    }*/
                }
            }
            
        }
    }
    
    public static void updateJurisdiction(List<Benfit_Request_Form__c> newBRFList){
        
        Set<id> accountIdSet = new Set<id>();
        for(Benfit_Request_Form__c brfObj: newBRFList){
            accountIdSet.add(brfobj.Account__c);
        }
        map<id,Account> newAccountMap = new map<id,Account>([select Id, name, Jurisdiction__c from Account where id=:accountIdSet]);
        for(Benfit_Request_Form__c brfObj: newBRFList){
            Account newAccountObj = newAccountMap.get(brfObj.Account__c);
            brfObj.Jurisdiction__c = newAccountObj.Jurisdiction__c;
        }
    }
    
    // T04 Bill deleted adjustment summary code no longer used.

    //T03 changes start here
    /*    
    * @Author: Sree Harsha
    * @This Method is called from BRFTriggerHandler
    * @This method - This method is to change status on 
    * @source BRF and associate old implementation to 
    * @the new BRF whenever current BRF is set to sold.
    * @param -  list<Benfit_Request_Form__c>  
    * @Output - Updates status in source BRF and 
    *           associates Imp to new BRF
    */
    public static void updateStatus(List<Benfit_Request_Form__c> lstBRFnew)
    {
        map<id,Benfit_Request_Form__c> mapbrf=new map<id,Benfit_Request_Form__c>();
        list<Benfit_Request_Form__c> updatebrf=new list<Benfit_Request_Form__c>();
    
        map<id,list<AIA_Implementation__c>> mapbrfimp=new map<id,list<AIA_Implementation__c>>();
        list<AIA_Implementation__c> lstimp=new list<AIA_Implementation__c>();
        list<AIA_Implementation__c> updatelstimp=new list<AIA_Implementation__c>();
        for(Benfit_Request_Form__c brf:lstBRFnew){
            if(brf.Status__c==AIA_Constants.sold && brf.Source_Benefit_Request_Form__c !=null && (brf.Request_Type__c == 'Off-Cycle - Administrative Change' || brf.Request_Type__c == 'Off-Cycle - Benefit Change' || 
                brf.Request_Type__c == 'Off-Cycle - Administrative and Benefit Change' || brf.Request_Type__c == 'Set-up Change - Administrative Changes' || brf.Request_Type__c == 'Set-up Change - Benefit Changes' || brf.Request_Type__c == 'Set-up Change - Admin and Benefit Changes') ){
                mapbrf.put(brf.Source_Benefit_Request_Form__c,brf); 
            }
        }
       list<AIA_Implementation__c> newImplementationList = new list<AIA_Implementation__c>();
        for(Benfit_Request_Form__c brf:[select id,Status__c, Account__c, Opportunity__c,Opportunity__r.Description,opportunity__r.name,(select id,Benefit_Request_Form__c,status__c,opportunity__c,opportunity__r.name,Account__c, Business_Type__c,Parent_Account__c, Opportunity__r.description from Implementations__r) from Benfit_Request_Form__c where id IN:mapbrf.keyset()]){//T12 added Opportunity__r.name,Opportunity__r.Description in the retrieval 
             //T11 Start Added condition before making source BRF SoldInactive 
            if(brf.Status__c == AIA_Constants.Sold)
                {
                brf.Status__c = AIA_Constants.SoldInactive;
                }
            //T11 End
            //brf.Status__c = AIA_Constants.SoldInactive;
               updatebrf.add(brf);
               if(brf.Implementations__r.size()>0 ){
                for(AIA_Implementation__c imp:brf.Implementations__r){
                    if(imp.Business_Type__c == 'NCR')
                        Continue;
                    if(imp.status__c == AIA_Constants.NotStarted){
                    system.debug('***mapbrf -'+mapbrf.get(brf.id).id);
                    imp.Benefit_Request_Form__c=mapbrf.get(brf.id).id;
                    imp.Business_Type__c=mapbrf.get(brf.id).Request_Type__c;
                    //imp.Account__c =brf.Account__c;     
                    imp.Imp_not_started__c = true;
                    updatelstimp.add(imp);
                    }
                    // T06 start
                    else if(imp.status__c == AIA_Constants.InProgress || imp.status__c == AIA_Constants.Completed ){
                    AIA_Implementation__c  impRec = new AIA_Implementation__c ();
                    impRec  =AIA_Opportunity_Helper.initializeImplementation( brf.Account__c, null, brf.Opportunity__c, mapbrf.get(brf.id).id, brf.Opportunity__r.name, brf.Opportunity__r.Description);
                    impRec.Imp_in_progress__c = true;       
                    impRec.Account__c = imp.Account__c;
                    impRec.Business_Type__c = imp.Business_Type__c;
                    impRec.Parent_Account__c = imp.Parent_Account__c;
                    newImplementationList.add(impRec);
                    }
                
                }
            }
        }
        system.debug('***newImplementationList '+newImplementationList);
        if(!newImplementationList.isEmpty()){
        system.debug('***newImplementationList - inside if'+newImplementationList);
        insert newImplementationList;
        } //T06 end
        if(!updatebrf.isEmpty()){
            update updatebrf;
        }
        if(!updatelstimp.isEmpty()){
            update updatelstimp;
        }
    
    }
    //T03 changes end here

//T08  -- START --
    Public Static Void AIA_Verify_AccountTeamMember(List<Benfit_Request_Form__c> listBRF){
        //Set to save Account ID's
        Set<String> accids = new Set<String>();
        Map<String,String> mapAccIDTeamNameToCount = new Map<String,String>(); 
        for(Benfit_Request_Form__c BRF:listBRF){
            //Get Account ID's
            accids.add(BRF.Account__c);
            system.debug('Test: '+accids);
        }
        //List of AccountTeams availble from the Set of Accid's 
      /* T18 -- Start */
      /*  List<AccountTeamMember> ATMList = [select Userid,user.name,TeamMemberRole,accountid  from AccountTeamMember WHERE accountid In: accids]; 
        system.debug('ListAtm: '+ATMList);
        if(!ATMList.ISEMPTY()){
            for(AccountTeamMember accTeamMem:ATMList)
            {
                if(accTeamMem.TeamMemberRole !=null)
                {
                   //If Account Team not present in the Account Team Role.
                    String AccAndTeamRole = accTeamMem.accountid + '#' + accTeamMem.TeamMemberRole ;
                    if(mapAccIDTeamNameToCount.containskey(AccAndTeamRole))
                    {
                        
                        //If Account Team present Twice once in the Account Team Role.
                        mapAccIDTeamNameToCount.put(AccAndTeamRole,'2# ' );
                    }
                    else{
                    //If Account Team present only once in the Account Team Role.
                    mapAccIDTeamNameToCount.put(AccAndTeamRole,'1#'+accTeamMem.Userid );
                    }
                }           
            }
        }*/
        List<Account_Team__c> ATMList = [select UserId__c,userId__r.name,TeamMemberRole__c,accountid__c  from Account_Team__c WHERE accountId__c In: accids]; 
        system.debug('ListAtm: '+ATMList);
        if(!ATMList.ISEMPTY()){
            for(Account_Team__c accTeamMem:ATMList)
            {
                if(accTeamMem.TeamMemberRole__c !=null)
                {
                   //If Account Team not present in the Account Team Role.
                    String AccAndTeamRole = accTeamMem.accountId__c + '#' + accTeamMem.TeamMemberRole__c ;
                    if(mapAccIDTeamNameToCount.containskey(AccAndTeamRole))
                    {
                        
                        //If Account Team present Twice once in the Account Team Role.
                        mapAccIDTeamNameToCount.put(AccAndTeamRole,'2# ' );
                    }
                    else{
                    //If Account Team present only once in the Account Team Role.
                    mapAccIDTeamNameToCount.put(AccAndTeamRole,'1#'+accTeamMem.Userid__c );
                    }
                }           
            }
        }
        /* T18 -- End*/
        system.debug(Logginglevel.INFO,'mapAccIDTeamNameToCount==' + mapAccIDTeamNameToCount);
        for(Benfit_Request_Form__c BRF:listBRF){

            String UW = '0# ';//UNDERWRITER.
            //String NBC = '0# ';//NASCO_BENEFIT_CODER//T14
            String BC = '0# ';//BENEFACT_CODER
            //String AA = '0# ';//ANCILLARY_ANALYST//T15
            String MT = '0# ';//MAST_TECH
            String AM = '0# ';//ACCOUNT_MGR
            String AE = '0# ';//ACCOUNTEXECUTIVE
            String IM = '0# ';//IMP Manager
            String BT = '0# ';//BENEFIT_TESTER//T14
            String BNC = '0# ';//BENEFIT_CODER//T14
            String VA ='0# ';//VISION_ANALYST//T16
            
            string AccAndUNDERWRITER = BRF.Account__c + '#' + AIA_Constants.UNDERWRITER;
            //string AccAndNBC = BRF.Account__c + '#' + NASCO_BENEFIT_CODER;//T14
            string AccAndBT = BRF.Account__c +'#' +BENEFIT_TESTER;//T14
            string AccAndBNC = BRF.Account__c +'#' +BENEFIT_CODER;//T14
            string AccAndBC = BRF.Account__c + '#' + BENEFACT_CODER;
            //string AccAndAA = BRF.Account__c + '#' + ANCILLARY_ANALYST;//T15
            string AccAndVA = BRF.Account__c + '#' + VISION_ANALYST;//T16
            string AccAndMT = BRF.Account__c + '#' + MAST_TECH;
            string AccAndAMGR = BRF.Account__c + '#' + ACCOUNT_MGR;
            string AccAndAE = BRF.Account__c + '#' + AIA_Constants.ACCOUNTEXECUTIVE;
            string AccAndIM = BRF.Account__c + '#' + AIA_Constants.IMP_MANAGER;
            
            //Check if related account has specified AccountTeamMember assigned in Account Team Role.
            if(mapAccIDTeamNameToCount.containskey(AccAndUNDERWRITER))//UNDERWRITER
            {
                UW = mapAccIDTeamNameToCount.get(AccAndUNDERWRITER);
            }
            //T14 Start
            /*if(mapAccIDTeamNameToCount.containskey(AccAndNBC))//NASCO_BENEFIT_CODER
            {
                NBC = mapAccIDTeamNameToCount.get(AccAndNBC);
            }*/
            
            if(mapAccIDTeamNameToCount.containskey(AccAndBT))//BENEFIT_TESTER
            {
                BT = mapAccIDTeamNameToCount.get(AccAndBT);
            }
            if(mapAccIDTeamNameToCount.containskey(AccAndBNC))//BENEFIT_CODER
            {
                BNC = mapAccIDTeamNameToCount.get(AccAndBNC);
            }
            //T14 -- End
            if(mapAccIDTeamNameToCount.containskey(AccAndBC))//BENEFACT_CODER
            {
                BC = mapAccIDTeamNameToCount.get(AccAndBC);
            }
            /* T15 -- Start*/
            /*if(mapAccIDTeamNameToCount.containskey(AccAndAA))//ANCILLARY_ANALYST
            {
                AA = mapAccIDTeamNameToCount.get(AccAndAA);
            }*/
            /* T15 -- End*/
            //T16 --Start
            if(mapAccIDTeamNameToCount.containskey(AccAndVA))//VISION_ANALYST
            {
                VA = mapAccIDTeamNameToCount.get(AccAndVA);
            }
            //T16 --End
            
            if(mapAccIDTeamNameToCount.containskey(AccAndMT))//MAST_TECH
            {
                MT = mapAccIDTeamNameToCount.get(AccAndMT);
            }
            if(mapAccIDTeamNameToCount.containskey(AccAndAMGR))//ACCOUNT_MGR
            {
                AM = mapAccIDTeamNameToCount.get(AccAndAMGR);
            }
            if(mapAccIDTeamNameToCount.containskey(AccAndAE))//ACCOUNTEXECUTIVE
            {
                AE = mapAccIDTeamNameToCount.get(AccAndAE);
            }
            if(mapAccIDTeamNameToCount.containskey(AccAndIM))//Implementation Manager
            {
                IM = mapAccIDTeamNameToCount.get(AccAndIM);
            }           
            //ID NBCUser;//T14
            ID UWUser;
            //ID AAUser;//T15
            ID BCUser;
            ID MTUser;
            ID AMUser;
            ID AEUser;
            ID IMUser;
            ID BTUser;//T14
            ID BNCUser;//T14            
            ID VAUser;//T16
            
            system.debug(Logginglevel.INFO,'@@@IM '+IM);
            system.debug('@@@IM '+IM);
            system.debug(Logginglevel.INFO,'@@@UW '+UW);
            //system.debug(Logginglevel.INFO,'@@@NBC '+NBC );
            system.debug(Logginglevel.INFO,'@@@BC '+BC );
            //system.debug(Logginglevel.INFO,'@@@AA '+AA);
            system.debug(Logginglevel.INFO,'@@@MT '+MT);
            system.debug(Logginglevel.INFO,'@@@AM '+AM);
            system.debug(Logginglevel.INFO,'@@@AE '+AE);
            
            
            String NoATM = '';
            String DupATM = '';
                
            //Split String to get the result of how many times the account team is present & the User ID of the Assigned User
            String [] UWstring = UW.split('#');             //UNDERWRITER
            Integer UWCount = Integer.valueof(UWstring[0]);
            if(!String.ISBLANK(UWstring[1]))
            UWUser = ID.valueof(UWstring[1]);
            
            //T14 -- Start
            /*String [] NBCstring = NBC.split('#');           //NASCO_BENEFIT_CODER
            Integer NBCCount = Integer.valueof(NBCstring[0]);
            if(!String.ISBLANK(NBCstring[1]))
            NBCUser = ID.valueof(NBCstring[1]);*/
                        
            String [] BTstring = BT.split('#');           //BENEFIT_TESTER
            Integer BTCount = Integer.valueof(BTstring[0]);
            if(!String.ISBLANK(BTstring[1]))
            BTUser = ID.valueof(BTstring[1]);
            
            String [] BNCstring = BNC.split('#');           //BENEFIT_CODER
            Integer BNCCount = Integer.valueof(BNCstring[0]);
            if(!String.ISBLANK(BNCstring[1]))
            BNCUser = ID.valueof(BNCstring[1]);
            
            //T14 --End
            
            String [] BCstring = BC.split('#');             //BENEFACT_CODER
            Integer BCCount = Integer.valueof(BCstring[0]);
            if(!String.ISBLANK(BCstring[1]))
            BCUser = ID.valueof(BCstring[1]);
            
            /* T15 -- Start*/
            /*String [] AAstring = AA.split('#');             //ANCILLARY_ANALYST
            Integer AACount = Integer.valueof(AAstring[0]);
            if(!String.ISBLANK(AAstring[1]))
            AAUser = ID.valueof(AAstring[1]);*/
            /*T15 -- End*/
            
            //T16 --Start
            String [] VAstring = VA.split('#');             //VISION_ANALYST
            Integer VACount = Integer.valueof(VAstring[0]);
            if(!String.ISBLANK(VAstring[1]))
            VAUser = ID.valueof(VAstring[1]);
            //T16 --End
            
            String [] MTstring = MT.split('#');             //MAST_TECH
            Integer MTCount = Integer.valueof(MTstring[0]);
            if(!String.ISBLANK(MTstring[1]))
            MTUser = ID.valueof(MTstring[1]);
            
            String [] AMstring = AM.split('#');             //ACCOUNT_MGR
            Integer AMCount = Integer.valueof(AMstring[0]);
            if(!String.ISBLANK(AMstring[1]))
            AMUser = ID.valueof(AMstring[1]);
            
            String [] AEstring = AE.split('#');             //ACCOUNTEXECUTIVE
            Integer AECount = Integer.valueof(AEstring[0]);
            if(!String.ISBLANK(AEstring[1]))
            AEUser = ID.valueof(AEstring[1]);
            
            String [] IMstring = IM.split('#');             //IMP Manager
            Integer IMCount = Integer.valueof(IMstring[0]);
            if(!String.ISBLANK(IMstring[1]))
            IMUser = ID.valueof(IMstring[1]);
            
            /* Underwriter */
                //If result ==  0 means no Account Team Member with specified role.
                if(UWCount == 0){NoATM = AIA_Constants.UNDERWRITER;
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(UWCount > 1){
                    DupATM =  AIA_Constants.UNDERWRITER;
                }
                
            /* Nasco Benefit Coder */   
            /*T14 Start   
            if(NBCCount == 0){
                    if(NoATM != '' ){NoATM = NoATM + ', ' + NASCO_BENEFIT_CODER;
                    }
                    else{
                    NoATM = NASCO_BENEFIT_CODER;
                    }
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(NBCCount > 1){
                    if(DupATM != '' ){
                    DupATM = DupATM + ', ' + NASCO_BENEFIT_CODER;
                    }
                    else{DupATM = NASCO_BENEFIT_CODER;
                    }
                }
                if(NBCCount == 1 && string.valueof(NBCUser) != ''){
                    BRF.Benefit_NASCO_Coder__c = NBCUser;
                }
            */
            /*Benefit Tester*/
            if(BTCount == 0){
                    if(NoATM != '' ){NoATM = NoATM + ', ' + BENEFIT_TESTER;
                    }
                    else{
                    NoATM = BENEFIT_TESTER;
                    }
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(BTCount > 1){
                    if(DupATM != '' ){
                    DupATM = DupATM + ', ' + BENEFIT_TESTER;
                    }
                    else{DupATM = BENEFIT_TESTER;
                    }
                }
                if(BTCount == 1 && string.valueof(BTUser) != ''){
                    //BRF.Benefit_NASCO_Coder__c = NBCUser;
                }
            
            /*Benefit Coder*/
            if(BNCCount == 0){
                    if(NoATM != '' ){NoATM = NoATM + ', ' + BENEFIT_CODER;
                    }
                    else{
                    NoATM = BENEFIT_CODER;
                    }
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(BNCCount > 1){
                    if(DupATM != '' ){
                    DupATM = DupATM + ', ' + BENEFIT_CODER;
                    }
                    else{DupATM = BENEFIT_CODER;
                    }
                }
                if(BNCCount == 1 && string.valueof(BNCUser) != ''){
                    //BRF.Benefit_NASCO_Coder__c = NBCUser;
                }
            //T14 End
            /* Benefact Coder */    
                if(BCCount == 0){
                    if(NoATM != '' ){
                    NoATM = NoATM + ', ' + BENEFACT_CODER;
                    }
                    else{NoATM = BENEFACT_CODER;
                    }
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(BCCount > 1){
                    if(DupATM != '' ){
                    DupATM = DupATM + ', ' + BENEFACT_CODER;
                    }
                    else{DupATM = BENEFACT_CODER;
                    }
                }
                if(BCCount == 1 && string.valueof(BCUser) != ''){
                    BRF.BeneFact_Coder__c = BCUser;
                }
                
            /* Ancillary Analyst */ 
            /*T15 -- Start    
            if(AACount == 0){
                    if(NoATM != '' ){
                    NoATM = NoATM + ', ' + ANCILLARY_ANALYST;
                    }
                    else{NoATM = ANCILLARY_ANALYST;
                    }
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(AACount > 1){
                    if(DupATM != '' ){DupATM = DupATM + ', ' + ANCILLARY_ANALYST;
                    }
                    else{DupATM = ANCILLARY_ANALYST;
                    }
                }
                if(AACount == 1 && string.valueof(AAUser) != ''){
                    BRF.Ancillary_Analyst__c = AAUser;
                }*/
            //T15 -- End
            
            //T16 --START
            if(VACount == 0){
                    if(NoATM != '' ){
                    NoATM = NoATM + ', ' + VISION_ANALYST;
                    }
                    else{NoATM = VISION_ANALYST;
                    }
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(VACount > 1){
                    if(DupATM != '' ){DupATM = DupATM + ', ' + VISION_ANALYST;
                    }
                    else{DupATM = VISION_ANALYST;
                    }
                }
                if(VACount == 1 && string.valueof(VAUser) != ''){
                    //BRF.Ancillary_Analyst__c = AAUser;
                }
            //T16 --END
                
            /* MAST Tech */ 
                if(MTCount == 0){
                    if(NoATM != '' ){
                    NoATM = NoATM + ', ' + MAST_TECH;
                    }
                    else{NoATM = MAST_TECH;
                    }
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(MTCount > 1){
                    if(DupATM != '' ){DupATM = DupATM + ', ' + MAST_TECH;
                    }
                    else{DupATM = MAST_TECH;
                    }
                }
                if(MTCount == 1 && string.valueof(MTUser) != ''){
                    BRF.MAST_Tech__c = MTUser;
                }
                system.debug(Logginglevel.INFO,'@@@AMCount '+AMCount );
            /* Account Manager */   
                if(AMCount == 0){
                    if(NoATM != '' ){
                    NoATM = NoATM + ', ' + ACCOUNT_MGR;
                    }
                    else{
                    NoATM = ACCOUNT_MGR;
                    }
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(AMCount > 1){
                    if(DupATM != '' ){DupATM = DupATM + ', ' + ACCOUNT_MGR;
                    }
                    else{DupATM = ACCOUNT_MGR;
                    }
                }
                system.debug(Logginglevel.INFO,'@@@DupATM '+DupATM );
                if(AMCount == 1 & string.valueof(AMUser) != ''){
                    BRF.Account_Manager_Account_Team__c = AMUser;
                }
            /* Account Executive */ 
                if(AECount == 0){
                    if(NoATM != '' ){
                    NoATM = NoATM + ', ' + AIA_Constants.ACCOUNTEXECUTIVE;
                    }
                    else{NoATM = AIA_Constants.ACCOUNTEXECUTIVE;
                    }
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(AECount > 1){
                    if(DupATM != '' ){DupATM = DupATM + ', ' + AIA_Constants.ACCOUNTEXECUTIVE;
                    }
                    else{DupATM = AIA_Constants.ACCOUNTEXECUTIVE;
                    }
                }
                if(AECount == 1 &&  string.valueof(AEUser) != ''){
                    BRF.Account_Executive_Account_Team__c = AEUser;
                }
                
                
              /* Implementation Manager */ 
              /*  if(IMCount == 0){
                    if(NoATM != '' ){
                    NoATM = NoATM + ', ' + AIA_Constants.IMP_MANAGER;
                    }
                    else{
                    NoATM = AIA_Constants.IMP_MANAGER;
                    }
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(IMCount > 1){
                    if(DupATM != '' ){
                    DupATM = DupATM + ', ' + AIA_Constants.IMP_MANAGER;
                    }
                    else{
                    DupATM = AIA_Constants.IMP_MANAGER;
                    }
                } */
                if(IMCount == 1 &&  string.valueof(IMUser) != ''){
                    BRF.Implementation_Manager_Account_Team__c = IMUser;
                }
                system.debug(Logginglevel.INFO,'@@@IMIMCount '+IMCount );
                system.debug(Logginglevel.INFO,'@@@IMIMUser '+IMUser);
                system.debug(Logginglevel.INFO,'@@@IMBRF.Implementation_Manager_Account_Team__c '+BRF.Implementation_Manager_Account_Team__c);
                //T17-- Start 
               //To avoid validation errors during BRF cloning
            if(AIA_BRF_DeepClone.isClone != null && AIA_BRF_DeepClone.isClone){
                hasSkipBRFVRs_CustPerm=true;
                IgnoreValidations=true;
            }
            //T17-- End
           If( !hasSkipBRFVRs_CustPerm || !IgnoreValidations ){
               System.debug('AIA_Utils.isClone2'+AIA_BRF_DeepClone.isClone);
               //If No duplicate Account Team Member present & No required Account Team member.
               if(!String.ISBLANK(NoATM) && String.ISBLANK(DupATM)){
                   BRF.adderror(ERROR1 + ' ' + NoATM);
               } 
               //If required Account Team member present & duplicate Account Team Member.
               if(!String.ISBLANK(DupATM) && String.ISBLANK(NoATM)){BRF.adderror(ERROR2 + ' ' + DupATM + ' ' + ERROR3);
               }
               //If Account has Duplicate Account Team Member & does not have required Account Team member.
               if(!String.ISBLANK(DupATM) && !String.ISBLANK(NoATM)){
                   BRF.adderror(ERROR1 + ' ' + NoATM + ' & ' + ERROR2 + ' ' + DupATM + ' ' + ERROR3);
               }
            }
        }
    }
 //T08  -- END --  

// T09 - START - Goutham Rapolu
    /** This method automatically sends BRF for either Sales Management approval or ARC Approval or Underwriting and still keep the sequence of these approvals intact **/
 Public Static Void Send_For_SalesMgmt_or_ARC_or_UW_Approval(List<Benfit_Request_Form__c> listBRF,MAP<id,Benfit_Request_Form__c> OLDMAP){
     //Set Request Type of BRF with all Off-Cycle.
     set<string> requesttype = new set<string>{'Off-Cycle','Off-Cycle - Administrative Change','Off-Cycle - Benefit Change','Off-Cycle - Administrative and Benefit Change'};
     //Trigger.New BRF
     Benfit_Request_Form__c BRF = listBRF[0];//new Benfit_Request_Form__c(
     Benfit_Request_Form__c BRFtoupdate = new Benfit_Request_Form__c(id=listBRF[0].id);
     //Trigger.Old BRF
     Benfit_Request_Form__c BRFold = OLDMAP.get(BRF.id);
     system.debug('@@SendforSalesMgmtApproval@@'+BRF.id+'oldid'+BRFold.id);
     system.debug('@@SendforSalesMgmtApproval@@'+BRF.sales__c+'oldid'+BRFold.sales__c);
     opportunity opp = [select id,account.id,Business_Type__c,(select Id from Proposal_Request_Forms__r) from opportunity where id=: BRF.Opportunity__c]; 
     boolean hasdoc = false;
     //AIA_Document__c AIADoc = new AIA_Document__c();
     if(opp.Business_Type__c == 'New'){
         benfit_request_form__c brfdoc = [select id, (Select Id, Document_Type__c from File_Net_Documents__r where Document_Type__c =:  'Census Information') from Benfit_Request_Form__c where Id=:BRF.id];
         //AIADoc = [Select Id, Document_Type__c from AIA_Document__c Where Benefit_Request_Form__c=: listBRF[0].id];
         if(brfdoc.File_Net_Documents__r.size()>0){
             hasdoc = true;
             }
     }
    //Skip if has Skip BRF VR's custom Permission.
     if(!hasSkipBRFVRs_CustPerm)
       {
         //Submit to ARC if Sales Management Approval is Approved.
         if(requesttype.contains(BRF.Request_Type__c) && BRF.sales__c == 'Approved' && BRF.sales__c != BRFold.Sales__c){
             ApexPages.StandardController con = new ApexPages.StandardController(BRF);
             AIA_BRFSubmitArcApprovalCtrlExtension ARC = new AIA_BRFSubmitArcApprovalCtrlExtension(con);
             ARC.brfRecId = BRF.id;
             ARC.displayPopup = false;
             ARC.submitBrfForArchApproval();
             system.debug('@@SendforSalesMgmtApproval@@'+ARC.brfRecId+'@@@'+ARC.displayPopup);
          }
          system.debug('@@underwritingold'+BRF.Submit_to_Underwriting__c);
          //Submit to Underwriting if Sales Management Approval & ARC Approval is Approved.
    
    // T10- Start Below if & else if conditions have no logic. Hence commenting the code
      
      //if((((listBRF[0].Funding_Arrangements__c == 'ASO' || listBRF[0].Funding_Arrangements__c == 'Other') && listBRF[0].Stop_Loss__c != 'CareFirst'  && (listBRF[0].Request_Type__c == 'Off-Cycle - Benefit Change' || listBRF[0].Request_Type__c == 'Off-Cycle - Administrative and Benefit Change')) || (listBRF[0].MHP_Required__c == null || listBRF[0].Request_Type__c == 'Off-Cycle - Administrative Change'))      //T13
         if((((listBRF[0].Funding_Arrangements__c == 'ASO' || listBRF[0].Funding_Arrangements__c == 'Other') && listBRF[0].Stop_Loss__c != 'CareFirst'  && (listBRF[0].Request_Type__c == 'Off-Cycle - Benefit Change' || listBRF[0].Request_Type__c == 'Off-Cycle - Administrative and Benefit Change')) || (listBRF[0].Request_Type__c == 'Off-Cycle - Administrative Change'))   //T13
        && (listBRF[0].ARC_Approval_Status__c == 'Approved by Committee' || listBRF[0].ARC_Approval_Status__c == 'Auto-Approved by System'))
            {
                //Noupdate required.
            }    
      //else if((((listBRF[0].Funding_Arrangements__c == 'ASO' || listBRF[0].Funding_Arrangements__c == 'Other') && listBRF[0].Stop_Loss__c != 'CareFirst'  && (listBRF[0].Request_Type__c == 'Set-up Change - Benefit Changes' || listBRF[0].Request_Type__c == 'Set-up Change - Admin and Benefit Changes')) || ((listBRF[0].MHP_Required__c == null || listBRF[0].Request_Type__c == 'Set-up Change - Administrative Changes')) )        //T13
        else if((((listBRF[0].Funding_Arrangements__c == 'ASO' || listBRF[0].Funding_Arrangements__c == 'Other') && listBRF[0].Stop_Loss__c != 'CareFirst'  && (listBRF[0].Request_Type__c == 'Set-up Change - Benefit Changes' || listBRF[0].Request_Type__c == 'Set-up Change - Admin and Benefit Changes')) || ( listBRF[0].Request_Type__c == 'Set-up Change - Administrative Changes') )  //T13
                && (listBRF[0].ARC_Approval_Status__c == 'Approved by Committee' || listBRF[0].ARC_Approval_Status__c == 'Auto-Approved by System'))
          {
              //Noupdate required.
          }
      else if(!hasdoc && opp.Proposal_Request_Forms__r.size()==0 && opp.Business_Type__c == 'New'
            && ((listBRF[0].ARC_Approval_Status__c == 'Approved by Committee' || listBRF[0].ARC_Approval_Status__c == 'Auto-Approved by System') && listBRF[0].Submit_to_Underwriting__c == false)
            ){
                //Noupdate required.
           system.debug('@@census document inside');
           } 
      
      else if(((listBRF[0].ARC_Approval_Status__c == 'Approved by Committee' || listBRF[0].ARC_Approval_Status__c == 'Auto-Approved by System')
                && listBRF[0].Submit_to_Underwriting__c == false )){
                      BRFtoupdate.Submit_to_Underwriting__c = True;
                      if(Approval.isLocked(listBRF[0]) == false)
                      update BRFtoupdate;
                      system.debug('@@underwriting'+BRF.Submit_to_Underwriting__c);
          }
      }       
    
  }
  // T09 - END - Goutham Rapolu
}