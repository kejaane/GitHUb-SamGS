@isTest 
public class AIA_View_WorkPlanTaskTest {
    @testSetup 
    static void testdata() {        
        Profile nonAdminProfile = [select id from profile where name='AIA 200+ Standard User - Custom'];
        List<user> userList = new list<user>();
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertEquals('TestAccount', acc.name);
        Account acc2 = AIA_TestUtil.CreateAccount('TestAccount2');
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        u1.LastName = 'alias1';
        u1.ProfileId= nonAdminProfile.Id;
        userList.add(u1); 
        
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        u2.LastName = 'alias2';
        u2.ProfileId =nonAdminProfile.Id;
        userList.add(u2);
        
       insert userList;
        
        List<Workplan_Task_Template__c> WTTList = new List<Workplan_Task_Template__c>();
        Workplan_Task_Template__c WTT0 = new Workplan_Task_Template__c();
        WTT0.Description__c = 'Complete Zip Code Verification Request';
        WTT0.Related_Object_API_Name__c = 'Benfit_Request_Form__c';
        WTT0.Status__c = 'Not-Started';
        WTT0.Task_Completion_Events__c = 'Update';
        WTT0.Task_Completion_Expression__c = '2';
        WTT0.Task_Creation_Criteria_Expression__c = '1';
        WTT0.Task_Creation_Events__c = 'Insert';
        WTT0.Task_Owner__c = '';
        WTT0.Task_Owner_Type__c = 'Account Team Role';
        WTT0.Task_Owner__c  = 'Account Executive';
        WTT0.Task_Type__c = 'Manual / SF should auto close this task';
        WTT0.Expected_SLA__c = 1;

        WTTList.add(WTT0);
        
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Name';
        WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Status__c = 'Not Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = '2';
        WTT4.Task_Completion_Expression__c = '1';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Manual / SF should auto close this task';
        WTT4.Expected_SLA__c = 1;
        WTTList.add(WTT4);
        insert WTTList;      
        
        List<Workplan_Task__c> WTList = new List<Workplan_Task__c>();
        Workplan_Task__c WT = new Workplan_Task__c();
        WT.AccountID__c = acc.id;
        WT.Description__c = 'Verify Account Legal Name';
        WT.Status__c = 'Not Started';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.SLA_Day_Type__c = 'Business';
        WT.OwnerID = u1.Id;
        WT.Workplan_Task_Template__c = WTT4.id;
        WT.status__c = 'In Progress';
        WTList.add(WT);
        
        Workplan_Task__c WT1 = new Workplan_Task__c();
        WT1.AccountID__c = acc2.id;
        WT1.Description__c = 'Complete Zip Code Verification Request';
        WT1.Status__c = 'Not Started';
        WT1.Task_Owner__c = 'Account Executive';
        WT1.Task_Owner_Type__c = 'Account Team Role';
        WT1.OwnerID = u2.Id;
        WT1.SLA_Day_Type__c = 'Calendar';
        WT1.Workplan_Task_Template__c = WTT0.id;
        WT1.status__c = 'Completed';
        WTList.add(WT1);
        
        insert WTList;        
    }
    
    @isTest
    Public static void testWorkPlans(){
        Test.startTest();
        User u = [select id from USer where lastname ='alias1' limit 1];
        Account acc = [select id from  Account WHERE name = 'TestAccount' Limit 1];
        System.runAs(u) {  
            PageReference pageRef = Page.AIA_View_WorkPlanTasks; 
            pageRef.getParameters().put('showallTsk', 'true');
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',userinfo.getUserId());
            AIA_View_WorkPlanTaskCtrller tskViewer = new AIA_View_WorkPlanTaskCtrller();
            tskViewer.listSize = 1;
            tskViewer.viewAll();
            tskViewer.nextTask();
            tskViewer.previousTask();            
            tskViewer.nextTask();
            tskViewer.nextLastTask();
            
            tskviewer.previousFirstTask();
           tskViewer.getprev();
            tskViewer.getnxt();
          
            tskViewer.SortField = 'Description__c';
            tskViewer.SortToggle();            
    }
}
}