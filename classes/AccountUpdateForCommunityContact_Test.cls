@isTest(seeAllData=false)
public class AccountUpdateForCommunityContact_Test{
    public static testmethod void test1(){
        Id RecId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Community_User_Contact'].Id;
        Test.startTest();
        //create Account
        Account acc = new Account();
        acc.Name = 'Community_User_Account';
        insert acc;
        Contact con = new Contact();
        con.LastName = 'Test';
        con.Phone = '1234567891';
        con.Email = 'test@gmail.com';
        con.RecordTypeId = RecId;
        insert con;
        update con;
        Test.stopTest();
    }
}