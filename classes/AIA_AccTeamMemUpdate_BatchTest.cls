/*****************************************************************************************************
*Date: 16-08-2018
*Developer: 
*Purpose: Test class for AIA_AccTeamMemUpdate_Batch
*=========================================================================================
* Update History
* Date         Developer     Tag          Description
*==================================================================================
*16-08-2018              Initial Development
*02/05/2019		Chaithra	 |T01|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*==================================================================================

*******************************************************************************************************/

@isTest
public class AIA_AccTeamMemUpdate_BatchTest {
    
    @testSetup
    static public void testSetup()
    {

        Account acc = AIA_TestUtil.AIA_createAccount();
        
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2); 
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3); 
        user u4 =AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5);
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u7 = AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7); 
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);
        user u9 = AIA_TestUtil.AIA_createUser('alias9');
        userList.add(u9);
        user u10 = AIA_TestUtil.AIA_createUser('alias10');
        userList.add(u10);
        user u11 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u11);
        
        //delegated manager
        user u12 = AIA_TestUtil.AIA_createUser('dm1');
        userList.add(u12);
        
        insert userList; 
        
        //Area manager data
        AIA_Area_Manager__c am1 = new AIA_Area_Manager__c(Area_Manager__c = u1.Id, Delegated_Manager_1__c = u12.id);
        AIA_Area_Manager__c am2 = new AIA_Area_Manager__c(Area_Manager__c = u2.Id, Delegated_Manager_2__c = u12.id);
        AIA_Area_Manager__c am3 = new AIA_Area_Manager__c(Area_Manager__c = u3.Id);
        final List<AIA_Area_Manager__c> areaManagers = new List<AIA_Area_Manager__c>{am1, am2, am3};
            insert areaManagers;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T01
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Implementation Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,AIA_Constants.QA_AUDITOR));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,AIA_Constants.SALES_SERVICE_REP)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,AIA_Constants.ACCOUNTEXECUTIVE)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,AIA_Constants.PROPOSALSPECIALIST)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u6.id,AIA_Constants.UNDERWRITER));
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,AIA_Constants.NASCO_BENEFIT_CODER)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,AIA_Constants.BENEFACT_CODER)); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,AIA_Constants.ANCILLARY_ANALYST)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,AIA_Constants.MAST_TECH));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,AIA_Constants.SALES_ASSISTANT));   
        insert acctMbrList;   
        
    }
    
    //method to test replace inactive ATM with delegate manager 1 or delegate manager 2 and Implementation manager
    @isTest
    public static void testInactivateATMDelegation(){
        
        //deactivate users
        final List<User> deactivateUsers = [select id from User
                                            where alias in ('alias1','alias2', 'alias3')];
        deactivateUsers[0].isActive = false;
        deactivateUsers[1].isActive = false;
        deactivateUsers[2].isActive = false;
        update deactivateUsers;
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
                             EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = pro.Id,
                             TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        Test.startTest();
        system.runAs(user){
            //call Batch
            AIA_AccTeamMemUpdate_Batch atmBatch =  new AIA_AccTeamMemUpdate_Batch();
            Database.executeBatch(atmBatch);
        }
        Test.stopTest();
        
    }
    
    /*public static testmethod void testSchedulableBatch()
{
//deactivate users
final List<User> deactivateUsers = [select id from User
where alias in ('alias1','alias2', 'alias3')];
deactivateUsers[0].isActive = false;
deactivateUsers[1].isActive = false;
deactivateUsers[2].isActive = false;
update deactivateUsers;

Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];

User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
LocaleSidKey='en_US', ProfileId = pro.Id,
TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
insert user;
Test.startTest();
system.runAs(user){

Database.BatchableContext BC;
AIA_AccTeamMemUpdate_Batch abs= new AIA_AccTeamMemUpdate_Batch();
String schedule = '0 0 23 * * ?';
String jobId = System.schedule('Test Batch',schedule,abs);
abs.start(BC);
abs.execute(BC,deactivateUsers);
abs.finish(BC);
}
Test.stopTest();
}*/
    
}