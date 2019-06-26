//=========================================================================================
//      Date: 11/02/2011
// Developer: Tom Barrett (TPB)
//   Purpose: To test the Util class. 
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
// 06/05/2013 Tom Barreett   added test code to cover two methods in the Util that had no
//                           code coverage
//=========================================================================================
@isTEST
private class Utils_TEST {
    static testMethod void test_1() {        
        User currentUser = new User();
        currentUser = [ Select email, Name , id from User where username = :UserInfo.getUserName() limit 1 ];        
        List<String> toAddresses = new List<String> {currentUser.Email};
        String replyToAddress = currentUser.Email;
        
        account acct = new account();
        acct.name = 'test';
        insert acct;
        attachment attach = new attachment();
        attach.name = 'Test Attachment';
        Blob bodyBlob = Blob.valueOf('Test Attachment Body Text');
        attach.body = bodyBlob;
        attach.parentid = acct.id;
        insert attach;
// BEGIN Add 06/05/2013        
        //Build attachement list
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('attachment.pdf');
        List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
        efaList.add(efa);  
// END Add 06/05/2013          
                  
        Test.StartTest();
            Utils.EmailUtil email = new Utils.EmailUtil(toAddresses);
            email.plainTextBody('Utils.EmailUtil Test');
            email.htmlBody('Utils.EmailUtil Test');
            email.senderDisplayName(currentUser.Name);
            email.subject('Utils.EmailUtil Test');
            email.replyTo(replyToAddress);
            email.bccAddresses(toAddresses);
            email.useSignature(FALSE);                //TPB Added on 06/05/2013 
            email.fileAttachments(efaList);           //TPB Added on 06/05/2013
            email.objectFileAttachments(acct.id);
            email.sendEmail();
        Test.StopTest();
    }
}