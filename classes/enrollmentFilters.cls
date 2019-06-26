/*************************************************************************************************************************************************
*  Update History:
* ----------------------------------------------------------------------------------------------------------------------------------------------
*  Author          Date-Modified      Tag      Description of Change
* ----------------------------------------------------------------------------------------------------------------------------------------------
* Thejaswi Ganesh  05/30/2018         T01      Updated to show only current Year and past 
*                                              2 years in StartYear drop down in total term
*                                              ratio VF page. Also deleted deprecated code.
* Thejaswi Ganesh  05/30/2018         T02      Commented Deprecated Code.
************************************************************************************************************/

public class enrollmentFilters {
    
    public string reportType {get;set;}
    public string startMonth {get;set;}
    public string endMonth {get;set;}
    public string startYear {get;set;}
    public string endYear {get;set;}
    public string jurisdiction {get;set;}
    public string css {get;set;}
    
    public List<SelectOption> reportTypeList {get;set;}
    public List<SelectOption> startYearList {get;set;}
    public List<SelectOption> endYearList {get;set;}
    public List<SelectOption> startMonthList {get;set;}
    public List<SelectOption> endMonthList {get;set;}
    public List<SelectOption> jurisdictionList {get;set;}
    public List<Summary_Enrollment_Jurisdiction__c> jurisdictions {get;set;}
    public List<String> jurisdictionTypes {get;set;}
    
    public List<Enrollment_Summary__c> lES {get;set;}
    public List<GroupWrapper> years {get; set;}
    
    public enrollmentFilters(ApexPages.StandardController controller) {
        css = 'hidden';
        years = new list<GroupWrapper>();
        // Get the custom settings for the filter selections
        List<Summary_Enrollment_Report_Type__c> reportTypes = [SELECT Id, Name FROM Summary_Enrollment_Report_Type__c ORDER BY NAME];
        reportTypeList = new List<SelectOption>();
        Integer i = 1;
        for( Summary_Enrollment_Report_Type__c r : reportTypes ) {
            reportTypeList.add( new SelectOption( String.valueOf(r.Name), r.Name ) );
        }
        
        jurisdictions = [SELECT Id, Name FROM Summary_Enrollment_Jurisdiction__c ORDER BY NAME];
        jurisdictionList = new List<SelectOption>();
        jurisdictionTypes = new List<String>();
        i = 1;
        for( Summary_Enrollment_Jurisdiction__c j : jurisdictions ) {
            jurisdictionList.add( new SelectOption( String.valueOf(j.Name), j.Name ) );
            jurisdictionTypes.add(j.name);
        }
        //BEGIN Change T01
        startYearList = new List<SelectOption>();
        Integer startYear = System.Today().year();
        Integer Number_Of_Years = 2; // This variable can be modified to set drop drop list. e.g 2 will display Current Year and Past two years in drop down.
        for (Integer K = Number_Of_Years; K>=0; K--) {
            startYearList.add(new SelectOption( String.valueOf(startYear-k), String.valueOf(startYear-k) ));
        }
        //END Change T01
       // List<Summary_Enrollment_End_Year__c> endYears = [SELECT Id, Name FROM Summary_Enrollment_End_Year__c ORDER BY NAME];// T02 Deprecated
        endYearList = new List<SelectOption>();
        endYearList.add( new SelectOption( '', 'Select Start Year' ) );
        /*i = 1;
        for( Summary_Enrollment_End_Year__c s1 : endYears ) {
            endYearList.add( new SelectOption( String.valueOf(s1.Name), s1.Name ) );
        }*/
        // Months are pretty standard.  We don't need a custom setting for them.
        startMonthList = new List<SelectOption>();
        startMonthList.add( new SelectOption( '01', 'January' ) );
        startMonthList.add( new SelectOption( '02', 'February' ) );
        startMonthList.add( new SelectOption( '03', 'March' ) );
        startMonthList.add( new SelectOption( '04', 'April' ) );
        startMonthList.add( new SelectOption( '05', 'May' ) );
        startMonthList.add( new SelectOption( '06', 'June' ) );
        startMonthList.add( new SelectOption( '07', 'July' ) );
        startMonthList.add( new SelectOption( '08', 'August' ) );
        startMonthList.add( new SelectOption( '09', 'September' ) );
        startMonthList.add( new SelectOption( '10', 'October' ) );
        startMonthList.add( new SelectOption( '11', 'November' ) );
        startMonthList.add( new SelectOption( '12', 'December' ) );
        endMonthList = new List<SelectOption>();
        endMonthList.add( new SelectOption( '01', 'January' ) );
        endMonthList.add( new SelectOption( '02', 'February' ) );
        endMonthList.add( new SelectOption( '03', 'March' ) );
        endMonthList.add( new SelectOption( '04', 'April' ) );
        endMonthList.add( new SelectOption( '05', 'May' ) );
        endMonthList.add( new SelectOption( '06', 'June' ) );
        endMonthList.add( new SelectOption( '07', 'July' ) );
        endMonthList.add( new SelectOption( '08', 'August' ) );
        endMonthList.add( new SelectOption( '09', 'September' ) );
        endMonthList.add( new SelectOption( '10', 'October' ) );
        endMonthList.add( new SelectOption( '11', 'November' ) );
        endMonthList.add( new SelectOption( '12', 'December' ) );
    }
    
