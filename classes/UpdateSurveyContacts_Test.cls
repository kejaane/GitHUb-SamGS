/*=========================================================================================
 * Date         : 05/07/2016
 * Developer    : Rajesh Pennam
 *              This class implements all unit tests for the batch classes in
 *              the Contact Updates. These tests are necessary in
 *              order to achieve the required code coverage levels by the
 *              Salesforce platform in order to allow production deployment
 *              of the code. 
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 05/07/2016  |  Rajesh Pennam    | Initial Version                                         
 *           |        | 
 *=========================================================================================
 */
@isTest
public class UpdateSurveyContacts_Test{
    static testmethod void test() {
        /*string query = '';
        query += 'select Id,Contact__c from Survey_Contacts__c Where Contact__c != null';
        query += ' AND Opportunity__r.RecordType.Name = \'51+\'';
        query += ' AND (Opportunity__r.StageName = \'Proposal\' OR Opportunity__r.StageName = \'Sold\')';
        query += ' AND Opportunity__r.SBU__c = \'Large\'';
        query += ' AND (Opportunity__r.Market_Segment_New__c = \'200-999\' OR Opportunity__r.Market_Segment_New__c = \'1000+\')';
        query += ' AND Opportunity__r.Effective_Date__c <= Today';
        query += ' AND Opportunity__r.Contract_End_Date__c > Today';
        query += ' AND (Surveys__c = \'Executive;Day to Day\' OR Surveys__c = \'Executive\' OR Surveys__c = \'Day to Day\')';*/                         
        
        Account a = new Account(Name = 'sTest');
        insert a;
        
        Opportunity o = new Opportunity();
        o.Name = 'sOppTest';
        o.AccountId = a.id;
        o.RecordTypeId = '01260000000cWGC';
        o.SBU__c = 'Large';
        o.Market_Segment_New__c = '200-999';
        o.Effective_Date__c = system.today().toStartofMonth();
        o.GeneralProducer__c = 'Direct';
        o.Contract_End_Date__c = system.today()+24;
        o.StageName = 'Proposal';
        o.Contract_End_Date__c = o.Effective_Date__c.addMonths(1)-1;
        o.CloseDate = o.Effective_Date__c-1;
        insert o;
        
        Contact c = new Contact(LastName = 'sconTest',Phone = '1234',Email = 'test@gmail.com',accountid=a.id);
        insert c;
        
        Survey_Contacts__c sc = new Survey_Contacts__c();
        sc.Contact__c = c.id;
        sc.Opportunity__c = o.id;
        sc.Surveys__c = 'Executive';
        insert sc;
        
        
        DynamicCodeDataStore__c ccd=new DynamicCodeDataStore__c();
        ccd.name='sfdcTeamEmail';
        ccd.Email__c='sfdcteam@carefirst.com';
        ccd.Text_255__c='test sample';
        insert ccd;
        system.debug('---ccd--'+ccd);
   
        Test.startTest();
              
        UpdateSurveyContactsToValue usc1 = new UpdateSurveyContactsToValue();
        Database.executeBatch(usc1);
        
        Test.stopTest();
        list<string> ss=new list<string>();
        ss.add('test@gmail.com');
        Utils  uu=new Utils ();
        Utils.EmailUtil ee=new Utils.EmailUtil(ss);
        ee.toAddresses(ss);
        ee.bccAddresses(ss);
        //added by rajesh
         
            
    }
    
    static testmethod void test2() {
        /*string query = '';
        query += 'select Id,Contact__c from Survey_Contacts__c Where Contact__c != null';
        query += ' AND Opportunity__r.RecordType.Name = \'51+\'';
        query += ' AND (Opportunity__r.StageName = \'Proposal\' OR Opportunity__r.StageName = \'Sold\')';
        query += ' AND Opportunity__r.SBU__c = \'Large\'';
        query += ' AND (Opportunity__r.Market_Segment_New__c = \'200-999\' OR Opportunity__r.Market_Segment_New__c = \'1000+\')';
        query += ' AND Opportunity__r.Effective_Date__c <= Today';
        query += ' AND Opportunity__r.Contract_End_Date__c > Today';
        query += ' AND (Surveys__c = \'Executive;Day to Day\' OR Surveys__c = \'Executive\' OR Surveys__c = \'Day to Day\')';*/                         
        
        Account a = new Account(Name = 'sTest');
        insert a;
        
        Opportunity o = new Opportunity();
        o.Name = 'sOppTest';
        o.AccountId = a.id;
        o.RecordTypeId = '01260000000cWGC';
        o.SBU__c = 'Large';
        o.Market_Segment_New__c = '200-999';
        o.Effective_Date__c = system.today().toStartofMonth();
        o.GeneralProducer__c = 'Direct';
        o.Contract_End_Date__c = system.today()+24;
        o.StageName = 'Proposal';
        o.Contract_End_Date__c = o.Effective_Date__c.addMonths(1)-1;
        o.CloseDate = o.Effective_Date__c-1;
        insert o;
        
        Contact c = new Contact(LastName = 'sconTest',Phone = '1234',Email = 'test@gmail.com' ,SBU_Market_Segment__c ='200+',accountid=a.id );
        insert c;
        
        Survey_Contacts__c sc = new Survey_Contacts__c();
        sc.Contact__c = c.id;
        sc.Opportunity__c = o.id;
        sc.Surveys__c = 'Executive';
        insert sc;
        DynamicCodeDataStore__c ccd=new DynamicCodeDataStore__c();
        ccd.name='sfdcTeamEmail';
        ccd.Email__c='sfdcteam@carefirst.com';
        ccd.Text_255__c='test sample';
        insert ccd;
        system.debug('---ccd--'+ccd);
        Test.startTest();
        UpdateSurveyContactsToNull usc = new UpdateSurveyContactsToNull();
        Database.executeBatch(usc);
        
        Test.stopTest();
    }
}