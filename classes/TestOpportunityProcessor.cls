/*------------------------------------------------------------------------------------
 *                      ----===[ HISTORY ]===---
 * Date        Developer        Description
 *------------------------------------------------------------------------------------
 * 12/06/2012 Varun Nagarajan   Modified code where Business__c has been replaced with 
 *                              Business_Type__c matching today's world requirements. 
 *
 * 06/06/2014 Tom Barrett (TPB) added Opp.Won_Lost_Reason__c = 'Acquisition'; 
 *                              to accomodate the Opportunity VR024 change and the
 *                              Incumbent_Successor__c field for VR064   
 *
 * 07/23/2015 Ashish Ojha       Added survey contact and Program to Test 
 * 10/20/2017 Vivek Sharma(VS) |T01| Added testMethod for Opportynity Clone with Products
 *************************************************************************************
 */
 
/**
 *  @Author: Acumen Solutions
 *  @Purpose: Test Class for OpportunityProcessorManager Class, OpportunityProcessor Trigger
 **/
 
@isTest
private class TestOpportunityProcessor {

    static testMethod void testOpportunityOwnerChange() {
        
        Profile profile = [select id from profile where name='System Administrator'];
        //List<user> userList = new list<user>();
        User oldUser = new User(alias = 'aliasU', email='alias@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = profile.Id, 
            timezonesidkey='Europe/London', username='aliastest@test.com',Lead_Rep__c =true
            );
        insert oldUser;
        
        User user1 = new User(alias = 'aliasU', email='alias@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = profile.Id, 
            timezonesidkey='Europe/London', username='testalias@test.com',Lead_Rep__c =true
            );
        insert user1;
        
        /*User oldUser = [ select u.name, u.id from User u
                         where IsActive =true and u.Profile.UserLicense.Name = 'Salesforce'  limit 1];*/
        Account testAcc = new Account();
        testAcc.Name = 'Test Account';
        testAcc.OwnerId  = oldUser.Id; 
        
        insert testAcc ;
           
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = testAcc.Id ;
        testOpp.OwnerId = oldUser.Id;
        testOpp.StageName ='Proposal';
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate;
        //testOpp.Business__c = 'National Renewal Sales';
        testOpp.Business_Type__c = 'Renewal';
        testOpp.GeneralProducer__c = 'Direct';
//TPB - 12/19/2013                  
        testOpp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = testOpp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp.Contract_End_Date__c = contractEndDate;       
        
        insert testOpp ;
        
        Opportunity opp = [ select name , id, StageName from Opportunity 
                            where name = 'Test Opportunity' and StageName ='Proposal' and AccountId =: testAcc.Id limit 1 ];
                           
        User newOwner = [ select name, id from User where id !=: oldUser.Id  and IsActive =true  and Lead_Rep__c =true  limit 1];
        opp.OwnerId = newOwner.Id;
        OpportunityTriggerHandler.BeforeUpdateRecursive=false;//T02
        OpportunityTriggerHandler.isFirstTime=true;//T02
        update opp;
            
        Account updateAcc = [select id, name , OwnerId from Account where id=: testAcc.Id];
        System.assertEquals(updateAcc.OwnerId , opp.OwnerId);
            
        Opportunity opp1 = [select name , id, StageName , Lead_Rep_Name_User__c , Effective_Date__c,CloseDate ,Account.Name, AccountId from Opportunity 
                            where name = 'Test Opportunity' and StageName ='Proposal' and AccountId =: testAcc.Id limit 1 ];
                                    
        System.assertEquals(opp1.Lead_Rep_Name_User__c , opp.OwnerId);     
    }
    
