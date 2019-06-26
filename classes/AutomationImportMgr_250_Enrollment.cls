/*=========================================================================================
 * Date			: 4/10/15
 * Developer	: Ken Gill
 * Purpose   	: 
 *              This is a sub-class of AutomationImportManager and
 *              implements the commands related to the monthly 2-50
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

public class AutomationImportMgr_250_Enrollment extends AutomationImportManager {
  
/*************************************************************************************
 * Purpose   : Constructor. Loads the Enrollment 51 SOP commands from the database
 *             The importSOPResourceFileName is the name of the static resource that contains the
 *             SOP Word document for online reference and is displayed in the AutomationProcessView page
 * 
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
   
	public AutomationImportMgr_250_Enrollment() {
	    super();
	    importType = AutomationImportManager.Import250_Enrollment;
	    importTitle = '2-50 Monthly Enrollment Import';     
        importSOPResourceFileName = 'SOP_250_Enrollments'; 	   
        addCommands(AutomationImportManager.loadCommandsFromDatabase(importType));
	}   

/*************************************************************************************
 * Purpose   : This is an implementation of the abstract base class method declaration. It
 *             is intended to handle all the automation commands for the 250 Enrollment SOP.
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
        System.debug('AutomationImportMgr_250_Enrollment.execute() called');
        System.debug('Handling input verb=' +command.verb + ' ,parameters= ' + parameters);
        
		AutomationCommand.AutomationCommandResult r= new AutomationCommand.AutomationCommandResult();
        String verb = command.verb;
	    command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;
	     
	    r.result = AutomationCommand.RESULT_SUCCESS;
	    r.resultMessage = 'Default success message';

		// ------------------------------------------------------------------------
		// INSERT NEW COMMAND verb handlers below with a new if(verb ==) {} clause
		// ------------------------------------------------------------------------
			    	    
        if( verb == 'NoOperation') {
        	handle_NoOperation(command, r);
   	    } else {
	    	// do nothing
	    	
	    }

        return r;
    }
         
}