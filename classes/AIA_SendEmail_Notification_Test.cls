/*****************************************************************************************************
*Date: 10-05-2017
*Developer: Satya Tirumalasetti
*Purpose: Test class for AIA_SendEmail_Notification class
*=========================================================================================
* Update History
* Date         Developer	Tag               Description
*==================================================================================
*10-05-2017   	Satya            		Initial Development
*02-13-2019		Chaithra 	|T01| 		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*==================================================================================

*******************************************************************************************************/

@isTest
Private class AIA_SendEmail_Notification_Test {
    
    @testsetup
    public static void createTestData() {
        
        
        EmailTemplate et = [SELECT BrandTemplateId,FolderId,Id,Name FROM EmailTemplate WHERE Name = 'AIA Notification for Dead Opp'];
        
        Account acc = AIA_TestUtil.CreateAccount2('TestAccount');  
        
        Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test1';
        cont.Accountid= acc.id;
        cont.Phone= '(987) 234-7892';
        cont.Email='test@gmail.com';
        insert cont;
        
        Profile nonAdminProfile = [select id from profile where name='AIA 200+ Standard User - Custom'];
        Profile adminProfile = [select id from profile where name='System Administrator'];
        
        //Creating User Test Data 
        List<user> userList = new list<user>();
        
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        u1.LastName = 'alias1';
        u1.ProfileId= nonAdminProfile.Id;
        userList.add(u1); 
        
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        u2.LastName = 'alias2';
        u2.ProfileId =nonAdminProfile.Id;
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
        
        insert userList;  
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();T01
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// T01 Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Account Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'Proposal Specialist')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u6.id,'Underwriter'));
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Sales Assistant')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Pharmacy Operations')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u13.id,'Pharmacy Management')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Benefit Tester')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u16.id,'Vision Analyst')); 
        //Sales Assistant
        insert acctMbrList;
        
        
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        
        insert pbe2;        
        //Using start and end methods for recaluclating limatations.
        test.startTest();
        
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        Benfit_Request_Form__c brf = AIA_TestUtil.createBrfgs(acc.id,opp.id);
        AIA_Implementation__c objImpl = AIA_TestUtil.CreateImplementation(opp.Id);
        AIA_Implementation__c objImpl1 = AIA_TestUtil.CreateImplementation1(opp.Id);
        
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = objImpl.id;
        aiaBD.Account__c=acc.id;
        aiaBD.Benefit_Request_Form__c=brf.id; 
        aiaBD.status__c = 'In Progress';
        insert aiaBD;
        List<Process__c> objProcess = AIA_TestUtil.CreateProcessList(objImpl1.Id);        
        List<Sub_Process__c> objSubProc = AIA_TestUtil.CreateSubProcessList(objImpl1.Id,objProcess[0].Id);
        
        List<WorkPlan_Task__c> lstTask = new List<WorkPlan_Task__c>();      
        List<string> userId = new List<string>();
        userId.add(u1.Id);
        userId.add(u2.Id);
        
        string strTeamRole = 'BeneFact Coder';  
        lstTask = AIA_TestUtil.CreateWorkPlanTask(objImpl1.Id, opp.Id, objSubProc[0].Id, userId,strTeamRole);  
        
        FeedItem post = new FeedItem();
        post.ParentId = u11.Id; 
        post.Body = 'Test';
        //post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'+objectPrefix+'?fcf='+viewId;
        //feedLst.add(post);    
        insert post;        
        test.stopTest();
        
    } 
    
    
    //Test if Opp is sold and chatter notification is sent to user
    public static testMethod void testSendChatterNotificationOnOppSold(){
        
        Account acc = [Select id from Account limit 1];
        //T01 starts
        /*AccountTeamMember accteam = [SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId,User.email,User.Name 
                                     FROM AccountTeamMember where AccountId = :acc.id limit 1];*/
        Account_Team__c accteam =[SELECT AccountAccessLevel__c,AccountId__c,TeamMemberRole__c,UserId__c,UserId__r.Email,UserId__r.Name
                                FROM Account_Team__c where AccountId__c= :acc.id limit 1];
        //T01 Ends
        test.startTest();
        list<Opportunity> oppList = [Select id, AccountId,StageName,Description from opportunity limit 1];
        Benfit_Request_Form__c brf = [Select id,ARC_Approval_Status__c,Status__c from Benfit_Request_Form__c limit 1];
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Opportunity__c  =oppList[0].id; 
        brf.Status__c = 'Sold';
        
        
        
        update brf;
        oppList[0].Won_Lost_Reason__c = 'Acquisition';
        oppList[0].Incumbent_Successor__c = 'Aetna';
        oppList[0].AccountId = acc.id;
        oppList[0].Potential_Contracts__c = 2;
        oppList[0].System__c = 'NASCO';
        oppList[0].StageName = 'Sold';
        system.debug('oppid>>>'+oppList[0].id);
        update oppList[0]; 
        
        System.assertEquals(oppList[0].StageName,'Sold');//ASIF REPLACE THIS WITH FEEDITEM CHECK
        list<Opportunity> oppList1 = [Select id, AccountId,StageName from opportunity where ID=:oppList[0].id];
        System.assertEquals(oppList1[0].StageName,'Sold');
        
        FeedItem feeditem = [select id,ParentId from FeedItem where ParentId =:accteam.UserId__c];//T01 replaced UserID
        System.assertnotEquals(feeditem ,null);
        System.assertEquals(feeditem.ParentId ,accteam.UserId__c);//T01 replaced UserID
        test.stopTest();
    }
    
    //Test if Opp is Dead and chatter notification is sent to user
    public static testMethod void testSendChatterNotificationDead(){
        test.startTest();
        Account acc = [Select id from Account limit 1];
        //T01 Starts
        /*AccountTeamMember accteam = [SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId,User.email,User.Name 
                                     FROM AccountTeamMember where AccountId = :acc.id and User.isActive = true limit 1];*/
        Account_Team__c accteam =[SELECT AccountAccessLevel__c,AccountId__c,TeamMemberRole__c,UserId__c,UserId__r.Email,UserId__r.Name
                                FROM Account_Team__c where AccountId__c= :acc.id and UserId__r.isActive = true limit 1];
        //T01 Ends
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        opp.stageName='RFP';
        update opp;
        opp.Won_Lost_Reason__c = 'Acquisition';
        opp.Incumbent_Successor__c = 'Aetna';
        opp.StageName = 'Dead';
        
        update opp;
        System.assertEquals(opp.StageName,'Dead');
        /*FeedItem feeditem = [select id,ParentId from FeedItem where ParentId =:accteam.UserId];
System.assertnotEquals(feeditem ,null);
System.assertEquals(feeditem.ParentId ,accteam.UserId);*/
        
        test.stopTest();
    }
    
    
    //Test if Implementation is made In-Progress and Email notification is sent to user
    public static testMethod void testImpStage(){
        
        Account acc = [Select id from Account limit 1];
        //T01 Starts
        /*AccountTeamMember accteam = [SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId,User.email,User.Name 
                                     FROM AccountTeamMember where AccountId = :acc.id limit 1];*/
        Account_Team__c accteam =[SELECT AccountAccessLevel__c,AccountId__c,TeamMemberRole__c,UserId__c,UserId__r.Email,UserId__r.Name
                                 FROM Account_Team__c where AccountId__c= :acc.id limit 1];
        //T01 Ends
        test.startTest();
        list<AIA_Implementation__c> impList = [Select id,status__c,Account__c from AIA_Implementation__c where status__c='Not Started' limit 1];
        system.System.assertEquals(impList[0].Status__c,'Not Started'); 
        
        
        impList[0].Status__c = 'In-Progress';
        impList[0].Account__c = acc.id;
        update impList[0]; 
        system.System.assertEquals(impList[0].Status__c,'In-Progress');
        Integer invocations = Limits.getEmailInvocations();
        system.assertEquals((invocations > 0), true, 'An email should be sent');
        test.stopTest();
    }
    
    
    //Test if Benefit Design is Approved and Email notification is sent to user
    public static testMethod void testBDStage(){
        
        AIA_Benefit_Design__c BD = [select id,status__C from AIA_Benefit_Design__c limit 1];
        system.System.assertEquals(BD.Status__c,'In Progress'); 
        test.startTest();
        BD.Status__c = 'Approved';      
        update BD; 
        System.assertEquals(BD.Status__c,'Approved');
        Integer invocations = Limits.getEmailInvocations();
        system.assertEquals(1, invocations, 'An email should be sent');
        test.stopTest();
    }
    
    
    //Test if AIA Document is uploaded and chatter notification is sent to user
    public static testMethod void testAiaDocStage(){
        Account acc = [Select id from Account limit 1];
        //T01 Starts
        /*AccountTeamMember accteam = [SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId,User.email,User.Name 
                                     FROM AccountTeamMember where AccountId = :acc.id and TeamMemberRole = 'Sales Assistant' limit 1];*/
        Account_Team__c accteam =[SELECT AccountAccessLevel__c,AccountId__c,TeamMemberRole__c,UserId__c,UserId__r.Email,UserId__r.Name
                                 FROM Account_Team__c where AccountId__c= :acc.id and TeamMemberRole__c='Sales Assistant' limit 1];
        //T01 Ends
        test.startTest();
        AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument1(acc.id);
        System.assertEquals(aiaDoc.Approval_Status__c , 'Not Started');
        AIA_DocumentTriggerHandler.beforeUpdateRecursive=false;
        AIA_DocumentTriggerHandler.afterUpdateRecursive = false;
        list<FeedItem> lstFeedItems = [select id,ParentId,Type,Body,Title from FeedItem where ParentId =:accteam.UserId__c];//T01 replaced Userid
        System.debug('lstFeedItems=='+lstFeedItems);
        System.assertnotEquals(lstFeedItems.size(),0);
        System.assertEquals(lstFeedItems[0].ParentId,accteam.UserId__c);//T01 replaced Userid
        test.stopTest();
    }
    
    
    //Test if workplan is completed
    public static testMethod void testworkplan(){
        
        AIA_Implementation__c imp = [Select id,status__c from AIA_Implementation__c where status__c='In-Progress' limit 1];
        WorkPlan_Task__c wpTask = [Select id, status__c,implementation__c from WorkPlan_Task__c limit 1];
        System.assertEquals(wpTask.Status__c,'In Progress'); 
        test.startTest();
        
        wpTask.implementation__c = imp.id;
        wpTask.status__c = 'Completed';
        update wpTask;
        system.assertEquals(wpTask.Status__c,'Completed');
        imp.Status__c = 'Completed'; 
        update imp;
        //ASIF ADD ASSERT
        test.stopTest();
    }
    
    
    
}