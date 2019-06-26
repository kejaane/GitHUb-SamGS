/*------------------------------------------------------------------------------------
 *                      ----===[ HISTORY ]===---
 * Date        Developer        Description
 *------------------------------------------------------------------------------------
 * 08/16/2016 Chida    THis class is called from Benefit  Design Trigger to populate Approvers from Accounts Team Role                                
 * 
  *************************************************************************************
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 * 03/24/2017 | Ramakrishna     | T01 | Added the logic for sending notifications to Account teams & for a List of users 
                                       when Benefit design is Approved.
 * 02/15/2018 | SATYA           | T02 | Uncommented the error code as a part of defect 38682
 * 06/08/2018 | Phani           | T03 | Added code for role updates
 * 06/19/2018 | Raviteja        | T04 | Modified code for missing account team roles
 * 06/20/2018 | Raj             | T05 | Modified code for missing account team roles
 * 09/06/2018 | Gayathri        | T06 | Updated the code handle multiple BD to check account team members
 * 11/28/2018 | Gayathri        | T07 | Replaced NASCO Benefit Coder with Benefit Tester as part of US1730
 * 12/04/2018 | Gayathri        | T08 | Commenting Ancillary Analyst as part of US1702
 * 12/05/2018 | Chaithra        | T09 | Replaced Ancillary Analyst with Vision Analyst /Pharmacy Operations as part of US1702
 * 01/31/2019 | Satya T         | T10 | Replaced standard Account Team Member with Custom Account Team Member.
*===========+============+========================================================================================
*/

/*
* @Author: Chida
* @Purpose: This class is populates following Approvers from account team role in Benefit Design
    Ancillary Analyst
    Benefit Coder
    Contract Tech
    QA Auditor
    NASCO Benefit Coder
* Input List of Benefit Request's
*/


