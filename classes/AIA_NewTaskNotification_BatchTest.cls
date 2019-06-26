/*=========================================================================================
 * Purpose      : This is the test class for the class AIA_NewTaskNotification_Batch.
 * Developer    : Gayathri
 * Date 		: 04/26/2018
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date        Developer          Tag        Description
 *============+=================+=====+===========================================================
 *
 *=========================================================================================
 */
@isTest
public class AIA_NewTaskNotification_BatchTest {
@testsetup
    public static void createTestData() {
        
       //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
               
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        insert userList;
        
        List<AIA_Area_Manager__c> areaLst = new List<AIA_Area_Manager__c>();
        AIA_Area_Manager__c area1 = new AIA_Area_Manager__c();
        area1.RecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Manager').getRecordTypeId();
        area1.Area_Manager__c = u4.Id;
        area1.Areas__c ='Account Executive'; 
        areaLst.add(area1);
        
        AIA_Area_Manager__c area2 = new AIA_Area_Manager__c();
        area2.RecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Non-Manager').getRecordTypeId();
        area2.Area_Manager__c = u1.Id;
        area2.Area_Belong_to__c ='Account Executive'; 
        areaLst.add(area2);
        
        Insert areaLst;
        
        // Opportunity has a NASCO System and an associated NASCO group ID
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity1';
        testopp1.AccountId = accnt.Id;
        testOpp1.StageName ='Proposal';    
        testOpp1.CloseDate = Date.today()-90;
        testOpp1.SBU__c = 'Small/Medium';
        testopp1.Market_Segment_New__c = '51-199';
        testopp1.Business_type__c = 'Renewal';
        testopp1.Division__c = '51-199 Renewals';   
        testopp1.Underwriting_Entity__c = 'MD';
        
        testOpp1.GeneralProducer__c = 'Direct'; 
        testOpp1.System__c = 'NASCO';    
        testOpp1.NASCO_Acct_ID__c = '12201';   
        testOpp1.Related_Products_Sold__c = 'Test';       
        Date effectiveDate = testOpp1.CloseDate.addDays(35);        
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        Date contractEndDate = testOpp1.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014              
        insert testOpp1;
        
        
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
        WT.AccountID__c = accnt.id;
        WT.Description__c = 'Verify Account Legal Name';
        WT.Status__c = 'Not Started';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.SLA_Day_Type__c = 'Business';
        WT.OwnerID = u1.Id;
        WT.Workplan_Task_Template__c = WTT4.id;
        WTList.add(WT);
        
        Workplan_Task__c WT1 = new Workplan_Task__c();
        WT1.AccountID__c = accnt.id;
        WT1.Description__c = 'Complete Zip Code Verification Request';
        WT1.Status__c = 'Not Started';
        WT1.Task_Owner__c = 'Account Executive';
        WT1.Task_Owner_Type__c = 'Account Team Role';
        WT1.OwnerID = u1.Id;
        WT1.SLA_Day_Type__c = 'Calendar';
        WT1.Workplan_Task_Template__c = WTT0.id;
        WTList.add(WT1);
        
        Workplan_Task__c WT2 = new Workplan_Task__c();
        WT2.AccountID__c = accnt.id;
        WT2.Description__c = 'Complete Zip Code Verification Request';
        WT2.Status__c = 'Not Started';
        WT2.Task_Owner__c = 'Account Executive';
        WT2.Task_Owner_Type__c = 'Account Team Role';
        WT2.OwnerID = u1.Id;
        WT2.SLA_Day_Type__c = 'Calendar';
        WT2.Workplan_Task_Template__c = WTT0.id;
        WTList.add(WT2);
        insert WTList;
      
        WTList[0].status__c = 'In Progress';
        WTList[1].status__c = 'In Progress';
        update WTList;
        WTList[1].status__c = 'Completed';
        WTList[1].OwnerID = u4.Id;
        update WTList;
        }
    
    public static testMethod void testNewTaskNotificationForUsers()
        {
            Test.startTest(); 
            List<Workplan_Task__c> WPT =[SELECT id,Expected_SLA__c,Description__c,Status__c,OwnerID,Workplan_Task_Template__c,Start_Date__c from Workplan_Task__c ];
            AIA_NewTaskNotification_Batch newBatch= new AIA_NewTaskNotification_Batch ();
            database.executebatch(newBatch,50);  
            test.stopTest();
        }  
    public static testmethod void testSchedulableBatch()
        {
            Test.startTest();
            AIA_NewTaskNotification_Batch abs= new AIA_NewTaskNotification_Batch();
            String schedule = '0 0 23 * * ?';
            String jobId = System.schedule('Test Batch',schedule,abs);
            abs.execute(null);
            Test.stopTest();
        }
    
    
}