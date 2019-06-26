/***********************************************************************************

     Date: 03/26/11
Developer: Tom Barrett
  Purpose: To handle any programmatic functionality for inserts and update           
***********************************************************************************/
trigger Activity_trigger on Task (before insert, before update){
    for (Task tsk : Trigger.new) {
        //PCMH Logic      
        if ( tsk.Subject == 'PCMH Presentation' && tsk.ActivityDate <> null && 
             tsk.ActivityDate > tsk.PCMH_Presentation_Date__c && tsk.PCMH_Decision__c == 'Yes' ) { 
            tsk.ActivityDate.addError('TR001: When Status is \'Completed\' and PCMH Decision is \'Yes\' the Due Date must be earlier than PCMH Effective Date');       
        }
        
        // If it is a recurrence activity we cannot update the ActivityDate because SFDC errors
        if ( tsk.ActivityDate == null && tsk.Subject == 'PCMH Presentation' && !tsk.IsRecurrence ) {        
            tsk.ActivityDate = tsk.PCMH_Presentation_Date__c;
        }
    }
}