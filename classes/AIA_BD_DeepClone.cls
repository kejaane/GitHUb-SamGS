/*=================================================================================================================
* Date         : 02/22/2017
* Developer    : Sree Harsha
* Purpose      : AIA_BD_DeepClone to Clone Benefit Design and all the selected Benefit Design Products (BDP) and related AIA Documents
*                    Selected BD Products will be cloned along with Grouper > Benefit > Limitations/CommentCode. 
*                    BDP clone will clone User Defined/Customized values from Source BDP and other values from Setup Plan.
*                    applicable for Cost Share, Benefit, CommentCode.
*=================================================================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 03/08/2017 | Sree Harsha    |     |  Initial Version                                         
* 04/04/2017 | Sree Harsha    | T01 |  Added method getBDForClone which calls in constructor and throws an error if 
*                                      Implementation already has a Benefit Design. If not, It pulls the Implementation 
*                                      through BRF Source_Benefit_Request_Form__c Source_Benefit_Request_Form__c and 
*                                      return list of implementation based on Account and matches with curent implementation
*                                      then It will select BD based on approved date. 
* 04/10/2017 | Sree Harsha    | T02 | Changes made for user story B-03789. Assigning values to some fields from
*                                     setup objects or runtime objects based on ifcustomized field.
* 04/14/2017 | Sree Harsha    | T03 | Implemented Logic for copying AIA Documents for user story B-03790
* 12/05/2017 | Goutham Rapolu | T04 | If Product is Risk & Non-Grandfathered then show only 5Tier for Drug.
* 04/02/2018 | Raviteja V     | T05 | Added clone functionality to Carefirst Private Exchange BD products
* 02/05/2018 | Sajitha Y      | T06 | Commented getPCSdata() method to stop call to PCS when BD is cloning as part of US1650
                                      and changed error message No Benefit Information is available for the selected 
                                      Plan in PCS to No Benefit Information is available for the selected Plan
* 11/28/2018 | Gayathri		  | T07 | Replaced Nasco Benefit Coder Approver with Benefit Tester Approver as part of US1730
* 12/04/2018 | Chaithra 	  | T08 | Replaced Ancillary Analyst Approver with Vision Analyst approver and Pharmacy Operation Approver as part of US1702
*===========+============+========================================================================================
*/

