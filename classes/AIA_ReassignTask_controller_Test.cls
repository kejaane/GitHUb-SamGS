/*===================================================================================================================
* Date       : 5/2/2018
* Developer  : Arshia Gulati
* Purpose    : This is the test class to test controller class AIA_ReassignTask_controller  for US-466
*
*                                 Update History
*                                 ---------------
* Date       |     Developer        | Tag |   Description
*============+============+=========================================================================================
* 4/27/2018  | Arshia Gulati       |     | Initial Creation
* 5/15/2018  | Arshia Gulati       | T01 | Added Test for Count of Active Tasks for each member
* 5/17/2018  | Arshia Gulati       | T02 | Authorize Sales user to re-assign task in their Group to other Team members US-366
*============+============+=========================================================================================*/
@isTest
public class AIA_ReassignTask_controller_Test {
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
        u3.ProfileId=nonAdminProfile.Id;
        userList.add(u3); 
        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        u4.LastName = 'alias4';
        u4.ProfileId=nonAdminProfile.Id;
        userList.add(u4);
       
         user u5 = AIA_TestUtil.AIA_createUser('alias5');
        u5.LastName = 'alias5';
        u5.ProfileId=nonAdminProfile.Id;
        userList.add(u5);
       
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        u6.LastName = 'alias6';
        u6.ProfileId=nonAdminProfile.Id;
        userList.add(u6);
        
        user u7 = AIA_TestUtil.AIA_createUser('alias7');
        u7.LastName = 'alias7';
        u7.ProfileId=AdminProfile.Id;
        userList.add(u7);
       
        //T02-Start
        user u8 = AIA_TestUtil.AIA_createUser('alias8');
        u8.LastName = 'alias8';
        u8.ProfileId=nonAdminProfile.Id;
        userList.add(u8);
        //T02-End
        insert userList;
        
        AIA_TestUtil.CreateAreaManager(u1.id, 'Implementation Manager;BeneFact Coder;BeneFact Tester', 'BeneFact Coder;BeneFact Tester', 'alias1', 'Manager');
        AIA_TestUtil.CreateAreaManager(u2.id, 'BeneFact Coder', '', 'alias2', 'Non-Manager');
        AIA_TestUtil.CreateAreaManager(u3.id, 'BeneFact Coder;BeneFact Tester', '', 'alias3', 'Non-Manager');
        AIA_TestUtil.CreateAreaManager(u4.id, 'Implementation Manager;Account Executive', 'Account Executive;AIA Admin', 'alias4', 'Manager');
        AIA_TestUtil.CreateAreaManager(u5.id, 'Account Executive', '', 'alias5', 'Non-Manager');
        AIA_TestUtil.CreateAreaManager(u6.id, 'BeneFact Tester', '', 'alias6', 'Non-Manager');
        AIA_TestUtil.CreateAreaManager(u8.id, 'Implementation Manager;', 'BeneFact Coder;BeneFact Tester', 'alias8', 'Manager');//T02
               
