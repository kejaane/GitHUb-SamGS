/*=========================================================================================
 * Date			: 4/10/15
 * Developer	: Ken Gill
 * Purpose   	: 
 *              This controller services requests from the
 *              AutomationProcessView and AutomationProcessList visualforce
 *              pages. It translates requests and associated parameters
 *              (from the URL) into commands that it executes by delegating
 *              to its AutomationImportManager reference which is an
 *              instance based on the current SOP process selected. It
 *              uses the ‘importType’ request parameter to configure
 *              an appropriate instance of AutomationImportManager subclass
 *              to use as a delegate for executing commands.
 *
 *              The execute() action handles the event of a specific
 *              automation command’s button being clicked on the user
 *              interface.
 *
 *              The checkCompletion() action is invoked by the client
 *              javascript pollCommandStatus() function to check on status
 *              of a batch process command in progress.
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

public class AutomationProcessController {
 
     public AutomationImportManager automationImportMgrDelegate {get; set;}
     public Integer	pollCount {get; set;}	// temp variable
     public Integer	commandCompleted {get; set;}// 0 - in progress, 1 - complete
     public AutomationCommand currentCommand {get; set;}
     public String commandStatus {get; set;}
     public String commandResult {get; set;}
     public String commandResultMessage {get; set;}


 
/*************************************************************************************
 * Purpose   : Constructor which initializes the controller by initializing it for a specific 
 *             type of SOP which is indicated by the importType parameter. It also initializes
 *             the AutomationImportManager delegate to the correct subclass instance that handles 
 *             'importType' SOP commands.
 *             
 * Parameters: String importType - specify the SOP for which this controller will support commands.
 *
 * Return    : None
 *************************************************************************************/
     
     public AutomationProcessController(String importType) {
         System.debug('AutomationProcessController(String importType): Called with importType= ' + importType);
         //status = READY;
         pollCount=0;
         commandCompleted=0;
         commandStatus = AutomationCommand.READY;
         commandResult = '';	// Nothing yet, no command has been executed at this time
         commandResultMessage = '';
         automationImportMgrDelegate = AutomationImportManager.getInstance(importType); 
     }

/*************************************************************************************
 * Purpose   : Constructor which initializes the controller based on the URL parameter 'importType'
 *             which it extracts from the ApexPages.currentPage().getParameters() map.
 *             
 * Parameters: importType URL parameter passed indirectly via ApexPages
 *
 * Return    : None
 *************************************************************************************/ 
     public AutomationProcessController() {
         String importType =  ApexPages.currentPage().getParameters().get('importType');
         System.debug('AutomationProcessController(): Called with importType= ' + importType);

         if(String.isBlank(importType) || AutomationImportManager.getInstance(importType) == null) {
             String message = 'Invalid importType parameter: ' + importType;
             ApexPages.Message msg = new ApexPages.Message( ApexPages.Severity.ERROR, message);
             ApexPages.addMessage( msg );
             System.debug(message);
         } else {
            this( importType );             
         }
      }
     
     public List<AutomationCommand> getCommands() { 
            return automationImportMgrDelegate.getCommands();
     }
     
     public Map<String,AutomationCommand> getCommandMap() { 
            return automationImportMgrDelegate.getCommandMap(); 
     }
 
 /*************************************************************************************
 * Purpose   : Responsible for executing a single automation command. When a user clicks on 
 *             a command button on the automation process view page, this controller action is
 *             invoked and a URL parameter 'verb' is used to pass the selected command.
 *
 *             This method retrieves the related Command from the commandMap using the verb as a key  *             and passes the Command object to the AutomationImportManager delegate sub-class for 
 *             execution. The result of the command is stored in a 
 *             AutomationCommand.AutomationCommandResult object (result code, result message) which 
 *             is used to render the response on the Visualforce page.
 *             
 * Parameters: verb - as a URL parameter which is retrieved using 
 *             ApexPages.currentPage().getParameters()
 *
 * Return    : PageReference - the next page displayed to the user. In this case it is null 
 *             the source page is reloaded. 
 *************************************************************************************/
     
     public PageReference execute() {
         Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
         String verbParameter = parameterMap.get('verb');
         System.debug('Execute called with verb= ' + verbParameter);
         currentCommand = getCommandMap().get(verbParameter);
         if( currentCommand != null) currentCommand.reset();	// if the command is being re-run reset any old status
         System.debug('AutomationProcessController:execute:currentCommand=' + currentCommand);
         AutomationCommand.AutomationCommandResult r = automationImportMgrDelegate.execute(currentCommand, parameterMap);
         currentCommand.Result = r.result;	// for use by the commandsDiv refresh action on AutomationProcessView.page 
         commandStatus = currentCommand.Status;
         commandResult = r.Result;
         commandResultMessage = r.resultMessage;
		 return null;
     }
 
/*************************************************************************************
 * Purpose   : Responsible for polling the status of a given command. This is used in the case
 *             of AutomationCommands connected to a Batch process. This controller action gets
 *             the completion status of the current command by delegating the status check through
 *             a related SOP AutomationImportManager sub-class instance based on current SOP process
 *             selected by the user
 *           
 *             
 * Parameters: None
 *
 * Return    : PageReference - the next page displayed to the user. In this case it is null 
 *             the source page is reloaded. 
 *************************************************************************************/
     
     public PageReference checkCompletion() {
     	System.debug('AutomationProcessController:checkCompletion called');
     	
		Map<String,String> parameterMap = ApexPages.currentPage().getParameters();

		if( currentCommand != null) 
			commandStatus = currentCommand.Status;
						
   		AutomationCommand.AutomationCommandResult r = automationImportMgrDelegate.pollStatus(currentCommand, parameterMap);
   		commandStatus = currentCommand.Status;
   		commandResult = r.Result;
   		commandResultMessage = r.resultMessage;
   		
   		return null;
     }
     
}