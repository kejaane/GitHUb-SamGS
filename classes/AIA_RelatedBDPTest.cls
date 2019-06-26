@isTest
private class AIA_RelatedBDPTest{


    static testmethod void PnameDrawloop(){
    
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        insert u4;
        
        //System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        //Create Account
        Account acc =AIA_TestUtil.createAccount('TestOEMAcc');
        List<user> userList1 = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList1.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList1.add(u2);
        user u3 =AIA_TestUtil.AIA_createUser('alias3');
        userList1.add(u3);
        
        insert userlist1;
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        insert acctMbrList;
                

        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
        
        //System.debug('2.Number of Queries used in this apex code so far: ' + Limits.getQueries());            
        
        /*AccountTeamMember atm3 = new AccountTeamMember ();
        atm3.TeamMemberRole = 'Contract Tech';
        atm3.AccountId = acc.id;
        atm3.UserId = u4.id;
        insert atm3;*/  
                /*Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=u4.id;
                 atmRole1.TeamMemberRole__c='Contract Tech';
                 atmRole1.AccountId__c =acc.id;   
                insert atmRole1;*/
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
        nbrf.Funding_Arrangements__c = 'ASO';
        insert nbrf;
        test.startTest();
        //System.debug('3.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
        
        //Create Benefit Design
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Benefit_Request_Form__c = nbrf.id;
        Imp.Opportunity__c = opp.Id;
        Imp.Account__c = acc.Id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        insert Imp;
        
        //System.debug('4.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
        
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = nbrf.Id;
        insert aiaBD;
        
        //System.debug('5.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
        
         
        
        //System.debug('6.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        AIA_Plan__c p = new AIA_Plan__c ();
        p.Product_Category__c = 'Medical';
        p.Product_Line__c = 'Health Maintenance Organization';
        p.Plan_Name__c ='testing plan';
        p.CDH__c = 'Yes';
        p.CDH_Type__c = 'HSA';
        p.CDH_Fund_Type__c = 'BlueFund';
        p.Plan_Id__c = 'testsdglksdgjlsldgkjs';
        p.Effective_Date__c = system.today();
        p.Termination_Date__c = system.today();
        p.Product_Status__c ='Active';
        p.Jurisdiction__c = 'MD';
        p.Product_Last_Updated_String_Format__c = '2016-10-25 07:04:03 AM';
        insert p;
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c = aiaBD.id;
        aiaBDP1.Plan_Name__c = p.id;
       
        insert aiaBDP1; 
        /*aiaBDP1.Product_Category__c = 'Medical';
        aiaBDP1.drawloop_product__c='Test';
        update aiaBDP1;*/
        
        AIA_Related_Benefit_Design_Product__c  aiarbdp = new AIA_Related_Benefit_Design_Product__c();
        aiarbdp.Benefit_Design_Product__c = aiaBDP1.id;
        
        
        insert aiarbdp;
        System.AssertEquals(aiarbdp.Benefit_Design_Product__c,aiaBDP1.id);
        
        aiaBDP1.Product_Category__c = 'Medical';
        aiaBDP1.drawloop_product__c='Test';
        update aiaBDP1;
        test.stopTest();
       /* AIA_Related_Benefit_Design_Product__c  aiarbdp1 = new AIA_Related_Benefit_Design_Product__c();
        aiarbdp1.Benefit_Design_Product__c = aiaBDP1.id;
        insert aiarbdp1;
        
       AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
        aiaBDP2.Benefit_Design__c = aiaBD.id;
        aiaBDP2.Plan_Name__c = p.id;  
        aiaBDP2.Product_Category__c = 'Vision';
        insert aiaBDP2; 
        
        AIA_Benefit_Design_Form__c aiaBDF = new AIA_Benefit_Design_Form__c();
        aiaBDF.Benefit_Design__c = aiaBD.id;
        aiaBDF.Benefit_Design_Product__c  = aiaBDP1.id; 
        aiaBDF.Child_Dependent_Mandates__c = 'Maryland'; 
        aiaBDF.Michelle_s_Law_4a__c = 'Yes';
        aiaBDF.Child_Dependents_Limit_Age_4a__c = 2;
        aiaBDF.Michelle_s_Law_Waiver_4a__c = 'Yes';
        aiaBDF.Students_Limit_Age_4a__c =  9;
        aiaBDF.Child_Dependents_Removal_Method_4a__c = 'On Birthday';
        aiaBDF.Students_Removal_Method_4a__c = 'On Birthday';
        aiaBDF.Part_time_Students_with_Disabilities_4a__c = 'Yes';  
             
        insert aiaBDF; 
        
         
        
        AIA_Benefit_Design_Product__c aiaBDP3 = new AIA_Benefit_Design_Product__c();
        aiaBDP3.Benefit_Design__c = aiaBD.id;
        aiaBDP3.Related_Medical_Product__c = aiaBDP1.id; 
        aiaBDP3.Plan_Name__c = p.id;
        aiaBDP3.Product_Category__c = 'Drug';    
        insert aiaBDP3; */
       //test.stopTest(); 
        //System.debug('7.Number of Queries used in this apex code so far: ' + Limits.getQueries());                
        
        
    }
    
