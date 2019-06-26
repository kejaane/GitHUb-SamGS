/*=================================================================================================
* Date         : 11/06/2017
* Developer    : Raviteja
* Purpose      : US-234 This class function tocheck all alpha prefix fields in gsp and make the
				 alpha prefix field in GSRF field completed.

*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+=============+=====+===================================================================
* 11/06/2017| Raviteja	  |		| initial creation
*
*===========+============+=====+===================================================================
*/
@istest
public class AIA_GSM_GSRFProductTriggerHelperTest {
 @testSetup static void testdata() {
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
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
     	user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
     	user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
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
     	acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u18.id,'Pharmacy Operations'));
        insert acctMbrList;
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id,wpt.id);
        //Creating benefit Request Form Test Data 
        Benfit_Request_Form__c brf = AIA_TestUtil.benForm(accnt.Id,o.id);
        //Creating AIA Plan Test Data 
        //AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        //Creating Proposed Plan Test Data 
       // Proposed_Products__c proPrd = AIA_TestUtil.proposedProduct(
        //    brf.id,aiapln.id);
        //Creating Benefit Design Test Data  
       // AIA_Benefit_Design__c bd=AIA_TestUtil.cCreateBenefitDesignWImpFromBrf(accnt.id,o.id,brf.id);
 
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = accnt.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = brf.id;
        insert Imp;
        
        
        //Creating Group Structure Request Form data
        List<AIA_Group_Structure_Request_Form__c> gsrfs=new List<AIA_Group_Structure_Request_Form__c>();
        AIA_Group_Structure_Request_Form__c gsrf = new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c = Imp.id;
        gsrf.Status__c = 'Draft - New';
        gsrf.Processing_Type__c = 'Standard';
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Vision_of_Plans__c = 0;
        gsrf.Dental_of_Plans__c = 0;
        gsrf.Drug_of_Plans__c = 0;
        gsrfs.add( gsrf);
       
        insert gsrfs;
       
      
    }
    public static testmethod void checkAlphaPrefixCompleted(){
        Test.startTest();
        AIA_Group_Structure_Request_Form__c gsrf=[select id,Alpha_Prefix_is_missing__c from AIA_Group_Structure_Request_Form__c
                                                 limit 1];
        List<AIA_Group_Structure_Form_Product__c> gsrfps=new List<AIA_Group_Structure_Form_Product__c>();
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        Id drug=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
        Id vision=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Vision').getRecordTypeId();
        Id medical=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='test';
        gsrfps.add(gsrfp1);
        AIA_Group_Structure_Form_Product__c gsrfp2 = new AIA_Group_Structure_Form_Product__c();
        gsrfp2.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp2.Coverage_Level__c = 'Standard';
        gsrfp2.Deductible__c = 'Two';
        gsrfp2.recordtypeid = drug;
        gsrfp2.Alpha_Prefix__c='test';
        gsrfps.add(gsrfp2);
    	 AIA_Group_Structure_Form_Product__c gsrfp3 = new AIA_Group_Structure_Form_Product__c();
        gsrfp3.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp3.Coverage_Level__c = 'Standard';
        gsrfp3.Deductible__c = 'Two';
        gsrfp3.recordtypeid = vision;
        gsrfp3.Alpha_Prefix__c='test';
        gsrfps.add(gsrfp3);
    	 AIA_Group_Structure_Form_Product__c gsrfp4 = new AIA_Group_Structure_Form_Product__c();
        gsrfp4.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp4.Coverage_Level__c = 'Standard';
        gsrfp4.Deductible__c = 'Two';
        gsrfp4.recordtypeid = medical;
        gsrfp4.Alpha_Prefix__c='test';
        gsrfps.add(gsrfp4);
        insert gsrfps;
       
        gsrfp4.Alpha_Prefix__c='';
        update gsrfp4;
       AIA_Group_Structure_Request_Form__c gsrfafter=[select id,Alpha_Prefix_is_missing__c from AIA_Group_Structure_Request_Form__c
                                                 limit 1]; 
        system.assertEquals(false, gsrfafter.Alpha_Prefix_is_missing__c);
        delete gsrfp4;
        Test.stopTest();
    }
}