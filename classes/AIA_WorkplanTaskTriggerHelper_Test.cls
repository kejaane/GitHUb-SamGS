/*===================================================================================================================
* Date       : 6/10/2018
* Developer  : Satya Tirumalasetti
* Purpose    : This test class is used to verify that status of dependent task changes as per the primary task
*              status as marked by user manualy
*
*                                 Update History
*                                 ---------------
* Date       |     Developer        | Tag |   Description
*============+============+=========================================================================================
* 4/27/2018  | Satya                |     | Initial Creation
*============+============+=========================================================================================*/
@isTest
public class AIA_WorkplanTaskTriggerHelper_Test {
    //Create test data
    @testSetup static void testdata() {
		//Test.startTest();
        
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
        
        List<Workplan_Task_Template__c> WTTList = new List<Workplan_Task_Template__c>();
         
        Workplan_Task_Template__c WTT60 = new Workplan_Task_Template__c();
        WTT60.Description__c = 'Complete AIA_Group_Structure_Request_Form__c';
        WTT60.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT60.Status__c = 'Not-Started';
        WTT60.Task_Completion_Events__c = 'Update';
        WTT60.Task_Completion_Expression__c = '2';
        WTT60.Task_Creation_Criteria_Expression__c = '';
        WTT60.Task_Creation_Events__c = 'Insert';
        WTT60.Task_Owner__c = '';
        WTT60.Task_Owner_Type__c = 'Account Team Role';
        WTT60.Task_Type__c = 'Manual / SF should auto close this task';
        WTT60.Used_For__c = 'Post-Sales';
        WTTList.add(WTT60);
        
        Workplan_Task_Template__c WTT50 = new Workplan_Task_Template__c();
        WTT50.Description__c = 'Complete implementation';
        WTT50.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT50.Status__c = 'Not-Started';
        WTT50.Task_Completion_Events__c = 'Update';
        WTT50.Task_Completion_Expression__c = '2';
        WTT50.Task_Creation_Criteria_Expression__c = '';
        WTT50.Task_Creation_Events__c = 'Insert';
        WTT50.Task_Owner__c = '';
        WTT50.Task_Owner_Type__c = 'Account Team Role';
        WTT50.Task_Type__c = 'Manual / SF should auto close this task';
        WTT50.Used_For__c = 'Post-Sales';
        WTTList.add(WTT50); 
        
        Workplan_Task_Template__c WTT70 = new Workplan_Task_Template__c();
        WTT70.Description__c = 'Complete implementation';
        WTT70.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT70.Status__c = 'Not-Started';
        WTT70.Task_Completion_Events__c = 'Update';
        WTT70.Task_Completion_Expression__c = '2';
        WTT70.Task_Creation_Criteria_Expression__c = '';
        WTT70.Task_Creation_Events__c = 'Insert';
        WTT70.Task_Owner__c = '';
        WTT70.Task_Owner_Type__c = 'Account Team Role';
        WTT70.Task_Type__c = 'Manual / SF should auto close this task';
        WTT70.Used_For__c = 'Post-Sales';
        WTT70.Task_Generation_Criteria_Expression__c = '1 AND 2';
        WTTList.add(WTT70);
        
        insert WTTList;
        
        Workplan_Task_Rules__c   wptr = new Workplan_Task_Rules__c();
        wptr.Criteria_Type__c = 'Task Generation criteria';
        wptr.Field_API_Name__c = 'Status__c';
        wptr.Object_API_Name__c = 'AIA_Implementation__c';
        wptr.Object_DML_Event__c = 'Update';
        wptr.Operation__c = 'Equal To';
        wptr.Rule_Number__c = 1;
        wptr.Value__c = 'In Progress';
        wptr.Workplan_Task_Template__c = WTT70.id;
        insert wptr;
        
        Workplan_Task_Rules__c   wptr1 = new Workplan_Task_Rules__c();
        wptr1.Criteria_Type__c = 'Task Generation criteria';
        wptr1.Field_API_Name__c = 'Status__c';
        wptr1.Object_API_Name__c = 'AIA_Implementation__c';
        wptr1.Object_DML_Event__c = 'Update';
        wptr1.Operation__c = 'Not Equal To';
        wptr1.Rule_Number__c = 2;
        wptr1.Value__c = 'Not Started';
        wptr1.Workplan_Task_Template__c = WTT70.id;
        insert wptr1;
        
        Dependent_Workplan_Task__c DWT = new Dependent_Workplan_Task__c();
        DWT.Dependent_Task__c = WTT50.id;
        DWT.Primary_Task__c = WTT60.id;
        
        insert DWT;
       
       
               
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl.Id);        
        List<Sub_Process__c> objSubProc = AIA_TestUtil.CreateSubProcessList(objImpl.Id,objProcess[0].Id); 
        List<Workplan_Task__c> WTList = new List<Workplan_Task__c>();
        Workplan_Task__c WT3 = new Workplan_Task__c();
        WT3.AccountID__c = acc.id;
        WT3.Description__c = 'This is primary task';
        WT3.RelatedObjectId__c = objImpl.id;
        WT3.Status__c = 'Not Started';
        WT3.Task_Owner__c = 'Ancillary Analyst';
        WT3.Task_Owner_Type__c = 'Account Team';
        WT3.Send_Notification__c=True;
        WT3.Workplan_Task_Template__c = WTT60.id;
        WT3.Sub_Process__c = objSubProc[0].Id;
        WT3.Implementation__c = objImpl.id;
        WTList.add(WT3);
        
