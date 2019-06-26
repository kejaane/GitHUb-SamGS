/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
//===================================================================================
//Date: 06/18/2016
//Developer: Goutham Rapolu
//Purpose: Test class for AIADocumentUploadController. The following test class
//         tests uploading of documents for the following objects:
//         1. Account
//         2. Opportunity
//         3. PRF
//         4. BRF
//         5. Proposed Product - failing
//         6. Implementation
//         7. Benefit Design
//         8. Contracts - Sandip to check with Virgilio
//         9. Workplan Assignment -- We are using a different VF page to upload the AIA Document in Workplan Assignment Object. AIA_WorkAssignmentFileUploadCX
//==================================================================================
// Update History
// Date         Developer               	Description
// 
//==================================================================================
//06/18/2016    Goutham Rapolu     			Initial Development
//1/17/2018 	Chaithra 		T01			Added account team roles as per US1702 and US1730
//2/4/2019 		Chaithra		T02			Replacing AccountTeamMember with custom object as part of US6713
//==================================================================================

@isTest
private class AIADocumentUploadController_Test {

// TODO: 6/22 - Add testmethod for Workplan Assignment
// TODO: 6/22 - Add testmethod to run as RUL user
// TODO: 6/22 - Add assert statement to validate that document uploaded successfully
   
    Public static testmethod void TestAccount() {
        Test.startTest();
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
         User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {
              /*Rajes changes start
              //Create Custom setting Picklist values for Account Object
              Document_Type_Values__c obj = new Document_Type_Values__c();
              obj.Account__c = true;
              obj.Pick_List_Value__c = 'BlueFund';
              obj.Name = 'Document Type Value 1';
              insert obj;
              Rajesh changes end */
             // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             
             aiaDocList.add(aiaDoc);
             
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount'); 
             //system.assertNotEquals(null,a.id);
             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');
             
             Apexpages.Currentpage().getParameters().put('id',a.id);
             ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
             AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
             controllerObj.processUpload();
              controllerObj.getIsClassic();
             Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
             controllerObj.cancelButton();  
             
             Attachment att = [select id from Attachment where id =: at.ID];
             system.assertNotEquals(null,att.id);
             // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
             Test.stopTest();
          }      
    }
    
    Public static testmethod void TestOpportunity() {
        Test.startTest();
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
         User u = AIA_TestUtil.createTestUser();
         System.runAs(u) { 
             /*Rajes changes start
             //Create Custom setting Picklist values for Account Object
              Document_Type_Values__c obj = new Document_Type_Values__c();
              obj.Opportunity__c = true;
              obj.Pick_List_Value__c = 'BlueFund';
              obj.Name = 'Document Type Value 1';
              insert obj;
              Rajesh changes end */
             // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             aiaDocList.add(aiaDoc); 

             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');
             
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             Apexpages.Currentpage().getParameters().put('id',o.id);
             ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
             AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
             controllerObj.processUpload();
             Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
             controllerObj.cancelButton();
             
             Attachment att = [select id from Attachment where id =: at.ID];
             system.assertNotEquals(null,att.id);
             // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
             Test.stopTest();
         }
    }
    
  
    Public static testmethod void TestBenfitRequestForm() {
        Test.startTest();
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
         User u = AIA_TestUtil.createTestUser();
         System.runAs(u) {
             /*Rajes changes start
             //Create Custom setting Picklist values for Account Object
              Document_Type_Values__c obj = new Document_Type_Values__c();
              obj.Benfit_Request_Form__c = true;
              obj.Pick_List_Value__c = 'BlueFund';
              obj.Name = 'Document Type Value 1';
              insert obj; 
              Rajesh changes end */ 
            // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             aiaDocList.add(aiaDoc);
             
             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');

             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             //system.assertNotEquals(null,a.id);
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             //system.assertNotEquals(null,o.id);
             
             // Create PRF
             Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
     //   brf.Control_Plan__c='MD';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
        
             Apexpages.Currentpage().getParameters().put('id',brf.id);
             ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
             AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
             controllerObj.processUpload();
             Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
             controllerObj.cancelButton();
             
             Attachment att = [select id from Attachment where id =: at.ID];
             system.assertNotEquals(null,att.id);
             // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
             Test.stopTest();
         }
    }
    