public Class AIA_BenefitDesignApproversHelper
{

//@testvisible public static final string ACCOUNT_ANALYST = 'Ancillary Analyst';//T09
@testvisible public static final string VISION_ANALYST = 'Vision Analyst';//T09
@testvisible public static final string PHARMACY_OPERATIONS='Pharmacy Operations';//T09
@testvisible public static final string BENEFACT_CODER = 'BeneFact Coder';
@testvisible public static final string CONTRACT_TECH = 'Contract Tech';
@testvisible public static final string QA_AUDITOR = 'QA Auditor';
@testvisible public static final string MAST_TECH = 'MAST Tech';
//@testvisible public static final string NASCO_BENEFIT_CODER = 'NASCO Benefit Coder'; //T03//T07
// T01 START
@testvisible public static final string Settlements_Analyst = 'Settlements Analyst';
@testvisible public static final string Benefit_Admin_Workflow_Mgmt = 'AIA User';
@testvisible public static final string Production_ID_Card = 'Production ID Card Tech';
@testvisible public static final string Benefit_Admin_Account_Setup = 'MAIN Tech'; //T03
@testvisible public static final string Underwriter = 'Underwriter';
@testvisible public static final string Benefit_NASCO_Tester = 'BeneFact Tester';
@testvisible public static final string Account_Dedicated_Rep = 'Account Dedicated Representative'; //T03
@testvisible public static final string Account_Manager = 'Account Manager';
@testvisible public static final string Implementation_PM = 'Implementation Manager'; //T05
//@testvisible public static final string Ancillary_Analyst = 'Ancillary Analyst'; T09
public static boolean IgnoreValidations = CF_CustomPermissionsReader_Helper.Permissions.ignoreVRs;
//T01 END
@testvisible public static final string BENEFIT_TESTER = 'Benefit Tester';//T07
@testvisible public static final string BENEFIT_CODER = 'Benefit Coder';//T07   

@testvisible public static final string ERROR1 = ' role/s not configured on the Account team';
@testvisible public static final string ERROR2 = 'The following roles are defined multiple times in the Account Team:';
//@testvisible public static final string ERROR3 = 'Please define these roles only once before saving the Group Structure.';
@testvisible public static final string ERROR3 = 'Please define these roles only once before saving the Benefit Design.'; //added as a part of 38683 defect
// by commenting above line
@testvisible public static final Set<Id> setAccountId = new Set<Id>();
/*
@testvisible public static final string ACCOUNT_ANALYST_STATUS = 'Ancillary Analyst status';
@testvisible public static final string BENEFACT_CODER_STATUS = 'BeneFact Coder status';
@testvisible public static final string CONTRACT_TECH_STATUS  = 'Contract Tech status';
@testvisible public static final string MAST_TECH_STATUS  = 'MAST Tech status';
@testvisible public static final string NASCO_BENEFIT_CODER_STATUS= 'NASCO Benefit Coder status';  */

//Harsha

@testvisible public static final Set<Id> setBenifitReqFormId = new Set<Id>();
@testvisible public static final Set<string> setProductCategory = new Set<string>();

/**
* @Author: Chidananda Nagaraj
* @This Method is called from GSTrigger
* @This method - This method is validate accoutn team role on Benefit Design
* @param -  list<AIA_Benefit_Design__c>  
* @Output -
*/
public static void beforeUpdateTeamMember(List<AIA_Benefit_Design__c> lstBD)
{

    //Set of Accounts from Benefit Design
    //@TestVisible Set<Id> setAccountId = new Set<Id>();
    for(AIA_Benefit_Design__c bd : lstBD)
    {
         //Get Account Id's
        setAccountId.add(bd.Account__c);
        setBenifitReqFormId.add(bd.Benefit_Request_Form__c);//Harsha
    }
    
    //Get Benifit Request form Child Proposed Products Records, Harsha
    List<Proposed_Products__c> ProposedProductLst = [select Id,Name,Product_Category__c from Proposed_Products__c where Benefit_Request_Form__c IN :setBenifitReqFormId];
    if(ProposedProductLst != null && ProposedProductLst.size()>0){
    for(Proposed_Products__c pp:ProposedProductLst){
        if(string.isNotBlank(pp.Product_Category__c)){
            setProductCategory.add(pp.Product_Category__c);
   }
  
    }
 } //Harsha
    List<string> accRoleName = New List<String>{PHARMACY_OPERATIONS,VISION_ANALYST,BENEFACT_CODER,CONTRACT_TECH,QA_AUDITOR,MAST_TECH,BENEFIT_TESTER,Settlements_Analyst,Benefit_Admin_Workflow_Mgmt,Production_ID_Card,Benefit_Admin_Account_Setup,Underwriter,Benefit_NASCO_Tester,Account_Dedicated_Rep,Account_Manager,Implementation_PM,BENEFIT_CODER};//T07
    //T06 Start//
    //Map<String,String> mapRoleWithUserId = new Map<String,String>();
    //Map<String,Integer> mapRoleWithCount = new Map<String,Integer>();
    Map<Id,Map<String,String>> mapAccRoleWithUserId = new Map<Id,Map<String,String>>();
    Map<Id,Map<String,Integer>> mapAccRoleWithCount = new Map<Id,Map<String,Integer>>();
    //T06 End//
    Integer AccountAnalyst = 0;
    Integer BenefactCoder = 0;
    Integer ContractTech = 0;
    Integer QAAuditor = 0;
    Integer MastTech = 0;
    Integer NASCOBenefitCoder = 0;
    //T01 Start    
    Integer SettlementsAnalyst = 0;
    Integer BenefitAdminWorkflowMgmt = 0;
    Integer ProductionIDCard  = 0;
    Integer BenefitAdminAccountSet = 0;
    Integer vUnderwriter = 0;
    Integer BenefitNASCOTester = 0;
    Integer AccountDedicatedRep = 0;
    Integer AccountManager = 0;
    Integer ImplementationPM = 0;
    Integer AncillaryAnalyst = 0;
    //T01 End

    system.debug('setAccountId::'+ setAccountId);
   // doing query on account team member role and add data in map and integer varibale
   
     /* T10 -- Start*/
  // For(AccountTeamMember accTeam : [select UserId,AccountId,TeamMemberRole from AccountTeamMember where AccountId IN : setAccountId and TeamMemberRole IN: accRoleName]){
     For(Account_Team__c accTeam : [select UserId__c,AccountId__c,TeamMemberRole__c from Account_Team__c where AccountId__c IN : setAccountId and TeamMemberRole__c IN: accRoleName]){
      //T06 -- Start
      //mapRoleWithUserId.put(accTeam.TeamMemberRole,accTeam.UserID);
      //if(mapAccRoleWithUserId.containsKey(accTeam.AccountId))
      if(mapAccRoleWithUserId.containsKey(accTeam.AccountId__c))
      {
         //mapAccRoleWithUserId.get(accTeam.AccountId).put(accTeam.TeamMemberRole,accTeam.UserID);
           mapAccRoleWithUserId.get(accTeam.AccountId__c).put(accTeam.TeamMemberRole__c ,accTeam.UserId__c); 
      }
      else
      {
         //mapAccRoleWithUserId.put(accTeam.AccountId,new Map<String,String>{accTeam.TeamMemberRole=>accTeam.UserID});
           mapAccRoleWithUserId.put(accTeam.AccountId__c,new Map<String,String>{accTeam.TeamMemberRole__c=>accTeam.UserId__c});  
      }
      //if(mapAccRoleWithCount.containsKey(accTeam.AccountId))
        if(mapAccRoleWithCount.containsKey(accTeam.AccountId__c))
            {
            //Map<String,Integer> roleCount=mapAccRoleWithCount.get(accTeam.AccountId);
              Map<String,Integer> roleCount=mapAccRoleWithCount.get(accTeam.AccountId__c);
                //if(roleCount.containsKey(accTeam.TeamMemberRole))
                  if(roleCount.containsKey(accTeam.TeamMemberRole__c))
                   {
                     // roleCount.put(accTeam.TeamMemberRole,roleCount.get(accTeam.TeamMemberRole)+1); 
                        roleCount.put(accTeam.TeamMemberRole__c,roleCount.get(accTeam.TeamMemberRole__c)+1);
                   }
                   else
                   {
                      //roleCount.put(accTeam.TeamMemberRole,1); 
                        roleCount.put(accTeam.TeamMemberRole__c,1); 
                   }
            }
          else
            {
            //mapAccRoleWithCount.put(accTeam.AccountId,new Map<String,Integer>{accTeam.TeamMemberRole=>1});
              mapAccRoleWithCount.put(accTeam.AccountId__c,new Map<String,Integer>{accTeam.TeamMemberRole__c=>1});
              /* T10 -- End*/
            }
      /*If(accTeam.TeamMemberRole == ACCOUNT_ANALYST){
          AccountAnalyst++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,AccountAnalyst);
          
      }
      If(accTeam.TeamMemberRole == BENEFACT_CODER){
          BenefactCoder++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,BenefactCoder);
          
      }
      If(accTeam.TeamMemberRole == CONTRACT_TECH){
          ContractTech++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,ContractTech);
      }
      If(accTeam.TeamMemberRole == QA_AUDITOR){
          QAAuditor++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,QAAuditor);
      }
      If(accTeam.TeamMemberRole == MAST_TECH){
          MastTech++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,MastTech);
      }
       If(accTeam.TeamMemberRole == NASCO_BENEFIT_CODER){
          NASCOBenefitCoder++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,NASCOBenefitCoder);
      }
    //T01 Start    
      If(accTeam.TeamMemberRole == Settlements_Analyst){
          SettlementsAnalyst++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,SettlementsAnalyst);
      }
      If(accTeam.TeamMemberRole == Benefit_Admin_Workflow_Mgmt){
          BenefitAdminWorkflowMgmt++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,BenefitAdminWorkflowMgmt);
      }
      If(accTeam.TeamMemberRole == Production_ID_Card){
          ProductionIDCard++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,ProductionIDCard);
      }
      If(accTeam.TeamMemberRole == Benefit_Admin_Account_Setup){
          BenefitAdminAccountSet++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,BenefitAdminAccountSet);
      }
      If(accTeam.TeamMemberRole == Underwriter){
          vUnderwriter++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,vUnderwriter);
      }
      If(accTeam.TeamMemberRole == Benefit_NASCO_Tester){
          BenefitNASCOTester++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,BenefitNASCOTester);
      }
      If(accTeam.TeamMemberRole == Account_Dedicated_Rep){
          AccountDedicatedRep++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,AccountDedicatedRep);
      }
      If(accTeam.TeamMemberRole == Account_Manager){
          AccountManager++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,AccountManager);
      }
      If(accTeam.TeamMemberRole == Implementation_PM){
          ImplementationPM++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,ImplementationPM);
      }
        //T06 End
      /*If(accTeam.TeamMemberRole == Ancillary_Analyst){
          AncillaryAnalyst++;
          mapRoleWithCount.put(accTeam.TeamMemberRole,AncillaryAnalyst);
      }*/            
      //T01 End
   }
    //T06 Start -- Updated the Map<String,String> to Map<Id,Map<String,string>> to handle account team members for multiple Accounts//
    for(AIA_Benefit_Design__c objBD : lstBD)
    {
      if( mapAccRoleWithUserId != null && !mapAccRoleWithUserId.isEmpty() && mapAccRoleWithUserId.containsKey(objBD.Account__c) && 
        mapAccRoleWithCount !=null && mapAccRoleWithCount.containsKey(objBD.Account__c))
      {
        //T08 Start
          /*if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(ACCOUNT_ANALYST))
        {
        if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(ACCOUNT_ANALYST) && mapAccRoleWithCount.get(objBD.Account__c).get(ACCOUNT_ANALYST) == 1 && (setProductCategory.contains('Drug') || setProductCategory.contains('Dental') || setProductCategory.contains('Vision'))) // if mapRoleWithCount is 1, then assigning the values
              objBD.Approver_Ancillary_Analyst__c = mapAccRoleWithUserId.get(objBD.Account__c).get(ACCOUNT_ANALYST);
          
          if(mapRoleWithCount != null && mapRoleWithCount.containsKey(ACCOUNT_ANALYST) && mapRoleWithCount.get(ACCOUNT_ANALYST) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Approver_Ancillary_Analyst__c = mapRoleWithUserId.get(ACCOUNT_ANALYST);
          else if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(ACCOUNT_ANALYST) && mapAccRoleWithCount.get(objBD.Account__c).get(ACCOUNT_ANALYST) != 1){ // if mapRoleWithCount is not 1, then throwing the error
              objBD.addError(ERROR2 + ' ' + ACCOUNT_ANALYST+ '. ' + ERROR3); //T02 change
          } 
        }*/
          //T08 End
          //T09 STARTS
       if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(VISION_ANALYST))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(VISION_ANALYST) && mapAccRoleWithCount.get(objBD.Account__c).get(VISION_ANALYST) == 1 && setProductCategory.contains('Vision')) // if mapRoleWithCount is 1, then assigning the values
              objBD.Approver_Vision_Analyst__c= mapAccRoleWithUserId.get(objBD.Account__c).get(VISION_ANALYST);
          else if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(VISION_ANALYST) && mapAccRoleWithCount.get(objBD.Account__c).get(VISION_ANALYST) != 1){// if mapRoleWithCount is not 1, then throwing the error
              objBD.addError(ERROR2 + ' ' + VISION_ANALYST + '. ' + ERROR3);
            
          }

        }
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(PHARMACY_OPERATIONS))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(PHARMACY_OPERATIONS) && mapAccRoleWithCount.get(objBD.Account__c).get(PHARMACY_OPERATIONS) == 1 && setProductCategory.contains('Drug')) // if mapRoleWithCount is 1, then assigning the values
              objBD.Approver_Pharmacy_Operations__c= mapAccRoleWithUserId.get(objBD.Account__c).get(PHARMACY_OPERATIONS);
          else if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(PHARMACY_OPERATIONS) && mapAccRoleWithCount.get(objBD.Account__c).get(PHARMACY_OPERATIONS) != 1){// if mapRoleWithCount is not 1, then throwing the error
              objBD.addError(ERROR2 + ' ' + PHARMACY_OPERATIONS + '. ' + ERROR3);
            }
   
        }
          //T09 Ends
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(BENEFACT_CODER))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(BENEFACT_CODER) && mapAccRoleWithCount.get(objBD.Account__c).get(BENEFACT_CODER) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.AIA_Approver_Benefact_Coder__c= mapAccRoleWithUserId.get(objBD.Account__c).get(BENEFACT_CODER);
          else if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(BENEFACT_CODER) && mapAccRoleWithCount.get(objBD.Account__c).get(BENEFACT_CODER) != 1){// if mapRoleWithCount is not 1, then throwing the error
              objBD.addError(ERROR2 + ' ' + BENEFACT_CODER + '. ' + ERROR3);
          }
        }
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(CONTRACT_TECH))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(CONTRACT_TECH) && mapAccRoleWithCount.get(objBD.Account__c).get(CONTRACT_TECH) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Approver_Contract_Tech__c = mapAccRoleWithUserId.get(objBD.Account__c).get(CONTRACT_TECH);
          else if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(CONTRACT_TECH) && mapAccRoleWithCount.get(objBD.Account__c).get(CONTRACT_TECH) != 1){// if mapRoleWithCount is not 1, then throwing the error
              objBD.addError(ERROR2 + ' ' + CONTRACT_TECH + '. ' + ERROR3);
          }
        }
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(QA_AUDITOR))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(QA_AUDITOR) && mapAccRoleWithCount.get(objBD.Account__c).get(QA_AUDITOR) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Approver_QA_Auditor__c = mapAccRoleWithUserId.get(objBD.Account__c).get(QA_AUDITOR);
          else if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(QA_AUDITOR) && mapAccRoleWithCount.get(objBD.Account__c).get(QA_AUDITOR) != 1){// if mapRoleWithCount is not 1, then throwing the error
              objBD.addError(ERROR2 + ' ' + QA_AUDITOR + '. ' + ERROR3);
          }
        }
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(MAST_TECH))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(MAST_TECH) && mapAccRoleWithCount.get(objBD.Account__c).get(MAST_TECH) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.AIA_Approver_MAST_Tech__c = mapAccRoleWithUserId.get(objBD.Account__c).get(MAST_TECH);
          else if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(MAST_TECH) && mapAccRoleWithCount.get(objBD.Account__c).get(MAST_TECH) != 1){// if mapRoleWithCount is not 1, then throwing the error
              objBD.addError(ERROR2 + ' ' + MAST_TECH + '. ' + ERROR3);
          }
        }
        
        //T07 -- Start
        /* if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(NASCO_BENEFIT_CODER))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(NASCO_BENEFIT_CODER) && mapAccRoleWithCount.get(objBD.Account__c).get(NASCO_BENEFIT_CODER) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Approver_Benefit_Coder__c = mapAccRoleWithUserId.get(objBD.Account__c).get(NASCO_BENEFIT_CODER);
          else if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(NASCO_BENEFIT_CODER) && mapAccRoleWithCount.get(objBD.Account__c).get(NASCO_BENEFIT_CODER) != 1){// if mapRoleWithCount is not 1, then throwing the error
              objBD.addError(ERROR2 + ' ' + NASCO_BENEFIT_CODER + '. ' + ERROR3);
          }
        }*/
        
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(BENEFIT_TESTER))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(BENEFIT_TESTER) && mapAccRoleWithCount.get(objBD.Account__c).get(BENEFIT_TESTER) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.AIA_Approver_Benefit_Tester__c = mapAccRoleWithUserId.get(objBD.Account__c).get(BENEFIT_TESTER);
          else if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(BENEFIT_TESTER) && mapAccRoleWithCount.get(objBD.Account__c).get(BENEFIT_TESTER) != 1){// if mapRoleWithCount is not 1, then throwing the error
              objBD.addError(ERROR2 + ' ' + BENEFIT_TESTER + '. ' + ERROR3);
          }
        }
        
          if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(BENEFIT_CODER))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(BENEFIT_CODER) && mapAccRoleWithCount.get(objBD.Account__c).get(BENEFIT_CODER) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.AIA_Approver_Benefit_Coder__c = mapAccRoleWithUserId.get(objBD.Account__c).get(BENEFIT_CODER);
          else if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(BENEFIT_CODER) && mapAccRoleWithCount.get(objBD.Account__c).get(BENEFIT_CODER) != 1){// if mapRoleWithCount is not 1, then throwing the error
              objBD.addError(ERROR2 + ' ' + BENEFIT_CODER + '. ' + ERROR3);
          }
        }
        //T07 -- End
    //T01 Start        
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(Settlements_Analyst))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(Settlements_Analyst) && mapAccRoleWithCount.get(objBD.Account__c).get(Settlements_Analyst) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Mail_Settlements_Analyst__c= mapAccRoleWithUserId.get(objBD.Account__c).get(Settlements_Analyst);         
        }
        
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(Benefit_Admin_Workflow_Mgmt))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(Benefit_Admin_Workflow_Mgmt) && mapAccRoleWithCount.get(objBD.Account__c).get(Benefit_Admin_Workflow_Mgmt) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Mail_Benefit_Admin_Workflow_Mgmt__c= mapAccRoleWithUserId.get(objBD.Account__c).get(Benefit_Admin_Workflow_Mgmt);         
        }
        
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(Production_ID_Card))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(Production_ID_Card) && mapAccRoleWithCount.get(objBD.Account__c).get(Production_ID_Card) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Mail_Production_ID_Card__c= mapAccRoleWithUserId.get(objBD.Account__c).get(Production_ID_Card);         
        }
        
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(Benefit_Admin_Account_Setup))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(Benefit_Admin_Account_Setup) && mapAccRoleWithCount.get(objBD.Account__c).get(Benefit_Admin_Account_Setup) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Mail_Benefit_Admin_Account_Setup__c= mapAccRoleWithUserId.get(objBD.Account__c).get(Benefit_Admin_Account_Setup);         
        }
        
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(Underwriter))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(Underwriter) && mapAccRoleWithCount.get(objBD.Account__c).get(Underwriter) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Mail_Underwriter__c= mapAccRoleWithUserId.get(objBD.Account__c).get(Underwriter);         
        }
        
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(Benefit_NASCO_Tester))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(Benefit_NASCO_Tester) && mapAccRoleWithCount.get(objBD.Account__c).get(Benefit_NASCO_Tester) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Mail_Benefit_NASCO_Tester__c= mapAccRoleWithUserId.get(objBD.Account__c).get(Benefit_NASCO_Tester);         
        }
        
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(Account_Dedicated_Rep))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(Account_Dedicated_Rep) && mapAccRoleWithCount.get(objBD.Account__c).get(Account_Dedicated_Rep) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Mail_Account_Dedicated_Rep__c= mapAccRoleWithUserId.get(objBD.Account__c).get(Account_Dedicated_Rep);         
        }
        
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(Account_Manager))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(Account_Manager) && mapAccRoleWithCount.get(objBD.Account__c).get(Account_Manager) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Mail_Account_Manager__c= mapAccRoleWithUserId.get(objBD.Account__c).get(Account_Manager);         
        }
        
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(Implementation_PM))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(Implementation_PM) && mapAccRoleWithCount.get(objBD.Account__c).get(Implementation_PM) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Mail_Implementation_PM__c= mapAccRoleWithUserId.get(objBD.Account__c).get(Implementation_PM);         
        } 
        /*T09 starts
        if(mapAccRoleWithUserId.get(objBD.Account__c).containskey(Ancillary_Analyst))
        {
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && mapAccRoleWithCount.get(objBD.Account__c).containsKey(Ancillary_Analyst) && mapAccRoleWithCount.get(objBD.Account__c).get(Ancillary_Analyst) == 1) // if mapRoleWithCount is 1, then assigning the values
              objBD.Mail_Ancillary_Analyst__c= mapAccRoleWithUserId.get(objBD.Account__c).get(Ancillary_Analyst);         
        }  T09 ends */                    
    //T01  End
       
        system.debug('AccountAnalyst>>>>>>'+AccountAnalyst); 
        system.debug('BenefactCoder>>>>>>'+BenefactCoder); 
      system.debug('ContractTech>>>>>>'+ContractTech); 
          system.debug('QAAuditor>>>>>>'+QAAuditor); 
      //T04 start Commented    
     /* if(AccountAnalyst == 0 && QAAuditor != 0 && ContractTech != 0 && BenefactCoder != 0 && MastTech != 0 && NASCOBenefitCoder != 0)
        objBD.addError(ERROR1 + ACCOUNT_ANALYST);
        
        
      if(BenefactCoder == 0 && QAAuditor != 0 && ContractTech != 0 && AccountAnalyst != 0 && MastTech != 0 && NASCOBenefitCoder != 0)
        objBD.addError(ERROR1 + BENEFACT_CODER);
        
      if(ContractTech == 0 && QAAuditor != 0 && AccountAnalyst != 0 && BenefactCoder != 0 && MastTech != 0 && NASCOBenefitCoder != 0)
        objBD.addError(ERROR1 + CONTRACT_TECH );
        
        
      if(QAAuditor == 0 && BenefactCoder != 0 && ContractTech != 0 && AccountAnalyst != 0 && MastTech != 0 && NASCOBenefitCoder != 0)
        objBD.addError(ERROR1 + QA_AUDITOR );
        
        if(MastTech == 0 && BenefactCoder != 0 && ContractTech != 0 && AccountAnalyst != 0 && QAAuditor!= 0 && NASCOBenefitCoder != 0)
        objBD.addError(ERROR1 + MAST_TECH );
        
          if(NASCOBenefitCoder == 0 && BenefactCoder != 0 && ContractTech != 0 && AccountAnalyst != 0 && QAAuditor!= 0 && MastTech != 0)
        objBD.addError(ERROR1 + NASCO_BENEFIT_CODER );
        
         
        if(ContractTech == 0 &&  AccountAnalyst == 0 ){
            objBD.addError(ERROR1 + CONTRACT_TECH +' ,  '+ ACCOUNT_ANALYST);
        } 
        
         
        if(QAAuditor == 0 &&  AccountAnalyst == 0 ){
            objBD.addError(ERROR1 + QA_AUDITOR +' ,  '+ ACCOUNT_ANALYST);
        } 
         
        
        if(BenefactCoder == 0 &&  AccountAnalyst == 0 ){
            objBD.addError(ERROR1 + BENEFACT_CODER +' ,  '+ ACCOUNT_ANALYST);
        } 
        
        
         if(BenefactCoder == 0 &&  ContractTech == 0 ){
            objBD.addError(ERROR1 + BENEFACT_CODER +' ,  '+ CONTRACT_TECH);
        } 
        
          if(BenefactCoder == 0 &&  QAAuditor == 0 ){
            objBD.addError(ERROR1 + BENEFACT_CODER +' ,  '+ QA_AUDITOR);
        }
        
         if(ContractTech == 0 &&  QAAuditor == 0 ){
            objBD.addError(ERROR1 + CONTRACT_TECH +' ,  '+ QA_AUDITOR);
        }
        
        
        
         if(BenefactCoder == 0 && QAAuditor== 0 && ContractTech == 0 ){
            objBD.addError(ERROR1 + BENEFACT_CODER+' , '+QA_AUDITOR+' , '+ CONTRACT_TECH);
        } 
        
        if(AccountAnalyst == 0 && QAAuditor == 0 && ContractTech == 0 ){
            objBD.addError(ERROR1 + ACCOUNT_ANALYST  +' , '+QA_AUDITOR+' , '+ CONTRACT_TECH);
        } 
        
       if(AccountAnalyst == 0 && BenefactCoder == 0 && ContractTech == 0 ){
            objBD.addError(ERROR1 + ACCOUNT_ANALYST  +' , '+BENEFACT_CODER +' , '+ CONTRACT_TECH);
        }
       if(AccountAnalyst == 0 && BenefactCoder == 0 && QAAuditor== 0 ){
            objBD.addError(ERROR1 + ACCOUNT_ANALYST  +' , '+ BENEFACT_CODER +' , '+ QA_AUDITOR);
         }
        if(AccountAnalyst == 0 && BenefactCoder == 0 && QAAuditor== 0 && MastTech==0 && NASCOBenefitCoder == 0){
            objBD.addError(ERROR1 + ACCOUNT_ANALYST  +' , '+ BENEFACT_CODER +' , '+ QA_AUDITOR+' , '+ MAST_TECH+' , '+ NASCO_BENEFIT_CODER);
         }*/
          //T04 End
           //T04 Start
          String error='';
          //T08 -- Start
          /*if(mapAccRoleWithCount.get(objBD.Account__c) != null && !mapAccRoleWithCount.get(objBD.Account__c).containsKey(ACCOUNT_ANALYST)){
              error+=ACCOUNT_ANALYST+',';
          }*/
          //T08 End
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && !mapAccRoleWithCount.get(objBD.Account__c).containsKey(BENEFACT_CODER)){
              error+=BENEFACT_CODER+',';
          }
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && !mapAccRoleWithCount.get(objBD.Account__c).containsKey(CONTRACT_TECH)){
              error+=CONTRACT_TECH+',';
          }
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && !mapAccRoleWithCount.get(objBD.Account__c).containsKey(QA_AUDITOR)){
              error+=QA_AUDITOR+',';
          }
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && !mapAccRoleWithCount.get(objBD.Account__c).containsKey(MAST_TECH)){
              error+=MAST_TECH+',';
          }
          //T09 start
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && !mapAccRoleWithCount.get(objBD.Account__c).containsKey(VISION_ANALYST)){
              error+=VISION_ANALYST+',';
          }
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && !mapAccRoleWithCount.get(objBD.Account__c).containsKey(PHARMACY_OPERATIONS)){
              error+=PHARMACY_OPERATIONS+',';
          }

          //T09 ends
          
          //T07 -- Start
          /*if(mapAccRoleWithCount.get(objBD.Account__c) != null && !mapAccRoleWithCount.get(objBD.Account__c).containsKey(NASCO_BENEFIT_CODER)){
              error+=NASCO_BENEFIT_CODER+',';
          }*/
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && !mapAccRoleWithCount.get(objBD.Account__c).containsKey(BENEFIT_TESTER)){
              error+=BENEFIT_TESTER+',';
          }
          if(mapAccRoleWithCount.get(objBD.Account__c) != null && !mapAccRoleWithCount.get(objBD.Account__c).containsKey(BENEFIT_CODER)){
              error+=BENEFIT_CODER+',';
          }
          //T07 End
         if(error!='')
         {
             error = 'The '+error.removeEnd(',');
             objBD.addError(error+ERROR1);
         }
        /*error=error.removeEnd(',');
            objBD.addError(error+ERROR1);*/
          //T04 End
       
      }else{
      
         
     /*     
       if(AccountAnalyst == 0 && BenefactCoder == 0 && QAAuditor == 0 ){
            objBD.addError(ERROR1 + BENEFACT_CODER +' , '+ ACCOUNT_ANALYST +' , '+ QAAuditor);
         }     
    */     
    /*****    if(AccountAnalyst == 0)
            objBD.addError(ERROR1 + ACCOUNT_ANALYST);
         if(BenefactCoder == 0)
            objBD.addError(ERROR1 + BENEFACT_CODER);
         if(ContractTech == 0)
            objBD.addError(ERROR1 + CONTRACT_TECH );
        if(QAAuditor == 0)
            objBD.addError(ERROR1 + QA_AUDITOR + ERROR1 );
        if(MastTech == 0)
            objBD.addError(ERROR1 + MAST_TECH + ERROR1 );   
        if(NASCOBenefitCoder == 0)
        objBD.addError(ERROR1 + NASCO_BENEFIT_CODER+ ERROR1  );
   ****/         
       /*
         }
        */
        
          //T07 -- Start
          //T08 -- Removed Ancillary Analyst from the condition and error
          if(mapAccRoleWithCount.get(objBD.Account__c) != null &&
          !mapAccRoleWithCount.get(objBD.Account__c).containsKey(BENEFACT_CODER) && 
          !mapAccRoleWithCount.get(objBD.Account__c).containsKey(CONTRACT_TECH) && 
          !mapAccRoleWithCount.get(objBD.Account__c).containsKey(QA_AUDITOR) && 
          !mapAccRoleWithCount.get(objBD.Account__c).containsKey(MAST_TECH) && 
          !mapAccRoleWithCount.get(objBD.Account__c).containsKey(BENEFIT_TESTER)&&//T08
          !mapAccRoleWithCount.get(objBD.Account__c).containsKey(BENEFIT_CODER)&&//T08   
          !mapAccRoleWithCount.get(objBD.Account__c).containsKey(VISION_ANALYST)&& //T09
          !mapAccRoleWithCount.get(objBD.Account__c).containsKey(PHARMACY_OPERATIONS))
        {
          objBD.addError(ERROR1 + BENEFACT_CODER +' , '+ CONTRACT_TECH +' , '+ QA_AUDITOR+' ,'+MAST_TECH+' ,'+VISION_ANALYST+' ,'+PHARMACY_OPERATIONS+' ,'+BENEFIT_CODER+' and '+BENEFIT_TESTER);//
         
        }
          
        //T07 -- End
        
        /*if(AccountAnalyst == 0 && BenefactCoder == 0 && ContractTech == 0 && QAAuditor == 0 && MastTech==0 && NASCOBenefitCoder == 0 && !IgnoreValidations){
            objBD.addError(ERROR1 + BENEFACT_CODER +' , '+ ACCOUNT_ANALYST +' , '+ CONTRACT_TECH +' , '+ QA_AUDITOR+' ,'+MAST_TECH+' and '+NASCO_BENEFIT_CODER);
         }*/
        //T06 -- End// 
      
      }
         
    }  
}
    /*Rajesh changes start here*/
  /*  public static void UpdateStatus(List<AIA_Benefit_Design__c> lstBD){
        
        for(AIA_Benefit_Design__c objBD1 : lstBD){
            if(objBD1.Approver_Ancillary_Analyst__c != null){
                if(objBD1.Approval_Status_Analyst__c != 'Approved' && objBD1.Approval_Status_Analyst__c != 'Rejected'){
                    objBD1.Approval_Status_Analyst__c.addError(ACCOUNT_ANALYST_STATUS+' must have either Approved or Rejected if Approver '+ACCOUNT_ANALYST+' is available');
                }
            }else{
                if(objBD1.Approval_Status_Analyst__c != 'N/A'){
                    objBD1.Approval_Status_Analyst__c.addError(ACCOUNT_ANALYST_STATUS+' must have N/A if Approver '+ACCOUNT_ANALYST+' is not available');
                }
            }
            if(objBD1.AIA_Approver_Benefact_Coder__c != null){
                if(objBD1.AIA_Approval_Status_Benefact_Coder__c != 'Approved' && objBD1.AIA_Approval_Status_Benefact_Coder__c != 'Rejected'){
                    objBD1.AIA_Approval_Status_Benefact_Coder__c.addError(BENEFACT_CODER_STATUS+' must have either Approved or Rejected if Approver '+BENEFACT_CODER+' is available');
                }
            }else{
                if(objBD1.AIA_Approval_Status_Benefact_Coder__c != 'N/A'){
                    objBD1.AIA_Approval_Status_Benefact_Coder__c.addError(BENEFACT_CODER_STATUS+' must have N/A if Approver '+BENEFACT_CODER+' is not available');
                }
            }
            
            if(objBD1.Approver_Contract_Tech__c != null){
                if(objBD1.AIA_Approval_Status_Contract_Tech__c != 'Approved' && objBD1.AIA_Approval_Status_Contract_Tech__c != 'Rejected'){
                    objBD1.AIA_Approval_Status_Contract_Tech__c.addError(CONTRACT_TECH_STATUS+' must have either Approved or Rejected if Approver '+CONTRACT_TECH+' is Available');
                }
            }else{
                if(objBD1.AIA_Approval_Status_Contract_Tech__c != 'N/A'){
                    objBD1.AIA_Approval_Status_Contract_Tech__c.addError(CONTRACT_TECH_STATUS+' must have N/A if Approver '+CONTRACT_TECH+' is not available');
                }
            }
            
            if(objBD1.AIA_Approver_MAST_Tech__c != null){
                if(objBD1.Approval_Status_MAST_Tech__c != 'Approved' && objBD1.Approval_Status_MAST_Tech__c != 'Rejected'){
                    objBD1.Approval_Status_MAST_Tech__c.addError(MAST_TECH_STATUS+' must have either Approved or Rejected if Approver '+MAST_TECH+' is available');
                }
            }else{
                if(objBD1.Approval_Status_MAST_Tech__c != 'N/A'){
                    objBD1.Approval_Status_MAST_Tech__c.addError(MAST_TECH_STATUS+' must have N/A if Approver '+MAST_TECH+' is not available');
                }
            }
            
            if(objBD1.Approver_Benefit_Coder__c != null){
                if(objBD1.AIA_Approval_Status_NASCO_Benefit_Coder__c != 'Approved' && objBD1.AIA_Approval_Status_NASCO_Benefit_Coder__c != 'Rejected'){
                    objBD1.AIA_Approval_Status_NASCO_Benefit_Coder__c.addError(NASCO_BENEFIT_CODER_STATUS+' must have either Approved or Rejected if Approver '+NASCO_BENEFIT_CODER+' is available');
                }
            }else{
                if(objBD1.AIA_Approval_Status_NASCO_Benefit_Coder__c != 'N/A'){
                    objBD1.AIA_Approval_Status_NASCO_Benefit_Coder__c.addError(NASCO_BENEFIT_CODER_STATUS+' must have N/A if Approver '+NASCO_BENEFIT_CODER+' is not available');
                }
            }
        }        
    } */
    /*Rajesh cahnges end here */
}