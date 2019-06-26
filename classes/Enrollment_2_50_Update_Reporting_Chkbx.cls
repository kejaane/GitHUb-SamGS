/*############################################################################################################################
Class        :   Enrollment_2_50_Update_Reporting_Chkbx
Author       :   Ashish Ojha
Created Date :   5/18/2015
Description  :   This class is used to update the Reporting_Checkbox_Off_Cycle__c and Reporting_Checkbox__c to true correspondingly 
                    from Reporting_Checkbox__c,Reporting_Checkbox_Formula_Off_Cycle__c.
Execution    :   Enrollment_2_50_Update_Reporting_Chkbx bc = new Enrollment_2_50_Update_Reporting_Chkbx(null);
                 database.executeBatch(bc);
*/
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
// 03/29/2016    Tom Barrett    Made changes to handle a new custom setting field that will allow for
//                              multiple email addresses to be entered dynamically without changing code  
//====================================================================================================
global class Enrollment_2_50_Update_Reporting_Chkbx implements Database.Batchable<SObject>,database.stateful{
 
    private String aquery=null;
    private String EmailBody = '';
    private integer BatchCount = 0; 
    private static final String Subject = 'Apex: Enrollment_2_50_Update_Reporting_Chkbx';
 
    //Constructor for the batch : to pass the query from developer console.
    public Enrollment_2_50_Update_Reporting_Chkbx(String query) 
    {
        this.aquery = query;
    }
    global database.querylocator start(Database.BatchableContext bc)
    {
           //Query on the Enrollment__c Objects, and querying all records provided that either of the reporting checkbox formula is set to true.
           String Query = 'select id, Reporting_Checkbox__c,Reporting_Checkbox_Formula_Off_Cycle__c,Reporting_checkbox_off_cycle__c,Reporting_Checkbox_Formula_On_Cycle__c FROM Enrollment__c WHERE Reporting_Checkbox_Formula_Off_Cycle__c = true or Reporting_Checkbox_Formula_On_Cycle__c = True ';
           if(aquery!=NULL)
           {
              query=aquery;  
           }      
           return Database.getQueryLocator(query);   
   }
     global void execute(Database.BatchableContext bc, Enrollment__c[] enrlList)
     {
     /*****************************************************  Variable Declaration *********************************************/
     //Map to store Entity Id of account and the account record.
      BatchCount += 1;
      if(enrlList != null && enrlList.size() > 0){
          for (enrollment__c b:enrlList){
             if(b.Reporting_Checkbox_Formula_Off_Cycle__c == true){
                 b.Reporting_checkbox_off_cycle__c = true;
             }
             if(b.Reporting_Checkbox_Formula_On_Cycle__c  == true){
                 b.Reporting_checkbox__c = true;
             }
          }
          database.update(enrlList);
      }
     /***************************************************End Variable Declaration*********************************************/
    }
    global void finish(Database.BatchableContext bc) {
          // Query the AsyncApexJob object to retrieve the current job's information.
        try {
            AsyncApexJob a = [ SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                           FROM AsyncApexJob 
                           WHERE Id = :BC.getJobId() and JobType <> 'BatchApexWorker' ];
            // Build email message
           // Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                         
            EmailBody += '<b>The Batch Apex job</b> ' + a.Status + '.<br/>';               
            EmailBody += '<b>The Batch Apex job processed</b> ' + a.TotalJobItems + ' <b>batches with</b> ' + a.NumberOfErrors + ' <b>failures.</b><br/>';
            EmailBody += '<b>The job was executed by:</b> ' + a.CreatedBy.Email + '.<br/><br/>';
          
//BEGIN CHANGE TPB 03/29/2016 
//NOTE: Before 03/29/2016 update the testEmail was used.
//      this is no longer needed.  Go to the DynamicCodeDataStore record 'EmailSupportTeams' when testing       
    // BEGIN: THIS CODE SHOULD ONLY BE UNCOMMENTED DURING TESTING       
                /*
                Utils.EmailUtil testEmail = new Utils.EmailUtil(new List<String>{UserInfo.getUserEmail()}); 
                testEmail.subject(subject);
                testEmail.replyTo(UserInfo.getUserEmail());
                testEmail.htmlBody(emailBody);
                testEmail.sendEmail();     
                */              
    // END: THIS CODE SHOULD ONLY BE UNCOMMENTED DURING TESTING   
    // BEFORE MOVING TO PRODUCTION COMMENT OUT THE CODE ABOVE AND UNCOMMENT THE LINE BELOW
    //         EmailAlerts.emailAdmins(subject, emailBody);  
           DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');
           string[] toAddresses = cs.Text_255__c.Split(',');
           Utils.EmailUtil Email = new Utils.EmailUtil(toAddresses); 
           Email.subject(subject);
           Email.replyTo(UserInfo.getUserEmail());
           Email.htmlBody(emailBody);
           Email.sendEmail();                                       
// END CHANGE TPB 03/29/2016  
                                        
                              
        } catch(System.Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_2_50_Update_Reporting_Chkbx.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                     
        }   
     }    
}