/*=================================================================================================
* Date         : 06/18/2018
* Developer    : Raviteja
* Purpose      : This class function is to test the AIA_Implementation_Dashboard class.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 06/18/2018| Raviteja   |     | Initial Version 
*
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_Implementation_Dashboard_Test {
    public static Account accnt;
    public static Opportunity opp;
    public static Benfit_Request_Form__c Brf;
    public static AIA_Implementation__c Imp;
    public static Process__c Process;
    public static Sub_Process__c SubProcess;
    @testSetup static void testdata() {
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
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
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
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
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Implementation Manager'));
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Implementation PM'));
        insert acctMbrList;
        
        //Creating Opportunity Test Data   
        Opportunity opp = AIA_TestUtil.opp(accnt.Id);
        //Creating Implementation Test Data
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp.id;
        Imp.Account__c = accnt.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        //Imp.Benefit_Request_Form__c=brf.id;
        Imp.Risk_Type__c='ASO';
        Imp.Status__c ='Not Started';
        insert Imp;
        //Creating Process Test Data
        Process__c Process = AIA_TestUtil.pro(opp.id,Imp.id);
        //Creating SupProcess Test Data
        Sub_Process__c SubProcess = AIA_TestUtil.Subpro(opp.id,Imp.id,Process.id);        
    }
    public static testMethod void testProcess(){
        Test.startTest();
        //Fatching subprocess
        Sub_Process__c subPro = [Select id from Sub_Process__c limit 1];
        //Fatching implementation
        AIA_Implementation__c imp = [select id from AIA_Implementation__c limit 1];
        //Creating Pagereferance
        PageReference pageRef = Page.AIA_Implementation_Dashboard;
        //Passing parameter of pagereferance
        pageRef.getParameters().put('Id', String.valueOf(imp.Id));
        //Testing the page
        Test.setCurrentPage(pageRef); 
        //Creating standared controller
        ApexPages.StandardController sc = new ApexPages.StandardController(imp);
        //Passing contoller to extention
        AIA_Implementation_Dashboard_Extn newSubPro = new AIA_Implementation_Dashboard_Extn(sc);
        
        Test.stopTest();
    }
    
    
    public static testMethod void TEST_populateProcessesList_Empty(){
        Test.startTest();
        //Fatching process
        Process__c process  = [Select id from Process__c limit 1];
        //delete process
        delete process;
        //Fatching implementation
        AIA_Implementation__c imp = [select id from AIA_Implementation__c limit 1];
        //Creating Pagereferance
        PageReference pageRef = Page.AIA_Implementation_Dashboard;
        //Passing parameter of pagereferance
        pageRef.getParameters().put('Id', String.valueOf(imp.Id));
        //Testing the page
        Test.setCurrentPage(pageRef); 
        //Creating standared controller
        ApexPages.StandardController sc = new ApexPages.StandardController(imp);
        //Passing contoller to extention
        AIA_Implementation_Dashboard_Extn newSubPro = new AIA_Implementation_Dashboard_Extn(sc);
        
        Test.stopTest();
    }
}