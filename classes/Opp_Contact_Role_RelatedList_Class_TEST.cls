/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================

* 9/11/2018   |     RAJ KIRAN JV      |     Test Class issues Fix R1E1
* 9/24/2018   |   Paritosh   |  R1E1_2	  |     Test method added for coverage
*==================================================================================

*******************************************************************************************************/

@isTest
public class Opp_Contact_Role_RelatedList_Class_TEST {    
    
    @testSetup
    static void testData()
    {
       Account acc = AIA_TestUtil.AIA_createAccount();
        
        Contact con =new Contact();
        con.FirstName= 'contact first name';
        con.LastName = 'contact last name';
        con.AccountId = acc.id;
        con.Phone = '364575678';
        con.Email = 'abcd@gnc.com';
        con.Broker_NPN__c = '6543621';
        insert con;
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp1';
        opp.Contract_End_Date__c = date.newinstance(2016,12, 31);  
        opp.CloseDate = date.newinstance(2016, 9, 30); 
        opp.Effective_Date__c = date.newinstance(2016, 10, 01);
        opp.AccountId = acc.id;
        opp.StageName = 'Proposal';
        opp.Probability = Decimal.valueOf('50');
        opp.Won_Lost_Reason__c = 'Acquisition';
        opp.SBU__c   = 'Small/Medium';
        opp.Market_Segment__c = '2-50';
        opp.Division__c = '2-50 Renewal Business';

        opp.Underwriting_Entity__c = 'DC';
        opp.system__c = 'NASCO';
        opp.NASCO_Acct_ID__c = '76543';
        opp.FullServiceProducer__c = 'Kelly & Associates Insurance Group';
        opp.Request_NPN__c = true;
        insert opp; 
        
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        
    }
    
    static testMethod void Test_saveContactRole() {
        
        Opportunity opp = [select id,name from Opportunity Limit 1];
        Contact con = [select id,name from Contact Limit 1];
        
        Opportunity_Contact_Role__c oc = new Opportunity_Contact_Role__c();
        oc.Role__c = 'Broker';
        oc.Opportunity__c= opp.id;
        insert oc;
        oc.Role__c= 'Primary Broker';
        oc.Primary__c= true;//19March17
        update oc;
        system.debug('Test class 1st call oc >>'+oc);
        Opportunity_Contact_Role__c dl=[select id,Role__C, Opportunity__c from Opportunity_Contact_Role__c where Opportunity__c = :oc.Opportunity__c ];
        ApexPages.StandardController sc = new ApexPages.StandardController(oc);
        Opp_Contact_Role_RelatedList_Class oppCRRC = new Opp_Contact_Role_RelatedList_Class(sc);
        oppCRRC.isBCCProfile=false;
        system.assertEquals('Proposal',oppCRRC.oppStage);
        oppCRRC.selectedCR = 1;
        list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> wraplistOCRTst = oppCRRC.wraplistOCR;
        for(Opp_Contact_Role_RelatedList_Class.wrapperOCR wocr : wraplistOCRTst){
            wocr.OCRInst.Contact_Name__c = con.id;
            wocr.OCRInst.Role__c = 'Primary Broker';
            wocr.OCRInst.Primary__c= true;//19March17
            wocr.OCRInst.Effective_Date__c = date.newinstance(2016, 9, 1);
            wocr.OCRInst.End_Date__c = date.newinstance(2016, 9, 30);
            break;          
        }
        oppCRRC.saveContactRole();
        oppCRRC.msg = 'Record Saved';
        oppCRRC.displayPopUp = true;
        oppCRRC.returnToOpp();
        List<Opportunity_Contact_Role__c> ocrList = [select id,Contact_Name__c,Role__c,Effective_Date__c,End_Date__c  from Opportunity_Contact_Role__c];
        system.assertEquals(1,ocrList.size());
        system.assertNotEquals(null,ocrList[0].id);
        system.assertEquals(con.id,ocrList[0].Contact_Name__c);
        system.assertEquals('Primary Broker',ocrList[0].Role__c);
        system.assertEquals(date.newinstance(2016, 9, 1),ocrList[0].Effective_Date__c );
        system.assertEquals(date.newinstance(2016, 9, 30),ocrList[0].End_Date__c );
        
        
        
        
        opp.StageName = 'Sold';
        opp.Probability = Decimal.valueOf('100');
        opp.Won_Lost_Reason__c = 'Acquisition';
        opp.Incumbent_Successor__c = 'Aetna';
        Test.StartTest();
        update opp;
        
        system.debug('Test class 2nd call opp >>'+opp);
        system.debug('Test class 2nd call oc >>'+oc);

        Opportunity_Contact_Role__c oc1 = new Opportunity_Contact_Role__c();
        oc1.Opportunity__c= opp.id;
        oc1.Role__c= 'Consultant';
        oc1.Primary__c = true;
        oc1.Standard_Contact_Role_ID__c=oc.id;
        insert oc1;
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(oc1);
        
        Opp_Contact_Role_RelatedList_Class oppCRRC1 = new Opp_Contact_Role_RelatedList_Class(sc1);
        system.assertEquals('Sold',oppCRRC1.oppStage);
        list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> wraplistOCRTst1 = oppCRRC1.wrapInputListOCR;
        list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> wraplistOCRTst2 = new list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> ();
        for(Opp_Contact_Role_RelatedList_Class.wrapperOCR wocr1 : wraplistOCRTst1){
            wocr1.OCRInst.Contact_Name__c = con.id;
            wocr1.OCRInst.Role__c = 'Primary Broker';//'Broker';//19March17
            wocr1.OCRInst.Primary__c= true;//19March17
            wocr1.OCRInst.Effective_Date__c = date.newinstance(2016, 10, 1);
            wocr1.OCRInst.End_Date__c = date.newinstance(2016,12, 31);//date.newinstance(2016,10, 30); 
            break;
                      
        }
        oppCRRC1.saveContactRole();
        
        for(Opp_Contact_Role_RelatedList_Class.wrapperOCR wocr1 : wraplistOCRTst1){
            wocr1.OCRInst.Contact_Name__c = con.id;
            wocr1.OCRInst.Role__c = 'Primary Broker';//'Broker';//19March17
            wocr1.OCRInst.Primary__c= true;//19March17
            break;
                      
        }
        oppCRRC1.saveContactRole();
        oppCRRC1.enableDates();
        Test.StopTest();
    }
    
