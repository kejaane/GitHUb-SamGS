@isTest()
public class NPN_Check_Test{ 
    static testMethod void testFSPGPRelatedList() { 
        List<Opportunity> optyList = new List<Opportunity>();
        FSP_GP__c newFSP = new FSP_GP__c();
        Map<id, Opportunity_Contact_Role__c> ocrMap = new Map<id, Opportunity_Contact_Role__c>();
        
        Account acc = new Account();
        acc.name = 'Test Acc';
        //acc.name = 'Community_User_Account';//Failing in AccountUpdateForCommunityContact.UpdateAccountForCommunityContact: line 17, column 1
        //acc.Sic = '7377';
        //acc.Status__c = 'Active';
        acc.Type = 'Partner';
        acc.RecordTypeId = QueryBase.getRecordTypeId('Account','X51');
        //acc.Facets_Account_Number__c = '0X84';
        //acc.RecType_Facets_Account_Number__c = '2-50_0X84s';
        insert acc;
        
        Contact con =new Contact();
        con.FirstName= 'contact first name';
        con.LastName = 'contact last name';
        con.AccountId = acc.id;
        con.Phone = '364575678';
        con.Email = 'abcd@gnc.com';
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
        opp.Business_Type__c = 'Renewal';
        opp.Underwriting_Entity__c = 'DC';
        opp.FullServiceProducer__c = 'Kelly & Associates Insurance Group Inc';
        optyList.add(opp);
        insert optyList;
        
        List<Opportunity_Contact_Role__c> a = new List<Opportunity_Contact_Role__c>();
        Opportunity_Contact_Role__c oc = new Opportunity_Contact_Role__c();
        oc.Role__c = 'Primary Broker';
        oc.Opportunity__c= opp.id;
        oc.Contact_Name__c = con.id;
        a.add(oc);
        Opportunity_Contact_Role__c oc1 = new Opportunity_Contact_Role__c();
        oc1.Role__c = 'Broker';
        oc1.Opportunity__c= opp.id;
        oc1.Contact_Name__c = con.id;
        a.add(oc1);
        Insert a;
        
        
        
        
        newFSP.FSP_GP__c = acc.id;                
        newFSP.Opportunity__c = opp.Id;                
        newFSP.Primary__c = true;                
        newFSP.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newFSP.End_Date__c = System.today(); 
        newFSP.FSP_GP__c = 'FSP'; 
        newFSP.Partner__c = 'Kelly & Associates Insurance Group';
        insert newFSP;
        Account acc2 = new Account();
         acc2.Name = 'TESTING2';
        acc2.Type = 'Partner';
        insert acc2;
        
        List<Partner__c> listPrtnrs = new List<Partner__c> ();
        Partner__c  prtnr = new Partner__c ();
        prtnr.Opportunity__c = opp.Id; 
        prtnr.Partner__c = acc2.id;
        prtnr.Role__c = 'Broker';
        prtnr.Primary__c = true;    
        
        
        listPrtnrs.add(prtnr);
        insert listPrtnrs;
        
        
        NPN_Check npn = new NPN_Check();
        npn.updateNPN(optyList);
        
        
        con.Phone = '1234546';
        con.Email = 'dfsc@ghj.com';
        update con;
        
    }
    
    static testMethod void testFSPGPRelatedList1() { 
        List<Opportunity> optyList = new List<Opportunity>();
        FSP_GP__c newFSP = new FSP_GP__c();
        Map<id, Opportunity_Contact_Role__c> ocrMap = new Map<id, Opportunity_Contact_Role__c>();
        
        Account acc = new Account();
        acc.name = 'Test Acc';
        //acc.name = 'Community_User_Account';//Failing in AccountUpdateForCommunityContact.UpdateAccountForCommunityContact: line 17, column 1
        //acc.Sic = '7377';
        //acc.Status__c = 'Active';
        acc.Type = 'Partner';
        acc.RecordTypeId = QueryBase.getRecordTypeId('Account','X51');
        //acc.Facets_Account_Number__c = '0X84';
        //acc.RecType_Facets_Account_Number__c = '2-50_0X84s';
        insert acc;
        
        Contact con =new Contact();
        con.FirstName= 'contact first name';
        con.LastName = 'contact last name';
        con.AccountId = acc.id;
        con.Phone = '364575678';
        con.Email = 'abcd@gnc.com';
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
        opp.Business_Type__c = 'Renewal';
        opp.Underwriting_Entity__c = 'DC';
        opp.FullServiceProducer__c = 'Kelly & Associates Insurance Group Inc';
        optyList.add(opp);
        insert optyList;
        
        List<Opportunity_Contact_Role__c> a = new List<Opportunity_Contact_Role__c>();
        Opportunity_Contact_Role__c oc = new Opportunity_Contact_Role__c();
        oc.Role__c = 'Primary Broker';
        oc.Opportunity__c= opp.id;
        oc.Contact_Name__c = con.id;
        oc.Primary__c = True;
        a.add(oc);
        Insert a;
        
        
        
        NPN_Check npn = new NPN_Check();
        npn.updateNPN(optyList);
        
        
        con.Phone = '1234546';
        con.Email = 'dfsc@ghj.com';
        update con;
        
    }
    
    
}