    public void resetEndYear(){
        if(startYear != 'none'){
            Decimal startYearNum = decimal.valueOf(startYear);
            
            endYearList.clear();
            endYearList.add( new SelectOption(string.valueOf(startYearNum+1), string.valueOf(startYearNum+1)) );
            //endYearList.add( new SelectOption(string.valueOf(startYearNum+2), string.valueOf(startYearNum+2)) );
        }else{
            endYearList.clear();
            endYearList.add( new SelectOption( '', 'Select Start Year' ) );
        }
        
    }
    
    public void Go() {
        reportType = reportType;
        Decimal startYearNum = decimal.valueOf(startYear);
        endYear = string.Valueof(startYearNum+1);
        
        if(years.size() > 0){
            years.clear();
        }
        
        String dateFilterStart = startYear + startMonth;
        String dateFilterEnd = endYear + endMonth;
        System.debug( 'Date Filter Start: ' + dateFilterStart );
        System.debug( 'Date Filter End: ' + dateFilterEnd );
        
        if(jurisdiction != 'ALL'){
            jurisdictionTypes.clear();
            jurisdictionTypes.add(jurisdiction);
        }
        
        if(jurisdiction == 'ALL'){
            jurisdictionTypes.clear();
            for( Summary_Enrollment_Jurisdiction__c j : jurisdictions ) {
                jurisdictionTypes.add(j.name);
            }
        }
        
        
        
        system.debug(jurisdictionTypes);
        
        
        lES = [SELECT Name, Date__c, Jurisdiction__c, Month_Name__c, Net_Change_Contracts__c, Net_Change_Groups__c, Net_Contract_Growth_Pct__c,
               New_Contracts__c, New_Contract_Sales_Pct__c, New_Groups__c, Off_Cycle_Contracts__c, Off_Cycle_Groups__c,
               Off_Cycle_Termed_Contract_Pct__c, Off_Cycle_Termed_Contracts__c, Off_Cycle_Termed_Groups__c, On_Cycle_Contracts__c,
               On_Cycle_Groups__c, On_Cycle_Termed_Contract_Pct__c, On_Cycle_Termed_Contracts__c, On_Cycle_Termed_Groups__c,
               Total_Contracts__c, Total_Contract_Terms_Pct__c, Total_Groups__c, Total_Termed_Contracts__c, Total_Termed_Groups__c,
               year__c, On_Cycle_Termed_Groups_Pct__c, Off_Cycle_Termed_Groups_Pct__c, Total_Group_Terms_Pct__c, New_Group_Sales_Pct__c,                                             
               Net_Group_Growth_Pct__c, Month__c
               FROM Enrollment_Summary__c
               WHERE (Year__c = :startYear
                      OR Year__c = :endYear)
               AND Month__c >= :startMonth
               AND Month__c <= :endMonth
               AND RecordType.Name = '2-50'
               AND Jurisdiction__c in :jurisdictionTypes
               order by Date__c,Jurisdiction__c];
        
        
        years=new List<GroupWrapper>();
        
        Map<String, List<Enrollment_Summary__c>> groupedMap=new Map<String, List<Enrollment_Summary__c>>();
        for (Enrollment_Summary__c acc : lES)
        {
            String key=acc.year__c;
            List<Enrollment_Summary__c> groupedAccs=groupedMap.get(key);
            if (null==groupedAccs)
            {
                groupedAccs=new List<Enrollment_Summary__c>();
                groupedMap.put(key, groupedAccs);
            }
            
            groupedAccs.add(acc);
        }
        
        for (String key : groupedMap.keySet())
        {
            GroupWrapper gr=new GroupWrapper();
            years.add(gr);
            gr.accs=groupedMap.get(key);  
            gr.monthWrappers = createSubTotalWrappers(groupedMap.get(key));
            gr.groupedVal=key;
            gr.reportType = reportType;
            gr.createTotals();
        }
        
        List<Decimal> yearSort = new List<Decimal>();
        Map<Decimal,GroupWrapper> yearSortMap = new Map<Decimal,GroupWrapper>();
        
        for(GroupWrapper gw : years){
            yearSort.add(decimal.valueOf(gw.groupedVal));
            yearSortMap.put(decimal.valueOf(gw.groupedVal),gw);
        }
        
        yearSort.sort();
        years.clear();
        for(Decimal d : yearSort){
            years.add(yearSortMap.get(d));
        }
        if(years.size() == 2){
            atomizationWrapper aw = new atomizationWrapper();
            aw.totalOnCyclePercent = years[1].totals[0].totalOnCyclePercent - years[0].totals[0].totalOnCyclePercent;
            aw.totalOffCyclePercent = years[1].totals[0].totalOffCyclePercent - years[0].totals[0].totalOffCyclePercent;
            aw.totalTermsPercent = years[1].totals[0].totalTermsPercent - years[0].totals[0].totalTermsPercent;
            aw.totalNewSalesPercent = years[1].totals[0].totalNewSalesPercent - years[0].totals[0].totalNewSalesPercent;
            aw.netGrowth = years[1].totals[0].netGrowth - years[0].totals[0].netGrowth;
            
            years[1].atomWrap = new List<atomizationWrapper>();
            years[1].atomWrap.add(aw);
            years[1].displayAtomWrap = true;
        }
        
        Map<String,Enrollment_Summary__c> monthMap = new Map<string,Enrollment_Summary__c>();
        
        for(Enrollment_Summary__c es : lES){
            
        }
    }
    
