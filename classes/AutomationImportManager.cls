/*=========================================================================================
 * Date			: 4/10/15
 * Developer	: Ken Gill
 * Purpose   	: 
 *              This class defines a common interface for implementing
 *              automation of any particular standard operating
 *              procedure (SOP) command set. The class also provides
 *              default implementation of common functionality needed
 *              by sub-classes.
 *
 *              The AutomationController uses AutomationImportManager
 *              as a delegate for executing commands selected
 *              on the user interface (AutomationProcessView)
 *              by a user. At run time, the specific sub-class of
 *              AutomationImportManager is specified by the URL request
 *              parameter ‘importType’. This parameter is used in
 *              the controller’s constructor to instantiate a specific
 *              sub-class of AutomationImportManager. Example: there is an
 *              AutomationImportMgr_51_Enrollment subclass to handle 51+
 *              Monthly enrollment SOP related commands.
 *
 *              The abstract method execute() is implemented by sub-classes
 *              and is intended to handle the commands passed as an
 *              argument to execute. The execute() method should handle
 *              all commands associated with the particular sub-class of
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
 
public abstract class AutomationImportManager {
    public static String Import51_Enrollment = 'Import51_Enrollment';
    public static String Import250_Enrollment = 'Import250_Enrollment';
    public static String Import250_BrokerActivity = 'Import250_BrokerActivity';


    public static Map<String,AutomationImportManager> automationImportManagerDelegates = new Map<String,AutomationImportManager>();

	static {
	    AutomationImportManager.registerAutomationImportManager( new AutomationImportMgr_250_BrokerActivity());
	    AutomationImportManager.registerAutomationImportManager( new AutomationImportMgr_51_Enrollment());
	    AutomationImportManager.registerAutomationImportManager( new AutomationImportMgr_250_Enrollment());
	 } 
	 
         
     public static void registerAutomationImportManager(AutomationImportManager mgr) {
         if( mgr != null && !String.isBlank(mgr.getImportType())) {
             AutomationImportManager.automationImportManagerDelegates.put(mgr.getImportType(), mgr);
         } else {
             System.debug('Error registering automation import manager: ' + String.valueOf(mgr));
         }
     }
 
    public static AutomationImportManager getInstance( String importType) {
    	if( ! automationImportManagerDelegates.containsKey( importType)) {
    		String message = 'No automation import manager found for import type= ' + importType;
    		System.debug( message);
    		throw new AutomationCommand.AutomationException(message);
    	}
    	return automationImportManagerDelegates.get( importType );
    }
    
    public String importType { get; set; }
    public String importTitle { get; set; }
    public String importSOPResourceFileName {get;set;}
    public List<AutomationCommand> commands { get; set; }
    public Map<String,AutomationCommand> commandMap { get; set; }


    public AutomationImportManager() {
        commands = new List<AutomationCommand>();
        commandMap = new Map<String,AutomationCommand>();
    }   

    public  String getImportType() { return importType; }
    public  String getImportTitle() { return importTitle; } 
    public List<AutomationCommand> getCommands() { return commands; }
    public Map<String,AutomationCommand> getCommandMap() { return commandMap; }
    
    

	public static void addCommandToDatabase(String importType, Decimal step, String name, Boolean isBatch, String description, String verb) {
		insert new AutomationCommand__c( ImportType__c=importType, Step__c = step, Name = name, IsBatch__c = isBatch,
						Description__c = description, Verb__c = verb);
	}

    public static List<AutomationCommand> loadCommandsFromDatabase(String forImportType) {
    	List<AutomationCommand> commandsToAdd = new List<AutomationCommand>();
    	
    	for( List<AutomationCommand__c> commandsFromDB : 
    	                             [SELECT ImportType__c,Step__c, Name, IsBatch__c, 
    	                             Description__c,Verb__c FROM AutomationCommand__c
    	                             WHERE ImportType__c = :forImportType
    	                             ORDER BY Step__c ASC])
     	{
     		for(AutomationCommand__c cmd: commandsFromDB) {
         		AutomationCommand c = new AutomationCommand( cmd.Name, cmd.Verb__c, cmd.Description__c);
        		c.isBatch = cmd.IsBatch__c;
        		c.Step = (Integer) cmd.Step__c;
        		commandsToAdd.add(c);
     		}
     	}	  	
     	return commandsToAdd;
    }
    
    public void addCommands(List<AutomationCommand> commandList) {
    	System.debug('AutomationImportManager:addCommands():' + commandList);
    	if( commandList != null && ! commandList.isEmpty()) {
    		substituteTokens( commandList, new Map<String,String>());	// for now name-value map is empty/not used
    		commands.addAll(commandList);
    		for( AutomationCommand c : commandList)
    			commandMap.put( c.verb, c);
    	}
    }
    
    // This is a helper method that can substitute symbols with values in the description field of loaded commands
    // An example is replacing RPT_DT__C with actual 'YYYYMM' formatted date string
    // TBD: the signature is generic to accept a map of name-value pairs for replacement but the implementation
    // only handles RPT_DT__C for now. The generic implementation is TBD for future. - KG 7/28/15
    
    public void substituteTokens( List<AutomationCommand> commandList, Map<String,String> tokenValues) {
    	for( AutomationCommand c : commandList) {
    		if( c.Description.contains('RPT_DT__c')) {
    			Date d = Date.today().addMonths(-1);
				Datetime dt = datetime.newInstance( d.year(), d.month(),d.day());
				String RptDateString = dt.format('YYYYMM');			 			
    			c.Description = c.Description.replace('RPT_DT__c', 'RPT_DT__c (' + rptDateString + ') ');
    		}
    	}
    }

	// This is a helper method that provides a NOP (no operation) default implementation. It can be used as a handler for new commands
	// that need to be declared in the metadata but that do not have a handler implemented yet. By assigning them
	// the 'NoOperation' verb, executing those commands on the interface would invoke this method.
  	public void handle_NoOperation(AutomationCommand command, AutomationCommand.AutomationCommandResult r) {
       	System.debug(command.verb + ' command execute');
		
		try {
			// implementation        				
			r.result = AutomationCommand.RESULT_PASS;
			r.resultMessage = 'NoOperation command performed'; 		
			command.Status = command.isBatch ?  AutomationCommand.RUNNING : AutomationCommand.COMPLETE;			
		} catch( Exception e) {
			command.Status = AutomationCommand.COMPLETE;			
			r.result = AutomationCommand.RESULT_ERROR;
			r.resultMessage = 'Error: ' + e.getMessage(); 			
		}
	
	}

    
    public  AutomationCommand.AutomationCommandResult pollStatus(AutomationCommand command, Map<String,String> parameters) {
        System.debug('AutomationImportManager.pollStatus():Input verb=' +command.verb + ' ,Parameters= ' + parameters);
		AutomationCommand.AutomationCommandResult r= new AutomationCommand.AutomationCommandResult();
		
    	if(command.isBatch && command.batchId != null) {
			List<AsyncApexJob> jobs = 
		    					    [select TotalJobItems, Status, ExtendedStatus, NumberOfErrors, MethodName, 
		      						JobType, JobItemsProcessed, Id, CreatedDate, CreatedById, 
		      						CompletedDate, ApexClassId, ApexClass.Name 
		      						FROM AsyncApexJob 
		      						WHERE Id = :command.batchId
					                ORDER BY CreatedDate DESC 
		     						];
			AsyncApexJob a = jobs[0];
			if(a != null) {				
				if( a.Status.equals('Completed')) {
					command.Status = AutomationCommand.COMPLETE;
					command.Result = AutomationCommand.RESULT_PASS;
					r.result = AutomationCommand.RESULT_PASS;
					r.resultMessage = 'Job finished with status= ' + a.Status + 
				             ', Total job items= ' + a.TotalJobItems + ', Items processed= ' + a.JobItemsProcessed + ', Errors = ' + a.NumberOfErrors;
			
				} else if (a.Status.equals('Failed') || a.Status.equals('Aborted')) {
					command.Status = AutomationCommand.COMPLETE;
					command.Result = AutomationCommand.RESULT_FAIL;
					r.result = AutomationCommand.RESULT_FAIL;
					r.resultMessage = 'Job finished with status= ' + a.Status + ', Extended Status= ' + a.ExtendedStatus;
					             
				} else {
					// remaining a.Status possible values: Holding, Queued, Preparing,Processing
					command.Status = AutomationCommand.RUNNING;
					command.Result = AutomationCommand.RESULT_RUNNING;
					r.result = AutomationCommand.RESULT_RUNNING;
					r.resultMessage = 
					         'Batch status= ' + a.Status +  
				             ' Total job items= ' + a.TotalJobItems + ', Items processed= ' + a.JobItemsProcessed + ', Errors = ' + a.NumberOfErrors;
				}
			} else {
				// command.Status unchanged
				//
				String s= 'No batch job found for batch ID= ' + command.batchId;
				System.debug(s);
				r.result = AutomationCommand.RESULT_FAIL; 
				r.resultMessage = 'No batch job found for batch ID' + command.batchId;
			}		
    	} else if ( ! command.isBatch) {
    			command.Status = AutomationCommand.COMPLETE;
    			command.Result = AutomationCommand.RESULT_FAIL;
 				r.result = AutomationCommand.RESULT_FAIL; 
				r.resultMessage = 'Command is not a batch command. Status polling is not applicable';    		
    	} else if ( command.batchId == null) {
    			command.Status = AutomationCommand.COMPLETE;
    			command.Result = AutomationCommand.RESULT_FAIL;
 				r.result = AutomationCommand.RESULT_FAIL; 
				r.resultMessage = 'No batch ID found for command.';    		  		
    	}
        	
    	System.debug('pollStatus result: ' + String.valueOf(r));
		return r;        
  }
  
    public abstract AutomationCommand.AutomationCommandResult execute(AutomationCommand command, Map<String,String> values);    
  
  
}