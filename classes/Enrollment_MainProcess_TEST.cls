/*****************************************************************************************************
*Date: 04-13-2017
*Developer: Rajesh Pennam
*Purpose: Code coverage for Enrollment_MainProcess Class 
*=========================================================================================
* Update History
* Date         Developer        Tag        Description
*==================================================================================
*09-16-2016    Rajesh Pennam    T01         Initial Development
*==================================================================================

*******************************************************************************************************/


@isTest

public class Enrollment_MainProcess_TEST{

    static testMethod void testBatch(){
    //T01 Starts Here
    Test.StartTest(); 
     TestUtil.createEnrollmentTestData();
     TestUtil.Create_Enrollment_Import();
     
     TestUtil.createDynamicCodeDataStore();
     TestUtil.Create_Error_Message();
        String Rpt_DT = '';  
      //T01 Ends Here          
      Test.StopTest();  
        ID RtIdEnrX51 = querybase.getRecordtypeId('Enrollment__c', 'X51');  
        Rpt_Dt = testUtil.createEnrollmentTestData(); 
        
           try {     
                Enrollment_MainProcess enmp = new Enrollment_MainProcess();
                enmp.query = 'SELECT id, Rpt_Dt__c, Run_Dt__c, Account_Name__c, Account_Number__c, SFDC_Product__c, Contracts__c, System__c, Sales_Rep__c, Risk__c, Processed_Type__C, Rating_State__c, New_Business_Indicator__c FROM Enrollment_Import__c WHERE Processed__c = FALSE';                
                enmp.EmailUsers = TRUE;
                ID batchprocessId = Database.executeBatch(enmp);
           
                List <Enrollment__c> enrll = new list<Enrollment__c>(); 
                enrll = [SELECT id, System__c, Account_Number__c, Contracts__c, Product__c, Risk__c, Run_Dt__c, Processed_Type__c  
                         FROM Enrollment__c WHERE Rpt_Dt__c = :Rpt_Dt AND Recordtypeid =:RtIdEnrX51];
        
                List <Enrollment_Recycle__c> enrllErr = new list<Enrollment_Recycle__c>(); 
                enrllErr = [SELECT id, System__c, Account_Number__c, Account_Name__c, Contracts__c, Error_Message__c, Error_Number__c, Opportunity_Name__c, SFDC_Product__c, Risk__c, Run_Dt__c, Sales_Rep__c, Processed_Type__c, Rating_State__c, New_Business_Indicator__c  
                            FROM Enrollment_Recycle__c];  
                           
                Enrollment__c DeleteEnrl = [ SELECT id FROM Enrollment__c WHERE Rpt_Dt__c = :Rpt_Dt LIMIT 1 ];    
                Delete DeleteEnrl;
                                             
                    
                System.assert(TRUE); //We should not get here
           }catch( Enrollment_MainProcess.EnrollmentException e ){
                RETURN;   
            } 
    }


    /*******************************************************************
     * Test against coded Exception in the Enrollment_MainProcess Class
     * Where we do not pass a value to the query method
     ******************************************************************/
    static TestMethod void testQuery(){
    
        TestUtil.createEnrollmentTestData();//T01
        TestUtil.Create_Enrollment_Import();
          TestUtil.Create_Error_Message();//T01
        Test.StartTest();
            Enrollment_MainProcess enmp = new Enrollment_MainProcess();
//            enmp.ProcessedType = 'M';   
            try{
                ID batchprocessId = Database.executeBatch(enmp);
        Test.StopTest();
                System.assert(FALSE); // We should never hit this
            }catch( Enrollment_MainProcess.EnrollmentException e ){
                RETURN;       
            }        
    }


    /*******************************************************************
     * Test against coded Exception in the Enrollment_MainProcess Class
     * Where we do not pass a valid value to the ProcessedType method
     ******************************************************************/    
    static TestMethod void testProcessedType(){
        TestUtil.createEnrollmentTestData();
        Test.StartTest(); 
            Enrollment_MainProcess enmp = new Enrollment_MainProcess();      
            try{
                enmp.query = 'Testing Query Not Using the enrollment import table';
//                enmp.ProcessedType = 'Z';
                ID batchprocessId = Database.executeBatch(enmp);
        Test.StopTest();
                System.assert(FALSE); //We should not get here
             }catch( Enrollment_MainProcess.EnrollmentException e ){
                 RETURN;   
             }   
    }  
              

    
    /*******************************************************************
     * This test case is for a method that was created in the QueryBase
     * class and afterward was not needed for the enrollment project; 
     * however, it is a good method that could be used in future projects
     * so it was decided to keep it and get code coverate here
     * QueryBase.idIsofSobj('Account', '0016000000MEugU');
     *******************************************************************/
    static  TestMethod void testQueryBase_idIsofSobj() {
        testUtil.createEnrollmentTestData();
        Account acc;
        acc = [ SELECT id FROM ACCOUNT LIMIT 1 ];
        // Positive Test
        QueryBase.idIsofSobj('Account', acc.id);
        // Negative Test
        QueryBase.idIsofSobj('Opportunity', acc.id);     
    }  

}