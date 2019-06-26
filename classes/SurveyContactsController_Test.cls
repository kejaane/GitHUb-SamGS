@isTest
public class SurveyContactsController_Test{
      
    static testMethod void Test1(){
            /* create user */
        User salesUser = [SELECT Name, Lead_Rep_Number__c 
                          FROM User 
                          WHERE Lead_Rep_Number__c != null Limit 1];
        
        
            /*Create Test Accounts*/
        Account acc1 = new Account();
        acc1.Name = 'TestAccount 1';
        acc1.Type = 'Customer';
        insert acc1;
        
            /*Create Test Contacts*/
        Contact con1 = new Contact();
        con1.LastName = 'Test1';
        con1.AccountId = acc1.Id;
        con1.Phone = '1111111111'; 
        con1.Email = 'Test1@carefirst.com';
        insert con1;
        
           /*Create Test Contacts*/
        Contact con2 = new Contact(); 
        con2.LastName = 'Test2'; 
        con2.AccountId = acc1.Id; 
        con2.Phone = '1111111111';  
        con2.Email = 'Test1@carefirst.com'; 
        insert con2; 

        
           /*Create Test Opportunities*/
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity1';
        testopp1.AccountId = acc1.Id;
        testOpp1.StageName ='Proposal';
        testOpp1.CloseDate = Date.today()-90;
//        testOpp1.Effective_Date__c = Date.today()-50;
        testOpp1.SBU__c = 'Small/Medium';
        testopp1.Market_Segment_New__c = '51-199';
        testopp1.Business_type__c = 'Renewal';
        testopp1.Division__c = '51-199 Renewals';   
        testopp1.Underwriting_Entity__c = 'MD';
        testopp1.Lead_Rep_Name_User__c = salesUser.Id;
        testOpp1.GeneralProducer__c = 'Direct'; 
        testOpp1.System__c = 'NASCO';    
        testOpp1.NASCO_Acct_ID__c = '12201'; 
//TPB - 12/19/2013        
        Date effectiveDate = testOpp1.CloseDate.addDays(32);        
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = effectiveDate+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp1.Contract_End_Date__c = contractEndDate;   
        
        insert testOpp1;  
        
              
           /*Create OpportunityContactRoles*/
        OpportunityContactRole testocr1 = new OpportunityContactRole();
        testocr1.Opportunityid = testOpp1.Id;
        testocr1.Contactid = con1.Id;
        testocr1.role = 'Broker';
        testocr1.isPrimary = True;
        insert testocr1;
                           
        Test.startTest();
            List<OpportunityContactRole> ocr1 = new List<OpportunityContactRole>();
            List<OpportunityContactRole> ocr2 = [SELECT ContactID, Contact.Name, Contact.Email, Contact.Phone FROM OpportunityContactRole WHERE OpportunityId = :testOpp1.Id];
            List<OpportunityContactRole> ContactRoleList = [SELECT ContactID, Contact.Name, Contact.Email, Contact.Phone FROM OpportunityContactRole WHERE OpportunityId = :testOpp1.Id]; 
            Set<id> idSet = new Set<id>();
            Map<id, OpportunityContactRole> ocrMap = new Map<id, OpportunityContactRole>();
            Map<id, id> scMap = new Map<id, id>();
            Map<id, id> crMap = new Map<id, id>();
            List<Survey_Contacts__c> scDeleteList = new List<Survey_Contacts__c>();
            List<Survey_Contacts__c> scUpdateList = new List<Survey_Contacts__c>();
            List<Survey_Contacts__c> scInsertList = new List<Survey_Contacts__c>();
            
            Survey_Contacts__c surv = new Survey_Contacts__c();
            surv.Contact__c = con2.id;
            surv.Phone__c = '1111111111';
            surv.Email__c = 'Test1@carefirst.com';
            surv.Opportunity__c = testOpp1.Id;
            scInsertList.add(surv);
            insert scInsertList;
              
            SurveyContactsController scc = new SurveyContactsController(new ApexPages.StandardController(testOpp1));
            scc.SurveyContactsController();
        Test.stopTest();
    }
}