/*===================================================================================================================
* Date       : 21/09/2017
* Developer  : Sajitha Y
* Purpose    : This is test class for AIA_GSRF_ACCRoleController
*                                 Update History
*                                 ---------------
* Date       |     Developer        | Tag |   Description
*============+============+=========================================================================================
* 21/09/2017 |     Sajitha Y        |     | Initial Version
*============+============+=========================================================================================
*/
@isTest
public class AIA_GSRF_ACCRoleControllerTest {
           @testSetup static void testdata() {
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
        accnt.NASCO_Account_Number__c='1234';   
        update accnt;
           
        //Creating WorkPlan Type Test Data 
        AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales'); 
        
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
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02 replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Implementation Manager'));
        insert acctMbrList;
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id,wpt.id);
        
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
        AIA_Drawloop_Package_ID__c dd=new AIA_Drawloop_Package_ID__c();       
               dd.Name='Group Structure Request Form';
               dd.DDP_ID__c='a19V0000001KEAe';
               insert dd;
    }
    // Test method to cover Validation if status not equal to Approved by Account
    public static testMethod void testAccRole()
    {
        
        Test.startTest();
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        //Inserting group structure request form
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
        gsrf.Status__c='Rejected by Account';
		update gsrf;
        PageReference pref = Page.AIA_GSRF_AccRoleVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_ACCRoleController gsrfcon=new AIA_GSRF_ACCRoleController(con);
        gsrfcon.custombuttonvalidation();
        
        AIA_Group_Structure_Request_Form__c gsrf1=[select status__c from AIA_Group_Structure_Request_Form__c limit 1];
        system.assertEquals('Rejected by Account', gsrf1.Status__c);
        Test.stopTest();
    }
    // Test method to cover status equal to Approved by Account
    public static testMethod void testAccRole1()
    {
        
        Test.startTest();
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        //Inserting group structure request form
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
        gsrf.Status__c='Approved by Account';
		update gsrf;
        PageReference pref = Page.AIA_GSRF_AccRoleVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_ACCRoleController gsrfcon=new AIA_GSRF_ACCRoleController(con);
        gsrfcon.custombuttonvalidation();
        
        AIA_Group_Structure_Request_Form__c gsrf1=[select status__c from AIA_Group_Structure_Request_Form__c limit 1];
        system.assertEquals('Approved by Account', gsrf1.Status__c);
        Test.stopTest();
    }
}