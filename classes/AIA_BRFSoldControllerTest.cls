/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================

*06/08/2018    raj kiran      T01       Added code for role updates
02/08/2019		Chaithra	 |T02|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*==================================================================================
11/09/2018      Paritosh        R1E1    R1 Enhancement coverage
*******************************************************************************************************/
@istest
public class AIA_BRFSoldControllerTest{

                    //Create testusers
        public static User AIA_createUser(String alias )
    {
        
        Integer max = 5;
        String randomString = EncodingUtil.convertToHex(crypto.generateAesKey(128)).substring(1,max).toUpperCase();
        Profile profile = [select id from profile where name='System Administrator'];
        
        User user = new User(alias = alias, email=alias + '@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = profile.Id, 
            timezonesidkey='Europe/London', username=alias +randomString+ '@test.com'
            );
        
        return user; 
        
      }
       //T02 starts
        /*public static AccountTeamMember AIA_createAccountTeamMember(string accId, string usrId, string strRole){
        AccountTeamMember acctMbr = new AccountTeamMember(); 
        acctMbr.AccountId = accId;
        acctMbr.TeamMemberRole = strRole;
        acctMbr.UserId = usrId;
        insert acctMbr;
        return acctMbr;
    }*/  
    public static Account_Team__c AIA_createAccountTeamMember(string accId, string usrId, string strRole){
        
     Account_Team__c  acctMbr =new  Account_Team__c();
      	acctMbr.AccountId__c=accId;
        acctMbr.TeamMemberRole__c=strRole;
        acctMbr.UserId__c=usrId;
        //insert acctMbr;
        
        return acctMbr;
    }
    //T02 Ends    
    @testSetup
    public static void test(){
        
        Test.startTest();
        
        //insert Account
       /* Account acct = new Account(); 
        acct.Name = 'TestAccount';
        acct.NumberOfEmployees = 45; // Num employees should always be <= 50
        acct.Sic = '0111';
        acct.EIN__c = '123456789'; // Has field validation, cannot be longer than 9 chars
        acct.BillingStreet = '1660 International Drive St. #518 Ste.500e ' +
        '1660 International Drive St. #518 Ste.500e' +
        '1660 International Drive St. #518 Ste.500e';
        acct.BillingCity = 'McLean123456789012345678902345678901';
        acct.BillingState = 'VA';
        acct.BillingPostalCode = '22102-4501'; // Has a validation rule in place 
        //acct.Billing_County_Code__c = 'DCMD';
        acct.Renewal_Anniversary_Month__c = 'Nov';
        acct.Account_Legal_Name__c= 'test Account';
        acct.RecordTypeId = QueryBase.getRecordtypeId('Account', 'X2_50');
        //acct.X200_Account__c = true;
        insert acct;*/
        
         Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X51');
        Account acct = new Account();
        acct.Name = '2_50_DEFAULT_ACCOUNT';
        acct.Type = 'Customer';
        acct.Account_Legal_Name__c= 'test Account';
        acct.RecordTypeId = rt_Acc_2_50;
        insert acct;
        system.assert(limits.getQueries()<100);
                
        List<user> userList = new list<user>();
        user u1 = AIA_createUser('alias1');
        userList.add(u1);
        user u2 = AIA_createUser('alias2');
        userList.add(u2);        
        user u3 = AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_createUser('alias6');
        userList.add(u6);
        user u7 = AIA_createUser('alias7');
        userList.add(u7);
        user u8 = AIA_createUser('alias8');
        userList.add(u8);
        user u9 = AIA_createUser('alias9');
        userList.add(u9);
        user u17 = AIA_createUser('aliasa9');
        userList.add(u17);
        user u18 = AIA_createUser('aliasb9');
        userList.add(u18);
        user u19 = AIA_createUser('aliasc9');
        userList.add(u19);
        user u20 = AIA_createUser('aliasd9');
        userList.add(u20);
        insert userList;       
         system.assert(limits.getQueries()<100);
        List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        //Create Account teams for all the relevant roles
       AccountTeamMemberList.add(AIA_createAccountTeamMember(acct.Id, u1.id, 'Auditor')) ;
        AccountTeamMemberList.add(AIA_createAccountTeamMember(acct.Id, u2.id, 'BeneFact Coder'));
        //AIA_createAccountTeamMember(acct.Id, u3.id, 'NASCO Benefit Coder');
        //AIA_createAccountTeamMember(acct.Id, u4.id, 'Ancillary Analyst');
        AccountTeamMemberList.add(AIA_createAccountTeamMember(acct.Id, u5.id, 'MAST Tech'));   
        AccountTeamMemberList.add(AIA_createAccountTeamMember(acct.Id, u6.id, 'Benefit Contract Specialist'));  
       AccountTeamMemberList.add(AIA_createAccountTeamMember(acct.Id, u7.id, 'Account Manager')); 
        AccountTeamMemberList.add(AIA_createAccountTeamMember(acct.Id, u8.id, 'Account Executive'));
        AccountTeamMemberList.add(AIA_createAccountTeamMember(acct.Id, u9.id, 'Underwriter')); //T01
        //Creating AccountMember Test Data T02 starts
        AccountTeamMemberList.add(AIA_createAccountTeamMember(acct.Id,u17.id,'Benefit Coder'));
        AccountTeamMemberList.add(AIA_createAccountTeamMember(acct.Id,u18.id,'Benefit Tester'));
        AccountTeamMemberList.add(AIA_createAccountTeamMember(acct.Id,u19.id,'Vision Analyst'));
        AccountTeamMemberList.add(AIA_createAccountTeamMember(acct.Id,u20.id,'Pharmacy Operations'));
        insert AccountTeamMemberList;
		//T02 ends
            Test.stopTest();
         system.assert(limits.getQueries()<100);
        //insert Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
        opp.Market_Segment_New__c = '51-199';
        opp.Business_type__c = 'Renewal';
        opp.Division__c = '51-199 New Business';
        opp.Legal_Account_Name_Verified__c =true;
        opp.Underwriting_Entity__c = 'NCAS';
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        insert opp;
         system.assert(limits.getQueries()<100);
        
        //insert BRF
        Benfit_Request_Form__c BRF = new Benfit_Request_Form__c();
        BRF.Opportunity__c = opp.id;
        BRF.Benefit_Effective_Date__c = system.today();
        BRF.Contract_Count__c = 14;
        BRF.Broker_Commission__c =31.0;
        BRF.Renewal_Date__c = system.today();
        BRF.Account__c = acct.id;
        BRF.Funding_Arrangements__c = 'Risk';
        insert BRF;
        
         system.assert(limits.getQueries()<100);
        
    }

    
    public static testmethod void testUpdateBRF()
    {
        Test.startTest();
        Benfit_Request_Form__c BRF = [select id,name from Benfit_Request_Form__c Limit 1];
        //R1E1 - Start
         Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
        pp.Benefit_Request_Form__c = BRF.id;
        pp.Funding_Arrangement__c = 'Risk';
        pp.Product_Category__c = 'Medical';
       // insert pp;
        //R1E1 - End
        
       ApexPages.standardController stdCon=new  ApexPages.standardController(BRF);
       AIA_BRFSoldController controller = new AIA_BRFSoldController(stdCon);
       PageReference pageRef = Page.AIA_BRFSold;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id',BRF.id);
       controller.updateBRF();
       controller.cancel(); 
	Test.stopTest();
    }
    
