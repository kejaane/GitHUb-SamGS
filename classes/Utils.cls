/**
 *  @Author: Acumen Solutions
 *  @Purpose: Util class containing several methods/ inner class used by different triggers and other classes.
 *                             ---====[ History ]====---
 *  Date        Developer       Description
 *  ==========================================================================================================
 *  05/17/11    Tom Barrett     Added the ability to include object related attachments in the email
 *  07/30/11    Tom Barrett     Added the ability to bcc users
 *  04/17/2014  Tom Barrett     Added the toAddress method
 *  07/03/2014  Ashish Ojha     Added the ability to send email after comletion of broker activity batch job
 *  10/29/2014  Tom Barrett     Added a method named getCloseDate to have a central location that all business logic
 *                              can call to programmatically adjust the closeddate minus 21 days from the 
 *                              Opportunity Effective_Date__c
 *  10/29/2014  Ashish Ojha     Added CreateOpportunityContactRole Method to be able to contactrole passing parameters
 *  10/29/2014  Ashish Ojha     Added CreatePartner Method to be able to Partners passing parameters
 */

public without sharing class Utils {

 public static boolean increment =false;    
    
/*
* @purpose:  Inner Class used for email functionality  
*/   
    public class EmailUtil {
        /* Instantiate  valiables, properties */    
        private Messaging.SingleEmailMessage singleEmailMessage;
        private List<String> toAddresses;  
        private List<String> bccAddresses;            //tpb 07/30/11
        private String subject = '';
        private String htmlBody = '';
        private String replyTo ='';
        private Boolean useSignature = false;       
        private List<Messaging.EmailFileAttachment> fileAttachments = null;
        private String senderDisplayName = UserInfo.getFirstName()+' '+UserInfo.getLastName();
        private String plainTextBody = '';
        
        /* Constructors  */
        public EmailUtil(){}
        
        public EmailUtil(List<String> addresses) {
            this.toAddresses = addresses;
       }
       
       /* Methods */
       public void toAddresses(List<String> addresses) {
           this.toAddresses = addresses;
       }
       
       /* method to bcc - tpb 07/30/11 */
       public void bccAddresses(List<String> addresses) {
            bccAddresses = addresses;
       }
       
       /* method to set senderDisplayName */
        public void senderDisplayName(String val) {
            senderDisplayName = val;
       }
       
       
       /* method to set email subject */
       public void subject(String val) {
           subject = val;         
       }
       
       /* method to set email htmlBody */
       public void htmlBody(String val) {
           htmlBody = val;           
       }
       
        /* method to set email signature */
       public void useSignature(Boolean bool) {
           useSignature = bool;           
       }
       
       /* method to set email replyTo params */
       public void replyTo(String val) {
           replyTo = val;           
       }
       
       /* method to set email plainTextBody */
       public void plainTextBody(String val) {
           plainTextBody = val;           
       }
       
       /* method to set email fileAttachments */
       public void fileAttachments(List<Messaging.Emailfileattachment> val) {
           fileAttachments = val;
           
       }
       
/* @NOTE    : Tom Barrett added the ability to get and send object related attachments
 * @purpose : To retrieve related attachments associated to objects (i.e.: Opportunity, Contact, etc.) 
 * @param   : ID of the current parent record (opportunity, contact, etc)
 * @return  : Message.EmailFileAttachment[]
 * @ Example: Retrive the id from the object that you want to get the associated attachments from
 *            pass it to this method.
 * Define   : Messaging.EmailFileAttachment[] fileAttachments = null;
 * Call     : emailUtil.getObjectAttachments(objectId);           
*/
        public void objectFileAttachments(id objectId) {
            Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[] {};
            for (Attachment a : [Select Name, Id, ParentId, Body, BodyLength 
                                 From Attachment Where parentId = :objectId]) {
                Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
                fileAttachment.setBody(a.Body);
                fileAttachment.setFileName(a.Name);
                fileAttachments.add(fileAttachment);
            }
            this.fileAttachments = fileAttachments;    
        } 
/* 
* @purpose : private method to build the SingleEmailMessage with the params set for the email .
* @param : 
* @return : instance of EmailUtil class
*/  
       private EmailUtil build() {
           /* Instantiate  SingleEmailMessage  */
           singleEmailMessage = new Messaging.SingleEmailMessage();
           
           /* set params  as provided  */
//begin change tpb 07/30/2011
           //singleEmailMessage.setToAddresses(this.toAddresses);           
           if ( this.toAddresses.size()> 0 ) {                               
               singleEmailMessage.setToAddresses(this.toAddresses);
           }           
           if (this.bccAddresses != null) {
               singleEmailMessage.setBccAddresses(this.bccAddresses);            
           }
//end change tpb 07/30/2011
           singleEmailMessage.setSenderDisplayName(this.senderDisplayName);
           singleEmailMessage.setSubject(this.subject);
           singleEmailMessage.setHtmlBody(this.htmlBody);
           singleEmailMessage.setUseSignature(this.useSignature);
           singleEmailMessage.setReplyTo(this.replyTo);
           singleEmailMessage.setPlainTextBody(this.plainTextBody);           
           singleEmailMessage.setFileAttachments(this.fileAttachments);
           return this;
       }        
       

/*
* @purpose : send email to the appropriate user as a SingleEmailMessage. 
* @param : null
* @return : void
*/       
       public void sendEmail() {
              try {
                  /* Called private method build()to build the SingleEmailMessage with the params set for the email */
                  build();
                  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { singleEmailMessage });
                  
              } catch (Exception ex) {
                  
                System.debug('Exception during email send process : ' + ex.getMessage());
              }                
       }    
        
    }
