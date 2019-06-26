/*****************************************************************************************************
*Date: 11-13-2017 
*Developer: Satya Tirumalasetti
*Purpose: This class will be called from AIA_DocuSign_RecipientHandler class to get the recipient
           Name,email and also send the email notifications to submitter of documents for signatures
           when ever they finished signing from their side. 
*=========================================================================================
* Update History
* Date         Developer    Tag           Description 
*==================================================================================
* 11-13-2017   Satya                  Initial Development
* 24-13-2017   Satya        T01       Added method to send email to submitter of the document
                                      when a recipient signs the document
*==================================================================================

*******************************************************************************************************/


//This class will be invoked from AIA_DocuSign_RecipientHandler 
public with sharing class AIA_DocuSign_RecipientHelper{
    
    
/* @Author: Satya 
* @This method will be called from AIA_DocuSign_StatusHandler when any new record is inserted to get recipient details
* @param -  List<dsfs__DocuSign_Status__c>
* @Output - populate fields in implementation record
*/
    
   Public static void populateNameandEMail(List<dsfs__DocuSign_Recipient_Status__c> docuSignList){
   
  
    Set<id> docusignRecipientSet = new Set<id>();
    id impId;
    Map<Id,dsfs__DocuSign_Recipient_Status__c> mapDocuSignImp = new Map<Id,dsfs__DocuSign_Recipient_Status__c>(); 
    Map<Id,dsfs__DocuSign_Recipient_Status__c> mapDocuSignAIAdoc = new Map<Id,dsfs__DocuSign_Recipient_Status__c>(); 
    
    
    // Lopp through all the records in the trigger context that has Routing order as 1 or 2
    for(dsfs__DocuSign_Recipient_Status__c Rep: [select id,dsfs__Recipient_Status__c,Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Parent_Status_Record__r.Implementation__c,
                                                 dsfs__DocuSign_Routing_Order__c,dsfs__Parent_Status_Record__r.AIA_Document__c from dsfs__DocuSign_Recipient_Status__c
                                                  where id in :docuSignList and (dsfs__DocuSign_Routing_Order__c = 1 OR dsfs__DocuSign_Routing_Order__c = 2) ]){
    
        //system.debug('record ' + Rep);
        
        //check if parent record(Docusign status) has Implementation. If it has, then add that to the map
        if(Rep.dsfs__Parent_Status_Record__c != null && (Rep.dsfs__Parent_Status_Record__r.Implementation__c != null && string.IsNotBlank(Rep.dsfs__Parent_Status_Record__r.Implementation__c))){
            mapDocuSignImp.put(Rep.dsfs__Parent_Status_Record__r.Implementation__c,Rep);
        }   
    }
    
    //If map is not empty, then get the implementation records
    if(!mapDocuSignImp.isEmpty()){
        List<AIA_Implementation__c> implList = [select id, DocuSign_Recipient_Name__c,DocuSign_Recipient_Email__c from AIA_Implementation__c where id in : mapDocuSignImp.keySet()];
        //Lopp through all the records and update the imp record with recipient name and email.
        for(AIA_Implementation__c imp : implList){
            dsfs__DocuSign_Recipient_Status__c DocuSignStatus = mapDocuSignImp.get(imp.id);
            imp.DocuSign_Recipient_Name__c = DocuSignStatus.Name;
            imp.DocuSign_Recipient_Email__c = DocuSignStatus.dsfs__DocuSign_Recipient_Email__c;
        }
        //Update the list if it is not empty
        if(!implList.isEmpty()){
            update implList;
        } 
    }
   } 
   
   
      
/*@Author: Satya 
* @Method to send email to submitter of the document when a recipient signs the document
* @param - List<dsfs__DocuSign_Recipient_Status__c> docuSignList, Map<Id,dsfs__DocuSign_Recipient_Status__c> oldMap
* @Output - send email to Submitter and VP
*/
   Public static void SendEmailToSubmitter(List<dsfs__DocuSign_Recipient_Status__c> docuSignList, Map<Id,dsfs__DocuSign_Recipient_Status__c> oldMap){
   
  
    Set<id> docusignRecipientSet = new Set<id>();
    id impId;       
    //Get all Docusign recipient status records when they are updated
    List<dsfs__DocuSign_Recipient_Status__c> docRecipStatusList = [select id,dsfs__Recipient_Status__c,Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Parent_Status_Record__c,dsfs__Parent_Status_Record__r.Implementation__c,dsfs__Parent_Status_Record__r.Implementation__r.Account_Legal_Name__c,
                                                 dsfs__DocuSign_Routing_Order__c,dsfs__Parent_Status_Record__r.AIA_Document__c,dsfs__Parent_Status_Record__r.Implementation__r.Docusign_Document_sending_user__c,dsfs__Parent_Status_Record__r.Implementation__r.DocuSign_Recipient_Name__c,
                                                 dsfs__Parent_Status_Record__r.AIA_Document__r.Implementation__r.Docusign_Document_sending_user__c,dsfs__Parent_Status_Record__r.AIA_Document__r.Implementation__r.Account_Legal_Name__c
                                                 from dsfs__DocuSign_Recipient_Status__c
                                                  where id in :docuSignList];
    Set<id> parentStausSet = new Set<Id>();
    //Get the parent record Id 
    for(dsfs__DocuSign_Recipient_Status__c Rep: docRecipStatusList){
        parentStausSet.add(Rep.dsfs__Parent_Status_Record__c);
    }
    //Check if record has routing number 3 and add it to the map, so that it needs to be routed to VP for signature
    Map<Id,Boolean> mapDocuRecMap = new Map<Id,Boolean>();
    for(dsfs__DocuSign_Recipient_Status__c parentReciStatus : [Select id,dsfs__Parent_Status_Record__c,dsfs__Parent_Status_Record__r.dsfs__Subject__c,dsfs__DocuSign_Routing_Order__c from dsfs__DocuSign_Recipient_Status__c where dsfs__Parent_Status_Record__c in:parentStausSet ]){
        //if(parentReciStatus.dsfs__DocuSign_Routing_Order__c == 3 ){
        if( (parentReciStatus.dsfs__Parent_Status_Record__r.dsfs__Subject__c.containsIgnoreCase('BAA')) || (parentReciStatus.dsfs__Parent_Status_Record__r.dsfs__Subject__c.containsIgnoreCase('Business Associate Agreement'))){
            mapDocuRecMap.put(parentReciStatus.dsfs__Parent_Status_Record__c,true);
        }
    }
    
    //Loop through all the trigger context records 
    for(dsfs__DocuSign_Recipient_Status__c Rep: docRecipStatusList ){
        
        system.debug('record ' + Rep);
        List<String> sendToEmailList = new List<String>();
        string AccName = '';
        
        //Check what the parent record has, whether it is Imp record or AIA Doc record and assign the email ID and Account legal name accordingly.
          if(Rep.dsfs__Parent_Status_Record__c != null && string.IsNotBlank(Rep.dsfs__Parent_Status_Record__c)){
            if(string.IsNotBlank(Rep.dsfs__Parent_Status_Record__r.Implementation__c)){
            sendToEmailList.add(Rep.dsfs__Parent_Status_Record__r.Implementation__r.Docusign_Document_sending_user__c);
            AccName = Rep.dsfs__Parent_Status_Record__r.Implementation__r.Account_Legal_Name__c;
            }else{
            sendToEmailList.add(Rep.dsfs__Parent_Status_Record__r.AIA_Document__r.Implementation__r.Docusign_Document_sending_user__c);
            AccName = Rep.dsfs__Parent_Status_Record__r.AIA_Document__r.Implementation__r.Account_Legal_Name__c;
            }
        }
        
        //Assign the Document type and body of email that needs to be sent submitter.
        //If the parent record contains child record that has routing order 1 or 2 then email with below type and  
       system.debug('oldMap.get(Rep.id).dsfs__Recipient_Status__c ' + oldMap.get(Rep.id).dsfs__Recipient_Status__c);
         if(oldMap.get(Rep.id).dsfs__Recipient_Status__c != Rep.dsfs__Recipient_Status__c && Rep.dsfs__Recipient_Status__c=='Completed'){
            if((Rep.dsfs__DocuSign_Routing_Order__c==1) || (Rep.dsfs__DocuSign_Routing_Order__c==2)){
                String type = 'Business Associate Confirmation';
                string EmailBody = AccName+' has electronically signed the ' + type+'.';
                if(mapDocuRecMap.containsKey(Rep.dsfs__Parent_Status_Record__c)){
                    type ='Business Associate Agreement (BAA)';
                    EmailBody = AccName+' has electronically signed the ' + type +'. The BAA has been routed to the Sales Vice President for final signature.';
                }
                system.debug('type>>>'+type);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(sendToEmailList); 
                //mail.setSubject(type +' for ' + Rep.dsfs__Parent_Status_Record__r.Implementation__r.Account_Legal_Name__c);
                mail.setSubject(type +' for ' + AccName);
                mail.setPlainTextBody(EmailBody);
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            if((Rep.dsfs__DocuSign_Routing_Order__c==3) && mapDocuRecMap.containsKey(Rep.dsfs__Parent_Status_Record__c)){
            //if((Rep.dsfs__DocuSign_Routing_Order__c==3) ){
     
                Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                mail1.setToAddresses(sendToEmailList); 
                mail1.setSubject('Business Associate Agreement for '+ AccName );
                mail1.setPlainTextBody('Large Group Sales VP has electronically signed the Business Associate Agreement (BAA).');
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 });
            }
        }           
    
   }
   
   }
   
 }