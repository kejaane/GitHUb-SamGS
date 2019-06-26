//=========================================================================================
//      Date: 06/05/2013
// Developer: Tom Barrett (TPB)
//   Purpose: This class is used to retrieves all Enrollment_Recycle__c records, copies 
//            them to the Enrollemnt_Recycle_Archive__c object then deletes the records 
//            all records from the Enrollment_Recycle__c object.
//            The Enrollment_ArchiveRecycle_Schedule class calls this class
//
//     Usage: Enrollment_ArchiveRecycle ear = new Enrollment_ArchiveRecycle();           
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
// 03/29/2016    Tom Barrett    Made changes to handle a new custom setting field that will allow for
//                              muliple email addresses to be entered dynamically without changing code  
//====================================================================================================
public class Enrollment_ArchiveRecycle {
    public Enrollment_ArchiveRecycle() {
        final string Subject = 'Apex: Enrollment_ArchiveRecycle';
        string EmailBody = '';
        integer CopyEnrollmentRecycleDataCount = 0;
        integer DeleteEnrollmentRecycleCount = 0;
        string ErrorMsg = '';
        boolean ErrorOccurred = FALSE;
        // Build a complete set of Enrollment_Recycle__c records 
        // This will be used to archive the Enrollments_Recycle records 
        Set<Id> EnrollmentRecycleRecIdsSet = new Set<Id>();
        for ( List<Enrollment_Recycle__c> er : [ SELECT id FROM Enrollment_Recycle__c ] ) {
            for ( Enrollment_Recycle__c e : er ) {
                EnrollmentRecycleRecIdsSet.add(e.id);
            }            
        }   
        SavePoint sp = Database.setSavePoint();
        try {
            // Call this method with FALSE so that the Enrollment_Recycle_Archive's 
            // Processed__c field is FALSE which means the records did not get processed for the current month
            CopyEnrollmentRecycleDataCount = Enrollment_QueryBase.CopyEnrollmentRecycleData(EnrollmentRecycleRecIdsSet, FALSE);
            DeleteEnrollmentRecycleCount = Enrollment_QueryBase.DeleteEnrollmentRecycleData(EnrollmentRecycleRecIdsSet);
            
        } catch (System.Exception e) {  
            Database.Rollback(sp);                  
            ErrorMsg += 'Exception in Enrollment_ArchiveRecycle Class: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage(); 
            ErrorOccurred = TRUE;
            System.debug(LoggingLevel.ERROR, ErrorMsg);            
        } finally {
            // Build email body and send email
            EmailBody += '<b>Enrollment Archive Recycle Completed.</b><br/>';
            EmailBody += '<b>Total Enrollment Recycle Records Copied:</b> ' + CopyEnrollmentRecycleDataCount + '<br/>';
            EmailBody += '<b>Total Enrollment Recycle Records Deleted:</b> ' + DeleteEnrollmentRecycleCount + '<br/><br/>';         
            If ( ErrorOccurred ) {
                ErrorMsg = '<b>AN ERROR OCCURRED!</b><br/>' + ErrorMsg;
                EmailBody += ErrorMsg;
            }
            
// BEGIN CHANGE TPB 03/29/2016
            // COMMMENT OUT ONLY DURING TESTING
            //EmailAlerts.emailAdmins(Subject, EmailBody); 
                        
            // THIS CODE SHOULD ONLY BE UNCOMMENTED DURING TESTING            
//            Utils.EmailUtil testEmail = new Utils.EmailUtil(new List<String>{UserInfo.getUserEmail()}); 
//            testEmail.subject(subject);
//            testEmail.replyTo(UserInfo.getUserEmail());
//            testEmail.htmlBody(emailBody);
//            testEmail.sendEmail();  

           DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');
           string[] toAddresses = cs.Text_255__c.Split(',');
           Utils.EmailUtil Email = new Utils.EmailUtil(toAddresses); 
           Email.subject(subject);
           Email.replyTo(UserInfo.getUserEmail());
           Email.htmlBody(emailBody);
           Email.sendEmail();    
// END CHANGE TPB 03/29/2016   
        } 
    }
}