//============================================================================================
//     Date: 02/26/2013
//Developer: Tom Barrett
//  Purpose: Provide a base class for all shared SOQL queries, DML's, Lists, Maps, and Sets 
//           associated with the Enrollment process.
//           Basically, it contains all code that is common to the enrollment process
//           Future efforts should always put the code that can be shared by the enrollment
//           process in this class
//============================================================================================
//                                 Update History
// Date       Developer         Description
//============================================================================================
// 08/19/2013 Tom Barrett       Added the SetLatestEnrlRunDt() method for the
//                              Enrollment_ContractSummary class Enrollment Trigger usage 
//
// 09/19/2013 Tom Barrett       Making changes to accomodate the consolidation of
//                              the enrollment_history__c object data into the Enrollment__c
//                              object.  This effort impacted the following:
//                              Classes: Enrollment_MainProcess, Enrollment_QueryBase,
//                                     and Enrollment_Recycle_Controllerext.   
// 
// 12/19/2013 Tom Barrett       Making changes to accommodate the changes were the new field 
//                              Contract_End_Date__c was added in order to resolve date gap
//                              issues.  By having an Effective Date and Contract End Date
//                              we are able to get the perfect window of Opportunities for
//                              monthly run.  This effort was for Sprint 13
// 12/03/2014 Tom Barrett TPB   Made changes to the necessary SOQL WHERE clause to only get
//                              51+ record type records. In addition, made changes to the
//                              CopyEnrollmentRecycleData method to include the new fields 
//                              Rating_State__c and New_Business_Indicator__c and added the 
//                              AccountId to the opps query so that it can be used to populate
//                              the Rating_State__c from the caller (i.e.: Enrollment_MainProcess)
//                            
// 01/16/2015 Tom Barrett TPB   Created the BuildBaselineMap method    
// 
// 01/27/2015 Tom Barrett TPB   Modified BuildBaselineMap method by including Status = 'Active' 
//                              in the WHERE clause.  The method should only pass '2-50' as the 
//                              first parm It used to work with '51+' but calling code was changed 
//                              not to call this method for 51+.  Read the assumptions comments in 
//                              the method  
//
// 03/19/2015 Tom Barrett TPB   Modified to allow multiple numbers in the National_Alliance_ID__c
//                              field.    
//                              When coding this effort I did some deep looking at the pattern
//                              that the existing code is using for multiple numbers and
//                              I realized that it could be coded more efficiently so I did that
//                              for National Alliance and NASCO. 
//
// 06/09/2016 Tom Barrett TPB   Updated to include the new 200+ (AIA_200) RecordType at the
//                              code that queries the Opportunity level. 
//                              It was determined not to include the new RecordType at the 
//                              Enrollment__c object level.     
//
// 03/13/2017 Tom Barrett TPB   Made significant changes where code was reading the Enrollment__c
//                              object to get the latest Rpt_Dt__c date value.
//                              The replacement is to read the Enrollent_Import__c and the 
//                              Enrollment_Import_2_50__c objects instead.                                     
//==============================================================================================
public without sharing class Enrollment_QueryBase {   
    public static String LatestEnrlRunDt; // added 08/19/2013
    public static String LatestEnrlRunDt2_50; // added TPB 03/13/2017
    public static final Map<String, Opportunity> facetsOppsMap = new Map<String, Opportunity>();
    public static final Map<String, Opportunity> luminexOppsMap = new Map<String, Opportunity>();
    public static final Map<String, Opportunity> nascoOppsMap = new Map<String, Opportunity>();
    public static final Map<String, Opportunity> nwlOppsMap = new Map<String, Opportunity>();
    public static final Map<String, Opportunity> naOppsMap = new Map<String, Opportunity>();
    
    public static final Id RtIdEnrX51 = querybase.getRecordtypeId('Enrollment__c', 'X51'); //Change 12/03/2014 TPB
    public static final Id RtIdOppX51 = querybase.getRecordtypeId('Opportunity', 'X51'); //Change 12/03/2014 TPB   
    public static final id RtIdOppAIA_200 = querybase.getRecordtypeId('Opportunity', 'AIA_200'); //Added 06/09/2016 TPB 
    
    /**************************************************************************************
     * Returns a Map of the Enrollment_Error_Messgae__c object.  The map holds the 
     * Error_Number__c as the key and Error_Message__c as the value 
     *************************************************************************************/   
    public static Map<String, Error_Message__c> getErrorMessageMap() {
        List<Error_Message__c> errMessages  = [ SELECT Error_Number__c, Error_Message__c 
                                                FROM Error_Message__c
                                                WHERE Source_Type__c = 'Enrollment' ];
        Map<String, Error_Message__c> errorMessageMap = new Map<String, Error_Message__c>();        
        for ( Error_Message__c em : errMessages ) {
            errorMessageMap.put(em.Error_Number__c, em);
        }
        System.debug('Enrollment_QueryBase.Error_Message - errorMessageMap count: ' + errorMessageMap.size());
        return errorMessageMap;   
    }
    
    /***************************************************************************************
     * Build Opportunity System Key Maps   
     * These maps contain all system field keys and related to opportunity records for the 
     * predefined opportunity window
     **************************************************************************************/
    public static void BuildOppSystemKeyMaps() {
        List<String> facetsSplit;
        List<String> nascoSplit;          
        List<String> naSplit;        // ADDED TPB 03/19/2015  
        
// BEGIN CHANGE TPB 12/19/2013        
        String RptDt = '';          
        
        //BEGIN CHANGE TPB 03/13/2017
        // Get the latest Rpt_Dt__c value which should always be in the format of YYYYMM        
        // COMMENTED OUT TPB 03/13/2017 RptDt = [ SELECT Rpt_Dt__c FROM Enrollment_Import__c ORDER BY Rpt_Dt__c DESC LIMIT 1 ].Rpt_Dt__c;
        RptDt = Enrollment_QueryBase.GetLatestEnrlRunDt51();        
        //END CHANGE TPB 03/13/2017
        
        // Convert YYYYMM value to a Date value that is always the first of the month.
        Date RptDtFirstDay = Date.newInstance(Integer.ValueOf(RptDt.substring(0,4)), Integer.ValueOf(RptDt.substring(4)), 1);
        Date RptDtLastDay = RptDtFirstDay.addMonths(1).addDays(-1);
        
        System.debug('RptDtFirstDay: ' + RptDtFirstDay + ', RptDtLastDay: ' + RptDtLastDay);

//Change 12/03/2014 TPB see history comment in header  
//Change 06/09/2016 TPB see history comment in header      
        List<Opportunity> Opps = [ SELECT Id, AccountId, Name, Facets_Grp_Num__c, Luminex__c, NASCO_Acct_ID__c, 
                                          National_Alliance_ID__c, Net_Lease_Group_ID__c, Effective_Date__c                                         
                                   FROM Opportunity 
                                   WHERE Effective_Date__c <= :RptDtLastDay AND Contract_End_Date__c > :RptDtFirstDay
                                         AND StageName = 'Sold' AND (RecordTypeId = :RtIdOppX51 OR RecordTypeId = :RtIdOppAIA_200)
                                   ORDER BY Effective_Date__c ASC ];                                           
/* DEPRECATED 12/19/2013
        List<Opportunity> Opps = [ SELECT Id, Name, Facets_Grp_Num__c, Luminex__c, NASCO_Acct_ID__c, National_Alliance_ID__c, 
                                          Net_Lease_Group_ID__c, Effective_Date__c                                         
                                   FROM Opportunity 
                                   WHERE Effective_Date__c >= LAST_N_MONTHS:12 AND Effective_Date__c <= LAST_MONTH
                                   AND StageName = 'Sold'
                                   ORDER BY Effective_Date__c ASC ];                                    
                         //   WHERE Effective_Date__c >= LAST_N_MONTHS:12 AND Effective_Date__c <= LAST_MONTH
                         //   WHERE Effective_Date__c >= 2012-09-01 AND Effective_Date__c <= 2013-08-31
*/                        
        System.debug('Enrollment_QueryBase.BuildOppSystemKeyMaps Opps count: ' + opps.size());                           
                                
// END CHANGE TPB 12/19/2013 
                                         
        for ( Opportunity opp : Opps ) {           
            //Split out the Facets numbers as the field allows for multiple numbers
            if ( opp.Facets_Grp_Num__c != NULL && opp.Facets_Grp_Num__c != '' ) {
                facetsSplit = opp.Facets_Grp_Num__c.split(',');            
                for ( String facetsGrpNum : facetsSplit ) {                 
                    facetsOppsMap.put(facetsGrpNum.toUpperCase(),opp);
                }
            }
              
            if ( opp.Luminex__c <> NULL ) {           
                luminexOppsMap.put(opp.Luminex__c.toUpperCase(), opp);
            }
            
            //Split out the Nasco numbers as the field allows for multiple numbers now
            if ( opp.NASCO_Acct_ID__c != NULL && opp.NASCO_Acct_ID__c != '' ) {
                nascoSplit = opp.NASCO_Acct_ID__c.split(',');
                for ( String nasco : nascoSplit ) {
                  nascoOppsMap.put(nasco.toUpperCase(), opp);
               }   
            }
            
            // BEGIN CHANGE TPB 03/19/2015
            // NOTE: Commented this out during the National Alliance change as it was
            // realized that it was code that was redundent because the loop above
            // handled it.  
            /*
            if ( opp.NASCO_Acct_ID__c <> NULL ) {
                nascoOppsMap.put(opp.NASCO_Acct_ID__c.toUpperCase(), opp);
            }
            */
            // END CHANGE TPB 03/19/2015


            if ( opp.Net_Lease_Group_ID__c <> NULL ) {
                nwlOppsMap.put(opp.Net_Lease_Group_ID__c.toUpperCase(), opp);     
            }  
            
            // BEGIN CHANGE TPB 03/19/2015
            //Split out the National Alliance numbers as the field allows for multiple numbers now
            if ( opp.National_Alliance_ID__c != NULL && opp.National_Alliance_ID__c != '' ) {
                naSplit = opp.National_Alliance_ID__c.split(',');
                for ( String na : naSplit ) {
                  naOppsMap.put(na.trim().toUpperCase(), opp);
                }   
            }
            
            //if ( opp.National_Alliance_ID__c <> NULL ) {
            //    naOppsMap.put(opp.National_Alliance_ID__c.toUpperCase(), opp);
            //}   
            // END CHANGE TPB 03/19/2015 
        }
        System.debug('facetsOppsMap count: ' + facetsOppsMap.size());
        System.debug('luminexOppsMap count: ' + luminexOppsMap.size());
        System.debug('nascoOppsMap count: ' + nascoOppsMap.size()); 
        System.debug('nwlOppsMap count: ' + nwlOppsMap.size());   
        System.debug('naOppsMap count: ' + naOppsMap.size()); 
    } 
     
    /**************************************************************************************
     * Update the Enrollment_Import__c's Processed__c field to TRUE
     *************************************************************************************/
    public static Integer UpdateEnrollmentImportProcessedField(Set<Id> ids) {
        Integer ProcessedCount = 0;
        Integer ReturnedProcessedCount = 0;
        for ( List<Enrollment_Import__c> updateEnrollmentProcessedFlags : [ SELECT Processed__c FROM Enrollment_Import__c WHERE Id in :Ids ] ) {
            for ( Enrollment_Import__c rec : updateEnrollmentProcessedFlags ) {
                rec.Processed__c = TRUE;
                processedCount += 1;
            }
            update updateEnrollmentProcessedFlags;
            ReturnedProcessedCount += ProcessedCount;
            processedCount = 0;          
        }  
        System.debug('Enrollment_QueryBase.UpdateEnrollmentProcessedFlags updated count: ' + ReturnedProcessedCount);            
        return ReturnedProcessedCount;
    } 


// BEGIN CHANGE 09/19/2013 TPB
// No longer need to copy and delete enrollment__c data since latest and history are staying in the Enrollment__c object
// The CopyEnrollmentData method and DeleteEnrollmentData have both been deprecated and superceeded by SetEnrollmentAsHistoryData
   
    /**************************************************************************************
     * Copies prior month processed data from Enrollment__c object and inserts it into the 
     * Enrollment_History__c object.  The set that is supplied should be the opportunity ids
     * that where collect during Enrollment__c inserts and the RptDt value should be the 
     * Rpt_Dt__c value on the Enrollment_Immport__c object during the time of the run.     
     *************************************************************************************/
/*   
    public static Integer CopyEnrollmentData(Set<Id> ids, String RptDt) { 
        List<Enrollment_History__c> enrollmentHistoryList = new List<Enrollment_History__c>();
        Integer processedCount = 0;
       
        for ( List<Enrollment__c> ced : [ SELECT Rpt_Dt__c, Account_Number__c, Contracts__c, Opportunity__c, 
                                                 Processed_Type__c, Product__c, Risk__c, Run_Dt__c, System__c 
                                          FROM Enrollment__c 
                                          Where Opportunity__c in :ids and Rpt_Dt__c <> :RptDt ] ) {

            for ( Enrollment__c rec : ced ) {
                Enrollment_History__c eh = new Enrollment_History__c();
                eh.Rpt_Dt__c = rec.Rpt_Dt__c;
                eh.Account_Number__c = rec.Account_Number__c; 
                eh.Contracts__c = rec.Contracts__c;
                eh.Opportunity__c = rec.Opportunity__c;
                eh.Processed_Type__c = rec.Processed_Type__c;
                eh.Product__c = rec.Product__c;
                eh.Risk__c = rec.Risk__c;
                eh.Run_Dt__c = rec.Run_Dt__c; 
                eh.System__c = rec.System__c;                
                enrollmentHistoryList.add(eh);                
            } 
            if ( enrollmentHistoryList <> NULL ) {
                insert enrollmentHistoryList;  
                processedCount = enrollmentHistoryList.size();             
            }
        }
        System.debug('Enrollment_QueryBase.CopyEnrollmentData insert count: ' + processedCount);
        return processedCount;
    }  
*/
  
 //   /**************************************************************************************
 //    * This method should only be called immediately after the CopyEnrollmentData method 
 //    * above.  This method deletes prior month processed data from Enrollment__c object.  
 //    * The set that is supplied should be the opportunity ids that where collected during 
 //    * Enrollment__c inserts and the RptDt value should be the Rpt_Dt__c value on the 
 //    * Enrollment_Immport__c object during the time of the run.
 //    *************************************************************************************/ 
/*
    public static Integer DeleteEnrollmentData(Set<Id> ids, String RptDt) { 
        List<Enrollment__c> enrollmentList = new List<Enrollment__c>();
        Integer processedCount = 0;
        for ( Enrollment__c e : [ SELECT id
                                  FROM Enrollment__c 
                                  Where Opportunity__c in :ids and Rpt_Dt__c <> :RptDt ] ) {
            enrollmentList.add(e);
        }                           
        if ( enrollmentList <> NULL ) {            
            delete enrollmentList; 
            processedCount = enrollmentList.size();
        }    
        System.debug('Enrollment_QueryBase.DeleteEnrollmentData delete count: ' + processedCount);
        return processedCount;
    } 
*/      
    
    /**************************************************************************************
     * This method superceeds the CopyEnrollmentData and DeleteEnrollment Data methods
     * It updates the Enrollment__c data's Latest_Enrollment__c field from 'Y' to 'N'
     * Where Latest_Enrollment__c = 'Y' and Rpt_Dt__c <> RptDt     
     *************************************************************************************/
    public static Integer SetEnrollmentAsHistoryData(Set<Id> ids, String RptDt) { 
        List<Enrollment__c> enrollmentList = new List<Enrollment__c>();
        Integer processedCount = 0;
        for ( Enrollment__c e : [ SELECT id
                                  FROM Enrollment__c 
                                  WHERE Opportunity__c in :ids 
                                    AND Rpt_Dt__c <> :RptDt
                                    AND Latest_Enrollment__c = 'Y' ] ) {
            e.Latest_Enrollment__c = 'N';                                    
            enrollmentList.add(e);
        }                           
        if ( enrollmentList <> NULL ) {            
            update enrollmentList; 
            processedCount = enrollmentList.size();
        }    
        System.debug('Enrollment_QueryBase.SetEnrollmentAsHistoryData update count: ' + processedCount);
        return processedCount;
    }     
    
// END CHANGE 09/19/2013 TPB     
    
     
    
    /**************************************************************************************
     * Copies Enrollment_Recycle__c object data that was successfully recycled by the user
     * interaction with the enrollment recycle process page.  The set that is supplied 
     * should be the Enrollment_Recycle__c ids that where collected during Enrollment__c 
     * inserts.  This method also has the ability to handle storing Enrollment_Recycle__c 
     * records as processed (TRUE) or not processed (FALSE).  This parameter was added to 
     * allow the method to be called by the Recycle process and the 
     *************************************************************************************/    
     public static Integer CopyEnrollmentRecycleData(Set<Id> ids, Boolean ProcessedFlag) { 
        List<Enrollment_Recycle_Archive__c> enrollmentRecycleArchiveList = new List<Enrollment_Recycle_Archive__c>();
        Integer processedCount = 0;
        for ( List<Enrollment_Recycle__c> cerd : [ SELECT Rpt_Dt__c, Account_Name__c, Account_Number__c, Contracts__c, Error_Message__c, 
                                                          Error_Number__c, Processed_Type__c, SFDC_Product__c, Sales_Rep__c, Risk__c, Run_Dt__c, 
                                                          System__c, Rating_State__c, New_Business_Indicator__c 
                                                   FROM Enrollment_Recycle__c 
                                                   Where Id in :ids ] ) {
            for ( Enrollment_Recycle__c rec : cerd ) {
                Enrollment_Recycle_Archive__c era = new Enrollment_Recycle_Archive__c();
                era.Rpt_Dt__c = rec.Rpt_Dt__c;
                era.Account_Name__c = rec.Account_Name__c;
                era.Account_Number__c = rec.Account_Number__c;               
                era.Error_Message__c = rec.Error_Message__c;
                era.Error_Number__c = rec.Error_Number__c;
                era.Contracts__c = rec.Contracts__c;   
                era.Processed__c = ProcessedFlag;            
                era.Processed_Type__c = rec.Processed_Type__c;
                era.SFDC_Product__c = rec.SFDC_Product__c;
                era.Sales_Rep__c = rec.Sales_Rep__c;
                era.Risk__c = rec.Risk__c;
                era.Run_Dt__c = rec.Run_Dt__c; 
                era.System__c = rec.System__c;   
                era.Rating_State__c = rec.Rating_State__c;
                era.New_Business_Indicator__c = rec.New_Business_Indicator__c;             
                enrollmentRecycleArchiveList.add(era);                              
            } 
        }
        if ( enrollmentRecycleArchiveList <> NULL ) {
            insert enrollmentRecycleArchiveList;  
            processedCount = enrollmentRecycleArchiveList.size();             
        }
        System.debug('Enrollment_QueryBase.CopyEnrollmentRecycleData insert count: ' + processedCount);
        return processedCount;
    }  
   
    /**************************************************************************************
     * This method should only be called immediately after the CopyEnrollmentRecycleData 
     * method above.  This method deletes prior month processed data from Enrollment_Recycle__c 
     * object.  The set that is supplied should be the Enrollment_Recycle ids that where 
     * collected during Enrollment__c inserts during the time of the run.
     *************************************************************************************/     
    public static Integer DeleteEnrollmentRecycleData(Set<Id> ids) { 
        List<Enrollment_Recycle__c> enrollmentRecycleList = new List<Enrollment_Recycle__c>();
        Integer processedCount = 0;

        for ( Enrollment_Recycle__c derd : [ SELECT id
                                  FROM Enrollment_Recycle__c 
                                  Where Id in :ids ] ) {
            enrollmentRecycleList.add(derd);                         
        }           
        if ( enrollmentRecycleList <> NULL ) { 
            delete enrollmentRecycleList; 
            processedCount = enrollmentRecycleList.size();
        }
        System.debug('Enrollment_QueryBase.DeleteEnrollmentRecycleData delete count: ' + processedCount);
        return processedCount;
    } 
 
 
    /**********************************
     * BEGIN DEPRECATE TPB 03/13/2017
     * REPLACED BY:
     * GetLatestEnrlRunDt51() Method
     */   
    // BEGIN ADD TPB 08/19/2013
    /****************************************************************************************
     * Used by the Enrollment Trigger to get the last known run date.  Needed to use a static
     * method and variable (LatestEnrlRunDt so that its value could be remembered between
     * the BEFORE and AFTER triggers
     ***************************************************************************************/     
/*
    public static void SetLatestEnrlRunDt() {
//Change 12/03/2014 TPB see history comment in header   
        LatestEnrlRunDt = [ SELECT Rpt_Dt__c FROM Enrollment__c
        WHERE RecordTypeId = :RtIdEnrX51
        ORDER BY Rpt_Dt__c DESC LIMIT 1 ].Rpt_Dt__c;
    }    
    // END ADD TPB 08/19/2013 
*/
    /*
     * END DEPRECATE TPB 03/13/2017
     *********************************/  

//BEGIN ADD TPB 03/13/2017
    /***********************************************************
     * This method gets the latest Rpt_Dt__c value that resides
     * on the enrollment_Import__c object.  
     * It is a smart method meaning it does not continiously 
     * query the database if the LatestEnrlRunDt was previously
     * populated in a given context run.  This is achieved by
     * using a the static variable LatestEnrlRunDt 
     ***********************************************************/
    public static String GetLatestEnrlRunDt51() { 
        if (LatestEnrlRunDt == NULL) {
            LatestEnrlRunDt = [ SELECT Rpt_Dt__c FROM Enrollment_Import__c LIMIT 1].Rpt_Dt__c;   
             System.debug('Enrollment_QueryBase.GetLatestEnrlRunDt51 query was executed'); 
        }
      return LatestEnrlRunDt;
    } 


    /***************************************************************
     * This method gets the latest Rpt_Dt__c value that resides
     * on the enrollment_Import_2_50__c object.  
     * It is a smart method meaning it does not continiously 
     * query the database if the LatestEnrlRunDt2_50 was previously
     * populated in a given context run.  This is achieved by
     * using a the static variable LatestEnrlRunDt 
     ***************************************************************/
    public static String GetLatestEnrlRunDt2_50() { 
        if (LatestEnrlRunDt2_50 == NULL) {
            LatestEnrlRunDt2_50 = [ SELECT Rpt_Dt__c FROM Enrollment_Import_2_50__c LIMIT 1].Rpt_Dt__c; 
            System.debug('Enrollment_QueryBase.GetLatestEnrlRunDt2_50 query was executed');  
        }
        return LatestEnrlRunDt2_50;   
    }

//END ADD TPB 03/13/2017
    
    
    /*****************************************************************************************
     * Build map of account_number__c (key) and AM_Name__c as value so that these related 
     * values can be later used to populate the curr_baseline_owner__c field in the caller
     * Assumptions: First parm is always '2-50'
     *              Second parm is format yyyy01 (ie. '201401') -- always January
     * Returns a Map of Account_Number__C key and AM_Name__C value
     ****************************************************************************************/
    public static Map<String, String> BuildBaselineMap(String BatchType, String RptBegin) { 
        Map<String, String> BaselineMap = new Map<String, String>();
        for ( Enrollment__c e: [ SELECT Account_Number__c, AM_Name__c 
                                   FROM Enrollment__c
                                   WHERE RecordType.Name = :BatchType AND Processed_Type__c = 'M' AND Status__c = 'Active' AND Rpt_Dt__c = :RptBegin ] ) {          
            BaselineMap.put(e.Account_Number__c, e.AM_Name__c);
        } 
        System.debug('BuildBaselineMap Method - BaselineMap.size: ' + BaselineMap.size()); 
        return BaselineMap;
    }    
    
    //BEGIN ADD TPB 03/13/2017
    /**************************************************
     *This method is used when the Process needs to 
     *take the Enrollment_Import__c's RPT_DT__C value
     *and adjust it one month back.
     **************************************************/
    public static String RptDtMonthMinus1(String RptDt){
        String Month = RptDt.right(2);  
        String Year = RptDt.left(4);     
        Integer MonthNum = Integer.valueOf(Month);
        Integer YearNum = Integer.valueOf(Year);
        
        //If we are in January then we need to adjust
        // not only the month to December (12) 
        // we need to subtract 1 from the year
        if (MonthNum == 1) {
            MonthNum = 13;
            YearNum = YearNum - 1;
            Year = YearNum.format();
            Year = Year.replace(',', '');
        }

        MonthNum = MonthNum - 1;
        String MonthFormatted = '';
        If (MonthNum < 10) {
            MonthFormatted = '0' + MonthNum.format();
        } else {
            MonthFormatted = MonthNum.format();
        }
        RptDt = Year + MonthFormatted;
        return RptDt;
    }
    //END ADD TPB 03/13/2017   
}