    public static testmethod void testUpdateInvalid()
    {
        test.startTest();
       Benfit_Request_Form__c BRF = [select id,name,AdjustmentRecordCount__c,Request_Type__c from Benfit_Request_Form__c Limit 1];
       BRF.AdjustmentRecordCount__c = 12;
       BRF.Request_Type__c = 'Renew As-is';
       update BRF;
       ApexPages.standardController stdCon=new  ApexPages.standardController(BRF);
       AIA_BRFSoldController controller = new AIA_BRFSoldController(stdCon);
       PageReference pageRef = Page.AIA_BRFSold;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id',BRF.id);
       controller.getIsClassic();
       controller.updateBRF();
       test.stopTest();
    }
     public static testmethod void testUpdatevalid()
    {
       Benfit_Request_Form__c BRF = [select id,name,Status__c,Count_of_Risk_Medical_Products__c,AdjustmentRecordCount__c,Request_Type__c from Benfit_Request_Form__c where Count_of_Risk_Medical_Products__c = 0 Limit 1];
       BRF.AdjustmentRecordCount__c = 0;
       BRF.Request_Type__c = '';
        // BRF.Request_Type__c = 'Renew As-is';
        //BRF.Count_of_Risk_Medical_Products__c = 0;
       BRF.Status__c ='New';
       update BRF;
       ApexPages.standardController stdCon=new  ApexPages.standardController(BRF);
       AIA_BRFSoldController controller = new AIA_BRFSoldController(stdCon);
       PageReference pageRef = Page.AIA_BRFSold;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id',BRF.id);
       controller.getIsClassic();
       controller.updateBRF();
       
    }
    public static testmethod void testUpdateInvalid1()
    {
       Benfit_Request_Form__c BRF = [select id,name,AdjustmentRecordCount__c,Request_Type__c from Benfit_Request_Form__c Limit 1];
       BRF.status__c = 'Sold';
       update BRF;
       ApexPages.standardController stdCon=new  ApexPages.standardController(BRF);
       AIA_BRFSoldController controller = new AIA_BRFSoldController(stdCon);
       PageReference pageRef = Page.AIA_BRFSold;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id',BRF.id);
       controller.updateBRF();
       
    }
    
    
    //R1E1 - Start
    