   static testMethod void Test_saveContactAdminRole() {
        
        Opportunity opp = [select id,name from Opportunity Limit 1];
        Contact con = [select id,name from Contact Limit 1];
        
        Opportunity_Contact_Role__c oc = new Opportunity_Contact_Role__c();
        oc.Opportunity__c= opp.id;
        oc.Role__c= 'Administrator';
        oc.Effective_Date__c = date.newinstance(2016, 9, 1);
        oc.End_Date__c = date.newinstance(2016, 9, 30);
        insert oc;
        
        Opportunity_Contact_Role__c dl=[select id,Role__C, Opportunity__c from Opportunity_Contact_Role__c where Opportunity__c = :oc.Opportunity__c ];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(oc);
        Opp_Contact_Role_RelatedList_Class oppCRRC = new Opp_Contact_Role_RelatedList_Class(sc);
        oppCRRC.isBCCProfile=false;
        oppCRRC.selectedCR = 1;
        list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> wraplistOCRTst = oppCRRC.wraplistOCR;
        for(Opp_Contact_Role_RelatedList_Class.wrapperOCR wocr : wraplistOCRTst){
            wocr.OCRInst.Contact_Name__c = con.id;
            wocr.OCRInst.Role__c = 'Administrator';
            wocr.OCRInst.Effective_Date__c = date.newinstance(2016, 9, 1);
            wocr.OCRInst.End_Date__c = date.newinstance(2016, 9, 30);
            break;          
        }
        oppCRRC.saveContactRole();
        oppCRRC.cancelContactRole();
               
   }
   
