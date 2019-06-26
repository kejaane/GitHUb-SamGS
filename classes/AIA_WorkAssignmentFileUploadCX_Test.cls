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
//Purpose: Test class for AIA_WorkAssignmentFileUploadCX
//==================================================================================
// Update History
// Date         Developer          Tag     	Description
// 
//==================================================================================
//06/18/2016    Goutham Rapolu     			Initial Development
//10/23/2017 	Rajesh Nagandla    T01		Commenting Code related to objects AIA_Workplan_Type__c,Workplan_Type_Stage__c,
//											AIA_Workplan_Type_Task__c, Workplan_Stage__c, AIA_Workplan_Assignment__c
//==================================================================================

@isTest
public with sharing class AIA_WorkAssignmentFileUploadCX_Test {
    /*Public static testmethod void TestWorkAssignmentFileUploadCX() {
         
         User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {    
             // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             
             // Create PRF
             PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
             system.assertNotEquals(null,p.id);
             string cv = 'document';
             Blob cvBlob = Blob.toPdf('document');*/
             /*T01 Start*/
			/*
			 list<Workplan_Stage__c> aiawsList = AIA_TestUtil.createWPS();
             system.assertNotEquals(0,aiawsList.size());
             
             AIA_Workplan_Assignment__c aiaWS = AIA_TestUtil.createWPAssignment(aiawsList,p.id);
             system.assertNotEquals(null,aiaWS);
             
             Apexpages.Currentpage().getParameters().put('id',aiaWS.id);
			 */
			/*T01 End*/
       /*      ApexPages.StandardController testController = new ApexPages.StandardController(aiaDoc);
             AIA_WorkAssignmentFileUploadCX controllerObj = new AIA_WorkAssignmentFileUploadCX(testController);
             controllerObj.fileBody = cvBlob;
             controllerObj.fileName = 'TestDoc.pdf';
             controllerObj.description = 'test Document';
             controllerObj.processUpload();
             controllerObj.cancelButton();  
          }      
    }*/
   /* Public static testmethod void TestNegativeCase() {
         
         User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {    
             // creating AIA Document
             AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
             system.assertNotEquals(null,aiaDoc.id);
             
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             
             // Create PRF
             PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
             system.assertNotEquals(null,p.id);
             /*T01 Start*/
			 /*
             list<Workplan_Stage__c> aiawsList = AIA_TestUtil.createWPS();
             system.assertNotEquals(0,aiawsList.size());
             
             AIA_Workplan_Assignment__c aiaWS = AIA_TestUtil.createWPAssignment(aiawsList,p.id);
             system.assertNotEquals(null,aiaWS);
             
             Apexpages.Currentpage().getParameters().put('id',aiaWS.id);
			 */
			 /*T01 End*/
            /* ApexPages.StandardController testController = new ApexPages.StandardController(aiaDoc);
             AIA_WorkAssignmentFileUploadCX controllerObj = new AIA_WorkAssignmentFileUploadCX(testController);
             controllerObj.processUpload();
             controllerObj.cancelButton();  
          }      
    }*/
}