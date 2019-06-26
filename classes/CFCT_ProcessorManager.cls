//=========================================================================================
//     Date: 08/02/2011
//Developer: Tom Barrett
//  Purpose: Manager class for CareFirst Custom Tools (CFCT) processes.
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
// 02/20/2015 TPB            Deprecated code in the getDomainURL method that references 
//                           hard-coded URL to dynamically get the URL.
// 
//03/02/2015  AO / TPB       Added Method opportunitiesInProposalEmailUsers to send email to 
//                           opportunity owner based on market segment
//                           Added Method BuildEmail to build emails into an array so 
//                           governor limits were not reached.
//=========================================================================================

public without sharing class CFCT_ProcessorManager {
    public static List<Messaging.SingleEmailMessage> allMail = new List<Messaging.SingleEmailMessage>();

/**************************************************************************
 * purpose: To prepare for the call to email the user.  This method relies
 *          on a call to CFCT_QueryBase.getOppsDateLimit() to get a list
 *          of opportunities that have owners where lead rep do not match 
 *   param: List of Opportuntities.  This list must be created from calling
 *          CFCT_QueryBase.getOppsDateLimit()
 *          Boolean representing if a VF page is using this method. 
 *  return: None
 **************************************************************************/
    public static void ownerLeadRepNoMatchEmailUsers(List<Opportunity> oppList) {   
        ID[] userIds = new ID []{};
        String curOwner = '';     
        integer recipientCount = 0;
        // read through the complete list and only get
        // one email per owner in the list
        for (Opportunity o:oppList ) {
            if ( curOwner <> o.owner.name ) {
                recipientCount++;
                userIds.add(o.ownerid);                            
            }        
            curOwner = o.owner.name; 
            if ( recipientCount > 249 ) {       //max that can be emailed as of 07/25/2011 is 250 recipients in mass email                 
                CFCT_ProcessorManager.SendEmail('CFCT_OwnerLeadRepNoMatch', userIds);
                userIds.clear();
                recipientCount = 0;                
            }        
        }   
        if ( recipientCount <> 0 ) {
            CFCT_ProcessorManager.SendEmail('CFCT_OwnerLeadRepNoMatch', userIds);
        }       
    }  
    
    
/**************************************************************************
 * purpose: To prepare for the call to email the user.  This method relies
 *          on a call to CFCT_QueryBase.getOppsDateLimitWithoutPartners() to 
 *          get a list of opportunities with missing partners 
 *   param: List of Opportuntities.  This list must be created from calling
 *          CFCT_QueryBase.getOppsDateLimit()
 *          Boolean representing if a VF page is using this method. 
 *  return: None
 **************************************************************************/
    public static void opportunitiesWithoutPartnersEmailUsers(List<Opportunity> oppList) {   
        ID[] userIds = new ID []{};
        String curOwner = '';     
        integer recipientCount = 0;
        // read through the complete list and only get
        // one email per owner in the list
        for (Opportunity o:oppList ) {
            if ( curOwner <> o.owner.name ) {
                recipientCount++;
                userIds.add(o.ownerid);                            
            }        
            curOwner = o.owner.name; 
            if ( recipientCount > 249 ) {       //max that can be emailed as of 07/25/2011 is 250 recipients in mass email                 
                CFCT_ProcessorManager.SendEmail('CFCT_OppsWithoutPartners', userIds);
                userIds.clear();
                recipientCount = 0;                
            }        
        }   
        if ( recipientCount <> 0 ) {
            CFCT_ProcessorManager.SendEmail('CFCT_OppsWithoutPartners', userIds);
        }       
    }      



/*************************************************************************************
 * purpose: To send a mass email to users
 *   param: String - name of an email template
 *          ID array of user ids
 *          Boolean representing if a VF page is using this method. 
 *  return: None
 *************************************************************************************/
    public static void sendEmail(String template, ID[] userIds) {
        try {
            Messaging.reserveMassEmailCapacity(2);          
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            mail.setTemplateId(CFCT_QueryBase.getTemplateId(template));
            mail.setReplyTo('SFDCsupport@carefirst.com');
            mail.setSenderDisplayName('SFDC Support');
            mail.setBccSender(true);
            mail.setUseSignature(false);            
            mail.setTargetObjectIds(userIds);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail }); 
            // Most likely the method was called by from a Visualforce page; otherwise a schedule called the method
            if ( ApexPages.currentPage() != null ) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.CONFIRM, '<font color="blue">Mass email has been sent to user(s)</font>');             
                ApexPages.addMessage(myMsg);  
            }    
        } catch( EmailException e ) {
            if ( ApexPages.currentPage() != null ) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.FATAL, '<font color="red">' + e.getMessage() + '</font>');               
                ApexPages.addMessage(myMsg);
            }
            System.debug('EmailException in CFCT_ProcessorManager.SendEmail :' + e);                        
        } catch( exception e ) {
          //  if ( vfpCall ) {
            if ( ApexPages.currentPage() != null ) {
                ApexPages.addMessages(e); 
            }
            System.debug('Exception in CFCT_ProcessorManager.sendEmail :' + e);    
        }
    }


/*************************************************************************************
 * purpose: Deprecated code in the getDomainURL method that references 
 *                         hard-coded URL to dynamically get the URL.
 *   param: None           
 *  return: DomainURL
 *************************************************************************************/    
    public static string getDomainURL() {        
        string DomainURL;
        // BEGIN CHANGE TPB 02/20/2015
        /*
        if ( Userinfo.getOrganizationId() == '00DP00000000ZiN' ) {
            DomainURL = 'https://na4.saleforce.com/';
        } else {
            DomainURL = 'https://cs4.salesforce.com';
        }
        */
        DomainURL = URL.getSalesforceBaseUrl().toExternalForm();        
        // END CHANGE TPB 02/20/2015
        return DomainURL;
    }