    static testMethod void Test_saveContactAdminRole1() {
        
        Opportunity opp = [select id,name from Opportunity Limit 1];
        Contact con = [select id,name from Contact Limit 1];
        
        Opportunity_Contact_Role__c oc = new Opportunity_Contact_Role__c();
        oc.Opportunity__c= opp.id;
        oc.Role__c= 'Administrator';
        oc.Effective_Date__c = date.newinstance(2016, 9, 1);
        oc.End_Date__c = date.newinstance(2016, 9, 30);
        insert oc;
        
        Opportunity_Contact_Role__c dl=[select id,Role__C, Opportunity__c from Opportunity_Contact_Role__c where Opportunity__c = :oc.Opportunity__c ];
        Profile pro = [SELECT Id FROM Profile WHERE Name='BCC RUL Custom'];
         
        User u1 = new User(Alias = 'TAlias25', Email='TestUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser@testorg.com.test');
        insert u1;
        
        system.runAs(u1)
        {
        ApexPages.StandardController sc = new ApexPages.StandardController(oc);
        Opp_Contact_Role_RelatedList_Class oppCRRC = new Opp_Contact_Role_RelatedList_Class(sc);
        oppCRRC.isBCCProfile=false;
        list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> wraplistOCRTst = oppCRRC.wraplistOCR;
        for(Opp_Contact_Role_RelatedList_Class.wrapperOCR wocr : wraplistOCRTst){
            wocr.OCRInst.Contact_Name__c = con.id;
            wocr.OCRInst.Role__c = 'Administrator';
            wocr.OCRInst.Effective_Date__c = date.newinstance(2016, 9, 1);
            wocr.OCRInst.End_Date__c = date.newinstance(2016, 9, 30);
            break;          
        }
        oppCRRC.saveContactRole();
        }
        try{
      delete dl; 
        }catch(Exception e){
            
        }
   }
   static testMethod void Test_saveContactRoleSold() {
        
        Opportunity opp = [select id,name from Opportunity Limit 1];
        Contact con = [select id,name from Contact Limit 1];
        
        opp.StageName = 'Sold';
        opp.Probability = Decimal.valueOf('100');
        opp.Won_Lost_Reason__c = 'Acquisition';
        opp.Incumbent_Successor__c = 'Aetna';
        Test.StartTest();
        update opp;
        Opportunity_Contact_Role__c oc1 = new Opportunity_Contact_Role__c();
        oc1.Opportunity__c= opp.id;
        oc1.Role__c= 'Primary Broker';
        oc1.Primary__c = true;
        insert oc1;
        
         Opportunity_Contact_Role__c oc2 = new Opportunity_Contact_Role__c();
        oc2.Opportunity__c= opp.id;
        oc2.Role__c= 'Primary Broker';
        
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(oc1);
        
        Opp_Contact_Role_RelatedList_Class oppCRRC1 = new Opp_Contact_Role_RelatedList_Class(sc1);
        system.assertEquals('Sold',oppCRRC1.oppStage);
        oppCRRC1.wrapInputListOCR.add(new Opp_Contact_Role_RelatedList_Class.wrapperOCR(oc1,0,''));
        oppCRRC1.wrapInputListOCR.add(new Opp_Contact_Role_RelatedList_Class.wrapperOCR(oc2,1,''));
        list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> wraplistOCRTst1 = oppCRRC1.wrapInputListOCR;
        list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> wraplistOCRTst2 = new list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> ();
        
        for(Opp_Contact_Role_RelatedList_Class.wrapperOCR wocr1 : wraplistOCRTst1){
            wocr1.OCRInst.Contact_Name__c = con.id;
            wocr1.OCRInst.Role__c = 'Primary Broker';
            wocr1.OCRInst.Primary__c= true;
            wocr1.OCRInst.Effective_Date__c = date.newinstance(2016, 10, 2);
            wocr1.OCRInst.End_Date__c = date.newinstance(2016,12, 31);
            break;
                      
        }
        oppCRRC1.saveContactRole();
       Test.StopTest();
    }
    static testMethod void Test_saveContactRoleSoldBcc() {
        
        Opportunity opp = [select id,name from Opportunity Limit 1];
        Contact con = [select id,name from Contact Limit 1];
        
        opp.StageName = 'Sold';
        opp.Probability = Decimal.valueOf('100');
        opp.Won_Lost_Reason__c = 'Acquisition';
        opp.Incumbent_Successor__c = 'Aetna';
        Test.StartTest();
        update opp;
        Opportunity_Contact_Role__c oc1 = new Opportunity_Contact_Role__c();
        oc1.Opportunity__c= opp.id;
        //oc1.Role__c= 'Full Service Producer';
        oc1.Role__c= 'Primary Broker';// added by raj for tets cover
        oc1.Primary__c = true;
        insert oc1;
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='BCC RUL Custom'];
         
        User u1 = new User(Alias = 'TAlias25', Email='TestUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser@testorg.com.test');
        insert u1;
        
