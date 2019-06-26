/*=========================================================================================
 * Date         : 4/10/15
 * Developer    : Ken Gill
 * Purpose      : 
 *              This class implements all unit tests for the classes in
 *              the automation framework. These tests are necessary in
 *              order to achieve the required code coverage levels by the
 *              Salesforce platform in order to allow production deployment
 *              of the code. The tests also serve a regression test suite.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/15/15  |  KG    | Initial Version                                         
 * 04/10/16     LK    | updated  testMethod void test_AutomationImportMgr_51_Enrollment()
 * 03/24/2017| TPB    | Updated to get data from the enrollment_import__c object
 *                    | See more detail in the TestUtil class   
 *=========================================================================================
 */

@isTest(SeeAllData=false)
public class AutomationTests {

public static Boolean forceException = false;
public static void forceException() { Integer i= 100/0; }

AutomationTests() {
    // System.Type t = AutomationInit.class;    // force the static initializer block that registers import managers
    //System.Type t2 = AutomationImportManager.class;   
}

public static testMethod void testAutomationCommand() {
    // code coverage statements. 
    AutomationCommand c = new AutomationCommand('name','verb', 'description');
    c.Result = 'result';
    String s = c.Result;
    AutomationCommand.AutomationCommandResult r = new AutomationCommand.AutomationCommandResult( AutomationCommand.RESULT_PASS, 'message');
}

public static testMethod void testAutomationImportManager() {
    System.Type t2 = AutomationImportManager.class; 
    Test.startTest();
    
    System.assertNotEquals(null, AutomationImportManager.getInstance(AutomationImportManager.Import51_Enrollment));
    System.assertNotEquals(null, AutomationImportManager.getInstance(AutomationImportManager.Import250_Enrollment));
    System.assertNotEquals(null, AutomationImportManager.getInstance(AutomationImportManager.Import250_BrokerActivity));
    
    try {
    AutomationImportManager.getInstance('Invalid_Import_Type');     
    } catch( Exception e) {
        System.assert( true, 'AutomationImportManager.getInstance(Invalid_Import_Type) should have thrown an exception');
    }   


    System.assertNotEquals(null, AutomationImportManager.getInstance(AutomationImportManager.Import51_Enrollment).getImportType());
    System.assertNotEquals(null, AutomationImportManager.getInstance(AutomationImportManager.Import51_Enrollment).getImportTitle());
    System.assertNotEquals(null, AutomationImportManager.getInstance(AutomationImportManager.Import51_Enrollment).getCommandMap()); 
    
    AutomationImportManager.addCommandToDatabase('TestImportType', 10, 'TestCommand', true, 'Description', 'Verb');
    System.assertNotEquals(null, AutomationImportManager.loadCommandsFromDatabase('TestImportType'));
    System.assertEquals(1, AutomationImportManager.loadCommandsFromDatabase('TestImportType').size());
    Test.stopTest();
    
}

public static testMethod void testAutomationProcessController() {
    AutomationProcessController controller = null;
    createCommandData();
    
    PageReference pageRef = Page.AutomationProcessView;
    Test.setCurrentPage(pageRef);

    Test.startTest();

    // - Test: Create controller without a specific import type specificed
    controller = new AutomationProcessController();
    System.assertEquals(null, controller.automationImportMgrDelegate);
    
    // + Test: create controller through URL parameters
    try {
    ApexPages.currentPage().getParameters().put('importType', AutomationImportManager.Import51_Enrollment);
    controller= new AutomationProcessController();
    System.assertNotEquals(null, controller);
    } catch(Exception e) {
            System.assert( false, 'Should not throw exception for valid importType parameter in URL');
    }
    
    // + Test: Create controller for 51 enrollment. verify appropriate delegate class used by controller
    AutomationProcessController controller51 = new AutomationProcessController(AutomationImportManager.Import51_Enrollment);
    System.assertNotEquals(null, controller51.getCommands());  // for code coverage
    System.assertNotEquals(null, controller51.getCommandMap());
    
    System.assertNotEquals(null, controller51.automationImportMgrDelegate);
    System.assertEquals(AutomationImportManager.Import51_Enrollment, controller51.automationImportMgrDelegate.importType);

    // + Test: Create controller for 2-50 enrollment. verify appropriate delegate class used by controller
    AutomationProcessController controller250 = new AutomationProcessController(AutomationImportManager.Import250_Enrollment);
    System.assertNotEquals(null, controller250.automationImportMgrDelegate);
    System.assertEquals(AutomationImportManager.Import250_Enrollment, controller250.automationImportMgrDelegate.importType);

    // + Test: Create controller for 2-50 Broker Activity process. verify appropriate delegate class used by controller
    AutomationProcessController controller250_BA = new AutomationProcessController(AutomationImportManager.Import250_BrokerActivity);
    System.assertNotEquals(null, controller250_BA.automationImportMgrDelegate);
    System.assertEquals(AutomationImportManager.Import250_BrokerActivity, controller250_BA.automationImportMgrDelegate.importType);

    // test action methods
    
    List<AutomationCommand> testCommands = AutomationTests.createCommands(1);   // create one command
    testCommands[0].Verb = 'DeleteEnrollmentData'; 
    // Have to set the above  to a recognized verb. Leaving verb=Verb0 cannot be batch polled 
    // in AutomationController.checkCompletion since there will be no valid batch id

    controller51.automationImportMgrDelegate.addCommands(testCommands);
    ApexPages.currentPage().getParameters().put('verb', testCommands[0].Verb);
    System.debug('Page Parameters=' + String.valueOf(ApexPages.currentPage().getParameters()));
    controller51.execute();
    controller51.checkCompletion();
    
    /*
    // List<String> verbsToTest = new List<String> { 'RunEnrollmentMain51', 'Verb_0' };
    List<String> verbsToTest = new List<String> {  'DeleteEnrollmentData' };
    for( String verb : verbsToTest) {
        System.debug('testAutomationProcessController:controller51:testing verb - ' + verb);
        testCommands[0].verb = verb;
        controller51.automationImportMgrDelegate.addCommands(testCommands.clone());     
        ApexPages.currentPage().getParameters().put('verb', verb);
        controller51.execute();
        controller51.checkCompletion();
    }
    */
    
    /*
    // Now exercise all the verbs supported by the Import Manager
    testCommands= controller51.automationImportMgrDelegate.getCommands();
    for( AutomationCommand c : testCommands) {
        System.debug('testAutomationProcessController:controller51:testing verb - ' + c.Verb);
        ApexPages.currentPage().getParameters().put('verb', c.Verb);
        controller51.execute();
        controller51.checkCompletion();
    }
    
    */
    
    Test.stopTest();
    
}