public with sharing class AIA_BD_DeepClone {
    // initializing variables
    public list<AIA_Benefit_Design_Product__c> BDPList{get;set;}
    public AIA_Benefit_Design__c newBD{set; get;}
    public list<AIA_Benefit_Design__c> bdList{set; get;}
    public list<AIA_Document__c> AIADoc{get; set;}
    public transient Set<String> CopayIDs=new Set<String>();
    public String impID;
    public String impIDForClone;
    public List<AIADocumentWrapper> AIA_DocWrapList{get; set;}
    public list<AIA_Document__c> selAIA_DocList{get;set;}
    public list<AIA_Benefit_Design_Product__c> selBDPList{get;set;}
    private ApexPages.StandardSetController standardController;
    public List<BDPWrapper> lstBDPWrapper{get; set;}
    public Boolean IsBrfPanel{get;set;}
    public Boolean IsPPPanel{get;set;}
    public Boolean IsSummaryPanel{get;set;}
    public list<AIA_Benefit_Design_Product__c> parentBDPList{get;set;}
    public list<AIA_Benefit_Design_Product__c> parentBDPList2{get;set;}
    public List<AIA_Benefit_Design_Product__c> bdpListToShow{get;set;}
    public list<AIA_Benefit_Design_Form__c>  listBDFToshow{get;set;}
    public AIA_Benefit_SummaryController aiabenfSummary = new AIA_Benefit_SummaryController();
    public Map<String, CopayTypeWrapper> copayBenMap = new Map<string, CopayTypeWrapper>();
    public Map<String,AIA_Plan_Benefits__c> mapIDTobenefit = new Map<String,AIA_Plan_Benefits__c>();  
    public Map<String,string> costShareOldValMap=new map <String,string>();
    public Map<String,AIA_Plan_Benefits__c> maplst = new Map<String,AIA_Plan_Benefits__c>();
    public Map<String,List<Limitations__c>> ParentBenLimitationMan = new   Map<String,List<Limitations__c>>();
    public Map<String,List<Limitations__c>> ParentBenLimitationLimit = new   Map<String,List<Limitations__c>>();
  //  public Map<String,Set<String>> benLimitsAllMap = new  Map<String,Set<String>>(); 
    public Map<String,AIA_Benefit_Design_Product__c > mapbenefitNameToBDPID = new Map<String,AIA_Benefit_Design_Product__c >();
    public Set<String> PlanLimitIDs=new Set<String>();
    public AIA_Benefit_Design__c bd{get;set;}
    public String bdId;  
    public string pagetitle{get;set;} 
    public Boolean isDataAvailable{get;set;}
    public Set<string> erroMessages{get;set;}
    public string BRFEffDate{get;set;}
    public list<AIA_Implementation__c> aia_ImpList{get;set;}
    public Boolean isShowNext{get;set;}
    Public string summaryPlanId{get;set;}
    public Map<string,List<Limitations__c>> BeneNameLimitationMap = new Map<string,List<Limitations__c>>();
    public Map<string,List<Limitations__c>> mapBenNamewithCode = new Map<string,List<Limitations__c>>();
    public Map<string,Limitations__c> mapBenNamewithType = new Map<string,Limitations__c>();
    private Map<Id,AIA_Benefit_Design_Product__c> mapOldBDPIdToOldBDPId =new Map<Id,AIA_Benefit_Design_Product__c>();
    private Boolean IsAIAInsertDone{get;set;}
    private Map<String,String> mapBDPIdToPlanId = new Map<String,String>();
    public boolean IsRiskNonGrandfathered{get;set;}//T04
    public boolean IsGrandfathered{get;set;}
    public Date NewBenefitEffectiveDate{get; set;}
    public Date OppEffDate{get;Set;}
    public boolean isClassic {get;set;}
    public Boolean displayPopUp{get; set;} //T03
    Public string BDSource{get;set;} //T02 
    Public string RelatedBRF{get;set;} //T02 
    Public string ImplementationBD{get;set;} //T02 
    Public string BDAccount{get;set;} //T02 
    Public string BDParentAccount{get;set;} //T02 


      
    //Calling constructor
    Public AIA_BD_DeepClone(ApexPages.StandardController controller){
        isClassic = AIA_Utils.isClassic();

        IsRiskNonGrandfathered = false;//T04
        IsGrandfathered = false;
        pagetitle = 'Select AIA Documents to be Cloned';
        isShowNext = false;
        IsAIAInsertDone = false;
        mapBDPIdToPlanId = new Map<String,String>();
        impID = ApexPages.currentPage().getParameters().get('id');
        system.debug('impID'+impID);
        newBD = new AIA_Benefit_Design__c();
        bd = new AIA_Benefit_Design__c();
        if(!String.isBlank(impID)){
            getBDForClone(impID);
        }
        
    }  
    
     // T03 Starts Here
       public void cancelBDP()
    {
         
        displayPopUp = true;
        
   
    }
     
 public PageReference returnToBDP()
    {
       AIA_BD_DeepCloneHelper aiaBDDeepHelper = new AIA_BD_DeepCloneHelper();
        aiaBDDeepHelper.cancelButton(newBD);
        String benID =  ApexPages.currentPage().getParameters().get('id');
        PageReference  pg = new PageReference('/'+benID);
        pg.setRedirect(true);
        return pg;       
    }
    
    
    
    
    
    /**
    * @Author: Sree Harsha 
    * @This Method is called from VF page to show related document for BD
    * @param -  list<AIADocumentWrapper> 
    * @Output - Return AIA_DocWrapList list
    */
    
    public list<AIADocumentWrapper> getRelatedAIADocument(){    
        bdId = bd.Source_BD__c;
        list<AIA_Document__c> AIADoc = new list<AIA_Document__c>();
        list<AIA_Benefit_Design__c> BDlist = new list<AIA_Benefit_Design__c>();
        set<id> BDPIDForDoc = new set<id>();
        system.debug('bdID>>'+bdID);
        //Query all AIA Document related to Source BD - T03
        if(bdID!= null){
          BDlist = [select id,Account__c,Account__r.Name,(select id from BD_Products__r) from AIA_Benefit_Design__c where id =:bdId];
          system.debug('BDlist >>>>>'+ BDlist+'BDlist[0].BD_Products__r'+BDlist[0].BD_Products__r);
          if(BDlist != null && BDlist.size()>0 && BDlist[0].BD_Products__r.size()>0){
            for(AIA_Benefit_Design_Product__c BDP:BDlist[0].BD_Products__r){
              BDPIDForDoc.add(BDP.id);
            } 
              BDAccount = bdList[0].Account__r.Name;
              //BDSource = bd.Source_BD__c;
 
          }
          
        }
        system.debug('bdId>>>DOC'+bdId);
        system.debug('BDPIDForDoc>>>>>'+BDPIDForDoc);
        if(bdId!='' && bdId!=null){
            String QueryString2=QueryBase2.getSobjectAllFieldsSOQL('AIA_Document__c', 'Benefit_Design__c =:bdId');// OR Benefit_Design_Product__c =:BDPIDForDoc'
            AIADoc = Database.query(QueryString2);
        }
        system.debug('AIADoc>>'+AIADoc);
        if(AIADoc!= null && AIADoc.size()>0){
            AIA_DocWrapList = new list<AIADocumentWrapper>();
            for(AIA_Document__c AIADocument: AIADoc){
                AIA_DocWrapList.add(new AIADocumentWrapper(AIADocument,false)); // Add AIA to list
            }
            
        }
        return AIA_DocWrapList;
    }
    
    /**
    * @Author: Sree Harsha 
    * @This Method is called from VF page and get all selected AIA Dcouments from AIA_BRF_DeepClone VF page.
    * @param -  
    * @Output - 
    */ 
    public void getSelectedAIADoc(){    
        
        selAIA_DocList = new list<AIA_Document__c>();
        if(AIA_DocWrapList != NULL && AIA_DocWrapList.size()>0){
            for(AIADocumentWrapper wrapper: AIA_DocWrapList){
                if(wrapper.checked){
                    selAIA_DocList.add(wrapper.aiaDoc);
                }
            }
        }  
    }
    
    /**
    * @Author: Sree Harsha 
    * @It is a wrapper class and used to store AIA_Document__c data
    * @param -  
    * @Output - 
    */   
    public class AIADocumentWrapper {
        public AIA_Document__c aiaDoc{get; set;}
        public Boolean checked {get; set;}
        public AIADocumentWrapper(AIA_Document__c aiaDoc,Boolean checked){
            this.aiaDoc = aiaDoc;
            this.checked = checked;
        }
    }
    
    /**
    * @Author: Sree Harsha 
    * @It is a wrapper class and used to store AIA_Benefit_Design_Product__c data
    * @param -  
    * @Output - 
    */   
    
    public class BDPWrapper{
        public AIA_Benefit_Design_Product__c bdp{get; set;}
        public Boolean checked {get; set;}
        public BDPWrapper(AIA_Benefit_Design_Product__c bdp,Boolean checked){
            this.bdp = bdp;
            this.checked = checked;
        }
    }
    
    /**
    * @Author: Sree Harsha 
    * @This Method is called from VF page and Method to Roll Back the operation when clicked Cancel
    * @param -  PageReference
    * @Output - 
    */ 
    public void cancelButton()
    {
        
         displayPOPUP = false;
    }
    
    /**
    * @Author: Sree Harsha 
    * @This Method is called from VF page and creating the BD,BDP, grouper,benefit and code comments
    * @param -  PageReference
    * @Output - 
    */ 
    
    public PageReference next(){ 
        if(IsBrfPanel == true)
        { 
            pagetitle ='Select Benefit Design Product to cloned';
            bdId = bd.Source_BD__c;
            newBD.Source_BD__c = bdId;
            newBD.Status__c = 'In Progress';
            //newBD.Ancillary_Tech_Response_Date__c = null; T08
            newBD.Vision_Analyst_Response_Date__c=null;
            newBD.Pharmacy_Operations_Response_Date__c=null;
            newBD.QA_Auditor_Initial_Notification__c = false;
            newBD.QA_Auditor_Final_Notification__c = false;
            if(impID != null && impID != '')
                newBd.Implementation__c = impID;
            if(bd != null && bd.Account__c != null)
                newBd.Account__c = bd.Account__c;
            newBD.Related_BRF__c = aia_ImpList[0].Benefit_Request_Form__r.id;
            
            
            
            //check if custom setting has this value
            AIA_Config__c runMethod = AIA_Config__c.getInstance('BDTHelper.createBenefitDesignProduct');
            //if value found and is allowed to run, then execute the method
            if(runMethod != null && runMethod.run__c){
                runMethod.run__c = false;
                update runMethod;
                upsert newBD;
            }
            if(runMethod != null && runMethod.run__c == false){
                runMethod.run__c = true;
                update runMethod;
            }
            
            // Query all filed and clone BDF  
            listBDFToshow = new list<AIA_Benefit_Design_Form__c>();
            list<AIA_Benefit_Design_Form__c>  lstBDF = new list<AIA_Benefit_Design_Form__c>();
            list<AIA_Benefit_Design_Form__c>  updateListBDF = new list<AIA_Benefit_Design_Form__c>();
            String BDFQueryString=QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefit_Design_Form__c','Benefit_Design__c =:bdId limit 1000');
            lstBDF=database.query(BDFQueryString);
            
            if(lstBDF != null && lstBDF.size()>0){
                for(AIA_Benefit_Design_Form__c ADF : lstBDF){
                    AIA_Benefit_Design_Form__c objADF = new AIA_Benefit_Design_Form__c();
                    objADF = ADF.clone(false,true);
                    objADF.Benefit_Design__c = newBd.id;
                    listBDFToshow.add(objADF);
                }
            }
            system.debug('listBDFToshow'+listBDFToshow.size());
            if(listBDFToshow != null && listBDFToshow.size()>0){
                insert listBDFToshow;
                listBDFToshow = [SELECT Id,name,Account_Legal_Name__c,Benefit_Design__c,recordtype.name,RecordTypeId FROM AIA_Benefit_Design_Form__c WHERE Benefit_Design__c =:BDID];
            }
             selAIA_DocList = new list<AIA_Document__c>();
            Set<String> setAIADocIds = new Set<String>();
            if(AIA_DocWrapList != NULL && AIA_DocWrapList.size()>0){
              for(AIADocumentWrapper wrapper: AIA_DocWrapList){
                  if(wrapper.checked){
                      AIA_Document__c AIADocument = wrapper.aiaDoc.clone(false);
                      AIADocument.Benefit_Design__c = newBD.id;                     
                      AIADocument.Attachment_ID__c = null;
                      AIADocument.ClonedFromAIADocID__c = wrapper.aiaDoc.Id;
                      AIADocument.ClonedFromAIADocName__c = wrapper.aiaDoc.Name;
                      selAIA_DocList.add(AIADocument);
                      setAIADocIds.add(wrapper.aiaDoc.id); 
                  }
              }
          }
          if(selAIA_DocList!=null && selAIA_DocList.size()>0){
              upsert selAIA_DocList;
              map<string,AIA_Document__c> attmap = new map<string,AIA_Document__c>();
              for (AIA_Document__c rec:selAIA_DocList){               
                  attmap.put(rec.ClonedFromAIADocID__c,rec);
              } 
              list<Attachment> attList = new list<Attachment>([select Id, name,body,parentId from attachment where parentId=:setAIADocIds limit 100]);
              List<Attachment> newattlist = new List<Attachment>(); 
              for(Attachment attrec:attList){
                  Attachment attachment = new Attachment();
                  attachment = attrec.clone(false);    
                  if(attmap != null && attmap.containsKey(attrec.parentId)){                      
                    attachment.ParentId = attmap.get(attrec.parentId).id; 
                  }             
                  newattlist.add(attachment);
              }
              
              upsert newattlist; 
              for(Attachment attParent:newattlist){
                  for(AIA_Document__c aia:selAIA_DocList){
                      if(aia.Id == attParent.ParentId){
                          aia.Attachment_ID__c = attParent.Id;
                      }                  
                  }   
              }
              upsert selAIA_DocList;                         
          }
        }
        else if(IsPPPanel == true)
        {
            pagetitle ='Review Product and Document Selections';
            //cloneSelRecords(lstBDPWrapper,newBD.id);
        }
        else if(IsSummaryPanel == true)
        { 
            pagetitle ='Summary of Selected Benefit Design product';
            return new PageReference('/'+newBD.id);
        }
        
        if(IsBrfPanel == true && IsPPPanel == false && IsSummaryPanel == false  )
        {
            IsPPPanel = true;
            IsBrfPanel = false;
            IsSummaryPanel = false;
        }
        else if(IsBrfPanel == false && IsPPPanel == true && IsSummaryPanel == false)
        {
            IsBrfPanel = false;
            IsPPPanel = false;
            IsSummaryPanel = true;
        }
        return null;
    }
    
    /**
    * @Author: Sree Harsha 
    * @This Method is called from VF page and it is used to go back in previous page
    * @param -  Void
    * @Output - 
    */
    public void back()
    {
        if(IsBrfPanel == false && IsPPPanel == false && IsSummaryPanel == true )
        {
            IsPPPanel = true;
            IsBrfPanel = false;
            IsSummaryPanel = false;
        }        
    }
    
    /**
    * @Author: Sree Harsha 
    * @This Method is called from VF page and it is used to delete BD,BDP and documents
    * @param -  Void
    * @Output - 
    */
    public void deleteBDP()
    {
        string BDPID= Apexpages.currentPage().getParameters().get('BDPID');
        string BDPName= Apexpages.currentPage().getParameters().get('BDPName');
        Set<ID> bpdIds = new Set<ID>();
        AIA_Benefit_Design_Product__c bdToDelete = new AIA_Benefit_Design_Product__c();
        List<AIA_Benefit_Design_Product__c> RelatedpptoDelete = new List<AIA_Benefit_Design_Product__c>();
        //T06 - Start  Commented error message to hide from user as per US1650
       /* if(erroMessages != null && erroMessages.size()>0)
        {
            for(string strerror: erroMessages)
            {
                if(strerror != BDPName)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, strerror + ' - No Benefit Information is available for the selected Plan');                
                    ApexPages.addMessage(myMsg);
                }
                else if (strerror == BDPName)
                {
                    erroMessages.remove(BDPName);
                }
            }
        } */
        //T06 - End
        system.debug('====mapOldBDPIdToOldBDPId=========' + mapOldBDPIdToOldBDPId);
        system.debug('====BDPID=========' + BDPID);
         if(mapOldBDPIdToOldBDPId!= null && mapOldBDPIdToOldBDPId.ContainsKey(BDPID))
        {
            bdToDelete = mapOldBDPIdToOldBDPId.get(BDPID);
            bpdIds.add(bdToDelete.id); 
        }
        
        
        List<AIA_Benefit_Design_Product__c> selPPList = new List<AIA_Benefit_Design_Product__c>();
        system.debug('====lstBDPWrapper=========' + lstBDPWrapper);
        for(BDPWrapper wrapper: lstBDPWrapper){
                  if(wrapper.checked)
                  {
                      selPPList.add(wrapper.bdp);
                  }
              }
        system.debug('@@selPPList:::'+selPPList);
        List<AIA_Benefit_Design_Product__c> finalselPPList = new List<AIA_Benefit_Design_Product__c>();
         RelatedpptoDelete = [select id, related_medical_product__c,Cloned_From_Name__c,Product_Category__c,Custom_New__c,Product_Parent_Name__c,Cloned_From__c,Benefit_Design__c
                              from AIA_Benefit_Design_Product__c 
                              where Benefit_Design__c  =:newBD.id
                              and related_medical_product__c =:bdToDelete.id ];
        system.debug('@@RelatedpptoDelete:::'+RelatedpptoDelete);
        for(AIA_Benefit_Design_Product__c pp: RelatedpptoDelete){
            for(AIA_Benefit_Design_Product__c pp1: selPPList){
               system.debug('@@pp1::: '+pp1.id +'@@pp:: '+pp.Cloned_From__c); 
                if(pp1.id != pp.Cloned_From__c){
                    finalselPPList.add(pp);
                }
            }
            if(selPPList.ISEMPTY()){finalselPPList.add(pp);}
        }
        List<AIA_Benefit_Design_Product__c> bdplist=new List<AIA_Benefit_Design_Product__c>();
        bdplist=[select id,Cloned_From_Name__c,Cloned_From__c,Benefit_Design__c
                              from AIA_Benefit_Design_Product__c 
                              where Cloned_From__c =:BDPID 
                              and Benefit_Design__c  =:newBD.id];
        if(!bdplist.ISEMPTY())
        bdToDelete = bdplist[0];
        system.debug('@@finalselPPList:::'+finalselPPList);
        try{
            if(bdToDelete != null && bdToDelete.id != null){
             mapOldBDPIdToOldBDPId.remove(BDPID);
               
             delete bdToDelete;
            if(!finalselPPList.ISEMPTY()){delete finalselPPList;}
            //T03
            bdpListToShow = [select id,Benefit_Design__c, Cloned_From_Name__c,Product_Category__c,Custom_New__c,Product_Parent_Name__c
                                      from AIA_Benefit_Design_Product__c where Benefit_Design__c  =:newBD.id ];
            system.debug('====bdpListToShow=========' + bdpListToShow);
            /***** BD forms ******/
            list<AIA_Benefit_Design_Form__c> AIABDFormList = [SELECT Id,Name FROM AIA_Benefit_Design_Form__c WHERE Benefit_Design__c  =:newBD.id ];
            system.debug(' AIABDFormList==Delete== :: '+AIABDFormList);
            if(AIABDFormList != null && AIABDFormList.size()>0) { delete AIABDFormList; } 
         }
        }catch(exception e){
            system.debug('@@Exception:::'+e);
        }
        
        
    }
    /**
    * @Author: Sree Harsha 
    * @This Method is called from VF page and check if Benefit Summary has data & is valid, if it doesn't then make call out to PCS
    * otherwise get data from Salesforce objects
    * @param -  Void
    * @Output - 
    */
    public void ValidateAndCallPCS(){
        string BDPID= Apexpages.currentPage().getParameters().get('BDPID');
        // T04  -   start
        string BDPCat= Apexpages.currentPage().getParameters().get('BDPCat');
        system.debug('BDPCat' + BDPCat);
        if(BDPCat!='CareFirst Private exchange'){
        //T04   -   End
        string planid= Apexpages.currentPage().getParameters().get('planid');
        string palanIdValue  = Apexpages.currentPage().getParameters().get('planIdValue');
        list<AIA_Plan__c> aiaPlanList = new list<AIA_Plan__c>();
        if(planid != NULL && planid !=''){
          String QueryStr=QueryBase2.getSobjectAllFieldsSOQL('AIA_Plan__c', 'Id=:planId');
          aiaPlanList = database.query(QueryStr);
        }

        system.debug('aiaPlanList line 348'+aiaPlanList);
        AIA_Plan__c aia_Plan;
        if(aiaPlanList != NULL && aiaPlanList.size() > 0)
            aia_Plan = aiaPlanList[0];
        
        String qry = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('AIA_Benefit_Design_Product__c', 'Id=:BDPID limit 1000','Benefit_Design__r.Jurisdiction__c,');
        System.debug('qry+++'+qry); 
        list<AIA_Benefit_Design_Product__c> thisBDPList = database.query(qry);
        AIA_Benefit_Design_Product__c bdp = new AIA_Benefit_Design_Product__c();
        if(thisBDPList != NULL && thisBDPList.size() > 0)
            bdp = thisBDPList[0];
        
        aiabenfSummary = new AIA_Benefit_SummaryController();
        boolean isClonableBDP = true;
        //T06 - Start  Commented error message to hide from user as per US1650
       /* if(erroMessages != null && erroMessages.size()>0){
            for(string strerror: erroMessages){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, strerror + ' - No Benefit Information is available for the selected Plan');                
                ApexPages.addMessage(myMsg);
            }
        } */
        //T06 - End
        //check if Benefit Summary has data & is valid, if it doesn't then make call out to PCS
        //otherwise get data from Salesforce objects
        //if(aia_Plan != NULL ){
        if(aia_Plan != NULL && hasBnftSumry(aia_Plan)){

            if(aia_Plan != NULL && isPCScallReq(aia_Plan)){
                //isPCSdata = true;
                system.debug('aia_Plan line 377'+aia_Plan);
                system.debug('planid line 378'+planid);
                system.debug('palanIdValue line 378'+palanIdValue);
                // T06 - Start Commented Commented PCS call as part of US1650
                //getPCSdata(planid,palanIdValue);
                //T06 - End
                if(Test.isRunningTest())
                {
                   summaryPlanId = planid; 
                }

               system.debug('summaryPlanId line 384'+summaryPlanId);
                if(summaryPlanId == null || summaryPlanId == '')
                {
                    isClonableBDP = false;
                    //T06 - Start  Commented error message to hide from user as per US1650
                    //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, bdp.Name + ' - No Benefit Information is available for the selected Plan');
                    //T06 - End
                    isDataAvailable = false;
                    erroMessages.add(bdp.Name);
                    //T06- Start
                    //ApexPages.addMessage(myMsg);
                    ///T06- End
                
                }
                else
                {
                    system.debug('@@summaryPlanId ::Inside '+summaryPlanId);  
                    String QueryString4=QueryBase2.getSobjectAllFieldsSOQL('AIA_Plan__c','Plan_Id__c =: summaryPlanId'); 
                    List<AIA_Plan__c> lstplanFromPCSCall = Database.query(QueryString4);
                    if(lstplanFromPCSCall!=null && lstplanFromPCSCall.size()>0)
                    {
                        AIA_Plan__c planFromPCSCall = lstplanFromPCSCall[0];
                       system.debug('@@planFromPCSCall :: '+planFromPCSCall);  
                       If(planFromPCSCall!=Null && planFromPCSCall.id!=null){
                            planid = planFromPCSCall.id;
                            mapBDPIdToPlanId.put(bdp.id,planid);
                       }
                    }
                    
                }
                
                //dispatcher();
                system.debug('IF PCSdata from setup  :: '+aia_Plan);  
            }else{
                // getBenefitSummary_TO();
                //  dispatcher();
                system.debug('================inside maininit else=========');
                system.debug('Else PCSdata :: '+aia_Plan);  
            }                        
        }
        else{
            //showError = true;
            system.debug('421'+summaryPlanId +planid);
            //T06 - Start  Commented error message to hide from user as per US1650
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, bdp.Name + ' - No Benefit Information is available for the selected Plan');
            //T06- End
            isDataAvailable = false;
            erroMessages.add(bdp.Name);
            //T06 - Start
            //ApexPages.addMessage(myMsg);
            //T06- End
        }

        /*if(aia_Plan != NULL && hasBnftSumry(aia_Plan)){
            if(aia_Plan != NULL && isPCScallReq(aia_Plan)){
                getPCSdata(planid,palanIdValue);
                system.debug('IF PCSdata from setup  :: '+aia_Plan);  
            }else{
                system.debug('================inside maininit else=========');
                system.debug('Else PCSdata :: '+aia_Plan);  
            }                        
        }
        else{
            //showError = true;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,bdp.Name + ' - No Benefit Information is available for the selected Plan');
            isDataAvailable = false;
            erroMessages.add(bdp.Name);
            ApexPages.addMessage(myMsg);
            
        }
        
        IF(aia_Plan != NULL && aia_Plan.Product_Status__c == 'Closed'){
            String QueryString4=QueryBase2.getSobjectAllFieldsSOQL('AIA_Plan__c','PreRenewalPlanID__c =: palanIdValue'); 
            list<AIA_Plan__c> PreRenewalPlanList = Database.query(QueryString4);
            AIA_Plan__c PreRenewalPlan = new AIA_Plan__c();
            if(PreRenewalPlanList != NULL && PreRenewalPlanList.size() > 0)
                PreRenewalPlan = PreRenewalPlanList[0];
            If(PreRenewalPlan != NULL && PreRenewalPlan.id != NULL){
                planid = PreRenewalPlan.id;
                if(PreRenewalPlan.Product_Status__c == 'Closed'){
                    isClonableBDP = false;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,bdp.Name + ' - No Benefit Information is available for the selected Plan');
                }
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, bdp.Name + ' - No Benefit Information is available for the selected Plan');
                isDataAvailable = false;
                isClonableBDP = false;
                erroMessages.add(bdp.Name);
                ApexPages.addMessage(myMsg);
            }
        } */
        if(isClonableBDP){
            ParentBenLimitationMan = new   Map<String,List<Limitations__c>>();
            ParentBenLimitationLimit = new   Map<String,List<Limitations__c>>();
            mapbenefitNameToBDPID = new Map<String,AIA_Benefit_Design_Product__c >();
            costShareOldValMap=new map <String,string>();
            mapIDTobenefit = new Map<String,AIA_Plan_Benefits__c>();
            maplst = new Map<String,AIA_Plan_Benefits__c>();
            AIA_BD_DeepCloneHelper aiaBDDeepHelper = new AIA_BD_DeepCloneHelper();
            aiaBDDeepHelper.getCopaysFromPlan(planid,'BDD',bdp,newBD);
            copayBenMap = new Map<string, CopayTypeWrapper>();
            mapbenefitNameToBDPID = aiaBDDeepHelper.mapbenefitNameToBDPID;
            for(string benfName: aiaBDDeepHelper.copayBenMap.Keyset()){
                AIA_BD_DeepCloneHelper.CopayTypeWrapper copaytype = aiaBDDeepHelper.copayBenMap.get(benfName);
                CopayTypeWrapper copay = new CopayTypeWrapper();
                copay.copayTypeSelectedObj = copaytype.copayTypeSelectedObj;
                copay.copayTypePecSpecObj = copaytype.copayTypePecSpecObj;
                copay.copayTypeSelectedObj2 = copaytype.copayTypeSelectedObj2;
                copay.copayTypePecSpecObj2 = copaytype.copayTypePecSpecObj2;
                copayBenMap.put(benfName,copay);
            }
            
            aiaBDDeepHelper.createWrapListFromPlanCostShr(planid,bdp);
            aiaBDDeepHelper.getPlanLimitation(aiaBDDeepHelper.benefitIdSet,bdp);
            aiaBDDeepHelper.getPlanCommentCodes(bdp);
            ParentBenLimitationMan = aiaBDDeepHelper.ParentBenLimitationMan;
            ParentBenLimitationLimit = aiaBDDeepHelper.ParentBenLimitationLimit;
            costShareOldValMap = aiaBDDeepHelper.costShareOldValMap;  
            mapIDTobenefit = aiaBDDeepHelper.mapIDTobenefit;
            maplst = aiaBDDeepHelper.maplst; 
            cloneSelRecords(lstBDPWrapper,newBD.id,bdp,newBD);
        }
            // T04  -   start     
       }
            else{
                String qry1 = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('AIA_Benefit_Design_Product__c', 'Id=:BDPID limit 1000','Benefit_Design__r.Jurisdiction__c,');
        list<AIA_Benefit_Design_Product__c> thisBDPList1 = database.query(qry1);
        AIA_Benefit_Design_Product__c bdp = new AIA_Benefit_Design_Product__c();
        if(thisBDPList1 != NULL && thisBDPList1.size() > 0)
            bdp = thisBDPList1[0];
            cloneSelRecords(lstBDPWrapper,newBD.id,bdp,newBD);
            }
      // T04    -   End
      
        
    }
    
    /**
* @Author: Sree Harsha 
* @This Method calls from ValidateAndCallPCS and returns true if Has_Benefit_Summary__c is true, false otherwise
* @param -  Boolean
* @Output - it will return result based on conditions
*/
    public boolean hasBnftSumry(AIA_Plan__c aia_Plan){
        boolean result = false;
        if(aia_Plan.Has_Benefit_Summary__c){//if checkbox is checked
            result = true;
        }
        return result;
    }   
    /**
* @Author: Sree Harsha 
* @This Method calls from ValidateAndCallPCS and returns true if PCS API call has to be made, false otherwise
* @param -  Boolean
* @Output - it will return result based on conditions
*/
  /*  public boolean isPCScallReq(AIA_Plan__c aia_Plan){
        boolean result = false;
        //check if Product Last Updated is greater than Config Last updated. If true get new data from PCS
        iF(aia_Plan.Product_Status__c == 'Active'){
            if(aia_Plan.Product_Last_Updated__c > aia_Plan.BDF_Configuration_Last_Updated__c || aia_Plan.BDF_Configuration_Last_Updated__c == null){
                result = true;
            }
        }
        
        return result;
    }
    */
    
  public boolean isPCScallReq(AIA_Plan__c aia_Plan){
        boolean result = false;
        //check if Product Last Updated is greater than Config Last updated. If true get new data from PCS
     if(aia_Plan.Product_Status__c == 'Active'){
         if(aia_Plan.Effective_Date__c <= bd.Benefit_Request_Form__r.Benefit_Effective_Date__c  && bd.Benefit_Request_Form__r.Benefit_Effective_Date__c <= aia_Plan.Termination_Date__c){
            if((aia_Plan.Product_Last_Updated__c > aia_Plan.Configuration_Last_Updated__c) || aia_Plan.Configuration_Last_Updated__c == null){
                return true;
            }
         }
            
         if((aia_Plan.Effective_Date__c < bd.Benefit_Request_Form__r.Benefit_Effective_Date__c  && bd.Benefit_Request_Form__r.Benefit_Effective_Date__c > aia_Plan.Termination_Date__c)){

            result = true;
            }
        }
        
        if(aia_Plan.Product_Status__c != 'Active'){
            result = true;
        }
       
        return result;
    }   
    
    
    
    /**
* @Author: Sree Harsha 
* @This Method calls is used to get data from PCS
* @param -  pageReference
* @Output - Return null
*/
// T06 - Start Commented getPCSdata to stop call to PCS as part of US1650
    /** public pageReference getPCSdata(string BDProdId,string planIdValue){
        system.debug('planIdValue line 537' +planIdValue);
        AIA_PCS_BenefitSummary benftSum = AIA_PCSIntegrationHandler.callPCS(planIdValue,'BDD',BDProdId,BRFEffDate);
        summaryPlanId = NULL;
        if(benftSum!=null && (benftSum.PlanID != null || benftSum.PlanID != '')){
            summaryPlanId = benftSum.PlanID;
        system.debug('@@summaryPlanId :: '+summaryPlanId);
        }
        return null;
    } **/
  // T06 - End  
