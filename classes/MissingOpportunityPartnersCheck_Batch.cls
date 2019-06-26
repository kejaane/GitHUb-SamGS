//=====================================================================
//     Date: 08/09/2010
//Developer: Tom Barrett
//  Purpose: To iterate through the Opportunity object and set the 
//           custom field 'MissingParnters to false if related
//           Opportunity Partner Record(s) are found; otherwise,
//           set the field to true.
//           If the LastModifiedBy field is equal to the user running
//           the job then the custom field LastModifiedByUser__c will
//           not be updated.
//           A report is used in conjunction with this custom field
//           in order to produce a report that shows Opportunities
//           with missing related Opportunity Partner records.
//
//More Info: In addition, the system administrators are notified
//           by email if an error occurs.  If a DML error occurs
//           valid records are committed to the database and an
//           email listing the record(s) that could not be saved
//           will be sent to the system administrators.
// Related
// Code     : MissingOpportunityPartnersCheck
//            MissingOpportunityParntersCheck_Schedule
//            MissingOpportunityPartnersCheck_Test
//            MissingOpportunityPartnersCheck_Batch
//            MissingOpportunityPartnersCheckReset (For Test Only)
//=====================================================================

global class MissingOpportunityPartnersCheck_Batch implements  Database.Batchable<sObject> {
    global final string query;
    global MissingOpportunityPartnersCheck_Batch (String q) {
       query = q;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {    
       return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext info, List<Opportunity> scope){
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for(Opportunity o : scope){ 
            if ( o.OpportunityPartnersFrom.size() > 0 ) {
                o.MissingPartner__c = false;    //Opportunity has partner record(s)                               
            } else {                                        
                o.MissingPartner__c = true;     //Opportunity is missing partner record(s)                 
            }   
            // Update the Custom field so we can know who really last modified the record
            // This is necessary because the audit trail from user updates would be lost, otherwise            
            if ( o.LastModifiedby.Name <> UserInfo.getName() ) {                
                o.Last_Modified_By_User__c = o.LastModifiedBy.Name + ', ' + o.LastModifiedDate.formatLong(); 
            }          
           oppsToUpdate.add(o); 
        }     

        integer x = 0; 
        boolean errsOccur = false;
        string errMsg;
        string subject;
        try {                           
            // Build results object array during the update process                              
            Database.SaveResult[] results = Database.Update(oppsToUpdate, false); 
            if (results != null){                
                errMsg = 'The Apex MissingOpportunityPartnersCheck.Check method threw the following exception: ' + 
                         '<br><br>';
                // Loop through the results object array
                for ( Database.SaveResult result : results ) {                    
                    if ( !result.isSuccess() ) {
                        errsOccur = true;                        
                        Database.Error[] errs = result.getErrors();
                        // Loop through the errors contained in the result array
                        for( Database.Error err : errs ) {
                            errMsg = errMsg + '#' + x + ') ID = ' + oppsToUpdate[x].Id + ' - ' + err.getStatusCode() + ' - ' + 
                            err.getMessage() + '<br><br>';                                                      
                        }                                         
                    } 
                    x = x + 1;                 
                }
                if ( errsOccur ) {
                    subject = 'Apex MissingOpportunityPartnersCheck.Check method - DMLException';
                    // Send an email to the Admin on failure.
                    EmailAlerts.emailAdmins(subject, errMsg);
                }
            }                     

       } catch (Exception e) {
            subject = 'Apex MissingOpportunityPartnersCheck.Check - Exception';
            EmailAlerts.emailAdmins(subject, e.getMessage());            
       } 
   }    
    
    global void finish(Database.BatchableContext BC){
      // Get the ID of the AsyncApexJob representing this batch job  
      // from Database.BatchableContext.    
      // Query the AsyncApexJob object to retrieve the current job's information.  
    
     AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
       TotalJobItems, CreatedBy.Email
       from AsyncApexJob where Id =:BC.getJobId()];       
           
      // Send an email to the Apex job's submitter notifying of job completion.      
      string subject = 'Apex MissingOpportunityPartnersCheck_Batch ' + a.Status;
      string body = 'The batch Apex job MissingOpportunityPartners_Batch processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.';
      If ( a.NumberOfErrors > 0 ) {  
          EmailAlerts.emailAdmins(subject, body);   
      }         
/*       
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      // Send to Job Schedule Creator Only
      //String[] toAddresses = new String[] {a.CreatedBy.Email};
      String[] toAddresses = new String[] 
      mail.setToAddresses(toAddresses);
      mail.setSubject('Apex MissingOpportunityPartnersCheck_Batch ' + a.Status);
      mail.setPlainTextBody('The batch Apex job MissingOpportunityPartners_Batch processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
    
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
*/
    }

}