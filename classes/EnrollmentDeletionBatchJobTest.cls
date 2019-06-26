/*************************************************************************************************************************************************
*  Date             : 05/30/2018
*  Developer        : Thejaswi Ganesh
*  Purpose          : Test Class for EnrollmentDeletionBatchJob
*
*  Update History:
* ----------------------------------------------------------------------------------------------------------------------------------------------
*  Author          Date-Modified      Tag      Description of Change
* ----------------------------------------------------------------------------------------------------------------------------------------------
* Thejaswi Ganesh  05/30/2018                  Initial Creation
*
************************************************************************************************************/

@isTest
public class EnrollmentDeletionBatchJobTest {
    
    static testMethod void testBatchJob() {
        test.startTest();
        List<Account> accounts = createTestAccounts();
        List<Opportunity> opps = createTestOpportunities( accounts );
        createTestEnrollments( accounts );
        EnrollmentDeletionBatchJob batchJob = new EnrollmentDeletionBatchJob();//default mode
        Database.executeBatch(batchJob);
        EnrollmentDeletionBatchJob batchJob2 = new EnrollmentDeletionBatchJob('initial');
        Database.executeBatch(batchJob2);
        EnrollmentDeletionBatchJob batchJob1 = new EnrollmentDeletionBatchJob('yearly');
        Database.executeBatch(batchJob1);
        test.stopTest();
    }
    
    private static List<Account> createTestAccounts() {
        Account a1 = new Account( Name = 'Test Account',
                                 Rating_State__c = 'M',
                                 RecordTypeId = QueryBase.getRecordtypeId( 'Account', 'X2_50') );
        
        List<Account> lA = new List<Account>();
        lA.add( a1 );
        insert lA;
        return lA;
    }
    
    private static List<Opportunity> createTestOpportunities( List<Account> accounts ) {
        Opportunity o1 = new Opportunity(   AccountId = accounts[0].Id,
                                         RecordTypeId = QueryBase.getRecordtypeId( 'Opportunity', 'X2_50' ),
                                         Name = 'Test Opp 1',
                                         CloseDate = date.newInstance(2013, 1, 1),
                                         Effective_Date__c = date.newInstance(2013, 2, 1),
                                         Contract_End_Date__c = date.newInstance(2013, 12, 31),
                                         StageName = 'Proposal',
                                         System__c = 'Facets',
                                         Risk_Non_Risk__c = 'Non-Risk',
                                         GeneralProducer__c = 'Direct');
        List<Opportunity> lO = new List<Opportunity>();
        lO.add( o1 );
        insert lO;
        return lo;
    }
    
    private static void createTestEnrollments( List<Account> accounts ) {
        
        // Get an Opp
        Opportunity o1 = [SELECT Id, Name, AccountId
                          FROM Opportunity
                          WHERE Account.Rating_State__c = 'M'
                          LIMIT 1];
        
        
        // MD
        List<Enrollment__c> lE = new List<Enrollment__c>();
        Enrollment__c E1 = new Enrollment__c();
        E1.RecordTypeId = QueryBase.getRecordtypeId( 'Enrollment__c', 'X2_50');
        E1.Opportunity__c = o1.Id;
        E1.Processed_Type__c = 'M';
        E1.Rpt_Dt__c = '201312';
        E1.Contracts__c = 100;
        E1.Groups__c = 5;
        E1.Status__c = 'Active';
        E1.On_Cycle__c = true;
        E1.New_Business_Indicator__c = 'N';
        E1.Renewal_Anniversary_Date__c = Date.newInstance( 2013, 12, 01 );
        E1.On_Cycle__c = true;
        E1.Reporting_Checkbox__c = true;
        lE.add( E1 );
        
        Enrollment__c E2 = new Enrollment__c();
        E2.RecordTypeId = QueryBase.getRecordtypeId( 'Enrollment__c', 'X2_50');
        E2.Opportunity__c = o1.Id;
        E2.Processed_Type__c = 'M';
        E2.Rpt_Dt__c = '201512';
        E2.Contracts__c = 100;
        E2.Groups__c = 5;
        E2.Status__c = 'Active';
        E2.On_Cycle__c = true;
        E2.New_Business_Indicator__c = 'N';
        E2.Renewal_Anniversary_Date__c = Date.newInstance( 2013, 12, 01 );
        E2.On_Cycle__c = true;
        E2.Reporting_Checkbox__c = true;
        lE.add( E2 );
        insert lE;
    }
    
}