/*****************************************************************************************************
*Date: 07-31-2018
*Developer: Paritosh
*Purpose: Test class for AIA_SubProc_TaskList_On_Dashboard_Ctlr
*=========================================================================================
* Update History
* Date         Developer               Description
*==================================================================================
*07-31-2018   Paritosh            Initial Development
*==================================================================================

*******************************************************************************************************/


@isTest 
public class AIA_SubProc_TaskList_On_DashboardTest {
    
    @testSetup
    static public void testSetup()
    {
        
        Account acc = AIA_TestUtil.CreateAccount('Test Account');
        
        List<user> userList = new list<user>();
        user u1  = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2  = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u3  = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        insert userList;
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,AIA_Constants.SALES_SERVICE_REP)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,AIA_Constants.ACCOUNTEXECUTIVE)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,AIA_Constants.PROPOSALSPECIALIST)); 
        insert acctMbrList;   
        
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        
        Test.startTest();    
        
        AIA_Implementation__c objImpl1 = AIA_TestUtil.CreateImplementation1(opp.Id);
        
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl1.Id);        
        List<Sub_Process__c> objSubProcs = AIA_TestUtil.CreateSubProcessList(objImpl1.Id,objProcess[0].Id);
        
        List<string> userId = new List<string> {u1.id, u2.id};
        AIA_TestUtil.CreateWorkPlanTask(objImpl1.Id, opp.Id, objSubProcs[0].Id, userId, AIA_Constants.BENEFACT_CODER);  
        AIA_TestUtil.CreateWorkPlanTask(objImpl1.Id, opp.Id, objSubProcs[1].Id, userId, AIA_Constants.BENEFACT_CODER);
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void testSorting(){
        
        Sub_Process__c subProcess = [Select id from Sub_Process__c limit 1];
        ApexPages.currentPage().getParameters().put('Id', subProcess.Id);
        AIA_SubProc_TaskList_On_Dashboard_Ctlr con = new AIA_SubProc_TaskList_On_Dashboard_Ctlr();
        con.setsubProcessID(subProcess.Id);
        
        //set sort field
        con.setSortField('Name');
        //toggle sort direction
        con.SortToggle();
        //redirect to Task creation page
        con.RedirectToCustomTaskPage();
        //test getters
        con.getsortField();
        con.getsubProcessID();
        
    }
    
    
}