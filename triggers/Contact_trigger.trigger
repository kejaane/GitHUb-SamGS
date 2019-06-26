/******************************************************************************************
 *      Date: 11/01/2013
 * Developer: Tom Barrett
 *   Purpose: To handle any programmatic Contact Trigger Events        
 ******************************************************************************************/
trigger Contact_trigger on Contact ( after insert, after delete, after update, before insert, before update, before delete ) {      
    if ( Trigger.isBefore ) {
        if ( Trigger.isInsert || Trigger.isUpdate ) { 
        
            //TPB 06/08/2016 - added emergency fix to bypass if batch processing 
            if(System.isBatch()) {
                System.debug('Contact_Trigger: Bypassing EGP Processing in Contract_Trigger, Trigger when called from a batch job');
                return;
            }
                     
            EmployerGroupPortal egp = new EmployerGroupPortal();
            egp.contacts = Trigger.new;
            egp.oldMap = Trigger.oldMap;
            egp.isInsert = Trigger.isInsert;
            egp.egpValidation();
        }        
    }
}