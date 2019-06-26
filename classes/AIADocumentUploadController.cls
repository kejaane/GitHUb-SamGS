/*********************************************************************************************************  
*  Class            : AIADocumentUploadController
*  Author           : Goutham Rapolu
*  Version History  : 1.0
*  Creation         : 05/31/16
*  Description      : This class will have the logic for upload a document from Account, Opportunity 
*                     PRF, BRF, Implementation, Workplan Assignment. Use with sharing keyord to apply 
*                     all sharing rules and setting for the running user 
**********************************************************************************************************
*  DATE             OWNER          TAG               DESCRIPTION
**********************************************************************************************************
* 01/28/2017 | Rajesh Pennam   | T01 | Updated the class to add the logic so that each parent object
*                                     of AIA Documents will see only the required values of document type
* 03/09/2017 | Rajesh Pennam   | T02 | Added new field Adj Summary Revision # on the layout
* 05/04/2017 | Asif Kutagulla  | T03 | Added code to ensure documents can be uploaded for object BDP & BDF
* 08/24/2017 | Rajesh Pennam   | T04 | Added new field Description
* 08/25/2017 | Debkanti        | T05 | Added logic for GSRF document upload
* 09/25/2017 | Goutham Rapolu  | T06 | Added logic to get Account Executive value from BRF for US171
* 10/30/2017 | Raviteja        | T08 | Added logic for GSRF obj name to render certain field US240
* 01/18/2018 | Debkanti        | T09 | Added Lightning design to page.
* 01/18/2018 | Rajesh Nagandla | T09 | Added Popup display record is save.
* 06/06/2019 | Alex Friedman   | T09 | Added Popup display record is save.
**********************************************************************************************************/

