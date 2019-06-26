/*****************************************************************************************************
*Date: 09-16-2016 
*Developer: Indira Das
*Purpose: AIADocumentAttachment test class fr BDF
*=========================================================================================
* Update History
* Date         Developer               Description
*==================================================================================
*09-16-2016    Indira Das             Initial Development
*09-25-2017    Sajitha Y      T01       Added Test method to cover GSRF code
*05-14-2018    Debaknti               Added Group Structure data from AIA_TestUtil class to fix the error on GSRF. 
*06-07-2018    raj kiran jv   T03     Added code for brf form valdiation for test class fail issue. 
*06/08/2018    raj kiran      T04     Added code for role updates
*01-17-2019	   Chaithra		  T05 	  Added roles to account team s part of US1702 and US1730
*02-04-2019	   Chaithra		  T06	  Added code for replacing standard AccountTeamMemeber as part of US6713
*==================================================================================

*******************************************************************************************************/


@isTest
private class AIADocumentAttachmentTest {
    
    
    static  testmethod void testupdateAIADocAttachmentid() {
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List <user> userlist= new List<User>();
        List<Account_Team__c> AccountTeamMemberList= new List<Account_Team__c>();
        //List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
        User user = new User(Alias = 'TAlias17', Email='TestUserBRF@testorg.com',
                             EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = pro.Id,
                             TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com12');
        
        User user2 = new User(Alias = 'TAlias13', Email='TestUserBRF@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = pro.Id,
                              TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com13');
        
        
        
        userlist.add(user);
        userlist.add(user2); 
        //T05 starts
        User u = AIA_TestUtil.AIA_createUser('alias10');
        userList.add(u);
        User u1 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u1);
        //T05 ends
        insert userlist;
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            
            
            /*AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = u1.id;
            AccountTeamMemberList.add(atmRole2);
            insert AccountTeamMemberList;*/ //T06 commneted
            Account_Team__c atmRole2 = new Account_Team__c ();
            atmRole2.TeamMemberRole__c = 'Contract Tech';
            atmRole2.AccountId__c =a.id;
            atmRole2.UserId__c = u1.id;
            AccountTeamMemberList.add(atmRole2);
            insert AccountTeamMemberList;
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            //create contact
            /*   contact c = AIA_TestUtil.createTestContactsAcc(a.id);
insert c; 

//add contact role for opp
OpportunityContactRole ocr= new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
insert ocr;
*/
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            //t03 start 
            
            nbrf.EGWP_Picklist__c = 'No';
            nbrf.FlexLink_Picklist__c = 'No';
            
            nbrf.Request_Type__c = 'Prospect/New';
            
            
            nbrf.Control_Plan__c = '580';
            nbrf.Benefit_Period__c = 'Calendar';
            
            nbrf.Sales_Segment_Size__c = 'commercial 200-999';
            nbrf.Contract_Period__c = 'Standard - 12 Months';
            
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Grandfathered_PPACA_Status__c = 'No';
            
            nbrf.Stop_Loss__c = 'CareFirst';
            nbrf.Funding_Arrangements__c = 'ASO';
            
            
            
            nbrf.Broker_Consultant_Compensation__c = 'Commission (%)';
            nbrf.Broker_Consultant_Amount__c = 5.0;
            
            nbrf.Contract_Count__c = 1.0;
            nbrf.Identity_Protection__c = 'No';
            
            nbrf.Enrollment_Type__c = 'Parallel';
            
            
            //t03 end
            
            insert nbrf;
            
            AIA_Plan__c plantest= AIA_TestUtil.CreateGSMPlan('Medical', 'Medical-1');
            AIA_Plan__c plantest2= AIA_TestUtil.CreateGSMPlan('Drug', 'Drug-1');
            
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest);
            planlist.add(plantest2);
            
            insert planlist;
            
            list<Proposed_Products__c> lstPP = new list<Proposed_Products__c>();
            Proposed_Products__c pp0= AIA_TestUtil.createBRFProposedProducts(nbrf.id, plantest.id, 'Medical');
            //Medical Risk
            pp0.Rider__c = 'None;';
            //insert pp0;
            lstPP.add(pp0);
            Proposed_Products__c pp1= AIA_TestUtil.createBRFProposedProducts(nbrf.id, plantest.id, 'Medical');
            pp1.Rider__c = 'None;';
            pp1.Related_Medical_Product__c=pp0.id;
            //insert pp1;
            lstPP.add(pp1);
            test.startTest(); 
            Proposed_Products__c pp= AIA_TestUtil.createBRFProposedProducts(nbrf.id, plantest.id, 'Medical');
            pp.Comments__c='Test Comment';
            pp.Account_Specified_Drug_Product_Name__c='Test Product Name';
            pp.Account_Specified_Medical_Product_Name__c='Test Medical Product Name';
            pp.Blue_Rewards__c='Standard';
            pp.BlueVision_Plus_Comments__c='Test Comment';
            pp.CDH__c='Yes';
            pp.CDH_Fund_Type__c='BlueFund';
            pp.CDH_Type__c='HSA';
            pp.Deductible__c='Stacked';
            pp.Dental_Product_Name__c='BlueDental Basic';
            // pp.Dental_Product_Options__c='PC-5 POS- basic dental services $5 per office visit with option to go OON';
            pp.Dental_Variables_by_Product__c='Deductible Applies to All Basic Services';
            pp.Drug_Product_Options__c='ASO No Drug';
            pp.Employer_Arrangement__c='Employer Sponsored';
            pp.Exchange_CDH_Fund_Type__c='BlueFund';
            pp.Exchange_CDH_Type__c='HSA';
            pp.Exchange_Package_Option__c='Dummy 1';
            pp.Funding_Arrangement__c='ASO';
            pp.FirstHelp__c = ' No';
            pp.Grandfathered_PPACA_Status__c='Yes';
            pp.Grandfathered_Status__c='Grandfathered';
            pp.Maintenance_Choic_Comments__c='Test Comment';
            pp.Medical_Plan_Comments__c='Test Comment';
            pp.Medical_Product_Name__c='BlueChoice HMO';
            pp.Medical_Product_Option__c='1';
            //pp.MHP_Test_Comments__c='Test Comment';
            //pp.MHP_Test_Completed_Date__c=DateTime.now()-5;
            //pp.MHP_Test_Result__c='Pass';
            pp.Out_of_Pocket_Max__c='Stacked';
            pp.Product_Line__c='HMO';
            pp.Product_Option__c='1';
            pp.Integrated_Non_Integrated__c='Integrated';
            pp.RX_OOP_Max_Integration__c='Integrated';
            pp.Standard_Network__c='Yes';
            pp.Vision_Product_Name__c='BlueVision Plus';
            pp.Related_Medical_Product__c=pp0.id;
            pp.Vision_Product_Options__c='Option A - $0 exam copay/12/12/24 month benefit period';
            pp.RecordTypeId=Schema.SObjectType.Proposed_Products__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
            pp.Integrated_Carved_Out_Vendor__c='CVS (Direct)';
            //pp.Cafeteria__c = True;
            pp.Rider__c='None;';
            //insert pp;
            lstPP.add(pp);
            try{
            insert lstPP;
            }catch(exception e){}
            // Create benefit design for opp with implementation .
            //  AIA_Benefit_Design__c bd= AIA_TestUtil.createBenefitDesign(o.id);
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            imp.Account__c=a.id;
            imp.Benefit_Request_Form__c=nbrf.id;
            
            insert Imp;
              
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            aiaBD.Implementation__c = Imp.id;
            aiaBD.Status__c='Approved';
            aiaBD.Account__c=a.id;
            aiaBD.Benefit_Request_Form__c=nbrf.id;
            
            insert aiaBD;
            
            //AIA_Benefit_Design_Product__c bdp=[select id,name from AIA_Benefit_Design_Product__c where Benefit_Design__c=:aiaBD.id limit 1];
            AIA_Benefit_Design_Product__c bdp=AIA_TestUtil.createBDProductsForBD(aiaBD, 'Medical', plantest.id, pp.id);
            // insert bdp;
            
            AIA_Benefit_Design_Form__c bdf= AIA_TestUtil.createBenefitDesignFormForBD(aiaBD, 'Domestic_Partner',null);
            bdf.Stand_Alone_Disease_Management__c = 'No';
            bdf.Stand_Alone_Wellness__c = 'No';
            upsert bdf;
            test.stopTest(); 
            AIA_Document__c aiadocBD=AIA_TestUtil.createAIADocument();
            aiadocBD.Benefit_Design__c=aiaBD.id;
            aiadocBD.Benefit_Design_Form__c=bdf.id;
            aiadocBD.Account__c=a.id;
            aiadocBD.Approval_Status__c='Pending';
            
            update aiadocBD;
            
            
            Attachment att=AIA_TestUtil.createAttachment(aiadocBD.Id);
            
            
            
            
        }
    }
    Static testmethod  void testupdateAIADocAttachmentidPP() {
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List <user> userlist= new List<User>();
        //List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();//T08
        List<Account_Team__c> AccountTeamMemberList= new List<Account_Team__c>();//T08
        User user = new User(Alias = 'TAlias17', Email='TestUserBRF@testorg.com',
                             EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = pro.Id,
                             TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com12');
        
        User user2 = new User(Alias = 'TAlias13', Email='TestUserBRF@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = pro.Id,
                              TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com13');
        
        
        userlist.add(user);
        userlist.add(user2);
        
        insert userlist;
        
        User u = AIA_TestUtil.createTestUser();
        
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            
            //T06 starts
            Account_Team__c atmRole2 = new Account_Team__c ();
            atmRole2.TeamMemberRole__c = 'Contract Tech';
            atmRole2.AccountId__c =a.id;
            atmRole2.UserId__c = user.id;
            insert AccountTeamMemberList;
            //T06 ends
            
            // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            

            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;    

//t03 start 
            
            nbrf.EGWP_Picklist__c = 'No';
            nbrf.FlexLink_Picklist__c = 'No';
            
            nbrf.Request_Type__c = 'Prospect/New';
            
            
            nbrf.Control_Plan__c = '580';
            nbrf.Benefit_Period__c = 'Calendar';
            
            nbrf.Sales_Segment_Size__c = 'commercial 200-999';
            nbrf.Contract_Period__c = 'Standard - 12 Months';
            
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Grandfathered_PPACA_Status__c = 'No';
            
            nbrf.Stop_Loss__c = 'CareFirst';
            nbrf.Funding_Arrangements__c = 'ASO';
            
            
            
            nbrf.Broker_Consultant_Compensation__c = 'Commission (%)';
            nbrf.Broker_Consultant_Amount__c = 5.0;
            
            nbrf.Contract_Count__c = 1.0;
            nbrf.Identity_Protection__c = 'No';
            
            nbrf.Enrollment_Type__c = 'Parallel';
            
            
            //t03 end           
            insert nbrf;
                        
            test.startTest();   
            AIA_Plan__c plantest= AIA_TestUtil.CreateGSMPlan('Medical', 'Medical-1');
            AIA_Plan__c plantest2= AIA_TestUtil.CreateGSMPlan('Drug', 'Drug-1');
            
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest);
            planlist.add(plantest2);
            
            insert planlist;
            
            Proposed_Products__c pp= AIA_TestUtil.createBRFProposedProducts(nbrf.id, plantest.id, 'Medical');
            try{
            insert pp;
            
            
            }catch(exception e){}
            
            AIA_Document__c aiadocBD=AIA_TestUtil.createAIADocument();
            aiadocBD.Benefit_Request_Form__c=nbrf.id;
            aiadocBD.Proposed_Products__c=pp.id;
            aiadocBD.Account__c=a.id;
            aiadocBD.Approval_Status__c='Approved';
            update aiadocBD;
            
            
            
            
            Attachment att=AIA_TestUtil.createAttachment(aiadocBD.Id);
            
            
            
            test.stopTest(); 
        }
    }
    //T01 - Start
       Static testmethod  void testupdateAIADocAttachmentidGSRF() {
         //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
        //Creating WorkPlan Type Test Data 
        AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales'); //Removed per US210 //Uncommented for R1 Deployment
        //Creating AIA Plan Test Data 
        //AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');//Commented for R1 Deployment
        
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
        user u12 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u12);
     user u13 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u13); 
        user u14 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u14);
     
        user u15 = AIA_TestUtil.AIA_createUser('alias15');
        userList.add(u15);
           user u16 = AIA_TestUtil.AIA_createUser('alias16');
        userList.add(u16);
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias19');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias20');
        userList.add(u20);
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T06
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();
       // acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder'));
       	acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u16.id,'Settlements Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T04
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst')); //T04
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech')); //T04
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Implementation Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Benefit Tester'));//T08
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u18.id,'Pharmacy Operations'));//T08
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u19.id,'Vision Analyst'));//T08
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u20.id,'Benefit Coder'));  //T08 
        insert acctMbrList;
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Removed WP per US210
        //Creating benefit Request Form Test Data 
        Benfit_Request_Form__c brf = AIA_TestUtil.benForm(accnt.Id,o.id);
        
        test.startTest();
        
        //Creating Proposed Plan Test Data 
        //Proposed_Products__c proPrd = AIA_TestUtil.proposedProduct(
            //brf.id,aiapln.id); // //Commented for R1 Deployment
        //Creating Implementation Test Data
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
        //Creating Group Structure
       // AIA_Group_Structure__c gs = AIA_TestUtil.createGs(Imp.id);//Commented for R1 Deployment
        
        // Creating Group Structure Request Form
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp.Id;
        gsrf.Alpha_Prefix_is_missing__c=true;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
       // gsrf.AIA_Group_Structure__c = gs.id; //Commented for R1 Deployment
        gsrf.Level_of_Participation__c ='Full Service'; // T03
        insert gsrf;
         
        
         AIA_Document__c aiadocBD=AIA_TestUtil.createAIADocument();
            aiadocBD.Group_Structure_Request_Form__c=gsrf.id;
            aiadocBD.Implementation__c=Imp.id;
            aiadocBD.Account__c=accnt.id;
            aiadocBD.Opportunity__c=o.Id;
            aiadocBD.Benefit_Request_Form__c=brf.id;
            update aiadocBD;
         Attachment att=AIA_TestUtil.createAttachment(aiadocBD.Id);
         test.stopTest(); 
    }
    // T01 - End
}