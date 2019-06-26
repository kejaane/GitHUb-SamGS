//=========================================================================================
//     Date: 01/16/2015
//Developer: Ken Gill started this class and Tom Barrett completed it
//  Purpose: This class processes Enrollment fields to create the enrollment baseline 
//           information for each year and record type (2-50 and 51+)        
//           It requires two parameter: 1) recordtype as a string ('2-50' or '51+')
//                                      2) report year as a string where year is like 2014, 2015, etc.
//
//           The process first reads the Enrollment__c object gathering a map of accounts (key) and compensation owner (value)
//           for a specific record type (2-50 or 51+) and Year being process (i.e.: 2014)    
//           This map is used by the 2-50 method to get the compensation owner populated on the record being read in the loop                                 
//
//    Usage: Enrollment_BaselineUpdateInitBatch job = new Enrollment_BaselineUpdateInitBatch(Enrollment_BaselineUpdateInitBatch.BatchType_2_50, '2013');
//           ID batchprocessid = Database.executeBatch(job);
//           
//Limitations: 
//           Because Salesforce has limitations such as how many records a SOQL query can 
//           return (50k) the year had to be passed as a parm to limit the number of 
//           records. An evaluation count was already performed to confirm that no given 
//           year for the query used in the Enrollment_QueryBase.BuildBaselineMap method 
//           returned more than 50,000 records.           
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//
//=========================================================================================
global class Enrollment_BaselineUpdateInitBatch implements Database.Batchable<sObject>, Database.Stateful{

    public static String BatchType_2_50 = '2-50';
    public static String BatchType_51_Plus = '51+';
   
    // batchType is specified when instantiating this class to specify if the enrollment processing is for 51+ or 2-50 type of
    // enrollment related opportunities. Depending on batchType, execute() delegates processing of a batch to either the executeBatch_2_50() or executeBatch_51_Plus() 
    private String BatchType;  
    private String ParmRptYear = '';    
    private String RptBegin = '';
    private String RptEnd = '';
    private String Query = '';     
    private Integer batchCount = 0;
    //USED ONLY IF THE NEED TO WRITE TO THE OPPORTUNITY
    //private List<Opportunity> oppsToUpdate = new List<Opportunity>();
    //private Set<Id> oppIdSet = new Set<Id>();
    private Map<String, String> BaselineMap = new Map<String, String>();   
    public class EnrollmentException extends Exception{}

    global Enrollment_BaselineUpdateInitBatch(String BatchType, String RptYear){     
        this.RptBegin = RptYear + '01';
        this.RptEnd = String.valueOf(Integer.valueOf(RptYear) + 1) + '01';
        this.BatchType = BatchType;
        this.ParmRptYear = RptYear;  
        // Get a map of accounts (Key) and Compensation Owner (value)
        BaselineMap = Enrollment_QueryBase.BuildBaselineMap(this.BatchType, this.RptBegin);
        if ( batchType == Enrollment_BaselineUpdateInitBatch.BatchType_2_50 ) {
            this.query = 'SELECT Rpt_Dt__c, Account_Number__c, Curr_Baseline_Compensation_Owner__c, Curr_Fiscal_Year__c, Curr_Baseline_Contracts__c, Contracts__c, AM_Name__c,Opportunity__r.Id FROM Enrollment__c WHERE RecordType.Name = \'2-50\' AND Processed_Type__c = \'M\' AND Rpt_Dt__c >= :RptBegin AND Rpt_Dt__c <= :RptEnd ';  
        }
        if ( batchType == Enrollment_BaselineUpdateInitBatch.BatchType_51_Plus ) {
            this.query = 'SELECT Rpt_Dt__c,Account_Number__c, Curr_Baseline_Compensation_Owner__c, Curr_Fiscal_Year__c, Curr_Baseline_Contracts__c, Contracts__c, AM_Name__c,Opportunity__r.Id,Opportunity__r.Owner.Id FROM Enrollment__c WHERE RecordType.Name = \'51+\' AND Processed_Type__c = \'M\' AND Rpt_Dt__c >= :RptBegin AND Rpt_Dt__c <= :RptEnd ';    
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC){         
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        System.debug('Batch # ' + batchCount++);
        System.debug('Scope size=' + scope.size());
        //System.debug('oppsToUpdate.size: ' + oppsToUpdate.size());        
        
        if(batchType == Enrollment_BaselineUpdateInitBatch.BatchType_2_50)
            executeBatch_2_50( BC, scope);
        
        if(batchType == Enrollment_BaselineUpdateInitBatch.BatchType_51_Plus)
            executeBatch_51_Plus( BC, scope);        

        try {      
            update scope;  
            //USED ONLY IF THE NEED TO WRITE TO THE OPPORTUNITY  
            //update oppsToUpdate;
            //oppIdSet.clear();
            //oppsToUpdate.clear();            
        } catch ( System.Exception e ) {
            String ErrorMsg = 'Apex Class EnrollmentBaselineUpdateBatch.start() threw an exception: ' +  e.getLineNumber() + ' - ' + e.getMessage();
            System.debug(LoggingLevel.ERROR, ErrorMsg);                                 
            throw new EnrollmentException(ErrorMsg, e);           
        }
    }
    
    global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex EnrollmentBaselineUpdateBatch - Parms: ' + this.batchType + ', ' + this.ParmRptYear + ' - Status: ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
    }   
   
    // Set Compensation baseline fields for 2-50 enrollments
    global void executeBatch_2_50(Database.BatchableContext BC, List<sObject> scope){           
        System.debug('Processing a 2-50 enrollment batch');
        for(Enrollment__c e : (List<Enrollment__c> )scope) {            
            e.Curr_Baseline_Compensation_Owner__c = BaselineMap.get(e.Account_Number__c);
            if ( e.Rpt_Dt__c == this.RptBegin ) {                
                e.Curr_Fiscal_Year__c = this.ParmRptYear + '_Baseline';                  
                e.Curr_Baseline_Contracts__c = e.Contracts__c;                
            } else {
                e.Curr_Fiscal_Year__c = e.Rpt_Dt__c;
                e.Curr_Baseline_Contracts__c = 0;   
            }            
        }        
    }
    
   // Set Compensation baseline fields for 51+ enrollments 
   global void executeBatch_51_Plus(Database.BatchableContext BC, List<sObject> scope){       
        System.debug('Processing a 51+ enrollment batch');    
        for(Enrollment__c e : (List<Enrollment__c> )scope) {
            if ( e.Rpt_Dt__c == this.RptBegin ) {                
                e.Curr_Fiscal_Year__c = this.ParmRptYear + '_Baseline';                  
                e.Curr_Baseline_Contracts__c = e.Contracts__c;                
            } else {
                e.Curr_Fiscal_Year__c = e.Rpt_Dt__c;
                e.Curr_Baseline_Contracts__c = 0;   
       
                /*USED ONLY IF THE NEED TO WRITE TO THE OPPORTUNITY                 
                if( !oppIdSet.contains(e.Opportunity__r.Id)) {
                    oppIdSet.add(e.Opportunity__r.Id);
                    oppsToUpdate.add(new Opportunity(Id=e.Opportunity__r.Id, Compensation_Owner__c=e.Opportunity__r.Owner.Id));
                } 
                */
            }         
        }
    } 
}