//BEGIN ADD 03/02/2015 Ashish Ojha / Tom Barrett
/*************************************************************************
 * purpose: To prepare for the call to email the user.  This method relies
 *          on a call to CFCT_QueryBase.getOppsInProposalFor_200Plus()  
 *          get a list of opportunities that are in proposal 
 *   param: List of Opportuntities and market segment.  
 *          This list must be created from calling
 *          CFCT_QueryBase.getOppsInProposalFor_200Plus 
 *                    
 *  return: None
 **************************************************************************/
    public static void opportunitiesInProposalEmailUsers_200Plus(List<Opportunity> oppList) {         
        String DomainURL = getDomainURL();  
        String WebLinkId = ''; 
        String HtmlBody = '';
        String Subject = '';
        String Msg = '';
        String Msg1 = '';
        ID CurOwnerId;
            
        // build email message
        subject = 'Stale Opportunity For  200+ Market Segment';        
        Msg = '<h1>Stale Opportunity For  200+ Market Segment</h1>';
        Msg += '<h4>You are receiving this automatic reminder as the opportunity noted below is still in the Proposal stage and one of the following conditions exist:</h4>';
        Msg += '1. Effective Date is 14 days away from today<br/>';
        Msg += '2. Effective Date is equal to today<br/>';
        Msg += '3. Effective Date is 14 days old<br/><br/><br/>';
        Msg += 'Please take a moment to update the Stage and other necessary components. If you have any questions please refer to the Salesforce SOP’s in the Sales Resource Guide or contact sfdcsupport@carefirst.com.<br/><br/>';
        Msg1 += '<br/><br/><br/><br/>';
        Msg1 += 'Thank you <br/>';
        Msg1 += 'SFDC Support <br/><br/>';        

        for (Opportunity o : oppList ) {
            CurOwnerId = o.Owner.Id;
            // append the current systme's domain url with the  opportunity id
            WebLinkId = DomainURL + '/' + o.Id; 
            HtmlBody = '<pre>';
            HtmlBody += Msg + '<a href="' + webLinkId + '">' + o.Name + '</a>'; 
            HtmlBody += Msg1;
            HtmlBody += '</pre>';
            BuildEmail(CurOwnerId, Subject, HtmlBody);
        } 
        Messaging.sendEmail(allMail);   
    }  

/*************************************************************************
 * purpose: To prepare for the call to email the user.  This method relies
 *          on a call to CFCT_QueryBase.getOppsInProposalFor_51to199()  
 *          get a list of opportunities that are in proposal 
 *   param: List of Opportuntities and market segment.  
 *          This list must be created from calling
 *          CFCT_QueryBase.getOppsInProposalFor_51to199 
 *                    
 *  return: None
 **************************************************************************/       
     public static void opportunitiesInProposalEmailUsers_51to199(List<Opportunity> oppList) { 
        String DomainURL = getDomainURL();  
        String WebLinkId = ''; 
        String HtmlBody = '';
        String Subject = '';
        String Msg = '';
        String Msg1 = '';
        ID CurOwnerId;    
              
               // build email message

        subject = 'Stale Opportunity For  51 to 199 Market Segment';         
        Msg = '<h1>Stale Opportunity For  51 to 199 Market Segment</h1>';
        Msg += '<h4>You are receiving this automatic reminder as the opportunity noted below is still in the Proposal stage and one of the following conditions exist:</h4>';
        Msg += '1. Effective Date is 10 days away from today<br/>';
        Msg += '2. Effective Date is equal to today<br/>';
        Msg += '3. Effective Date is 14 days old<br/>'; 
        Msg += '4. Effective Date is 30 days old<br/><br/>'; 
        Msg += 'Please take a moment to update the Stage and other necessary components. If you have any questions please refer to the Salesforce SOP’s in the Sales Resource Guide or contact sfdcsupport@carefirst.com.<br/><br/>';
        Msg1 += '<br/><br/><br/><br/>';
        Msg1 += 'Thank you <br/>';
        Msg1 += 'SFDC Support<br/><br/>';       

        for (Opportunity o : oppList ) {
            CurOwnerId = o.Owner.Id;
            // append the current systme's domain url with the  opportunity id
            WebLinkId = DomainURL + '/' + o.Id; 
            HtmlBody = '<pre>';
            HtmlBody += Msg + '<a href="' + webLinkId + '">' + o.Name + '</a>';
            HtmlBody += Msg1; 
            HtmlBody += '</pre>';
            BuildEmail(CurOwnerId, Subject, HtmlBody);
        } 
        Messaging.sendEmail(allMail);   
    }      


/*************************************************************************************
 * purpose: Build email to be sent to the owner with Subject and body
 *   param: Id -     OwnerId 
 *          String - Subject of the email message
 *          String - Html Body of the email message
 *  return: None
 *************************************************************************************/
    public static void BuildEmail( Id OwnerId, String Subject, String HtmlBody ) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(OwnerId);
        //mail.setToAddresses(toAddress);
        // mail.setCcAddresses(ccAddresses);
        mail.setHtmlBody(HtmlBody); 
        mail.saveAsActivity = False;
        mail.setSubject(Subject);
        allMail.add(mail);
        
    }   
//END ADD 03/02/2015 Ashish Ojha / Tom Barrett    
     
}