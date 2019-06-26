/*============================================================================================
 * Date         : 4/10/15
 * Developer    : Ken Gill
 * Purpose      : 
 *              This is a sub-class of AutomationImportManager and
 *              implements the commands related to the monthly 2-50
 *              Broker Activity SOP. It provides an implementation
 *              of the abstract execute() method from the base class
 *              AutomationImportManager.
 *
 *============================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+===================================================================
 * 10/15/15  |  KG    | Initial Version                                         
 * 05/23/15  |  TPB   | Updating to hold the command routines for the BrokerActivity Processes
 *============================================================================================
 */

public class AutomationImportMgr_250_BrokerActivity extends AutomationImportManager {

  //  public class AutomationImportMgr_250_BrokerActivityException extends Exception{}


/*************************************************************************************
 * Purpose   : Constructor. Loads the 250 Broker Activity SOP commands from the database
 *             The importSOPResourceFileName is the name of the static resource that contains the
 *             SOP Word document for online reference and is displayed in the AutomationProcessView page
 * 
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
  
  public AutomationImportMgr_250_BrokerActivity() {
        super();
        importType = AutomationImportManager.Import250_BrokerActivity;
        importTitle = '2-50 Monthly Broker Activity Import';
        importSOPResourceFileName = 'SOP_250_BrokerActivityImport';        
        addCommands(AutomationImportManager.loadCommandsFromDatabase(importType));
    }   
    
/*************************************************************************************
 * Purpose   : This is an implementation of the abstract base class method declaration. It
 *             is intended to handle all the automation commands for the 250 Broker Activity SOP.
 *             The appropriate commmand is selected by comparing the input command verb with 
 *             a matching if clause and when found the code in the matching block is executed.
 *             This implementation also supports a 'NOP' (no operation) command verb.
 *
 *             NOTE:
 *             A new handler if() clause should be added to this method anytime a new automation 
 *             command is added to this SOP. 
 *             In addition, a new test case(s) should be added to the AutomationTests class for each  new
 *             command that will provide code coverage for the related new if() command handling block added.
 *             
 * Parameters: AutomationCommand command - the command to be executed
 *             Map<String,String> parameters - any additional parameters that are needed to execute the command
 *
 * Return    : AutomationCommand.AutomationCommandResult - this represents a success/fail boolean result as well as
 *             a result message string fields encapsulated in an object. This is used by the controler to update status
 *             on screen to the user
 *************************************************************************************/
    
    public override AutomationCommand.AutomationCommandResult execute(AutomationCommand command, Map<String,String> parameters) {        
        System.debug('AutomationImportMgr_250_BrokerActivity.execute() called');
        System.debug('Handling input verb=' +command.verb + ' ,parameters= ' + parameters);
        
        AutomationCommand.AutomationCommandResult r= new AutomationCommand.AutomationCommandResult();
        String verb = command.verb;
        command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;
         
        r.result = AutomationCommand.RESULT_SUCCESS;
        r.resultMessage = 'Default success message';

        // ------------------------------------------------------------------------
        // INSERT NEW COMMAND verb handler calls below with a new if(verb ==) {} clause
        // ------------------------------------------------------------------------
                
        if( verb == 'NoOperation') {
            handle_NoOperation(command, r);
        } else if ( verb == 'CheckBrokerActivityImportRecordCountIsZero' ) {
            handle_CheckBrokerActivityImportRecordCountIsZero(command, r);
        } else if ( verb == 'RunBrokerActivityAccountsProcess') {
            handle_RunBrokerActivityAccountsProcess(command, r);
        } else if ( verb == 'CheckBrokerActivityAccountImportRecordCountIsZero' ) {
            handle_CheckBrokerActivityAccountImportRecordCountIsZero(command, r);
        } else if ( verb == 'RunBrokerActivityContactsProcess' ) {
          handle_RunBrokerActivityContactsProcess(command, r);  
        } else if ( verb == 'CheckBrokerActivityContactImportRecordCountIsZero' ) {
            handle_CheckBrokerActivityContactImportRecordCountIsZero(command, r);          
        } else {   
            String errMsg = 'AutomationImportMgr_250_BrokerActivity.execute()::Unrecognized input verb=' +command.verb + ' ,parameters= ' + parameters;   
            System.debug(errMsg); // log; do nothing   
            throw new AutomationCommand.AutomationException('The coded verb does not match the data on the AutomationCommand table or the command that was selected is not correct or coded at all.   '  + errMsg);     
        }        
        return r;
    }
    
    
    // -----------------------------
    // Handler Methods Start Here...
    // -----------------------------