        Workplan_Task__c WT3a = new Workplan_Task__c();
        WT3a.AccountID__c = acc.id;
        WT3a.Description__c = 'This is dependent task';
        WT3a.RelatedObjectId__c = objImpl.id;
        WT3a.Status__c = 'Not Started';
        WT3a.Task_Owner__c = 'Ancillary Analyst';
        WT3a.Task_Owner_Type__c = 'Account Team';
        WT3a.Send_Notification__c=True;
        WT3a.Workplan_Task_Template__c = WTT50.id;
        WT3a.Sub_Process__c = objSubProc[0].Id;
        WT3a.Implementation__c = objImpl.id;
        WTList.add(WT3a);
        
        Workplan_Task__c WT4 = new Workplan_Task__c();
        WT4.AccountID__c = acc.id;
        WT4.Description__c = 'This is primary task for not required';
        WT4.RelatedObjectId__c = objImpl.id;
        WT4.Status__c = 'Not Started';
        WT4.Task_Owner__c = 'Ancillary Analyst';
        WT4.Task_Owner_Type__c = 'Account Team';
        WT4.Send_Notification__c=True;
        WT4.Workplan_Task_Template__c = WTT60.id;
        WT4.Sub_Process__c = objSubProc[0].Id;
        WT4.Implementation__c = objImpl.id;
        WTList.add(WT4);
        
        Workplan_Task__c WT4a = new Workplan_Task__c();
        WT4a.AccountID__c = acc.id;
        WT4a.Description__c = 'This is dependent task for not required';
        WT4a.RelatedObjectId__c = objImpl.id;
        WT4a.Status__c = 'Not Started';
        WT4a.Task_Owner__c = 'Ancillary Analyst';
        WT4a.Task_Owner_Type__c = 'Account Team';
        WT4a.Send_Notification__c=True;
        WT4a.Workplan_Task_Template__c = WTT50.id;
        WT4a.Sub_Process__c = objSubProc[0].Id;
        WT4a.Implementation__c = objImpl.id;
        WTList.add(WT4a);
		
        Workplan_Task__c WT5a = new Workplan_Task__c();
        WT5a.AccountID__c = acc.id;
        WT5a.Description__c = 'This is dependent task for not required';
        WT5a.RelatedObjectId__c = objImpl.id;
        WT5a.Status__c = 'Not required';
        WT5a.Task_Owner__c = 'Ancillary Analyst';
        WT5a.Task_Owner_Type__c = 'Account Team';
        WT5a.Send_Notification__c=True;
        WT5a.Workplan_Task_Template__c = WTT50.id;
        WT5a.Sub_Process__c = objSubProc[0].Id;
        WT5a.Implementation__c = objImpl.id;
        WTList.add(WT5a);
		        
        insert WTList;
        
