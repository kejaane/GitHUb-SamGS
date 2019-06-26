/*=================================================================================================
* Date         : 12/22/2017
* Developer    : satya
* Purpose      : This test class is for AIADocumentAttachment class.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 12/22/2017|  Satya    |     | Initial Version  
* 06/08/2018| raj kiran | T01 | Added code for role updates
* 02/05/2019| Chaithra 	| T02 | replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*===========+============+=====+===================================================================
*/
@isTest
public class AIADocumentAttachmentTest1 {
    @testSetup static void testdata() {
        //Creating Test Data 
       AIA_AdjustmentSummaryUtils.disableAdjustmentSummary(); 
        AIA_Docusign_Emaills__c settings1 = new AIA_Docusign_Emaills__c(Name = 'TestUser', EmailId__c = 'test@test.com');
        insert settings1;
            
            
        Account accnt = AIA_TestUtil.acc();
        
        //Creating User Test Data 
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        /**/  userList.add(u2);
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
        user u12 = AIA_TestUtil.AIA_createUser('alias12');
        userList.add(u12);
        user u13 = AIA_TestUtil.AIA_createUser('alias13');
        userList.add(u13);
        user u14 = AIA_TestUtil.AIA_createUser('alias14');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias15');
        userList.add(u15);
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02 commented
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Implementation Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Proposal Specialist'));
        insert acctMbrList;
        
        
        Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X51');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_2_50;
        con.email           ='con@email.con';
        con.AccountId       = accnt.id;
        insert con;
        
        
        //Removed as per US210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);*/
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Removed WP per US210
        
        //Creating benefit Request Form Test Data 
        //Benfit_Request_Form__c brf = AIA_TestUtil.benForm(accnt.Id,o.id);
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //nbrf.Control_Plan__c='690';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = accnt.Id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Broker_Consultant_Name__c = con.id;
        brf.Implementation_Manager_Account_Team__c=u13.id;
        brf.Account_Executive_Account_Team__c=u14.id;
        Insert brf;
        /*//Creating AIA Plan Test Data 
        //AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        //Creating Proposed Plan Test Data 
        //Proposed_Products__c proPrd = AIA_TestUtil.proposedProduct(
            brf.id,aiapln.id);*/
        Test.startTest();
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = accnt.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Benefit_Request_Form__c=brf.id;
        Imp.Risk_Type__c='ASO';
        Imp.DocuSign_Recipient_Email__c = 'test@email.com';
        
        insert Imp;
        
         list<AIA_Document__c> aiadoclist = new list<AIA_Document__c>();
             
            AIA_Document__c aiadocBD=AIA_TestUtil.createAIADocument();
            aiadocBD.Document_Type__c = 'Business Associate Agreement (BAA)';
            aiadocBD.Implementation__c = Imp.id;
            aiadoclist.add(aiadocBD);
            AIA_Document__c aiadocBD2 =AIA_TestUtil.createAIADocument();
            aiadocBD2.Document_Type__c = 'Custom BAA';
            aiadocBD2.Implementation__c = Imp.id;
            aiadocBD2.Description__c = 'test Description';
            aiadoclist.add(aiadocBD2);
            AIA_Document__c aiadocBD3 =AIA_TestUtil.createAIADocument();
            aiadocBD3.Document_Type__c = 'Custom BAA';
            aiadocBD3.Implementation__c = Imp.id;
            aiadocBD3.Approval_Status__c = 'Approved';
            aiadocBD3.Description__c = 'test Description';
            aiadoclist.add(aiadocBD3);
            update aiadoclist;
            Test.stopTest();
                       
        
    }
    
    
    public static testMethod void testMethod1()
    { 
       Test.startTest();
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary(); 
        AIA_Implementation__c imp = [select id from AIA_Implementation__c limit 1];
         AIA_Document__c aiadocBD = [Select id,Document_Type__c from  AIA_Document__c where Document_Type__c = 'Business Associate Agreement (BAA)'];
         system.assertEquals(aiadocBD.Document_Type__c,'Business Associate Agreement (BAA)');
         
        Attachment attch=new Attachment();
        attch.parentId=aiadocBD.Id;
        attch.Body=Blob.valueOf('This is test');
        attch.description='Test description';
        attch.name='Test1';
        insert attch;
        
        system.assertNotEquals(attch.id,null);
        
       
        Test.stopTest();  
    }
    
    public static testMethod void testMethod2()
    { 
       Test.startTest();
       AIA_AdjustmentSummaryUtils.disableAdjustmentSummary(); 
        AIA_Implementation__c imp = [select id from AIA_Implementation__c limit 1];
         AIA_Document__c aiadocBD = [Select id,Document_Type__c from  AIA_Document__c where Document_Type__c = 'Business Associate Agreement (BAA)'];
         system.assertEquals(aiadocBD.Document_Type__c,'Business Associate Agreement (BAA)');
         
        Attachment attch=new Attachment();
        attch.parentId=imp.Id;
        attch.Body=Blob.valueOf('This is test');
        attch.description='Test description';
        attch.name='Test1';
        insert attch;
        
        system.assertEquals(attch.name,'Test1');
        
       
        Test.stopTest();  
    }
    
    
    public static testMethod void testMethod3()
    { 
       Test.startTest();
       AIA_AdjustmentSummaryUtils.disableAdjustmentSummary(); 
        List<String> sendToEmailList = new List<String>();
        AIA_Implementation__c imp = [select id from AIA_Implementation__c limit 1];
         AIA_Docusign_Emaills__c toEmails = AIA_Docusign_Emaills__c.getAll().values();
         sendToEmailList.add(toEmails.EmailId__c); 
         AIA_Document__c aiadocBD = [Select id,Document_Type__c from  AIA_Document__c where Document_Type__c = 'Custom BAA' and Approval_Status__c != 'Approved'];
         system.assertEquals(aiadocBD.Document_Type__c,'Custom BAA');
         
         
        Attachment attch=new Attachment();
        attch.parentId=aiadocBD.Id;
        attch.Body=Blob.valueOf('This is test');
        attch.description='Test description';
        attch.name='Test1';
        insert attch;
        
       
        Test.stopTest();  
    }
    
    
    public static testMethod void testMethod4()
    { 
       Test.startTest();
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary(); 
        AIA_Implementation__c imp = [select id from AIA_Implementation__c limit 1];
         
        Attachment attch=new Attachment();
        attch.parentId=imp.Id;
        attch.Body=Blob.valueOf('This is test');
        attch.description='Test description';
        attch.name='Business Associate Confirmation Form.pdf';
        insert attch;
        system.assertNotEquals(attch.id,null);
        
       
        Test.stopTest();  
    }
    
    
    public static testMethod void testMethod5()
    { 
       Test.startTest();
       AIA_AdjustmentSummaryUtils.disableAdjustmentSummary(); 
        List<String> sendToEmailList = new List<String>();
        AIA_Implementation__c imp = [select id from AIA_Implementation__c limit 1];
         AIA_Docusign_Emaills__c toEmails = AIA_Docusign_Emaills__c.getAll().values();
         sendToEmailList.add(toEmails.EmailId__c); 
         AIA_Document__c aiadocBD = [Select id,Document_Type__c from  AIA_Document__c where Document_Type__c = 'Custom BAA' and Approval_Status__c = 'Approved'];
         system.assertEquals(aiadocBD.Document_Type__c,'Custom BAA');
         
         
        Attachment attch=new Attachment();
        attch.parentId=aiadocBD.Id;
        attch.Body=Blob.valueOf('This is test');
        attch.description='Test description';
        attch.name='Test1';
        insert attch;
        
       
        Test.stopTest();  
    }
   
}