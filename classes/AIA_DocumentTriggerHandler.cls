/***************************************************************************************************************
* Date      : 05/31/2016
* Developer : Spandhan Zangam 
* Purpose   : Trigger handler for AIA Document trigger
*===============================================================================================================
*                        --Update History--
* Date         Developer       Tag         Description
*===============================================================================================================
* 06-16-2016 | Spandhan      |     | Initial Development
* 08-12-2016 | Chida         |     | User story :B-03392 Validate Approvers Implementation PM and Account  
*                                    Manager When Uploading Group Structure Document Tag UB-03392
* 02-23-2017 | Rajesh Pennam |     | B-03720 Update ADR to be populated for Mock ID/ Producation ID Approvals
* 04-27-2017 | Asif Kutagulla| T02 | Added method call to update Department/Sub-Department based on Document Type
* 08-29-2017 | Raviteja      | T03 | Added method call to check if the owner is the deleting user
* 09-11-2017 | Raviteja      | T04 | Added method to update the "Attachment With Supporting Detail" check box on GSRF
* 09/17/2017 | Satya         | T05 | Added methods for workplan tasks assignment 
* 13/10/2017 | Raviteja      | T06 | Commented code as part of US 209
* 11/15/2017 | Satya         | T07 | Added for Docusign user story when document is returned back from Docusign
* 03/22/2018 | Phani         | T08 | Added code for US477
* 04/26/2018 | Asif Kutagulla| T09 | Added text in ERROR1 in two different lines
* 05/03/2017 | Raviteja      | T10 | Added code to uncheck edit field,change picklist to backend.
*5/29/2018   | Satya         | T11 | Added as a part of US2861, to send notification when Quote Doc is uploaded.
* 06/08/2018 | Phani         | T12 | Added code for role updates
* 07/04/2018 | Sajitha Y     | T13 | Moved AIA User Approver field update inside customer support as part of defect 39656
* 10/07/2018 | Rajesh Nagandl| T14 | Updating Gs status as Approved. To start dependent subprocess. Replacement of Process builder.

* 10/13/2018 | Naga Kandukoor| T15 | Updating effective dt field on AIA document on basis of category field
* 10/23/2018 | Paritosh      | T16 | Update field Benefit Design Document Uploaded
* 1/8/2019   | Chaithra P V  | T17 | Updated vision analyst and pharmacy operations field to have value from account team
                                     inorder to send a notification on GS final based on US1702
* 10/23/2018 | Raviteja      | T18 | Added Group Structure with BGI doc type to populate approver fields.

***************************************************************************************************************/

