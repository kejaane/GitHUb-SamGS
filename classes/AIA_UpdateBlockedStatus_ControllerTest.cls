/*=========================================================================================
 * Date         : 05/29/18
 * Developer    : Arshia Gulati
 * Purpose      :  
 * 
 * This class contains unit tests for AIA_UpdateBlockedStatus_Controller US2254
 *   
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 05/29/18  |  AG    |  Initial
 *=========================================================================================
 */
@isTest
public class AIA_UpdateBlockedStatus_ControllerTest {
    //Create test data
    @testSetup static void testdata() {
        
        Profile nonAdminProfile = [select id from profile where name='AIA 200+ Standard User - Custom'];
        Profile adminProfile = [select id from profile where name='System Administrator'];
       
        //Creating User Test Data 
        List<user> userList = new list<user>();
       
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        u1.LastName = 'alias1';
        u1.ProfileId= nonAdminProfile.Id;
        userList.add(u1); 
        
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        u2.LastName = 'alias2';
        u2.ProfileId =nonAdminProfile.Id;
        userList.add(u2);
        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        u3.LastName = 'alias3';
        u3.ProfileId =nonAdminProfile.Id;
        userList.add(u3);
        
        insert userList;
              
        //Creating WorkPlan Task Test Data 
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');  
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Proposal Specialist')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Account Manager'));
        insert acctMbrList;
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        AIA_Implementation__c objImpl = AIA_TestUtil.CreateImplementation(opp.Id);     
        objImpl.OwnerId = u2.Id;
        update objImpl;
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl.Id);        
        List<Sub_Process__c> objSubProc = AIA_TestUtil.CreateSubProcessList(objImpl.Id,objProcess[0].Id);
       
        List<WorkPlan_Task__c> lstTask = new List<WorkPlan_Task__c>();      
        List<string> userId = new List<string>();
        userId.add(u1.Id);
        userId.add(u2.Id);
        
        string strTeamRole = 'BeneFact Coder';  // T02 Create task with team role
        lstTask = AIA_TestUtil.CreateWorkPlanTask(objImpl.Id, opp.Id, objSubProc[0].Id, userId,strTeamRole);    
         
        System.Debug('Test Data Created');
    }
    
    //Test Method
@isTest static void test_BlockTask() {        
        User  u1 = [SELECT id  from User where LastName = 'alias1' Limit 1];  
        User  u2 = [SELECT id  from User where LastName = 'alias2' Limit 1]; 
        //Task to be blocked
        List<WorkPlan_Task__c> lstTask = [SELECT Id,Task_Name__c,Description__c,Owner.Name,OwnerId 
                                          FROM WorkPlan_Task__c where OwnerId = :u1.Id]; 
    Test.startTest();
        //Task causing block on selected task
        List<WorkPlan_Task__c> lstBlockerTask = [SELECT Id,Task_Name__c,Sub_Process__r.Id,Description__c,Owner.Name,OwnerId 
                                          FROM WorkPlan_Task__c where OwnerId = :u2.Id];        
        lstBlockerTask[0].status__c = AIA_CONSTANTS.WPTask_STATUS_COMPLETED; 
        update lstBlockerTask;
             
        //Test.startTest();
        
        //Run As User 1 who owns the task selected
        System.runAs(u1){
            
        Apexpages.StandardSetController ssc = new Apexpages.StandardSetController(lstTask);
        //Test for Error Message when No task is selected
        AIA_UpdateBlockedStatus_Controller cntl_NoTask = new AIA_UpdateBlockedStatus_Controller(ssc);  
        cntl_NoTask.UpdateTaskStatus();            
        System.assertEquals('Please select a task to Block',cntl_NoTask.strMessage);
        
        //Test for error message when No Sub Process is selected
        ssc.setSelected(lstTask);       
        AIA_UpdateBlockedStatus_Controller cntl = new AIA_UpdateBlockedStatus_Controller(ssc);  
        cntl.UpdateTaskStatus();            
        System.assertEquals( ApexPages.getMessages()[0].getDetail(),'Please select a Sub Process');

        //Test for error message when No Blocker Task is selected
        cntl.SubProcess_selected = lstBlockerTask[0].Sub_Process__r.Id;
        cntl.changeSubprocess();
        cntl.UpdateTaskStatus();      
        System.assertEquals( ApexPages.getMessages()[1].getDetail(),'Please select a Task');
        
        //Test for Block Status update
        cntl.BlockerTask_selected = lstBlockerTask[0].Id;
        cntl.UpdateTaskStatus();            
        WorkPlan_Task__c objTsk = [select Id,Status__c
                                   from WorkPlan_Task__c 
                                   where Id=:lstTask[0].Id LIMIT 1]; 
        System.assertEquals(AIA_Constants.WPTask_STATUS_BLOCKED,objTsk.Status__c);
            
        //Test for Cancel Update
        PageReference  returnedPage = cntl.CancelUpdate();
        PageReference  expectedpage = new ApexPages.Action('{!List}').invoke();
        System.assertEquals(returnedPage,expectedpage);            
        }    
    
        //Test for Error Message when selected Task is owned by another user
        System.runAs(u2){            
            Apexpages.StandardSetController ssc = new Apexpages.StandardSetController(lstTask);            
            ssc.setSelected(lstTask);       
            AIA_UpdateBlockedStatus_Controller cntl = new AIA_UpdateBlockedStatus_Controller(ssc);          
            System.assertEquals('Please select In-Progress tasks owned by You',cntl.strMessage);
        }
    
        Test.stopTest();
    }
}