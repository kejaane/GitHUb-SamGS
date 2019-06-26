@isTest
public class AIA_Workplan_BatchTest {
@testSetup
    static public void testSetup()
    {
        
        
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
        
        //delegated manager
        user u12 = AIA_TestUtil.AIA_createUser('dm1');
        userList.add(u12);
        
        insert userList; 
        
        
        //Area manager data
        AIA_Area_Manager__c am1 = new AIA_Area_Manager__c(Area_Manager__c = u1.Id, Delegated_Manager_1__c = u12.id);
        AIA_Area_Manager__c am2 = new AIA_Area_Manager__c(Area_Manager__c = u2.Id, Delegated_Manager_2__c = u12.id);
        AIA_Area_Manager__c am3 = new AIA_Area_Manager__c(Area_Manager__c = u3.Id);
        final List<AIA_Area_Manager__c> areaManagers = new List<AIA_Area_Manager__c>{am1, am2, am3};
		insert areaManagers;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Implementation Manager'));
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,AIA_Constants.ANCILLARY_ANALYST));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,AIA_Constants.SALES_SERVICE_REP)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,AIA_Constants.ACCOUNTEXECUTIVE)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,AIA_Constants.PROPOSALSPECIALIST)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u6.id,AIA_Constants.UNDERWRITER));
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,AIA_Constants.NASCO_BENEFIT_CODER)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,AIA_Constants.BENEFACT_CODER)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,AIA_Constants.QA_AUDITOR)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,AIA_Constants.MAST_TECH));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,AIA_Constants.SALES_ASSISTANT));   
        insert acctMbrList;
        
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        AIA_Implementation__c objImpl = AIA_TestUtil.CreateImplementation(opp.Id);
        
        List<Workplan_Task_Template__c> WTTList = new List<Workplan_Task_Template__c>();
         
        Workplan_Task_Template__c WTT60 = new Workplan_Task_Template__c();
        WTT60.Description__c = 'Complete AIA_Group_Structure_Request_Form__c';
        WTT60.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT60.Status__c = 'Not-Started';
        WTT60.Task_Completion_Events__c = 'Update';
        WTT60.Task_Completion_Expression__c = '2';
        WTT60.Task_Creation_Criteria_Expression__c = '';
        WTT60.Task_Creation_Events__c = 'Insert';
        WTT60.Task_Owner__c = '';
        WTT60.Task_Owner_Type__c = 'Account Team Role';
        WTT60.Task_Type__c = 'Manual / SF should auto close this task';
        WTT60.Acc_Team_Role_for_New_Business__c=AIA_Constants.ANCILLARY_ANALYST;
        WTT60.Acc_Team_Role_for_Renewal_Business__c = AIA_Constants.ANCILLARY_ANALYST;
        WTTList.add(WTT60);
        
        Workplan_Task_Template__c WTT50 = new Workplan_Task_Template__c();
        WTT50.Description__c = 'Complete implementation';
        WTT50.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT50.Status__c = 'Not-Started';
        WTT50.Task_Completion_Events__c = 'Update';
        WTT50.Task_Completion_Expression__c = '2';
        WTT50.Task_Creation_Criteria_Expression__c = '';
        WTT50.Task_Creation_Events__c = 'Insert';
        WTT50.Task_Owner__c = '';
        WTT50.Task_Owner_Type__c = 'Account Team Role';
        WTT50.Task_Type__c = 'Manual / SF should auto close this task';
        WTT50.Acc_Team_Role_for_New_Business__c='Implementation Manager';
        WTT50.Acc_Team_Role_for_Renewal_Business__c = 'Implementation Manager';
        WTTList.add(WTT50); 
        
        Workplan_Task_Template__c WTT70 = new Workplan_Task_Template__c();
        WTT70.Description__c = 'Complete implementation';
        WTT70.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT70.Status__c = 'Not-Started';
        WTT70.Task_Completion_Events__c = 'Update';
        WTT70.Task_Completion_Expression__c = '2';
        WTT70.Task_Creation_Criteria_Expression__c = '';
        WTT70.Task_Creation_Events__c = 'Insert';
        WTT70.Task_Owner__c = '';
        WTT70.Task_Owner_Type__c = 'Account Team Role';
        WTT70.Task_Type__c = 'Manual / SF should auto close this task';
        WTT70.Acc_Team_Role_for_New_Business__c='Implementation Manager';
        WTT70.Acc_Team_Role_for_Renewal_Business__c = 'Implementation Manager';
        WTTList.add(WTT70);
        
        insert WTTList;
        
              
               
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl.Id);        
        List<Sub_Process__c> objSubProc = AIA_TestUtil.CreateSubProcessList(objImpl.Id,objProcess[0].Id); 
        List<Workplan_Task__c> WTList = new List<Workplan_Task__c>();
        Workplan_Task__c WT3 = new Workplan_Task__c();
        WT3.AccountID__c = acc.id;
        WT3.Description__c = 'This is primary task';
        WT3.RelatedObjectId__c = objImpl.id;
        WT3.Status__c = 'Not Started';
        WT3.Task_Owner__c = 'Ancillary Analyst';
        WT3.Task_Owner_Type__c = 'Account Team';
        WT3.Send_Notification__c=True;
        WT3.Workplan_Task_Template__c = WTT60.id;
        WT3.Sub_Process__c = objSubProc[0].Id;
        WT3.Implementation__c = objImpl.id;
        WTList.add(WT3);
        
        Workplan_Task__c WT3a = new Workplan_Task__c();
        WT3a.AccountID__c = acc.id;
        WT3a.Description__c = 'This is dependent task';
        WT3a.RelatedObjectId__c = objImpl.id;
        WT3a.Status__c = 'Not Started';
        WT3a.Task_Owner__c = 'Ancillary Analyst';
        WT3a.Task_Owner_Type__c = 'Account Team';
        WT3a.Send_Notification__c=True;
        WT3a.Workplan_Task_Template__c = WTT50.id;
        WT3a.Sub_Process__c = objSubProc[0].Id;
        WT3a.Implementation__c = objImpl.id;
        WTList.add(WT3a);
        
        Workplan_Task__c WT4 = new Workplan_Task__c();
        WT4.AccountID__c = acc.id;
        WT4.Description__c = 'This is primary task for not required';
        WT4.RelatedObjectId__c = objImpl.id;
        WT4.Status__c = 'Not Started';
        WT4.Task_Owner__c = 'Ancillary Analyst';
        WT4.Task_Owner_Type__c = 'Account Team';
        WT4.Send_Notification__c=True;
        WT4.Workplan_Task_Template__c = WTT60.id;
        WT4.Sub_Process__c = objSubProc[0].Id;
        WT4.Implementation__c = objImpl.id;
        WTList.add(WT4);
        
        Workplan_Task__c WT4a = new Workplan_Task__c();
        WT4a.AccountID__c = acc.id;
        WT4a.Description__c = 'This is dependent task for not required';
        WT4a.RelatedObjectId__c = objImpl.id;
        WT4a.Status__c = 'Not Started';
        WT4a.Task_Owner__c = 'Ancillary Analyst';
        WT4a.Task_Owner_Type__c = 'Account Team';
        WT4a.Send_Notification__c=True;
        WT4a.Workplan_Task_Template__c = WTT50.id;
        WT4a.Sub_Process__c = objSubProc[0].Id;
        WT4a.Implementation__c = objImpl.id;
        WTList.add(WT4a);
		
        Workplan_Task__c WT5a = new Workplan_Task__c();
        WT5a.AccountID__c = acc.id;
        WT5a.Description__c = 'This is dependent task for not required';
        WT5a.RelatedObjectId__c = objImpl.id;
        WT5a.Status__c = 'Not required';
        WT5a.Task_Owner__c = 'Ancillary Analyst';
        WT5a.Task_Owner_Type__c = 'Account Team';
        WT5a.Send_Notification__c=True;
        WT5a.Workplan_Task_Template__c = WTT50.id;
        WT5a.Sub_Process__c = objSubProc[0].Id;
        WT5a.Implementation__c = objImpl.id;
        WTList.add(WT5a);
		system.runas(u2)
        {
          insert WTList;  
        }
        
        
    }
    @isTest
    public static void testInactivateATMDelegation(){
        
        //deactivate users
        final List<User> deactivateUsers = [select id from User
                                      where alias in ('alias1','alias2', 'alias3')];
        deactivateUsers[0].isActive = false;
        deactivateUsers[1].isActive = false;
        deactivateUsers[2].isActive = false;
        update deactivateUsers;
        //system.assertEquals([select id,OwnerId,owner.Name from Workplan_Task__c where (Status__c= 'Not Started' or Status__c= 'In Progress')],null);
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        Test.startTest();
        system.runAs(user){
        //call Batch
        AIA_Workplan_BatchClass atmBatch =  new AIA_Workplan_BatchClass();
        Database.executeBatch(atmBatch);
            /*
        Database.BatchableContext BC;
        atmBatch.start(BC);
            atmBatch.execute(BC,deactivateUsers);
             atmBatch.finish(BC);*/
    }
        Test.stopTest();
            
    }
}