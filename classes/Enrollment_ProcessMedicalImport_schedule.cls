global class Enrollment_ProcessMedicalImport_schedule implements Schedulable{
        Enrollment_MainProcess epm = new Enrollment_MainProcess();
    {
        epm.query = 'SELECT id, Rpt_Dt__c, Run_Dt__c, Account_Name__c, Account_Number__c, SFDC_Product__c, Contracts__c, System__c, Sales_Rep__C, Risk__c, Processed_Type__c, Rating_State__c, New_Business_Indicator__c FROM Enrollment_Import__c WHERE Processed_Type__c = \'M\' AND Processed__c = FALSE';        
        epm.EmailUsers = TRUE;
    }
    global void execute(SchedulableContext SC){
        ID batchprocessId = Database.executeBatch(epm, 100);      
   }
}