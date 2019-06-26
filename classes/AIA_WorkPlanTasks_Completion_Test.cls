@isTest(SeeAllData=true)

private class AIA_WorkPlanTasks_Completion_Test{

static testMethod void Test1() {

Account a=new Account();
a.NAme='Test';
a.Account_Legal_Name__c='Test';
insert a;

      Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        
       
       
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Names';
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
        //WTT4.Workplan_Task_Rules__c=
        insert WTT4;
       
         //WTR1.Workplan_Task_Template__c = WTT4.id;
         //insert WTR1;
         
          Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
        string s='Status__C';
        WTR.Field_API_Name__c = 'Document_Type__c';
        WTR.Object_API_Name__c = 'AIA_Document__c';
        WTR.Object_DML_Event__c = 'Insert';
        WTR.Operation__c = 'Equal To';
        WTR.Rule_Number__c = 1;
        WTR.Value__c = 'In-Progress';
        WTR.Workplan_Task_Template__c = WTT4.id;
        WTR.Criteria_Type__c = 'Task Completion Criteria';
        
        insert WTR;
        
        
        
        AIA_Benefit_Design_Product__c  ab=[select id,name from AIA_Benefit_Design_Product__c limit 1];


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
        //insert Imp;
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
        WT.RelatedObjectId__c = doc[0].id;
        WT.Status__c = 'Not Started';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
       insert WT;
       


       AIA_WorkPlanTasks_Completion aiataskcompletion = new AIA_WorkPlanTasks_Completion();
      
       aiataskcompletion.completionWorkplanTasksForAIADocument('Insert',doc,'AIA_Document__c');
       
       Map<String,Boolean> ruleMap =new Map<String,Boolean>();
         rulemap.put('1',false);
     AIA_WorkplanTask_RulesCriteria wr=new AIA_WorkplanTask_RulesCriteria();
wr.checkCritetia(ruleMap ,WTT4.Task_Completion_Expression__c);
}

/*static testMethod void Test6() {

Account a=new Account();
a.NAme='Test';
a.Account_Legal_Name__c='Test';
insert a;

      Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        

       
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Names';
        //WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Related_Object_API_Name__c = 'AIA_Document__c';
        WTT4.Status__c = 'Not-Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = '';
        WTT4.Task_Completion_Expression__c = '1';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Manual / SF should auto close this task';
        //WTT4.Workplan_Task_Rules__c=
        insert WTT4;
       
         
        
        
        AIA_Benefit_Design_Product__c  ab=[select id,name from AIA_Benefit_Design_Product__c limit 1];


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
        //insert Imp;
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
        WT.RelatedObjectId__c = doc[0].id;
       // WT.RelatedObjectId__c = ailist[0].id;
        WT.Status__c = 'Not Started';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
       insert WT;
       
     
      
       AIA_WorkPlanTasks_Completion aiataskcompletion = new AIA_WorkPlanTasks_Completion();
      
       
      aiataskcompletion.completionWorkplanTasksForAIADocument('Insert',doc,'AIA_Document__c');
        
         //aiataskcompletion.completionWorkplanTasksForSObject('Insert',ailist,'AIA_Implementation__c');
         
         

}*/

static testMethod void Test3() {

Account a=new Account();
a.NAme='Test';
a.Account_Legal_Name__c='Test';
insert a;

      Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        

       
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Names';
        //WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Related_Object_API_Name__c = 'AIA_Document__c';
        WTT4.Status__c = 'Not-Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = '';
        WTT4.Task_Completion_Expression__c = '(1 AND )';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Manual / SF should auto close this task';
        //WTT4.Workplan_Task_Rules__c=
        insert WTT4;
       
         //WTR1.Workplan_Task_Template__c = WTT4.id;
         //insert WTR1;
         
          Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
        string s='Status__C';
        WTR.Field_API_Name__c = 'Document_Type__c';
        WTR.Object_API_Name__c = 'AIA_Document__c';
        WTR.Object_DML_Event__c = 'Insert';
        WTR.Operation__c = 'Equal To';
        WTR.Rule_Number__c = 2;
        WTR.Value__c = 'Cede Document';
        WTR.Workplan_Task_Template__c = WTT4.id;
        WTR.Criteria_Type__c = 'Task Completion Criteria';
        
        insert WTR;
        
        
        List<Workplan_Task_Rules__c> WTRList = new List<Workplan_Task_Rules__c>();
        
        Workplan_Task_Rules__c WTR6 = new Workplan_Task_Rules__c();
        WTR6.Field_API_Name__c = 'Document_Type__c';
        WTR6.Object_API_Name__c = 'AIA_Document__c';
        WTR6.Object_DML_Event__c = 'Insert';
        WTR6.Operation__c = 'Equal To';
        WTR6.Rule_Number__c = 2;
        WTR6.Value__c = 'Cede Document';
        WTR6.Workplan_Task_Template__c = WTT4.id;
        WTR6.Criteria_Type__c = 'Task Completion Criteria';

        WTRList.add(WTR6);
        
        Workplan_Task_Rules__c WTR7 = new Workplan_Task_Rules__c();
        WTR7.Field_API_Name__c = 'Document_Type__c';
        WTR7.Object_API_Name__c = 'AIA_Document__c';
        WTR7.Object_DML_Event__c = 'Update';
        WTR7.Operation__c = 'Equal To';
        WTR7.Rule_Number__c = 2;
        WTR7.Value__c = 'CEDE Document';
        WTR7.Workplan_Task_Template__c = WTT4.id;
        WTR7.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR7);
        
        
        
