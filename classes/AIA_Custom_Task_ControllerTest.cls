/*=========================================================================================
* Date         : 04/18/18
* Developer    : Arshia Gulati
* Purpose      : This class contains unit tests for AIA_Custom_Task_Controller
*=========================================================================================
*                                 Update History
*                                 ---------------
* Date       Developer         Description
*===========+============+================================================================
* 04/18/18  |  AG    |     |This class is used to test AIA_Custom_Task_Controller
* 05/03/2018|Gayathri|  T01|Added a test method to chec create custom task in BRF as part of US228 
* 05/08/2018|AG      |  T03|Added a test method to assign team role and member US1790
* 05/14/2018|AG      |  T04|Add test to check number of active tasks assigned to team members US1691
* 06/05/2018|AG      |  T05| Updated to populate SLA Days based on Due Date US890 enhancement
* 02/24/2019|Chaithra|  T06| Changed reference from Standard obj to Custom Obj
*=========================================================================================
*/
@isTest
public class AIA_Custom_Task_ControllerTest {
    //T03-Start
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
        u4.ProfileId=AdminProfile.Id;
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
        
        insert userList;
        
        AIA_TestUtil.CreateAreaManager(u1.id, 'Implementation Manager;BeneFact Coder;BeneFact Tester', 'BeneFact Coder;BeneFact Tester', 'alias1', 'Manager');
        AIA_TestUtil.CreateAreaManager(u2.id, 'BeneFact Coder', '', 'alias2', 'Non-Manager');
        AIA_TestUtil.CreateAreaManager(u3.id, 'BeneFact Coder;BeneFact Tester', '', 'alias3', 'Non-Manager');
        AIA_TestUtil.CreateAreaManager(u4.id, 'AIA Admin;BeneFact Tester', 'BeneFact Tester;AIA Admin', 'alias4', 'Manager');
        AIA_TestUtil.CreateAreaManager(u5.id, 'BeneFact Tester', '', 'alias5', 'Non-Manager');
        AIA_TestUtil.CreateAreaManager(u6.id, 'AIA Admin;BeneFact Tester', 'AIA Admin', 'alias6', 'Manager');
        
