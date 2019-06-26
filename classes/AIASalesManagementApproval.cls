/*=================================================================================================================
 * Date         : 02/16/2016
 * Developer    : Satya Tirumalasetti
 * Purpose      : The purpose of this class is to send email to the user's Manager to get get the sales management 
 *                approval for a particualr BRF that user submitted.
 *=================================================================================================================
 */


global class AIASalesManagementApproval{
    webservice static String SubmittoSalesManagementApproval( Id recId, Id accountId){
         EmailTemplate emailTemplate = [Select id from EmailTemplate where name=:'AIA Sales Management Approval'];
         Contact cnt;
         List<Contact> cntList = [select id, Email from Contact where AccountId =: accountId limit 1];
         if(cntList.size() > 0){
            cnt = cntList[0];
         }else{
             return 'Error : Assosiated Account does not have a contact';
         }
         
         //To get current user Info and user's Manager info.
         List<User> user = [select managerId from User where id =: UserInfo.getUserId()];
         List<String> sendTo = new List<String>();
         List<User> mangaeruserList ;
         system.debug(user[0].managerId);
         if(user.Size() > 0 && String.isNotBlank(user[0].managerId))
              mangaeruserList = [select email from User where id =: user[0].managerId];
         system.debug(mangaeruserList);       
         if(mangaeruserList != null && mangaeruserList.size()>0 && mangaeruserList[0].email != null){
             sendTo.add(String.valueOf(mangaeruserList[0].email));   
         }else{
             return 'Error : Manger doesnot exist for this user';
         }    
        
         
         List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
         Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
         singleMail.setTargetObjectId(cnt.id);
         singleMail.setWhatId(recId);
         singleMail.setTemplateId(emailTemplate.Id);
         singleMail.setSaveAsActivity(false);                
         singleMail.setTreatTargetObjectAsRecipient(false);
    
         singleMail.setToAddresses(sendTo);
         emails.add(singleMail);
        
        // Send email to manager and if it is success, make the corresponding BRF Approval status field to In Review
         Messaging.SendEmailResult[] result = Messaging.sendEmail(emails);
         if(result != null && result[0].isSuccess()){
             Benfit_Request_Form__c brfRec = [select id,name,Sales__c,Sales_Management_Approval__c from Benfit_Request_Form__c where id =:recId];
             brfRec.Sales__c = 'In Review';
             if(mangaeruserList.size() > 0)
                 brfRec.Sales_Management_Approval__c = mangaeruserList[0].id ;
            
             update brfRec;
         }
         //return String.valueOf(result[0].isSuccess()+mangaeruserList[0].email);
         return 'Success';
    }
}