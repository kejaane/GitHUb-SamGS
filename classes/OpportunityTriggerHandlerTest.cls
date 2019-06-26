/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================
* 7/18/2018   |     Paritosh          |     Initial Creation
* 9/11/2018   |     RAJ KIRAN JV      |     Test Class issues Fix R1E1- 
*==================================================================================

*******************************************************************************************************/

@isTest
public class OpportunityTriggerHandlerTest {
    
    @testSetup
    public static void testSetup(){
        
        final List<user> userList = new list<user>();
        //final List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        final List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u1);
        userList.add(u2);
        userList.add(u3);
        insert userList;
        
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,AIA_Constants.ACCOUNTEXECUTIVE)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,AIA_Constants.SALES_SERVICE_REP)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,AIA_Constants.PROPOSALSPECIALIST)); 
        insert   acctMbrList;
        
        Opportunity opp = new opportunity();
        opp.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
        opp.AccountId = acc.id;
        opp.name = 'Test Opportunity';
        opp.SBU__c = 'Large';
        opp.Market_Segment_New__c = '1000+';
        opp.Division__c = 'Commercial Business';
        opp.Business_Type__c = 'New';
        opp.Effective_Date__c = Date.newInstance(2014, 10, 1);
        opp.CloseDate = opp.Effective_Date__c.addDays(-11);
        opp.Legal_Account_Name_Verified__c = true;
        opp.AE_Name__c = 'Test AE Name';
        opp.AM_Name__c = 'Test AM Name';
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        opp.type = 'Medical Only';
        opp.Underwriting_Entity__c = 'NCAS';
        opp.Risk_Non_Risk__c = 'Non-Risk';
        opp.StageName = 'RFP';
        opp.FullServiceProducer__c = 'Direct';
        insert opp;
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'Sold';
        brf.Account__c = acc.id;
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Request_Type__c = 'Renewal';
        brf.Benefit_Period__c = 'Calendar';
        brf.Control_Plan__c = '580';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Grandfathered'; 
        brf.Identity_Protection__c = 'No';
        brf.Broker_Commission__c = 3.5;
        brf.Contract_Count__c = 5;
        brf.Formulary__c = '1';
        brf.Maintenance_Choice__c = 'Mandatory';
        insert brf;
        
        Opportunity_Contact_Role__c oppContactRole = new Opportunity_Contact_Role__c();
        oppContactRole.Opportunity__c = opp.id;
        insert oppContactRole;
        
        FSP_GP__c gp = new FSP_GP__c();
        gp.Opportunity__c = opp.id;
        gp.Primary__c = true;
        insert gp;
        
        Partner__c partner = new Partner__c();
        partner.Opportunity__c = opp.id;
        //partner.Role__c = 'Actuary';
        partner.Role__c = 'Consultant';// added by raj for test class changes R1 E1
        
        insert partner;

    }
    
    @isTest
    public static void testBeforeUpdate(){
        
        test.startTest();
        
        Opportunity opp = [select Id, System__c from opportunity where name = 'Test Opportunity' limit 1];
        opp.System__c = 'NASCO';
        opp.StageName = 'Sold';
        opp.Effective_Date__c = Date.newInstance(2014, 10, 2);
        update opp;
        
        test.stopTest();
    }
    
    @isTest
    public static void testDeleteUndelete(){
        
        Opportunity opp = [select Id, System__c from opportunity where name = 'Test Opportunity' limit 1];
       
        test.startTest();
        delete opp;
        undelete opp;
        test.stopTest();
    }
    
}