/* =========================================================================================
 * Date         : 08/01/2016
 * Developer    : Laveen Kattela
 * Purpose      : This Apex controller is for Communities_CaseDetailPage(VF Page). This class holds the total functionality of "community case detail Page" body section.
 *                
 *                1.It has logic for "Contact Details" section  -  The Contact person person to whom the case is created  
 *                2.It has logic for "Group / Subscriber Information" section  
 *                3.It has Logic for "Case Details" section 
 *                4.It has Logic to "Add a Comments"
 *                5.It has logic for "Resoulution Reason" section- this section only visible to user when status is "closed" 
 *                6.It has Logic for "Case Timeline" section. 
 *                  
 *=========================================================================================
 * Update History
 *  ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 08/01/16   |  Laveen Kattela    | Initial Version                                          
 *===========+============+================================================================
 */

global without sharing class Communities_CaseDetailPage {
    
    global case myCase {get;set;}
    public List<Attachment> cattList{get;set;}   
    public List<CommentObject> coblist {get;set;}  
    public MyWraper ccobj{get;set;}
    
    public string CaseId;
    public static Attachment Attach{get
    {    if(Attach == null)
            Attach = new Attachment();
        return Attach;
    }set;}
    public static Integer FileSize{get;set;}

    public Communities_CaseDetailPage(){

        myCase  = new Case();
        coblist  = new List<CommentObject>();
        System.debug(Apexpages.currentPage().getParameters().get('id'));
        String cid =Apexpages.currentPage().getParameters().get('id');
    if(string.isNotBlank(cid))
            CaseId = cid;
        List<Case>  CaseList = [SELECT CaseNumber, Subscriber_ID__c ,Communitie_Group_ID__c,
                   ClosedDate,CreatedById,CreatedDate,IsClosed,OwnerId,Priority,Contact.Name,Contact.phone,Contact.Email,
                   Broker_Status__c,Reason,Status,Subject,Type,Group_ID__c,Description,Group__c,
                   Broker_Agent__c,Origin,Resolution_Reason__c,Member_Type__c,Resolution_Reason_Posted_Date__c,
                   Broker_Agent__r.Name,Broker_Agent__r.email,Broker_Agent__r.Phone,Group__r.Group_id__c,
                   (Select Id, ParentId, IsPublished, CommentBody, CreatedBy.name, CreatedDate, SystemModstamp, LastModifiedDate, LastModifiedById, IsDeleted From CaseComments ORDER BY CreatedDate DESC) 
                   from case where id = :cid  ];
                   
                  if(CaseList.size()>0)
                  {
                       myCase  = CaseList[0];
                       ccobj =  new MyWraper();
                       //ccobj.Groupid = CaseList[0].Group__r.Group_id__c;
                       ccobj.Groupid = CaseList[0].Communitie_Group_ID__c;
                       for(CaseComment cc: myCase.CaseComments){
                            CommentObject co = new CommentObject();
                            DateTime dt =Datetime.valueOf(cc.CreatedDate.format('yyyy-MM-dd HH:mm:ss','America/New_York'));
                            co.cd =dt  ;
                            co.cd = cc.CreatedDate;
                            co.cn = cc.CreatedBy.name;
                            co.cb = cc.CommentBody;
                            co.cc = cc;
                            coblist.add(co);
                            
                        }
                   }
                   
           cattList =[select id, name from attachment where parentid  = :cid];
           
        
    }
    
    public PageReference addAttachment(){
        if(string.isNotBlank(CaseId)){
            Case c = [select Id,Status from Case where Id = :CaseId limit 1];
            if(FileSize > 10000000){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The total size of attached file cannot exceed 10MB. ');
                ApexPages.addMessage(myMsg);
                return null;
            }else if(ApexPages.hasMessages(ApexPages.severity.ERROR)) {
                System.debug('The total size of attached file cannot exceed 10MB. Please reduce the file size, abort processing. ApexPages.getMessages() ' + ApexPages.getMessages());            
                return null;
            }
            else if(c.Status != 'Closed'){
                system.debug('In Creating Attachment');
                Attach.OwnerId = UserInfo.getUserId();
                Attach.ParentId = CaseId; // the file is attached to The Above Case
                Attach.IsPrivate = false;
                system.debug('before insert attachment '+Attach);
                try{
                    if(Attach != null)
                        insert Attach;
                        
                }catch(DMLException ex){
                    system.debug(ex+'');
                }
                system.debug('after insert attachment '+Attach);    
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,  'Attachments cannot be added to a closed case'); 
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        return new PageReference('/SaleforceSAMMDBrokerCommunity/apex/Communities_CaseDetailPage?id='+CaseId);
    }
    
    @RemoteAction
    global static void CreateCaseCommnet(String CaseComment,String cid) {
        CaseComment  cc = new CaseComment ();
        cc.ParentId  = cid;
        cc.CommentBody = CaseComment;
        insert cc;
    }
    
    public List<CaseHistory> getHistory(){
        List<CaseHistory> chlist =[SELECT Id, Field,CreatedById , CreatedDate, NewValue,OldValue FROM CaseHistory where CaseId =:myCase.id];
        return chlist;
        
    }
    public List<CaseComment > getCaseComment(){
        List<CaseComment > cclist =[SELECT CommentBody,CreatedById,CreatedBy.name, CreatedDate,IsPublished,ParentId FROM CaseComment WHERE ParentId  =:Apexpages.currentPage().getParameters().get('id') 
                                    ORDER BY CreatedDate DESC ];
        for(CaseComment cc: cclist){
            CommentObject co = new CommentObject();
            co.cd = cc.CreatedDate;
            co.cn = cc.CreatedBy.name;
            co.cb = cc.CommentBody;
            coblist.add(co);
            
        }
        return cclist;  
    }
    public class MyWraper{
        
        public String Groupid{get;set;}
        
    }
    public class CommentObject{
        public DateTime cd{get;set;}
        public String cn{get;set;}
        public String cb{get;set;}
        public CaseComment  cc{get;set;}
    }
}