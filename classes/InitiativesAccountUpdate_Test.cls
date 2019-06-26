/*=========================================================================================
 * Date         : 07/14/2016
 * Developer    : Rajesh Pennam
 * Purpose      : This class is used to test the functionlaity of the InitiativesAccountUpdate
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 07/14/16  |  Rajesh Pennam   | Initial Version                                         
 *           |        | 
 *=========================================================================================
 */
@isTest
public class InitiativesAccountUpdate_Test{
    public static testmethod void test() {

        Test.startTest();
        //create Accounts
        Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.phone='3162535216';
        a.RecordTypeId = rt_acc_51;
        insert a;
        
        //create opportunities
        Opportunity o = new Opportunity();
        o.Name = 'OppTest' + Date.Today();  
        o.AccountId = a.Id;
        o.StageName = 'Proposal';
        o.Effective_Date__c = system.today().toStartofMonth();
        o.CloseDate = o.Effective_Date__c - 1;
        o.Contract_End_Date__c = o.Effective_Date__c.addMonths(1)-1;
        o.System__c = 'Facets';
        o.Facets_Grp_Num__c = 'X23A';        
        o.FullServiceProducer__c = 'Direct';
        insert o;  
        
        
        //create intitaitives
        Initiative__c i = new Initiative__c();
        i.Name = 'Test';
        i.Opportunity_Name__c = o.Id;
        insert i;
        update i;
 
        //system.assertequals(2,lst.size());
        Test.stopTest();
    }
}