   Public static testmethod void TestPRF(){
       Test.startTest();
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
         User u = AIA_TestUtil.createTestUser();
         System.runAs(u) { 
             /*Rajes changes start
             //Create Custom setting Picklist values for Account Object
              Document_Type_Values__c obj = new Document_Type_Values__c();
              obj.PRF__c = true;
              obj.Pick_List_Value__c = 'BlueFund';
              obj.Name = 'Document Type Value 1';
              insert obj;
              Rajesh changes end */
            // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             aiaDocList.add(aiaDoc);

             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');
              
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             //system.assertNotEquals(null,a.id);
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             // Create PRF
             PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
             system.assertNotEquals(null,p.id);
             Apexpages.Currentpage().getParameters().put('id',p.id);
             ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
             AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
             controllerObj.processUpload();
             Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
             controllerObj.cancelButton();
             
             Attachment att = [select id from Attachment where id =: at.ID];
             system.assertNotEquals(null,att.id);
             // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
             Test.stopTest();
         }
    }
    
    Public static testmethod void TestAIAImplementation() {
        Test.startTest();
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
         User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {
              /*Rajes changes start
              //Create Custom setting Picklist values for Account Object
              Document_Type_Values__c obj = new Document_Type_Values__c();
              obj.AIA_Implementation__c = true;
              obj.Pick_List_Value__c = 'BlueFund';
              obj.Name = 'Document Type Value 1';
              insert obj;
              Rajesh changes end */    
             // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             aiaDocList.add(aiaDoc);

             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');
             
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount'); 
             system.assertNotEquals(null,a.id);
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             AIA_Implementation__c aiaImp = AIA_TestUtil.CreateImp(o.id);
             system.assertNotEquals(null,aiaImp.id);
             Apexpages.Currentpage().getParameters().put('id',aiaImp.id);
             ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
             AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
             controllerObj.processUpload();
             Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
             controllerObj.cancelButton();  
             
             Attachment att = [select id from Attachment where id =: at.ID];
             system.assertNotEquals(null,att.id);
             // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
             test.stopTest();
          }      
    }
    
 
    Public static testmethod void TestProposedProducts() {
        Test.startTest();
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
         User u = AIA_TestUtil.createTestUser();
          System.runAs(u) { 
              /*Rajes changes start
              //Create Custom setting Picklist values for Account Object
              Document_Type_Values__c obj = new Document_Type_Values__c();
              obj.Proposed_Products__c = true;
              obj.Pick_List_Value__c = 'BlueFund';
              obj.Name = 'Document Type Value 1';
              insert obj; 
              Rajesh changes end */   
             // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             aiaDocList.add(aiaDoc);

             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');
             
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             // Create PRF
         Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
     //   brf.Control_Plan__c='MD';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
                     List<Proposed_Products__c> aiaPPList = AIA_TestUtil.createListProposedProductsForASO(brf.id,'Pass');
             system.assertNotEquals(0,aiaPPList.size());
             Apexpages.Currentpage().getParameters().put('id',aiaPPList[0].id);
             ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
             AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
             controllerObj.processUpload();
             Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
             controllerObj.cancelButton();  
             
             Attachment att = [select id from Attachment where id =: at.ID];
             system.assertNotEquals(null,att.id);
             // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
             Test.stopTest();
          }      
    }
    
    
    Public static testmethod void TestAIABenefitDesign() {
       
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
        //List <user> userlist= new List<User>(); T02
        //List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>(); T02
        List<Account_Team__c> AccountTeamMemberList= new List<Account_Team__c>();
         Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom']; 
         User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {    
              /*Rajes changes start
              //Create Custom setting Picklist values for Account Object
              Document_Type_Values__c obj = new Document_Type_Values__c();
              obj.AIA_Benefit_Design__c = true;
              obj.Pick_List_Value__c = 'BlueFund';
              obj.Name = 'Document Type Value 1';
              insert obj;
              Rajesh changes end */ 
             // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             aiaDocList.add(aiaDoc);
             
             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');

             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             
        User u5 = new User(Alias = 'TAlias2', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
        insert u5;
        /*T02 Commented      
         //T01 starts
        User u1 = AIA_TestUtil.AIA_createUser('alias120');
        userlist.add(u1);
        User u2 = AIA_TestUtil.AIA_createUser('alias131');
        userlist.add(u2);
        User u3 = AIA_TestUtil.AIA_createUser('alias142');
        userlist.add(u3);
        User u4 = AIA_TestUtil.AIA_createUser('alias153');
        userlist.add(u4);
        //T01 ends
        insert userlist;
        
         AccountTeamMember atm2 = new AccountTeamMember ();
        atm2.TeamMemberRole = 'Contract Tech';
        atm2.AccountId = a.id;
        atm2.UserId = u5.id;
        AccountTeamMemberList.add(atm2);
        
              //T01 starts
            AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Benefit Tester';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = u2.id;
            AccountTeamMemberList.add(atmRole3);
     
     		AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'Pharmacy Operations';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = u.id;
            AccountTeamMemberList.add(atmRole4);
            
            AccountTeamMember atmRole5 = new AccountTeamMember ();
     		atmRole5.TeamMemberRole = 'Vision Analyst';
            atmRole5.AccountId =a.id;
            atmRole5.UserId = u3.id;
            AccountTeamMemberList.add(atmRole5);
            
            AccountTeamMember atmRole6 = new AccountTeamMember ();
     		atmRole6.TeamMemberRole = 'Benefit Coder';
            atmRole6.AccountId =a.id;
            atmRole6.UserId = u4.id;
            AccountTeamMemberList.add(atmRole6);*/
              
            Account_Team__c atm2 = new Account_Team__c ();
        	atm2.TeamMemberRole__c = 'Contract Tech';
        	atm2.AccountId__c = a.id;
        	atm2.UserId__c = u5.id;
        	AccountTeamMemberList.add(atm2);
            //T02 changes ends
            insert AccountTeamMemberList;
           
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             test.starttest();
             
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Account__c=a.id;
            brf.Request_Type__c='Prospect/New';
            brf.Benefit_Effective_Date__c   = system.today();
            brf.Benefit_Period__c='Calendar';
            brf.Jurisdiction__c ='VA';
            brf.Sales_Segment_Size__c = 'Labor';
            brf.Contract_Period__c = 'Standard - 12 Months';
            brf.Grandfathered_Status__c  = 'Grandfathered';
            brf.Broker_Commission__c = 3.5;
            brf.Contract_Count__c = 20;
            brf.Funding_Arrangements__c = 'Both'; 
            brf.opportunity__c  = o.id;  
            insert brf;
             
            // AIA_Benefit_Design__c aiaBD = AIA_TestUtil.createBenefitDesign(o.id,a.id);
            // system.assertNotEquals(null,aiaBD.id);
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.Id;
            Imp.Account__c = a.Id;
            Imp.Benefit_Request_Form__c = brf.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            insert Imp;
            

            
            AIA_Benefit_Design__c aiaBD1 = new AIA_Benefit_Design__c();
            aiaBD1.Implementation__c = Imp.id;
            aiaBD1.Account__c = a.Id;
            aiaBD1.Benefit_Request_Form__c = brf.Id;
            insert aiaBD1;
       
             Apexpages.Currentpage().getParameters().put('id',aiaBD1.id);
             ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
             AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
             controllerObj.processUpload();
             controllerObj.saveStandardAttachment();
             
             Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
              
              
            controllerObj.cancelButton();  
              
           
             Attachment att = [select id from Attachment where id =: at.ID];
             system.assertNotEquals(null,att.id);
             test.stoptest();  
             // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
          }      
    }
    
    Public static testmethod void TestAIAGSRF() {
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
         Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom']; 
         User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {    
              /*Rajes changes start
              //Create Custom setting Picklist values for Account Object
              Document_Type_Values__c obj = new Document_Type_Values__c();
              obj.AIA_Benefit_Design__c = true;
              obj.Pick_List_Value__c = 'BlueFund';
              obj.Name = 'Document Type Value 1';
              insert obj;
              Rajesh changes end */ 
             // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             aiaDocList.add(aiaDoc);
             
             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');

             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
      /*R1 Changes*/ a.National_or_Local__c= 'National';
                    update a; 
             system.assertNotEquals(null,a.id);
             
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
        insert u2;
        User u3 = new User(Alias = 'TAlias2', Email='TestUserBRF4@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF4@testorg.com.test');
        insert u3;
        User u4 = new User(Alias = 'TAlias2', Email='TestUserBRF5@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF5@testorg.com.test');
        insert u4;
        User u5 = new User(Alias = 'TAlias2', Email='TestUserBRF6@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF6@testorg.com.test');
        insert u5;
        User u6 = new User(Alias = 'TAlias2', Email='TestUserBRF7@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF7@testorg.com.test');
        insert u6;

         User u7 = new User(Alias = 'TAlias7', Email='TestUserBRF8@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF8@testorg.com.test');
        insert u7;
        // T02 replaced all below std AccountTeamMember with Account_Team__c 
        Account_Team__c atm2 = new Account_Team__c ();
        atm2.TeamMemberRole__c = 'Contract Tech';
        atm2.AccountId__c = a.id;
        atm2.UserId__c = u2.id;
        insert atm2;
        Account_Team__c atm3 = new Account_Team__c ();
        atm3.TeamMemberRole__c = 'Implementation Manager';
        atm3.AccountId__c = a.id;
        atm3.UserId__c = u3.id;
        insert atm3;
        Account_Team__c atm4 = new Account_Team__c ();
        atm4.TeamMemberRole__c = 'Billing Tech';
        atm4.AccountId__c = a.id;
        atm4.UserId__c = u4.id;
        insert atm4;
        Account_Team__c atm5 = new Account_Team__c ();
        atm5.TeamMemberRole__c = 'Settlements Analyst';
        atm5.AccountId__c = a.id;
        atm5.UserId__c = u5.id;
        insert atm5;
        Account_Team__c atm6 = new Account_Team__c ();
        atm6.TeamMemberRole__c = 'Automated Enrollment Tech';
        atm6.AccountId__c = a.id;
        atm6.UserId__c = u6.id;
        insert atm6;
        //T02 Ends
        
        /**AccountTeamMember atm7 = new AccountTeamMember ();
        atm7.TeamMemberRole = 'Implementation Manager';
        atm7.AccountId = a.id;
        atm7.UserId = u7.id;
        insert atm7**/
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             test.starttest();
             
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Account__c=a.id;
            brf.Request_Type__c='Prospect/New';
            brf.Benefit_Effective_Date__c   = system.today();
            brf.Benefit_Period__c='Calendar';
            brf.Jurisdiction__c ='VA';
            brf.Sales_Segment_Size__c = 'Labor';
            brf.Contract_Period__c = 'Standard - 12 Months';
            brf.Grandfathered_Status__c  = 'Grandfathered';
            brf.Broker_Commission__c = 3.5;
            brf.Contract_Count__c = 20;
            brf.Funding_Arrangements__c = 'Both'; 
            brf.opportunity__c  = o.id;  
            insert brf;
             
            // AIA_Benefit_Design__c aiaBD = AIA_TestUtil.createBenefitDesign(o.id,a.id);
            // system.assertNotEquals(null,aiaBD.id);
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.Id;
            Imp.Account__c = a.Id;
            Imp.Benefit_Request_Form__c = brf.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            try{
            insert Imp;
              }catch(Exception e){}
            AIA_Group_Structure_Request_Form__c gsrf = new AIA_Group_Structure_Request_Form__c();
            gsrf.Implementation__c = Imp.id;
            gsrf.Status__c = 'Draft - New';
            gsrf.Processing_Type__c = 'Standard';
            gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 580 for DC'; 
             // gsrf.Level_of_Participation__c ='Full Service'; // T01
           //  gsrf.National_or_Local__c = 'National';
             /*R1 changes */ gsrf.Is_it_a_National_Account_With_Par_Plans__c = true;
              
            insert gsrf;
       
             Apexpages.Currentpage().getParameters().put('id',gsrf.id);
             ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
             AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
             controllerObj.processUpload();
             controllerObj.saveStandardAttachment();
             
             Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
              
              
            controllerObj.cancelButton();  
              controllerObj.returnToOpp();
              controllerObj.liprocessUpload();
           
             Attachment att = [select id from Attachment where id =: at.ID];
             system.assertNotEquals(null,att.id);
             test.stoptest();  
             // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
          }      
    }
    
    Public static testmethod void TestAIABenefitDesignProduct() {
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
        //List <user> userlist= new List<User>();
        //List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>(); t02
         List<Account_Team__c> AccountTeamMemberList= new List<Account_Team__c>();
         Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom']; 
         User u = AIA_TestUtil.createTestUser();
         System.runAs(u) {    
              /*Rajes changes start
              //Create Custom setting Picklist values for Account Object
              Document_Type_Values__c obj = new Document_Type_Values__c();
              obj.AIA_Benefit_Design__c = true;
              obj.Pick_List_Value__c = 'BlueFund';
              obj.Name = 'Document Type Value 1';
              insert obj;
              Rajesh changes end */ 
             // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             aiaDocList.add(aiaDoc);
             
             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');

             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             
        User u5 = new User(Alias = 'TAlias2', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
        insert u5;
            
        //T02 replaced std object AccountTeamMember with custom obj Account_Team__c
         Account_Team__c atm2 = new Account_Team__c ();
        atm2.TeamMemberRole__c = 'Contract Tech';
        atm2.AccountId__c = a.id;
        atm2.UserId__c = u5.id;
        AccountTeamMemberList.add(atm2);
        //T02 Ends    
            insert AccountTeamMemberList;
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             test.starttest();
             
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Account__c=a.id;
            brf.Request_Type__c='Prospect/New';
            brf.Benefit_Effective_Date__c   = system.today();
            brf.Benefit_Period__c='Calendar';
            brf.Jurisdiction__c ='VA';
            brf.Sales_Segment_Size__c = 'Labor';
            brf.Contract_Period__c = 'Standard - 12 Months';
            brf.Grandfathered_Status__c  = 'Grandfathered';
            brf.Broker_Commission__c = 3.5;
            brf.Contract_Count__c = 20;
            brf.Funding_Arrangements__c = 'Both';   
            brf.opportunity__c  = o.id;
            insert brf;
             
            // AIA_Benefit_Design__c aiaBD = AIA_TestUtil.createBenefitDesign(o.id,a.id);
            // system.assertNotEquals(null,aiaBD.id);
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.Id;
            Imp.Account__c = a.Id;
            Imp.Benefit_Request_Form__c = brf.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            insert Imp;
            
            AIA_Benefit_Design__c aiaBD1 = new AIA_Benefit_Design__c();
            aiaBD1.Implementation__c = Imp.id;
            aiaBD1.Account__c = a.Id;
            aiaBD1.Benefit_Request_Form__c = brf.Id;
            insert aiaBD1;
            
            AIA_Plan__c pln = AIA_TestUtil.CreatePlan('test');
            
            Proposed_Products__c app = AIA_TestUtil.createProposedProducts(brf.id);
            
            AIA_Benefit_Design_Product__c abdp = AIA_TestUtil.createBDProductsForBD(aiaBD1, 'Medical', pln.Id, app.id);
            insert abdp;
            system.assertNotEquals(NULL, abdp.Id);
            
            Apexpages.Currentpage().getParameters().put('id',abdp.id);
            ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
            AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
            controllerObj.fileBody = cvBlob;
            controllerObj.fileName = 'TestDoc.pdf';
            controllerObj.description = 'test Document';
            controllerObj.processUpload();
            controllerObj.saveStandardAttachment();
            Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
            controllerObj.cancelButton();  
            
            Attachment att = [select id from Attachment where id =: at.ID];
            system.assertNotEquals(null,att.id);
            test.stoptest();  
            // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
          }      
    }
    
    Public static testmethod void TestAIABenefitDesignForm() {
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
        //List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>(); T02
        List<Account_Team__c> AccountTeamMemberList= new List<Account_Team__c>();
         Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom']; 
         User u = AIA_TestUtil.createTestUser();
         System.runAs(u) {    
              /*Rajes changes start
              //Create Custom setting Picklist values for Account Object
              Document_Type_Values__c obj = new Document_Type_Values__c();
              obj.AIA_Benefit_Design__c = true;
              obj.Pick_List_Value__c = 'BlueFund';
              obj.Name = 'Document Type Value 1';
              insert obj;
              Rajesh changes end */ 
             // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             aiaDocList.add(aiaDoc);
             
             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');

             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             
        User u5 = new User(Alias = 'TAlias2', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
        insert u5;
       
        //T02 changes starts
        Account_Team__c atm2 = new Account_Team__c ();
        atm2.TeamMemberRole__c = 'Contract Tech';
        atm2.AccountId__c = a.id;
        atm2.UserId__c = u5.id;
         AccountTeamMemberList.add(atm2);
            
            insert AccountTeamMemberList;
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             test.starttest();
             
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Account__c=a.id;
            brf.Request_Type__c='Prospect/New';
            brf.Benefit_Effective_Date__c   = system.today();
            brf.Benefit_Period__c='Calendar';
            brf.Jurisdiction__c ='DC';
            brf.Sales_Segment_Size__c = 'Labor';
            brf.Contract_Period__c = 'Standard - 12 Months';
            brf.Grandfathered_Status__c  = 'Grandfathered';
            brf.Broker_Commission__c = 3.5;
            brf.Contract_Count__c = 20;
            brf.Funding_Arrangements__c = 'Both';   
            brf.opportunity__c  = o.id;
            insert brf;
             
            // AIA_Benefit_Design__c aiaBD = AIA_TestUtil.createBenefitDesign(o.id,a.id);
            // system.assertNotEquals(null,aiaBD.id);
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.Id;
            Imp.Account__c = a.Id;
            Imp.Benefit_Request_Form__c = brf.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            insert Imp;
            
            AIA_Benefit_Design__c aiaBD1 = new AIA_Benefit_Design__c();
            aiaBD1.Implementation__c = Imp.id;
            aiaBD1.Account__c = a.Id;
            aiaBD1.Benefit_Request_Form__c = brf.Id;
            insert aiaBD1;
            
            AIA_Plan__c pln = AIA_TestUtil.CreatePlan('test');
            
            Proposed_Products__c app = AIA_TestUtil.createProposedProducts(brf.id);
            
            AIA_Benefit_Design_Product__c abdp = AIA_TestUtil.createBDProductsForBD(aiaBD1, 'Medical', pln.Id, app.id);
            insert abdp;
            system.assertNotEquals(NULL, abdp.Id);
            
            //AIA_Benefit_Design_Form__c abdf = AIA_TestUtil.createBenefitDesignFormForBD(aiaBD1,'Domestic_Partner',abdp.Id);
            AIA_Benefit_Design_Form__c abdf = AIA_TestUtil.createBenefitDesignFormForBD(aiaBD1,'Admin',abdp.Id);
            //system.assertNotEquals(NULL, abdf.Id);
            
            Apexpages.Currentpage().getParameters().put('id',abdf.id);
            ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
            AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
            controllerObj.fileBody = cvBlob;
            controllerObj.fileName = 'TestDoc.pdf';
            controllerObj.description = 'test Document';
            controllerObj.processUpload();
            controllerObj.saveStandardAttachment();
            Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
            controllerObj.cancelButton();  
            
            Attachment att = [select id from Attachment where id =: at.ID];
            system.assertNotEquals(null,att.id);
            test.stoptest();  
            // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
          }      
    }
    
    Public static testmethod void TestContract() {
        
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
         User u = AIA_TestUtil.createTestUser();
         
             // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             aiaDocList.add(aiaDoc); 

             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');
             
             // Create Contract
             AIA_TestUtil.CreateContract();     
             Contract c = [select id from contract limit 1];
             system.assertNotEquals(null,c.id); 
        	Test.startTest();
             Apexpages.Currentpage().getParameters().put('id',c.id);
             ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
             AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
             controllerObj.processUpload();
             controllerObj.saveStandardAttachment();
             Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
             controllerObj.cancelButton();
             
             Attachment att = [select id from Attachment where id =: at.ID];
             system.assertNotEquals(null,att.id);
             // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
       Test.stopTest(); 
    }
    /*Public static testmethod void TestInvalidContact(){
            try{
            List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
            // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             aiaDocList.add(aiaDoc); 

             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');
             contact con=new contact(lastName='TestCon');
             insert con;
             Apexpages.Currentpage().getParameters().put('id',con.id);
             ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
             AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
             controllerObj.processUpload();
             controllerObj.cancelButton();
            }
            
            catch(exception e){}
        
    }*/
            Public static testmethod void TestTruncatedName1() {
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
         User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {    
             // creating AIA Document
           //  AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
           //  system.assertNotEquals(null,aiaDoc.id);
           //  aiaDocList.add(aiaDoc);

             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');
             
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount'); 
             system.assertNotEquals(null,a.id);
             a.Account_Legal_Name__c = 'TruncateNamexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
             update a;

           
            // creating AIA Document  
            AIA_Document__c aiaDoc = new AIA_Document__c();
            aiaDoc.Account__c = a.id;
            aiaDoc.Document_Status__c = 'Signed Quote';
            aiaDoc.Document_Type__c = 'Additional Documentation';
            aiaDoc.Active__c = True;
            aiaDoc.Start_Date__c = System.today();
            aiaDoc.End_Date__c = System.today()+10;
            aiaDoc.Approval_Status__c = 'Pending';
            insert aiaDoc;
        
            
             Apexpages.Currentpage().getParameters().put('id',a.id);
             ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
             AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
              controllerObj.attchId = aiaDoc.id;
             
             controllerObj.processUpload();
             Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
             controllerObj.saveStandardAttachment();
            // controllerObj.cancelButton();  
             
             Attachment att = [select id from Attachment where id =: at.ID];
             system.assertNotEquals(null,att.id);
             // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
          }      
    }

Public static testmethod void TestTruncatedName2() {
         List<AIA_Document__c> aiaDocList = new List<AIA_Document__c>();
         User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {    
             // creating AIA Document
           //  AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
           //  system.assertNotEquals(null,aiaDoc.id);
           //  aiaDocList.add(aiaDoc);

             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');
             
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount'); 
             system.assertNotEquals(null,a.id);
             a.Account_Legal_Name__c = 'TruncateName';
             update a;

           
            // creating AIA Document  
            AIA_Document__c aiaDoc = new AIA_Document__c();
            aiaDoc.Account__c = a.id;
            aiaDoc.Document_Status__c = 'Signed Quote';
            aiaDoc.Document_Type__c = 'Additional Documentation';
            aiaDoc.Active__c = True;
            aiaDoc.Start_Date__c = System.today();
            aiaDoc.End_Date__c = System.today()+10;
            aiaDoc.Approval_Status__c = 'Pending';
            insert aiaDoc;
        
            
             Apexpages.Currentpage().getParameters().put('id',a.id);
             ApexPages.StandardSetController testController = new ApexPages.StandardSetController(aiaDocList);
             AIADocumentUploadController controllerObj = new AIADocumentUploadController(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
              controllerObj.attchId = aiaDoc.id;
             
             controllerObj.processUpload();
             Attachment at=AIA_TestUtil.createAttachment(Id.valueOf(controllerObj.fDocNetId)); 
             controllerObj.saveStandardAttachment();
            // controllerObj.cancelButton();  
             
             Attachment att = [select id from Attachment where id =: at.ID];
             system.assertNotEquals(null,att.id);
             // TODO: 6/22 - Add assert statement to validate that document uploaded successfully
          }      
    }
}