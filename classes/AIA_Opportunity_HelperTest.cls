/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================
* 7/19/2018   |     Paritosh          |     Initial Creation
*==================================================================================

*******************************************************************************************************/

@isTest
public class AIA_Opportunity_HelperTest {



    @testSetup
    public static void testSetup(){
        //Test.startTest();
        final List<user> userList = new list<user>();
        //final List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        final List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u1);
        userList.add(u2);
        userList.add(u3);
        insert userList;
        
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        acc.Has_Sub_Groups__c = true;
        
        //Sub Group Account
        Account subGroupAcc = AIA_TestUtil.CreateAccount('SubGroup');
        subGroupAcc.ParentId = acc.id;
        
        update new List<Account> {acc,subGroupAcc};
      
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
       
        test.starttest();
         //system.assertEquals(limits.getQueries(),0);
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'New';
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
        brf.AIA_Approval_Status__c=true;
        brf.ARC_Approval_Status__c='Approved by Committee';
        insert brf;
        
        AIA_Plan__c plan = AIA_TestUtil.CreateGSMPlan('Medical', 'Medical-1');
        
        Proposed_Products__c pp = AIA_TestUtil.createBRFProposedProducts(brf.id,plan.id,'Medical');
        pp.Sub_Group_Account__c = acc.id;
        pp.Benefit_Request_Form__c=brf.id;
        insert pp;
        
        //update BRF to Sold
        brf.Status__c = 'Sold';
        update brf;
        
        test.stopTest();

    }
    
    //test CreateImplementation when BRF has Sub Group Account
    @isTest 
    public static void testCreateImplementationBRFSubGroup(){
        
        test.startTest();
       //Proposed_Products__c pp=[select id,name from Proposed_Products__c limit 1];
        //add Sub Group Account to BRF
        Benfit_Request_Form__c brf = [Select Sub_Group_Account__c from Benfit_Request_Form__c limit 1];
        Account subGroupAcc = [select id from Account where name='SubGroup'];
        brf.Sub_Group_Account__c = subGroupAcc.id;
        brf.Submit_to_ARC_Approval__c=false;
         brf.Request_Type__c = 'Off-Cycle - Administrative Change';
         brf.Request_Type__c='Set-up Change - Administrative Changes';
         brf.Status__c = 'Sold';
        update brf;
        
        //pp.Benefit_Request_Form__c=brf.id;
        //update pp;
       
        //update opportunity to Sold
        Opportunity opp = [select Id, System__c from opportunity where name = 'Test Opportunity' limit 1];
        opp.System__c = 'NASCO';
        opp.StageName = 'Sold';
        
        update opp;
        
        
       
        test.stopTest();
    }
    
    //test CreateImplementation when Proposed Product has Sub Group Account
    @isTest
    public static void testCreateImplementationPPSubGroup(){
        
        test.startTest();
        
        //Our PP already have subgroup account

        //update opportunity to Sold
        Opportunity opp = [select Id, System__c from opportunity where name = 'Test Opportunity' limit 1];
        opp.System__c = 'NASCO';
        opp.StageName = 'Sold';
        try{
        update opp;
        }catch(Exception e){}
        test.stopTest();
    }
    
    //test case for AIA_Verify_AccountTeamMember when no account team members are there
    @isTest
    public static  void TEST_AIA_Verify_AccountTeamMember_NoMembers(){
        
        Test.startTest();
        
        //no account team members
        final List<AccountTeamMember> atms = [select id from AccountTeamMember];
        delete atms;
        
        //create BCC RUL Custom user
        Profile bccProfile = [select id from profile where name ='BCC RUL Custom' ];
        User bccUser = new User(alias = 'alias', email='alias' + '@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = bccProfile.Id, 
            timezonesidkey='Europe/London', username='alias6969'+'@test.com'
            );
        insert bccUser;
        
        //update opportunity as BCC RUL Custom user to get error
        System.runAs(bccUser){
            try  {
                Opportunity opp = [select Id, System__c from opportunity where name = 'Test Opportunity' limit 1];
                update opp;
            }
            catch (Exception e){}
        }
        
        Test.stopTest();

    }
    
    //test case for AIA_Verify_AccountTeamMember when duplicate Account Team Members
    @isTest
    public static  void AIA_Verify_AccountTeamMember_DuplicateMembers(){
        
        Test.startTest();
        
        Account acc = [select id from Account where name = 'TestAccount' limit 1];
        
        final List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u1);
        userList.add(u2);
        userList.add(u3);
        insert userList;

        //duplicate ALL
        //final List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        final List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,AIA_Constants.ACCOUNTEXECUTIVE)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,AIA_Constants.SALES_SERVICE_REP)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,AIA_Constants.PROPOSALSPECIALIST)); 
        insert acctMbrList;
        
        //create BCC RUL Custom user
        Profile bccProfile = [select id from profile where name ='BCC RUL Custom' ];
        User bccUser = new User(alias = 'alias', email='alias' + '@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = bccProfile.Id, 
            timezonesidkey='Europe/London', username='alias6969'+'@test.com'
            );
        insert bccUser;
        
        //update opportunity as BCC RUL Custom user to get error
        System.runAs(bccUser){
            try  {
                Opportunity opp = [select Id, System__c from opportunity where name = 'Test Opportunity' limit 1];
                update opp;
            }
            catch (Exception e){}
        }
        
        Test.stopTest();

    }
    
}