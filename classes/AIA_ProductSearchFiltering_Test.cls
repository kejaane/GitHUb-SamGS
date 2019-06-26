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
//=========================================================================================
// Date: 08/11/2016
// Developer: Goutham Rapolu
// Purpose: Used to create test class for AIA_GroupStructureTriggerHelper Class
// 7/25/2017  Debkanti  Added testAIA_ProductSearchFilteringControllerClass1 to cover Dental logic
// 7/25/2017  Debkanti  Added testAIA_ProductSearchFilteringControllerClass2 to cover Vision logic
// 7/25/2017  Debkanti  Added testAIA_ProductSearchFilteringControllerClass3 to cover Drug logic
// 6/14/2017  Sajitha Y Added jurisdiction value for Account to increase coverage
//=========================================================================================

@isTest
public with sharing class AIA_ProductSearchFiltering_Test {
    Public static testmethod void testAIA_ProductSearchFilteringControllerClass() {
    
    List<AIA_Plan__c> alst=new List<AIA_Plan__c>(); 
        Test.startTest();
        User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {    
            
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
              a.Jurisdiction__c ='CEDE';
              update a;
             system.assertNotEquals(null,a.id);
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             
             // Create Benefit Request Form           
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
             nbrf.Jurisdiction__c ='CEDE';
            nbrf.Opportunity__c = o.id;
            
             insert nbrf;
             system.assertNotEquals(null,nbrf.id);
             
              
             //Create Plan
             AIA_Plan__c aiaPlan = AIA_TestUtil.CreatePlan(nbrf.id);             
             system.assertNotEquals(null,aiaPlan.id);
             alst.add(aiaPlan);
             
             AIA_Plan__c aiaDrugPlan = AIA_TestUtil.CreateDrugPlan(nbrf.id);             
             AIA_TestUtil.CreateRelatedPlan(aiaPlan.id,aiaDrugPlan.id);
             
                     
             PageReference pageRef = Page.AIA_ProductSearchFiltering;
             Test.setCurrentPage(pageRef);
             Apexpages.Currentpage().getParameters().put('brfId', nbrf.id);
             ApexPages.StandardSetController ssc=new ApexPages.StandardSetController(alst);
             Apexpages.currentPage().getParameters().put('addPlan','Drug');           
             Apexpages.currentPage().getParameters().put('productName','test');
             Apexpages.currentPage().getParameters().put('productCategory','Medical');            
             Apexpages.currentPage().getParameters().put('productLine','HMO');
             Apexpages.currentPage().getParameters().put('CDH','Yes');
             Apexpages.currentPage().getParameters().put('CDHtype','HSA');
             Apexpages.currentPage().getParameters().put('CDHfundType','BlueFund');
             Apexpages.currentPage().getParameters().put('planId',aiaPlan.id);
             AIA_ProductSearchFilteringController controllerObj = new AIA_ProductSearchFilteringController();
             controllerObj.setCon =null;
             controllerObj.size = 2;
             controllerObj.getProdCategoryItems();
             controllerObj.getProdLine();
             controllerObj.getCDHitems();
             controllerObj.getCDHtypeItems();
             controllerObj.toggleSort();
             controllerObj.getCDHfundTypeItems();
             controllerObj.effectiveDate = system.today();
             controllerObj.termDate = system.today();
             controllerObj.Plans = aiaPlan;
             controllerObj.productLine = 'HMO';
             controllerObj.productName = 'test';
             controllerObj.productCategory = 'Medical';
             controllerObj.CDH = 'Yes';
             controllerObj.CDHtype = 'HSA';
             controllerObj.CDHfundType = 'BlueFund';
             controllerObj.runSearch();
             controllerObj.cancelButton();
             controllerObj.first();
             controllerObj.last();
             controllerObj.previous();
             controllerObj.next();
             String searchQuery = controllerObj.debugSoql;
             system.assertNotEquals(null, searchQuery);
              
             Integer recCount = controllerObj.noOfRecords;
              system.assertEquals(0, recCount);
             Integer pgNum = controllerObj.pageNumber;
              system.assertEquals(1, pgNum);
          }
          test.stopTest();
    }
    
    Public static testmethod void testAIA_ProductSearchFilteringDrug() {
    
    List<AIA_Plan__c> alst=new List<AIA_Plan__c>();
        Test.startTest();
        User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {    
            
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             

             // Create Benefit Request Form           
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            nbrf.Jurisdiction__c = 'MD';
            
              insert nbrf;
             system.assertNotEquals(null,nbrf.id);
             
              
             //Create Plan
            AIA_Plan__c p2 = new AIA_Plan__c ();

            p2.Product_Category__c = 'Drug';
            p2.Product_Line__c = 'Health Maintenance Organization';
            p2.CDH__c = 'Yes';
            p2.CDH_Type__c = 'HSA';
            p2.CDH_Fund_Type__c = 'BlueFund';
            p2.Plan_Id__c = 'test';
            p2.Effective_Date__c = system.today();
            p2.Termination_Date__c = system.today();
            p2.Product_Status__c ='Active';
            p2.Jurisdiction__c = 'MD';
            alst.add(p2);
            insert p2;
            system.assertNotEquals(null,p2.id);
            
                               
             PageReference pageRef = Page.AIA_ProductSearchFiltering;
             Test.setCurrentPage(pageRef);
             Apexpages.Currentpage().getParameters().put('brfId', nbrf.id);
             ApexPages.StandardSetController ssc=new ApexPages.StandardSetController(alst);
             
             AIA_ProductSearchFilteringController controllerObj = new AIA_ProductSearchFilteringController();
             controllerObj.getProdCategoryItems();
             controllerObj.hasNext=true;
             controllerObj.hasPrevious=true;
             controllerObj.pageNumber=10;
             controllerObj.noOfRecords=10;
             controllerObj.pageNumberTotal=10;
             controllerObj.getProdLine();
             controllerObj.getCDHitems();
             controllerObj.getCDHtypeItems();
             controllerObj.getCDHfundTypeItems();
             controllerObj.effectiveDate = system.today();
             controllerObj.termDate = system.today();
             controllerObj.Plans = p2;
             controllerObj.productLine = 'HMO';
             controllerObj.productName = 'testDrug';
             controllerObj.productCategory = 'Drug';
             controllerObj.CDH = 'Yes';
             controllerObj.CDHtype = 'HSA';
             controllerObj.CDHfundType = 'BlueFund';
             Apexpages.currentPage().getParameters().put('productName','testDrug');
             Apexpages.currentPage().getParameters().put('productCategory','Drug');
             Apexpages.currentPage().getParameters().put('productLine','HMO');
             Apexpages.currentPage().getParameters().put('CDH','Yes');
             Apexpages.currentPage().getParameters().put('CDHtype','HSA');
             Apexpages.currentPage().getParameters().put('CDHfundType','BlueFund');
             controllerObj.runSearch();
             controllerObj.cancelButton();
             controllerObj.first();
             controllerObj.last();
             controllerObj.previous();
             controllerObj.next();
             Apexpages.currentPage().getParameters().put('productCategory','CareFirst Private Exchange');
             
              controllerObj.runSearch();
             controllerObj.cancelButton();
             controllerObj.first();
             controllerObj.last();
             controllerObj.previous();
             controllerObj.next();
             controllerObj.runQuery();
          }
          test.stopTest();
    } 
    
    Public static testmethod void testAIA_ProductSearchFilteringControllerClass1() {
    
    List<AIA_Plan__c> alst=new List<AIA_Plan__c>(); 
        Test.startTest();
        User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {    
            
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             
             // Create Benefit Request Form           
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
             insert nbrf;
             system.assertNotEquals(null,nbrf.id);
             
              
             //Create Plan
             AIA_Plan__c aiaPlan = AIA_TestUtil.CreatePlan(nbrf.id);             
             system.assertNotEquals(null,aiaPlan.id);
             alst.add(aiaPlan);
             
             AIA_Plan__c aiaDrugPlan = AIA_TestUtil.CreateDrugPlan(nbrf.id);             
             AIA_TestUtil.CreateRelatedPlan(aiaPlan.id,aiaDrugPlan.id);
             
                     
             PageReference pageRef = Page.AIA_ProductSearchFiltering;
             Test.setCurrentPage(pageRef);
             Apexpages.Currentpage().getParameters().put('brfId', nbrf.id);
             ApexPages.StandardSetController ssc=new ApexPages.StandardSetController(alst);
             Apexpages.currentPage().getParameters().put('addPlan','Drug');           
             Apexpages.currentPage().getParameters().put('productName','test');
             Apexpages.currentPage().getParameters().put('productCategory','Dental');
             Apexpages.currentPage().getParameters().put('productLine','HMO');
             Apexpages.currentPage().getParameters().put('CDH','Yes');
             Apexpages.currentPage().getParameters().put('CDHtype','HSA');
             Apexpages.currentPage().getParameters().put('CDHfundType','BlueFund');
             Apexpages.currentPage().getParameters().put('planId',aiaPlan.id);
             AIA_ProductSearchFilteringController controllerObj = new AIA_ProductSearchFilteringController();
             controllerObj.setCon =null;
             controllerObj.size = 2;
             controllerObj.getProdCategoryItems();
             controllerObj.getProdLine();
             controllerObj.getCDHitems();
             controllerObj.getCDHtypeItems();
             controllerObj.toggleSort();
             controllerObj.getCDHfundTypeItems();
             controllerObj.effectiveDate = system.today();
             controllerObj.termDate = system.today();
             controllerObj.Plans = aiaPlan;
             controllerObj.productLine = 'HMO';
             controllerObj.productName = 'test';
             controllerObj.productCategory = 'Dental';
             controllerObj.CDH = 'Yes';
             controllerObj.CDHtype = 'HSA';
             controllerObj.CDHfundType = 'BlueFund';
             controllerObj.runSearch();
             controllerObj.cancelButton();
             controllerObj.first();
             controllerObj.last();
             controllerObj.previous();
             controllerObj.next();
             String searchQuery = controllerObj.debugSoql;
             system.assertNotEquals(null, searchQuery);
              
             Integer recCount = controllerObj.noOfRecords;
              system.assertEquals(0, recCount);
             Integer pgNum = controllerObj.pageNumber;
              system.assertEquals(1, pgNum);
          }
          test.stopTest();
    }
    
     Public static testmethod void testAIA_ProductSearchFilteringControllerClass2() {
    
    List<AIA_Plan__c> alst=new List<AIA_Plan__c>(); 
        Test.startTest();
        User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {    
            
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             
             // Create Benefit Request Form           
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
             insert nbrf;
             system.assertNotEquals(null,nbrf.id);
             
              
             //Create Plan
             AIA_Plan__c aiaPlan = AIA_TestUtil.CreatePlan(nbrf.id);             
             system.assertNotEquals(null,aiaPlan.id);
             alst.add(aiaPlan);
             
             AIA_Plan__c aiaDrugPlan = AIA_TestUtil.CreateDrugPlan(nbrf.id);             
             AIA_TestUtil.CreateRelatedPlan(aiaPlan.id,aiaDrugPlan.id);
             
                     
             PageReference pageRef = Page.AIA_ProductSearchFiltering;
             Test.setCurrentPage(pageRef);
             Apexpages.Currentpage().getParameters().put('brfId', nbrf.id);
             ApexPages.StandardSetController ssc=new ApexPages.StandardSetController(alst);
             Apexpages.currentPage().getParameters().put('addPlan','Drug');           
             Apexpages.currentPage().getParameters().put('productName','test');
              Apexpages.currentPage().getParameters().put('productCategory','Vision');
             Apexpages.currentPage().getParameters().put('productLine','HMO');
             Apexpages.currentPage().getParameters().put('CDH','Yes');
             Apexpages.currentPage().getParameters().put('CDHtype','HSA');
             Apexpages.currentPage().getParameters().put('CDHfundType','BlueFund');
             Apexpages.currentPage().getParameters().put('planId',aiaPlan.id);
             AIA_ProductSearchFilteringController controllerObj = new AIA_ProductSearchFilteringController();
             controllerObj.setCon =null;
             controllerObj.size = 2;
             controllerObj.getProdCategoryItems();
             controllerObj.getProdLine();
             controllerObj.getCDHitems();
             controllerObj.getCDHtypeItems();
             controllerObj.toggleSort();
             controllerObj.getCDHfundTypeItems();
             controllerObj.effectiveDate = system.today();
             controllerObj.termDate = system.today();
             controllerObj.Plans = aiaPlan;
             controllerObj.productLine = 'HMO';
             controllerObj.productName = 'test';
             controllerObj.productCategory = 'Vision';
             controllerObj.CDH = 'Yes';
             controllerObj.CDHtype = 'HSA';
             controllerObj.CDHfundType = 'BlueFund';
             controllerObj.runSearch();
             controllerObj.cancelButton();
             controllerObj.first();
             controllerObj.last();
             controllerObj.previous();
             controllerObj.next();
             String searchQuery = controllerObj.debugSoql;
             system.assertNotEquals(null, searchQuery);
              
             Integer recCount = controllerObj.noOfRecords;
              system.assertEquals(0, recCount);
             Integer pgNum = controllerObj.pageNumber;
              system.assertEquals(1, pgNum);
          }
          test.stopTest();
    }
    
     Public static testmethod void testAIA_ProductSearchFilteringControllerClass3() {
    
    List<AIA_Plan__c> alst=new List<AIA_Plan__c>(); 
        Test.startTest();
        User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {    
            
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             
             // Create Benefit Request Form           
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
             insert nbrf;
             system.assertNotEquals(null,nbrf.id);
             
              
             //Create Plan
             AIA_Plan__c aiaPlan = AIA_TestUtil.CreatePlan(nbrf.id);             
             system.assertNotEquals(null,aiaPlan.id);
             alst.add(aiaPlan);
             
             AIA_Plan__c aiaDrugPlan = AIA_TestUtil.CreateDrugPlan(nbrf.id);             
             AIA_TestUtil.CreateRelatedPlan(aiaPlan.id,aiaDrugPlan.id);
             
                     
             PageReference pageRef = Page.AIA_ProductSearchFiltering;
             Test.setCurrentPage(pageRef);
             Apexpages.Currentpage().getParameters().put('brfId', nbrf.id);
             ApexPages.StandardSetController ssc=new ApexPages.StandardSetController(alst);
             Apexpages.currentPage().getParameters().put('addPlan','Drug');           
             Apexpages.currentPage().getParameters().put('productName','test');
              Apexpages.currentPage().getParameters().put('productCategory','Drug');
             Apexpages.currentPage().getParameters().put('productLine','HMO');
             Apexpages.currentPage().getParameters().put('CDH','Yes');
             Apexpages.currentPage().getParameters().put('CDHtype','HSA');
             Apexpages.currentPage().getParameters().put('CDHfundType','BlueFund');
             Apexpages.currentPage().getParameters().put('planId',aiaPlan.id);
             AIA_ProductSearchFilteringController controllerObj = new AIA_ProductSearchFilteringController();
             controllerObj.setCon =null;
             controllerObj.size = 2;
             controllerObj.getProdCategoryItems();
             controllerObj.getProdLine();
             controllerObj.getCDHitems();
             controllerObj.getCDHtypeItems();
             controllerObj.toggleSort();
             controllerObj.getCDHfundTypeItems();
             controllerObj.effectiveDate = system.today();
             controllerObj.termDate = system.today();
             controllerObj.Plans = aiaPlan;
             controllerObj.productLine = 'HMO';
             controllerObj.productName = 'test';
             controllerObj.productCategory = 'Drug';
             controllerObj.CDH = 'Yes';
             controllerObj.CDHtype = 'HSA';
             controllerObj.CDHfundType = 'BlueFund';
             controllerObj.runSearch();
             controllerObj.cancelButton();
             controllerObj.first();
             controllerObj.last();
             controllerObj.previous();
             controllerObj.next();
             String searchQuery = controllerObj.debugSoql;
             system.assertNotEquals(null, searchQuery);
              
             Integer recCount = controllerObj.noOfRecords;
              system.assertEquals(0, recCount);
             Integer pgNum = controllerObj.pageNumber;
              system.assertEquals(1, pgNum);
          }
          test.stopTest();
    }
   }