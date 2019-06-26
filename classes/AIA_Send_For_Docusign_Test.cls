/*=================================================================================================
* Date         : 11/08/2017
* Developer    : satya
* Purpose      : This class function is to test the AIA_Send_For_Docusign class.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 11/08/2017|  Satya    |     | Initial Version                                         
* 2/15/2018 |  Satya    | T01 | Added account team roles
06/08/2018    raj kiran   T02       Added code for role updates
* 06/14/2018 | Sajitha Y | T03 | Added system admin profile to increase coverage
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_Send_For_Docusign_Test {
    @testSetup static void testdata() {
        //Creating Account Test Data 
        
        AIA_Docusign_Document__c settings = new AIA_Docusign_Document__c(Name = 'ID',BAA_Document__c = 'a1963000001DK00',BAC_Document__c='a1963000001DK0A');
        
        insert settings;
            
            
        Account accnt = AIA_TestUtil.acc();
        
        
        //T01 changes start
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
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T02
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst')); //T02
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech')); //T02
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Implementation Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Proposal Specialist'));
        insert acctMbrList;
        //T01 changes end
        
        //Removed per US210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);*/
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Removed WP per US210
        
        //Creating benefit Request Form Test Data 
        /*Benfit_Request_Form__c brf = AIA_TestUtil.benForm(accnt.Id,o.id);
        brf.Implementation_Manager_Account_Team__c=u13.id;
        brf.Account_Executive_Account_Team__c=u14.id;
              
        update brf;*/
        
        
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
        
        
        
        //Creating AIA Plan Test Data 
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        //Creating Proposed Plan Test Data 
        Proposed_Products__c proPrd = AIA_TestUtil.proposedProduct(
            brf.id,aiapln.id);
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
        
    }
    
    
    public static testMethod void testMethod1()
    {
        //T03 - Start
       Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];  
       
       User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        insert u; 
        // T03 - End
        PageReference pgref = Page.AIA_SendForDocusign;
        Test.startTest();
        system.runAs(u){
        Test.setCurrentPage(pgref);

        AIA_Implementation__c imp = [select id from AIA_Implementation__c limit 1];
         AIA_Docusign_Document__c aiaDocSign = AIA_Docusign_Document__c.getValues('ID');
                  
        Apexpages.StandardController sc = new Apexpages.StandardController(imp);
        AIA_Send_For_Docusign sfa = new AIA_Send_For_Docusign(sc);
        sfa.sendToDocusign();
        sfa.Back();
        }
        Test.stopTest();
        
        
        AIA_GSM_GSRFHelperClass.hasSkipGSRFs_CustPerm=true;
        
    }
    
   public static testmethod void OppRenewaltest()
   {
   //T03 - start
     Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];  
       
       User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        insert u;
    //T03 - End   
        Test.startTest();
       system.runAs(u){
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
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T02
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Implementation Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Proposal Specialist'));
        insert acctMbrList;
       
       //Creating Opportunity Test Data   
       Opportunity o = AIA_TestUtil.AIA_createopportunity1(accnt.Id);
        
        //Creating benefit Request Form Test Data 
       /* Benfit_Request_Form__c brf = AIA_TestUtil.benForm(accnt.Id,o.id);
        brf.Implementation_Manager_Account_Team__c=u13.id;
        brf.Account_Executive_Account_Team__c=u14.id;
        update brf;*/
        
        //T01 changes start
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
        //T01 ends
        
        
        //Creating AIA Plan Test Data 
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        //Creating Proposed Plan Test Data 
        Proposed_Products__c proPrd = AIA_TestUtil.proposedProduct(
            brf.id,aiapln.id);
        //Creating Benefit Design Test Data  
        //AIA_Benefit_Design__c bd=AIA_TestUtil.cCreateBenefitDesignWImpFromBrf(accnt.id,o.id,brf.id);
        
        PageReference pgref = Page.AIA_SendForDocusign;
        
        Test.setCurrentPage(pgref);
        
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
        AIA_Docusign_Document__c aiaDocSign = AIA_Docusign_Document__c.getValues('ID');
                  
        Apexpages.StandardController sc = new Apexpages.StandardController(imp);
        AIA_Send_For_Docusign sfa = new AIA_Send_For_Docusign(sc);
        sfa.sendToDocusign();
        sfa.Back();
       }
        Test.stopTest();
        
    
   } 
}