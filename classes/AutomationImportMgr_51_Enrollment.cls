/*=========================================================================================
 * Date			: 4/10/15
 * Developer	: Ken Gill
 * Purpose   	: 
 *              This is a sub-class of AutomationImportManager and
 *              implements the commands related to the monthly 51+
 *              Enrollment Activity SOP. It provides an implementation
 *              of the abstract execute() method from the base class
 *              AutomationImportManager.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/15/15  |  KG    |	Initial Version                                         
 *   	     |        | 
 *=========================================================================================
 */

public class AutomationImportMgr_51_Enrollment extends AutomationImportManager {

  
/*************************************************************************************
 * Purpose   : Constructor. Loads the Enrollment 51 SOP commands from the database
 *             The importSOPResourceFileName is the name of the static resource that contains the
 *             SOP Word document for online reference and is displayed in the AutomationProcessView page
 * 
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
  
  public AutomationImportMgr_51_Enrollment() {
        super();
        importType = AutomationImportManager.Import51_Enrollment;
        importTitle = '51+ Monthly Enrollment Import'; 
        importSOPResourceFileName = 'SOP_51_Enrollments'; 	   
        addCommands(AutomationImportManager.loadCommandsFromDatabase(importType));
  }


/*************************************************************************************
 * Purpose   : This is an implementation of the abstract base class method declaration. It
 *             is intended to handle all the automation commands for the 51 Enrollment SOP.
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
        System.debug('AutomationImportMgr_51_Enrollment.execute()::input verb=' +command.verb + ' ,parameters= ' + parameters);
	    
		AutomationCommand.AutomationCommandResult r= new AutomationCommand.AutomationCommandResult();
	    String verb = command.verb;
	    command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;
	     
	    r.result = AutomationCommand.RESULT_SUCCESS;
	    r.resultMessage = 'Default success message';

		// ------------------------------------------------------------------------
		// INSERT NEW COMMAND verb handlers below with a new if(verb ==) {} clause
		// ------------------------------------------------------------------------

        if( verb == 'CheckRecyclingEmpty') {
        	handle_CheckRecyclingEmpty(command, r); 
        	
        } else if( verb == 'RunMonthly51BookOfBusinessBaseline') {
        	handle_RunMonthly51BookOfBusinessBaseline(command, r);
        	
        } else if( verb == 'RunMonthly51BookOfBusinessBaselineAtEnd') {
        		// this clause is needed because the verb has to be unique
        		// even though the same handler handles this and previous verb
        		// 'RunMonthly51BookOfBusinessBaseline' and 'RunMonthly51BookOfBusinessBaselineAtEnd'
        	handle_RunMonthly51BookOfBusinessBaseline(command, r);
        	
        } else if( verb == 'RunYearly51BookOfBusinessBaseline') {
        	handle_RunYearly51BookOfBusinessBaseline(command, r);
        	
        } else if( verb == 'CheckNoUnprocessedEnrollments') {
        	handle_CheckNoUnprocessedEnrollments(command, r);
        	
        } else if( verb == 'DeleteEnrollmentData') {        	
        	handle_DeleteEnrollmentData(command, r);
        	
        } else if( verb == 'CheckEnrollmentImportRecordCountIsZero') {
        	handle_CheckEnrollmentImportRecordCountIsZero(command, r);
        	
        } else if( verb == 'CheckEnrollmentImportRecordCountGreaterThanZero') {
        	handle_CheckEnrollmentImportRecordCountGreaterThanZero(command, r);
        	
        } else if( verb == 'RunEnrollmentMain51') {
        	handle_RunEnrollmentMain51(command, r);
 
        } else if( verb == 'NoOperation') {
        	handle_NoOperation(command, r);
        
   	    } else {
	    	System.debug('AutomationImportMgr_51_Enrollment.execute()::Unrecognized input verb=' +command.verb + ' ,parameters= ' + parameters); // log; do nothing
	    }
	    
	    return r;
    }
    
    //------ Individual verb handling helper functions -------------------//
      
	public void handle_CheckRecyclingEmpty(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
       	System.debug(command.verb + ' command execute');
		
		try {
			if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();		
			// implementation        				
			AggregateResult[] results = [ SELECT count(Id) FROM Enrollment_Recycle__c];
			Integer counter = (Integer) results[0].get('expr0');
			System.debug('Got count value = ' + counter);
			r.result = counter == 0 ? AutomationCommand.RESULT_PASS : AutomationCommand.RESULT_FAIL;
			r.resultMessage = 'Enrollment_Recycle__c ' + ( counter == 0 ? 'is Empty' : 'has ' + counter + ' records'); 		
			command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;			
		} catch( Exception e) {
			command.Status = AutomationCommand.COMPLETE;			
			r.result = AutomationCommand.RESULT_FAIL;
			r.resultMessage = 'Error: ' + e.getMessage(); 			
		}
	
	}

	public void handle_RunMonthly51BookOfBusinessBaseline(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
       	System.debug(command.verb + ' command execute');	
		try {
			if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();		
			// implementation 
			Enrollment_BaselineUpdateBatch job = new Enrollment_BaselineUpdateBatch( Enrollment_BaselineUpdateBatch.BatchType_51_Plus);
			command.batchId  = Database.executeBatch(job);
			System.debug(command.batchId);
			
			r.result = AutomationCommand.RESULT_RUNNING;
			r.resultMessage = 'Started batch execution of RunMonthly51BookOfBusinessBaseline';			       				 		
			command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;			
		} catch( Exception e) {
			command.Status = AutomationCommand.COMPLETE;			
			r.result = AutomationCommand.RESULT_FAIL;
			r.resultMessage = 'Exception: ' + e.getMessage(); 			
		}	
	}
	
	public void handle_RunYearly51BookOfBusinessBaseline(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
       	System.debug(command.verb + ' command execute');	
		try {
			if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();		
			// implementation 
			Integer currentMonth = Date.today().month();
			if(Test.isRunningTest()) currentMonth = 3; 	// force it to 3 months if unit testing to get coverage
			
			if( currentMonth == 3) {	// Only run if current month is March
				Enrollment_BaselineYearlyShiftBatch job = new Enrollment_BaselineYearlyShiftBatch( Enrollment_BaselineUpdateBatch.BatchType_51_Plus);
				command.batchId  = Database.executeBatch(job);
				System.debug(command.batchId);
				
				r.result = AutomationCommand.RESULT_RUNNING;
				r.resultMessage = 'Started batch execution of RunMonthly51BookOfBusinessBaseline';			       				 		
				command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;
			} else {
				r.result = AutomationCommand.RESULT_PASS;
				r.resultMessage = command.Name + ': This only has to be run in March each year. No batch process executed';			       				 		
				command.Status = AutomationCommand.COMPLETE;				
			}			
		} catch( Exception e) {
			command.Status = AutomationCommand.COMPLETE;			
			r.result = AutomationCommand.RESULT_FAIL;
			r.resultMessage = 'Exception: ' + e.getMessage(); 			
		}	
	}	
	
	public void handle_CheckNoUnprocessedEnrollments(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
       	System.debug(command.verb + ' command execute');
		
		try {
			if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();		
			// implementation       				
			Integer unProcessedCount = 0; // insert DML here
			AggregateResult[] results = [ SELECT count(Id) FROM Enrollment_Import__c WHERE Processed__c = False];
			Integer counter = (Integer) results[0].get('expr0');
			
			r.result = counter == 0 ? AutomationCommand.RESULT_PASS : AutomationCommand.RESULT_FAIL;
			r.resultMessage = counter + ' Unprocessed enrollments for 51+';				
			command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;					
		} catch( Exception e) {
			command.Status = AutomationCommand.COMPLETE;			
			r.result = AutomationCommand.RESULT_FAIL;
			r.resultMessage = 'Error: ' + e.getMessage(); 			
		}
}

	public void handle_CheckEnrollmentImportRecordCountIsZero(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
       	System.debug(command.verb + ' command execute');
		
		try {
			if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();		
			// implementation        				
			Integer unProcessedCount = 0; // insert DML here
			Date d = Date.today().addMonths(-1);
			Datetime dt = datetime.newInstance( d.year(), d.month(),d.day());
			String RptDateString = dt.format('YYYYMM');
			
			
			AggregateResult[] results = [ SELECT count(Id) FROM Enrollment_Import__c WHERE Processed__c = False AND Rpt_Dt__c = :RptDateString];
			Integer counter = (Integer) results[0].get('expr0');
			
			r.result = counter == 0 ? AutomationCommand.RESULT_PASS : AutomationCommand.RESULT_FAIL;
			r.resultMessage = counter + ' Unprocessed enrollments for 51+';				
			command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;					
		} catch( Exception e) {
			command.Status = AutomationCommand.COMPLETE;			
			r.result = AutomationCommand.RESULT_FAIL;
			r.resultMessage = 'Error: ' + e.getMessage(); 			
		}
}

	public void handle_CheckEnrollmentImportRecordCountGreaterThanZero(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
       	System.debug(command.verb + ' command execute');
		
		try {
			if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();		
			// implementation       				
			Integer unProcessedCount = 0; // insert DML here
			Date d = Date.today().addMonths(-1);
			Datetime dt = datetime.newInstance( d.year(), d.month(),d.day());
			String RptDateString = dt.format('YYYYMM');			
			
			AggregateResult[] results = [ SELECT count(Id) FROM Enrollment_Import__c WHERE Processed__c = False AND Rpt_Dt__c = :RptDateString];
			Integer counter = (Integer) results[0].get('expr0');
			
			r.result = counter > 0 ? AutomationCommand.RESULT_PASS : AutomationCommand.RESULT_FAIL;
			r.resultMessage = counter + ' Unprocessed enrollments for 51+';				
			command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;					
		} catch( Exception e) {
			command.Status = AutomationCommand.COMPLETE;			
			r.result = AutomationCommand.RESULT_FAIL;
			r.resultMessage = 'Error: ' + e.getMessage(); 			
		}
}

	public void handle_DeleteEnrollmentData(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
       	System.debug(command.verb + ' command execute');	
		try {
			if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();		
			// implementation 
			Enrollment_DeleteData d = new Enrollment_DeleteData();
			d.query = 'SELECT Id FROM Enrollment_Import__c';
			command.batchId  = Database.executeBatch(d);			
			System.debug(command.batchId);
			
			r.result = AutomationCommand.RESULT_RUNNING;	
			r.resultMessage = 'Started batch execution of DeleteEnrollmentData';			       				 		
			command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;			
		} catch( Exception e) {
			command.Status = AutomationCommand.COMPLETE;			
			r.result = AutomationCommand.RESULT_FAIL;
			r.resultMessage = 'Error: ' + e.getMessage(); 			
		}	
	}

/*
	public void handle_CheckEnrollmentImportRecordCount(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
       	System.debug(command.verb + ' command execute');
		
		try {
			if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();		
			// implementation        				
			AggregateResult[] results = [ SELECT count(Id) FROM Enrollment_Import__c];
			Integer counter = (Integer) results[0].get('expr0');
			System.debug('Got count value = ' + counter);
			r.result = AutomationCommand.RESULT_PASS;
			r.resultMessage = 'Enrollment_Import__c ' + ( counter == 0 ? 'is Empty' : 'has ' + counter + ' records'); 		
			command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;			
		} catch( Exception e) {
			command.Status = AutomationCommand.COMPLETE;			
			r.result = AutomationCommand.RESULT_ERROR;
			r.resultMessage = 'Error: ' + e.getMessage(); 			
		}
	
	}
*/
	        
	public void handle_RunEnrollmentMain51(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
       	System.debug(command.verb + ' command execute');	
		try {
			if( Test.isRunningTest() && AutomationTests.forceException) AutomationTests.forceException();		
			// implementation 
        	Enrollment_MainProcess epm = new Enrollment_MainProcess();
			epm.EmailUsers = TRUE;
			epm.query = 'SELECT id, Rpt_Dt__c, Run_Dt__c, Account_Name__c, Account_Number__c, SFDC_Product__c, Contracts__c, System__c, Sales_Rep__c, Risk__c, Processed_Type__C, Rating_State__c, New_Business_Indicator__c FROM Enrollment_Import__c WHERE Processed__c = FALSE';
			command.batchId  = Database.executeBatch(epm, 100);			
			System.debug(command.batchId);
			
			r.result = AutomationCommand.RESULT_RUNNING;
			r.resultMessage = 'Started batch execution of RunEnrollmentMain51';			       				 		
			command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;			
		} catch( Exception e) {
			command.Status = AutomationCommand.COMPLETE;			
			r.result = AutomationCommand.RESULT_FAIL;
			r.resultMessage = 'Error: ' + e.getMessage(); 			
		}	
	}
	         
  }