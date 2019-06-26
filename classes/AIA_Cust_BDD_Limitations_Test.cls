/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================

*06/08/2018    raj kiran      T01       Added code for role updates
*01-18-2019 	Chaithra 		|T02| Created users for account team role as per US1702 and US1730
*02/08/2019		Chaithra	 |T03|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*==================================================================================

*******************************************************************************************************/


@isTest
public class AIA_Cust_BDD_Limitations_Test{
    public static Proposed_Products__c pp;
    public static AIA_Benefit_Design_Product__c bdp;
    public static List<AIA_Benefits__c> lstBnft;
    public static AIA_Grouper__c ag1;
    
    public static testMethod void Test1()    
    {         
            CreateTestData();
            PageReference pageRef = Page.AIA_Cust_BDD_Limit; //new pageReference('/apex/AIA_Additional_Benefits?pid='+pp.id);
            Test.setCurrentPage(pageRef);            
            pageRef.getParameters().put('id',bdp.id);
        	pageRef.getParameters().put('Grouper',ag1.id);
        	ApexPages.StandardController sc = new ApexPages.StandardController(bdp);
                    
          //Test.startTest(); 
            AIA_Cust_BDD_Limitations ext = new AIA_Cust_BDD_Limitations(sc);    
        	ext.Actions();
			ext.getLimitationType();
        	ext.save();
        	ext.Cancel();
        	ext.BackToAddAdditionalBenefits();
          Test.stopTest();     
    }
    
   public static testMethod void Test2()    
    {         
            CreateTestData();
            PageReference pageRef = Page.AIA_Cust_BDD_Limit; //new pageReference('/apex/AIA_Additional_Benefits?pid='+pp.id);
            Test.setCurrentPage(pageRef);            
            pageRef.getParameters().put('id',bdp.id);
        	pageRef.getParameters().put('Grouper',ag1.id);
        	ApexPages.StandardController sc = new ApexPages.StandardController(bdp);
                    
          //Test.startTest(); 
            AIA_Cust_BDD_Limitations ext = new AIA_Cust_BDD_Limitations(sc);   
        	ext.selectedBenefit = 'test2';        	
        	ext.LmtType = 'Comment';
        	ext.Actions();
        	ext.save();
          Test.stopTest();     
    }
    
    public static testMethod void Test3()    
    {         
            
        	CreateTestData();
            PageReference pageRef = Page.AIA_Cust_BDD_Limit; //new pageReference('/apex/AIA_Additional_Benefits?pid='+pp.id);
            Test.setCurrentPage(pageRef);            
            pageRef.getParameters().put('id',bdp.id);
        	pageRef.getParameters().put('Grouper',ag1.id);
        	ApexPages.StandardController sc = new ApexPages.StandardController(bdp);
                  
            //Test.startTest();
            AIA_Cust_BDD_Limitations ext = new AIA_Cust_BDD_Limitations(sc);   
        	ext.selectedBenefit = 'test2';
        	ext.LmtType = 'MaxRow';
        	ext.Actions();
        	ext.save();
            Test.stopTest();     
    }    
    
  public static void CreateTestData(){                         
          Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];

            List<User> usrLst = new  List<User>();
      		User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB123RF@testorg.com.test');
            //insert u;
    		usrLst.add(u);
            User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF121@testorg.com.test');
            //insert u1;
    		usrLst.add(u1);
            User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF222@testorg.com.test');
            //insert u2;
    		usrLst.add(u2);
            User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBR12F3@testorg.com.test');
            //insert u3;
    		usrLst.add(u3);
            User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB3RF4@testorg.com.test');
            //insert u4;
    		usrLst.add(u4);
            User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUse12rBRF5@testorg.com.test');
            //insert u5;
    		usrLst.add(u5);
            User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingU21serBRF6@testorg.com.test');
            //insert u6;
            usrLst.add(u6);
    