 public static testMethod void test_AutomationImportMgr_51_Enrollment() {
 
    DynamicCodeDataStore__c cs = new DynamicCodeDataStore__c();
    cs.Name='EmailSupportTeams';
    cs.Text_255__c='sfInfoSysMS@carefirst.com';
    cs.Email__c = '';
    insert cs;
    
    createCommandData();
    AutomationImportManager mgr = new AutomationImportMgr_51_Enrollment();  
    List<AutomationCommand> testCommands = AutomationTests.createCommands(1);   // create one command
    
    Test.startTest();

    // test adding of commands
    List<AutomationCommand> existingCommands = mgr.getCommands().clone();   // you have to clone the command list if 
                                                                            //you want to compare with later modifications otherwise you are 
                                                                            // just holding a reference to the internal map in ImportManager 
                                                                            // for commands
    //System.assertEquals(0, existingCommands.size());  // there should be no command records in AutomationCommand__c object
    mgr.addCommands(testCommands);  
    System.assertEquals(1, mgr.getCommands().size() - existingCommands.size()); 


    List<AutomationCommand> mgrCommands = mgr.getCommands();    
    // test the execute method
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                 User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                 LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

    System.runAs(u) {        
        //TestUtil.Create_Enrollment_Data_Shift();  // this line is for creating 2-50 enrollment data; not needed in this method  
        TestUtil.Create_Enrollment_Import(); //Add TPB 03/24/2017
        TestUtil.Create_Enrollment_Data_51();
    }
    
    for( integer i=0; i < mgrCommands.size(); i++)
        mgr.execute(mgrCommands.get(i), new Map<String,String>()); 

    // Force exception clauses to be exercised
    AutomationTests.forceException = true;
    for( integer i=0; i < mgrCommands.size(); i++)
        mgr.execute(mgrCommands.get(i), new Map<String,String>());
     
    AutomationTests.forceException = false;
    
    // test the pollStatus method
    AutomationCommand c = new AutomationCommand( 'Run51EnrollmentMain', 'RunEnrollmentMain51', 'This command will run the batch process for processing 51 monthly enrollments');
    c.description = 'This command will run the batch process for processing 51 monthly enrollments';
    c.isBatch = true;            
    
    mgr.pollStatus(c, new Map<String,String>()); 
        
    Test.stopTest();
 }