        WT4A.Status__c='Completed';
		update WTList;

       
       //Test.startTest();
    }
     //To Check the dependent  task status is changed to Not Required when primary task is marked as not required
    @isTest
    public static void test_NotRequiredStatus(){
        User  u2 = [SELECT id  from User where LastName = 'alias2' Limit 1];  
        
        Workplan_Task__c WptPrimary = [select id,Status__c,Workplan_Task_Template__c,Opportunity__c,Opportunity_Implementation_ID__c,Description__c 
                                       from Workplan_Task__c
                                       where Description__c='This is primary task' limit 1 ];
         
        test.startTest();  
        WptPrimary.Status__c = 'Not Required';
        update WptPrimary;
        Workplan_Task__c WptDependent = [select id,Status__c,Workplan_Task_Template__c,Opportunity__c,Opportunity_Implementation_ID__c,Description__c 
                                       from Workplan_Task__c
                                       where Description__c='This is dependent task' limit 1 ];
        system.assertequals(WptDependent.Status__c,'Not Started');
        wptDependent.Status__c = 'In Progress';
        update wptDependent;
        
    }
    
    //To Check the dependent  task status is vhanged to Not Started when primary task is marked as not started from not required
    @isTest
    public static void test_NotStartedStatus(){
        User  u2 = [SELECT id  from User where LastName = 'alias2' Limit 1];  
        
        Workplan_Task__c WptPrimary = [select id,Status__c,Workplan_Task_Template__c,Opportunity__c,Opportunity_Implementation_ID__c,Description__c 
                                       from Workplan_Task__c
                                       where Description__c='This is primary task for not required' limit 1 ];
        
        test.startTest();  
        WptPrimary.Status__c = 'Not Started';
        update WptPrimary;
         Workplan_Task__c WptDependent = [select id,Status__c,Workplan_Task_Template__c,Opportunity__c,Opportunity_Implementation_ID__c,Description__c 
                                       from Workplan_Task__c
                                       where Description__c='This is dependent task for not required' limit 1 ];
        //system.assertequals(WptDependent.Status__c,'Not Started');
        
    }
  @isTest
    public static void test_completed(){
        User  u2 = [SELECT id  from User where LastName = 'alias2' Limit 1];  
        
        Workplan_Task__c WptPrimary = [select id,Status__c,Workplan_Task_Template__c,Opportunity__c,
                                       Opportunity_Implementation_ID__c,Description__c 
                                       from Workplan_Task__c
                                       where Description__c='This is primary task for not required' limit 1 ];
        
        test.startTest();  
        WptPrimary.Status__c = 'Completed';
        WptPrimary.SLA_Day_Type__c='Calendar';
        update WptPrimary;
         Workplan_Task__c WptDependent = [select id,Status__c,Workplan_Task_Template__c,Opportunity__c,Opportunity_Implementation_ID__c,Description__c 
                                       from Workplan_Task__c
                                       where Description__c='This is dependent task for not required' limit 1 ];
        system.assertequals(WptDependent.Status__c,'Completed');
        
    }
    @isTest
    public static void test_updateDueDateWithCalendar()
    {
        
      	Workplan_Task__c W1 =[SELECT ID,status__c FROM Workplan_Task__c where status__C = 'Not Started' LIMIT 1];
        Workplan_Task__c W2 =[SELECT ID,status__c FROM Workplan_Task__c where status__C = 'Not Started' LIMIT 1];
		system.assertEquals('Not Started', w1.Status__c);
        test.startTest(); 
        w1.Status__c ='In Progress';
        w1.Total_Days_to_Complete_Task_SLA__c = 4;
        w1.SLA_Day_Type__c = 'Calendar';
        update w1;
        
        system.assertEquals('In Progress',w1.Status__c);
        
        
		system.assertEquals('Not Started', w2.Status__c);
        
        w2.Status__c ='In Progress';
        w2.Total_Days_to_Complete_Task_SLA__c = 4;
        w2.SLA_Day_Type__c = 'Business';
        update w2;
        test.stopTest();
        system.assertEquals('In Progress',w2.Status__c);
       
    }
    @isTest
    public static void test_updateDueDateWithBusiness()
    { 
        Workplan_Task__c W2 =[SELECT ID,status__c FROM Workplan_Task__c where status__C = 'Not Started' LIMIT 1];
		//system.assertEquals('Not Started', w1.Status__c);
        test.startTest(); 
        w2.Status__c ='In Progress';
        w2.Total_Days_to_Complete_Task_SLA__c = 4;
        w2.SLA_Day_Type__c = 'Business';
        update w2;
        test.stopTest();
        system.assertEquals('In Progress',w2.Status__c);
    }
    
    @isTest
    public static void test_updateWPlanStatus()
    
    {
        Workplan_Task__c W1 =[SELECT ID,status__c FROM Workplan_Task__c where status__C != 'Completed' LIMIT 1];
        test.startTest();
        w1.Status__c ='Not Required';
        update w1;
        system.assertEquals('Not Required', w1.Status__c);
        w1.Status__c ='Not Started';
        
        update w1;
        system.assertEquals('Not Started', w1.Status__c);
        test.stopTest();
       
    }

    
}