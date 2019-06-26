/*=================================================================================================
* Date         : 03/22/2018
* Developer    : satya
* Purpose      : This class function is to test the AIA_FeedItem_TriggerHelper Functionality.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 03/22/2018|  Satya    |     | Initial Version   
06/08/2018    raj kiran      T01       Added code for role updates
*01-18-2019 	Chaithra 		|T02| Created users for account team role as per US1702 and US1730
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_FeedItem_TriggerHelper_Test {
    @testSetup static void testdata() {
        //Creating Account Test Data 
        
                   
         Account accnt = AIA_TestUtil.acc();
        
        //Creating User Test Data 
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u9 = AIA_TestUtil.AIA_createUser('alias9');
        userList.add(u9);
        user u10 = AIA_TestUtil.AIA_createUser('alias10');
        userList.add(u10);
        user u11 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u11); 
        user u12 = AIA_TestUtil.AIA_createUser('alias12');
        userList.add(u12);
        user u13 = AIA_TestUtil.AIA_createUser('alias13');
        userList.add(u13);
        user u14 = AIA_TestUtil.AIA_createUser('alias14');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias15');
        userList.add(u15);
        //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();//T03
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T03 replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Implementation Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Proposal Specialist'));
        //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
        insert acctMbrList;
        
        //Commenting as part of US210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);*/
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Updated as part of US210       
        Test.startTest();
        //Creating benefit Request Form Test Data 
        Benfit_Request_Form__c brf = AIA_TestUtil.benefitForm(accnt.Id,o.id);
        system.assertNOTEquals(brf,Null);
        
        //Creating AIA Plan Test Data 
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        //Creating Proposed Plan Test Data 
        Proposed_Products__c proPrd = AIA_TestUtil.proposedProduct(brf.id,aiapln.id);
        //Creating Benefit Design Test Data  
        //AIA_Benefit_Design__c bd=AIA_TestUtil.cCreateBenefitDesignWImpFromBrf(accnt.id,o.id,brf.id);
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = accnt.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Benefit_Request_Form__c=brf.id;
        Imp.Risk_Type__c='ASO';
        insert Imp;
        Test.stopTest();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = accnt.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c = aiaBD.id;
        insert aiaBDP1;
        
              
         
    }
    
    
    public static testMethod void testMethod1()
    {
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User u1 = new User(Alias = 'TAlias25', Email='TestUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser@testorg.com.test');
        insert u1;
        
        system.runAS (u1) {
        
        Test.startTest();
        
        Opportunity opp = [select id from Opportunity limit 1];
        system.assertNOTEquals(opp.id,Null); 
        AIA_Implementation__c imp = [select id from AIA_Implementation__c limit 1];
        system.assertNOTEquals(imp.id,Null); 
               
         list<FeedItem> Feedlst  = new list<FeedItem>();
        
         FeedItem post = new FeedItem();
         post.ParentId = opp.id;
         post.Body = 'hi AccountTeam'; 
         //insert post;
         Feedlst.add(post); 
         
         FeedItem post1 = new FeedItem();
         post1.ParentId = imp.id;
         post1.Body = 'hi AccountManager'; 
         //insert post1;
        
         Feedlst.add(post1);  
         
         insert Feedlst;
         
         system.AssertEquals(Feedlst.size(),2); 
         system.AssertEquals(post1.Body,'hi AccountManager');
         system.AssertNotEquals(post.id,null);
              
        Test.stopTest();
        
    }
    }
    
    public static testMethod void testMethod2()
    {
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User u1 = new User(Alias = 'TAlias25', Email='TestUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser@testorg.com.test');
        insert u1;
        
        system.runAS (u1) {
        
        
        Test.startTest();
        
        Account acc = [select id from Account limit 1];
        system.assertNOTEquals(acc.id,Null); 
         
        Proposed_Products__c pp = [select id from Proposed_Products__c limit 1 ];
        system.assertNOTEquals(pp.id,Null); 
        
        list<FeedItem> Feedlst  = new list<FeedItem>();

         FeedItem post = new FeedItem();
         post.ParentId = acc.id;
         post.Body = 'hi AccountTeam'; 
         Feedlst.add(post); 
         
         FeedItem post1 = new FeedItem();
         post1.ParentId = pp.id;
         post1.Body = 'hi AccountExecutive'; 
         Feedlst.add(post1);
         insert Feedlst;
         
         system.AssertEquals(Feedlst.size(),2); 
         system.AssertNotEquals(post.id,null);
         system.AssertNotEquals(post1.id,null);
              
        
        Test.stopTest();  
       }
    }
    
     public static testMethod void testMethod3()
    {
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User u1 = new User(Alias = 'TAlias25', Email='TestUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser@testorg.com.test');
        insert u1;
        
        system.runAS (u1) {
        
        Test.startTest();
        
        Benfit_Request_Form__c brf = [select id from Benfit_Request_Form__c limit 1];
        system.assertNOTEquals(brf.id,Null); 
                
        
         FeedItem post = new FeedItem();
         post.ParentId = brf.id;
         post.Body = 'hi AccountTeam'; 
         insert post; 
         
         system.AssertNotEquals(post.id,null);
         system.AssertEquals(post.Body,'hi AccountTeam'); 
        
              
        Test.stopTest();  
       }
    }
    
    
    public static testMethod void testMethod4()
    {
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User u1 = new User(Alias = 'TAlias25', Email='TestUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser@testorg.com.test');
        insert u1;
        
        system.runAS (u1) {
        
        Test.startTest();
        
        AIA_Benefit_Design__c bd = [select id from AIA_Benefit_Design__c limit 1];
        system.assertNOTEquals(bd.id,Null); 
         
        AIA_Benefit_Design_Product__c bdp = [select id from AIA_Benefit_Design_Product__c limit 1 ];
        system.assertNOTEquals(bdp.id,Null); 
        
        list<FeedItem> Feedlst  = new list<FeedItem>();
        
         FeedItem post = new FeedItem();
         post.ParentId = bd.id;
         post.Body = 'hi AccountTeam'; 
         //insert post;
         Feedlst.add(post); 
         
         FeedItem post1 = new FeedItem();
         post1.ParentId = bdp.id;
         post1.Body = 'hi AccountExecutive'; 
         //insert post1;
         Feedlst.add(post1);   
         
        insert Feedlst;
         
        system.AssertEquals(Feedlst.size(),2); 
        system.AssertNotEquals(post.id,null);
        system.AssertNotEquals(post1.id,null);
              
        Test.stopTest();  
    }
   } 
    
    
}