/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================

*06/08/2018    phani      |T01|       Added code for role updates
*02/05/2019		Chaithra  |T02|		  Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*==================================================================================

*******************************************************************************************************/

@isTest
public class AIA_Acc_TeamMemAdd_controller_Test {

    @testSetup static void testdata() {
        
        Profile nonAdminProfile = [select id from profile where name='AIA 200+ Standard User - Custom'];
        Profile adminProfile = [select id from profile where name='System Administrator'];
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
        //Creating WorkPlan Type Test Data 
        //AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales');//Commented per US210 
        
         
        //Creating User Test Data 
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        u1.LastName = 'alias1';
        u1.ProfileId= nonAdminProfile.Id;
        /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
       u2.LastName = 'alias2';
        u2.ProfileId =nonAdminProfile.Id;
        /**/  userList.add(u2);
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        u3.LastName = 'alias3';
        u3.ProfileId=nonAdminProfile.Id;
        /**/  userList.add(u3); 
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
       u4.LastName = 'alias4';
        u4.ProfileId=nonAdminProfile.Id;
        /**/  userList.add(u4);
        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
       u5.LastName ='alias5';
        //u5.ProfileId=nonAdminProfile.Id;
        /**/  userList.add(u5);  
        
         user u6 = AIA_TestUtil.AIA_createUser('alias6');
       u6.LastName = 'alias6';
        u6.ProfileId=nonAdminProfile.Id;
        /**/  userList.add(u6);
         user u7 = AIA_TestUtil.AIA_createUser('alias7');
       u7.LastName = 'alias7';
        u7.ProfileId=nonAdminProfile.Id;
        /**/  userList.add(u7);
        
        
        user u8 = AIA_TestUtil.AIA_createUser('alias8');
       u7.LastName = 'alias8';
        u7.ProfileId=adminProfile.Id;
        /**/  userList.add(u8);
        insert userList;
               
        List<AIA_Area_Manager__c> userEntryList = new list<AIA_Area_Manager__c>();
        AIA_Area_Manager__c usrEntry1 = new AIA_Area_Manager__c();
        usrEntry1.Area_Manager__c = u1.id;
        usrEntry1.Area_Belong_to__c = 'Account Dedicated Representative'; //T01 
        usrEntry1.Name = 'alias1';
        usrEntry1.RecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Non-Manager').getRecordTypeId(); 
        userEntryList.add(usrEntry1);
        
        AIA_Area_Manager__c usrEntry2 = new AIA_Area_Manager__c();
        usrEntry2.Area_Manager__c = u2.id;
        usrEntry2.Area_Belong_to__c = 'Account Executive';
        usrEntry2.Name = 'alias2';
        usrEntry2.RecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Non-Manager').getRecordTypeId(); 
        userEntryList.add(usrEntry2);
        
        AIA_Area_Manager__c usrEntry3 = new AIA_Area_Manager__c();
        usrEntry3.Area_Manager__c = u3.id;        
        usrEntry3.Name = 'alias3';
        usrEntry3.Areas__c = 'Account Dedicated Representative'; //T01 
        usrEntry3.RecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Manager').getRecordTypeId(); 
        userEntryList.add(usrEntry3);
        
        AIA_Area_Manager__c usrEntry4 = new AIA_Area_Manager__c();
        usrEntry4.Area_Manager__c = u4.id;
        usrEntry4.Area_Belong_to__c = 'Implementation Manager';
        usrEntry4.Areas__c = 'Account Executive;AIA Admin';
        usrEntry4.Name = 'alias4';
        usrEntry4.RecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Manager').getRecordTypeId(); 
        userEntryList.add(usrEntry4);
        
        /*AIA_Area_Manager__c usrEntry5 = new AIA_Area_Manager__c();
        usrEntry5.Area_Manager__c = u6.id;
        usrEntry5.Area_Belong_to__c = 'NASCO Benefit Coder';
        usrEntry5.Name = 'alias6';
        usrEntry5.RecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Non-Manager').getRecordTypeId(); 
        userEntryList.add(usrEntry5);*/ // T02 Commented 
                
        AIA_Area_Manager__c usrEntry6 = new AIA_Area_Manager__c();
        usrEntry6.Area_Manager__c = u7.id;
        usrEntry6.Area_Belong_to__c = 'BeneFact Coder';
        usrEntry6.Name = 'alias7';
        usrEntry6.RecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Non-Manager').getRecordTypeId(); 
        userEntryList.add(usrEntry6);
        insert userEntryList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u6.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'BeneFact Coder'));
         
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T02
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        insert acctMbrList;
        
        
         Opportunity opp = AIA_TestUtil.CreateOpportunity(accnt.Id);
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
        WTTList.add(WTT50); 
        
        insert WTTList;
        
        Dependent_Workplan_Task__c DWT = new Dependent_Workplan_Task__c();
        DWT.Dependent_Task__c = WTT50.id;
        DWT.Primary_Task__c = WTT60.id;
        
        insert DWT;
       
       
               
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl.Id);        
        List<Sub_Process__c> objSubProc = AIA_TestUtil.CreateSubProcessList(objImpl.Id,objProcess[0].Id); 
        
        List<Workplan_Task__c> WTList = new List<Workplan_Task__c>();
        Workplan_Task__c WT3 = new Workplan_Task__c();
        WT3.AccountID__c = accnt.id;
        WT3.Description__c = 'This is primary task';
        WT3.RelatedObjectId__c = objImpl.id;
        WT3.Status__c = 'In Progress';
        WT3.Task_Owner__c = 'Ancillary Analyst';
        WT3.Task_Owner_Type__c = 'Account Team';
        WT3.Send_Notification__c=True;
        WT3.Workplan_Task_Template__c = WTT60.id;
        WT3.Sub_Process__c = objSubProc[0].Id;
        WT3.Implementation__c = objImpl.id;
        WTList.add(WT3);
        
        Workplan_Task__c WT3a = new Workplan_Task__c();
        WT3a.AccountID__c = accnt.id;
        WT3a.Description__c = 'This is dependent task';
        WT3a.RelatedObjectId__c = objImpl.id;
        WT3a.Status__c = 'In Progress';
        WT3a.Task_Owner__c = 'Ancillary Analyst';
        WT3a.Task_Owner_Type__c = 'Account Team';
        WT3a.Send_Notification__c=True;
        WT3a.Workplan_Task_Template__c = WTT50.id;
        WT3a.Sub_Process__c = objSubProc[0].Id;
        WT3a.Implementation__c = objImpl.id;
        WTList.add(WT3a);
        insert WTList;
    }
  @isTest
     
    public static void checkWithSystemAdminUser(){
        AIA_Acc_TeamMemAdd_controller ctrller;
        User nonAadminUser = [SELECT ID FROM User WHERE alias= 'alias8'];
        List<Account> accList = [SELECT Id FROM Account];        
        //T04-Start
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(accList[0]);
        AIA_Acc_TeamMemAdd_controller stdctrller = new AIA_Acc_TeamMemAdd_controller(stdcontroller);
        stdctrller.listView();
        //T04-End
        ApexPages.StandardSetController stdSetcontroller = new ApexPages.StandardSetController(accList);
        stdSetcontroller.setSelected(accList);
        //ApexPages.StandardController stdcontroller = new ApexPages.StandardController(new Account());
        Test.startTest();
        System.runAs(nonAadminUser){
        PageReference pref = Page.AIA_Account_Team_member_Add;
        ctrller = new AIA_Acc_TeamMemAdd_controller(stdSetcontroller);
        ctrller.AIA_AccountTeamMember();
         ctrller.addTeamMember();   
        //System.debug(ctrller.allowedUsers.Size());
        
        }
        Test.stopTest();
        List<AIA_Area_Manager__c> recCount = [SELECT Id FROM AIA_Area_Manager__c];
        //System.assertEquals(recCount.size(), ctrller.allowedUsers1.Size());
        //System.assertEquals(recCount.size(), ctrller.atmwrap.users.Size());
        //atmwrap.users
    }
    
    @isTest
    public static void checkWithNonAdminUser(){
        AIA_Acc_TeamMemAdd_controller ctrller;
        User adminUser = [SELECT ID FROM User WHERE alias= 'alias3'];
        List<Account> accList = [SELECT Id FROM Account];        
        ApexPages.StandardSetController stdSetcontroller = new ApexPages.StandardSetController(accList);
        stdSetcontroller.setSelected(accList);
        //ApexPages.StandardController stdcontroller = new ApexPages.StandardController(new Account());
        Test.startTest();
        System.runAs(adminUser){
        PageReference pref = Page.AIA_Account_Team_member_Add;
        ctrller = new AIA_Acc_TeamMemAdd_controller(stdSetcontroller);
        ctrller.AIA_AccountTeamMember();
       // System.debug(ctrller.allowedUsers.Size());
        
        }
        Test.stopTest();
        List<AIA_Area_Manager__c> recCount = [SELECT Id FROM AIA_Area_Manager__c WHERE Area_Belong_to__c ='Account Dedicated Representative' ] ; //T01 
        //System.assertEquals(recCount.size(), ctrller.atmwrap.users.Size());        
    }
    
    @isTest
    public static void checkWithAIAAdminUser(){
        AIA_Acc_TeamMemAdd_controller ctrller;
        User adminUser = [SELECT ID FROM User WHERE alias= 'alias4'];
        List<Account> accList = [SELECT Id FROM Account];        
        ApexPages.StandardSetController stdSetcontroller = new ApexPages.StandardSetController(accList);
        stdSetcontroller.setSelected(accList);
        //ApexPages.StandardController stdcontroller = new ApexPages.StandardController(new Account());
        Test.startTest();
        System.runAs(adminUser){
        PageReference pref = Page.AIA_Account_Team_member_Add;
        ctrller = new AIA_Acc_TeamMemAdd_controller(stdSetcontroller);
        ctrller.AIA_AccountTeamMember();
        //System.debug(ctrller.allowedUsers.Size());
        
        }
        Test.stopTest();
        List<AIA_Area_Manager__c> recCount = [SELECT Id FROM AIA_Area_Manager__c  ];
        //System.assertEquals(recCount.size(), ctrller.atmwrap.users.Size());
        ctrller.addTeamMemberPopup();
        ctrller.cancelTeamPop();
        
    }
    
    @isTest
   public static void insertMemNonAdminUser(){
        AIA_Acc_TeamMemAdd_controller ctrller;
        User nonAdminUser = [SELECT ID FROM User WHERE alias= 'alias3'];
        User newTeamMem = [SELECT ID,Name FROM User WHERE alias= 'alias1'];
       System.debug('newTeamMem'+newTeamMem);
        List<Account> accList = [SELECT Id FROM Account LIMIT 1];        
        ApexPages.StandardSetController stdSetcontroller = new ApexPages.StandardSetController(accList);
        stdSetcontroller.setSelected(accList);
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(new Account());
       
        System.runAs(nonAdminUser){
        PageReference pref = Page.AIA_Account_Team_member_Add;
        ctrller = new AIA_Acc_TeamMemAdd_controller(stdSetcontroller);
        ctrller.AIA_AccountTeamMember();
        //System.debug(ctrller.allowedUsers.Size());       
       // AIA_Acc_TeamMemAdd_controller.ATMWrapperCls wrap = new AIA_Acc_TeamMemAdd_controller.ATMWrapperCls();
            AIA_Acc_TeamMemAdd_controller.ATMWrapperCls wrap = ctrller.lstATMWrappercls[0];
       
        //T02 Starts
        /*wrap.ATM.userId = newTeamMem.Id;
        wrap.ATM.TeamMemberRole = 'Account Dedicated Representative'; //T01
        wrap.UserName = newTeamMem.Name;*/
        wrap.ATM.UserId__c=newTeamMem.Id;
        wrap.ATM.TeamMemberRole__c ='Account Dedicated Representative';
        wrap.UserName=newTeamMem.Name;
        //T02 Ends
        
        wrap.transferable = 'Yes';
            Test.startTest();
         //ctrller.lstATMWrappercls.add(wrap);
            
        ctrller.addTeamMember();
         ctrller.rowToRemove = 1;
        ctrller.removeRowFromList();
        ctrller.listView();
         Apexpages.currentPage().getParameters().put('param1','Account Dedicated Representative'); //T01 
             Apexpages.currentPage().getParameters().put('param2','1');
           ctrller.populateRole();
            ctrller.addTeamMemberPopup();
            ctrller.cancelTeamPop();
        
        }
      Test.stopTest();              
   }
 

}