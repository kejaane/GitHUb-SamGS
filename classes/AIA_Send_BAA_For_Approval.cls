/*=======================================================================================================
 * Date         : 11/22/2017
 * Developer    : Satya Tirumalasetti
 * Purpose      : 
 *=======================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date      +  Developer   + Tag + Description
 *===========+==============+============================================================================
 * 11/22/2017|  Satya       |     | Initial Version.
 *===========+==============+=====+======================================================================
*/

public without sharing class AIA_Send_BAA_For_Approval {
    public ID DocID{get;set;}
    public set<id> DocSet = new set<id>();
    public List<AIA_Document__c> DocObjectList = new List<AIA_Document__c>();
    public Id UserId;
    public string Email;
    
    
    public void sendToApproval(list<AIA_Document__c> lstDocs) {
      
        List<String> sendToEmailList = new List<String>();
        Attachment att = new Attachment();
        UserId = UserInfo.getUserId();
        Email = UserInfo.getUserEmail();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        List<GroupMember> GMList = new List<GroupMember>();
      
        try{
      
            for(AIA_Document__c AIAdoc:lstDocs){
                DocSet.add(AIAdoc.id);
            }
      
            system.debug('doc id >>'+docSet);
            DocObjectList = [select id,Document_Type__c,Implementation__c,Implementation__r.Account_Legal_Name__c,Description__c,Docusign_Sender__c,Attachment_ID__c,Is_sent_for_BAA_Approval__c from AIA_Document__c where id in :DocSet and Document_Type__c='Custom BAA'  AND Is_sent_for_BAA_Approval__c = false];
            system.debug('docList>>'+DocObjectList);
            Map<Id, Attachment> attMap = new Map<Id, Attachment>();
            //Get the attachment associated to the record
            List<Attachment> attList =[select id,Name,Body,ParentId from Attachment where ParentId in :DocObjectList order by createdDate limit 1];
            for(Attachment att1 : attList){
                if(!attMap.containsKey(att1.ParentId))
                    attMap.put(att1.ParentId,att1);
            }   
        
            //to send document for signature, current Document type must be Custom BAA
            //if(DocObject.Document_Type__c == 'Custom BAA')
            if(DocObjectList.size()> 0 ){       
                List<Group> grpList = [select Id,Name from Group where Name= 'AIA BAA'];
                if(grpList.size() > 0){
                    GMList =[select groupId,UserOrGroupId from GroupMember where groupid = :grpList[0].id];
                }
                system.debug('@@ GMList '+GMList );
                set<id> uidlist = new set<id>();
                for(GroupMember GMUid:GMList){
                    uidlist.add(GMUid.UserOrGroupId);
                }
             
             
                List<user> UserList = [select id, name,Email from user where id in:uidlist];
                system.debug('@@ UserList '+UserList );
                if(!UserList.isEmpty()){
                    for(AIA_Document__c aiaDoc : DocObjectList){            
                   
                        att = attMap.get(aiaDoc.id);
                        
                        List<AIA_Docusign_Approval_Response__c> ARList = new List<AIA_Docusign_Approval_Response__c>();
                        for(user U:UserList){
                            sendToEmailList.add(U.Email);
                            AIA_Docusign_Approval_Response__c AR = new AIA_Docusign_Approval_Response__c();
                            AR.Response__c = 'Pending';
                            AR.Business_Area_to_be_Approved__c = 'BAA Approval';
                            AR.AIA_Document__c = aiaDoc.id;
                            AR.OwnerId = U.id;
                            ARList.add(AR);
                        }
                        system.debug('ARList>>'+ARList);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(sendToEmailList); 
                        mail.setSubject(aiaDoc.Implementation__r.Account_Legal_Name__c+' BAA Change Request');
                        String htmlBody;
                        htmlBody = 'Please review the attached customized Business Associate Agreement and approve or reject by clicking the link \n '+sfdcBaseURL+'/'+aiaDoc.id;
                        htmlBody += '<br/><br/>The reason the account is requesting to use the customized document is described below:';
                        htmlBody += '<br/>'+aiaDoc.Description__c; 
                        mail.sethtmlBody(htmlBody); 
                        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                        // Add to attachment file
                        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                        efa.setFileName(att.Name);
                        efa.setBody(att.Body);
                        fileAttachments.add(efa);
                        mail.setFileAttachments(fileAttachments);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        
                        system.debug('ARList>>'+ARList);

                        
                        system.debug('attach record>>'+att);
                        aiaDoc.Is_sent_for_BAA_Approval__c = true;
                        aiaDoc.Docusign_Sender__c =Email;
                        update aiaDoc;
                        
                        if(!ARList.isEmpty())
                            insert ARList;
                    }
                }
            }
        }catch(Exception e){AIA_Utils util=new AIA_Utils();util.logException(e); }
                   
    } 
   }