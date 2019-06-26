/*=======================================================================================================
 * Date         : 11/12/2017
 * Developer    : Satya Tirumalasetti
 * Purpose      : Controller for the VF page which is called when Send For BAA Rejection button is clicked
 *                on the AIA Document record. This will send an email to recipient with an explanation of 
 *                why the customized BAA document has been rejected.                   
 *=======================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date      +  Developer   + Tag + Description
 *===========+==============+============================================================================
 * 11/12/2017|  Satya       |     | Initial Version.
 *===========+==============+=====+======================================================================
*/

public without sharing class AIA_BAARejectionEmailExtCtrlr {
    public String emailToAddress{set;get;}
    public String emailSubject{set;get;}
    public String mailBody{set;get;}
    public String recId;
    public String ImplrecId;
    Static final String Status = 'Rejected';
    Static final String ERROR_MSG = 'Email will be sent only when Approval status is Rejected. Click Cancel to go back.';
    public Boolean isDisable {get;set;}

    
    //constructor
    public AIA_BAARejectionEmailExtCtrlr(ApexPages.StandardController controller) {
        AIA_Document__c aiaDoc = (AIA_Document__c)controller.getRecord();
        recId = aiaDoc.id;
        isDisable = false;
        //Get the aia record in the current context
        AIA_Document__c aidocRec = [Select id, Name,Implementation__c,Approval_Status__c,Implementation__r.DocuSign_Recipient_Email__c from AIA_Document__c where id =: recId ];
        If(aidocRec.Approval_Status__c != Status){
            isDisable = true;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info, ERROR_MSG));
        }
        ImplrecId = aidocRec.Implementation__c;
        //Get the recipient email address from the implementation record
        emailToAddress = aidocRec.Implementation__r.DocuSign_Recipient_Email__c;
    }
    
    //Method that will be called when user clicks on send button on the VF page. This will get the recipient email address, Subject and body entered by user.
    public PageReference sendEmail(){        
        List<String> sendToEmailList = new List<String>();//list to hold email addressess to which email needs to be sent
        sendToEmailList.add(emailToAddress);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(sendToEmailList); 
        mail.setSubject(emailSubject); //subject enterd by user on VF page
        mail.setPlainTextBody(mailBody);//Explanation entered by the user.
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        
        //Get the attachement of the current AIA Document
        List<Attachment> attachmentlist = [SELECT Body,Id,Name,ParentId FROM Attachment where parentId =: recId];
        // Add to attachment file
        if(attachmentlist.size() > 0){
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(attachmentlist[0].Name);
            efa.setBody(attachmentlist[0].Body);
            fileAttachments.add(efa);
            mail.setFileAttachments(fileAttachments);
        }
        try{
            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            if(results.size() == 1 && results[0].success){
            
                //if success, redirect the page to Implementation record.
                PageReference recordPage = new PageReference('/' + implRecId);
                recordPage.setRedirect(true);
                return recordPage;
            }else{
                return null;
            }
        }catch(Exception e){
            System.debug('Exception >> '+ e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            return null;
        }
        return null;
        
    }
    
    //Method to return back to the AIA doc once email is send successfully
    public PageReference Back(){
        PageReference BackToAIARec = new PageReference('/' + recId);
        BackToAIARec.setRedirect(true);
        return BackToAIARec;
    }

}