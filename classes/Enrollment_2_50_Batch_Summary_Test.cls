/****************************************************************************
* Name        - Enrollment_2_50_Batch_Summary_Test
* Description - Test Coverage for Enrollment_2_50_Batch_Summary
*                   
* Modification Log :
* ---------------------------------------------------------------------------
* Developer            Date          Description
* ---------------------------------------------------------------------------
* jmasters (EP)        12-11-2018    Created 
* Tom Barrett (TPB)    08/18/2015    added new method createTestCustomSettings 
* Ashish Ojha (AO)     04/04/2016    Updated method createTestCustomSettings       
****************************************************************************/
@isTest
private class Enrollment_2_50_Batch_Summary_Test {

    static testMethod void testBatchJob() {
        List<Account> accounts = createTestAccounts();
        createTestOpportunities( accounts );
        createTestEnrollments( accounts );
        createTestCustomSettings();        // TPB ADDED 08/18/2015
        List<Enrollment__c> lE = [SELECT Id FROM Enrollment__c LIMIT 5];
        test.startTest();
        Enrollment_2_50_Batch_Summary batchJob = new Enrollment_2_50_Batch_Summary( lE );
        database.executeBatch( batchJob );
        test.stopTest();
    }
    
    private static List<Account> createTestAccounts() {
        Account a1 = new Account( Name = 'Test Account',
                                  Rating_State__c = 'M',
                                  RecordTypeId = QueryBase.getRecordtypeId( 'Account', 'X51') );
        Account a2 = new Account( Name = 'Test Account',
                                  Rating_State__c = 'D' );
        Account a3 = new Account( Name = 'Test Account',
                                  Rating_State__c = 'V' );
        List<Account> lA = new List<Account>();
        lA.add( a1 );
        lA.add( a2 );
        lA.add( a3 );
        insert lA;
        
        return lA;
    }
    
    private static void createTestOpportunities( List<Account> accounts ) {
        Opportunity o1 = new Opportunity(   AccountId = accounts[0].Id,
                                            RecordTypeId = QueryBase.getRecordtypeId( 'Opportunity', 'X51' ),
                                            Name = 'Test Opp 1',
                                            CloseDate = date.newInstance(2017, 1, 1),
                                            Effective_Date__c = date.newInstance(2017, 2, 1),
                                            Contract_End_Date__c = date.newInstance(2017, 12, 31),
                                            StageName = 'Proposal',
                                            System__c = 'Facets',
                                            Risk_Non_Risk__c = 'Non-Risk',
                                            GeneralProducer__c = 'Direct' );
        Opportunity o2 = new Opportunity(   AccountId = accounts[1].Id,
                                            RecordTypeId = QueryBase.getRecordtypeId( 'Opportunity', 'X51' ),
                                            Name = 'Test Opp 1',
                                            CloseDate = date.newInstance(2017, 1, 1),
                                            Effective_Date__c = date.newInstance(2017, 2, 1),
                                            Contract_End_Date__c = date.newInstance(2017, 12, 31),
                                            StageName = 'Proposal',
                                            System__c = 'Facets',
                                            Risk_Non_Risk__c = 'Non-Risk',
                                            GeneralProducer__c = 'Direct' );
        Opportunity o3 = new Opportunity(   AccountId = accounts[2].Id,
                                            RecordTypeId = QueryBase.getRecordtypeId( 'Opportunity', 'X51' ),
                                            Name = 'Test Opp 1',
                                            CloseDate = date.newInstance(2017, 1, 1),
                                            Effective_Date__c = date.newInstance(2017, 2, 1),
                                            Contract_End_Date__c = date.newInstance(2017, 12, 31),
                                            StageName = 'Proposal',
                                            System__c = 'Facets',
                                            Risk_Non_Risk__c = 'Non-Risk',
                                            GeneralProducer__c = 'Direct' );
        List<Opportunity> lO = new List<Opportunity>();
        lO.add( o1 );
        lO.add( o2 );
        lO.add( o3 );
        insert lO;
    }
    
