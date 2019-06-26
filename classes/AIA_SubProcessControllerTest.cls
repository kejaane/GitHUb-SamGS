/*****************************************************************************************************
*Date: 07-13-2018
*Developer: Paritosh
*Purpose: Test class for AIA_SubProcessController
*=========================================================================================
* Update History
* Date         Developer               Description
*==================================================================================
*07-13-2018   Paritosh            Initial Development
*==================================================================================
* 12/27/2018 | Phani				 | T01 | Added additional Account team members
*******************************************************************************************************/



@isTest
public class AIA_SubProcessControllerTest {
    
    public static final String  UsedFor_Post_Sales  = 'Post-Sales';
    
    
     @testsetup
    public static void createTestData() {
        
        Account acc = AIA_TestUtil.CreateAccount2('TestAccount');  
        
        //Profile nonAdminProfile = [select id from profile where name='AIA 200+ Standard User - Custom'];
        //Profile adminProfile = [select id from profile where name='System Administrator'];
        
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
        //T01-Start
        user u12 = AIA_TestUtil.AIA_createUser('alias12');
        userList.add(u12); 
        user u13 =AIA_TestUtil.AIA_createUser('alias13');
        userList.add(u13);
        user u14 = AIA_TestUtil.AIA_createUser('alias14');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias15');
        userList.add(u15);
        user u16 = AIA_TestUtil.AIA_createUser('alias16');
        userList.add(u16);
        //T01-END        
        insert userList;  
        
       //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,AIA_Constants.CONTRACT_TECH));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,AIA_Constants.QA_AUDITOR));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,AIA_Constants.SALES_SERVICE_REP)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,AIA_Constants.ACCOUNTEXECUTIVE)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,AIA_Constants.PROPOSALSPECIALIST)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u6.id,AIA_Constants.UNDERWRITER));
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,AIA_Constants.NASCO_BENEFIT_CODER)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,AIA_Constants.BENEFACT_CODER)); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,AIA_Constants.ANCILLARY_ANALYST)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,AIA_Constants.MAST_TECH));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,AIA_Constants.SALES_ASSISTANT));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,AIA_Constants.Benefit_Coder));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u13.id,AIA_Constants.Benefit_Tester));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,AIA_Constants.Pharmacy_Management));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,AIA_Constants.Pharmacy_Operations));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u16.id,AIA_Constants.Vision_Analyst));
        
        insert acctMbrList;
        
        
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        
        test.startTest();    
        
        Benfit_Request_Form__c brf = AIA_TestUtil.createBrfgs(acc.id,opp.id);
        AIA_Implementation__c objImpl1 = AIA_TestUtil.CreateImplementation1(opp.Id);
        
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = objImpl1.id;
        aiaBD.Account__c=acc.id;
        aiaBD.Benefit_Request_Form__c=brf.id; 
        aiaBD.status__c = 'In Progress';
        insert aiaBD;
        
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl1.Id);        
        List<Sub_Process__c> objSubProcs = AIA_TestUtil.CreateSubProcessList(objImpl1.Id,objProcess[0].Id);
        
        objSubProcs[0].Status__c = AIA_Constants.STATUS_NOTREQUIRED;
        objSubProcs[0].Stage__c = 'Benefit Design';
        objSubProcs[1].Status__c = AIA_Constants.STATUS_INPROGRESS;
        objSubProcs[1].Stage__c = 'Group Structure';
        update objSubProcs;
        
        List<string> userId = new List<string>();
        userId.add(u1.Id);
        userId.add(u2.Id);
        
        string strTeamRole = 'BeneFact Coder';  
        AIA_TestUtil.CreateWorkPlanTask(objImpl1.Id, opp.Id, objSubProcs[0].Id, userId,strTeamRole);  
        AIA_TestUtil.CreateWorkPlanTask(objImpl1.Id, opp.Id, objSubProcs[1].Id, userId,strTeamRole);
        
        test.stopTest();
      
       } 
    
    //updates all the tasks for a sub process when sub process status is changed from
    //Not required to In-Progress
    @isTest static void test_updateWorkPlanTaskStatusTest() {
        
        Sub_Process__c subProcess = [Select ID, Status__c from Sub_Process__c where Status__c =:AIA_Constants.STATUS_NOTREQUIRED limit 1];
        subProcess.Status__c = AIA_Constants.STATUS_INPROGRESS;
        update subProcess;
        subProcess.Status__c = AIA_Constants.STATUS_NOTREQUIRED;
        update subProcess;
    }
    
    //updates all the tasks for a sub process when sub process status is changed from In-Progress to Not required
    @isTest static void test_updateWorkPlanTaskStatusTest2() {
        
        Sub_Process__c subProcess = [Select ID, Status__c,Stage__c from Sub_Process__c where Status__c =: AIA_Constants.STATUS_INPROGRESS limit 1];
        subProcess.Status__c = AIA_Constants.STATUS_NOTREQUIRED;
        update subProcess;
        
    }
    
    //tests exception of AIA_SubProcessTriggerHelper.updateActualSLA()
    @isTest static void test_updateActualSLA_Excep() {
        Sub_Process__c subProcess = [Select ID, Status__c from Sub_Process__c where Status__c =: AIA_Constants.STATUS_INPROGRESS limit 1];
        subProcess.AIA_Sub_Process_Start_date__c = null;
        subProcess.Status__c = AIA_Constants.COMPLETED_STATUS;
        subProcess.SLA_Day_Type__c = AIA_Constants.CALENDER_TYPE;
        new AIA_SubProcessTriggerHelper().updateActualSLA(new List<Sub_Process__c>{subProcess});
    }
    
    //updates all the tasks for a sub process when sub process status is changed from In-Progress to Not required
    @isTest static void test_updateWorkPlanTaskStatusTest4() {
        
        Sub_Process__c subProcess = [Select ID, Status__c,Stage__c from Sub_Process__c where Status__c =: AIA_Constants.STATUS_NOTREQUIRED limit 1];
        system.debug('-------SMSL0------>'+subProcess);
        subProcess.Stage__c = 'Group Structure';
        subProcess.Status__c = AIA_Constants.STATUS_INPROGRESS;
        update subProcess;
        
    }
    

}