    public List<subTotalWrapper> createSubTotalWrappers(List<Enrollment_Summary__c> accs){
        List<subTotalWrapper> wrappers = new List<subTotalWrapper>();
        
        Map<String, List<Enrollment_Summary__c>> groupedMap=new Map<String, List<Enrollment_Summary__c>>();
        for (Enrollment_Summary__c es : accs){
            String key=es.Month_Name__c;
            List<Enrollment_Summary__c> groupedAccs=groupedMap.get(key);
            
            if (null==groupedAccs){
                groupedAccs=new List<Enrollment_Summary__c>();
                groupedMap.put(key, groupedAccs);
            }
            groupedAccs.add(es);
        }
        
        for (String key : groupedMap.keySet()){
            subTotalWrapper tw=new subTotalWrapper();
            wrappers.add(tw);
            tw.accs=groupedMap.get(key);             
            tw.month=key;   
            tw.reportType = reportType;
            tw.createTotals();
            if(key == 'Jan'){tw.monthNumber = 1;}
            if(key == 'Feb'){tw.monthNumber = 2;}
            if(key == 'Mar'){tw.monthNumber = 3;}
            if(key == 'Apr'){tw.monthNumber = 4;}
            if(key == 'May'){tw.monthNumber = 5;}
            if(key == 'Jun'){tw.monthNumber = 6;}
            if(key == 'Jul'){tw.monthNumber = 7;}
            if(key == 'Aug'){tw.monthNumber = 8;}
            if(key == 'Sep'){tw.monthNumber = 9;}
            if(key == 'Oct'){tw.monthNumber = 10;}
            if(key == 'Nov'){tw.monthNumber = 11;}
            if(key == 'Dec'){tw.monthNumber = 12;}
            
            if(jurisdiction == 'ALL'){tw.displayTable = true;} 
        }
        
        List<Decimal> monthSort = new List<Decimal>();
        Map<Decimal,subTotalWrapper> monthSortMap = new Map<Decimal,subTotalWrapper>();
        
        for(subTotalWrapper sw : wrappers){
            monthSort.add(sw.monthNumber);
            monthSortMap.put(sw.monthNumber,sw);
            
        }
        
        monthSort.sort();
        wrappers.clear();
        Integer order = 0;
        for(Decimal d : monthSort){
            subTotalWrapper sw = monthSortMap.get(d);
            // if(order == 0){
            sw.cssClass = 'hidden';
            //}else{
            sw.cssClass = '';
            // }
            wrappers.add(sw);
            order++;
        }
        
        
        
        return wrappers;
    }
    
