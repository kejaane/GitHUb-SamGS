/*=========================================================================================
 * Purpose      : This is the test class for the class AIA_Create_New_BRF.
 * Developer    : Gayathri
 * Date 		: 04/03/2018
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date        Developer          Tag        Description
 *============+=================+=====+===========================================================
 * 10/12/2018	Paritosh			TO1		Added method to cover SaveBRF Exception
 * 02/08/2019		Chaithra	 |T02|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
 *=========================================================================================
 */

@isTest
public class AIA_Create_New_BRF_test {
	@testSetup
	public static void testdata()
    {
        //Creating account
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNOTEquals(acc,Null);      
        acc.Jurisdiction__c = 'MD';
        update acc;
        
        //Creating Account team members
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u3 =AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);
        insert userList;
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();T02
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Proposal Specialist')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Account Manager'));
        insert acctMbrList;
        
        //Commenting as part of US210
        /*//Creating workplan type 
        AIA_Workplan_Type__c WT = new AIA_Workplan_Type__c();
        WT.active__c = true;  
        WT.Workplan_Type__c ='New';
        WT.Used_For__c ='Pre-Sales';
        insert WT;
        system.assertNotEquals(null,WT.id);*/
        
        //Creating Opportunity
        Opportunity o = AIA_TestUtil.opp(acc.id);//Updating as part of US210
        o.Risk_Non_Risk__c = 'ASO';
        Update o;
        system.assertNotEquals(null,o.id);
        
        //Creating PRF
        PRF__c prf = AIA_TestUtil.CreatePRF(o.id);
    }
    
    public static testmethod void testGetBRFFields()
    {
        Account acc = [select id,name from Account Limit 1];
        Opportunity opp = [select id,name from Opportunity Limit 1]; 
        PRF__c prf = [select id,name from PRF__c limit 1];
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        Test.startTest();
        //Getting related Opportunity
        AIA_Create_New_BRF.getOpp(opp.id);
        //Getting related PRF
        AIA_Create_New_BRF.getPRF(prf.Id);
        //Getting the picklist values for the field Request Type
        AIA_Create_New_BRF.getselectOptions(brf,'Request_Type__c');
        //Getting the user permission for the field Request Type 
        AIA_Create_New_BRF.getBRFFields('Request_Type__c');
        //Getting the picklist values for the dependent picklist field
        AIA_Create_New_BRF.getDependentOptionsImpl('Benfit_Request_Form__c', 'Grandfathered_Status__c', 'Grandfathered_PPACA_Status__c');
        brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        brf.Funding_Arrangements__c = 'ASO';
        //Saving the BRF
        AIA_Create_New_BRF.saveBRF(brf);
        system.assertNotEquals(brf.Id,null);
        Test.stopTest();
        
    }
    
     public static testmethod void testSaveBRFException()
    {
        Profile pro = [SELECT Id FROM Profile WHERE Name='51+ Standard User - Custom']; 
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestclassUserBRF@testorg.com');
        insert u;
        
        System.runAs(u) {
        Account acc = [select id,name from Account Limit 1];
        Opportunity opp = [select id,name from Opportunity Limit 1]; 
        PRF__c prf = [select id,name from PRF__c limit 1];
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        Test.startTest();
        brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Number_of_Months_for_Contract_Period__c = 12;
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        brf.Funding_Arrangements__c = 'ASO';
        //Saving the BRF
        Try {
            AIA_Create_New_BRF.saveBRF(brf);
        }
        Catch (Exception e){
        }
        system.assertEquals(brf.Id,null);
        Test.stopTest();
        }
    }
}