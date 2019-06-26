/*=================================================================================================
* Date         : 2/07/2018
* Developer    : Raviteja
* Purpose      : This class function is to test the AIA_ProposedProductCPE class.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 2/07/2018| Raviteja    |     | Initial Version                                         
*
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_ProposedProductCPE_Test {
    @testSetup static void testdata() {
        // Creating Account Test data
        Account acc = new Account();
        acc.Name = 'TestAccount1';
        acc.Type = 'Customer';
        acc.RecordTypeId = QueryBase.getRecordtypeId('Account', 'X51');       
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        
        //Removed per US210
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
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u13.id,'Implementation Manager'));
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
        //o.Workplan_Type__c = wpt.id;//Removed per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        
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
    }
	    public static testMethod void testCPEInsert(){
            Proposed_Products__c pp=new Proposed_Products__c();
            Benfit_Request_Form__c brfObj = [Select Id,Funding_Arrangements__c,RecordTypeId From Benfit_Request_Form__c  limit 1];
			PageReference pref = Page.AIA_ProposedProductCPE;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('brfid',brfObj.id);
            ApexPages.currentPage().getParameters().put('RecordType',brfObj.RecordTypeId);
            ApexPages.currentPage().getParameters().put('fundingArrangement',brfObj.Funding_Arrangements__c);
            ApexPages.standardController stdCon=new  ApexPages.standardController(pp);
			AIA_ProposedProductCPE apcpe=new AIA_ProposedProductCPE(stdCon);
            system.assertNotEquals(pref.getUrl(),null);
            apcpe.cancel();
            
        }
}