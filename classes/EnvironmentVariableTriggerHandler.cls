/*=========================================================================================
 * Date			: 10/21/2014
 * Developer	: Ken Gill
 * Purpose   	: This class is the extension point of the Trigger Framework for adding EnvironmentVariable handlers.               
 *                Whenever an EnvironmentVariable record is updated through the Administration application (EnvironmentVariables tab), dataloader or direct
 *                record update through the developer console, this handler captures the after insert and after update events
 *                and causes the EGPService related configuration to be refreshed based on the changes.
 * 				  
 * 				  NOTE: This class is the extension point for any other classes that want to reload their configuration from EnvironmentVariables
 *                when they are updated.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/21/14  |  KG	  |	Initial Version                                         
 *           |  	  |	
 *===========+============+================================================================
 */

public with sharing class EnvironmentVariableTriggerHandler extends TriggerHandler {

public EnvironmentVariableTriggerHandler() {}

	/* context override */


protected override void afterInsert() {
	processAfterUpdateOrInsert();
}

protected override void afterUpdate() {
	processAfterUpdateOrInsert();
}


	// Cause dependent classes to reload Environment variables
private void processAfterUpdateOrInsert() {
		  // Make the EGPService reload its configuration any time related environment variables are updated.
		  // This method is a future call and will run outside the trigger context. This is necessary so the updates
		  // to records are visible.
	  EGPService.reloadConfigurationFromEnvironmentVariables();
}

}