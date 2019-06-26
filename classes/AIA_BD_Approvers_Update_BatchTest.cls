@isTest
public class AIA_BD_Approvers_Update_BatchTest {
@testSetup
    static public void testSetup()
    {
        //Test.startTest();
        Account acc = AIA_TestUtil.AIA_createAccount();
        
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2); 
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3); 
        user u4 =AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5);
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u7 = AIA_TestUtil.AIA_createUser('alias7');        
        userList.add(u7); 
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);
        user u9 = AIA_TestUtil.AIA_createUser('alias9');
        userList.add(u9);
        user u10 = AIA_TestUtil.AIA_createUser('alias10');
        userList.add(u10);
        user u11 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u11);
        user u12 = AIA_TestUtil.AIA_createUser('dm1');
        userList.add(u12);
        //Creating User Test Data T01 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias19');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias20');
        userList.add(u20);
        //T01 ends
        
        insert userList; 
               
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,AIA_Constants.IMP_MANAGER));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,AIA_Constants.QA_AUDITOR));
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,AIA_Constants.SALES_SERVICE_REP)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,AIA_Constants.ACCOUNTEXECUTIVE)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,AIA_Constants.PROPOSALSPECIALIST)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u6.id,AIA_Constants.UNDERWRITER));
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,AIA_Constants.NASCO_BENEFIT_CODER)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,AIA_Constants.BENEFACT_CODER)); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,AIA_Constants.ANCILLARY_ANALYST)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,AIA_Constants.MAST_TECH));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,AIA_Constants.CONTRACT_TECH));
        //Creating AccountMember Test Data T01 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
        //T01 ends
        insert acctMbrList;
        
        Test.startTest();
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
    o.StageName = 'RFP';
    o.FullServiceProducer__c = 'Direct';
    insert o;
        
        Benfit_Request_Form__c brfSource = new Benfit_Request_Form__c();
    brfSource.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
    brfSource.Contract_Count__c = 123;
    brfSource.Benefit_Effective_Date__c = system.today();
    brfSource.Account__c = acc.id;
    brfSource.ARC_Approval_Status__c = '';//'Approved by Committee';
    brfSource.Escalated_to_Senior_Management__c = true;
    brfSource.Status__c = 'new';
    brfSource.Opportunity__c = o.id;
    brfSource.Jurisdiction__c = 'MD';
    brfSource.Enrollment_Type__c = 'Cafeteria';
    brfSource.Request_Type__c = 'Prospect/New';
    insert brfSource;
    system.assertNOTEquals(brfSource,Null);
        
    
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
    aiapln.Plan_Name__c='Test Plan';
    aiapln.Product_Status__c = 'Active';
    aiapln.Plan_Id__c='PLAN-Test';
    aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
    aiapln.Jurisdiction__c = 'MD';
    aiapln.Has_Benefit_Summary__c=true;
    insert aiapln;
        
    Proposed_Products__c pp = new Proposed_Products__c();           
    pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
    pp.Benefit_Request_Form__c = brfSource.id;
    pp.Funding_Arrangement__c = 'ASO';
    pp.Product_Category__c = 'Medical';
    pp.Product_Line__c = 'PPO';
    pp.Plan_Name__c = aiapln.id;
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
    insert pp;
        
    AIA_Implementation__c Imp1 = new AIA_Implementation__c();
    Imp1.Name__c = 'testprf';
    Imp1.Opportunity__c = o.Id;
    Imp1.Account__c = acc.Id;
    Imp1.Effective_Date__c = system.today();
    Imp1.Implementation_Plan_Timeline_Days__c = '60';
    Imp1.Risk_Type__c='ASO';
    Imp1.Benefit_Request_Form__c = brfSource.id;
    insert Imp1; 
        
    
    AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
    aiaBD.Implementation__c = Imp1.id;
    aiaBD.Account__c = acc.Id;
    aiaBD.Benefit_Request_Form__c = brfSource.Id;
    aiaBD.Approver_Benefit_Coder__c = u1.id;
    aiaBD.Approver_Ancillary_Analyst__c = u2.id;
    aiaBD.Approver_Contract_Tech__c = u3.id;
    aiaBD.AIA_Approver_Benefact_Coder__c    = u8.id;
    aiaBD.AIA_Approver_MAST_Tech__c = u9.id;
    aiaBD.Approver_Vision_Analyst__c = u20.id;
    aiaBD.Approver_Pharmacy_Operations__c = u19.id;
    aiaBD.AIA_Approver_Benefit_Tester__c =u17.id;
    aiaBD.AIA_Approver_Benefit_Coder__c = u18.id;
        aiaBD.Approval_Status_Analyst__c='N/A';
        aiaBD.AIA_Approval_Status_Contract_Tech__c='N/A';
        aiaBD.AIA_Approval_Status_NASCO_Benefit_Coder__c='N/A';
        aiaBD.AIA_Approval_Status_Benefact_Coder__c='N/A';
        aiaBD.Approval_Status_MAST_Tech__c='N/A';
        aiaBD.Approval_Status_Vision_Analyst__c='N/A';
        aiaBD.Approval_Status_Pharmacy_Operations__c='N/A';
        aiaBD.AIA_Approval_Status_Benefit_Tester__c='N/A';
        aiaBD.AIA_Approval_Status_Benefit_Coder__c='N/A';
        
    insert aiaBD; 
        //List<AccountTeamMember> atmLst = [Select Id,TeammemberRole,accountId,userId from AccountTeamMember where AccountId =:acc.id and TeamMemberRole IN ('MAST Tech','Contract Tech','NASCO Benefit Coder','BeneFact Coder')];
     	List<Account_Team__c> atmLst=[Select Id,TeamMemberRole__c,AccountId__c,UserId__c from Account_Team__c where AccountId__c =:acc.id and TeamMemberRole__c IN ('MAST Tech','Contract Tech','BeneFact Coder')];
        Delete atmLst;
        
     /*//List<AccountTeamMember> acctMbrList1 = new List<AccountTeamMember>();
     List<Account_Team__c> acctMbrList1= new List<Account_Team__c>();
     //acctMbrList1.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.Id,'NASCO Benefit Coder')); 
     acctMbrList1.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'MAST Tech'));
     acctMbrList1.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Contract Tech'));
     acctMbrList1.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'BeneFact Coder'));
     //acctMbrList1.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Ancillary Analyst'));
     insert acctMbrList1;*/
       

   /* u1.IsActive=false;
        u2.IsActive=false;
        u3.IsActive=false;
        u4.IsActive=false;
        u5.IsActive=false;
        u6.IsActive=false;
        u7.IsActive=false;
        u8.IsActive=false;
        u9.IsActive=false;
        u10.IsActive=false;
        u11.IsActive=false;
        u12.IsActive=false;*/
      Test.stopTest();  
     
    }
    
    @isTest
    public static void testBDApproversBatch(){
                List<user> us=[select id,isactive from user where alias in('alias1','alias2','alias3','alias4','alias5','alias6','alias7','alias8','alias9','alias10','alias11','alias12','alias17','alias18','alias19','alias20')];

                Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
		User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        
        //AIA_BD_Approvers_Update_Batch updateBD = new AIA_BD_Approvers_Update_Batch();
        // Database.executeBatch(updateBD, 200);
        test.startTest();

                System.runAs(user) { 

        for(user u:us){
            u.isActive=false;
        }
        update us;
                }
        AIA_BD_Approvers_Update_Batch abs= new AIA_BD_Approvers_Update_Batch();
        String schedule = '0 0 23 * * ?';
        String jobId = System.schedule('Test Batch',schedule,abs);
        test.stopTest();
        
    }
  
}