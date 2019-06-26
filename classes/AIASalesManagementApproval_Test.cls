/*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 02/05/2019| Chaithra 	| T01 | replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*===========+============+=====+===================================================================
*/
@isTest
public class AIASalesManagementApproval_Test{
    public static testMethod void Test1(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List<user> userList = new list<user>();
        
        user user = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(User);
        
        user U1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(U1); 
        user U2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(U2);
        Insert userList;
        
        user user2 = AIA_TestUtil.AIA_createUser('alias2');
        user2.ManagerID = user.id;
        insert user2;
        
        Account a = AIA_TestUtil.CreateAccount('Test Account');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T01
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,U1.id,'Account Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,U2.id,'Account Executive')); 
        insert acctMbrList;
        
        Contact con = new Contact(AccountId=a.id,firstName='fname',LastName='lName',phone='123456677',Email ='test@test.com');
        insert con;
                
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        o.Business_Type__c = 'New';
        update o;
                
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.Account__c = a.id;
        nbrf.EGWP_Picklist__c = 'No';
        nbrf.FlexLink_Picklist__c = 'No';
        nbrf.Opportunity__c = o.id;
        nbrf.Request_Type__c ='Prospect/New';
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Benefit_Period__c = 'Calendar';
        nbrf.Control_Plan__c = '580';
        nbrf.Sales_Segment_Size__c = 'Labor';
        nbrf.Contract_Period__c = 'Non-Standard';
        nbrf.Number_of_Months_for_Contract_Period__c = 14; 
        nbrf.Grandfathered_Status__c = 'Mixed';
        nbrf.Grandfathered_PPACA_Status__c = 'Yes';
        nbrf.Stop_Loss__c = 'Preferred - HM';
        nbrf.Broker_Consultant_Compensation__c = 'Commission (%)';
        nbrf.Broker_Consultant_Amount__c = 3.5;
        nbrf.Contract_Count__c = 23;
        nbrf.Identity_Protection__c = 'Yes';
        nbrf.Enrollment_Type__c = 'Parallel';
        nbrf.Formulary__c = '1';
        nbrf.Maintenance_Choice__c = 'None';
        nbrf.Generic_Step_Therapy__c = 'No';
        nbrf.Tiers__c ='3';   
        insert nbrf; 
        
        System.runAs(user2) {
            AIASalesManagementApproval.SubmittoSalesManagementApproval(nbrf.id,a.id);
        }
    } 
    
    public static testMethod void Test2(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List<user> userList = new list<user>();
        
        user user = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(User); 
        
        user U1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(U1); 
        user U2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(U2);
        Insert userList;
        
        user user2 = AIA_TestUtil.AIA_createUser('alias2');
        user2.managerid = null;
        insert User2;
        
        Account a = AIA_TestUtil.CreateAccount('Test Account');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T01
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,U1.id,'Account Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,U2.id,'Account Executive')); 
        insert acctMbrList;
        
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        o.Business_Type__c = 'New';
        update o;
                
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.Account__c = a.id;
        nbrf.EGWP_Picklist__c = 'No';
        nbrf.FlexLink_Picklist__c = 'No';
        nbrf.Opportunity__c = o.id;
        nbrf.Request_Type__c ='Prospect/New';
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Benefit_Period__c = 'Calendar';
        nbrf.Control_Plan__c = '580';
        nbrf.Sales_Segment_Size__c = 'Labor';
        nbrf.Contract_Period__c = 'Non-Standard';
        nbrf.Number_of_Months_for_Contract_Period__c = 14; 
        nbrf.Grandfathered_Status__c = 'Mixed';
        nbrf.Grandfathered_PPACA_Status__c = 'Yes';
        nbrf.Stop_Loss__c = 'Preferred - HM';
        nbrf.Broker_Consultant_Compensation__c = 'Commission (%)';
        nbrf.Broker_Consultant_Amount__c = 3.5;
        nbrf.Contract_Count__c = 23;
        nbrf.Identity_Protection__c = 'Yes';
        nbrf.Enrollment_Type__c = 'Parallel';
        nbrf.Formulary__c = '1';
        nbrf.Maintenance_Choice__c = 'None';
        nbrf.Generic_Step_Therapy__c = 'No';
        nbrf.Tiers__c ='3';   
        insert nbrf; 
        
        System.runAs(user2) {
            try{
                AIASalesManagementApproval.SubmittoSalesManagementApproval(nbrf.id,a.id);
            }catch(exception e){}
                
        }
    }      
}