@isTest()
public class FSP_GP_RelatedList_Class_Test{ 
   public static Id optyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('51+').getRecordTypeId();
    
   @testSetup
    static void testData()
    {
        Account acc = new Account();
        acc.Name = 'Test partner Account';
        acc.Type = 'Partner';
        insert acc;
        FSP_GP_Account_Lookup__c fspGPAccId = new FSP_GP_Account_Lookup__c();
        fspGPAccId.Name = 'Test Partner';
        fspGPAccId.Partner_ID__c = acc.Id;
        fspGPAccId.Partner_Name__c = 'Kelly & Associates Insurance Group';
        insert fspGPAccId;
    }
    static testMethod void testFSPGPInsert(){
        
        FSP_GP__c newFSP = new FSP_GP__c();
        FSP_GP__c newFSP1 = new FSP_GP__c();
        Account acc = new Account();
        Account acc2 = new Account();
        List<FSP_GP__c> insertFSPGP = new List<FSP_GP__c>(); 
        
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Customer';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Customer';
        insert acc2;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2010, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';//'Sold';//new change 9Nov16
        testOpp.System__c = 'NASCO';
        testOpp.NASCO_Acct_ID__c='12345';
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate;
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
        
        if(testOpp.System__c != null)
        insert testOpp ;

        //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        //end new change 9Nov16 
        Test.startTest();    
        
        newFSP.FSP_GP__c = acc2.id;                
        newFSP.Opportunity__c = testOpp.Id;                
        newFSP.Primary__c = true;                
        newFSP.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newFSP.End_Date__c = System.today(); 
        newFSP.FSP_GP__c = 'GP';
        newFSP.Partner__c = 'Kelly & Associates Insurance Group';
        insert newFSP;
        
        newFSP1.FSP_GP__c = acc2.id;                
        newFSP1.Opportunity__c = testOpp.Id;                
        newFSP1.Primary__c = true;                
        newFSP1.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newFSP1.End_Date__c = System.today(); 
        newFSP1.FSP_GP__c = 'GP';
        newFSP1.Partner__c = 'Kelly & Associates Insurance Group';
        
        insert newFSP1;
        
        FSP_GP_RelatedList_Class FSPGPRelatedList = new FSP_GP_RelatedList_Class(new ApexPages.StandardController(newFSP));
        FSPGPRelatedList.saveFSPGP();
        FSPGPRelatedList.msg = 'Record saved';
        FSPGPRelatedList.displayPopUp = true;
        FSPGPRelatedList.returnToOpp();
        //Delete 
        delete newFSP;
        
        Test.stopTest();
   
   }
    
