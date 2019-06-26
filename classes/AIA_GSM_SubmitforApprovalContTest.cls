/*=================================================================================================
* Date         : 09/25/2017
* Developer    : Raviteja
* Purpose      : US-86 This class function to test the "AIA_GSM_SubmitforApprovalController" class

*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+=============+=====+===================================================================
* 09/25/2017| Raviteja    |     | Initial Version
* 05/25/2018| Sajitha Y   | T01 | cover unlock string in else part
06/08/2018    raj kiran      T02       Added code for role updates
* 09/25/2018| Paritosh    | R1E1| Added new methods for coverage
*===========+============+=====+===================================================================
*/
@istest
public class AIA_GSM_SubmitforApprovalContTest {
       @testSetup static void testdata() {
           test.startTest();
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
        accnt.Account_Effective_Date__c=Date.today();   
        update accnt;
           
        //Creating WorkPlan Type Test Data 
        //AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales'); //Commented per US210
        
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
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u16.id,'Settlements Analyst')); //T02
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T02
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech')); //T02
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Implementation Manager'));
        insert acctMbrList;
        
        List<AccountTeamMember> acctMbrList1 = new List<AccountTeamMember>();
        acctMbrList1.add(AIA_TestUtil.SD_CreateStdAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst'));
        insert acctMbrList1;
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Updated per US210
           
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'New';
        brf.Account__c = accnt.id;
        brf.Opportunity__c = o.id;
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
           
           
      test.stopTest();
    }
    
    
    public static testMethod void testGSRFInsert()
    {
        
       
        
        //Querying data for test
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        // r1 AIA_Group_Structure__c groupStruct = new AIA_Group_Structure__c();
        //.AIA_Implementation__c = imp[0].id;
        //insert groupStruct;
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].id;
        gsrf.Alpha_Prefix_is_missing__c=true;
        gsrf.Status__c = 'Draft - New';
        gsrf.Processing_Type__c = 'Standard';
         string values = '580-DC zipcode range&690 for all others  ';
       gsrf.Par_Plan__c=values;
        // r1 gsrf.AIA_Group_Structure__c = groupStruct.id;
        //Inserting group structure request form
        insert gsrf;
                gsrf.Status__c = 'Assigned to MAST';
        update gsrf;
        system.debug('hello: '+system.Limits.getQueries());
        

        List<AIA_Group_Structure_Request_Form__c> gsrf1=[select id,Processing_Type__c,Alpha_Prefix_is_missing__c,status__c,Implementation__c,NASCO_Account_Number__c from AIA_Group_Structure_Request_Form__c limit 1];
Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
       // r1 gsrfp1.AIA_Group_Structure__c = groupStruct.id;
        insert gsrfp1;
        system.debug('hello1: '+system.Limits.getQueries());
         AIA_Group__c g1=new AIA_Group__c();
        g1.Group_Structure_Request_Form__c=gsrf.id;
        g1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g1.Employee_Status__c='Cobra';
         g1.Plan_Code__c='Plan code 580 for DC';
        // r1 g1.AIA_Group_Structure__c= groupStruct.id;
        insert g1;
        system.debug('hello2: '+system.Limits.getQueries());
         AIA_department__c d1=new AIA_department__c();
        d1.Group_Structure_Request_Form__c=gsrf.id;
        d1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        d1.Employee_Status__c='Cobra';
        //r 1d1.AIA_Group_Structure__c= groupStruct.id;
        insert d1;
        system.debug('hello3: '+system.Limits.getQueries());
        AIA_Package__c p1=new AIA_Package__c();
        p1.Group_Structure_Request_Form__c=gsrf.id;
        p1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        p1.Coverage_Levels__c='Standard';
        p1.Employee_Status__c='Cobra';
        //r1 p1.AIA_Group_Structure__c= groupStruct.id;
        insert p1;
        system.debug('hello4: '+system.Limits.getQueries());
        AIA_FACET_Group__c rec=new AIA_FACET_Group__c();
            rec.Name='DEP-1';
            rec.Group_Structure_Request_Form__c=gsrf.id;
            rec.Employee_Status__c='Cobra';
            rec.Product_Description_List__c='VISION';
        //r1 rec.AIA_Group_Structure__c= groupStruct.id;
            insert rec; 
        system.debug('hello5: '+system.Limits.getQueries());
        AIA_FACET_Sub_Group__c rec1=new AIA_FACET_Sub_Group__c();
            rec1.Name='DEP-1';
            rec1.Group_Structure_Request_Form__c=gsrf.id;
            rec1.Employee_Status__c='Cobra';
            rec1.Product_Description_List__c='VISION';
        //r1 rec1.AIA_Group_Structure__c= groupStruct.id;
            insert rec1; 
        system.debug('hello6: '+system.Limits.getQueries());
        AIA_FACET_Class__c packs=new AIA_FACET_Class__c();
                    packs.Name='DEP-1';
        packs.Group_Structure_Request_Form__c=gsrf.id;
        packs.Product_Description_other__c='test';
        //r1 packs.AIA_Group_Structure__c= groupStruct.id;
            packs.Employee_Status__c='Cobra';
            packs.Product_description__c='BLUEDENTAL PLUS';
            insert packs;
        system.debug('hello7: '+system.Limits.getQueries());
        system.debug('gsrf'+gsrf);
         Test.startTest();
        PageReference pref = Page.AIA_GSM_SubmitforApproval;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf1[0].id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf1[0]);
        AIA_GSM_SubmitforApprovalController gsrfa=new AIA_GSM_SubmitforApprovalController(con);
        gsrfa.getIsClassic();
        gsrfa.submitforapproval();
        gsrfa.backtogsrf();
        // T01 - Start
       //r1 gsrfa.getRelateddata(gsrf1[0].id,'Unlock'); 
        // T01 - End
        apexPages.currentPage().getParameters().put('id',gsrf1[0].id);
        ApexPages.StandardController con1 = new ApexPages.StandardController(gsrf1[0]);
        AIA_GSM_SubmitforApprovalController gsrfa1=new AIA_GSM_SubmitforApprovalController(con1);
        gsrfa1.submitforapproval();
        List<GSM_Approval_Response__c> gsrps=[select id from GSM_Approval_Response__c];
        List<AccountTeamMember> acctMbrList=[select id from AccountTeamMember];
      //system.assertEquals(1, gsrps.size()); 
       gsrf.Par_Plan__c='580-DC zipcode range;690 for all others'  ;
           AIA_GSM_GSRFTriggerHelper.parplanvalidation(new List<AIA_Group_Structure_Request_Form__c>{gsrf});
        Test.stopTest();
        
       
 
        
    }
     public static testMethod void testGSRFInserterr()
    {
        
        Test.startTest();
        try{
        //Querying data for test
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        set<string> accteamset = new set<string>();
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].id;
        gsrf.Alpha_Prefix_is_missing__c=true;
        gsrf.Status__c = 'Draft - New';
        gsrf.Processing_Type__c = 'Standard';
        string values = '580-DC zipcode range&690 for all others';
       gsrf.Par_Plan__c=values;
        //Inserting group structure request form
        insert gsrf;
                gsrf.Status__c = 'Assigned to MAST';
        update gsrf;

        List<AIA_Group_Structure_Request_Form__c> gsrf1=[select id,Processing_Type__c,Alpha_Prefix_is_missing__c,status__c,Implementation__c,NASCO_Account_Number__c from AIA_Group_Structure_Request_Form__c limit 1];
Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
       
        insert gsrfp1;
         AIA_Group__c g1=new AIA_Group__c();
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
        AIA_FACET_Group__c rec=new AIA_FACET_Group__c();
            rec.Name='DEP-1';
            rec.Group_Structure_Request_Form__c=gsrf.id;
            rec.Employee_Status__c='Cobra';
            rec.Product_Description_List__c='VISION';
            insert rec; 
        AIA_FACET_Sub_Group__c rec1=new AIA_FACET_Sub_Group__c();
            rec1.Name='DEP-1';
            rec1.Group_Structure_Request_Form__c=gsrf.id;
            rec1.Employee_Status__c='Cobra';
            rec1.Product_Description_List__c='VISION';
            insert rec1; 
        AIA_FACET_Class__c packs=new AIA_FACET_Class__c();
                    packs.Name='DEP-1';
        packs.Group_Structure_Request_Form__c=gsrf.id;
        packs.Product_Description_other__c='test';
        
            packs.Employee_Status__c='Cobra';
            packs.Product_description__c='BLUEDENTAL PLUS';
            insert packs; 
        system.debug('gsrf'+gsrf);
        PageReference pref = Page.AIA_GSM_SubmitforApproval;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',rec1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf1[0]);
        AIA_GSM_SubmitforApprovalController gsrfa=new AIA_GSM_SubmitforApprovalController(con);
        gsrfa.getIsClassic();
        gsrfa.submitforapproval();
        gsrfa.backtogsrf();
        AIA_GSM_SubmitforApprovalController gsa=new AIA_GSM_SubmitforApprovalController(con);
        accteamset= gsa.fetchAccountteammembers(imp[0].Id);
        gsa.createApprovalresponses(accteamset,rec1.id);
        List<GSM_Approval_Response__c> gsrps=[select id from GSM_Approval_Response__c];
        List<AccountTeamMember> acctMbrList=[select id from AccountTeamMember];
        //system.assertEquals(1, gsrps.size()); 
    }
        catch(Exception e){
            system.debug('exc'+e);
        }
        Test.stopTest();
 
        
    }
     public static testMethod void testGSRFInsertprocthpe()
    {
        
        Test.startTest();
        
        //Querying data for test
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].id;
        gsrf.Alpha_Prefix_is_missing__c=true;
        gsrf.Status__c = 'Draft - New';
        //gsrf.Processing_Type__c = 'Standard';
         string values = '580-DC zipcode range&690 for all others';
       gsrf.Par_Plan__c=values;
        //Inserting group structure request form
        insert gsrf;
                gsrf.Status__c = 'Assigned to MAST';
        update gsrf;
        
        List<AIA_Group_Structure_Request_Form__c> gsrf1=[select id,Processing_Type__c,Alpha_Prefix_is_missing__c,status__c,Implementation__c,NASCO_Account_Number__c from AIA_Group_Structure_Request_Form__c limit 1];

        system.debug('gsrf'+gsrf);
        PageReference pref = Page.AIA_GSM_SubmitforApproval;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf1[0].id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf1[0]);
        AIA_GSM_SubmitforApprovalController gsrfa=new AIA_GSM_SubmitforApprovalController(con);
        gsrfa.submitforapproval();
        gsrfa.backtogsrf();
        List<GSM_Approval_Response__c> gsrps=[select id from GSM_Approval_Response__c];
        List<AccountTeamMember> acctMbrList=[select id from AccountTeamMember];
        system.assertEquals(0, gsrps.size()); 
        Test.stopTest();
 
        
    }
    
    public static testMethod void testGSRFsubmitalphaNull()
    {
        
        Test.startTest();
        //del nasco number
        Account a=[select NASCO_Account_Number__c from Account];
        a.NASCO_Account_Number__c='';
        update a;
        //Querying data for test
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].id;
        gsrf.Alpha_Prefix_is_missing__c=false;
        gsrf.Status__c = 'Draft - New';
        gsrf.Processing_Type__c = 'Standard';
        string values = '580-DC zipcode range&690 for all others';
       gsrf.Par_Plan__c=values;
        //gsrf.Status__c='Approved';
        //Inserting group structure request form
        try{
            insert gsrf;
        }
        catch(Exception e){}
        
        List<AIA_Group_Structure_Request_Form__c> gsrf1=[select id,Processing_Type__c,Alpha_Prefix_is_missing__c,status__c,NASCO_Account_Number__c,Implementation__c from AIA_Group_Structure_Request_Form__c limit 1];

        system.debug('gsrf'+gsrf);
        PageReference pref = Page.AIA_GSM_SubmitforApproval;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',gsrf1[0].id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf1[0]);
        AIA_GSM_SubmitforApprovalController gsrfa=new AIA_GSM_SubmitforApprovalController(con);
        gsrfa.submitforapproval();
        
        PageReference pref1 = Page.AIA_GSM_SubmitforApproval;
        Test.setCurrentPage(pref1);
        ApexPages.currentPage().getParameters().put('id',gsrf1[0].id);
        ApexPages.StandardController con1 = new ApexPages.StandardController(gsrf1[0]);
        AIA_GSM_SubmitforApprovalController gsrfa1=new AIA_GSM_SubmitforApprovalController(con1);
        gsrfa1.submitforapproval();
        Test.stopTest();
 
        
    }
    
    
    //R1E1
    public static testmethod void  test_getRelateddata(){
         
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].id;
        gsrf.Alpha_Prefix_is_missing__c=true;
        gsrf.Status__c = 'Draft - New';
        gsrf.Processing_Type__c = 'Standard';
        string values = '580-DC zipcode range&690 for all others  ';
        gsrf.Par_Plan__c=values;
        insert gsrf;

        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        //gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        insert gsrfp1;

         AIA_Group__c g1=new AIA_Group__c();
        g1.Group_Structure_Request_Form__c=gsrf.id;
        g1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g1.Employee_Status__c='Cobra';
         g1.Plan_Code__c='Plan code 580 for DC';
        // r1 g1.AIA_Group_Structure__c= groupStruct.id;
        insert g1;
        system.debug('hello2: '+system.Limits.getQueries());
         AIA_department__c d1=new AIA_department__c();
        d1.Group_Structure_Request_Form__c=gsrf.id;
        d1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        d1.Employee_Status__c='Cobra';
        //r 1d1.AIA_Group_Structure__c= groupStruct.id;
        insert d1;
        system.debug('hello3: '+system.Limits.getQueries());
        AIA_Package__c p1=new AIA_Package__c();
        p1.Group_Structure_Request_Form__c=gsrf.id;
        p1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        p1.Coverage_Levels__c='Standard';
        p1.Employee_Status__c='Cobra';
        //r1 p1.AIA_Group_Structure__c= groupStruct.id;
        insert p1;
        system.debug('hello4: '+system.Limits.getQueries());
        AIA_FACET_Group__c rec=new AIA_FACET_Group__c();
            rec.Name='DEP-1';
            rec.Group_Structure_Request_Form__c=gsrf.id;
            rec.Employee_Status__c='Cobra';
            rec.Product_Description_List__c='VISION';
        //r1 rec.AIA_Group_Structure__c= groupStruct.id;
            insert rec; 
        system.debug('hello5: '+system.Limits.getQueries());
        AIA_FACET_Sub_Group__c rec1=new AIA_FACET_Sub_Group__c();
            rec1.Name='DEP-1';
            rec1.Group_Structure_Request_Form__c=gsrf.id;
            rec1.Employee_Status__c='Cobra';
            rec1.Product_Description_List__c='VISION';
        //r1 rec1.AIA_Group_Structure__c= groupStruct.id;
            insert rec1; 
        system.debug('hello6: '+system.Limits.getQueries());
        AIA_FACET_Class__c packs=new AIA_FACET_Class__c();
                    packs.Name='DEP-1';
        packs.Group_Structure_Request_Form__c=gsrf.id;
        packs.Product_Description_other__c='test';
        //r1 packs.AIA_Group_Structure__c= groupStruct.id;
            packs.Employee_Status__c='Cobra';
            packs.Product_description__c='BLUEDENTAL PLUS';
            insert packs;
        
        Test.startTest();
        AIA_GSM_SubmitforApprovalController.getRelateddata(gsrf.id,'lock');
        Test.stopTest();
    }
    
    public static testmethod void  test_getRelateddata2(){
         
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].id;
        gsrf.Alpha_Prefix_is_missing__c=true;
        gsrf.Status__c = 'Draft - New';
        gsrf.Processing_Type__c = 'Standard';
        string values = '580-DC zipcode range&690 for all others  ';
        gsrf.Par_Plan__c=values;
        insert gsrf;

        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        //gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        insert gsrfp1;

         AIA_Group__c g1=new AIA_Group__c();
        g1.Group_Structure_Request_Form__c=gsrf.id;
        g1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g1.Employee_Status__c='Cobra';
         g1.Plan_Code__c='Plan code 580 for DC';
        // r1 g1.AIA_Group_Structure__c= groupStruct.id;
        insert g1;
        system.debug('hello2: '+system.Limits.getQueries());
         AIA_department__c d1=new AIA_department__c();
        d1.Group_Structure_Request_Form__c=gsrf.id;
        d1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        d1.Employee_Status__c='Cobra';
        //r 1d1.AIA_Group_Structure__c= groupStruct.id;
        insert d1;
        system.debug('hello3: '+system.Limits.getQueries());
        AIA_Package__c p1=new AIA_Package__c();
        p1.Group_Structure_Request_Form__c=gsrf.id;
        p1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        p1.Coverage_Levels__c='Standard';
        p1.Employee_Status__c='Cobra';
        //r1 p1.AIA_Group_Structure__c= groupStruct.id;
        insert p1;
        system.debug('hello4: '+system.Limits.getQueries());
        AIA_FACET_Group__c rec=new AIA_FACET_Group__c();
            rec.Name='DEP-1';
            rec.Group_Structure_Request_Form__c=gsrf.id;
            rec.Employee_Status__c='Cobra';
            rec.Product_Description_List__c='VISION';
        //r1 rec.AIA_Group_Structure__c= groupStruct.id;
            insert rec; 
        system.debug('hello5: '+system.Limits.getQueries());
        AIA_FACET_Sub_Group__c rec1=new AIA_FACET_Sub_Group__c();
            rec1.Name='DEP-1';
            rec1.Group_Structure_Request_Form__c=gsrf.id;
            rec1.Employee_Status__c='Cobra';
            rec1.Product_Description_List__c='VISION';
        //r1 rec1.AIA_Group_Structure__c= groupStruct.id;
            insert rec1; 
        system.debug('hello6: '+system.Limits.getQueries());
        AIA_FACET_Class__c packs=new AIA_FACET_Class__c();
                    packs.Name='DEP-1';
        packs.Group_Structure_Request_Form__c=gsrf.id;
        packs.Product_Description_other__c='test';
        //r1 packs.AIA_Group_Structure__c= groupStruct.id;
            packs.Employee_Status__c='Cobra';
            packs.Product_description__c='BLUEDENTAL PLUS';
            insert packs;
        
        Test.startTest();
        AIA_GSM_SubmitforApprovalController.getRelateddata(gsrf.id,'open');
        Test.stopTest();
    }
    
    //R1E1 End

}