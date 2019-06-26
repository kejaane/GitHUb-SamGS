/*
 *=========================================================================================
 * Date: 05/18/2018
 * Developer: Rajesh Pennam
 * Purpose: The purpose of this test class is to verify the code coverage and check the functionality 
 *          programatically for the controller AIA_User_Account_View_Controller
 *===========================================================================================
 * Date           Developer      Tag   Description
 * ==========================================================================================
 * 09/21/2017 | Rajesh Pennam  |     | Initial Version
 * 02/22/2019 | Chaithra       | T01 | Removed multiple acc creation
 * 02/26/2019 | Chaithra       | T02 | Changed reference from standard object to custom obj
 *===========================================================================================
 */



@istest
public class AIA_User_Account_View_Controller_Test{

    @testSetup 
    static void testdata() {
         
        Profile nonAdminProfile = [select id from profile where name='AIA 200+ Standard User - Custom'];
        //Test.starttest();
        List<user> userList = new list<user>();
       
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        u1.LastName = 'alias1';
        u1.ProfileId= nonAdminProfile.Id;
        userList.add(u1); 
        
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        u2.LastName = 'alias2';
        u2.ProfileId =nonAdminProfile.Id;
        userList.add(u2);
        
       insert userList;
       // system.assertEquals('alias1', [select id,lastname from user where LastName = 'alias1' limit 1].lastname);
       system.assertEquals('alias1', u1.lastname);
        //Creating WorkPlan Task Test Data 
        Test.starttest();
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertEquals('TestAccount', acc.name);
        //Account acc2 = AIA_TestUtil.CreateAccount('TestAccount2'); T01 
         //Account acc3 = AIA_TestUtil.CreateAccount('TestAccount3'); T01
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        //system.assertEquals(limits.getQueries(),0);
        AIA_Implementation__c objImpl = AIA_TestUtil.CreateImplementation(opp.Id);        
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl.Id);        
        List<Sub_Process__c> objSubProc = AIA_TestUtil.CreateSubProcessList(objImpl.Id,objProcess[0].Id);
       
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// T02
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Proposal Specialist')); //T01 replaced acc2
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Manager'));// T01 replaced acc3
        insert acctMbrList;
        system.debug('acctMbrList***'+acctMbrList);
        List<WorkPlan_Task__c> lstTasks = new List<WorkPlan_Task__c>();
        List<WorkPlan_Task__c> lstTask = new List<WorkPlan_Task__c>();      
        List<string> userId = new List<string>();
        userId.add(u2.Id);
        userId.add(u1.Id);
        system.debug('test%%%%');
        lstTask = AIA_TestUtil.CreateWorkPlanTask(String.valueof(objImpl.Id), String.valueof(opp.Id), String.valueof(objSubProc[0].Id), userId,'BeneFact Coder');    
        system.debug('lstTask***'+lstTask);
        for(WorkPlan_Task__c tsk :lstTask ){
            tsk.Status__c = 'In Progress'; 
            tsk.Task_Owner__c ='BeneFact Coder';
            lstTasks.add(tsk);
        }
        update lstTasks;
         Test.stoptest();
        system.debug('lstTask111***'+lstTask);
    }

    
 public static testmethod void testdeafultPPVision(){
        
        User u = [select id from USer where lastname ='alias1' limit 1];
        Account acc = [select id from account where name = 'TestAccount' Limit 1];
     Test.startTest();
        System.runAs(u) {  
            PageReference pageRef = Page.AIA_User_Account_View; // Add your VF page Name here
            pageRef.getParameters().put('showallAcc', 'true');
            pageRef.getParameters().put('id' , u.id);
            Test.setCurrentPage(pageRef);
            
            AIA_User_Account_View_Controller testUsrAcc = new AIA_User_Account_View_Controller();
            testUsrAcc.viewAll();   
            system.assertEquals('50', String.valueOF(testUsrAcc.listSize));
           // testUsrAcc.accIdSelected = acc.Id;
            for (AIA_User_Account_View_Controller.AccountSubClass a : (list<AIA_User_Account_View_Controller.AccountSubClass>)testUSrAcc.CurrentAccountList) {
             a.aCheckBox = true;
            }
            testUsrAcc.manageTeamMembers();
             system.debug('CurrentAccountList***'+testUSrAcc.CurrentAccountList);
           
            //Test.startTest();
             testUsrAcc.nextAccount();
            testUsrAcc.previousAccount();
            //testUSrAcc.accountCounter=0;
            testUsrAcc.nextLastAccount();
            
            Test.stopTest();
            
        }
    
   }
   
   
    public static testmethod void testdeafultPPVision1(){
        
        User u = [select id from USer where lastname ='alias1' limit 1];
        Account acc = [select id from account where name = 'TestAccount' Limit 1];
        System.runAs(u) {  
            PageReference pageRef = Page.AIA_User_Account_View; // Add your VF page Name here
            pageRef.getParameters().put('showallAcc', 'true');
            pageRef.getParameters().put('id' , u.id);
            Test.setCurrentPage(pageRef);
            
            AIA_User_Account_View_Controller testUsrAcc = new AIA_User_Account_View_Controller();
            testUsrAcc.viewAll();   
            system.assertEquals('50', String.valueOF(testUsrAcc.listSize));
           // testUsrAcc.accIdSelected = acc.Id;
            for (AIA_User_Account_View_Controller.AccountSubClass a : (list<AIA_User_Account_View_Controller.AccountSubClass>)testUSrAcc.CurrentAccountList) {
             a.aCheckBox = true;
            }
            testUsrAcc.manageTeamMembers();
             system.debug('CurrentAccountList***'+testUSrAcc.CurrentAccountList);
            
            Test.startTest();
            testUsrAcc.previousFirstAccount();
            testUsrAcc.getprev();
            testUsrAcc.getnxt();
            Test.stopTest();
        }
     
   } 
   
    public static testmethod void testdeafultPPVision2(){
        
        User u = [select id from USer where lastname ='alias1' limit 1];
        Account acc = [select id from account where name = 'TestAccount' Limit 1];
        System.runAs(u) {  
            PageReference pageRef = Page.AIA_User_Account_View; // Add your VF page Name here
            pageRef.getParameters().put('showallAcc', 'true');
            pageRef.getParameters().put('id' , u.id);
            Test.setCurrentPage(pageRef);
            
            AIA_User_Account_View_Controller testUsrAcc = new AIA_User_Account_View_Controller();
            testUsrAcc.viewAll();   
            system.assertEquals('50', String.valueOF(testUsrAcc.listSize));
           // testUsrAcc.accIdSelected = acc.Id;
            for (AIA_User_Account_View_Controller.AccountSubClass a : (list<AIA_User_Account_View_Controller.AccountSubClass>)testUSrAcc.CurrentAccountList) {
             a.aCheckBox = true;
            }
            testUsrAcc.manageTeamMembers();
             system.debug('CurrentAccountList***'+testUSrAcc.CurrentAccountList);
            
            Test.startTest();
            testUsrAcc.SortField = 'CreatedDate';
            testUsrAcc.SortToggle();
            Test.stopTest();
        }
     
   } 
   
    public static testmethod void testdeafultPPVision3(){
        
        User u = [select id from USer where lastname ='alias1' limit 1];
        Account acc = [select id from account where name = 'TestAccount' Limit 1];
        Test.startTest();
        System.runAs(u) {  
            PageReference pageRef = Page.AIA_User_Account_View; // Add your VF page Name here
            pageRef.getParameters().put('showallAcc', 'true');
            pageRef.getParameters().put('id' , u.id);
            Test.setCurrentPage(pageRef);
            
            AIA_User_Account_View_Controller testUsrAcc = new AIA_User_Account_View_Controller();
            testUsrAcc.viewAll();   
            system.assertEquals('50', String.valueOF(testUsrAcc.listSize));
           // testUsrAcc.accIdSelected = acc.Id;
            for (AIA_User_Account_View_Controller.AccountSubClass a : (list<AIA_User_Account_View_Controller.AccountSubClass>)testUSrAcc.CurrentAccountList) {
             a.aCheckBox = true;
            }
            testUsrAcc.manageTeamMembers();
             system.debug('CurrentAccountList***'+testUSrAcc.CurrentAccountList);
            
            //Test.startTest();
            testUsrAcc.UpdateAccountSelectedSet();
            testUsrAcc.SortField = 'taskCount';
            testUsrAcc.BuildQuery() ;
            Test.stopTest();
        }
     
   } 
    
}