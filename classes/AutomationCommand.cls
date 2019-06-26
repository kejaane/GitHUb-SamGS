/*=========================================================================================
 * Date			: 4/10/15
 * Developer	: Ken Gill
 * Purpose   	:  
 *                This class represent a single command that is implemented
 *                in the automation framework and the supporting
 *                attributes. This includes the command name, verb,
 *                description,  SOP step number and result fields. It also
 *                declares a common AutomationException class that is used by
 *                the framework to raise irrecoverable error conditions to
 *                the calling code. It also includes constants to represent
 *                a command result (Pass, Fail) and command status (Ready,
 *                Running and Complete).
 *
 *				  The inner class AutomationCommandResult represents the result 
 *				  of executing an AutomationCommand and is modelled as an inner 
 *				  class of AutomationCommand since the two are intimately related.
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/15/15  |  KG    |	Initial Version                                         
 *   	     |        | 
 *=========================================================================================
 */
public class AutomationCommand {
		public class AutomationException extends Exception {}
			
		// This inner class is used to capture the result of a command execution and 
		// uses 2 attributes - a boolean result status (Success/Error) and a String result 
		// message to provide descriptive text feedback
		public with sharing class AutomationCommandResult {
			
			// This represents the result of the auomation check performed. It does not mean the result of command execution
			// i.e. whether the command completed succesfully or not 
			public String result {get; set;}	
			public String   resultMessage {get; set;}

			
			public AutomationCommandResult() {
				result = AutomationCommand.RESULT_ERROR; 	// default if result not explicity set
				resultMessage = ' ';
			}
			public AutomationCommandResult(String result, String resultMessage) {
				this.result = result;
				this.resultMessage = resultMessage;
			}
		}
		
		public enum STATE { READY, RUNNING, COMPLETE }
    	public static String READY = 'Ready';
        public static String RUNNING = 'Running';
        public static String COMPLETE = 'Complete';
     
     	public static Boolean SUCCESS = True;
     	public static Boolean ERROR = False;
     	public static String RESULT_SUCCESS = 'Success'; // deprecated
     	public static String RESULT_PASS='Pass';		// command runs successfuly
     	public static String RESULT_FAIL='Fail';		// command runs with error result
     	public static String RESULT_RUNNING='Running';  // command has started
     	public static String RESULT_ERROR = 'Error';	// meant for internal exceptions
     	
        public Integer Step {get;set;}		// This corresponds to a step in the SOP procedure document and is used to render onscreen
        public String Name {get;set;}		// Short name for the command
        public String Verb {get;set;}		// Action verb. Used 'verb' instead of 'action' for field name to avoid confusion with controller action
        public String Description {get;set;} // Short description of what the command does. Used to render on screen description
        public String Result { get; set;}	// Used to indicate result (Sucesss/Error) for a command.
        public String Status { get; set;}	// Execution status (Ready,Running, Complete) for a command.
        public Boolean isBatch {get;set;}	// Indicates whether a command is executed asynchronously by a Apex Batch class
        public String batchId {get; set;}	// If isBatch=true, this field stores the Id of the Apex Batch Process which can 
        									// be used later to poll the completion status of the command (Apex batch process).

        
        public AutomationCommand( String name, String verb, String description) {
            this.Name =  name;
            this.verb = verb;
            this.description = description;
            this.Status = AutomationCommand.READY; 
            this.isBatch = false;
        }
        
        public void reset() {
        	this.Status = AutomationCommand.READY;
        	this.result = '';
        	this.batchId = '';
        }
        
     }