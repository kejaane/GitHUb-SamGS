@isTest
private class AIA_ImplementationTriggerHelper_Test {
    @testsetup static void CreateTestData()
    {
        Test.startTest();
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        User user = new User(Alias = 'TAlias17', Email='TestUserBRF@testorg.com',
                             EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = pro.Id,
                             TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.comax12');
        
        
        insert user;
        
        Account a = AIA_TestUtil.CreateAccount('Test Account');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        
        /*AccountTeamMember atmRole2 = new AccountTeamMember ();
atmRole2.TeamMemberRole = 'Contract Tech';
atmRole2.AccountId =a.id;
atmRole2.UserId = user.id;
insert atmRole2;*/
        /*Account_Team__c atmRole1 =new Account_Team__c();
atmRole1.UserId__c=user.Id;
atmRole1.TeamMemberRole__c='Contract Tech';
atmRole1.AccountId__c =a.id;   
insert atmRole1;*/
        
        //Creating Account team members
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u3 =AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);
        user u4 =AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);
        
        insert userList;
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02 replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u1.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'Proposal Specialist')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u3.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
        insert acctMbrList;
        
        AIA_Area_Manager__c area1 = new AIA_Area_Manager__c();
        area1.RecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Manager').getRecordTypeId();
        area1.Area_Manager__c = u4.Id;
        area1.Area_Belong_to__c ='Implementation Manager'; 
        insert area1;
        
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        o.Business_Type__c = 'New';
        update o;
        system.debug('opp');
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = a.id;
        // nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Opportunity__c = o.id;
        insert nbrf;
        
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        //Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Account__c=a.id;
        //Imp.Benefit_Design_Revision_Date__c=system.today();
        
        Imp.Benefit_Request_Form__c=nbrf.id;
        //insert Imp;
        
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = o.id;
        Imp1.Benefit_Design_Revision_Date__c=system.today();
        //Imp1.Generate_Workplan_Stages__c = true;
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Risk_Type__c='ASO';
        Imp1.Account__c=a.id;
        Imp1.Benefit_Request_Form__c=nbrf.id;
        //insert Imp1;
        
        
        List<AIA_Implementation__c> list1 = new List<AIA_Implementation__c>();
        list1.add(Imp);
        list1.add(Imp1);
        
        Insert list1;
        
        
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c=a.id;
        aiaBD.Benefit_Request_Form__c=nbrf.id; 
        //aiaBD.status__c = 'In Progress';
        insert aiaBD;
        
        Test.stopTest();
    }
    //Added by offshore to cover for the role Implementation PM and multiple roles per account
    static testMethod void TestRevisionNumberUpdate_NewImplForPM()
    {
        try{
            Test.startTest();
            Account acc = [Select Id from Account LIMIT 1];
            Benfit_Request_Form__c nbrf = [Select Id from Benfit_Request_Form__c LIMIT 1];
            
            AIA_Benefit_Design__c abd = [Select id,status__c from AIA_Benefit_Design__c limit 1];
            abd.status__c = 'Approved';
            
            update abd;
            
            Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];         
            User u = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = pro.Id,
                              TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
            insert u;
            User u1 = new User(Alias = 'TAlias26', Email='TestUser1BRF35@testorg.com',
                               EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
                               LocaleSidKey='en_US', ProfileId = pro.Id,
                               TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser1BRF35@testorg.com.test');
            insert u1;
            //List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
            List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();//T02 replaced standard AccountTeamMember with custom
            /*AccountTeamMember atmRole1 = new AccountTeamMember ();
//atmRole1.TeamMemberRole = 'Implementation PM';
atmRole1.TeamMemberRole = AIA_ImplementationTriggerHelper.Implementation_PM;
atmRole1.AccountId =acc.id;
atmRole1.UserId = u.id;
AccountTeamMemberList.add(atmRole1);


AccountTeamMember atmRole2 = new AccountTeamMember ();
atmRole2.TeamMemberRole = 'Implementation Manager';
atmRole2.AccountId =acc.id;
atmRole2.UserId = u1.id;
AccountTeamMemberList.add(atmRole2);*/
            Account_Team__c atmRole1 =new Account_Team__c();
            atmRole1.UserId__c=u.id;
            atmRole1.TeamMemberRole__c=AIA_ImplementationTriggerHelper.Implementation_PM;
            atmRole1.AccountId__c =acc.id;   
            AccountTeamMemberList.add(atmRole1);
            Account_Team__c atmRole2 =new Account_Team__c();
            atmRole2.UserId__c=u1.id;
            atmRole2.TeamMemberRole__c='Implementation Manager';
            atmRole2.AccountId__c =acc.id;   
            AccountTeamMemberList.add(atmRole2);
            
            
            user u4 =AIA_TestUtil.AIA_createUser('alias5');
            insert u4;
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Implementation Manager'));
            
            insert AccountTeamMemberList;
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = [Select Id from Opportunity LIMIT 1].id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Benefit_Design_Revision_Date__c=system.today();
            
            Imp.Risk_Type__c='ASO';
            imp.Account__c=acc.Id;
            imp.Benefit_Request_Form__c=nbrf.Id;
            insert Imp;
            
            
            
            
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            aiaBD.Implementation__c = Imp.id;
            aiaBD.Account__c=acc.id;
            aiaBD.Benefit_Request_Form__c=nbrf.id; 
            aiaBD.status__c = 'In Progress';
            insert aiaBD;
            system.assertNotEquals(null, aiaBD.id);
            
            //AIA_Benefit_Design__c abdTEST = [Select id,Revision_number__c,status__c from AIA_Benefit_Design__c Order By CreatedDate DESC limit 1];
            AIA_Benefit_Design__c abdTEST = [Select id,Revision_number__c,status__c from AIA_Benefit_Design__c where id =:aiaBD.id];
            system.assertEquals('In Progress', abdTEST.status__c);
            system.assertEquals('SF - 2', abdTEST.Revision_number__c);
            
            Test.stopTest();
        }
        catch(Exception e){
            system.debug(e);
        }
    }
    static testMethod void TestRevisionNumberUpdate_NewImpl()
    {
        Test.startTest();
        Account acc = [Select Id from Account LIMIT 1];
        Benfit_Request_Form__c nbrf = [Select Id from Benfit_Request_Form__c LIMIT 1];
        
        AIA_Benefit_Design__c abd = [Select id,status__c from AIA_Benefit_Design__c limit 1];
        abd.status__c = 'Approved';
        
        update abd;
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];         
        User u = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = pro.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        insert u;
        //Creating Account Team Member
        //List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
        List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();//T02 replaced standard AccountTeamMember with custom
        Account_Team__c atmRole1 = AIA_TestUtil.accTm(acc.id,'Implementation Coordinator',u.id);
        //Account_Team__c atmRole2 = AIA_TestUtil.accTm(acc.id,'Implementation Coordinator',u.id);
        AccountTeamMemberList.add(atmRole1);
        //AccountTeamMemberList.add(atmRole2);
        insert AccountTeamMemberList;
        //Creating Implementation
        AIA_Implementation__c Imp = AIA_TestUtil.imp(acc.Id,nbrf.Id);
        system.assertNotEquals(null,Imp.id);
        //Creating Benefit Design
        AIA_Benefit_Design__c aiaBD = AIA_TestUtil.benefitDesn(Imp.id, acc.id, nbrf.id);
        system.assertNotEquals(null, aiaBD.id);
        
        //AIA_Benefit_Design__c abdTEST = [Select id,Revision_number__c,status__c from AIA_Benefit_Design__c Order By CreatedDate DESC limit 1];
        AIA_Benefit_Design__c abdTEST = [Select id,Revision_number__c,status__c from AIA_Benefit_Design__c where id =:aiaBD.id];
        system.assertEquals('In Progress', abdTEST.status__c);
        system.assertEquals('SF - 2', abdTEST.Revision_number__c);
        
        Test.stopTest();
    }
    static testMethod void UpdateOwnerTest()
    {
        
        Account acc = [Select id from Account limit 1];
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];         
        User u = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = pro.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        insert u;
        User u1 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = pro.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorgg.com.test');
        insert u1;
        List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>(); 
        AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u.id,'Implementation Coordinator'));
        AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Implementation Manager'));
        insert AccountTeamMemberList; 
        
        AIA_Area_Manager__c area1 = new AIA_Area_Manager__c();
        area1.RecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Manager').getRecordTypeId();
        area1.Area_Manager__c = u.Id;
        area1.Area_Belong_to__c ='Implementation Coordinator'; 
        insert area1;
        AIA_Area_Manager__c area2 = new AIA_Area_Manager__c();
        area2.RecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Manager').getRecordTypeId();
        area2.Area_Manager__c = u1.Id;
        area2.Area_Belong_to__c ='Implementation Manager'; 
        insert area2;
        
        Benfit_Request_Form__c nbrf = [select id from Benfit_Request_Form__c limit 1];    
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = [Select Id from Opportunity LIMIT 1].id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Benefit_Design_Revision_Date__c=system.today();
        Imp.Status__c = 'Not Started';
        Imp.Risk_Type__c='ASO';
        imp.Account__c=acc.Id;
        imp.Benefit_Request_Form__c=nbrf.Id;
        imp.Business_Type__c = 'NCR';
        insert Imp;
        
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = [Select Id from Opportunity LIMIT 1].id;
        Imp1.Generate_Workplan_Stages__c = true;
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Benefit_Design_Revision_Date__c=system.today();
        Imp1.Status__c = 'Not Started';
        Imp1.Risk_Type__c='ASO';
        imp1.Account__c=acc.Id;
        imp1.Benefit_Request_Form__c=nbrf.Id;
        imp1.Business_Type__c = 'New';
        insert Imp1;
        
        List<AIA_Implementation__c> impList = new List<AIA_Implementation__c>();
        impList.add(Imp);
        impList.add(Imp1);
        
        
        
    }
     static testMethod void updateTasksNotRequiredTest()
     {
         List<AIA_Implementation__c> impList = [select id,status__c from AIA_Implementation__c where status__c != 'Completed' limit 2];
         Map<Id,AIA_Implementation__c> impOldMap = new Map<Id,AIA_Implementation__c>();
         
         for(AIA_Implementation__c a : impList)
         {
             impOldMap.put(a.id,a);
         }
         
         AIA_Implementation__c abc = impList[0];
         system.debug('imp status'+abc.Status__c);
         
         abc.Status__c = 'Completed';
         update abc;
         
     }
}