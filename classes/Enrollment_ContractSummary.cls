//==============================================================================================
//      Date: 08/17/2013
// Developer: Tom Barrett (TPB)
//   Purpose: This controller Summarizes the Enrollment Contracts by the most recent 
//            enrollment date (Rpt_Dt__c) and stores the total and the most recent enrollment
//            date at the Account object level.
//
//            Due to the limitation of SF's Aggregate query not being able to have access two
//            objects up a helper class was used to pick up where the aggregate query below 
//            only got up to the opportunity level.
//            See the Enrollment_ContractSummaryHelperClass for more detail.
//===============================================================================================
//                                 Update History
// Date       Developer   TAG#   Description
//===============================================================================================
// 04/02/2014 Tom Barrett TPB    Made major changes streamlining the summary process.
//                               I figured out how to reference the account id in the 
//                               aggregate query which removed the need to use the
//                               Enrollment_ContractSummaryHelperClass class.  This was the first
//                               phase for the Ancillary effort.  In addition, had to handle the 
//                               multiple processed_Type__c values using if else logic as the 
//                               primary solution in the aggregate loop
// NOTE:                         Removed a lot of code when the ContractSummaryHelperClass was
//                               no longer needed so that this class could be easily read by
//                               the developer
//                               The reference to the class prior to this change can be found at
//                               S:\Marketing\Sales\Sales Shared\Sales Project Mgmt & System Suppt\Salesforce Maintenance\Metadata_Backup\PROD_20140418_Before_Ancillary_ContractSummary_Change
//   
// 12/09/2014 Tom Barrett TPB    Added the skip logic when 2-50 record type is detected.  This logic 
//                               assumes that there will never be a batch of records with a mixed match
//                               of 2-50 and 51+ records.  It assumes this because it only checks the 
//                               first record in a 200 record batch.  In addition, added the recordtypeid
//                               to the aggregate WHERE clause AND another WHERE Clause below
//     
// 03/13/2017 Tom Barrett TPB    Made significant changes where code was reading the Enrollment__c
//                               object to get the latest Rpt_Dt__c date value.
//                               The replacement is to read the Enrollent_Import__c object instead.    
//                           
// 10/29/2018 Tom Barrett 001    Added functionality to call Governor Limit Monitoring Framework (GLM).        
//               
//====================================================================================================
public without sharing class Enrollment_ContractSummary{      
    // Holds all unique Opportunity Ids associated with enrollment
    private set<id> OppIds = new set<id>();    
    private String LatestEnrlRunDt = '';  
        
    // BEGIN ADD TPB 12/09/2014
    private  Id RtIdEnrlX51 = Enrollment_QueryBase.RtIdEnrX51;  
    // END ADD TPB 12/09/2014
    
    // BEGIN ADD #001
    private static boolean RunGLMonce = false;
    // END ADD #001
        
    public void ContractSummary(Enrollment__c[] enrollment){

        // BEGIN ADD TPB 12/09/2014
        Id RtIdEnrlRec = enrollment[0].recordtypeid; // checks first record only        
        if ( RtIdEnrlX51 != RtIdEnrlRec ) return;
        // END ADD TPB 12/09/2014     

        //BEGIN CHANGE TPB 03/13/2017
        
        // Sets the latest Rpt_Dt__c date in the class (static)        
        /*
        if ( Enrollment_QueryBase.LatestEnrlRunDt == NULL ) {
            Enrollment_QueryBase.SetLatestEnrlRunDt();                        
        }  
        // Gets the latest Rpt_Dt__c date 
        LatestEnrlRunDt = Enrollment_QueryBase.LatestEnrlRunDt; 
        */
        LatestEnrlRunDt = Enrollment_QueryBase.GetLatestEnrlRunDt51();         
        
        //END CHANGE TPB 03/13/2017
                      
        OppIds = BuildOppSetIds(enrollment); 

        // Convert the LatestEnrlRunDt (yyyymm) to (mm/dd/yyyy)
        Date LatestEnrollmentDate = ConvertToLastDayOfMonth(LatestEnrlRunDt); 
             
        Integer AggCnt = 0; // just for troubleshoot needs
        Map<id, Account> accountsToUpdate = new Map<id, Account>(); 
        Account account;
        Id CurrAccountId;
        Id PrevAccountId;
        Boolean FirstLoop = false;
        
        // Produce a sum of Enrollment__c contracts and add them to the map
        // using Group By to have a single Opportunity Id with a single sum value
        for(AggregateResult q : [ SELECT Opportunity__r.Account.Id AccountId, Processed_Type__c, SUM(Contracts__c)
                                  FROM Enrollment__c
                                  WHERE RecordTypeId = :RtIdEnrlX51 AND Rpt_Dt__c = :LatestEnrlRunDt AND Opportunity__c IN :OppIds                                 
                                  GROUP BY Opportunity__r.Account.Id, Processed_Type__c ]){                                 
            AggCnt += 1;       
          
            
            CurrAccountId = (id)q.get('AccountId');
            
            // Everytime we have a new account id we need to reset 
            // the counts to zero because if the aggregate query doesn't bring
            // in the same processed type each month we zero out what doesn't come in
            // Neat little trick -- hope it isn't using up too much memory!
            if ( PrevAccountId <> CurrAccountId ) {
                account = new Account();
                account.id = CurrAccountId;
                account.Latest_Enrollment_Date__c = LatestEnrollmentDate;               
                account.Latest_Medical_Enrollment__c = 0;
                account.Latest_Dental_Enrollment__c = 0;
                account.Latest_Drug_Enrollment__c = 0;
                account.Latest_Vision_Enrollment__c = 0;                 
                PrevAccountId = CurrAccountId;
            } 
            // Let's get the total for the correct record type during each
            // interation of the aggregate query                  
            if ( (String)q.get('Processed_Type__c') == 'M' ) {          
                account.Latest_Medical_Enrollment__c = (Double)q.get('expr0');
            } else if ( (String)q.get('Processed_Type__c') == 'D' ) {
                account.Latest_Dental_Enrollment__c = (Double)q.get('expr0');
            } else if ( (String)q.get('Processed_Type__c') == 'R' ) {
                account.Latest_Drug_Enrollment__c = (Double)q.get('expr0');
            } else if ( (String)q.get('Processed_Type__c') == 'V' ) {
                account.Latest_Vision_Enrollment__c = (Double)q.get('expr0');                                           
            }            
            accountsToUpdate.put(account.Id, account); 
        }    
        
        try {         
        
            update accountsToUpdate.values(); 
            
        }catch(System.Exception e){
            System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_ContractSummary.ContractSummary: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());      
        }            
             
        System.debug(AggCnt + ': ' + account);   
        
        // BEGIN ADD #001
		if (!RunGLMonce) {
        	GLM.checkLimit(GLM.sfLimit.ALLlimits, 'Enrollment_ContractSummary.ContractSummary()');
            RunGLMonce = true;
        }        
        // END ADD #001          
    } 
    