     static testmethod void PnameDrawloop1(){

   
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        /*User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        insert u4;*/
        
        //System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        //Create Account
        Account acc =AIA_TestUtil.createAccount('TestOEMAcc');
        List<user> userList1 = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList1.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList1.add(u2);
        user u3 =AIA_TestUtil.AIA_createUser('alias3');
        userList1.add(u3);
        user u4 =AIA_TestUtil.AIA_createUser('alias4');
        userList1.add(u4);
        insert userlist1;
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList1 = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
         acctMbrList1.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Manager')); 
        acctMbrList1.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Account Executive')); 
        acctMbrList1.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Proposal Specialist')); 
        acctMbrList1.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        
        insert acctMbrList1;
                

        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
        
        //System.debug('2.Number of Queries used in this apex code so far: ' + Limits.getQueries());            
        
       /* AccountTeamMember atm3 = new AccountTeamMember ();
        atm3.TeamMemberRole = 'Contract Tech';
        atm3.AccountId = acc.id;
        atm3.UserId = u4.id;
        insert atm3;*/ 
        
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
        nbrf.Funding_Arrangements__c = 'ASO';
        insert nbrf;
        
        //System.debug('3.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
         test.startTest();
        //Create Benefit Design
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp.Id;
        Imp.Benefit_Request_Form__c = nbrf.id;
        Imp.Account__c = acc.Id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        insert Imp;
        
        //System.debug('4.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
        
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = nbrf.Id;
        insert aiaBD;
        
        //System.debug('5.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
        
         
        
        //System.debug('6.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        AIA_Plan__c p = new AIA_Plan__c ();
        p.Product_Category__c = 'Medical';
        p.Product_Line__c = 'Health Maintenance Organization';
        p.Plan_Name__c ='testing plan';
        p.CDH__c = 'Yes';
        p.CDH_Type__c = 'HSA';
        p.CDH_Fund_Type__c = 'BlueFund';
        p.Plan_Id__c = 'testsdglksdgjlsldgkjs';
        p.Effective_Date__c = system.today();
        p.Termination_Date__c = system.today();
        p.Product_Status__c ='Active';
        p.Jurisdiction__c = 'MD';
        p.Product_Last_Updated_String_Format__c = '2016-10-25 07:04:03 AM';
        insert p;
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c = aiaBD.id;
        aiaBDP1.Plan_Name__c = p.id;
        aiaBDP1.drawloop_product__c='Test';
        insert aiaBDP1; 
        /*aiaBDP1.Product_Category__c = 'Medical';
        aiaBDP1.drawloop_product__c='Test';
        update aiaBDP1;*/
        //test.startTest();
        AIA_Related_Benefit_Design_Product__c  aiarbdp = new AIA_Related_Benefit_Design_Product__c();
        aiarbdp.Benefit_Design_Product__c = aiaBDP1.id;
        
        
        insert aiarbdp;
        System.AssertEquals(aiarbdp.Benefit_Design_Product__c,aiaBDP1.id);
        
        aiaBDP1.Product_Category__c = 'Medical';
        aiaBDP1.drawloop_product__c='Test';
        update aiaBDP1;
        test.stopTest();
       /* AIA_Related_Benefit_Design_Product__c  aiarbdp1 = new AIA_Related_Benefit_Design_Product__c();
        aiarbdp1.Benefit_Design_Product__c = aiaBDP1.id;
        insert aiarbdp1;
        
       AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
        aiaBDP2.Benefit_Design__c = aiaBD.id;
        aiaBDP2.Plan_Name__c = p.id;  
        aiaBDP2.Product_Category__c = 'Vision';
        insert aiaBDP2; 
        
        AIA_Benefit_Design_Form__c aiaBDF = new AIA_Benefit_Design_Form__c();
        aiaBDF.Benefit_Design__c = aiaBD.id;
        aiaBDF.Benefit_Design_Product__c  = aiaBDP1.id; 
        aiaBDF.Child_Dependent_Mandates__c = 'Maryland'; 
        aiaBDF.Michelle_s_Law_4a__c = 'Yes';
        aiaBDF.Child_Dependents_Limit_Age_4a__c = 2;
        aiaBDF.Michelle_s_Law_Waiver_4a__c = 'Yes';
        aiaBDF.Students_Limit_Age_4a__c =  9;
        aiaBDF.Child_Dependents_Removal_Method_4a__c = 'On Birthday';
        aiaBDF.Students_Removal_Method_4a__c = 'On Birthday';
        aiaBDF.Part_time_Students_with_Disabilities_4a__c = 'Yes';  
             
        insert aiaBDF; 
        
         
        
        AIA_Benefit_Design_Product__c aiaBDP3 = new AIA_Benefit_Design_Product__c();
        aiaBDP3.Benefit_Design__c = aiaBD.id;
        aiaBDP3.Related_Medical_Product__c = aiaBDP1.id; 
        aiaBDP3.Plan_Name__c = p.id;
        aiaBDP3.Product_Category__c = 'Drug';    
        insert aiaBDP3; */
       //test.stopTest(); 
        //System.debug('7.Number of Queries used in this apex code so far: ' + Limits.getQueries());                
        
        
    }
}