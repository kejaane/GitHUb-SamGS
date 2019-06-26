/*########################################################################################################################
Class        :   Enrollment_Group_Flag_Process
Author       :   Ashish Ojha 
Created Date :   11/25/2014
Description  :   This class reads the Enrollment__c records and sets the Group__c number and the Groups_Medical__c field
                 to a 1 or 0 based on business rules.                 
Overloaded   :   There are two overloaded methods, one takes a single parameter and it is only for test scripts; while
                 the other method also has one parameter.  
                 The parameter is for how much data is updated based on the Rpt_Dt__c field.  If the parameter value
                 is '' then all records are updated.  If the parameter value contains a format of CCYYMM and data matches then only
                 the matching records are updated.  This paramter should be '' for the first initial execution and then the CCYYMM
                 value should be supplied thereafter so that we only update what is necessary.  If 'RECENT' is supplied as a parameter
                 then the most recent Rpt_Dt__c value will be dynamically added to the WHERE clause for updating the records.

DEPENDENCY NOTES: The Sort_Key_Process_Type__c is the driver for the logic to work correctly.  
                  If this formula field is ever changed one must review and test this class for impacts               
USAGE:      
    Testing Only   
             :   Enrollment_Group_Flag_Process ep = new Enrollment_Group_Flag_Process(TRUE);

    populates all records on Groups__c and Groups_Medical__c
             :   Enrollment_Group_Flag_Process ep = new Enrollment_Group_Flag_Process('');

    populates Groups__c and Groups_Medical__c for a specific period
             :   Enrollment_Group_Flag_Process ep = new Enrollment_Group_Flag_Process('201401');
    
    BEGIN DEPRECATED TPB 03/13/2017
    populates Groups__c and Groups_Medical__c for the most recent period
             :   Enrollment_Group_Flag_Process ep = new Enrollment_Group_Flag_Process('RECENT' );
    END DEPRECATE TPB 03/13/2017


Execute      :   ID batchprocessId = Database.executeBatch(ep);
*/
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
// 03/30/2016    Tom Barrett    Made changes to handle a new custom setting field that will allow for
//                              muliple email addresses to be entered dynamically without changing code 
// 06/22/2016    Ashish Ojha    Changed Account_Number to EIN on Orderby and Key pair selection 
//
// 03/13/2017    Tom Barrett    Deprecated the method that uses the RECENT parm.  
//====================================================================================================
global class Enrollment_Group_Flag_Process implements Database.Batchable<SObject>,database.stateful{
    Integer totFailure = 0;
    Integer totProcessed = 0;
    private Boolean ForTestingOnly = False;
    Integer totUpdates = 0;
    private String EmailBody = '';
    private integer BatchCount = 0; 
    private String Subject = 'Apex: Enrollment_Group_Flag_Process'; 
    private String NonTrappableErrorMsg = '';
    private Boolean NonTrappableError = FALSE;
    private String RptDt = '';
    private String Query = 'SELECT Id, Rpt_Dt__c, Account_Number__c, EIN__c, Groups__c, Groups_Medical__c, Processed_Type__C FROM Enrollment__c where RecordType.developername = \'X2_50\' ';
   //AO changes Begin 06/22/2016
    private String OrderBy = ' ORDER BY Rpt_Dt__c, EIN__c, Sort_Key_Process_Type__c DESC';
   //AO changes End 06/22/2016 
    private String KeyPairPrev = ''; //this field helps determine the keymatch value between batches
    public class Enrollment_Group_Flag_ProcessException extends Exception{}

    
     /**************************
      * BEGIN OVERLOAD METHODS *
      **************************/   
    
    // This method is only for passing test script code coverage and should only 
    // be called by a test script.  You should never use it for anything else
    public Enrollment_Group_Flag_Process(Boolean ForTestingOnly) {   
        Subject += '(' + ForTestingOnly + ')';
        this.ForTestingOnly = ForTestingOnly; 
        this.Query += this.OrderBy; 
    }        
    
    /****************************************************************************************************
     * ProcessedType: Currently should only be 'M' or ''
     *                When '' is the value the Groups__c field will be updated
     *                When 'M' is the value the Groups_Medical__c field will be updated
     *         RptDt: Currently should be a CCYYMM (i.e.: 201401 which means January 2014) format, 'RECENT' or '' 
     *                When '' is the value all records are updated
     *                When CCYYMM is the value only those records are updated
     *                When 'RECENT' is the value then the latest RPT_Dt__c value is used to update the records
     ****************************************************************************************************/     
    public Enrollment_Group_Flag_Process(String RptDt) {         
        String WhereClause = '';
        Subject += '(' + RptDt + ')';       
        this.RptDt = RptDt.trim();
/*        
        if ( this.ProcessedType.length() > 0 && this.ProcessedType.capitalize() != 'M' ) {            
            throw new Enrollment_Group_Flag_ProcessException('Parameter must be \'\' or \'M\' only!');              
        } 
*/
        if ( this.RptDt.length() != 0 ) { 
            //BEGIN DEPRECATE TPB 03/13/2017
            // Parameter value is 'RECENT' so lets get the most recent Rpt_Dt__c value and use it
            /*
            if ( this.RptDt.capitalize() == 'RECENT' ) {
                this.RptDt = [ SELECT Rpt_Dt__c FROM Enrollment__c ORDER BY Rpt_Dt__c DESC LIMIT 1 ].Rpt_Dt__c;
            }
            */
            //END DEPRECATE TPB 03/13/2017
            WhereClause = ' and Rpt_Dt__c = \'' +  this.RptDt + '\' ';              
        }           
        this.Query += WhereClause + this.OrderBy;         
    }    
    /************************
     * END OVERLOAD METHODS *    
     ************************/
    
    
    global database.querylocator start(Database.BatchableContext bc) {        
System.debug('Query: ' + Query); 
        return Database.getQueryLocator(Query);           
    }
    
    global void execute(Database.BatchableContext bc, Enrollment__c[] Enrollment2_50List) { 
        BatchCount += 1;
        List<Enrollment__c>   enrlListToUpdate = new List<Enrollment__c>();
        Enrollment__c enrl2_50;  
        String keyPair;
            
        /******************* Iterating on all the Enrollment__c Records ***********************************/   
        for(Enrollment__c enrl: Enrollment2_50List){
            totprocessed += 1;
            //AO Changes 06/22/2016
            KeyPair = enrl.Rpt_Dt__c + enrl.EIN__c;
            //AO Changes 06/22/2016
            enrl.Groups__c = 0;
            enrl.Groups_Medical__c = 0;               
          
            if ( KeyPair != KeyPairPrev ) {
                KeyPairPrev = KeyPair;
                enrl.Groups__c = 1; 
                // Only used to assist with throwing an error for the test script
                if( ForTestingOnly ) enrl.Groups__c = 99;
                // only make Groups_Medical__c = 1 only for first of matching keypair and when enrl.Processed_Type = 'M'
                if ( enrl.Processed_Type__c.capitalize() == 'M' ) enrl.Groups_Medical__c = 1;
                // Only used to assist with throwing an error for the test script
                if( ForTestingOnly ) enrl.Groups_Medical__c = 99;                 
            }  
            enrlListToUpdate.add(enrl);
        } 
        
        Savepoint sp = Database.setSavepoint();                 
        try{
            update enrlListToUpdate;                            
         }catch(System.Exception e){
             Database.rollback(sp);
             System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_Group_Flag_Process.Execute: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
             NonTrappableErrorMsg += '<b>Exception in Enrollment_Group_Flag_Process.Execute: Error at line</b> ' + e.getLineNumber() + ' - ' + e.getMessage() + '<br/>'; 
             NonTrappableErrorMsg += '<b>Error occured during batch #</b>' + BatchCount + '<br/>';  
             NonTrappableError     = true; 
             totfailure += enrlListToUpdate.size();                  
             throw new Enrollment_Group_Flag_ProcessException(NonTrappableErrorMsg);                                     
         }
         totupdates = totprocessed - totfailure;
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
            EmailBody += '<b>Total Enrollment 2-50 Records Processed: </b> ' + totprocessed + '<br/>';                
            EmailBody += '<b>Total Enrollment 2-50 Record Updated: </b> ' + totUpdates + '<br/>';
            EmailBody += '<b>Total Enrollment 2-50 Records Failure: </b> ' + totfailure + '<br/>';

            if (NonTrappableError || Test.isRunningTest()) {
                EmailBody += '<br/><b>*** SERIOUS ISSUE OCCURED ***</b><br/>';
                EmailBody += NonTrappableErrorMsg + '<br/><br/>';
                EmailBody += '<b>Check the logs for details.</b><br/>';
            }
            
            
//BEGIN CHANGE TPB 03/30/2016 
//NOTE: Before 03/30/2016 update the testEmail was used.
//      this is no longer needed.  Go to the DynamicCodeDataStore record 'EmailSupportTeams' when testing              
           // if ( QueryBase.isProductionOrg() ) {               
           //     EmailAlerts.emailAdmins(subject, emailBody);
           // } else {
           //     Utils.EmailUtil testEmail = new Utils.EmailUtil(new List<String>{UserInfo.getUserEmail()}); 
           //     testEmail.subject(subject);
           //     testEmail.replyTo(UserInfo.getUserEmail());
           //     testEmail.htmlBody(emailBody);
           //     testEmail.sendEmail();  
           // }  
           DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');
           string[] toAddresses = cs.Text_255__c.Split(',');
           Utils.EmailUtil Email = new Utils.EmailUtil(toAddresses); 
           Email.subject(subject);
           Email.replyTo(UserInfo.getUserEmail());
           Email.htmlBody(emailBody);
           Email.sendEmail();                                       
// END CHANGE TPB 03/30/2016             
                         
        } catch(System.Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_Group_Flag_Process.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                     
        }   
    }    
}