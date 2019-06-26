/*############################################################################################################################
Class        :   SBU_Attachment_On_Case
Author       :   Ashish Ojha
Created Date :   02/01/2016
Description  :   This class is used to extent trigger on Attachment Object. This Class is used to check if
                 there is an attachement being added to or deleted from a closed case that belongs to the SBU_Broker_Support
                 record type and if so will prevent that from happening. 
                 Method "PreventAddAttachmentOnCase" is used to process the New List of Sobjects passed in from the 
                 AttachmentTriggerHandler Class during Before Insert Trigger Execution
                 Method "PreventDelAttachmentOnCase" is used to process the Old List of Sobjects passed in from the 
                 AttachmentTriggerHandler Class during Before Delete Trigger Execution

*=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 02/01/2016|  AO    | Initial Version                                         
 * 08/10/2016|  AO    | Update the where clause for 3 additional record types       | 
 *===========+============+================================================================
#############################################################################################################################*/


public class SBU_Attachment_On_case{
    
    Public static Void PreventAddAttachmentOnCase(list<attachment> attlist){
        Set<Id> caseIdSet = new Set<Id>();
        Map<Id,Case> mapCase = new Map<Id,Case>();
        // get schima of Case object 
        Schema.DescribeSObjectResult r = Case.sObjectType.getDescribe();
        // assign the prefix of case object to make sure that the parent object we are going against is case
        String keyPrefix = r.getKeyPrefix();
        System.debug(keyPrefix+ 'key prefix');
          //loop through all attachments in the list and gather those whose parent is a case and add it to
          //caseId Set.
        for(Attachment att : attlist){
            if(att.ParentId != null && String.valueOf(att.ParentId).startsWith(keyPrefix)){
        caseIdSet.add(att.ParentId);           
        }
      }
       // Now we go through each item in the Case in that Set and select cases that are Closed and 
       // put it in the case Map Along with the Case Id
        if(caseIdSet != null && caseIdSet.size() > 0){
            for(Case cs : [Select Id from case where status = 'Closed' and ((RecordType.Name = 'SBU Broker Support Internal') or (RecordType.DeveloperName = 'SBU_Group_Case') or (RecordType.DeveloperName = 'SBU_Member_Case') or (RecordType.DeveloperName = 'SBU_Non_Member_Case')) and id in : caseIdSet]){

        mapCase.put(cs.id,cs);
     }
   }
    // now we go thought each of the attachments, see if the parent Case id is in that Map where
    // we had previously stored ids of cases that are closed. And since they are not suppose to be in that map,
    // we throw an error message.
    for(Attachment att : attlist){
        if(att.ParentId != null && String.valueOf(att.ParentId).startsWith(keyPrefix)){
            if(mapCase != null && mapCase.containskey(att.ParentId)){
                att.addError('Attachment,' + att.Name + ' cannot be added because the Case has been Closed.  ');
            }
        }
     }
  }
    
    
    Public static Void PreventDelAttachmentOnCase(list<attachment> attlist){
        Set<Id> caseIdSet = new Set<Id>();
        Map<Id,Case> mapCase = new Map<Id,Case>();
        // get schima of Case object 
        Schema.DescribeSObjectResult r = Case.sObjectType.getDescribe();
        // assign the prefix of case object to make sure that the parent o
        // bject we are going against is case
        String keyPrefix = r.getKeyPrefix();
        System.debug(keyPrefix+ 'key prefix');
        //loop through all attachments in the list and gather those whose parent
        // is a case and add it to caseId Set.  
        for(Attachment att : attlist){
            if(att.ParentId != null && String.valueOf(att.ParentId).startsWith(keyPrefix)){
        caseIdSet.add(att.ParentId);           
        }
      }
        // Now we go through each item in the Case in that Set and select cases that are Closed and 
       // put it in the case Map Along with the Case Id
        if(caseIdSet != null && caseIdSet.size() > 0){
            for(Case cs : [Select Id from case where status = 'Closed' and ((RecordType.Name = 'SBU Broker Support Internal') or (RecordType.DeveloperName = 'SBU_Group_Case') or (RecordType.DeveloperName = 'SBU_Member_Case') or (RecordType.DeveloperName = 'SBU_Non_Member_Case')) and id in : caseIdSet]){

        mapCase.put(cs.id,cs);
    }
  }
    // now we go thought each of the attachments, see if the parent Case id is in that Map where
    // we had previously stored ids of cases that are closed. And since they are not suppose to be in that map,
    // we throw an error message.
    for(Attachment att : attlist){
        if(att.ParentId != null && String.valueOf(att.ParentId).startsWith(keyPrefix)){
            if(mapCase != null && mapCase.containskey(att.ParentId)){
                att.addError('Attachment:, '+ att.Name+ ' cannot be deleted because the Case has been Closed.  ');
           }
        }
      }
    }
  
  }