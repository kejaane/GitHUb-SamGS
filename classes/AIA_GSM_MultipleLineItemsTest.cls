/*=================================================================================================
* Date         : 10/17/2017
* Developer    : Raviteja
* Purpose      : This class function is to test the AIA_GSRF_Validation_Controller class.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer         Tag     Description
*===========+=================+=====+===================================================================
* 10/17/2017| Raviteja        |     | Initial Version   
* 06/08/2018| raj kiran       | T01 | Added code for role updates
* 07/19/2018| Rajesh Nagandla | T02 | Added code for test coverage improvement
* 02/12/2019		Chaithra  | T03 | Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_GSM_MultipleLineItemsTest {
    
    public static Account accnt;
    public static Opportunity o;
    public static Benfit_Request_Form__c BRF;
    public static AIA_Implementation__c Imp;
   //public static AIA_Group_Structure__c Gstrc; r1
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
        user u16 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u16);
        user u17 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u17);
        //T03 starts
        user u19 = AIA_TestUtil.AIA_createUser('alias19');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias20');
        userList.add(u20);
        //T03 ends
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T03
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder'));T03 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); T03
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u16.id,'Settlements Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Implementation Manager'));
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Implementation PM'));
        //T03 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u20.id,'Pharmacy Operations'));
        //T03 ends
        insert acctMbrList;
         Test.startTest();
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Updated per US210
        
        Benfit_Request_Form__c BRF = new Benfit_Request_Form__c();
        BRF.Opportunity__c = o.id;
        BRF.Benefit_Effective_Date__c = system.today();
        BRF.Contract_Count__c = 14;
        BRF.Broker_Commission__c =31.0;
        BRF.Renewal_Date__c = system.today();
        BRF.Account__c = accnt.id;
        BRF.Funding_Arrangements__c = 'Risk';
        BRF.Request_Type__c='Prospect/New';
        BRF.Control_Plan__c ='580';
        BRF.Alternate_Networks_Requested__c=true;
        insert BRF;
        
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = accnt.id;
        //Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        //Imp.Benefit_Request_Form__c=brf.id;
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c =BRF.Id;
        insert Imp;
        
        Benfit_Request_Form__c BRF2 = new Benfit_Request_Form__c();
        BRF2.Opportunity__c = o.id;
        BRF2.Benefit_Effective_Date__c = system.today();
        BRF2.Contract_Count__c = 14;
        BRF2.Broker_Commission__c =31.0;
        BRF2.Renewal_Date__c = system.today();
        BRF2.Account__c = accnt.id;
        BRF2.Funding_Arrangements__c = 'Risk';
        BRF2.Request_Type__c='Renewal';
        BRF2.Control_Plan__c ='580';
        BRF2.Alternate_Networks_Requested__c=true;
        insert BRF2;
        
        AIA_Implementation__c Imp2 = new AIA_Implementation__c();
        Imp2.Name__c = 'testprf';
        Imp2.Opportunity__c = o.id;
        Imp2.Account__c = accnt.id;
        //Imp2.Generate_Workplan_Stages__c = true;
        Imp2.Effective_Date__c = system.today();
        Imp2.Implementation_Plan_Timeline_Days__c = '60';
        //Imp.Benefit_Request_Form__c=brf.id;
        Imp2.Risk_Type__c='ASO';
        Imp2.Benefit_Request_Form__c =BRF2.Id;
        insert Imp2;
        //system.debug('number of soql'+system.Limits.getQueries());
        /* R1
        
        
        AIA_Group_Structure__c Gstrc = new AIA_Group_Structure__c();
        Gstrc.Account_Name__c= accnt.id;
        Gstrc.AIA_Implementation__c = Imp.id;
        insert Gstrc;
        system.debug('number of soql'+system.Limits.getQueries());
        */
        /* r1 comment 
        AIA_Group_Number_Repository__c gnr = new AIA_Group_Number_Repository__c();
        gnr.AIA_Account__c = accnt.id;
        gnr.AIA_Control_Plan__c = '190';
        //gnr.AIA_Group_Structure__c = Gstrc.id;
        gnr.AIA_Number_of_Groups_Required__c = 2;
        insert gnr;
        
        */
        Test.stopTest();
    }
    
    public static testMethod void testGroupsInsertexc(){
        Test.startTest();
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
        // Gstrc =[select id from AIA_Group_Structure__c limit 1];
        Account accnt1 =[select id from Account limit 1];
        
        /* 
        AIA_Group_Structure__c Gstrc1 = new AIA_Group_Structure__c();
        Gstrc1.Account_Name__c= accnt1.id;
        Gstrc1.AIA_Implementation__c = Imp.id;
        //Gstrc1.Group_Structure_Request_Form__c =gsrf.id; 
        Gstrc1.AIA_GS_Type__c='Internal';
        insert Gstrc1;
         system.debug('Gstrc1: '+Gstrc1);
         */
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp.id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        //gsrf.AIA_Group_Structure__c=Gstrc2.id;
       
        insert gsrf;
        system.debug('gsrf: '+gsrf);
        // R1 AIA_Group_Structure_Request_Form__c Gstrc2 = [select id,AIA_Group_Structure__c from AIA_Group_Structure_Request_Form__c where id=:gsrf.id];
        AIA_Group_Structure_Request_Form__c Gstrc2 = [select id  from AIA_Group_Structure_Request_Form__c where id=:gsrf.id];
        
        system.debug('Gstrc2: '+Gstrc2);
        // r1 AIA_Group_Structure__c Gstrc3 = [select id from AIA_Group_Structure__c where id=:Gstrc2.AIA_Group_Structure__c]; r1
        //system.debug('Gstrc3: '+Gstrc3);
        //Gstrc3.AIA_GS_Type__c = 'Internal';
        //update Gstrc3;
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        //Id medical=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('medical').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        //gsrfp1.AIA_Group_Structure__c = Gstrc3.id; R1
        insert gsrfp1;
        system.debug('gsrfp1: '+gsrfp1);
        AIA_Group__c g1=new AIA_Group__c();
        // r1 g1.Group_Number__c='g1';
        g1.Group_Structure_Request_Form__c=gsrf.id;
        g1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g1.Employee_Status__c='Cobra';
        g1.Plan_Code__c='Plan code 580 for DC';
        //g1.AIA_Group_Structure__c = Gstrc3.id;
        insert g1;
        PageReference pref = Page.AIA_GSM_MultipleGroupAddVF;
        Test.setCurrentPage(pref);
        //r1 ApexPages.currentPage().getParameters().put('gsrfid',Gstrc3.id);
        ApexPages.currentPage().getParameters().put('gsrfid',Gstrc2.id);
        ApexPages.StandardController con = new ApexPages.StandardController(Gstrc2);
        AIA_GSM_MultipleGroupAdd gsrfa=new AIA_GSM_MultipleGroupAdd(con);
        AIA_Group__c g2=new AIA_Group__c();
        //r1g2.Group_Number__c='g2';
        g2.Group_Structure_Request_Form__c=gsrf.id;
        g2.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g2.Employee_Status__c='Cobra';
        g2.Plan_Code__c=null;
        // r1 g2.AIA_Group_Structure__c = Gstrc3.id;
        gsrfa.grps.clear();
        gsrfa.grps.add(g2);
        gsrfa.multipleRowsize=3;
        gsrfa.multipleRows();
        //r1 gsrfa.populateSaveRecord();
        gsrfa.removerow();
        gsrfa.rowToRemove =1;
        gsrfa.removeRowFromList();
        gsrfa.save();
        gsrfa.cancel();
        gsrfa.refresh();
        //r1 gsrfa.productsearch();
        //r1 gsrfa.src='External';
        gsrfa.cancel();
        //r1 gsrfa.src='External';
        //r1 gsrfa.groupExternalPopulate();
        
       Test.stopTest();
        
        
    }
    
    public static testMethod void testGroupsInsert(){
        Test.startTest();
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
        //AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp.id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        //gsrf.AIA_Group_Structure__c = Gstrc.id;
        insert gsrf;
        system.debug('number of soql'+system.Limits.getQueries());        
        system.debug('number of soql'+system.Limits.getQueries());
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        //gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        insert gsrfp1;
        system.debug('number of soql'+system.Limits.getQueries());
        PageReference pref = Page.AIA_GSM_MultipleGroupAddVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('gsrfid',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSM_MultipleGroupAdd gsrfa=new AIA_GSM_MultipleGroupAdd(con);
        AIA_Group__c g1=new AIA_Group__c();
        g1.Name='g1';
        g1.Group_Structure_Request_Form__c=gsrf.id;
        g1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g1.Employee_Status__c='Cobra';
        g1.Plan_Code__c='Plan code 580 for DC';
        //g1.AIA_Group_Structure__c = Gstrc.id;
        gsrfa.grps.clear();
        gsrfa.grps.add(g1);
        gsrfa.save();
        gsrfa.addrow();
        gsrfa.multipleRowsize=3;
        //gsrfa.multipleRows();
        gsrfa.removerow();
        gsrfa.rowToRemove=1;
        gsrfa.removeRowFromList();
        gsrfa.refresh();
        gsrfa.cancel();
        List <AIA_Group__c> grps=[select id from AIA_Group__c where Group_Structure_Request_Form__c=:gsrf.id];
        //system.assertEquals(1, grps.size());
        AIA_Group__c groups1=new AIA_Group__c();
        groups1.Group_Structure_Request_Form__c=gsrf.id;
        groups1.Employee_Status__c='test';
        try{
            
            gsrfa.save();
            Test.stopTest();
        }
        catch(Exception e){
            system.debug('to cover exceptins');
        }
        
    }
    public static testMethod void testGroupsInsert1(){
        //testdata();
        //BRF.Request_Type__c = 'Prospect/New';
        // update BRF;
        //Imp.Benefit_Request_Form__c = BRF.id;
        //update Imp;
        Test.startTest();
        
        Benfit_Request_Form__c BRF = [select id from Benfit_Request_Form__c limit 1];
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
        //AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        //Imp.Benefit_Request_Form__c = BRF.id;
        //Update Imp;
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp.id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        //gsrf.AIA_Group_Structure__c =Gstrc.id;
        insert gsrf;
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        //gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        insert gsrfp1;
        PageReference pref = Page.AIA_GSM_MultipleGroupAddVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('gsrfid',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSM_MultipleGroupAdd gsrfa=new AIA_GSM_MultipleGroupAdd(con);
        AIA_Group__c g1=new AIA_Group__c();
        g1.Name='g1';
        g1.Group_Structure_Request_Form__c=gsrf.id;
        g1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g1.Employee_Status__c='Cobra';
        g1.Plan_Code__c='Plan code 580 for DC';
        //g1.AIA_Group_Structure__c = Gstrc.id;
        gsrfa.grps.clear();
        gsrfa.grps.add(g1);
        gsrfa.save();
        gsrfa.addrow();
        gsrfa.multipleRowsize=3;
        //gsrfa.multipleRows();
        gsrfa.removerow();
        gsrfa.rowToRemove=1;
        gsrfa.removeRowFromList();
        gsrfa.refresh();
        gsrfa.cancel();
        List <AIA_Group__c> grps=[select id from AIA_Group__c where Group_Structure_Request_Form__c=:gsrf.id];
       // system.assertEquals(1, grps.size());
        AIA_Group__c groups1=new AIA_Group__c();
        groups1.Group_Structure_Request_Form__c=gsrf.id;
        groups1.Employee_Status__c='test';
        //groups1.AIA_Group_Structure__c = Gstrc.id;
        try{
            
            gsrfa.save();
            update grps;
            
            Test.stopTest();
            
        }
        catch(Exception e){
            system.debug('to cover exceptins');
        }
        
    }
    public static testMethod void testGroupsInsertduplicate(){
        Test.startTest();
        
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
        //AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp.id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        //gsrf.AIA_Group_Structure__c = Gstrc.id;
        insert gsrf;
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        //gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        insert gsrfp1;
        PageReference pref = Page.AIA_GSM_MultipleGroupAddVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('gsrfid',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSM_MultipleGroupAdd gsrfa=new AIA_GSM_MultipleGroupAdd(con);
        AIA_Group__c g2=new AIA_Group__c();
        g2.Name='g1';
        g2.Group_Structure_Request_Form__c=gsrf.id;
        g2.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g2.Employee_Status__c='Cobra';
        g2.Plan_Code__c='Plan code 580 for DC';
        //g2.AIA_Group_Structure__c = Gstrc.id;
        insert g2;
        AIA_Group__c g1=new AIA_Group__c();
        g1.Name='g1';
        g1.Group_Structure_Request_Form__c=gsrf.id;
        g1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g1.Employee_Status__c='Cobra';
        g1.Plan_Code__c='Plan code 580 for DC';
        //g1.AIA_Group_Structure__c = Gstrc.id;
        gsrfa.grps.clear();
        gsrfa.grps.add(g1);
        gsrfa.grps.add(g2);
        //gsrfa.save();
        gsrfa.addrow();
        gsrfa.multipleRowsize=3;
        //gsrfa.multipleRows();
        gsrfa.removerow();
        gsrfa.rowToRemove=1;
        gsrfa.removeRowFromList();
        gsrfa.refresh();
        gsrfa.cancel();
        List <AIA_Group__c> grps=[select id from AIA_Group__c where Group_Structure_Request_Form__c=:gsrf.id];
        system.assertEquals(1, grps.size());
        AIA_Group__c groups1=new AIA_Group__c();
        groups1.Group_Structure_Request_Form__c=gsrf.id;
        groups1.Employee_Status__c='test';
        //groups1.AIA_Group_Structure__c = Gstrc.id;
        try{
            
            gsrfa.save();
            delete g2;
            Test.stopTest();
            
        }
        catch(Exception e){
            system.debug('to cover exceptins');
        }
        
    }
    
    public static testMethod void testGroupsInsertduplicate2(){
        Test.startTest();
        Benfit_Request_Form__c br=[select id,name from Benfit_Request_Form__c limit 1];
        br.Request_Type__c='Renewal';
        update br;
        AIA_Implementation__c Imp2=[select id from AIA_Implementation__c limit 1];
        Imp2.Benefit_Request_Form__c=br.id;
        update Imp2;
        //AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp2.id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        //gsrf.AIA_Group_Structure__c = Gstrc.id;
        insert gsrf;
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        //gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        insert gsrfp1;
        PageReference pref = Page.AIA_GSM_MultipleGroupAddVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('gsrfid',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSM_MultipleGroupAdd gsrfa=new AIA_GSM_MultipleGroupAdd(con);
        AIA_Group__c g2=new AIA_Group__c();
        g2.Name='g1';
        g2.Group_Structure_Request_Form__c=gsrf.id;
        g2.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g2.Employee_Status__c='Cobra';
        g2.Plan_Code__c='Plan code 580 for DC';
        //g2.AIA_Group_Structure__c = Gstrc.id;
        insert g2;
        AIA_Group__c g1=new AIA_Group__c();
        g1.Name='g1';
        g1.Group_Structure_Request_Form__c=gsrf.id;
        g1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g1.Employee_Status__c='Cobra';
        g1.Plan_Code__c='Plan code 580 for DC';
        //g1.AIA_Group_Structure__c = Gstrc.id;
        gsrfa.grps.clear();
        gsrfa.grps.add(g1);
        gsrfa.grps.add(g2);
        //gsrfa.save();
        gsrfa.addrow();
        gsrfa.multipleRowsize=3;
        //gsrfa.multipleRows();
        gsrfa.removerow();
        gsrfa.rowToRemove=1;
        gsrfa.removeRowFromList();
        gsrfa.refresh();
        gsrfa.cancel();
        List <AIA_Group__c> grps=[select id from AIA_Group__c where Group_Structure_Request_Form__c=:gsrf.id];
        system.assertEquals(1, grps.size());
        AIA_Group__c groups1=new AIA_Group__c();
        groups1.Group_Structure_Request_Form__c=gsrf.id;
        groups1.Employee_Status__c='test';
        //groups1.AIA_Group_Structure__c = Gstrc.id;
        try{
            
            gsrfa.save();
            delete g2;
            Test.stopTest();
            
        }
        catch(Exception e){
            system.debug('to cover exceptins');
        }
        
    }
    public static testMethod void testGroupsInsertduplicatenot(){
        Test.startTest();
        
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
        //AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp.id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        //gsrf.AIA_Group_Structure__c = Gstrc.id;
        insert gsrf;
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        //gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        insert gsrfp1;
        PageReference pref = Page.AIA_GSM_MultipleGroupAddVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('gsrfid',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSM_MultipleGroupAdd gsrfa=new AIA_GSM_MultipleGroupAdd(con);
        AIA_Group__c g2=new AIA_Group__c();
        g2.Name='g1';
        g2.Group_Structure_Request_Form__c=gsrf.id;
        g2.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g2.Employee_Status__c='Cobra';
        g2.Plan_Code__c='Plan code 580 for DC';
        //g2.AIA_Group_Structure__c = Gstrc.id;
        insert g2;
        AIA_Group__c g1=new AIA_Group__c();
        g1.Name='g2';
        g1.Group_Structure_Request_Form__c=gsrf.id;
        g1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g1.Employee_Status__c='Cobra';
        g1.Plan_Code__c='Plan code 580 for DC';
        //g1.AIA_Group_Structure__c = Gstrc.id;
        gsrfa.grps.clear();
        gsrfa.grps.add(g1);
        gsrfa.save();
        gsrfa.addrow();
        gsrfa.multipleRowsize=3;
        //gsrfa.multipleRows();
        gsrfa.removerow();
        gsrfa.rowToRemove=1;
        gsrfa.removeRowFromList();
        gsrfa.refresh();
        gsrfa.cancel();
        List <AIA_Group__c> grps=[select id from AIA_Group__c where Group_Structure_Request_Form__c=:gsrf.id];
        system.assertEquals(2, grps.size());
        AIA_Group__c groups1=new AIA_Group__c();
        groups1.Group_Structure_Request_Form__c=gsrf.id;
        groups1.Employee_Status__c='test';
        //groups1.AIA_Group_Structure__c = Gstrc.id;
        try{
            
            gsrfa.save();
            Test.stopTest();
            
        }
        catch(Exception e){
            system.debug('to cover exceptins');
        }
        
    }
    /**T02 - Start**/
    public static testMethod void testGroupsInsertduplicatenot1(){
        Test.startTest();
        
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
        //AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp.id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        //gsrf.AIA_Group_Structure__c = Gstrc.id;
        insert gsrf;
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        //gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        insert gsrfp1;
        PageReference pref = Page.AIA_GSM_MultipleGroupAddVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('gsrfid',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSM_MultipleGroupAdd gsrfa=new AIA_GSM_MultipleGroupAdd(con);
        
        AIA_Group__c g1=new AIA_Group__c();
        g1.Name='g2';
        g1.Group_Structure_Request_Form__c=gsrf.id;
        g1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        g1.Employee_Status__c='Cobra';
        //g1.Plan_Code__c='Plan code 580 for DC';
        //g1.AIA_Group_Structure__c = Gstrc.id;
        gsrfa.grps.clear();
        gsrfa.grps.add(g1);
        gsrfa.save();
        Test.stopTest();
    }
    /**T02 - End**/
    public static testMethod void testDepInsert(){
        Test.startTest();
        
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
       // AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp.id;
        //gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        //gsrf.AIA_Group_Structure__c = Gstrc.id;
        insert gsrf;
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        //gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        insert gsrfp1;
        PageReference pref = Page.AIA_MultipleDepartmentAdd;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('gsrfid',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);//
       AIA_MultipleDepartmentAdd gsrfa=new AIA_MultipleDepartmentAdd(con);
        AIA_department__c d1=new AIA_department__c();
       // d1.AIA_Group_Structure__c = Gstrc.id;
        d1.Group_Structure_Request_Form__c=gsrf.id;
        d1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        d1.Employee_Status__c='Cobra';
        
        
       
        gsrfa.objectRecords.clear();
        gsrfa.objectRecords.add(d1);
        gsrfa.save();
        gsrfa.addrow();
        gsrfa.multipleRowsize=3;
        gsrfa.multipleRows();
        gsrfa.removerow();
        gsrfa.rowToRemove=1;
        gsrfa.removeRowFromList();
        gsrfa.cancel();
        gsrfa.refresh();
        
        List <AIA_Department__c> deps=[select id from AIA_Department__c where Group_Structure_Request_Form__c=:gsrf.id];//
       // List <AIA_Department__c> deps=[select id from AIA_Department__c where AIA_Group_Structure__c=:Gstrc.id];
       // system.assertEquals(1, deps.size());
        AIA_Department__c departs=new AIA_Department__c();
        departs.Group_Structure_Request_Form__c=gsrf.id;
       //r1 departs.AIA_Group_Structure__c = Gstrc.id;
        try{
            
            gsrfa.save();
            update deps; 
           delete deps; 
            Test.stopTest();
            
        }
        catch(Exception e){
            system.debug('to cover exceptins');
        }
        
        
    }
    public static testMethod void testPackageInsert(){
        Test.startTest();
        
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
        //r1 AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp.id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        //r1 gsrf.AIA_Group_Structure__c = Gstrc.id;
        insert gsrf;
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        // r1 gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        insert gsrfp1;
        PageReference pref = Page.AIA_GSM_MultiplePackageAddVF;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('gsrfid',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
         
        AIA_GSM_MultiplePackageAdd gsrfa=new AIA_GSM_MultiplePackageAdd(con);
        AIA_Package__c p1=new AIA_Package__c();
        p1.Group_Structure_Request_Form__c=gsrf.id;
        p1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        p1.Coverage_Levels__c='Standard';
        p1.Employee_Status__c='Cobra';
        // r1 p1.AIA_Group_Structure__c = Gstrc.id;
        gsrfa.packgs.clear();
        gsrfa.packgs.add(p1);
        gsrfa.save();
        
        AIA_Package__c p11=new AIA_Package__c();
        p11.Group_Structure_Request_Form__c=gsrf.id;
        p11.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        p11.Coverage_Levels__c='Standard';
        p11.Employee_Status__c='Cobra';
        // r1p11.AIA_Group_Structure__c = Gstrc.id;
        insert p11;
        gsrfa.save();
        gsrfa.addrow();
        gsrfa.multipleRowsize=3;
        gsrfa.multipleRows();
        gsrfa.removerow();
        gsrfa.rowToRemove=1;
        gsrfa.removeRowFromList();
        gsrfa.cancel();
        List <AIA_Package__c> pckgs=[select id from AIA_Package__c where Group_Structure_Request_Form__c=:gsrf.id];
        system.assertEquals(2, pckgs.size());
        AIA_Package__c packs=new AIA_Package__c();
        packs.Group_Structure_Request_Form__c=gsrf.id;
        try{
           gsrfa.addrow();
            gsrfa.save();
            gsrfa.cancel();
            gsrfa.refresh();
            
            update pckgs;
            delete pckgs;
            Test.stopTest();
            
        }
        catch(Exception e){
            system.debug('to cover exceptins');
        }
    }
    public static testMethod void testFacetInsert(){
        Test.startTest();
        
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
        // r1AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp.id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        // r1 gsrf.AIA_Group_Structure__c = Gstrc.id;
        insert gsrf;
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        // r1 gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        insert gsrfp1;
        PageReference pref = Page.AIA_GSM_MultipleFacetAdd;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('gsrfid',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_GSM_MultipleFacetAdd gsrfa=new AIA_GSM_MultipleFacetAdd(con);
        AIA_FACET_Class__c rec=new AIA_FACET_Class__c();
        rec.Name='DEP-1';
        rec.Employee_Status__c='Cobra';
        rec.Product_description__c='BLUEDENTAL PLUS';
        rec.Group_Structure_Request_Form__c=gsrf.id;
        // r1 rec.AIA_Group_Structure__c = Gstrc.id;
       gsrfa.facets.clear();
        gsrfa.facets.add(rec);
        gsrfa.save();
        gsrfa.addrow();
        gsrfa.multipleRowsize=3;
        gsrfa.multipleRows();
        gsrfa.removerow();
        gsrfa.rowToRemove=1;
        gsrfa.removeRowFromList();
        gsrfa.cancel();
        List <AIA_FACET_Class__c> pckgs=[select id from AIA_FACET_Class__c where Group_Structure_Request_Form__c=:gsrf.id];
        system.assertEquals(1, pckgs.size());
        AIA_FACET_Class__c packs=new AIA_FACET_Class__c();
        packs.Name='DEP-1';
        packs.Group_Structure_Request_Form__c=gsrf.id;
        packs.Product_Description_other__c='test';
        
        packs.Employee_Status__c='Cobra';
        packs.Product_description__c='BLUEDENTAL PLUS';
        // r1 packs.AIA_Group_Structure__c = Gstrc.id;
        insert packs; 
        try{
            gsrfa.addrow();
            gsrfa.save();
            gsrfa.cancel();
            gsrfa.refresh();
            update pckgs;
            delete pckgs;
            Test.stopTest();
            
        }
        catch(Exception e){
            system.debug('to cover exceptins');
        }
    }
    public static testMethod void testFacetGroupsInsert(){
        Test.startTest();
        
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
       // r1  AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp.id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        // r1 gsrf.AIA_Group_Structure__c = Gstrc.id;
        insert gsrf;
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        // r1 gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        insert gsrfp1;
        PageReference pref = Page.AIA_MultipleFacetGroupsAdd;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('gsrfid',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
        AIA_MultipleFacetGroupsAdd gsrfa=new AIA_MultipleFacetGroupsAdd(con);
        AIA_FACET_Group__c rec=new AIA_FACET_Group__c();
        rec.Name='DEP-1';
        rec.Group_Structure_Request_Form__c=gsrf.id;
        rec.Employee_Status__c='Cobra';
        rec.Product_Description_List__c='VISION';
        // r1 rec.AIA_Group_Structure__c = Gstrc.id;
         gsrfa.objectRecords.clear();
        gsrfa.objectRecords.add(rec); 
        gsrfa.save();
        gsrfa.addrow();
        gsrfa.multipleRowsize=3;
        gsrfa.multipleRows();
        gsrfa.removerow();
        gsrfa.rowToRemove=1;
        gsrfa.removeRowFromList();
        gsrfa.cancel();
        gsrfa.refresh();
        List <AIA_FACET_Group__c> pckgs=[select id from AIA_FACET_Group__c where Group_Structure_Request_Form__c=:gsrf.id];
        system.assertEquals(1,pckgs.size());
        AIA_FACET_Group__c packs=new AIA_FACET_Group__c();
        packs.Group_Structure_Request_Form__c=gsrf.id;
        // r1 packs.AIA_Group_Structure__c = Gstrc.id;
        try{
           gsrfa.save();
            update pckgs;
            delete pckgs;
            Test.stopTest();
            
            
        }
        catch(Exception e){
            system.debug('to cover exceptins');
        }
    }
    public static testMethod void testFacetSubGroupsInsert(){
        Test.startTest();
        
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
        // AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp.id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        // gsrf.AIA_Group_Structure__c = Gstrc.id;
        insert gsrf;
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        // gsrfp1.AIA_Group_Structure__c = Gstrc.id;
        insert gsrfp1;
        PageReference pref = Page.AIA_GSM_MultipleFacetSubGroupAdd;
        Test.setCurrentPage(pref);
       ApexPages.currentPage().getParameters().put('gsrfid',gsrf.id);
        ApexPages.StandardController con = new ApexPages.StandardController(gsrf);
       AIA_GSM_MultipleFacetSubGroupAdd gsrfa=new AIA_GSM_MultipleFacetSubGroupAdd(con);
        AIA_FACET_Sub_Group__c rec=new AIA_FACET_Sub_Group__c();
        rec.Name='DEP-1';
        rec.Group_Structure_Request_Form__c=gsrf.id;
        rec.Employee_Status__c='Cobra';
        rec.Product_Description_List__c='VISION';
        // r1 rec.AIA_Group_Structure__c = Gstrc.id;
       gsrfa.facetsSub.clear();
        gsrfa.facetsSub.add(rec); 
        gsrfa.save();
        gsrfa.addrow();
        gsrfa.multipleRowsize=3;
        gsrfa.multipleRows();
        gsrfa.removerow();
        gsrfa.rowToRemove=1;
        gsrfa.removeRowFromList();
        gsrfa.cancel();
        gsrfa.refresh();
        List <AIA_FACET_Sub_Group__c> pckgs=[select id from AIA_FACET_Sub_Group__c where Group_Structure_Request_Form__c=:gsrf.id];
        system.assertEquals(1, pckgs.size());
        AIA_FACET_Sub_Group__c packs=new AIA_FACET_Sub_Group__c();
        packs.Group_Structure_Request_Form__c=gsrf.id;
       // r1 packs.AIA_Group_Structure__c = Gstrc.id;
        try{
            gsrfa.save();
            gsrfa.refresh();
            update pckgs;
            delete pckgs;
            Test.stopTest();
            
        }
        catch(Exception e){
            system.debug('to cover exceptins');
        }
    }
    public static testMethod void testExceptions(){
        test.startTest();
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
        // r1 AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imp.id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others;Plan code 780 for NJ';
        // r1 gsrf.AIA_Group_Structure__c = Gstrc.id;
        insert gsrf;
         test.stopTest();
    }
    
}