        system.runAs(u1)
        {
        ApexPages.StandardController sc1 = new ApexPages.StandardController(oc1);
        
        Opp_Contact_Role_RelatedList_Class oppCRRC1 = new Opp_Contact_Role_RelatedList_Class(sc1);
        system.assertEquals('Sold',oppCRRC1.oppStage);
        list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> wraplistOCRTst1 = oppCRRC1.wrapInputListOCR;
        list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> wraplistOCRTst2 = new list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> ();
        for(Opp_Contact_Role_RelatedList_Class.wrapperOCR wocr1 : wraplistOCRTst1){
            wocr1.OCRInst.Contact_Name__c = con.id;
            wocr1.OCRInst.Role__c = 'Administrator';
            wocr1.OCRInst.Primary__c= true;
            wocr1.OCRInst.Effective_Date__c = date.newinstance(2016, 10, 1);
            wocr1.OCRInst.End_Date__c = date.newinstance(2016,12, 31);
            break;
                      
        }
        oppCRRC1.enableDates();
        oppCRRC1.saveContactRole();
        
        for(Opp_Contact_Role_RelatedList_Class.wrapperOCR wocr1 : wraplistOCRTst1){
            wocr1.OCRInst.Contact_Name__c = con.id;
            wocr1.OCRInst.Role__c = 'Primary Broker';
            wocr1.OCRInst.Primary__c= true;
            wocr1.OCRInst.Effective_Date__c = null;
            wocr1.OCRInst.End_Date__c = null;
            break;
                      
        }
        oppCRRC1.saveContactRole();
        
            for(Opp_Contact_Role_RelatedList_Class.wrapperOCR wocr1 : wraplistOCRTst1){
            wocr1.OCRInst.Contact_Name__c = con.id;
            wocr1.OCRInst.Role__c = 'Primary Broker';
            //wocr1.OCRInst.Primary__c= true;
            wocr1.OCRInst.Effective_Date__c = date.newinstance(2016, 10, 2);
            wocr1.OCRInst.End_Date__c = date.newinstance(2016, 12, 31);
            break;
                      
        }
        oppCRRC1.saveContactRole();
        for(Opp_Contact_Role_RelatedList_Class.wrapperOCR wocr1 : wraplistOCRTst1){
            wocr1.OCRInst.Contact_Name__c = con.id;
            wocr1.OCRInst.Role__c = 'Primary Broker';
            wocr1.OCRInst.Effective_Date__c = date.newinstance(2016, 10, 1);
            wocr1.OCRInst.End_Date__c = date.newinstance(2016, 11, 31);
            break;
                      
        }
        oppCRRC1.enableDates();
        oppCRRC1.saveContactRole();
        Test.StopTest();
        }}
    static testMethod void Test_saveContactRoleSoldNonBcc() {
        
        Opportunity opp = [select id,name from Opportunity Limit 1];
        Contact con = [select id,name from Contact Limit 1];
        
        opp.StageName = 'Sold';
        opp.Probability = Decimal.valueOf('100');
        opp.Won_Lost_Reason__c = 'Acquisition';
        opp.Incumbent_Successor__c = 'Aetna';
        Test.StartTest();
        update opp;
        Opportunity_Contact_Role__c oc1 = new Opportunity_Contact_Role__c();
        oc1.Opportunity__c= opp.id;
        oc1.Role__c= 'Broker';
        oc1.Primary__c = true;
        insert oc1;
        Profile pro = [SELECT Id FROM Profile WHERE Name='2+ Standard User - Custom'];
         
        User u1 = new User(Alias = 'TAlias25', Email='TestUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser@testorg.com.test');
        insert u1;
        
        system.runAs(u1)
        {
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(oc1);
        
        Opp_Contact_Role_RelatedList_Class oppCRRC1 = new Opp_Contact_Role_RelatedList_Class(sc1);
        system.assertEquals('Sold',oppCRRC1.oppStage);
        list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> wraplistOCRTst1 = oppCRRC1.wrapInputListOCR;
        
        for(Opp_Contact_Role_RelatedList_Class.wrapperOCR wocr1 : wraplistOCRTst1){
            wocr1.OCRInst.Contact_Name__c = con.id;
            wocr1.OCRInst.Role__c = 'Primary Broker';
            wocr1.OCRInst.Primary__c= true;
            wocr1.OCRInst.Effective_Date__c = date.newinstance(2016, 10, 1);
            wocr1.OCRInst.End_Date__c = date.newinstance(2016,12, 31);
            break;
                      
        }
        oppCRRC1.saveContactRole();
        
        }
        Test.StopTest();
    }
    static testMethod void Test_saveContactRoleMultiPrimary() {
        
        Opportunity opp = [select id,name from Opportunity Limit 1];
        Contact con = [select id,name from Contact Limit 1];
        
        opp.StageName = 'Sold';
        opp.Probability = Decimal.valueOf('100');
        opp.Won_Lost_Reason__c = 'Acquisition';
        opp.Incumbent_Successor__c = 'Aetna';
        Test.StartTest();
        update opp;
        List<Opportunity_Contact_Role__c> ocrLst = new List<Opportunity_Contact_Role__c>();
        Opportunity_Contact_Role__c oc1 = new Opportunity_Contact_Role__c();
        oc1.Opportunity__c= opp.id;
        oc1.Role__c= 'Primary Broker';
        
        
        oc1.Primary__c = true;
        oc1.Effective_Date__c =  date.newinstance(2016, 10, 1);
        oc1.End_Date__c = date.newinstance(2016,12, 31);
        ocrLst.add(oc1);
        
        Opportunity_Contact_Role__c oc2 = new Opportunity_Contact_Role__c();
        oc2.Opportunity__c= opp.id;
        oc2.Role__c= 'Administrator';
        oc2.Effective_Date__c =  date.newinstance(2016, 10, 1);
        oc2.End_Date__c = date.newinstance(2016,12, 31);
        ocrLst.add(oc2);
        
        Opportunity_Contact_Role__c oc3 = new Opportunity_Contact_Role__c();
        oc3.Opportunity__c= opp.id;
        oc3.Role__c= 'Firm Executive';
         
        oc3.Effective_Date__c =  date.newinstance(2016, 10, 1);
        oc3.End_Date__c = date.newinstance(2016,12, 31);
        ocrLst.add(oc3);
       
        /*  R1E1 start 
        Opportunity_Contact_Role__c oc4 = new Opportunity_Contact_Role__c();
        oc4.Opportunity__c= opp.id;
        oc4.Role__c= 'General Producer';
        oc4.Effective_Date__c =  date.newinstance(2016, 10, 1);
        oc4.End_Date__c = date.newinstance(2016,12, 31);
        ocrLst.add(oc4);
        
        
        Opportunity_Contact_Role__c oc5 = new Opportunity_Contact_Role__c();
        oc5.Opportunity__c= opp.id;
        oc5.Role__c= 'Group Administrator';
        oc5.Effective_Date__c =  date.newinstance(2016, 10, 1);
        oc5.End_Date__c = date.newinstance(2016,12, 31);
        ocrLst.add(oc5);
        
        
        Opportunity_Contact_Role__c oc6 = new Opportunity_Contact_Role__c();
        oc6.Opportunity__c= opp.id;
        oc6.Role__c= 'Surveyor';
        oc6.Effective_Date__c =  date.newinstance(2016, 10, 1);
        oc6.End_Date__c = date.newinstance(2016,12, 31);
        ocrLst.add(oc6);
        
         R1E1-- END
        */ 
        
        
        insert ocrLst;
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(oc1);
        
        Opp_Contact_Role_RelatedList_Class oppCRRC1 = new Opp_Contact_Role_RelatedList_Class(sc1);
        system.assertEquals('Sold',oppCRRC1.oppStage);
        oppCRRC1.errorMsg = '';
        list<Opp_Contact_Role_RelatedList_Class.wrapperOCR> wraplistOCRTst1 = oppCRRC1.wrapInputListOCR;
        for(Opp_Contact_Role_RelatedList_Class.wrapperOCR wocr1 : wraplistOCRTst1){
            wocr1.OCRInst.Contact_Name__c = con.id;
            wocr1.OCRInst.Role__c = 'Primary Broker';
            wocr1.OCRInst.Primary__c= true;
            wocr1.OCRInst.Effective_Date__c = date.newinstance(2017, 10, 1);
            wocr1.OCRInst.End_Date__c = date.newinstance(2016,12, 31);
            //break;
                      
        }
        oppCRRC1.saveContactRole();
        Test.StopTest();
    }
    
    //R1E1_2 start
    public static testmethod void test_saveCRonProposal_exception(){
        
        Contact con = [select id,name from Contact Limit 1];
        Opportunity_Contact_Role__c oc1 = new Opportunity_Contact_Role__c();
        oc1.Role__c = 'Primary Broker';
        oc1.Contact_Name__c = con.id;
            
        ApexPages.StandardController sc1 = new ApexPages.StandardController(oc1);
        Opp_Contact_Role_RelatedList_Class oppCRRC1 = new Opp_Contact_Role_RelatedList_Class(sc1);
        
        Opp_Contact_Role_RelatedList_Class.wrapperOCR wrapper = new Opp_Contact_Role_RelatedList_Class.wrapperOCR(oc1, 0, '');
        oppCRRC1.wraplistOCR = new List<Opp_Contact_Role_RelatedList_Class.wrapperOCR>();
        oppCRRC1.wraplistOCR.add(wrapper);
        
        oppCRRC1.oppStage='Proposal';
        oppCRRC1.saveContactRole();
    }
    //R1E1_2 end
}