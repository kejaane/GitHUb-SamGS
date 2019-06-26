//=========================================================================================
//     Date: 12/30/2014
//Developer: Enable Path
//  Purpose: 
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
// 03/13/2017 Tom Barrett TPB   Made significant changes where code was reading the Enrollment__c
//                              object to get the latest Rpt_Dt__c date value.
//                              The replacement is to read the Enrollent_Import__c and the 
//                              Enrollment_Import_2_50__c objects instead.             
//====================================================================================================
public class enrollmentFilters2_199 {
    
    public string reportType {get;set;}
    public string month {get;set;}
    public string year {get;set;}
    public string jurisdiction {get;set;}
    public string recType {get;set;}
    public Decimal contractNumber {get;set;}
    public Decimal groupNumber {get;set;}
    public List<SelectOption> reportTypeList {get;set;}
    public List<SelectOption> monthList {get;set;}
    public List<SelectOption> years {get;set;}
    public List<SelectOption> jurisdictionList {get;set;}
    public List<SelectOption> recTypes {get;set;}
    public List<Summary_Enrollment_Jurisdiction__c> jurisdictions {get;set;}
    public List<String> jurisdictionTypes {get;set;}
    public Decimal totalStartingBalance {get;set;}
    public Decimal totalNew {get;set;}
    public Decimal totalTermed {get;set;}
    public Decimal totalMonthEndBalance {get;set;}
    public Boolean displayResults {get;set;}
    public map<string,Enrollment_Summary_51_Terms__c> customSettingMap {get;set;}
    
    public List<ResultsWrapper> results {get;set;}
    public List<totalWrapper> totals {get;set;}
    public List<String> total {get;set;}
    
    public enrollmentFilters2_199(ApexPages.StandardController controller) {
    
       displayResults = false;
        
        results = new List<ResultsWrapper>();
        customSettingMap = new map<string,Enrollment_Summary_51_Terms__c>();
        
        AggregateResult ar = [SELECT MAX(Date__c) MaxDate FROM Enrollment_Summary__c];
        if( null != ar ) {
            String sMaxDate = String.valueOf(ar.get('MaxDate'));
            year = sMaxDate.substring(0,4);
            month = sMaxDate.substring(4,6);
        }

        List<Summary_Enrollment_Report_Type__c> reportTypes = [SELECT Id, Name FROM Summary_Enrollment_Report_Type__c ORDER BY NAME];
        reportTypeList = new List<SelectOption>();
        
        for( Summary_Enrollment_Report_Type__c r : reportTypes ) {
            reportTypeList.add( new SelectOption( r.Name, r.Name ) );
        }
        
        jurisdictions = [SELECT Id, Name FROM Summary_Enrollment_Jurisdiction__c where Name != 'ALL' ORDER BY NAME];
        jurisdictionList = new List<SelectOption>();
        jurisdictionTypes = new List<String>();
        
        for( Summary_Enrollment_Jurisdiction__c j : jurisdictions ) {
            //jurisdictionList.add( new SelectOption( String.valueOf(j.Name), j.Name ) );
            jurisdictionTypes.add(j.name);
        }
        
        years = new List<SelectOption>();
        List<Summary_Enrollment_Start_Year__c> startYears = [SELECT Id, Name FROM Summary_Enrollment_Start_Year__c ORDER BY NAME];
        years = new List<SelectOption>();
        
        for( Summary_Enrollment_Start_Year__c s1 : startYears ) {
            years.add( new SelectOption( String.valueOf(s1.Name), s1.Name ) );
        }
        
        recTypes = new List<SelectOption>();
        recTypes.add(new SelectOption('2-50','2-50'));
        recTypes.add(new SelectOption('51+','51+'));
            
        List<Enrollment_Summary_51_Terms__c> terms = [Select Id, Contracts__c, Groups__c, Jurisdiction__c from Enrollment_Summary_51_Terms__c];        
        
        for(Enrollment_Summary_51_Terms__c cs : terms){
            customSettingMap.put(cs.Jurisdiction__c,cs);
        }
        
        // Months are pretty standard.  We don't need a custom setting for them.
        monthList = new List<SelectOption>();
        monthList.add( new SelectOption( '01', 'January' ) );
        monthList.add( new SelectOption( '02', 'February' ) );
        monthList.add( new SelectOption( '03', 'March' ) );
        monthList.add( new SelectOption( '04', 'April' ) );
        monthList.add( new SelectOption( '05', 'May' ) );
        monthList.add( new SelectOption( '06', 'June' ) );
        monthList.add( new SelectOption( '07', 'July' ) );
        monthList.add( new SelectOption( '08', 'August' ) );
        monthList.add( new SelectOption( '09', 'September' ) );
        monthList.add( new SelectOption( '10', 'October' ) );
        monthList.add( new SelectOption( '11', 'November' ) );
        monthList.add( new SelectOption( '12', 'December' ) );
    
    }
    
