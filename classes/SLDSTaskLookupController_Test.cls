@isTest
 Public class SLDSTaskLookupController_Test  {
 
 
  public static user createTestRecords(){
    
    User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
     LastName = 'last',
     Email = 'Test@Care.com',
     Username = 'Test@Care.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
    );
  
    insert u;
     return u;
 
  }

private static testMethod void generateUniqueComponentIdTest() {

   User u = new User();
   u= SLDSTaskLookupController_Test.createTestRecords();
   
   system.runAs(u){  
      
       
       SLDSTaskLookupController c=new SLDSTaskLookupController();
       c.Label = 'opportunity';
       c.objectName = 'Opportunity';         
       System.assertEquals('opportunity', c.uniqueComponentId);
       
    }
  
  }
    
    


private static testmethod void searchTest(){

   User u = new User();
   u= SLDSDynamicLookupControllerTest.createTestRecords();
   
   system.runAs(u){ 

        //Removing per Us210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'Renewal';
        wpt.Active__c=true;
        insert wpt;*/
            
        Account acct = new Account(); 
        acct.Name = 'Test10';
        acct.NumberOfEmployees = 45; // Num employees should always be <= 50
        acct.Sic = '0111';
        acct.EIN__c = '123456789'; // Has field validation, cannot be longer than 9 chars
        acct.BillingStreet = '1660 International Drive St. #518 Ste.500e ' +
        '1660 International Drive St. #518 Ste.500e' +
        '1660 International Drive St. #518 Ste.500e';
        acct.BillingCity = 'McLean123456789012345678902345678901';
        acct.BillingState = 'VA';
        acct.BillingPostalCode = '22102-4501'; // Has a validation rule in place 
        //acct.Billing_County_Code__c = 'MD';
        acct.Renewal_Anniversary_Month__c = 'Nov';
        acct.Account_Legal_Name__c= 'test Account';
        insert acct;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = Acct.Id;
        opp.Market_Segment_New__c = '51-199';
        opp.Business_type__c = 'Renewal';
        opp.Division__c = '51-199 New Business';
        opp.Legal_Account_Name_Verified__c =true;
        opp.Underwriting_Entity__c = 'NCAS';
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        //opp.Workplan_Type__c = wpt.id;
        insert opp;
                  
        
        
        //List<SLDSTaskLookupController.Wrapper> lst2 = SLDSTaskLookupController.search('opportunity', 'Account.name','Name2','url->www.google.com','Test');
   
List<SLDSTaskLookupController.Wrapper> lst3 = SLDSTaskLookupController.search('opportunity', 'Account.name','Name','url->www.google.com','Test');
List<SLDSTaskLookupController.Wrapper> lst4 = SLDSTaskLookupController.search('opportunity', 'Account.name','Name','field->Name','Test');
     
        }
    

 
 
     
    }

 
 }