/*****************************************************************************************************

*=========================================================================================
* 								Update History
* Date         Developer       Tag          Description
*==================================================================================

*03/15/2019    Rajesh      T01       Commented out lines that are not reffered
*==================================================================================

*******************************************************************************************************/
@isTest 
public class enrollmentFilters2_199_Test {
     public static Enrollment_Summary__c Test1() {
         PageReference pageRef = Page.EnrollmentsSummarized2_199;
         Test.setCurrentPageReference(pageRef);
         TestUtil.Create_Enrollment_Import();
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');
            //Test.StartTest(); 
            System.runAs(u) {
         TestUtil.Create_Enrolment_Import_2_50_Data();
         Summary_Enrollment_Jurisdiction__c cc=new Summary_Enrollment_Jurisdiction__c();
         cc.name='VA';
         insert cc;
         }
         Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
         Schema.SObjectType s = sObjectMap.get('Enrollment_Summary__c') ; 
         Schema.DescribeSObjectResult resSchema = s.getDescribe() ;
         Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName();
         /** T01 Since ES2 and sums are not referred any where commenting out referreded lines.
         List<Enrollment_Summary__c> sums = new List<Enrollment_Summary__c>();
         **/
         Enrollment_Summary__c ES1 = new Enrollment_Summary__c(
               Date__c = '201401',
               RecordTypeId = recordTypeInfo.get('2-50').getRecordTypeId(),
               Jurisdiction__c = 'VA');
               insert ES1;
         /** T01 Since ES2 and sums are not referred any where commenting out referreded lines.
         sums.add(ES1);
               
         Enrollment_Summary__c ES2 = new Enrollment_Summary__c(
               Date__c = '201702',
               RecordTypeId = recordTypeInfo.get('51+').getRecordTypeId(),
               Jurisdiction__c = 'VA');
         
         sums.add(ES2);
         
         insert sums;
         system.debug('--sums----'+sums);
         Account TestAcc = AIA_Testutil.createAccount('Test Account'); **/
         //Removing per US210
         /*AIA_Workplan_Type__c WpType =AIA_Testutil.AIA_CreateWorkPlan();
         insert WpType;*/
        /** T01 Since opp is not referred any where commenting out these lines.
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        opp.StageName = 'RFP';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = TestAcc.id;
        opp.Market_Segment_New__c = '51-199';
        // opp.Business_type__c = 'Off-Cycle';
        opp.Division__c = '51-199 New Business';
        opp.Legal_Account_Name_Verified__c =true;
        opp.Underwriting_Entity__c = 'NCAS';
        Date tday = system.today();
        opp.Effective_Date__c =Date.newInstance(tday.Year(),tday.month(),1);  //Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);            
        opp.Off_Cycle_Term_Date__c = opp.Effective_Date__c.addDays(-1);     
        Id opptwohundredplusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId;
        opp.RecordTypeId = opptwohundredplusId;            
            
        insert opp;**/
         /**T01 Since eobj and eobj2 are not referred any where commenting out these lines.
         enrollment__c  eobj = new enrollment__c();
         eobj.RecordTypeId = Schema.SObjectType.Enrollment__c.RecordTypeInfosByName.get('2-50').RecordTypeId;
         eobj.Opportunity__c = opp.id;
         eobj.Rpt_dt__c='201412';
         insert eobj;
         enrollment__c  eobj2 = new enrollment__c();
         eobj2.RecordTypeId = Schema.SObjectType.Enrollment__c.RecordTypeInfosByName.get('51+').RecordTypeId;
         eobj2.Opportunity__c = opp.id;
         eobj2.Rpt_dt__c='201412';
         insert eobj2;
         **/
         return ES1;
    }
    
    static testMethod void Test2() {
        
        Enrollment_Summary__c ES1 = enrollmentFilters2_199_Test.Test1();
        Test.startTest();            
        ApexPages.StandardController sc = new ApexPages.standardController(ES1);
        enrollmentFilters2_199 con = new enrollmentFilters2_199(sc);  
        con.recType = '2-50';   
        con.month = '12';
        con.year = '2014';
        con.go();
        List<enrollmentFilters2_199.ResultsWrapper> wlist = new List<enrollmentFilters2_199.ResultsWrapper>();
        enrollmentFilters2_199.ResultsWrapper wobj = new enrollmentFilters2_199.ResultsWrapper();
        wobj.startingBalance =10;
        wobj.newCount=10;
        wobj.termed=10;
        wobj.monthEndBalance =10;
        wlist.add(wobj);
        con.calcTotals(wlist,'startingBalance');
        con.calcTotals(wlist,'newCount');
        con.calcTotals(wlist,'termed');
        con.calcTotals(wlist,'monthEndBalance');
        Test.stopTest(); 
    }
    static testMethod void Test3() {
        Enrollment_Summary__c ES1 = enrollmentFilters2_199_Test.Test1();
        Test.startTest();
        ApexPages.StandardController sc2 = new ApexPages.standardController(ES1);
        enrollmentFilters2_199 con2 = new enrollmentFilters2_199(sc2);  
        con2.recType = '51+';   
        con2.month = '12';
        con2.year = '2014';
        con2.go();
        Test.stopTest();
    }
}