@isTest(SeeAlldata=true)
public class AIA_Workplan_Task_Management_Test {
    static testMethod void Test0() {
        Account a=new Account();
        a.NAme='Test';
        a.Account_Legal_Name__c='Test';
        insert a;
        
        /*R1 added teammember*/
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  userList.add(u1); 
        
        
        
        user u10= AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u10);
        user u11= AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u11);
        user u2 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u2);
        user u3= AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u3);
        user u4 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u4);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
        insert userlist;
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u10.id,'NASCO Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u11.id,'Underwriter'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'BeneFact Coder'));
        
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u3.id,'Ancillary Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'MAST Tech'));
        
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u14.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u15.id,'Account Manager'));
        insert acctMbrList;
        /*R1 added teammember*/
        Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Names';
        //WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT4.Status__c = 'Not-Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = 'AIA_Implementation__c';
        //WTT4.Task_Completion_Expression__c ='(1 OR 1)';
        WTT4.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Manual / SF should auto close this task';
        //WTT4.Workplan_Task_Rules__c=
        insert WTT4;
        
        Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
        
        WTR.Field_API_Name__c = 'Status__c';
        WTR.Object_API_Name__c = 'AIA_Implementation__c';
        WTR.Object_DML_Event__c = 'Insert';
        WTR.Operation__c = 'Equal To';
        WTR.Rule_Number__c = 1;
        WTR.Value__c = 'In-Progress';
        WTR.Workplan_Task_Template__c = WTT4.id;
        WTR.Criteria_Type__c = 'Task Completion Criteria';
        
        insert WTR;
        
        
        Dependent_Workplan_Task__c DWT = new Dependent_Workplan_Task__c();
        DWT.Dependent_Task__c = WTT4.id;
        DWT.Primary_Task__c = WTT4.id;
        
        insert DWT;
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.Id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
        
        List<AIA_Implementation__c > ailist=new List<AIA_Implementation__c >();
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = a.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = brf.id;
        
        ailist.add(Imp);
        insert ailist;
        
        List<AIA_Document__c> doc=new list<AIA_Document__c >();
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Status__c = 'Complete';
        aiaDoc.Document_Type__c = 'Cede Document';
        aiaDoc.Active__c = True;
        aiadoc.Document_Name__c = 'Test';
        aiadoc.source__c = 'Benefit Request Form';
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Approval_Status__c = 'Approved';
        aiadoc.Opportunity__c=o.id;  
        aiadoc.Benefit_Request_Form__c = brf.id;
        //aiadoc.Benefit_Design_Product__c=ab.id;
        aiadoc.Implementation__c= imp.id; 
        aiaDoc.Sub_Department__c = 'Benefits Summaries';
        aiaDoc.Category__c = 'Opportunity';
        insert aiaDoc;
        doc.add(aiaDoc);
        //insert doc;
        
        Workplan_Task__c WT = new Workplan_Task__c();
        WT.AccountID__c = a.id;
        WT.Description__c = 'Verify Account Legal Name';
        WT.Opportunity__c = o.id;
        //WT.Opportunity__c = doc[0].id;
        WT.RelatedObjectId__c = ailist[0].id;
        WT.Status__c = 'Completed';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
        insert WT;
        
        
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        // acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u1.id,'NASCO Benefit Coder')); 
        
        //insert acctMbrList;
        
        Map<Id,AIA_Document__c> aiaDocMap = new Map<Id,AIA_Document__c>();
        for(AIA_Document__c aiaDoc2:doc)
        {
            aiaDocMap.put(aiaDoc2.Id,aiaDoc2);
        }
        AIA_Workplan_Task_Management awt=new AIA_Workplan_Task_Management();
        awt.createWorkplanTasksForSObject('Insert',aiaDocMap,'AIA_Document__c');
        
        
        Map<Id,AIA_Implementation__c> IMPMap = new Map<Id,AIA_Implementation__c>();
        for(AIA_Implementation__c imp2:ailist)
        {
            IMPMap.put(imp2.Id,imp2);
        }
        
        
        AIA_Workplan_Task_Management awt2=new AIA_Workplan_Task_Management();
        awt2.createWorkplanTasksForSObject('Insert',IMPMap,'AIA_Implementation__c');
        
        
    }
    static testMethod void Test1() {
        Account a=new Account();
        a.NAme='Test';
        a.Account_Legal_Name__c='Test';
        insert a;
        
        /*R1 added teammember*/
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  userList.add(u1); 
        user u10 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u10);
        user u11 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u11);
        user u2 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u2);
        user u3= AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u3);
        user u4 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u4);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
        insert userlist;
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u10.id,'NASCO Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u11.id,'Underwriter'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'BeneFact Coder'));
        
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u3.id,'Ancillary Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'MAST Tech'));
        
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u14.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u15.id,'Account Manager'));
        insert acctMbrList;
        /*R1 added teammember*/
        
        Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Names';
        //WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT4.Status__c = 'Not-Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = 'AIA_Implementation__c';
        //WTT4.Task_Completion_Expression__c ='(1 OR 1)';
        WTT4.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Manual / SF should auto close this task';
        //WTT4.Workplan_Task_Rules__c=
        insert WTT4;
        
        Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
        
        WTR.Field_API_Name__c = 'Status__c';
        WTR.Object_API_Name__c = 'AIA_Implementation__c';
        WTR.Object_DML_Event__c = 'Insert';
        WTR.Operation__c = 'Equal To';
        WTR.Rule_Number__c = 1;
        WTR.Value__c = 'In-Progress';
        WTR.Workplan_Task_Template__c = WTT4.id;
        WTR.Criteria_Type__c = 'Task Completion Criteria';
        
        insert WTR;
        
        
        List<Workplan_Task_Rules__c> WTRList = new List<Workplan_Task_Rules__c>();
        
        Workplan_Task_Rules__c WTR6 = new Workplan_Task_Rules__c();
        WTR6.Field_API_Name__c = 'Status__c';
        WTR6.Object_API_Name__c = 'AIA_Implementation__c';
        WTR6.Object_DML_Event__c = 'Insert';
        WTR6.Operation__c = 'Equal To';
        WTR6.Rule_Number__c = 2;
        WTR6.Value__c = 'In-Progress';
        WTR6.Workplan_Task_Template__c = WTT4.id;
        WTR6.Criteria_Type__c = 'Task Completion Criteria';
        
        WTRList.add(WTR6);
        
        Workplan_Task_Rules__c WTR7 = new Workplan_Task_Rules__c();
        WTR7.Field_API_Name__c = 'Status__c';
        WTR7.Object_API_Name__c = 'AIA_Implementation__c';
        WTR7.Object_DML_Event__c = 'Update';
        WTR7.Operation__c = 'Equal To';
        WTR7.Rule_Number__c = 2;
        WTR7.Value__c = 'In-Progress';
        WTR7.Workplan_Task_Template__c = WTT4.id;
        WTR7.Criteria_Type__c = 'Task Creation Criteria';
        
        WTRList.add(WTR7);
        
        insert WTRList;
        
        Dependent_Workplan_Task__c DWT = new Dependent_Workplan_Task__c();
        DWT.Dependent_Task__c = WTT4.id;
        DWT.Primary_Task__c = WTT4.id;
        
        insert DWT;
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.Id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
        
        List<AIA_Implementation__c > ailist=new List<AIA_Implementation__c >();
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = a.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = brf.id;
        
        ailist.add(Imp);
        insert ailist;
        
        List<AIA_Document__c> doc=new list<AIA_Document__c >();
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Status__c = 'Complete';
        aiaDoc.Document_Type__c = 'Cede Document';
        aiaDoc.Active__c = True;
        aiadoc.Document_Name__c = 'Test';
        aiadoc.source__c = 'Benefit Request Form';
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Approval_Status__c = 'Approved';
        aiadoc.Opportunity__c=o.id;  
        aiadoc.Benefit_Request_Form__c = brf.id;
        //aiadoc.Benefit_Design_Product__c=ab.id;
        aiadoc.Implementation__c= imp.id; 
        aiaDoc.Sub_Department__c = 'Benefits Summaries';
        aiaDoc.Category__c = 'Opportunity';
        //insert aiaDoc;
        doc.add(aiaDoc);
        insert doc;
        
        Workplan_Task__c WT = new Workplan_Task__c();
        WT.AccountID__c = a.id;
        WT.Description__c = 'Verify Account Legal Name';
        WT.Opportunity__c = o.id;
        //WT.Opportunity__c = doc[0].id;
        WT.RelatedObjectId__c = ailist[0].id;
        WT.Status__c = 'Completed';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
        insert WT;
        
        
        
        Map<Id,AIA_Document__c> aiaDocMap = new Map<Id,AIA_Document__c>();
        for(AIA_Document__c aiaDoc2:doc)
        {
            aiaDocMap.put(aiaDoc2.Id,aiaDoc2);
        }
        AIA_Workplan_Task_Management awt=new AIA_Workplan_Task_Management();
        awt.createWorkplanTasksForSObject('Insert',aiaDocMap,'AIA_Document__c');
        
        
        Map<Id,AIA_Implementation__c> IMPMap = new Map<Id,AIA_Implementation__c>();
        for(AIA_Implementation__c imp2:ailist)
        {
            IMPMap.put(imp2.Id,imp2);
        }
        
        
        AIA_Workplan_Task_Management awt2=new AIA_Workplan_Task_Management();
        awt2.createWorkplanTasksForSObject('Insert',IMPMap,'AIA_Implementation__c');
        
        
    }
    static testMethod void Test2() {
        Account a=new Account();
        a.NAme='Test';
        a.Account_Legal_Name__c='Test';
        insert a;
        
        /*R1 added teammember*/
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  userList.add(u1);
        user u10 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u10);
        user u11 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u11);
        user u2 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u2);
        user u3= AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u3);
        user u4 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u4);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
        insert userlist;
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u10.id,'NASCO Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u11.id,'Underwriter'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'BeneFact Coder'));
        
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u3.id,'Ancillary Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'MAST Tech'));
        
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u14.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u15.id,'Account Manager'));
        insert acctMbrList;
        /*R1 added teammember*/
        
        Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Names';
        //WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT4.Status__c = 'Not-Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = 'AIA_Implementation__c';
        //WTT4.Task_Completion_Expression__c ='(1 OR 1)';
        WTT4.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Manual / SF should auto close this task';
        //WTT4.Workplan_Task_Rules__c=
        insert WTT4;
        
        Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
        
        WTR.Field_API_Name__c = 'Status__c';
        WTR.Object_API_Name__c = 'AIA_Implementation__c';
        WTR.Object_DML_Event__c = 'Insert';
        WTR.Operation__c = 'Not Equal To';
        WTR.Rule_Number__c = 1;
        WTR.Value__c = 'In-Progress';
        WTR.Workplan_Task_Template__c = WTT4.id;
        WTR.Criteria_Type__c = 'Task Completion Criteria';
        
        insert WTR;
        
        
        List<Workplan_Task_Rules__c> WTRList = new List<Workplan_Task_Rules__c>();
        
        Workplan_Task_Rules__c WTR6 = new Workplan_Task_Rules__c();
        WTR6.Field_API_Name__c = 'Status__c';
        WTR6.Object_API_Name__c = 'AIA_Implementation__c';
        WTR6.Object_DML_Event__c = 'Insert';
        WTR6.Operation__c = 'Not Equal To';
        WTR6.Rule_Number__c = 2;
        WTR6.Value__c = 'In-Progress';
        WTR6.Workplan_Task_Template__c = WTT4.id;
        WTR6.Criteria_Type__c = 'Task Completion Criteria';
        
        WTRList.add(WTR6);
        
        Workplan_Task_Rules__c WTR7 = new Workplan_Task_Rules__c();
        WTR7.Field_API_Name__c = 'Status__c';
        WTR7.Object_API_Name__c = 'AIA_Implementation__c';
        WTR7.Object_DML_Event__c = 'Update';
        WTR7.Operation__c = 'Not Equal To';
        WTR7.Rule_Number__c = 2;
        WTR7.Value__c = 'CEDE Document';
        WTR7.Workplan_Task_Template__c = WTT4.id;
        WTR7.Criteria_Type__c = 'Task Creation Criteria';
        
        WTRList.add(WTR7);
        
        insert WTRList;
        
        Dependent_Workplan_Task__c DWT = new Dependent_Workplan_Task__c();
        DWT.Dependent_Task__c = WTT4.id;
        DWT.Primary_Task__c = WTT4.id;
        
        insert DWT;
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.Id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
        
        List<AIA_Implementation__c > ailist=new List<AIA_Implementation__c >();
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = a.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = brf.id;
        
        ailist.add(Imp);
        insert ailist;
        
        List<AIA_Document__c> doc=new list<AIA_Document__c >();
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Status__c = 'Complete';
        aiaDoc.Document_Type__c = 'Cede Document';
        aiaDoc.Active__c = True;
        aiadoc.Document_Name__c = 'Test';
        aiadoc.source__c = 'Benefit Request Form';
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Approval_Status__c = 'Approved';
        aiadoc.Opportunity__c=o.id;  
        aiadoc.Benefit_Request_Form__c = brf.id;
        //aiadoc.Benefit_Design_Product__c=ab.id;
        aiadoc.Implementation__c= imp.id; 
        aiaDoc.Sub_Department__c = 'Benefits Summaries';
        aiaDoc.Category__c = 'Opportunity';
        //insert aiaDoc;
        doc.add(aiaDoc);
        insert doc;
        
        Workplan_Task__c WT = new Workplan_Task__c();
        WT.AccountID__c = a.id;
        WT.Description__c = 'Verify Account Legal Name';
        WT.Opportunity__c = o.id;
        //WT.Opportunity__c = doc[0].id;
        WT.RelatedObjectId__c = ailist[0].id;
        WT.Status__c = 'Completed';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
        insert WT;
        
        // List<user> userList = new list<user>();
        
        
        
        
        
        
        Map<Id,AIA_Document__c> aiaDocMap = new Map<Id,AIA_Document__c>();
        for(AIA_Document__c aiaDoc2:doc)
        {
            aiaDocMap.put(aiaDoc2.Id,aiaDoc2);
        }
        AIA_Workplan_Task_Management awt=new AIA_Workplan_Task_Management();
        awt.createWorkplanTasksForSObject('Insert',aiaDocMap,'AIA_Document__c');
        
        
        Map<Id,AIA_Implementation__c> IMPMap = new Map<Id,AIA_Implementation__c>();
        for(AIA_Implementation__c imp2:ailist)
        {
            IMPMap.put(imp2.Id,imp2);
        }
        
        
        AIA_Workplan_Task_Management awt2=new AIA_Workplan_Task_Management();
        awt2.createWorkplanTasksForSObject('Insert',IMPMap,'AIA_Implementation__c');
        
        
    }
    static testMethod void Test3() {
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  //userList.add(u1); 
        
        // insert userList;
        insert u1;
        system.runas(u1){
            Account a=new Account();
            a.NAme='Test';
            a.Account_Legal_Name__c='Test';
            insert a;
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u1.id,'Implementation Manager')); 
            /*R1 added teammember*/
            //List<user> userList = new list<user>();
            
            user u10 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u10);
            user u11 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u11);
            user u2 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u2);
            user u3= AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u3);
            user u4 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u4);
            user u14 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u14);
            user u15 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u15);
            
            insert userlist;
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u10.id,'NASCO Benefit Coder'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u11.id,'Underwriter'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'BeneFact Coder'));
            
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u3.id,'Ancillary Analyst'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'MAST Tech'));
            
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u14.id,'Account Executive'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u15.id,'Account Manager'));
            insert acctMbrList;
            /*R1 added teammember*/
            
            
            Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
            
            Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
            WTT4.Description__c = 'Verify Account Legal Name';
            //WTT4.Related_Object_API_Name__c = 'Opportunity';
            WTT4.Related_Object_API_Name__c = 'AIA_Implementation__c';
            WTT4.Status__c = 'Not-Started';
            WTT4.Task_Creation_Events__c = 'Insert';
            WTT4.Task_Completion_Events__c = 'Update';
            WTT4.Task_Creation_Criteria_Expression__c = '';
            //WTT4.Task_Completion_Expression__c ='(1 OR 1)';
            WTT4.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
            WTT4.Task_Owner_Type__c = 'Account Team Role';
            WTT4.Task_Owner__c = 'Ancillary Analyst';
            WTT4.Task_Type__c = 'Automated recording of this event';
            WTT4.Acc_Team_Role_for_Renewal_Business__c='Implementation Manager';
            // WT.Task_Type__c='';
            insert WTT4;
            
            Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
            
            WTR.Field_API_Name__c = 'Status__c';
            WTR.Object_API_Name__c = 'AIA_Implementation__c';
            WTR.Object_DML_Event__c = 'Insert';
            WTR.Operation__c = 'Equal To';
            WTR.Rule_Number__c = 1;
            WTR.Value__c = 'In-Progress';
            WTR.Workplan_Task_Template__c = WTT4.id;
            WTR.Criteria_Type__c = 'Task Completion Criteria';
            
            insert WTR;
            
            
            Dependent_Workplan_Task__c DWT = new Dependent_Workplan_Task__c();
            DWT.Dependent_Task__c = WTT4.id;
            DWT.Primary_Task__c = WTT4.id;
            
            insert DWT;
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = a.Id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;
            
            List<AIA_Implementation__c > ailist=new List<AIA_Implementation__c >();
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Account__c = a.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            Imp.Benefit_Request_Form__c = brf.id;
            
            ailist.add(Imp);
            insert ailist;
            Process_Type__c processtype1 = new Process_Type__c();
            processtype1.Active__c = true;
            processtype1.Used_For__c = 'Post-Sales';
            processtype1.Process_Name__c = 'Open Enrollment, Materials, & Support';
            processtype1.Stage__c = 'Proposal';
            processtype1.Sequence_Number__c = 1;   
            insert processtype1;
            
            Sub_Process_Type__c subprocesstype2 = new Sub_Process_Type__c();
            subprocesstype2.Active__c = true;
            subprocesstype2.Used_For__c = 'Post-Sales';
            subprocesstype2.Process_Type__c = processtype1.Id;
            subprocesstype2.Stage__c = AIA_CONSTANTS.SEARCHLIGHT_HEALTHCHECK;//'Group Structure';
            insert subprocesstype2;
            
            process__c p1 = new process__C();
            p1.Active__c = true;
            p1.Used_for__c = 'Post-sales';
            p1.Implementation__c = Imp.id;
            p1.Process_Type__c = processtype1.Id; 
            insert p1;
            
            Sub_Process__c sp1 = new Sub_Process__c();
            sp1.process__c = p1.id;
            sp1.Implementation__c = imp.id;
            sp1.status__c = 'In-Progress';
            sp1.used_for__c = 'Post-Sales';
            sp1.Sub_Process_Type__c = subprocesstype2.Id;
            insert sp1;
            
            List<AIA_Document__c> doc=new list<AIA_Document__c >();
            AIA_Document__c aiaDoc = new AIA_Document__c();
            aiaDoc.Document_Status__c = 'Complete';
            aiaDoc.Document_Type__c = 'Cede Document';
            aiaDoc.Active__c = True;
            aiadoc.Document_Name__c = 'Test';
            aiadoc.source__c = 'Benefit Request Form';
            aiaDoc.Start_Date__c = System.today();
            aiaDoc.End_Date__c = System.today()+10;
            aiaDoc.Approval_Status__c = 'Approved';
            aiadoc.Opportunity__c=o.id;  
            aiadoc.Benefit_Request_Form__c = brf.id;
            //aiadoc.Benefit_Design_Product__c=ab.id;
            aiadoc.Implementation__c= imp.id; 
            aiaDoc.Sub_Department__c = 'Benefits Summaries';
            aiaDoc.Category__c = 'Opportunity';
            //insert aiaDoc;
            doc.add(aiaDoc);
            insert doc;
            Test.StartTest();
            Process__c plist=[select id,name,Status__c from Process__c limit 1];
            Sub_Process__c splist=[select id,Status__c from Sub_Process__c limit 1];
            Workplan_Task__c WT2 = new Workplan_Task__c();
            WT2.AccountID__c = acctMbrList[0].Accountid__C;
            WT2.Description__c = 'Verify Account Legal Name';
            WT2.Opportunity__c = o.id;
            //WT.Opportunity__c = doc[0].id;
            WT2.RelatedObjectId__c = ailist[0].id;
            WT2.Status__c = 'Completed';
            WT2.Task_Owner__c = 'Ancillary Analyst';
            WT2.Task_Owner_Type__c = 'Account Team Role';
            WT2.Workplan_Task_Template__c = WTT4.id;
            WT2.Opportunity_Implementation_ID__c= ailist[0].id;
            WT2.Process__c=plist.id;
            WT2.Sub_Process__c =splist.id;
            insert WT2;
            
            Workplan_Task__c WT = new Workplan_Task__c();
            WT.AccountID__c = acctMbrList[0].Accountid__c;
            WT.Description__c = 'Verify Account Legal Name';
            WT.Opportunity__c = o.id;
            //WT.Opportunity__c = doc[0].id;
            WT.RelatedObjectId__c = ailist[0].id;
            WT.Status__c = 'Not Started';
            WT.Task_Owner__c = 'Vision Analyst';
            WT.Task_Owner_Type__c = 'Account Team Role';
            WT.Workplan_Task_Template__c = WTT4.id;
            WT.Opportunity_Implementation_ID__c= ailist[0].id;
            WT.Process__c=plist.id;
            WT2.Sub_Process__c =splist.id;
            insert WT;
            
            Map<Id,AIA_Document__c> aiaDocMap = new Map<Id,AIA_Document__c>();
            for(AIA_Document__c aiaDoc2:doc)
            {
                aiaDocMap.put(aiaDoc2.Id,aiaDoc2);
            }
            AIA_Workplan_Task_Management awt=new AIA_Workplan_Task_Management();
            awt.createWorkplanTasksForSObject('Insert',aiaDocMap,'AIA_Document__c');
            
            
            Map<Id,AIA_Implementation__c> IMPMap = new Map<Id,AIA_Implementation__c>();
            for(AIA_Implementation__c imp2:ailist)
            {
                IMPMap.put(imp2.Id,imp2);
            }
            
            
            AIA_Workplan_Task_Management awt2=new AIA_Workplan_Task_Management();
            awt2.createWorkplanTasksForSObject('Insert',IMPMap,'AIA_Implementation__c');
            Test.StopTest();
        }
    }
    static testMethod void Test4() {
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  //userList.add(u1); 
        
        // insert userList;
        insert u1;
        system.runas(u1){
            Account a=new Account();
            a.NAme='Test';
            a.Account_Legal_Name__c='Test';
            insert a;
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u1.id,'NASCO Benefit Coder')); 
            /*R1 added teammember*/
            
            
            user u10 = AIA_TestUtil.AIA_createUser('alias14');
            userList.add(u10);
            user u11= AIA_TestUtil.AIA_createUser('alias14');
            userList.add(u11);
            user u12=AIA_TestUtil.AIA_createUser('alias143');
            userList.add(u12);
            user u2 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u2);
            user u3= AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u3);
            user u4 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u4);
            user u14 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u14);
            user u15 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u15);
            insert userlist;
            // List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u12.id,'Benefit Request Form'));
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u10.id,'NASCO Benefit Coder'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u11.id,'Underwriter'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'BeneFact Coder'));
            
            
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u3.id,'Ancillary Analyst'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'MAST Tech'));
            
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u14.id,'Account Executive'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u15.id,'Account Manager'));
            insert acctMbrList;
            /*R1 added teammember*/
            
            
            Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
            
            Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
            WTT4.Description__c = 'Verify Account Legal Name';
            //WTT4.Related_Object_API_Name__c = 'Opportunity';
            WTT4.Related_Object_API_Name__c = 'AIA_Implementation__c';
            WTT4.Status__c = 'Not-Started';
            WTT4.Task_Creation_Events__c = 'Insert';
            WTT4.Task_Completion_Events__c = 'Update';
            WTT4.Task_Creation_Criteria_Expression__c = '';
            //WTT4.Task_Completion_Expression__c ='(1 OR 1)';
            WTT4.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
            WTT4.Task_Owner_Type__c = 'Account Team Role';
            WTT4.Task_Owner__c = 'Ancillary Analyst';
            WTT4.Task_Type__c = 'Manual / SF should auto close this task';
            WTT4.Acc_Team_Role_for_Renewal_Business__c='NASCO Benefit Coder';
            // WT.Task_Type__c='';
            insert WTT4;
            
            Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
            
            WTR.Field_API_Name__c = 'Status__c';
            WTR.Object_API_Name__c = 'AIA_Implementation__c';
            WTR.Object_DML_Event__c = 'Insert';
            WTR.Operation__c = 'Equal To';
            WTR.Rule_Number__c = 1;
            WTR.Value__c = 'In-Progress';
            WTR.Workplan_Task_Template__c = WTT4.id;
            WTR.Criteria_Type__c = 'Task Completion Criteria';
            
            insert WTR;
            
            
            Dependent_Workplan_Task__c DWT = new Dependent_Workplan_Task__c();
            DWT.Dependent_Task__c = WTT4.id;
            DWT.Primary_Task__c = WTT4.id;
            
            insert DWT;
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = a.Id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            try{
                insert brf;
            }catch(Exception e){}
            List<AIA_Implementation__c > ailist=new List<AIA_Implementation__c >();
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Account__c = a.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            Imp.Benefit_Request_Form__c = brf.id;
            
            ailist.add(Imp);
            insert ailist;
            Process_Type__c processtype1 = new Process_Type__c();
            processtype1.Active__c = true;
            processtype1.Used_For__c = 'Post-Sales';
            processtype1.Process_Name__c = 'Open Enrollment, Materials, & Support';
            processtype1.Stage__c = 'Proposal';
            processtype1.Sequence_Number__c = 1;   
            insert processtype1;
            
            Sub_Process_Type__c subprocesstype2 = new Sub_Process_Type__c();
            subprocesstype2.Active__c = true;
            subprocesstype2.Used_For__c = 'Post-Sales';
            subprocesstype2.Process_Type__c = processtype1.Id;
            subprocesstype2.Stage__c = AIA_CONSTANTS.SEARCHLIGHT_HEALTHCHECK;//'Group Structure';
            insert subprocesstype2;
            
            process__c p1 = new process__C();
            p1.Active__c = true;
            p1.Used_for__c = 'Post-sales';
            p1.Implementation__c = Imp.id;
            p1.Process_Type__c = processtype1.Id; 
            insert p1;
            
            Sub_Process__c sp1 = new Sub_Process__c();
            sp1.process__c = p1.id;
            sp1.Implementation__c = imp.id;
            sp1.status__c = 'In-Progress';
            sp1.used_for__c = 'Post-Sales';
            sp1.Sub_Process_Type__c = subprocesstype2.Id;
            insert sp1;
            List<AIA_Document__c> doc=new list<AIA_Document__c >();
            AIA_Document__c aiaDoc = new AIA_Document__c();
            aiaDoc.Document_Status__c = 'Complete';
            aiaDoc.Document_Type__c = 'Cede Document';
            aiaDoc.Active__c = True;
            aiadoc.Document_Name__c = 'Test';
            aiadoc.source__c = 'Benefit Request Form';
            aiaDoc.Start_Date__c = System.today();
            aiaDoc.End_Date__c = System.today()+10;
            aiaDoc.Approval_Status__c = 'Approved';
            aiadoc.Opportunity__c=o.id;  
            aiadoc.Benefit_Request_Form__c = brf.id;
            //aiadoc.Benefit_Design_Product__c=ab.id;
            aiadoc.Implementation__c= imp.id; 
            aiaDoc.Sub_Department__c = 'Benefits Summaries';
            aiaDoc.Category__c = 'Opportunity';
            //insert aiaDoc;
            doc.add(aiaDoc);
            insert doc;
            
            Test.StartTest();
            list<Process__c> plist=[select id,name,Status__c from Process__c limit 1];
            list<Sub_Process__c> subproclist = [select id, Status__c from Sub_Process__c Limit 1];
            Workplan_Task__c WT2 = new Workplan_Task__c();
            WT2.AccountID__c = acctMbrList[0].Accountid__c;
            WT2.Description__c = 'Verify Account Legal Name';
            WT2.Opportunity__c = o.id;
            //WT.Opportunity__c = doc[0].id;
            WT2.RelatedObjectId__c = ailist[0].id;
            WT2.Status__c = 'Completed';
            WT2.Task_Owner__c = 'Ancillary Analyst';
            WT2.Task_Owner_Type__c = 'Account Team Role';
            WT2.Workplan_Task_Template__c = WTT4.id;
            WT2.Opportunity_Implementation_ID__c= ailist[0].id;
            //Wt2.Process__c=plist[0].id;
            Wt2.Sub_Process__c=subproclist[0].id;
            insert WT2;
            
            Workplan_Task__c WT = new Workplan_Task__c();
            WT.AccountID__c = acctMbrList[0].Accountid__c;
            WT.Description__c = 'Verify Account Legal Name';
            WT.Opportunity__c = o.id;
            //WT.Opportunity__c = doc[0].id;
            WT.RelatedObjectId__c = ailist[0].id;
            WT.Status__c = 'Not Started';
            WT.Task_Owner__c = 'Ancillary Analyst';
            WT.Task_Owner_Type__c = 'Account Team Role';
            WT.Workplan_Task_Template__c = WTT4.id;
            WT.Opportunity_Implementation_ID__c= ailist[0].id;
            // Wt.Process__c=plist[0].id;
            Wt.Sub_Process__c=subproclist[0].id;
            insert WT;
            
            
            
            
            
            Map<Id,AIA_Document__c> aiaDocMap = new Map<Id,AIA_Document__c>();
            for(AIA_Document__c aiaDoc2:doc)
            {
                aiaDocMap.put(aiaDoc2.Id,aiaDoc2);
            }
            AIA_Workplan_Task_Management awt=new AIA_Workplan_Task_Management();
            awt.createWorkplanTasksForSObject('Insert',aiaDocMap,'AIA_Document__c');
            
            
            Map<Id,AIA_Implementation__c> IMPMap = new Map<Id,AIA_Implementation__c>();
            for(AIA_Implementation__c imp2:ailist)
            {
                IMPMap.put(imp2.Id,imp2);
            }
            
            
            AIA_Workplan_Task_Management awt2=new AIA_Workplan_Task_Management();
            awt2.createWorkplanTasksForSObject('Insert',IMPMap,'AIA_Implementation__c');
            Test.StopTest();
        }
    }
    static testMethod void Test5() {
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  //userList.add(u1); 
        
        // insert userList;
        insert u1;
        
        Account a=new Account();
        a.Name='Workforce Management';
        a.Account_Legal_Name__c='Test';
        insert a;
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u1.id,'Blue Rewards Tech')); 
        
        // insert acctMbrList;
        
        /*R1 added teammember*/
        //List<user> userList = new list<user>();
        
        user u10 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u10);
        user u11 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u11);
        user u2 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u2);
        user u3= AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u3);
        user u4 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u4);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
        
        insert userlist;
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u10.id,'NASCO Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u11.id,'Underwriter'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'BeneFact Coder'));
        
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u3.id,'Ancillary Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'MAST Tech'));
        
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u14.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u15.id,'Account Manager'));
        insert acctMbrList;
        /*R1 added teammember*/
        
        
        Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        o.Business_Type__c='New';
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Name';
        //WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Related_Object_API_Name__c = 'AIA_Document__c';
        WTT4.Status__c = 'Not-Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = '';
        //WTT4.Task_Completion_Expression__c ='(1 OR 1)';
        WTT4.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Automated recording of this event';
        WTT4.Acc_Team_Role_for_Renewal_Business__c='OwnerId';
        
        insert WTT4;
        
        Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
        
        WTR.Field_API_Name__c = 'Status__c';
        WTR.Object_API_Name__c = 'AIA_Document__c';
        WTR.Object_DML_Event__c = 'Insert';
        WTR.Operation__c = 'Equal To';
        WTR.Rule_Number__c = 1;
        WTR.Value__c = 'In-Progress';
        WTR.Workplan_Task_Template__c = WTT4.id;
        WTR.Criteria_Type__c = 'Task Completion Criteria';
        
        insert WTR;
        
        
        Dependent_Workplan_Task__c DWT = new Dependent_Workplan_Task__c();
        DWT.Dependent_Task__c = WTT4.id;
        DWT.Primary_Task__c = WTT4.id;
        
        insert DWT;
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.Id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
        
        List<AIA_Implementation__c > ailist=new List<AIA_Implementation__c >();
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = a.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = brf.id;
        
        ailist.add(Imp);
        insert ailist;
        
        List<AIA_Document__c> doc=new list<AIA_Document__c >();
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Status__c = 'Complete';
        aiaDoc.Document_Type__c = 'Cede Document';
        aiaDoc.Active__c = True;
        aiadoc.Document_Name__c = 'Test';
        aiadoc.source__c = 'Benefit Request Form';
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Approval_Status__c = 'Approved';
        aiadoc.Opportunity__c=o.id;  
        aiadoc.Benefit_Request_Form__c = brf.id;
        //aiadoc.Benefit_Design_Product__c=ab.id;
        aiadoc.Implementation__c= imp.id; 
        aiaDoc.Sub_Department__c = 'Benefits Summaries';
        aiaDoc.Category__c = 'Opportunity';
        //insert aiaDoc;
        doc.add(aiaDoc);
        insert doc;
        
        Workplan_Task__c WT2 = new Workplan_Task__c();
        WT2.AccountID__c = acctMbrList[0].Accountid__c;
        WT2.Description__c = 'Verify Account Legal Name';
        WT2.Opportunity__c = o.id;
        //WT.Opportunity__c = doc[0].id;
        WT2.RelatedObjectId__c = doc[0].id;
        WT2.Status__c = 'Completed';
        WT2.Task_Owner__c = 'Ancillary Analyst';
        WT2.Task_Owner_Type__c = 'Account Team Role';
        WT2.Workplan_Task_Template__c = WTT4.id;
        WT2.Opportunity_Implementation_ID__c= ailist[0].id;
        //Wt2.Ownerid=u1.id;
        insert WT2;
        
        Workplan_Task__c WT = new Workplan_Task__c();
        WT.AccountID__c = a.id;
        WT.Description__c = 'Verify Account Legal Name';
        WT.Opportunity__c = o.id;
        //WT.Opportunity__c = doc[0].id;
        WT.RelatedObjectId__c = doc[0].id;
        WT.Status__c = 'Not Started';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
        WT.Opportunity_Implementation_ID__c=ailist[0].id;
        // WT.Ownerid=u1.id;
        insert WT;
        
        
        
        
        
        Map<Id,AIA_Document__c> aiaDocMap = new Map<Id,AIA_Document__c>();
        for(AIA_Document__c aiaDoc2:doc)
        {
            aiaDocMap.put(aiaDoc2.Id,aiaDoc2);
        }
        AIA_Workplan_Task_Management awt=new AIA_Workplan_Task_Management();
        awt.createWorkplanTasksForSObject('Insert',aiaDocMap,'AIA_Document__c');
        
        
        Map<Id,AIA_Implementation__c> IMPMap = new Map<Id,AIA_Implementation__c>();
        for(AIA_Implementation__c imp2:ailist)
        {
            IMPMap.put(imp2.Id,imp2);
        }
        
        
        AIA_Workplan_Task_Management awt2=new AIA_Workplan_Task_Management();
        awt2.createWorkplanTasksForSObject('Insert',IMPMap,'AIA_Implementation__c');
    }
    
    static testMethod void Test6() {
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  //userList.add(u1); 
        
        // insert userList;
        insert u1;
        system.runas(u1){
            Account a=new Account();
            a.NAme='Test';
            a.Account_Legal_Name__c='Test';
            insert a;
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u1.id,'Implementation Manager')); 
            /*R1 added teammember*/
            //List<user> userList = new list<user>();
            
            user u10 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u10);
            user u11 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u11);
            user u2 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u2);
            user u3= AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u3);
            user u4 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u4);
            user u14 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u14);
            user u15 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u15);
            
            insert userlist;
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u10.id,'NASCO Benefit Coder'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u11.id,'Underwriter'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'BeneFact Coder'));
            
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u3.id,'Ancillary Analyst'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'MAST Tech'));
            
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u14.id,'Account Executive'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u15.id,'Account Manager'));
            insert acctMbrList;
            /*R1 added teammember*/
            
            
            Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
            
            Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
            WTT4.Description__c = 'Verify Account Legal Name';
            //WTT4.Related_Object_API_Name__c = 'Opportunity';
            WTT4.Related_Object_API_Name__c = 'AIA_Implementation__c';
            WTT4.Status__c = 'Not-Started';
            WTT4.Task_Creation_Events__c = 'Insert';
            WTT4.Task_Completion_Events__c = 'Update';
            WTT4.Task_Creation_Criteria_Expression__c = '';
            //WTT4.Task_Completion_Expression__c ='(1 OR 1)';
            WTT4.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
            WTT4.Task_Owner_Type__c = 'Account Team Role';
            WTT4.Task_Owner__c = 'Ancillary Analyst';
            WTT4.Task_Type__c = 'Automated recording of this event';
            WTT4.Acc_Team_Role_for_Renewal_Business__c='Implementation Manager';
            // WT.Task_Type__c='';
            insert WTT4;
            
            Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
            
            WTR.Field_API_Name__c = 'Status__c';
            WTR.Object_API_Name__c = 'AIA_Implementation__c';
            WTR.Object_DML_Event__c = 'Insert';
            WTR.Operation__c = 'Equal To';
            WTR.Rule_Number__c = 1;
            WTR.Value__c = 'In-Progress';
            WTR.Workplan_Task_Template__c = WTT4.id;
            WTR.Criteria_Type__c = 'Task Completion Criteria';
            
            insert WTR;
            
            
            Dependent_Workplan_Task__c DWT = new Dependent_Workplan_Task__c();
            DWT.Dependent_Task__c = WTT4.id;
            DWT.Primary_Task__c = WTT4.id;
            
            insert DWT;
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = a.Id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;
            
            List<AIA_Implementation__c > ailist=new List<AIA_Implementation__c >();
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Account__c = a.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            Imp.Benefit_Request_Form__c = brf.id;
            
            ailist.add(Imp);
            insert ailist;
            Process_Type__c processtype1 = new Process_Type__c();
            processtype1.Active__c = true;
            processtype1.Used_For__c = 'Post-Sales';
            processtype1.Process_Name__c = 'Open Enrollment, Materials, & Support';
            processtype1.Stage__c = 'Proposal';
            processtype1.Sequence_Number__c = 1;   
            insert processtype1;
            
            /*Process_Type__c processtype2 = new Process_Type__c();
            processtype2.Active__c = true;
            processtype2.Used_For__c = 'Post-Sales';
            processtype2.Process_Name__c = 'Group Structure & Admin Setup';
            processtype2.Stage__c = 'Proposal';
            processtype2.Sequence_Number__c = 1;   
            insert processtype2;*/
            
            Sub_Process_Type__c subprocesstype2 = new Sub_Process_Type__c();
            subprocesstype2.Active__c = true;
            subprocesstype2.Used_For__c = 'Post-Sales';
            subprocesstype2.Process_Type__c = processtype1.Id;
            subprocesstype2.Stage__c = AIA_CONSTANTS.SEARCHLIGHT_HEALTHCHECK;//'Group Structure';
            insert subprocesstype2;
            
            /*Sub_Process_Type__c subprocesstype3 = new Sub_Process_Type__c();
            subprocesstype3.Active__c = true;
            subprocesstype3.Used_For__c = 'Post-Sales';
            subprocesstype3.Process_Type__c = processtype2.Id;
            subprocesstype3.Stage__c = 'Group Structure & Admin Setup';//'Group Structure';
            insert subprocesstype3;*/
            
            process__c p1 = new process__C();
            List<process__c> plist1 = new List<process__C>();
            p1.Active__c = true;
            p1.Used_for__c = 'Post-sales';
            p1.Implementation__c = Imp.id;
            p1.Process_Type__c = processtype1.Id; 
            p1.Status__c='Completed';
            p1.Stage__c = 'Group Structure & Admin Setup';
            plist1.add(p1);
            
            
            process__c p2 = new process__C();
            p2.Active__c = true;
            p2.Used_for__c = 'Post-sales';
            p2.Implementation__c = Imp.id;
            p2.Process_Type__c = processtype1.Id; 
            p2.Status__c='';
            p2.Stage__c = 'Group Structure & Admin Setup';
            plist1.add(p2);
            
            
            /*process__c p3 = new process__C();
            p3.Active__c = true;
            p3.Used_for__c = 'Post-sales';
            p3.Implementation__c = Imp.id;
            p3.Process_Type__c = processtype2.Id; 
            p3.Status__c='';
            p3.Stage__c = 'Group Structure & Admin Setup';
            plist1.add(p3);*/
            insert plist1;
            
            Sub_Process__c sp1 = new Sub_Process__c();
            sp1.process__c = p1.id;
            sp1.Implementation__c = imp.id;
            sp1.status__c = 'In-Progress';
            sp1.used_for__c = 'Post-Sales';
            sp1.Sub_Process_Type__c = subprocesstype2.Id;
            insert sp1;
            
            /*Sub_Process__c sp2 = new Sub_Process__c();
            sp2.process__c = p3.id;
            sp2.Implementation__c = imp.id;
            sp2.status__c = 'In-Progress';
            sp2.used_for__c = 'Post-Sales';
            sp2.Sub_Process_Type__c = subprocesstype3.Id;
            insert sp2;*/
            
            
            
            List<AIA_Document__c> doc=new list<AIA_Document__c >();
            AIA_Document__c aiaDoc = new AIA_Document__c();
            aiaDoc.Document_Status__c = 'Complete';
            aiaDoc.Document_Type__c = 'Cede Document';
            aiaDoc.Active__c = True;
            aiadoc.Document_Name__c = 'Test';
            aiadoc.source__c = 'Benefit Request Form';
            aiaDoc.Start_Date__c = System.today();
            aiaDoc.End_Date__c = System.today()+10;
            aiaDoc.Approval_Status__c = 'Approved';
            aiadoc.Opportunity__c=o.id;  
            aiadoc.Benefit_Request_Form__c = brf.id;
            //aiadoc.Benefit_Design_Product__c=ab.id;
            aiadoc.Implementation__c= imp.id; 
            aiaDoc.Sub_Department__c = 'Benefits Summaries';
            aiaDoc.Category__c = 'Opportunity';
            //insert aiaDoc;
            doc.add(aiaDoc);
            insert doc;
            Test.StartTest();
            Process__c plist=[select id,name,Status__c from Process__c limit 1];
            Sub_Process__c splist=[select id,Status__c from Sub_Process__c limit 1];
            Workplan_Task__c WT2 = new Workplan_Task__c();
            WT2.AccountID__c = acctMbrList[0].Accountid__c;
            WT2.Description__c = 'Verify Account Legal Name';
            WT2.Opportunity__c = o.id;
            //WT.Opportunity__c = doc[0].id;
            WT2.RelatedObjectId__c = ailist[0].id;
            WT2.Status__c = 'Completed';
            WT2.Task_Owner__c = 'Vision Analyst';
            WT2.Task_Owner_Type__c = 'Account Team Role';
            WT2.Workplan_Task_Template__c = WTT4.id;
            WT2.Opportunity_Implementation_ID__c= ailist[0].id;
            WT2.Process__c=plist1[0].id;
            WT2.Sub_Process__c =splist.id;
            insert WT2;
            
            Workplan_Task__c WT = new Workplan_Task__c();
            WT.AccountID__c = acctMbrList[0].Accountid__c;
            WT.Description__c = 'Verify Account Legal Name';
            WT.Opportunity__c = o.id;
            //WT.Opportunity__c = doc[0].id;
            WT.RelatedObjectId__c = ailist[0].id;
            WT.Status__c = 'In Progress';
            WT.Description__c='Complete Account Implementation Review/Approval';
            WT.Task_Owner__c = 'Ancillary Analyst';
            WT.Task_Owner_Type__c = 'Account Team Role';
            WT.Workplan_Task_Template__c = WTT4.id;
            WT.Opportunity_Implementation_ID__c= ailist[0].id;
            WT.Process__c=plist1[0].id;
            WT2.Sub_Process__c =splist.id;
            insert WT;
            
            
            
            Workplan_Task__c WT3 = new Workplan_Task__c();
            WT3.AccountID__c = acctMbrList[0].Accountid__c;
            //WT3.Description__c = 'Verify Account Legal Name';
            WT.Description__c='Complete Account Implementation Review/Approval';
            WT3.Opportunity__c = o.id;
            //WT.Opportunity__c = doc[0].id;
            WT3.RelatedObjectId__c = ailist[0].id;
            WT3.Status__c = 'In Progress';
            WT3.Task_Owner__c = 'Vision Analyst';
            WT3.Task_Owner_Type__c = 'Account Team Role';
            //WT3.Workplan_Task_Template__c = WTT4.id;
            WT3.Opportunity_Implementation_ID__c= ailist[0].id;
            WT2.Process__c=p2.id;
            WT3.Sub_Process__c =splist.id;
            insert WT3;
            
            list<Workplan_Task__c> wtPlna = [select id,name,Description__c, Status__c from Workplan_Task__c where id=:WT3.Id];
           
            //system.debug('******TEstDebug*********'+procsss);
            //Process__c plist2=[select id,name,Status__c from Process__c where id=:plist.id limit 1];
            //plist2.Stage__c = 'Group Structure & Admin Setup';
            //update plist2;
            
            Map<Id,AIA_Document__c> aiaDocMap = new Map<Id,AIA_Document__c>();
            for(AIA_Document__c aiaDoc2:doc)
            {
                aiaDocMap.put(aiaDoc2.Id,aiaDoc2);
            }
            AIA_Workplan_Task_Management awt=new AIA_Workplan_Task_Management();
            awt.createWorkplanTasksForSObject('Insert',aiaDocMap,'AIA_Document__c');
            
            
            Map<Id,AIA_Implementation__c> IMPMap = new Map<Id,AIA_Implementation__c>();
            for(AIA_Implementation__c imp2:ailist)
            {
                IMPMap.put(imp2.Id,imp2);
            }
            
            
            AIA_Workplan_Task_Management awt2=new AIA_Workplan_Task_Management();
            awt2.createWorkplanTasksForSObject('Insert',IMPMap,'AIA_Implementation__c');
            Test.StopTest();
        }
    }
    
   static testMethod void Test7() {
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        insert u1;
        system.runas(u1){
            Account a=new Account();
            a.NAme='Test';
            a.Account_Legal_Name__c='Test';
            insert a;
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u1.id,'Implementation Manager')); 
            /*R1 added teammember*/
            //List<user> userList = new list<user>();
            
            user u10 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u10);
            user u11 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u11);
            user u2 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u2);
            user u3= AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u3);
            user u4 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u4);
            user u14 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u14);
            user u15 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u15);
            
            insert userlist;
            
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u10.id,'NASCO Benefit Coder'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u11.id,'Underwriter'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'BeneFact Coder'));
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u3.id,'Ancillary Analyst'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'MAST Tech'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u14.id,'Account Executive'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u15.id,'Account Manager'));
            insert acctMbrList;
            /*R1 added teammember*/
            
            
            Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
            
            Process_Type__c processtype2 = new Process_Type__c();
            processtype2.Active__c = true;
            processtype2.Used_For__c = 'Post-Sales';
            processtype2.Process_Name__c = 'Group Structure & Admin Setup';
            processtype2.Stage__c = 'Group Structure & Admin Setup';
            processtype2.Sequence_Number__c = 1;   
            insert processtype2;
            
            Process_Type__c processtype21 = new Process_Type__c();
            processtype21.Active__c = true;
            processtype21.Used_For__c = 'Post-Sales';
            processtype21.Process_Name__c = 'Account & Member Tools';
            processtype21.Stage__c = 'Account & Member Tools';
            processtype21.Sequence_Number__c = 1;   
            insert processtype21;
            
            Sub_Process_Type__c subprocesstype3 = new Sub_Process_Type__c();
            subprocesstype3.Active__c = true;
            subprocesstype3.Used_For__c = 'Post-Sales';
            subprocesstype3.Process_Type__c = processtype2.Id;
            subprocesstype3.Stage__c = 'Group Structure';
            insert subprocesstype3;
            
            Sub_Process_Type__c subprocesstype31 = new Sub_Process_Type__c();
            subprocesstype31.Active__c = true;
            subprocesstype31.Used_For__c = 'Post-Sales';
            subprocesstype31.Process_Type__c = processtype21.Id;
            subprocesstype31.Stage__c = 'MyAccount';
            insert subprocesstype31;
            
            Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
            WTT4.Description__c = 'Complete Settlements Review/Approval';
            WTT4.Related_Object_API_Name__c = 'AIA_Implementation__c';
            WTT4.Status__c = 'Not-Started';
            WTT4.Task_Creation_Events__c = 'Insert';
            WTT4.Task_Completion_Events__c = 'Update';
            WTT4.Task_Creation_Criteria_Expression__c = '';
            WTT4.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
            WTT4.Task_Owner_Type__c = 'Account Team Role';
            WTT4.Task_Owner__c = 'Vision Analyst';
            WTT4.Task_Type__c = 'Automated recording of this event';
            WTT4.Acc_Team_Role_for_Renewal_Business__c='Vision Analyst';
            WTT4.Acc_Team_Role_for_New_Business__c = 'Vision Analyst';
            insert WTT4;
            
            Workplan_Task_Template__c WTT41 = new Workplan_Task_Template__c();
            WTT41.Description__c = 'Send notification to My Account team to set-up the account';
            WTT41.Related_Object_API_Name__c = 'AIA_Implementation__c';
            WTT41.Status__c = 'Not-Started';
            WTT41.Task_Creation_Events__c = 'Insert';
            WTT41.Task_Completion_Events__c = 'Update';
            WTT41.Task_Creation_Criteria_Expression__c = '';
            WTT41.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
            WTT41.Task_Owner_Type__c = 'Account Team Role';
            WTT41.Task_Owner__c = 'Vision Analyst';
            WTT41.Task_Type__c = 'Automated recording of this event';
            WTT41.Acc_Team_Role_for_Renewal_Business__c='Vision Analyst';
            WTT41.Acc_Team_Role_for_New_Business__c = 'Vision Analyst';
            insert WTT41;
            
            Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
            
            WTR.Field_API_Name__c = 'Status__c';
            WTR.Object_API_Name__c = 'AIA_Implementation__c';
            WTR.Object_DML_Event__c = 'Update';
            WTR.Operation__c = 'Equal To';
            WTR.Rule_Number__c = 1;
            WTR.Value__c = 'In-Progress';
            WTR.Workplan_Task_Template__c = WTT4.id;
            WTR.Criteria_Type__c = 'Task Completion Criteria';
            
            insert WTR;
            
            Workplan_Task_Rules__c WTR1 = new Workplan_Task_Rules__c();
            
            WTR1.Field_API_Name__c = 'Status__c';
            WTR1.Object_API_Name__c = 'AIA_Implementation__c';
            WTR1.Object_DML_Event__c = 'Update';
            WTR1.Operation__c = 'Equal To';
            WTR1.Rule_Number__c = 1;
            WTR1.Value__c = 'In-Progress';
            WTR1.Workplan_Task_Template__c = WTT41.id;
            WTR1.Criteria_Type__c = 'Task Completion Criteria';
            
            insert WTR1;
            Dependent_Workplan_Task__c DWT = new Dependent_Workplan_Task__c();
            DWT.Dependent_Task__c = WTT4.id;
            DWT.Primary_Task__c = WTT4.id;
            
            insert DWT;
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = a.Id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;
            
            List<AIA_Implementation__c > ailist=new List<AIA_Implementation__c >();
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Account__c = a.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='Risk';
            Imp.Benefit_Request_Form__c = brf.id;
            Imp.Status__c = 'Not Started';
            ailist.add(Imp);
            insert ailist;
            
            Test.startTest();
            Imp.Status__c = 'In-Progress';
            Update Imp;
            List<Process__c> procLst = [SELECT Id, Stage__c, Implementation__c, Implementation__r.BRF_Funding_Arrangement__c, 
												(Select id, Description__c, Status__c from Workplan_Tasks__r where 
												Status__c != 'Completed' and Status__c != 'Not Required') 
												FROM Process__c WHERE Implementation__c=:imp.id AND Status__c != 'Completed' LIMIT 1];
            for(Process__c proc:procLst)
            {
                proc.status__c = 'Completed';
            }
            update procLst;
            
            List<Workplan_Task__c> wpLst = [Select Id,Status__c from Workplan_Task__c where status__c !='Not Required' And status__c != 'Completed' LIMIT 1];
            for(Workplan_Task__c wp:wpLst)
            {
                wp.status__c = 'Completed';
            }
            update wpLst;
            process__c p1 = new process__C();
            p1.Active__c = true;
            p1.Used_for__c = 'Post-sales';
            p1.Implementation__c = Imp.id;
            p1.Process_Type__c = processtype2.Id; 
            p1.Status__c='In-Progress';
            p1.Stage__c = 'Group Structure & Admin Setup';
            insert p1;
            
            process__c p11 = new process__C();
            p11.Active__c = true;
            p11.Used_for__c = 'Post-sales';
            p11.Implementation__c = Imp.id;
            p11.Process_Type__c = processtype21.Id; 
            p11.Status__c='In-Progress';
            p11.Stage__c = 'Account & Member Tools';
            insert p11;
            
            Sub_Process__c sp2 = new Sub_Process__c();
            sp2.process__c = p1.id;
            sp2.Implementation__c = imp.id;
            sp2.status__c = 'In-Progress';
            sp2.used_for__c = 'Post-Sales';
            sp2.Sub_Process_Type__c = subprocesstype3.Id;
            insert sp2;
            
            Sub_Process__c sp21 = new Sub_Process__c();
            sp21.process__c = p11.id;
            sp21.Implementation__c = imp.id;
            sp21.status__c = 'Completed';
            sp21.used_for__c = 'Post-Sales';
            sp21.Sub_Process_Type__c = subprocesstype31.Id;
            insert sp21;
            
            Workplan_Task__c WT = new Workplan_Task__c();
            WT.AccountID__c = a.Id;
            WT.Description__c = 'Complete Account Implementation Review/Approval';
            WT.Opportunity__c = o.id;
            WT.RelatedObjectId__c = imp.id;
            WT.Status__c = 'In Progress';
            WT.Description__c='Complete Account Implementation Review/Approval';
            WT.Task_Owner__c = 'Ancillary Analyst';
            WT.Task_Owner_Type__c = 'Account Team Role';
            WT.Workplan_Task_Template__c = WTT4.id;
            WT.Process__c=p1.id;
            WT.Sub_Process__c =sp2.id;
            insert WT;
            
            Workplan_Task__c WT1 = new Workplan_Task__c();
            WT1.AccountID__c = a.Id;
            WT1.Description__c = 'Verify Account Legal Name';
            WT1.Opportunity__c = o.id;
            WT1.RelatedObjectId__c = imp.id;
            WT1.Status__c = 'Completed';
            WT1.Description__c='Send notification to My Account team to set-up the account';
            WT1.Task_Owner__c = 'Ancillary Analyst';
            WT1.Task_Owner_Type__c = 'Account Team Role';
            WT1.Workplan_Task_Template__c = WTT41.id;
            WT.Process__c=p11.id;
            WT1.Sub_Process__c =sp21.id;
            insert WT1;
            
            p11.Status__c = 'Completed';
            update p11;
            
            List<Process__c> processLst1 = [SELECT Id, Stage__c, Implementation__c, Implementation__r.BRF_Funding_Arrangement__c, 
												(Select id, Description__c, Status__c from Workplan_Tasks__r where 
												Status__c != 'Completed' and Status__c != 'Not Required') 
												FROM Process__c WHERE Implementation__c =:imp.id AND Status__c != 'Completed'];
                
            //system.assertEquals(processLst1[0].Workplan_Tasks__r,null);
            List<Process__c> processLst = new List<Process__c>{p1,p11};
            AIA_ProcessTriggerHelper helper = new AIA_ProcessTriggerHelper();
            helper.finalTaskCloseUpdate(processLst);
            Test.StopTest();
        }
    }
     
    
}