/**
* @Author: Sree Harsha 
* @This Method calls to clone the selected list of bdps and the associated childs (Groupers, Benefits, Comment codes, AIADocs)
* @param -  pageReference
* @Output - 
*/
    //clone the selected list of bdps and the associated childs (Groupers, Benefits, Comment codes, AIADocs)
    public PageReference cloneSelRecords(List<BDPWrapper> BDPSelectList,string BDID,AIA_Benefit_Design_Product__c Currentbdp,AIA_Benefit_Design__c CurrentBD){
        List<Proposed_Products__c> CurrentPP = new List<Proposed_Products__c>();
        List<AIA_Benefit_Design_Product__c> SelectedBDPlistold = new List<AIA_Benefit_Design_Product__c>();
        List<AIA_Benefit_Design_Product__c> SelectedBDPlist = new List<AIA_Benefit_Design_Product__c>();
        bdpListToShow = new List<AIA_Benefit_Design_Product__c>();
        set<string> oldRecIds = new set<string>();
        Map<Id,AIA_Benefit_Design_Product__c> mapIdToBDP =new Map<Id,AIA_Benefit_Design_Product__c>();
        Map<Id,AIA_Benefit_Design_Product__c> mapOldIdToOldBDP =new Map<Id,AIA_Benefit_Design_Product__c>();
        AIA_Benefit_Design_Product__c bdpobj;
        AIA_Document__c Docobj;
        Decimal maxvalue = 0;
        Map<Id,Decimal> mapGrpIdTomaxValue =new Map<Id,Decimal>();
        CurrentPP = [select id, cloned_From__c from Proposed_Products__c where Benefit_Request_Form__c =: CurrentBD.Related_BRF__c];
        try{
            //system.debug('====cloneSelRecordsaiabenfSummary=========' + aiabenfSummary.grouperWrapList);
            system.debug(LoggingLevel.INFO,'BDPSelectList=== ::' + BDPSelectList);
            if(BDPSelectList != null && BDPSelectList.size()>0){
                for(BDPWrapper mw: BDPSelectList){
                    if(mw.checked == true){ 
                        SelectedBDPlistold.add(mw.bdp);                        
                    }
                }
            }  
set<id> ActuallBDPIdSet = new set<id>();            
            system.debug(LoggingLevel.INFO,'SelectedBDPlistold=== ::' + SelectedBDPlistold);
            if(SelectedBDPlistold != null && SelectedBDPlistold.size()>0){
                for(AIA_Benefit_Design_Product__c PW: SelectedBDPlistold){
                    /*if(PW.Plan_Name__r.Product_Status__c == 'Active'){
                        SelectedBDPlist.add(PW);
                    }
                    if(PW.Plan_Name__r.Product_Status__c == 'Closed'){
                        string RPID = PW.Plan_Name__r.Plan_Id__c;
                        system.debug(Logginglevel.INFO,'RPID===========' + RPID);
                        String QSS4=QueryBase2.getSobjectAllFieldsSOQL('AIA_Plan__c','PreRenewalPlanID__c =:RPID'); 
                        system.debug(Logginglevel.INFO,'QSS4===========' + QSS4);
                        List<AIA_Plan__c> PRPlan = Database.query(QSS4);
                        system.debug(Logginglevel.INFO,'PRPlan===========' + PRPlan);
                        If(PRPlan!= null && PRPlan.size()>0){  
                            AIA_Plan__c prpc = PRPlan[0];
                            system.debug('prpc===========' + prpc);
                            system.debug(Logginglevel.INFO,'prpc===========' + prpc);
                            If(prpc!=Null && prpc.id!=null){
                                if(prpc.Product_Status__c != null && prpc.Product_Status__c == 'Active'){
                                    SelectedBDPlist.add(PW);
                                }
                                if(prpc.Product_Status__c != null && prpc.Product_status__c == 'Closed' && PW.Custom__c == True){
                                    SelectedBDPlist.add(PW);        
                                }
                            }
                        }
                    }*/
                    ActuallBDPIdSet.add(PW.Id);
                }
            }                      
            
            set<id> BDPIdSet = new set<id>();
            
            /*if(SelectedBDPlist != null && SelectedBDPlist.size()>0){
                for(AIA_Benefit_Design_Product__c bpdRec:SelectedBDPlist){
                    ActuallBDPIdSet.add(bpdRec.Id);
                }
            }*/
            system.debug(LoggingLevel.INFO,'ActuallBDPIdSet=== ::' + ActuallBDPIdSet);
            List<AIA_Benefit_Design_Product__c> AncillryBDPList = new List<AIA_Benefit_Design_Product__c>([select Id,name from AIA_Benefit_Design_Product__c where Related_Medical_Product__c in :ActuallBDPIdSet]);
            if(AncillryBDPList != null && AncillryBDPList.size()>0){
                for(AIA_Benefit_Design_Product__c ancpp:AncillryBDPList){
                    SelectedBDPlist.add(ancpp);
                    ActuallBDPIdSet.add(ancpp.Id);
                }
            }
            set<id> ClonedBDPIdSet = new set<id>();
            system.debug(LoggingLevel.INFO,'ActuallBDPIdSet==2= ::' + ActuallBDPIdSet);
            if(ActuallBDPIdSet != null && ActuallBDPIdSet.size()>0){
                List<AIA_Benefit_Design_Product__c> ClonedBDPList = new List<AIA_Benefit_Design_Product__c>([select Id,name,Cloned_From__c,Cloned_From_Name__c,Product_Category__c,Custom__c,Product_Parent_Name__c from AIA_Benefit_Design_Product__c where Cloned_From__c in :ActuallBDPIdSet and Benefit_Design__c =:bdId limit 1000]);
                system.debug(LoggingLevel.INFO,'ClonedBDPList=== ::' + ClonedBDPList);
                if(ClonedbdpList != null && ClonedbdpList.size()>0){
                    for(AIA_Benefit_Design_Product__c clonedbdps:ClonedbdpList){
                        ClonedBDPIdSet.add(clonedbdps.Cloned_From__c);
                    }
                }
            }
            system.debug(LoggingLevel.INFO,'ClonedBDPIdSet=== ::' + ClonedBDPIdSet);
            //Query all fields for bdps
            String QueryString=QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefit_Design_Product__c','Id in :ActuallBDPIdSet');
            List<AIA_Benefit_Design_Product__c> BDPList = Database.query(QueryString);
            list<AIA_Benefit_Design_Product__c> relatedBDPList = new list<AIA_Benefit_Design_Product__c>();
            parentBDPList = new list<AIA_Benefit_Design_Product__c>();  
            parentBDPList2   = new list<AIA_Benefit_Design_Product__c>();       
            //Clone the bdps
            
            for(AIA_Benefit_Design_Product__c bdp: BDPList){
                
                bdpobj = new AIA_Benefit_Design_Product__c();
                bdpobj = bdp.clone(false);
                bdpobj.Custom__c = bdp.Custom__c; 
                system.debug(bdpobj.Custom__c+'>>>>>>>>>>>>>>>>>>'+bdp.Custom__c); 
                bdpobj.Benefit_Design__c = bdId;   
                bdpobj.Cloned_From__c = bdp.Id;
                bdpobj.Cloned_From_Name__c = bdp.Name;
                if(bdp.Product_Category__c =='Medical'){
                    bdpobj.Cloned_From_Related_Medical__c = '';
                }   
                else 
                    bdpobj.Cloned_From_Related_Medical__c = bdp.Related_Medical_Product__c;
                if(mapBDPIdToPlanId.containsKey(bdp.id))
                {
                    bdpobj.Plan_Name__c = mapBDPIdToPlanId.get(bdp.id);
                }
                //bdpobj.Custom__c = False;
                if(ClonedBDPIdSet.Contains(bdp.id)) { bdpListToShow.add(bdpobj); continue; }
                parentBDPList2.add(bdpobj);
                BDPIdSet.add(bdp.Id);                       
            }
            system.debug(LoggingLevel.INFO,'BDPIdSet=== ::' + BDPIdSet);
            
            for(AIA_Benefit_Design_Product__c bdp2: parentBDPList2){
                for(Proposed_Products__c PP2:CurrentPP){
                 if(PP2.Cloned_From__c == bdp2.Proposed_Products__c){
                     bdp2.Proposed_Products__c = PP2.id;
                 
                    }
                }
                 parentBDPList.add(bdp2);

            }
           
            
            
            system.debug(LoggingLevel.INFO,'parentBDPList=== ::' + parentBDPList);
            if(parentBDPList != null && parentBDPList.size()>0){               
                upsert parentBDPList;
                system.debug(LoggingLevel.INFO,'@@parentBDPList@@'+parentBDPList);
            }
            map<string,string> ancmap = new map<string,string>();
            for (AIA_Benefit_Design_Product__c rec:parentBDPList){               
                ancmap.put(rec.Cloned_From__c,rec.Id);
                mapIdToBDP.put(bdpobj.Id,bdpobj);
                mapOldIdToOldBDP.put(rec.Cloned_From__c,rec);
                if(!mapOldBDPIdToOldBDPId.ContainsKey(rec.Cloned_From__c))
                    mapOldBDPIdToOldBDPId.put(rec.Cloned_From__c,rec);
            }
            // Get the Ancillary products (related products)
            for(AIA_Benefit_Design_Product__c anc: parentBDPList){
                if(anc.Cloned_From_Related_Medical__c != ''){ anc.Related_Medical_Product__c = ancmap.get(anc.Cloned_From_Related_Medical__c); }
            }  
            if(parentBDPList != null && parentBDPList.size()>0){               
                upsert parentBDPList;    
                system.debug(LoggingLevel.INFO,'@@@@parentBDPList@@@@'+parentBDPList);   
            }
            
      map<string,AIA_Benefit_Design_Product__c> mapBPDForDoc = new map<string,AIA_Benefit_Design_Product__c>();
            List<AIA_Benefit_Design_Product__c> CustomBDPlst = New List<AIA_Benefit_Design_Product__c>();
            if(parentBDPList != NULL && parentBDPList.size()>0){
             for(AIA_Benefit_Design_Product__c CustomBDP:parentBDPList){
                if(CustomBDP.OldBDPCustom__c == True){ CustomBDP.Custom__c = True; }
                 CustomBDPlst.add(CustomBDP);
                mapBPDForDoc.put(CustomBDP.Cloned_From__c,CustomBDP);
             } 
            }
            system.debug(LoggingLevel.INFO,'CustomBDPlst=== ::' + CustomBDPlst);
            upsert CustomBDPlst;  
            
            list<AIA_Document__c> newAIADocList = new  list<AIA_Document__c>();
            boolean isBDPAdded = false;
            System.debug(LoggingLevel.INFO,'+++++parentBDPList+++++'+parentBDPList);
            if(!parentBDPList.isempty()){
            for(AIA_Benefit_Design_Product__c selbdP:parentBDPList)
            {
               if(AIA_DocWrapList != NULL && AIA_DocWrapList.size()>0){
               system.debug(LoggingLevel.INFO,'AIA_DocWrapList=== ::' + AIA_DocWrapList);
               for(AIADocumentWrapper AIAwrapper: AIA_DocWrapList){
                   // system.debug(LoggingLevel.INFO,'wrapper.checked=== ::' + wrapper.checked);
                   // system.debug(LoggingLevel.INFO,'wrapper.aiaDoc.Proposed_Products__c=== ::' + wrapper.aiaDoc.Benefit_Design_Product__c);
                   // system.debug(LoggingLevel.INFO,'selbdP.id=== ::' + selbdP.Cloned_From__c);
                    if(AIAwrapper.checked){
                        if(AIAwrapper.aiaDoc.Benefit_Design_Product__c == selbdP.Cloned_From__c)
                        {
                            if(!selAIA_DocList.isempty()){
                            for(AIA_Document__c AIADocument: selAIA_DocList){
                                System.debug(LoggingLevel.INFO,'+++++parentBDPList+++++'+parentBDPList);
                                if(AIADocument.ClonedFromAIADocID__c == AIAwrapper.aiaDoc.Id)
                                {
                                  isBDPAdded = true;
                                  AIADocument.Benefit_Design_Product__c = selbdP.id;
                                }
                            }
                          }  
                        }
                    }
                 }
               }  
               
            } 
           } 
            System.debug(LoggingLevel.INFO,'+++++selAIA_DocList+++++'+selAIA_DocList);
            if(selAIA_DocList!=null && selAIA_DocList.size()>0 && isBDPAdded){
                upsert selAIA_DocList;
            }
            //Querying the existing groupers & associated Benefits
           /* list<AIA_Grouper__c> existingGrouperList = new list<AIA_Grouper__c>();
            Id BDPRTypeId = Schema.SObjectType.AIA_Grouper__c.RecordTypeInfosByName.get('BD Product').RecordTypeId;
            Id benefitBDPRTypeId = Schema.SObjectType.AIA_Benefits__c.RecordTypeInfosByName.get('BD Product').RecordTypeId;
            List<String> lstchildObjects = new List<string>();
            lstchildObjects.add('AIA_Benefits__c');
            String qry = QueryBase2.getSobjectAllFieldsSOQLWithChildObjects('AIA_Grouper__c', 'recordTypeId=:BDPRTypeId and Benefit_Design_Product__c in: BDPIdSet','AIA_Benefits__c','Benefit__r');        
            //query all the fields for clone to work
            existingGrouperList = Database.query(qry);
            
            Map<id,List<AIA_Benefits__c>> GrouperBenefitMap = new Map<id,List<AIA_Benefits__c>>();
            Map<id,List<Limitations__c>> BeneLimitationMap = new Map<id,List<Limitations__c>>(); */
            BeneNameLimitationMap = new Map<string,List<Limitations__c>>();        
            Map<string,AIA_Benefit_Design_Product__c> BeneNameToBDPMap = new Map<string,AIA_Benefit_Design_Product__c>(); 
            Set<String> setNewBenefits = new Set<String>();  
            Map<string,AIA_Benefits__c> BeneNameToBenefit = new Map<string,AIA_Benefits__c>();
            /*
            for(AIA_Grouper__c grouper : existingGrouperList){
                GrouperBenefitMap.put(grouper.id,grouper.benefit__r);
            }  */

            list<AIA_Grouper__c> existingGrouperList = new list<AIA_Grouper__c>();
            Id BDPRTypeId = Schema.SObjectType.AIA_Grouper__c.RecordTypeInfosByName.get('BD Product').RecordTypeId;
            Id benefitBDPRTypeId = Schema.SObjectType.AIA_Benefits__c.RecordTypeInfosByName.get('BD Product').RecordTypeId;
        
        //T02 start added fields in query 
        //query all the fields for clone to work
        //list<AIA_Grouper__c> existingGrouperList = new list<AIA_Grouper__c>();
        list<AIA_Benefits__c> existingBenefits = new list<AIA_Benefits__c>();
        List<String> lstchildObjects = new List<string>();
        lstchildObjects.add('AIA_Benefits__c');
         String qry = QueryBase2.getSobjectAllFieldsSOQL('AIA_Grouper__c', 'recordTypeId=:BDPRTypeId and Benefit_Design_Product__c in: BDPIdSet');
        System.debug('qry+++'+qry);        
        //query all the fields for clone to work
        existingGrouperList = Database.query(qry);
        Set<string> setGrpIds = new Set<String>();
        for(AIA_Grouper__c grouper : existingGrouperList){
            setGrpIds.add(grouper.id);            
        }
        Map<id,List<AIA_Benefits__c>> GrouperBenefitMap = new Map<id,List<AIA_Benefits__c>>();
        Map<id,List<Limitations__c>> BeneLimitationMap = new Map<id,List<Limitations__c>>();                                                                                                                                 
        system.debug('@@existingGrouperList'+existingGrouperList);
        
        String qry1 = QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefits__c', 'Grouper__c in: setGrpIds');
        System.debug('qry+++'+qry1);        
        //query all the fields for clone to work
        existingBenefits = Database.query(qry1);
        for(AIA_Benefits__c benefit1 : existingBenefits){
            if(GrouperBenefitMap.containsKey(benefit1.Grouper__c))
            {
                GrouperBenefitMap.get(benefit1.Grouper__c).add(benefit1);  
            }
            else
            {
                GrouperBenefitMap.put(benefit1.Grouper__c ,new List<AIA_Benefits__c> { benefit1});
            } 
         }   
            List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c,IsCustom__c,Benefit__r.Benefit_Name__c,OldMax_TierVal__c, Benefit__r.Grouper__c,comment_codes__c, IsSelected__c, Jurisdiction__c, 
                                                               MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c, Clone_Benefit_name__c,Benefit__r.Benefit_Type__c,
                                                               MaxDuration__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, IS_ASO_Only__c,
                                                               TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
                                                               MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c,  
                                                               MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,
                                                               TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c, RecordType__c,Effective_Date__c, Term_Date__c,
                                                               ParentBenefitName__c, TierLimitTo__c, TierLimitType__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c,
                                                               MaxDuration_Selected__c,MaxAge_Selected__c, TierLimit_Selected__c, TierAge_Selected__c,Benefit__r.CommentCode_Custom__c,Benefit__r.CommentCode_NonStandard__c
                                                                   FROM Limitations__c where Benefit__r.Grouper__c   in:GrouperBenefitMap.keySet()]);
            system.debug('lmtsn>>> 788'+lmtsn);
            
            if(lmtsn != null && lmtsn.size()>0){
                for(Limitations__c lst :lmtsn){
                    string namewithcode = lst.Clone_Benefit_name__c+ '-' + lst.Benefit__r.Benefit_Type__c;
                    string namewithcodeType = lst.Clone_Benefit_name__c+ '-' + lst.Benefit__r.Benefit_Type__c+ '-' + lst.RecordType__c+ '-' + lst.Code__c;
                    if(mapBenNamewithCode != NULL && mapBenNamewithCode.containsKey(namewithcode)){
                      mapBenNamewithCode.get(namewithcode).add(lst);
                    }else{
                    mapBenNamewithCode.put(namewithcode,new list<Limitations__c>{lst});
                    }
                    mapBenNamewithType.put(namewithcodeType,lst);
                }  
            }
            
            system.debug('mapBenNamewithCode line 805'+mapBenNamewithCode);
            for(Limitations__c obj:lmtsn){
                List<Limitations__c> lmts=new List<Limitations__c>();
                List<Limitations__c> namelmts=new List<Limitations__c>();
                if(BeneLimitationMap.containsKey(obj.Benefit__c))
                {
                    lmts=BeneLimitationMap.get(obj.Benefit__c);
                }
                
                if(BeneNameLimitationMap != Null && BeneNameLimitationMap.containsKey(obj.Benefit__r.Benefit_Name__c)){
                    BeneNameLimitationMap.get(obj.Benefit__r.Benefit_Name__c).add(obj);
                    namelmts=BeneNameLimitationMap.get(obj.Benefit__r.Benefit_Name__c);
                }
                lmts.add(obj);
                BeneLimitationMap.put(obj.Benefit__c,lmts);
             
                BeneNameLimitationMap.put(obj.Benefit__r.Benefit_Name__c,namelmts);
              
            } 
             system.debug(LoggingLevel.INFO,'BeneLimitationMap---'+BeneLimitationMap);
            //Creating a Map between BDP & Grouper
            Map<id,List<AIA_Grouper__c>> BDPGrouperMap = new Map<id,list<AIA_Grouper__c>>();
            for(AIA_Benefit_Design_Product__c bdp:parentBDPList){
                bdpListToShow.add(bdp);
                list<AIA_Grouper__c> tempGrouperList = new list<AIA_Grouper__c>();
                for(AIA_Grouper__c grouper : existingGrouperList){
                    if(bdp.Cloned_From__c ==grouper.Benefit_Design_Product__c){
                        tempGrouperList.add(grouper);
                        BDPGrouperMap.put(bdp.id,tempGrouperList);
                        //continue;
                    }
                }
            }
            Id BDRTypeId = Schema.SObjectType.AIA_Grouper__c.RecordTypeInfosByName.get('BD Product').RecordTypeId;
            Id benefitBDRTypeId = Schema.SObjectType.AIA_Benefits__c.RecordTypeInfosByName.get('BD Product').RecordTypeId;
            
            //Cloning Groupers
            list<AIA_Grouper__c> clonedGrouperList = new list<AIA_Grouper__c>();
            for(AIA_Benefit_Design_Product__c bdp:parentBDPList){
                if(BDPGrouperMap.get(bdp.id)!=null){
                    list<AIA_Grouper__c> tempclonedGrouperList = BDPGrouperMap.get(bdp.id);
                    for(AIA_Grouper__c parentGrouper:tempclonedGrouperList){
                        AIA_Grouper__c clonedGrouper = new AIA_Grouper__c();
                        
                        clonedGrouper=parentGrouper.clone();
                        clonedGrouper.Benefit_Design_Product__c = bdp.id;
                        clonedGrouper.Cloned_From__c = parentGrouper.id;
                        clonedGrouper.recordTypeId= BDPRTypeId;
                        clonedGrouper.Grouper_Record_Type__c = parentGrouper.Grouper_Record_Type__c;
                        clonedGrouper.Sequence_Number__c = parentGrouper.Sequence_Number__c;
                        clonedGrouperList.add(clonedGrouper);
                    }
                }
            }
            if(clonedGrouperList.size()>0)
                insert clonedGrouperList;
            system.debug('clonedGrouperList******* 837'+clonedGrouperList);
            
            //Cloning associated Benefits
            List<AIA_Benefits__c> clonedBenefitList = new list<AIA_Benefits__c>();
            if(clonedGrouperList.size()>0){
                AIA_Benefit_Design_Product__c bdp = new AIA_Benefit_Design_Product__c();
                Set<string> SetBenifitname = New Set<string>();
                Set<string> Setbnames = New Set<string>();
                for(AIA_Grouper__c clonedGrouper:clonedGrouperList){
                    if(GrouperBenefitMap.get(clonedGrouper.Cloned_From__c)!=null){
                        
                        system.debug('@@mapIdToPP==='+mapIdToBDP);
                        if(mapIdToBDP != null && mapIdToBDP.containsKey(clonedGrouper.Benefit_Design_Product__c))
                            bdp =  mapIdToBDP.get(clonedGrouper.Benefit_Design_Product__c);
                        system.debug('@@cBen==bdp='+bdp);
                        list<AIA_Benefits__c> tempBenefitList = GrouperBenefitMap.get(clonedGrouper.Cloned_From__c);
                        system.debug('@@tempBenefitList'+tempBenefitList);
                        
                        for(AIA_Benefits__c benefit:tempBenefitList){
                            Setbnames.add(benefit.Benefit_Name__c);
                        }
                        system.debug('@@Setbnames:: '+Setbnames);
                        for(string strbenName:copayBenMap.keySet())
                        {
                            system.debug('@@strbenName:: '+strbenName);
                            system.debug('@@Setbnames.Contains(strbenName)'+!Setbnames.Contains(strbenName));
                            if(!Setbnames.Contains(strbenName))
                            {
                                if(bdp != null)
                                {
                                    BeneNameToBDPMap.put(strbenName,bdp);
                                    //system.debug('@@BeneNameToPPMap=='+BeneNameToPPMap);
                                }
                                system.debug('@@strbenName==Added=='+strbenName);
                                SetBenifitname.add(strbenName);
                            }
                        }
                        system.debug('@@SetBenifitname'+Setbnames);
                        
                        for(AIA_Benefits__c benefit:tempBenefitList){
                            AIA_Benefits__c clonedBenefit = new AIA_Benefits__c();
                            //system.debug('==mapIdToAIAbenifit=='+mapIdToAIAbenifit);
                            CopayTypeWrapper  cBen = null;
                            system.debug('@@copayBenMap==='+copayBenMap);
                            system.debug('@@cBen==='+benefit.Benefit_Name__c);
                            system.debug('@@copayBenMap==='+copayBenMap.containsKey(benefit.Benefit_Name__c));
                            if(copayBenMap != null && copayBenMap.containsKey(benefit.Benefit_Name__c))
                                cBen = copayBenMap.get(benefit.Benefit_Name__c);
                            //copayBenMap.put(copType.Plan_Benefits__c, ct);
                            
                            system.debug('@@cBen==='+cBen);
                            clonedBenefit=benefit.clone();
                            clonedBenefit.Grouper__c=clonedGrouper.id;
                            clonedBenefit.recordTypeId=benefitBDPRTypeId;
                            clonedBenefit.Benefit_Record_Type__c = benefit.Benefit_Record_Type__c;
                            clonedBenefit.Cloned_From_Benefit__c=benefit.id;
                            if(benefit.Benefit_Type__c == 'Limitation'){
                                clonedBenefit.Copay_Type_1_IsCovered__c = '';
                                clonedBenefit.OON_Copay_Type_1_IsCovered__c = '';
                            }
                            system.debug('@@benefit.id==='+benefit.id);
                            system.debug('line 898'+isDataAvailable);
                            
                            if(isDataAvailable){                      
                                AIA_Plan_Copay_Type__c copayTypeSelected=new AIA_Plan_Copay_Type__c();
                                if(cBen !=null && cBen.copayTypeSelectedObj!=null){
                                    copayTypeSelected=cBen.copayTypeSelectedObj;
                                    system.debug('copayTypeSelected1+++'+copayTypeSelected);
                                    
                                    if(copayTypeSelected != NULL)
                                    {   
                                        IF(bdp.Product_Category__c=='Medical'){
                                          //  system.debug('@@benefit.Benefit_Name__c==='+benefit.Benefit_Name__c);
                                          //  system.debug('copayTypeSelected+++Medical++'+copayTypeSelected);
                                          //  system.debug('benefit+++Medical++'+benefit);
                                            
                                           clonedBenefit.InNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;
                            
                               
                                If(benefit.CoInsurance_Customized__c == false) {
                                clonedBenefit.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                clonedBenefit.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;    
                                }
                                 
                             
                                If(benefit.Copay_Type_1_IsCovered_Customized__c == false){
                                clonedBenefit.Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                clonedBenefit.Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No'; 
                                }
                                
                              
                                If(benefit.Copay_Type_1_Deductible_Customized__c == false){
                                clonedBenefit.Copay_Type_1_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                                clonedBenefit.Copay_Type_1_Default_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;   
                                }
                                
                               
                                if(benefit.Copay_Type_1_Amount_Customized__c == false){
                                clonedBenefit.Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                clonedBenefit.Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                                
                                clonedBenefit.Copay_Type_1_Low__c = copayTypeSelected.Copay_Low__c;
                                clonedBenefit.Copay_Type_1_High__c = copayTypeSelected.Copay_High__c;               
                                clonedBenefit.Copay_Type_1_Increment__c = copayTypeSelected.Copay_Increment__c;
                                clonedBenefit.Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;
                                clonedBenefit.Copay_Type_1_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
                                clonedBenefit.Copay_Type_1_AdditionalInvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;    
                                }
                                
                               
                                
                                if(benefit.Benefit_non_standard__c == false){
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Y'){
                                clonedBenefit.IS_ASO_Only__c = True; 
                                }
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'N'){
                                clonedBenefit.IS_ASO_Only__c = False;
                                }
                                
                                clonedBenefit.IsAppGlobalCoinsurance__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCoinsurance__c;
                                clonedBenefit.IsAppGlobalCopay__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCopay__c;
                                                            
                                }
                                        } 
                                        
                                         if (bdp.Product_Category__c == 'Vision') {

                                            clonedBenefit.InNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;
                                            clonedBenefit.Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;

                                        if(benefit.CoInsurance_Customized__c == false){
                                                clonedBenefit.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                                clonedBenefit.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;   
                                        }
                                        if(benefit.Copay_Type_1_IsCovered_Customized__c== false){
                                                clonedBenefit.Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                                                clonedBenefit.Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No'; 
                                          }       
                                        if(benefit.Copay_Type_1_Amount_Customized__c == false){
                                                clonedBenefit.Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                                clonedBenefit.Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                                                clonedBenefit.Copay_Type_1_Low__c = copayTypeSelected.Copay_Low__c;
                                                clonedBenefit.Copay_Type_1_High__c = copayTypeSelected.Copay_High__c;
                                                clonedBenefit.Copay_Type_1_Increment__c = copayTypeSelected.Copay_Increment__c;
                                                clonedBenefit.Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;
                                                clonedBenefit.Copay_Type_1_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
                                                clonedBenefit.Copay_Type_1_AdditionalInvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;     
                                           }
                                                
                                        if(benefit.Discount_Amount_Customized__c == false){
                                                clonedBenefit.Discount_Amount__c = copayTypeSelected.Discount_Amount__c;
                                                clonedBenefit.Discount_Amount_Default__c = copayTypeSelected.Discount_Amount__c;
                                        }
                                        if(benefit.ScheduledAmounts_Customized__c == false){
                                                clonedBenefit.IN_Approximate_Member_Payment_w_Discount__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
                                                clonedBenefit.IN_Approx_Member_Payment_w_Disc_Default__c= copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
                                        }
                                        if(benefit.Allowed_Amount_Customized__c == false){
                                                clonedBenefit.Allowed_Amount__c = copayTypeSelected.Allowed_Amount__c;
                                                clonedBenefit.Allowed_Amount_Default__c= copayTypeSelected.Allowed_Amount__c;
                                        }
                                        if(benefit.Discount_Amount_Customized__c == false){
                                                clonedBenefit.Discount_Applies__c = copayTypeSelected.Discount_Applies__c;
                                                clonedBenefit.Discount_Applies_Default__c= copayTypeSelected.Discount_Applies__c;
                                        }
                                             //clonedBenefit.Davis_Benefit_Variable__c = copayTypeSelected.Plan_Benefits__r.Davis_Benefit_Variable__c;
                                        if(benefit.Davis_Variable_customized__c  == false){
                                                clonedBenefit.Davis_Benefit_Variable__c  = copayTypeSelected.Plan_Benefits__r.Davis_Benefit_Variable__c;
                                                clonedBenefit.Davis_Benefit_Variable_Default__c= copayTypeSelected.Plan_Benefits__r.Davis_Benefit_Variable__c;
                                        }       
                                               
                                             if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Y') {
                                              clonedBenefit.IS_ASO_Only__c = True;
                                             }
                                             if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'N') {
                                              clonedBenefit.IS_ASO_Only__c = False;
                                             }

                                             clonedBenefit.IsAppGlobalCoinsurance__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCoinsurance__c;
                                             clonedBenefit.IsAppGlobalCopay__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCopay__c;

                                            }   
                                                                                
                                         IF(bdp.Product_Category__c == 'Dental') {
                                            

                                            clonedBenefit.InNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;   
                                        if(benefit.CoInsurance_Customized__c == false){    
                                            clonedBenefit.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                            clonedBenefit.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;   
                                        }
                                        if(benefit.Copay_Type_1_IsCovered_Customized__c == false){    
                                             clonedBenefit.Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                                             clonedBenefit.Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';   
                                        }
                                        if(benefit.Copay_Type_1_Deductible_Customized__c== false){     
                                             clonedBenefit.Copay_Type_1_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                                             clonedBenefit.Copay_Type_1_Default_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                                        }
                                        if(benefit.Dental_AnnualMaximumApplies_Customized__c == false){     
                                            if(copayTypeSelected.AnnualMaximumApplies__c == 'Yes' || copayTypeSelected.AnnualMaximumApplies__c == 'Y'){     
                                                clonedBenefit.AnnualMaximumApplies__c= 'Yes' ;       
                                            }       
                                            if(copayTypeSelected.AnnualMaximumApplies__c == 'No' || copayTypeSelected.AnnualMaximumApplies__c == 'N'){      
                                                clonedBenefit.AnnualMaximumApplies__c= 'No' ;        
                                            }
                                        }
                                             if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Y') {
                                              clonedBenefit.IS_ASO_Only__c = True;
                                             }
                                             if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'N') {
                                              clonedBenefit.IS_ASO_Only__c = False;
                                             }

                                             clonedBenefit.IsAppGlobalCoinsurance__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCoinsurance__c;
                                             clonedBenefit.IsAppGlobalCopay__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCopay__c;

                                            

                                           }   
                        if(bdp.Product_Category__c=='Drug'){
                                                
                                    clonedBenefit.InNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;
                                    
                                       
                                        If(benefit.CoInsurance_Customized__c == false){
                                        clonedBenefit.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                        clonedBenefit.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;    
                                        }
                                        
                                       
                                        If(benefit.Copay_Type_1_IsCovered_Customized__c == false){
                                        clonedBenefit.Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                        clonedBenefit.Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No'; 
                                        }
                                        
                                        
                                        if(benefit.Copay_Type_1_Amount_Customized__c == false){
                                        clonedBenefit.Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                        clonedBenefit.Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                                        
                                        clonedBenefit.Copay_Type_1_Low__c = copayTypeSelected.Copay_Low__c;
                                        clonedBenefit.Copay_Type_1_High__c = copayTypeSelected.Copay_High__c;               
                                        clonedBenefit.Copay_Type_1_Increment__c = copayTypeSelected.Copay_Increment__c;
                                        clonedBenefit.Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;
                                        clonedBenefit.Copay_Type_1_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
                                        clonedBenefit.Copay_Type_1_AdditionalInvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;    
                                        }
                                        
                                       if(benefit.Copay_Min_Payment_Customized__c == false){
                                        clonedBenefit.Copay_Min_Payment__c = copayTypeSelected.MinPayAmount__c;
                                        clonedBenefit.Copay_Default_Min_Payment__c = copayTypeSelected.MinPayAmount__c; 
                                        }
                                        
                                         if(benefit.Copay_Max_Payment_Customized__c == false){
                                        clonedBenefit.Copay_Max_Payment__c = copayTypeSelected.MaxPayAmount__c;
                                        clonedBenefit.Copay_Default_Max_Payment__c = copayTypeSelected.MaxPayAmount__c; 
                                        }
                                        
                                        
                                        if(benefit.Tier_Type_Customized__c == false){
                                        clonedBenefit.Tier_type__c=copayTypeSelected.TierType__c; 
                                        clonedBenefit.Tier_Type_Default__c=copayTypeSelected.TierType__c;   
                                        }
                                        
                                        
                                        if(benefit.Benefit_non_standard__c  == false){
                                        if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Y'){
                                        clonedBenefit.IS_ASO_Only__c = True; 
                                        }
                                        if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'N'){
                                        clonedBenefit.IS_ASO_Only__c = False;
                                        }
                                        
                                        clonedBenefit.IsAppGlobalCoinsurance__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCoinsurance__c;
                                        clonedBenefit.IsAppGlobalCopay__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCopay__c;
                                                                    
                                        }
                                    }                              
  
                                    }
                                    
                                }
                                if(cBen !=null && cBen.copayTypePecSpecObj!=null && cBen.copayTypeSelectedObj.id!=cBen.copayTypePecSpecObj.id){ // && pp.Product_Category__c=='Medical'
                                    copayTypeSelected=cBen.copayTypePecSpecObj;
                                    if(copayTypeSelected != null)
                                    {
                                    //    system.debug('copayTypePecSpec1+++'+copayTypeSelected);
                                        
                                     clonedBenefit.InNetwork_ExtID_Copay2__c = copaytypeselected.ExtID__c;
                            
                                   if(benefit.Copay_Type_2_Amount_Customized__c == false){
                                    clonedBenefit.Copay_Type_2_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                    clonedBenefit.Copay_Type_2_DefaultAmount__c = copayTypeSelected.CopayAmount__c; 
                                    
                                    clonedBenefit.Copay_Type_2_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                    clonedBenefit.Copay_Type_2_Low__c = copayTypeSelected.Copay_Low__c;
                                    clonedBenefit.Copay_Type_2_High__c = copayTypeSelected.Copay_High__c;
                                    clonedBenefit.Copay_Type_2_Increment__c = copayTypeSelected.Copay_Increment__c;
                                    clonedBenefit.CopayType2_Additional_InvalidIncrement__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;
                                    clonedBenefit.Copay_Type_2_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
                                    clonedBenefit.Copay_Type_2_AliasName__c = copayTypeSelected.AliasName__c;
                                        }
                                    }
                                    
                                }
                                if(cBen !=null && cBen.copayTypeSelectedObj2!=null ){
                                    copayTypeSelected=cBen.copayTypeSelectedObj2;
                                    if(copayTypeSelected != null)
                                    {
                                       //system.debug('copayTypeSelected2+++'+copayTypeSelected);
                                        if(bdp.Product_Category__c=='Medical'){
                                        
                                        //system.debug('benefit+++Medical++'+benefit);
                                        
                                        clonedBenefit.OutNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;
                                        
                                             if(benefit.OON_Coinsurance_Customized__c == false){
                                            clonedBenefit.OON_CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                            clonedBenefit.OON_Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;    
                                            }
                                            
                                            if(benefit.OON_Copay_Type_1_IsCovered_Customized__c == false){
                                            clonedBenefit.OON_Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                            clonedBenefit.OON_Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No'; 
                                            }
                                            
                                           if(benefit.OON_Copay_Type_1_Deductible_Customized__c ==  false){
                                            clonedBenefit.OON_Copay_Type_1_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                                            clonedBenefit.OON_Copay_1_Default_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;    
                                            }
                                            
                                            if(benefit.OON_Copay_Type_1_Amount_Customized__c == false){
                                            clonedBenefit.OON_Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                            clonedBenefit.OON_Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                                            
                                            clonedBenefit.OON_Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;
                                            clonedBenefit.OON_Copay_AmountLow__c = copayTypeSelected.Copay_Low__c;
                                            clonedBenefit.OON_Copay_AmountHigh__c = copayTypeSelected.Copay_High__c;               
                                            clonedBenefit.OON_Copay_AmountIncrement__c = copayTypeSelected.Copay_Increment__c;
                                            clonedBenefit.OON_Copay_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
                                            clonedBenefit.OON_Copay_Additional_InvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;  
                                            }
                                            
                                            
                                        } 
                                        
                                if (bdp.Product_Category__c == 'Dental') {

                                            
                                            clonedBenefit.OutNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;
                                        if(benefit.OON_Coinsurance_Customized__c == false){
                                             clonedBenefit.OON_CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                             clonedBenefit.OON_Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;
                                        }
                                        if(benefit.OON_Copay_Type_1_IsCovered_Customized__c == false){     
                                              clonedBenefit.OON_Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                                             clonedBenefit.OON_Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                                        }
                                        if(benefit.OON_Copay_Type_1_Deductible_Customized__c == false){     
                                             clonedBenefit.OON_Copay_Type_1_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                                             clonedBenefit.OON_Copay_1_Default_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                                        }
                                        if(benefit.OON_Copay_Type_1_Amount_Customized__c){     
                                             clonedBenefit.OON_Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                             clonedBenefit.OON_Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                                        }
                                        if(benefit.DentalOONAnnualMaximumApplies_Customized__c == false){
                                             if(copayTypeSelected.AnnualMaximumApplies__c == 'Yes' || copayTypeSelected.AnnualMaximumApplies__c == 'Y'){     
                                                clonedBenefit.OON_AnnualMaximumApplies__c= 'Yes' ;       
                                            }       
                                            if(copayTypeSelected.AnnualMaximumApplies__c == 'No' || copayTypeSelected.AnnualMaximumApplies__c == 'N'){      
                                                clonedBenefit.OON_AnnualMaximumApplies__c= 'No' ;        
                                            }
                                           } 

                                           }
                                           
                                         if (bdp.Product_Category__c == 'Vision') {

                                            

                                            clonedBenefit.OutNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;
                                        if(benefit.OON_Coinsurance_Customized__c == false){
                                             clonedBenefit.OON_CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                             clonedBenefit.OON_Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;
                                        }
                                        if(benefit.OON_Copay_Type_1_IsCovered_Customized__c == false){     
                                              clonedBenefit.OON_Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                                             clonedBenefit.OON_Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                                        }
                                        if(benefit.OON_Copay_Type_1_Amount_Customized__c == false){     
                                             clonedBenefit.OON_Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                             clonedBenefit.OON_Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;

                                             clonedBenefit.OON_Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;
                                             clonedBenefit.OON_Copay_AmountLow__c = copayTypeSelected.Copay_Low__c;
                                             clonedBenefit.OON_Copay_AmountHigh__c = copayTypeSelected.Copay_High__c;
                                             clonedBenefit.OON_Copay_AmountIncrement__c = copayTypeSelected.Copay_Increment__c;
                                             clonedBenefit.OON_Copay_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
                                             clonedBenefit.OON_Copay_Additional_InvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;
                                         }
                                        if(benefit.OON_Discount_Amount_Customized__c == false){     
                                            clonedBenefit.OON_Discount_Amount__c = copayTypeSelected.Discount_Amount__c;
                                            clonedBenefit.OON_Discount_Amount_Default__c = copayTypeSelected.Discount_Amount__c;
                                        }
                                        if(benefit.OON_ScheduledAmounts_Customized__c == false){
                                            clonedBenefit.ON_Approximate_Member_Payment_w_Discount__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
                                            clonedBenefit.ON_Approx_Member_Payment_w_Disc_Default__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
                                        }
                                        if(benefit.OON_Allowed_Amount_Customized__c == false){
                                            clonedBenefit.OON_Allowed_Amount__c = copayTypeSelected.Allowed_Amount__c;
                                            clonedBenefit.OON_Allowed_Amount_Default__c= copayTypeSelected.Allowed_Amount__c;
                                        }
                                        if(benefit.OON_Discount_Applies_Customized__c == false){
                                            clonedBenefit.OON_Discount_Applies__c = copayTypeSelected.Discount_Applies__c;
                                            clonedBenefit.OON_Discount_Applies_Default__c = copayTypeSelected.Discount_Applies__c;
                                        }  
                                           }
                                                                    }
                                                                }
                                if(cBen !=null && cBen.copayTypePecSpecObj2!=null && bdp.Product_Category__c=='Medical' && cBen.copayTypeSelectedObj2.id!=cBen.copayTypePecSpecObj2.id){
                                    copayTypeSelected=cBen.copayTypePecSpecObj2;
                                    if(copayTypeSelected != null)
                                    {
                                     //system.debug('copayTypePecSpec2+++'+copayTypeSelected);
                            
                                        clonedBenefit.OutNetwork_ExtID_Copay2__c = copaytypeselected.ExtID__c;
                                        
                                       
                                        if(benefit.OON_Copay_Type_2_Customized__c == false){
                                        clonedBenefit.OON_Copay_Type_2_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                        clonedBenefit.OON_Copay_Type_2_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                                        
                                        clonedBenefit.OON_Copay_Type_2_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                        clonedBenefit.OON_Copay_Type_2_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                                        clonedBenefit.OON_Copay2_Low__c = copayTypeSelected.Copay_Low__c;
                                        clonedBenefit.OON_Copay2_High__c = copayTypeSelected.Copay_High__c;
                                        clonedBenefit.OON_Copay_Type_2_AliasName__c = copayTypeSelected.AliasName__c;
                                        clonedBenefit.OON_Copay2_Increment__c = copayTypeSelected.Copay_Increment__c;
                                        clonedBenefit.OON_Copay2Additional_InvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c ;
                                        clonedBenefit.OON_Copay_Type_2_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c; 


                                        }
                                    }
                                }
                                
                                 System.debug('+++++createWrapListFromPlanCostShr++++mapIDTobenefit++++'+mapIDTobenefit);
                         //System.debug(LoggingLevel.INFO,'+++++mapIDTobenefit+++++'+mapIDTobenefit);
                        // System.debug(LoggingLevel.INFO,'+++++mapIDTobenefit++++benefit.Benefit_Name__c+'+benefit.Benefit_Name__c);
                        //System.debug(LoggingLevel.INFO,'+++++createWrapListFromPlanCostShr++++mapIDTobenefit+++benefit.Benefit_Name__c+'+benefit.Benefit_Name__c);
                        if(mapIDTobenefit != null && mapIDTobenefit.containsKey(benefit.Benefit_Name__c))
                         {
                        AIA_Plan_Benefits__c aiaPlanbenefit = mapIDTobenefit.get(benefit.Benefit_Name__c);
                        //System.debug(LoggingLevel.INFO,'+++++mapIDTobenefit++++aiaPlanbenefit+'+aiaPlanbenefit); 
                        //System.debug(LoggingLevel.INFO,'+++++mapIDTobenefit++++maplst+'+maplst);                        
                        
                        if (benefit.Cost_Share_Customized__c == false || benefit.OON_Cost_Share_Customized__c == false){
                            if(aiaPlanbenefit.IS_ASO_Only__c == 'Yes' || aiaPlanbenefit.IS_ASO_Only__c == 'Y'){
                                clonedBenefit.IS_ASO_Only__c = True; 
                            }
                            if(aiaPlanbenefit.IS_ASO_Only__c== 'No' || aiaPlanbenefit.IS_ASO_Only__c== 'N'){
                                clonedBenefit.IS_ASO_Only__c = False;
                            }
                            clonedBenefit.Grouper__c = clonedGrouper.id;
                            }
                            if(benefit.Cost_Share_Customized__c == false){
                            clonedBenefit.Cost_Share_Type__c = aiaPlanbenefit.Cost_Share_Type__c;
                            clonedBenefit.DefaultPlanBenefitValue__c= costShareOldValMap.get(aiaPlanbenefit.Benefit_Name__c);
                             
                            if(benefit.benefit_name__c == 'Three Month Carryover Deductible'){
                            clonedBenefit.Cost_Share_SelectedAmount__c = (aiaPlanbenefit.Three_Month_Deductible_Carryover__c!=''?aiaPlanbenefit.Three_Month_Deductible_Carryover__c:'');//T01
                            clonedBenefit.Cost_Share_Default_Amount__c = (aiaPlanbenefit.Three_Month_Deductible_Carryover__c!=''?aiaPlanbenefit.Three_Month_Deductible_Carryover__c:'');//T01

                            }
                            
                            clonedBenefit.Cost_Share_Low__c = (aiaPlanbenefit.Cost_Share_Low__c!=''?aiaPlanbenefit.Cost_Share_Low__c:'0');
                            clonedBenefit.Cost_Share_High__c = (aiaPlanbenefit.Cost_Share_High__c!=''?aiaPlanbenefit.Cost_Share_High__c:'0');
                            clonedBenefit.Cost_Share_Increment__c = (aiaPlanbenefit.Cost_Share_Increment__c!=''?aiaPlanbenefit.Cost_Share_Increment__c:'0');
                            
                            if(benefit.benefit_name__c != 'Three Month Carryover Deductible'){
                            clonedBenefit.Cost_Share_SelectedAmount__c = (aiaPlanbenefit.Cost_Share_Default_Amount__c!=''?aiaPlanbenefit.Cost_Share_Default_Amount__c:'');
                            clonedBenefit.Cost_Share_Default_Amount__c = (aiaPlanbenefit.Cost_Share_Default_Amount__c!=''?aiaPlanbenefit.Cost_Share_Default_Amount__c:'');
                            }
                            
                            clonedBenefit.Cost_Share_InvalidIncrements__c = (aiaPlanbenefit.Cost_Share_InvalidIncrements__c!=''?aiaPlanbenefit.Cost_Share_InvalidIncrements__c:'0');
                            clonedBenefit.Cost_Share_AdditionalIncrements__c = (aiaPlanbenefit.Cost_Share_AdditionalIncrements__c!=''?aiaPlanbenefit.Cost_Share_AdditionalIncrements__c:'0'); 
                            
                            }
                            if(maplst.containskey(aiaPlanbenefit.Benefit_Name__c)){
                                if(benefit.OON_Cost_Share_Customized__c == false){
                                
                                clonedBenefit.OON_Cost_Share_Low__c = (maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_Low__c!=''?maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_Low__c:'0');
                                clonedBenefit.OON_Cost_Share_High__c = (maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_High__c!=''?maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_High__c:'0');
                                clonedBenefit.OON_Cost_Share_Increment__c = (maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_Increment__c!=''?maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_Increment__c:'0');
                                /*11-22-2016 change by indira -- as it was erroring out to check the new and old value*/
                                
                                if(benefit.benefit_name__c == 'Three Month Carryover Deductible'){
                                clonedBenefit.OON_Cost_Share_SelectedAmount__c = (maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_Default_Amount__c!=''?maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_Default_Amount__c:'');
                                clonedBenefit.OON_Cost_Share_Default_Amount__c = (maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_Default_Amount__c!=''?maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_Default_Amount__c:'');
                                }
                                
                                if(benefit.benefit_name__c != 'Three Month Carryover Deductible'){
                                clonedBenefit.OON_Cost_Share_SelectedAmount__c = (maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_Default_Amount__c!=''?maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_Default_Amount__c:'');
                                clonedBenefit.OON_Cost_Share_Default_Amount__c = (maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_Default_Amount__c!=''?maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_Default_Amount__c:'');
                                }
                                clonedBenefit.OON_Cost_Share_InvalidIncrements__c = (maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_InvalidIncrements__c!=''?maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_InvalidIncrements__c:'0');                     
                                clonedBenefit.OON_Cost_Share_AdditionalIncrements__c = (maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_AdditionalIncrements__c!=''?maplst.get(aiaPlanbenefit.Benefit_Name__c).Cost_Share_AdditionalIncrements__c:'0');
                                clonedBenefit.ON_CostShare_3Month_DeductibleCarryover__c = (maplst.get(aiaPlanbenefit.Benefit_Name__c).Three_Month_Deductible_Carryover__c!=''?maplst.get(aiaPlanbenefit.Benefit_Name__c).Three_Month_Deductible_Carryover__c:'');//T01
                                }
                            }
                        //}                       
                            
                           
                    }
                         
                        
                        }
                            system.debug('@@clonedBenefit==='+clonedBenefit);
                            clonedBenefitList.add(clonedBenefit);
                            
                        }
                    }
                    
                }
                
                Set<String> setClonedBenNames = new Set<String>();
                for(AIA_Benefits__c clonedben:clonedBenefitList)
                {
                    setClonedBenNames.add(clonedben.Benefit_Name__c);
                    system.debug('@@maxvalue=='+maxvalue);
                    system.debug('@@clonedben.Sequence_Number_SF__c=='+clonedben.Sequence_Number_SF__c);
                    Decimal tmpMaxValue = 0;
                    if(mapGrpIdTomaxValue.containsKey(clonedben.Grouper__c))
                    {
                        tmpMaxValue = mapGrpIdTomaxValue.get(clonedben.Grouper__c);                         
                    }                       
                    if(tmpMaxValue < clonedben.Sequence_Number_SF__c) { tmpMaxValue = clonedben.Sequence_Number_SF__c; }
                    mapGrpIdTomaxValue.put(clonedben.Grouper__c,tmpMaxValue);  
                }
                system.debug('@@setClonedBenNames==='+setClonedBenNames);
                 List<AggregateResult> agrmaxSeqNumber = [SELECT max(Sequence_Number__c)maxNum FROM AIA_Grouper__c where ID in: clonedGrouperList];
                    
                    Integer maxSeqNumberGrouper = Integer.ValueOf(agrmaxSeqNumber[0].get('maxNum'));
                    
                   List<AggregateResult> agrmaxSeqNumber2 = [SELECT max(Sequence_Number_SF__c)maxNum FROM AIA_Benefits__c where Grouper__c in: clonedGrouperList
                                                                     and Benefit_Type__c = 'Benefit'];
                        Integer  maxSeqNumber = Integer.ValueOf(agrmaxSeqNumber2[0].get('maxNum'));
                for(string strben:SetBenifitname)
                {
                    if (copayBenMap != null && copayBenMap.containsKey(strben) && !setClonedBenNames.Contains(strben))
                    {
                        setNewBenefits.add(strben);
                        //if(BeneNameToPPMap != null && BeneNameToPPMap.ContainsKey(strben))
                        //{
                       /* AIA_Benefit_Design_Product__c bdp1 = mapbenefitNameToBDPID.get(strben);
                        AIA_Benefit_Design_Product__c bdp2 = mapOldIdToOldBDP.get(bdp1.id);*/ //Unused variables 
                        system.debug('@@strben==='+strben);
                        
                        AIA_Benefits__c clonedBenefit = ClonebenifitFromCopay(strben,bdp,clonedGrouperList,maxSeqNumberGrouper ,maxSeqNumber );
                       if(maxSeqNumber == null){
                                maxSeqNumber = 0;
                            }                           
                            maxSeqNumber = maxSeqNumber+1; 
                            clonedBenefit.Sequence_Number_SF__c = maxSeqNumber;
                            clonedBenefit.Sequence_Number__c = maxSeqNumber;
                        clonedBenefitList.add(clonedBenefit);
                        BeneNameToBenefit.put(strben,clonedBenefit); 
                        
                    }
                }
                system.debug('@@clonedBenefitList'+clonedBenefitList);
                system.debug('@@clonedBenefitList'+clonedBenefitList);
                if(clonedBenefitList != NULL && clonedBenefitList.size()>0)
                    insert clonedBenefitList;   
            } 
              
            Map<String,boolean> mapManBenNameToIsCustom = new Map<String,boolean>(); 
            Map<String,boolean> mapLimitBenNameToIsCustom = new Map<String,boolean>(); 
            Map<String,boolean> mapLimitToIsCustom = new Map<String,boolean>(); 
            
             for(String str:BeneLimitationMap.KeySet()){ 
            list<Limitations__c> tempLimitList = BeneLimitationMap.get(str);
            system.debug('@@BeneNameLimitationMap==tempLimitList='+tempLimitList);
            boolean isCustom = false;
            system.debug(LoggingLevel.INFO,'@@tempLimitList*==='+tempLimitList);
            for(Limitations__c limi:tempLimitList){
                if(limi.IsCustom__c == 'Yes' || limi.recordtype__c == 'BRF' || limi.Benefit__r.CommentCode_Custom__c==True || limi.Benefit__r.CommentCode_NonStandard__c==True)
                {
                    isCustom = true; 
                    system.debug('@@limi==='+limi);
                }                   
            }
            mapLimitToIsCustom.put(str,isCustom);
         }
            system.debug('@@mapLimitToIsCustom==='+mapLimitToIsCustom);
            system.debug(LoggingLevel.INFO,'@@mapLimitToIsCustom==='+mapLimitToIsCustom);
            
            //Cloning associated Benefits Limitations
            List<Limitations__c> clonedLimitList = new list<Limitations__c>();
            if(clonedBenefitList != NULL && clonedBenefitList.size()>0){
                for(AIA_Benefits__c clonedBen:clonedBenefitList){
                    boolean IsLimitCustom = false;
                    system.debug(Logginglevel.INFO,'@@clonedBen.Benefit_Name__c==='+clonedBen.Benefit_Name__c);
                    system.debug(Logginglevel.INFO,'@@BeneNameLimitationMap.containsKey(clonedBen.Benefit_Name__c)==='+BeneNameLimitationMap.containsKey(clonedBen.Benefit_Name__c));
                    if(BeneLimitationMap.get(clonedBen.Cloned_From_Benefit__c)!=null){
                        if(mapLimitToIsCustom.containsKey(clonedBen.Cloned_From_Benefit__c)){
                            IsLimitCustom = mapLimitToIsCustom.get(clonedBen.Cloned_From_Benefit__c);
                        }
                        system.debug(Logginglevel.INFO,'IsLimitCustom==='+IsLimitCustom);
                        system.debug(Logginglevel.INFO,'isDataAvailable==='+isDataAvailable);
                        if(IsLimitCustom || !isDataAvailable)
                        {
                            system.debug(Logginglevel.INFO,'@@BeneLimitationMap==clonedLimitList='+BeneNameLimitationMap.get(clonedBen.Benefit_Name__c));
                            if(BeneLimitationMap.get(clonedBen.Cloned_From_Benefit__c)!=null){
                                list<Limitations__c> tempLimitList = BeneLimitationMap.get(clonedBen.Cloned_From_Benefit__c);
                                
                                system.debug(Logginglevel.INFO,'@@tempLimitList'+tempLimitList);
                                for(Limitations__c limi:tempLimitList){
                                    
                                    Limitations__c clonedLimi = new Limitations__c();
                                    clonedLimi=limi.clone();
                                    clonedLimi.Benefit__c =clonedBen.id;
                                    clonedLimitList.add(clonedLimi);
                                    
                                }
                            }
                            system.debug(Logginglevel.INFO,'@@clonedLimitList==IsLimitCustom=='+clonedLimitList);
                        }
                        else
                        {
                           if(ParentBenLimitationMan.get(clonedBen.Benefit_Name__c)!=null){
                            if(clonedBen.Benefit_Type__c == 'Mandate')
                            {
                            list<Limitations__c> tempLimitList = ParentBenLimitationMan.get(clonedBen.Benefit_Name__c);
                            system.debug(Logginglevel.INFO,'@@tempLimitList==Mandate=='+tempLimitList);
                            system.debug(Logginglevel.INFO,'ParentBenLimitationMan---===Mandate=='+ clonedBen.Benefit_Name__c + 'Limitaions===' + tempLimitList);
                            for(Limitations__c limi:tempLimitList){
                                Limitations__c clonedLimi = new Limitations__c();
                                clonedLimi=limi.clone();
                                clonedLimi.Benefit__c =clonedBen.id;
                                clonedLimitList.add(clonedLimi);
                                
                            }
                            system.debug(Logginglevel.INFO,'@@clonedLimitList==IsLimitCustom==Mandate=='+clonedLimitList);
                            }
                            }
                            system.debug('@@ParentBenLimitationLimit==clonedLimitList='+ParentBenLimitationLimit.get(clonedBen.Benefit_Name__c));
                            if(ParentBenLimitationLimit.get(clonedBen.Benefit_Name__c)!=null){
                                if(clonedBen.Benefit_Type__c == 'Limitation')
                                {
                                list<Limitations__c> tempLimitList = ParentBenLimitationLimit.get(clonedBen.Benefit_Name__c);
                                system.debug(Logginglevel.INFO,'@@ParentBenLimitationLimit==tempLimitList==Limit=='+tempLimitList);
                                system.debug(Logginglevel.INFO,'ParentBenLimitationLimit---===Limit=='+ clonedBen.Benefit_Name__c + 'Limitaions===' + tempLimitList);
                                for(Limitations__c limi:tempLimitList){
                                    Limitations__c clonedLimi = new Limitations__c();
                                    clonedLimi=limi.clone();
                                    clonedLimi.Benefit__c =clonedBen.id;
                                    clonedLimitList.add(clonedLimi);
                                    
                                }
                                system.debug(Logginglevel.INFO,'@@clonedLimitList==IsLimitCustom==Limitaaion=='+clonedLimitList);
                                }
                            } 
                            
                        } 
                    }
                }            
            }
            system.debug(Logginglevel.INFO,'@@clonedLimitList=='+clonedLimitList);          
            Set<id> setbenids =new  set<id>();
        for(string strben:setNewBenefits)
        {
             if (copayBenMap != null && copayBenMap.containsKey(strben))
            {
                
                system.debug('@@strben==='+strben);
                CopayTypeWrapper  cBen = copayBenMap.get(strben);
                if(cBen !=null){                    
                    if(cBen.copayTypeSelectedObj != null)
                    {
                        setbenids.add(cBen.copayTypeSelectedObj.Plan_Benefits__c);
                    }
                    if(cBen.copayTypePecSpecObj != null)
                    {
                        setbenids.add(cBen.copayTypePecSpecObj.Plan_Benefits__c);
                    }
                    if(cBen.copayTypeSelectedObj2 != null)
                    {
                        setbenids.add(cBen.copayTypeSelectedObj2.Plan_Benefits__c );
                    }
                    if(cBen.copayTypePecSpecObj2 != null)
                    {
                        setbenids.add(cBen.copayTypePecSpecObj2.Plan_Benefits__c);
                    }
                }
            }
        }
        
       
        AIA_BD_DeepCloneHelper aiaBDDeepHelper = new AIA_BD_DeepCloneHelper();
        aiaBDDeepHelper.getPlanLimitation(setbenids,Currentbdp);
        aiaBDDeepHelper.getPlanCommentCodes(Currentbdp);
        ParentBenLimitationMan = aiaBDDeepHelper.ParentBenLimitationMan;
        ParentBenLimitationLimit = aiaBDDeepHelper.ParentBenLimitationLimit;
        List<AIA_Benefits__c> lstOldbenefitsToUpdate = new List<AIA_Benefits__c>();
        Map<String,AIA_Benefits__c> newBenefits = new Map<String,AIA_Benefits__c>();
        for(string strben:setNewBenefits)
        {
             system.debug(Logginglevel.INFO,'strben---==='+ strben);
            system.debug(Logginglevel.INFO,'copayBenMap.containsKey(strben)---==='+ copayBenMap.containsKey(strben));   
            if (copayBenMap != null && copayBenMap.containsKey(strben))
            {
                if(ParentBenLimitationMan.get(strben)!=null){
                    AIA_Benefits__c oldBenefitToClone = BeneNameToBenefit.get(strben);
                    if(oldBenefitToClone != null)
                    {
                        AIA_Benefits__c newLimitBenefit = new AIA_Benefits__c(); 
                        newLimitBenefit = oldBenefitToClone.clone();
                        newLimitBenefit.Benefit_Type__c = 'Mandate' ;
                        newLimitBenefit.Sequence_Number_SF__c = oldBenefitToClone.Sequence_Number_SF__c - 0.5;
                        newBenefits.put(strben+'_Mandate',newLimitBenefit);
                    }                                
                }
                if(ParentBenLimitationLimit.get(strben)!=null){
                    AIA_Benefits__c oldBenefitToClone = BeneNameToBenefit.get(strben);
                    system.debug(Logginglevel.INFO,'oldBenefitToClone ---==='+ oldBenefitToClone);
                    if(oldBenefitToClone!=null){
                        AIA_Benefits__c newLimitBenefit = new AIA_Benefits__c(); 
                        newLimitBenefit = oldBenefitToClone.clone();
                        newLimitBenefit.Benefit_Type__c = 'Limitation' ;                
                        newLimitBenefit.Sequence_Number_SF__c = oldBenefitToClone.Sequence_Number_SF__c + 0.5;
                        newBenefits.put(strben+'_Limitation',newLimitBenefit);  
                    }
                }
            }
        }
        insert newBenefits.Values();
        for(string strben:setNewBenefits)
        {
             system.debug(Logginglevel.INFO,'strben---==='+ strben);
            system.debug(Logginglevel.INFO,'copayBenMap.containsKey(strben)---==='+ copayBenMap.containsKey(strben));   
            if (copayBenMap != null && copayBenMap.containsKey(strben))
            {
                if(ParentBenLimitationMan.get(strben)!=null){
                AIA_Benefits__c oldBenefitToClone = BeneNameToBenefit.get(strben); 
                oldBenefitToClone.Parent_Mandate_Benefit__c= newBenefits.get(strben+'_Mandate').id;//newLimitBenefit.id;
                lstOldbenefitsToUpdate.add(oldBenefitToClone);
                //update  oldBenefitToClone;
                    list<Limitations__c> tempLimitList = ParentBenLimitationMan.get(strben);
                    system.debug('@@tempLimitList'+tempLimitList);
                    for(Limitations__c limi:tempLimitList){
                        Limitations__c clonedLimi = new Limitations__c();
                        clonedLimi=limi.clone();
                        clonedLimi.Benefit__c = newBenefits.get(strben+'_Mandate').id;
                        clonedLimitList.add(clonedLimi);
                       
                    }
                    system.debug(Logginglevel.INFO,'clonedLimi---ParentBenLimitationMan===up=='+clonedLimitList); 
                }
                system.debug(Logginglevel.INFO,'ParentBenLimitationLimit.get(strben)---==='+ ParentBenLimitationLimit.get(strben));
                if(ParentBenLimitationLimit.get(strben)!=null){
                    AIA_Benefits__c oldBenefitToClone = BeneNameToBenefit.get(strben);
                    system.debug(Logginglevel.INFO,'oldBenefitToClone ---==='+ oldBenefitToClone);
                if(oldBenefitToClone!=null){
               
                 oldBenefitToClone.Parent_Benefit__c = newBenefits.get(strben+'_Limitation').id;      
                //update  oldBenefitToClone;
                lstOldbenefitsToUpdate.add(oldBenefitToClone); 
                    list<Limitations__c> tempLimitList = ParentBenLimitationLimit.get(strben);
                    system.debug(Logginglevel.INFO,'tempLimitList ---==='+ tempLimitList );
                    system.debug('@@ParentBenLimitationLimit==tempLimitList'+tempLimitList);
                    for(Limitations__c limi:tempLimitList){
                        Limitations__c clonedLimi = new Limitations__c();
                        clonedLimi=limi.clone();
                        clonedLimi.Benefit__c =newBenefits.get(strben+'_Limitation').id;
                        system.debug(Logginglevel.INFO,'clonedLimi---ParentBenLimitationLimit==='+clonedLimi);
                        clonedLimitList.add(clonedLimi);
                      }
system.debug(Logginglevel.INFO,'clonedLimi---ParentBenLimitationMan===oldBenefitToClone=='+clonedLimitList);                      
                    }
                }
                
            }
        }
        system.debug(Logginglevel.INFO,'clonedLimitList---Final==='+clonedLimitList);
        insert clonedLimitList;
        if(lstOldbenefitsToUpdate != null && lstOldbenefitsToUpdate.size()>0)
            update lstOldbenefitsToUpdate;
        system.debug(Logginglevel.INFO,'clonedLimitList---Final==='+clonedLimitList);                 
        }catch(Exception e){
            system.debug('Exception in cloning of Records :'+e.getLineNumber()+'Message'+e.getmessage());
            system.debug(Logginglevel.INFO,'Exception in cloning of Records INFO :'+e.getLineNumber()+' Message:'+e.getmessage());
        }
        return null;//new PageReference('/'+BrfID);
    }

