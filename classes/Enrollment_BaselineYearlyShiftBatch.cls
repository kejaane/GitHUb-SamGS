//=========================================================================================
//     Date: 01/16/2015
//Developer: Tom Barrett
//  Purpose: This class does two things.  It reads through the entire current fiscal year records.
//           For example: If this is Fiscal Year 2014 then records with Rpt_Dt__c equal to 201401 through
//           201501 would be chosen.  Refer to the WHERE clause for other record criteria requirements.
//           This class will fail if you attempt to run it and the latest enrollment data is not equal
//           to YYYY01 (i.e.: 201401).
//           As it iterates throuch the records the baseline values for January of the current fiscal year are set.  
//           For example, if the latest Rpt_Dt__c value is '201501' then we populate the Curr* field values into variables.
//           Next we populate Curr_Fiscal_Year__c field with '2015_Baseline' and the Curr_Baseline_Contracts__c 
//           with Contracts__c and the Curr_Baseline_Compensation_Owner__c with Am_Name__c.  Next we copy the   
//           copy the values stored in the variables to the Prev* fields. 
//           This class should only be executed once a year after the Enrollment_BaselineUpdateBatch class and before the 
//           loading of February data load which runs in March. 
//           See the Enrollemnt_BaselineUpdateBatch class for details on it funcationality and job execution time.
//
//    Usage: Enrollment_BaselineYearlyShiftBatch job = new Enrollment_BaselineYearlyShiftBatch(Enrollment_BaselineYearlyShiftBatch.BatchType_2_50);
//           ID batchprocessid = Database.executeBatch(job);
//       Or: Enrollment_BaselineYearlyShiftBatch job = new Enrollment_BaselineYearlyShiftBatch(Enrollment_BaselineYearlyShiftBatch.BatchType_51_Plus);
//           ID batchprocessid = Database.executeBatch(job);
//          
//       Or: Enrollment_BaselineYearlyShiftBatch job = new Enrollment_BaselineYearlyShiftBatch(Enrollment_BaselineYearlyShiftBatch.BatchType_2_50, '2013');
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
global class Enrollment_BaselineYearlyShiftBatch implements Database.Batchable<SObject>, Database.Stateful{
    public static String BatchType_2_50 = '2-50';
    public static String BatchType_51_Plus = '51+';
    private String BatchType = '';
    private String RptDtBegin  = '';
    private String RptDtEnd = '';
    private Integer BatchCount = 0;   
    private String Query = '';  
    
    public class Enrollment_BaselineYearlyShiftException extends Exception{}    
     
    /*****************************************************************************
     * This method assumes the latest rpt_dt__c value is what should be processed
     * It would typically be used via a scheduled job so that it can dynamically 
     * determine the proper Rpt_Dt__c date to process
     * i.e.: For fiscal year 2013 the parm should be '201401'
     ****************************************************************************/
    global Enrollment_BaselineYearlyShiftBatch(String BatchType) {
        this.RptDtEnd = GetRptDtEnd(BatchType);
        this.RptDtBegin = GetRptDtBegin(this.RptDtEnd); 
        this.BatchType = BatchType;
    }

    global database.querylocator start(Database.BatchableContext bc) {   
        if ( this.BatchType == Enrollment_BaselineYearlyShiftBatch.BatchType_2_50 ) {
            this.Query = 'SELECT id, Rpt_Dt__c, Contracts__c, AM_Name__c, Curr_Fiscal_Year__c, Curr_Baseline_Compensation_Owner__c, Curr_Baseline_Contracts__c, Prev_Fiscal_Year__c, Prev_Baseline_Compensation_Owner__c, Prev_Baseline_Contracts__c ' +
                         'FROM Enrollment__c ' +
                         'WHERE Processed_Type__C = \'M\' AND ' + 
                         'Rpt_Dt__c >= \'' + this.RptDtBegin + '\' AND Rpt_Dt__c <=  \'' + this.RptDtEnd + '\' AND ' +
                         'RecordType.Name = \'' + this.BatchType + '\' AND Status__c = \'Active\'';  
        }
        
        if ( this.BatchType == Enrollment_BaselineYearlyShiftBatch.BatchType_51_Plus ) {
            this.Query = 'SELECT id, Rpt_Dt__c, Contracts__c, AM_Name__c, Curr_Fiscal_Year__c, Curr_Baseline_Compensation_Owner__c, Curr_Baseline_Contracts__c, Prev_Fiscal_Year__c, Prev_Baseline_Compensation_Owner__c, Prev_Baseline_Contracts__c ' +
                          'FROM Enrollment__c ' +
                          'WHERE Processed_Type__C = \'M\' AND ' +
                          'Rpt_Dt__c >= \'' + this.RptDtBegin + '\' AND Rpt_Dt__c <=  \'' + this.RptDtEnd + '\' AND ' +
                          'RecordType.Name = \'' + this.BatchType + '\''; 
        }
        System.debug('Query: ' + this.Query);
        return Database.getQueryLocator(this.Query); 
    }
  
    global void execute(Database.BatchableContext bc, Enrollment__c[] EnrollmentList) {
        System.debug('Batch # ' + batchCount++);
        System.debug('EnrollmentList size=' + EnrollmentList.size());
        list <Enrollment__c>  enrlToUpdate = new  list<Enrollment__c>(); 
        
        for(Enrollment__c enrl : EnrollmentList){
            //Copy the current values to the previous fields
            enrl.Prev_Fiscal_Year__c = enrl.Curr_Fiscal_Year__c;
            enrl.Prev_Baseline_Compensation_Owner__c = enrl.Curr_Baseline_Compensation_Owner__c;
            enrl.Prev_Baseline_Contracts__c = enrl.Curr_Baseline_Contracts__c;
            
            // If the record's Rpt_Dt__c is equal to the RptDtEnd date let us also setup 
            // the baseline for that record. This will be the baseline for the new year.
            If ( enrl.Rpt_Dt__c == RptDtEnd ) {
                // Set the current baseline
                enrl.Curr_Fiscal_Year__c = enrl.Rpt_Dt__c.Left(4) + '_Baseline';                
                enrl.Curr_Baseline_Compensation_Owner__c = enrl.AM_Name__c;
                enrl.Curr_Baseline_Contracts__c = enrl.Contracts__c;
            }             
            enrlToUpdate.add(enrl);
        }     
        if(enrlToUpdate != null && enrlToUpdate.size() > 0){
            try {      
                database.update(enrlToUpdate, true);             
            } catch ( System.Exception e ) {
                String ErrorMsg = 'Apex Class Enrollment_BaselineYearlyShift.start() threw an exception: ' +  e.getLineNumber() + ' - ' + e.getMessage();
                System.debug(LoggingLevel.ERROR, ErrorMsg);                                 
                throw new Enrollment_BaselineYearlyShiftException(ErrorMsg, e);           
            } 
        }        
    }
   
    global void finish(Database.BatchableContext bc) {
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
        //mail.setSubject('Apex Enrollment_BaselineYearlyShift - Parms: ' + this.batchType + ' - Status: ' + a.Status);
        //mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
        //                      ' batches with '+ a.NumberOfErrors + ' failures.');
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
           
        String subject = 'Apex Enrollment_BaselineYearlyShiftBatch - Parms: ' + this.batchType + ' - Status: ' + a.Status;
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


//BEGIN DEPRECATE TPB 03/13/2017   
//REPLACED WITH NEW ONE BELOW 
    /*****************************************************
     * Gets the latest Rpt_Dt__c value
     * If that date is not in January an error is thrown
     * We call this the end date because January is the 
     * end of the fiscal year
     ****************************************************/
    /*
    private String GetRptDtEnd(String BatchType) {
        String RptDt = '';     
        System.debug('GetRptDtEnd Method - BatchType: ' + BatchType);
        RptDt = [ SELECT Rpt_Dt__c 
                  FROM Enrollment__c 
                  WHERE RecordType.Name = :BatchType
                  ORDER BY Rpt_Dt__c DESC LIMIT 1 ].Rpt_Dt__c;
        If ( RptDt.Right(2) != '01' ) {
            throw new Enrollment_BaselineYearlyShiftException('The Enrollment_BaseYearlyShiftBatch Process detected a non January latest enrollment__c Rpt_Dt__c date!');       
        }  
        System.debug('GetRptDtEnd Method - RptDt: ' + RptDt);
        return RptDt;
    }
    */
//END DEPRECATE TPB 03/13/2017

//BEGIN ADD TPB 03/13/2017
    /********************************************************
     * Gets the latest Rpt_Dt__c value based on if
     * '51+' or '2-50' is passed in.
     * In addition, because the year base manipulates only
     * the January data of the current calendar year
     * need to adjust the month position minus 1.
     * As long as the Yearly Baseline is executed in the 
     * month of March this adjustment will aways put it to '01'
     * because in March we run against 02 data (i.e: 201702).
     ********************************************************/
    private String GetRptDtEnd(String BatchType) { 
        String RptDt = '';
        String EnrlObjectName = '';
        if (BatchType == '2-50') {
            RptDt = Enrollment_QueryBase.GetLatestEnrlRunDt2_50();
            EnrlObjectName = 'Enrollment_Import_2_50__c';
        } else { // Assumed '51+'
            RptDt =  Enrollment_QueryBase.GetLatestEnrlRunDt51();
            EnrlObjectName = 'Enrollment_Import__c';
            
            //Now we have to make that adjustment so that we process
            //January ('01') data for the baseline yearly shift!
            RptDt = Enrollment_QueryBase.RptDtMonthMinus1(RptDt);  
        }      
        //If we did not calulate YYYY01 then throw an error something is wrong!
        If ( RptDt.Right(2) != '01' ) {
            throw new Enrollment_BaselineYearlyShiftException('The Enrollment_BaseYearlyShiftBatch Process detected a non January latest Rpt_Dt__c date on the ' + EnrlObjectName + ' object!');       
        }  
        System.debug('GetRptDtEnd Method - RptDt: ' + RptDt);
        return RptDt;
    }  
//END ADD TPB 03/13/2017
 
    
    private String GetRptDtBegin(String RptDtEnd) {
        String RptDtBegin = '';      
        // Get the beginining of the fiscal year
        // i.e: If RptDtEnd is '201401' then return '201301'
        RptDtBegin = String.valueOf(Integer.valueOf(RptDtEnd.Left(4)) - 1) + '01'; 
        System.debug('GetRptDtBegin - RptDtBegin: ' + RptDtBegin);
        return RptDtBegin;
    }
}