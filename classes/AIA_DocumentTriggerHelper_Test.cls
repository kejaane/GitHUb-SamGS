/****************************************************************************************************************************************************
*  Class            : AIA_DocumentTriggerHelper_Test
*  Author           : Asif Kutagulla
*  Description      : Test class for Helper class for AIA_DocumentTriggerHelper.
*                          ======[Modification Log]======
* ---------------------------------------------------------------------------------------------------------------------------------------------------
*  Author          Date-Modified      Tag       Description of Change
* ---------------------------------------------------------------------------------------------------------------------------------------------------
*  04-28-2017   |   Asif Kutagulla              Initial Creation
*  08-29-2017    |   Raviteja      | T01 |    Added test methods call to check scenario of 
owner is the deleting user,status
*  08-29-2017    |   Phani          | T02 |    Added test methods to verify 'Current BDD' for US477
*   06-08-2018   | raj kiran         | T03 |     Added code for role updates
*  23-10-2018   | Paritosh          | T04 |     Test for updateBenefitDesignDocumentUploadedField                  
*  01-17-2019    | Chaithra      | T05 |   Replaced Nasco Benefit coder and Ancilarry analyst roles with new roles as per US1702 and US1730
*   04-08-2019   | Petricia       | T06 |    Test for updateCurentBDD_UpdateOp
*  24-04-2019   | Petricia       | T07 |   Test for validateStatus method - US7455
****************************************************************************************************************************************************/
@isTest
private class AIA_DocumentTriggerHelper_Test {
    @testSetup static void testdata() {
        Test.startTest();
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
        accnt.NASCO_Account_Number__c='1234';   
        update accnt;
        
        //Creating WorkPlan Type Test Data 
        //AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales');//Commented per US210 
        
        //Creating User Test Data 
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        /**/  userList.add(u2);       
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8); 
        user u9 = AIA_TestUtil.AIA_createUser('alias9');
        userList.add(u9);
        user u10 = AIA_TestUtil.AIA_createUser('alias10');
        userList.add(u10);
        user u11 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u11); 
        user u12 = AIA_TestUtil.AIA_createUser('alias12');
        userList.add(u12);
        user u13 = AIA_TestUtil.AIA_createUser('alias13');
        userList.add(u13); 
        user u14 = AIA_TestUtil.AIA_createUser('alias14');
        userList.add(u14);
        
        user u15 = AIA_TestUtil.AIA_createUser('alias15');
        userList.add(u15);
        user u16 = AIA_TestUtil.AIA_createUser('alias16');
        userList.add(u16);
        //T05 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        //T05 ends
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T06
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T06
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); //T05 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'Benefit Coder'));// T05
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Benefit Tester')); //T05
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); //T05
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Vision Analyst'));//T05
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u18.id,'Pharmacy Operations')); //T05
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u16.id,'Settlements Analyst'));  //T03
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T03
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech')); //T03
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Implementation Manager'));
        insert acctMbrList;
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Updated per US210
        
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = accnt.id;
        //Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        //Imp.Benefit_Request_Form__c=brf.id;
        Imp.Risk_Type__c='ASO';
        insert Imp;
        AIA_Drawloop_Package_ID__c dd=new AIA_Drawloop_Package_ID__c();       
        dd.Name='Group Structure Request Form';
        dd.DDP_ID__c='a19V0000001KEAe';
        insert dd;
        //T06 - Start - AIA_Document test data
        AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
        AIA_Document__c aiaDoc1 = AIA_TestUtil.createAIADocument();
        //T06 -End
        
        Test.stopTest();   
    }
    private static testMethod void test1() {
        AIA_Document_Department_Mapping__c addm = new AIA_Document_Department_Mapping__c();
        addm.Name = 'Test';
        addm.Document_Type__c = 'Additional Documentation';
        addm.Department__c = 'Dep1';
        addm.Sub_Department__c = 'SubDep1';
        Database.saveResult sr = Database.insert(addm);
        
        Test.startTest();
        
        AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
        if(sr.isSuccess()){
            AIA_Document__c docm = [Select Id,Document_Type__c,Department__c,Sub_Department__c From AIA_Document__c Where Id=:aiaDoc.Id];
            system.assertEquals('Additional Documentation',docm.Document_Type__c);
            system.assertEquals('Dep1',addm.Department__c);
            system.assertEquals('SubDep1',addm.Sub_Department__c);
        }
        
        Test.StopTest();
    }
    
    private static testMethod void test2() {
        AIA_Document_Department_Mapping__c addm = new AIA_Document_Department_Mapping__c();
        addm.Name = 'Test';
        addm.Document_Type__c = 'Additional Documentation';
        addm.Department__c = 'Dep1';
        addm.Sub_Department__c = 'SubDep1';
        Database.saveResult sr = Database.insert(addm);
        
        Test.startTest();
        
        AIA_DocumentTriggerHelper.testExcep = True;
        AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
        
        list<Error_Log__c> eLogList = new list<Error_Log__c>();
        eLogList = [Select id From Error_Log__c];
        //system.assertEquals(1, eLogList.size());
        
        Test.StopTest();
    }
    
    /** T01 - start **/
    static testMEthod void DeleteAIADocument(){
        test.startTest();
        User a=AIA_TestUtil.AIA_createUser('testuser');
        insert a;
        system.assertNotEquals(a.id, null);
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].Id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        gsrf.Level_of_Participation__c ='Full Service'; // T03
        insert gsrf;
        AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
        aiaDoc.Group_Structure_Request_Form__c=gsrf.id;
        aiaDoc.Document_Type__c=AIA_Constants.DOCTYPE;
        update aiaDoc;
        try{
            delete aiaDoc;
        }
        catch(Exception e){
            system.debug('to cover error liine');
        }
        
        test.stopTest();
    }
    static testMEthod void DeleteAIADocumentOwner(){
        test.startTest();
        User a=AIA_TestUtil.AIA_createUser('testuser');
        insert a;
        system.assertNotEquals(a.id, null);
        List<AIA_Implementation__c> imp=[select id from AIA_Implementation__c limit 1];
        
        AIA_Group_Structure_Request_Form__c gsrf=new AIA_Group_Structure_Request_Form__c();
        gsrf.Implementation__c=imp[0].Id;
        gsrf.Par_Plan__c='580-DC zipcode range&690 for all others';
        gsrf.Processing_Type__c='Standard';
        gsrf.Level_of_Participation__c ='Full Service'; // T03
        insert gsrf;
        AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
        aiaDoc.Group_Structure_Request_Form__c=gsrf.id;
        aiadoc.OwnerId=a.id;
        update aiaDoc;
        try{
            delete aiaDoc;
        }
        catch(Exception e){
            system.debug('to cover error liine');
        }
        
        test.stopTest();
    }
    /** T01 - End **/
    /** T02 - Start **/
    private static testMethod void test3() {
        Test.startTest();
        AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument('Benefit Design Document','Approved');
        AIA_Document__c doc = [SELECT Id,AIA_Current_BDD__c FROM AIA_Document__c WHERE Document_Type__c='Benefit Design Document' and Approval_Status__c='Approved' ];
        AIA_DocumentTriggerHandler.afterUpdateRecursive=false;
        //System.assertEquals(True, doc.AIA_Current_BDD__c);
        Test.stopTest();
    }
    private static testMethod void test4() {
        AIA_Document__c aiaDoc1 = AIA_TestUtil.createAIADocument('Benefit Design Document','Approved');
        AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument('Benefit Design Document','Not Started');
        Test.startTest();
        aiaDoc.Document_Status__c='Draft';
        aiaDoc.Approval_Status__c='Approved';
        update aiaDoc;
        AIA_Document__c doc = [SELECT Id,AIA_Current_BDD__c,Document_Status__c,Approval_Status__c FROM AIA_Document__c WHERE Document_Type__c='Benefit Design Document' and Approval_Status__c='Approved'  and Document_Status__c='Draft'];
        Test.stopTest();
        AIA_Document__c doc1 = [SELECT Id,AIA_Current_BDD__c FROM AIA_Document__c WHERE Document_Type__c='Benefit Design Document' and Approval_Status__c='Approved'  and Document_Status__c='Complete'];
        //System.assertEquals(True, doc.AIA_Current_BDD__c);
        
    }
    /** T02 - End **/
    
    //T04 Start
    public static testmethod void test_updateBenefitDesignDocumentUploadedField(){
        
        Account accnt = [select id from Account limit 1];
        AIA_Implementation__c impl = [Select id from AIA_Implementation__c limit 1];
        
        AIA_Benefit_Design__c bd = new AIA_Benefit_Design__c();
        bd.Implementation__c = impl.id;
        bd.Account__c = accnt.Id;
        insert bd;
        Test.startTest();
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Status__c = 'Complete';
        aiaDoc.Document_Type__c = 'Benefit Design Document';
        aiaDoc.Active__c = True;
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Benefit_Design__c = bd.id;
        insert aiaDoc;
        Test.stopTest();
        
    }
    //T04 End
    //
    
    public static testmethod void test_approveGSDocument(){
        
        Account accnt = [select id from Account limit 1];
        AIA_Implementation__c impl = [Select id from AIA_Implementation__c limit 1];
        
        
        
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Type__c = 'Group Structure Document';
        aiaDoc.Active__c = True;
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Implementation__c = impl.id;
        aiaDoc.Source__c ='Implementation'; 
        insert aiaDoc;
        aiaDoc.Approval_Status__c = 'Approved';
        update aiaDoc;
        
        List<AIA_Document__c> docLst = new List<AIA_Document__c>{aiaDoc};
            AIA_DocumentTriggerHelper docHelper = new AIA_DocumentTriggerHelper();
        docHelper.updateGSdocimp(docLst);
        
    }
    //T06 -Start
    public static testmethod void test_updateCurentBDD_UpdateOp()
    {
        
        AIA_DocumentTriggerHandler.afterUpdateRecursive = false;
        AIA_Document_Department_Mapping__c addm = new AIA_Document_Department_Mapping__c();
        addm.Name = 'Test';
        addm.Document_Type__c = 'Additional Documentation';
        addm.Department__c = 'Dep1';
        addm.Sub_Department__c = 'SubDep1';
        Database.saveResult sr = Database.insert(addm);
        
        Test.startTest();
        
        AIA_DocumentTriggerHelper.testExcep = True;
        
        List<AIA_Document__c> docList = [select id,name,Approval_Status__c,AIA_Current_BDD__c,Document_Type__c from AIA_Document__C where Document_Type__c = 'Additional Documentation' Limit 2];
        
        system.debug('++++++++++docList'+docList);
        docList[1].Document_Type__c = 'Benefit Design Document';
        docList[1].Approval_Status__c = 'Approved';
        update docList[1];
        test.stoptest();
        
    }
    //T06 - End
    //T07 - Start
    public static testMethod void testRunAs() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        
        User u1 = [select id from user where ProfileId =:p.id and isActive = true limit 1];
        
        Account accnt = [select id from Account limit 1];
        AIA_Implementation__c impl = [Select id from AIA_Implementation__c limit 1];
        
        AIA_Benefit_Design__c bd = new AIA_Benefit_Design__c();
        bd.Implementation__c = impl.id;
        bd.Account__c = accnt.Id;
        insert bd;
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Status__c = 'Complete';
        aiaDoc.Document_Type__c = 'Benefit Design Document';
        aiaDoc.Active__c = True;
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Benefit_Design__c = bd.id;
        insert aiaDoc;
        aiaDoc.OwnerId = u1.id;
        update aiaDoc;
        bd.Status__c = 'In Review';
        update bd;
        
        System.runAs(u1) {
            try{
                delete aiaDoc;
            }
            catch(exception e)
            {
                system.debug('In run as Exception');
            }
            
            
        }
    }
    //T07 - End
    
}