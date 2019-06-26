/*=================================================================================================================
 * Date         : 02/06/2017
 * Developer    : Ramakrishna
 * Purpose      : While adding new products on BRF, user can select existing proposed products. Then the selected  
 *                products along with groupers, benefits, comments codes and AIA Docs with Attachemnts will be CLONED.
 *=================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 * 02/06/2017 | Ramakrishna    |     | Initial Version
 * 31/01/2018 | Gayathri       | T02 | Added a method to if logged-in user is in classic or lightning mode
 * 02/26/2018 | Satya T        | T03 | Added as a part of production defect. When user clicks on copy products button 
 *                                      on PP related list of BRF, selected PP should be copied & if all of them have 
 *                                      arc approved checkbox  to true, then arc aproval status will be set to 
 *                                      "Approved by Committee" 
 *===========+============+========================================================================================
 */
public class AIA_Add_Products_On_BRF_Cls {
    
    public string BrfID{get;set;} 
  //  public ApexPages.StandardController ctler{get; set;}   
    public List<MainWrapper> PPSelectList{get;set;} 
    public string selectedId{get;set;}
    public boolean selectedFlg{get;set;}
    public Map<id,List<AIA_Benefits__c>> GrouperBenefitMap = new Map<id,List<AIA_Benefits__c>>();
    /** T02 - Start **/
    public PageReference returnToBRF()
    {
        return new PageReference('/' + BrfID);
    }
    public String msg{get; set;}
    public Boolean displayPopUp{get; set;}
    /** T02 - End **/       
    public AIA_Add_Products_On_BRF_Cls(){
       // ctler=controller;       
        BrfID= ApexPages.currentPage().getParameters().get('id');
        PPSelectList = prepareProposedProducts(BrfID);
     }  
    //public class myException extends Exception{}   // just to test exception & roll back added this line
   
   @TestVisible private void displayError(string errorMsg){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.error, errorMsg);
        ApexPages.AddMessage(myMsg); 
    }
 
    //T02--Start--Method to check whether the page is in Classic or lightning
    public Boolean getIsClassic() {
    return (UserInfo.getUiThemeDisplayed() == 'Theme3');
    }
    //T02--End
    
