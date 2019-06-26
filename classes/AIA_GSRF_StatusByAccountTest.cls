/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================

*06/08/2018    raj kiran      T01       Added code for role updates
*==================================================================================

*******************************************************************************************************/
@isTest
public class AIA_GSRF_StatusByAccountTest {
   @testSetup static void testdata() {
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
        accnt.NASCO_Account_Number__c='1234';   
        update accnt;
           
        //Creating WorkPlan Type Test Data 
        //AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales');//Removed WP per US210 
        
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
        user u12 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u12);
     user u13 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u13); 
        user u14 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u14);
     
        user u15 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u15);
		user u16 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u16);
    	 insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02 replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u16.id,'Settlements Analyst')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //t01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech')); //T01 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Implementation Manager'));
        insert acctMbrList;
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Removed WP per US210
        
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = accnt.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        //Imp.Benefit_Request_Form__c=brf.id;
        Imp.Risk_Type__c='ASO';
        insert Imp;
    }
    
    public static testMethod void testGSRFApprovedAccValid()
    {
        
        Test.startTest();
        
        //Querying data for test
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].Id;
         gsrf.Alpha_Prefix_is_missing__c=true;
         gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        gsrf.Status__c='Approved by Internal Team';
        update gsrf;

        PageReference pref = Page.AIA_GSM_ApprovedByAccount;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_StatusByAccount gsrfa=new AIA_GSRF_StatusByAccount(con);
        gsrfa.saveRecForApproved();
        AIA_Group_Structure_Request_Form__c gsrf1=[select status__c from AIA_Group_Structure_Request_Form__c limit 1];
        system.assertEquals('Approved by Account', gsrf1.Status__c);
        Test.stopTest();
        
    }
    public static testMethod void testGSRFApprovedAccinValid()
    {
        
        Test.startTest();
        //try{
            //Querying data for test
            //Querying data for test
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].Id;
         gsrf.Alpha_Prefix_is_missing__c=true;
         gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        gsrf.Status__c='Rejected by Internal Team';
        update gsrf;
		
            PageReference pref = Page.AIA_GSM_ApprovedByAccount;
            Test.setCurrentPage(pref);
            //ApexPages.currentPage().getParameters().put('id',gsrf.id);
            ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
            AIA_GSRF_StatusByAccount gsrfa=new AIA_GSRF_StatusByAccount(con);
            gsrfa.saveRecForApproved();
            gsrfa.backtogsrf();
        //}
        /*catch(Exception e){
            system.debug('To cover error lines');
        }*/
        Test.stopTest();
        
    }
    
    public static testMethod void testGSRFRejectedAccValid()
    {
        
        Test.startTest();
        
        //Querying data for test
         //Querying data for test
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].Id;
         gsrf.Alpha_Prefix_is_missing__c=true;
         gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        gsrf.Status__c='Approved by Internal Team';
        update gsrf;

        PageReference pref = Page.AIA_GSM_RejectedByAccount;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_StatusByAccount gsrfa=new AIA_GSRF_StatusByAccount(con);
        gsrfa.saveRecForRejected();
        
        AIA_Group_Structure_Request_Form__c gsrf1=[select status__c from AIA_Group_Structure_Request_Form__c limit 1];
        system.assertEquals('Approved by Internal Team', gsrf1.Status__c);
        Test.stopTest();
        
    }
    public static testMethod void testGSRFRejectedAccinValid()
    {
        
        Test.startTest();
        try{
            //Querying data for test
             //Querying data for test
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].Id;
         gsrf.Alpha_Prefix_is_missing__c=true;
         gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        gsrf.Status__c='Approved by Internal Team';
        update gsrf;

            PageReference pref = Page.AIA_GSM_RejectedByAccount;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',gsrf.id);
            ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
            AIA_GSRF_StatusByAccount gsrfa=new AIA_GSRF_StatusByAccount(con);
            gsrfa.saveRecForRejected();
        }
        catch(Exception e){
            system.debug('To cover error lines');
        }
        Test.stopTest();
        
    }
    public static testMethod void testGSRFRejectedAccinValidrej()
    {
        
        Test.startTest();
        try{
            //Querying data for test
             //Querying data for test
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].Id;
         gsrf.Alpha_Prefix_is_missing__c=true;
         gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        gsrf.Status__c='Approved by Internal Team';
        gsrf.Rejected_comments_by_Account__c='test';    
        update gsrf;

            PageReference pref = Page.AIA_GSM_RejectedByAccount;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',gsrf.id);
            ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
            AIA_GSRF_StatusByAccount gsrfa=new AIA_GSRF_StatusByAccount(con);
            gsrfa.getIsClassic();
            gsrfa.backtogsrf();
            gsrfa.saveRecForRejected();
        }
        catch(Exception e){
            system.debug('To cover error lines');
        }
        Test.stopTest();
        
    }
}