public with sharing class AIADocumentUploadController {
    
    //Variable Declaration 
    public id recordID{get;set;} // Record Id of object where document upload was initiated
    String myIdPrefix; // for Getting prefix from record ID
    public String description {get;set;} // Using In VF page for adding description for file
    public ID attID{get;set;} // for test class only
    public String fileName {get;set;}
    public Blob fileBody {get;set;}
    public Boolean isAttachmentSaved {get;set;}
    public AIA_Document__c fNetAttachment{get;set;}
    public ContentVersion  attObj{get;set;}
    public String fDocNetId{get;set;}    
    public String attchId{get;set;}
    public String displayMessage{get;set;}
    public String Objname{get;set;}
    public Boolean isGSRF {get;set;}
    public Boolean isAttachmentDisable {get;set;}
    /**T09-Start**/
    public String msg{get; set;}
    public Boolean displayPopUp{get; set;}
    /**T09-End**/
    Static final String ERROR_MSG_RESTRICT_UPLOAD = 'Documents cannot be uploaded to Benefit Design, when the status is In Review. Click Cancel to go back.';
    
    /* Rajesh Changes Start Here T01 */
    public String objAPIname ='';
    /* Rajesh Changes End Here */
    
    //constructor initialization
    public AIADocumentUploadController(ApexPages.StandardSetController controller) {
        system.debug('@@ in constructor');
        recordID =  ApexPages.CurrentPage().getParameters().get('id');
        system.debug('@@ in constructor recordID'+recordID);
        //Get prefix from record ID
        myIdPrefix = String.valueOf(recordID).substring(0,3);
        system.debug('@@ in constructor myIdPrefix'+myIdPrefix);
        
        /* Rajesh Changes Start Here T01 */
        //Get Object Name 
        objAPIname= QueryBase2.findObjectNameFromRecordIdPrefix(myIdPrefix);
        system.debug('@@ in objAPIname'+objAPIname);
        /* Rajesh Changes End Here */
        
        
        //T03 Satya To prevent user from inserting new AIA doc when BD status is in "In-Review" 
        isAttachmentDisable = false;
        if(recordID != null && 
           objAPIname != null && 
                   (objAPIname == AIA_Constants.BD)) {
                        AIA_Benefit_Design__c abd = [Select Status__c from AIA_Benefit_Design__c where id =: recordID];
            if(abd.status__c  == 'In Review'){
                isAttachmentDisable = true;
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info, ERROR_MSG_RESTRICT_UPLOAD));
            }
        }
        //Satya changes ends
        
        // Set Attachment Flag to not saved
        isAttachmentSaved = false;
        // Initialize new AIA Document
        fNetAttachment = new AIA_Document__c();
        attObj=new ContentVersion();
        
       //T01
        if(objAPIname == 'Account' ){
            Objname='Account';
        }
        else if(objAPIname == 'Opportunity' ){
           Objname='Opportunity';
        }
        else if(objAPIname == AIA_Constants.BD ){
            Objname='Benefit Design';
        }
        else if(objAPIname == 'AIA_Implementation__c' ){
            Objname='Implementation';
        }
        else if(objAPIname == 'Benfit_Request_Form__c' ){
           Objname='Benefit Request Form';
        }
        else if(objAPIname == 'PRF__c' ){
            Objname='Proposal Request Form';
        }
        else if(objAPIname == 'Proposed_Products__c' ){
            Objname='Proposed Product';
        }
        /*
        else if(objAPIname == 'AIA_Workplan_Assignment__c' ){
            Objname='Workplan Assignment';
        }*/
        else if(objAPIname == 'Case'){
            Objname='Case';
        }
        else if(objAPIname == 'Contract'){
            Objname='Contract';
        }
        //T03-Start
        else if(objAPIname == AIA_Constants.BDF){
            Objname='Benefit Design Form';
        }
        else if(objAPIname == AIA_Constants.BDP){
            Objname='Benefit Design Product';
        }
        //T03-End
        //T05-Start
        else if(objAPIname == 'AIA_Group_Structure_Request_Form__c'){
            Objname='Group Structure Request Form';
        //T08-start
            isGSRF=true;
        //T08 end
        }
        //T05-End
       fNetAttachment.Category__c = Objname;
                    
    }
    /**T09-Start**/
    public PageReference returnToOpp()
    {
        return new PageReference('/' +recordID);
    }
    //Check whether the page is in Classic or lightning
    //US-535
    public Boolean getIsClassic() {
    return (UserInfo.getUiThemeDisplayed() == 'Theme3');
        }
    /**T09-End**/
    /**
    * @Author: Goutham Rapolu
    * @This method - creates a new FileNetDocument record
    * @param - String recordID
    * @Output - Returns object name
    */ 
    private Database.SaveResult saveCustomAttachment() {
        
        Proposed_Products__c objPP;
        PRF__c objPRF;
        Opportunity objOpp;
        Account objAcc;
        Benfit_Request_Form__c objBRF;
        AIA_Benefit_Design__c objBD;
        AIA_Implementation__c objImp;
        contract objCon;
        //T03-Start
        AIA_Benefit_Design_Product__c objBDP;
        AIA_Benefit_Design_Form__c objBDF;
        //T03-End
        //T05-Start
        AIA_Group_Structure_Request_Form__c objGSRF;
        //T05-End
        
        
        list<AIA_Document__c> FNDlist = new list<AIA_Document__c>();
               
        // Based on the object name, query the data from object and checking if how many AIA_Document__c are there.
        if(objAPIname != null && objAPIname == 'PRF__c'){
            if(recordID != null)
                objPRF = [select Id,Opportunity__c,Opportunity__r.accountID FROM PRF__c where id =: recordID  and Opportunity__c != null limit 1];
            FNDlist = [select id from AIA_Document__c where Proposal_Request_Form__c =: recordID];
        }else if(objAPIname != null && objAPIname == 'Opportunity'){
            if(recordID != null)
                objOpp = [select AccountId,Id FROM Opportunity where id =: recordID limit 1];
            FNDlist = [select id from AIA_Document__c where Opportunity__c =: recordID];
        }else if(objAPIname != null && objAPIname == 'Account'){
            if(recordID != null)
                objAcc = [select Id FROM Account where id =: recordID limit 1];
            FNDlist = [select id from AIA_Document__c where Account__c =: recordID];
        }else if(objAPIname != null && objAPIname == 'Benfit_Request_Form__c'){
            if(recordID != null)
                objBRF = [select Id,Opportunity__c,Account__c,Account_Executive_Account_Team__c FROM Benfit_Request_Form__c where id =: recordID limit 1];
            system.debug('objBRF'+objBRF);
            FNDlist = [select id from AIA_Document__c where Benefit_Request_Form__c =: recordID];
            
        }else if(objAPIname != null && objAPIname == 'Proposed_Products__c'){
            if(recordID != null)
                objPP = [select Id, Opportunity__c,Benefit_Request_Form__c, Account__c  FROM Proposed_Products__c where id =: recordID  ];
            system.debug('objPP'+objPP);
            FNDlist = [select id from AIA_Document__c where Proposed_Products__c =: recordID];  
        }else if(objAPIname != null && objAPIname == 'AIA_Benefit_Design__c'){
            if(recordID != null)
                objBD = [select Id, Account_Name__c FROM AIA_Benefit_Design__c where id =: recordID  ];
            system.debug('objBD'+ objBD);
            FNDlist = [select id from AIA_Document__c where Benefit_Design__c =: recordID];
        }else if(objAPIname != null && objAPIname == 'AIA_Implementation__c'){
            if(recordID != null)
                objImp = [select Id, Account__c, Opportunity__c FROM AIA_Implementation__c where id =: recordID];
            system.debug('objImp'+ objImp);
            FNDlist = [select id from AIA_Document__c where Implementation__c =: recordID];
        }       
        else if(objAPIname != null && objAPIname == 'Contract'){
            system.debug('@@ in objCon');
            if(recordID != null)
                objCon = [select AccountId,Id FROM Contract where id =: recordID limit 1];
            FNDlist = [select id from AIA_Document__c where Opportunity__c =: recordID];
        }
        //T03-Start
        else if(objAPIname != null && objAPIname == 'AIA_Benefit_Design_Product__c'){
            system.debug('@@ in objBDP');
            if(recordID != null)
                objBDP = [select Id,Benefit_Design__c,Benefit_Design__r.Account__c,Opportunity__c FROM AIA_Benefit_Design_Product__c where id =: recordID limit 1];
            FNDlist = [select id from AIA_Document__c where Benefit_Design_Product__c =: recordID];
        }
        else if(objAPIname != null && objAPIname == 'AIA_Benefit_Design_Form__c'){
            system.debug('@@ in objBDF');
            if(recordID != null)
                objBDF = [select Id,Benefit_Design__r.Account__c FROM AIA_Benefit_Design_Form__c where id =: recordID limit 1];
            FNDlist = [select id from AIA_Document__c where Benefit_Design_Form__c =: recordID];
        }
        //T03-End
        //T05-Start
         else if(objAPIname != null && objAPIname == 'AIA_Group_Structure_Request_Form__c'){
            system.debug('@@ in objGSRF');
            if(recordID != null)
                objGSRF = [select Id FROM AIA_Group_Structure_Request_Form__c where id =: recordID limit 1];
            FNDlist = [select id from AIA_Document__c where Group_Structure_Request_Form__c =: recordID];
        }
        //T05-End
        
        // Associate with the parent objects
        //Cannot use objAPIname name in source as it will return API name.
        AIA_Document__c fNetDoc = new AIA_Document__c();
        fNetDoc.Document_Name__c = this.fileName;
        if(objAPIname != null && objAPIname == 'PRF__c'){
            fNetDoc.Proposal_Request_Form__c = objPRF.id;
            fNetDoc.Opportunity__c = objPRF.Opportunity__c;
            fNetDoc.Account__c = objPRF.Opportunity__r.accountID;
            fNetDoc.Source__c = 'PRF';
        }else if(objAPIname != null && objAPIname =='Opportunity'){
            fNetDoc.Opportunity__c = objOpp.id;
            fNetDoc.Account__c = objOpp.AccountId;
            fNetDoc.Source__c = 'Opportunity';
            
        }else if(objAPIname != null && objAPIname =='Account'){
            fNetDoc.Account__c = objAcc.Id;
            fNetDoc.Source__c = 'Account';
            
        }else if(objAPIname != null && objAPIname =='Benfit_Request_Form__c'){
            fNetDoc.Benefit_Request_Form__c = objBRF.id;
            system.debug('fNetDoc.Benefit_Request_Form__c'+fNetDoc.Benefit_Request_Form__c+'>>>>>>>>>>>>'+objBRF.id);
            system.debug('objAPIname'+objAPIname);
            fNetDoc.Opportunity__c = objBRF.Opportunity__c;
            fNetDoc.Account__c = objBRF.Account__c;
            fNetDoc.Source__c = 'Benefit Request Form'; 
            fNetDoc.Account_Executive_Account_Team__c = objBRF.Account_Executive_Account_Team__c; //US171 T06
                     
        }else if(objAPIname != null && objAPIname =='Proposed_Products__c'){
            fNetDoc.Proposed_Products__c = objPP.id;
            system.debug('fNetDoc.Proposed_Products__c'+fNetDoc.Proposed_Products__c+'>>>>>>>>>>>>'+objPP.id);
            system.debug('objAPIname'+objAPIname);
            fNetDoc.Benefit_Request_Form__c = objPP.Benefit_Request_Form__c;
            fNetDoc.Opportunity__c = objPP.Opportunity__c;
            fNetDoc.Account__c = objPP.Account__c;
            fNetDoc.Source__c = 'Proposed Products';
            
        }else if(objAPIname != null && objAPIname =='AIA_Benefit_Design__c'){
            fNetDoc.Benefit_Design__c = objBD.id; 
            system.debug('fNetDoc.Benefit_Design__c'+fNetDoc.Benefit_Design__c +'>>>>>>>>>>>>'+ objBD.id);
            system.debug('objAPIname'+objAPIname);
            fNetDoc.Account__c = objBD.Account_Name__c;
            fNetDoc.Source__c = 'Benefit Design';
            
        }else if(objAPIname != null && objAPIname =='AIA_Implementation__c'){
            fNetDoc.Implementation__c = objImp.id; 
            system.debug('fNetDoc.Implementation__c'+fNetDoc.Implementation__c +'>>>>>>>>>>>>'+ objImp.id);
            system.debug('objAPIname'+objAPIname);
            fNetDoc.Account__c = objImp.Account__c;
            fNetDoc.Opportunity__c = objImp.Opportunity__c;
            fNetDoc.Source__c = 'Implementation';
            
        }
        else if(objAPIname != null && objAPIname =='Contract'){
            fNetDoc.contract__c = objCon.id; 
            system.debug('fNetDoc.Benefit_Design__c'+fNetDoc.Benefit_Design__c +'>>>>>>>>>>>>'+ objCon.id);
            system.debug('objAPIname'+objAPIname);
            fNetDoc.Account__c = objCon.AccountId;
            fNetDoc.Source__c = 'Contract';
            system.debug('@@ fNetDoc'+fNetDoc);
            
        }
        //T03-Start
        else if(objAPIname != null && objAPIname =='AIA_Benefit_Design_Product__c'){
            fNetDoc.Benefit_Design_Product__c = objBDP.id; 
            fNetDoc.Benefit_Design__c = objBDP.Benefit_Design__c; 
            system.debug('fNetDoc.Benefit_Design_Product__c'+fNetDoc.Benefit_Design_Product__c +'>>>>>>>>>>>>'+ objBDP.id);
            system.debug('objAPIname'+objAPIname);
            fNetDoc.Account__c = objBDP.Benefit_Design__r.Account__c;
            fNetDoc.Source__c = 'Benefit Design Product';
            system.debug('@@ fNetDoc'+fNetDoc);
            
        }
        else if(objAPIname != null && objAPIname =='AIA_Benefit_Design_Form__c'){
            fNetDoc.Benefit_Design_Form__c = objBDF.id; 
            system.debug('fNetDoc.Benefit_Design_Form__c'+fNetDoc.Benefit_Design_Form__c +'>>>>>>>>>>>>'+ objBDF.id);
            system.debug('objAPIname'+objAPIname);
            fNetDoc.Account__c = objBDF.Benefit_Design__r.Account__c;
            fNetDoc.Source__c = 'Benefit Design Form';
            system.debug('@@ fNetDoc'+fNetDoc);
            
        }
        //T03-End
        //T05-Start
        else if(objAPIname != null && objAPIname =='AIA_Group_Structure_Request_Form__c'){
            fNetDoc.Group_Structure_Request_Form__c = objGSRF.id; 
            system.debug('fNetDoc.Group_Structure_Request_Form__c'+fNetDoc.Group_Structure_Request_Form__c +'>>>>>>>>>>>>'+ objGSRF.id);
            system.debug('objAPIname'+objAPIname);
            //fNetDoc.Account__c = objCon.AccountId;
            fNetDoc.Source__c = 'Group Structure Request Form';
            system.debug('@@ fNetDoc'+fNetDoc);
            
        }
        //T05-End
        
        if(FNDlist!= null && FNDlist.size()>0){
            fNetDoc.Version__c = FNDlist.size()+1;
        }else{
            fNetDoc.Version__c =1;
        }
        system.debug('-------------fNetDoc.Category__c-----------'+Objname);
        fNetDoc.Document_Status__c = fNetAttachment.Document_Status__c;
        fNetDoc.Document_Type__c = fNetAttachment.Document_Type__c;
        fNetDoc.Active__c = fNetAttachment.Active__c;
        fNetDoc.Category__c = Objname;//T01 Added new field
        fNetDoc.Start_Date__c = fNetAttachment.Start_Date__c;
        fNetDoc.End_Date__c = fNetAttachment.End_Date__c;
        fNetDoc.Approval_Status__c =fNetAttachment.Approval_Status__c;
        IF(fNetDoc.Approval_Status__c == '' || fNetDoc.Approval_Status__c == null ){
        fNetDoc.Approval_Status__c = 'Not Started';
        }
        fNetDoc.Adj_Summ_Revision__c = fNetAttachment.Adj_Summ_Revision__c;// T02 Rajesh Added new field
        fNetDoc.Description__c = fNetAttachment.Description__c; //T04 Rajesh Added new field
        
        if(fNetDoc.Document_Type__c == 'Marked Up Benefit Summary') {
        if(objPP!=NULL) {
            objPP.Custom_New__c = 'Custom';
            }
        }
        if(objPP!=NULL) {
            update objPP;   
        }
        system.debug('fNetDoc'+ fNetDoc);
         
        // fill out cust obj fields
        Database.SaveResult dbsr=Database.insert(fNetDoc,true);
        system.debug('@@ dbsr.getId() @@'+ dbsr.getId());
        
        fDocNetId=String.valueOf(dbsr.getId());
        return dbsr;
    }
    
    // create an actual Attachment record
    public PageReference saveStandardAttachment() {
        String passedParam1=attchId;
        System.debug('inside saveStandardAttachment--->'+fDocNetId);
        try{
            if (String.isBlank(passedParam1)) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                           'Could not save attachment.'));
                system.debug('Test 2');           
                return null;
            } else {
                system.debug('Test 3'+fileName);
                // update the FilenetDocument Object record with some attachment info
                fNetAttachment = new AIA_Document__c();
                // attID = attachmentResult.getId();
                attID=ID.valueOf(passedParam1);
                //T01 Added Category & Adj Summary Revision#. T03 added Benefit_Design_Product__c,Benefit_Design_Form__c to the query
                //T04 Added new field Description to the query
                //T05 Added new field Group_Structure_Request_Form__c to query
                fNetAttachment = [select id,account__r.Account_Legal_Name__c,Document_Name__c,Document_Type__c,Adj_Summ_Revision__c,Category__c,Active__c,End_Date__c,
                                         Version__c,Attachment_ID__c,Approval_Status__c,Document_Status__c,Benefit_Request_Form__c,Opportunity__c,Account__c,Source__c,
                                         Benefit_Design_Product__c,Benefit_Design_Form__c,Start_Date__c,Document_Format__c,Description__c,Group_Structure_Request_Form__c
                                  from AIA_Document__c 
                                  where id = :fDocNetId 
                                  limit 1];
                if(fNetAttachment.Approval_Status__c=='' || fNetAttachment.Approval_Status__c==null){
                    fNetAttachment.Approval_Status__c='Not Started';
                }
                system.debug(fNetAttachment+'fNetAttachment');
                String str = fNetAttachment.Document_Name__c;
                list<string> fileExtension = new list<string>();
                fileExtension = str.split('[.]');
                system.debug(fileExtension[0]+'OOOOOO'+fileExtension[1]);
                string truncatedLegalName;
                if(fNetAttachment.account__r.Account_Legal_Name__c.length()<=100)
                {
                    truncatedLegalName=fNetAttachment.account__r.Account_Legal_Name__c;
                }
                else{
                    truncatedLegalName=fNetAttachment.account__r.Account_Legal_Name__c.substring(0,100);
                }
                fNetAttachment.Document_Name__c = truncatedLegalName+'_'+fNetAttachment.Document_Type__c+'_'+fileExtension[0]+'_'+fNetAttachment.Version__c;
                fNetAttachment.Attachment_ID__c = ID.valueOf(passedParam1);//attachmentResult.getId();
                fNetAttachment.Document_Format__c = fileExtension[1];
                
                update fNetAttachment;
                system.debug('Update fNetAttachment'+ fNetAttachment);
            }
            
        } catch (Exception e) {
            System.debug('Excepiton is --->'+e.getMessage());
            ApexPages.AddMessages(e);
            system.debug('Test 4');
            fNetAttachment = new AIA_Document__c();
            //T01 Added Category and Adj Summary Revision#. T03 added Benefit_Design_Product__c,Benefit_Design_Form__c to the query
            //T04 Added new field Description to the query
            //T05 Added new field Group_Structure_Request_Form__c to query
            if(String.isNotBlank(fDocNetId)){
                fNetAttachment = [select id,account__r.Account_Legal_Name__c,Document_Name__c,Document_Type__c,Adj_Summ_Revision__c,Category__c,Active__c,End_Date__c,
                                         Version__c,Attachment_ID__c,Approval_Status__c,Document_Status__c,Benefit_Request_Form__c,Opportunity__c,Account__c,Source__c,
                                         Benefit_Design_Product__c,Start_Date__c,Document_Format__c,Benefit_Design_Form__c,Description__c,Group_Structure_Request_Form__c
                                  from AIA_Document__c 
                                  where id = :fDocNetId 
                                  limit 1];
                system.debug(fNetAttachment+'fNetAttachment');
            }
            if(fNetAttachment != null)
                //delete fNetAttachment;
                return null;
        }
        return null;
    }
    
    /**
    * Called when the user clicks the attach button on the visualforce.    
    * Clicking the attach button does the following:
    * 1. Insert new AIA_Document__c record
    * 2. Insert new Attachment with the new AIA_Document__c record as parent
    * 3. Update the AIA_Document__c record with the ID of the new Attachment
    **/
    
    // Attach Button for Classic
    public PageReference processUpload() {
        Database.SaveResult attachmentResult; // insert the attahcment
        Database.SaveResult customAttachmentResult; // insert AIA_Document__c record
         displayMessage='';    
        try{
           customAttachmentResult = saveCustomAttachment();    
            if(!customAttachmentResult.isSuccess())
            {
                pagereference p = apexpages.Currentpage();
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'dml excpeion'));                
                return p;
            }
        }
        catch(DMLException dmlex){
            displayMessage=dmlex.getDmlMessage(0);
            System.debug('---Line Number---'+dmlex.getLineNumber()+'---error message---'+dmlex.getDmlMessage(0));
            
             pagereference p = apexpages.Currentpage();
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.FATAL,dmlex.getDmlMessage(0)));                
            return null;   
        }
        
        if (customAttachmentResult == null || customAttachmentResult.isSuccess()) {
            return null;
        }
        return null;
    }
    /**T09-Start**/
    // Attach Button for lightning
    public void liprocessUpload() {
       msg = 'Document Saved';
       displayPopUp = true;
    }
    /**T09-End**/
    // Cancel Button
    public pageReference cancelButton(){
        pageReference pg = new pageReference('/'+recordID);
        pg.setRedirect(true);
        return pg;
    }
    
}