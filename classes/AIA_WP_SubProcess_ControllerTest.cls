/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/

@isTest
private class AIA_WP_SubProcess_ControllerTest {
    
    public static testmethod void PositiveAIA_SubProcessTesting(){   
      /* comm as per 210
        User currentUser=AIA_TestUtil.createTestUser(); 
        system.assertNotEquals(null, currentUser.id);
        
        System.runAs (currentUser) {
            AIA_Config__c config = new AIA_Config__c();
            config.Name='AIA_Workplan.createWorkplanAssignments';
            config.Run__c = true;
            insert config;
            system.assertNotEquals(null,config.Run__c);
            
            Account TestAcc = AIA_Testutil.createAccount('Test Account');  
            system.assertNotEquals(null,TestAcc.id); 
            
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'Implementation Coordinator';
            atm.AccountId =TestAcc.id;
            atm.UserId = userinfo.getUserId();
            insert atm;
            system.assertNotEquals(null,atm.id); 
            
            
            AIA_Workplan_Type__c WpType =AIA_Testutil.AIA_CreateWorkPlan();
            insert WpType;
            system.assertNotEquals(null,WpType.id); 
            
            
            Schema.DescribeSObjectResult WPTSdSobjres = Schema.SObjectType.Workplan_Type_Stage__c; 
            Map<String,Schema.RecordTypeInfo> WPTSRecordType = WPTSdSobjres.getRecordTypeInfosByName();
            
            Id ProcesswptsRtid    = WPTSRecordType.get('Process').getRecordTypeId();       //Getting the Process RecordTypeID
            Id SubProcesswptsRtid = WPTSRecordType.get('Sub-Process').getRecordTypeId();  
            
            Workplan_Type_Stage__c process = AIA_Workplan_Test.AIA_CreateWorkTypeStage(ProcesswptsRtid,WpType.id);
            insert process;
            system.assertNotEquals(null,process.id); 
            
            Workplan_Type_Stage__c subprocess = AIA_Workplan_Test.AIA_CreateWorkTypeStage(SubProcesswptsRtid,WpType.id);
            subprocess.Parent_Workplan_Type_Stage__c =process.id;
            insert subprocess;
            system.assertNotEquals(null,subprocess.id); 
            
            Workplan_Type_Stage__c subprocess2 = AIA_Workplan_Test.AIA_CreateWorkTypeStage(SubProcesswptsRtid,WpType.id);
            subprocess2.Parent_Workplan_Type_Stage__c =process.id;
            insert subprocess2;
            system.assertNotEquals(null,subprocess2.id); 
            
            AIA_Workplan_Type_Task__c wptt = AIA_Workplan_Test.AIA_CreateWorkTypeTask(subprocess.id); 
            wptt.Send_Notification__c = true;
            wptt.Assgin_To_Non_AIA_Contact__c = false;
            wptt.Default_Owner__c = userinfo.getUserId();
            insert wptt;
            system.assertNotEquals(null,wptt.id); 
            
            AIA_Workplan_Type_Task__c wptt1 = AIA_Workplan_Test.AIA_CreateWorkTypeTask1(subprocess.id); 
            wptt1.Default_Owner__c = userinfo.getUserId();
            insert wptt1;
            system.assertNotEquals(null,wptt1.id); 
            
            AIA_Workplan_Type_Task__c wptt2 = AIA_Workplan_Test.AIA_CreateWorkTypeTask1(subprocess.id); 
            wptt2.Default_Owner__c = userinfo.getUserId();
            wptt2.Assignee_Type__c = 'Role';
            wptt2.Role__c ='Implementation Coordinator';
            insert wptt2;
            system.assertNotEquals(null,wptt2.id);
            
            
            Opportunity opp = new Opportunity();
            opp.Name = 'Test opp';
            opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
            opp.StageName = 'RFP';
            opp.CloseDate = Date.today() + 7;
            opp.AccountId = TestAcc.id;
            opp.Market_Segment_New__c = '51-199';
            // opp.Business_type__c = 'Off-Cycle';
            opp.Division__c = '51-199 New Business';
            opp.Legal_Account_Name_Verified__c =true;
            opp.Underwriting_Entity__c = 'NCAS';
            Date tday = system.today();
            opp.Effective_Date__c =Date.newInstance(tday.Year(),tday.month(),1);  //Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
            opp.CloseDate = opp.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
            opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
            opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);            
            opp.Off_Cycle_Term_Date__c = opp.Effective_Date__c.addDays(-1);
            
            Id opptwohundredplusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId;
            opp.RecordTypeId = opptwohundredplusId;
            
            Test.startTest();
            insert opp;
            system.assertNotEquals(null,opp.id);
            
            opp.Workplan_Type__c = WpType.id;
            update opp;
            System.assertEquals(opp.Workplan_Type__c, WpType.id);
            
            System.debug('***'+opp.Workplan_Type__c);
            System.debug('***'+WpType.id);
            opp.StageName ='ARC Approval';
            
            Schema.DescribeSObjectResult WPSdSobjres = Schema.SObjectType.Workplan_Stage__c; 
            Map<String,Schema.RecordTypeInfo> WPSRecordType = WPSdSobjres.getRecordTypeInfosByName(); 
            Id ProcesswpsRtid = WPSRecordType.get('Process').getRecordTypeId(); 
            Id SubProcesswpsRtid = WPSRecordType.get('Sub-Process').getRecordTypeId(); 
            
            
            List<Workplan_Stage__c> wpstages=[select id,Account__c,Workplan_Type__r.ownerId,Implementation__r.Account__c,Implementation__r.account__r.name,implementation__r.Implementation_Plan_Timeline_Days__c,implementation__r.Effective_Date__c, 
                                              name,Parent_Workplan_Stage__c,All_Assignments_Must_Be_Completed__c,RecordType.Name from Workplan_Stage__c where  Opportunity__c=:opp.id and RecordTypeid=:SubProcesswpsRtid];
            system.assertequals(wpstages.size(),2);
            Set<id> wpsidset = new Set<id>();
            Set<id> Parentwpsidset = new Set<id>();
            for(Workplan_Stage__c obj:wpstages)
                wpsidset.add(obj.id);
            System.debug('***'+wpstages);
            for(Workplan_Stage__c obj:wpstages) 
                Parentwpsidset.add(obj.Parent_Workplan_Stage__c);
            System.debug('***'+Parentwpsidset);
            List<AIA_Workplan_Assignment__c> wpas=[select id,Status__c,External_Assignee__c,ownerID,Workplan_Stage__c from AIA_Workplan_Assignment__c where Workplan_Stage__c in :wpsidset];
            List<Workplan_Stage__c> parentwpas=[select id,Status__c,Parent_Workplan_Stage__c,Workplan_Stage__c from Workplan_Stage__c where Workplan_Stage__c in :Parentwpsidset];
            Workplan_Stage__c wps;
            
            if(wpstages != NULL && wpstages.size() > 0){
                wps =wpstages[0];
            }
            wps.ownerID = userinfo.getUserId();
            update wps;
            if(wps != NULL){
                //setup a reference to the page the controller is expecting with the parameters
                PageReference pref = Page.AIA_Workplan_SubProcess;
                Test.setCurrentPage(pref);
                pref.getParameters().put('Id',wps.Id);  
                pref.getParameters().put('type','ssp');
                
                
                // Construct the standard controller
                ApexPages.StandardController con = new ApexPages.StandardController(wps);
                
                // create the controller
                AIA_WP_SubProcess_Controller cntrl = new AIA_WP_SubProcess_Controller(con);
                // Switch to test context
                cntrl.onPageLoad();
                wps.Status__c = 'In Progress';
                update wps;
                AIA_WP_SubProcess_Controller.MarkNotRequired();
                set<ID> userID = new set<ID>();
                userID.add(currentUser.id);
                if(userID != null && userID.size()>0)
                    AIA_WP_SubProcess_Controller.sendMail(userID,wpas);
            }
            
            
            Test.stopTest();
           
        }
 */
    }
   /* 
    public static Workplan_Type_Stage__c AIA_CreateWorkTypeStage(Id recordTypeId,Id wptId){
        comm as per us 210
        Workplan_Type_Stage__c wpts = new Workplan_Type_Stage__c();
        wpts.Active__c=true;
        wpts.stage__c = 'RFP';
        wpts.recordTypeId = recordTypeId;
        wpts.Workplan_Type__c = wptId;
        
        return wpts;

    }
  */  
    /*comm as per 210 us
    public static testmethod void PositiveAIA_SubProcessTestingRoleTeam(){      
        
        User currentUser=AIA_TestUtil.createTestUser();      
        system.assertNotEquals(null, currentUser.id);
        
        Account TestAcc = AIA_Testutil.createAccount('Test Account');  
        system.assertNotEquals(null,TestAcc.id); 
        
        AccountTeamMember atm = new AccountTeamMember ();
        atm.TeamMemberRole = 'Implementation Coordinator';
        atm.AccountId =TestAcc.id;
        atm.UserId = userinfo.getUserId();
        insert atm;
        system.assertNotEquals(null,atm.id); 
        
        System.runAs (currentUser) {
            AIA_Config__c config = new AIA_Config__c();
            config.Name='AIA_Workplan.createWorkplanAssignments';
            config.Run__c = true;
            insert config;
            system.assertNotEquals(null,config.Run__c);
            
            
            AccountTeamMember accTeam = new AccountTeamMember ();
            accTeam.TeamMemberRole = 'Implementation Coordinator';
            accTeam.AccountId =TestAcc.id;
            accTeam.UserId = currentUser.id; 
            insert accTeam; 
            system.assertNotEquals(null,accTeam.id);
            
            AccountTeamMember accTeamRole = new AccountTeamMember ();
            accTeamRole.TeamMemberRole = 'Implementation Coordinator';
            accTeamRole.AccountId =TestAcc.id;
            accTeamRole.UserId = currentUser.id; 
            insert accTeamRole; 
            system.assertNotEquals(null,accTeamRole.id);
            
         /*   AccountTeamMember atm3 = new AccountTeamMember ();
            atm3.TeamMemberRole = 'Underwriter';
            atm3.AccountId = TestAcc.id;
            atm3.UserId = currentUser.id;
            insert atm3;  
            
            system.assertNotEquals(null,atm3.id);*/
            
