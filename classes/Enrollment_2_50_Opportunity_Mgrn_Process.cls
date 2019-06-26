/*Class      :   Enrollment_2_50_Opportunity_Mgrn_Process
Author       :   Ashish Ojha
Created Date :   06/25/2016
Description  :   This class is used update opportunity data from Enrollment_Import_2_50__c to Opportunity object.
                 Opportunitis are updated based on the concatination of
                 Facets_Account_Number__c + Recordtype name and Contract Effective date as the Key.
                 The batch will run through all the records in Enrollment_Import_2_50__c object 
                 that have Processed_opportunity = False and Term reason = 'GRHX'. this batch process updates opportunity's 
                 Stage, Won/lost Reason fields with hard coded values. It will also update the Termination date field.                     
Instantiate  :   Enrollment_2_50_Opportunity_Mgrn_Process ep = new Enrollment_2_50_Opportunity_Mgrn_Process();
          OR :   Enrollment_2_50_Opportunity_Mgrn_Process ep = new Enrollment_2_50_Opportunity_Mgrn_Process(TRUE);
Execution    :   Enrollment_2_50_Opportunity_Mgrn_Process bc = new Enrollment_2_50_Opportunity_Mgrn_Process(FALSE);
                 database.executeBatch(bc);
*/
//====================================================================================================
//                                 Update History
// Date          Developer      Description

