/*************************************************************************************************************************************************
*  Date             : 05/30/2018
*  Developer        : Thejaswi Ganesh
*  Purpose          : Batch class to handle Enrollment Deletion of older records.
*                     This is how you call it:
*                     EnrollmentDeletionBatchJob be = new EnrollmentDeletionBatchJob('initial');
*                     database.executeBatch(be);  
*                     (OR) For yearly cleanup please use below code.
*                     EnrollmentDeletionBatchJob be = new EnrollmentDeletionBatchJob('yearly');
*                     database.executeBatch(be);  
*
*  Update History:
* ----------------------------------------------------------------------------------------------------------------------------------------------
*  Author          Date-Modified      Tag      Description of Change
* ----------------------------------------------------------------------------------------------------------------------------------------------
* Thejaswi Ganesh  05/30/2018                  Initial Creation
*
************************************************************************************************************/
global class EnrollmentDeletionBatchJob implements Database.Batchable<sObject> {
    
    String StartDate = String.valueOf(System.Today().year()-2)+'-01-01';//Dynamic calcuation of startDate for e.g if currentYear is 2018 startDate will be 2016-01-01
    //The below query fetches 2-50 enrollments under 2-50 opportunities with 
    //effective date < startDate and order by descending Rpt_Dt
    String EndDate = String.valueOf(System.Today().year()-2)+'-12-01';
    String RecordId = '01260000000cWHjAAM';
    String RecordType = '2-50';
    String query = '';
    
    //By default deletion occurs in initial Batch mode
    global EnrollmentDeletionBatchJob() {
        query = 'SELECT Id,RecordType.Name,Name,(SELECT ID, RecordType.Name, RPT_Dt__c ' + 
            'FROM Enrollments__r ' + 
            'WHERE RecordType.id = \''+RecordId+'\' Order By Rpt_Dt__c DESC) ' + 
            'FROM Opportunity ' + 
            'WHERE  Effective_Date__c < '+StartDate+' AND RecordType.Name = \''+RecordType+'\'';
        
    }
    // In case of yearly mode pass 'yearly' to constructor
    global EnrollmentDeletionBatchJob( String deletionMode ) {
        // get the Record Type ID
        If(deletionMode.equalsIgnoreCase('initial') )
        {
            query = 'SELECT Id,RecordType.Name,Name,(SELECT ID, RecordType.Name, RPT_Dt__c ' + 
                'FROM Enrollments__r ' + 
                'WHERE RecordType.id = \''+RecordId+'\' Order By Rpt_Dt__c DESC) ' + 
                'FROM Opportunity ' + 
                'WHERE  Effective_Date__c < '+StartDate+' AND RecordType.Name = \''+RecordType+'\'';
            
        }
        else if (deletionMode.equalsIgnoreCase('yearly') )
        {
            query = 'SELECT Id,RecordType.Name,Name,(SELECT ID, RecordType.Name, RPT_Dt__c ' + 
                'FROM Enrollments__r ' + 
                'WHERE RecordType.id = \''+RecordId+'\' Order By Rpt_Dt__c DESC) ' + 
                'FROM Opportunity ' + 
                'WHERE  Effective_Date__c >= '+StartDate+' AND Effective_Date__c <= '+EndDate+' AND RecordType.Name = \''+RecordType+'\'';
            
        }    
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
        String RptDt = '';
        Boolean FirstTime = true;
        List<Enrollment__c> deleteList = new List<Enrollment__c>();
        //Loop enrollments under Opportunities and prepare delete list
        for(Opportunity opportunities: oppList){
            for(Enrollment__c enrollments : opportunities.Enrollments__r){
                //Do not add latest enrollment to deletList
                if(FirstTime == true)
                {
                    RptDt = enrollments.RPT_Dt__c;
                    FirstTime = false;
                }
                else if(!RptDt.equals(enrollments.RPT_Dt__c))
                {
                    deleteList.add(enrollments)  ;
                    //   b.Latest_Enrollment__c='N';
                    // FirstTime = false;  
                }    
            }
            RptDt='';
            FirstTime=true;   
            
        }
        try 
        {   // Invoke soql delete command list of enrollment objects in batch mode.
            delete deleteList;
            //  update deleteList;
            System.debug('Number of Enrollment records deleted ' + deleteList.size() );
        } 
        catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    
    global void finish(Database.BatchableContext BC) { 
    }
}