            /*
            AIA_Workplan_Type__c WpType =AIA_Testutil.AIA_CreateWorkPlan();
            insert WpType;
            system.assertNotEquals(null,WpType.id); 
            
            Schema.DescribeSObjectResult WPTSdSobjres = Schema.SObjectType.Workplan_Type_Stage__c; 
            Map<String,Schema.RecordTypeInfo> WPTSRecordType = WPTSdSobjres.getRecordTypeInfosByName();
            
            Id ProcesswptsRtid    = WPTSRecordType.get('Process').getRecordTypeId();       //Getting the Process RecordTypeID
            Id SubProcesswptsRtid = WPTSRecordType.get('Sub-Process').getRecordTypeId();  
            
            Workplan_Type_Stage__c process = AIA_Workplan_Test.AIA_CreateWorkTypeStage(ProcesswptsRtid,WpType.id);
            insert process;
            system.assertNotEquals(null,process.id); 
            
            Workplan_Type_Stage__c subprocess = AIA_Workplan_Test.AIA_CreateWorkTypeStage(SubProcesswptsRtid,WpType.id);
            subprocess.Parent_Workplan_Type_Stage__c =process.id;
            insert subprocess;
            system.assertNotEquals(null,subprocess.id); 
            
            Workplan_Type_Stage__c subprocess2 = AIA_Workplan_Test.AIA_CreateWorkTypeStage(SubProcesswptsRtid,WpType.id);
            subprocess2.Parent_Workplan_Type_Stage__c =process.id;
            insert subprocess2;
            system.assertNotEquals(null,subprocess2.id); 
            
            AIA_Workplan_Type_Task__c wptt = AIA_Workplan_Test.AIA_CreateWorkTypeTask(subprocess.id); 
            wptt.Send_Notification__c = true;
            wptt.Assgin_To_Non_AIA_Contact__c = false;
            wptt.Default_Owner__c = userinfo.getUserId();
            insert wptt;
            system.assertNotEquals(null,wptt.id); 
            
            AIA_Workplan_Type_Task__c wptt1 = AIA_Workplan_Test.AIA_CreateWorkTypeTask1(subprocess.id); 
            wptt1.Default_Owner__c = userinfo.getUserId();
            insert wptt1;
            system.assertNotEquals(null,wptt1.id); 
            
            AIA_Workplan_Type_Task__c wptt2 = AIA_Workplan_Test.AIA_CreateWorkTypeTask1(subprocess.id); 
            wptt2.Default_Owner__c = userinfo.getUserId();
            wptt2.Assignee_Type__c = 'Role';
            wptt2.Role__c ='Implementation Coordinator';
            insert wptt2;
            system.assertNotEquals(null,wptt2.id);
            
            
            Opportunity opp = new Opportunity();
            opp.Name = 'Test opp';
            opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
            opp.StageName = 'RFP';
            opp.CloseDate = Date.today() + 7;
            opp.AccountId = TestAcc.id;
            opp.Market_Segment_New__c = '51-199';
            // opp.Business_type__c = 'Off-Cycle';
            opp.Division__c = '51-199 New Business';
            opp.Legal_Account_Name_Verified__c =true;
            opp.Underwriting_Entity__c = 'NCAS';
            Date tday = system.today();
            opp.Effective_Date__c =Date.newInstance(tday.Year(),tday.month(),1);  //Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
            opp.CloseDate = opp.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
            opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
            opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);            
            opp.Off_Cycle_Term_Date__c = opp.Effective_Date__c.addDays(-1);
            
            Id opptwohundredplusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId;
            opp.RecordTypeId = opptwohundredplusId;
            
            Test.startTest();
            insert opp;
            system.assertNotEquals(null,opp.id);
            
            opp.Workplan_Type__c = WpType.id;
            update opp;
            System.assertEquals(opp.Workplan_Type__c, WpType.id);
            
            System.debug('***'+opp.Workplan_Type__c);
            System.debug('***'+WpType.id);
            opp.StageName ='ARC Approval';
            
            Schema.DescribeSObjectResult WPSdSobjres = Schema.SObjectType.Workplan_Stage__c; 
            Map<String,Schema.RecordTypeInfo> WPSRecordType = WPSdSobjres.getRecordTypeInfosByName(); 
            Id ProcesswpsRtid = WPSRecordType.get('Process').getRecordTypeId(); 
            Id SubProcesswpsRtid = WPSRecordType.get('Sub-Process').getRecordTypeId(); 
            
            
            List<Workplan_Stage__c> wpstages=[select id,Account__c,Workplan_Type__r.ownerId,Implementation__r.Account__c,Implementation__r.account__r.name,implementation__r.Implementation_Plan_Timeline_Days__c,implementation__r.Effective_Date__c, 
                                              name,Parent_Workplan_Stage__c,All_Assignments_Must_Be_Completed__c,RecordType.Name from Workplan_Stage__c where  Opportunity__c=:opp.id and RecordTypeid=:SubProcesswpsRtid];
            system.assertequals(wpstages.size(),2);
            Set<id> wpsidset = new Set<id>();
            Set<id> Parentwpsidset = new Set<id>();
            for(Workplan_Stage__c obj:wpstages)
                wpsidset.add(obj.id);
            System.debug('***'+wpstages);
            for(Workplan_Stage__c obj:wpstages) 
                Parentwpsidset.add(obj.Parent_Workplan_Stage__c);
            System.debug('***'+Parentwpsidset);
            List<AIA_Workplan_Assignment__c> wpas=[select id,Status__c,External_Assignee__c,ownerID,Workplan_Stage__c from AIA_Workplan_Assignment__c where Workplan_Stage__c in :wpsidset];
            List<Workplan_Stage__c> parentwpas=[select id,Status__c,Parent_Workplan_Stage__c,Workplan_Stage__c from Workplan_Stage__c where Workplan_Stage__c in :Parentwpsidset];
            Workplan_Stage__c wps;
            
            if(wpstages != NULL && wpstages.size() > 0){
                wps =wpstages[0];
            }
            wps.ownerID = userinfo.getUserId();
            update wps;
            if(wps != NULL){
                //setup a reference to the page the controller is expecting with the parameters
                PageReference pref = Page.AIA_Workplan_SubProcess;
                Test.setCurrentPage(pref);
                pref.getParameters().put('Id',wps.Id);  
                pref.getParameters().put('type','ssp');
                
                
                // Construct the standard controller
                ApexPages.StandardController con = new ApexPages.StandardController(wps);
                
                // create the controller
                AIA_WP_SubProcess_Controller cntrl = new AIA_WP_SubProcess_Controller(con);
                // Switch to test context
                cntrl.onPageLoad();
                wps.Status__c = 'In Progress';
                update wps;
                AIA_WP_SubProcess_Controller.MarkNotRequired();
                set<ID> userID = new set<ID>();
                userID.add(currentUser.id);
                if(userID != null && userID.size()>0)
                    AIA_WP_SubProcess_Controller.sendMail(userID,wpas);
                
                //test sendmail method for contactids
                Contact testCon=AIA_TestUtil.createTestContactsAcc(TestAcc.id);
                insert testCon;
                set<ID> contactID = new set<ID>();
                contactID.add(testCon.id);
                AIA_WP_SubProcess_Controller.sendMail(contactID,wpas);
            }
            
            
            Test.stopTest();
            
        }
    }
   */ 
                /*
    public static testmethod void PositiveAIA_SubProcessTestingWithNORoleTeam(){  
        
        User currentUser=AIA_TestUtil.createTestUser();      
        system.assertNotEquals(null, currentUser.id);
        System.runAs (currentUser) {
            AIA_Config__c config = new AIA_Config__c();
            config.Name='AIA_Workplan.createWorkplanAssignments';
            config.Run__c = true;
            insert config;
            system.assertNotEquals(null,config.Run__c);
            
            Account TestAcc = AIA_Testutil.createAccount('Test Account');  
            system.assertNotEquals(null,TestAcc.id); 
            
       /*     AccountTeamMember atm3 = new AccountTeamMember ();
            atm3.TeamMemberRole = 'Underwriter';
            atm3.AccountId = TestAcc.id;
            atm3.UserId = currentUser.id;
            insert atm3;  
            system.assertNotEquals(null,atm3.id);*/
           
