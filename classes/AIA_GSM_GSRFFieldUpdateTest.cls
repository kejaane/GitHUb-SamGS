/*=================================================================================================
* Date         : 09/21/2017
* Developer    : Debkanti
* Purpose      : US-61 This class function to test the "AIA_GSM_GSRFFieldUpdate" class

*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 09/21/2017| Debkanti    |     | Initial Version
06/08/2018    raj kiran      T01       Added code for role updates
*02/12/2019     Chaithra     |T02|      Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*===========+============+=====+===================================================================
*/
@istest
public class AIA_GSM_GSRFFieldUpdateTest {
    public static Account accnt;
     public static Opportunity o;
     public static Benfit_Request_Form__c BRF;
     public static AIA_Implementation__c Imp;
     //public static AIA_Group_Structure__c Gstrc;
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
        //T02 starts
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
        //T02 ends
         insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();t02
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02 replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u16.id,'Settlements Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Implementation Manager'));
       // acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Implementation PM'));
       //T02 Starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u20.id,'Pharmacy Operations'));
        //T02 ends
        insert acctMbrList;
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Updated per US210
        
        list<Benfit_Request_Form__c> brfList = new list<Benfit_Request_Form__c>();
        Benfit_Request_Form__c BRF = new Benfit_Request_Form__c();
        BRF.Opportunity__c = o.id;
        BRF.Benefit_Effective_Date__c = system.today();
        BRF.Contract_Count__c = 14;
        BRF.Broker_Commission__c =31.0;
        BRF.Renewal_Date__c = system.today();
        BRF.Account__c = accnt.id;
        BRF.Funding_Arrangements__c = 'Risk';
        BRF.Request_Type__c='Prospect/New';
        //insert BRF;
        brfList.add(BRF);
        test.startTest();
       Benfit_Request_Form__c BRF1 = new Benfit_Request_Form__c();
        BRF1.Opportunity__c = o.id;
        BRF1.Benefit_Effective_Date__c = system.today();
        BRF1.Contract_Count__c = 14;
        BRF1.Broker_Commission__c =31.0;
        BRF1.Renewal_Date__c = system.today();
        BRF1.Account__c = accnt.id;
        BRF1.Funding_Arrangements__c = 'Risk';
        BRF1.Request_Type__c='RFP';
        BRF1.Enrollment_Option__c='Other';
        //insert BRF1;
        brfList.add(BRF1);
        insert brfList;
               
        list<AIA_Implementation__c> implist= new list<AIA_Implementation__c>();
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = accnt.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '90';
        Imp.Benefit_Request_Form__c=brf.id;
        Imp.Risk_Type__c='ASO';
        //insert Imp;
        implist.add(Imp);
       
        
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf1';
        Imp1.Opportunity__c = o.id;
        Imp1.Account__c = accnt.id;
        Imp1.Generate_Workplan_Stages__c = true;
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Benefit_Request_Form__c=BRF1.id;
        Imp1.Risk_Type__c='ASO';
        //insert Imp1;
        implist.add(Imp1);
        Insert implist;
       
        //AIA_Group_Structure__c Gstrc = new AIA_Group_Structure__c();
        //Gstrc.Account_Name__c= accnt.id;
        //Gstrc.AIA_Implementation__c = Imp.id;
        //insert Gstrc;
        test.stopTest();  
        AIA_Group_Structure_Request_Form__c gsrf1 = new AIA_Group_Structure_Request_Form__c();
        gsrf1.Implementation__c = Imp.Id;
        gsrf1.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf1.Status__c = 'Draft - New'; 
        //gsrf1.Processing_Type__c = 'Standard';
        //gsrf1.AIA_Group_Structure__c = Gstrc.id;
        //gsrfs.add(gsrf1);
        insert gsrf1; 
      
    }
    public static testMethod void testGSRFFieldUpdate()
    {
         Test.startTest();
       List<AIA_Implementation__c> Imps = [select id from AIA_Implementation__c where Implementation_Plan_Timeline_Days__c='60'];
        system.debug('size of imps'+Imps[0]+' 1 ');
        Account accnt =[select id from Account limit 1];
        //AIA_Group_Structure__c Gstrc =[select id from AIA_Group_Structure__c limit 1];
        //AIA_Group_Structure__c Gstrc1 = new AIA_Group_Structure__c();
//AIA_Group_Structure__c Gstrc = new AIA_Group_Structure__c();
       // Gstrc1.Account_Name__c= accnt.id;
       // Gstrc1.AIA_Implementation__c = Imps[0].id;
       //insert Gstrc1;
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c(); 
        gsrf.Status__c='Draft - New';
        gsrf.Implementation__c=Imps[0].id;
        
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        //gsrf.AIA_Group_Structure__c=Gstrc1.id;
        insert gsrf;
         
       
        List<AIA_Group_Structure_Request_Form__c> gsrf2 = new List<AIA_Group_Structure_Request_Form__c>();
        gsrf2=[select id,Processing_Type__c,Implementation__c from  AIA_Group_Structure_Request_Form__c];
        system.debug('size of GSRF '+gsrf2.size()+' id values '+gsrf2);
        //system.assertEquals(gsrf2[0].Processing_Type__c,gsrf2[1].Processing_Type__c );
        List<AIA_Group_Structure_Request_Form__c> gsrf3= new List<AIA_Group_Structure_Request_Form__c>();
        /*   gsrf3 = [select id,Processing_Type__c,Implementation__c from  AIA_Group_Structure_Request_Form__c where (implementation__c=:imps[0].Id or implementation__c=:imps[1].id )];
        system.debug('size of GSRF3 '+gsrf3.size()+' id values '+gsrf3);*/
        
        //system.assertEquals('Standard',gsrf3.Processing_Type__c );*/
        Test.stopTest();
}
   
}