//=========================================================================================
//     Date: 08/03/2010
//Developer: Tom Barrett
//  Purpose: To give the developer the ability to email the 
//           System Admins when errors occur in code or for any other reason necessary.
// 01/21/12: See addition below...
// ========================================================================================
//                     Update History
// Date        Developer      Description
// ========================================================================================
// 01/21/12    TPB            Added the emailDeactivateRecipients() method
//                            Added the getDeactivateRecipientList() method
// ========================================================================================

global class EmailAlerts { 
    //=======================================
    // emails the active admins in the system
    //=======================================   
    public static void emailAdmins( string subject, string body ) {
        // Send an email to the Admin on failure.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //*** BEGIN TEST USE ONLY ***      
        //String[] toAddresses = new String[] {'my.email.com'};
        //mail.setToAddresses(toAddresses);
        //*** END TESTING USE ONLY ***
        
        //>>>>>>> UNCOMMENT FOR PRODUCTION <<<<<<<
        mail.setToAddresses( getSystemAdminList() );
        
        mail.setSubject(subject);
        mail.setHTMLbody(body);
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail });
    }

    //=============================================
    // gets the list of active admins in the system
    //=============================================  
    public static string[] getSystemAdminList() {
        List<string> AdminList = new List<string>();        
        User[] SysAdmins = [ Select u.email
                             From User u
                             Where u.Profile.Name = 'System Administrator'
                             And IsActive = true ];
        for ( User u : SysAdmins ) {         
            AdminList.add(u.email);
        }     
        return AdminList;
    }

    //====================================================
    // emails the user who have are selected as Deactivate 
    // Recipients in the system and who are active
    //====================================================
    public static void emailDeactivateRecipients( string subject, string body ) {
        // Send an email to the recipients that are checked on the User record.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //*** BEGIN TEST USE ONLY ***      
        //String[] toAddresses = new String[] {'my.email.com'};
        //mail.setToAddresses(toAddresses);
        //*** END TESTING USE ONLY ***
        
        //>>>>>>> UNCOMMENT FOR PRODUCTION <<<<<<<
        mail.setToAddresses( getDeactivateRecipientList() );
        
        mail.setSubject(subject);
        mail.setHTMLbody(body);
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );
    }
    
    //=============================================
    // gets the list of active user who are selected
    // as Deactivate Recipients
    //=============================================      
    public static string[] getDeactivateRecipientList() {
        List<string> DeactivateRecipientList = new List<string>();
        User[] DeactivateRecipients = [ Select u.email
                                        From User u
                                        Where u.Deactivate_Recipient__c = true
                                        And IsActive = true ];
        for ( User u : DeactivateRecipients ) {
            DeactivateRecipientList.add(u.email);   
        }                         
        return DeactivateRecipientList;
    }
}