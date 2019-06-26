public with sharing class AutomationInit {

	static {
	    AutomationImportManager.registerAutomationImportManager( new AutomationImportMgr_250_BrokerActivity());
	    AutomationImportManager.registerAutomationImportManager( new AutomationImportMgr_51_Enrollment());
	    AutomationImportManager.registerAutomationImportManager( new AutomationImportMgr_250_Enrollment());
	 } 

	// Important: This method should be executed once in each new Org sandbox so the command metadata is loaded 
	// in the database. Failing to do this would result in a blank automation process commands page (no commands displayed)
	// since the commands are loaded from the database which would be empty otherwise
	
	public static Boolean initializeOrgEnvironment(String environment) {
		Boolean result = true;
		result = AutomationInit.addCommandsToDatabase(environment);
		return result;
	}

	// this will invoke the utility methods on each specific AutomationImportManager subclass to add
	// it's command metadata to the database
	public static boolean addCommandsToDatabase(String environment) {
		Boolean result = true;
		/* Deprecated - commands are now loaded through XLS files instead of hard coded meta data - KG 7/30/15
		try {
		result = result? AutomationImportMgr_51_Enrollment.addCommandsToDatabase() : false;
		result = result? AutomationImportMgr_250_Enrollment.addCommandsToDatabase() : false;
		result = result? AutomationImportMgr_250_BrokerActivity.addCommandsToDatabase() : false;
		} catch (Exception e) {
			System.debug('Error initializing automation framework for environment ' + environment + 
			              ', Exception: ' + e.getMessage());
			result = false;
		}
		*/
		return result;		
	}
}