    static testMethod void testFSPGPSold1() { 
        
        FSP_GP__c newFSP = new FSP_GP__c();
        FSP_GP__c newFSP1 = new FSP_GP__c();
        Account acc = new Account();
        Account acc2 = new Account();
        List<FSP_GP__c> insertFSPGP = new List<FSP_GP__c>(); 
        
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Customer';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Customer';
        insert acc2;
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2010, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';//'Sold';//new change 9Nov16
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate;
        testOpp.Business_Type__c = 'Renewal';
        testOpp.GeneralProducer__c = 'Kelly & Associates Insurance Group';
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
        
        List<FSP_GP__c> fspGPList = new List<FSP_GP__c>();
        
        newFSP.FSP_GP__c = acc2.id;                
        newFSP.Opportunity__c = testOpp.Id;                
        newFSP.Primary__c = true;                
        Date effectiveDate2 =  effectiveDate.addDays(2);          
        newFSP.Effective_Date__c = Date.newInstance(effectiveDate2.Year(), effectiveDate2.Month(),1);
        newFSP.End_Date__c = contractEndDate; 
        newFSP.FSP_GP__c = 'GP'; 
        newFSP.Partner__c = 'Kelly & Associates Insurance Group';
        fspGPList.add(newFSP);       
        
        newFSP1.FSP_GP__c = acc2.id;                
        newFSP1.Opportunity__c = testOpp.Id;                
        Date effectiveDate3 =  effectiveDate.addDays(31);          
        newFSP1.Effective_Date__c = Date.newInstance(effectiveDate3.Year(), effectiveDate3.Month(),1);
        newFSP1.End_Date__c = contractEndDate; 
        newFSP1.FSP_GP__c = 'GP'; 
        newFSP1.Partner__c = 'Kelly & Associates Insurance Group';
        fspGPList.add(newFSP1);
        FSP_GP__c newFSP2 = new FSP_GP__c ();
        newFSP2.FSP_GP__c = acc2.id;                
        newFSP2.Opportunity__c = testOpp.Id;                
        newFSP2.Effective_Date__c = Date.newInstance(effectiveDate2.Year(), effectiveDate2.Month(),1);
        newFSP2.End_Date__c = contractEndDate; 
        newFSP2.FSP_GP__c = 'GP'; 
        newFSP2.Partner__c = 'Kelly & Associates Insurance Group';
        insert fspGPList;
        PageReference pageRef = Page.FSP_GP_RelatedList_Page;
            Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('oppid',testOpp.Id);
        
        FSP_GP_RelatedList_Class FSPGPRelatedList = new FSP_GP_RelatedList_Class(new ApexPages.StandardController(newFSP));
        FSPGPRelatedList.wrapInputListFSPGP.add(new FSP_GP_RelatedList_Class.wrapperFSPGP(newFSP1,1,'',true));
        FSPGPRelatedList.saveFSPGP();
        FSPGPRelatedList.cancelFSPGP();
        
        Test.StopTest();
               
   }
   static testMethod void testFSPGPInsert1(){
        
        FSP_GP__c newFSP = new FSP_GP__c();
        FSP_GP__c newFSP1 = new FSP_GP__c();
        Account acc = new Account();
        Account acc2 = new Account();
        List<FSP_GP__c> insertFSPGP = new List<FSP_GP__c>(); 
        
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Customer';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Customer';
        insert acc2;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2010, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';//'Sold';//new change 9Nov16
        testOpp.System__c = 'NASCO';
        testOpp.NASCO_Acct_ID__c='12345';
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
        
        if(testOpp.System__c != null)
        insert testOpp ;

        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        Test.startTest();    
        
        newFSP.FSP_GP__c = acc2.id;                
        newFSP.Opportunity__c = testOpp.Id;                
        newFSP.Primary__c = true;                
        newFSP.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newFSP.End_Date__c = System.today(); 
        newFSP.FSP_GP__c = 'GP';
        newFSP.Partner__c = 'Kelly & Associates Insurance Group';
        insert newFSP;
        
        newFSP1.FSP_GP__c = acc2.id;                
        newFSP1.Opportunity__c = testOpp.Id;                
        newFSP1.Primary__c = true;                
        newFSP1.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newFSP1.End_Date__c = System.today(); 
        newFSP1.FSP_GP__c = 'GP';
        newFSP1.Partner__c = 'Kelly & Associates Insurance Group';
        
        insert newFSP1;
       
        Profile pro = [SELECT Id FROM Profile WHERE Name='BCC RUL Custom'];
         
        User u1 = new User(Alias = 'TAlias25', Email='TestUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser@testorg.com.test');
        insert u1;
        
        system.runAs(u1)
        {
        FSP_GP_RelatedList_Class FSPGPRelatedList = new FSP_GP_RelatedList_Class(new ApexPages.StandardController(newFSP));
        FSPGPRelatedList.saveFSPGP();
        }
        
        Test.stopTest();
   }  
    