    public static testmethod void testMHPPass(){
        Benfit_Request_Form__c BRF = [select id,name,AdjustmentRecordCount__c,Request_Type__c from Benfit_Request_Form__c Limit 1];
        BRF.Submit_Medical_Plan_s_for_MHP_Testing__c = true;
        update BRF;
        ApexPages.standardController stdCon=new  ApexPages.standardController(BRF);
        AIA_BRFSoldController  controller = new AIA_BRFSoldController(stdCon);
        ApexPages.currentPage().getParameters().put('id',BRF.id);
        controller.updateBRF();
        controller.MHPPass();
    }
    
    public static testmethod void testSave()
    {
        Benfit_Request_Form__c BRF = [select id,name,Count_of_Risk_Medical_Products__c,AdjustmentRecordCount__c,Request_Type__c from Benfit_Request_Form__c Limit 1];
        ApexPages.standardController stdCon=new  ApexPages.standardController(BRF);
        AIA_BRFSoldController controller = new AIA_BRFSoldController(stdCon);
        PageReference pageRef = Page.AIA_BRFSold;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',BRF.id);
        controller.Save();
        
    }
    public static testmethod void testSave2()
    {
        try{
        Benfit_Request_Form__c BRF = [select id,name,Status__c,AdjustmentRecordCount__c,Request_Type__c from Benfit_Request_Form__c Limit 1];
        
        
        BRF.Status__c='Sold';
        
         update BRF;
        ApexPages.standardController stdCon=new  ApexPages.standardController(BRF);
       AIA_BRFSoldController controller = new AIA_BRFSoldController(stdCon);
       PageReference pageRef = Page.AIA_BRFSold;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id',BRF.id);
       controller.updateBRF();
        }catch (exception e){
            
        }
        
    }
    
    
    
