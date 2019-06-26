/*=================================================================================================
* Date         : 09/22/2017
* Developer    : Debkanti
* Purpose      : US-60 This class function to test the "AIA_GSM_GSRFProductCount" class

*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+=============+=====+===================================================================
* 09/22/2017| Debkanti    |     | Initial Version
*01-18-2019 | Chaithra 	  |T01| 	Created users for account team role as per US1702 and US1730
*===========+============+=====+===================================================================
*/
@istest
public class AIA_GSM_GSRFProductCountTest {
    @testSetup static void testdata() {
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
        //Creating WorkPlan Type Test Data 
        AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales');
        //Creating User Test Data 
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
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
        user u10 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u10);        
        user u11 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u11); 
        user u12 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u12);
        //Creating User Test Data T01 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T01 ends
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
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Account Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Implementation Manager'));
        //Creating AccountMember Test Data T01 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u20.id,'Pharmacy Operations'));
		//T01 ends
		insert acctMbrList;
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id,wpt.id);
        //Creating benefit Request Form Test Data 
        Benfit_Request_Form__c brf = AIA_TestUtil.benForm(accnt.Id,o.id);
        
        Test.startTest();
        //Creating AIA Plan Test Data 
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        //Creating Proposed Plan Test Data 
        Proposed_Products__c proPrd = AIA_TestUtil.proposedProduct(
            brf.id,aiapln.id);
        //Creating Benefit Design Test Data  
        AIA_Benefit_Design__c bd=AIA_TestUtil.cCreateBenefitDesignWImpFromBrf(accnt.id,o.id,brf.id);
        
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
        
        Proposed_Products__c pp = new Proposed_Products__c();
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
        pp.Benefit_Request_Form__c = brf.Id;
        pp.Funding_Arrangement__c = 'ASO';
        pp.Product_Category__c = 'Medical';
        pp.Product_Line__c = 'PPO';
        pp.Plan_Name__c = aiapln.Id;
        pp.Product_Name__c = 'BlueChoice Advantage';
        pp.CDH__c = 'Yes';
        pp.CDH_Fund_Type__c = 'BlueFund';
        pp.CDH_Type__c = 'HSA';
        pp.Deductible__c = 'Stacked';
        pp.Grandfathered_Status__c = 'Grandfathered';
        pp.Integrated_Non_Integrated__c = 'Yes';
        pp.Grandfathered_PPACA_Status__c = 'No';
        pp.Blue_Rewards__c = 'No';
        pp.Out_of_Pocket_Max__c = 'Stacked';
        pp.Has_Benefit_Details__c =false;
        pp.Rider__c='None';
        insert pp;
        Test.stopTest();
        //Creating Group Structure Request Form data
        
        //AIA_Group_Structure_Form_Product__c gsrfp = AIA_TestUtil.gsmGsrfprod(gsrf.id);
        
    }
    public static testMethod void testGSRFDelete()
    {
        Test.startTest();
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
        
        AIA_Group_Structure_Request_Form__c gsrf = new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c = Imp.id;
        gsrf.Status__c = 'Draft - New';
        gsrf.Processing_Type__c = 'Standard';
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Vision_of_Plans__c = 0;
        gsrf.Dental_of_Plans__c = 0;
        gsrf.Drug_of_Plans__c = 0;
        system.debug(gsrf +'******@@@@@@');
        //insert ;
        database.insert(gsrf,false);
        Id RecordTypeIdContact = Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
        system.debug('TestClass: '+RecordTypeIdContact);
        List<AIA_Group_Structure_Form_Product__c> gsrfps=new List<AIA_Group_Structure_Form_Product__c>();
        AIA_Group_Structure_Form_Product__c gsrfp = new AIA_Group_Structure_Form_Product__c();
        gsrfp.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp.Coverage_Level__c = 'Standard';
        gsrfp.Deductible__c = 'Two';
        gsrfp.recordtypeid = RecordTypeIdContact;
        gsrfps.add(gsrfp);
        system.debug('TestClass1: '+gsrfp);
        Id RecordTypeIdContact1 = Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = RecordTypeIdContact1;
        gsrfps.add(gsrfp1);
        Id RecordTypeIdContact2 = Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Vision').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp2 = new AIA_Group_Structure_Form_Product__c();
        gsrfp2.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp2.Coverage_Level__c = 'Standard';
        gsrfp2.Deductible__c = 'Two';
        gsrfp2.recordtypeid = RecordTypeIdContact2;
        gsrfps.add(gsrfp2);
        insert gsrfps; 
        // update  gsrfps;   
        delete gsrfps;
        
        
        Test.stopTest();
        
    }
    public static testMethod void testGSRFDelete2()
    {
        Test.startTest();
        
        AIA_Implementation__c Imp=[select id from AIA_Implementation__c limit 1];
        
        AIA_Group_Structure_Request_Form__c gsrf = new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c = Imp.id;
        gsrf.Status__c = 'Draft - New';
        gsrf.Processing_Type__c = 'Standard';
        //gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Vision_of_Plans__c = 0;
        gsrf.Dental_of_Plans__c = 0;
        gsrf.Drug_of_Plans__c = 0;
        
        database.insert(gsrf,false);
        list<AIA_Group_Structure_Request_Form__c> bbb=new list<AIA_Group_Structure_Request_Form__c>();
        bbb.add(gsrf);
        Id RecordTypeIdContact = Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
        system.debug('TestClass: '+RecordTypeIdContact);
        List<AIA_Group_Structure_Form_Product__c> gsrfps=new List<AIA_Group_Structure_Form_Product__c>();
        
        AIA_Group_Structure_Form_Product__c gsrfp = new AIA_Group_Structure_Form_Product__c();
        //gsrfp.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp.Coverage_Level__c = 'Standard';
        gsrfp.Deductible__c = 'Two';
        //gsrfp.recordtypeid = RecordTypeIdContact;
        gsrfps.add(gsrfp);
        insert gsrfps;
        update gsrfps;
        update gsrfps;
        try{
            AIA_GroupStructureFormTriggerHelper at=new AIA_GroupStructureFormTriggerHelper();
            AIA_GroupStructureFormTriggerHelper.createGSParentProducts(bbb);
            
            
            
        } catch (Exception e) {
            System.debug('something went wrong :- '+e);
        }       
        
    }
    
}