    static testMethod void testFSPGPSoldInvalid() { 
        
        FSP_GP__c newFSP = new FSP_GP__c();
        FSP_GP__c newFSP1 = new FSP_GP__c();
        Account acc = new Account();
        List<FSP_GP__c> insertFSPGP = new List<FSP_GP__c>(); 
        
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Customer';        
        insert acc;
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2010, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate;
        testOpp.Business_Type__c = 'Renewal';
        testOpp.GeneralProducer__c = 'Kelly & Associates Insurance Group';
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
        
        List<FSP_GP__c> fspGPList = new List<FSP_GP__c>();
        
        newFSP.FSP_GP__c = acc.id;                
        newFSP.Opportunity__c = testOpp.Id;                
        newFSP.Primary__c = true;                
        Date effectiveDate2 =  effectiveDate.addDays(2);          
        newFSP.Effective_Date__c = Date.newInstance(effectiveDate2.Year(), effectiveDate2.Month(),1);
        newFSP.End_Date__c = contractEndDate; 
        newFSP.FSP_GP__c = 'GP'; 
        newFSP.Partner__c = 'Kelly & Associates Insurance Group';
        fspGPList.add(newFSP);       
        insert fspGPList;
        //FSP/GP without Effective Date and End Date
        newFSP1.FSP_GP__c = acc.id;                
        newFSP1.Opportunity__c = testOpp.Id;                
        newFSP1.Primary__c = true;                
        newFSP1.FSP_GP__c = 'GP';
        newFSP1.Partner__c = 'Kelly & Associates Insurance Group';
        
        //FSP/GP without Effective Date 
		FSP_GP__c newFSP2 = new FSP_GP__c();
        newFSP2.FSP_GP__c = acc.id;                
        newFSP2.Opportunity__c = testOpp.Id;                
        newFSP2.Primary__c = true;                
        newFSP2.FSP_GP__c = 'GP';
        newFSP2.Partner__c = 'Kelly & Associates Insurance Group';        
        newFSP2.Effective_Date__c = date.newinstance(2010, 3, 2);
        newFSP2.End_Date__c = contractEndDate; 
        
        FSP_GP__c newFSP3 = new FSP_GP__c();
        newFSP3.FSP_GP__c = acc.id;                
        newFSP3.Opportunity__c = testOpp.Id;                
        newFSP3.Primary__c = true;                
        newFSP3.FSP_GP__c = 'GP';
        newFSP3.Partner__c = 'Kelly & Associates Insurance Group';        
        newFSP3.Effective_Date__c = date.newinstance(2010, 3, 1);
        newFSP3.End_Date__c = contractEndDate.addDays(3); 
        
        PageReference pageRef = Page.FSP_GP_RelatedList_Page;
            Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('oppid',testOpp.Id);
        
        FSP_GP_RelatedList_Class FSPGPRelatedList = new FSP_GP_RelatedList_Class(new ApexPages.StandardController(newFSP));
        FSPGPRelatedList.wrapInputListFSPGP.add(new FSP_GP_RelatedList_Class.wrapperFSPGP(newFSP1,1,'',true));
        FSPGPRelatedList.wrapInputListFSPGP.add(new FSP_GP_RelatedList_Class.wrapperFSPGP(newFSP2,1,'',true));
        FSPGPRelatedList.wrapInputListFSPGP.add(new FSP_GP_RelatedList_Class.wrapperFSPGP(newFSP3,1,'',true));
        FSPGPRelatedList.saveFSPGP();
        
        Test.StopTest();
               
   }
    
    static testMethod void testFSPGPSoldInvalid1() { 
        
        FSP_GP__c newFSP = new FSP_GP__c();
        FSP_GP__c newFSP1 = new FSP_GP__c();
        Account acc = new Account();
        List<FSP_GP__c> insertFSPGP = new List<FSP_GP__c>(); 
        
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Customer';        
        insert acc;
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2010, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate;
        testOpp.Business_Type__c = 'Renewal';
        testOpp.GeneralProducer__c = 'Kelly & Associates Insurance Group';
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
        
        List<FSP_GP__c> fspGPList = new List<FSP_GP__c>();
        
        newFSP.FSP_GP__c = acc.id;                
        newFSP.Opportunity__c = testOpp.Id;                
        newFSP.Primary__c = true;                
        newFSP.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        newFSP.End_Date__c = contractEndDate; 
        newFSP.FSP_GP__c = 'GP'; 
        newFSP.Partner__c = 'Kelly & Associates Insurance Group';
        fspGPList.add(newFSP);       
        insert fspGPList;
        
        newFSP1.FSP_GP__c = acc.id;                
        newFSP1.Opportunity__c = testOpp.Id;                
        newFSP1.Primary__c = true;                
        newFSP1.FSP_GP__c = 'GP';
        newFSP1.Partner__c = 'Kelly & Associates Insurance Group';
        Date effectiveDate2 = effectiveDate.addDays(35);
        newFSP1.Effective_Date__c = Date.newInstance(effectiveDate2.Year(), effectiveDate2.Month(),1);
        newFSP1.End_Date__c = contractEndDate; 
        
        FSP_GP__c newFSP3 = new FSP_GP__c();
        newFSP3.FSP_GP__c = acc.id;                
        newFSP3.Opportunity__c = testOpp.Id;                
        newFSP3.Primary__c = true;                
        newFSP3.FSP_GP__c = 'GP';
        newFSP3.Partner__c = 'Kelly & Associates Insurance Group';        
        newFSP3.Effective_Date__c = Date.newInstance(effectiveDate2.Year(), effectiveDate2.Month(),1);
        newFSP3.End_Date__c = contractEndDate.addDays(3);
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='2+ Standard User - Custom'];
         
