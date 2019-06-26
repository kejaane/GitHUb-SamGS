/*=========================================================================================
 * Date		: 11/6/15
 * Developer	: Ken Gill
 * Purpose   	:  
 * 
 *               This is a general Validation class that can be extended by classes that need to 
 *               support validation semantics. In addition to providing a comment method, it also 
 *               provides helper methods to add and display validation errors.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/6/15   |  KG    |	Initial Version                                         
 *   	     |        | 
 *=========================================================================================
 */
public with sharing class FCI_Validation {

	 public boolean isValid {get; set; }
	 public Map<String,String> fieldMessages { get; set;}
	
	 // this method must be implemented by sub-classes
	 //public abstract boolean validate();
	
	 public FCI_Validation() {
		isValid = false;
		fieldMessages = new Map<String,String>();
	 }
	

    /**
     * Add an error message whenever a field validation error is encountered
     */
    public void addFieldValidationError(String field, String errorMessage) {
		if(field !=null && errorMessage != null)
			fieldMessages.put(field, errorMessage);
    }

    /**
     * Get an HTML formatted string of the validation messages.
     */
    public String getValidationMessagesAsHTML() {
		String message = '';
		for(String key : fieldMessages.keySet()) {
		  message += 
	            '<h2><font color="red">' + key + '</font></h2> - ' +
	            '<font color="Black">' + fieldMessages.get(key) + '</font><br/>';
	    }
	    return message;
	}
	
    public Map<String,String> getValidationMessages() {
    	return fieldMessages;
    }
}