/*=================================================================================================================
 * Date         : 02/27/2017
 * Developer    : Goutham Rapolu
 * Purpose      : AIA_BRF_DeepClone to Clone BRF and all the selected Products and related AIA Documents
 *                Selected Products will be cloned along with Grouper > Benefit > Limitations/CommentCode. 
 *                PP clone will clone User Defined/Customized values from Source PP and other values from Setup Plan.
 *                applicable for Cost Share, Benefit, CommentCode.
 *=================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 * 02/27/2017 | Goutham Rapolu |     | Initial Version                                         
 * 12/05/2017 | Goutham Rapolu | T01 | If Product is Risk & Non-Grandfathered then show only 5Tier for Drug.
 * 01/22/2018 | Rajesh Pennam  | T02 | Added Opportunity Name to Pre-Populate in BRF Deep Clone 
 * 02/11/2018 | Rajesh Penam   | T03 | Added delete functionality and custom pop ups
 * 04/02/2018 | Raviteja V     | T04 | Added clone functionality to Carefirst Private Exchange Proposed products
 * 05/02/2018 | Sajitha Y      | T05 | Commented getPCSdata() method to stop call to PCS when BRF is cloning as part of US1650
                                       and changed error message No Benefit Information is available for the selected 
                                       Plan in PCS to No Benefit Information is available for the selected Plan
 * 6/7/2018   | Chaithra P V   | T06 | Added logic to populate MHP value based on Funding Arrangement while cloning BRF
 * 09/5/2017  | Arshia G       | T07 |  Commented MHP fields for US771
 * 09/17/2018 | Raviteja       | T08 |  Reset MHP checkbox for cloned BRF 
 * 10/23/2018 | Chaithra P V   | T09 | Changed the if condition as part of RITM0679609 
 * 10/25/2018 | Naeem T P      | T10 | Commented out unreachable code to upgrade API
 * 01/08/2019 | Phani		   | T11 | Static variable(Used in AIA_BRFTriggerHelper) to avoid validation errors while cloning BRF
 * 01/22/2019 | Rajesh Nagandla| T12 | INC0499548/INC0504435 fix - Displaying PPs on clone page if funding arrangement is Both.
 *=================================================================================================================
 */

