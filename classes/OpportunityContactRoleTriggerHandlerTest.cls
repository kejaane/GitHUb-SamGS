/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================
* 7/18/2018   |     Paritosh          |     Initial Creation
*==================================================================================

*******************************************************************************************************/


@isTest
public class OpportunityContactRoleTriggerHandlerTest {

    
    @testSetup
    public static void testSetup(){
        
        final List<user> userList = new list<user>();
        //final List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
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

        Contact con = new Contact();
        con.RecordTypeId = QueryBase.getRecordtypeId('Contact', 'X51');
        con.AccountId = acc.id;
        con.LastName = 'Test Contact';
        con.Phone = '001';
        con.Email = 'test@test.com';
        
        insert con;
        
        Opportunity_Contact_Role__c oppContactRole = new Opportunity_Contact_Role__c();
        oppContactRole.Opportunity__c = opp.id;
        oppContactRole.Contact_Name__c = con.id;
        oppContactRole.Role__c = 'Primary Broker';
        insert oppContactRole;
        
    }
    
    @isTest
    public static void testDeleteUndelete() {
        
        test.startTest();
        
        Opportunity_Contact_Role__c oppRole = [select id from Opportunity_Contact_Role__c limit 1];
        delete oppRole;
        
        //delete with BCC RUL Custom profile
        Profile bccProfile = [select id from profile where name ='BCC RUL Custom' ];
        User bccUser = new User(alias = 'alias', email='alias' + '@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = bccProfile.Id, 
            timezonesidkey='Europe/London', username='alias6969'+'@test.com'
            );
        insert bccUser;
        
        Opportunity opp = [select id from Opportunity limit 1];
        Opportunity_Contact_Role__c oppContactRole2 = new Opportunity_Contact_Role__c();
        oppContactRole2.Opportunity__c = opp.id;
        insert oppContactRole2;
        
        System.runAs(bccUser){
            try {	delete oppContactRole2;	}
            catch(Exception e) {}
        }
        
        test.stopTest();
    }
    
    @isTest
    public static void testBeforeUpdate() {
        
        test.startTest();
        
        Opportunity_Contact_Role__c oppRole = [select id from Opportunity_Contact_Role__c limit 1];
        oppRole.Role__c = 'Consultant';
        update oppRole;
        
        test.stopTest();
    }
    
    @isTest
    public static void testExceptions() {
        
        test.startTest();
        
        Opportunity opp = [select id from Opportunity limit 1];
        Opportunity_Contact_Role__c oppContactRole2 = new Opportunity_Contact_Role__c();
        oppContactRole2.Opportunity__c = opp.id;
        insert oppContactRole2;
        
        try {
            oppContactRole2.Standard_Contact_Role_ID__c = null;
            update oppContactRole2;
        }
        catch(Exception e){}
        
        try{
            delete oppContactRole2;
        }
        catch(Exception e) {}
        
        test.stopTest();
    }
}