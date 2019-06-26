/*=================================================================================================
* Date         : 03/22/2018
* Developer    : satya
* Purpose      : This class function is to test the AIA_Send_Customized_BAA_For_Docusign class.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 03/22/2018|  Satya    |     | Initial Version   
* 06/08/2018    raj kiran      	|T01|       Added code for role updates
* 01-18-2019 	Chaithra 		|T02| Created users for account team role as per US1702 and US1730
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_FeedItem_TriggerHelper_Test1 {
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
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T03 replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder'));T02 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst'));T02 
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
        
        //Commenting as part of Us210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);*/
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id); //Updated as part of US210      
         //Creating benefit Request Form Test Data 
        //Benfit_Request_Form__c brf = AIA_TestUtil.benForm(accnt.Id,o.id);
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = accnt.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'Both';
        brf.EGWP_Picklist__c = 'No';
        brf.FlexLink_Picklist__c = 'No';
        brf.Request_Type__c = 'RFP';
        brf.Benefit_Period__c= 'Contract';
        brf.Stop_Loss__c ='CareFirst';
        brf.Control_Plan__c= '690';
        brf.Sales_Segment_Size__c = 'Labor';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Mixed';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 
        brf.Contract_Count__c =5;
        brf.Identity_Protection__c= 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        brf.Implementation_Manager_Account_Team__c=u13.id;
        brf.Account_Executive_Account_Team__c=u14.id;
        insert brf;
        system.assertNOTEquals(brf,Null);
        Test.startTest();
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
        
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = accnt.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        
              
        
        AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
        
        
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA NCR Cases').getRecordTypeId();  
        Id devRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA Account Issue').getRecordTypeId();
        Id devRecordTypeId2 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA Benefit Design Cases').getRecordTypeId();    
        
        
        list<case> cslst = new list<case>();
        Case cs = new Case();
        cs.Status= 'New';
        cs.Origin = 'ILog';
        cs.Recordtypeid=devRecordTypeId;
        cs.Opportunity__c = o.id;
        cslst.add(cs);
        system.assertNOTEquals(cs,Null);
        
        Case cs1 = new Case();
        cs1.Status= 'In-Queue';
        cs1.Origin = 'Email';
        cs1.AccountId = accnt.id;
        cs1.Recordtypeid=devRecordTypeId1;
        cslst.add(cs1);
        
        Case cs2 = new Case();
        cs2.Status= 'Open';
        cs2.Origin = 'Web';
        cs2.Recordtypeid=devRecordTypeId2;
        cs2.AIA_Benefit_Design__c = aiaBD.id;
        cslst.add(cs2);
        
        Insert cslst;
        Test.stopTest();
         
    }
    
    
   
    
    
    public static testMethod void NCRcasetestMethod()
    {
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         
        User u1 = new User(Alias = 'TAlias25', Email='TestUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser@testorg.com.test');
        insert u1;
        
        Test.startTest();
        case cs = [Select id,Opportunity__c from case where RecordType.DeveloperName = 'AIA_NCR_Cases'];
        system.assertNOTEquals(cs.id,Null);
        
        Account accnt = [Select id from Account limit 1];
        
        system.runAS (u1) {
        
         FeedItem post1 = new FeedItem();
         post1.ParentId = accnt.id;
         post1.Body = 'hi AccountExecutive'; 
         insert post1;
         
         system.AssertEquals(post1.Body,'hi AccountExecutive');
                  
         FeedItem post2 = new FeedItem();
         post2.ParentId = cs.id;
         post2.Body = 'hi AccountExecutive'; 
         insert post2;     
         
         system.assertNotEquals(post2.id,null); 
              
        Test.stopTest(); 
        
        } 
    }
    
     public static testMethod void AccountCasetestMethod()
    {
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         
        User u1 = new User(Alias = 'TAlias25', Email='TestUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser@testorg.com.test');
        insert u1;
        
        Test.startTest();
        
        system.runAS (u1) {
        
        AIA_Document__c aiaDoc = [select id,Implementation__c from AIA_Document__c limit 1 ];
        system.assertNOTEquals(aiaDoc.id,Null); 
        
                        
        case cs = [Select id,AccountId from case where RecordType.DeveloperName = 'AIA_Account_Issue'];
        system.assertNOTEquals(cs.id,Null);
        
        
        
         list<FeedItem> Feedlst  = new list<FeedItem>();
                 
         FeedItem post1 = new FeedItem();
         post1.ParentId = aiaDoc.id;
         post1.Body = 'hi AccountExecutive'; 
         insert post1;
         //Feedlst.add(post1);   
         
         FeedItem post2 = new FeedItem();
         post2.ParentId = cs.id;
         post2.Body = 'hi AccountManager'; 
         insert post2;
        // Feedlst.add(post2);  
         
        // insert Feedlst;
         
        // system.AssertEquals(Feedlst.size(),2);   
              
        Test.stopTest();  
        
        }
    }
    
    
    public static testMethod void BDCasetestMethod()
    {
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         
        User u1 = new User(Alias = 'TAlias25', Email='TestUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser@testorg.com.test');
        insert u1;
        
        Test.startTest();
                        
        system.runAS (u1) {
                                     
        case cs = [Select id,AIA_Benefit_Design__c from case where RecordType.DeveloperName = 'AIA_BD_Cases'];
        system.assertNOTEquals(cs.id,Null);
        
                
         FeedItem post2 = new FeedItem();
         post2.ParentId = cs.id;
         post2.Body = 'hi AccountManager'; 
         insert post2;  
         system.assertNotEquals(post2.id,null);  
              
        Test.stopTest(); 
        
        } 
    }
    
    
    
}