public without sharing class AIA_BRF_DeepClone {
  
   // public savepoint sp;
   public Integer maxSeqNumber;
    public list<Proposed_Products__c> PPlst{get;set;}
    public Benfit_Request_Form__c BRF{set; get;}
    public Benfit_Request_Form__c brfObj{set; get;}
    public Benfit_Request_Form__c BRFlst{set; get;}
    public list<AIA_Document__c> AIADoc{get; set;}
    public Date NewBenefitEffectiveDate{get; set;}
    public transient Set<String> CopayIDs=new Set<String>();
    public boolean IsRiskNonGrandfathered{get;set;} //T01
    public boolean IsGrandfathered{get;set;}
    public date OppEffDate{get;Set;}
    public boolean isClassic {get;set;}
    
    public List<AIADocumentWrapper> AIA_DocWrapList{get; set;}
    public list<AIA_Document__c> selAIA_DocList{get;set;}
    public list<Proposed_Products__c> selPPList{get;set;}
    private ApexPages.StandardSetController standardController;
    public String brfID = ApexPages.currentPage().getParameters().get('id');
    public List<PPWrapper> lstPPWrapper{get; set;}
    public Boolean IsBrfPanel{get;set;}
    public Boolean IsPPPanel{get;set;}
    public Boolean IsSummaryPanel{get;set;}
     public list<Proposed_Products__c> parentPPList{get;set;}
    public List<Proposed_Products__c> ppListToShow{get;set;}
    public AIA_Benefit_SummaryController aiabenfSummary = new AIA_Benefit_SummaryController();
    public Map<String, CopayTypeWrapper> copayBenMap = new Map<string, CopayTypeWrapper>();
     public Map<String,AIA_Plan_Benefits__c> mapIDTobenefit = new Map<String,AIA_Plan_Benefits__c>();  
    public Map<String,string> costShareOldValMap=new map <String,string>();
    public Map<String,AIA_Plan_Benefits__c> maplst = new Map<String,AIA_Plan_Benefits__c>();
    public  Map<String,List<Limitations__c>> ParentBenLimitationMan = new   Map<String,List<Limitations__c>>();
    public  Map<String,List<Limitations__c>> ParentBenLimitationLimit = new   Map<String,List<Limitations__c>>();
    public Map<String,Proposed_Products__c > mapbenefitNameToPPID = new Map<String,Proposed_Products__c >();
    public  Map<String,Set<String>> benLimitsAllMap = new  Map<String,Set<String>>(); 
    public  Set<String> PlanLimitIDs=new Set<String>();
    private  Set<String> ExludedPPs = new set<String>();
    private Map<String,String> mapPPIdToPlanId = new Map<String,String>();
    private Map<Id,Proposed_Products__c> mapOldPPIdToOldPP =new Map<Id,Proposed_Products__c>();
    public static boolean isClone;//T11
 /**************
    String jurisdictionFrmPP = '';
    transient Set<id> benefitIdSet = new Set<id>();
    transient Set<ID> pgroupersID= new Set<ID>();
    transient  Map<String,set<String>> AllGrpParentBenName=new Map<String,set<String>> ();
    transient Map<String,set<String>> AllParentBenName=new Map<String,set<String>> ();
    
    transient CopayTypeWrapper copTypeWrapObj = new CopayTypeWrapper();
   
  ***************/  
    public Set<string> erroMessages{get;set;}
    public Boolean isDataAvailable{get;set;}
    public string pagetitle{get;set;}  
    Public string summaryPlanId{get;set;}
    Public string opportunityName{get;set;} //T02 
    public Boolean displayPopUp{get; set;} //T03
      public Boolean getIsClassic() {
        system.debug('Theme of '+UserInfo.getUiThemeDisplayed());
        return (UserInfo.getUiThemeDisplayed() == 'Theme3');
    }    
       
    public string BRFPCSEffDate{get;set;} 
    public boolean Istestdata{get;set;}
    public date originaleffdate{get;set;}
    
    
    Public AIA_BRF_DeepClone(ApexPages.StandardController controller){        
        system.debug('@@ brfObj in constrcutor'+70);
        IsRiskNonGrandfathered = false;//T01
        isClassic = AIA_Utils.isClassic();
        IsGrandfathered = false;// Savepoint sp = Database.setSavepoint();
        pagetitle = 'Select AIA Documents to be Cloned';
        String queryString=QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds( 'Benfit_Request_Form__c','id=:brfId','Opportunity__r.AccountId, Opportunity__r.Name, Opportunity__r.Legal_Account_Name_Verified__c, ');
        mapPPIdToPlanId = new Map<String,String>();
        //Clone BRF with few fields defaulted to blank as it is a new BRF.    
          BRF = new Benfit_Request_Form__c();  
          if(brfObj==null){
            brfObj = new Benfit_Request_Form__c();
            system.debug('@@ brfObj null check 80'+brfObj);
          }
          if(!String.isBlank(brfID)){
          Benfit_Request_Form__c BRFlst = database.query(queryString);
           //T01 START
           if(BRFlst.Funding_Arrangements__c == 'Risk' && BRFlst.Grandfathered_Status__c=='Non-Grandfathered'){
                IsRiskNonGrandfathered = True;
                system.debug('@@IsRiskNonGrandfathered@@'+IsRiskNonGrandfathered);
            }
            if(BRFLst.Grandfathered_Status__c == 'Grandfathered'){IsGrandfathered = True;}
           //T01 END 
          BRF = BRFlst.clone(false);
          Benfit_Request_Form__c b=BRFlst;
          if(brfObj.opportunity__c==null){
            system.debug('@@ brfObj.opportunity__c null check 87'+brfObj.opportunity__c);
            brfObj.opportunity__c = b.opportunity__c;
            opportunityName =   b.opportunity__r.Name; //T02   

          }
          IsBrfPanel = true;
          IsPPPanel = false; 
          IsSummaryPanel = false; 
          isDataAvailable = true;
          Istestdata = false;
          erroMessages = new Set<String>();
            if(brfObj.opportunity__c != NULL && brfObj.opportunity__c != b.Opportunity__c){
                system.debug('@@ in if brfObj.opportunity__c 96'+ brfObj.opportunity__c);
                system.debug('@@ in if brfObj.opportunity__c 97'+ brfObj.opportunity__r.name); 
               /* Opportunity opp = [select id,name,AccountId from Opportunity where id =: brfObj.opportunity__c limit 1];
                BRF.Opportunity__c = opp.id;
                BRF.Account__c = opp.AccountId;
                BRF.Opportunity__r.Name = opp.name;*/
            }else{
                system.debug('@@ in if brfObj.opportunity__c 102'+ b.opportunity__c);
                BRF.Opportunity__c = b.Opportunity__c;
                BRF.Account__c = b.Opportunity__r.AccountId;
            }
            
            BRF.Benefit_Effective_Date__c = b.Benefit_Effective_Date__c;
            originaleffdate = b.Benefit_Effective_Date__c;
            BRF.Request_Type__c = b.Request_Type__c; 
            BRF.Status__c = 'New';
            BRF.ARC_Approval_Status__c = '';
            BRF.Source_Benefit_Request_Form__c = b.id;
            BRF.Submit_to_Underwriting__c = false;
            BRF.Underwriting_Comments__c = '';
             //BRF.MHP_Test_Result__c = '';  //T06 uncommented for MHP test result population on Cloned BRF 
            BRF.Sales__c = '';
            BRF.ARC_Approval_Initial_Submission_Date__c = null;
            BRF.ARC_Approval_Date__c = null;
          //  BRF.Create_Adjustment_Summary__c = false;
            BRF.BRF_Sold_Date_field__c = null;
            BRF.Escalated_to_Senior_Management__c = False;
            BRF.Senior_Management_Approved_By__c = null;
            BRF.Senior_Management_Comments__c = null;
              //T08
            BRF.Submit_Medical_Plan_s_for_MHP_Testing__c = false;
            //T08
           }
              
         
        //Query all Proposed Products related to Source BRF    
        PPlst = new List<Proposed_Products__c>();
        //Benfit_Request_Form__c BRF = (Benfit_Request_Form__c)controller.getRecord();         
        string CFE = 'CareFirst Private exchange1';
        List<Proposed_Products__c> PPList = new List<Proposed_Products__c>();
       //T01 START
       String QueryString1=QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Proposed_Products__c', 'Benefit_Request_Form__c = :brfID AND Product_Category__c !=: CFE','Plan_Name__r.Plan_Id__c,Plan_Name__r.Product_Status__c, ');
           PPList = Database.query(QueryString1);
       //T01 END
          
          lstPPWrapper = new List<PPWrapper>();
          for(Proposed_Products__c PP : PPlist)
          {
              PPWrapper ppwrpObj = new PPWrapper(PP,false);
              lstPPWrapper.add(ppwrpObj);  // Add all PP from source BRF to List.
          }        
      }
      // T03 Starts Here
       public void cancelBRF()
    {
         
        displayPopUp = false;
        
   
    }
     
 public PageReference returnToBRF()
    {
        String benID =  ApexPages.currentPage().getParameters().get('id');
        PageReference  pg = new PageReference('/'+benID );
        pg.setRedirect(true);
        return pg;       
    }
 // T03 Ends Here
 
 public list<AIADocumentWrapper> getRelatedAIADocument(){    
   
   //Query all AIA Document related to Source BRF.
   
     String QueryString2=QueryBase2.getSobjectAllFieldsSOQL('AIA_Document__c', 'Benefit_Request_Form__c =:brfID');//AND Proposed_Products__c = null//Benfit_Request_Form__c changed
       List<AIA_Document__c> AIADoc = Database.query(QueryString2);

      if(brfID!= null){
        AIA_DocWrapList = new list<AIADocumentWrapper>();
        for(AIA_Document__c AIADocument: AIADoc){
        AIA_DocWrapList.add(new AIADocumentWrapper(AIADocument,false)); // Add AIA to list
        }

      }
      return AIA_DocWrapList;
  }
  
  

  
public void getSelectedAIADoc(){    
//get all selected AIA Dcouments from AIA_BRF_DeepClone VF page.
      selAIA_DocList = new list<AIA_Document__c>();
      
      for(AIADocumentWrapper wrapper: AIA_DocWrapList){
         if(wrapper.checked){
              selAIA_DocList.add(wrapper.aiaDoc);
          }
      }
       system.debug('selAIA_DocList*******'+ selAIA_DocList);       
       
  }
  
  
   public class AIADocumentWrapper {
    public AIA_Document__c aiaDoc{get; set;}
    public Boolean checked {get; set;}
    public AIADocumentWrapper(AIA_Document__c aiaDoc,Boolean checked){
      this.aiaDoc = aiaDoc;
      this.checked = checked;
    }
  }
  public class PPWrapper{
    public Proposed_Products__c pp{get; set;}
    public Boolean checked {get; set;}
    public PPWrapper(Proposed_Products__c pp,Boolean checked){
      this.pp = pp;
      this.checked = checked;
    }
  }

      
//Method to Roll Back the operation when clicked Cancel
  public void cancelButton()
    {
    
    AIA_BRF_DeepCloneHelper aiaBrfDeepHelper = new AIA_BRF_DeepCloneHelper();
      try{
       aiaBrfDeepHelper.cancelButton(BRF);
      }
      catch(exception e){}
       displayPopUp = true;

       
    }

public PageReference next(){
    			isClone =true; //T11
         system.debug('Next****IsBrfPanel***'+ IsBrfPanel); 
 system.debug('Next****IsPPPanel***'+ IsPPPanel);   
 system.debug('Next****IsSummaryPanel***'+ IsSummaryPanel);    
system.debug('@@ in if brfObj.opportunity__c in next'+ brfObj.opportunity__c); 
 pageReference pgRef = null;
boolean legalName;
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
if(brfObj.opportunity__c != NULL){
                system.debug('@@ in if brfObj.opportunity__c 96'+ brfObj.opportunity__c);
                system.debug('@@ in if brfObj.opportunity__c 97'+ brfObj.opportunity__r.name); 
                Opportunity opp = [select id,name,AccountId,Legal_Account_Name_Verified__c,Effective_Date__c from Opportunity where id =: brfObj.opportunity__c limit 1];
                BRF.Opportunity__c = opp.id;
                //BRF.Account__c = opp.AccountId;
                BRF.Opportunity__r.Name = opp.name;
                legalName = opp.Legal_Account_Name_Verified__c;
                OppEffDate = opp.Effective_Date__c;
                
            }

system.debug('@@ in if brfObj.opportunity__c in next'+ brfObj.opportunity__r.name); 
        if(IsBrfPanel == true)
        {
            pagetitle ='Select Proposed Products to be Cloned';
            try{
             system.debug('brfObj.opportunity__c'+brfObj.opportunity__c);
             //system.debug('@@Benefit_Effective222_Date__cType@@'+ BRF.Source_Benefit_Request_Form__r.Benefit_Effective_Date__c);
             system.debug('@@Today@@'+system.today());
                
             if(LegalName == False){
                ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,'EBRF007:Cannot Verify Account Legal Name');
                ApexPages.addMessage(myMsg2);
                return null;
            //T10 start commenting out unreachable code
            /*IsPPPanel = false;
            IsSummaryPanel = false;
            IsBrfPanel = true;*/
            //T10 End
            }
               
            if(!((BRF.Request_Type__c == 'Set-up Change - Administrative Changes' || BRF.Request_Type__c == 'Set-up Change - Admin and Benefit Changes' || BRF.Request_Type__c == 'Set-up Change - Benefit Changes') && (system.today() > originaleffdate ))){ 
               if(LegalName == True){
                   System.debug('upsert BRF 1');
               upsert BRF;
                   System.debug('upsert BRF 1 E');
               NewBenefitEffectiveDate = BRF.Benefit_Effective_Date__c;
                
               
               
       List<Proposed_Products__c> PPList = new List<Proposed_Products__c>();
       //T01 START
       Date tierdate = date.parse('01/01/2018');//2018-01-01
       string CFE = 'CareFirst Private exchange1';
       System.debug('OppEffDate::'+OppEffDate);
       if(IsRiskNonGrandfathered == True && OppEffDate >= tierdate && NewBenefitEffectiveDate >= OppEffDate){
           PPList.clear();
           String QueryString1=QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Proposed_Products__c', 'Benefit_Request_Form__c = :brfID AND Product_Category__c !=: CFE AND Plan_Name__r.TierCount__c <> \'3\' and Plan_Name__r.TierCount__c <> \'4\'','Plan_Name__r.Plan_Id__c,Plan_Name__r.Product_Status__c, ');
           PPList = Database.query(QueryString1);       
           System.debug('PPList2#'+PPList.size());
       }
       
       if(IsGrandfathered || (OppEffDate < tierdate && NewBenefitEffectiveDate < OppEffDate) || (IsRiskNonGrandfathered == True && OppEffDate < tierdate) || (IsRiskNonGrandfathered == True && OppEffDate >= tierdate && NewBenefitEffectiveDate < OppEffDate) || (OppEffDate < tierdate && NewBenefitEffectiveDate < tierdate )){
           PPList.clear();
           String QueryString1=QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Proposed_Products__c', 'Benefit_Request_Form__c = :brfID AND Product_Category__c !=: CFE AND Plan_Name__r.TierCount__c <> \'5\'','Plan_Name__r.Plan_Id__c,Plan_Name__r.Product_Status__c, ');
           PPList = Database.query(QueryString1);      
           System.debug('PPList1#'+PPList.size());
       }
       //T09 commented if(OppEffDate >= tierdate && NewBenefitEffectiveDate >= OppEffDate && BRF.funding_arrangements__c != 'Risk'){
       //T12 Commented if(NewBenefitEffectiveDate >= OppEffDate && BRF.funding_arrangements__c == 'ASO') {// T09 added 
	   if(NewBenefitEffectiveDate >= OppEffDate && BRF.funding_arrangements__c != 'Risk') { //T12
           PPList.clear();
           String QueryString1=QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Proposed_Products__c', 'Benefit_Request_Form__c = :brfID AND Product_Category__c !=: CFE ','Plan_Name__r.Plan_Id__c,Plan_Name__r.Product_Status__c, ');
           PPList = Database.query(QueryString1); 
        System.debug('PPList3#'+PPList.size());
       }
       if(test.isrunningtest()){ 
           String QueryString1=QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Proposed_Products__c', 'Benefit_Request_Form__c = :brfID AND Product_Category__c !=: CFE','Plan_Name__r.Plan_Id__c,Plan_Name__r.Product_Status__c, ');
           PPList = Database.query(QueryString1);
       }
       
       System.debug('Required Values'+PPLIst.size());
       
       //T01 END
          
         if(!test.isrunningtest()){ 
              lstPPWrapper = new List<PPWrapper>();
                  for(Proposed_Products__c PP : PPlist)
                  {
                    
                       PPWrapper ppwrpObj = new PPWrapper(PP,false);
                       lstPPWrapper.add(ppwrpObj);  // Add all PP from source BRF to List.
                  }  
          } 
           
          
          
          
               }
            }
            if((BRF.Request_Type__c == 'Set-up Change - Administrative Changes' || BRF.Request_Type__c == 'Set-up Change - Admin and Benefit Changes' || BRF.Request_Type__c == 'Set-up Change - Benefit Changes') && (system.today() > originaleffdate )){ 
                system.debug('@@Request Type@@222'+ BRF.Request_Type__c);
                //system.debug('@@Benefit_Effective222_Date__cType@@'+ BRF.Source_Benefit_Request_Form__r.Benefit_Effective_Date__c);
                system.debug('@@Today@@'+system.today());
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Request type can be set to any Set-up Change only if BRF was created by Deep Cloning a Sold BRF and if the new BRF was created earlier than Source BRF Benefit Effective Date.');
                ApexPages.addMessage(myMsg);
            return null;
            //T10 Start again Comment out unreachable code
            /*IsPPPanel = false;
            IsSummaryPanel = false;
            IsBrfPanel = true;*/
            //T10 End
            } 
            
               system.debug('BRFBRF'+BRF+'>>>>'+BRF.opportunity__r.Name);
          //     system.debug('BRFEffectiveDatePCSFormat__c'+BRF.EffectiveDatePCSFormat__c);
               BRFPCSEffDate = string.valueOf(BRF.Benefit_Effective_Date__c);
               system.debug('BRFBRFPCSEffDate'+BRFPCSEffDate);
            }catch(Exception e){
                System.debug('Exception e '+e.getLineNumber());
                Apexpages.addMessages(e); 
                
            }
            getSelectedAIADoc();
            selAIA_DocList = new list<AIA_Document__c>();
            Set<String> setAIADocIds = new Set<String>();
            for(AIADocumentWrapper wrapper: AIA_DocWrapList){
                if(wrapper.checked){
                      AIA_Document__c AIADocument = wrapper.aiaDoc.clone(false);
                      AIADocument.Benefit_Request_Form__c = BRF.id;
                      AIADocument.Opportunity__c = BRF.Opportunity__c;
                      AIADocument.Account__c= BRF.Account__c;
                      AIADocument.Attachment_ID__c = null;
                      AIADocument.ClonedFromAIADocID__c = wrapper.aiaDoc.Id;
                      AIADocument.ClonedFromAIADocName__c = wrapper.aiaDoc.Name;
                      selAIA_DocList.add(AIADocument);
                      setAIADocIds.add(wrapper.aiaDoc.id); 

                }
            }
            
             if(selAIA_DocList!=null && selAIA_DocList.size()>0){
                upsert selAIA_DocList;
                map<string,string> attmap = new map<string,string>();
                for (AIA_Document__c rec:selAIA_DocList){               
                    attmap.put(rec.ClonedFromAIADocID__c,rec.Id);
                }   
                
                list<Attachment> attList = new list<Attachment>([select Id, name,body,parentId from attachment where parentId in:setAIADocIds limit 1]);
              
                List<Attachment> newattlist = new List<Attachment>(); 
                for(Attachment attrec:attList){
                  Attachment attachment = new Attachment();
                  attachment = attrec.clone(false);                           
                  attachment.ParentId = attmap.get(attrec.parentId);              
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
           
           /* 
           // selPPList = new list<Proposed_Products__c>();
           
              for(PPWrapper wrapper: lstPPWrapper){
                  if(wrapper.checked){
                      
                      Proposed_Products__c PP = wrapper.pp.clone(false);
                      PP.Benefit_Request_Form__c = BRF.id;
                      ppListToShow.add(PP);
                  }
              }
           //  upsert selPPList;
           */
           
           
           
              pagetitle ='Review Product and Document Selections';
             //cloneSelRecords(lstPPWrapper,BRF.id);
        }
        else if(IsSummaryPanel == true)
        {System.debug('upsert BRF 2');
            upsert BRF;
         System.debug('upsert BRF 2E');
            NewBenefitEffectiveDate = BRF.Benefit_Effective_Date__c;
            pagetitle ='Summary of Selected Praposed product';
            return new PageReference('/'+BRF.id);
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
    public void back()
    {
        if(IsBrfPanel == false && IsPPPanel == false && IsSummaryPanel == true )
        {
            IsPPPanel = true;
            IsBrfPanel = false;
            IsSummaryPanel = false;
        }        
    }
    
      public void deletePP()
    {
        string PPID= Apexpages.currentPage().getParameters().get('PPID');
        string PPName= Apexpages.currentPage().getParameters().get('PPName');
        Set<ID> ppIds = new Set<ID>();
        Proposed_Products__c ppToDelete = new Proposed_Products__c(); //T03
        List<Proposed_Products__c> RelatedpptoDelete = new List<Proposed_Products__c>();
        List<Proposed_Products__c> RelatedpptoDeleteFinal = new List<Proposed_Products__c>();
        //T05 - Start  Commented error messages for skeleton Plans as per US1650 
       /* if(erroMessages != null && erroMessages.size()>0)
        {
            for(string strerror: erroMessages)
            {
                
                if(strerror != PPName)
                {
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, strerror + ' - No Benefit Information is available for the selected Plan');                
                    ApexPages.addMessage(myMsg);
                  
                }
                else if (strerror == PPName)
                {
                    erroMessages.remove(PPName);
                }
            }
        } */
        //T05- End
        system.debug('====mapOldPPIdToOldPP=========' + mapOldPPIdToOldPP);
        system.debug('====PPID=========' + PPID);
         if(mapOldPPIdToOldPP!= null && mapOldPPIdToOldPP.ContainsKey(PPID))
        {
            ppToDelete = mapOldPPIdToOldPP.get(PPID);
            ppIds.add(ppToDelete.id); 
        }
        
        id newbrfid = ppToDelete.Benefit_Request_Form__r.id;
        List<proposed_products__c> selPPList = new List<proposed_products__c>();
        set<id> SelPPids = new set<id>();
        Map<Id,proposed_products__c> finalPPMap = new Map<Id,proposed_products__c>();
        system.debug('====lstPPWrapper=========' + lstPPWrapper);
        for(PPWrapper wrapper: lstPPWrapper){
                  if(wrapper.checked)
                  {
                      selPPList.add(wrapper.pp);
                      SelPPids.add(wrapper.pp.id);
                  }
              }
        system.debug('@@selPPList:::'+selPPList);
        List<proposed_products__c> finalselPPList = new List<proposed_products__c>();
        set<id> relIDs = new Set<id>();
         RelatedpptoDelete = [select id, related_medical_product__c,Cloned_From_Name__c,Product_Category__c,Custom_New__c,Product_Parent_Name__c,Cloned_From__c
                              from Proposed_Products__c 
                              where benefit_request_form__c =:BRF.id 
                              and related_medical_product__c =:ppToDelete.id ];//and id not in:SelPPids
        system.debug('@@RelatedpptoDelete:::'+RelatedpptoDelete);
        set<id> selppidss = new set<id>();
        system.debug('@@RelatedpptoDelete:After::'+RelatedpptoDelete);
      for(proposed_products__c pp: RelatedpptoDelete){
        for(proposed_products__c pp1: selPPList){
           system.debug('@@pp1::: '+pp1.id +'@@pp:: '+pp.Cloned_From__c); 
                if(pp1.id == pp.Cloned_From__c){
                    selppidss.add(pp.id);
                    selppidss.add(pp1.id);
                }if(pp1.id != pp.Cloned_From__c && !(selppidss.contains(pp.id) || selppidss.contains(pp1.id))){
                    if(!finalPPMap.containsKey(pp.id)){ //T-pha
                       finalPPMap.put(pp.iD,pp);
                       finalselPPList.add(pp);
                    }
                }
                
            }
            if(selPPList.ISEMPTY()){finalselPPList.add(pp);}
        }
        List<Proposed_Products__c> pplist=new List<Proposed_Products__c>();
        pplist=[select id,Cloned_From_Name__c,Cloned_From__c
                              from Proposed_Products__c 
                              where Cloned_From__c =:PPID 
                              and benefit_request_form__c =:BRF.id ];
        if(!pplist.ISEMPTY())
        ppToDelete = pplist[0];
        system.debug('@@finalselPPList:::'+finalselPPList);
        try{
            if(ppToDelete!=null && ppToDelete.id != null){
             mapOldPPIdToOldPP.remove(PPID);
               
             delete ppToDelete;
            if(!finalselPPList.ISEMPTY()){delete finalselPPList;}
            //T03
            ppListToShow = [select id, Cloned_From_Name__c,Product_Category__c,Custom_New__c,Product_Parent_Name__c
                                      from Proposed_Products__c where benefit_request_form__c =:BRF.id ];
            system.debug('====ppListToShow=========' + ppListToShow);
         }
        }catch(exception e){
            system.debug('@@Exception:::'+e);
        }
        
        
    }
    
   public void ValidateAndCallPCS()
    {
        isClone=true;//T11
        string PPID= Apexpages.currentPage().getParameters().get('PPID');
        // T04  -   start
        string PPCat= Apexpages.currentPage().getParameters().get('PPCat');
        system.debug('PPCat' + PPCat);
        if(PPCat!='CareFirst Private exchange'){
        //T04   -   End
        ExludedPPs=new Set<String>();
        string planid= Apexpages.currentPage().getParameters().get('planid');
        string palanIdValue  = Apexpages.currentPage().getParameters().get('palanIdValue');
        system.debug('====planid=========' + planid);
        system.debug('====palanIdValue=========' + palanIdValue);
        system.debug('====PPID=========' + PPID);
        String QueryStr=QueryBase2.getSobjectAllFieldsSOQL('AIA_Plan__c', 'Id=:planId');
        system.debug('===ValidateAndCallPCS=QueryStr=========' + QueryStr);
        AIA_Plan__c aia_Plan = database.query(QueryStr);
        system.debug('===ValidateAndCallPCS=aia_Plan=========' + aia_Plan);
        //String QueryStr1=QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c', 'Id=:PPID');
        
        
        String qry = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Proposed_Products__c', 'Id=:PPID','Benefit_Request_Form__r.Jurisdiction__c,');
        system.debug('===ValidateAndCallPCS=aia_Plan=========' + aia_Plan);
        System.debug('qry+++'+qry); 
        Proposed_Products__c pp = database.query(qry);
        aiabenfSummary = new AIA_Benefit_SummaryController();
        boolean isClonablePP = true;
        //T05 - Start  Commented error message for skeleton Plans as per US1650
       /* if(erroMessages != null && erroMessages.size()>0)
        {
            for(string strerror: erroMessages)
            {
                 
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, strerror + ' - No Benefit Information is available for the selected Plan');                
                ApexPages.addMessage(myMsg);
               
            }
        } */
        //T05 - End
        // Pan
       // aiabenfSummary.createWrapListFromPlan(pp);
        //aiabenfSummary.createWrapListFromPlanCostShr(planid);
        //system.debug('====aiabenfSummary=========' + aiabenfSummary.grouperWrapList);
        //check if Benefit Summary has data & is valid, if it doesn't then make call out to PCS
        //otherwise get data from Salesforce objects
        if(aia_Plan != NULL ){
            if(aia_Plan != NULL && hasBnftSumry(aia_Plan)){
                system.debug('EnterClone: '+aia_Plan);

                if(aia_Plan != NULL && isPCScallReq(aia_Plan)){
                    system.debug('EnterClone1: '+aia_Plan);
                    //isPCSdata = true;
                    // T05 - Start Commented PCS call as part of US1650
                    //getPCSdata(planid,palanIdValue);
                    // T05- End
                    // Coomenting as part od Defect 39562
                    /*if(Test.isRunningTest() && Istestdata)
                    {
                       summaryPlanId = planid; 
                    }
                    if(summaryPlanId == null || summaryPlanId == '')
                    {
                        isClonablePP = false;
                        //T05 - Start  Commented error message to hide from user as per US1650
                        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, pp.Name + ' - No Benefit Information is available for the selected Plan');
                        //T05 - Start
                        isDataAvailable = false;
                        ExludedPPs.add(PPID);
                        erroMessages.add(pp.Name);
                        // T05- Start
                       // ApexPages.addMessage(myMsg);
                       // T05- End
                       system.debug('ErrorClone: '+erroMessages);
                    
                    }
                    else
                    {
                        system.debug('@@summaryPlanId ::Inside '+summaryPlanId);  
                        String QueryString4=QueryBase2.getSobjectAllFieldsSOQL('AIA_Plan__c','Plan_Id__c =:summaryPlanId'); 
                        List<AIA_Plan__c> lstplanFromPCSCall = Database.query(QueryString4);
                        if(lstplanFromPCSCall!=null && lstplanFromPCSCall.size()>0)
                        {
                            AIA_Plan__c planFromPCSCall = lstplanFromPCSCall[0];
                           system.debug('@@planFromPCSCall :: '+planFromPCSCall);  
                           If(planFromPCSCall!=Null && planFromPCSCall.id!=null){
                                planid = planFromPCSCall.id;
                                mapPPIdToPlanId.put(PP.id,planid);
                                 //system.debug(LoggingLevel.INFO,'lstplanFromPCSCall==planid== ::' + planid);
                           }
                        }
                        
                    }*/
                    //system.debug(LoggingLevel.INFO,'mapPPIdToPlanId==--' + mapPPIdToPlanId);
                    system.debug('IF PCSdata from setup  :: '+aia_Plan);  
                }
                          
            }
            else{
                //showError = true;
               //T05 - Start  Commented error message for skeleton Plans as per US1650
               // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, pp.Name + ' - No Benefit Information is available for the selected Plan');
               // T05- End 
                isDataAvailable = false;
                erroMessages.add(pp.Name);
                //T05- Start
               // ApexPages.addMessage(myMsg);
               // T05- End
            }
        }
        
       if(isClonablePP)
       {
            //system.debug(LoggingLevel.INFO,'lstplanFromPCSCall==planid== ::' + planid);
           ParentBenLimitationMan = new   Map<String,List<Limitations__c>>();
           ParentBenLimitationLimit = new   Map<String,List<Limitations__c>>();
           mapbenefitNameToPPID = new Map<String,Proposed_Products__c >();
           costShareOldValMap=new map <String,string>();
            mapIDTobenefit = new Map<String,AIA_Plan_Benefits__c>();
            maplst = new Map<String,AIA_Plan_Benefits__c>();
           AIA_BRF_DeepCloneHelper aiaBrfDeepHelper = new AIA_BRF_DeepCloneHelper();
           aiaBrfDeepHelper.getCopaysFromPlan(planid,'BRF',pp,BRF);
           copayBenMap = new Map<string, CopayTypeWrapper>();
           system.debug('================aiaBrfDeepHelper.copayBenMap=========' + aiaBrfDeepHelper.copayBenMap);
           mapbenefitNameToPPID = aiaBrfDeepHelper.mapbenefitNameToPPID;
           system.debug('================aiaBrfDeepHelper.mapbenefitNameToPPID=========' + mapbenefitNameToPPID);
           System.debug(LoggingLevel.INFO,'+++++mapbenefitNameToPPID+++++'+mapbenefitNameToPPID);
           for(string benfName: aiaBrfDeepHelper.copayBenMap.Keyset())
           {
               AIA_BRF_DeepCloneHelper.CopayTypeWrapper copaytype = aiaBrfDeepHelper.copayBenMap.get(benfName);
               CopayTypeWrapper copay = new CopayTypeWrapper();
               copay.copayTypeSelectedObj = copaytype.copayTypeSelectedObj;
                copay.copayTypePecSpecObj = copaytype.copayTypePecSpecObj;
                copay.copayTypeSelectedObj2 = copaytype.copayTypeSelectedObj2;
                copay.copayTypePecSpecObj2 = copaytype.copayTypePecSpecObj2;
               copayBenMap.put(benfName,copay);
           }
           system.debug('================aiaBrfDeepHelper.copayBenMap==After=======' + copayBenMap);
           
           aiaBrfDeepHelper.createWrapListFromPlanCostShr(planid,pp);

           aiaBrfDeepHelper.getPlanLimitation(aiaBrfDeepHelper.benefitIdSet,pp,BRF.Benefit_Effective_Date__c);
           aiaBrfDeepHelper.getPlanCommentCodes(pp,BRF.Benefit_Effective_Date__c);
           ParentBenLimitationMan = aiaBrfDeepHelper.ParentBenLimitationMan;
           ParentBenLimitationLimit = aiaBrfDeepHelper.ParentBenLimitationLimit;
           
           costShareOldValMap = aiaBrfDeepHelper.costShareOldValMap;
           mapIDTobenefit = aiaBrfDeepHelper.mapIDTobenefit;
           maplst = aiaBrfDeepHelper.maplst; 
           system.debug('================aiaBrfDeepHelper.ParentBenLimitationLimit=======' +  aiaBrfDeepHelper.ParentBenLimitationLimit);
           system.debug('================aiaBrfDeepHelper.ParentBenLimitationMan=======' +  aiaBrfDeepHelper.ParentBenLimitationMan);
           system.debug('================aiaBrfDeepHelper.costShareOldValMap=======' +  aiaBrfDeepHelper.costShareOldValMap);  
            cloneSelRecords(lstPPWrapper,BRF.id,pp);
       }
      // T04    -   start     
       }
            else{
                String qry1 = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Proposed_Products__c', 'Id=:PPID','Benefit_Request_Form__r.Jurisdiction__c,');
                Proposed_Products__c pp1 = database.query(qry1);
                cloneSelRecords(lstPPWrapper,BRF.id,pp1);
            }
      // T04    -   End
         
    } 
    public boolean hasBnftSumry(AIA_Plan__c aia_Plan){
        boolean result = false;
        if(aia_Plan.Has_Benefit_Summary__c){//if checkbox is checked
            result = true;
        }
        return result;
    }
    

    //returns true if PCS API call has to be made, false otherwise
 /*   public boolean isPCScallReq(AIA_Plan__c aia_Plan){
        boolean result = false;
        //check if Product Last Updated is greater than Config Last updated. If true get new data from PCS
     if(aia_Plan.Product_Status__c == 'Active'){
         if(aia_Plan.Effective_Date__c >= BRF.Benefit_Effective_Date__c  && BRF.Benefit_Effective_Date__c <= aia_Plan.Termination_Date__c){
            if((aia_Plan.Product_Last_Updated__c > aia_Plan.Configuration_Last_Updated__c) || aia_Plan.Configuration_Last_Updated__c == null){
                return true;
            }
         }
            
         if((aia_Plan.Effective_Date__c < BRF.Benefit_Effective_Date__c  && BRF.Benefit_Effective_Date__c > aia_Plan.Termination_Date__c)){

            result = true;
            }
        }
        
        if(aia_Plan.Product_Status__c != 'Active'){
            result = true;
        }
       
        return result;
    } */
    
    public boolean isPCScallReq(AIA_Plan__c aia_Plan){
        boolean result = false;
        //check if Product Last Updated is greater than Config Last updated. If true get new data from PCS
     if(aia_Plan.Product_Status__c == 'Active'){
         if(aia_Plan.Effective_Date__c <= BRF.Benefit_Effective_Date__c  && BRF.Benefit_Effective_Date__c <= aia_Plan.Termination_Date__c){
            if((aia_Plan.Product_Last_Updated__c > aia_Plan.Configuration_Last_Updated__c) || aia_Plan.Configuration_Last_Updated__c == null){
                return true;
            }
         }
            
         if((aia_Plan.Effective_Date__c < BRF.Benefit_Effective_Date__c  && BRF.Benefit_Effective_Date__c > aia_Plan.Termination_Date__c)){

            result = true;
            }
        }
        
        if(aia_Plan.Product_Status__c != 'Active'){
            result = true;
        }
       
        return result;
    }
  //get data from PCS
    //T05 - Start Commented getPCSdata to stop call to PCS as part of US1650
  /**  public pageReference getPCSdata(string propProdId,string planIdValue){
        //system.debug('getting plan data from PCS webservice'+ planId);
       AIA_PCS_BenefitSummary benftSum = AIA_PCSIntegrationHandler.callPCS(planIdValue,'BRF',propProdId,BRFPCSEffDate);
        //isPCSdata = true;
        system.debug(' PCS Service Call Result :: '+benftSum);
        summaryPlanId = null;
        if(benftSum!=null && (benftSum.PlanID != null || benftSum.PlanID != '')){
        summaryPlanId = benftSum.PlanID;
        system.debug('@@summaryPlanId :: '+summaryPlanId);
        }
        return null;
    } **/
    // T05 - End
    //clone the selected list of PPs and the associated childs (Groupers, Benefits, Comment codes, AIADocs)
    public PageReference cloneSelRecords(List<PPWrapper> PPSelectList,string BrfID,Proposed_Products__c currentPP){
        
        List<Proposed_Products__c> SelectedPPlist = new List<Proposed_Products__c>();
        List<Proposed_Products__c> SelectedPPlistold = new List<Proposed_Products__c>();
        ppListToShow = new List<Proposed_Products__c>();
        set<string> availablePPIds = new set<string>();
        Map<Id,Proposed_Products__c> mapIdToPP =new Map<Id,Proposed_Products__c>();
        Map<Id,Proposed_Products__c> mapOldIdToOldPP =new Map<Id,Proposed_Products__c>();
        Proposed_Products__c PPobj;
        AIA_Document__c Docobj;
        Decimal maxvalue = 0;               
        Map<Id,Decimal> mapGrpIdTomaxValue =new Map<Id,Decimal>();
        try{
            system.debug('====PPSelectList=========' + PPSelectList);
            
            
            if(PPSelectList != null && PPSelectList.size()>0){
                for(PPWrapper mw: PPSelectList){
                    if(mw.checked == true && !ExludedPPs.Contains(mw.pp.id)){
                        //system.debug('&&&&&&&&&&&&&&&&&&&&&&&& selected PP:'+mw);                     
                        //SelectedPPlistold.add(mw.pp);
                        SelectedPPlist.add(mw.pp);                        
                    }
                    availablePPIds.add(mw.pp.id);
                }
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&& selected PPs:'+SelectedPPlist);  // Proposed products which are selected from UI
            }                        
             
                 
                                    
            set<id> PPIdSet = new set<id>();
            set<id> ActuallPPIdSet = new set<id>();
            for(Proposed_Products__c ppRec:SelectedPPlist){
                //PPIdSet.add(ppRec.Id);
                ActuallPPIdSet.add(ppRec.Id);
            }
            system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&& ActuallPPIdSet'+ActuallPPIdSet);
            
            
           List<Proposed_Products__c> AncillryPPList = new List<Proposed_Products__c>([select Id,name from Proposed_Products__c where Related_Medical_Product__c in :ActuallPPIdSet]);
            for(Proposed_Products__c ancpp:AncillryPPList){
                    SelectedPPlist.add(ancpp);
                    //PPIdSet.add(ancpp.Id);
                    ActuallPPIdSet.add(ancpp.Id);
            }
            system.debug('Related_Medical_Product__c&&&&&&&&&&&&&&&&&&&&&&&&&&&& ActuallPPIdSet'+ActuallPPIdSet);
            set<id> ClonedPPIdSet = new set<id>();
            List<Proposed_Products__c> ClonedPPList = new List<Proposed_Products__c>([select Id,name,Cloned_From__c,Cloned_From_Name__c,Product_Category__c,Custom__c,Product_Parent_Name__c from Proposed_Products__c where Cloned_From__c in :ActuallPPIdSet and Benefit_Request_Form__c =:BrfID]);
            for(Proposed_Products__c clonedcpp:ClonedPPList){
                if(availablePPIds.Contains(clonedcpp.Cloned_From__c))
                    ClonedPPIdSet.add(clonedcpp.Cloned_From__c);
            }
            system.debug('ClonedPPList&&&&&&&&&&&&&&&&&&&&&&&&&&&& '+ClonedPPList);
            //system.debug('ClonedPPList&&&&&&&&&&&&&&&&&&&&&&&&&&&& '+ClonedPPList);
            //Query all fields for PPs
            String QueryString=QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c', 'Id in :ActuallPPIdSet');
            //system.debug('&&&&&&&&&& query:'+QueryString);
                    List<Proposed_Products__c> PPList = Database.query(QueryString);
            //system.debug('&&&&&&&&&&&&&&&&& PPList from the query:'+PPList);
                    list<Proposed_Products__c> relatedPPList = new list<Proposed_Products__c>();
                     parentPPList = new list<Proposed_Products__c>();                                     
            //Clone the PPs
            //system.debug(LoggingLevel.INFO,'cloneSelRecords--mapPPIdToPlanId==--' + mapPPIdToPlanId);
            for(Proposed_Products__c pp: PPList){
                            
                            PPobj = new Proposed_Products__c();
                            PPobj = pp.clone(false);
                            PPobj.Benefit_Request_Form__c = BrfID;   
                            PPobj.Cloned_From__c = pp.Id;
                            PPobj.Cloned_From_Name__c = pp.Name;
                //T07-Start
                /*
                            PPobj.MHP_Test_Result__c = null;
                            PPobj.MHP_Test_Comments__c = null;
                            PPobj.MHP_Test_Completed_By__c = null;
                            PPobj.MHP_Test_Completed_Date__c = null;

                             //T06 Start added logic to populate MHP Test result in Proposed Product
                            if(PPobj.Funding_Arrangement__c=='Risk' )
                            {
                                if(pp.MHP_Test_Result__c!='Pass')
                                   PPobj.MHP_Test_Result__c = pp.MHP_Test_Result__c;
                                else {
                                  PPobj.MHP_Test_Result__c = 'Pass';
                                  }
                                    
                            }
                            
                            else
                            {
                                if(pp.MHP_Test_Result__c!='Deferred')
                                   PPobj.MHP_Test_Result__c = pp.MHP_Test_Result__c;
                                else {
                                  PPobj.MHP_Test_Result__c = 'Deferred';
                                  }
                            }
                       */
                //T07-End       
                            //T06 End
                                if(pp.Product_Category__c =='Medical' || pp.Product_Category__c == 'CareFirst Private exchange' ){
                                       PPobj.Cloned_From_Related_Medical__c = '';
                                    system.debug('error excep in 925'+pp.Product_Category__c);
                                }   
                                else 
                                    PPobj.Cloned_From_Related_Medical__c = pp.Related_Medical_Product__c;   
                            if(mapPPIdToPlanId.containsKey(pp.id))
                            {
                                PPobj.Plan_Name__c = mapPPIdToPlanId.get(pp.id);
                            }
                            PPobj.Custom__c = False;
                            if(ClonedPPIdSet.Contains(pp.id))
                            {
                                ppListToShow.add(PPobj);
                                system.debug('&&&&&&&&&&&&&&&& ppListToShow==:'+ppListToShow);
                                continue;
                                
                                
                            }
                            
                            parentPPList.add(PPobj);
                            PPIdSet.add(pp.Id); 
                            
                            
                        }            
            system.debug('&&&&&&&&&&&&&&&& List for Insert:'+parentPPList);
            //system.debug('&&&&&&&&&&&&&&&& List for Insert:'+ppListToShow);
                                            
         if(parentPPList != null && parentPPList.size()>0){               
                upsert parentPPList;
            system.debug('error excep 1 :'+parentPPList);
            } 
        map<string,string> ancmap = new map<string,string>();
        for (Proposed_Products__c rec:parentPPList){               
            ancmap.put(rec.Cloned_From__c,rec.Id);
            mapIdToPP.put(rec.Id,rec);
            mapOldIdToOldPP.put(rec.Cloned_From__c,rec);
            if(!mapOldPPIdToOldPP.ContainsKey(rec.Cloned_From__c))
                mapOldPPIdToOldPP.put(rec.Cloned_From__c,rec);
        }
        // Get the Ancillary products (related products)
        for(Proposed_Products__c anc: parentPPList){
            anc.isFirstEdit__c = true;
            if(anc.Cloned_From_Related_Medical__c != ''){
                anc.Related_Medical_Product__c = ancmap.get(anc.Cloned_From_Related_Medical__c);
            system.debug('error excep med :'+ancmap);
            system.debug('error excep med 2 :'+anc.Cloned_From_Related_Medical__c);
            system.debug('error excep med 22 :'+anc.Related_Medical_Product__c);
            }
            if(anc.OldPPCustom__c == True){
                anc.Custom__c = True;
            }
        }  
        if(parentPPList != null && parentPPList.size()>0){               
                upsert parentPPList;
            system.debug('error excep 2 :'+parentPPList);
                
            } 
            //Maintain Old and new PP Ids
            system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&& OutPPIdSet'+PPIdSet); 
            
        //Query for the existing AIA Documents which are associated with proposed products
            /*list<AIA_Document__c> AIADocumentList = [SELECT Id,Name,Document_Type__c, Document_Name__c ,Proposed_Products__c,Source__c, Benefit_Request_Form__c 
                                              FROM AIA_Document__c 
                                              WHERE Proposed_Products__c in :PPIdSet];//Document_Type__c != 'Marked Up Benefit Summary' AND 
            set<id> AIADocIdSet = new set<id>();
                for(AIA_Document__c AIADocRec:AIADocumentList){
                    AIADocIdSet.add(AIADocRec.Id);
                }
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&& PPIdSet'+AIADocIdSet);    
             // Query all filed and clone AIADocs   
             String AIAQueryString=QueryBase2.getSobjectAllFieldsSOQL('AIA_Document__c', 'Id in :AIADocIdSet');
                system.debug('&&&&&&&&&& query:'+AIAQueryString);
             List<AIA_Document__c> AIADocList = Database.query(AIAQueryString);
                system.debug('&&&&&&&&&&&&&&&&& AIAdDocsList from the query:'+AIADocList); */   
            
            list<AIA_Document__c> newAIADocList = new  list<AIA_Document__c>();
            boolean isPPAdded = false;
            System.debug(LoggingLevel.INFO,'+++++parentPPList+++++'+parentPPList);
            for(Proposed_Products__c selPP:parentPPList)
            {
                for(AIADocumentWrapper wrapper: AIA_DocWrapList){
                    system.debug(LoggingLevel.INFO,'wrapper.checked=== ::' + wrapper.checked);
                    system.debug(LoggingLevel.INFO,'wrapper.aiaDoc.Proposed_Products__c=== ::' + wrapper.aiaDoc.Proposed_Products__c);
                    system.debug(LoggingLevel.INFO,'selPP.id=== ::' + selPP.Cloned_From__c);
                    if(wrapper.checked){
                        if(wrapper.aiaDoc.Proposed_Products__c == selPP.Cloned_From__c)
                        {
                            for(AIA_Document__c AIADocument: selAIA_DocList){
                                System.debug(LoggingLevel.INFO,'+++++parentPPList+++++'+parentPPList);
                                if(AIADocument.ClonedFromAIADocID__c == wrapper.aiaDoc.Id)
                                {
                                  isPPAdded = true;
                                  AIADocument.Proposed_Products__c = selPP.id;
                                }
                            }
                        }
                          

                    }
                }
                
            }
            System.debug(LoggingLevel.INFO,'+++++selAIA_DocList+++++'+selAIA_DocList);
            if(selAIA_DocList!=null && selAIA_DocList.size()>0 && isPPAdded){
                upsert selAIA_DocList;
            }
        /*Maintain old and new Ids for AIADocs
         map<string,string> attmap = new map<string,string>();
            for (AIA_Document__c rec:newAIADocList){               
                attmap.put(rec.ClonedFromAIADocID__c,rec.Id);
            }   
        //Clone Attachments    
        list<Attachment> attList = new list<Attachment>([select Id, name,body,parentId from attachment where parentId in:AIADocIdSet limit 1]);          
        List<Attachment> newattlist = new List<Attachment>(); 
            for(Attachment attrec:attList){
             String encodedContentsString = System.currentPageReference().getParameters().get('fileContents');             
              
              Attachment attachment = new Attachment();
              attachment = attrec.clone(false);                           
              attachment.ParentId = attmap.get(attrec.parentId);              
              newattlist.add(attachment);
            }
            
            upsert newattlist; 
            
            for(Attachment attParent:newattlist){
                for(AIA_Document__c aia:newAIADocList){
                    if(aia.Id == attParent.ParentId){
                        aia.Attachment_ID__c = attParent.Id;
                    }                    
                }   
            }
            upsert newattlist;*/
       /*List<Proposed_Products__c> CustomPPlst = New List<Proposed_Products__c>();
            for(Proposed_Products__c Custompp:parentPPList){
                            if(Custompp.OldPPCustom__c == True){
                            Custompp.Custom__c = True;
                            }
                            CustomPPlst.add(Custompp);
                            } 
        Upsert CustomPPlst; */        
        //if pp category is CareFirst Private exchange1 these will not be applicable    
        // T-   Start    
//      if(Product_Category__c!='CareFirst Private exchange1'){
        //Querying the existing groupers & associated Benefits
        list<AIA_Grouper__c> existingGrouperList = new list<AIA_Grouper__c>();
        list<AIA_Benefits__c> existingBenefits = new list<AIA_Benefits__c>();
        Id PPRTypeId = Schema.SObjectType.AIA_Grouper__c.RecordTypeInfosByName.get('Proposed Product').RecordTypeId;
        Id benefitPPRTypeId = Schema.SObjectType.AIA_Benefits__c.RecordTypeInfosByName.get('Proposed Product').RecordTypeId;
        List<String> lstchildObjects = new List<string>();
        lstchildObjects.add('AIA_Benefits__c');
        String qry = QueryBase2.getSobjectAllFieldsSOQL('AIA_Grouper__c', 'recordTypeId=:PPRTypeId and Proposed_Products__c in: PPIdSet');
        System.debug('qry+++'+qry);        
        //query all the fields for clone to work
        existingGrouperList = Database.query(qry);

        
        Map<id,List<AIA_Benefits__c>> GrouperBenefitMap = new Map<id,List<AIA_Benefits__c>>();
        Map<id,List<Limitations__c>> BeneLimitationMap = new Map<id,List<Limitations__c>>();
Map<string,List<Limitations__c>> BeneNameLimitationMap = new Map<string,List<Limitations__c>>(); 
Map<string,Proposed_Products__c> BeneNameToPPMap = new Map<string,Proposed_Products__c>(); 
Set<String> setNewBenefits = new Set<String>();  
Map<string,AIA_Benefits__c> BeneNameToBenefit = new Map<string,AIA_Benefits__c>();        
        system.debug('&&&&&&&&&&&&&&&&&&&&&&& existingGrouperList'+existingGrouperList);
        Set<string> setGrpIds = new Set<String>();
        for(AIA_Grouper__c grouper : existingGrouperList){
            setGrpIds.add(grouper.id);            
        }
        String qry1 = QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefits__c', 'Grouper__c in: setGrpIds');
        System.debug('qry+++'+qry1);        
        //query all the fields for clone to work
        existingBenefits = Database.query(qry1);
        for(AIA_Benefits__c benefit : existingBenefits){
            if(GrouperBenefitMap.containsKey(benefit.Grouper__c))
            {
                GrouperBenefitMap.get(benefit.Grouper__c).add(benefit);  
            }
            else
            {
                GrouperBenefitMap.put(benefit.Grouper__c ,new List<AIA_Benefits__c> { benefit });
            }           

        
        }

//String queryLimit= QueryBase2.getSobjectAllFieldsSOQL('Limitations__c', 'Benefit__r.Grouper__c in:GrouperBenefitMap.keySet()');
//List<Limitations__c> lmtsn=database.query(queryLimit);
        List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c,IsCustom__c,Benefit__r.Benefit_Name__c,OldMax_TierVal__c, Benefit__r.Grouper__c,comment_codes__c, IsSelected__c, Jurisdiction__c, 
                                                               MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c, 
                                                               MaxDuration__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, IS_ASO_Only__c,
                                                               TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
                                                               MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c,  
                                                               MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,
                                                               TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c, RecordType__c,Effective_Date__c, Term_Date__c,
                                                               ParentBenefitName__c, TierLimitTo__c, TierLimitType__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c,
                                                               MaxDuration_Selected__c,MaxAge_Selected__c, TierLimit_Selected__c, TierAge_Selected__c
                                                               FROM Limitations__c where Benefit__r.Grouper__c   in:GrouperBenefitMap.keySet()]); 
          
        system.debug('@@lmtsn '+lmtsn );                                                       
        for(Limitations__c obj:lmtsn){
            List<Limitations__c> lmts=new List<Limitations__c>();
            List<Limitations__c> namelmts=new List<Limitations__c>();
            if(BeneLimitationMap.containsKey(obj.Benefit__c)){
                lmts=BeneLimitationMap.get(obj.Benefit__c);
            }
            
            if(BeneNameLimitationMap.containsKey(obj.Benefit__r.Benefit_Name__c)){
                namelmts=BeneNameLimitationMap.get(obj.Benefit__r.Benefit_Name__c);
            }
            lmts.add(obj);
            namelmts.add(obj);
            BeneLimitationMap.put(obj.Benefit__c,lmts);
            BeneNameLimitationMap.put(obj.Benefit__r.Benefit_Name__c,namelmts);
        } 
        system.debug('@@BDPGrouperMap'+BeneLimitationMap);
        system.debug('@@BDPGrouperMap'+BeneNameLimitationMap);
        system.debug('@@GrouperBenefitMap'+GrouperBenefitMap);
        //Creating a Map between BDP & Grouper
        Map<id,List<AIA_Grouper__c>> BDPGrouperMap = new Map<id,list<AIA_Grouper__c>>();
        for(Proposed_Products__c bdp:parentPPList){
            ppListToShow.add(bdp);
            list<AIA_Grouper__c> tempGrouperList = new list<AIA_Grouper__c>();
            for(AIA_Grouper__c grouper : existingGrouperList){
                if(bdp.Cloned_From__c ==grouper.Proposed_Products__c){
                    tempGrouperList.add(grouper);
                    BDPGrouperMap.put(bdp.id,tempGrouperList);
                    //continue;
                }
            }
        }
        
        system.debug('@@BDPGrouperMap'+BDPGrouperMap);
        Id BDRTypeId = Schema.SObjectType.AIA_Grouper__c.RecordTypeInfosByName.get('BD Product').RecordTypeId;
        Id benefitBDRTypeId = Schema.SObjectType.AIA_Benefits__c.RecordTypeInfosByName.get('BD Product').RecordTypeId;
        
        //Cloning Groupers
        list<AIA_Grouper__c> clonedGrouperList = new list<AIA_Grouper__c>();
        for(Proposed_Products__c bdp:parentPPList){
            if(BDPGrouperMap.get(bdp.id)!=null){
                list<AIA_Grouper__c> tempclonedGrouperList = BDPGrouperMap.get(bdp.id);
                for(AIA_Grouper__c parentGrouper:tempclonedGrouperList){
                    AIA_Grouper__c clonedGrouper = new AIA_Grouper__c();
                    
                    clonedGrouper=parentGrouper.clone();
                    clonedGrouper.Proposed_Products__c = bdp.id;
                    clonedGrouper.Cloned_From__c = parentGrouper.id;
                    clonedGrouper.recordTypeId= PPRTypeId;
                    clonedGrouper.Grouper_Record_Type__c = 'BRF';
                    clonedGrouper.Sequence_Number__c = parentGrouper.Sequence_Number__c;
                    clonedGrouperList.add(clonedGrouper);
                }
            }
        }
        if(clonedGrouperList.size()>0)
            insert clonedGrouperList;
        system.debug('@@clonedGrouperList'+clonedGrouperList);
   
            
        //Cloning associated Benefits
        List<AIA_Benefits__c> clonedBenefitList = new list<AIA_Benefits__c>();
        if(clonedGrouperList.size()>0){
            Proposed_Products__c pp = new Proposed_Products__c();
            Set<string> SetBenifitname = New Set<string>();
            Set<string> Setbnames = New Set<string>();
            for(AIA_Grouper__c clonedGrouper:clonedGrouperList){
                system.debug('@@GrouperBenefitMap.get(clonedGrouper.Cloned_From__c)'+GrouperBenefitMap);
                if(GrouperBenefitMap.get(clonedGrouper.Cloned_From__c)!=null){
                    
                    //system.debug('@@mapIdToPP==='+mapIdToPP);
                     //system.debug('@@clonedGrouper.Proposed_Products__c==='+clonedGrouper.Proposed_Products__c);
                    if(mapIdToPP != null && mapIdToPP.containsKey(clonedGrouper.Proposed_Products__c))
                      pp =  mapIdToPP.get(clonedGrouper.Proposed_Products__c);
                    //system.debug('@@cBen==PP='+pp);
                    list<AIA_Benefits__c> tempBenefitList = GrouperBenefitMap.get(clonedGrouper.Cloned_From__c);
                    //system.debug('@@tempBenefitList'+tempBenefitList);
                    
                    
                    for(AIA_Benefits__c benefit:tempBenefitList){
                        Setbnames.add(benefit.Benefit_Name__c);
                    }
                    //system.debug('@@Setbnames'+Setbnames);
                    for(string strbenName:copayBenMap.keySet())
                    {
                        //system.debug('@@strbenName'+strbenName);
                       // system.debug('@@Setbnames.Contains(strbenName)'+!Setbnames.Contains(strbenName));
                        if(!Setbnames.Contains(strbenName))
                        {
                            if(pp != null)
                            {
                                BeneNameToPPMap.put(strbenName,pp);
                                //system.debug('@@BeneNameToPPMap=='+BeneNameToPPMap);
                            }
                           system.debug('@@strbenName==Added=='+strbenName);
                           SetBenifitname.add(strbenName);
                        }
                    }
                    system.debug('@@SetBenifitname'+Setbnames);
                    //System.debug(LoggingLevel.INFO,'+++++SetBenifitname+++++'+SetBenifitname);
                    for(AIA_Benefits__c benefit:tempBenefitList){
                        AIA_Benefits__c clonedBenefit = new AIA_Benefits__c();
                        //system.debug('==mapIdToAIAbenifit=='+mapIdToAIAbenifit);
                        CopayTypeWrapper  cBen = null;
                        system.debug('@@copayBenMap==='+copayBenMap);
                        system.debug('@@cBen==='+benefit.Benefit_Name__c);
                        system.debug('@@copayBenMap==='+copayBenMap.containsKey(benefit.Benefit_Name__c));
                        if(copayBenMap != null && copayBenMap.containsKey(benefit.Benefit_Name__c))
                            cBen = copayBenMap.get(benefit.Benefit_Name__c);
                       // if(cBen == null)
                        //    continue;
                            
                       // copayBenMap.put(copType.Plan_Benefits__c, ct);
                        
                        //system.debug('@@cBen==='+cBen);
                        clonedBenefit=benefit.clone();
                        clonedBenefit.Grouper__c=clonedGrouper.id;
                        clonedBenefit.recordTypeId=benefitPPRTypeId;
                        clonedBenefit.Benefit_Record_Type__c = 'BRF';
                        clonedBenefit.Cloned_From_Benefit__c=benefit.id;
                        if(benefit.Benefit_Type__c == 'Limitation'){
                        clonedBenefit.Copay_Type_1_IsCovered__c = '';
                        clonedBenefit.OON_Copay_Type_1_IsCovered__c = '';
                        }
                        //system.debug('@@benefit.id==='+benefit.id);
                        if(isDataAvailable)
                        {                        
                        AIA_Plan_Copay_Type__c copayTypeSelected=new AIA_Plan_Copay_Type__c();
                        if(cBen !=null && cBen.copayTypeSelectedObj!=null){
                            copayTypeSelected=cBen.copayTypeSelectedObj;
                            //system.debug('copayTypeSelected1+++'+copayTypeSelected);
                            
                            if(copayTypeSelected != null)
                            {   
                            IF(pp.Product_Category__c=='Medical'){
                           // system.debug('@@benefit.Benefit_Name__c==='+benefit.Benefit_Name__c);
                            //system.debug('copayTypeSelected+++Medical++'+copayTypeSelected);
                            //system.debug('benefit+++Medical++'+benefit);

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
                            if (pp.Product_Category__c == 'Vision') {

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
        clonedBenefit.IN_Approx_Member_Payment_w_Disc_Default__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
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
 IF(pp.Product_Category__c == 'Dental') {
    

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
    if(pp.Product_Category__c=='Drug'){
                            
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
                        if(cBen !=null && cBen.copayTypePecSpecObj!=null && copayTypeSelected.AliasName__c != cBen.copayTypePecSpecObj.AliasName__c){ // && pp.Product_Category__c=='Medical'
                            copayTypeSelected=cBen.copayTypePecSpecObj;
                            if(copayTypeSelected != null)
                            {
                            //system.debug('copayTypePecSpec1+++'+copayTypeSelected);
                            
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
                            if(pp.Product_Category__c=='Medical'){
                            
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
                            
                          if (pp.Product_Category__c == 'Dental') {

    
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
   
 if (pp.Product_Category__c == 'Vision') {

    

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
                        if(cBen !=null && cBen.copayTypePecSpecObj2!=null && pp.Product_Category__c=='Medical' 
                          && copayTypeSelected.AliasName__c != cBen.copayTypePecSpecObj2.AliasName__c){
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
                        if(tmpMaxValue < clonedben.Sequence_Number_SF__c)       
                        {       
                             tmpMaxValue = clonedben.Sequence_Number_SF__c;         
                        }       
                        mapGrpIdTomaxValue.put(clonedben.Grouper__c,tmpMaxValue);   
                    }
                    system.debug('@@maxvalue=='+maxvalue);
                    system.debug('@@setClonedBenNames==='+setClonedBenNames);
                    System.debug(LoggingLevel.INFO,'+++++setClonedBenNames+++++'+setClonedBenNames);
                    List<AggregateResult> agrmaxSeqNumber = [SELECT max(Sequence_Number__c)maxNum FROM AIA_Grouper__c where ID in: clonedGrouperList];
                    
                    Integer maxSeqNumberGrouper = Integer.ValueOf(agrmaxSeqNumber[0].get('maxNum'));
                    
                   List<AggregateResult> agrmaxSeqNumber2 = [SELECT max(Sequence_Number_SF__c)maxNum FROM AIA_Benefits__c where Grouper__c in: clonedGrouperList
                                                                     and Benefit_Type__c = 'Benefit'];
                            maxSeqNumber = Integer.ValueOf(agrmaxSeqNumber2[0].get('maxNum'));
                   
    
    system.debug('seqnumbernewben'+ maxSeqNumber );
                    for(string strben:SetBenifitname)
                    {
                        if (copayBenMap != null && copayBenMap.containsKey(strben) && !setClonedBenNames.Contains(strben))
                        {
                            system.debug('@@strben==='+strben);
                            System.debug(LoggingLevel.INFO,'+++++strben+++++'+strben);
                            setNewBenefits.add(strben);
                           if(mapbenefitNameToPPID != null && mapbenefitNameToPPID.ContainsKey(strben))
                            {
                            Proposed_Products__c pp1 = mapbenefitNameToPPID.get(strben);
                              if(mapOldIdToOldPP != null && mapOldIdToOldPP.ContainsKey(pp1.id))
                            {
                            Proposed_Products__c pp2 = mapOldIdToOldPP.get(pp1.id);
                            system.debug('@@pp1==='+pp1);
                            AIA_Benefits__c clonedBenefit= ClonebenifitFromCopay(strben,pp2,clonedGrouperList,maxSeqNumberGrouper ,maxSeqNumber );
                            system.debug('@@NewclonedBenefit==='+clonedBenefit);
                            if(maxSeqNumber == null){
                                maxSeqNumber = 0;
                            }                           
                            maxSeqNumber = maxSeqNumber+1; 
                            clonedBenefit.Sequence_Number_SF__c = maxSeqNumber;
                            clonedBenefit.Sequence_Number__c = maxSeqNumber;
                            System.debug(LoggingLevel.INFO,'+++++NewclonedBenefit+++++'+clonedBenefit);
                            
                            clonedBenefitList.add(clonedBenefit);
                            BeneNameToBenefit.put(strben,clonedBenefit); 
                            }
                            }
                        }
                    }
        system.debug('@@clonedBenefitList'+clonedBenefitList);
        if(clonedBenefitList.size()>0)
            insert clonedBenefitList; 
        }
          
        
        System.debug('+++++createWrapListFromPlanCostShr++++mapIDTobenefit++++'+mapIDTobenefit);
       Map<String,boolean> mapManBenNameToIsCustom = new Map<String,boolean>(); 
       Map<String,boolean> mapLimitBenNameToIsCustom = new Map<String,boolean>(); 
       Map<String,boolean> mapLimitToIsCustom = new Map<String,boolean>(); 
       
         
         for(String str:BeneNameLimitationMap.KeySet()){ 
            list<Limitations__c> tempLimitList = BeneNameLimitationMap.get(str);
            system.debug('@@BeneNameLimitationMap==tempLimitList='+tempLimitList);
            boolean isCustom = false;
            for(Limitations__c limi:tempLimitList){
                if(limi.IsCustom__c == 'Yes')
                {
                    isCustom = true; 
                    system.debug('@@limi==='+limi);
                }                   
            }
            mapLimitToIsCustom.put(str,isCustom);
         }
     system.debug(Logginglevel.INFO,'@@mapLimitToIsCustom==='+mapLimitToIsCustom);
                 
       //Cloning associated Benefits Limitations
        List<Limitations__c> clonedLimitList = new list<Limitations__c>();
        if(clonedBenefitList.size()>0){
            for(AIA_Benefits__c clonedBen:clonedBenefitList){
                boolean IsLimitCustom = false;
                system.debug('@@clonedBen.Benefit_Name__c==='+clonedBen.Benefit_Name__c);
                system.debug('@@BeneNameLimitationMap.containsKey(clonedBen.Benefit_Name__c)==='+BeneNameLimitationMap.containsKey(clonedBen.Benefit_Name__c));
                //system.debug(Logginglevel.INFO,'BeneLimitationMap---==='+ BeneLimitationMap);
                //system.debug(Logginglevel.INFO,'clonedBen---==='+ clonedBen);
                if(BeneLimitationMap.get(clonedBen.Cloned_From_Benefit__c)!=null){
                    if(mapLimitToIsCustom.containsKey(clonedBen.Benefit_Name__c)){
                        IsLimitCustom = mapLimitToIsCustom.get(clonedBen.Benefit_Name__c);
                    }
                    system.debug(Logginglevel.INFO,'@@IsLimitCustom==='+IsLimitCustom);
                    if(IsLimitCustom || !isDataAvailable )
                    {
                        system.debug('@@BeneLimitationMap==clonedLimitList='+BeneNameLimitationMap.get(clonedBen.Benefit_Name__c));
                        if(BeneLimitationMap.get(clonedBen.Cloned_From_Benefit__c)!=null){
                            list<Limitations__c> tempLimitList = BeneLimitationMap.get(clonedBen.Cloned_From_Benefit__c);
                           
                            system.debug('@@tempLimitList'+tempLimitList);
                            system.debug(Logginglevel.INFO,'BeneLimitationMap---==='+ clonedBen.Cloned_From_Benefit__c + 'Limitaions===' + tempLimitList);
                            for(Limitations__c limi:tempLimitList){
                                Limitations__c clonedLimi = new Limitations__c();
                                clonedLimi=limi.clone();
                                clonedLimi.Benefit__c =clonedBen.id;
                                clonedLimitList.add(clonedLimi);
                                
                            }
                             system.debug(Logginglevel.INFO,'@@clonedLimitList@@'+clonedLimitList);
                        }
                        
                    }
                    else
                    {
                        system.debug('@@ParentBenLimitationMan==clonedLimitList='+ParentBenLimitationMan.get(clonedBen.Benefit_Name__c));
                        if(ParentBenLimitationMan.get(clonedBen.Benefit_Name__c)!=null){
                            if(clonedBen.Benefit_Type__c == 'Mandate')
                            {
                            list<Limitations__c> tempLimitList = ParentBenLimitationMan.get(clonedBen.Benefit_Name__c);
                            system.debug('@@tempLimitList'+tempLimitList);
                            system.debug(Logginglevel.INFO,'ParentBenLimitationMan---==='+ clonedBen.Benefit_Name__c + 'Limitaions===' + tempLimitList);
                            for(Limitations__c limi:tempLimitList){
                                Limitations__c clonedLimi = new Limitations__c();
                                clonedLimi=limi.clone();
                                clonedLimi.Benefit__c =clonedBen.id;
                                clonedLimitList.add(clonedLimi);
                                
                            }
                            }
                        }
                        system.debug(Logginglevel.INFO,'ParentBenLimitationLimit.get(clonedBen.Benefit_Name__c)---==='+ ParentBenLimitationLimit.get(clonedBen.Benefit_Name__c));
                        system.debug(Logginglevel.INFO,'ParentBenLimitationLimit---Inside==='+ ParentBenLimitationLimit);
                        system.debug('@@ParentBenLimitationLimit==clonedLimitList='+ParentBenLimitationLimit.get(clonedBen.Benefit_Name__c));
                        if(ParentBenLimitationLimit.get(clonedBen.Benefit_Name__c)!=null){
                            if(clonedBen.Benefit_Type__c == 'Limitation')
                            {
                            list<Limitations__c> tempLimitList = ParentBenLimitationLimit.get(clonedBen.Benefit_Name__c);
                            system.debug('@@ParentBenLimitationLimit==tempLimitList'+tempLimitList);
                            system.debug(Logginglevel.INFO,'ParentBenLimitationLimit---==='+ clonedBen.Benefit_Name__c + 'Limitaions===' + tempLimitList);
                            for(Limitations__c limi:tempLimitList){
                                Limitations__c clonedLimi = new Limitations__c();
                                clonedLimi=limi.clone();
                                clonedLimi.Benefit__c =clonedBen.id;
                                clonedLimitList.add(clonedLimi);
                                
                            }
                            }
                        }
                    }
                }
                
            }
        }
system.debug(Logginglevel.INFO,'setNewBenefits---==='+ setNewBenefits);
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
        
       
        AIA_BRF_DeepCloneHelper aiaBrfDeepHelper = new AIA_BRF_DeepCloneHelper();        
        aiaBrfDeepHelper.getPlanLimitation(setbenids,currentPP,BRF.Benefit_Effective_Date__c);
        aiaBrfDeepHelper.getPlanCommentCodes(currentPP,BRF.Benefit_Effective_Date__c);
        ParentBenLimitationMan = aiaBrfDeepHelper.ParentBenLimitationMan;
        ParentBenLimitationLimit = aiaBrfDeepHelper.ParentBenLimitationLimit;
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
                    AIA_Benefits__c newLimitBenefit = new AIA_Benefits__c(); 
                    newLimitBenefit = oldBenefitToClone.clone();
                    newLimitBenefit.Benefit_Type__c = 'Mandate' ;
                    newLimitBenefit.Sequence_Number_SF__c = oldBenefitToClone.Sequence_Number_SF__c - 0.5;
                    newBenefits.put(strben+'_Mandate',newLimitBenefit);                                
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
                      //system.debug(Logginglevel.INFO,'clonedLimi---ParentBenLimitationMan==='+clonedLimi);  
                    }
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
                        //system.debug(Logginglevel.INFO,'clonedLimi---ParentBenLimitationLimit==='+clonedLimi);
                        clonedLimitList.add(clonedLimi);
                      }  
                    }
                }
                
            }
        }
        //system.debug(Logginglevel.INFO,'clonedLimitList---Final==='+clonedLimitList);
        insert clonedLimitList;
        if(lstOldbenefitsToUpdate != null && lstOldbenefitsToUpdate.size()>0)
            update lstOldbenefitsToUpdate;
        system.debug(Logginglevel.INFO,'clonedLimitList---Final==='+clonedLimitList); 
      
        }catch(Exception e){
            system.debug('Exception in cloning of Records :'+e.getLineNumber()+'Message'+e.getmessage());
            system.debug(Logginglevel.INFO,'Exception in cloning of Records INFO :'+e.getLineNumber()+'Message'+e.getmessage());
        }
        return null;//new PageReference('/'+BrfID);
    }
    

    
 public PageReference save(){
 
    
     
        try {
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_BenefitTriggerHandler.disableAdjustmentsOnUpdates();
        AIA_ProposedProductsHandler.firstRun = true;
        AIA_ProposedProductsHandler.afterInsert = true;
        AIA_ProposedProductsHandler.afterUpdate = true;
        AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;

        system.debug('@@ brfObj.opportunity__c in save'+brfObj.opportunity__c);
          BRF.Opportunity__c = brfObj.opportunity__c;System.debug('upsert BRF 3');
          upsert BRF;System.debug('upsert BRF 3E');
            getSelectedAIADoc();
        
            upsert selAIA_DocList;
             selPPList = new list<Proposed_Products__c>();
              for(PPWrapper wrapper: lstPPWrapper){
                  if(wrapper.checked){
                      wrapper.pp.Benefit_Request_Form__c = BRF.id;
                      selPPList.add(wrapper.pp);
                  }
              }
             upsert selPPList; 
            PageReference  pgRef = new pageReference('/'+BRF.id);
            pgRef.setRedirect(true);
            return pgRef;
            /*T10 Start again commenting out unreachable code
              AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();
            T10 End*/
        }
        //T01 Start
        catch(DMLException dmlex) { 
        // Database.rollback(sp);
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,dmlex.getDmlMessage(0));
            ApexPages.addMessage(myMsg);
            return null; 
            } 
            /*T10 Start again Commenting out unreachable code
            return null; //T01 End
            T10 End */
    }
 
  Transient Map<String,AIA_Plan_Copay_Type__c> ParentBenifitMandateName= new Map<String,AIA_Plan_Copay_Type__c>();
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
public AIA_Benefits__c ClonebenifitFromCopay(string benefitname,Proposed_Products__c pp,list<AIA_Grouper__c> clonedGrouperList,Integer maxSeqNumberGrouper ,Integer maxSeqNumber ) {
      AIA_Benefits__c clonedBenefit = new AIA_Benefits__c() ;
CopayTypeWrapper  cBen = null;


 Id benefitPPRTypeId = Schema.SObjectType.AIA_Benefits__c.RecordTypeInfosByName.get('Proposed Product').RecordTypeId;
 Id PPRTypeId = Schema.SObjectType.AIA_Grouper__c.RecordTypeInfosByName.get('Proposed Product').RecordTypeId;
 system.debug('ClonebenifitFromCopay++benefitname+++' + benefitname);
 if (copayBenMap != null && copayBenMap.containsKey(benefitname))
  cBen = copayBenMap.get(benefitname);
  /*List<AggregateResult> agrmaxSeqNumber = [SELECT max(Sequence_Number__c)maxNum FROM AIA_Grouper__c where ID in: clonedGrouperList];
    Integer maxSeqNumberGrouper = Integer.ValueOf(agrmaxSeqNumber[0].get('maxNum'));*/
    if(maxSeqNumberGrouper == null){
        maxSeqNumberGrouper = 0;
        }
    maxSeqNumberGrouper = maxSeqNumberGrouper +1;
  

   /*List<AggregateResult> agrmaxSeqNumber2 = [SELECT max(Sequence_Number_SF__c)maxNum FROM AIA_Benefits__c where Grouper__c in: clonedGrouperList
                                                     and Benefit_Type__c = 'Benefit'];
            maxSeqNumber = Integer.ValueOf(agrmaxSeqNumber2[0].get('maxNum'));*/
             if(maxSeqNumber == null){
             maxSeqNumber = 0;
             }
    
    maxSeqNumber = maxSeqNumber+1; 
    
    system.debug('seqnumbernewben'+ maxSeqNumber );
           
               
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
        system.debug('aiagrp.Proposed_Products__c++' + aiagrp.Proposed_Products__c);
        system.debug('pp.id++' + pp.id);
        if(aiagrp.Name == copayTypeSelected.Grouper_Name__c && aiagrp.Proposed_Products__c == pp.id)
        {
            clonedBenefit.Grouper__c=aiagrp.id;
        }
     
        
        
    }
    system.debug('clonedBenefit.Grouper__c+++' + clonedBenefit.Grouper__c);
    
    if(clonedBenefit.Grouper__c == null)
    {
        AIA_Grouper__c clonedGrouper = new AIA_Grouper__c();
        system.debug('clonedGrouper.Proposed_Products__c = pp.id');
        clonedGrouper.Proposed_Products__c = pp.id;
        system.debug('clonedGrouper.Name = copayTypeSelected.Grouper_Name__c++');
        clonedGrouper.Name = copayTypeSelected.Grouper_Name__c;  
        system.debug('clonedGrouper.recordTypeId= PPRTypeId++');
        clonedGrouper.recordTypeId= PPRTypeId;
        system.debug('clonedGrouper.Grouper_Record_Type__c BRF');
        clonedGrouper.Grouper_Record_Type__c = 'BRF';
        system.debug('clonedGrouper.Group_Type__c++');
        clonedGrouper.Group_Type__c= 'Benefit Group';
        
        clonedGrouper.Sequence_Number__c = maxSeqNumberGrouper ;
        
        
        system.debug('clonedGrouper+++' + clonedGrouper);
        //clonedGrouper.Sequence_Number__c = parentGrouper.Sequence_Number__c;
        insert clonedGrouper;
        clonedBenefit.Grouper__c=clonedGrouper.id;
        clonedGrouperList.add(clonedGrouper);
      
    }
    system.debug('pp+++Medical++' + pp);
    system.debug('benefitPPRTypeId+++Medical++' + benefitPPRTypeId);
    clonedBenefit.recordTypeId=benefitPPRTypeId;
    clonedBenefit.Benefit_Record_Type__c = 'BRF';
    clonedBenefit.benefit_name__c=benefitname;
           
            
            
              
  IF(pp.Product_Category__c == 'Medical') {
    
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
     
     clonedBenefit.Sequence_Number_SF__c = maxSeqNumber;
     clonedBenefit.Sequence_Number__c = maxSeqNumber;
    maxSeqNumber = maxSeqNumber+1;
   
     if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'Y') {
      clonedBenefit.IS_ASO_Only__c = True;
     }
     if (copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c == 'N') {
      clonedBenefit.IS_ASO_Only__c = False;
     }

     clonedBenefit.IsAppGlobalCoinsurance__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCoinsurance__c;
     clonedBenefit.IsAppGlobalCopay__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCopay__c;

    

   } 
   
   if (pp.Product_Category__c == 'Drug') {

    clonedBenefit.InNetwork_ExtID_Copay1__c = copaytypeselected.ExtID__c;
 clonedBenefit.DefaultPlanBenefitValue__c=  (copayTypeSelected.IsCovered__c!=null?copayTypeSelected.IsCovered__c:'')+'_'
                                    +(copayTypeSelected.CopayAmount__c!=null?String.valueof(copayTypeSelected.CopayAmount__c):'')
                                    +'_'+(copayTypeSelected.CoinsuranceAmount__c!=null?String.valueof(copayTypeSelected.CoinsuranceAmount__c):'')
                                    +'_'+(copayTypeSelected.MinPayAmount__c!=null?String.valueof(copayTypeSelected.MinPayAmount__c):'')
                                    +'_'+(copayTypeSelected.MaxPayAmount__c!=null?String.valueof(copayTypeSelected.MaxPayAmount__c):'')
                                    +'_'+(copayTypeSelected.TierType__c!=null?copayTypeSelected.TierType__c:'');
     clonedBenefit.Sequence_Number_SF__c = maxSeqNumber;
     clonedBenefit.Sequence_Number__c = maxSeqNumber;
     maxSeqNumber = maxSeqNumber+1;
     clonedBenefit.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
     clonedBenefit.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;
     clonedBenefit.Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
     clonedBenefit.Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c == 'Yes' ? 'Yes' : 'No';
     clonedBenefit.Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
     clonedBenefit.Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;

      clonedBenefit.Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
     clonedBenefit.Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
     clonedBenefit.Copay_Type_1_Low__c = copayTypeSelected.Copay_Low__c;
     clonedBenefit.Copay_Type_1_High__c = copayTypeSelected.Copay_High__c;
     clonedBenefit.Copay_Type_1_Increment__c = copayTypeSelected.Copay_Increment__c;
     clonedBenefit.Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;
     clonedBenefit.Copay_Type_1_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
     clonedBenefit.Copay_Type_1_AdditionalInvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;
     
 
     clonedBenefit.Copay_Min_Payment__c = copayTypeSelected.MinPayAmount__c;
     clonedBenefit.Copay_Default_Min_Payment__c = copayTypeSelected.MinPayAmount__c;
     
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
 if (pp.Product_Category__c == 'Vision') {
    
     clonedBenefit.Sequence_Number_SF__c = maxSeqNumber;
     clonedBenefit.Sequence_Number__c = maxSeqNumber;
     maxSeqNumber = maxSeqNumber+1;
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
 IF(pp.Product_Category__c == 'Dental') {
    
     clonedBenefit.Sequence_Number_SF__c = maxSeqNumber;
     clonedBenefit.Sequence_Number__c = maxSeqNumber;
     maxSeqNumber = maxSeqNumber+1;
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
  if (copayTypeSelected != null) {
       for(AIA_Grouper__c aiagrp:clonedGrouperList)
    {
        system.debug('aiagrp.Name++' + aiagrp.Name);
        system.debug('aiagrp.Name++' + copayTypeSelected.Grouper_Name__c);
        system.debug('copayTypeSelected.Grouper_Name__c++' + copayTypeSelected.Grouper_Name__c);
        system.debug('aiagrp.Proposed_Products__c++' + aiagrp.Proposed_Products__c);
        system.debug('pp.id++' + pp.id);
        
        if(aiagrp.Name == copayTypeSelected.Grouper_Name__c && aiagrp.Proposed_Products__c == pp.id)
        {
            clonedBenefit.Grouper__c=aiagrp.id;
        }
        if(Test.isRunningTest() && Istestdata && clonedBenefit.Grouper__c == null)
       {
           clonedBenefit.Grouper__c=aiagrp.id;
       }
        
    }
    system.debug('clonedBenefit.Grouper__c+++' + clonedBenefit.Grouper__c);
    
    if(clonedBenefit.Grouper__c == null)
    {
        AIA_Grouper__c clonedGrouper = new AIA_Grouper__c(); 
        system.debug('clonedGrouper.Proposed_Products__c = pp.id');
        clonedGrouper.Proposed_Products__c = pp.id;
        system.debug('clonedGrouper.Name = copayTypeSelected.Grouper_Name__c++');
        clonedGrouper.Name = copayTypeSelected.Grouper_Name__c;  
        system.debug('clonedGrouper.recordTypeId= PPRTypeId++');
        clonedGrouper.recordTypeId= PPRTypeId;
        system.debug('clonedGrouper.Grouper_Record_Type__c BRF');
        clonedGrouper.Grouper_Record_Type__c = 'BRF';
        system.debug('clonedGrouper.Group_Type__c++');
        clonedGrouper.Group_Type__c= 'Benefit Group';
        clonedGrouper.Sequence_Number__c = maxSeqNumberGrouper ;
        
        system.debug('clonedGrouper+++' + clonedGrouper);
        //clonedGrouper.Sequence_Number__c = parentGrouper.Sequence_Number__c;
        insert clonedGrouper;
        clonedBenefit.Grouper__c=clonedGrouper.id;
    }
    clonedBenefit.DefaultPlanBenefitValue__c=  (copayTypeSelected.IsCovered__c!=null?copayTypeSelected.IsCovered__c:'')
                                    +'_'+(copayTypeSelected.CoinsuranceAmount__c!=null?String.valueof(copayTypeSelected.CoinsuranceAmount__c):'')
                                    +'_'+ (copayTypeSelected.DeductibleApplies__c!=null?copayTypeSelected.DeductibleApplies__c:'')
                                    +'_'+(copayTypeSelected.CopayAmount__c!=null?String.valueof(copayTypeSelected.CopayAmount__c):'')+'_';
   system.debug('copayTypePecSpec1+++' + copayTypeSelected);
clonedBenefit.recordTypeId=benefitPPRTypeId;
    clonedBenefit.Benefit_Record_Type__c = 'BRF';
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
        system.debug('aiagrp.Proposed_Products__c++' + aiagrp.Proposed_Products__c);
        system.debug('pp.id++' + pp.id);
        if(aiagrp.Name == copayTypeSelected.Grouper_Name__c && aiagrp.Proposed_Products__c == pp.id)
        {
            clonedBenefit.Grouper__c=aiagrp.id;
        }
       if(Test.isRunningTest() && Istestdata)
       {
           clonedBenefit.Grouper__c=aiagrp.id;
       }
        
    }
    system.debug('clonedBenefit.Grouper__c+++' + clonedBenefit.Grouper__c);
    
    if(clonedBenefit.Grouper__c == null)
    {
        AIA_Grouper__c clonedGrouper = new AIA_Grouper__c(); 
        system.debug('clonedGrouper.Proposed_Products__c = pp.id');
        clonedGrouper.Proposed_Products__c = pp.id;
        system.debug('clonedGrouper.Name = copayTypeSelected.Grouper_Name__c++');
        clonedGrouper.Name = copayTypeSelected.Grouper_Name__c;  
        system.debug('clonedGrouper.recordTypeId= PPRTypeId++');
        clonedGrouper.recordTypeId= PPRTypeId;
        system.debug('clonedGrouper.Grouper_Record_Type__c BRF');
        clonedGrouper.Grouper_Record_Type__c = 'BRF';
        system.debug('clonedGrouper.Group_Type__c++');
        clonedGrouper.Group_Type__c= 'Benefit Group';
        clonedGrouper.Sequence_Number__c = maxSeqNumberGrouper ;
        system.debug('clonedGrouper+++' + clonedGrouper);
        //clonedGrouper.Sequence_Number__c = parentGrouper.Sequence_Number__c;
        insert clonedGrouper;
        clonedBenefit.Grouper__c=clonedGrouper.id;
    }  
    clonedBenefit.recordTypeId=benefitPPRTypeId;
    clonedBenefit.Benefit_Record_Type__c = 'BRF';
    clonedBenefit.benefit_name__c=benefitname;
   system.debug('copayTypeSelected2+++' + copayTypeSelected);
   if (pp.Product_Category__c == 'Medical') {

    
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

if (pp.Product_Category__c == 'Dental') {

    
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
   
 if (pp.Product_Category__c == 'Vision') {

    

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
 if (cBen != null && cBen.copayTypePecSpecObj2 != null && pp.Product_Category__c == 'Medical') {
  copayTypeSelected = cBen.copayTypePecSpecObj2;
  
  if (copayTypeSelected != null) {
       for(AIA_Grouper__c aiagrp:clonedGrouperList)
    {
        system.debug('aiagrp.Name++' + aiagrp.Name);
        system.debug('aiagrp.Name++' + copayTypeSelected.Grouper_Name__c);
        system.debug('copayTypeSelected.Grouper_Name__c++' + copayTypeSelected.Grouper_Name__c);
        system.debug('aiagrp.Proposed_Products__c++' + aiagrp.Proposed_Products__c);
        system.debug('pp.id++' + pp.id);
        if(aiagrp.Name == copayTypeSelected.Grouper_Name__c && aiagrp.Proposed_Products__c == pp.id)
        {
            clonedBenefit.Grouper__c=aiagrp.id;
        }
        
    }
    system.debug('clonedBenefit.Grouper__c+++' + clonedBenefit.Grouper__c);
    
    if(clonedBenefit.Grouper__c == null)
    {
        AIA_Grouper__c clonedGrouper = new AIA_Grouper__c(); 
        system.debug('clonedGrouper.Proposed_Products__c = pp.id');
        clonedGrouper.Proposed_Products__c = pp.id;
        system.debug('clonedGrouper.Name = copayTypeSelected.Grouper_Name__c++');
        clonedGrouper.Name = copayTypeSelected.Grouper_Name__c;  
        system.debug('clonedGrouper.recordTypeId= PPRTypeId++');
        clonedGrouper.recordTypeId= PPRTypeId;
        system.debug('clonedGrouper.Grouper_Record_Type__c BRF');
        clonedGrouper.Grouper_Record_Type__c = 'BRF';
        system.debug('clonedGrouper.Group_Type__c++');
        clonedGrouper.Group_Type__c= 'Benefit Group';
        clonedGrouper.Sequence_Number__c = maxSeqNumberGrouper ;
        system.debug('clonedGrouper+++' + clonedGrouper);
        //clonedGrouper.Sequence_Number__c = parentGrouper.Sequence_Number__c;
        insert clonedGrouper;
        clonedBenefit.Grouper__c=clonedGrouper.id;
    }
    clonedBenefit.DefaultPlanBenefitValue__c=  (copayTypeSelected.IsCovered__c!=null?copayTypeSelected.IsCovered__c:'')
                                    +'_'+(copayTypeSelected.CoinsuranceAmount__c!=null?String.valueof(copayTypeSelected.CoinsuranceAmount__c):'')
                                    +'_'+ (copayTypeSelected.DeductibleApplies__c!=null?copayTypeSelected.DeductibleApplies__c:'')
                                    +'_'+(copayTypeSelected.CopayAmount__c!=null?String.valueof(copayTypeSelected.CopayAmount__c):'')+'_';
   system.debug('copayTypePecSpec2+++' + copayTypeSelected);
clonedBenefit.recordTypeId=benefitPPRTypeId;
    clonedBenefit.Benefit_Record_Type__c = 'BRF';
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

    
}