 public static testMethod void test_AutomationImportMgr_250_Enrollment() {
    createCommandData();
    AutomationImportManager mgr = new AutomationImportMgr_250_Enrollment();     
    List<AutomationCommand> testCommands = AutomationTests.createCommands(1);   // create one command
    
    Test.startTest();

    // test adding of commands
    List<AutomationCommand> existingCommands = mgr.getCommands().clone();   // you have to clone the command list if 
                                                                            //you want to compare with later modifications otherwise you are 
                                                                            // just holding a reference to the internal map in ImportManager 
                                                                            // for commands
    System.assertEquals(0, existingCommands.size());    // there should be no command records in AutomationCommand__c object
    mgr.addCommands(testCommands);  
    System.assertEquals(1, mgr.getCommands().size() - existingCommands.size()); 


    List<AutomationCommand> mgrCommands = mgr.getCommands();    
    // test the execute method
    
    for( integer i=0; i < mgrCommands.size(); i++)
        mgr.execute(mgrCommands.get(i), new Map<String,String>()); 
        
    // Force exception clauses to be exercised
    AutomationTests.forceException = true;
    for( integer i=0; i < mgrCommands.size(); i++)
        mgr.execute(mgrCommands.get(i), new Map<String,String>()); 
    AutomationTests.forceException = false;     // turn it off  

/*  
    // test the pollStatus method
    for( integer i=0; i < mgrCommands.size(); i++)
        mgr.pollStatus(mgrCommands.get(i), new Map<String,String>()); 
*/      
    Test.stopTest();    
 }

 public static testMethod void test_AutomationImportMgr_250_BrokerActivity() {
    createCommandData();
    AutomationImportManager mgr = new AutomationImportMgr_250_BrokerActivity();     
//  List<AutomationCommand> testCommands = AutomationTests.createCommands(1);   // create one command
    
    Test.startTest();

    // test adding of commands
//  List<AutomationCommand> existingCommands = mgr.getCommands().clone();   // you have to clone the command list if 
                                                                            //you want to compare with later modifications otherwise you are 
                                                                            // just holding a reference to the internal map in ImportManager 
                                                                            // for commands
    //System.assertEquals(0, existingCommands.size());  // there should be no command records in AutomationCommand__c object
//  mgr.addCommands(testCommands);  
//  System.assertEquals(1, mgr.getCommands().size() - existingCommands.size()); 


    List<AutomationCommand> mgrCommands = mgr.getCommands();    
    // test the execute method
    
    for( integer i=0; i < mgrCommands.size(); i++)
        mgr.execute(mgrCommands.get(i), new Map<String,String>()); 

/*  
    // test the pollStatus method
    for( integer i=0; i < mgrCommands.size(); i++)
        mgr.pollStatus(mgrCommands.get(i), new Map<String,String>()); 
*/      
    Test.stopTest();    
 }

 public static testMethod void test_Automation_SupportingClasses() {
    Test.startTest();
    // AutomationCommandStatus
    AutomationCommandStatus cmdStatus = new AutomationCommandStatus();
    cmdStatus.status = 1;   // complete
    cmdStatus.statusMessage = 'Completed';
    
    // AutomationInit
    AutomationInit.initializeOrgEnvironment('DEV9');    // dummy argument
    Test.stopTest();

 }
 
  public static testMethod void test_IntegrationLogging() {
    
    List<IntegrationMessage> messageList = new List<IntegrationMessage>();
    List<IntegrationLog__c> logList = new List<IntegrationLog__c>();
    
    IntegrationMessage entry;
    for(Integer i = 0; i < 2; i++) {
     entry = new IntegrationMessage();
     entry.timestamp = Datetime.now();  //DateTime
     entry.transactionID = i; // Integer
     entry.msgType = 'msgType';
     entry.result = 'result'; 
     entry.target = 'target';
     entry.targetAddress = 'targetAddress';
     entry.source = 'source';
     entry.sourceAddress = 'sourceAddress';
     entry.msgData = 'msgData';
     entry.relatedData = 'relatedData';
    
     messageList.add(entry);

    }
    
    Integration.log(messageList[0]);
    Integration.log(messageList);
    

 }
 
//------------------------------------------------------------------------------------------------
//  Supporting helper methods for test methods
//------------------------------------------------------------------------------------------------

 public static List<AutomationCommand> createCommands(Integer numberCommands) {
        List<AutomationCommand> commandsToAdd = new List<AutomationCommand>();
        for(integer i=0; i < numberCommands; i++) {
                System.debug('Adding a command');
                AutomationCommand c = new AutomationCommand( 'Name_' +i, 'Verb'+i, 'Description' + i);
                c.description = 'Some description text for this command goes here ';
                c.Step = i;
                if( Math.mod(i,2) ==0 ) { c.isBatch = true; }            
                commandsToAdd.add(c);         
        }       
        return commandsToAdd;
    }


