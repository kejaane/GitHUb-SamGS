//=========================================================================================
//     Date: 01/26/2015
//Developer: Tom Barrett (TPB)
//  Purpose: This class processes Enrollment fields to create the enrollment baseline 
//           information for each year and record type (2-50 and 51+).
//           To be clear it does not set the initial Fiscal Year.  Refer to the
//           Enrollment_BaselineYearlyShiftBatch class for that. A fiscal year spans from
//           February to January (i.e.: For a 2014 fiscal year it would span from 201402 to 201501 
//           - Note that 201401 is the actual starting baseline for this example).
//           
//           This class first determines the latest Rpt_Dt__c date which is stored in the RptDtCurrent
//           variable then it uses that value to get the begining fiscal baseline Rpt_Dt__c (i.e.: 201401).  
//           The RptDtBegin will be used to build the BaselineMap. Note the baselinemap is only used for 2-50 business.
//           The RptDtCurrent is used to build the query that is interated through.
//           if the recordtype is 2-50 the process reads the Enrollment__c object creating a 
//           the Baselinemap of account_Number__c (key) and AM_Name__c (value) based on the baseline 
//           RptDtBegin time frame.  The baseline time frame/value is always in January of 
//           the prior fiscal year.  Remember the fiscal year is actually February to January.  
//           As each record in the query batch is read if the map is searched for a matching account_number__c and if 
//           found that value is stored on the Curr_Baseline_Owner__c field. In addition, the Curr_Fiscal_Year__c
//           is set to the Rpt_Dt__c value and the Curr_Baseline_Contracts__c are set to zero. 
//           
//           Example: If this code is processed when the current Rpt_Dt__C equals '201501' (any January really) this code
//           will be setting the last month of the fiscal year which is always January.  After this class is executed
//           the Enrollment_BaselineYearlyShiftBatch class must be executed to initiate the new current fiscal year
//           baseline which in this example would 2015 fiscal year.                                  
//
//    Usage: Enrollment_BaselineUpdateBatch job = new Enrollment_BaselineUpdateBatch(Enrollment_BaselineUpdateBatch.BatchType_2_50);
//           ID batchprocessid = Database.executeBatch(job);
//           Or
//           Enrollment_BaselineUpdateBatch job = new Enrollment_BaselineUpdateBatch(Enrollment_BaselineUpdateBatch.BatchType_51_Plus);
//           ID batchprocessid = Database.executeBatch(job);
//           
//Limitations: 
//           Because Salesforce has limitations such as how many records a SOQL query can 
//           return (50k) the year had to be passed as a parm to limit the number of 
//           records. An evaluation count was already performed to confirm that no given 
//           year for the query used in the Enrollment_QueryBase.BuildBaselineMap method 
//           returned more than 50,000 records.           
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
// 03/30/2016    Tom Barrett    Made changes to handle a new custom setting field that will allow for
//                              multiple email addresses to be entered dynamically without changing code 
//
// 03/13/2017 Tom Barrett TPB   Made significant changes where code was reading the Enrollment__c
//                              object to get the latest Rpt_Dt__c date value.
//                              The replacement is to read the Enrollent_Import__c and the 
//                              Enrollment_Import_2_50__c objects instead.                                     
//====================================================================================================
global class Enrollment_BaselineUpdateBatch implements Database.Batchable<sObject>, Database.Stateful{

    public static String BatchType_2_50 = '2-50';
    public static String BatchType_51_Plus = '51+';
   
    // batchType is specified when instantiating this class to specify if the enrollment processing is for 51+ or 2-50 type of
    // enrollment related opportunities. Depending on batchType, execute() delegates processing of a batch to either the executeBatch_2_50() or executeBatch_51_Plus() 
    private String BatchType;   
    private String RptDtBegin = '';
    private String RptDtCurrent = '';
    private String RptBeginYear = '';
    private String Query = '';     
    private Integer batchCount = 0;
    private Map<String, String> BaselineMap = new Map<String, String>();   
    public class Enrollment_BaselineUpdateBatchException extends Exception{}

    global Enrollment_BaselineUpdateBatch(String BatchType){ 
        this.RptDtCurrent = GetRptDtCurrent(BatchType);
        this.RptDtBegin = GetRptDtBegin(this.RptDtCurrent);  
        this.RptBeginYear = String.valueOf(Integer.valueOf(RptDtBegin.left(4)));  
        this.BatchType = BatchType;  
        if ( batchType == Enrollment_BaselineUpdateBatch.BatchType_2_50 ) {
            // Get a map of accounts (Key) and Compensation Owner (value)
            BaselineMap = Enrollment_QueryBase.BuildBaselineMap(this.BatchType, this.RptDtBegin);
            this.query = 'SELECT Rpt_Dt__c, Account_Number__c, Curr_Baseline_Compensation_Owner__c, Curr_Fiscal_Year__c, Curr_Baseline_Contracts__c, Contracts__c, AM_Name__c ' +
                         'FROM Enrollment__c ' + 
                         'WHERE Processed_Type__C = \'M\' AND Curr_Fiscal_Year__c = NULL AND Status__c = \'Active\' AND RecordType.Name = \'2-50\' AND Rpt_Dt__c = \'' + RptDtCurrent + '\'';            
        }
        
        if ( batchType == Enrollment_BaselineUpdateBatch.BatchType_51_Plus ) {
            this.query = 'SELECT Rpt_Dt__c,Account_Number__c, Curr_Baseline_Compensation_Owner__c, Curr_Fiscal_Year__c, Curr_Baseline_Contracts__c, Contracts__c, AM_Name__c ' + 
                         'FROM Enrollment__c ' +
                         'WHERE Processed_Type__C = \'M\' AND Curr_Fiscal_Year__c = NULL AND RecordType.Name = \'51+\' AND Rpt_Dt__c = \'' + RptDtCurrent + '\''; 
        }
        System.debug('this.query: ' + this.query);         
    }

    global Database.QueryLocator start(Database.BatchableContext BC){      
        return Database.getQueryLocator(this.query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        System.debug('Batch # ' + batchCount++);
        System.debug('Scope size=' + scope.size());  
        
        if(this.BatchType == Enrollment_BaselineUpdateBatch.BatchType_2_50)
            executeBatch_2_50( BC, scope);
        
        if(this.BatchType == Enrollment_BaselineUpdateBatch.BatchType_51_Plus)
            executeBatch_51_Plus( BC, scope);
        try {      
            Database.Update(scope, true);            
        } catch ( System.Exception e ) {
            String ErrorMsg = 'Apex Class Enrollment_BaselineUpdateBatch.start() threw an exception: ' +  e.getLineNumber() + ' - ' + e.getMessage();
            System.debug(LoggingLevel.ERROR, ErrorMsg);                                 
            throw new Enrollment_BaselineUpdateBatchException(ErrorMsg, e);           
        }
    }
    
    global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id = :BC.getJobId()];                          
                          
        // Send an email to the Apex job's submitter notifying of job completion.
//BEGIN CHANGE TPB 03/30/2016                 
        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {a.CreatedBy.Email};
        //mail.setToAddresses(toAddresses);      
        //mail.setSubject('Apex EnrollmentBaselineUpdateBatch - Parms: ' + this.BatchType + ' - Status: ' + a.Status);
        //mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
        //                      ' batches with '+ a.NumberOfErrors + ' failures.');
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
        
        String subject = 'Apex Enrollment_BaselineUpdateBatch - Parms: ' + this.BatchType + ' - Status: ' + a.Status;
        String emailBody = 'The batch Apex job processed ' + a.TotalJobItems +
                           ' batches with '+ a.NumberOfErrors + ' failures.';
        DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');
        string[] toAddresses = cs.Text_255__c.Split(',');       
        Utils.EmailUtil Email = new Utils.EmailUtil(toAddresses); 
        Email.subject(subject);
        Email.replyTo(UserInfo.getUserEmail());
        Email.htmlBody(emailBody);
        Email.sendEmail();                                      
// END CHANGE TPB 03/30/2016         
    }   
   
    // Set Compensation baseline fields for 2-50 enrollments
    global void executeBatch_2_50(Database.BatchableContext BC, List<sObject> scope){           
        System.debug('Processing a 2-50 enrollment batch');
        for(Enrollment__c e : (List<Enrollment__c> )scope) {            
            e.Curr_Baseline_Compensation_Owner__c = BaselineMap.get(e.Account_Number__c);
            e.Curr_Fiscal_Year__c = e.Rpt_Dt__c;
            e.Curr_Baseline_Contracts__c = 0;   
        }        
    }
    
   // Set Compensation baseline fields for 51+ enrollments 
   global void executeBatch_51_Plus(Database.BatchableContext BC, List<sObject> scope){       
        System.debug('Processing a 51+ enrollment batch');    
        for(Enrollment__c e : (List<Enrollment__c> )scope) {
            e.Curr_Fiscal_Year__c = e.Rpt_Dt__c;
            e.Curr_Baseline_Contracts__c = 0;  
        }
    } 