           /* 
            AIA_Workplan_Type__c WpType =AIA_Testutil.AIA_CreateWorkPlan();
            insert WpType;
            system.assertNotEquals(null,WpType.id); 
            
            Schema.DescribeSObjectResult WPTSdSobjres = Schema.SObjectType.Workplan_Type_Stage__c; 
            Map<String,Schema.RecordTypeInfo> WPTSRecordType = WPTSdSobjres.getRecordTypeInfosByName();
            
            Id ProcesswptsRtid    = WPTSRecordType.get('Process').getRecordTypeId();       //Getting the Process RecordTypeID
            Id SubProcesswptsRtid = WPTSRecordType.get('Sub-Process').getRecordTypeId();  
            
            Workplan_Type_Stage__c process = AIA_Workplan_Test.AIA_CreateWorkTypeStage(ProcesswptsRtid,WpType.id);
            insert process;
            system.assertNotEquals(null,process.id); 
            
            Workplan_Type_Stage__c subprocess = AIA_Workplan_Test.AIA_CreateWorkTypeStage(SubProcesswptsRtid,WpType.id);
            subprocess.Parent_Workplan_Type_Stage__c =process.id;
            insert subprocess;
            system.assertNotEquals(null,subprocess.id); 
            
            Workplan_Type_Stage__c subprocess2 = AIA_Workplan_Test.AIA_CreateWorkTypeStage(SubProcesswptsRtid,WpType.id);
            subprocess2.Parent_Workplan_Type_Stage__c =process.id;
            insert subprocess2;
            system.assertNotEquals(null,subprocess2.id); 
            
            AIA_Workplan_Type_Task__c wptt = AIA_Workplan_Test.AIA_CreateWorkTypeTask(subprocess.id); 
            wptt.Send_Notification__c = true;
            wptt.Assgin_To_Non_AIA_Contact__c = false;
            wptt.Default_Owner__c = userinfo.getUserId();
            insert wptt;
            system.assertNotEquals(null,wptt.id); 
            
            AIA_Workplan_Type_Task__c wptt1 = AIA_Workplan_Test.AIA_CreateWorkTypeTask1(subprocess.id); 
            wptt1.Default_Owner__c = userinfo.getUserId();
            insert wptt1;
            system.assertNotEquals(null,wptt1.id); 
            
            AIA_Workplan_Type_Task__c wptt2 = AIA_Workplan_Test.AIA_CreateWorkTypeTask1(subprocess.id); 
            wptt2.Default_Owner__c = userinfo.getUserId();
            wptt2.Assignee_Type__c = 'Role';
            wptt2.Role__c ='Implementation Coordinator';
            insert wptt2;
            system.assertNotEquals(null,wptt2.id);
            
            
            Opportunity opp = new Opportunity();
            opp.Name = 'Test opp';
            opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
            opp.StageName = 'RFP';
            opp.CloseDate = Date.today() + 7;
            opp.AccountId = TestAcc.id;
            opp.Market_Segment_New__c = '51-199';
            // opp.Business_type__c = 'Off-Cycle';
            opp.Division__c = '51-199 New Business';
            opp.Legal_Account_Name_Verified__c =true;
            opp.Underwriting_Entity__c = 'NCAS';
            Date tday = system.today();
            opp.Effective_Date__c =Date.newInstance(tday.Year(),tday.month(),1);  //Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
            opp.CloseDate = opp.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
            opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
            opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);            
            opp.Off_Cycle_Term_Date__c = opp.Effective_Date__c.addDays(-1);
            
            Id opptwohundredplusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId;
            opp.RecordTypeId = opptwohundredplusId;
            
            Test.startTest();
            insert opp;
            system.assertNotEquals(null,opp.id);
            
            opp.Workplan_Type__c = WpType.id;
            update opp;
            System.assertEquals(opp.Workplan_Type__c, WpType.id);
            
            System.debug('***'+opp.Workplan_Type__c);
            System.debug('***'+WpType.id);
            opp.StageName ='ARC Approval';
            
            Schema.DescribeSObjectResult WPSdSobjres = Schema.SObjectType.Workplan_Stage__c; 
            Map<String,Schema.RecordTypeInfo> WPSRecordType = WPSdSobjres.getRecordTypeInfosByName(); 
            Id ProcesswpsRtid = WPSRecordType.get('Process').getRecordTypeId(); 
            Id SubProcesswpsRtid = WPSRecordType.get('Sub-Process').getRecordTypeId(); 
            
            
            List<Workplan_Stage__c> wpstages=[select id,Account__c,Workplan_Type__r.ownerId,Implementation__r.Account__c,Implementation__r.account__r.name,implementation__r.Implementation_Plan_Timeline_Days__c,implementation__r.Effective_Date__c, 
                                              name,Parent_Workplan_Stage__c,All_Assignments_Must_Be_Completed__c,RecordType.Name from Workplan_Stage__c where  Opportunity__c=:opp.id and RecordTypeid=:SubProcesswpsRtid];
            system.assertequals(wpstages.size(),2);
            Set<id> wpsidset = new Set<id>();
            Set<id> Parentwpsidset = new Set<id>();
            for(Workplan_Stage__c obj:wpstages)
                wpsidset.add(obj.id);
            System.debug('***'+wpstages);
            for(Workplan_Stage__c obj:wpstages) 
                Parentwpsidset.add(obj.Parent_Workplan_Stage__c);
            System.debug('***'+Parentwpsidset);
            List<AIA_Workplan_Assignment__c> wpas=[select id,Status__c,External_Assignee__c,ownerID,Workplan_Stage__c from AIA_Workplan_Assignment__c where Workplan_Stage__c in :wpsidset];
            List<Workplan_Stage__c> parentwpas=[select id,Status__c,Parent_Workplan_Stage__c,Workplan_Stage__c from Workplan_Stage__c where Workplan_Stage__c in :Parentwpsidset];
            Workplan_Stage__c wps;
            
            if(wpstages != NULL && wpstages.size() > 0){
                wps =wpstages[0];
            }
            wps.ownerID = userinfo.getUserId();
            update wps;
            if(wps != NULL){
                //setup a reference to the page the controller is expecting with the parameters
                PageReference pref = Page.AIA_Workplan_SubProcess;
                Test.setCurrentPage(pref);
                pref.getParameters().put('Id',wps.Id);  
                pref.getParameters().put('type','ssp');
                
                
                // Construct the standard controller
                ApexPages.StandardController con = new ApexPages.StandardController(wps);
                
                // create the controller
                AIA_WP_SubProcess_Controller cntrl = new AIA_WP_SubProcess_Controller(con);
                // Switch to test context
                cntrl.onPageLoad();
                wps.Status__c = 'In Progress';
                update wps;
                AIA_WP_SubProcess_Controller.MarkNotRequired();
                set<ID> userID = new set<ID>();
                userID.add(currentUser.id);
                if(userID != null && userID.size()>0)
                    AIA_WP_SubProcess_Controller.sendMail(userID,wpas);
            }
            
            
            Test.stopTest();
           
        }
    }
   */ 
   
}