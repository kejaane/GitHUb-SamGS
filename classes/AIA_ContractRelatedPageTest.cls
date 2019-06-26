/*=================================================================================================
* Date         : 2/19/2018
* Developer    : Raviteja
* Purpose      : This class function is to test the AIA_ContractRelatedPage class.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 2/19/2018| Raviteja    |     | Initial Version                                         
* 2/08/2019| Chaithra	 | T01 | Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_ContractRelatedPageTest {
   @testSetup static void testdata() {
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
       //Commenting as part of US210 
       //Creating WorkPlan Type Test Data 
       // AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales'); 
        
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
       	user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Implementation Manager'));
       acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u20.id,'Pharmacy Operations'));
            insert acctMbrList;
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Updating as part of US210
               
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = accnt.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
       // Imp.Benefit_Request_Form__c=brf.id;
        Imp.Risk_Type__c='ASO';
        insert Imp;
    }
    
	    public static testMethod void testContract(){
            Contract c=new Contract();
            //query implementations
			AIA_Implementation__c Imp=[select id,Account__c  from AIA_Implementation__c limit 1];
			PageReference pref = Page.AIA_ContractRelatedPage;
            Test.setCurrentPage(pref);
            //pass parameters of imp and account to autopopulate
            ApexPages.currentPage().getParameters().put('impid',Imp.id);
            ApexPages.currentPage().getParameters().put('accid',Imp.Account__c);
            ApexPages.standardController stdCon=new  ApexPages.standardController(c);
			AIA_ContractRelatedPage apcpe=new AIA_ContractRelatedPage(stdCon);
            system.assertNotEquals(pref.getUrl(),null);
            apcpe.cancel();
            
        }
}