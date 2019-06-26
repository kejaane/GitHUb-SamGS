/**
 *  @Author: Acumen Solutions
 *  @Purpose: Test Class for OpportunityProcessorManager Class , OpportunityDeepCloneController  Class
 **/
@isTest
private class TestOpportunityDeepCloneController {
    static testMethod void testOpportunityDeepCloneController_test1() {    
    
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
        testContact.Email = 'OppDeepClone@test.com';
        insert testContact;        
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(2012, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);
        
        testOpp.Name = 'Test Opportunity1';
        testOpp.AccountId = testAcc1.Id ;
        testOpp.StageName ='Proposal';
        testOpp.CloseDate = closedDate;
        testOpp.GeneralProducer__c = 'Direct';
        testOpp.Effective_Date__c = effectiveDate;
        testOpp.GeneralProducer__c = 'Direct';
//TPB - 12/19/2013       
            testOpp.Effective_Date__c = effectiveDate;
            Date contractEndDate = EffectiveDate+366;
            contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
            contractEndDate = contractEndDate.addDays(-1);
            testOpp.Contract_End_Date__c = contractEndDate;   
                
        insert testOpp ;
        
        PricebookEntry proceBookEntry = [ Select p.Name,  p.Id , p.IsActive From PricebookEntry p  where p.IsActive = true limit 1];
        
        OpportunityLineItem testOppProduct = new OpportunityLineItem();
        testOppProduct.OpportunityId = testOpp.id;
        testOppProduct.PricebookEntryId = proceBookEntry.Id;
        testOppProduct.Product_Sold__c = false;
        testOppProduct.Quantity = 10.00 ;
        testOppProduct.TotalPrice = 100.00;
        insert testOppProduct;
        
        Partner testPartner = new Partner();
        testPartner.AccountToId = testAcc2.id;
        testPartner.OpportunityId= testOpp.Id;
        testPartner.IsPrimary=true;        
        insert testPartner;
        
        OpportunityContactRole testConRole = new OpportunityContactRole();
        testConRole.OpportunityId = testOpp.id;
        testConRole.ContactId = testContact.id;        
        insert testConRole;
        
        //Ashish Ojha Code Changes
        Survey_Contacts__c testSurvey = new Survey_Contacts__c();
        testSurvey.Opportunity__c = testOpp.id;
        testSurvey.Surveys__c = 'test';
        insert testSurvey;
        
        Programs__c pg = new Programs__c();
        pg.Opportunity_Name__c = testOpp.id;
        insert pg;
        
        //End Code Changes
        test.starttest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
        OpportunityDeepCloneController  odcc = new OpportunityDeepCloneController(sc);
        
        
        Pagereference pageRef1 = Page.CloneOpportunityWithProduct ;
        pageRef1.getParameters().put('id', String.valueOf(testOpp.Id));       
        pageRef1 = odcc.cloneWithProduct();
        
        //System.assert(odcc.cloneWithProduct() != null);
        //System.assert([select Id from Opportunity where Id=:odcc.newOpportunityId ].size() == 1);
        
        PageReference pageRef2 = Page.CloneOpportunityWithoutProduct ;
        pageRef2.getParameters().put('id', String.valueOf(testOpp.Id));
        pageRef2 = odcc.cloneWithoutProduct();
        
        test.stoptest();
          
        //System.assert(odcc.cloneWithoutProduct() != null);
        //System.assert([select Id from Opportunity where Id=:odcc.newOpportunityId ].size() == 1);        
    }    
}