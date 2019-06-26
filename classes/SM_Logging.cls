//=========================================================================================
//      Date: 05/17/2018
// Developer: Tom Barrett
//   Purpose: This class performs the insert to the SM_Log__c object doing a save in the
//            same context (thread) or a different thread using the Queueable Apex feature.  
//            It takes a list of the SM_Support.LogWrapper class which contains the records 
//            to insert into the SM_Log__c table/object.
//            In addition, it does self cleaning by deleting older log records based on
//            the second parameter passed in which comes from the value set in the 
//            SM_Setting__mdt record 'Log_Deletion' record.  The value is stored in the 
//            Number__c field on that record.
// Special
// Attentions:               
//            The code was written to do a queueable context insert and an insert in the same
//            context due to a limitation of sales force.  The error that was occuring was:
//            'MIXED_DML_OPERATION, DML operation on setup object is not permitted after you 
//            have updated a non-setup object'.  
//            
//            Currently only the Deactivate User module's DUservice process has this issue 
//            and utilizes the first example syntax below while all the other modules use 
//            the second syntax example.
//
//  Usage:
//  Enqueue Example
//		SM_QueueableLog ql = new SM_QueueableLog(ResponseWrapperMap.values(), SM_Support.DayToStartDeletion, true);
//	    System.enqueueJob(ql);     
//	    
// Non Enqueue Example which saves the log in the same context
//      SM_QueueableLog ql = new SM_QueueableLog(ResponseWrapperMap.values(), SM_Support.DayToStartDeletion, false);
//                     
//=========================================================================================
//                                 Update History
// Date       Developer			Tag      Description
//=========================================================================================
//  
//=========================================================================================
public class SM_Logging implements Queueable {
    List<SM_Log__c> LogList = new List<SM_Log__c>();
    List<SM_Support.LogWrapper> LogWrapper;
    Datetime dt = System.now();
    Integer DayToStartDeletion;  

    //Used for the queueable/enque capabilities or standard saves in the same context.
    //See above class header for proper usage between queuable saves to the log  or 
    //saves to the log in the same context thread
    public SM_Logging(List<SM_Support.LogWrapper> LogWrapper, Integer DayToStartDeletion, Boolean Enqueued) { 
        System.debug('---SM_Logging---');
    	this.LogWrapper = LogWrapper;
        this.DayToStartDeletion = DayToStartDeletion;
        if (!Enqueued) {
            BuildLogRecords(); 
            Insert this.logList; 
            DeleteOldLogs(); 
        }
    }      
    
    //This is when the code actually runs in a seperate thread
    public void execute(QueueableContext context) {
        System.debug('---SM_Logging.execute---');
        BuildLogRecords();
        Insert this.logList; 
        DeleteOldLogs(); 
    }
    
    private void BuildLogRecords() {
        System.debug('---SM_Logging.BuildLogRecords---');
        for (SM_Support.LogWrapper r : logWrapper) {            
            SM_Log__c log = new SM_Log__c(); 
            log.Email_Grouping__c = r.EmailGrouping;
            log.Log_Grouping__c = r.LogGrouping;
            log.Sandbox_Name__c = r.SandboxName;            
            log.Severity__c = r.Severity;   
            log.Message_Source__c = r.MsgSource;
            log.Message__c = r.Msg;
            log.Username__c = r.Username;
            log.Profile_Name__c = r.ProfileName;
            log.Permission_Sets__c = r.PermissionSets;
            log.Source_Last_Modified_Date__c = r.LastmodifiedDate;
            log.Last_Login_Date__c = r.LastLoginDate;
            if(r.isFrozen == null) r.isFrozen = 'n/a';
            log.IsFrozen__c = r.isFrozen;
            this.LogList.add(log);            
        }    
    }
    
    private void DeleteOldLogs() {
        System.debug('---SM_Logging.DeleteOldLogs---');
        //Calculate the Deletion date by turning the number
        //to a negative number so th addDays method subtracts.
        DayToStartDeletion = DayToStartDeletion * -1;    
        //Calculate the date.  If the custom metedata record 'Log_Deletion' is zero or blank
        //then dt will equal today and if so we return without cleaning up the logs (delete).
        this.dt = this.dt.addDays(DayToStartDeletion);
        //If SM Settings 'Log_Deletion' equals zero return
        if (DayToStartDeletion == 0) return; 
     
        //Clean up the log because you were taught to clean up after yourself -- right?
        List<SM_Log__c> Log  = [SELECT ID, CreatedDate FROM SM_Log__c WHERE CreatedDate <= :this.dt LIMIT 5000];  
        try {
        	Delete log;
            System.debug('Deleted ' + log.size() + ' log records');
            if(log.isEmpty()) return;
            Database.emptyRecycleBin(log);            
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage() + ' - occurred at line number: ' + e.getLineNumber());
        }
    }
}