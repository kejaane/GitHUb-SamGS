//=========================================================================================
//     
//=========================================================================================
//                                 Update History
// Date       Developer      	Description
//=========================================================================================
// 08/14/2018 Debkanti	|T01|	Added method to check classic or lightning 
//=========================================================================================
public class CFCT_MassContactOwnerChange_Controller {

    private String currentContactOwnerId;
    private String newContactOwnerId;  
    String plainTextBody;  
    String htmlBody;
    
    /* constructor */
    public CFCT_MassContactOwnerChange_Controller() {
        //ApexPages.Message processingMsg = new ApexPages.Message(ApexPages.Severity.INFO,''); 
        //ApexPages.addMessage(processingMsg);
    }
    
    public String getSummaryResults() {
        return this.htmlBody;
    }

    public PageReference myResults() {
        return null;
    }
    
    public PageReference changeOwner() {           
        if ( validatePassed() ) {        
            //ApexPages.Message processingMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Processing...'); 
            //ApexPages.addMessage(processingMsg);
            
            /* Attempt to Change Contact Owner */
            if ( changeOwnerHelper() ) {
                String msg = 'Mass Contact Owner Change Completed Successfully.  ';
                msg += 'Please check your email for a list of contacts that were updated.';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, msg);  
                ApexPages.addMessage(myMsg);     
            }
        }
        return null; 
    }      
    
    /* Getter which dynamically generates a unique list  
       of contact owners from the Contact object */        
    public List<SelectOption> getcurrentContactOwners() {
        String oId;  
        String oName;    
        List<SelectOption> optionList = new List<SelectOption>(); 
        /* Add a null option to force the user to make a selection. */
        optionList.add(new SelectOption('','--None--'));  
        /* Loop through the Contact records creating a selectOption  
        for each result with the owner Id as the value and the owner name 
        as the label displayed in the selectList */  
        for ( AggregateResult c : [ SELECT ownerid, owner.name ownername 
                                    FROM contact 
                                    GROUP BY owner.name, ownerid 
                                    ORDER BY owner.name Limit 1000 ] ) {
            oId = (String) c.get('ownerid');
            oName = (String) c.get('ownername');             
            optionList.add(new SelectOption(oId, oName));  
        }  
        return optionList;
    } 
        
    public String getCurrentContactOwner() {
        return this.currentContactOwnerId;
    } 
    
    public void setCurrentContactOwner(String cco) {
        this.currentContactOwnerId = cco; 
    }     
    
    /* Getter which retrieves a list of all  
       active standard users */        
    public List<SelectOption> getNewContactOwners() { 
        String oId; 
        String oName;            
        List<SelectOption> optionList = new List<SelectOption>(); 
        /* Add a null option to force the user to make a selection. */
        optionList.add(new SelectOption('','--None--'));  
        /* Loop through the Contact records creating a selectOption  
        for each result with the owner Id as the value and the owner name 
        as the label displayed in the selectList */  
        for ( User u : [ SELECT id, name  
                         FROM User 
                         WHERE isActive = true AND UserType = 'Standard'
                         ORDER BY name Limit 1000 ] ) {
            oId = (String) u.get('id');
            oName = (String) u.get('name');             
            optionList.add(new SelectOption(oId, oName));  
        }  
        return optionList;
    }  
    
    public String getNewContactOwner() {
        return this.newContactOwnerId;
    } 
    
    public void setNewContactOwner(String nco) { 
        this.newContactOwnerId = nco; 
    } 
    
    /* Update the Contact owner, build email body message
       and summary email with results  */
    private boolean changeOwnerHelper() {        
        String NewOwner;
        String CurrentOwner; 
        integer x = 0;   
        String WebLinkId;
        String DomainURL= CFCT_ProcessorManager.getDomainURL();
 
          
             
        List<Contact> contactList = [ SELECT id, OwnerId, Owner.Name, name  
                                      FROM Contact
                                      WHERE OwnerId = :this.currentContactOwnerId LIMIT 1000 ];                                      
        List<User> co = [ SELECT Name
                          FROM User
                          WHERE id = :this.currentContactOwnerId LIMIT 1 ];         
        currentOwner = co.get(0).Name;
        
        List<User> no = [ SELECT Name
                          FROM User
                          WHERE id = :this.newContactOwnerId LIMIT 1 ];                                     
        newOwner = no.get(0).Name;  
        
        /* Build message with List of Contacts that had the owner changed */
        htmlBody = '<b><font size="6" color="Blue">Mass Contact Owner Change Results</font></b><br/><br/>'; 
        htmlBody += '<font size="4">Owner changed from <b><font color="#580000">' + currentOwner + ' </font></b>to <b><font color="#580000">' + newOwner + ' </font></b>for the following Contact(s):</font><br><br>';  
        plainTextBody = 'Mass Contact Ownership Change Results \n\n';   
        plainTextBody += 'Owner changed from ' + currentOwner + ' to ' + newOwner + ' for the following Contact(s): \n\n';

        for ( Contact c : contactList ) {            
            c.OwnerId = this.newContactOwnerId;                
            webLinkId = DomainURL + '/' + c.Id; 
            htmlBody += '<a href="' + webLinkId + '">' + c.Name + '</a><br/><br/>';      
            x = x + 1;
            plainTextBody += c.Name + '\n';
        }  
        try {
            Update contactList;  
            sendEmail();        
        } catch (DMLException e) {
            System.debug('DMLException in CFCT_QueryBase.changeOwnerHelper is :' + e);
        } catch (Exception e) {
            System.debug('Exception in CFCT_QueryBase.changeOwnerHelper is :' + e);   
        } 
        return true;
    }
    
    /* returns false if validation does not pass; otherwise true */
    private boolean validatePassed() {
        boolean passed = true;
        if ( this.currentContactOwnerId == null ) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose a Current Owner');  
            ApexPages.addMessage(myMsg);            
            passed = false;
        }        
      
        if ( this.newContactOwnerId == null ){  
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose a New Owner');  
            ApexPages.addMessage(myMsg);
            passed = false;
        }                    
        
        if ( ( this.currentContactOwnerId == this.newContactOwnerId ) && ( this.currentContactOwnerId <> null || this.newContactOwnerID <> null ) ) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Current and New Owner cannot be the same');  
            ApexPages.addMessage(myMsg);          
           passed = false;
        }        
        return passed;
    }
    
    private void sendEmail() {
        User currentUser = new User();
        currentUser = QueryBase.getCurrentUser();
        List<String> toAddresses = new List<String> {currentUser.Email};
        String replyToAddress = currentUser.Email;        
        Utils.EmailUtil email = new Utils.EmailUtil(toAddresses);
        email.plainTextBody(plainTextBody);
        email.htmlBody(htmlBody);
        email.senderDisplayName(currentUser.Name);
        email.subject('Mass Contact Owner Change');
        email.replyTo(replyToAddress);
        email.sendEmail();
    }
    /*-T01-Start-*/
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    /*-T01-End-*/
}