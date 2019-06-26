/*****************************************************************************************************
*Date: 07-23-2018
*Developer: Paritosh
*Purpose: Test class for AIA_SubProc_TaskList_On_Dashboard_Ctlr
*=========================================================================================
* Update History
* Date         Developer               Description
*==================================================================================
*07-23-2018   Paritosh            Initial Development
*==================================================================================

*******************************************************************************************************/



@isTest
public class AIA_SubProc_TaskList_On_Dashboard_Test {
    
    @testSetup
    public static void testSetup(){
        
        Account acc = AIA_TestUtil.CreateAccount2('TestAccount');  
        
        //Creating User Test Data 
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2); 
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3); 
        user u4 =AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5);
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u7 = AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7); 
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);
        user u9 = AIA_TestUtil.AIA_createUser('alias9');
        userList.add(u9);
        user u10 = AIA_TestUtil.AIA_createUser('alias10');
        userList.add(u10);
        user u11 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u11);
                     
        insert userList;  
        
       //Creating AccountMember Test Data 
       
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,AIA_Constants.CONTRACT_TECH));
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,AIA_Constants.QA_AUDITOR));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,AIA_Constants.SALES_SERVICE_REP)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,AIA_Constants.ACCOUNTEXECUTIVE)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,AIA_Constants.PROPOSALSPECIALIST)); 
        /*acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u6.id,AIA_Constants.UNDERWRITER));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,AIA_Constants.NASCO_BENEFIT_CODER)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,AIA_Constants.BENEFACT_CODER)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,AIA_Constants.ANCILLARY_ANALYST)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,AIA_Constants.MAST_TECH));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,AIA_Constants.SALES_ASSISTANT));*/   
        insert acctMbrList;
        
        
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        
        test.startTest();    
        
        Benfit_Request_Form__c brf = AIA_TestUtil.createBrfgs(acc.id,opp.id);
        AIA_Implementation__c objImpl1 = AIA_TestUtil.CreateImplementation1(opp.Id);
        
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = objImpl1.id;
        aiaBD.Account__c=acc.id;
        aiaBD.Benefit_Request_Form__c=brf.id; 
        //aiaBD.status__c = 'In Progress';
        insert aiaBD;
        
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl1.Id);   
        
        Sub_Process__c objSubProc = AIA_TestUtil.CreateSubProcessList(objImpl1.Id,objProcess[0].Id)[0];
        //objSubProc.Status__c = AIA_Constants.STATUS_NOTREQUIRED;
        //update objSubProc;
        
        List<string> ownerIds = new List<string>();
        ownerIds.add(u4.Id);
        ownerIds.add(u5.Id);
        
        //string strTeamRole = 'BeneFact Coder'; 
        List<WorkPlan_Task__c> lstTask = new List<WorkPlan_Task__c>();
        lstTask = AIA_TestUtil.CreateWorkPlanTask(objImpl1.Id, opp.Id, objSubProc.Id, ownerIds, AIA_Constants.PROPOSALSPECIALIST);  
        
        test.stopTest();
    }


}