    public void go(){
    
        total = new List<String>();
        string s = '';
        total.add(s);
    
        if(results.size() > 0){
            results.clear();
        }
        
        List<Enrollment_Summary__c> allES = new list<Enrollment_Summary__c>();
        /*enrollment__c maxEnrollment = [Select Rpt_dt__c from enrollment__c where RecordType.Name = :recType order by Rpt_dt__c DESC limit 1];
        
        String maxDate = maxEnrollment.Rpt_dt__c;
       
        System.debug('maxDate = ' + maxDate);
        
        year = maxDate.substring(0,4);
        System.debug( 'year = ' + year );
        month = maxDate.substring(4);
        System.debug( 'month = ' + month );
        String filterDate = year + month;
        System.debug( 'Filter = ' + filterDate );
        System.debug( 'recType = ' + recType );*/
        
        if(recType == '51+'){
        //BEGIN CHANGE TPB 03/13/2017
        //enrollment__c maxEnrollment51 = [Select Rpt_dt__c from enrollment__c where RecordType.Name = :recType order by Rpt_dt__c DESC limit 1];
        
        //String maxDate51 = maxEnrollment51.Rpt_dt__c;
        
        String maxDate51 =  Enrollment_QueryBase.GetLatestEnrlRunDt51();
        //END CHANGE TPB 03/13/2017
       
        System.debug('maxDate = ' + maxDate51);
        
        year = maxDate51.substring(0,4);
        System.debug( 'year = ' + year );
        month = maxDate51.substring(4);
        System.debug( 'month = ' + month );
        String filterDate51 = year + month;
        System.debug( 'Filter = ' + filterDate51 );
        System.debug( 'recType = ' + recType );
        
        allES = [SELECT Id, Name, Date__c, Jurisdiction__c, Month_Name__c, Net_Change_Contracts__c, Net_Change_Groups__c, Net_Contract_Growth_Pct__c,
                                               New_Contracts__c, New_Contract_Sales_Pct__c, New_Groups__c, Off_Cycle_Contracts__c, Off_Cycle_Groups__c,
                                               Off_Cycle_Termed_Contract_Pct__c, Off_Cycle_Termed_Contracts__c, Off_Cycle_Termed_Groups__c, On_Cycle_Contracts__c,
                                               On_Cycle_Groups__c, On_Cycle_Termed_Contract_Pct__c, On_Cycle_Termed_Contracts__c, On_Cycle_Termed_Groups__c,
                                               Total_Contracts__c, Total_Contract_Terms_Pct__c, Total_Groups__c, Total_Termed_Contracts__c, Total_Termed_Groups__c,
                                               year__c, Recordtype.Name                                         
                                               FROM Enrollment_Summary__c
                                               WHERE Date__c = :filterDate51
                                               AND RecordType.Name = :recType
                                               order by Jurisdiction__c]; 
                                               
        }
        
        if(recType == '2-50'){
        //BEGIN CHANGE TPB 03/13/2017
        //enrollment__c maxEnrollment2_50 = [Select Rpt_dt__c from enrollment__c where RecordType.Name = :recType order by Rpt_dt__c DESC limit 1];
        
        //String maxDate2_50 = maxEnrollment2_50.Rpt_dt__c;
        
        String maxDate2_50 = Enrollment_QueryBase.GetLatestEnrlRunDt2_50();
        //END CHANGE TPB 03/13/2017
       
        System.debug('maxDate = ' + maxDate2_50);
        
        year = maxDate2_50.substring(0,4);
        System.debug( 'year = ' + year );
        month = maxDate2_50.substring(4);
        System.debug( 'month = ' + month );
        String filterDate2_50 = year + month;
        System.debug( 'Filter = ' + filterDate2_50 );
        System.debug( 'recType = ' + recType );
        
        allES = [SELECT Id, Name, Date__c, Jurisdiction__c, Month_Name__c, Net_Change_Contracts__c, Net_Change_Groups__c, Net_Contract_Growth_Pct__c,
                                               New_Contracts__c, New_Contract_Sales_Pct__c, New_Groups__c, Off_Cycle_Contracts__c, Off_Cycle_Groups__c,
                                               Off_Cycle_Termed_Contract_Pct__c, Off_Cycle_Termed_Contracts__c, Off_Cycle_Termed_Groups__c, On_Cycle_Contracts__c,
                                               On_Cycle_Groups__c, On_Cycle_Termed_Contract_Pct__c, On_Cycle_Termed_Contracts__c, On_Cycle_Termed_Groups__c,
                                               Total_Contracts__c, Total_Contract_Terms_Pct__c, Total_Groups__c, Total_Termed_Contracts__c, Total_Termed_Groups__c,
                                               year__c, Recordtype.Name                                         
                                               FROM Enrollment_Summary__c
                                               WHERE Date__c = :filterDate2_50 //WHERE Date__c >= '201301'
                                                AND RecordType.Name = :recType
                                               order by Jurisdiction__c];
        }
            
        system.debug('allES = '+allES.size());
           Map<string,List<Enrollment_Summary__c>> ESMap = new Map<string,List<Enrollment_Summary__c>>();
           
           Map<string,Enrollment_Summary__c> JurMap = new Map<string,Enrollment_Summary__c>();
           
           for(Enrollment_Summary__c ES : allES){
               system.debug('making maps');
               
                   JurMap.put(ES.Jurisdiction__c,ES);
           }
           
           for(String j : jurisdictionTypes){
               system.debug('assigning jurisdictions');
               if(JurMap.containsKey(j)) {
                   List<Enrollment_Summary__c> esList = new List<Enrollment_Summary__c>();
                   esList.add(JurMap.get(j));                  
                   
                   ESMap.put(j,esList);
               }           
           }
           
           for(string j : ESMap.keyset()){
               Decimal startingBalance = 0;
               Decimal newCount = 0;
               Decimal termed = 0;
               Decimal monthEndBalance = 0;
               
               List<Enrollment_Summary__c> esList = ESMap.get(j);
               system.debug('esList'+esList.size()); 
               
               Enrollment_Summary_51_Terms__c csNumbers = customSettingMap.get(j);
               
               for(Enrollment_Summary__c ES : esList){
                   system.debug('ES ID - '+ES.Id); 
                   system.debug('reportType - '+reportType);
                   if(reportType == 'Contracts'){
                       startingBalance = startingBalance + ES.Total_Contracts__c;
                       system.debug('startingBalance - '+ES.Id+' - '+startingBalance);
                  // 12-26-2014 jhm: Changed from Total_Termed_Contracts__c 
                       newCount = newCount + ES.New_Contracts__c;
                       system.debug('newCount - '+ES.Id+' - '+newCount);
                       termed = termed + ES.Total_Termed_Contracts__c;
                       system.debug('termed - '+ES.Id+' - '+termed);
                   }
                   
                   if(reportType == 'Groups'){
                       startingBalance = startingBalance + ES.Total_Groups__c;
                  // 12-26-2014 jhm: Changed from Total_Termed_Groups__c 
                       newCount = newCount + ES.New_Groups__c;
                       termed = termed + ES.Total_Termed_Groups__c;
                   }
               }
               
           
               if(reportType == 'Contracts' && null != csNumbers && recType == '51+'){
                   termed = termed + csNumbers.Contracts__c;
               }
                   
               if(reportType == 'Groups' && null != csNumbers && recType == '51+'){
                   termed = termed + csNumbers.Groups__c;
               }
                  
               monthEndBalance = (startingBalance + newCount) - termed;
                   
               ResultsWrapper rw = new ResultsWrapper();
               rw.startingBalance = startingBalance;
               rw.newCount = newCount;
               rw.termed = termed;
               rw.monthEndBalance = monthEndBalance;
               rw.jurisdiction = j;
              
               results.add(rw);  
           } 
           
           if(results.size() > 0){
               displayResults = true;
           }
           
           totalStartingBalance = calcTotals(results,'startingBalance');
           totalNew = calcTotals(results,'newCount');
           totalTermed = calcTotals(results,'termed');
           totalMonthEndBalance = calcTotals(results,'monthEndBalance');
        
            totals = new List<totalWrapper>();
            
        totalWrapper tw = new totalWrapper();
            tw.startingBalance = totalStartingBalance;
            tw.newCount = totalNew;
            tw.termed = totalTermed;
            tw.monthEndBalance = totalMonthEndBalance;
            
        totals.add(tw);
    }
    
    public Decimal calcTotals(List<ResultsWrapper> wraps, String field){
    
        Decimal d = 0;
        
        for(ResultsWrapper w : wraps){
            if(field == 'startingBalance'){
               d = d + w.startingBalance;
            }
            if(field == 'newCount'){
               d = d + w.newCount;
            }
            if(field == 'termed'){
               d = d + w.termed;
            }
            if(field == 'monthEndBalance'){
               d = d + w.monthEndBalance;
            }
        }
    
        return d;
    }
    
    public class ResultsWrapper{
        public Decimal startingBalance {get;set;}
        public Decimal newCount {get;set;}
        public Decimal termed {get;set;}
        public Decimal monthEndBalance {get;set;}
        public String jurisdiction {get;set;}
    }
    
    public class totalWrapper{
        public Decimal startingBalance {get;set;}
        public Decimal newCount {get;set;}
        public Decimal termed {get;set;}
        public Decimal monthEndBalance {get;set;}
        public String jurisdiction {get;set;}
    }
        
}