//Fetch the eligible proposed products i.e PPs from other BRFs which has same effective date & opportunity     
    public List<MainWrapper> prepareProposedProducts(string BrfID){
        Benfit_Request_Form__c BRF = new Benfit_Request_Form__c();
        List<Benfit_Request_Form__c> BRFLst = new List<Benfit_Request_Form__c>();
        List<Proposed_Products__c> PPLst = new List<Proposed_Products__c>();
        List<MainWrapper> PageLst = new List<MainWrapper>();
        set<string> BRFIds = new set<string>();
        Map<String,List<Proposed_Products__c>> ProposedProductsMap = new Map<String,List<Proposed_Products__c>>();
        
        try{
            system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& BRF Id '+BrfID);
            if(BrfID != null){
                BRF = [select Id,Name,Benefit_Effective_Date__c,Opportunity__c from Benfit_Request_Form__c where Id =:BrfID];                
                if(BRF != null){
                    if(BRF.Benefit_Effective_Date__c != null && BRF.Opportunity__c != null)
                    BRFLst = [select ID,Name,Benefit_Effective_Date__c from Benfit_Request_Form__c 
                                where Opportunity__c = :BRF.Opportunity__c 
                                AND Benefit_Effective_Date__c = :BRF.Benefit_Effective_Date__c 
                                AND Id !=: BRF.Id];
                    system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& Relavent BRFs List '+BRFLst);
                    List<Proposed_Products__c> existingPPList = new List<Proposed_Products__c>([select Id,name, Cloned_From__c,ARC_check__c from Proposed_Products__c where Benefit_Request_Form__c =:BrfID]);
                    
                    map<string, Proposed_Products__c> existingPPmap = new map<string, Proposed_Products__c>();
                    for(Proposed_Products__c map1 : existingPPList){
                        existingPPmap.put(map1.Cloned_From__c, map1);
                    }
                                        
                    if(BRFLst != null && BRFLst.size()>0){
                        for(Benfit_Request_Form__c brf1 : BRFLst){
                            BRFIds.add(brf1.Id);
                        }                        
                        if(BRFIds != null && BRFIds.size()>0){
                            PPLst = [select Id,Name,Benefit_Request_Form__c,Custom__c,Product_Category__c,Product_Name__c,
                                     Account_Specified_Product_Name__c,Plan_Name__c,Funding_Arrangement__c,Benefits_Completed__c,ARC_check__c,
                                     ARC_Approved__c 
                                     from Proposed_Products__c where Benefit_Request_Form__c IN :BRFIds order by Name asc]; 
                                    // and Related_Medical_Product__c=null];                    
                            system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&& Proposed Products List '+PPLst);
                            if(PPLst != null && PPLst.size()>0){ 
                                    if(existingPPmap != null && existingPPmap.size()>0){
                                            for(Proposed_Products__c pp :PPLst){
                                                  if(!(existingPPmap.containsKey(pp.Id))){  
                                                        PageLst.add(new MainWrapper(pp)); 
                                                   }
                                                //else PageLst.add(new MainWrapper(pp)); 
                                            }
                                    }
                                    else{
                                            for(Proposed_Products__c pp :PPLst){
                                                PageLst.add(new MainWrapper(pp));
                                            }
                                    }                               
                            system.debug('Page List '+PageLst);
                            }
                        }                        
                    }
                }
            }
        }catch(Exception e){
            system.debug('Exception in Add Proposed Products '+e.getMessage());
        }
        return PageLst;
    }

    /*  Below method is to query Ancillary products, for the primary medical products selected on the UI, and mark them automatically on the UI
        for the cloning process.
    */
    public void AutoSelectAncillaryProducts(){        
        Savepoint sp = Database.setSavepoint();                     
        try{            
            List<Proposed_Products__c> AncillryPPList = new List<Proposed_Products__c>([select Id,name,ARC_check__c from Proposed_Products__c where Related_Medical_Product__c =:selectedId]);
                if(AncillryPPList !=null && AncillryPPList.size()>0){
                     for(Proposed_Products__c ancpp:AncillryPPList){                    
                        for(MainWrapper mw: PPSelectList){
                            if(mw.product.Id == ancpp.Id){  
                                if(selectedFlg==false){
                                    mw.selected = true;
                                }else mw.selected = false;
                            }
                        }                   
                    }                
                }                                                               
        }catch(Exception e){
            system.debug('Exception in Add Proposed Products '+e.getMessage());
        }
    }

    //clone the selected list of PPs and the associated childs (Groupers, Benefits, Comment codes, AIADocs)
    public PageReference cloneSelRecords(List<MainWrapper> PPSelectList,string BrfID){
        
        Savepoint sp = Database.setSavepoint();
        
        List<Proposed_Products__c> SelectedPPlist = new List<Proposed_Products__c>();
        set<string> oldRecIds = new set<string>();
        Proposed_Products__c PPobj;
        AIA_Document__c Docobj;
        
        try{
            if(PPSelectList != null && PPSelectList.size()>0){
                for(MainWrapper mw: PPSelectList){
                    if(mw.Selected == true){
                        system.debug('&&&&&&&&&&&&&&&&&&&&&&&& selected PP:'+mw);                     
                        SelectedPPlist.add(mw.product);                        
                    }
                }
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&& selected PPs:'+SelectedPPlist);  // Proposed products which are selected from UI
            }                        
                                    
            set<id> PPIdSet = new set<id>();
            for(Proposed_Products__c ppRec:SelectedPPlist){
                PPIdSet.add(ppRec.Id);
            }
            system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&& PPIdSet'+PPIdSet);
            
            
       /*    List<Proposed_Products__c> AncillryPPList = new List<Proposed_Products__c>([select Id,name from Proposed_Products__c where Related_Medical_Product__c in :PPIdSet]);
            for(Proposed_Products__c ancpp:AncillryPPList){
                    SelectedPPlist.add(ancpp);
                    PPIdSet.add(ancpp.Id);
            }   */
            //Query all fields for PPs
            String QueryString=QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c', 'Id in :PPIdSet');
            system.debug('&&&&&&&&&& query:'+QueryString);
                    List<Proposed_Products__c> PPList = Database.query(QueryString);
            system.debug('&&&&&&&&&&&&&&&&& PPList from the query:'+PPList);
                    list<Proposed_Products__c> relatedPPList = new list<Proposed_Products__c>();
                    list<Proposed_Products__c> parentPPList = new list<Proposed_Products__c>();                                     
            //Clone the PPs
            for(Proposed_Products__c pp: PPList){
                            PPobj = new Proposed_Products__c();
                            PPobj = pp.clone(false);
                            PPobj.Benefit_Request_Form__c = BrfID;   
                            PPobj.Cloned_From__c = pp.Id;
                             PPobj.ARC_check__c = pp.ARC_Approved__c; //T03
                                if(pp.Product_Category__c =='Medical'){
                                       PPobj.Cloned_From_Related_Medical__c = '';
                                }   
                                else 
                                    PPobj.Cloned_From_Related_Medical__c = pp.Related_Medical_Product__c;                                    
                            PPobj.Custom__c = False;
                            parentPPList.add(PPobj);                
                        }            
            system.debug('&&&&&&&&&&&&&&&& List for Insert:'+parentPPList);
         map<string,string> ancmap = new map<string,string>();                                                                      
         if(parentPPList != null && parentPPList.size()>0){               
               // upsert parentPPList;
             
            //Maintain Old and new PP Ids
          //  map<string,string> ancmap = new map<string,string>();
            for (Proposed_Products__c rec:parentPPList){               
                ancmap.put(rec.Cloned_From__c,rec.Id);
            }
            // Get the Ancillary products (related products)
            for(Proposed_Products__c anc: parentPPList){
                if(anc.Cloned_From_Related_Medical__c != ''){
                    anc.Related_Medical_Product__c = ancmap.get(anc.Cloned_From_Related_Medical__c);
                }
            }  
            upsert parentPPList;
         }    
        //Query for the existing AIA Documents which are associated with proposed products
            list<AIA_Document__c> AIADocumentList = [SELECT Id,Name,Document_Type__c, Document_Name__c ,Proposed_Products__c,Source__c, Benefit_Request_Form__c 
                                              FROM AIA_Document__c 
                                              WHERE Document_Type__c != 'Marked Up Benefit Summary' AND Proposed_Products__c in :PPIdSet];
            set<id> AIADocIdSet = new set<id>();
                for(AIA_Document__c AIADocRec:AIADocumentList){
                    AIADocIdSet.add(AIADocRec.Id);
                }
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&& PPIdSet'+AIADocIdSet);    
             // Query all filed and clone AIADocs   
             String AIAQueryString=QueryBase2.getSobjectAllFieldsSOQL('AIA_Document__c', 'Id in :AIADocIdSet');
                system.debug('&&&&&&&&&& query:'+AIAQueryString);
             List<AIA_Document__c> AIADocList = Database.query(AIAQueryString);
                system.debug('&&&&&&&&&&&&&&&&& AIAdDocsList from the query:'+AIADocList);    
            
            list<AIA_Document__c> newAIADocList = new  list<AIA_Document__c>();
            for(AIA_Document__c AIAdoc:AIADocList) {
                    Docobj = new AIA_Document__c();
                    Docobj = AIAdoc.clone(false);
                    Docobj.ClonedFromAIADocID__c = AIAdoc.Id;
                    Docobj.Attachment_ID__c = null;
                    Docobj.Benefit_Request_Form__c = BrfID;
                    Docobj.Proposed_Products__c = ancmap.get(AIADoc.Proposed_Products__c); 
                    newAIADocList.add(Docobj);
            }
            
            if(newAIADocList!=null && newAIADocList.size()>0){
                upsert newAIADocList;
            }
        //Maintain old and new Ids for AIADocs
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
            upsert newAIADocList;
            
            
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
            
        List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c,OldMax_TierVal__c, Benefit__r.Grouper__c,comment_codes__c, IsSelected__c, Jurisdiction__c, 
                                                               MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c, 
                                                               MaxDuration__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, IS_ASO_Only__c,
                                                               TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c, RecordType__c,
                                                               ParentBenefitName__c, TierLimitTo__c, TierLimitType__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c 
                                                               FROM Limitations__c where Benefit__r.Grouper__c   in:GrouperBenefitMap.keySet()]);
        for(Limitations__c obj:lmtsn){
            List<Limitations__c> lmts=new List<Limitations__c>();
            if(BeneLimitationMap.containsKey(obj.Benefit__c)){
                lmts=BeneLimitationMap.get(obj.Benefit__c);
            }
            lmts.add(obj);
            BeneLimitationMap.put(obj.Benefit__c,lmts);
        } 
        
        system.debug('@@GrouperBenefitMap'+GrouperBenefitMap);
        //Creating a Map between BDP & Grouper
        Map<id,List<AIA_Grouper__c>> BDPGrouperMap = new Map<id,list<AIA_Grouper__c>>();
        for(Proposed_Products__c bdp:parentPPList){
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
            for(AIA_Grouper__c clonedGrouper:clonedGrouperList){
                if(GrouperBenefitMap.get(clonedGrouper.Cloned_From__c)!=null){
                    list<AIA_Benefits__c> tempBenefitList = GrouperBenefitMap.get(clonedGrouper.Cloned_From__c);
                    system.debug('@@tempBenefitList'+tempBenefitList);
                    for(AIA_Benefits__c benefit:tempBenefitList){
                        AIA_Benefits__c clonedBenefit = new AIA_Benefits__c();
                        clonedBenefit=benefit.clone();
                        clonedBenefit.Grouper__c=clonedGrouper.id;
                        clonedBenefit.recordTypeId=benefitPPRTypeId;
                        clonedBenefit.Benefit_Record_Type__c = 'BRF';
                        clonedBenefit.Cloned_From_Benefit__c=benefit.id;
                        clonedBenefitList.add(clonedBenefit);
                        
                    }
                }
            }
        }
        system.debug('@@clonedBenefitList'+clonedBenefitList);
        if(clonedBenefitList.size()>0)
            insert clonedBenefitList;   
        
            
       //Cloning associated Benefits Limitations
        List<Limitations__c> clonedLimitList = new list<Limitations__c>();
        if(clonedBenefitList.size()>0){
            for(AIA_Benefits__c clonedBen:clonedBenefitList){
                if(BeneLimitationMap.get(clonedBen.Cloned_From_Benefit__c)!=null){
                    list<Limitations__c> tempLimitList = BeneLimitationMap.get(clonedBen.Cloned_From_Benefit__c);
                    system.debug('@@tempLimitList'+tempLimitList);
                    for(Limitations__c limi:tempLimitList){
                        Limitations__c clonedLimi = new Limitations__c();
                        clonedLimi=limi.clone();
                        clonedLimi.Benefit__c =clonedBen.id;
                        clonedLimitList.add(clonedLimi);
                        
                    }
                }
            }
        }            
        
        insert clonedLimitList;     
        //Update ARC approval status and approved dates on BRF    
          Benfit_Request_Form__c BRFrec = new Benfit_Request_Form__c();          
          List<Proposed_Products__c> AllPPsList = new List<Proposed_Products__c>();  
          Boolean ARCflag = true;  
            
          BRFrec = [select Id,Name,ARC_Approval_Status__c,ARC_Approval_Date__c from Benfit_Request_Form__c where Id =:BrfID];  
          AllPPsList = [select Id,Name,Benefit_Request_Form__c,Custom__c,ARC_Approved__c,ARC_check__c from Proposed_Products__c where Benefit_Request_Form__c =:BRFrec.Id];  
            for(Proposed_Products__c pp: AllPPsList){
                 //T01  if(pp.ARC_Approved__c == false){
                if(pp.ARC_check__c == false){
                    ARCflag = false;
                }
            }
           // throw new myException('test');
            //Database.rollback(sp);
            if(ARCflag == true){
                BRFrec.ARC_Approval_Status__c = 'Auto-Approved by System';
               // BRFrec.MHP_Test_Result__c = 'Pass';
                BRFrec.ARC_Approval_Date__c = date.today();
                
                upsert BRFrec;
            }               
        }
        catch(Exception e){
                system.debug('Exception in cloning of Records :'+e);
                Database.rollback(sp);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(myMsg);
                return null;
            }
        if(!getIsClassic())
        {
            msg = 'Product Added';
            displayPopUp = true;
            return null;
        }
        return new PageReference('/'+BrfID);
    }        
   public class MainWrapper{
        public Boolean Selected{get;set;}
        public Proposed_Products__c Product{get;set;}
        public MainWrapper(Proposed_Products__c pp){
            Selected = false;
            Product = pp;
        }
    }     
    public PageReference callsave(){        
          return cloneSelRecords(PPSelectList,BrfID);    
    }
    public PageReference BackToBRF() {        
        pageReference pg1Ref = new pageReference('/'+BrfID);
        
        pg1Ref.setRedirect(true);
        return pg1Ref;
    }
}