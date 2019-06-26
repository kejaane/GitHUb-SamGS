/*=========================================================================================
 * Date         : 09/29/166
 * Developer    : Indira Das
 * Purpose      : This class is calle from Attachment trigger handler for attacments 
 *                
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
===============+================+=====+==========================================================
 * 09/29/16    |  Indira Das    |     | updated AIA documant with the attachements details for 
 *                                      Benefit design Form generated from Drawloop   
 * 09/25/17    |  Sajitha Y     | T01 | Upadted code to populate Document Name for GSRF Drawloop - US:74   
 * 10/04/2017  | Goutham Rapolu | T02 | Update BD with count of AIA Document on Drawloop Autogeneration 
 *                                       from BD Send for Approval  
 * 11/07/2017  | satya          | T03 | Added for Docusign to send emails to users whenever docusign
                                       document get signed and to notify user once all signers complete
                                       the signatures,  
 * 12/5/2017   | Satya          | T04 | Added null check, to check if BRF has Broker field value. If it has, 
                                        add it to the email list 
 * 6/6/2019     | Alex          | T05 | Added 
 * 6/6/2019     | Alex          | T05 | Added  2  
 * 6/12/2019     | Alex          | T05 | Added  22                                                                                                          
 *===========+============+================================================================
 */


public class AIADocumentAttachment {