        //T05 - Start
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');       
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();//T06
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//t06
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Proposal Specialist')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Account Manager'));
        insert acctMbrList;        
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        AIA_Implementation__c objImpl = AIA_TestUtil.CreateImplementation(opp.Id);        
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl.Id);        
        List<Sub_Process__c> objSubProc = AIA_TestUtil.CreateSubProcessList(objImpl.Id,objProcess[0].Id);
        //T05 - End
        
    }
    //Create task as Implementation Manager - Assign Task to team members who belongs to the area managed by the IP-Manager
    @isTest static void test_CreateTaskAsManager() {
        AIA_Implementation__c  objImpl = [SELECT id  from AIA_Implementation__c Limit 1]; //T05 
        User  u1 = [SELECT id  from User where LastName = 'alias1' Limit 1];  
        User  u2 = [SELECT id  from User where LastName = 'alias2' Limit 1]; 
        User  u3 = [SELECT id  from User where LastName = 'alias3' Limit 1]; 
        
        Test.startTest();
        System.runAs(u1){
            AIA_Custom_Task_Controller cntl = new AIA_Custom_Task_Controller(new Apexpages.StandardController(objImpl));        
            
            //Test for Task Name validation
            cntl.SaveTask();
            System.Debug('AG ApexPages.getMessages()' +ApexPages.getMessages());
            System.assertEquals( ApexPages.getMessages()[0].getDetail(),'Please enter New Task Name.');
            
            //Test for SubProcess List
            List<SelectOption> lstSubProcess = cntl.getSubprocessList();
            System.assertNotEquals(null, lstSubProcess);
            
            //Test for Task Description validation
            cntl.objTask.Task_Name__c = 'New Test Task';
            cntl.SaveTask();        
            System.Debug('AG ApexPages.getMessages()' +ApexPages.getMessages());
            System.assertEquals( ApexPages.getMessages()[1].getDetail(),'Please enter Task Description.');
            
            //Test for Team Member Name validation
            cntl.objTask.Description__c = 'New Task Description';
            System.Debug('AG ApexPages.getMessages()' +ApexPages.getMessages());
            
            //Test for Due Date validation   
            cntl.selected_TeamRole = 'BeneFact Coder';
            cntl.SelectTeamMember();
            cntl.selected_TeamMember = u2.Id;
            cntl.SaveTask();
            System.assertEquals( ApexPages.getMessages()[2].getDetail(),'Please enter Total Days to Complete Task (SLA).'); //T05 
            
            //Test for SLA Edit by 'Business' DayType        
            Date dt = System.today();        
            //T05 - Start
            cntl.objTask.Total_Days_to_Complete_Task_SLA__c = 10;//dt.addDays(10);
            cntl.SetDueDate();
            AIA_CalculateDaysDiffExcludingHoliday calDate = new AIA_CalculateDaysDiffExcludingHoliday();
            System.assertEquals(String.valueOf(calDate.addBussinessDays(dt,Integer.valueOf(cntl.objTask.Total_Days_to_Complete_Task_SLA__c))),String.valueOf(cntl.objTask.ExpectedDate__c)); 
            
            //Test for SLA Edit by 'Calendar' DayType
            cntl.daytype='Calendar';
            cntl.SetDueDate();
            System.assertEquals(String.valueOf(dt.addDays(10)),String.valueOf(cntl.objTask.ExpectedDate__c)); 
            //T05 - End  
            
            //Test for Task Creation
            cntl.SaveTask();  
            WorkPlan_Task__c objTsk = [select Id,Sequence_Number__c,Implementation__c 
                                       from WorkPlan_Task__c 
                                       where Implementation__c =:objImpl.Id 
                                       and Task_Name__c = 'New Test Task' LIMIT 1]; 
            System.assertNotEquals(null,objTsk.Id);
            
            //Test for Cancel Screen
            PageReference  returnedPage = cntl.CancelTask();
            PageReference  expectedpage = new PageReference( '/' + objImpl.Id);
            System.assertEquals(returnedPage.getUrl(),expectedpage.getUrl());
            
            //T04 - Start - Test Active Tasks are assigned to the User
            AIA_Custom_Task_Controller cntl2 = new AIA_Custom_Task_Controller(new Apexpages.StandardController(objImpl));                
            cntl2.selected_TeamRole = 'BeneFact Coder';
            cntl2.SelectTeamMember();
            System.assertEquals(cntl2.mapUserIDToTasksCount.get(u2.Id),1);
            System.assertEquals((cntl2.TeamMemberList.get(2)).getLabel(),'alias2#1 Active tasks');
            System.assertEquals((cntl2.TeamMemberList.get(3)).getLabel(),'alias3#No Active tasks');
            //T04 - End  
        }
        Test.stopTest();
    }
    //T03-End
    
    @isTest static void test_CreateTaskAsAdmin() {
        
        AIA_Implementation__c  objImpl = [SELECT id  from AIA_Implementation__c Limit 1]; //T05 
        User  u1 = [SELECT id  from User where LastName = 'alias4' Limit 1];  
        User  u2 = [SELECT id  from User where LastName = 'alias5' Limit 1]; 
        
        Test.startTest();
        System.runAs(u1){
            AIA_Custom_Task_Controller cntl = new AIA_Custom_Task_Controller(new Apexpages.StandardController(objImpl));        
            
            //Test for Task Name validation
            cntl.SaveTask();
            System.Debug('AG ApexPages.getMessages()' +ApexPages.getMessages());
            System.assertEquals( ApexPages.getMessages()[0].getDetail(),'Please enter New Task Name.');
            
            //Test for SubProcess List
            List<SelectOption> lstSubProcess = cntl.getSubprocessList();
            System.assertNotEquals(null, lstSubProcess);
            
            //Test for Task Description validation
            cntl.objTask.Task_Name__c = 'New Test Task';
            cntl.SaveTask();        
            System.Debug('AG ApexPages.getMessages()' +ApexPages.getMessages());
            System.assertEquals( ApexPages.getMessages()[1].getDetail(),'Please enter Task Description.');
            
            //Test for Team Member Name validation
            cntl.objTask.Description__c = 'New Task Description';
            System.Debug('AG ApexPages.getMessages()' +ApexPages.getMessages());
            
            //Test for Due Date validation   
            cntl.selected_TeamRole = 'BeneFact Tester';//(cntl.TeamRoleList.get(1)).getValue(); 
            cntl.SelectTeamMember();
            cntl.selected_TeamMember = u2.Id;
            cntl.SaveTask();
            System.assertEquals( ApexPages.getMessages()[2].getDetail(),'Please enter Total Days to Complete Task (SLA).'); //T05 
            
            //Test for SLA Edit by 'Business' DayType        
            Date dt = System.today();        
            //T05 - Start
            cntl.objTask.Total_Days_to_Complete_Task_SLA__c = 10;
            cntl.SetDueDate();
            AIA_CalculateDaysDiffExcludingHoliday calDate = new AIA_CalculateDaysDiffExcludingHoliday();
            System.assertEquals(String.valueOf(calDate.addBussinessDays(dt,Integer.valueOf(cntl.objTask.Total_Days_to_Complete_Task_SLA__c))),String.valueOf(cntl.objTask.ExpectedDate__c)); 
            
            //Test for SLA Edit by 'Calendar' DayType
            cntl.daytype='Calendar';
            cntl.SetDueDate();
            System.assertEquals(String.valueOf(dt.addDays(10)),String.valueOf(cntl.objTask.ExpectedDate__c)); 
            //T05 - End
            
            //Test for Task Creation
            cntl.SaveTask();  
            WorkPlan_Task__c objTsk = [select Id,Sequence_Number__c,Implementation__c 
                                       from WorkPlan_Task__c 
                                       where Implementation__c =:objImpl.Id 
                                       and Task_Name__c = 'New Test Task' LIMIT 1]; 
            System.assertNotEquals(null,objTsk.Id);
            
            //Test for Cancel Screen
            PageReference  returnedPage = cntl.CancelTask();
            PageReference  expectedpage = new PageReference( '/' + objImpl.Id);
            System.assertEquals(returnedPage.getUrl(),expectedpage.getUrl());
        }
        Test.stopTest();
    }
    
    @isTest static void test_CreateTaskAsAdminRole() {
        
        AIA_Implementation__c  objImpl = [SELECT id  from AIA_Implementation__c Limit 1]; //T05 
        User  u1 = [SELECT id  from User where LastName = 'alias6' Limit 1];  
        User  u2 = [SELECT id  from User where LastName = 'alias5' Limit 1]; 
        
        Test.startTest();
        System.runAs(u1){
            AIA_Custom_Task_Controller cntl = new AIA_Custom_Task_Controller(new Apexpages.StandardController(objImpl));        
            
            //Test for SubProcess List
            List<SelectOption> lstSubProcess = cntl.getSubprocessList();
            System.assertNotEquals(null, lstSubProcess);
            
            cntl.objTask.Task_Name__c = 'New Test Task3';
            cntl.objTask.Description__c = 'New Task Description';
            cntl.selected_TeamRole = 'BeneFact Tester';
            cntl.SelectTeamMember();
            Date dt = System.today();        
            //T05 - Start
            cntl.objTask.Total_Days_to_Complete_Task_SLA__c = 10;
            cntl.SetDueDate();
            //T05 - End
            cntl.SaveTask();  
            System.Debug('AG ApexPages.getMessages()' +ApexPages.getMessages());
            System.assertEquals( ApexPages.getMessages()[0].getDetail(),'Please select Team Member.');
            
            cntl.selected_TeamMember = u2.Id;
            cntl.SaveTask();
            
            WorkPlan_Task__c objTsk = [select Id,Sequence_Number__c,Implementation__c 
                                       from WorkPlan_Task__c 
                                       where Implementation__c =:objImpl.Id 
                                       and Task_Name__c = 'New Test Task3' LIMIT 1]; 
            System.assertNotEquals(null,objTsk.Id);        
        }
        Test.stopTest();
    }
    
    @isTest static void test_CreateBRFTask() {
         Test.StartTest(); 
        //T05 - Start
        Account  acc = [SELECT id  from Account Limit 1]; 
        Opportunity  opp = [SELECT id  from Opportunity Limit 1]; 
        //T05 - End
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        brf.Funding_Arrangements__c = 'ASO';
        insert brf;
        //Test.startTest();
        
        
        Test.stopTest();
    }   
    @isTest
    private static void testClass()
    {
        Test.StartTest(); 
        PageReference pageRef = Page.AIA_CreateCustomTask;
        Account  acc = [SELECT id  from Account Limit 1]; 
        Opportunity  opp = [SELECT id  from Opportunity Limit 1]; 
        //T05 - End
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        brf.Funding_Arrangements__c = 'ASO';
        insert brf;
       
        
        
       
      // Test.StartTest(); 
        AIA_Custom_Task_Controller testAccPlan = new AIA_Custom_Task_Controller();
        
        
        //testAccPlan.save(); call all your function here
        Test.StopTest();
        
    }
    @isTest
    private static void testClass2()
    {
        Test.StartTest(); 
        Pagereference pageRef1 = Page.AIA_CreateCustomTask;   
        Account  acc = [SELECT id  from Account Limit 1]; 
        Opportunity  opp = [SELECT id  from Opportunity Limit 1]; 
        //T05 - End
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        brf.Funding_Arrangements__c = 'ASO';
        insert brf;
        
               //Test.StartTest(); 

            PageReference pageRef = Page.AIA_CreateCustomTask; // Add your VF page Name here
            pageRef.getParameters().put('brfid', brf.id);
            pageRef.getParameters().put('brfid', String.valueOf(brf.Id));
            Test.setCurrentPage(pageRef);

            AIA_Custom_Task_Controller testAccPlan = new AIA_Custom_Task_Controller();
            //testAccPlan.redirctPage();    
        Test.StopTest();
    }
}