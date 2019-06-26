/*=================================================================================================
* Date         : 09/25/2017
* Developer    : Raviteja
* Purpose      : US-86 This class function to test the "AIA_GSM_internalprocessHandler" class

*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    		Tag     Description
*===========+=============+=====+===================================================================
* 09/25/2017|	Raviteja    	|   | 	Initial Version
* 06/08/2018	raj kiran    	|T01| 	Added code for role updates
*01-18-2019 	Chaithra 		|T02| 	Created users for account team role as per US1702 and US1730
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_GSM_internalprocessHandlerTest {
      @testSetup static void testdata() {
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
        accnt.NASCO_Account_Number__c='1234';   
        update accnt;
        
        //Commenting as per US210
        /*Creating WorkPlan Type Test Data 
        AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales'); 
        */
        
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        /**/  userList.add(u2);
         user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
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
		user u16 = AIA_TestUtil.AIA_createUser('alias16');
        userList.add(u16);
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
        Test.startTest();
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02 replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Settlements Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u6.id,'Underwriter')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Settlements Analyst')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Automated Enrollment Tech')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Implementation Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u16.id,'AIA User'));
        //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
          insert acctMbrList;
          
         List<AccountTeamMember> acctMbrList1 = new List<AccountTeamMember>();
        acctMbrList1.add(AIA_TestUtil.SD_CreateStdAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst'));
        insert acctMbrList1;
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Updated as per US210
        //Creating benefit Request Form Test Data 
        Benfit_Request_Form__c brf = AIA_TestUtil.benForm(accnt.Id,o.id);
        
        //Creating Benefit Design Test Data  
        AIA_Benefit_Design__c bd=AIA_TestUtil.cCreateBenefitDesignWImpFromBrf(accnt.id,o.id,brf.id);
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
        bd.Implementation__c=Imp.id;
        update bd;
          Test.stopTest();
    }
    
     public static testMethod void testGSRFInsert()
    {
        
        Test.startTest();
        
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
        gsrf.Alpha_Prefix_is_missing__c=true;
         gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        //Inserting group structure request form
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
		update gsrf;
        List<AIA_Group_Structure_Request_Form__c> gsrf1=[select id,Processing_Type__c,Alpha_Prefix_is_missing__c,status__c,Implementation__c,NASCO_Account_Number__c from AIA_Group_Structure_Request_Form__c limit 1];

        system.debug('gsrf'+gsrf);
        PageReference pref = Page.AIA_GSM_SubmitforApproval;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf1[0].id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf1[0]);
        AIA_GSM_SubmitforApprovalController gsrfa=new AIA_GSM_SubmitforApprovalController(con);
        gsrfa.submitforapproval();
        GSM_Approval_Response__c g=new GSM_Approval_Response__c();
        g.Group_Structure_Request_Form__c=gsrf.id;
        insert g;
        
         List <GSM_Approval_Response__c> garlst = [select id,Response__c,Group_Structure_Request_Form__c,Approval_Type__c from GSM_Approval_Response__c where Group_Structure_Request_Form__c =: gsrf.id ];
        for(GSM_Approval_Response__c gresp:garlst){
            gresp.Response__c='Reject';
            gresp.Approval_Type__c='Internal';
            gresp.Comments__c='Reject test';
        }
		//AIA_GSM_internalprocessHandler.AfterUpdateRecursive=false;
        update garlst;
        List<AIA_Group_Structure_Request_Form__c> gsrf2=[select id,ownerid,Alpha_Prefix_is_missing__c,status__c,NASCO_Account_Number__c,Implementation__c from AIA_Group_Structure_Request_Form__c limit 1];
		system.assertEquals('Rejected by Internal Team',gsrf2[0].Status__c);
        
        
        Test.stopTest();
 
        
    }
     public static testMethod void testGSRFInsertdbl()
    {
        
        Test.startTest();
        
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
        gsrf.Alpha_Prefix_is_missing__c=true;
         gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        //Inserting group structure request form
        insert gsrf;
        
        gsrf.Status__c='Assigned to MAST';
		update gsrf;
        try{
        AIA_Group_Structure_Request_Form__c gsrf12=new AIA_Group_Structure_Request_Form__c();
        gsrf12.Implementation__c=bd[0].Implementation__c;
        gsrf12.Alpha_Prefix_is_missing__c=true;
         gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf12.Processing_Type__c='Standard';
        //Inserting group structure request form
        insert gsrf12;
        }catch(Exception e){
            system.debug('cover error liones');
        }
        List<AIA_Group_Structure_Request_Form__c> gsrf1=[select id,Processing_Type__c,Alpha_Prefix_is_missing__c,status__c,Implementation__c,NASCO_Account_Number__c from AIA_Group_Structure_Request_Form__c limit 1];

        system.debug('gsrf'+gsrf);
        PageReference pref = Page.AIA_GSM_SubmitforApproval;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf1[0].id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf1[0]);
        AIA_GSM_SubmitforApprovalController gsrfa=new AIA_GSM_SubmitforApprovalController(con);
        gsrfa.submitforapproval();
        GSM_Approval_Response__c g=new GSM_Approval_Response__c();
        g.Group_Structure_Request_Form__c=gsrf.id;
        insert g;
        
         List <GSM_Approval_Response__c> garlst = [select id,Response__c,Group_Structure_Request_Form__c,Approval_Type__c from GSM_Approval_Response__c where Group_Structure_Request_Form__c =: gsrf.id ];
        for(GSM_Approval_Response__c gresp:garlst){
            gresp.Response__c='Reject';
            gresp.Approval_Type__c='Internal';
            gresp.Comments__c='Reject test';
        }
		//AIA_GSM_internalprocessHandler.AfterUpdateRecursive=false;
        update garlst;
        List<AIA_Group_Structure_Request_Form__c> gsrf2=[select id,ownerid,Alpha_Prefix_is_missing__c,status__c,NASCO_Account_Number__c,Implementation__c from AIA_Group_Structure_Request_Form__c limit 1];
		system.assertEquals('Rejected by Internal Team',gsrf2[0].Status__c);
        Test.stopTest();
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
  public static testMethod void testGSRFLineInsert()
    {
        
        Test.startTest();
        
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
        gsrf.Alpha_Prefix_is_missing__c=true;
         gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        //Inserting group structure request form
        insert gsrf;
        
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        insert gsrfp1;
        
        AIA_Group__c g1=new AIA_Group__c();
        g1.Name='g1';
        g1.Group_Structure_Request_Form__c=gsrf.id;
        g1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g1.Employee_Status__c='Cobra';
        g1.Plan_Code__c='Plan code 580 for DC';
        insert g1;
        
        AIA_department__c d1=new AIA_department__c();
        d1.Group_Structure_Request_Form__c=gsrf.id;
        d1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        d1.Employee_Status__c='Cobra';
        insert d1;
        
        AIA_Package__c p1=new AIA_Package__c();
        p1.Group_Structure_Request_Form__c=gsrf.id;
        p1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        p1.Coverage_Levels__c='Standard';
        p1.Employee_Status__c='Cobra';
        insert p1;
        
        AIA_FACET_Class__c rec=new AIA_FACET_Class__c();
        rec.Name='DEP-1';
        rec.Employee_Status__c='Cobra';
        rec.Product_description__c='BLUEDENTAL PLUS';
        rec.Group_Structure_Request_Form__c=gsrf.id;
        insert rec;
        
        AIA_FACET_Group__c rec1=new AIA_FACET_Group__c();
        rec1.Name='DEP-1';
        rec1.Group_Structure_Request_Form__c=gsrf.id;
        rec1.Employee_Status__c='Cobra';
        rec1.Product_Description_List__c='VISION';
        insert rec1;
        
        AIA_FACET_Sub_Group__c rec2=new AIA_FACET_Sub_Group__c();
        rec2.Name='DEP-1';
        rec2.Group_Structure_Request_Form__c=gsrf.id;
        rec2.Employee_Status__c='Cobra';
        rec2.Product_Description_List__c='VISION';
        insert rec2;
        
        gsrf.Status__c='Assigned to MAST';
		update gsrf;
        List<AIA_Group_Structure_Request_Form__c> gsrf1=[select id,Processing_Type__c,Alpha_Prefix_is_missing__c,status__c,Implementation__c,NASCO_Account_Number__c from AIA_Group_Structure_Request_Form__c limit 1];

        system.debug('gsrf'+gsrf);
        PageReference pref = Page.AIA_GSM_SubmitforApproval;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf1[0].id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf1[0]);
        AIA_GSM_SubmitforApprovalController gsrfa=new AIA_GSM_SubmitforApprovalController(con);
        gsrfa.submitforapproval();
        GSM_Approval_Response__c g=new GSM_Approval_Response__c();
        g.Group_Structure_Request_Form__c=gsrf.id;
        insert g;
        
         List <GSM_Approval_Response__c> garlst = [select id,Response__c,Group_Structure_Request_Form__c,Approval_Type__c from GSM_Approval_Response__c where Group_Structure_Request_Form__c =: gsrf.id ];
        for(GSM_Approval_Response__c gresp:garlst){
            gresp.Response__c='Reject';
            gresp.Approval_Type__c='Internal';
            gresp.Comments__c='Reject test';
        }
		//AIA_GSM_internalprocessHandler.AfterUpdateRecursive=false;
        update garlst;
        List<AIA_Group_Structure_Request_Form__c> gsrf2=[select id,ownerid,Alpha_Prefix_is_missing__c,status__c,NASCO_Account_Number__c,Implementation__c from AIA_Group_Structure_Request_Form__c limit 1];
		system.assertEquals('Rejected by Internal Team',gsrf2[0].Status__c);
        AIA_GSM_internalprocessHelper.getRelateddata(gsrf.id,'lock');
        
        Test.stopTest();
 
        
    }

}