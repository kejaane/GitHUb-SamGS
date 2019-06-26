/*===================================================================================
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
*===================================================================================
* Date:         11/21/2017 
* Developer:    Goutham Rapolu
* Purpose:      Test class for AIA_EditAccountTeamController,AIA_CreateDefaultAccountTeamMember
* 
*==================================================================================
* Update History
* Date          Developer               Description
*==================================================================================
* 11/21/2017    Goutham Rapolu         Initial Development
*06/08/2018     raj kiran      T01      Added code for role updates
*16/08/2018     Arshia         T02      Changed profile for DefaultAccountTeam
*02/05/2019		Chaithra	   T03 		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*==================================================================================
*/


@istest
public class AIA_AccountTeamMember_Test {
  
public static testmethod void Test_AccountTeam3(){
   
        ID NonManagerRTId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Non-Manager').getRecordTypeId();
        ID ManagerRTId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Manager').getRecordTypeId();
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNOTEquals(acc,Null);  
        
        Profile profile = [select id from profile where name='System Administrator'];
        List<user> userList = new list<user>();
        User u1 = new User(alias = 'aliasU', email='alias@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = profile.Id, 
            timezonesidkey='Europe/London', username='aliastest@test.com'
            );
        userList.add(u1); 
        User u2 = new User(alias = 'aliasU2', email='alias@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = profile.Id, 
            timezonesidkey='Europe/London', username='aliastest2@test.com'
            );
        userList.add(u2); 
        User u3 = new User(alias = 'aliasU3', email='alias@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = profile.Id, 
            timezonesidkey='Europe/London', username='aliastest3@test.com'
            );
        userList.add(u3); 
           
        insert userList;       
        system.assertNOTEquals(userList.size(),Null); 
		//T03 Starts
        /*List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        AccountTeamMember a1 = new AccountTeamMember();
        a1.AccountId = acc.id;
        a1.UserId = userList[0].id;
        a1.TeamMemberRole = 'Account Manager';
        acctMbrList.add(a1); 
        
        AccountTeamMember a2 = new AccountTeamMember();
        a2.AccountId = acc.id;
        a2.UserId = userList[1].id;
        a2.TeamMemberRole = 'Implementation Manager';
        acctMbrList.add(a2);  
        
        AccountTeamMember a3 = new AccountTeamMember();
        a3.AccountId = acc.id;
        a3.UserId = UserInfo.getUserId();
        a3.TeamMemberRole = 'Implementation Manager';
        acctMbrList.add(a3); 

        insert acctMbrList;*/
    	List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
        Account_Team__c a1 = new Account_Team__c();
        a1.AccountId__c = acc.id;
        a1.UserId__c = userList[0].id;
        a1.TeamMemberRole__c = 'Account Manager';
        acctMbrList.add(a1); 
        
        Account_Team__c a2 = new Account_Team__c();
        a2.AccountId__c = acc.id;
        a2.UserId__c = userList[1].id;
        a2.TeamMemberRole__c = 'Implementation Manager';
        acctMbrList.add(a2);  
        
        Account_Team__c a3 = new Account_Team__c();
        a3.AccountId__c = acc.id;
        a3.UserId__c = UserInfo.getUserId();
        a3.TeamMemberRole__c = 'Implementation Manager';
        acctMbrList.add(a3); 

        insert acctMbrList;
    	//T03 Ends
        system.assertNOTEquals(acctMbrList.size(),Null); 
        
        List<AIA_Area_Manager__c> UserArealist = new List<AIA_Area_Manager__c>();
        AIA_Area_Manager__c AM1 = new AIA_Area_Manager__c();
        AM1.Area_Manager__c = UserInfo.getUserId();
        AM1.Delegated_User__c = userList[0].id;
        AM1.Delegated_Manager_1__c = userList[1].id;
        AM1.Delegated_Manager_2__c = userlist[2].id;
        AM1.Areas__c = 'Underwriter;Ancillary Analyst;Account Manager';
        AM1.Area_Belong_to__c = 'Underwriter;Ancillary Analyst;Account Manager';
        AM1.RecordTypeid = ManagerRTId; 
        UserArealist.add(AM1);
        
        insert UserArealist;
    
      
        
        
      /*  PageReference pref = Page.AIA_EditAccountTeam;
        Test.starttest();
        Test.setCurrentPage(pref); */
    
     Test.starttest();
     
        ApexPages.currentPage().getParameters().put('id',acc.id);
        ApexPages.StandardController con = new ApexPages.StandardController(acc);
        
        AIA_AccountTeamMemberController EAT = new AIA_AccountTeamMemberController(con);
        EAT.AIA_AccountTeamMember();
        
        ApexPages.currentPage().getParameters().put('atmid',acctMbrList[0].id);
        EAT.deleteAccTM();
        Test.stoptest(); 
    }
  
  
    public static testmethod void Test_AccountTeam1(){
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNOTEquals(acc,Null);  
        
        Profile profile = [select id from profile where name='System Administrator'];
        List<user> userList = new list<user>();
        User u1 = new User(alias = 'aliasU', email='alias@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = profile.Id, 
            timezonesidkey='Europe/London', username='aliastest@test.com'
            );
        userList.add(u1);    
        insert userList;       
        system.assertNOTEquals(userList.size(),Null); 
        
        //T03 Starts 
        /*List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        AccountTeamMember a1 = new AccountTeamMember();
        a1.AccountId = acc.id;
        a1.UserId = userList[0].id;
        a1.TeamMemberRole = 'Underwriter'; //T01
        acctMbrList.add(a1); 
        insert acctMbrList;*/
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
        Account_Team__c a1 = new Account_Team__c();
        a1.AccountId__c = acc.id;
        a1.UserId__c = userList[0].id;
        a1.TeamMemberRole__c = 'Underwriter';
        acctMbrList.add(a1); 
        //insert acctMbrList;
        //T03 Ends
        system.assertNOTEquals(acctMbrList.size(),Null); 
       
        ApexPages.StandardController con = new ApexPages.StandardController(acc); 
        Test.starttest();
        AIA_AccountTeamMemberController EAT = new AIA_AccountTeamMemberController(con);
        EAT.AIA_AccountTeamMember();
    
    EAT.getIsClassic(); // added by raj
        Test.stoptest(); 
    }
     public static testmethod void Test_DefaultAccountTeam4(){
       // List<UserAccountTeamMember> UATM = new List<UserAccountTeamMember>();
        //UATM = [select id,TeamMemberRole,OwnerId,UserId from UserAccountTeamMember limit 1];
        //UATM = [select id,TeamMemberRole,OwnerId,UserId,user.profile.name,user.isActive from UserAccountTeamMember where (user.profile.name LIKE '%system%' or  user.profile.name LIKE '%AIA 200%') LIMIT 1];
        string str;
          Profile profile = [select id from profile where name='System Administrator'];
        List<user> userList = new list<user>();
        User u1 = new User(alias = 'aliasU', email='alias@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = profile.Id, 
            timezonesidkey='Europe/London', username='aliastest@test.com'
            );
        userList.add(u1); 
        User u2 = new User(alias = 'aliasU2', email='alias@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = profile.Id, 
            timezonesidkey='Europe/London', username='aliastest2@test.com'
            );
        userList.add(u2); 
        User u3 = new User(alias = 'aliasU3', email='alias@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = profile.Id, 
            timezonesidkey='Europe/London', username='aliastest3@test.com'
            );
        userList.add(u3); 
           
        insert userList;       
       // List<user> UATM=[SELECT Id FROM User WHERE Id IN (SELECT ownerid FROM Default_Account_Team__c) AND (profile.name LIKE '%Admin%' ) and IsActive = true Limit 1];   //T02
       List<user> UATM=[SELECT Id FROM User Limit 1];   //T02
          Default_Account_Team__c DFT = new Default_Account_Team__c();
     	 DFT.OwnerId=userinfo.getUserId();
   		 DFT.UserId__c = userList[1].id;
   		 DFT.Team_Role__c = 'Account Executive';
   		 DFT.Opportunity_Access__c = 'Read/Write';
         DFT.Case_Access__c ='Read/Write';
         dft.Contact_Access__c = 'Read/Write';
         dft.Account_Access__c = 'Read/Write';
          insert DFT;
         system.assertNOTEquals(UATM,Null);
         if(!UATM.isEmpty() && !AIA_utils.isNullOrEmpty(UATM[0].id)){
             system.debug('entered 1');
            //ID DATMuser = UATM[0].Ownerid;
            //user u = [select id,Alias,Email,EmailEncodingKey,LastName,LocaleSidKey,ProfileId,UserName from User where ID=:DATMuser];
                Account acc = AIA_TestUtil.CreateAccount('TestAccount');
           //UserAccountTeamMember uat1= [SELECT UserId,ownerid FROM UserAccountTeamMember where user.isactive = true limit 1];
           Default_Account_Team__c uat1 = [SELECT id,OwnerId,UserId__c,Team_Role__c from default_account_team__c limit 1 ];
           user u10=[select id from user  limit 1 ];
                system.assertNOTEquals(acc,Null); 
             
                
            /*   List<UserAccountTeamMember> utml=  [SELECT AccountAccessLevel,CaseAccessLevel,ContactAccessLevel,OpportunityAccessLevel,OwnerId,SystemModstamp,TeamMemberRole,UserId 
                              FROM UserAccountTeamMember 
                              WHERE OwnerId = :UATM[0].id AND 
                              User.isActive = TRUE];
                 system.debug('utml'+utml);*/
            /*    --------    */
               List<Default_Account_Team__c> dat= [Select Account_Access__c,Case_Access__c,Contact_Access__c,Opportunity_Access__c,OwnerId,SystemModstamp,Team_Role__c,UserId__c
                              FROM Default_Account_Team__c];
                             
            /*     -----------  */
                /* List<UserAccountTeamMember> utml1=  [SELECT AccountAccessLevel,CaseAccessLevel,ContactAccessLevel,OpportunityAccessLevel,OwnerId,SystemModstamp,TeamMemberRole,UserId 
                              FROM UserAccountTeamMember 
                              WHERE User.isActive = TRUE];*/
                 //system.debug('utml 1'+utml1);
                Test.starttest();
                ApexPages.currentPage().getParameters().put('id',acc.id);
                ApexPages.StandardController con = new ApexPages.StandardController(acc);
                AIA_AccountTeamMemberController EAT = new AIA_AccountTeamMemberController(con);
                 system.debug('entered 2');
                 EAT.DefaultAccountTeam();
                  system.debug('entered 3');
                EAT.showPopup();
                EAT.cancelTeamPop();
                 Test.stopTest();
            
        }    
    } 
}