    public class GroupWrapper{
        public List<Enrollment_Summary__c> accs {get; set;}
        public List<subTotalWrapper> monthWrappers {get;set;}
        public String groupedVal {get; set;}
        public Integer count {get {return accs.size(); } set;}
        public List<totalsWrapper> totals {get;set;}
        public List<atomizationWrapper> atomWrap {get;set;}
        public Boolean displayAtomWrap {get;set;}
        public String reportType {get;set;}
        
        
        public void createTotals(){
            totals = new List<totalsWrapper>();
            totalsWrapper total = new totalsWrapper();
            total.avgTotalTermedSize = 0;
            total.totalOnCycle = 0;
            total.totalTermed = 0;
            total.totalonCycleTermed = 0;
            total.totaloffCycleTermed = 0;
            total.totalNew = 0;
            total.netChange = 0;
            total.totalOnCyclePercent = 0;
            total.totalOffCyclePercent = 0;
            total.totalTermsPercent = 0;
            total.totalNewSalesPercent = 0;
            total.netGrowth = 0;
            
            decimal totalTermedGroups = 0;
            decimal totalTermedContracts = 0;
            for(subTotalWrapper sw : monthWrappers){
                for(Enrollment_Summary__c es : sw.accs){
                    if(reportType != 'Groups'){
                        total.totalOnCycle = total.totalOnCycle + es.On_Cycle_Contracts__c;
                        total.totalTermed = total.totalTermed + es.Total_Termed_Contracts__c;
                        total.totalonCycleTermed = total.totalonCycleTermed + es.On_Cycle_Termed_Contracts__c;
                        total.totaloffCycleTermed = total.totaloffCycleTermed + es.Off_Cycle_Termed_Contracts__c;
                        total.totalNew = total.totalNew + es.New_Contracts__c;
                        total.netChange = total.netChange + es.Net_Change_Contracts__c;
                    }
                    
                    if(reportType == 'Groups'){
                        total.totalOnCycle = total.totalOnCycle + es.On_Cycle_Groups__c;
                        total.totalTermed = total.totalTermed + es.Total_Termed_Groups__c;
                        total.totalonCycleTermed = total.totalonCycleTermed + es.On_Cycle_Termed_Groups__c;
                        total.totaloffCycleTermed = total.totaloffCycleTermed + es.Off_Cycle_Termed_Groups__c;
                        total.totalNew = total.totalNew + es.New_Groups__c;
                        total.netChange = total.netChange + es.Net_Change_Groups__c;
                    }
                    totalTermedContracts = totalTermedContracts + es.Total_Termed_Contracts__c;
                    totalTermedGroups = totalTermedGroups + es.Total_Termed_Groups__c;
                }
            }
            if(total.totalOnCycle != 0){
                total.totalOnCyclePercent = (total.totalonCycleTermed/total.totalOnCycle)*100;
                total.totalOnCyclePercent = total.totalOnCyclePercent.setscale(1);
                total.totalOffCyclePercent = (total.totaloffCycleTermed/total.totalOnCycle)*100;
                total.totalOffCyclePercent = total.totalOffCyclePercent.setscale(1);
                total.totalTermsPercent = (total.totalTermed/total.totalOnCycle)*100;
                total.totalTermsPercent = total.totalTermsPercent.setscale(1);
                total.totalNewSalesPercent = (total.totalNew/total.totalOnCycle)*100;
                total.totalNewSalesPercent = total.totalNewSalesPercent.setscale(1);
                total.netGrowth = (total.netChange/total.totalOnCycle)*100;
                total.netGrowth = total.netGrowth.setscale(1);
            }
            if(totalTermedGroups != 0){
                total.avgTotalTermedSize = (totalTermedContracts/totalTermedGroups);
                total.avgTotalTermedSize = total.avgTotalTermedSize.setScale(1);
            }
            
            totals.add(total);
            
        }
    }
    
    public class totalsWrapper{
        public Decimal avgTotalTermedSize {get;set;}
        public Decimal totalOnCycle {get; set;}
        public Decimal totalTermed {get; set;}
        public Decimal totalonCycleTermed {get; set;}
        public Decimal totaloffCycleTermed {get; set;}
        public Decimal totalNew {get; set;}
        public Decimal netChange {get; set;}
        public Decimal totalOnCyclePercent {get; set;}
        public Decimal totalOffCyclePercent {get; set;}
        public Decimal totalTermsPercent {get; set;}
        public Decimal totalNewSalesPercent {get; set;}
        public Decimal netGrowth {get; set;}    
        public Decimal totalActive {get; set;} 
        public Decimal totalOffCycle {get; set;} 
        
    }
    
