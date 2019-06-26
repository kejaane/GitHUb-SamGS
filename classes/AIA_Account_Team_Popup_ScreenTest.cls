/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*
*=========================================================================================
* Date: 09/21/2017
* Developer: Goutham Rapolu
* Purpose: Used to create Popup message to verify accountteam members on Account screen 
*          when account is inserted with default Account Team Member US174
*=========================================================================================
* Update History
* Date           Developer      Tag   Description
* 09/21/2017 | Goutham Rapolu |     | Initial Version
* 05/30/2018  | sajitha Y     | T01 | Modified test class as per US1789
* 09/26/2018  | Paritosh      | R1E1| Added test method
*========================================================================================
*/

@isTest 
private class AIA_Account_Team_Popup_ScreenTest{
    static testMethod void testAIA_AccountTeamPopup() {
        //Query user who has Default Account Team available.
        //user usr=[SELECT Id FROM User WHERE Id IN (SELECT ownerId FROM UserAccountTeamMember) LIMIT 1];
        user usr=[SELECT Id,profile.name FROM User WHERE Id IN (SELECT ownerId FROM UserAccountTeamMember) and (profile.name LIKE '%system%' OR profile.name LIKE '%AIA 200%')  and isActive=true LIMIT 1];
        system.assertNotEquals(null,usr.id);    
        
        //Run test class as User with Account Team.
        system.runAs(usr){      
            
            //Start Test
            test.starttest();
            
            //Create Account
            List<ID> accids = new List<ID>();
            Account a = AIA_TestUtil.AIA_createAccount();
            accids.add(a.id);
            system.assertNotEquals(null,a.id);
            //Create Account Team Member
            AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,usr.id,AIA_Constants.SALES_SERVICE_REP); 
            //T01 - start
            AIA_Account_Team_Popup_Screen.getAccountNames(accids);
            //T01 - End
            //Query Account to check if AIA_Display_Account_Team_PopUp__c is updated after account creation.
            Account acc = [select id,AIA_Display_Account_Team_PopUp__c from account where id =:a.id];        
            System.assertNotEquals(acc.id, null);
            //System.assertEquals(acc.AIA_Display_Account_Team_PopUp__c, false);
            //Stop Test
            test.stoptest();      
        }
    }
    
    //R1E1 Start
    static testmethod void testException(){
        
        //Create Account
        List<ID> accids = new List<ID>();
        Account a = AIA_TestUtil.createAccount('test_account');
        accids.add(a.id);
        
        //create 2-50 Standard User - Custom profile user with no edit access to 51+ Account
        Profile prof = [SELECT id FROM profile WHERE name='2-50 Standard User - Custom'];
        User user = new User(alias = 'alias1', email='alias1' + '@test.com', 
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                             localesidkey='en_US', ProfileId = prof.Id, 
                             timezonesidkey='Europe/London', username='alias123@test.com'
                            );
        insert user;
        
        System.runAs(user){
            AIA_Account_Team_Popup_Screen.getAccountNames(accids);
        }
    }
    //R1E1 End
}