//====================================================================================================
global class Enrollment_2_50_Opportunity_Mgrn_Process implements Database.Batchable<SObject>,database.stateful{
    Integer totOppFailures = 0;
    Integer totOppUpdate = 0;
    Integer totprocessed = 0;
    
   
    String fmtDate;
    DateTime dt; 
    Time fmtTime; 
    // This variable is used to when we are passing the query from the developer console
    private Boolean ForTestingOnly = False;
    private String entType = null;
    private String EmailBody = '';
    private integer BatchCount = 0;
    private static final String Subject = 'Apex: Enrollment_2_50_Opportunity_Mgrn_Process';
    private String NonTrappableErrorMsg = '';
    private Boolean NonTrappableError = FALSE;
    private String failedRecordIds = '';
    public class Enrollment_2_50_Opportunity_Mgrn_ProcessException extends Exception{}
    //Constructor for the batch : to pass the query from developer console.
    // Also for testing purpose only, we are passing a boolean value to be false
    public Enrollment_2_50_Opportunity_Mgrn_Process(boolean ForTestingOnly) {
        this.ForTestingOnly = ForTestingOnly;      
    }
    global database.querylocator start(Database.BatchableContext bc) {   
       String Query = 'Select id,Account_Number__c,External_id__c,Term_Date__c, Contract_Effective_Date__c, Account_Name__c, Term_Reason__c ' +
                       'FROM Enrollment_Import_2_50__c ' +
                       'WHERE processed_opportunity__c = false and Term_Reason__c = \'GRHX\'';                        

        return Database.getQueryLocator(query); 
        
    }
  
    global void execute(Database.BatchableContext bc, Enrollment_Import_2_50__c[] EnrollmentImpList) {
        BatchCount += 1;
        
        Set<String> ExternalKeySet              = new Set<String>();
        Map<String, Opportunity> OpportunityMap = new Map<String, Opportunity>();      
        map<id,opportunity> updOppMap           = new map<id,opportunity>();  
        /******************* Iterating on all the Enrollment 2-50 Import Records ***********************************/ 

        //List of Enrollment 2-50 import object which we are getting from Start method
        if(EnrollmentImpList != null && EnrollmentImpList.size() > 0){       
            for(Enrollment_Import_2_50__c enrl: EnrollmentImpList){
   
        //Add all External ID field into a Set
                ExternalKeySet.add(enrl.External_id__c);
                totprocessed += 1;
                enrl.Processed_opportunity__c = true;
             }
                if(ExternalKeySet.size() >0){
                 OpportunityMap = new Map<String, opportunity>();
        //iterate through all opportunities that have the Same external Key as the ones in the Set we created above
        //and put them in a map with corresponding external Key           
                 for(opportunity opp: [select id, termination_date__c, Won_Lost_reason__c, external_Key__c,stageName from opportunity where external_Key__c in: ExternalKeySet]){
                 OpportunityMap.put(opp.external_Key__c,opp);
                 }
        //iterate though the Enrollment import list and check to see if the opportunity map's key has matching external Id                 
                         for(enrollment_import_2_50__c enrl : EnrollmentImpList){
                         if(OpportunityMap.containskey(enrl.External_id__c)){
        //if it does we get the instance of the opportunity with a matching External id and add them to a new Map                    
                            opportunity oppObj = OpportunityMap.get(enrl.External_id__c);
                            if(!ForTestingOnly){
                                oppObj.Termination_Date__c = enrl.Term_Date__c;
                                }
                                oppObj.StageName = 'Migrated to DCHL';
                                oppobj.Won_Lost_reason__c = 'Group Terminated Due to Migration to DCHL';  
                                
       // using Map to avoid duplicate opportunity as we have multiple enrollment for single opportunity                  
                               updOppMap.put(oppObj.id,oppObj);
                           
                           }
                           
                      }
                      System.debug('count of oop map::' + updOppMap.size());
                   }
                 } 
                  

        if(updOppMap != null && updOppMap.size() > 0) {
      
        Savepoint sp = Database.setSavepoint();

              try{
        
            // Update the map with opportunity as value with enrollement termination date.
            update updOppMap.values();
            totOppUpdate = updOppMap.size() ;
            
            if(EnrollmentImpList != null && EnrollmentImpList.size() > 0){
                update EnrollmentImpList;
                    
                }
                                         
         }catch(System.Exception e){
             Database.rollback(sp);
             System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_2_50_Opportunity_Mgrn_Process.Execute: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
             NonTrappableErrorMsg += '<b>Exception in Enrollment_2_50_Opportunity_Mgrn_Process.Execute: Error at line</b> ' + e.getLineNumber() + ' - ' + e.getMessage() + '<br/>';
             NonTrappableErrorMsg += '<b>Error occured during batch #</b>' + BatchCount + '<br/>';
             NonTrappableError     = true;
             totOppFailures += updOppMap.size();             
             throw new Enrollment_2_50_Opportunity_Mgrn_ProcessException(NonTrappableErrorMsg);    
            }                          
         }
         
         //totEnrlFailure = totprocessed - enrolmentInsertCount ;
         /***************************************************End Variable Declaration*********************************************/
     }
   
    global void finish(Database.BatchableContext bc) {
        // Query the AsyncApexJob object to retrieve the current job's information.
        try {
            AsyncApexJob a = [ SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                               FROM AsyncApexJob
                               WHERE Id = :BC.getJobId() and JobType <> 'BatchApexWorker' ];
            //Build email message                            
            EmailBody += '<b>The Batch Apex job</b> ' + a.Status + '.<br/>';             
            EmailBody += '<b>The Batch Apex job processed</b> ' + a.TotalJobItems + ' <b>batches with</b> ' + a.NumberOfErrors + ' <b>failures.</b><br/>';
            EmailBody += '<b>The job was executed by:</b> ' + a.CreatedBy.Email + '.<br/><br/>';
            EmailBody += '<b>Begin Main Process</b><br/>';
            EmailBody += '<b>Total Enrollment 2-50 Opportunity Import Records Processed: </b> ' + totprocessed + '<br/>';              
            //EmailBody += '<b>Total Enrollment 2-50 Opportunity Record Updates: </b> ' + totOppupdate + '<br/>';
            EmailBody += '<b>Total Enrollment 2-50 Opportunity Records Failure: </b> ' + totOppFailures + '<br/>';
            if (NonTrappableError || Test.isRunningTest()) {
                EmailBody += '<br/><b>*** SERIOUS ISSUE OCCURED ***</b><br/>';
                EmailBody += NonTrappableErrorMsg + '<br/><br/>';
                EmailBody += '<b>Check the logs for details.</b><br/>';
            }
 
    //         EmailAlerts.emailAdmins(subject, emailBody);  
           DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');
           string[] toAddresses = cs.Text_255__c.Split(',');
           Utils.EmailUtil Email = new Utils.EmailUtil(toAddresses); 
           Email.subject(subject);
           Email.replyTo(UserInfo.getUserEmail());
           Email.htmlBody(emailBody);
           Email.sendEmail();                                       
                                       
                             
        } catch(System.Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_2_50_Opportunity_Mgrn_Process.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                    
        } 
    }
}