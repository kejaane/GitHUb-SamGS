/*=================================================================================================
* Date         : 2/15/2018
* Developer    : Raviteja
* Purpose      : This class function is to test the AIA_ExportAdjustmentSummary class.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 2/15/2018| Raviteja    	 |   | Initial Version                                         
*01-18-2019 	Chaithra 	 |T01| Created users for account team role as per US1702 and US1730
*02/12/2019		Chaithra	 |T02|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_ExportAdjustmentSummaryTest {
@testSetup static void testdata() {
        // Creating Account Test data
        Account acc = new Account();
        acc.Name = 'TestAccount1';
        acc.Type = 'Customer';
        acc.RecordTypeId = QueryBase.getRecordtypeId('Account', 'X51');       
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        
    	//Commenting as part of US210
        //Creating WorkPlan Type Test Data 
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c(); 
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;*/
        
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
        user u10 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u10); 
        user u11 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u11);
    	user u12 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u12); 
        user u13 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u13);
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
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();//T02
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder'));T01 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u13.id,'Implementation Manager'));
    	//Creating AccountMember Test Data T01 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T01 ends
            insert acctMbrList;
        
        //Creating Opportunity Test Data   
        Opportunity o = new opportunity();
        o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');    
        o.AccountId = acc.id;
        o.name = 'Test Opportunity';
        o.SBU__c = 'Large';
        o.Market_Segment_New__c = '1000+';
        o.Division__c = 'Commercial Business';
        o.Business_Type__c = 'New';
        o.Effective_Date__c =  Date.newInstance(2014,10,1);
        o.CloseDate = o.Effective_Date__c.addDays(-11);
        o.Legal_Account_Name_Verified__c = true;
        o.AE_Name__c = 'Test AE Name';
        o.AM_Name__c = 'Test AM Name';
        o.Contract_End_Date__c = o.Effective_Date__c.addMonths(1);
        o.Contract_End_Date__c = o.Contract_End_Date__c.addDays(-1);
        o.type = 'Medical Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//Change as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        Test.startTest();
        //Creating benefit Request Form Test Data 
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Funding_Arrangements__c='Both';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
    //Create Benefit Design
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = acc.Id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        insert Imp;
        
        //System.debug('4.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
        
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        aiaBD.Status__c = 'In Progress';
        insert aiaBD;
   		AIA_Benefit_Design__c aiaBD1 = new AIA_Benefit_Design__c();
        aiaBD1.Implementation__c = Imp.id;
        aiaBD1.Account__c = acc.Id;
        aiaBD1.Benefit_Request_Form__c = brf.Id;
        aiaBD1.Status__c = 'Approved';
        insert aiaBD1;
    Test.stopTest();
    system.debug('aiaBD1'+aiaBD1);
        
    }
	    public static testMethod void testBD(){
            AIA_Benefit_Design__c bdObj = [Select Id,status__c From AIA_Benefit_Design__c where status__c!='Approved'  limit 1];
			PageReference pref = Page.AIA_ExportAdjustmentSummary;
            Test.setCurrentPage(pref);
            ApexPages.standardController stdCon=new  ApexPages.standardController(bdObj);
			AIA_ExportAdjustmentSummary apcpe=new AIA_ExportAdjustmentSummary(stdCon);
            system.assertNotEquals(pref.getUrl(),null);
            apcpe.isApproved();
            apcpe.backtoBD();
            
        }
     public static testMethod void testBDisapproved(){
         AIA_Drawloop_Package_ID__c ddp=new AIA_Drawloop_Package_ID__c();
         ddp.Name='Adjustment Summary';
         ddp.DDP_ID__c='a191F0000009MqUQAU';
         insert ddp;
            AIA_Benefit_Design__c bdObj = [Select Id,status__c From AIA_Benefit_Design__c where status__c='Approved' limit 1];
			
           	PageReference pref = Page.AIA_ExportAdjustmentSummary;
            Test.setCurrentPage(pref);
            ApexPages.standardController stdCon=new  ApexPages.standardController(bdObj);
			AIA_ExportAdjustmentSummary apcpe=new AIA_ExportAdjustmentSummary(stdCon);
            system.assertNotEquals(pref.getUrl(),null);
            apcpe.isApproved();
            apcpe.backtoBD();
            
        }
}