    public static void updateAIADocumentAttachmentID(List<Attachment> attachmentDetails){
        
        List<AIA_Document__c> updateAIAdocs= new List<AIA_Document__c>();
        //Alex add
        List<AIA_Document__c> updateAIAdocs_2= new List<AIA_Document__c>();
        //end Alex add
        List<AIA_Document__c> getAIAdocs= new List<AIA_Document__c>();
        Map<id,AIA_Document__c> getAIAdocMap= new Map<id,AIA_Document__c>();
         Map<id,AIA_Document__c> getAIAdocMapBRF= new Map<id,AIA_Document__c>();
        Map<id,AIA_Document__c> getAIAdocMapGSRF= new Map<id,AIA_Document__c>();
        Map<id,AIA_Document__c> getBAACustomAIAdocMap= new Map<id,AIA_Document__c>();
        Map<id,AIA_Document__c> getBAACustomAIAdocMap1= new Map<id,AIA_Document__c>();
        
        Map<id,Integer> bdAIAdocCountMap = new Map<id,Integer>();
        Map<id,Integer> brfAIAdocCountMap = new Map<id,Integer>();
        Map<id,Integer> gsrfAIAdocCountMap = new Map<id,Integer>();
        Schema.DescribeSObjectResult r = AIA_Document__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        System.debug('Printing --'+keyPrefix );
        Set<String> parentidList= new  Set<String>();
        Set<String> parentBDFormList= new  Set<String>();
        Set<String> parentPPList= new  Set<String>();
        Set<String> parentBDPList= new  Set<String>();
        Set<String> parentGSRFList= new  Set<String>();
        //T03 changes
        Schema.DescribeSObjectResult dr = AIA_Implementation__c.sObjectType.getDescribe();
        String keyPrefixImpl = dr.getKeyPrefix();
        String DocType='';
        //T03 changes ends
        Set<ID> attachmentParentId = new Set<ID>();
        for(Attachment a:attachmentDetails){
            String parentidPrefix= String.valueOf(a.parentid).substring(0,3);
            if(parentidPrefix==keyPrefix && parentidList.contains(a.ParentId)==false){
                parentidList.add(a.ParentId);
            }
            if(((String)a.ParentId).startsWith(keyPrefixImpl)){
                attachmentParentId.add(a.ParentId);
            }
        }
        //String QueryString=querybase2.getSobjectAllFieldsSOQL('AIA_Document__c', 'id in :parentidList');
        String QueryString=querybase2.getSobjectAllFieldsSOQLWithSelectedFileds('AIA_Document__c', 'id in :parentidList','Implementation__r.Docusign_Document_sending_user__c,Implementation__r.DocuSign_Recipient_Email__c,Implementation__r.Benefit_Request_Form__c,Implementation__r.Benefit_Request_Form__r.Broker_Consultant_Name__c,Implementation__r.Benefit_Request_Form__r.Broker_Consultant_Name__r.Email,Implementation__r.Account_Legal_Name__c,Implementation__r.Docusign_Document_sending_user_Name__c,');
        
        getAIAdocs= Database.query(QueryString);
      for(AIA_Document__c ad:getAIAdocs){
          
            //T03 changes
            if( ad.Implementation__c !=null && ad.Document_Type__c == 'Business Associate Agreement (BAA)'){
                getBAACustomAIAdocMap.put(ad.id, ad);
                system.debug('map>>'+getBAACustomAIAdocMap);
            } 
            
            if( ad.Implementation__c !=null && ad.Document_Type__c == 'Custom BAA'){
                getBAACustomAIAdocMap1.put(ad.id, ad);
                system.debug('map>>'+getBAACustomAIAdocMap1);
            }//T03 changes ends
            
           // if( ad.Benefit_Design__c!=null && (ad.Benefit_Design_Form__c!=null || ad.Benefit_Design_Product__c!=null)){
            if( ad.Benefit_Design__c!=null || ad.Benefit_Design_Product__c!=null){
                getAIAdocMap.put(ad.id, ad);
                parentBDFormList.add(ad.Benefit_Design__c);
            }
          else if( ad.Benefit_Request_Form__c!=null && ad.Proposed_Products__c!=null){
                getAIAdocMapBRF.put(ad.id, ad);
               getAIAdocMap.put(ad.id, ad);
                parentPPList.add(ad.Benefit_Request_Form__c);
            }
          //T01 - Start
          else if( ad.Group_Structure_Request_Form__c!=null){
                getAIAdocMapGSRF.put(ad.id, ad);
                getAIAdocMap.put(ad.id, ad);
                parentGSRFList.add(ad.Group_Structure_Request_Form__c);
            }
          // T01 - End
        }
           
        
        
        if(parentBDFormList.size()>0){
           for (AggregateResult results : [select Benefit_Design__c,count(id) aiacount from AIA_Document__c where  Benefit_Design__c in : parentBDFormList group by Benefit_Design__c])  {
                Id bdid=(ID)results.get('Benefit_Design__c');
                Integer cnt=(Integer)results.get('aiacount');
                bdAIAdocCountMap.put(bdid,cnt);
                system.debug('bdid==+cnt'+bdid+'----'+cnt);
            }
        }
        if(parentPPList.size()>0){
           for (AggregateResult results : [select Benefit_Request_Form__c,count(id) aiacount from AIA_Document__c where  Benefit_Request_Form__c in : parentPPList group by Benefit_Request_Form__c])  {
                Id bdid=(ID)results.get('Benefit_Request_Form__c');
                Integer cnt=(Integer)results.get('aiacount');
                brfAIAdocCountMap.put(bdid,cnt);
                system.debug('brfid==+cnt'+bdid+'----'+cnt);
            }
        }
        // T01 - Start
          if(parentGSRFList.size()>0){
           for (AggregateResult results : [select Group_Structure_Request_Form__c,count(id) aiacount from AIA_Document__c where  Group_Structure_Request_Form__c in : parentGSRFList group by Group_Structure_Request_Form__c])  {
                Id bdid=(ID)results.get('Group_Structure_Request_Form__c');
                Integer cnt=(Integer)results.get('aiacount');
                gsrfAIAdocCountMap.put(bdid,cnt);
                system.debug('brfid==+cnt'+bdid+'----'+cnt);
            }
         // T01 - End
        }
        
        
        Map<id,AIA_Implementation__c> implMap = new Map<id,AIA_Implementation__c>([select Account__c,Account_Legal_Name__c,Docusign_Document_sending_user__c,Docusign_Document_sending_user_Name__c,DocuSign_Recipient_Name__c,DocuSign_Recipient_Email__c,Account__r.Name,id,name,Benefit_Request_Form__c,Benefit_Request_Form__r.Broker_Consultant_Name__c,Benefit_Request_Form__r.Broker_Consultant_Name__r.Email,(select id from AIA_Documents__r) from AIA_Implementation__c where id in :attachmentParentId]);
        system.debug('implMap>>>'+implMap);
        List<AIA_Document__c> documentList = new List<AIA_Document__c>();
        
        for(Attachment a:attachmentDetails){
           //T03 changes start
            system.debug('a.id=='+a.id);
            system.debug('keyPrefixImpl=='+keyPrefixImpl);
            system.debug('keyPrefix=='+keyPrefix);
            system.debug('a.ParentId=='+a.ParentId);
            
            //check the current attachment parent record, if it is implementation or AIA Document 
            if((((String)a.ParentId).startsWith(keyPrefixImpl) && implMap.containsKey(a.ParentId)) || (((String)a.ParentId).startsWith(keyPrefix) && getBAACustomAIAdocMap.containsKey(a.ParentId)) || (((String)a.ParentId).startsWith(keyPrefix) && getBAACustomAIAdocMap1.containsKey(a.ParentId)) ){
                system.debug('keyPrefixImpl=='+keyPrefixImpl);
                if(a.Name == 'Business Associate Confirmation Form.pdf'){
                    DocType = 'Business Associate Confirmation (BAC)';
                } else {DocType = 'Business Associate Agreement (BAA)';}
                AIA_Implementation__c imp = implMap.get(a.ParentId);
                AIA_Document__c aiaDoc = getBAACustomAIAdocMap.get(a.ParentId);
                AIA_Document__c aiaDoc1 = getBAACustomAIAdocMap1.get(a.ParentId);
                
                //if attachment parent is implementation, create a new AIA Document record
                if(((String)a.ParentId).startsWith(keyPrefixImpl) && implMap.containsKey(a.ParentId)){
                documentList.add(new AIA_Document__c(Generated_By__c = 'Generated by Doscusign',Document_Type__c =DocType,Category__c = 'Implementation',Document_Status__c = 'Completed',Document_Format__c = 'PDF',Implementation__c = a.ParentId,Account__c = imp.Account__c,Attachment_ID__c = a.id,Document_Name__c=imp.Account__r.Name+' Executed Business Associate Agreement '+System.Today().format()));
                }
                List<String> sendToEmailList = new List<String>();
                List<String> sendToEmailSenderList = new List<String>();
                
                ///get the list of emails from the custom setting
                for(AIA_Docusign_Emaills__c toEmails : AIA_Docusign_Emaills__c.getAll().values()){        
                    sendToEmailList.add(toEmails.EmailId__c);        
                }
                
                //if the parent record of attachment is AIA document, emails will be sent to users with the below subject and email body format
                //if(aiaDoc != null && aiaDoc.Implementation__r.Benefit_Request_Form__c != null && aiaDoc.Implementation__r.Benefit_Request_Form__r.Broker_Consultant_Name__c != null && aiaDoc.Implementation__r.Benefit_Request_Form__r.Broker_Consultant_Name__r.Email != null){
                    //T04 Changes
                    if(aiaDoc != null){     
                    if(aiaDoc.Implementation__r.Benefit_Request_Form__c != null && aiaDoc.Implementation__r.Benefit_Request_Form__r.Broker_Consultant_Name__c != null && aiaDoc.Implementation__r.Benefit_Request_Form__r.Broker_Consultant_Name__r.Email != null){       
                    sendToEmailList.add(aiaDoc.Implementation__r.Benefit_Request_Form__r.Broker_Consultant_Name__r.Email);
                    }//T04 ends
                    sendToEmailSenderList.add(aiaDoc.Implementation__r.DocuSign_Recipient_Email__c);
                    
                    if(DocType == 'Business Associate Agreement (BAA)'){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(sendToEmailList); 
                    mail.setSubject(aiaDoc.Implementation__r.Account_Legal_Name__c+' Executed '+DocType+' '+ System.Today().format());
                    //mail.setPlainTextBody(DocType + ' Signature has been completed');
                    String htmlBody;        
                    htmlBody = 'Attached you will find a copy of the executed '+DocType+ ' for '+aiaDoc.Implementation__r.Account_Legal_Name__c+ ' effective '+System.Today().format() + '.'+'<br/>';       
                    htmlBody += '<br/><br/>Thank you,';   
                    htmlBody += '<br/>'+aiaDoc.Implementation__r.Docusign_Document_sending_user_Name__c;         
                    mail.sethtmlBody(htmlBody); 
                    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                    // Add to attachment file
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(a.Name);
                    efa.setBody(a.Body);
                    fileAttachments.add(efa);
                    mail.setFileAttachments(fileAttachments);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    
                    
                    //this email will be sent submitter as otification of completion
                    Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                    mail1.setToAddresses(sendToEmailSenderList); 
                    mail1.setSubject(DocType+' has been completed.');
                    mail1.setPlainTextBody('The '+DocType+' for '+aiaDoc.Implementation__r.Account_Legal_Name__c+' has been completed.');
                    List<Messaging.Emailfileattachment> fileAttachments1 = new List<Messaging.Emailfileattachment>();
                    // Add to attachment file
                    Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
                    efa1.setFileName(a.Name);
                    efa1.setBody(a.Body);
                    fileAttachments1.add(efa1);
                    mail1.setFileAttachments(fileAttachments1);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 });
                    
                }
                    
                    
                }
                
                if((aiaDoc1 != null) && aiaDoc1.Approval_Status__c == 'Approved'){     
                    if(aiaDoc1.Implementation__r.Benefit_Request_Form__c != null && aiaDoc1.Implementation__r.Benefit_Request_Form__r.Broker_Consultant_Name__c != null && aiaDoc1.Implementation__r.Benefit_Request_Form__r.Broker_Consultant_Name__r.Email != null){       
                    sendToEmailList.add(aiaDoc1.Implementation__r.Benefit_Request_Form__r.Broker_Consultant_Name__r.Email);
                    }//T04 ends
                    sendToEmailSenderList.add(aiaDoc1.Implementation__r.DocuSign_Recipient_Email__c);
                    
                    if(DocType == 'Business Associate Agreement (BAA)'){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(sendToEmailList); 
                    mail.setSubject(aiaDoc1.Implementation__r.Account_Legal_Name__c+' Executed Custom '+DocType+' '+ System.Today().format());
                    //mail.setPlainTextBody(DocType + ' Signature has been completed');
                    String htmlBody;        
                    htmlBody = 'Attached you will find a copy of the executed custom '+DocType+ ' for '+aiaDoc1.Implementation__r.Account_Legal_Name__c+ ' effective '+System.Today().format()+'.' +'<br/>';       
                    htmlBody += '<br/><br/>Thank you,';   
                    htmlBody += '<br/>'+aiaDoc1.Implementation__r.Docusign_Document_sending_user_Name__c;         
                    mail.sethtmlBody(htmlBody); 
                    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                    // Add to attachment file
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(a.Name);
                    efa.setBody(a.Body);
                    fileAttachments.add(efa);
                    mail.setFileAttachments(fileAttachments);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    
                    
                    //this email will be sent submitter as otification of completion
                    Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                    mail1.setToAddresses(sendToEmailSenderList); 
                    mail1.setSubject('Custom '+DocType+' has been completed.');
                    mail1.setPlainTextBody('The custom '+DocType+' for '+aiaDoc1.Implementation__r.Account_Legal_Name__c+' has been completed.');
                    List<Messaging.Emailfileattachment> fileAttachments1 = new List<Messaging.Emailfileattachment>();
                    // Add to attachment file
                    Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
                    efa1.setFileName(a.Name);
                    efa1.setBody(a.Body);
                    fileAttachments1.add(efa1);
                    mail1.setFileAttachments(fileAttachments1);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 });
                    
                }
                    
                    
                }
                
                //if the parent record of attachment is Implementation, emails will be sent to users with the below subject and email body format
                //if(imp != null && imp.Benefit_Request_Form__c != null && imp.Benefit_Request_Form__r.Broker_Consultant_Name__c != null && imp.Benefit_Request_Form__r.Broker_Consultant_Name__r.Email != null){ 
                //T04 changes
                if(imp != null ){ 
                if(imp.Benefit_Request_Form__c != null && imp.Benefit_Request_Form__r.Broker_Consultant_Name__c != null && imp.Benefit_Request_Form__r.Broker_Consultant_Name__r.Email != null){              
                    sendToEmailList.add(imp.Benefit_Request_Form__r.Broker_Consultant_Name__r.Email);
                    } //T04 changes ends
                    sendToEmailSenderList.add(imp.DocuSign_Recipient_Email__c);
                    
                    if(DocType == 'Business Associate Agreement (BAA)'){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(sendToEmailList); 
                    mail.setSubject(imp.Account_Legal_Name__c+' Executed '+DocType+' '+ System.Today().format());
                    //mail.setPlainTextBody(DocType + ' Signature has been completed');
                    String htmlBody;        
                    htmlBody = 'Attached you will find a copy of the executed '+DocType+ ' for '+imp.Account_Legal_Name__c+ ' effective '+System.Today().format()+'.' +'<br/>';       
                    htmlBody += '<br/><br/>Thank you,';   
                    htmlBody += '<br/>'+imp.Docusign_Document_sending_user_Name__c;         
                    mail.sethtmlBody(htmlBody); 
                    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                    // Add to attachment file
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(a.Name);
                    efa.setBody(a.Body);
                    fileAttachments.add(efa);
                    mail.setFileAttachments(fileAttachments);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
                
                if(DocType == 'Business Associate Confirmation (BAC)'){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(sendToEmailList); 
                    mail.setSubject(imp.Account_Legal_Name__c+' Executed '+DocType+' '+ System.Today().format());
                    //mail.setPlainTextBody(imp.Account_Legal_Name__c+' has executed the '+DocType+'. Attached is a copy of the signed document.');
                    String htmlBody;        
                    htmlBody = imp.Account_Legal_Name__c+' has executed the '+DocType+'. Attached is a copy of the signed document.' +'<br/>';       
                    htmlBody += '<br/><br/>Thank you,'; 
                    htmlBody += '<br/>'+imp.Docusign_Document_sending_user_Name__c;       
                    mail.sethtmlBody(htmlBody);
                    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                    // Add to attachment file
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(a.Name);
                    efa.setBody(a.Body);
                    fileAttachments.add(efa);
                    mail.setFileAttachments(fileAttachments);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    
                  }  
                
                //this email will be sent submitter as notification of completion    
                Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                mail1.setToAddresses(sendToEmailSenderList); 
                mail1.setSubject(DocType+' has been completed.');
                mail1.setPlainTextBody('The '+DocType+' for '+imp.Account_Legal_Name__c+' has been completed.');
                List<Messaging.Emailfileattachment> fileAttachments1 = new List<Messaging.Emailfileattachment>();
                // Add to attachment file
                Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
                efa1.setFileName(a.Name);
                efa1.setBody(a.Body);
                fileAttachments1.add(efa1);
                mail1.setFileAttachments(fileAttachments1);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 });
                }
               
            
            } //T03 changes ends
            if(getBAACustomAIAdocMap1.containsKey(a.ParentId)){
                AIA_Document__c aiadoc = getBAACustomAIAdocMap1.get(a.ParentId);
                //system.debug('aiadoc.Implementation__r.Docusign_Document_sending_user__c>>'+aiadoc1.Implementation__r.Docusign_Document_sending_user__c+' ;  '+aiadoc1);
               if(aiadoc.Approval_Status__c == 'Approved'){
                aiadoc.Attachment_ID__c=a.id;
                aiadoc.Document_Format__c='pdf';
                aiadoc.Ready_for_Filenet__c = true;
                aiadoc.Document_Status__c = 'Complete';
                
                update aiadoc;
                }
                         
                
            }
            if( getAIAdocMap.containsKey(a.ParentId)){
                 AIA_Document__c aiadoc= getAIAdocMap.get(a.ParentId);
                    String parentidPrefix= String.valueOf(a.parentid).substring(0,3);
                    if(parentidPrefix==keyPrefix && (aiadoc.Attachment_ID__c==null || aiadoc.Attachment_ID__c=='') ){
                        aiadoc.Attachment_ID__c=a.id;
                         aiadoc.Document_Format__c='docx';
                        aiadoc.Start_Date__c=date.today();
                        if( aiadoc.Benefit_Design_Form__c!=null || aiadoc.Benefit_Design_Product__c!=null|| aiadoc.Benefit_Design__c!=null)
                        {
                            aiadoc.Version__c=bdAIAdocCountMap.get(aiadoc.Benefit_Design__c)+1;
                            aiadoc.Document_Name__c=aiadoc.Account_Legal_Name__c+'_Benefit Design Document_'+a.Name.substringBefore('.')+'_V'+aiadoc.Version__c;
                        }
                        else if(aiadoc.Proposed_Products__c!=null && aiadoc.Benefit_Request_Form__c!=null){
                             aiadoc.Version__c=brfAIAdocCountMap.get(aiadoc.Benefit_Request_Form__c)+1;
                             aiadoc.Document_Name__c=aiadoc.Account_Legal_Name__c+'_Benefit Request Document_'+a.Name.substringBefore('.')+'_V'+aiadoc.Version__c;
                        }
                        // T01 - Start
                        else if(aiadoc.Group_Structure_Request_Form__c!=null){
                             aiadoc.Version__c=gsrfAIAdocCountMap.get(aiadoc.Group_Structure_Request_Form__c)+1;
                             aiadoc.Document_Name__c=aiadoc.Account_Legal_Name__c+'_Group Structure Request Document_'+a.Name.substringBefore('.')+'_V'+aiadoc.Version__c;
                        }
                        // T01 - End
                        updateAIAdocs.add(aiadoc);
                    }
                
            }
        }
     //T02 Start 
     //T02 End  
        if(!updateAIAdocs.ISEMPTY()){
            update updateAIAdocs;
        }
        if(!documentList.isEmpty()){
            insert documentList;
        }
    }
}