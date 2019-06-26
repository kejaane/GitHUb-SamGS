/*=================================================================================================
 * Date         : 08/27/2018
 * Developer    : Gayathri Palanisamy
 * Purpose      : This is the test class for 'AIA_Standard_Partner_Related_ListExt' class
 *=================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer         Tag     Description
 *============+=================+=====+============================================================
 *============+=================+=====+============================================================ 
 */
@isTest()
public class AIA_Standard_Partner_Related_ListTest {
@testsetup
    static void createTestData()
    {
        List<Account> accLst = new List<Account>();
        Account acc = new Account();
        acc.Name = 'Partner Account';
        acc.Type = 'Customer';
        accLst.add(acc);
        
        Account acc2 = new Account();
        acc2.Name = 'Test Account';
        acc2.Type = 'Partner';
        accLst.add(acc2);
        insert accLst;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2016, 3, 1);         
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';
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
        
        Partner__c newPartner = new Partner__c();
        newPartner.Partner__c = acc2.id;                
        newPartner.Opportunity__c = testOpp.Id;                
        newPartner.Primary__c = true;                
        newPartner.Effective_Date__c = date.newinstance(2016, 3, 1); 
        newPartner.End_Date__c = contractEndDate ; 
        newPartner.Role__c = 'Broker';
        insert newPartner;
    }
    
    public static testmethod void  getPartners()
    {
        Test.startTest();
        Partner p1= [Select Id from Partner Limit 1];
        system.assertNotEquals(p1,null);
        Account acc = [Select Id,Name from Account where Name = 'Partner Account' Limit 1];
        AIA_Standard_Partner_Related_ListExtn partnerRelatedList = new AIA_Standard_Partner_Related_ListExtn(new ApexPages.StandardController(acc));
        Test.stopTest();  
    }
    public static testmethod void  viewAllPartners()
    {
        Test.startTest();
        Partner p1= [Select Id from Partner Limit 1];
        system.assertNotEquals(p1,null);
        Account acc = [Select Id,Name from Account where Name = 'Partner Account' Limit 1];
        PageReference pref = Page.AIA_Standard_Partner_Related_List;
    	Test.setCurrentPage(pref);
        AIA_Standard_Partner_Related_ListExtn partnerRelatedList = new AIA_Standard_Partner_Related_ListExtn(new ApexPages.StandardController(acc));
        system.assertEquals(partnerRelatedList.enableTable,true);
        partnerRelatedList.enableAllRec();
        partnerRelatedList.goToAccount();
        Test.stopTest();  
    }
}