    public void handle_CheckBrokerActivityImportRecordCountIsZero(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
         System.debug(command.verb + ' command execute');
    
        try {
          if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();    
          // implementation           
          AggregateResult[] results = [ SELECT count(Id) FROM Broker_Import_2_50__c WHERE Processed__c = true];
          Integer counter = (Integer) results[0].get('expr0');
          
          r.result = counter == 0 ? AutomationCommand.RESULT_PASS : AutomationCommand.RESULT_FAIL;
          r.resultMessage = counter + ' There should be zero Broker Activity Import Records (SB, AG, FSP, and GP) Processed!';        
          command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;          
        } catch( Exception e) {
          command.Status = AutomationCommand.COMPLETE;      
          r.result = AutomationCommand.RESULT_ERROR;
          r.resultMessage = 'Error: ' + e.getMessage();       
        }
    }       
    
    
    public void handle_RunBrokerActivityAccountsProcess(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
        System.debug(command.verb + ' command execute');  
        try {
            if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();    
            // implementation 
            BrokerActivityAccountsProcess bap = new BrokerActivityAccountsProcess(NULL);
            command.batchId = Database.executeBatch(bap); 
               
            System.debug(command.batchId);
                  
            r.result = AutomationCommand.RESULT_SUCCESS;
            r.resultMessage = 'Started batch execution of RunBrokerActivityAccountsProcess';                          
            command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;      
        } catch( Exception e) {
            command.Status = AutomationCommand.COMPLETE;      
            r.result = AutomationCommand.RESULT_ERROR;
            r.resultMessage = 'Error: ' + e.getMessage();       
        }  
    }  
    
 
    public void handle_CheckBrokerActivityAccountImportRecordCountIsZero(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
         System.debug(command.verb + ' command execute');
    
        try {
          if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();    
          // implementation           
          AggregateResult[] results = [ SELECT count(Id) FROM Broker_Import_2_50__c WHERE Entity_Type__c IN('AG', 'FSP', 'GP') AND Processed__c = false];
          Integer counter = (Integer) results[0].get('expr0');
          
          r.result = counter == 0 ? AutomationCommand.RESULT_PASS : AutomationCommand.RESULT_FAIL;
          r.resultMessage = counter + ' There should be zero Broker Activity Import Account (AG, FSP, and GP) Records Not Processed!';        
          command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;          
        } catch( Exception e) {
          command.Status = AutomationCommand.COMPLETE;      
          r.result = AutomationCommand.RESULT_ERROR;
          r.resultMessage = 'Error: ' + e.getMessage();       
        }
    }      
            

    public void handle_RunBrokerActivityContactsProcess(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
        System.debug(command.verb + ' command execute');  
        try {
            if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();    
            // implementation 
            BrokerActivityContactsProcess bap = new BrokerActivityContactsProcess(NULL);
            command.batchId = Database.executeBatch(bap); 
               
            System.debug(command.batchId);
                  
            r.result = AutomationCommand.RESULT_SUCCESS;
            r.resultMessage = 'Started batch execution of RunBrokerActivityContactsProcess';                          
            command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;      
        } catch( Exception e) {
            command.Status = AutomationCommand.COMPLETE;      
            r.result = AutomationCommand.RESULT_ERROR;
            r.resultMessage = 'Error: ' + e.getMessage();       
        }  
    } 
 

    public void handle_CheckBrokerActivityContactImportRecordCountIsZero(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
         System.debug(command.verb + ' command execute');
    
        try {
          if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();    
          // implementation           
          AggregateResult[] results = [ SELECT count(Id) FROM Broker_Import_2_50__c WHERE Entity_Type__c = 'SB' AND Processed__c = false];
          Integer counter = (Integer) results[0].get('expr0');
          
          r.result = counter == 0 ? AutomationCommand.RESULT_PASS : AutomationCommand.RESULT_FAIL;
          r.resultMessage = counter + ' There should be zero Broker Activity Import Contacts (SB) Records Not Processed!';        
          command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;          
        } catch( Exception e) {
          command.Status = AutomationCommand.COMPLETE;      
          r.result = AutomationCommand.RESULT_ERROR;
          r.resultMessage = 'Error: ' + e.getMessage();       
        }
    }      
    
          
}