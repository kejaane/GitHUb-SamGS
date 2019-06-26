/*************************************************************************************************************************************************
 *  Class            : AIA_ZipDocumentsController
 *  Author           : Asif Kutagulla
 *  Version History  : 1.0
 *  Creation         : 01/11/2017
 *  Description      : Controller extension for the Visualforce page AIA_ZipDocuments. Page is used to selectively zip attachments associated with 
 *                     AIA Document records related to a Benefit Design record.
 *                   -------------------------------------------------------------------------
 *  Modification Log:
 * ----------------------------------------------------------------------------------------------------------------------------------------------
 *  Author          Date-Modified      Tag      Description of Change
 * ----------------------------------------------------------------------------------------------------------------------------------------------
 * Asif Kutagulla    01/11/2017                 Initial Creation
 * Asif Kutagulla    05/11/2017        T01      Default version number to 0
 *************************************************************************************************************************************************/
public with sharing class AIA_ZipDocumentsController {
    //public list<AIADocuments> BenDes1lst{get; set;}
    public list<AIA_Document__c> BenDes1lst{get; set;}
    private ApexPages.StandardSetController standardController;
    public String bdRecordName;
    public String benID = ApexPages.currentPage().getParameters().get('id');
    //maximum file size (bytes) that can be zipped due to Visualforce remoting - response size restriction 
    public static final Integer MAXFILESIZE = 4508876;
    
    @testvisible public String zipFileName {get; set;}
    public String zipContent {get; set;}
    
    Public AIA_ZipDocumentsController(ApexPages.StandardController controller){
        //BenDes1lst = new List<AIADocuments>();
        BenDes1lst = new List<AIA_Document__c>();
        AIA_Benefit_Design__c BD = (AIA_Benefit_Design__c)controller.getRecord();
        bdRecordName = BD.Name;
        for(AIA_Document__c aiaDoc: [SELECT Id,Name,(SELECT BodyLength FROM Attachments LIMIT 1),
                                            Zip_File__c,Document_Name__c,Document_Type__c
                                     FROM AIA_Document__c 
                                     WHERE Benefit_Design__c =:benID AND Zip_File__c =: False])
        {
            if(aiaDoc.Attachments[0].BodyLength <= MAXFILESIZE)
            {
                BenDes1lst.add(aiaDoc);   
            }
        }
    }
    
    //method to create attachment, aia document for the zipped file
    public PageReference uploadZip() {
        try {
            // Receive the generated zip file and store it (in this case as a Document)
            if (String.isEmpty(zipFileName) || String.isBlank(zipFileName)) {
                zipFileName = bdRecordName;
            }
            else {
                zipFileName.replace('.', '');
            }
            
            // Create AIA Document Object
            AIA_Document__c doc = new AIA_Document__c();
            doc.Document_Name__c = zipFileName+'.zip';
            doc.Benefit_Design__c = benId;
            doc.Document_Type__c = 'Benefit Design Document';
            doc.Adj_Summ_Revision__c = 0;//T01
            insert doc;
            
            // Add zip file as attachment
            Attachment att = new Attachment();
            att.ParentId = doc.Id;
            att.Name = zipFileName+'.zip';
            att.Body = EncodingUtil.base64Decode(zipContent);
            insert att;
            
            // Redirect to orignal page
            System.debug('+++doc++'+doc);
            
            this.zipFileName = null;
            this.zipContent = null;
            
            PageReference pageRef = new PageReference('/' + doc.Id);
            pageRef.setRedirect(true);
            
            return pageRef;
        }
        catch(Exception ex)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'An error occurred. Please contact your Admin'+ex.getMessage());
            ApexPages.addMessage(myMsg);   
        }
        return null;
    }    
    
    //method called in vf page javascript to retrieve the document content
    @RemoteAction
    public static AttachmentWrapper getAttachment(String aiaDocID) {        
        Attachment att = [SELECT Id, Name, ContentType, Body
                          FROM Attachment
                          WHERE ParentId = :aiaDocID
                          LIMIT 1];        
        AttachmentWrapper attWrapper = new AttachmentWrapper();
        attWrapper.attEncodedBody = EncodingUtil.base64Encode(att.body);
        attWrapper.attName = att.Name;
        return attWrapper;
    }
    
    //wrapper to return document content to the javascript
    public class AttachmentWrapper {
        public String attEncodedBody {get; set;}
        public String attName {get; set;}
    }
    
    //method to redirect page to Benefit Design record
    public PageReference cancelButton()
    {
        String benID =  ApexPages.currentPage().getParameters().get('id');
        PageReference  pg = new PageReference('/'+benID );
        pg.setRedirect(true);
        return pg;
    }
    
}