        AIA_Benefit_Design_Product__c  ab=[select id,name from AIA_Benefit_Design_Product__c limit 1];


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
        //insert Imp;
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
        WT.RelatedObjectId__c = doc[0].id;
       // WT.RelatedObjectId__c = ailist[0].id;
        WT.Status__c = 'Not Started';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
       insert WT;
       
     
         
      
       AIA_WorkPlanTasks_Completion aiataskcompletion = new AIA_WorkPlanTasks_Completion();
      
       
      aiataskcompletion.completionWorkplanTasksForAIADocument('Insert',doc,'AIA_Document__c');
        
        
        
 
}


static testMethod void Test5() {

Account a=new Account();
a.NAme='Test';
a.Account_Legal_Name__c='Test';
insert a;

      Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        

       
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Names';
        //WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Related_Object_API_Name__c = 'AIA_Document__c';
        WTT4.Status__c = 'Not-Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = '';
        WTT4.Task_Completion_Expression__c = '1';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Manual / SF should auto close this task';
        //WTT4.Workplan_Task_Rules__c=
        insert WTT4;
       
         //WTR1.Workplan_Task_Template__c = WTT4.id;
         //insert WTR1;
         
          Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
        string s='Status__C';
        WTR.Field_API_Name__c = 'Document_Type__c';
        WTR.Object_API_Name__c = 'AIA_Document__c';
        WTR.Object_DML_Event__c = 'Insert';
        WTR.Operation__c = 'Not Equal To';
        WTR.Rule_Number__c = 1;
        WTR.Value__c = 'mmm Document';
        WTR.Workplan_Task_Template__c = WTT4.id;
        WTR.Criteria_Type__c = 'Task Completion Criteria';
        
        insert WTR;
        
        
        List<Workplan_Task_Rules__c> WTRList = new List<Workplan_Task_Rules__c>();
        
       
        Workplan_Task_Rules__c WTR8 = new Workplan_Task_Rules__c();
        WTR8.Field_API_Name__c = 'Document_Type__c';
        WTR8.Object_API_Name__c = 'AIA_Document__c';
        WTR8.Object_DML_Event__c = 'Insert';
        WTR8.Operation__c = 'Not Equal To';
        WTR8.Rule_Number__c = 1;
        WTR8.Value__c = '';
        WTR8.Workplan_Task_Template__c = WTT4.id;
        WTR8.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR8);
        
        AIA_Benefit_Design_Product__c  ab=[select id,name from AIA_Benefit_Design_Product__c limit 1];


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
        //insert Imp;
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
        WT.RelatedObjectId__c = doc[0].id;
       // WT.RelatedObjectId__c = ailist[0].id;
        WT.Status__c = 'Not Started';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
       insert WT;
       
     
      
       AIA_WorkPlanTasks_Completion aiataskcompletion = new AIA_WorkPlanTasks_Completion();
      
       
      aiataskcompletion.completionWorkplanTasksForAIADocument('Insert',doc,'AIA_Document__c');
        
         aiataskcompletion.completionWorkplanTasksForSObject('Insert',ailist,'AIA_Implementation__c');

}

