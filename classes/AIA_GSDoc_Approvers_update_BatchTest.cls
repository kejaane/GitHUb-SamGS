/*****************************************************************************************************
*Date: 16-08-2018
*Developer: 
*Purpose: Test class for AIA_AccTeamMemUpdate_Batch
*=========================================================================================
* Update History
* Date         Developer               Description
*==================================================================================
*16-08-2018              Initial Development
*==================================================================================

*******************************************************************************************************/

@isTest
public class AIA_GSDoc_Approvers_update_BatchTest {
    
    @testSetup
    static public void testSetup()
    {
        Map<id,Id> usrManagerMap = new Map<id,Id>();
        Map<id,string> mangerIdNameMap = new Map<id,string>();
        Account acc = AIA_TestUtil.CreateAccount('Test Account');
        Map<Id,List<Id>> accUserMap = new Map<Id,List<Id>>();
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      // u1.IsActive = false;
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
        //u12.IsActive = true;
        userList.add(u12);
        
        insert userList; 
       
        list<user> usr = [select id,name from user where isactive=false limit 3];
        
       
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02 replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Implementation Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,AIA_Constants.QA_AUDITOR));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,AIA_Constants.SALES_SERVICE_REP)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,AIA_Constants.ACCOUNTEXECUTIVE)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,AIA_Constants.PROPOSALSPECIALIST)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u6.id,AIA_Constants.UNDERWRITER));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'Account Dedicated Representative')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'Billing Tech')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Settlements Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,AIA_Constants.MAST_TECH));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,AIA_Constants.IMP_MANAGER));   
        insert acctMbrList; 
        
        //Area manager data
        AIA_Area_Manager__c am1 = new AIA_Area_Manager__c(Area_Manager__c = usr[0].Id, Delegated_Manager_1__c = u12.id);
        AIA_Area_Manager__c am2 = new AIA_Area_Manager__c(Area_Manager__c = usr[1].Id, Delegated_Manager_2__c = u12.id);
        AIA_Area_Manager__c am3 = new AIA_Area_Manager__c(Area_Manager__c = usr[2].Id);
       
        AIA_Area_Manager__c am4 = new AIA_Area_Manager__c(Area_Manager__c = u3.Id);
        final List<AIA_Area_Manager__c> areaManagers = new List<AIA_Area_Manager__c>{am1, am2, am3};
            insert areaManagers;
        
        list<AIA_Document__c>  AIADoclst = new List<AIA_Document__c>();
        AIA_Document__c  AIADoc = new AIA_Document__c();
        AIADoc.Account__c = acc.id;
        AIADoc.Approver_Billing_Tech__c = userList[0].Id;
        AIADoc.Approver_Settlements_Tech__c = userList[1].Id;
        AIADoc.Approver_QA_Auditor__c = userList[2].Id;
        AIADoc.LGIT_Tech__c = userList[7].Id;
        AIADoc.Approver_Account_Dedicated_Rep__c = userList[8].Id;
        AIADoc.Approver_Implementation_Team__c=userList[4].Id;
        AIADoc.Approver_Sales_Service_Rep__c = userList[5].Id;
        //AIADoc.Approver_Account_Dedicated_Rep__c=userList[6].Id;       
        AIADoclst.add(AIADoc);
        insert AIADoclst;
   
        
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       // Insert account as current user
        System.runAs (thisUser) {
            
         User uId =[select Id from User where IsActive=true and id=:userList[0].id ];
           User u =[select Id,Username ,IsActive from User where Id =: uId.Id ];
    		u.IsActive = false;
        update u;
            List<AccountTeamMember>  memList = [SELECT Id,AccountId,userId 
                                            FROM AccountTeamMember 
                                            WHERE userId =:u.Id];
            system.debug(memList+'@@@@@@@@@@@');
        }
        
    }   
     @isTest
    public static void testBDApproversBatch(){
        list<AIA_Document__c>  AIADoclst = [SELECT Id,Account__c,Approver_Billing_Tech__c,Approver_Settlements_Tech__c,Approver_QA_Auditor__c,LGIT_Tech__c,Approver_Implementation_Team__c,Approver_Sales_Service_Rep__c,Approver_Account_Dedicated_Rep__c FROM AIA_Document__c ];
        test.startTest();
       AIA_GSDoc_Approvers_update_Batch updateBD = new AIA_GSDoc_Approvers_update_Batch();
        Database.executeBatch(updateBD, 200);
        database.BatchableContext BC;
       updateBD.start(BC);
      updateBD.execute(BC,AIADoclst);
      updateBD.finish(BC);
        test.stopTest();
        
    }
         @isTest
    public static void testgetIMDetailsVer1(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        Test.startTest();
		AIA_GSDoc_Approvers_update_Batch up = new AIA_GSDoc_Approvers_update_Batch();
		
        String schTime = '0 0 12 * * ?';
		
		system.schedule('AIA_GSDoc_Approvers_update_BatchTest', schTime, up);
		Test.stopTest();
       
    }
    
}