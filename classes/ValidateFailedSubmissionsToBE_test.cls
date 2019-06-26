//============================================================
//      Date: 12/14/2012
// Developer: Tom Barrett (TPB)
//   Purpose: To test the ValidateFailedSubmissionToBE class
//============================================================
//------------------------------------------------------------------------------------
//                      ----===[ HISTORY ]===---
// Date        Developer        Description
//------------------------------------------------------------------------------------
// 06/06/2014 Tom Barrett (TPB) added Incumbent_Successor__c for VR064
//-------------------------------------------------------------------------------------



@isTest
private class ValidateFailedSubmissionsToBE_test {
    static testMethod void test1() {        
        /* create account */
        Account testAcc1 = new Account();
        testAcc1.Name = 'Test Account1';
        insert testAcc1 ;

        /* create opportunity in proposal stage */
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(2050, 1, 1);
        Date effectiveDate = date.newinstance(2050, 12, 1);        
        testOpp.Name = 'Test Opportunity1';
        testOpp.AccountId = testAcc1.Id ;
        testOpp.StageName ='Proposal';
        testOpp.CloseDate = closedDate;
        testOpp.Effective_Date__c = effectiveDate; 
        testOpp.GeneralProducer__c = 'Direct'; 
        testOpp.BE_Prospect_ID__c = 'PR-0304';  
//TPB - 12/19/2013        
        Date contractEndDate = testOpp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp.Contract_End_Date__c = contractEndDate;  
                       
        insert testOpp; 
        
        /* create Integration_Err_Log */
        Integration_Err_Log__c testIEL = new Integration_Err_Log__c();
        testIEL.Name = 'test';
        testIEL.Source_ID__c = testOpp.id;
        testIEL.Validated__c = FALSE;
        testIEL.Validate_Adjusted__c = FALSE;
        insert testIEL;  
        
        /* create opportunity in dead stage */
        Opportunity testOpp2 = new Opportunity();    
        testOpp2.Name = 'Test Opportunity2';
        testOpp2.AccountId = testAcc1.Id ;
        testOpp2.StageName ='Dead';
        testOpp2.Won_Lost_Reason__c = 'Won';
        testOpp2.CloseDate = closedDate;
        testOpp2.Effective_Date__c = effectiveDate; 
        testOpp2.GeneralProducer__c = 'Direct';  
//TPB - 12/19/2013        
        testOpp2.Effective_Date__c = effectiveDate;
        testOpp2.Contract_End_Date__c = contractEndDate;          
        testOpp2.Incumbent_Successor__c = 'CareFirst'; //06/06/2014 TPB                        
        insert testOpp2; 
                
        /* create Integration_Err_Log */
        Integration_Err_Log__c testIEL2 = new Integration_Err_Log__c();
        testIEL2.Name = 'test2';
        testIEL2.Source_ID__c = testOpp2.id;
        testIEL2.Validated__c = FALSE;
        testIEL2.Validate_Adjusted__c = FALSE;                
        insert testIEL2;     
        

        
        Test.startTest();
            ValidateFailedSubmissionsToBE vstb = new ValidateFailedSubmissionsToBE();
        Test.stopTest();
    }  
}