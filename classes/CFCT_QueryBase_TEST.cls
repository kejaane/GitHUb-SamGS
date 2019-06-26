//=========================================================================================
//      Date: 11/02/2011
// Developer: Tom Barrett (TPB)
//   Purpose: This test class is used primarily test the CFCT_QueryBase class
//
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
// 07/01/2016 TPB            Updated to include testing the new 200+ record type
//=========================================================================================

@isTEST
private class CFCT_QueryBase_TEST {

    static testMethod void testAdminLoggedIn_1() {
        //logged in as admin test and complete CFCT_QueryBase class test
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User(alias = 'admin', email='adminuser1@testorg.com',
        emailencodingkey='UTF-8', lastname='adminTesting', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='adminuser1@testorg.com');
        System.runAs(u) {
            System.Assert(CFCT_QueryBase.adminLoggedIn() == true, true);            
            /* create another user to use as a lead rep */
            User u2 = new User(alias = 'leadRep', email='LeadRepUser@testorg.com',
            emailencodingkey='UTF-8', lastname='LeadRepTesting', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, Lead_Rep__c = true,
            timezonesidkey='America/Los_Angeles', username='LeadRepUser@testorg.com');            
            
            /* create account */  
            Account testAcc = new Account();
            testAcc.Name = 'Test Account';
            testAcc.OwnerId  = u.Id;     
            insert testAcc ;   
            List<Opportunity> oppList = new List<Opportunity>(); //BEGIN CHANGE TPB 07/01/2016
            /* create 51+ record type opportunity */
            Opportunity testOpp = new Opportunity();            
            Date closedDate = date.newinstance(1900, 1, 1);
            Date EffectiveDate = date.newinstance(2050, 1, 1);
            testOpp.RecordTypeId = QueryBase.getRecordTypeId('Opportunity', 'X51');            
            testOpp.Name = 'Test Opportunity';
            testOpp.AccountId = testAcc.Id ;
            testOpp.OwnerId = u.Id;
            testOpp.Lead_Rep_Name_User__c = u2.id;
            testOpp.StageName ='Proposal';
            testOpp.CloseDate = closedDate;
            testOpp.Effective_Date__c =  EffectiveDate;
//TPB 12/20/12 testOpp.Business__c = 'National Renewal Sales';
            testOpp.Business_Type__c = 'Renewal';  
            testOpp.GeneralProducer__c = 'Direct';   
//TPB 12/19/13
            testOpp.Contract_End_Date__c = date.newinstance(2050, 1, 31);   
            
//BEGIN CHANGE TPB 07/01/2016            
            //insert testOpp ;
            oppList.add(testOpp); 
            
            /* create 200+ record type opportunity */
            Opportunity testOpp2 = new Opportunity();  
            testOpp2.RecordTypeId = QueryBase.getRecordTypeId('Opportunity', 'AIA_200');          
            testOpp2.Name = 'Test Opportunity';
            testOpp2.AccountId = testAcc.Id ;
            testOpp2.OwnerId = u.Id;
            testOpp2.Lead_Rep_Name_User__c = u2.id;
            testOpp2.StageName ='Proposal';
            testOpp2.CloseDate = date.newinstance(1900, 1, 1);
            testOpp2.Effective_Date__c =  date.newinstance(2050, 1, 1);
            testOpp2.Business_Type__c = 'Renewal';  
            testOpp2.GeneralProducer__c = 'Direct';
            testOpp2.Contract_End_Date__c = date.newinstance(2050, 1, 31); 
            oppList.add(testOpp2);           
             
            insert oppList;            
//END CHANGE 
                        
            /* test QueryBase class */
            CFCT_QueryBase.getOppsCurUserOwnsDateLimit(); 
            CFCT_QueryBase.getOppsDateLimit();  
            CFCT_QueryBase.getOppsCurUserOwnsDateLimitWithoutPartners() ; 
            CFCT_QueryBase.getOppsDateLimitWithoutPartners(); 
            
            
             /* prep for email template test */            
            List<Folder> lstFolder = [ Select Id From Folder Where Name = 'ForTestingDoNotRemove' ];                                          
            if( lstFolder.size() > 0 ) {
                Test.StartTest();
                //Document document = new Document(FolderId = lstFolder.get(0).Id, Name='ForTestingDoNotRemove',Keywords = 'Test');
                EmailTemplate e = [ Select Name From EmailTemplate Where FolderId = :lstFolder.get(0).Id Limit 1 ];                                
                CFCT_QueryBase.getTemplateId(e.name);
                Test.StopTest();   
            }                
        }
    }
    
