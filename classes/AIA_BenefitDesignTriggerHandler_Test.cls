@isTest
private class AIA_BenefitDesignTriggerHandler_Test{

    static testmethod void testcreateBenefitDesignProduct(){
    
      Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom']; 
         

        
         User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        insert u4;
        User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF5@testorg.com.test');
        insert u5;
        User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF6@testorg.com.test');
        insert u6;
		//T01 ends
        AIA_Config__c cs = new AIA_Config__c();
        cs.Run__c = true;
        cs.Name = 'BDTHelper.createBenefitDesignProduct';
        insert cs;


     
        //Create Account
        Account acc =AIA_TestUtil.createAccount('TestOEMAcc');
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id);     
        list<Account_Team__c> listTeam = new List<Account_Team__c>(); 
         Account_Team__c atm3 = new Account_Team__c ();
        atm3.TeamMemberRole__c = 'Contract Tech';
        atm3.AccountId__c = acc.id;
        atm3.UserId__c = u4.id;
        //insert atm3;
    	listTeam.add(atm3);
        
        Account_Team__c atm5 = new Account_Team__c ();
        atm5.TeamMemberRole__c = 'Account Executive';
        atm5.AccountId__c = acc.id;
        atm5.UserId__c = u5.id;
        //insert atm5;
        listTeam.add(atm5);
        
        Account_Team__c atm4 = new Account_Team__c ();
        atm4.TeamMemberRole__c = 'Account Manager';
        atm4.AccountId__c = acc.id;
        atm4.UserId__c = u6.id;
        //insert atm4;
        listTeam.add(atm4);
        insert listTeam;
        
        system.debug('Team is: '+listTeam);
        system.debug('Acc: '+acc);
       
        update acc;
		Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = acc.id;
        //nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Opportunity__c = opp.id;
        nbrf.Jurisdiction__c = 'MD';
        insert nbrf;
        
        //Create Benefit Design
        
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp.Id;
        Imp.Account__c = acc.Id;
        //mp.Generate_Workplan_Stages__c = true; R1 Risk
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        insert Imp;
        Test.startTest();
        
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = nbrf.Id;
        aiaBD.Status__c = 'In Progress';
        insert aiaBD;
        Test.stopTest();
        system.debug('TestclassBd: '+aiaBD.id);
        system.debug('TestclassBd1: '+aiaBD);
        
        AIA_Benefit_Design__c bd= [select id,name,Status__c from AIA_Benefit_Design__c where Status__c = 'In Progress' Limit 1];
        system.debug('SOQL bd Testclass:'+bd);
        bd.Status__c = 'In Review';
        update bd;
        
        
    }
    static testmethod void testcreateBenefitDesignProduct1(){
    
      Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         

        
         User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        insert u4;
        User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF5@testorg.com.test');
        insert u5;
        User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF6@testorg.com.test');
        insert u6;
		User u7 = new User(Alias = 'TAlias7', Email='TestUserBRF7@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF7@testorg.com.test');
        insert u7;
        //T01 ends


     
        //Create Account
        Account acc =AIA_TestUtil.createAccount('TestOEMAcc');
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id);     
        list<Account_Team__c> listTeam = new List<Account_Team__c>(); 
         Account_Team__c atm3 = new Account_Team__c ();
        atm3.TeamMemberRole__c = 'Contract Tech';
        atm3.AccountId__c = acc.id;
        atm3.UserId__c = u4.id;
        //insert atm3;
    	listTeam.add(atm3);
        
        Account_Team__c atm5 = new Account_Team__c ();
        atm5.TeamMemberRole__c = 'Account Executive';
        atm5.AccountId__c = acc.id;
        atm5.UserId__c = u5.id;
        listTeam.add(atm5);
        
        Account_Team__c atm4 = new Account_Team__c ();
        atm4.TeamMemberRole__c = 'Account Manager';
        atm4.AccountId__c = acc.id;
        atm4.UserId__c = u6.id;
        listTeam.add(atm4);
        insert listTeam;
        
        system.debug('Team is: '+listTeam);
        system.debug('Acc: '+acc);
       
        update acc;
        
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = acc.id;
        //nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Opportunity__c = opp.id;
        nbrf.Jurisdiction__c = 'MD';
        insert nbrf;
        
        Test.startTest();
        //Create Benefit Design
        
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true; R1 Risk
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        insert Imp;
        
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = nbrf.Id;
        aiaBD.Status__c = 'In Review';
        insert aiaBD;
        system.debug('TestclassBd: '+aiaBD.id);
        system.debug('TestclassBd1: '+aiaBD);
        system.runAs(u4){
            aiaBD.Status__c = 'Approved';
            update aiaBD;
            Test.stopTest();
        }
    }
}