            User u7 = new User(Alias = 'TAlias7', Email='TestUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Testin11gUserBRF7@testorg.com.test');
            //insert u7;
    		usrLst.add(u7);
            User u8 = new User(Alias = 'TAla87', Email='T76estUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSery67', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Test76564in11gUserBRF7@testorg.com.test');
            //insert u8;
    		usrLst.add(u8);
            User u9 = new User(Alias = 'TAli97', Email='Te5467stUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer776', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te75stin11gUserBRF7@testorg.com.test');
            //insert u9;
    		usrLst.add(u9);
    
            User u10 = new User(Alias = 'TA197', Email='Te10e11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='Testing1076', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te10gUserBRF7@testorg.com.test');
            //insert u10;
            usrLst.add(u10);
      
      user u11 = AIA_TestUtil.AIA_createUser('alias1');
      user u12 = AIA_TestUtil.AIA_createUser('alias2');
      usrLst.add(u11);
      usrLst.add(u12);
      //T02 starts
      user u17 = AIA_TestUtil.AIA_createUser('aliasa17');
       usrLst.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('aliasa18');
        usrLst.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('aliasa17');
        usrLst.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('aliasa18');
        usrLst.add(u20);
        insert usrLst;
      //t02 ends
      		
      
      		//Commenting as part of US210
      		/*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
          wpt.Used_For__c = 'Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c = true;
            insert wpt;*/
            
            Account Acc = new Account();
            Acc.RecordTypeId = QueryBase.getRecordtypeId('Account', 'X51');
            Acc.Name = 'Test Account';
            Acc.Type = 'Customer';
            Acc.Account_Legal_Name__c = 'Test Account Legal Name';
            Acc.BillingStreet = 'James Street';
            Acc.BillingCity = 'New York';
            Acc.BillingState = 'MD';
            Acc.BillingPostalCode = '21212';
            Acc.BillingCountry = 'USA';
            Acc.Billing_County_Code__c = 'MO-Montgomery';
            
            Insert Acc;
            
            Opportunity o = new opportunity();
            o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
            o.AccountId = acc.id;
            o.name = 'Test Opportunity';
            o.SBU__c = 'Large';
            o.Market_Segment_New__c = '1000+';
            o.Division__c = 'Commercial Business';
            o.Business_Type__c = 'New';
            o.Effective_Date__c = Date.newInstance(2014, 10, 1);
            o.CloseDate = o.Effective_Date__c.addDays(-11);
            o.Legal_Account_Name_Verified__c = true;
            o.AE_Name__c = 'Test AE Name';
            o.AM_Name__c = 'Test AM Name';
            o.Contract_End_Date__c = o.Effective_Date__c.addMonths(1);
            o.Contract_End_Date__c = o.Contract_End_Date__c.addDays(-1);
            o.type = 'Medical Only';
            o.System__c = 'Facets';
            o.Underwriting_Entity__c = 'NCAS';
            o.Risk_Non_Risk__c = 'Non-Risk';
           // o.Workplan_Type__c = wpt.id;//Commenting as part of US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;

        	//T03 changes starts
      		/*List<AccountTeamMember> accTeamLst = new List<AccountTeamMember>();
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId = acc.id;
            atmRole.UserId = u.id;
            //insert atmRole;
    		accTeamLst.add(atmRole);
            AccountTeamMember atm1 = new AccountTeamMember ();
            atm1.TeamMemberRole = 'Account Manager';
            atm1.AccountId =acc.id;
            atm1.UserId = u1.id;
            //insert atm1;
    		accTeamLst.add(atm1);
            AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Implementation Manager';
            atmRole1.AccountId = acc.id;
            atmRole1.UserId = u2.id;
            //insert atmRole1;
            //system.assertNotEquals(null,atmRole1.id);
    		accTeamLst.add(atmRole1);
            AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Settlements Analyst'; //T01
            atmRole2.AccountId = acc.id;
            atmRole2.UserId = u3.id;
            //insert atmRole2;
    		accTeamLst.add(atmRole2);
            AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Billing Tech';
            atmRole3.AccountId = acc.id;
            atmRole3.UserId = u4.id;
            //insert atmRole3;
    		accTeamLst.add(atmRole3);
            AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'Auditor'; //T01
            atmRole4.AccountId = acc.id;
            atmRole4.UserId = u5.id;
            //insert atmRole4;
    		accTeamLst.add(atmRole4);
            
         	AccountTeamMember atmRole5 = new AccountTeamMember ();
            atmRole5.TeamMemberRole = 'QA Auditor';
            atmRole5.AccountId = acc.id;
            atmRole5.UserId = u6.id;
            //insert atmRole5;
    		accTeamLst.add(atmRole5);
    
            AccountTeamMember atmRole61 = new AccountTeamMember ();
            atmRole61.TeamMemberRole = 'Contract Tech';
            atmRole61.AccountId = acc.id;
            atmRole61.UserId = u7.id;
            //insert atmRole61;        
    		accTeamLst.add(atmRole61);
            
      		AccountTeamMember atmRole62 = new AccountTeamMember ();
            atmRole62.TeamMemberRole = 'Ancillary Analyst';
            atmRole62.AccountId = acc.id;
            atmRole62.UserId = u8.id;
            //insert atmRole62;
      		accTeamLst.add(atmRole62);
    
            AccountTeamMember atmRole6 = new AccountTeamMember ();
            atmRole6.TeamMemberRole = 'NASCO Benefit Coder';
            atmRole6.AccountId = acc.id;
            atmRole6.UserId = u9.id;
            //insert atmRole6;
            accTeamLst.add(atmRole6);
      		
    
            AccountTeamMember atmRole15 = new AccountTeamMember ();
            atmRole15.TeamMemberRole = 'MAST Tech';
            atmRole15.AccountId = acc.id;
            atmRole15.UserId = u10.id;
            //insert atmRole15;
      		accTeamLst.add(atmRole15);*/
      List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T03
      	acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'MAST Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u6.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Settlements Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Implementation Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u.id,'BeneFact Coder'));
      
      acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Account Executive')); 
      acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Underwriter')); 
      acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
      //T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
      //T02 ends
      		insert acctMbrList;
        
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            brf.ARC_Approval_Status__c = 'Pending';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
          brf.Rider__c = 'Vision Care Rider';
            insert brf;
        
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical', 'Test');
            aiapln.Plan_Name__c = 'Test Plan';
            //aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            // aiapln.Jurisdiction__c = 'MD';
            insert aiapln;
        
            pp = new Proposed_Products__c();
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c = brf.id;
            pp.Funding_Arrangement__c = 'ASO';
            pp.Product_Category__c = 'Medical';
            pp.Product_Line__c = 'PPO';
            pp.Plan_Name__c = aiapln.id;
            pp.Product_Name__c = 'BlueChoice Advantage';
            pp.CDH__c = 'Yes';
            pp.CDH_Fund_Type__c = 'BlueFund';
            pp.CDH_Type__c = 'HSA';
            pp.Deductible__c = 'Stacked';
            pp.Grandfathered_Status__c = 'Grandfathered';
            pp.Integrated_Non_Integrated__c = 'Yes';
            pp.Grandfathered_PPACA_Status__c = 'No';
            pp.Blue_Rewards__c = 'No';
            pp.Out_of_Pocket_Max__c = 'Stacked';
            pp.Has_Benefit_Details__c = True;
            insert pp;
        
            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'Additional Services';
            ag.Group_Type__c = 'Benefit Group';
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();            
            ag.Proposed_Products__c = pp.id;
            insert ag;
        
            lstBnft = new List < AIA_Benefits__c > ();
     /*       AIA_Benefits__c ab3 = new AIA_Benefits__c();
            ab3.Grouper__c = ag.id;
            ab3.Benefit_Name__c = 'test1';            
            ab3.Benefit_Type__c = 'Limitation';
            ab3.Type__c = 'Benefit';
            ab3.Benefit_Record_Type__c = 'BRF';            
            lstBnft.add(ab3); 
            
            AIA_Benefits__c ab4 = new AIA_Benefits__c();
            ab4.Grouper__c = ag.id;
            ab4.Benefit_Name__c = 'test2';            
            ab4.Benefit_Type__c = 'Limitation';
            ab4.Type__c = 'Benefit';
            ab4.Benefit_Record_Type__c = 'BRF';            
            lstBnft.add(ab4);  */
        
            AIA_Benefits__c ab = new AIA_Benefits__c();
            ab.Grouper__c = ag.id;
            ab.Benefit_Name__c = 'test1 - General General';
            ab.Benefit_Type__c = 'Benefit';            
            ab.Type__c = 'Benefit';
            ab.Benefit_Record_Type__c = 'BRF';    
          //  ab.Parent_Benefit__c = ab3.Id; 
            ab.CoInsurance_AmountValueSelected__c = '';
          	ab.Copay_Type_1_DeductibleApplies__c = ''; 
          	ab.Copay_Type_1_IsCovered__c = 'N/A';
          	ab.Place_of_Service__c = 'In-Patient';
          	ab.Dummy_Parent_Benefit_Name__c = 'Ben1';
                  
            lstBnft.add(ab);            
            
            AIA_Benefits__c ab2 = new AIA_Benefits__c();
            ab2.Grouper__c = ag.id;
            ab2.Benefit_Name__c = 'test2 - Outpatient Independent Lab';            
            ab2.Benefit_Type__c = 'Benefit';
            ab2.Type__c = 'Benefit';
            ab2.Benefit_Record_Type__c = 'BRF';   
        //    ab2.Parent_Benefit__c = ab3.Id;
            ab2.CoInsurance_AmountValueSelected__c = '1000';
          	ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
         	 ab2.Copay_Type_1_IsCovered__c = 'Yes';    
          	ab2.Place_of_Service__c = 'Out-Patient';
          	ab2.Dummy_Parent_Benefit_Name__c = 'Ben2';
        
            lstBnft.add(ab2);
            insert lstBnft;
        
          AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.Id;
            Imp.Account__c = acc.Id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            insert Imp;  
            
           AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            aiaBD.Implementation__c = Imp.id;
            aiaBD.Account__c = acc.id;   
            aiaBD.Parent_Account__c = acc.id;  
      		aiaBD.Benefit_Request_Form__c = brf.id;
      		Test.startTest();
            insert aiaBD;
      
          bdp= new AIA_Benefit_Design_Product__c();
            bdp.Benefit_Design__c=aiaBD.id;
            //  bdp.RecordTypeId= QueryBase.getRecordtypeId('AIA_Benefit_Design_Product__c', rtype);
            bdp.Plan_Name__c=aiapln.id;
            bdp.Proposed_Products__c=pp.id;     
            // bdp.Funding_Arrangement__c = 'Risk';
            insert bdp;   
 
        	ag1 = new AIA_Grouper__c();
            ag1.Name = 'Additional Services';
            ag1.Group_Type__c = 'Benefit Group';
            ag1.Grouper_Record_Type__c = 'BDD';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag1.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();            
            ag1.Proposed_Products__c = pp.id;
          	ag1.Benefit_Design_Product__c = bdp.id;
            insert ag1;
        
            List < AIA_Benefits__c > BDlstBnft = new List < AIA_Benefits__c > ();
    /*      AIA_Benefits__c BDab3 = new AIA_Benefits__c();
            BDab3.Grouper__c = ag1.id;
            BDab3.Benefit_Name__c = 'test1';            
            BDab3.Benefit_Type__c = 'Limitation';
            BDab3.Type__c = 'Benefit';
            BDab3.Benefit_Record_Type__c = 'BRF';            
            BDlstBnft.add(BDab3); 
          
          AIA_Benefits__c BDab4 = new AIA_Benefits__c();
            BDab4.Grouper__c = ag1.id;
            BDab4.Benefit_Name__c = 'test2';            
            BDab4.Benefit_Type__c = 'Limitation';
            BDab4.Type__c = 'Benefit';
            BDab4.Benefit_Record_Type__c = 'BDD';            
            BDlstBnft.add(BDab4);  */
        
            AIA_Benefits__c BDab = new AIA_Benefits__c();
            BDab.Grouper__c = ag1.id;
            BDab.Benefit_Name__c = 'test1 - General General';
            BDab.Benefit_Type__c = 'Benefit';            
            BDab.Type__c = 'Benefit';
            BDab.Benefit_Record_Type__c = 'BDD';    
     	//	BDab.Parent_Benefit__c = BDab3.Id;        
            BDlstBnft.add(BDab);            
            
            AIA_Benefits__c BDab2 = new AIA_Benefits__c();
            BDab2.Grouper__c = ag1.id;
            BDab2.Benefit_Name__c = 'test2 - Outpatient Independent Lab';            
            BDab2.Benefit_Type__c = 'Benefit';
            BDab2.Type__c = 'Benefit';
            BDab2.Benefit_Record_Type__c = 'BDD';   
      	//	BDab.Parent_Benefit__c = BDab3.Id;        
            BDlstBnft.add(BDab2);
      
      		insert BDlstBnft;	
        
      		Limitations__c comments = AIA_TestUtil.createBenefitComentCode(bdp.Id, True ,'Comment');
      		Limitations__c MaxRows = AIA_TestUtil.createBenefitComentCode(bdp.Id, True ,'MaxRow');
         //  AIA_Benefits__c updatedBenefit = new AIA_Benefits__c(Id=ab.id);
         //  updatedBenefit.Sequence_Number__c =0;
        
    }    
}