/*===================================================================================================================
* Date       : 5/2/2018
* Developer  : Satya
* Purpose    : This is the test class for AIA_TaskReassign_controller to test the teask reassignment
*
*                                 Update History
*                                 ---------------
* Date       |     Developer        | Tag |   Description
*============+============+=========================================================================================
* 5/2/2018   |     Satya            |     | Initial Creation
*============+============+=========================================================================================*/

@isTest
public class AIA_TaskReassign_controllerTest {
    @isTest
    //Here we are testing whether the task is getting reassigned to other person successfully or not
    public static void AssignTasktest(){
        Test.startTest();
        List<WorkPlan_Task__c> lstTask = [SELECT Id,Task_Name__c,Description__c,Owner.Name,OwnerId 
                                          FROM WorkPlan_Task__c];  
        List<AIA_Area_Manager__c> userEntryList = [Select Id, Area_Manager__c,Area_Belong_to__c,Areas__c,Name 
                                                   from AIA_Area_Manager__c];
        User  u = [SELECT id from User where LastName = 'alias1' Limit 1];  
        User  newUser = [SELECT id ,Name from User where LastName = 'alias3' Limit 1];  
       Set<String> task_selected = new Set<String>();
        System.runas(u){
        PageReference pref = Page.AIA_ReassignWorkplanTask;
        Test.SetCurrentPage(Pref);
          ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstTask);
          stdSetController.setSelected(lstTask);
          AIA_TaskReassign_controller tskCtrl = new AIA_TaskReassign_controller(stdSetController);
          tskCtrl.lstTaskWrapper[0].SelectedTeamMember = newUser.Id;
          tskCtrl.SaveWorkPlanTask();
          WorkPlan_Task__c objTask = [SELECT Id,Owner.Name,OwnerId 
                                      FROM WorkPlan_Task__c where OwnerId = :newUser.Id Limit 1];
          System.assertEquals(objTask.Owner.Name,newUser.Name);
          PageReference  returnedPage = tskCtrl.CancelWorkPlanTask();
          PageReference  expectedpage =  new ApexPages.Action('{!List}').invoke();
          System.assertEquals(returnedPage,expectedpage);
            Test.stopTest();
        }
    }
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
        u3.ProfileId=nonAdminProfile.Id;
        userList.add(u3); 
        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        u4.LastName = 'alias4';
        u4.ProfileId=nonAdminProfile.Id;
        userList.add(u4);
          
        insert userList;
        
        
                   
        //Creating WorkPlan Task Test Data 
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');        
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        AIA_Implementation__c objImpl = AIA_TestUtil.CreateImplementation(opp.Id);        
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl.Id);        
        List<Sub_Process__c> objSubProc = AIA_TestUtil.CreateSubProcessList(objImpl.Id,objProcess[0].Id);
        AIA_TestUtil.CreateAreaManager(u1.id, 'Implementation Manager;BeneFact Coder;BeneFact Tester', 'BeneFact Coder;BeneFact Tester', 'alias1', 'Manager');
        AIA_TestUtil.CreateAreaManager(u2.id, 'BeneFact Coder', '', 'alias2', 'Non-Manager');
        AIA_TestUtil.CreateAreaManager(u3.id, 'BeneFact Coder;BeneFact Tester', '', 'alias3', 'Non-Manager');
        AIA_TestUtil.CreateAreaManager(u4.id, 'Implementation Manager;Account Executive', 'Account Executive;AIA Admin', 'alias4', 'Manager');
        
       
        List<WorkPlan_Task__c> lstTasks = new List<WorkPlan_Task__c>();
        List<WorkPlan_Task__c> lstTask = new List<WorkPlan_Task__c>();      
        List<string> userId = new List<string>();
        userId.add(u2.Id);
        userId.add(u1.Id);
        userId.add(u4.Id);
        lstTask = AIA_TestUtil.CreateWorkPlanTask(objImpl.Id, opp.Id, objSubProc[0].Id, userId,'');    
        for(WorkPlan_Task__c tsk :lstTask ){
            tsk.Status__c = 'In Progress'; 
            tsk.Task_Owner__c ='BeneFact Coder';
            lstTasks.add(tsk);
        }
        update lstTasks;
    }
}