    //Added by Rajashekar
   /* @testSetup
    public static void Updatetest(){
        
        Test.startTest();
        
        //insert Account
        Account acct = new Account(); 
        acct.Name = 'TestAccount';
        acct.NumberOfEmployees = 45; // Num employees should always be <= 50
        acct.Sic = '0111';
        acct.EIN__c = '123456789'; // Has field validation, cannot be longer than 9 chars
        acct.BillingStreet = '1660 International Drive St. #518 Ste.500e ' +
        '1660 International Drive St. #518 Ste.500e' +
        '1660 International Drive St. #518 Ste.500e';
        acct.BillingCity = 'McLean123456789012345678902345678901';
        acct.BillingState = 'VA';
        acct.BillingPostalCode = '22102-4501'; // Has a validation rule in place 
        //acct.Billing_County_Code__c = 'DCMD';
        acct.Renewal_Anniversary_Month__c = 'Nov';
        acct.Account_Legal_Name__c= 'test Account';
        acct.X200_Account__c = true;
        insert acct;
        
                     
                
        List<user> userList = new list<user>();
        user u1 = AIA_createUser('alias1');
        userList.add(u1);
        user u2 = AIA_createUser('alias2');
        userList.add(u2);        
        user u3 = AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_createUser('alias6');
        userList.add(u6);
        user u7 = AIA_createUser('alias7');
        userList.add(u7);
        user u8 = AIA_createUser('alias8');
        userList.add(u8);
        user u9 = AIA_createUser('alias9');
        userList.add(u9);
        user u17 = AIA_createUser('aliasa9');
        userList.add(u17);
        user u18 = AIA_createUser('aliasb9');
        userList.add(u18);
        user u19 = AIA_createUser('aliasc9');
        userList.add(u19);
        user u20 = AIA_createUser('aliasd9');
        userList.add(u20);
        insert userList;       
        
        //Create Account teams for all the relevant roles
        AIA_createAccountTeamMember(acct.Id, u1.id, 'Auditor');
        AIA_createAccountTeamMember(acct.Id, u2.id, 'BeneFact Coder');
        //AIA_createAccountTeamMember(acct.Id, u3.id, 'NASCO Benefit Coder');
        //AIA_createAccountTeamMember(acct.Id, u4.id, 'Ancillary Analyst');
        AIA_createAccountTeamMember(acct.Id, u5.id, 'MAST Tech');   
        AIA_createAccountTeamMember(acct.Id, u6.id, 'Benefit Contract Specialist');  
        AIA_createAccountTeamMember(acct.Id, u7.id, 'Account Manager'); 
        AIA_createAccountTeamMember(acct.Id, u8.id, 'Account Executive');
        AIA_createAccountTeamMember(acct.Id, u9.id, 'Underwriter'); //T01
        //Creating AccountMember Test Data T02 starts
        AIA_createAccountTeamMember(acct.Id,u17.id,'Benefit Coder');
        AIA_createAccountTeamMember(acct.Id,u18.id,'Benefit Tester');
        AIA_createAccountTeamMember(acct.Id,u19.id,'Vision Analyst');
        AIA_createAccountTeamMember(acct.Id,u20.id,'Pharmacy Operations');
		//T02 ends
        //insert Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
        opp.Market_Segment_New__c = '51-199';
        opp.Business_type__c = 'Renewal';
        opp.Division__c = '51-199 New Business';
        opp.Legal_Account_Name_Verified__c =true;
        opp.Underwriting_Entity__c = 'NCAS';
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        insert opp;
        
        
        //insert BRF
        Benfit_Request_Form__c BRF = new Benfit_Request_Form__c();
        BRF.Opportunity__c = opp.id;
        BRF.Benefit_Effective_Date__c = system.today();
        BRF.Contract_Count__c = 14;
        BRF.Broker_Commission__c =31.0;
        BRF.Renewal_Date__c = system.today();
        BRF.Account__c = acct.id;
        BRF.Submit_Medical_Plan_s_for_MHP_Testing__c  = false;
        BRF.Funding_Arrangements__c = 'Risk';
        insert BRF;
        
        
        
        Proposed_Products__c prod = new Proposed_Products__c();
        prod.Benefit_Request_Form__c  = BRF.Id;
        prod.Product_Category__c = 'Medical';
        prod.Funding_Arrangement__c = 'Risk';
        insert prod;
         Proposed_Products__c prods = new Proposed_Products__c();
        prods.Benefit_Request_Form__c  = BRF.Id;
        prods.Product_Category__c = 'Medical';
        prods.Funding_Arrangement__c = 'Risk';
        insert prods;
        Test.stopTest();
    }*/
    //R1E1 - End
}