        //Creating WorkPlan Task Test Data 
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');        
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        AIA_Implementation__c objImpl = AIA_TestUtil.CreateImplementation(opp.Id);        
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl.Id);        
        List<Sub_Process__c> objSubProc = AIA_TestUtil.CreateSubProcessList(objImpl.Id,objProcess[0].Id);
       
        List<WorkPlan_Task__c> lstTask = new List<WorkPlan_Task__c>();      
        List<string> userId = new List<string>();
        userId.add(u2.Id);
        userId.add(u2.Id);
      //  userId.add(u5.Id);
        
        string strTeamRole = 'BeneFact Coder';  // T02 Create task with team role
        lstTask = AIA_TestUtil.CreateWorkPlanTask(objImpl.Id, opp.Id, objSubProc[0].Id, userId,strTeamRole);
        userId = new List<string>();
        userId.add(u5.Id);
        strTeamRole = 'Account Executive';  // T02 Create task with team role
        lstTask = AIA_TestUtil.CreateWorkPlanTask(objImpl.Id, opp.Id, objSubProc[0].Id, userId,strTeamRole);    
        
        //T02- Start - Create task with team role blank
        userId = new List<string>();
        userId.add(u6.Id);
        strTeamRole = '';
        lstTask = AIA_TestUtil.CreateWorkPlanTask(objImpl.Id, opp.Id, objSubProc[0].Id, userId,strTeamRole);            
         
        System.Debug('Test Data Created');
    }
     //Assign Task to the team members in the same Group as Sales User
    @isTest
    public static void test_AssignTaskAsSalesUser(){
        Test.startTest();
        User  u2 = [SELECT id  from User where LastName = 'alias2' Limit 1];  
        List<WorkPlan_Task__c> lstTask = [SELECT Id,Task_Name__c,Description__c,Owner.Name,OwnerId
                                          FROM WorkPlan_Task__c];  
        
        User  newUser = [SELECT id ,Name from User where LastName = 'alias3' Limit 1];  
         //T01 - Start
        User  u1 = [SELECT id ,Name from User where LastName = 'alias1' Limit 1];          
        //T01 - End
        Set<String> task_selected = new Set<String>();
        Apexpages.StandardSetController ssc = new Apexpages.StandardSetController(lstTask);
        ssc.setSelected(lstTask);
        System.runas(u2){
        AIA_ReassignTask_Controller objAssign = new AIA_ReassignTask_Controller(ssc);
            for(WorkPlan_Task__c tsk:lstTask){
                task_selected.add(tsk.Id);
            }
            objAssign.tskIds_Selcted = task_selected;
            objAssign.AIA_Tasks();
            
            //T01 - Start - Test Active Tasks are assigned to the User
            System.assertEquals(objAssign.mapUserIDToTasksCount.get(u2.Id),2);
            System.assertEquals(objAssign.mapUserIDToTasksCount.get(u1.Id),null);
            //T01 - End
            
            Integer noofTasks = objAssign.lstTaskWrapper.size();
            for(Integer i=0; i<noofTasks;i++){
                objAssign.lstTaskWrapper[i].selected_TeamMember = newUser.Id;
            }
            objAssign.AssignTask();
            WorkPlan_Task__c objTask = [SELECT Id,Owner.Name,OwnerId 
                                          FROM WorkPlan_Task__c where OwnerId = :newUser.Id Limit 1];
            System.assertEquals(objTask.Owner.Name,newUser.Name);
        }
        Test.stopTest();
    }
  //T02- End
    //Assign Task to the team members in the same area as managed by the area manager and the role of previous assigned user
    @isTest
    public static void test_AssignTaskAsManager(){
        Test.startTest();
        User  u8 = [SELECT id  from User where LastName = 'alias8' Limit 1];  
        List<WorkPlan_Task__c> lstTask = [SELECT Id,Task_Name__c,Description__c,Owner.Name,OwnerId 
                                          FROM WorkPlan_Task__c];  
        
        User  newUser = [SELECT id ,Name from User where LastName = 'alias3' Limit 1];  
         //T01 - Start
        User  u2 = [SELECT id ,Name from User where LastName = 'alias2' Limit 1];  
        User  u5 = [SELECT id ,Name from User where LastName = 'alias5' Limit 1];  
        //T01 - End
        Set<String> task_selected = new Set<String>();
        Apexpages.StandardSetController ssc = new Apexpages.StandardSetController(lstTask);
        ssc.setSelected(lstTask);
        System.runas(u8){
        AIA_ReassignTask_Controller objAssign = new AIA_ReassignTask_Controller(ssc);
            for(WorkPlan_Task__c tsk:lstTask){
                task_selected.add(tsk.Id);
            }
            objAssign.tskIds_Selcted = task_selected;
            objAssign.AIA_Tasks();
            
            //T01 - Start - Test Active Tasks are assigned to the User
            System.assertEquals(objAssign.mapUserIDToTasksCount.get(u2.Id),2);
            System.assertEquals(objAssign.mapUserIDToTasksCount.get(u5.Id),1);
            //T01 - End
            
            Integer noofTasks = objAssign.lstTaskWrapper.size();
            for(Integer i=0; i<noofTasks;i++){
                objAssign.lstTaskWrapper[i].selected_TeamMember = newUser.Id;
            }
            objAssign.AssignTask();
            WorkPlan_Task__c objTask = [SELECT Id,Owner.Name,OwnerId 
                                          FROM WorkPlan_Task__c where OwnerId = :newUser.Id Limit 1];
            System.assertEquals(objTask.Owner.Name,newUser.Name);
        }
        Test.stopTest();
    }
    //Assign Task to the team members in the same area as previously assigned user
    @isTest
    public static void test_AssignTaskAsAIAAdmin(){
        Test.startTest();
        List<WorkPlan_Task__c> lstTask = [SELECT Id,Task_Name__c,Description__c,Owner.Name,OwnerId 
                                          FROM WorkPlan_Task__c];  
        User  u = [SELECT id  from User where LastName = 'alias4' Limit 1];  
        User  newUser = [SELECT id ,Name from User where LastName = 'alias3' Limit 1]; 
        //T01 - Start
        User  u2 = [SELECT id ,Name from User where LastName = 'alias2' Limit 1];  
        User  u5 = [SELECT id ,Name from User where LastName = 'alias5' Limit 1];  
        //T01 - End
        Set<String> task_selected = new Set<String>();
        System.runas(u){
        AIA_ReassignTask_Controller objAssign = new AIA_ReassignTask_Controller(new Apexpages.StandardSetController(lstTask));
            for(WorkPlan_Task__c tsk:lstTask){
                task_selected.add(tsk.Id);
            }
            objAssign.tskIds_Selcted = task_selected;
            objAssign.AIA_Tasks();
           
            //T01 - Start - Test Active Tasks are assigned to the User
            System.assertEquals(objAssign.mapUserIDToTasksCount.get(u2.Id),2);
            System.assertEquals(objAssign.mapUserIDToTasksCount.get(u5.Id),1);
            //T01 - End 
        
            //Test to Save Task without assigning a team member
            objAssign.AssignTask();
            System.assert(objAssign.IsError);
            
            Integer noofTasks = objAssign.lstTaskWrapper.size();
            for(Integer i=0; i<noofTasks;i++){
                objAssign.lstTaskWrapper[i].selected_TeamMember = newUser.Id;
            }
            objAssign.AssignTask();
            WorkPlan_Task__c objTask = [SELECT Id,Owner.Name,OwnerId 
                                          FROM WorkPlan_Task__c where OwnerId = :newUser.Id Limit 1];
            System.assertEquals(objTask.Owner.Name,newUser.Name);
        }
        Test.stopTest();
    }
    //Login as System Admin and Assign Task to the team members in the same area as previously assigned user
    @isTest
    public static void test_AssignTaskAsSystemAdmin(){
        Test.startTest();
        List<WorkPlan_Task__c> lstTask = [SELECT Id,Task_Name__c,Description__c,Owner.Name,OwnerId 
                                          FROM WorkPlan_Task__c];  
        User  u = [SELECT id  from User where LastName = 'alias7' Limit 1];  
        User  newUser = [SELECT id ,Name from User where LastName = 'alias3' Limit 1];
         //T01 - Start
        User  u2 = [SELECT id ,Name from User where LastName = 'alias2' Limit 1];  
        User  u5 = [SELECT id ,Name from User where LastName = 'alias5' Limit 1];  
        //T01 - End
        Set<String> task_selected = new Set<String>();
        System.runas(u){
        AIA_ReassignTask_Controller objAssign = new AIA_ReassignTask_Controller(new Apexpages.StandardSetController(lstTask));
            for(WorkPlan_Task__c tsk:lstTask){
                task_selected.add(tsk.Id);
            }
            objAssign.tskIds_Selcted = task_selected;
            objAssign.AIA_Tasks();
            //T01 - Start - Test Active Tasks are assigned to the User
            System.assertEquals(objAssign.mapUserIDToTasksCount.get(u2.Id),2);
            System.assertEquals(objAssign.mapUserIDToTasksCount.get(u5.Id),1);
            //T01 - End
            Integer noofTasks = objAssign.lstTaskWrapper.size();
            for(Integer i=0; i<noofTasks;i++){
                objAssign.lstTaskWrapper[i].selected_TeamMember = newUser.Id;
            }
            objAssign.AssignTask();
            WorkPlan_Task__c objTask = [SELECT Id,Owner.Name,OwnerId 
                                          FROM WorkPlan_Task__c where OwnerId = :newUser.Id Limit 1];
            System.assertEquals(objTask.Owner.Name,newUser.Name);
        }
        Test.stopTest();
    }
    //Cancel action - to view list page
    @isTest
    public static void test_Cancel(){
	Test.startTest();
        List<WorkPlan_Task__c> lstTask = [SELECT Id,Task_Name__c,Description__c,Owner.Name,OwnerId 
                                          FROM WorkPlan_Task__c];  
        User  u = [SELECT id  from User where LastName = 'alias1' Limit 1];  
        Set<String> task_selected = new Set<String>();
        System.runas(u){
        AIA_ReassignTask_Controller objAssign = new AIA_ReassignTask_Controller(new Apexpages.StandardSetController(lstTask));
            for(WorkPlan_Task__c tsk:lstTask){
                task_selected.add(tsk.Id);
            }
            objAssign.tskIds_Selcted = task_selected;
            objAssign.AIA_Tasks();
            
            PageReference  returnedPage = objAssign.CancelAssign();
            System.Debug(returnedPage);
        PageReference  expectedpage =  new ApexPages.Action('{!List}').invoke();
            System.Debug(expectedpage);
        System.assertEquals(returnedPage,expectedpage);
        Test.stopTest();
        }
    }
    
}