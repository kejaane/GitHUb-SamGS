//******************************************************************************************
//      Date: 08/17/2013
// Developer: Tom Barrett
//   Purpose: To handle any programmatic Enrollment Triggers 
//============================================================================================
//                                 Update History
// Date       Developer       Description
//============================================================================================  
// 03/13/2017 Tom Barrett TPB Made significant changes where code was reading the Enrollment__c
//                            object to get the latest Rpt_Dt__c date value.
//                            The replacement is to read the Enrollent_Import__c object instead.                                  
//==============================================================================================      

trigger Enrollment_trigger on Enrollment__c ( after insert, after delete, after update, before delete ) {
    
    /// BEGIN  ROLL UP CODE
    /**************************************************************************************
     * First IF statement checks if it is a BEFORE trigger on a delete and if it is set the 
     * Latest run date which is stored as  static variable so that it can retain its 
     * value when the AFTER trigger fires so it can be used to delete the record based on
     * the last run date value even if the last record is deleted.
     * If the last record never was deleted for a given run date then this code would not
     * even be necessary and most likely that scenario will not happen but wanted to code
     * for it just in case.
     *
     * Second IF statement check if it is an After trigger on  Insert or Update and if it
     * is calls the Enrollment_ContractSummary.ContractSummary method passing in the 
     * Trigger.new list
     * 
     * Third IF statement checks if it is an After trigger on delete and if it is calls the
     * Enrollment_ContractSummary.ContractSummary method passing in the Trigger.old list.
     * CURRENT KNOWN LIMIT: If the last record that matches the RPT_DT__c value on the
     *                      enrollment__c object is deleted the roll up does not update
     *                      correctly.  This is because in the Enrollment_ContractSummary
     *                      class's ContactSummary method uses an aggregate query that
     *                      would return no record.  Because there is no record there is
     *                      no account id to reference and update the latest values
     *************************************************************************************/ 
    if ( Trigger.isBefore && Trigger.isDelete ) {
        //BEGIN CHANGE TPB 03/13/2017
           //Enrollment_QueryBase.SetLatestEnrlRunDt(); 
        Enrollment_QueryBase.GetLatestEnrlRunDt51();        
        //END CHANGE TPB 03/13/2017      
    }
    If ( Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) ) {
        Enrollment_ContractSummary ecs = new Enrollment_ContractSummary();
        ecs.ContractSummary(Trigger.new);
    }
    If ( Trigger.isAfter && Trigger.isDelete ) {
        Enrollment_ContractSummary ecs = new Enrollment_ContractSummary();
        ecs.ContractSummary(Trigger.old);
    }      
    /// END ROLL UP CODE    
}