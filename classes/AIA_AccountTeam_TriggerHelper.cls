/*****************************************************************************************************
*Date:      02-04-2019
*Developer: Satya Tirumalasetti
*Purpose:  
*================================================================================================
* Update History
* Date         Developer    Tag           Description 
*================================================================================================
* 02-04-2019   Satya                  Initial Development
*=================================================================================================

*******************************************************************************************************/


//This class will be invoked from AIA_AccountTeamTriggerHandler
public with sharing class AIA_AccountTeam_TriggerHelper{

    set<id> AcctSet = new set<id>();
    public map<id,map<string,string>> AcctToRecordMap = new map<id,map<string,string>>();
    public map<string,string> userToRoleMap = new map<string,string>();
    @testvisible public static final string Account_Dedicated_Rep = 'Account Dedicated Representative';
    @testvisible public static final string Contract_Coordinator = 'Contract Coordinator';
    @testvisible public static final string MAST_Tech = 'MAST Tech';
    @testvisible public static final string Benefit_Tester = 'Benefit Tester';
    @testvisible public static final string Benefit_Coder = 'Benefit Coder';
    @testvisible public static final string Vision_Analyst = 'Vision Analyst';
    @testvisible public static final string Implementation_Coordinator = 'Implementation Coordinator';
    @testvisible public static final string Auditor = 'Auditor';
    @testvisible public static final string Sales_Assistant = 'Sales Assistant';
    @testvisible public static final string Automated_Enrollment_Tech = 'Automated Enrollment Tech';
    @testvisible public static final string Underwriter = 'Underwriter';
    @testvisible public static final string Enrollment_Tech = 'Enrollment Tech';
    @testvisible public static final string Billing_Tech = 'Billing Tech';
    @testvisible public static final string BeneFact_Coder = 'BeneFact Coder';
    @testvisible public static final string Account_Dedicated_Representative = 'Account Dedicated Representative';
    @testvisible public static final string QA_Auditor = 'QA Auditor';
    @testvisible public static final string Contract_Tech = 'Contract Tech';
    @testvisible public static final string Facets_Migration_Contact = 'Facets Migration Contact';
    @testvisible public static final string Legal = 'Legal';
    @testvisible public static final string AIA_Admin = 'AIA Admin';
    @testvisible public static final string Blue_Rewards_Tech = 'Blue Rewards Tech';
    @testvisible public static final string Wellness_Tech = 'Wellness Tech';
    @testvisible public static final string Proposal_Specialist = 'Proposal Specialist';
    @testvisible public static final string Account_Executive = 'Account Executive';
    @testvisible public static final string Pharmacy_Operations = 'Pharmacy Operations';
    @testvisible public static final string Benefit_Contract_Specialist = 'Benefit Contract Specialist';
    @testvisible public static final string Production_ID_Card_Tech = 'Production ID Card Tech';
    @testvisible public static final string Settlements_Analyst = 'Settlements Analyst';
    @testvisible public static final string Contract_Manager = 'Contract Manager';

     Public static void populateAccountRoles(List<Account_Team__c> AccountTeamLst){
     
         set<id> AcctSet = new set<id>();
         map<id,map<string,string>> AcctToRecordMap = new map<id,map<string,string>>();
         map<string,string> userToRoleMap = new map<string,string>();
         
         //Loop through all the Account Team records and get the accound Id's
         for(Account_Team__c act:AccountTeamLst){
             AcctSet.add(act.AccountId__c);
         }
         
         //Get the Account team records and create a map of acc id's with teamroles and their respective users
         for(Account_Team__c ActList : [select id,AccountId__c,TeamMemberRole__c,UserId__c,UserId__r.email from Account_Team__c where AccountId__c in:AcctSet]){
             if(AcctToRecordMap.containskey(ActList.AccountId__c)){
                 AcctToRecordMap.get(ActList.AccountId__c).put(ActList.TeamMemberRole__c,ActList.UserId__c);
             }else{
                 map<string,string> AcMap = new map<string,string>();
                 AcMap.put(ActList.TeamMemberRole__c,ActList.UserId__c);
                 AcctToRecordMap.put(ActList.AccountId__c,AcMap);
             }
         }
         
       /*  list<string> lst = new list<string>();
         for(AccountTeamObject__mdt DName :[Select id,DeveloperName,Parameter__c from AccountTeamObject__mdt]){
            lst.add(DName.Parameter__c); 
         }
         map<string,list<string>> objToFieldMap = new map<string,list<string>>();
         for(string obj:lst){
             Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap();
             for(string Fname:objectFields.keyset()){
                 if(Fname.contains('_atr')){
                    if(objToFieldMap.containskey(obj)){
                    objToFieldMap.get(obj).add(Fname);
                    }else {
                        list<string> fieldlst = new list<string>();
                        fieldlst.add(Fname);
                        objToFieldMap.put(obj,fieldlst);
                    }
    }  
             }

         }*/
         List<sObject> objects = new List<sObject>();
         List<Account> accountList = new List<Account>(); //To store account records
         List<ID_Card__c> idList = new List<ID_Card__c>(); //to store Id Card records
         List<Benfit_Request_Form__c> breqList = new List<Benfit_Request_Form__c>(); //To store BRF records
         List<AIA_Benefit_Design__c> bdsgList = new List<AIA_Benefit_Design__c>(); //To Store BD records
         
         //Get the list of accounts and populate the teamrole fields with the users
         for(Account actlst : [select id,Mast_Tech_User__c,Account_Dedicated_Representative_User__c,
                               Account_Executive_User__c,AIA_Admin_User__c,Auditor_User__c,Automated_Enrollment_Tech_User__c,
                               BeneFact_Coder_User__c,Benefit_Coder_User__c,Benefit_Contract_Specialist_User__c,
                               Benefit_Tester_User__c,Billing_Tech_User__c,Blue_Rewards_Tech_User__c,
                               Contract_Coordinator_User__c,Contract_Manager_User__c,Contract_Tech_User__c,
                               Enrollment_Tech_User__c,Facets_Migration_Contact_User__c,Implementation_Coordinator_User__c,
                               Legal_User__c,Pharmacy_Operations_User__c,Production_ID_Card_Tech_User__c,
                               Proposal_Specialist_User__c,QA_Auditor_User__c,Sales_Assistant_User__c,
                               Settlements_Analyst_User__c,Underwriter_User__c,Vision_Analyst_User__c,
                               Wellness_Tech_User__c 
                               from Account where id in:AcctSet]){
             if(AcctToRecordMap.containskey(actlst.id)){
                 if(AcctToRecordMap.get(actlst.id).containskey(Account_Dedicated_Rep)){
                     actlst.Account_Dedicated_Representative_User__c=AcctToRecordMap.get(actlst.id).get(Account_Dedicated_Rep);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Contract_Coordinator)){
                     actlst.Contract_Coordinator_User__c=AcctToRecordMap.get(actlst.id).get(Contract_Coordinator);
                     
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(MAST_Tech)){
                     actlst.Mast_Tech_User__c=AcctToRecordMap.get(actlst.id).get(MAST_Tech);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Benefit_Tester)){
                     actlst.Benefit_Tester_User__c=AcctToRecordMap.get(actlst.id).get(Benefit_Tester);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Benefit_Coder)){
                     actlst.Benefit_Coder_User__c=AcctToRecordMap.get(actlst.id).get(Benefit_Coder);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Vision_Analyst)){
                     actlst.Vision_Analyst_User__c=AcctToRecordMap.get(actlst.id).get(Vision_Analyst);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Implementation_Coordinator)){
                     actlst.Implementation_Coordinator_User__c=AcctToRecordMap.get(actlst.id).get(Implementation_Coordinator);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Auditor)){
                     actlst.Auditor_User__c=AcctToRecordMap.get(actlst.id).get(Auditor);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Sales_Assistant)){
                     actlst.Sales_Assistant_User__c=AcctToRecordMap.get(actlst.id).get(Sales_Assistant);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Automated_Enrollment_Tech)){
                     actlst.Automated_Enrollment_Tech_User__c=AcctToRecordMap.get(actlst.id).get(Automated_Enrollment_Tech);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Underwriter)){
                     actlst.Underwriter_User__c=AcctToRecordMap.get(actlst.id).get(Underwriter);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Enrollment_Tech)){
                     actlst.Enrollment_Tech_User__c=AcctToRecordMap.get(actlst.id).get(Enrollment_Tech);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Billing_Tech)){
                     actlst.Billing_Tech_User__c=AcctToRecordMap.get(actlst.id).get(Billing_Tech);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(BeneFact_Coder)){
                     actlst.BeneFact_Coder_User__c=AcctToRecordMap.get(actlst.id).get(BeneFact_Coder);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Account_Dedicated_Representative)){
                     actlst.Account_Dedicated_Representative_User__c=AcctToRecordMap.get(actlst.id).get(Account_Dedicated_Representative);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(QA_Auditor)){
                     actlst.QA_Auditor_User__c=AcctToRecordMap.get(actlst.id).get(QA_Auditor);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Contract_Tech)){
                     actlst.Contract_Tech_User__c=AcctToRecordMap.get(actlst.id).get(Contract_Tech);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Facets_Migration_Contact)){
                     actlst.Facets_Migration_Contact_User__c=AcctToRecordMap.get(actlst.id).get(Facets_Migration_Contact);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Legal)){
                     actlst.Legal_User__c=AcctToRecordMap.get(actlst.id).get(Legal);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(AIA_Admin)){
                     actlst.AIA_Admin_User__c=AcctToRecordMap.get(actlst.id).get(AIA_Admin);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Blue_Rewards_Tech)){
                     actlst.Blue_Rewards_Tech_User__c=AcctToRecordMap.get(actlst.id).get(Blue_Rewards_Tech);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Wellness_Tech)){
                     actlst.Wellness_Tech_User__c =AcctToRecordMap.get(actlst.id).get(Wellness_Tech);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Proposal_Specialist)){
                     actlst.Proposal_Specialist_User__c=AcctToRecordMap.get(actlst.id).get(Proposal_Specialist);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Account_Executive)){
                     actlst.Account_Executive_User__c=AcctToRecordMap.get(actlst.id).get(Account_Executive);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Pharmacy_Operations)){
                     actlst.Pharmacy_Operations_User__c=AcctToRecordMap.get(actlst.id).get(Pharmacy_Operations);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Benefit_Contract_Specialist)){
                     actlst.Benefit_Contract_Specialist_User__c=AcctToRecordMap.get(actlst.id).get(Benefit_Contract_Specialist);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Production_ID_Card_Tech)){
                     actlst.Production_ID_Card_Tech_User__c=AcctToRecordMap.get(actlst.id).get(Production_ID_Card_Tech);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Settlements_Analyst)){
                     actlst.Settlements_Analyst_User__c=AcctToRecordMap.get(actlst.id).get(Settlements_Analyst);
                 }
                 if(AcctToRecordMap.get(actlst.id).containskey(Contract_Manager)){
                     actlst.Contract_Manager_User__c=AcctToRecordMap.get(actlst.id).get(Contract_Manager);
                 }
               accountList.add(actlst);  
             }
         }
         
         //Get the ID Card records associated to the account's in the list and populate the Mast Tech user in those records
         /*for(ID_Card__c idCardlst : [select id,Mast_Tech_User__c,Implementation__r.Account__c from ID_Card__c where Implementation__r.Account__c in:AcctSet]){
             if(AcctToRecordMap.containskey(idCardlst.Implementation__r.Account__c)){
                 if(AcctToRecordMap.get(idCardlst.Implementation__r.Account__c).containskey(MAST_Tech)){
                     idCardlst.Mast_Tech_User__c=AcctToRecordMap.get(idCardlst.Implementation__r.Account__c).get(MAST_Tech);
                     idList.add(idCardlst);
                 }
             }
         }*/
         
          //Get the BRF records associated to the account's in the list and populate the Underwriter user in those records
        /* for(Benfit_Request_Form__c brflst : [select id,Underwriter_User__c,Account__c from Benfit_Request_Form__c where Account__c in:AcctSet and    Status__c != 'Sold' ]){
             if(AcctToRecordMap.containskey(brflst.Account__c)){
                 if(AcctToRecordMap.get(brflst.Account__c).containskey(Underwriter)){
                     brflst.Underwriter_User__c=AcctToRecordMap.get(brflst.Account__c).get(Underwriter);
                     breqList.add(brflst);
                 }
             }
         }*/
         
         //get the BD records associated to the account's and update them so that BD trigger will populate the teamrole fields of BD record
        /* for(AIA_Benefit_Design__c bdlst : [select id,Account__c from AIA_Benefit_Design__c where Account__c in:AcctSet]){
             if(AcctToRecordMap.containskey(bdlst.Account__c)){
                 //bdsgList.add(bdlst);
             }
         }*/
         
         //If the lists are not empty, add them to the generalised Sobject list to get updated
         if(accountList.size()>0){objects.addAll((List<sObject>)(accountList));}
         if(idList.size()>0){objects.addAll((List<sObject>)(idList));}
         if(breqList.size()>0){objects.addAll((List<sObject>)(breqList));}
         if(bdsgList.size()>0){objects.addAll((List<sObject>)(bdsgList));}
         
         system.debug('5--'+objects.size());
         
         //If the list is not empty, update the list
         if(objects.size()>0){update objects;}
         

     
     }

}