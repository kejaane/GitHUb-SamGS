public class PCMH_Tasks {
    public static void process(List<Task> tasks) {
    
        for (Task tsk : tasks) {
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
}