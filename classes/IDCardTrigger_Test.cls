@isTest
private class IDCardTrigger_Test{

    static testmethod void testIDCard(){
    	Test.startTest();
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        insert u4;
        
        //System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        //Create Account
        Account acc =AIA_TestUtil.createAccount('TestOEMAcc');
        Contact con = new Contact(AccountId=acc.id,firstName='fname',LastName='lName',phone='123456677',Email ='test@test.com');
        insert con;
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
        
        //System.debug('2.Number of Queries used in this apex code so far: ' + Limits.getQueries());            
        
        AccountTeamMember atm3 = new AccountTeamMember ();
        atm3.TeamMemberRole = 'MAST Tech';
        atm3.AccountId = acc.id;
        atm3.UserId = u4.id;
        insert atm3;  

        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = acc.id;
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Opportunity__c = opp.id;
        nbrf.Jurisdiction__c = 'MD';
        insert nbrf;
        
        //System.debug('3.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
        
        //Create Benefit Design
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = nbrf.id;
        insert Imp;
        
        ID_Card__c idc = new ID_Card__c ();
        idc.Status__c = 'In Progress';
        idc.products_selected_count__c = 1;
        idc.Member_level_Products__c = 'Yes';
        idc.sent_to_approval__c = true;
        idc.Implementation__c= Imp.id;
        insert idc;
        Test.stopTest();
    }
}