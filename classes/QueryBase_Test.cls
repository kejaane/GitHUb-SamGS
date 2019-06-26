@isTest
private class QueryBase_Test {
    static testMethod void getAllOpportunityContactRoleByOpportunityId_Test() {
        Test.startTest();
        //Create account
          User oldUser = [ select u.name, u.id from User u
                         where IsActive =true and u.Profile.UserLicense.Name = 'Salesforce'  limit 1];
        Account testAcc = new Account();
        testAcc.Name = 'Community_User_Account';
        testAcc.OwnerId  = oldUser.Id; 
        
        insert testAcc ;
          
          //Then create a primary contact

        Contact c = new Contact();
        c.FirstName = 'Paul';
        c.LastName = 'Test';
        c.AccountId = testacc.id;
        c.MailingStreet = '298 S. Ringo Street';
        c.MailingCity = 'Little Rock';
        c.MailingState = 'AR';
        c.MailingPostalCode = '72201';
        c.phone='1234567890';
        c.email='test@test.com';
        insert c;

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
        
         //Now update the OCR for the primary contact
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = c.Id;
        ocr.OpportunityId = testOpp.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        
        insert ocr;
        System.debug('created opportunity contact role for primary');
            
        
        
        
        Test.stopTest();
       list<OpportunityContactRole> lstocr = QueryBase.getAllOpportunityContactRoleByOpportunityId(testOpp.id);        
        System.assert(lstocr.size() == 1);
    }
    
    static testMethod void getAllOpportunityPartner_Test(){
    
    //Create account
          User oldUser = [ select u.name, u.id from User u
                         where IsActive =true and u.Profile.UserLicense.Name = 'Salesforce'  limit 1];
        Account testAcc = new Account();
        testAcc.Name = 'Community_User_Account';
        testAcc.OwnerId  = oldUser.Id; 
        
        insert testAcc ;
        
        Account testAcc1 = new Account();
        testAcc1.Name = 'Test Account2';
        testAcc1.OwnerId  = oldUser.Id; 
        
        insert testAcc1 ;
        
          Account testAcc2 = new Account();
        testAcc2.Name = 'Test Account3';
        testAcc2.OwnerId  = oldUser.Id; 
        
        insert testAcc2 ;          
          //Then create a primary contact

        Contact c = new Contact();
        c.FirstName = 'Paul';
        c.LastName = 'Test';
        c.AccountId = testacc.id;
        c.MailingStreet = '298 S. Ringo Street';
        c.MailingCity = 'Little Rock';
        c.MailingState = 'AR';
        c.phone='1234567890';
        c.email='test@test.com';
        c.MailingPostalCode = '72201';
        
        insert c;

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
        
        //Opportunity partner
        Partner partner = new Partner();
        partner.AccountToId = testAcc1.Id;
        partner.OpportunityId = testOpp.id;
        partner.IsPrimary = true;
        partner.Role = 'PARTNER_DEVELOPMENT_ROLE';
        insert partner;
         List<OpportunityPartner> oppPart = QueryBase.getAllOpportunityPartner(testopp.id,testAcc2.id);
         system.Assert(oppPart.size()==0);
    }
    
    static testMethod void insertOpportunityRecords_Test(){
     User oldUser = [ select u.name, u.id from User u
                         where IsActive =true and u.Profile.UserLicense.Name = 'Salesforce'  limit 1];
        Account testAcc = new Account();
        testAcc.Name = 'Community_User_Account';
        testAcc.OwnerId  = oldUser.Id; 
        
        insert testAcc ;
        Contact c = new Contact();
        c.FirstName = 'Paul';
        c.LastName = 'Test';
        c.AccountId = testacc.id;
        c.MailingStreet = '298 S. Ringo Street';
        c.MailingCity = 'Little Rock';
        c.MailingState = 'AR';
        c.phone='1234567890';
        c.email='test@test.com';
        c.MailingPostalCode = '72201';
        
        insert c;

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
        
        list<opportunity> oppLst = new list<opportunity>();
        opplst.add(testopp);
        list<opportunity> lstopp = QueryBase.insertOpportunityRecords(opplst);
        system.assert(lstOpp.size()==1);
        
        //Now update the OCR for the primary contact
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = c.Id;
        ocr.OpportunityId = lstOpp[0].Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        list<OpportunityContactRole > ocrLst = new list<OpportunityContactRole >();
        ocrlst.add(ocr);
        list<OpportunityContactRole > lstocr = QueryBase.insertOpportunityContactRoleRecords(ocrlst);
        system.assert(lstocr.size()==1);
        
        //Opportunity partner
        Partner partner = new Partner();
        partner.AccountToId = testAcc.Id;
        partner.OpportunityId = lstOpp[0].id;
        partner.IsPrimary = true;
        partner.Role = 'PARTNER_DEVELOPMENT_ROLE';
        
        list<Partner> lstpar = new list<Partner >();
        lstpar.add(partner);
        list<Partner > parlst = QueryBase.insertOpportunityPartnerRecords(lstpar);
        system.Assert(parlst.size()==1);
        
        Partner__c part = new Partner__c();
        //part.AccountToId = testAcc.Id;
        part.Opportunity__c = lstOpp[0].id;
        part.Primary__c= true;
        part.Role__C = 'Consultant';
        list<Partner__c> lstpart = new list<Partner__c >();
        lstpart.add(part);
        list<Partner__c > partlst = QueryBase.insertCustomOpportunityPartnerRecords(lstpart);
        system.Assert(partlst.size()==1);
        
        FSP_GP__c fsp= new FSP_GP__c();
        //part.AccountToId = testAcc.Id;
        fsp.Opportunity__c = lstOpp[0].id;
        fsp.Primary__c= true;
        fsp.Partner__c = 'BenefitMall';
        list<FSP_GP__c > lstfsp = new list<FSP_GP__c >();
        lstfsp.add(fsp);
        list<FSP_GP__c > fsplst = QueryBase.insertFSPGPRecords(lstfsp);
        system.Assert(fsplst.size()==1);
        boolean admin = QueryBase.isAdmin();
    }
}