    static testMethod void testAdminLoggedIn_2() {
        // standard user test
        Profile p = [select id from profile where name='Standard User'];
        User u = new User(alias = 'standrt', email='standarduser@testorg.com',
        emailencodingkey='UTF-8', lastname='testingStandard', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='testingStandard@testorg.com');
        System.runAs(u) {
            Test.StartTest();
            System.Assert(CFCT_QueryBase.adminLoggedIn() == false, true);
            Test.StopTest();
        }
    }    
//AO Changes 03/09/2015
// Created new method
    
    static testMethod void testAdminLoggedIn_3() {
        //logged in as admin test and complete CFCT_QueryBase class test
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User(alias = 'admin', email='adminuser1@testorg.com',
        emailencodingkey='UTF-8', lastname='adminTesting', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='adminuser1@testorg.com');
        System.runAs(u) {
            System.Assert(CFCT_QueryBase.adminLoggedIn() == true, true);            
            /* create another user to use as a lead rep */
            User u2 = new User(alias = 'leadRep', email='LeadRepUser@testorg.com',
            emailencodingkey='UTF-8', lastname='LeadRepTesting', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, Lead_Rep__c = true,
            timezonesidkey='America/Los_Angeles', username='LeadRepUser@testorg.com');            
            
            /* create account */  
            Account testAcc = new Account();
            testAcc.Name = 'Test Account';
            testAcc.OwnerId  = u.Id;             
            insert testAcc ;    
            
            /* create 51+ record type opportunity */
            List<Opportunity> oppList = new List<Opportunity>(); //BEGIN CHANGE TPB 07/01/2016
            String RtId = querybase.getRecordtypeId('Opportunity', 'X51');
            Opportunity testOpp = new Opportunity();
            Date closedDate = date.newinstance(1900, 1, 1);
            Date EffectiveDate = date.newinstance(2050, 1, 1);            
            testOpp.Name = 'Test Opportunity';
            testOpp.AccountId = testAcc.Id ;
            testOpp.OwnerId = u.Id;
            testOpp.Lead_Rep_Name_User__c = u2.id;
            testOpp.StageName ='Proposal';
            testOpp.CloseDate = closedDate;
            testOpp.Effective_Date__c =  EffectiveDate;
            testOpp.Business_Type__c = 'New';  
            testOpp.GeneralProducer__c = 'Direct';   
            testOpp.Contract_End_Date__c = date.newinstance(2050, 1, 31); 
            testOpp.Market_Segment_New__c = '200-999';
            testOpp.RecordTypeId = RtId ;
            
//BEGIN CHANGE TPB 07/01/2016            
            //insert testOpp ;
            oppList.add(testOpp);  
            
            /* create 200+ record type opportunity */
            Opportunity testOpp2 = new Opportunity();  
            testOpp2.RecordTypeId = QueryBase.getRecordTypeId('Opportunity', 'AIA_200');          
            testOpp2.Name = 'Test Opportunity';
            testOpp2.AccountId = testAcc.Id ;
            testOpp2.OwnerId = u.Id;
            testOpp2.Lead_Rep_Name_User__c = u2.id;
            testOpp2.StageName ='Proposal';
            testOpp2.CloseDate = date.newinstance(1900, 1, 1);
            testOpp2.Effective_Date__c =  date.newinstance(2050, 1, 1);
            testOpp2.Business_Type__c = 'New';  
            testOpp2.GeneralProducer__c = 'Direct';
            testOpp2.Contract_End_Date__c = date.newinstance(2050, 1, 31); 
            oppList.add(testOpp2);            
             
            insert oppList;
//END CHANGE   
            
            CFCT_QueryBase.getOppsCurUserOwnsDateLimit(); 
            CFCT_QueryBase.getOppsDateLimit();  
            CFCT_QueryBase.getOppsCurUserOwnsDateLimitWithoutPartners() ; 
            CFCT_QueryBase.getOppsDateLimitWithoutPartners(); 
            CFCT_QueryBase.getOppsInProposalFor_200Plus();
            CFCT_QueryBase.getOppsInProposalFor_51to199();

             /* prep for email template test */            
            List<Folder> lstFolder = [ Select Id From Folder Where Name = 'ForTestingDoNotRemove' ];                                          
            if( lstFolder.size() > 0 ) {
                Test.StartTest();
                //Document document = new Document(FolderId = lstFolder.get(0).Id, Name='ForTestingDoNotRemove',Keywords = 'Test');
                EmailTemplate e = [ Select Name From EmailTemplate  Limit 1 ];                                
                CFCT_QueryBase.getTemplateId(e.name);
                Test.StopTest();   
            }                
        }
    }
}