    static testMethod void testOpportunityCloneOnStageChange() {
        Account testAcc1 = new Account();
        testAcc1.Name = 'Test Account1';
        insert testAcc1 ;
        
        Account testAcc2 = new Account();
        testAcc2.Name = 'Test Account2';
        insert testAcc2 ;
        
        Contact testContact = new  Contact();
        testContact.AccountId = testAcc2.id;
        testContact.FirstName = 'Test';
        testContact.LastName = 'Test'; 
        testContact.Phone = '555-555-5555';
        testContact.Email = 'OppProcess@test.com';
        insert testContact;
        
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(2012, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);
        
        testOpp.Name = 'Test Opportunity1';
        testOpp.AccountId = testAcc1.Id;         
        testOpp.StageName ='Proposal';       
        testOpp.CloseDate = closedDate;
        testOpp.Description =' This is the description';
        testOpp.Effective_Date__c = effectiveDate;
        testOpp.GeneralProducer__c = 'Direct';
        testOpp.System__c = 'NASCO';
        testOpp.NASCO_Acct_ID__c='12345';
//TPB - 12/19/2013        
        Date contractEndDate = effectiveDate+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp.Contract_End_Date__c = contractEndDate;
        testOpp.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014
        
        if(testOpp.System__c != null)        
        insert testOpp ;
        
        //PricebookEntry proceBookEntry = [ Select p.Name,  p.Id , p.IsActive From PricebookEntry p  where p.IsActive = true limit 1];
        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware');
                insert prod;
            Id pricebookId = Test.getStandardPricebookId();
            PricebookEntry proceBookEntry = new PricebookEntry(
                                            Pricebook2Id = pricebookId, Product2Id = prod.Id,
                                            UnitPrice = 10000, IsActive = true);
            insert proceBookEntry;

        
        OpportunityLineItem testOppProduct = new OpportunityLineItem();
        testOppProduct.OpportunityId = testOpp.id;
        testOppProduct.PricebookEntryId = proceBookEntry.Id;
        testOppProduct.Product_Sold__c = true;
        testOppProduct.Quantity = 10.00 ;
        testOppProduct.TotalPrice = 100.00;
        Test.startTest();
        insert testOppProduct;
        //Test.stopTest();
        
        Partner testPartner = new Partner();
        testPartner.AccountToId = testAcc2.id;
        testPartner.OpportunityId= testOpp.Id;
        testPartner.IsPrimary=true;
        
        insert testPartner;
        
        //Ashish Ojha Code Changes
        Survey_Contacts__c testSurvey = new Survey_Contacts__c();
        testSurvey.Opportunity__c = testOpp.id;
        testSurvey.Surveys__c = 'test';
        insert testSurvey;
        
        Programs__c pg = new Programs__c();
        pg.Opportunity_Name__c = testOpp.id;
        insert pg;
        
        //End Code Changes
        
        OpportunityContactRole testConRole = new OpportunityContactRole();
        testConRole.OpportunityId = testOpp.id;
        testConRole.ContactId = testContact.id;
        
        insert testConRole;
        testOpp.Incumbent_Successor__c = 'CareFirst'; //06/06/2014 TPB
        
        testOpp.StageName = 'Sold';
        OpportunityTriggerHandler.isFirstTime=true;//T02
        update testOpp; 
        
        Test.stopTest();
        Opportunity clonedOpp = [ select id, name , Effective_Date__c,StageName  , description
                                from Opportunity where AccountId =: testAcc1.Id and id <>: testOpp.id limit 1];
        System.assertEquals(clonedOpp.StageName , 'Proposal');
        System.assertEquals(clonedOpp.description , null);
        System.assertEquals(clonedOpp.name, 'Test Account1 03/13'); 
    }
    
        //T01 - VS helper method for test data creation
        //@testSetup
    public static Opportunity createOppty(Boolean withProducts){
        User oldUser = [ select u.name, u.id from User u
                         where IsActive =true and u.Profile.UserLicense.Name = 'Salesforce'  limit 1];
        Account testAcc = new Account();
        testAcc.Name = 'Test Account';
        testAcc.OwnerId  = oldUser.Id; 
        
        insert testAcc ;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = testAcc.Id ;
        testOpp.OwnerId = oldUser.Id;
        testOpp.StageName ='Dead';
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate;
        testOpp.Business_Type__c = 'Renewal';
        testOpp.GeneralProducer__c = 'Direct';
        testOpp.Won_Lost_Reason__c = 'PRICE (RATE/DISCOUNTS)';
        testOpp.Incumbent_Successor__c = 'ACO';
        testOpp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = testOpp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp.Contract_End_Date__c = contractEndDate;       
        insert testOpp ;
        if(withProducts){
            Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware');
                insert prod;
            Id pricebookId = Test.getStandardPricebookId();
            PricebookEntry priceBookEntry1 = new PricebookEntry(
                                            Pricebook2Id = pricebookId, Product2Id = prod.Id,
                                            UnitPrice = 10000, IsActive = true);
            insert priceBookEntry1;

            //PricebookEntry priceBookEntry1 = [ Select Name, Id , IsActive From PricebookEntry where IsActive = true limit 1];
            OpportunityLineItem testOppProduct = new OpportunityLineItem();
            testOppProduct.OpportunityId = testOpp.id;
            testOppProduct.PricebookEntryId = priceBookEntry1.Id;
            testOppProduct.Product_Sold__c = false;
            testOppProduct.Quantity = 10.00 ;
            testOppProduct.TotalPrice = 100.00;            
            insert testOppProduct;
        }
        return testOpp;
    }
    
