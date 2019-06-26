/*------------------------------------------------------------------------------------
 *                      ----===[ HISTORY ]===---
 * Date        Developer        Description
 *------------------------------------------------------------------------------------
 * 12/06/2012 Varun Nagarajan   Modified code where Business__c has been replaced with
                                Business_Type__c matching today's world requirements 
 *                              at CareFirst.  
 
 *06/27/2014 Ashish Ojha         Renamed Profile name from 
 *                              Standard user - Custom to Id = '00e60000000oSNM' 
 *************************************************************************************
 */
 
@isTEST
private class CFCT_ProcessManager_TEST {
    static testMethod void test_ownerLeadRepNoMatchEmailUsers_1() {
        //logged in as admin test and complete CFCT_QueryBase class test
        Profile p = [select id from profile where Id = '00e60000000oSNM'];
        User u = new User(alias = 'stduser2', email='standardUser1xyz@testorg.com',
        emailencodingkey='UTF-8', lastname='StandardUser1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, Lead_Rep__c = true,
        timezonesidkey='America/Los_Angeles', username='standarduser1xyz@testorg.com');        
        /* create another user to use as a lead rep */
        User u2 = new User(alias = 'leadRep', email='LeadRepUser@testorg.com',
        emailencodingkey='UTF-8', lastname='LeadRepTesting', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, Lead_Rep__c = true,
        timezonesidkey='America/Los_Angeles', username='LeadRepUser@testorg.com'); 
        System.runAs(u) {
          //  System.Assert(CFCT_QueryBase.adminLoggedIn() == true, true);            
                      
            /* create account */  
            Account testAcc = new Account();
            testAcc.Name = 'Test Account';
            testAcc.OwnerId  = u.Id;     
            insert testAcc ;    
            /* create opportunity */
            Opportunity testOpp = new Opportunity();
            Date closedDate = date.newinstance(1900, 1, 1);
            Date EffectiveDate = date.newinstance(2050, 1, 1);            
            testOpp.Name = 'Test123 Opportunity';
            testOpp.AccountId = testAcc.Id ;
            testOpp.OwnerId = u.Id;
            testOpp.Lead_Rep_Name_User__c = u2.id;
            testOpp.StageName ='Proposal';
            testOpp.CloseDate = closedDate;
            testOpp.Effective_Date__c =  EffectiveDate;
            testOpp.GeneralProducer__c = 'Direct';
            //testOpp.Business__c = 'National Renewal Sales';   
            testOpp.Business_Type__c = 'Renewal';    
//TPB - 12/19/2013       
            testOpp.Effective_Date__c = EffectiveDate;
            Date contractEndDate = EffectiveDate+366;
            contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
            contractEndDate = contractEndDate.addDays(-1);
            testOpp.Contract_End_Date__c = contractEndDate;   
                         
            insert testOpp ;
            
            List<Opportunity> oppList = [ Select id, name, owner.id, owner.email, 
                                           owner.Name, Lead_Rep_Name_User__c
                                    From Opportunity
                                    Where Name = 'Test123 Opportunity' ];
            
            System.Assert(oppList.size() == 1, true);
            
            Test.StartTest();            
            CFCT_ProcessorManager.ownerLeadRepNoMatchEmailUsers(oppList);
            CFCT_ProcessorManager.opportunitiesWithoutPartnersEmailUsers(oppList);            
            CFCT_ProcessorManager.getDomainURL();
// AO 03/09/2015
            
            CFCT_ProcessorManager.BuildEmail(oppList[0].owner.id,'test date','<br/>htmlbody');
            CFCT_ProcessorManager.opportunitiesInProposalEmailUsers_200Plus(oppList);
            CFCT_ProcessorManager.opportunitiesInProposalEmailUsers_51to199(oppList);
            Test.StopTest();
        }
    }  
}