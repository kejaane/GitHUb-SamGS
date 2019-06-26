/*=========================================================================================
 * Date         : 10/19/2016
 * Developer    : Rajesh Pennam
 * Purpose      : This class is used to test the functionlaity of the ProtemoiAccountUpdate
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
public class ProtemoiAccountUpdate_Test{
    public static testmethod void test() {

        Test.startTest();
        //create Accounts
        Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_51;
        insert a;
        
        //create Contact
        Contact con = new Contact();
        con.LastName = 'Test';
        con.Phone = '1234567891';
        con.Email = 'test@gmail.com';
        con.AccountId       = a.id;
        insert con;  
        
        
        //create Protemoi
        Protemoi__c p = new Protemoi__c();
        p.Contact_Name__c = con.Id;
        insert p;
        update p;
 
        //system.assertequals(2,lst.size());
        Test.stopTest();
    }
}