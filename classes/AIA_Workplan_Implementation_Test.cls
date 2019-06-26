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
//Purpose: Test class for AIA_Workplan_Implementation
//==================================================================================
// Update History
// Date         Developer               Description
// 
//==================================================================================
//06/18/2016    Chidananda nagaraj     Initial Development
//==================================================================================
@isTest
public with sharing class AIA_Workplan_Implementation_Test {
    static Schema.DescribeSObjectResult objResult = Schema.SObjectType.Opportunity; 
    static Map<String,Schema.RecordTypeInfo> objRecordType = objResult.getRecordTypeInfosByName(); 
    static Id opp200RecTypId = objRecordType !=NULL && objRecordType.containsKey('200+') ? objRecordType.get('200+').getRecordTypeId() : NULL;  
    static testmethod void testCreateWorkplanStages(){
        test.startTest();
        User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {  
            // Create Account
             AIA_Implementation__c Imp;
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             system.debug('Opp'+o);
             o.recordTypeId = opp200RecTypId;
             o.Business_Type__c = 'RFP';
             update o;
             
             // Create PRF
             PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
             system.assertNotEquals(null,p.id);
             
             List<AIA_Implementation__c> aiaImpList = AIA_TestUtil.CreateImpList(o.id);
             system.assertNotEquals(0,aiaImpList.size());
             
              Imp = AIA_TestUtil.UpdateImp(o.id);             
             update Imp;
          }
          test.stopTest();
    }
    
    static testmethod void testImpl_Opp_200RecType(){
        
        User u = AIA_TestUtil.createTestUser();
        //Id opp50RecTypId = objRecordType.get('50+').getRecordTypeId();
        //Getting the RecordTypes -Id's of - Benfit_Request_Form__c  object
        Schema.DescribeSObjectResult brfObjResult = Schema.SObjectType.Benfit_Request_Form__c; 
        Map<String,Schema.RecordTypeInfo> brfObjRecordType = brfObjResult.getRecordTypeInfosByName();  
        Id brfRecTypId = objRecordType !=NULL && objRecordType.containsKey('ASO') ? objRecordType.get('ASO').getRecordTypeId() : NULL;
        System.runAs(u) {  
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        o.recordTypeId = opp200RecTypId;
        o.Business_Type__c = 'Renewal';
        update o;

        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        //brf.Identity_Protection_Mandate_ASO__c = 'No';
        brf.Funding_Arrangements__c = 'ASO';
        brf.Request_Type__c = 'Renew As-is';
        insert brf;
             
        test.startTest();          
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Benefit_Request_Form__c = brf.Id;
        Imp.Risk_Type__c = 'ASO';
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        insert Imp;
        Imp.Implementation_Plan_Timeline_Days__c = '120';
        update Imp;
        AIA_Implementation__c testImpl = [Select Id,Business_Type__c From AIA_Implementation__c Where id = :Imp.Id];
        system.assertEquals('Renewal', testImpl.Business_Type__c);
        test.stopTest();
      }
    }
    static testmethod void testImpl_Opp_200RecType2(){
        
        User u = AIA_TestUtil.createTestUser();
        //Id opp50RecTypId = objRecordType.get('50+').getRecordTypeId();
        //Getting the RecordTypes -Id's of - Benfit_Request_Form__c  object
        Schema.DescribeSObjectResult brfObjResult = Schema.SObjectType.Benfit_Request_Form__c; 
        Map<String,Schema.RecordTypeInfo> brfObjRecordType = brfObjResult.getRecordTypeInfosByName();  
        Id brfRecTypId = objRecordType !=NULL && objRecordType.containsKey('ASO') ? objRecordType.get('ASO').getRecordTypeId() : NULL;
        System.runAs(u) {  
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        o.recordTypeId = opp200RecTypId;
        o.Business_Type__c = 'Renewal';
        update o;

        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        //brf.Identity_Protection_Mandate_ASO__c = 'No';
        brf.Funding_Arrangements__c = 'ASO';
        brf.Request_Type__c = 'RFP';
        insert brf;
             
        test.startTest();          
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Benefit_Request_Form__c = brf.Id;
        Imp.Risk_Type__c = 'ASO';
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        insert Imp;
        Imp.Implementation_Plan_Timeline_Days__c = '120';
        update Imp;
        AIA_Implementation__c testImpl = [Select Id,Business_Type__c From AIA_Implementation__c Where id = :Imp.Id];
        system.assertEquals('Prospect/New', testImpl.Business_Type__c);
        test.stopTest();
      }
    }
    static testmethod void testImpl_Opp_200RecType3(){
        
        User u = AIA_TestUtil.createTestUser();
        //Id opp50RecTypId = objRecordType.get('50+').getRecordTypeId();
        //Getting the RecordTypes -Id's of - Benfit_Request_Form__c  object
        Schema.DescribeSObjectResult brfObjResult = Schema.SObjectType.Benfit_Request_Form__c; 
        Map<String,Schema.RecordTypeInfo> brfObjRecordType = brfObjResult.getRecordTypeInfosByName();  
        Id brfRecTypId = objRecordType !=NULL && objRecordType.containsKey('ASO') ? objRecordType.get('ASO').getRecordTypeId() : NULL;
        System.runAs(u) {  
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        o.recordTypeId = opp200RecTypId;
        o.Business_Type__c = 'Renewal';
        update o;

        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        //brf.Identity_Protection_Mandate_ASO__c = 'No';
        brf.Funding_Arrangements__c = 'ASO';
        brf.Request_Type__c = 'Renewal';
        insert brf;
             
        test.startTest();          
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Benefit_Request_Form__c = brf.Id;
        Imp.Risk_Type__c = 'ASO';
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        insert Imp;
        Imp.Implementation_Plan_Timeline_Days__c = '120';
        update Imp;
        AIA_Implementation__c testImpl = [Select Id,Business_Type__c From AIA_Implementation__c Where id = :Imp.Id];
        system.assertEquals('Renewal', testImpl.Business_Type__c);
        test.stopTest();
      }
    }
}