        User u1 = new User(Alias = 'TAlias25', Email='TestUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser@testorg.com.test');
        insert u1;
        
        system.runAs(u1)
        {
        PageReference pageRef = Page.FSP_GP_RelatedList_Page;
            Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('oppid',testOpp.Id);
        
            FSP_GP_RelatedList_Class FSPGPRelatedList = new FSP_GP_RelatedList_Class(new ApexPages.StandardController(newFSP));
        FSPGPRelatedList.wrapInputListFSPGP.add(new FSP_GP_RelatedList_Class.wrapperFSPGP(newFSP1,1,'',true));
        FSPGPRelatedList.wrapInputListFSPGP.add(new FSP_GP_RelatedList_Class.wrapperFSPGP(newFSP3,1,'',true));
        FSPGPRelatedList.saveFSPGP();
        }
        Test.StopTest();
               
   }
    static testMethod void testFSPGPSoldInvalid2() { 
        
        FSP_GP__c newFSP = new FSP_GP__c();
        Account acc = new Account();
        
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Customer';        
        insert acc;
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2010, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate;
        testOpp.Business_Type__c = 'Renewal';
        testOpp.GeneralProducer__c = 'Kelly & Associates Insurance Group';
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
        
        newFSP.FSP_GP__c = acc.id;                
        newFSP.Opportunity__c = testOpp.Id;                
        newFSP.Primary__c = true;                
        newFSP.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        newFSP.Effective_Date__c = newFSP.Effective_Date__c.addMonths(1);
        newFSP.End_Date__c = contractEndDate; 
        newFSP.FSP_GP__c = 'GP'; 
        newFSP.Partner__c = 'Kelly & Associates Insurance Group';
        PageReference pageRef = Page.FSP_GP_RelatedList_Page;
            Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('oppid',testOpp.Id);
        
        FSP_GP_RelatedList_Class FSPGPRelatedList = new FSP_GP_RelatedList_Class(new ApexPages.StandardController(newFSP));
        FSPGPRelatedList.wrapInputListFSPGP.add(new FSP_GP_RelatedList_Class.wrapperFSPGP(newFSP,1,'',true));
        FSPGPRelatedList.saveFSPGP();
        
        Test.StopTest();
               
   }
    static testMethod void testFSPGPSoldValid() { 
        
        FSP_GP__c newFSP = new FSP_GP__c();
        Account acc = new Account();
        
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Customer';        
        insert acc;
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2010, 3, 1);        
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate;
        testOpp.Business_Type__c = 'Renewal';
        testOpp.GeneralProducer__c = 'Kelly & Associates Insurance Group';
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
        
        newFSP.FSP_GP__c = acc.id;                
        newFSP.Opportunity__c = testOpp.Id;                
        newFSP.Primary__c = true;                
        newFSP.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        newFSP.End_Date__c = contractEndDate; 
        newFSP.FSP_GP__c = 'GP'; 
        newFSP.Partner__c = 'Kelly & Associates Insurance Group';
       
        PageReference pageRef = Page.FSP_GP_RelatedList_Page;
            Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('oppid',testOpp.Id);
        
        FSP_GP_RelatedList_Class FSPGPRelatedList = new FSP_GP_RelatedList_Class(new ApexPages.StandardController(newFSP));
        FSPGPRelatedList.wrapInputListFSPGP.add(new FSP_GP_RelatedList_Class.wrapperFSPGP(newFSP,1,'',true));
        FSPGPRelatedList.saveFSPGP();
        
        Test.StopTest();
               
   }
}