Transient Map<String,AIA_Plan_Copay_Type__c> ParentBenifitMandateName= new Map<String,AIA_Plan_Copay_Type__c>();
    
    /**
* @Author: Sree Harsha 
* @ This is a wrapper class to store AIA_Plan_Copay_Type__c data
* @param -  
* @Output - 
*/    
    public class CopayTypeWrapper {
        public AIA_Plan_Copay_Type__c copayTypeSelectedObj  {get; set;} 
        public AIA_Plan_Copay_Type__c copayTypePecSpecObj   {get; set;}
        public AIA_Plan_Copay_Type__c copayTypeSelectedObj2  {get; set;} 
        public AIA_Plan_Copay_Type__c copayTypePecSpecObj2   {get; set;}
        public CopayTypeWrapper(){
            this.copayTypeSelectedObj = new AIA_Plan_Copay_Type__c();
            this.copayTypePecSpecObj = new AIA_Plan_Copay_Type__c();
            this.copayTypeSelectedObj2 = new AIA_Plan_Copay_Type__c();
            this.copayTypePecSpecObj2 = new AIA_Plan_Copay_Type__c();
        }
    }
    
    /**
* @Author: Sree Harsha 
* @ It will call to create extra benefit which will come from PCS.
* @param - string benefitname,AIA_Benefit_Design_Product__c bdp,list<AIA_Grouper__c> clonedGrouperList
* @Output - AIA_Benefits__c
*/ 
    public AIA_Benefits__c ClonebenifitFromCopay(string benefitname,AIA_Benefit_Design_Product__c bdp,list<AIA_Grouper__c> clonedGrouperList,Integer maxSeqNumberGrouper ,Integer maxSeqNumber) {
        AIA_Benefits__c clonedBenefit = new AIA_Benefits__c() ;
        CopayTypeWrapper  cBen = null;
        Id benefitPPRTypeId = Schema.SObjectType.AIA_Benefits__c.RecordTypeInfosByName.get('BD Product').RecordTypeId;
        Id PPRTypeId = Schema.SObjectType.AIA_Grouper__c.RecordTypeInfosByName.get('BD Product').RecordTypeId;
        system.debug('ClonebenifitFromCopay++benefitname+++' + benefitname +'copayBenMap>>'+copayBenMap);
        if (copayBenMap != null && copayBenMap.containsKey(benefitname))
            cBen = copayBenMap.get(benefitname);
        System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
       // List<AggregateResult> agrmaxSeqNumber = [SELECT max(Sequence_Number__c)maxNum FROM AIA_Grouper__c where ID in: clonedGrouperList];
         System.debug('2.Number of Queries used in this apex code so far: ' + Limits.getQueries());
      //  Integer maxSeqNumberGrouper = Integer.ValueOf(agrmaxSeqNumber[0].get('maxNum'));
        if(maxSeqNumberGrouper == null){
            maxSeqNumberGrouper = 0;
        }
        maxSeqNumberGrouper = maxSeqNumberGrouper +1;
        system.debug('ClonebenifitFromCopay++cBen +++' + cBen );
        AIA_Plan_Copay_Type__c copayTypeSelected = new AIA_Plan_Copay_Type__c();
        if (cBen != null && cBen.copayTypeSelectedObj != null) {
            copayTypeSelected = cBen.copayTypeSelectedObj;
            system.debug('copayTypeSelected1+++' + copayTypeSelected);
            
            if (copayTypeSelected != null) {
                //  clonedBenefit.Grouper__c=clonedGrouper.id;
                for(AIA_Grouper__c aiagrp:clonedGrouperList)
                {
                    system.debug('aiagrp.Name++' + aiagrp.Name);
                    system.debug('aiagrp.Name++' + copayTypeSelected.Grouper_Name__c);
                    system.debug('copayTypeSelected.Grouper_Name__c++' + copayTypeSelected.Grouper_Name__c);
                    system.debug('aiagrp.Benefit_Design_Product__c++' + aiagrp.Benefit_Design_Product__c);
                    system.debug('bdp.id++' + bdp.id);
                    if(aiagrp.Name == copayTypeSelected.Grouper_Name__c && aiagrp.Benefit_Design_Product__c == bdp.id)
                    {
                        clonedBenefit.Grouper__c=aiagrp.id;
                    }
                    
                }
                system.debug('clonedBenefit.Grouper__c+++' + clonedBenefit.Grouper__c);
                
                if(clonedBenefit.Grouper__c == null)
                {
                    AIA_Grouper__c clonedGrouper = new AIA_Grouper__c();
                    system.debug('clonedGrouper.Benefit_Design_Product__c = bdp.id');
                    clonedGrouper.Benefit_Design_Product__c = bdp.id;
                    system.debug('clonedGrouper.Name = copayTypeSelected.Grouper_Name__c++');
                    clonedGrouper.Name = copayTypeSelected.Grouper_Name__c;  
                    system.debug('clonedGrouper.recordTypeId= PPRTypeId++');
                    clonedGrouper.recordTypeId= PPRTypeId;
                    system.debug('clonedGrouper.Grouper_Record_Type__c BDD');
                    clonedGrouper.Grouper_Record_Type__c = copayTypeSelected.Plan_Benefits__r.Record_Type__c;
                    system.debug('clonedGrouper.Group_Type__c++');
                    clonedGrouper.Group_Type__c= 'Benefit Group';
                    clonedGrouper.Sequence_Number__c = maxSeqNumberGrouper ;
                    system.debug('clonedGrouper+++' + clonedGrouper);
                    //clonedGrouper.Sequence_Number__c = parentGrouper.Sequence_Number__c;
                    insert clonedGrouper;
                    clonedBenefit.Grouper__c=clonedGrouper.id;
                }
                system.debug('bdp+++Medical++' + bdp);
                system.debug('benefitPPRTypeId+++Medical++' + benefitPPRTypeId);
                clonedBenefit.recordTypeId=benefitPPRTypeId;
                clonedBenefit.Benefit_Record_Type__c = copayTypeSelected.Plan_Benefits__r.Record_Type__c;
                clonedBenefit.benefit_name__c=benefitname;
                IF(bdp.Product_Category__c == 'Medical') {
                    
                    system.debug('copayTypeSelected+++Medical++' + copayTypeSelected);
                    clonedBenefit.DefaultPlanBenefitValue__c=  (copayTypeSelected.IsCovered__c!=null?copayTypeSelected.IsCovered__c:'')
                        +'_'+(copayTypeSelected.CoinsuranceAmount__c!=null?String.valueof(copayTypeSelected.CoinsuranceAmount__c):'')
                        +'_'+ (copayTypeSelected.DeductibleApplies__c!=null?copayTypeSelected.DeductibleApplies__c:'')
                        +'_'+(copayTypeSelected.CopayAmount__c!=null?String.valueof(copayTypeSelected.CopayAmount__c):'')+'_';
                    // system.debug('benefit+++Medical++' + benefit);
                    clonedBenefit.InNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;   
                    clonedBenefit.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                    clonedBenefit.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;   
                    clonedBenefit.Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                    clonedBenefit.Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';    
                    clonedBenefit.Copay_Type_1_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                    clonedBenefit.Copay_Type_1_Default_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                    clonedBenefit.Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                    clonedBenefit.Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                    clonedBenefit.Copay_Type_1_Low__c = copayTypeSelected.Copay_Low__c;
                    clonedBenefit.Copay_Type_1_High__c = copayTypeSelected.Copay_High__c;
                    clonedBenefit.Copay_Type_1_Increment__c = copayTypeSelected.Copay_Increment__c;
                    clonedBenefit.Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;
                    clonedBenefit.Copay_Type_1_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
                    clonedBenefit.Copay_Type_1_AdditionalInvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;
                    
                    
                    
                    if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Y') {
                        clonedBenefit.IS_ASO_Only__c = True;
                    }
                    if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'N') {
                        clonedBenefit.IS_ASO_Only__c = False;
                    }
                    
                    clonedBenefit.IsAppGlobalCoinsurance__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCoinsurance__c;
                    clonedBenefit.IsAppGlobalCopay__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCopay__c;
                    
                    
                    
                } else if (bdp.Product_Category__c == 'Drug') {
                    
                    clonedBenefit.InNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;
                    clonedBenefit.DefaultPlanBenefitValue__c=  (copayTypeSelected.IsCovered__c!=null?copayTypeSelected.IsCovered__c:'')+'_'
                        +(copayTypeSelected.CopayAmount__c!=null?String.valueof(copayTypeSelected.CopayAmount__c):'')
                        +'_'+(copayTypeSelected.CoinsuranceAmount__c!=null?String.valueof(copayTypeSelected.CoinsuranceAmount__c):'')
                        +'_'+(copayTypeSelected.MinPayAmount__c!=null?String.valueof(copayTypeSelected.MinPayAmount__c):'')
                        +'_'+(copayTypeSelected.MaxPayAmount__c!=null?String.valueof(copayTypeSelected.MaxPayAmount__c):'')
                        +'_'+(copayTypeSelected.TierType__c!=null?copayTypeSelected.TierType__c:'');
                    
                    clonedBenefit.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                    clonedBenefit.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;
                    clonedBenefit.Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                    clonedBenefit.Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                    clonedBenefit.Copay_Max_Payment__c = copayTypeSelected.MaxPayAmount__c;
                    clonedBenefit.Copay_Default_Max_Payment__c = copayTypeSelected.MaxPayAmount__c;
                    clonedBenefit.Tier_type__c = copayTypeSelected.TierType__c;
                    clonedBenefit.Tier_Type_Default__c = copayTypeSelected.TierType__c;
                    if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Y') {
                        clonedBenefit.IS_ASO_Only__c = True;
                    }
                    if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'N') {
                        clonedBenefit.IS_ASO_Only__c = False;
                    }
                    
                    clonedBenefit.IsAppGlobalCoinsurance__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCoinsurance__c;
                    clonedBenefit.IsAppGlobalCopay__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCopay__c;
                }
    
    if (bdp.Product_Category__c == 'Vision') {

    clonedBenefit.InNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;
    clonedBenefit.Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;

        clonedBenefit.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
        clonedBenefit.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;   

        clonedBenefit.Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
        clonedBenefit.Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';  

        clonedBenefit.Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
        clonedBenefit.Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
        clonedBenefit.Copay_Type_1_Low__c = copayTypeSelected.Copay_Low__c;
        clonedBenefit.Copay_Type_1_High__c = copayTypeSelected.Copay_High__c;
        clonedBenefit.Copay_Type_1_Increment__c = copayTypeSelected.Copay_Increment__c;
        clonedBenefit.Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;
        clonedBenefit.Copay_Type_1_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
        clonedBenefit.Copay_Type_1_AdditionalInvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;     
        
        clonedBenefit.Discount_Amount__c = copayTypeSelected.Discount_Amount__c;
        clonedBenefit.Discount_Amount_Default__c = copayTypeSelected.Discount_Amount__c;

        clonedBenefit.IN_Approximate_Member_Payment_w_Discount__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
        clonedBenefit.IN_Approx_Member_Payment_w_Disc_Default__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;

        clonedBenefit.Allowed_Amount__c = copayTypeSelected.Allowed_Amount__c;
        clonedBenefit.Allowed_Amount_Default__c= copayTypeSelected.Allowed_Amount__c;

        clonedBenefit.Discount_Applies__c = copayTypeSelected.Discount_Applies__c;
        clonedBenefit.Discount_Applies_Default__c= copayTypeSelected.Discount_Applies__c;

        clonedBenefit.Davis_Benefit_Variable__c = copayTypeSelected.Plan_Benefits__r.Davis_Benefit_Variable__c;
        clonedBenefit.Davis_Benefit_Variable_Default__c = copayTypeSelected.Plan_Benefits__r.Davis_Benefit_Variable__c;
                                
     if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Y') {
      clonedBenefit.IS_ASO_Only__c = True;
     }
     if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'N') {
      clonedBenefit.IS_ASO_Only__c = False;
     }

     clonedBenefit.IsAppGlobalCoinsurance__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCoinsurance__c;
     clonedBenefit.IsAppGlobalCopay__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCopay__c;

    }   
 IF(bdp.Product_Category__c == 'Dental') {
    

    clonedBenefit.InNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;   
    
    clonedBenefit.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
    clonedBenefit.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;   
    
     clonedBenefit.Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
     clonedBenefit.Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';   
     
     clonedBenefit.Copay_Type_1_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
     clonedBenefit.Copay_Type_1_Default_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
     
    if(copayTypeSelected.AnnualMaximumApplies__c == 'Yes' || copayTypeSelected.AnnualMaximumApplies__c == 'Y'){     
        clonedBenefit.AnnualMaximumApplies__c= 'Yes' ;       
    }       
    if(copayTypeSelected.AnnualMaximumApplies__c == 'No' || copayTypeSelected.AnnualMaximumApplies__c == 'N'){      
        clonedBenefit.AnnualMaximumApplies__c= 'No' ;        
    }

     if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Y') {
      clonedBenefit.IS_ASO_Only__c = True;
     }
     if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'N') {
      clonedBenefit.IS_ASO_Only__c = False;
     }

     clonedBenefit.IsAppGlobalCoinsurance__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCoinsurance__c;
     clonedBenefit.IsAppGlobalCopay__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCopay__c;

    

   }  
                
                
            }
        }
        
        
        if (cBen != null && cBen.copayTypePecSpecObj != null) { // && pp.Product_Category__c=='Medical'
            copayTypeSelected = cBen.copayTypePecSpecObj;
            if (copayTypeSelected != null && cBen.copayTypeSelectedObj.id !=cBen.copayTypePecSpecObj.id) {
                for(AIA_Grouper__c aiagrp:clonedGrouperList)
                {
                    system.debug('aiagrp.Name++' + aiagrp.Name);
                    system.debug('aiagrp.Name++' + copayTypeSelected.Grouper_Name__c);
                    system.debug('copayTypeSelected.Grouper_Name__c++' + copayTypeSelected.Grouper_Name__c);
                    system.debug('aiagrp.Benefit_Design_Product__c++' + aiagrp.Benefit_Design_Product__c);
                    system.debug('bdp.id++' + bdp.id);
                    
                    if(aiagrp.Name == copayTypeSelected.Grouper_Name__c && aiagrp.Benefit_Design_Product__c == bdp.id)
                    {
                        clonedBenefit.Grouper__c=aiagrp.id;
                    }
                    
                }
                system.debug('clonedBenefit.Grouper__c+++' + clonedBenefit.Grouper__c);
                
                if(clonedBenefit.Grouper__c == null)
                {
                    AIA_Grouper__c clonedGrouper = new AIA_Grouper__c(); 
                    system.debug('clonedGrouper.Benefit_Design_Product__c = bdp.id');
                    clonedGrouper.Benefit_Design_Product__c = bdp.id;
                    system.debug('clonedGrouper.Name = copayTypeSelected.Grouper_Name__c++');
                    clonedGrouper.Name = copayTypeSelected.Grouper_Name__c;  
                    system.debug('clonedGrouper.recordTypeId= PPRTypeId++');
                    clonedGrouper.recordTypeId= PPRTypeId;
                    system.debug('clonedGrouper.Grouper_Record_Type__c BDD');
                    clonedGrouper.Grouper_Record_Type__c = copayTypeSelected.Plan_Benefits__r.Record_Type__c;
                    system.debug('clonedGrouper.Group_Type__c++');
                    system.debug('clonedGrouper+++' + clonedGrouper);
                    clonedGrouper.Group_Type__c= 'Benefit Group';
                    clonedGrouper.Sequence_Number__c = maxSeqNumberGrouper ;
                    insert clonedGrouper;
                    clonedBenefit.Grouper__c=clonedGrouper.id;
                }
                clonedBenefit.DefaultPlanBenefitValue__c=  (copayTypeSelected.IsCovered__c!=null?copayTypeSelected.IsCovered__c:'')
                    +'_'+(copayTypeSelected.CoinsuranceAmount__c!=null?String.valueof(copayTypeSelected.CoinsuranceAmount__c):'')
                    +'_'+ (copayTypeSelected.DeductibleApplies__c!=null?copayTypeSelected.DeductibleApplies__c:'')
                    +'_'+(copayTypeSelected.CopayAmount__c!=null?String.valueof(copayTypeSelected.CopayAmount__c):'')+'_';
                system.debug('copayTypePecSpec1+++' + copayTypeSelected);
                clonedBenefit.recordTypeId=benefitPPRTypeId;
                clonedBenefit.Benefit_Record_Type__c = copayTypeSelected.Plan_Benefits__r.Record_Type__c;
                clonedBenefit.benefit_name__c=benefitname;
                clonedBenefit.InNetwork_ExtID_Copay2__c = copaytypeselected.ExtID__c;
                
                clonedBenefit.Copay_Type_2_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                clonedBenefit.Copay_Type_2_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                
                clonedBenefit.Copay_Type_2_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                clonedBenefit.Copay_Type_2_Low__c = copayTypeSelected.Copay_Low__c;
                clonedBenefit.Copay_Type_2_High__c = copayTypeSelected.Copay_High__c;
                clonedBenefit.Copay_Type_2_Increment__c = copayTypeSelected.Copay_Increment__c;
                clonedBenefit.CopayType2_Additional_InvalidIncrement__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;
                clonedBenefit.Copay_Type_2_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
                clonedBenefit.Copay_Type_2_AliasName__c = copayTypeSelected.AliasName__c;
            }
            
        }
        if (cBen != null && cBen.copayTypeSelectedObj2 != null) {
            copayTypeSelected = cBen.copayTypeSelectedObj2;
            if (copayTypeSelected != null) {
                for(AIA_Grouper__c aiagrp:clonedGrouperList)
                {
                    system.debug('aiagrp.Name++' + aiagrp.Name);
                    system.debug('aiagrp.Name++' + copayTypeSelected.Grouper_Name__c);
                    system.debug('copayTypeSelected.Grouper_Name__c++' + copayTypeSelected.Grouper_Name__c);
                    system.debug('aiagrp.Benefit_Design_Product__c++' + aiagrp.Benefit_Design_Product__c);
                    system.debug('bdp.id++' + bdp.id);
                    if(aiagrp.Name == copayTypeSelected.Grouper_Name__c && aiagrp.Benefit_Design_Product__c == bdp.id)
                    {
                        clonedBenefit.Grouper__c=aiagrp.id;
                    }
                    
                }
                system.debug('clonedBenefit.Grouper__c+++' + clonedBenefit.Grouper__c);
                
                if(clonedBenefit.Grouper__c == null)
                {
                    AIA_Grouper__c clonedGrouper = new AIA_Grouper__c(); 
                    system.debug('clonedGrouper.Benefit_Design_Product__c = bdp.id');
                    clonedGrouper.Benefit_Design_Product__c = bdp.id;
                    system.debug('clonedGrouper.Name = copayTypeSelected.Grouper_Name__c++');
                    clonedGrouper.Name = copayTypeSelected.Grouper_Name__c;  
                    system.debug('clonedGrouper.recordTypeId= PPRTypeId++');
                    clonedGrouper.recordTypeId= PPRTypeId;
                    system.debug('clonedGrouper.Grouper_Record_Type__c BDD');
                    clonedGrouper.Grouper_Record_Type__c = copayTypeSelected.Plan_Benefits__r.Record_Type__c;
                    system.debug('clonedGrouper.Group_Type__c++');
                    system.debug('clonedGrouper+++' + clonedGrouper);
                    clonedGrouper.Group_Type__c= 'Benefit Group';
                    clonedGrouper.Sequence_Number__c = maxSeqNumberGrouper ;
                    
                    insert clonedGrouper;
                    clonedBenefit.Grouper__c=clonedGrouper.id;
                }  
                clonedBenefit.recordTypeId=benefitPPRTypeId;
                clonedBenefit.Benefit_Record_Type__c = copayTypeSelected.Plan_Benefits__r.Record_Type__c;
                clonedBenefit.benefit_name__c=benefitname;
                system.debug('copayTypeSelected2+++' + copayTypeSelected);
                if (bdp.Product_Category__c == 'Medical') {
                    clonedBenefit.DefaultPlanBenefitValue__c=  (copayTypeSelected.IsCovered__c!=null?copayTypeSelected.IsCovered__c:'')
                        +'_'+(copayTypeSelected.CoinsuranceAmount__c!=null?String.valueof(copayTypeSelected.CoinsuranceAmount__c):'')
                        +'_'+ (copayTypeSelected.DeductibleApplies__c!=null?copayTypeSelected.DeductibleApplies__c:'')
                        +'_'+(copayTypeSelected.CopayAmount__c!=null?String.valueof(copayTypeSelected.CopayAmount__c):'')+'_';
                    clonedBenefit.OutNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;
                    clonedBenefit.OON_CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                    clonedBenefit.OON_Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;
                    clonedBenefit.OON_Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                    clonedBenefit.OON_Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                    clonedBenefit.OON_Copay_Type_1_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                    clonedBenefit.OON_Copay_1_Default_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                    clonedBenefit.OON_Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                    clonedBenefit.OON_Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                    
                    clonedBenefit.OON_Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;
                    clonedBenefit.OON_Copay_AmountLow__c = copayTypeSelected.Copay_Low__c;
                    clonedBenefit.OON_Copay_AmountHigh__c = copayTypeSelected.Copay_High__c;
                    clonedBenefit.OON_Copay_AmountIncrement__c = copayTypeSelected.Copay_Increment__c;
                    clonedBenefit.OON_Copay_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
                    clonedBenefit.OON_Copay_Additional_InvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;
                    
                }
                
     if (bdp.Product_Category__c == 'Dental') {

    
    clonedBenefit.OutNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;

     clonedBenefit.OON_CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
     clonedBenefit.OON_Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;
      clonedBenefit.OON_Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
     clonedBenefit.OON_Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
     clonedBenefit.OON_Copay_Type_1_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
     clonedBenefit.OON_Copay_1_Default_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
     
     clonedBenefit.OON_Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
     clonedBenefit.OON_Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;

     if(copayTypeSelected.AnnualMaximumApplies__c == 'Yes' || copayTypeSelected.AnnualMaximumApplies__c == 'Y'){     
        clonedBenefit.OON_AnnualMaximumApplies__c= 'Yes' ;       
    }       
    if(copayTypeSelected.AnnualMaximumApplies__c == 'No' || copayTypeSelected.AnnualMaximumApplies__c == 'N'){      
        clonedBenefit.OON_AnnualMaximumApplies__c= 'No' ;        
    }

   }
   
 if (bdp.Product_Category__c == 'Vision') {

    

    clonedBenefit.OutNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;

     clonedBenefit.OON_CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
     clonedBenefit.OON_Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;
     
      clonedBenefit.OON_Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
     clonedBenefit.OON_Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
     
     clonedBenefit.OON_Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
     clonedBenefit.OON_Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;

     clonedBenefit.OON_Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;
     clonedBenefit.OON_Copay_AmountLow__c = copayTypeSelected.Copay_Low__c;
     clonedBenefit.OON_Copay_AmountHigh__c = copayTypeSelected.Copay_High__c;
     clonedBenefit.OON_Copay_AmountIncrement__c = copayTypeSelected.Copay_Increment__c;
     clonedBenefit.OON_Copay_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
     clonedBenefit.OON_Copay_Additional_InvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;
     
    clonedBenefit.OON_Discount_Amount__c = copayTypeSelected.Discount_Amount__c;
    clonedBenefit.OON_Discount_Amount_Default__c = copayTypeSelected.Discount_Amount__c;

    clonedBenefit.ON_Approximate_Member_Payment_w_Discount__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
    clonedBenefit.ON_Approx_Member_Payment_w_Disc_Default__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;

    clonedBenefit.OON_Allowed_Amount__c = copayTypeSelected.Allowed_Amount__c;
    clonedBenefit.OON_Allowed_Amount_Default__c= copayTypeSelected.Allowed_Amount__c;

    clonedBenefit.OON_Discount_Applies__c = copayTypeSelected.Discount_Applies__c;
    clonedBenefit.OON_Discount_Applies_Default__c = copayTypeSelected.Discount_Applies__c;
  
   }           
            }
        }
        if (cBen != null && cBen.copayTypePecSpecObj2 != null && bdp.Product_Category__c == 'Medical' && cBen.copayTypeSelectedObj2.id !=cBen.copayTypePecSpecObj2.id) {
            copayTypeSelected = cBen.copayTypePecSpecObj2;
            
            if (copayTypeSelected != null) {
                for(AIA_Grouper__c aiagrp:clonedGrouperList)
                {
                    system.debug('aiagrp.Name++' + aiagrp.Name);
                    system.debug('aiagrp.Name++' + copayTypeSelected.Grouper_Name__c);
                    system.debug('copayTypeSelected.Grouper_Name__c++' + copayTypeSelected.Grouper_Name__c);
                    system.debug('aiagrp.Benefit_Design_Product__c++' + aiagrp.Benefit_Design_Product__c);
                    system.debug('bdp.id++' + bdp.id);
                    if(aiagrp.Name == copayTypeSelected.Grouper_Name__c && aiagrp.Benefit_Design_Product__c == bdp.id)
                    {
                        clonedBenefit.Grouper__c=aiagrp.id;
                    }
                    
                }
                system.debug('clonedBenefit.Grouper__c+++' + clonedBenefit.Grouper__c);
                
                if(clonedBenefit.Grouper__c == null)
                {
                    AIA_Grouper__c clonedGrouper = new AIA_Grouper__c(); 
                    system.debug('clonedGrouper.Benefit_Design_Product__c = bdp.id');
                    clonedGrouper.Benefit_Design_Product__c = bdp.id;
                    system.debug('clonedGrouper.Name = copayTypeSelected.Grouper_Name__c++');
                    clonedGrouper.Name = copayTypeSelected.Grouper_Name__c;  
                    system.debug('clonedGrouper.recordTypeId= PPRTypeId++');
                    clonedGrouper.recordTypeId= PPRTypeId;
                    system.debug('clonedGrouper.Grouper_Record_Type__c BDD');
                    clonedGrouper.Grouper_Record_Type__c = copayTypeSelected.Plan_Benefits__r.Record_Type__c;
                    system.debug('clonedGrouper.Group_Type__c++');
                    system.debug('clonedGrouper+++' + clonedGrouper);
                    clonedGrouper.Group_Type__c= 'Benefit Group';
                    clonedGrouper.Sequence_Number__c = maxSeqNumberGrouper ;
                    
                    insert clonedGrouper;
                    clonedBenefit.Grouper__c=clonedGrouper.id;
                }
                clonedBenefit.DefaultPlanBenefitValue__c=  (copayTypeSelected.IsCovered__c!=null?copayTypeSelected.IsCovered__c:'')
                    +'_'+(copayTypeSelected.CoinsuranceAmount__c!=null?String.valueof(copayTypeSelected.CoinsuranceAmount__c):'')
                    +'_'+ (copayTypeSelected.DeductibleApplies__c!=null?copayTypeSelected.DeductibleApplies__c:'')
                    +'_'+(copayTypeSelected.CopayAmount__c!=null?String.valueof(copayTypeSelected.CopayAmount__c):'')+'_';
                system.debug('copayTypePecSpec2+++' + copayTypeSelected);
                
                clonedBenefit.recordTypeId=benefitPPRTypeId;
                clonedBenefit.Benefit_Record_Type__c = copayTypeSelected.Plan_Benefits__r.Record_Type__c;
                clonedBenefit.benefit_name__c=benefitname;
                clonedBenefit.OutNetwork_ExtID_Copay2__c = copaytypeselected.ExtID__c;
                
                clonedBenefit.OON_Copay_Type_2_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                clonedBenefit.OON_Copay_Type_2_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                
                clonedBenefit.OON_Copay_Type_2_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
                clonedBenefit.OON_Copay_Type_2_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                clonedBenefit.OON_Copay2_Low__c = copayTypeSelected.Copay_Low__c;
                clonedBenefit.OON_Copay2_High__c = copayTypeSelected.Copay_High__c;
                clonedBenefit.OON_Copay_Type_2_AliasName__c = copayTypeSelected.AliasName__c;
                clonedBenefit.OON_Copay2_Increment__c = copayTypeSelected.Copay_Increment__c;
                clonedBenefit.OON_Copay2Additional_InvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;
                clonedBenefit.OON_Copay_Type_2_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
            }
        }
        system.debug('clonedBenefit+++' + clonedBenefit);
        return clonedBenefit;
        
    } 
    
