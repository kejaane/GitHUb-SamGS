/*=========================================================================================
 * Date      : 12/09/2016
 * Developer : Rajesh Pennam
 * Purpose   : This class is having the logic to insert the implementation record when the 
 *              case is approved
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer         Description
 *===========+============+================================================================
 * 12/09/2016  |  Rajesh Pennam    | Initial Version                                         
 *             |          | 
 *=============+==========+================================================================
 */
 
 @istest
 
public class AIA_Imp_Insert_For_ApprovedCasesTest{
    public static testmethod void test1(){
        //start test
        Test.startTest();
        //insert users
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1);
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u6);
        user u7 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u7);  
        insert userList;
        //insert Account
        Account Acc = AIA_TestUtil.AIA_createAccount();
        //insert Account teams
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(Acc.Id,u7.id,'NASCO Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(Acc.Id,u1.id,'Account Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(Acc.Id,u2.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(Acc.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(Acc.Id,u4.id,'QA Auditor')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(Acc.Id,u5.id,'MAST Tech'));
        insert acctMbrList;
        //insert Opportunity
        Opportunity Opp = AIA_TestUtil.AIA_createopportunity(Acc.Id);
        //insert BRF 
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();     
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = Acc.id;
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Opportunity__c = Opp.Id;
        nbrf.Jurisdiction__c = 'MD';
        insert nbrf;
        //get Record type Id for NCr Cases
        Id RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA NCR Cases').getRecordTypeId();
        //insert Case
        Case c = new Case();
        c.Status = 'New';
        c.Origin = 'Web';
        c.AccountId = Acc.Id;
        c.Opportunity__c = Opp.Id;
        c.RecordTypeId = RecordTypeId;
        insert c;
        //Update case
        c.Status = 'Approved';
        update c;         
        Test.stopTest();
    }
}