//===========================
// Private Methods Start Here
//===========================
    
    /****************************************************************************************
     * Build OppIds so it can be used in the aggregate query above.  This method builds a set 
     * of all opportunity ids in the trigger.  In addition, it collects any opportunity ids
     * that are associated to the account that is associated to any of the trigger 
     * opportunities that also have latest enrollment counts but were not in the current 
     * trigger list
     ****************************************************************************************/
    private Set<Id> BuildOppSetIds(Enrollment__c[] enrollment) {       
        set<id> AcctIds = new set<id>();

        for ( Enrollment__c e : enrollment ) {
            OppIds.add(e.Opportunity__c);
        }
System.debug('OppIds in trigger: ' + OppIds); 
        
        // Get the associated account ids so that we can us it later to get any opportunities ids 
        // that where not part of the trigger but do have enrollments with the latest enrollment date
        for ( Opportunity o : [ SELECT AccountId FROM Opportunity WHERE id IN :OppIds ] ) {
            AcctIds.add(o.AccountId);  
        }
        
        // Using the AcctIds from above lets get any opportunity ids associated with the account that was
        // also associated with the enrollments on the trigger.new or trigger.old that came into this class
        // those that did not but are from the latest enrollment run
        for ( Opportunity o : [ SELECT id 
                                FROM Opportunity 
                                WHERE AccountId IN :AcctIds 
                                  AND id IN (SELECT Opportunity__c 
                                             FROM Enrollment__c 
                                             WHERE RecordTypeId = :RtIdEnrlX51 AND Rpt_Dt__c = :LatestEnrlRunDt) ] ) {                                           
            OppIds.add(o.id);
        }         
System.debug('OppIds in trigger and non trigger associated opp ids: ' + OppIds); 
        return OppIds;
    }   
 
    
    /**************************************************************************************
     * Converts a date format of CCYYMM to the last day of that month in CCYY-MM-DD format
     * For example, 201301 would be converted to 2013-01-31
     *************************************************************************************/
    private Date ConvertToLastDayOfMonth( String RptDt ) {
        Date DateIn = Date.ValueOf(RptDt.left(4) + '-' + RptDt.mid(4,2) + '-01');
        Integer numberOfDays = Date.daysInMonth(DateIn.year(), DateIn.month());
        Date lastDayOfMonth = Date.newInstance(DateIn.year(), DateIn.month(), numberOfDays);        
        return lastDayOfMonth;
    }    
}