static testMethod void Test2() {

Account a=new Account();
a.NAme='Test';
a.Account_Legal_Name__c='Test';
insert a;

      Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        

       
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Names';
        //WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT4.Status__c = 'Not-Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = '';
        //WTT4.Task_Completion_Expression__c = '1';
        WTT4.Task_Completion_Expression__c = '(1 OR 2 OR 3)';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Manual / SF should auto close this task';
        //WTT4.Workplan_Task_Rules__c=
        insert WTT4;
       
         //WTR1.Workplan_Task_Template__c = WTT4.id;
         //insert WTR1;
         
          Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
        string s='Status__C';
        WTR.Field_API_Name__c = 'Status__c';
        WTR.Object_API_Name__c = 'AIA_Implementation__c';
        WTR.Object_DML_Event__c = 'Insert';
        WTR.Operation__c = 'Equal To';
        WTR.Rule_Number__c = 1;
        WTR.Value__c = 'In-Progress';
        WTR.Workplan_Task_Template__c = WTT4.id;
        WTR.Criteria_Type__c = 'Task Completion Criteria';
        
        insert WTR;
        
        
        
        AIA_Benefit_Design_Product__c  ab=[select id,name from AIA_Benefit_Design_Product__c limit 1];


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
        //insert Imp;
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
        WT.Status__c = 'Not Started';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
       insert WT;
       
      
       AIA_WorkPlanTasks_Completion aiataskcompletion = new AIA_WorkPlanTasks_Completion();
      
         aiataskcompletion.completionWorkplanTasksForSObject('Insert',ailist,'AIA_Implementation__c');
         
         Map<String,Boolean> ruleMap =new Map<String,Boolean>();
         List<string> ls=new List<string> {'1', '2', '3'};
         for(string ss:ls){
         rulemap.put(ss,false);
     
}
AIA_WorkplanTask_RulesCriteria wr=new AIA_WorkplanTask_RulesCriteria();
     wr.checkCritetia(ruleMap ,WTT4.Task_Completion_Expression__c);
}
static testMethod void Test11() {

Account a=new Account();
a.NAme='Test';
a.Account_Legal_Name__c='Test';
insert a;

      Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        

       
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Names';
        //WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT4.Status__c = 'Not-Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = '';
        WTT4.Task_Completion_Expression__c = '1';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Manual / SF should auto close this task';
        //WTT4.Workplan_Task_Rules__c=
        insert WTT4;
       
         //WTR1.Workplan_Task_Template__c = WTT4.id;
         //insert WTR1;
         
          Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
        string s='Status__C';
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
        WTR7.Value__c = 'CEDE Document';
        WTR7.Workplan_Task_Template__c = WTT4.id;
        WTR7.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR7);
        
        AIA_Benefit_Design_Product__c  ab=[select id,name from AIA_Benefit_Design_Product__c limit 1];


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
        //insert Imp;
        ailist.add(Imp);
        insert ailist;

      
      Workplan_Task__c WT = new Workplan_Task__c();
        WT.AccountID__c = a.id;
        WT.Description__c = 'Verify Account Legal Name';
        WT.Opportunity__c = o.id;
       
        WT.RelatedObjectId__c = ailist[0].id;
        WT.Status__c = 'Not Started';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
       insert WT;
       
      
       AIA_WorkPlanTasks_Completion aiataskcompletion = new AIA_WorkPlanTasks_Completion();
      
       
      
        
         aiataskcompletion.completionWorkplanTasksForSObject('Insert',ailist,'AIA_Implementation__c');
         aiataskcompletion.completionWorkplanTasksForSObject('Update',ailist,'AIA_Implementation__c');

}

