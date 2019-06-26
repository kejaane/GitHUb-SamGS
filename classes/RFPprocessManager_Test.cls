@isTEST
private class RFPprocessManager_Test {
    static testMethod void test_RFP1(){
        /* create account */
        Account testAcc = new Account( Name = 'Test Account' + System.Today() );
        insert testAcc;
        
        Date closeDate = date.newinstance(2014, 4, 15);  
        Date effectiveDate = date.newinstance(2014, 5, 1);  
        Date contractEndDate = date.newinstance(2014, 12, 31);  
        
        /* create opportunity */
        Opportunity oppTest = new Opportunity( Name = 'Test Opp' + System.Today(), Effective_Date__c = effectiveDate, Contract_End_Date__c = contractEndDate, AccountId = testAcc.Id, 
                                               CloseDate = closeDate, StageName = 'Proposal', GeneralProducer__c = 'Direct',
                                               Business__c = 'National Renewal Sales' );                                               
        insert oppTest;
        
        /* create RFP */
        RFP__c rfpTest = new RFP__c( Name = 'RFP Test', Opportunity_Name__c = oppTest.id, Benefits_Services__c = 'Dental' );
        insert rfpTest;
        
        /* create PRF */
        PRF__c prfTest = new PRF__c( Name = 'PRF Test', RFP_Name__c = rfpTest.id );   
        insert prfTest;      
    
    }
       
}