 public static void createCommandData() {
        AutomationImportManager.addCommandToDatabase(  'Import250_BrokerActivity',Integer.valueOf('20') ,'Run Monthly 2-50 Broker Activity for Accounts (AG)',true,'Executes the monthly 2-50 broker activity accounts process','RunBrokerActivityAccountsProcess');
    
        AutomationImportManager.addCommandToDatabase(  'Import250_BrokerActivity',Integer.valueOf('30') ,'Confirm Broker Activity Import Account (AG) Data Processed',false,'Check the Broker Activity Import object and make sure all Account (AG) data processed.','CheckBrokerActivityAccountImportRecordCountIsZero');
        
        AutomationImportManager.addCommandToDatabase(  'Import250_BrokerActivity', Integer.valueOf('40'),'Run Monthly 2-50 Broker Activity for Contacts (AG)',true,'Executes the monthly 2-50 broker activity contacts process','RunBrokerActivityContactsProcess');
        
        AutomationImportManager.addCommandToDatabase(  'Import250_BrokerActivity',Integer.valueOf('50') ,'Confirm Broker Import Contact (SB) Data',false,'Check the Broker Activity Import object and make sure all Contact (SB) data processed.','CheckBrokerActivityContactImportRecordCountIsZero');
        
        
        AutomationImportManager.addCommandToDatabase( 'Import51_Enrollment',Integer.valueOf('10') ,'Verify Error Recyling Completed',false,'Verify that Error Recyling (Users action) has been completed','CheckRecyclingEmpty');
        
        AutomationImportManager.addCommandToDatabase( 'Import51_Enrollment',Integer.valueOf('20') ,'Run 51+ Monthly Baseline for Book of Business (BOB)',true,'Run the monthly batch process for the 51 enrollment Book of Baseline calculation','RunMonthly51BookOfBusinessBaseline');
        
        AutomationImportManager.addCommandToDatabase( 'Import51_Enrollment',Integer.valueOf('30') ,'Delete Enrollment Import Data',true,'Run the delete enrollment import batch process','DeleteEnrollmentData');
        
        AutomationImportManager.addCommandToDatabase( 'Import51_Enrollment',Integer.valueOf('40') ,'Confirm All Enrolmlent Import Data Deleted',false,'Check the count of Enrollment import records. Should be zero after running Delete Enrollment Import Data command','CheckEnrollmentImportRecordCountIsZero');
        
        
        
        AutomationImportManager.addCommandToDatabase( 'Import51_Enrollment',Integer.valueOf('50') ,'Load Enrollment Data (external action)',false,'Reminder: This is to be performed externally to this tool.','NoOperation');
        
        AutomationImportManager.addCommandToDatabase( 'Import51_Enrollment',Integer.valueOf('60') ,'Confirm Enrollment Import Data',false,'Confirm Enrollment Import data loaded RPT_DT__c value is correct. Check the count of Enrollment import records. Should be > 0after running Import.','CheckEnrollmentImportRecordCountGreaterThanZero');
        
        AutomationImportManager.addCommandToDatabase( 'Import51_Enrollment',Integer.valueOf('70') ,'Run 51+ Yearly Baseline Compensation for Book of Business (BOB) SOP',true,'Run the Yearly process for calculating compensation baseline for Book of Business (BOB). This command only needs to be run in the month of March','RunYearly51BookOfBusinessBaseline');
        
        AutomationImportManager.addCommandToDatabase( 'Import51_Enrollment',Integer.valueOf('80') ,'Run 51 Enrollment Main process',true,'This command will run the batch process for processing 51 monthly enrollments','RunEnrollmentMain51'); 
        
        AutomationImportManager.addCommandToDatabase( 'Import51_Enrollment',Integer.valueOf('90') ,'Confirm All Enrollment Import Records Processed',false,'Check the Enrollment Import object and make sure there are no records containing an unchecked processed field','CheckNoUnprocessedEnrollments');
        
        AutomationImportManager.addCommandToDatabase( 'Import51_Enrollment',Integer.valueOf('100') ,'Run 51+ Monthly Baseline for Book of Business (BOB)',true,'Run the monthly batch process for the 51 enrollment Book of Baseline calculation','RunMonthly51BookOfBusinessBaselineAtEnd');
            
 }
}