/*=================================================================================================
* Date         : 28/08/2017
* Developer    : Raviteja
* Purpose      : This class function is to test the AIA_GSRF_Validation_Controller class.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 07/09/2017| Raviteja    	|     | Initial Version    
06/08/2018    raj kiran      T01       Added code for role updates
*07/11/2018 | Sajitha Y   	| T02 | Upadted to increase code covereage
*01-18-2019 | Chaithra 		| T03 | Created users for account team role as per US1702 and US1730
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_GSRF_AssignToMastControllerTest {
    @testSetup static void testdata() {
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
        //Creating WorkPlan Type Test Data 
        //AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales');//Commented per US210 
        
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
        //Creating User Test Data T03 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T03 ends
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech'));//T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Implementation Manager'));
		//Creating AccountMember Test Data T03 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u20.id,'Pharmacy Operations'));
		//T03 ends        
        insert acctMbrList;
        
        List<AccountTeamMember> acctMbrList1 = new List<AccountTeamMember>();
        acctMbrList1.add(AIA_TestUtil.SD_CreateStdAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst'));
        acctMbrList1.add(AIA_TestUtil.SD_CreateStdAccountTeamMember(accnt.Id,u7.id,'Settlements Analyst'));
        acctMbrList1.add(AIA_TestUtil.SD_CreateStdAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        insert acctMbrList1;
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Updated per US210
        //Creating benefit Request Form Test Data 
        Benfit_Request_Form__c brf = AIA_TestUtil.benForm(accnt.Id,o.id);
        //Creating AIA Plan Test Data 
        brf.Alternate_Networks_Requested__c=true;
        update brf;
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        //Creating Proposed Plan Test Data 
        Proposed_Products__c proPrd = AIA_TestUtil.proposedProduct(
            brf.id,aiapln.id);
        Test.startTest();
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
        
        /* r1 AIA_Group_Structure__c groupStruct = new AIA_Group_Structure__c();
        groupStruct.AIA_Implementation__c = Imp.Id;
        groupStruct.Account_Name__c = accnt.id;
        insert groupStruct;*/
        Test.stopTest();
    }
    
    
    public static testMethod void testGSRFAssigntoMastValid()
    {
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        Test.startTest();
        
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
            gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        gsrf.Status__c='Rejected by Internal Team';
        gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
        gsrf.Processing_Type__c='Standard';
        //Inserting group structure request form
        update gsrf;
        PageReference pref = Page.AIA_GSRF_AssignToMastVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_AssignToMastController gsrfa=new AIA_GSRF_AssignToMastController(con);
        gsrfa.saveRec();
        gsrfa.backtogsrf();
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
        //system.assertEquals(gsrf1.status__c,'Rejected by Internal Team');
       //system.assertEquals('Assigned to MAST',gsrf1.status__c);
        Test.stopTest();
        
    }
    public static testMethod void testGSRFAssigntoMastinValid()
    {
        
        Test.startTest();
        try{
            //Querying data for test
            List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
            AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
            gsrf.Implementation__c=bd[0].Implementation__c;
                gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
            gsrf.Status__c='Approved by Internal Team';
            //gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
            gsrf.Processing_Type__c='Standard';
            update gsrf;
            PageReference pref = Page.AIA_GSRF_AssignToMastVF;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',gsrf.id);
            ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
            AIA_GSRF_AssignToMastController gsrfa=new AIA_GSRF_AssignToMastController(con);
            gsrfa.saveRec();
            AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
            system.assertnotEquals(gsrf1.status__c,'Rejected by Internal Team');
        }
        catch(Exception e){
            system.debug('To cover error lines');
        }
        Test.stopTest();
        
    }
    
    //To cover assign to owner
     public static testMethod void testGSRFAssigntoOwnerValid()
    {
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        Test.startTest();
        
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
            gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        
        system.debug('gsrf'+gsrf);
        PageReference pref = Page.AIA_GSRF_AssigntoOwner;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_AssignToOwner gsrfa=new AIA_GSRF_AssignToOwner(con);
        gsrfa.saveRec();
        gsrfa.backtogsrf();
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
        system.assertEquals(gsrf1.status__c,'Draft - Incomplete');
        Test.stopTest();
        
    }
    public static testMethod void testGSRFAssigntoOwnerinValiderr()
    {
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        Test.startTest();
        
       try{
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        system.debug('gsrf'+gsrf);
        PageReference pref = Page.AIA_GSRF_AssigntoOwner;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id','gsrf.id');
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_AssignToOwner gsrfa=new AIA_GSRF_AssignToOwner(con);
        gsrfa.rec.Par_Plan__c='';
        
        gsrfa.saveRec();

        gsrfa.backtogsrf();
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
        system.assertEquals(gsrf1.status__c,'Assigned to MAST');
                   }
        catch(Exception e){
            system.debug('eee'+e);
        }
        Test.stopTest();
        
    }
      public static testMethod void testGSRFAssigntoOwnerinValid()
    {
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        Test.startTest();
       
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
        gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        system.debug('gsrf'+gsrf);
        PageReference pref = Page.AIA_GSRF_AssigntoOwner;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_AssignToOwner gsrfa=new AIA_GSRF_AssignToOwner(con);
        gsrfa.getIsClassic();
        gsrfa.saveRec();
        gsrfa.backtogsrf();
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
        system.assertEquals(gsrf1.status__c,'Awaiting Internal Approval');
        Test.stopTest();
        
    }
    
    public static testMethod void testGSRFAssigntoOwnerValidgsperror()
    {
        
        Test.startTest();
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
        gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        gsrf.Status__c='Rejected by Internal Team';
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        //Inserting group structure request form
        update gsrf;
          Id RecordTypeIdContact = Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
        system.debug('TestClass: '+RecordTypeIdContact);
        //r1 AIA_Group_Structure__c gsid = [select id from AIA_Group_Structure__c Limit 1];
        List<AIA_Group_Structure_Form_Product__c> gsrfps=new List<AIA_Group_Structure_Form_Product__c>();
        AIA_Group_Structure_Form_Product__c gsrfp = new AIA_Group_Structure_Form_Product__c();
        gsrfp.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp.Coverage_Level__c = 'Standard';
        gsrfp.Deductible__c = 'Two';
        gsrfp.recordtypeid = RecordTypeIdContact;
        //r1 gsrfp.AIA_Group_Structure__c = gsid.id;
        gsrfps.add(gsrfp);
        insert gsrfps;
        List<AIA_Group_Structure_Form_Product__c> gsps=[select id,Gsp_Opened__c from AIA_Group_Structure_Form_Product__c where Group_Structure_Request_Form__c =:gsrf.id];
        for(AIA_Group_Structure_Form_Product__c thisgsp:gsps){
            thisgsp.Group_Structure_Request_Form__c=gsrf.id;
            thisgsp.Gsp_Opened__c=false;
        }
       //update gsps;
        //system.debug('gsps'+gsps);
       PageReference pref = Page.AIA_GSRF_AssignToMastVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',RecordTypeIdContact);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_AssignToMastController gsrfa=new AIA_GSRF_AssignToMastController(con);
        gsrfa.getIsClassic();
        gsrfa.rec.Par_Plan__c='';
        gsrfa.saveRec();
        gsrfa.backtogsrf();
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
        system.assertEquals(gsrf1.status__c,'Rejected by Internal Team');
        Test.stopTest();  
    }
    
    public static testMethod void testGSRFAssigntoOwnerValidgsperror11()
    {
        
        Test.startTest();
        boolean allfilled = true;
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
        gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
        insert gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        gsrf.Status__c='Rejected by Internal Team';
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        //Inserting group structure request form
        update gsrf;
          Id RecordTypeIdContact = Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
        system.debug('TestClass: '+RecordTypeIdContact);
        //r1 AIA_Group_Structure__c gsid = [select id from AIA_Group_Structure__c Limit 1];
        List<AIA_Group_Structure_Form_Product__c> gsrfps=new List<AIA_Group_Structure_Form_Product__c>();
        AIA_Group_Structure_Form_Product__c gsrfp = new AIA_Group_Structure_Form_Product__c();
        gsrfp.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp.Coverage_Level__c = 'Standard';
        gsrfp.Deductible__c = 'Two';
        gsrfp.recordtypeid = RecordTypeIdContact;
        //r1 gsrfp.AIA_Group_Structure__c = gsid.id;
        gsrfps.add(gsrfp);
        insert gsrfps;
        List<AIA_Group_Structure_Form_Product__c> gsps=[select id,Gsp_Opened__c from AIA_Group_Structure_Form_Product__c where Group_Structure_Request_Form__c =:gsrf.id];
        for(AIA_Group_Structure_Form_Product__c thisgsp:gsps){
            thisgsp.Group_Structure_Request_Form__c=gsrf.id;
            thisgsp.Gsp_Opened__c=false;
        }
        //update gsps;
        //system.debug('gsps'+gsps);
       PageReference pref = Page.AIA_GSRF_AssignToMastVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_AssignToMastController gsrfa=new AIA_GSRF_AssignToMastController(con);
        gsrfa.getIsClassic();
        gsrfa.saveRec();
        gsrfa.backtogsrf();
        //r1 gsrfa.allfilled = true;
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
        //system.assertEquals(gsrf1.status__c,'Assigned to MAST');
        Test.stopTest();  
    }
    
    //To cover assign to owner
     public static testMethod void testGSRFAssigntoOwnerValidgsprequired()
    {
        
        Test.startTest();
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
        gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        gsrf.Status__c='Rejected by Internal Team';
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        //Inserting group structure request form
        update gsrf;
          Id RecordTypeIdContact = Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
        system.debug('TestClass: '+RecordTypeIdContact);
        //r1 AIA_Group_Structure__c gsid = [select id from AIA_Group_Structure__c Limit 1];
        List<AIA_Group_Structure_Form_Product__c> gsrfps=new List<AIA_Group_Structure_Form_Product__c>();
        AIA_Group_Structure_Form_Product__c gsrfp = new AIA_Group_Structure_Form_Product__c();
        gsrfp.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp.Coverage_Level__c = 'Standard';
        gsrfp.Deductible__c = 'Two';
        gsrfp.recordtypeid = RecordTypeIdContact;
        //r1 gsrfp.AIA_Group_Structure__c = gsid.id;
        gsrfps.add(gsrfp);
        insert gsrfps;
        List<AIA_Group_Structure_Form_Product__c> gsps=[select id,Gsp_Opened__c from AIA_Group_Structure_Form_Product__c where Group_Structure_Request_Form__c =:gsrf.id];
        for(AIA_Group_Structure_Form_Product__c thisgsp:gsps){
            thisgsp.Group_Structure_Request_Form__c=gsrf.id;
            thisgsp.Gsp_Opened__c=true;//T02
        }
        update gsps;
        //system.debug('gsps'+gsps);
       PageReference pref = Page.AIA_GSRF_AssignToMastVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_AssignToMastController gsrfa=new AIA_GSRF_AssignToMastController(con);
        gsrfa.getIsClassic();
        gsrfa.saveRec();
        gsrfa.backtogsrf();
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
        //system.assertEquals(gsrf1.status__c,'Assigned to MAST');
        Test.stopTest();  
    }
        
    
    //To cover assign to owner
     public static testMethod void testGSRFAssigntoOwnerValidgsp()
    {
        
        Test.startTest();
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
        gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
        insert gsrf;
        system.debug('testdata: '+gsrf.Status__c);
        gsrf.Status__c='Assigned to MAST';
        
        update gsrf;
        system.debug('testdata1: '+gsrf.Status__c);
        //gsrf.Status__c='Awaiting Internal Approval';
        //update gsrf;
        //gsrf.Status__c='Rejected by Internal Team';
        //gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        //gsrf.Processing_Type__c='Standard';
        //Inserting group structure request form
        update gsrf;
          
        //Id RecordTypeIdContact = Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
        Id RecordTypeIdContact = Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();
        system.debug('TestClass: '+RecordTypeIdContact);
        //r1 AIA_Group_Structure__c gsid = [select id from AIA_Group_Structure__c Limit 1];
        List<AIA_Group_Structure_Form_Product__c> gsrfps=new List<AIA_Group_Structure_Form_Product__c>();
        AIA_Group_Structure_Form_Product__c gsrfp = new AIA_Group_Structure_Form_Product__c();
        gsrfp.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp.Coverage_Level__c = 'Standard';
        gsrfp.Deductible__c = 'Two';
        gsrfp.recordtypeid = RecordTypeIdContact;
        //r1 gsrfp.AIA_Group_Structure__c = gsid.id;
        gsrfps.add(gsrfp);
        insert gsrfps;
        List<AIA_Group_Structure_Form_Product__c> gsps=[select id,Gsp_Opened__c from AIA_Group_Structure_Form_Product__c where Group_Structure_Request_Form__c =:gsrf.id];
        for(AIA_Group_Structure_Form_Product__c thisgsp:gsps){
            thisgsp.Group_Structure_Request_Form__c=gsrf.id;
            thisgsp.Gsp_Opened__c=true;
        }
        update gsps;
        system.debug('gsps'+gsps);
       PageReference pref = Page.AIA_GSRF_AssignToMastVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_AssignToMastController gsrfa=new AIA_GSRF_AssignToMastController(con);
        gsrfa.getIsClassic();
        gsrfa.saveRec();
        gsrfa.backtogsrf();
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
        system.assertEquals(gsrf1.status__c,'Assigned to MAST');
        Test.stopTest();  
    }
     public static testMethod void testGSRFAssigntoOwnerValidgsp1()
    {
        
        Test.startTest();
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
            gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        gsrf.Status__c='Rejected by Internal Team';
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        //Inserting group structure request form
        update gsrf;
          Id RecordTypeIdContact = Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
        system.debug('TestClass: '+RecordTypeIdContact);
        //r1 AIA_Group_Structure__c gsid = [select id from AIA_Group_Structure__c Limit 1];
        List<AIA_Group_Structure_Form_Product__c> gsrfps=new List<AIA_Group_Structure_Form_Product__c>();
        AIA_Group_Structure_Form_Product__c gsrfp = new AIA_Group_Structure_Form_Product__c();
        gsrfp.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp.Coverage_Level__c = 'Standard';
        gsrfp.Deductible__c = 'Two';
        gsrfp.recordtypeid = RecordTypeIdContact;
        //r1 gsrfp.AIA_Group_Structure__c = gsid.id;
        gsrfps.add(gsrfp);
        insert gsrfps;
        List<AIA_Group_Structure_Form_Product__c> gsps=[select id,Gsp_Opened__c from AIA_Group_Structure_Form_Product__c where Group_Structure_Request_Form__c =:gsrf.id];
        for(AIA_Group_Structure_Form_Product__c thisgsp:gsps){
            thisgsp.Group_Structure_Request_Form__c=gsrf.id;
            thisgsp.Gsp_Opened__c=true;
           //r1 thisgsp.AIA_Product_Terminated__c = false;
        }
        update gsps;
        system.debug('gsps'+gsps);
       
        Test.stopTest();  
    }
   public static testMethod void testGSRFAssigntoOwnerValidgsperror12()
    {
        
        Test.startTest();
        
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
        gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
        insert gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        update gsrf;
          Id RecordTypeIdContact = Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
        system.debug('TestClass: '+RecordTypeIdContact);
        //r1 AIA_Group_Structure__c gsid = [select id from AIA_Group_Structure__c Limit 1];
        List<AIA_Group_Structure_Form_Product__c> gsrfps=new List<AIA_Group_Structure_Form_Product__c>();
        AIA_Group_Structure_Form_Product__c gsrfp = new AIA_Group_Structure_Form_Product__c();
        gsrfp.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp.Deductible__c = 'Two';
        gsrfp.recordtypeid = RecordTypeIdContact;
        //r1 gsrfp.AIA_Group_Structure__c = gsid.id;
        gsrfps.add(gsrfp);
        insert gsrfps;
        List<AIA_Group_Structure_Form_Product__c> gsps=[select id,Gsp_Opened__c from AIA_Group_Structure_Form_Product__c where Group_Structure_Request_Form__c =:gsrf.id];
        for(AIA_Group_Structure_Form_Product__c thisgsp:gsps){
            thisgsp.Group_Structure_Request_Form__c=gsrf.id;
            thisgsp.Gsp_Opened__c=false;
        }
        update gsps;
        AccountTeamMember atm = [select id from AccountTeamMember where TeamMemberRole = 'Billing Tech' limit 1];
        delete atm;
        
        system.debug('gsps'+gsps);
        PageReference pref = Page.AIA_GSRF_AssignToMastVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_AssignToMastController gsrfa=new AIA_GSRF_AssignToMastController(con);
        gsrfa.saveRec();
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
        Test.stopTest(); 
        
    }
     public static testMethod void testGSRFAssigntoMastValidaccntteam()
    {
        
        Test.startTest();
        
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c,account__c from AIA_benefit_design__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
            gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
         gsrf.Status__c='Draft - New';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        gsrf.Status__c='Rejected by Internal Team';
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        //Inserting group structure request form
        update gsrf;
        List<AIA_Group_Structure_Form_Product__c> gsps=new List<AIA_Group_Structure_Form_Product__c>();
        Id medical=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();
        //r1 AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = medical;
        gsrfp1.Alpha_Prefix__c='tes';
        gsrfp1.Gsp_Opened__c=false;
        //r1 gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        gsps.add(gsrfp1);
        AIA_Group_Structure_Form_Product__c gsrfp2 = new AIA_Group_Structure_Form_Product__c();
        gsrfp2.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp2.Coverage_Level__c = 'Standard';
        gsrfp2.Deductible__c = 'Two';
        gsrfp2.recordtypeid = medical;
        gsrfp2.Alpha_Prefix__c='tes';
        gsrfp2.Gsp_Opened__c=false;
        //r1 gsrfp2.AIA_Group_Structure__c = Gstrc.id;
        gsps.add(gsrfp2);
        insert gsps;
        AccountTeamMember act=[select id from AccountTeamMember where accountid=:bd[0].account__c and TeamMemberRole ='Settlements Analyst' limit 1];
        delete act;
        PageReference pref = Page.AIA_GSRF_AssignToMastVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_AssignToMastController gsrfa=new AIA_GSRF_AssignToMastController(con);
        gsrfa.saveRec();
        gsrfa.backtogsrf();
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
        system.assertEquals(gsrf1.status__c,'Rejected by Internal Team');
        Test.stopTest();
        
    }
    public static testMethod void testGSRFAssigntoMastValidgsrfopened()
    {
        
        Test.startTest();
        
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
            gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        gsrf.Status__c='Awaiting Internal Approval';
        update gsrf;
        gsrf.Status__c='Rejected by Internal Team';
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        //Inserting group structure request form
        update gsrf;
        List<AIA_Group_Structure_Form_Product__c> gsps=new List<AIA_Group_Structure_Form_Product__c>();
        Id medical=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();
        //r1 AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = medical;
        gsrfp1.Alpha_Prefix__c='tes';
        //r1 gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        gsrfp1.Gsp_Opened__c=false;
        gsps.add(gsrfp1);
        AIA_Group_Structure_Form_Product__c gsrfp2 = new AIA_Group_Structure_Form_Product__c();
        gsrfp2.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp2.Coverage_Level__c = 'Standard';
        gsrfp2.Deductible__c = 'Two';
        gsrfp2.recordtypeid = medical;
        gsrfp2.Alpha_Prefix__c='tes';
        gsrfp2.Gsp_Opened__c=false;
        //r1 gsrfp2.AIA_Group_Structure__c = Gstrc.id;
        gsps.add(gsrfp2);
        insert gsps;
        
        PageReference pref = Page.AIA_GSRF_AssignToMastVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_AssignToMastController gsrfa=new AIA_GSRF_AssignToMastController(con);
        gsrfa.saveRec();
        gsrfa.backtogsrf();
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
        system.assertEquals(gsrf1.status__c,'Rejected by Internal Team');
        Test.stopTest();
        
    }
    public static testMethod void testGSRFAssigntoMastValid1()
    {
        
        Test.startTest();
        
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
            gsrf.Par_Plan__c='Plan code 780 for NJ;690-MD zipcode range&580 for all others';
        insert gsrf;
        gsrf.Status__c='Assigned to MAST';
        update gsrf;
        //gsrf.Status__c='Awaiting Internal Approval';
        //update gsrf;
        gsrf.Is_it_a_National_Account_With_Par_Plans__c = true;
        gsrf.Level_of_Participation__c='Full Service';
        //gsrf.Alternate_Networks_Requested__c = True;
        update gsrf;
        gsrf.Status__c='Rejected by Internal Team';
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        gsrf.Processing_Type__c='Standard';
        //Inserting group structure request form
        update gsrf;
        List<AIA_Group_Structure_Form_Product__c> gsps=new List<AIA_Group_Structure_Form_Product__c>();
        Id medical=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();

        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = medical;
        gsrfp1.Alpha_Prefix__c='tes';
       
        gsps.add(gsrfp1);
        AIA_Group_Structure_Form_Product__c gsrfp2 = new AIA_Group_Structure_Form_Product__c();
        gsrfp2.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp2.Coverage_Level__c = 'Standard';
        gsrfp2.Deductible__c = 'Two';
        gsrfp2.recordtypeid = medical;
        gsrfp2.Alpha_Prefix__c='tes';
       
        gsps.add(gsrfp2);
        PageReference pref = Page.AIA_GSRF_AssignToMastVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSRF_AssignToMastController gsrfa=new AIA_GSRF_AssignToMastController(con);
        gsrfa.saveRec();
        gsrfa.backtogsrf();
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,status__c from AIA_Group_Structure_Request_Form__c];
        system.assertEquals(gsrf1.status__c,'Rejected by Internal Team');
        Test.stopTest();
        
    }
    
}