//BEGIN DEPRECATE TPB 03/13/2017  
//REPLACED WITH NEW ONE BELOW  
    /*****************************************************
     * Gets the latest Rpt_Dt__c value
     ****************************************************/
/*
    private String GetRptDtCurrent(String BatchType) {
        String RptDtCurrent = '';      
        RptDtCurrent = [ SELECT Rpt_Dt__c 
                         FROM Enrollment__c 
                         WHERE RecordType.Name = :BatchType
                         ORDER BY Rpt_Dt__c DESC LIMIT 1 ].Rpt_Dt__c;                               
        return RptDtCurrent;
    }
*/
//END DEPRECATE TPB 03/13/2017   

//BEGIN ADD TPB 03/13/2017
    /*****************************************************
     * Gets the latest Rpt_Dt__c value based on the parm
     * '51+' or '2-50' is passed in.
     ****************************************************/
    private String GetRptDtCurrent(String BatchType) { 
        String RptDt = '';
        if (BatchType == '2-50') {
            RptDt = Enrollment_QueryBase.GetLatestEnrlRunDt2_50();
        } else { // Assumed '51+'
            RptDt =  Enrollment_QueryBase.GetLatestEnrlRunDt51();
        }
        return RptDt;
    } 
//END ADD TPB 03/13/2017
 

    /*****************************************************
     * Expects the latest Rpt_Dt__c value and returns
     * the the RptDt to use as the Baseline date
     * i.e: If 201501 is the latest RptDt date then 201401 
     *      is returned
     *      If 201502 thru 201601 is the latest RptDt date 
     *      then 201501 is returned.  Get it?
     ****************************************************/
    private String GetRptDtBegin(String RptDt) {
        String RptDtBegin = '';        
        If ( RptDt.Right(2) == '01' ) {
            RptDtBegin = String.valueOf(Integer.valueOf(RptDt.left(4)) - 1) + '01';
        } else {
            RptDtBegin = String.valueOf(Integer.valueOf(RptDt.left(4))) + '01';  
        }                             
        return RptDtBegin;
    }
}