/* T01 changes start here
* @Author: Sree Harsha 
* @This Method calls in constructor and It will throw an error if Implementation is having BD.
* If not, It will pull the Implementation through BRF Source_Benefit_Request_Form__c Source_Benefit_Request_Form__c and return list of implementation.
* Select the Implementation based on Account. If account does not match , it will search in parent account and matches with cureent implementation
* then It will select BD based on approved date. If there are no BD with this name, then it will check for created date
* @param - String ImpId (Current Implementation Id)
* @Output -
*/    
    public void getBDForClone(String ImpId){
        if(!String.isBlank(impID)){
            bdList = new list<AIA_Benefit_Design__c>();
            map<string,AIA_Implementation__c> mapAccountTOImp = new map<string,AIA_Implementation__c>();
            aia_ImpList = new list<AIA_Implementation__c>();
            list<AIA_Implementation__c> sourceImpList = new list<AIA_Implementation__c>();
            list<Benfit_Request_Form__c> sourceBRFwithImp = new list<Benfit_Request_Form__c>();
            
            aia_ImpList = [select id,Name,Benefit_Request_Form__c,Benefit_Request_Form__r.Name,Benefit_Request_Form__r.EffectiveDatePCSFormat__c,Benefit_Request_Form__r.Source_Benefit_Request_Form__c,
                                Benefit_Request_Form__r.Funding_Arrangements__c, Benefit_Request_Form__r.Grandfathered_Status__c,Benefit_Request_Form__r.Benefit_Effective_Date__c,Benefit_Request_Form__r.Opportunity__r.Effective_Date__c,
                                Benefit_Request_Form__r.id,Parent_Account__c,Parent_Account__r.name,Account__c,Account__r.name,(select id from Benefit_Design_c__r) 
                            from AIA_Implementation__c 
                            where id =: impID limit 1];
            system.debug('aia_ImpList'+aia_ImpList);
            if(aia_ImpList != NULL && aia_ImpList.size()>0 && aia_ImpList[0].Benefit_Design_c__r.size()>0){ 
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please clone BD from last years implementation');
                isShowNext = true;
                ApexPages.addMessage(myMsg);
            }else{
                string SoruceBRFID;
                if(aia_ImpList != NULL && aia_ImpList.size()>0){
                    SoruceBRFID = aia_ImpList[0].Benefit_Request_Form__r.Source_Benefit_Request_Form__c;
                //T04 START
                if(aia_ImpList[0].Benefit_Request_Form__r.Funding_Arrangements__c == 'Risk' && aia_ImpList[0].Benefit_Request_Form__r.Grandfathered_Status__c=='Non-Grandfathered'){
                    IsRiskNonGrandfathered = True;
                    system.debug('@@IsRiskNonGrandfathered@@'+IsRiskNonGrandfathered);
                }
                if(aia_ImpList[0].Benefit_Request_Form__r.Grandfathered_Status__c=='Grandfathered'){
                    IsGrandfathered = True;
                }
                //T04 END
                    if(SoruceBRFID != NULL){
                      sourceBRFwithImp = [select id,name,Account__c, Account__r.Name,(select id,Status__c,Parent_Account__c,Parent_Account__r.name,
                                          Account__c,Account__r.name,createdDate from Implementations__r order BY createdDate ASC limit 1000) 
                                          from Benfit_Request_Form__c where id=:SoruceBRFID limit 1];
                    }else{
                      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please clone BD from last years implementation');
                      isShowNext = true;
                    ApexPages.addMessage(myMsg);
                    }
                }
                system.debug('sourceBRFwithImp'+sourceBRFwithImp);
                
                if(sourceBRFwithImp != NULL && sourceBRFwithImp.size()>0 && sourceBRFwithImp[0].Implementations__r.size()>0){
                    system.debug('sourceBRFwithImp[0].Implementations__r.size'+sourceBRFwithImp[0].Implementations__r.size());
                    for(AIA_Implementation__c imp : sourceBRFwithImp[0].Implementations__r){
                        system.debug('imp.Account__c'+imp.Account__c+'aia_ImpList[0].Account__c' + aia_ImpList[0].Account__c);
                        if(imp.Account__c != NULL && imp.Account__c == aia_ImpList[0].Account__c){
                            if(mapAccountTOImp != null && mapAccountTOImp.containsKey(imp.Account__r.name)){
                                if(imp.createddate > mapAccountTOImp.get(imp.Account__r.name).createddate){
                                    system.debug('ContainsKey mapAccountTOImp'+mapAccountTOImp);
                                    mapAccountTOImp.put(imp.Account__r.name,imp); 
                                }
                            }else{
                                mapAccountTOImp.put(imp.Account__r.name,imp);
                                system.debug(' mapAccountTOImp'+mapAccountTOImp);
                            }
                            
                        }
                    }
                }else{
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please fill out all relevant fields before cloning the Benefit Design');
                    isShowNext = true;
                    ApexPages.addMessage(myMsg);
                }
            }
            List<AIA_Implementation__c> accToImpList = new list<AIA_Implementation__c>();
            accToImpList = mapAccountTOImp.values();
            
            bdList = new list<AIA_Benefit_Design__c>();
            if(accToImpList != NULL && accToImpList.size()>0){
                String queryString=QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds( 'AIA_Benefit_Design__c','implementation__c =: accToImpList order BY createdDate ASC limit 1000','Implementation__r.Benefit_Request_Form__r.id,Implementation__r.Benefit_Request_Form__r.EffectiveDatePCSFormat__c, Implementation__r.Parent_Account__c,Benefit_Request_Form__r.Benefit_Effective_Date__c,');
        //system.debug('@@queryString'+queryString);
                bdList = database.query(queryString); 
            }
            
            if(bdList != null && bdList.size() > 0){  
                for(AIA_Benefit_Design__c objBD: bdList){
                    if(objBD.Status__c =='Approved'){
                        bdList = new list<AIA_Benefit_Design__c>();
                        bdlist.add(objBD);
                    }
                }
                BRFEffDate = aia_ImpList[0].Benefit_Request_Form__r.EffectiveDatePCSFormat__c;
                NewBenefitEffectiveDate = aia_ImpList[0].Benefit_Request_Form__r.Benefit_Effective_Date__c;
                OppEffDate = aia_ImpList[0].Benefit_Request_Form__r.Opportunity__r.Effective_Date__c;
                //BRFEffDate = bdList[0].Implementation__r.Benefit_Request_Form__r.EffectiveDatePCSFormat__c;
                //newBD = bdList[0].clone(false);
                newBD = new AIA_Benefit_Design__c();
                bd.Source_BD__c = bdList[0].id;
                BDSource =  bdList[0].Name;
                bd.Related_BRF__c = aia_ImpList[0].Benefit_Request_Form__r.id;
                bd.Implementation__c = aia_ImpList[0].id;
                //system.debug('@@ bdList[0]'+bdList[0]);
                //system.debug('@@ aia_ImpList[0].id'+aia_ImpList[0].id);
                //system.debug('@@ aia_ImpList[0].Parent_Account__c '+aia_ImpList[0].Parent_Account__c);
                bd.Account__c =aia_ImpList[0].Account__c;
                bd.Parent_Account__c =aia_ImpList[0].Parent_Account__c;
                bd.Benefit_Request_Form__c =aia_ImpList[0].Benefit_Request_Form__c;
                bdId=bd.Source_BD__c;
                impIDForClone = bdList[0].Implementation__c;
                RelatedBRF =  aia_ImpList[0].Benefit_Request_Form__r.Name;
                ImplementationBD= aia_ImpList[0].Name; 
                BDAccount=  aia_ImpList[0].Account__r.Name;
                BDParentAccount=  aia_ImpList[0].Parent_Account__r.Name;
                system.debug('bdList = '+bdList);   
                IsBrfPanel = true;
                IsPPPanel = false; 
                IsSummaryPanel = false;
                isDataAvailable = true;
                erroMessages = new Set<String>();
                newBD.Source_BD__c = bdList[0].id;
                newBD.Related_BRF__c = bdList[0].Implementation__r.Benefit_Request_Form__r.id;
                newBD.Implementation__c = bdList[0].Implementation__c;
                newBD.Account__c = bd.Account__c;
                newBD.Parent_Account__c = bd.Parent_Account__c;
                newBD.Identity_Protection__c = bdList[0].Identity_Protection__c;
                //T08 --Start
                //newBD.Approver_Ancillary_Analyst__c = bdList[0].Approver_Ancillary_Analyst__c;
                newBD.Approver_Vision_Analyst__c = bdList[0].Approver_Vision_Analyst__c;
                newBD.Approver_Pharmacy_Operations__c = bdList[0].Approver_Pharmacy_Operations__c;
                //T08 --End
                newBD.AIA_Approver_Benefact_Coder__c = bdList[0].AIA_Approver_Benefact_Coder__c;
                newBD.Approver_Contract_Tech__c = bdList[0].Approver_Contract_Tech__c;
                newBD.AIA_Approver_MAST_Tech__c = bdList[0].AIA_Approver_MAST_Tech__c;
                //T07 -- Start
                //newBD.Approver_Benefit_Coder__c = bdList[0].Approver_Benefit_Coder__c;
                newBD.AIA_Approver_Benefit_Tester__c =bdList[0].AIA_Approver_Benefit_Tester__c;
                newBD.AIA_Approver_Benefit_Coder__c =bdList[0].AIA_Approver_Benefit_Coder__c;
                //T07 -- End
                newBD.Approver_QA_Auditor__c = bdList[0].Approver_QA_Auditor__c;
                newBD.Benefit_Request_Form__c = aia_ImpList[0].Benefit_Request_Form__c;
                BDPList = new List<AIA_Benefit_Design_Product__c>(); 
                
                //Query all BDP related to Source BD 
                String QueryStringBDPList=QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('AIA_Benefit_Design_Product__c', 'Benefit_Design__r.Implementation__c = :impIDForClone and Benefit_Design__c =:bdId  and Proposed_Products__c != null','Plan_Name__r.Plan_Id__c,Plan_Name__r.Product_Status__c,Proposed_Products__r.id, ');
                system.debug('QueryString1::'+QueryStringBDPList);
                List<AIA_Benefit_Design_Product__c> BDPList = Database.query(QueryStringBDPList);
              //  system.debug(Logginglevel.INFO,+'@@@@BDPList@@@'+BDPList);
                
                id SBRFID = aia_ImpList[0].Benefit_Request_Form__r.id;
                List<Proposed_Products__c> ClonedBRFPPList = new  List<Proposed_Products__c>();
                //T04 START
                Date tierdate = date.parse('01/01/2018');
                
       if(IsRiskNonGrandfathered == True && OppEffDate >= tierdate && NewBenefitEffectiveDate >= OppEffDate){
           ClonedBRFPPList.clear();
           string QAClonedBRF = QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c','Benefit_Request_Form__c =:SBRFID AND Plan_Name__r.TierCount__c <> \'3\' and Plan_Name__r.TierCount__c <> \'4\'');
           ClonedBRFPPList = Database.query(QAClonedBRF);       
       }
       
       if(IsGrandfathered || (OppEffDate < tierdate && NewBenefitEffectiveDate < OppEffDate) || (IsRiskNonGrandfathered == True && OppEffDate < tierdate) 
       || (IsRiskNonGrandfathered == True && OppEffDate >= tierdate && NewBenefitEffectiveDate < OppEffDate) || (OppEffDate < tierdate && NewBenefitEffectiveDate < tierdate )){
           ClonedBRFPPList.clear();
           string QAClonedBRF = QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c','Benefit_Request_Form__c =:SBRFID and Plan_Name__r.TierCount__c <> \'5\'');
           ClonedBRFPPList = Database.query(QAClonedBRF);       
       }
       if(OppEffDate >= tierdate && NewBenefitEffectiveDate >= OppEffDate && aia_ImpList[0].Benefit_Request_Form__r.Funding_Arrangements__c != 'Risk'){
           ClonedBRFPPList.clear();
           string QAClonedBRF = QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c','Benefit_Request_Form__c =:SBRFID ');
           ClonedBRFPPList = Database.query(QAClonedBRF);    
       
       }
                
                
                
             /*   if(NewBenefitEffectiveDate >= tierdate ){
                if(!IsRiskNonGrandfathered){
                    string QAClonedBRF = QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c','Benefit_Request_Form__c =:SBRFID');
                    ClonedBRFPPList = Database.query(QAClonedBRF);
                }
                }
                if(NewBenefitEffectiveDate < tierdate ){
                    string QAClonedBRF = QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c','Benefit_Request_Form__c =:SBRFID and Plan_Name__r.TierCount__c <> \'5\'');
                    ClonedBRFPPList = Database.query(QAClonedBRF);
                 }
                IF(IsRiskNonGrandfathered){
                    string QAClonedBRF = QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c','Benefit_Request_Form__c =:SBRFID AND Plan_Name__r.TierCount__c <> \'3\' and Plan_Name__r.TierCount__c <> \'4\'');
                    ClonedBRFPPList = Database.query(QAClonedBRF);
                }*/
                //T04 END
               // system.debug(Logginglevel.INFO,+'@@@@ClonedBRFPPList@@@'+ClonedBRFPPList);
                
                List<AIA_Benefit_Design_Product__c> BDPList2 = new List<AIA_Benefit_Design_Product__c>();
                for(AIA_Benefit_Design_Product__c BDP1:BDPList){
                    for(Proposed_Products__c PP1:ClonedBRFPPList){
                    system.debug(Logginglevel.INFO,+'@@@@PP.id@@@'+PP1.id);
                    system.debug(Logginglevel.INFO,+'@@@@BDP.id@@@'+BDP1.id);
                    if(BDP1.Proposed_Products__r.id == PP1.Cloned_From__c){
                        BDPList2.add(BDP1);
                        }
                        
                    }
                }
               // system.debug(Logginglevel.INFO,+'@@@@BDPListtoShowINFO@@@'+BDPList2);
               // system.debug('@@@@BDPListtoShow@@@'+BDPList2);
                
                
                lstBDPWrapper = new List<BDPWrapper>();
                if(BDPList != null && BDPList.size()>0){
                    for(AIA_Benefit_Design_Product__c BDP : BDPList2)
                    {
                        system.debug('CONSTR::'+BDP.Plan_Name__r.Product_Status__c);
                        BDPWrapper bdpwrpObj = new BDPWrapper(BDP,false);
                        lstBDPWrapper.add(bdpwrpObj);  // Add all bdp from source BD to List.
                    }  
                    system.debug('lstBDPWrapper::'+lstBDPWrapper);
                    system.debug(logginglevel.INFO,'lstBDPWrapperINFO::'+lstBDPWrapper);
                }  
            }
            
        }
    }  //T01 changes end here
}