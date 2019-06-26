@isTest
public class AIA_GetBenefitRedirectionTest {
    
        @testSetup static void testdata() {

 // Creating Account Test data
        Account acc = new Account();
        acc.Name = 'TestAccount1';
        acc.Type = 'Customer';
        acc.RecordTypeId = QueryBase.getRecordtypeId('Account', 'X51');       
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        
        //Removed per US210
        //Creating WorkPlan Type Test Data 
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c(); 
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;*/
        
        //Creating User Test Data 
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
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
        user u10 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u10); 
        user u11 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u11);
    	user u12 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u12); 
        user u13 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u13);
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02 replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u13.id,'Implementation Manager'));
            insert acctMbrList;
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(acc.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
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
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(brf);
            
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            aiapln.Plan_Name__c='Test Plan';
            aiapln.Plan_Id__c='PLAN-Test';
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.Has_Benefit_Summary__c=true;
               
            insert aiapln;
      
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='ASO';
            pp.Plan_Name__c=aiapln.id;
            pp.Product_Category__c='Medical';
            pp.Blue_Rewards__c='Standard';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.Id;
             //pp.MHP_Test_Result__c='Pass';
             
              test.startTest();
             
              insert pp;
}
    public static testmethod void redirect(){
        Proposed_Products__c pp=[select id from Proposed_Products__c limit 1];
        //Creating Pagereferance
        PageReference pageRef = Page.AIA_GetBenefitRedirection;
        //Passing parameter of pagereferance
        pageRef.getParameters().put('Id', String.valueOf(pp.Id));
        //Testing the page
        Test.setCurrentPage(pageRef); 
        //Creating standared controller
        ApexPages.StandardController sc = new ApexPages.StandardController(pp);
        //Passing contoller to extention
        AIA_GetBenefitRedirection getred = new AIA_GetBenefitRedirection(sc);
        getred.redirectOld();
        getred.popUp();
        getred.redirect();
    }
    
}