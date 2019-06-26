/********************************************************************************
 ********************************************************************************    
 *	Class            : EnvironmentVariablesController
 *	Author		     : Acumen Solutions: Alejandro Olivas
 *	Version History  : 1.0
 *	Creation         : 06/16/11
 *	Description      : Controller class whose primary function is to manage
 *					   the environment variables defined by a system admin.
 *					   This includes, rendering the visualforce page, editing,
 *					   deleting, and creating new environment variables
 ********************************************************************************
  *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/21/14  |  KG	  |	Modified this class to be more generic and applicable to any module                                         
 *           |  	  |	beyond BrokerExpress. Added Is_Editable__c, Is_Required__c and modified
 *           |  	  |	the SOQL query in method getLatestEnvironmentVariables() of this class 
 *           |  	  |	to include these
 *           |  	  |	
 *           |  	  |	
 *===========+============+================================================================
 */
 
public with sharing class EnvironmentVariablesController {

	public EnvironmentVariable__c selectedVar { get;set; }
	public List<EnvironmentVariable__c> environmentVars { get;set; }

	public boolean editingVariable { get;set; }

	public EnvironmentVariablesController() {
		selectedVar = new EnvironmentVariable__c();
		environmentVars = new List<EnvironmentVariable__c>();
		editingVariable = false;
		getLatestEnvironmentVariables();
	}

	/**
	 * Saves an environment variable that was just created or that was
	 * being edited
	 */
	public PageReference saveVariable() {
		boolean hasError = false;
		String errorMessage = '';
		String hasReqFields = checkRequiredFields();
		if ( !hasReqFields.equals('yes') ) {
			hasError = true;
			errorMessage = hasReqFields;
		} else {
			// Do not check for a duplicate value when editing an environment var
			if ( editingVariable || checkForDuplicateVariable(selectedVar) ) {
				selectedVar.Name = selectedVar.Variable_Name__c;
				upsert selectedVar;
				editingVariable = false;
			} else {
				hasError = true;
				errorMessage = 'Duplicate Environment Variable. A ' +
					'variable with the name <strong>' + selectedVar.Variable_Name__c + 
					'</strong> in the <strong>' +selectedVar.Module__c + 
					'</strong> module already exists.';
			}
		}

		if ( hasError ) {
			editingVariable = false;
			ApexPages.Message msg = new ApexPages.Message(
				ApexPages.Severity.ERROR, errorMessage);
			ApexPages.addMessage(msg);
		}
		// Get the latest list of variables, including the one just added/updated
		getLatestEnvironmentVariables();
		selectedVar = new EnvironmentVariable__c();
		return null;
	}

	/**
	 * Marks an environment variable for editing and displays this variable's
	 * content on the input fields available for editing
	 */
	public PageReference editVariable() {
		String selectedID = ApexPages.currentPage().getParameters().get('selectedID');
		editingVariable = true;
		selectedVar = 
			[SELECT id, Variable_Name__c, Module__c, Value__c, IsEncrypted__c 
			 FROM EnvironmentVariable__c WHERE Id =: selectedID];
		if ( selectedVar.IsEncrypted__c ) {
			//SelectedVar.VariableValue__c = SMBUtils.GetDecryptedValue(SelectedVar.VariableValue__c);
		}
		//Selected = true;
		return null;
	}

	/**
	 * Deletes an environment variable from the database
	 */
	public PageReference deleteVariable() {
		String selectedID = ApexPages.currentPage().getParameters().get('selectedID');
		selectedVar = [SELECT id FROM EnvironmentVariable__c WHERE id =: selectedID];
		delete SelectedVar;
		getLatestEnvironmentVariables();
		selectedVar = new EnvironmentVariable__c();		
		return null;
	}
	
	/**
	 * Returns a list of the latest environment variables
	 */
	private void getLatestEnvironmentVariables() {
		environmentVars = 
			[SELECT Variable_Name__c, Value__c, Module__c, IsEncrypted__c, Is_Required__c, Is_Editable__c FROM EnvironmentVariable__c];
	}

	/**
	 * Checks that the required fields on the Environment Variables contain values
	 */
	private String checkRequiredFields() {
		String reqFields = 'yes';
		String errorMsg = '';
		boolean reqFieldMissing = false;
		if ( selectedVar.Module__c == null ) {
			reqFieldMissing = true;
			reqFields = 'Module must be selected! Cannot be left ' + 
				'as <strong>--None--</strong>. ';
		}
		if ( selectedVar.Variable_Name__c == null ) {
			errorMsg = 'Name is a required field';
			if ( reqFieldMissing ) {
				reqFields += '<br/>' + errorMsg;
			} else {
				reqFields = errorMsg;
			}
		}
		return reqFields;
	}

	/**
	 * Checks if an environment variable by the same name within the same module
	 * already exists, if so this function returns true otherwise false
	 * 9/28/14 KG: The logic of this method was in reverse returning false if a duplicate existed. Fixed the logic.
	 */
	private boolean checkForDuplicateVariable(EnvironmentVariable__c var) {
		boolean duplicateExists = false;
		try {
			List<EnvironmentVariable__c> duplicateCheck = 
				[SELECT Variable_Name__c, Value__c, Module__c FROM EnvironmentVariable__c 
				 WHERE Variable_Name__c LIKE: selectedVar.Variable_Name__c 
				 AND Module__c =: selectedVar.Module__c];
				 
			if( duplicateCheck.size() >= 1) duplicateExists= true;
		} catch (Exception e) {
			duplicateExists = false;
		}
		return duplicateExists;
	}
	
	/*
		private boolean checkForDuplicateVariable(EnvironmentVariable__c var) {
		boolean duplicateExists = false;
		try {
			EnvironmentVariable__c duplicateCheck = 
				[SELECT Variable_Name__c, Value__c, Module__c FROM EnvironmentVariable__c 
				 WHERE Variable_Name__c LIKE: selectedVar.Variable_Name__c 
				 AND Module__c =: selectedVar.Module__c];
		} catch (Exception e) {
			duplicateExists = false;
		}
		return duplicateExists;
	}
	*/
/*
	private static String getEncryptedValue(String input) {
		//EnvironmentVariables__c v = [select VariableValue__c from EnvironmentVariables__c where Module__c = 'EncryptionKey' limit 1];
		String key_to_store = EnvironmentVariables__c.getInstance('EncryptionKey_Key').VariableValue__c;
		Blob data = Blob.valueOf(input);
		Blob encryptedData = Crypto.encryptWithManagedIV('AES128', Blob.valueOf(key_to_store), data);
		return EncodingUtil.base64Encode(encryptedData);
	}
	
	public static String getDecryptedValue(String input) {
		//EnvironmentVariables__c v = [select VariableValue__c from EnvironmentVariables__c where Module__c = 'EncryptionKey' limit 1];
		String key_to_store = EnvironmentVariables__c.getInstance('EncryptionKey_Key').VariableValue__c;	
        Blob encryptedData = EncodingUtil.base64Decode(input);
		Blob decryptedData=Crypto.decryptWithManagedIV('AES128', Blob.valueOf(key_to_store), encryptedData);
		return decryptedData.toString();
	}
*/
}