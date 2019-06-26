/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
    **/
 /*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================

*06/08/2018    raj kiran      T01       Added code for role updates
02/08/2019		Chaithra	 |T02|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*==================================================================================

*******************************************************************************************************/
 
@isTest
Public class AIA_BRFTriggerHandler_Test{
    public static testmethod void createBRFFromPRF(){
        
        // Start Test
        Test.startTest();
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        
         User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        insert u4;


         User u5 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF355@testorg.com.test');
        insert u5;
        
        List<user> userList = new list<user>();
        user u8 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u8); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        insert userList;
                
         System.runAs(u) {           
        
            // Step 1 - Create Account
            Account a = AIA_TestUtil.AIA_createAccount();
            //Commenting as part of US210
             // Step 2 - create Work Plan Type
            //AIA_Workplan_Type__c wpt = AIA_TestUtil.createWPT1();
         
         //T02 commented
        /*AccountTeamMember atm3 = new AccountTeamMember ();
        atm3.TeamMemberRole = 'Underwriter';//T01
        atm3.AccountId = a.id;
        atm3.UserId = u4.id;
        insert atm3;  

        AccountTeamMember atm4 = new AccountTeamMember ();
        atm4.TeamMemberRole = 'MAST Tech';
        atm4.AccountId = a.id;
        atm4.UserId = u5.id;
        insert atm4;         
      
        AccountTeamMember atm5 = new AccountTeamMember ();
        atm5.TeamMemberRole = 'AIA User'; //T01 
        atm5.AccountId = a.id;
        atm5.UserId = u5.id;
        insert atm5;*/
             
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u7.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u8.id,'Proposal Specialist')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'Account Manager'));
        //T02 Starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'Underwriter'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'MAST Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'AIA User'));
        //T02 Ends
        insert acctMbrList;
        
            // Step 3 - Create Opportunity
            Opportunity o = AIA_TestUtil.CreateOpportunity(a.Id);//Updating as part of US210
            // Step 4 - Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);           
            
            try{
                // Step 5 -  Create BRF
                Benfit_Request_Form__c b = AIA_TestUtil.CreateBRF(p.Id,a.id);
                b.Escalated_to_Senior_Management__c = true;
                Update b;
            }catch(exception e ){
                RETURN;   
            } 
            
            // Verify that opportunity Id on BRF was populated from the opportunityId created in Step #2
            Benfit_Request_Form__c vbrf = [select Id,Proposal_Request_Form__r.Opportunity__c from Benfit_Request_Form__c where Proposal_Request_Form__c = :p.Id];
            system.assertequals(o.Id,vbrf.Proposal_Request_Form__r.Opportunity__c);
            
            // Add assert statement here
            Account va = [select Id,Name from Account Where Name = 'TestAccount' limit 1];
            system.assertequals('TestAccount',va.Name);
            
            Opportunity vo = [select Id,Name from Opportunity where Name = 'Testopp' limit 1];
            system.assertequals('Testopp',vo.Name);
            
            PRF__c vp = [select Id,Opportunity__c from PRF__c where Opportunity__c =: o.Id];
            // Test that opportunnity Id is populated from the PRF
            system.assertequals(o.Id,vp.Opportunity__c);
            // Test that accountId is populated
        
       }
       
       Profile pro1 = [SELECT Id FROM Profile WHERE Name='AIA RUL Custom'];
         
        User u1 = new User(Alias = 'TAlias', Email='TestUser3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro1.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUser3@testorg.com');
        
         System.runAs(u1) {           
        
            // Step 1 - Create Account
            Account a = AIA_TestUtil.CreateAccount('TestAccount');
            //Commenting as part of US210
             //step 2 - create work plan type
            //AIA_Workplan_Type__c wpt = AIA_TestUtil.createWPT1();
            // Step 3 - Create Opportunity
            Opportunity o = AIA_TestUtil.CreateOpportunity(a.Id);//Updating as part of US210
            // Step 4 - Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);           
                        
            try{
                // Step 5 -  Create BRF
                Benfit_Request_Form__c b = AIA_TestUtil.CreateBRF(p.Id,a.id);
            }catch(exception e ){
                RETURN;   
            } 
            
            // Verify that opportunity Id on BRF was populated from the opportunityId created in Step #2
            Benfit_Request_Form__c vbrf = [select Id,Proposal_Request_Form__r.Opportunity__c from Benfit_Request_Form__c where Proposal_Request_Form__c = :p.Id];
            system.assertequals(o.Id,vbrf.Proposal_Request_Form__r.Opportunity__c);
            
            // Add assert statement here
            Account va = [select Id,Name from Account Where Name = 'TestAccount'limit 1];
            system.assertequals('TestAccount',va.Name);
            
            Opportunity vo = [select Id,Name from Opportunity where Name = 'Testopp' limit 1];
            system.assertequals('Testopp',vo.Name);
            
            PRF__c vp = [select Id,Opportunity__c from PRF__c where Opportunity__c =: o.Id];
            system.assertequals(o.Id,vp.Opportunity__c);
        
       }
       // Stop Test
       Test.stopTest();
   }
    public static testmethod void negativeTestToValidateBRF(){
            // Step 1 - Create Account
            Account a = AIA_TestUtil.CreateAccount('TestAccount');
            //Commenting as part od US210
            //step 2 - create Workplan type
            //AIA_Workplan_Type__c wpt = AIA_TestUtil.createWPT1();
            // Step 3 - Create Opportunity
            Opportunity o = AIA_TestUtil.CreateOpportunity(a.Id);//Updating as part of US210
            // Step 4 - Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);           
            
            // Start Test
            Test.startTest();
            
            try{
                // Step 5 -  Create BRF
                Benfit_Request_Form__c b = AIA_TestUtil.CreateBRF(p.Id,a.id);
              //  AIA_TestUtil.createAIADocument(b);
                AIA_Document__c fileNetDoc = new AIA_Document__c();
                fileNetDoc.Document_Type__c='Signed Quote';
                fileNetDoc.Approval_Status__c='Approved';
                fileNetDoc.Benefit_Request_Form__c = b.id;
                insert fileNetDoc;
                b.ARC_Approval_Status__c = 'Approved by Committee';
                b.Status__c='Sold';
                update b;
            }catch(exception e ){
                test.stopTest();
            }
    }
    
     static testmethod void testCreateImplementation(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        
        List <user> userlist= new List<User>();
        //List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();//t02
        List<Account_Team__c> AccountTeamMemberList= new List<Account_Team__c>();//t02
        
        User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com.test');
        userlist.add(u1);
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF2@testorg.com.test');
         userlist.add(u2);
        
        User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
         userlist.add(u3);
         insert userlist;
             try{

                test.StartTest();
                 
       Account acc = AIA_TestUtil.CreateAccount('TestAccount');
         //T02 commented       
       /*AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'BeneFact Coder';
        atmRole.AccountId = acc.id;
        atmRole.UserId = u1.id;
       AccountTeamMemberList.add(atmRole);
        
        AccountTeamMember atm1 = new AccountTeamMember ();
        atm1.TeamMemberRole = 'Ancillary Analyst';
        atm1.AccountId =acc.id;
        atm1.UserId = u2.id;
       AccountTeamMemberList.add(atm1);
        
       
        
        AccountTeamMember atmRole2 = new AccountTeamMember ();
        atmRole2.TeamMemberRole = 'NASCO Benefit Coder';
        atmRole2.AccountId = acc.id;
        atmRole2.UserId = u3.id;
       AccountTeamMemberList.add(atmRole2);*/
                 Account_Team__c atmRole =new Account_Team__c();
                 atmRole.UserId__c=u3.id;
                 atmRole.TeamMemberRole__c='BeneFact Coder';
                 atmRole.AccountId__c =acc.id;
                 AccountTeamMemberList.add(atmRole);
                insert AccountTeamMemberList;
      
                opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);
                //PRF__c prf =AIA_TestUtil.CreatePRF(opp.id);
                Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
                brf.Account__c = acc.id;
                brf.Opportunity__c = opp.id;
                brf.Contract_Count__c = 123;
                brf.Benefit_Effective_Date__c = system.today();
                brf.Renewal_Date__c = system.today();
                AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = false;
                brf.Status__c='Sold';
                insert brf;
                     Test.stopTest();
                AIA_TestUtil.createAIADocument(brf);
                //brf =AIA_TestUtil.updateBRF(prf.id,acc.id,brf.id);
                brf.Contract_Count__c = 123;
                brf.Benefit_Effective_Date__c = system.today();             
                brf.ARC_Approval_Status__c = 'Approved by Committee';
                brf.Escalated_to_Senior_Management__c = true;
                brf.Status__c = 'Sold';
                update brf;
               // CF_CustomPermissionsReader_Helper.Permissions.skipBRFVRs = false;
               AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = false;
                brf.Contract_Count__c = 123;
                update brf;
                }
                
                catch(exception e){}
        }
    
     public static testmethod void testCaseBrokerNameUpdate(){
     
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        system.assertNotEquals(null,user.id);
        User u = AIA_TestUtil.createTestUser();
          
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);          

        User user2 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF2@testorg.com1');
        insert user2;        
        system.assertNotEquals(null,user2.id);

        
        System.runAs(u) { 
            // Create Account
            try{
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';            
            update a;
            
         
            /*AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Underwriter'; //T01
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user1.id;*/
            Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=user1.id;
                 atmRole1.TeamMemberRole__c='Underwriter';
                 atmRole1.AccountId__c =a.id;   
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);
            
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr= new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            // Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);  
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Submit_to_Underwriting__c= true;
            nbrf.Request_Type__c = 'Off-Cycle - Administrative and Benefit Change';
            AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
            nbrf.Opportunity__c = o.id;
            nbrf.Proposal_Request_Form__c = p.Id;
            nbrf.Status__c = 'Sold';
            test.startTest();
            insert nbrf;
            AIA_Document__c fileNetDoc = new AIA_Document__c();
            fileNetDoc.Document_Type__c='Signed Quote';
            fileNetDoc.Approval_Status__c='Approved';
            fileNetDoc.Benefit_Request_Form__c = nbrf.id;
            insert fileNetDoc;
            system.assertNOTEquals(fileNetDoc,Null);    
    
            Attachment att=AIA_TestUtil.createAttachment(fileNetDoc.Id); 
            system.assertNOTEquals(att,Null);
            update nbrf;
           
            Benfit_Request_Form__c nbrf2 = new Benfit_Request_Form__c();
            nbrf2.Contract_Count__c = 123;
            nbrf2.Benefit_Effective_Date__c = system.today();
            nbrf2.Account__c = a.id;
            //nbrf2.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf2.Escalated_to_Senior_Management__c = true;
            nbrf2.Status__c = AIA_Constants.sold;
            nbrf2.Source_Benefit_Request_Form__c=nbrf.id;
            AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = false;
            nbrf2.Request_Type__c='Prospect/New';
            nbrf2.Opportunity__c = o.id;

            insert nbrf2;
            
            
            List<AIA_Implementation__c> impl = new List<AIA_Implementation__c>();
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Benefit_Request_Form__c=nbrf.id;
            Imp.status__c = AIA_Constants.NotStarted;
            Imp.Risk_Type__c='ASO';
            impl.add(Imp);
            
            AIA_Implementation__c Imp2 = new AIA_Implementation__c();
            Imp2.Name__c = 'testprf';
            Imp2.Opportunity__c = o.id;
            Imp2.Generate_Workplan_Stages__c = true;
            Imp2.Effective_Date__c = system.today();
            Imp2.Implementation_Plan_Timeline_Days__c = '60';
            Imp2.Generate_Workplan_Stages__c = true;
            Imp2.Benefit_Request_Form__c=nbrf.id;
            Imp2.status__c = AIA_Constants.InProgress;
            Imp2.Risk_Type__c='ASO';
            impl.add(Imp2);
            
            AIA_Implementation__c Imp1 = new AIA_Implementation__c();
            Imp1.Name__c = 'testprf';
            Imp1.Opportunity__c = o.id;
            Imp1.Generate_Workplan_Stages__c = true;
            Imp1.Effective_Date__c = system.today();
            Imp1.Implementation_Plan_Timeline_Days__c = '60';
            Imp1.Generate_Workplan_Stages__c = true;
            Imp1.Benefit_Request_Form__c=nbrf.id;
            Imp1.status__c = AIA_Constants.NotStarted;
            Imp1.Risk_Type__c='ASO';
            impl.add(Imp1);
            insert impl;
           
            Benfit_Request_Form__c nbrft = [select id,name,Broker_Consultant_Name__c from Benfit_Request_Form__c where id=:nbrf.id];
            Benfit_Request_Form__c brf=[select id,Status__c,Opportunity__c,Account__c,request_type__c,(select id,Benefit_Request_Form__c,status__c,opportunity__c,opportunity__r.name, Opportunity__r.description from Implementations__r) from Benfit_Request_Form__c where id =:nbrf.id];
            List<Benfit_Request_Form__c> nbrfl=new List<Benfit_Request_Form__c>();
            nbrfl.add(nbrf);
            test.stopTest();
            }
            catch(Exception e)
            {}
        }
 }
   public static testmethod void brfwithPRF()
   {
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u3 =AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);
       user u4 =AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);
        insert userlist;
            

                test.StartTest();
                 
                Account acc = AIA_TestUtil.CreateAccount('TestAccount');
                system.assertNotEquals(acc,null);
                 //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
                 List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
                acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Manager')); 
                acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Account Executive')); 
                acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Proposal Specialist')); 
                acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Implementation Manager')); 
                insert acctMbrList;
                
       
      
                opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);
                system.assertNotEquals(opp,null);
                PRF__c prf = new PRF__c();
        		prf.Name = 'testprf';
        		prf.Opportunity__c = opp.id;
        		prf.Alt_Network_State__c = 'MD';
        		prf.CDH_Administrator__c = 'ConnectYourCare';
        		prf.Medical_Networks__c = 'Alternative Networks';
        		prf.Medical_Products__c = 'CDH';
        		prf.CDH_Products__c = 'Blue Preferred';
        		prf.CDH_Addl_Info__c = 'Test';
        		prf.CDH_Funding_Arrangement__c = 'HSA';
        		insert prf;
                system.assertNotEquals(prf,null);
                Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
                brf.Request_Type__c = 'Prospect/New';
                brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
                brf.Contract_Count__c = 123;
                brf.Benefit_Effective_Date__c = system.today();
                brf.Account__c = acc.id;
                brf.Escalated_to_Senior_Management__c = true;
                brf.Status__c = 'New';
                brf.Opportunity__c = opp.id;
                brf.Jurisdiction__c = 'MD';
                brf.Enrollment_Type__c = 'Cafeteria';
                //brf.MHP_Test_Result__c = 'Pass';
                brf.EGWP_Picklist__c = 'Yes';
                brf.FlexLink_Picklist__c = 'Yes';
                brf.Benefit_Effective_Date__c = system.today();
                brf.Benefit_Period__c = 'Contract';
                brf.Control_Plan__c = '690';
                brf.Sales_Segment_Size__c = 'Commercial 200-999';
                brf.Contract_Period__c = 'Standard - 12 Months';
                brf.Grandfathered_Status__c = 'Non-Grandfathered';
                brf.Grandfathered_PPACA_Status__c = 'Yes';
                brf.Stop_Loss__c = 'Carefirst';
                brf.Broker_Consultant_Compensation__c = 'Commission (%)';
                brf.Broker_Consultant_Amount__c = 50;
                brf.Identity_Protection__c = 'Yes';
                brf.Enrollment_Type__c = 'Parallel';
                brf.Funding_Arrangements__c = 'ASO';
                
                insert brf;
                system.assertNotEquals(brf,null);
                     Test.stopTest();
                
                //Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                
                AIA_Document__c aiaDoc = new AIA_Document__c();
                aiaDoc.Document_Type__c='Signed Quote';
                aiaDoc.Approval_Status__c='Approved';
                aiaDoc.Benefit_Request_Form__c = brf.id;
                insert aiaDoc;
                Map<id,Benfit_Request_Form__c> oldBRFMap = new Map<id,Benfit_Request_Form__c>();
                oldBRFMap.put(brf.Id,brf);
                brf.Proposal_Request_Form__c = prf.id;
                brf.ARC_Approval_Status__c = 'Approved by Committee';
                brf.Status__c = 'Sold';
                update brf;
                List<Benfit_Request_Form__c> brfLst = new List<Benfit_Request_Form__c>();
                brfLst.add(brf);
                Map<id,Benfit_Request_Form__c> newBRFMap = new Map<id,Benfit_Request_Form__c>();
                newBRFMap.put(brf.Id,brf);
       			system.assertNotEquals(prf.Opportunity__c,null);
       			system.assertNotEquals(brf.Proposal_Request_Form__c,null);
       			system.assertEquals(brf.Proposal_Request_Form__c,prf.Id);
       			AIA_BRFTriggerHandler.updateOpportunityOnBRF(brfLst);
                AIA_BRFTriggerHandler.ValidateSoldBRF(brfLst,newBRFMap,oldBRFMap);
                
                
        } 
   public static testmethod void brfwithPRF1()
   {
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u3 =AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);
       user u4 =AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);
        insert userlist;
            

                test.StartTest();
                 
                Account acc = AIA_TestUtil.CreateAccount('TestAccount');
                system.assertNotEquals(acc,null);
                 //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
                 List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
                acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Manager')); 
                acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Account Executive')); 
                acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Proposal Specialist')); 
                acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Implementation Manager')); 
                insert acctMbrList;
                
       
      
                opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);
                system.assertNotEquals(opp,null);
                Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
                brf.Request_Type__c = 'Prospect/New';
                brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
                brf.Contract_Count__c = 123;
                brf.Benefit_Effective_Date__c = system.today();
                brf.Account__c = acc.id;
                brf.Escalated_to_Senior_Management__c = true;
                brf.Status__c = 'New';
                brf.Opportunity__c = opp.id;
                brf.Jurisdiction__c = 'MD';
                brf.Enrollment_Type__c = 'Cafeteria';
                //brf.MHP_Test_Result__c = 'Pass';
                brf.EGWP_Picklist__c = 'Yes';
                brf.FlexLink_Picklist__c = 'Yes';
                brf.Benefit_Effective_Date__c = system.today();
                brf.Benefit_Period__c = 'Contract';
                brf.Control_Plan__c = '690';
                brf.Sales_Segment_Size__c = 'Commercial 200-999';
                brf.Contract_Period__c = 'Standard - 12 Months';
                brf.Grandfathered_Status__c = 'Non-Grandfathered';
                brf.Grandfathered_PPACA_Status__c = 'Yes';
                brf.Stop_Loss__c = 'Carefirst';
                brf.Broker_Consultant_Compensation__c = 'Commission (%)';
                brf.Broker_Consultant_Amount__c = 50;
                brf.Identity_Protection__c = 'Yes';
                brf.Enrollment_Type__c = 'Parallel';
                brf.Funding_Arrangements__c = 'ASO';
                
                insert brf;
                system.assertNotEquals(brf,null);
                     Test.stopTest();
                AIA_Document__c aiaDoc = new AIA_Document__c();
                aiaDoc.Document_Type__c='Signed';
                aiaDoc.Approval_Status__c='Approved';
                aiaDoc.Benefit_Request_Form__c = brf.id;
                insert aiaDoc;
                Map<id,Benfit_Request_Form__c> oldBRFMap = new Map<id,Benfit_Request_Form__c>();
                oldBRFMap.put(brf.Id,brf);
                brf.ARC_Approval_Status__c = 'Approved by Committee';
                brf.Status__c = 'Sold';
                update brf;
                List<Benfit_Request_Form__c> brfLst = new List<Benfit_Request_Form__c>();
                brfLst.add(brf);
                Map<id,Benfit_Request_Form__c> newBRFMap = new Map<id,Benfit_Request_Form__c>();
                newBRFMap.put(brf.Id,brf);
       			AIA_BRFTriggerHandler.ValidateSoldBRF(brfLst,newBRFMap,oldBRFMap);
                
                
        } 
        
}