@isTest
// 6/27/2014 : Changed profile name to Profile Record id

private class CFCT_OwnerLeadRepNoMatch_Controller_Test {
    static testMethod void CFCT_OwnerLeadRepNoMatch_Controller_Test1() {
        //logged in as admin 
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User(alias = 'admuser', email='adminuser@testorgxyz.com',
        emailencodingkey='UTF-8', lastname='adminUserTesting', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='adminuser@testorgxyz.com');
        System.runAs(u) {  
            /* create account */
            Account testAcc1 = new Account();
            testAcc1.Name = 'Test Account1';
            insert testAcc1 ;
            /* create opportunity */
            Opportunity testOpp = new Opportunity();
            Date closedDate = date.newinstance(2050, 1, 1);
            Date effectiveDate = date.newinstance(2050, 12, 1);        
            testOpp.Name = 'Test Opportunity1';
            testOpp.AccountId = testAcc1.Id ;
            testOpp.StageName ='Proposal';
            testOpp.CloseDate = closedDate;
            testOpp.Effective_Date__c = effectiveDate;    
            testOpp.GeneralProducer__c = 'Direct';  
//TPB - 12/19/2013        
            //effectiveDate = Date.today()+30;        
            testOpp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
            Date contractEndDate = testOpp.Effective_Date__c+365;
            contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
            contractEndDate = contractEndDate.addDays(-1);
            testOpp.Contract_End_Date__c = contractEndDate;         
                             
            insert testOpp ; 
            
            Test.StartTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);            
            CFCT_OwnerLeadRepNoMatch_Controller  pageCon = new CFCT_OwnerLeadRepNoMatch_Controller();            
            Pagereference pageRef1 = Page.CFCT_OwnerLeadRepNoMatch;
            List<Opportunity> ol = pageCon.getOpps();             
            integer i = pageCon.getPageNumber();
            i = pageCon.getTotalPages();
            i = pageCon.getRecCount();
            boolean a = pageCon.getSysAdmin();
            pageRef1 = pageCon.emailUsers();
            System.assert(i >= 1, true);
            Test.StopTest();
        }
    }
    
    static testMethod void CFCT_OwnerLeadRepNoMatch_Controller_Test2() {
        //logged in as standard user
        // 6/27/2014 : Changed profile name to Profile Record id
        Profile p = [select id from profile where Id = '00e60000000oSNM'];
        User u = new User(alias = 'stndr', email='standruser@testorgxyz.com',
        emailencodingkey='UTF-8', lastname='stndrUserTesting', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='stdruser@testorgxyz.com');
        System.runAs(u) {        
            /* create account */
            Account testAcc1 = new Account();
            testAcc1.Name = 'Test Account2';
            insert testAcc1 ;
            /* create opportunity */
            Opportunity testOpp = new Opportunity();
            Date closedDate = date.newinstance(2050, 1, 1);
            Date effectiveDate = date.newinstance(2050, 12, 1);        
            testOpp.Name = 'Test Opportunity2';
            testOpp.AccountId = testAcc1.Id ;
            testOpp.StageName ='Proposal';
            testOpp.CloseDate = closedDate;
            testOpp.Effective_Date__c = effectiveDate;
            testOpp.GeneralProducer__c = 'Direct';
//TPB - 12/19/2013        
            //effectiveDate = Date.today()+30;        
            testOpp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
            Date contractEndDate = testOpp.Effective_Date__c+365;
            contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
            contractEndDate = contractEndDate.addDays(-1);
            testOpp.Contract_End_Date__c = contractEndDate;        
                        
            insert testOpp ;   
            
            Test.StartTest();         
            ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);            
            CFCT_OwnerLeadRepNoMatch_Controller  pageCon = new CFCT_OwnerLeadRepNoMatch_Controller();            
            Pagereference pageRef1 = Page.CFCT_OwnerLeadRepNoMatch;
            List<Opportunity> ol = pageCon.getOpps();   
            integer i = pageCon.getPageNumber();
            i = pageCon.getTotalPages();
            i = pageCon.getRecCount();
            boolean a = pageCon.getSysAdmin();
            pageRef1 = pageCon.emailUsers();
            pageCon.getIsClassic();
            System.assert(i >= 1, true);  
            Test.StopTest();    
        }
    }        
}