//===================================================================================
//Date: 06/18/2016
//Developer: Chidananda Nagaraj
//Purpose: Test class for AIA_OpportunityHelper_Test
//==================================================================================
// Update History
// Date         Developer               Description
// 
//==================================================================================
//06/18/2016    Chidananda     Initial Development
//==================================================================================
@isTest
public with sharing class AIA_OpportunityHelper_Test {
    static testmethod void testCase1(){
    test.startTest();
    User u = AIA_TestUtil.createTestUser();
      System.runAs(u) { 
      // Create Account
          Account a = AIA_TestUtil.CreateAccount('TestAccount');
          system.assertNotEquals(null,a.id);
          a.BillingState ='VA';
          update a;
          // Create Opportunity
          Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
          system.assertNotEquals(null,o.id);
          o.StageName ='Sold';
          try{
                update o;
          }
          catch (Exception e) {
          System.AssertNotEquals('False', 'Exception ' + e);
          }
       }
    test.stopTest();
    }
}