/*=================================================================================================
* Date         : 09/19/2017
* Developer    : Raviteja
* Purpose      : US-63 this class funtion to test the "AIA_GroupHelper" class
*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 09/19/2017| Raviteja    |     | Initial Version                                         
* 01-18-2019|	Chaithra  | T01 | Created users for account team role as per US1702 and US1730
*===========+============+=====+===================================================================
*/
@istest
public class AIA_GroupHelperTest {
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
     
        user u15 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u15);
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
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Implementation Manager'));
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
        Imp.Benefit_Request_Form__c=brf.id;
        Imp.Risk_Type__c='ASO';
        insert Imp;
        bd.Implementation__c=Imp.id;
        //update bd;
     	Test.stopTest();
    }
    
    
    public static testMethod void testGSRFInsert()
    {
        
        
        Test.startTest();
        
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        system.debug('Te: '+bd);
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        //Inserting group structure request form
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        gsrf.Implementation__c=bd[0].Implementation__c;
        insert gsrf;
        
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        AIA_Group_Structure_Form_Product__c gsrfp1 = new AIA_Group_Structure_Form_Product__c();
        gsrfp1.Group_Structure_Request_Form__c = gsrf.id;
        gsrfp1.Coverage_Level__c = 'Standard';
        gsrfp1.Deductible__c = 'Two';
        gsrfp1.recordtypeid = dental;
        gsrfp1.Alpha_Prefix__c='tes';
        insert gsrfp1;
        
        List<AIA_Group__c> lstGroup=new List<AIA_Group__c>();
        AIA_Group__c g1=new AIA_Group__c();
        //g1.Alpha_Prefix__c='test1';
        g1.Group_Structure_Request_Form__c=gsrf.id;
        g1.Plan_Code__c = 'Plan code 580 for DC';
        g1.Employee_Status__c = 'Active';
        g1.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        //lstGroup.add(g1);
        insert g1;
       
        //List<AIA_Group__c> lstGroup1=new List<AIA_Group__c>();
        AIA_Group__c g2=new AIA_Group__c();
        //g2.Alpha_Prefix__c='';
        g2.Group_Structure_Request_Form__c=gsrf.id;
        g2.Plan_Code__c = 'Plan code 580 for DC';
        g2.Employee_Status__c = 'Active';
        g2.Group_Structure_Request_Form_Product__c=gsrfp1.id;
        insert g2;
        //lstGroup.add(g2);
        //insert lstGroup;
        
        AIA_Group_Structure_Request_Form__c gsrf2=[select id,Alpha_Prefix_is_missing__c from  AIA_Group_Structure_Request_Form__c limit 1];
        system.assertEquals(true,gsrf2.Alpha_Prefix_is_missing__c );
        //g2.Alpha_Prefix__c='test';
        update g2;
        AIA_Group_Structure_Request_Form__c gsrf3=[select id,Alpha_Prefix_is_missing__c from  AIA_Group_Structure_Request_Form__c limit 1];
        //system.assertEquals(true,gsrf3.Alpha_Prefix_is_missing__c );
        
        delete g2;
        delete g1;
       // AIA_Group_Structure_Request_Form__c gsrf1=[select id,Alpha_Prefix_is_missing__c from  AIA_Group_Structure_Request_Form__c limit 1];
       // system.assertEquals(false,gsrf1.Alpha_Prefix_is_missing__c );

        
        Test.stopTest();
        
    }
     public static testMethod void testGSRFDelete()
    {
        
        Test.startTest();
        try{        
        //Querying data for test
        List<AIA_benefit_design__c> bd=[select id,Implementation__c from AIA_benefit_design__c limit 1];
        system.debug('Te: '+bd);
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=bd[0].Implementation__c;
        //Inserting group structure request form        
        insert gsrf;
        
        List<AIA_Group__c> lstGroup=new List<AIA_Group__c>();
        AIA_Group__c g1=new AIA_Group__c();
        //g1.Alpha_Prefix__c='test1';
        g1.Group_Structure_Request_Form__c=gsrf.id;
        lstGroup.add(g1);
       
        List<AIA_Group__c> lstGroup1=new List<AIA_Group__c>();
        AIA_Group__c g2=new AIA_Group__c();
        //g2.Alpha_Prefix__c='';
        g2.Group_Structure_Request_Form__c=gsrf.id;
        lstGroup.add(g2);
        
        insert lstGroup;
        AIA_Group_Structure_Request_Form__c gsrf2=[select id,Alpha_Prefix_is_missing__c from  AIA_Group_Structure_Request_Form__c limit 1];
        system.assertEquals(false,gsrf2.Alpha_Prefix_is_missing__c );
        
        delete g2;
        AIA_Group_Structure_Request_Form__c gsrf1=[select id,Alpha_Prefix_is_missing__c from  AIA_Group_Structure_Request_Form__c limit 1];
        system.assertEquals(true,gsrf1.Alpha_Prefix_is_missing__c );

        }
        catch(Exception e){
            system.debug('To cover exception');
        }
        Test.stopTest();
        
    }
}