/*
* @purpose : send email to the appropriate user as a SingleEmailMessage. 
* @param : body,subject,smtpto
* @return : void
*/
public static void SendMail(String body,String subject ,String smtpTo)
    {
        // First, reserve email capacity for the current Apex transaction to ensure 
        // that we won't exceed our daily email limits when sending email after 
        // the current transaction is committed. 
        
        if(Test.isRunningTest()) return;
        
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // Strings to hold the email addresses to which you are sending the email. 
          
       
        String[] toAddresses = new String[] {smtpTo}; 
        
        mail.setToAddresses(toAddresses);
        
        mail.setReplyTo('spmss.process@carefirst.com');
        mail.setSenderDisplayName('Support :');
        mail.setSubject(subject);
        mail.setBccSender(false);
        mail.setUseSignature(false);
        
        // Specify the text content of the email. 
        mail.setPlainTextBody(body);
        
        mail.setHtmlBody(body);
        
        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    /* ############################################################################
        Manage Custom Settings 
   ############################################################################## */ 
/*   public static Map<String,EntityType__c> getEntityTypes()
   {
        Map<String,EntityType__c> custSettingMap = EntityType__c.getAll();
        return custSettingMap;
   }
   public static Set<String> getEntityTypesAccount()
   {
    Set<String> entityTypeSet = new Set<String>();
    Map<String,EntityType__c> custSettingMap = getEntityTypes();
    String entityTypes = custSettingMap.get('AccountEntityTypes').Value__c;
    for(String s: entityTypes.split(','))
    {
        entityTypeSet.add(s.trim());
    }
    return entityTypeSet;
   }
   public static Set<String> getEntityTypesContact()
   {
    Set<String> entityTypeSet = new Set<String>();
    Map<String,EntityType__c> custSettingMap = getEntityTypes();
    String entityTypes = custSettingMap.get('ContactEntityTypes').Value__c;
    for(String s: entityTypes.split(','))
    {
        entityTypeSet.add(s.trim());
    }
    return entityTypeSet;
   } */
/*
* @purpose : To create Opportunit Contact Role
* @param : Id oppId,Id contactId, String role,boolean Primary
* @return : ContactRole
*/   
   //public static // Utils.methodName(params);
    public static OpportunityContactRole CreateOpportuntyContactRole(Id oppId,Id contactId, String role,boolean Primary){
        OpportunityContactRole cr = new OpportunityContactRole();
        cr.contactid = contactId;
        cr.Role      = role;
        cr.OpportunityId = oppId;
        cr.isprimary = Primary;
        return cr;
    }
/*
* @purpose : To create Opportunit Partner
* @param : Id oppId,Id accid, String role,boolean Primary
* @return : Partner

*/ 
    public static Partner CreatePartner(Id oppId,Id accId, String role, boolean Primary){
        Partner p = new Partner();
        p.Role      = role;
        p.OpportunityId = oppId;
        p.AccountToId = accId;
        p.isprimary = Primary;
        return p;
    }  
    
/*
* @purpose: Adjust the date coming in to -21 days
*           the primary purpose is to have a central method that is standard for
*           adjusting the Opportunity CloseDate using the Opportunity Effective_Date__c
* @param  : Assumes you are passing in the Opportunity_Effective__c date
* @return : Date value
*/
    public static Date getCloseDate(Date dateIn) {
        return dateIn.addDays(-21);
    }
}