    private static void createTestEnrollments( List<Account> accounts ) {
        
        // Get an Opp
        Opportunity o1 = [SELECT Id, Name, AccountId
                         FROM Opportunity
                         WHERE Account.Rating_State__c = 'M'
                         LIMIT 1];
        Opportunity o2 = [SELECT Id, Name, AccountId
                         FROM Opportunity
                         WHERE Account.Rating_State__c = 'V'
                         LIMIT 1];
        Opportunity o3 = [SELECT Id, Name, AccountId
                         FROM Opportunity
                         WHERE Account.Rating_State__c = 'D'
                         LIMIT 1];
        
        // MD
        List<Enrollment__c> lE = new List<Enrollment__c>();
        Enrollment__c E1 = new Enrollment__c();
        E1.RecordTypeId = QueryBase.getRecordtypeId( 'Enrollment__c', 'X2_50');
        E1.Opportunity__c = o1.Id;
        E1.Processed_Type__c = 'M';
        E1.Rpt_Dt__c = '201712';
        E1.Contracts__c = 100;
        E1.Groups__c = 5;
        E1.Status__c = 'Active';
        E1.On_Cycle__c = true;
        E1.New_Business_Indicator__c = 'N';
        E1.Renewal_Anniversary_Date__c = Date.newInstance( 2017, 12, 01 );
        E1.On_Cycle__c = true;
        E1.Reporting_Checkbox__c = true;
        lE.add( E1 );
        Enrollment__c E1a = E1.clone();
        E1a.Contracts__c += 1;
        E1a.Groups__c += 1;
        lE.add( E1a );
        Enrollment__c E2 = E1.clone();
        E2.On_Cycle__c = false;
        E2.New_Business_Indicator__c = 'Y';
        lE.add( E2 );
        Enrollment__c E2a = E2.clone();
        E2a.Contracts__c += 1;
        E2a.Groups__c += 1;
        lE.add( E2a );
        Enrollment__c E3 = E1.clone();
        E3.Status__c = 'Termed';
        E3.Termination_Date__c = Date.newInstance(2018, 01, 01);
        E3.Renewal_Anniversary_Date__c = Date.newInstance( 2017, 12, 01 );
        E3.Reporting_Checkbox__c = true;
        lE.add( E3 );
        Enrollment__c E3a = E3.clone();
        E3a.Contracts__c += 1;
        E3a.Groups__c += 1;
        lE.add( E3a );
        Enrollment__c E3a51a = E3.clone();
        E3a51a.RecordTypeId = QueryBase.getRecordtypeId( 'Enrollment__c', 'X51' );
        lE.add( E3a51a );
        Enrollment__c E3a51b = E3a51a.clone();
        E3a51b.Contracts__c += 1;
        E3a51b.Groups__c += 1;
        lE.add( E3a51b );
        Enrollment__c E3a51c = E3a51b.clone();
        E3a51c.Contracts__c += 1;
        E3a51c.Groups__c += 1;
        E3a51c.New_Business_Indicator__c = 'Y';
        lE.add( E3a51c );
        Enrollment__c E3a51d = E3a51c.clone();
        E3a51d.Contracts__c += 1;
        E3a51d.Groups__c += 1;
        lE.add( E3a51d );
        
        // VA
        Enrollment__c E4 = E1.clone();
        E4.RecordTypeId = QueryBase.getRecordtypeId( 'Enrollment__c', 'X2_50');
        E4.Opportunity__c = o2.Id;
        E4.Processed_Type__c = 'M';
        E4.Rpt_Dt__c = '201712';
        E4.Contracts__c = 100;
        E4.Groups__c = 5;
        E4.Status__c = 'Active';
        E4.On_Cycle__c = true;
        E4.New_Business_Indicator__c = 'N';
        E4.Renewal_Anniversary_Date__c = Date.newInstance( 2017, 12, 01 );
        E4.On_Cycle__c = true;
        E4.Reporting_Checkbox__c = true;
        lE.add( E4 );
        Enrollment__c E4a = E4.clone();
        E4a.Contracts__c += 1;
        E4a.Groups__c += 1;
        lE.add( E4a );
        Enrollment__c E5 = E4.clone();
        E5.On_Cycle__c = false;
        E5.New_Business_Indicator__c = 'Y';
        lE.add( E5 );
        Enrollment__c E5a = E5.clone();
        E5a.Contracts__c += 1;
        E5a.Groups__c += 1;
        lE.add( E5a );
        Enrollment__c E6 = E4.clone();
        E6.Status__c = 'Termed';
        E6.Termination_Date__c = Date.newInstance(2018, 01, 01);
        E6.Renewal_Anniversary_Date__c = Date.newInstance( 2017, 12, 01 );
        E6.Reporting_Checkbox__c = true;
        lE.add( E6 );
        Enrollment__c E6a = E6.clone();
        E6a.Contracts__c += 1;
        E6a.Groups__c += 1;
        lE.add( E6a );
        Enrollment__c E6a51a = E6.clone();
        E6a51a.RecordTypeId = QueryBase.getRecordtypeId( 'Enrollment__c', 'X51' );
        lE.add( E6a51a );
        Enrollment__c E6a51b = E6a51a.clone();
        E6a51b.Contracts__c += 1;
        E6a51b.Groups__c += 1;
        lE.add( E6a51b );
        Enrollment__c E6a51c = E6a51b.clone();
        E6a51c.Contracts__c += 1;
        E6a51c.Groups__c += 1;
        E6a51c.New_Business_Indicator__c = 'Y';
        lE.add( E6a51c );
        Enrollment__c E6a51d = E6a51c.clone();
        E6a51d.Contracts__c += 1;
        E6a51d.Groups__c += 1;
        lE.add( E6a51d );
        
        // DC
        Enrollment__c E7 = E1.clone();
        E7.RecordTypeId = QueryBase.getRecordtypeId( 'Enrollment__c', 'X2_50');
        E7.Opportunity__c = o3.Id;
        E7.Processed_Type__c = 'M';
        E7.Rpt_Dt__c = '201712';
        E7.Contracts__c = 100;
        E7.Groups__c = 5;
        E7.Status__c = 'Active';
        E7.On_Cycle__c = true;
        E7.New_Business_Indicator__c = 'N';
        E7.Renewal_Anniversary_Date__c = Date.newInstance( 2017, 12, 01 );
        E7.On_Cycle__c = true;
        E7.Reporting_Checkbox__c = true;
        lE.add( E7 );
        Enrollment__c E7a = E7.clone();
        E7a.Contracts__c += 1;
        E7a.Groups__c += 1;
        lE.add( E7a );
        Enrollment__c E8 = E7.clone();
        E8.On_Cycle__c = false;
        E8.New_Business_Indicator__c = 'Y';
        lE.add( E8 );
        Enrollment__c E8a = E8.clone();
        E8a.Contracts__c += 1;
        E8a.Groups__c += 1;
        lE.add( E8a );
        Enrollment__c E9 = E7.clone();
        E9.Status__c = 'Termed';
        E9.Termination_Date__c = Date.newInstance(2018, 01, 01);
        E9.Renewal_Anniversary_Date__c = Date.newInstance( 2017, 12, 01 );
        E9.Reporting_Checkbox__c = true;
        lE.add( E9 );
        Enrollment__c E9a = E9.clone();
        E9a.Contracts__c += 1;
        E9a.Groups__c += 1;
        lE.add( E9a );
        Enrollment__c E9a51a = E9.clone();
        E9a51a.RecordTypeId = QueryBase.getRecordtypeId( 'Enrollment__c', 'X51' );
        lE.add( E9a51a );
        Enrollment__c E9a51b = E9a51a.clone();
        E9a51b.Contracts__c += 1;
        E9a51b.Groups__c += 1;
        lE.add( E9a51b );
        Enrollment__c E9a51c = E9a51b.clone();
        E9a51c.Contracts__c += 1;
        E9a51c.Groups__c += 1;
        E9a51c.New_Business_Indicator__c = 'Y';
        lE.add( E9a51c );
        Enrollment__c E9a51d = E9a51c.clone();
        E9a51d.Contracts__c += 1;
        E9a51d.Groups__c += 1;
        lE.add( E9a51d );

        insert lE;
         
    }
    
     private static void createTestCustomSettings() {
        DynamicCodeDataStore__c cs = new DynamicCodeDataStore__c();
        // AO change begin
        //cs.name = 'sfdcTeamEmail';
        cs.name = 'EmailSupportTeams';
        cs.Email__c = 'sfdcTeam@carefirst.com';
        cs.text_255__c = 'sfdcTeam@carefirst.com';
        //AO change End
        insert cs;
     }
    
}