    //T01 - VS helper method for test data creation
    static List<OpportunityContactRole> createOpptyConRole(Opportunity testOpp){
        List<OpportunityContactRole> opptyConRole = new List<OpportunityContactRole>();
        Contact testContact = new  Contact();
        testContact.AccountId = testOpp.Accountid;
        testContact.FirstName = 'Test';
        testContact.LastName = 'Test'; 
        testContact.Phone = '555-555-5555';
        testContact.Email = 'OppProcess@test.com';
        insert testContact;    
        OpportunityContactRole testConRole = new OpportunityContactRole();
        testConRole.OpportunityId = testOpp.id;
        testConRole.ContactId = testContact.id;            
        insert testConRole;
        opptyConRole.add(testConRole);
        return opptyConRole;
    }
    
    //T01 - VS test method for Opportunity Clone with Products
    static testMethod void createOpptyWithProduct_test(){
        Opportunity testOppty = createOppty(true);
        OpportunityProcessorManager OPM1 = new OpportunityProcessorManager();
        Test.startTest();
        OPM1.cloneOpportunityWithProduct(testOppty);
        Test.StopTest();
        Opportunity clonedOppty = [select id,stageName from Opportunity where stageName!=:'Dead' LIMIT 1];
        system.assertNotEquals('Dead',clonedOppty.stageName,'Clone failed');
    }
    
    //T01 - VS test method for Opportunity Clone without Products
    static testMethod void createOpptyWithOutProduct_test(){
        Opportunity testOppty = createOppty(false);
        OpportunityProcessorManager OPM1 = new OpportunityProcessorManager();
        Test.startTest();
        OPM1.cloneOpportunityWithoutProduct(testOppty);
        Test.stopTest();
        Opportunity clonedOppty = [select id,stageName from Opportunity where stageName!=:'Dead' LIMIT 1];
        system.assertNotEquals('Dead',clonedOppty.stageName,'Clone failed');
    }
    //T01 - VS test method for cloneOpportunityContactRole for coverage
    static testMethod void cloneOpportunityContactRole_Test(){
        Opportunity testOppty = createOppty(true);        
        OpportunityProcessorManager OPM1 = new OpportunityProcessorManager();
        List<OpportunityContactRole> oppConRoleList = createOpptyConRole(testOppty);
        test.startTest();
        OPM1.cloneOpportunityContactRole(testOppty,oppConRoleList);
        test.stopTest();
    }
    //T01 - VS test method for cloneOpportunityPartner for coverage
    static testMethod void cloneOpportunityPartner_test(){
        Opportunity testOppty = createOppty(false);
        List<OpportunityPartner> opptyPartnerList = new List<OpportunityPartner>();
        OpportunityPartner opptyPartner = new OpportunityPartner();
        opptyPartnerList.add(opptyPartner);
        OpportunityProcessorManager OPM1 = new OpportunityProcessorManager();
        Test.StartTest();        
        OPM1.cloneOpportunityPartner(testOppty,opptyPartnerList);
        Test.StopTest();        
    }
    //T01 - VS test method for coverage
    static testMethod void createOpptyWithProductAndContactRole_test(){
        Opportunity testOppty = createOppty(true);        
        Opportunity_Contact_Role__c opptyConRole = new Opportunity_Contact_Role__c(Role__c='Broker',Primary__c=true,
                                                    Effective_Date__c=date.newinstance(2017, 3, 1),
                                                    End_Date__c =date.newinstance(2017, 3, 3),Opportunity__c=testOppty.id );
        insert opptyConRole;
        FSP_GP__c oppFSP = new FSP_GP__c(Opportunity__c=testOppty.id,Effective_Date__c=date.newinstance(2017, 3, 1),
                                                    End_Date__c=date.newinstance(2017, 3, 1));
        insert oppFSP;
        OpportunityProcessorManager OPM1 = new OpportunityProcessorManager();
        test.startTest();
        OPM1.cloneOpportunityWithProduct(testOppty);
        Test.stopTest();
        Opportunity clonedOppty = [select id,stageName from Opportunity where stageName!=:'Dead' LIMIT 1];
        system.assertNotEquals('Dead',clonedOppty.stageName,'Clone failed');
    }

}