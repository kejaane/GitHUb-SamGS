/*=======================================================================================================
 * Date         : 11/22/2017
 * Developer    : Satya Tirumalasetti
 * Purpose      : This will be called from AIA_Docusign_ApprovalResponseHandler whenever Docusign Approval 
 *                Response record got updated                  
 *=======================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date      +  Developer   + Tag + Description
 *===========+==============+============================================================================
 * 11/22/2017|  Satya       |     | Initial Version.
 *===========+==============+=====+======================================================================
*/

public without sharing class AIA_Docusign_ApprovalResponseHelper{

     
      public static void updateDocOnBaaApproval(list<AIA_Docusign_Approval_Response__c> lstAR){
       List<AIA_Docusign_Approval_Response__c> ARrecs = new list<AIA_Docusign_Approval_Response__c>();
       
       //Get the user details
       string Email = UserInfo.getUserEmail();
       string Name  = UserInfo.getName();
       set<id> AIADocID = new set<id>();
       set<string> attStr = new set<string>();
       String Area = 'BAA Approval';
       Integer approvedCount=0;
       Integer rejectedCount=0;
       Integer pendingCount=0;
       
       //Get the Parent record ID's
      for (AIA_Docusign_Approval_Response__c res:lstAR){
      
          AIADocID.add(res.AIA_Document__c);
          
      }
      
         //Get the list of Docusign records 
         ARrecs = [select id,Business_Area_to_be_Approved__c,AIA_Document__c,Response__c from AIA_Docusign_Approval_Response__c
                    where AIA_Document__c in :AIADocID and Business_Area_to_be_Approved__c = :Area];
          system.debug('records>>'+ARrecs);
         Map<id,Integer> mapAppRespPending = new Map<id,Integer>(); 
         Map<id,Integer> mapAppRespAccept = new Map<id,Integer>(); 
         Map<id,Integer> mapAppRespReject = new Map<id,Integer>();
         Map<id,Integer> mapAppRespAll = new Map<id,Integer>();  
         
         //Loop through all the records in the context     
        for(AIA_Docusign_Approval_Response__c rec:ARrecs){
            //if(rec.AIA_Document__c != null && rec.Business_Area_to_be_Approved__c == Area){
            
            //Get the responses and add them to corresponding maps
                 if(rec.Response__c == 'Pending'){
                    //pendingCount += 1;
                    if(!mapAppRespPending.containsKey(rec.AIA_Document__c)){
                        mapAppRespPending.put(rec.AIA_Document__c,1);
                     }else{
                        mapAppRespPending.put(rec.AIA_Document__c,mapAppRespPending.get(rec.AIA_Document__c)+1);                    
                     }
                 }else if(rec.Response__c == 'Accept'){
                    //approvedCount += 1;
                    if(!mapAppRespAccept.containsKey(rec.AIA_Document__c)){
                        mapAppRespAccept.put(rec.AIA_Document__c,1);
                    }else{
                        mapAppRespAccept.put(rec.AIA_Document__c,mapAppRespAccept.get(rec.AIA_Document__c)+1);              
                    }
                 }else if(rec.Response__c == 'Reject'){
                    //rejectedCount += 1;
                    if(!mapAppRespReject.containsKey(rec.AIA_Document__c)){
                        mapAppRespReject.put(rec.AIA_Document__c,1);
                    }else{
                        mapAppRespReject.put(rec.AIA_Document__c,mapAppRespReject.get(rec.AIA_Document__c)+1);              
                    }
                 }
                 
                 //Get all the records in the context and add it to the map. This is used to calculate whether all the responses to the AIA doc are received or not and then update the AIA Doc record
                if(!mapAppRespAll.containsKey(rec.AIA_Document__c)){
                        mapAppRespAll.put(rec.AIA_Document__c,1);
                }else{
                    mapAppRespAll.put(rec.AIA_Document__c,mapAppRespAll.get(rec.AIA_Document__c)+1);                
                }
            //}
        }
         
          list<AIA_Document__c> docList = new list<AIA_Document__c>();
          
          //Get the salesforce org URL
          String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
           
         for(AIA_Document__c aiaDoc : [Select id,name,Approval_Status__c,Document_Status__c,approval_size__c,Docusign_Submitter_Email__c,Docusign_Submitter_Name__c,Document_Type__c from AIA_Document__c where id in:AIADocID]){
              AIA_Document__c docRec = new AIA_Document__c(id=aiaDoc.Id);
              if(string.valueof(aiaDoc.approval_size__c) == '' || aiaDoc.approval_size__c == 0 ||aiaDoc.approval_size__c==null ){
               docRec.approval_size__c= 1;
             }else{docRec.approval_size__c = aiaDoc.approval_size__c+1;}
             //update the AIA record depending upon the responses of the approvers
             if(mapAppRespAccept.containsKey(aiaDoc.id) && mapAppRespAccept.get(aiaDoc.id) > 0 && mapAppRespAccept.get(aiaDoc.id)==mapAppRespAll.get(aiaDoc.id)){
                 
                 //AIA_Document__c docRec = new AIA_Document__c(id=aiaDoc.Id);
                 docRec.Approval_Status__c = 'Approved';
                 //docRec.Document_Status__c = 'Complete';
                 docRec.Docusign_Submitter_Email__c = Email;
                 docRec.Docusign_Submitter_Name__c = Name;
                 //docRec.Document_Type__c = 'Business Associate Agreement (BAA)';
                 
                 //docList.add(docRec);
                 //system.debug('docListinside>>IF>>'+docList);
             }else if(mapAppRespReject.containsKey(aiaDoc.id) && mapAppRespReject.get(aiaDoc.id) > 0 && aiaDoc.approval_size__c >= 7 ){
                 //AIA_Document__c docRec = new AIA_Document__c(id=aiaDoc.Id);
                 docRec.Approval_Status__c = 'Rejected';
                 docRec.Docusign_Submitter_Email__c = Email;
                 docRec.Docusign_Submitter_Name__c = Name;
                 
                 //docList.add(docRec);
                 //system.debug('docListinside>>ELSE>>'+docList);
             }
             docList.add(docRec);
             //system.debug('docListinside>>'+docList);
         }
         system.debug('docList>>'+docList);
         
         // update the AIA Document records
            update docList;
         
      
      }




}