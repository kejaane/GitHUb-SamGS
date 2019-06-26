//==========================================================================================================
//      Date: 09/02/2017
// Developer: Tom Barrett (TPB)
//   Purpose: Test classes to test the GLM class for the Governor Limit Monitoring Framework          
//==========================================================================================================
//                                  Update History
// Date          Developer      Tag     Description
//==========================================================================================================
// mm/dd/yyyy    name           Txxx    xxxx    
//==========================================================================================================
@isTest
Public Class GLM_Test {    
    
    /***********************************
     * Test the ALL Limit functionality
     ***********************************/
    public static testMethod void AllLimits() { 
        Test.startTest();
        	GLM.checkLimit(GLM.sfLimit.ALLlimits, 'AllLimits Limit Test');
        Test.stopTest();
    }
   
    /***********************************
     * Test a single limit functionality
     ***********************************/
    public static testMethod void AggregateQueries() {
        Test.startTest();
        	GLM.checkLimit(GLM.sfLimit.AggregateQueries, 'AggregateQueries Limit Test');      
        Test.stopTest();
    }
    
    /******************************************
     * Test when a record doesn't exist on the
     * GLM custom metadata type table
     ******************************************/
    public static testMethod void NoSuchLimit() {
        Test.startTest();
        	GLM.checkLimit(GLM.sfLimit.NoSuchLimit, 'NoSuchLimit Limit Test');      
        Test.stopTest();
    } 

}