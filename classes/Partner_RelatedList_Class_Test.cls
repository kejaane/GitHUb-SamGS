@isTest()
public class Partner_RelatedList_Class_Test{ 
    static Partner__c newPartner = new Partner__c();
    static Partner__c newPartner1 = new Partner__c();
    static Account acc = new Account();
    static Account acc2 = new Account();
    static List<Partner__c> insertPartners = new List<Partner__c>(); 
    
    static testMethod void testOpportunityInsert() { 
        
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2016, 3, 1);     //date.newinstance(2012, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        //testOpp.OwnerId = oldUser.Id;
        testOpp.StageName ='Proposal';//'Sold';//new change 9Nov16
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
        testOpp.Won_Lost_Reason__c =  'Acquisition'; 
        testOpp.Incumbent_Successor__c = 'Ameritas';
        testOpp.System__c = 'NASCO';
        testOpp.NASCO_Acct_ID__c='12345';  
        
        insert testOpp ;
        //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        testOpp.StageName = 'Sold';
        testOpp.Probability = Decimal.valueOf('100');
        testOpp.Won_Lost_Reason__c = 'Acquisition';
        testOpp.Incumbent_Successor__c = 'Aetna';
        Test.startTest();
        update testOpp;
        //end new change 9Nov16
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Proposal';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';
        
        insert testOpp1 ;
        
        newPartner.Partner__c = acc2.id;                
        newPartner.Opportunity__c = testOpp.Id;                
        newPartner.Primary__c = true;                
        newPartner.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newPartner.End_Date__c = contractEndDate ;//System.today(); 
        newPartner.Role__c = 'Broker';
        insertPartners.add(newPartner);
        
        Partner__c newPartner2 = new Partner__c();
        newPartner2.Partner__c = acc2.id;                
        newPartner2.Opportunity__c = testOpp.Id;                
        newPartner2.Primary__c = true;                
        newPartner2.Effective_Date__c = date.newinstance(2016, 4, 1); 
        newPartner2.End_Date__c = contractEndDate ; 
        newPartner2.Role__c = 'Broker';
        insertPartners.add(newPartner2);
        
 
        Partner__c part_sold_effdtnot1 = new Partner__c();
        part_sold_effdtnot1.Partner__c = acc2.id;                
        part_sold_effdtnot1.Opportunity__c = testOpp.Id;                
        part_sold_effdtnot1.Primary__c = true;                
        part_sold_effdtnot1.Effective_Date__c = date.newinstance(2016, 3, 8); 
        part_sold_effdtnot1.End_Date__c = System.today(); 
        part_sold_effdtnot1.Role__c = 'Broker';
        insertPartners.add(part_sold_effdtnot1);
        
        newPartner1.Partner__c = acc2.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newPartner1.End_Date__c = System.today(); 
        newPartner1.Role__c = 'Broker';              
        insertPartners.add(newPartner1);                
         
        
        for(Integer i=0;i<10;i++ ){
            Partner__c part = new Partner__c();
            part.Opportunity__c = testOpp.Id;                
            part.Primary__c = true;                
            part.Effective_Date__c = date.newinstance(2016, 3, 1); 
            part.End_Date__c = System.today();
            if(i>=2 && i<=4)
                part.Role__c = 'Broker';
            else if(i>=5 && i<=7)
                part.Role__c = 'Consultant';
            else if(i>=8 && i<=10)
                part.Role__c = 'None (Direct Sale)';                   
            insertPartners.add(part);
        }
        
        for(Integer i=0;i<10;i++ ){
            Partner__c part = new Partner__c();
            part.Opportunity__c = testOpp.Id;                
            part.Primary__c = true;
            insertPartners.add(part);
        }
        