    public class subTotalWrapper{
        public List<Enrollment_Summary__c> accs {get; set;}
        public String month {get;set;}
        public totalsWrapper total {get; set;}  
        public Decimal monthNumber {get;set;}
        public String cssClass {get;set;}
        public String reportType {get;set;}
        public Boolean displayTable {get;set;}
        
        public void createTotals(){
            total = new totalsWrapper();
            total.avgTotalTermedSize = 0;
            total.totalOnCycle = 0;
            total.totalTermed = 0;
            total.totalonCycleTermed = 0;
            total.totaloffCycleTermed = 0;
            total.totalNew = 0;
            total.netChange = 0;
            total.totalOnCyclePercent = 0;
            total.totalOffCyclePercent = 0;
            total.totalTermsPercent = 0;
            total.totalNewSalesPercent = 0;
            total.netGrowth = 0;
            total.totalActive = 0;
            total.totalOffCycle = 0;
            
            decimal totalTermedGroups = 0;
            decimal totalTermedContracts = 0;
            for(Enrollment_Summary__c es : accs){
                if(reportType != 'Groups'){
                    total.totalOnCycle = total.totalOnCycle + es.On_Cycle_Contracts__c;
                    total.totalTermed = total.totalTermed + es.Total_Termed_Contracts__c;
                    total.totalonCycleTermed = total.totalonCycleTermed + es.On_Cycle_Termed_Contracts__c;
                    total.totaloffCycleTermed = total.totaloffCycleTermed + es.Off_Cycle_Termed_Contracts__c;
                    total.totalNew = total.totalNew + es.New_Contracts__c;
                    total.netChange = total.netChange + es.Net_Change_Contracts__c;
                    total.totalActive = total.totalActive + es.Total_Contracts__c;
                    total.totalOffCycle = total.totalOffCycle + es.Off_Cycle_Contracts__c;
                }
                
                if(reportType == 'Groups'){
                    total.totalOnCycle = total.totalOnCycle + es.On_Cycle_Groups__c;
                    total.totalTermed = total.totalTermed + es.Total_Termed_Groups__c;
                    total.totalonCycleTermed = total.totalonCycleTermed + es.On_Cycle_Termed_Groups__c;
                    total.totaloffCycleTermed = total.totaloffCycleTermed + es.Off_Cycle_Termed_Groups__c;
                    total.totalNew = total.totalNew + es.New_Groups__c;
                    total.netChange = total.netChange + es.Net_Change_Groups__c;
                    total.totalActive = total.totalActive + es.Total_Groups__c;
                    total.totalOffCycle = total.totalOffCycle + es.Off_Cycle_Groups__c;
                }
                totalTermedContracts = totalTermedContracts + es.Total_Termed_Contracts__c;
                totalTermedGroups = totalTermedGroups + es.Total_Termed_Groups__c;
            }
            
            if(total.totalOnCycle != 0){
                total.totalOnCyclePercent = (total.totalonCycleTermed/total.totalOnCycle)*100;
                total.totalOnCyclePercent = total.totalOnCyclePercent.setscale(1);
                total.totalOffCyclePercent = (total.totaloffCycleTermed/total.totalOnCycle)*100;
                total.totalOffCyclePercent = total.totalOffCyclePercent.setscale(1);
                total.totalTermsPercent = (total.totalTermed/total.totalOnCycle)*100;
                total.totalTermsPercent = total.totalTermsPercent.setscale(1);
                total.totalNewSalesPercent = (total.totalNew/total.totalOnCycle)*100;
                total.totalNewSalesPercent = total.totalNewSalesPercent.setscale(1);
                total.netGrowth = (total.netChange/total.totalOnCycle)*100;
                total.netGrowth = total.netGrowth.setscale(1);
            }
            if(totalTermedGroups != 0){
                total.avgTotalTermedSize = (totalTermedContracts/totalTermedGroups)*100;
                total.avgTotalTermedSize = total.avgTotalTermedSize.setScale(1);
            }
        }
        
        
    }
    
    public class atomizationWrapper{
        public Decimal totalOnCyclePercent {get; set;}
        public Decimal totalOffCyclePercent {get; set;}
        public Decimal totalTermsPercent {get; set;}
        public Decimal totalNewSalesPercent {get; set;}
        public Decimal netGrowth {get; set;}
        
    }
    
}