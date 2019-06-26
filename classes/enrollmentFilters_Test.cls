//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
// 05/26/2017    Rajesh Pennam   Updated class by removing see all data= true 
//====================================================================================================

@isTest 
private class enrollmentFilters_Test {
    static testMethod void Test1() {
         PageReference pageRef = Page.EnrollmentsSummarized;
         Test.setCurrentPageReference(pageRef);
        
         
         Summary_Enrollment_Jurisdiction__c cc=new Summary_Enrollment_Jurisdiction__c();
         cc.name='VA';
         insert cc;
        
         
         Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
         Schema.SObjectType s = sObjectMap.get('Enrollment_Summary__c') ; 
         Schema.DescribeSObjectResult resSchema = s.getDescribe() ;
         Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName();
         
         List<Enrollment_Summary__c> sums = new List<Enrollment_Summary__c>();
         
         Enrollment_Summary__c ES1 = new Enrollment_Summary__c(
               Date__c = '201312',
               RecordTypeId = recordTypeInfo.get('2-50').getRecordTypeId(),
               Jurisdiction__c = 'VA',
         On_Cycle_Contracts__c = 2,
         Total_Termed_Groups__c = 2);
         
         sums.add(ES1);
               
         Enrollment_Summary__c ES2 = new Enrollment_Summary__c(
               Date__c = '201312',
               RecordTypeId = recordTypeInfo.get('2-50').getRecordTypeId(),
               Jurisdiction__c = 'MD',
         On_Cycle_Contracts__c = 2,
         Total_Termed_Groups__c = 2);
         
         sums.add(ES2);
        
        Enrollment_Summary__c ES3 = new Enrollment_Summary__c(
               Date__c = '201412',
               RecordTypeId = recordTypeInfo.get('2-50').getRecordTypeId(),
               Jurisdiction__c = 'MD');
         
         sums.add(ES3);
        
        Enrollment_Summary__c ES4 = new Enrollment_Summary__c(
               Date__c = '201412',
               RecordTypeId = recordTypeInfo.get('2-50').getRecordTypeId(),
               Jurisdiction__c = 'MD');
         
         sums.add(ES4);
         
         insert sums;
                
                
                     
        ApexPages.StandardController sc = new ApexPages.standardController(ES1);
        enrollmentFilters con = new enrollmentFilters(sc);  
            
         con.reportType = 'Contracts';
         con.startMonth = '01';
         con.endMonth = '12';
         con.startYear = '2013';
         con.resetEndYear();
         con.jurisdiction = 'ALL';
         con.go();
        
        ApexPages.StandardController sc2 = new ApexPages.standardController(ES2);
        enrollmentFilters con2 = new enrollmentFilters(sc2);  
            
         con2.reportType = 'Groups';
         con2.startMonth = '01';
         con2.endMonth = '12';
         con2.startYear = '2013';
         con2.resetEndYear();
         con2.jurisdiction = 'ALL';
         con2.go();
        
            
    }
     static testMethod void Test2() {
         PageReference pageRef = Page.EnrollmentsSummarized;
         Test.setCurrentPageReference(pageRef);
        
         
         Summary_Enrollment_Jurisdiction__c cc=new Summary_Enrollment_Jurisdiction__c();
         cc.name='VA';
         insert cc;
        
         
         Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
         Schema.SObjectType s = sObjectMap.get('Enrollment_Summary__c') ; 
         Schema.DescribeSObjectResult resSchema = s.getDescribe() ;
         Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName();
         
         List<Enrollment_Summary__c> sums = new List<Enrollment_Summary__c>();
         
         Enrollment_Summary__c ES1 = new Enrollment_Summary__c(
               Date__c = '201312',
               RecordTypeId = recordTypeInfo.get('2-50').getRecordTypeId(),
               Jurisdiction__c = 'VA',
         On_Cycle_Groups__c = 2,
         Total_Termed_Groups__c = 2);
         
         sums.add(ES1);
               
         Enrollment_Summary__c ES2 = new Enrollment_Summary__c(
               Date__c = '201312',
               RecordTypeId = recordTypeInfo.get('2-50').getRecordTypeId(),
               Jurisdiction__c = 'MD',
               On_Cycle_Groups__c = 2,
               Total_Termed_Groups__c = 2);
         
         sums.add(ES2);
        
        Enrollment_Summary__c ES3 = new Enrollment_Summary__c(
               Date__c = '201412',
               RecordTypeId = recordTypeInfo.get('2-50').getRecordTypeId(),
               Jurisdiction__c = 'MD',
               On_Cycle_Groups__c = 2,
               Total_Termed_Groups__c = 2);
         
         sums.add(ES3);
        
        Enrollment_Summary__c ES4 = new Enrollment_Summary__c(
               Date__c = '201412',
               RecordTypeId = recordTypeInfo.get('2-50').getRecordTypeId(),
               Jurisdiction__c = 'MD');
         
         sums.add(ES4);
         
         insert sums;
                
                
                     
        ApexPages.StandardController sc = new ApexPages.standardController(ES1);
        enrollmentFilters con = new enrollmentFilters(sc);  
            
         con.reportType = 'Groups';
         con.startMonth = '01';
         con.endMonth = '12';
         con.startYear = '2013';
         con.resetEndYear();
         con.jurisdiction = 'ALL';
         con.go();
            
          ApexPages.StandardController sc2 = new ApexPages.standardController(ES2);
        enrollmentFilters con2 = new enrollmentFilters(sc2);  
            
         con2.reportType = 'Contracts';
         con2.startMonth = '01';
         con2.endMonth = '12';
         con2.startYear = '2013';
         con2.resetEndYear();
         con2.jurisdiction = 'ALL';
         con2.go();
       
    }
}