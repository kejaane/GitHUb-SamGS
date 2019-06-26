/*************************************************************************************************************************************************
*  Class            : AIA_CSNumController_Test
*  Author           : Rajesh Pennam
*  Version History  : 1.0
*  Creation         : 07/27/2017
*  Description      : This class is ffor the code coverage for AIA_CSNumController
*
*  Modification Log:
* ----------------------------------------------------------------------------------------------------------------------------------------------
*  Author          Date-Modified      Tag      Description of Change
* ----------------------------------------------------------------------------------------------------------------------------------------------
* Rajesh Pennam     07/27/2017               Initial Development
* phani          06/08/2018          T01       Added code for role updates
02/08/2019		Chaithra	 		|T02|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*************************************************************************************************************************************************/
@istest
public class AIA_CSNumController_Test {
    @testSetup Static void testdata() {

        Profile pro = [SELECT Id FROM Profile WHERE Name = 'AIA 200+ Standard User - Custom'];

        User user = new User(Alias = 'TAlias1', Email = 'TestUserBRF@testorg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'TestingUSer', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = pro.Id,
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'TestingUserBRF@testorg.com1');
        insert user;
        User u222 = AIA_TestUtil.createTestUser();

        System.runAs(u222) {

            //Create Test Accounts
            Account acc = new Account();
            acc.Name = 'TestAccount1';
            acc.Type = 'Customer';
            acc.RecordTypeId = QueryBase.getRecordtypeId('Account', 'X51');
            acc.Renewal_Anniversary_Month__c = 'Jan';
            acc.Jurisdiction__c = 'MD';
            acc.Account_Legal_Name__c = 'test Account';
            insert acc;
            //Commenting as part of US210
            //Creating WorkPlan Type Test Data 
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c = 'Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c = true;
            insert wpt;*/

            //Create Users to insert in Account Team Roles
            List < user > userList = new list < user > ();
            user u1 = AIA_TestUtil.AIA_createUser('alias11');
            userList.add(u1);
            user u2 = AIA_TestUtil.AIA_createUser('alias21');
            userList.add(u2);
            user u7 = AIA_TestUtil.AIA_createUser('alias71');
            userList.add(u7);
            user u8 = AIA_TestUtil.AIA_createUser('alias81');
            userList.add(u8);
            user u3 = AIA_TestUtil.AIA_createUser('alias31');
            userList.add(u3);
            user u4 = AIA_TestUtil.AIA_createUser('alias41');
            userList.add(u4);
            user u5 = AIA_TestUtil.AIA_createUser('alias51');
            userList.add(u5);
            user u6 = AIA_TestUtil.AIA_createUser('alias61');
            userList.add(u6);
            user u9 = AIA_TestUtil.AIA_createUser('alias91');
            userList.add(u9);
            user u = AIA_TestUtil.AIA_createUser('alias0');
            userList.add(u);
            user u10 = AIA_TestUtil.AIA_createUser('alias10');
            userList.add(u10);
            insert userList;

            //Create Account Team
            //List < AccountTeamMember > acctMbrList = new List < AccountTeamMember > (); T02
            List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id, u7.id, 'NASCO Benefit Coder'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id, u8.id, 'BeneFact Coder'));
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id, u3.id, 'Ancillary Analyst'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id, u5.id, 'MAST Tech'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id, u1.id, 'Underwriter')); //T01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id, u2.id, 'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id, u4.id, 'Contract Tech'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id, u9.id, 'Account Dedicated Representative')); //T01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id, u.id, 'Account Executive'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id, u10.id, 'Proposal Specialist'));
            insert acctMbrList;

        }
    }

    private static testMethod void Test1() {

        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'AIA 200+ Standard User - Custom'].Id,
            LastName = 'last',
            Email = 'puser000@Test.com',
            Username = 'puser000@Test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');

        insert u;

        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'AIA_200'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);

        system.runAS(u) {
            Test.startTest();
            account acc = [Select Id From account limit 1];

            Customer_Service__c CS = new Customer_Service__c();
            CS.Account__c = acc.id;
            CS.Area__c = 'Member Service';
            CS.Phone_Number__c = '1234567899';
            CS.Service_Hours__c = '24/7 - 365 Days';
            CS.Service_Number__c = 'Performance';
            insert CS;
            system.assertNotEquals(null, CS.id);

            PageReference pageRef = Page.AIA_CS_Number_Page;
            pageRef.getParameters().put('id', String.valueOf(acc.Id));
            pageRef.getParameters().put('recid', String.valueOf(CS.Id));

            Test.SetCurrentPage(PageRef);
            List < Customer_Service__c > lstCS = new List < Customer_Service__c > ();
            lstCS.add(cs);
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(lstCS);
            sc.setSelected(lstCS);

            AIA_CSNumController customerRedirect = new AIA_CSNumController();
            customerRedirect.rowToRemove=1; 
            customerRedirect.viewEditCSNum();
            customerRedirect.addRowRedirect();
            customerRedirect.addrowcancel();
            customerRedirect.addrow();
            customerRedirect.removerow();
            //customerRedirect.multipleRows();
            customerRedirect.removeRowFromList();
            customerRedirect.canceDetails();
            customerRedirect.editTable();
            customerRedirect.editInactTable();
            customerRedirect.refreshCNSNew();
            customerRedirect.saveRec();
            customerRedirect.cancelRec();
            customerRedirect.saveRec();
            customerRedirect.refresh();
            customerRedirect.InActrefresh();
            customerRedirect.save1();
            CS.Area__c = 'Other';
            CS.Other_Area__c = '';
            customerRedirect.csnLStInActive = (List < Customer_Service__c > )(new List < Customer_Service__c > ().add(cs));

            customerRedirect.saveinAct();
            system.debug('tesing Del**********');
            customerRedirect.deleteRec();
            Customer_Service__c tConfirm = [Select Id, IsDeleted from Customer_Service__c WHERE Id = : cs.Id ALL ROWS];
            System.assertEquals(tConfirm.IsDeleted, true);
            test.stopTest();

        }

    }

    private static testmethod void Test2() {

        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = '51+ Standard User - Custom'].Id,
            LastName = 'last',
            Email = 'puser000@Test.com',
            Username = 'puser000@Test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');

        insert u;
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'AIA_200'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );

        system.runAS(u) {
            //try{

            Test.StartTest();
            account acc = [Select Id From account limit 1];
            Customer_Service__c CS1 = new Customer_Service__c();
            CS1.Account__c = acc.id;
            CS1.Area__c = 'Other';
            CS1.Other_Area__c = '123';
            CS1.Phone_Number__c = '1234567899';
            CS1.Service_Hours__c = '24/7 - 365 Days';
            CS1.Service_Number__c = 'Performance';
            insert CS1;
            system.assertNotEquals(null, CS1.id);

            //}
            //catch(Exception e){
            //    system.debug('for catch coverage');

            //}

            PageReference pageRef = Page.AIA_CustomerServiceNumber;
            pageRef.getParameters().put('id', String.valueOf(acc.Id));
            Test.SetCurrentPage(PageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(acc);
            AIA_CustomerServiceNumController customerRedirect = new AIA_CustomerServiceNumController(sc);
            customerRedirect.addRowRedirect();
            customerRedirect.addrowcancel();
            customerRedirect.addrow();
            customerRedirect.removerow();
            //customerRedirect.multipleRows();
            customerRedirect.removeRowFromList();
            customerRedirect.saveRec();
            customerRedirect.cancelRec();
            customerRedirect.saveRec();
            customerRedirect.refresh();
            customerRedirect.InActrefresh();
            customerRedirect.save1();
            customerRedirect.saveinAct();
            //customerRedirect.deleteRec();

            test.stopTest();

        }

    }

}