public with sharing class EnvironmentVariables {
	
	/**
	 * Checks and returns true if an input map of environment variables (name, EnvironmentVariable__c) has a specified required set of environment variable names. If any are missing, an error message is appended to the 
	 * error message holder input string.
	 */
	public static  boolean validateEnvironmentVarsPresent(Map<String, EnvironmentVariable__c> variablesMapToCheck, Set<String> requiredVariables, String errorMessage) {
		boolean environmentVarsPresent = true;
		
		if(requiredVariables.isEmpty()) 	// if no required variables then result is true
			return environmentVarsPresent; 
			
		if(requiredVariables.isEmpty() && variablesMapToCheck.isEmpty())
			return environmentVarsPresent;
		
		Set<String> reqVars = requiredVariables.clone();
		errorMessage = '<h1><font color="blue">Missing required Environment variables:</font></h1><br/><br/>';

		if ( variablesMapToCheck.isEmpty() ) {
 			environmentVarsPresent = false;
			errorMessage += '<strong>All ' + requiredVariables.size() + ' environment variables are missing:</strong><br/>';
				
		} else if ( variablesMapToCheck.size() != requiredVariables.size() ) {
			environmentVarsPresent = false;
			// Remove the environment variables found to keep the ones missing
			for ( EnvironmentVariable__c var : variablesMapToCheck.values() ) {
				reqVars.remove(var.Variable_Name__c);
			}
			errorMessage += '<strong>The following environment variables are missing:</strong><br/>';
		}

		// Complete building the error message if one was found 
		if ( !environmentVarsPresent ) {
			// Add to the message the remaining/missing environment variables
			for ( String varName : reqVars ) {
				errorMessage += '<font color="red">' + varName + '</font><br/>';
			}
			errorMessage += '<br/><h1><font color="blue">Please contact a system admin.</font><h1/>';
			// if called from VisualForce page
			if(ApexPages.currentPage() != null) {
				ApexPages.Message msg = 
				new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
			ApexPages.addMessage(msg);
			}
			
			System.debug(LoggingLevel.DEBUG, errorMessage);
		}
		return environmentVarsPresent;
	}

	/**
	 * Gets the environment variables for a specified module in an easily accessible map
	 */
	public static Map<String, EnvironmentVariable__c> getEnvironmentVariablesForModule(String moduleName, Map<String, EnvironmentVariable__c> varMapHolder ) {
		System.debug('moduleName=' + moduleName);
		List<EnvironmentVariable__c> vars = [SELECT Variable_Name__c, Value__c, Module__c, Is_Required__c, Is_Editable__c, IsEncrypted__c FROM EnvironmentVariable__c WHERE Module__c = :moduleName];
		for ( EnvironmentVariable__c currVar : vars ) {
				varMapHolder.put(currVar.Variable_Name__c, currVar);
		}
		System.debug( 'Retrieved variable value in varMapHolder=' + varMapHolder);
		return varMapHolder;
	}
	

	/**
	 * Gets the environment variables for a specified module in an easily accessible map
	 */
	public static Map<String, EnvironmentVariable__c> getEnvironmentVariablesForModule(String moduleName ) {
		Map<String, EnvironmentVariable__c> soapVars = new Map<String, EnvironmentVariable__c>();
		System.debug('moduleName=' + moduleName);
		List<EnvironmentVariable__c> vars = [SELECT Variable_Name__c, Value__c, Module__c, Is_Required__c, Is_Editable__c, IsEncrypted__c FROM EnvironmentVariable__c WHERE Module__c = :moduleName];
		for ( EnvironmentVariable__c currVar : vars ) {
				soapVars.put(currVar.Variable_Name__c, currVar);
		}
		System.debug( 'Retrieved soapVars=' + soapVars);
		return soapVars;
	}
	

}