public Class AIA_DocumentTriggerHandler{  

    //for storing diiferent accountTeamRole
    public static final string BILLING_TECH = 'Billing Tech'; 
    public static final string QA_AUDITOR = 'QA Auditor';
    public static final string SETTLEMENTS_ANALYST = 'Settlements Analyst';
    public static final string IMPLEMENTATION_PM = 'Implementation Manager';
    public static final string ACCOUNT_MANAGER = 'Account Manager';
    public static final string CUSTOMER_SUPPORT = 'AIA User';  //T12
    public static final string PAR_PLAN = 'AIA User';    //T12
    public static final string MAST_TECH = 'MAST Tech';
    public static final string VISION_ANALYST ='Vision Analyst';//T17
    public static final string PHARMACY_OPERATIONS='Pharmacy Operations';//T17
    public static final string INSERTS = 'Insert';
    public static final string AIADocument = 'AIA_Document__c';
    public static final string ADR = 'Account Dedicated Representative'; // @ 02/23/2017 Rajesh Added 'ADR'
    public static  boolean afterUpdateRecursive = false;
    public static  boolean beforeUpdateRecursive = false;

    // for storing different document type
    public static final string PRODUCTION_ID_CARD = 'Production Id Card';
    public static final string MOCK_ID_CARD = 'Mock ID Card';
    public static final string GROUP_STRUCTURE_DOCUMENT = 'Group Structure Document';
    //T18
    public static final string GROUP_STRUCTURE_DOCUMENT_BGI = 'Group Structure with BGI';
    public static final string ERROR1 = 'The Implementation Manager and Account Manager are required to be setup on the Account as they are approvers '+
                                        'for the Group Structure document to be uploaded. Please contact the Implementation manager';//T09
    
    public static Final Set<String> accTeamList = new Set<String>{VISION_ANALYST,PHARMACY_OPERATIONS,IMPLEMENTATION_PM,CUSTOMER_SUPPORT,ACCOUNT_MANAGER,PAR_PLAN,BILLING_TECH,SETTLEMENTS_ANALYST,QA_AUDITOR,MAST_TECH,ADR}; // //@ 02/23/2017 Rajesh Added 'ADR'//T17 ADDED vISION AND PHARMACY
        //T18
     @testvisible set<string> docTypes = new set<string>{PRODUCTION_ID_CARD,MOCK_ID_CARD,GROUP_STRUCTURE_DOCUMENT,GROUP_STRUCTURE_DOCUMENT_BGI};
            set<string> prodIdCardTeamRoles = new set<string>{'Implementation Manager','AIA User','Account Dedicated Representative'}; //@ 02/23/2017 Rajesh Added 'ADR'  
                set<string> mockIdCardTeamRoles = new set<string>{'Implementation Manager','AIA User','Account Manager','AIA User','Account Dedicated Representative'}; //@ 02/23/2017 Rajesh Added 'ADR'
                    set<string> grpStructDocTeamRoles = new set<string>{'Vision Analyst','Pharmacy Operations','QA Auditor','Billing Tech','Settlements Analyst','Implementation Manager','Account Manager','MAST Tech'};
                        Integer ImpPM = 0;
    Integer AccountManager = 0;
    
    /** T03-start **/
    //Execute before delete Logic to handle the owner change and assign to Mast logic
     public void beforeDelete(List<AIA_Document__c> lstAIADocument){
         AIA_DocumentTriggerHelper adtp = new AIA_DocumentTriggerHelper();
         adtp.validateStatus(lstAIADocument);
         
     }
    /** T03-End **/

    public void AfterInsert(List<AIA_Document__c> lstAIADocument,Map<id,AIA_Document__c> mapDocMap){

         AIA_DocumentTriggerHelper adtp = new AIA_DocumentTriggerHelper();
        /** T04-Start **/
         adtp.attachmentDetailCheck(lstAIADocument);
         /** T04-End **/

        //T16 Start
        adtp.updateBenefitDesignDocumentUploadedField(lstAIADocument);
        //T16 End

      
       //T11 - To Send notification to Account Executive, and Sales Assistant when Quote doc is uploaded
        if(!beforeUpdateRecursive){
        AIA_SendEmail_Notification notify = new AIA_SendEmail_Notification();
        notify.notifyQuoteToAccMem(lstAIADocument);
         beforeUpdateRecursive =true;
         afterUpdateRecursive = true; //T15 10/13/2018
         UpdateEffectiveDate(lstAIADocument); // T15 10/13/2018
       
        }
        //T11- Changes Ends 
        
     if(!test.isrunningtest()){    
        // T05 Added for workplan tasks assignment
        AIA_Workplan_Task_Management wtm = new AIA_Workplan_Task_Management();
        wtm.createWorkplanTasksForSObject(INSERTS, mapDocMap, AIADocument);
        AIA_WorkPlanTasks_Completion WTC = new AIA_WorkPlanTasks_Completion();
        WTC.completionWorkplanTasksForAIADocument(INSERTS, lstAIADocument, AIADocument);
        
            }
    }
    
    public void AfterDelete(List<AIA_Document__c> lstAIADocument){

         AIA_DocumentTriggerHelper adtp = new AIA_DocumentTriggerHelper();
        /** T04-Start **/
         adtp.attachmentDetailCheck(lstAIADocument);
         /** T04-End **/
    }
    
    // EXECUTE BEFORE INSERT LOGIC    
    public void beforeInsert(List<AIA_Document__c> lstAIADocument){
        system.debug('inside beforeinsert'+lstAIADocument);
        /** T02-Start **/
        AIA_DocumentTriggerHelper adtp = new AIA_DocumentTriggerHelper();
        adtp.setAIADoc_Department_SubDepartment(lstAIADocument);
        /** T02-End   **/
        
        Set<Id> setAccountId=new Set<Id>();
        system.debug('docTypes' + docTypes);
        system.debug('accTeamList' + accTeamList);
        // Checking Account value and document type containing a vale for each record.
        for(AIA_Document__c aiaDoc : lstAIADocument){
            if(aiaDoc.Account__c != null && aiaDoc.Document_Type__c != NULL && docTypes.contains(aiaDoc.Document_Type__c)){
                // Condition is true add them to setaccountid 
                setAccountId.add(aiaDoc.Account__c);
            }
        } 
        // if setaccountid variable not null add those records for process records method.
        if(!setAccountId.isEmpty()){
            system.debug('before processRecords call');
            processRecords(setAccountId,lstAIADocument);
            }      
        /** T08-Start **/
        adtp.updateCurentBDD_CreateOp(lstAIADocument);
        /** T08-End **/
  }  
    // Esecute before Update logic 
    public void beforeUpdate(List<AIA_Document__c> lstAIADocument,Map<Id,AIA_Document__c> mapAIADocument){
    system.debug('inside before update');
if(!afterUpdateRecursive){ // T15 10/13/2018
         /** T02-Start **/
    system.debug('inside before update after afterUpdateRecursive condition check');
        AIA_DocumentTriggerHelper adtp = new AIA_DocumentTriggerHelper();
        adtp.setAIADoc_Department_SubDepartment(lstAIADocument);
        /** T02-End   **/
        
        Set<Id> setAccountId=new Set<Id>();
        
        // Checking Account value and document type containing a vale for each record.
        for(AIA_Document__c aiaDoc : lstAIADocument){
            if(aiaDoc.Account__c != null && aiaDoc.Document_Type__c != NULL && docTypes.contains(aiaDoc.Document_Type__c) 
             && aiaDoc.Document_Type__c != mapAIADocument.get(aiaDoc.Id).Document_Type__c){
                // Condition is true add them to setaccountid 
                setAccountId.add(aiaDoc.Account__c);
            }
        }
        
        system.debug('setAccountId' + setAccountId);
        // if setaccountid variable not null add those records for process records method.
        if(!setAccountId.isEmpty()){
            processRecords(setAccountId,lstAIADocument);
            }
        /** T08-Start **/
        adtp.updateCurentBDD_UpdateOp(lstAIADocument);
        /** T08-End **/
        }
    }
    public void afterupdate(List<AIA_Document__c> lstAIADocument,Map<Id,AIA_Document__c> mapAIADocument){

         system.debug('--SMSL Handler-->');
         if(!afterUpdateRecursive){ // T15 10/13/2018
         //T07 changes
         AIA_Send_BAA_For_Approval aba = new AIA_Send_BAA_For_Approval();
         aba.sendToApproval(lstAIADocument);


         /*T14-Start*/
         AIA_DocumentTriggerHelper adtp = new AIA_DocumentTriggerHelper();
         adtp.updateGSdocimp(lstAIADocument);
         afterUpdateRecursive = true; //T15 10/13/2018
         UpdateEffectiveDate(lstAIADocument);//T15 10/13/2018
            
        }
        /* T14-End*/

         //T07 changes ends
         //T10  start-  update GS unchecking checkbox and make piclist to backend
         /*
        if(!afterUpdateRecursive){
         AIA_DocumentTriggerHelper adtp = new AIA_DocumentTriggerHelper();
         adtp.updateGS(lstAIADocument);
         UpdateEffectiveDate(lstAIADocument); //T15 10/13/2018
         afterUpdateRecursive = true;
        }*/ //Commented for R1 Deployment
         //T10  End

    } 
    
    // Process the records to match lookup fields on AIA DOcument 
    public void processRecords(Set<Id> setAccId, List<AIA_Document__c> lstAIADocument){
        map<id,list<Account_Team__c>> mapOfAccountwithTeamMember=new map<id,list<Account_Team__c>>(); //added by rajesh
        map<string,id> maproleuserid=new map<string,id>();
        list<Account_Team__c> listOfAccountteamMember= new  list<Account_Team__c>();
        
        List<Account_Team__c> lstAcTeamMembr=new List<Account_Team__c>();
        Account_Team__c acctTM = new Account_Team__c();
        for(Account_Team__c at:[select UserId__c,AccountId__c,TeamMemberRole__c from Account_Team__c where AccountId__c IN : setAccId and TeamMemberRole__c IN: accTeamList]){
        system.debug('lstAcTeamMembr' + lstAcTeamMembr);
        // @02/23/2017 Rajesh added
            lstAcTeamMembr.add(at);
            if(mapOfAccountwithTeamMember.containskey(at.AccountId__c) &&  mapOfAccountwithTeamMember.get(at.AccountId__c)!= NULL){
                
                listOfAccountteamMember = new  list<Account_Team__c>();
                listOfAccountteamMember= mapOfAccountwithTeamMember.get(at.AccountId__c);
                listOfAccountteamMember.add(at);
                mapOfAccountwithTeamMember.put(at.AccountId__c,listOfAccountteamMember);
            }
            else{
                listOfAccountteamMember = new  list<Account_Team__c>();
                listOfAccountteamMember.add(at);
                mapOfAccountwithTeamMember.put(at.AccountId__c,listOfAccountteamMember);
            }
                    
                
            
        }
        // @02/23/2017 Rajesh end
        
        if(!lstAcTeamMembr.isEmpty()){    
            system.debug('INSIDE>> '+ lstAIADocument);
            List<AIA_Document__c> lstDoc = new List<AIA_Document__c>();
            for(AIA_Document__c doc : lstAIADocument){
                //system.debug('FOR LOOP>>> '+doc);
                for(Account_Team__c accTeam:lstAcTeamMembr){ 
                    //system.debug('accTeam>> '+accTeam);
                    if(doc.Account__c == accTeam.AccountId__c){ 
                        //added by rejesh
                        for(Account_Team__c atmm:mapOfAccountwithTeamMember.get(doc.Account__c)){
                                        
                                        maproleuserid.put(atmm.TeamMemberRole__c,atmm.UserId__c);
                        }   
                        //system.debug('>ACC> '+doc.Document_Type__c);
                        //system.debug('>ACC TEAM Role> '+accTeam.TeamMemberRole);
                        if(doc.Document_Type__c == PRODUCTION_ID_CARD && accTeam.TeamMemberRole__c != NULL && prodIdCardTeamRoles.contains(accTeam.TeamMemberRole__c)){
                            //system.debug('1111');
                            if(accTeam.TeamMemberRole__c == IMPLEMENTATION_PM ){
                                doc.Approver_Implementation_Team__c = accTeam.UserId__c;                                
                            }
                            else if(accTeam.TeamMemberRole__c == CUSTOMER_SUPPORT || accTeam.TeamMemberRole__c == ADR ){
                                if(!maproleuserid.isEmpty()){
                                doc.Approver_Customer_Support__c = maproleuserid.get(CUSTOMER_SUPPORT); // @02/23/2017 Rajesh added 
                                doc.Approver_Account_Dedicated_Rep__c = maproleuserid.get(ADR); // @02/23/2017 Rajesh added 'ADR' to auto-populate
                            }
                            }
                            
                        }else if(doc.Document_Type__c == MOCK_ID_CARD && accTeam.TeamMemberRole__c != NULL && mockIdCardTeamRoles.contains(accTeam.TeamMemberRole__c )){
                            //system.debug('2222');
                            if(accTeam.TeamMemberRole__c == IMPLEMENTATION_PM){
                                doc.Approver_Implementation_Team__c = accTeam.UserId__c;
                            }else if(accTeam.TeamMemberRole__c == CUSTOMER_SUPPORT || accTeam.TeamMemberRole__c == ADR ){
                                doc.Approver_Customer_Support__c = maproleuserid.get(CUSTOMER_SUPPORT); //@02/23/2017 Rajesh added                               
                                doc.Approver_Account_Dedicated_Rep__c = maproleuserid.get(ADR); // @02/23/2017 Rajesh added 'ADR' to auto-populate                                
                                  //T13 - Start 
                                doc.Approver_Par_Plan__c =  maproleuserid.get(CUSTOMER_SUPPORT); // Added as part of Defect fix 39656
                                //T13 - End
                            }else if(accTeam.TeamMemberRole__c == ACCOUNT_MANAGER){
                                doc.Approver_Sales_Service_Rep__c = maproleuserid.get(ACCOUNT_MANAGER);
                            }//T13 - Start commented as part of defect 39656
                            /*else if(accTeam.TeamMemberRole == PAR_PLAN){
                                doc.Approver_Par_Plan__c = accTeam.UserId;
                            }*/
                            //T13-End
                        }
                        //T18 added bgi doc type
                        else if((doc.Document_Type__c == GROUP_STRUCTURE_DOCUMENT|| doc.Document_Type__c == GROUP_STRUCTURE_DOCUMENT_BGI) && accTeam.TeamMemberRole__c != NULL && grpStructDocTeamRoles.contains(accTeam.TeamMemberRole__c )){
                            system.debug('Group structure doc.Document_Type__c>>> '+doc.Document_Type__c);
                            // Condition is true, then assigning value in Approver_QA_Auditor__c 
                            if(accTeam.TeamMemberRole__c == QA_AUDITOR){
                                doc.Approver_QA_Auditor__c = accTeam.UserId__c;
                                
                            }
                            // Condition is true, then assigning value in Approver_Billing_Tech__c 
                            if(accTeam.TeamMemberRole__c == BILLING_TECH){
                                doc.Approver_Billing_Tech__c = accTeam.UserId__c;                                
                            }
                            if(accTeam.TeamMemberRole__c == MAST_TECH){
                                doc.LGIT_Tech__c = accTeam.UserId__c;                                                                                             
                            }
                            // Condition is true, then assigning value in Approver_Settlements_Tech__c 
                            if(accTeam.TeamMemberRole__c == SETTLEMENTS_ANALYST){
                                doc.Approver_Settlements_Tech__c = accTeam.UserId__c;
                                
                            }
                            // Condition is true, then assigning value in Approver_Implementation_Team__c 
                            if(accTeam.TeamMemberRole__c == IMPLEMENTATION_PM){
                                // ImpPM++;
                                doc.Approver_Implementation_Team__c = accTeam.UserId__c;
                                //system.debug('HEREEEE');
                            }
                            // Condition is true, then assigning value in Approver_Sales_Service_Rep__c 
                            if(accTeam.TeamMemberRole__c == ACCOUNT_MANAGER){
                                //  AccountManager++;
                                system.debug('accteam inside account manager check'+accTeam.UserId__c);
                                doc.Approver_Sales_Service_Rep__c = accTeam.UserId__c;
                            }
                            //T17 Starts
                            // Populating value to vision and pharmacy role from account team
                            if(accTeam.TeamMemberRole__c ==PHARMACY_OPERATIONS){
                               doc.Team_Pharmacy_Operations__c =accTeam.UserId__c;
                            } 
                            if(accTeam.TeamMemberRole__c ==VISION_ANALYST){
                               doc.Team_Vision_Analyst__c =accTeam.UserId__c;
                            }
                            //T17 Ends
                            
                        }                        
                        
                    }                                        
                }                
            }
        }
        for(AIA_Document__c doc1 : lstAIADocument){
            //T18 added bgi doc type
            if (doc1.Document_Type__c == GROUP_STRUCTURE_DOCUMENT || doc1.Document_Type__c == GROUP_STRUCTURE_DOCUMENT_BGI){
                for(Account_Team__c accTeam1:lstAcTeamMembr){ 
                    
                    if(accTeam1.TeamMemberRole__c == IMPLEMENTATION_PM){
                        ImpPM++;
                    }
                    if(accTeam1.TeamMemberRole__c == ACCOUNT_MANAGER){
                        AccountManager++;
                    }
                }       
                
                /* 08-12-2016 Chida : User story :B-03392 Validate Approvers When Uploading Group Structure Document 
                    Tag UB-03392 Start*/
                if(ImpPM==0 || AccountManager == 0){
                    doc1.addError(ERROR1);
                }
                //system.debug('>ImpPM44444444> '+ImpPM);
                //system.debug('>AccountManager44444> '+AccountManager);
                /* 08-12-2016 Chida : User story :B-03392 Validate Approvers When Uploading Group Structure Document 
                    Tag UB-03392  End*/
                system.debug('IMp PM' +ImpPM);
                system.debug('Account Manager' +AccountManager);
            }
        }
    }
    // Start T15 10/13/2018
    //Update effective dt basis on category field
    private void UpdateEffectiveDate(List<AIA_Document__c> lstAIADocuments)
    {
        List<AIA_Document__c> AIADocument = [select id,Category__c,Opportunity__r.Effective_Date__c,Benefit_Request_Form__r.Benefit_Effective_Date__c,Proposal_Request_Form__r.Effective_Date__c,
        Implementation__r.Effective_Date__c,Benefit_Design__r.Opportunity_Effective_Date__c,Proposed_Products__r.Effective_Date__c,Benefit_Design_Product__r.Effective_Date__c,Benefit_Design_Form__r.Effective_Date__c,Group_Structure_Request_Form__r.Effective_Date__c
         from AIA_Document__c where id in:lstAIADocuments];
         system.debug('UpdateEffectiveDate======'+AIADocument);
         
        for(AIA_Document__c aiaDoc : AIADocument){
            if(aiaDoc.Category__c != null && aiaDoc.Category__c != '')
            {
                if(aiaDoc.Category__c == 'Opportunity')
                {
                    aiaDoc.Effective_Date__c= aiaDoc.Opportunity__r.Effective_Date__c;
                }
                else if(aiaDoc.Category__c == 'Benefit Request Form')
                {
                    aiaDoc.Effective_Date__c= aiaDoc.Benefit_Request_Form__r.Benefit_Effective_Date__c;
                }
                else if(aiaDoc.Category__c == 'Proposal Request Form')
                {
                    aiaDoc.Effective_Date__c= aiaDoc.Proposal_Request_Form__r.Effective_Date__c;
                }
                else if(aiaDoc.Category__c == 'Implementation')
                {
                    aiaDoc.Effective_Date__c= aiaDoc.Implementation__r.Effective_Date__c;
                }
                else if(aiaDoc.Category__c == 'Benefit Design')
                {
                    aiaDoc.Effective_Date__c= aiaDoc.Benefit_Design__r.Opportunity_Effective_Date__c;
                }
                else if(aiaDoc.Category__c == 'Proposed Product')
                {
                    aiaDoc.Effective_Date__c= aiaDoc.Proposed_Products__r.Effective_Date__c;
                }
                else if(aiaDoc.Category__c == 'Benefit Design Product')
                {
                    aiaDoc.Effective_Date__c= aiaDoc.Benefit_Design_Product__r.Effective_Date__c;
                }               
                else if(aiaDoc.Category__c == 'Benefit Design Form')
                {
                    aiaDoc.Effective_Date__c= aiaDoc.Benefit_Design_Form__r.Effective_Date__c;
                }
                else if(aiaDoc.Category__c == 'Group Structure Request Form')
                {
                    aiaDoc.Effective_Date__c= aiaDoc.Group_Structure_Request_Form__r.Effective_Date__c;
                }
            }
            
        }
        if(AIADocument.size()>0)
            update AIADocument;
    }
    // End T15 10/13/2018
}