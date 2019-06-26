/*=========================================================================================
 * Date         : 04/18/18
 * Developer    : Arshia Gulati
 * Purpose      :  
 * 
 * This class contains unit tests for 
 *   
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 04/18/18  |  AG    | This class is used to test AIA_Custom_SubProcess_Controller
 *           |        | 
 *=========================================================================================
 */
@isTest
public class AIA_Custom_SubProcess_ControllerTest {
     //Create test data
    @testSetup static void testdata() {
        
        Profile nonAdminProfile = [select id from profile where name='AIA 200+ Standard User - Custom'];
        Profile adminProfile = [select id from profile where name='System Administrator'];
       
        //Creating User Test Data 
        List<user> userList = new list<user>();
       
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        u1.LastName = 'alias1';
        u1.ProfileId= AdminProfile.Id;
        userList.add(u1); 
        
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        u2.LastName = 'alias2';
        u2.ProfileId =nonAdminProfile.Id;
        userList.add(u2);
        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        u3.LastName = 'alias3';
        u3.ProfileId=nonAdminProfile.Id;
        userList.add(u3); 
        
        insert userList;
        
    //    AIA_TestUtil.CreateAreaManager(u1.id, 'BeneFact Coder;BeneFact Tester', 'BeneFact Coder;BeneFact Tester', 'alias1', 'Manager');
        AIA_TestUtil.CreateAreaManager(u2.id, 'Implementation Manager;BeneFact Coder', 'BeneFact Coder;BeneFact Tester', 'alias2', 'Manager');
		AIA_TestUtil.CreateAreaManager(u3.id, 'BeneFact Coder;BeneFact Tester', '', 'alias3', 'Non-Manager');
     System.Debug('SP:Test Data Created');
    }
    @isTest static void test_CreateSubProcessAsAdmin() {
       
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');  
        System.Debug('SP:Account Created');
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        System.Debug('SP:Opportunity Created');
        AIA_Implementation__c objImpl = AIA_TestUtil.CreateImplementation(opp.Id);        
        System.Debug('SP:Implementation Created');
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl.Id);   
        System.Debug('SP:Process Created');
        List<Sub_Process__c> objSubProc = AIA_TestUtil.CreateSubProcessList(objImpl.Id,objProcess[0].Id);
        System.Debug('SP:Subprocess Created');
        
        User  u1 = [SELECT id  from User where LastName = 'alias1' Limit 1];  
              
        Test.startTest();
        System.runas(u1){
        //Test for exception
        AIA_Custom_SubProcess_Controller cntlNull = new AIA_Custom_SubProcess_Controller(new Apexpages.StandardController(objImpl));        
        cntlNull.slSubProcess = '';
        try{
            cntlNull.SaveSubProcess();
        }catch(exception ex){
            System.assert(true);
        }        
        
        //Test for null value in 'New Subprocess Name'
        AIA_Custom_SubProcess_Controller cntl = new AIA_Custom_SubProcess_Controller(new Apexpages.StandardController(objImpl));        
        PageReference returnedSavePage = cntl.SaveSubProcess();
        System.assert(ApexPages.getMessages().size()>0);
        
        //Test for blank value in 'New Subprocess Name'
        cntl = new AIA_Custom_SubProcess_Controller(new Apexpages.StandardController(objImpl));        
        cntl.NewSubprocess = '';
        returnedSavePage = cntl.SaveSubProcess();        
        System.assert(ApexPages.getMessages().size()>0);
        
        //Test for Process List
        List<SelectOption> lstProcess = cntl.getProcessList();
        System.assertNotEquals(null, lstProcess);
        
        //Test for SubProcess List
        List<SelectOption> lstSubProcess = cntl.getItems();
        System.assertNotEquals(null, lstSubProcess);
            
        //Test for Sub Process Creation
        cntl.NewSubprocess = 'New Subprocess';
        cntl.changeSubProcess();
        returnedSavePage = cntl.SaveSubProcess();
        PageReference  expectedpage = new PageReference( '/' + objImpl.Id);
       
        Sub_Process__c objSub = [select Id,Sequence_Number__c,Implementation__c 
                                 from Sub_Process__c 
                                 where Stage__c = 'New Subprocess' and Implementation__c =:objImpl.Id LIMIT 1];                
        System.assertNotEquals(null,objSub.Id);        
        
        //Test for Cancel
        PageReference  returnedPage = cntl.CancelSubProcess();        
        System.Debug('AG returnedPage '+returnedPage);
        System.Debug('AG expectedpage '+expectedpage);
        System.assertEquals(returnedPage.getUrl(),expectedpage.getUrl());
        }
        Test.stopTest();
	}
    @isTest static void test_CreateSubProcessAsIPManager() {
       
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');        
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        AIA_Implementation__c objImpl = AIA_TestUtil.CreateImplementation(opp.Id);        
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl.Id);        
        List<Sub_Process__c> objSubProc = AIA_TestUtil.CreateSubProcessList(objImpl.Id,objProcess[0].Id);
        User  u2 = [SELECT id  from User where LastName = 'alias2' Limit 1];  
        
        Test.startTest();
        System.runas(u2){
        //Test for exception
        AIA_Custom_SubProcess_Controller cntlNull = new AIA_Custom_SubProcess_Controller(new Apexpages.StandardController(objImpl));        
        cntlNull.slSubProcess = '';
        try{
            cntlNull.SaveSubProcess();
        }catch(exception ex){
            System.assert(true);
        }        
        
        //Test for null value in 'New Subprocess Name'
        AIA_Custom_SubProcess_Controller cntl = new AIA_Custom_SubProcess_Controller(new Apexpages.StandardController(objImpl));        
        PageReference returnedSavePage = cntl.SaveSubProcess();
        System.assert(ApexPages.getMessages().size()>0);
        
        //Test for blank value in 'New Subprocess Name'
        cntl = new AIA_Custom_SubProcess_Controller(new Apexpages.StandardController(objImpl));        
        cntl.NewSubprocess = '';
        returnedSavePage = cntl.SaveSubProcess();        
        System.assert(ApexPages.getMessages().size()>0);
        
        //Test for Process List
        List<SelectOption> lstProcess = cntl.getProcessList();
        System.assertNotEquals(null, lstProcess);
        
        //Test for SubProcess List
        List<SelectOption> lstSubProcess = cntl.getItems();
        System.assertNotEquals(null, lstSubProcess);
            
        //Test for Sub Process Creation
        cntl.NewSubprocess = 'New Subprocess';
        cntl.changeSubProcess();
        returnedSavePage = cntl.SaveSubProcess();
        PageReference  expectedpage = new PageReference( '/' + objImpl.Id);
       
        Sub_Process__c objSub = [select Id,Sequence_Number__c,Implementation__c 
                                 from Sub_Process__c 
                                 where Stage__c = 'New Subprocess' and Implementation__c =:objImpl.Id LIMIT 1];                
        System.assertNotEquals(null,objSub.Id);        
        
        //Test for Cancel
        PageReference  returnedPage = cntl.CancelSubProcess();        
        System.Debug('AG returnedPage '+returnedPage);
        System.Debug('AG expectedpage '+expectedpage);
        System.assertEquals(returnedPage.getUrl(),expectedpage.getUrl());
        }
        Test.stopTest();
	}
}