        insert insertPartners;
         upsert insertPartners[6];
        //Test.StartTest();
         Test.StopTest();
        Partner_RelatedList_Class partnerRelatedList = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner)); 
        partnerRelatedList.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner2,1,''));
       
        
        partnerRelatedList.savePartner();
        partnerRelatedList.cancelPartner();
        
        
        Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
        partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
        partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
        
        partnerRelatedList1.savePartner();
        partnerRelatedList1.liRecordSave();
        partnerRelatedList1.returnToOpp();
        partnerRelatedList1.selectedCR = 1;
        partnerRelatedList1.cancelPartner();    
        
       
               
   }
    static testMethod void testOpportunityInsert0() { 
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2016, 3, 1);     //date.newinstance(2012, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';//'Sold';//new change 9Nov16
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate;
        testOpp.Business_Type__c = 'Renewal';
        testOpp.GeneralProducer__c = 'Direct';
        testOpp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = testOpp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp.Contract_End_Date__c = contractEndDate;  
        testOpp.Won_Lost_Reason__c =  'Acquisition'; 
        testOpp.Incumbent_Successor__c = 'Ameritas';
        testOpp.System__c = 'NASCO';
        testOpp.NASCO_Acct_ID__c='12345';  
        
        insert testOpp ;
        //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        testOpp.StageName = 'Sold';
        testOpp.Probability = Decimal.valueOf('100');
        testOpp.Won_Lost_Reason__c = 'Acquisition';
        testOpp.Incumbent_Successor__c = 'Aetna';
        Test.startTest();
        update testOpp;
        //end new change 9Nov16
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Proposal';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        //TPB - 12/19/2013                  
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';
        
        insert testOpp1 ;
        
        newPartner.Partner__c = acc2.id;                
        newPartner.Opportunity__c = testOpp.Id;                
        newPartner.Primary__c = true;                
        newPartner.Effective_Date__c = effectiveDate; 
        newPartner.End_Date__c = contractEndDate ;//System.today(); 
        newPartner.Role__c = 'Broker';
        insertPartners.add(newPartner);
        
        Partner__c newPartner2 = new Partner__c();
        newPartner2.Partner__c = acc2.id;                
        newPartner2.Opportunity__c = testOpp.Id;                
        newPartner2.Primary__c = true;                
        newPartner2.Effective_Date__c = effectiveDate; 
        newPartner2.End_Date__c = contractEndDate ; 
        newPartner2.Role__c = 'None (Direct Sale)';
        insertPartners.add(newPartner2);
        
        newPartner1.Partner__c = acc2.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newPartner1.End_Date__c = System.today(); 
        newPartner1.Role__c = 'Broker';              
        insertPartners.add(newPartner1);                
         
        
        for(Integer i=0;i<10;i++ ){
            Partner__c part = new Partner__c();
            part.Opportunity__c = testOpp.Id;                
            part.Primary__c = true;                
            part.Effective_Date__c = date.newinstance(2016, 3, 1); 
            part.End_Date__c = System.today();
            if(i>=2 && i<=4)
                part.Role__c = 'Broker';
            else if(i>=5 && i<=7)
                part.Role__c = 'Consultant';
            else if(i>=8 && i<=10)
                part.Role__c = 'None (Direct Sale)';                   
            insertPartners.add(part);
        }
        
        for(Integer i=0;i<10;i++ ){
            Partner__c part = new Partner__c();
            part.Opportunity__c = testOpp.Id;                
            part.Primary__c = true;
            insertPartners.add(part);
        }
        
        insert insertPartners;
           
        Test.StopTest();
        Partner_RelatedList_Class partnerRelatedList = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner)); 
        partnerRelatedList.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner2,1,''));
       
        
        partnerRelatedList.savePartner();
        partnerRelatedList.cancelPartner();
        
         system.runAs(u){
        Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
        partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
        partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
        
        partnerRelatedList1.enableDates();  
        partnerRelatedList1.savePartner();
        partnerRelatedList1.selectedCR = 1;
        partnerRelatedList1.cancelPartner();    
        }
       
               
   }
   static testMethod void testPartnerDelete() {
   // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';//'Sold';//new change 9Nov16
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate;
        testOpp.Business_Type__c = 'Renewal';
        testOpp.GeneralProducer__c = 'Direct';
        testOpp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = testOpp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp.Contract_End_Date__c = contractEndDate;  
        testOpp.Won_Lost_Reason__c =  'Acquisition'; 
        testOpp.Incumbent_Successor__c = 'Ameritas';  
        testOpp.System__c = 'NASCO';
        testOpp.NASCO_Acct_ID__c='12345';
        
        insert testOpp ;
        
        //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        testOpp.StageName = 'Sold';
        testOpp.Probability = Decimal.valueOf('100');
        testOpp.Won_Lost_Reason__c = 'Acquisition';
        testOpp.Incumbent_Successor__c = 'Aetna';
        Test.startTest();
        update testOpp;
        
        //end new change 9Nov16 
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='RFP';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp.System__c = 'NASCO';
        testOpp.NASCO_Acct_ID__c='12345';  
        
        insert testOpp1 ;
        
        
        newPartner.Partner__c = acc2.id;                
        newPartner.Opportunity__c = testOpp.Id;                
        newPartner.Primary__c = true;                
        newPartner.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newPartner.End_Date__c = System.today(); 
        newPartner.Role__c = 'Broker';
        insertPartners.add(newPartner);
        
        newPartner1.Partner__c = acc2.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = date.newinstance(2016, 4, 1); 
        newPartner1.End_Date__c = System.today(); 
        newPartner1.Role__c = 'Consultant';              
        insertPartners.add(newPartner1);
       
        Partner__c part_sold_nulldates = new Partner__c();
        part_sold_nulldates.Partner__c = acc2.id;                
        part_sold_nulldates.Opportunity__c = testOpp.Id;                
        part_sold_nulldates.Primary__c = true;                
        part_sold_nulldates .Role__c = 'None (Direct Sale)';
        insertPartners.add(part_sold_nulldates );
        
        Partner__c part_sold_NoRole = new Partner__c();
        part_sold_NoRole.Partner__c = acc2.id;                
        part_sold_NoRole.Opportunity__c = testOpp.Id;                
        part_sold_NoRole.Primary__c = true;                
        part_sold_NoRole.Effective_Date__c = date.newinstance(2016, 3, 1); 
        part_sold_NoRole.End_Date__c = System.today(); 
        insertPartners.add(part_sold_NoRole);
       
        Partner__c part_sold_effdtnot1 = new Partner__c();
        part_sold_effdtnot1.Partner__c = acc2.id;                
        part_sold_effdtnot1.Opportunity__c = testOpp.Id;                
        part_sold_effdtnot1.Primary__c = true;                
        part_sold_effdtnot1.Effective_Date__c = date.newinstance(2016, 3, 8); 
        part_sold_effdtnot1.End_Date__c = System.today(); 
        part_sold_effdtnot1.Role__c = 'None (Direct Sale)';
        insertPartners.add(part_sold_effdtnot1);

         Test.stopTest(); 
        insert insertPartners;
       
        
        Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
        partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
        partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
        partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(part_sold_nulldates,1,''));
        partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(part_sold_NoRole,1,''));
        partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(part_sold_effdtnot1,1,''));
        
        partnerRelatedList1.savePartner();
        delete insertPartners;
       
   }
   
    static testMethod void testPartnerInvalid() {
         Profile pro = [SELECT Id FROM Profile WHERE Name='BCC RUL Custom'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
   // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='S';//'Sold';//new change 9Nov16
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate;
        testOpp.Business_Type__c = 'Renewal';
        testOpp.GeneralProducer__c = 'Direct';
        testOpp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = testOpp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp.Contract_End_Date__c = contractEndDate;  
        testOpp.Won_Lost_Reason__c =  'Acquisition'; 
        testOpp.Incumbent_Successor__c = 'Ameritas';  
        testOpp.System__c = 'NASCO';
        testOpp.NASCO_Acct_ID__c='12345';
        
        insert testOpp ;
        
        //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        testOpp.StageName = 'Sold';
        testOpp.Probability = Decimal.valueOf('100');
        testOpp.Won_Lost_Reason__c = 'Acquisition';
        testOpp.Incumbent_Successor__c = 'Aetna';
        Test.startTest();
        update testOpp;
        
        //end new change 9Nov16 
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='RFP';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp.System__c = 'NASCO';
        testOpp.NASCO_Acct_ID__c='12345';  
        
        insert testOpp1 ;
        
        
        newPartner.Partner__c = acc2.id;                
        newPartner.Opportunity__c = testOpp.Id;                
        newPartner.Primary__c = true;                
        newPartner.Effective_Date__c = date.newinstance(2016, 3, 3); 
        newPartner.End_Date__c = System.today(); 
        newPartner.Role__c = 'Consultant';
        insertPartners.add(newPartner);
        
        newPartner1.Partner__c = acc2.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = date.newinstance(2016, 4, 1); 
        newPartner1.End_Date__c = System.today()+1; 
        newPartner1.Role__c = 'None (Direct Sale)';              
        insertPartners.add(newPartner1);
       
        

         Test.stopTest(); 
        insert insertPartners;
       
        system.runAs(u){
         Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
         partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner,1,''));
         partnerRelatedList1.savePartner();
           
        }
    }
    static testMethod void testPartnerInvalidProposal() {
         Profile pro = [SELECT Id FROM Profile WHERE Name='BCC RUL Custom'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
   // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        Date contractEndDate = effectiveDate+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        
       Test.startTest();
        //end new change 9Nov16 
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Proposal';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';  
        
        insert testOpp1 ;
         //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp1.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        
        
        newPartner.Partner__c = acc2.id;                
        newPartner.Opportunity__c = testOpp1.Id;                
        newPartner.Primary__c = true;                
        newPartner.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newPartner.End_Date__c = System.today(); 
        newPartner.Role__c = 'Consultant';
        insertPartners.add(newPartner);
        
        newPartner1.Partner__c = acc2.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = date.newinstance(2016, 4, 1); 
        newPartner1.End_Date__c = System.today()+1; 
        newPartner1.Role__c = 'None (Direct Sale)';              
        insertPartners.add(newPartner1);
        
        
       
        
        
         Test.stopTest(); 
        try{
        insert insertPartners;
       
        
         system.runAs(u){
         Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
         partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner,1,''));
         //partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner2,1,''));
         partnerRelatedList1.selectedCR=1;
         partnerRelatedList1.savePartner();
           
        }
         
        Partner__c newPartner2 = new Partner__c();
        newPartner2.Partner__c = acc.id;                
        newPartner2.Opportunity__c = testOpp1.Id;                
        newPartner2.Primary__c = true;                
        newPartner2.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1); 
        newPartner2.End_Date__c = contractEndDate; 
        newPartner2.Role__c = 'None (Direct Sale)';
        insert newPartner2;
         Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner2));
         partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner2,1,''));
         partnerRelatedList1.savePartner();
        }
        catch(Exception e){}
       
   }
    static testMethod void testPartnerInvalidSold() {
         Profile pro = [SELECT Id FROM Profile WHERE Name='BCC RUL Custom'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
   // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        Date contractEndDate = effectiveDate+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        
       Test.startTest();
        //end new change 9Nov16 
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Proposal';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';  
        
        insert testOpp1 ;
         //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp1.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        
        testOpp1.StageName ='Sold';
        update testOpp1;
        
        newPartner.Partner__c = acc2.id;                
        newPartner.Opportunity__c = testOpp1.Id;                
        newPartner.Primary__c = true;                
        newPartner.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1); 
        newPartner.End_Date__c = contractEndDate; 
        newPartner.Role__c = 'Broker';
        insertPartners.add(newPartner);
        
        newPartner1.Partner__c = acc2.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);  
        newPartner1.End_Date__c = System.today(); 
        newPartner1.Role__c = 'Consultant';              
        insertPartners.add(newPartner1);
       
        
        
         Test.stopTest(); 
        try{
        insert insertPartners;
       
        system.runAs(u){
         Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
         partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner,1,''));
         partnerRelatedList1.selectedCR=1;
         partnerRelatedList1.savePartner();
           
        }
        }
        catch(Exception e){}
       
   }
    
    static testMethod void testPartnerBCC() {
         Profile pro = [SELECT Id FROM Profile WHERE Name='BCC RUL Custom'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        Date contractEndDate = effectiveDate+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        
       Test.startTest();
        //end new change 9Nov16 
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Proposal';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';  
        
        insert testOpp1 ;
         //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp1.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        testOpp1.Won_Lost_Reason__c ='Test';
        testOpp1.StageName = 'Sold';
        testOpp1.Incumbent_Successor__c = '';
        update testOpp1;
        
        newPartner1.Partner__c = acc.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1); 
        newPartner1.End_Date__c = contractEndDate; 
        newPartner1.Role__c = 'None (Direct Sale)';              
        
        Test.stopTest(); 
        try{
        system.runAs(u){
         Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
         partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
         partnerRelatedList1.selectedCR=1;
         partnerRelatedList1.savePartner();
           
        }
        }
        catch(Exception e){}
       
   }
    
    static testMethod void testPartnerNonBCC() {
         Profile pro = [SELECT Id FROM Profile WHERE Name='2+ Standard User - Custom'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        Date contractEndDate = effectiveDate+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        
       Test.startTest();
        //end new change 9Nov16 
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Proposal';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';  
        
        insert testOpp1 ;
         //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp1.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        
        testOpp1.StageName = 'Sold';
        testOpp1.Won_Lost_Reason__c = 'Test Record';
        update testOpp1;
        
        newPartner1.Partner__c = acc.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1); 
        newPartner1.End_Date__c = contractEndDate; 
        newPartner1.Role__c = 'Broker';              
        
        Test.stopTest(); 
        try{
        
         Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
         partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
         partnerRelatedList1.selectedCR=1;
        system.runAs(u){
            partnerRelatedList1.savePartner();
           
        }
            partnerRelatedList1.savePartner();
        }
        catch(Exception e){}
       
   }
     static testMethod void testPartner() {
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2016, 3, 1);     //date.newinstance(2012, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        //testOpp.OwnerId = oldUser.Id;
        testOpp.StageName ='Proposal';//'Sold';//new change 9Nov16
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
        testOpp.Won_Lost_Reason__c =  'Acquisition'; 
        testOpp.Incumbent_Successor__c = 'Ameritas';
        testOpp.System__c = 'NASCO';
        testOpp.NASCO_Acct_ID__c='12345';  
        
        insert testOpp ;
        //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        testOpp.StageName = 'Sold';
        testOpp.Probability = Decimal.valueOf('100');
        testOpp.Won_Lost_Reason__c = 'Acquisition';
        testOpp.Incumbent_Successor__c = 'Aetna';
        Test.startTest();
        update testOpp;
        //end new change 9Nov16
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Proposal';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';
        
        insert testOpp1 ;
        
        newPartner.Partner__c = acc2.id;                
        newPartner.Opportunity__c = testOpp.Id;                
        newPartner.Primary__c = true;                
        newPartner.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newPartner.End_Date__c = contractEndDate ;//System.today(); 
        newPartner.Role__c = '';
        insertPartners.add(newPartner);
        
        Partner__c newPartner2 = new Partner__c();
        newPartner2.Partner__c = acc2.id;                
        newPartner2.Opportunity__c = testOpp.Id;                
        newPartner2.Primary__c = true;                
        newPartner2.Effective_Date__c = null; 
        newPartner2.End_Date__c = null ; 
        newPartner2.Role__c = '';
        insertPartners.add(newPartner2);
        
 
        Partner__c part_sold_effdtnot1 = new Partner__c();
        part_sold_effdtnot1.Partner__c = acc2.id;                
        part_sold_effdtnot1.Opportunity__c = testOpp.Id;                
        part_sold_effdtnot1.Primary__c = true;                
        part_sold_effdtnot1.Effective_Date__c = date.newinstance(2016, 3, 8); 
        part_sold_effdtnot1.End_Date__c = System.today(); 
        part_sold_effdtnot1.Role__c = 'Broker';
        insertPartners.add(part_sold_effdtnot1);
        
        newPartner1.Partner__c = acc2.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newPartner1.End_Date__c = System.today(); 
        newPartner1.Role__c = 'Broker';              
        insertPartners.add(newPartner1);                
         
        
        for(Integer i=0;i<10;i++ ){
            Partner__c part = new Partner__c();
            part.Opportunity__c = testOpp.Id;                
            part.Primary__c = true;                
            part.Effective_Date__c = date.newinstance(2016, 3, 1); 
            part.End_Date__c = System.today();
            if(i>=2 && i<=4)
                part.Role__c = 'Broker';
            else if(i>=5 && i<=7)
                part.Role__c = 'Consultant';
            else if(i>=8 && i<=10)
                part.Role__c = 'None (Direct Sale)';                   
            insertPartners.add(part);
        }
        
        for(Integer i=0;i<10;i++ ){
            Partner__c part = new Partner__c();
            part.Opportunity__c = testOpp.Id;                
            part.Primary__c = true;
            insertPartners.add(part);
        }
        
        insert insertPartners;
           
        //Test.StartTest();
         Test.StopTest();
        Partner_RelatedList_Class partnerRelatedList = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner)); 
        partnerRelatedList.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner2,1,''));
       
        
        partnerRelatedList.savePartner();
        partnerRelatedList.cancelPartner();
        
        
        Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
        partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
        partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
        
        partnerRelatedList1.savePartner();
        partnerRelatedList1.liRecordSave();
        partnerRelatedList1.returnToOpp();
        partnerRelatedList1.selectedCR = 1;
        partnerRelatedList1.cancelPartner();    
        
       
     }
    
     static testMethod void testPartner1() {
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2016, 3, 1);     //date.newinstance(2012, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        //testOpp.OwnerId = oldUser.Id;
        testOpp.StageName ='Proposal';//'Sold';//new change 9Nov16
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
        testOpp.Won_Lost_Reason__c =  'Acquisition'; 
        testOpp.Incumbent_Successor__c = 'Ameritas';
        testOpp.System__c = 'NASCO';
        testOpp.NASCO_Acct_ID__c='12345';  
        
        insert testOpp ;
        //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        testOpp.StageName = 'Sold';
        testOpp.Probability = Decimal.valueOf('100');
        testOpp.Won_Lost_Reason__c = 'Acquisition';
        testOpp.Incumbent_Successor__c = 'Aetna';
        Test.startTest();
        update testOpp;
        //end new change 9Nov16
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Proposal';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';
        
        insert testOpp1 ;
        
        newPartner.Partner__c = acc2.id;                
        newPartner.Opportunity__c = testOpp.Id;                
        newPartner.Primary__c = true;                
        newPartner.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newPartner.End_Date__c = null ;//System.today(); 
        newPartner.Role__c = 'Broker';
        insertPartners.add(newPartner);
        
        Partner__c newPartner2 = new Partner__c();
        newPartner2.Partner__c = acc2.id;                
        newPartner2.Opportunity__c = testOpp.Id;                
        newPartner2.Primary__c = true;                
        newPartner2.Effective_Date__c = null; 
        newPartner2.End_Date__c = null ; 
        newPartner2.Role__c = 'Consultant';
        insertPartners.add(newPartner2);
         
         
        
 
        Partner__c part_sold_effdtnot1 = new Partner__c();
        part_sold_effdtnot1.Partner__c = acc2.id;                
        part_sold_effdtnot1.Opportunity__c = testOpp.Id;                
        part_sold_effdtnot1.Primary__c = true;                
        part_sold_effdtnot1.Effective_Date__c = date.newinstance(2016, 3, 8); 
        part_sold_effdtnot1.End_Date__c = System.today(); 
        part_sold_effdtnot1.Role__c = 'Consultant';
        insertPartners.add(part_sold_effdtnot1);
        
        newPartner1.Partner__c = acc2.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newPartner1.End_Date__c = System.today(); 
        newPartner1.Role__c = 'Consultant';              
        insertPartners.add(newPartner1);                
         
        
        for(Integer i=0;i<10;i++ ){
            Partner__c part = new Partner__c();
            part.Opportunity__c = testOpp.Id;                
            part.Primary__c = true;                
            part.Effective_Date__c = date.newinstance(2016, 3, 1); 
            part.End_Date__c = System.today();
            if(i>=2 && i<=4)
                part.Role__c = 'Consultant';
            else if(i>=5 && i<=7)
                part.Role__c = 'Consultant';
            else if(i>=8 && i<=10)
                part.Role__c = 'Consultant';                   
            insertPartners.add(part);
        }
        
        for(Integer i=0;i<10;i++ ){
            Partner__c part = new Partner__c();
            part.Opportunity__c = testOpp.Id;                
            part.Primary__c = true;
            insertPartners.add(part);
        }
        
        insert insertPartners;
           
        //Test.StartTest();
         Test.StopTest();
        Partner_RelatedList_Class partnerRelatedList = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner)); 
        partnerRelatedList.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner2,1,''));
       
        
        partnerRelatedList.savePartner();
        partnerRelatedList.cancelPartner();
        
        
        Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
        partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
        partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
        
        partnerRelatedList1.savePartner();
        partnerRelatedList1.liRecordSave();
        partnerRelatedList1.returnToOpp();
        partnerRelatedList1.selectedCR = 1;
        partnerRelatedList1.cancelPartner();    
        
       
     }
    
    static testMethod void testOpportunityInsert012() { 
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2016, 3, 1);     //date.newinstance(2012, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';//'Sold';//new change 9Nov16
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate;
        testOpp.Business_Type__c = 'Renewal';
        testOpp.GeneralProducer__c = 'Direct';
        testOpp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = testOpp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp.Contract_End_Date__c = contractEndDate;  
        testOpp.Won_Lost_Reason__c =  'Acquisition'; 
        testOpp.Incumbent_Successor__c = 'Ameritas';
        testOpp.System__c = 'NASCO';
        testOpp.NASCO_Acct_ID__c='12345';  
        
        insert testOpp ;
        //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        testOpp.StageName = 'Sold';
        testOpp.Probability = Decimal.valueOf('100');
        testOpp.Won_Lost_Reason__c = 'Acquisition';
        testOpp.Incumbent_Successor__c = 'Aetna';
        Test.startTest();
        update testOpp;
        //end new change 9Nov16
        
               
        newPartner.Partner__c = acc2.id;                
        newPartner.Opportunity__c = testOpp.Id;                
        newPartner.Primary__c = true;                
        newPartner.Effective_Date__c = effectiveDate.addMonths(1); 
        newPartner.End_Date__c = contractEndDate ;//System.today(); 
        newPartner.Role__c = 'None (Direct Sale)';
        insertPartners.add(newPartner);
        
        Partner__c newPartner1 = new Partner__c();
        newPartner1.Partner__c = acc2.id;                
        newPartner1.Opportunity__c = testOpp.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = effectiveDate; 
        newPartner1.End_Date__c = contractEndDate ;//System.today(); 
        //newPartner1.Role__c = 'None (Direct Sale)';
        insertPartners.add(newPartner1);
        insert insertPartners;
           
        Test.StopTest();
        Partner_RelatedList_Class partnerRelatedList = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner)); 
        partnerRelatedList.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner,1,''));
        partnerRelatedList.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
                      
        partnerRelatedList.savePartner();

        
    }
    
    static testMethod void testPartnerNonBCCproposal() {
         Profile pro = [SELECT Id FROM Profile WHERE Name='2+ Standard User - Custom'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        Date contractEndDate = effectiveDate+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        
       Test.startTest();
        //end new change 9Nov16 
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Proposal';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';  
        
        insert testOpp1 ;
         //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp1.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        
        /*testOpp1.StageName = 'Sold';
        testOpp1.Won_Lost_Reason__c = 'Test Record';
        update testOpp1;*/
        
        newPartner1.Partner__c = acc.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1); 
        newPartner1.End_Date__c = contractEndDate; 
        newPartner1.Role__c = 'Broker';              
        
        Test.stopTest(); 
        try{
        
         Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
         partnerRelatedList1.wrapListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
         partnerRelatedList1.wrapListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
         partnerRelatedList1.selectedCR=1;
        system.runAs(u){
            partnerRelatedList1.savePartner();
           
        }
            partnerRelatedList1.savePartner();
        }
        catch(Exception e){}
       
   }
    static testMethod void testPartnerBCCSoldInvalid() {
         Profile pro = [SELECT Id FROM Profile WHERE Name='2+ Standard User - Custom'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        Date contractEndDate = effectiveDate+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        
       Test.startTest();
        //end new change 9Nov16 
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Sold';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        //testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';  
        
        insert testOpp1 ;
         //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp1.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        
        testOpp1.StageName = 'Sold';
        testOpp1.Won_Lost_Reason__c = 'Test Record';
        update testOpp1;
        
        newPartner1.Partner__c = acc2.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = effectiveDate; 
        newPartner1.End_Date__c = contractEndDate; 
        newPartner1.Role__c = 'Broker';              
         
        Test.stopTest(); 
        try{
        
         Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
         partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
         partnerRelatedList1.selectedCR=1;
        system.runAs(u){
            partnerRelatedList1.savePartner();
           
        }
            partnerRelatedList1.savePartner();
        }
        catch(Exception e){}
       
   }
    
    static testmethod void updatePartner()
    {
        Profile pro = [SELECT Id FROM Profile WHERE Name='BCC RUL Custom'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Account acc3 = new Account();
        acc3.Name = 'New Partner';
        acc3.Type='Partner';
        insert acc3;
        
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        Date contractEndDate = effectiveDate+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        
       Test.startTest();
        //end new change 9Nov16 
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Sold';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        //testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';  
        
        insert testOpp1 ;
         //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp1.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        
        testOpp1.StageName = 'Sold';
        testOpp1.Won_Lost_Reason__c = 'Test Record';
        update testOpp1;
        
        newPartner1.Partner__c = acc2.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = effectiveDate; 
        newPartner1.End_Date__c = contractEndDate; 
        newPartner1.Role__c = 'Broker';              
        insert newPartner1;
        
        Test.stopTest(); 
        try{
        
         Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
         partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
         partnerRelatedList1.selectedCR=1;
         partnerRelatedList1.savePartner();
          partnerRelatedList1.wrapInputListPartner[0].partnerInst.Partner__c = acc3.id;
          partnerRelatedList1.wrapInputListPartner[0].partnerInst.Role__c = 'None (Direct Sale)' ;
        partnerRelatedList1.savePartner();
            system.runAs(u){
                delete newPartner1;
            }
        }
        catch(Exception e){} 
    }
    static testMethod void testPartnerSoldInvalid() {
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 2);        
        Date contractEndDate = effectiveDate+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        
       Test.startTest();
        //end new change 9Nov16 
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Sold';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        //testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';  
        
        insert testOpp1 ;
         //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp1.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        
        testOpp1.StageName = 'Sold';
        testOpp1.Won_Lost_Reason__c = 'Test Record';
        update testOpp1;
        
        newPartner1.Partner__c = acc2.id;                
        newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = effectiveDate; 
        newPartner1.End_Date__c = contractEndDate; 
        newPartner1.Role__c = 'Broker';              
         
        Test.stopTest(); 
        try{
        
         Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
         partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
         partnerRelatedList1.selectedCR=1;
         partnerRelatedList1.savePartner();
        }
        catch(Exception e){}
       
   }
    
    static testMethod void testPartnerSoldOppId() {
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        Date contractEndDate = effectiveDate+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        
       Test.startTest();
        //end new change 9Nov16 
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Sold';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        //testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';  
        
        insert testOpp1 ;
         //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp1.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        
        testOpp1.StageName = 'Sold';
        testOpp1.Won_Lost_Reason__c = 'Test Record';
        update testOpp1;
        
        newPartner1.Partner__c = acc2.id;                
        //newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = effectiveDate; 
        newPartner1.End_Date__c = contractEndDate; 
        newPartner1.Role__c = 'Broker'; 
        
        List<Partner__c> partnerLst = new List<Partner__c>();
        Partner__c newPartner2 = new Partner__c();
        newPartner2.Partner__c = acc2.id;                
        newPartner2.Opportunity__c = testOpp1.Id;                
        newPartner2.Primary__c = true;                
        newPartner2.Effective_Date__c = effectiveDate; 
        newPartner2.End_Date__c = contractEndDate; 
        newPartner2.Role__c = 'Broker';
        partnerLst.add(newPartner2);
        
        Partner__c newPartner3 = new Partner__c();
        newPartner3.Partner__c = acc2.id;                
        newPartner3.Opportunity__c = testOpp1.Id;                
        newPartner3.Primary__c = true;                
        newPartner3.Effective_Date__c = effectiveDate; 
        newPartner3.End_Date__c = contractEndDate; 
        newPartner3.Role__c = 'Broker';
        partnerLst.add(newPartner3);
        
        //insert partnerLst;
         
        Test.stopTest(); 
        try{
         PageReference pref = Page.Partner_RelatedList_Page;
  			Test.setCurrentPage(pref);
            pref.getParameters().put('oppid',testOpp1.Id);
         Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
         partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner2,1,''));
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner3,1,''));
         partnerRelatedList1.selectedCR=1;
         partnerRelatedList1.savePartner();
        }
        catch(Exception e){}
       
   }
    
    static testMethod void testPartnerProposalOppId() {
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Partner';        
        insert acc;
        
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2012, 3, 1);        
        Date contractEndDate = effectiveDate+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        
       Test.startTest();
        //end new change 9Nov16 
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity';
        testOpp1.AccountId = acc.Id ;
        testOpp1.StageName ='Sold';
        testOpp1.CloseDate = closedDate;
        testOpp1.Effective_Date__c = effectiveDate;
        testOpp1.Business_Type__c = 'Renewal';
        testOpp1.GeneralProducer__c = 'Direct';
        //testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.System__c = 'NASCO';
        testOpp1.NASCO_Acct_ID__c='12345';  
        
        insert testOpp1 ;
         //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp1.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        
        testOpp1.StageName = 'Sold';
        testOpp1.Won_Lost_Reason__c = 'Test Record';
        update testOpp1;
        
        newPartner1.Partner__c = acc2.id;                
        //newPartner1.Opportunity__c = testOpp1.Id;                
        newPartner1.Primary__c = true;                
        newPartner1.Effective_Date__c = effectiveDate; 
        newPartner1.End_Date__c = contractEndDate; 
        newPartner1.Role__c = 'Broker'; 
        
        
        Test.stopTest(); 
        try{
         PageReference pref = Page.Partner_RelatedList_Page;
  			Test.setCurrentPage(pref);
            pref.getParameters().put('oppid',testOpp1.Id);
         Partner_RelatedList_Class partnerRelatedList1 = new Partner_RelatedList_Class(new ApexPages.StandardController(newPartner1));
         partnerRelatedList1.wrapInputListPartner =  new List<Partner_RelatedList_Class.wrapperPartner>();
         partnerRelatedList1.wrapInputListPartner.add(new Partner_RelatedList_Class.wrapperPartner(newPartner1,1,''));
         partnerRelatedList1.selectedCR=1;
         partnerRelatedList1.savePartner();
        }
        catch(Exception e){}
       
   }  
}