static testMethod void Test12() {

Account a=new Account();
a.NAme='Test';
a.Account_Legal_Name__c='Test';
insert a;

      Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        

       
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Names';
        //WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT4.Status__c = 'Not-Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = '';
        WTT4.Task_Completion_Expression__c = '1';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Manual / SF should auto close this task';
        //WTT4.Workplan_Task_Rules__c=
        insert WTT4;
       
         //WTR1.Workplan_Task_Template__c = WTT4.id;
         //insert WTR1;
         
          Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
        string s='Status__C';
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
        
        AIA_Benefit_Design_Product__c  ab=[select id,name from AIA_Benefit_Design_Product__c limit 1];


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
        //insert Imp;
        ailist.add(Imp);
        insert ailist;

      
      Workplan_Task__c WT = new Workplan_Task__c();
        WT.AccountID__c = a.id;
        WT.Description__c = 'Verify Account Legal Name';
        WT.Opportunity__c = o.id;
       
        WT.RelatedObjectId__c = ailist[0].id;
        WT.Status__c = 'Not Started';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
       insert WT;
       
      
       AIA_WorkPlanTasks_Completion aiataskcompletion = new AIA_WorkPlanTasks_Completion();
      
       
      
        
         aiataskcompletion.completionWorkplanTasksForSObject('Insert',ailist,'AIA_Implementation__c');
         aiataskcompletion.completionWorkplanTasksForSObject('Update',ailist,'AIA_Implementation__c');

}

static testMethod void Test4() {

Account a=new Account();
a.NAme='Test';
a.Account_Legal_Name__c='Test';
insert a;

      Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        

       
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Names';
        //WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT4.Status__c = 'Not-Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = '';
        WTT4.Task_Completion_Expression__c = '2 OR ';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Manual / SF should auto close this task';
        //WTT4.Workplan_Task_Rules__c=
        insert WTT4;
       
         //WTR1.Workplan_Task_Template__c = WTT4.id;
         //insert WTR1;
         
          Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
        string s='Status__C';
        WTR.Field_API_Name__c = 'Document_Type1__c';
        WTR.Object_API_Name__c = 'AIA_Document__c';
        WTR.Object_DML_Event__c = 'Insert';
        WTR.Operation__c = 'Equal To';
        WTR.Rule_Number__c = 1;
        WTR.Value__c = 'Cede Document';
        WTR.Workplan_Task_Template__c = WTT4.id;
        WTR.Criteria_Type__c = 'Task Completion Criteria';
        
        insert WTR;
        
        List<Workplan_Task_Rules__c> WTRList = new List<Workplan_Task_Rules__c>();
        
        Workplan_Task_Rules__c WTR6 = new Workplan_Task_Rules__c();
        WTR6.Field_API_Name__c = 'Document_Type2__c';
        WTR6.Object_API_Name__c = 'AIA_Implementation__c';
        WTR6.Object_DML_Event__c = 'Insert';
        WTR6.Operation__c = 'Equal To';
        WTR6.Rule_Number__c = 2;
        WTR6.Value__c = 'Cede Document';
        WTR6.Workplan_Task_Template__c = WTT4.id;
        WTR6.Criteria_Type__c = 'Task Completion Criteria';

        WTRList.add(WTR6);
        
        Workplan_Task_Rules__c WTR7 = new Workplan_Task_Rules__c();
        WTR7.Field_API_Name__c = 'Document_Type__c';
        WTR7.Object_API_Name__c = 'AIA_Document__c';
        WTR7.Object_DML_Event__c = 'insert';
        WTR7.Operation__c = 'Not Equal To';
        WTR7.Rule_Number__c = 2;
        WTR7.Value__c = 'CEDE Document';
        WTR7.Workplan_Task_Template__c = WTT4.id;
        WTR7.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR7);
        
        Workplan_Task_Rules__c WTR25 = new Workplan_Task_Rules__c();
        WTR25.Field_API_Name__c = 'Zip_Code_Validation__c';
        WTR25.Object_API_Name__c = 'AIA_Document3__c';
        WTR25.Object_DML_Event__c = 'insert';
        WTR25.Operation__c = 'Not Equal To';
        WTR25.Rule_Number__c = 2;
        WTR25.Value__c = 'EDE Document';
        WTR25.Workplan_Task_Template__c = WTT4.id;
        WTR25.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR25); 
         insert WTRList;
        
        
        AIA_Benefit_Design_Product__c  ab=[select id,name from AIA_Benefit_Design_Product__c limit 1];


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
        //insert Imp;
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
        WT.Status__c = 'Not Started';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
       insert WT;
       
     
      
       AIA_WorkPlanTasks_Completion aiataskcompletion = new AIA_WorkPlanTasks_Completion();
      
         aiataskcompletion.completionWorkplanTasksForSObject('Insert',ailist,'AIA_Implementation__c');

}
}