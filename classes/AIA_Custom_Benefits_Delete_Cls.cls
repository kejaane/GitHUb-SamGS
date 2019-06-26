/*=========================================================================================
 * Date         : 01/28/2017
 * Developer    : RamaKrishna
 * Purpose      : This class is to delete custom benefits and limitations for PP.
 *                                -When user click on 'Get Benefits' button on Proposed product then the custom page "AIA_Custom_Benefits_Delete" will invoke this controller.
 *                                -Custom page will diplay the existing benefits and limitations(comment codes) which are associated with PP.
 *                                -User can select any benefit/ limiation and click on delete button on the custom page
 *                                -This controller will take care of deleting the selected records.     
 *                                -comments have been provided bellow for each method with the purpose.         
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer        Version            Description
 *===========+================+========+=================================================================
 * 01/28/2017| RamaKrishna    |        | Initial Version  
 * 01/24/2018|Rajesh Nagandla | T01    | Added SLDS classes to all components/tags. 
 * 02/15/2018| Debkanti       | T04    | Added to distinguish between classic and lightning using 
 *                                       custom metadata.                                          
 *===========+============+================================================================
*/
public class AIA_Custom_Benefits_Delete_Cls {
    
    public string ppid{get;set;}
    public string BDPid{get;set;}
    public string VFpageName{get;set;}
    public string selectedBenefit{get;set;}
    public List<AIA_Benefits__c> BenList{get;set;}
    public List<AIA_Benefits__c> BenListDisplay{get;set;}
    public List<AIA_Benefits__c> LmtList{get;set;}
   // public List<AIA_Grouper__c> grupList;
        public map<Id,AIA_Benefits__c> Benmap;
    public List<selectOption> BenefitOptions{get;set;}
    set<string> benset{get;set;}
    public List<MainWrapper> LimiationWrap{get;set;}
    public List<MainWrapper> BenefitWrap{get;set;}   
    public string LmtName{get;set;} 
    public List<MainWrapperLmt> CommentCodeWrap{get;set;} 
    public List<Limitations__c> CommentCodeList{get;set;}
    public string isBenSelected{get;set;} 
    public string grouper{get;set;}
    public AIA_Grouper__c GrouperObj{get;set;}
    /*T04 - Start*/
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    /*T04 - End*/
    //*******contructor of the class
    public AIA_Custom_Benefits_Delete_Cls(){     
       
                        VFpageName =  ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
                        system.debug('@@@@@@@ current VFpageName : '+VFpageName);
        
                if(VFpageName == 'AIA_Custom_Benefits_Delete'){                                    
                        ppid = ApexPages.currentPage().getParameters().get('pid');
                        grouper= ApexPages.currentPage().getParameters().get('Grouper');
                        GrouperObj =  [select name from AIA_Grouper__c where Id =:grouper limit 1];
                    /*    grupList = new List<AIA_Grouper__c>([select Id, name 
                                                             from AIA_Grouper__c 
                                                             where Proposed_Products__c =:ppid
                                                             and name = 'Additional Services' limit 1]);  */
                }else 
                    if(VFpageName == 'AIA_Custom_Benefits_Delete_BDD'){
                        BDPid = ApexPages.currentPage().getParameters().get('pid');
                        grouper= ApexPages.currentPage().getParameters().get('Grouper');
                        GrouperObj =  [select name from AIA_Grouper__c where Id =:grouper limit 1];
                        /*      grupList = new List<AIA_Grouper__c>([select Id, name 
                                                     from AIA_Grouper__c 
                                                     where Benefit_Design_Product__c =:BDPid
                                                     and name = 'Additional Services' limit 1]);  */
                    }
                isBenSelected = '--None--';
                        list<selectOption> BenDropdownList = getBenefitNames();
                        if(BenDropdownList.size()<2){
                    Apexpages.Message validationMsg; 
                    validationMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'There are no custom limitations/Benefits to delete');
                    Apexpages.addmessage(validationMsg);                    
                }

    }
        //*******get the parent benefit names which are currently available under additional serivices grouper.
    public list<selectOption> getBenefitNames(){
        
                if(VFpageName == 'AIA_Custom_Benefits_Delete'){
                        BenListDisplay = new List<AIA_Benefits__c>([select Id,Parent_Benefit_Name__c,Benefit_Name__c
                                                            from AIA_Benefits__c 
                                                            where Grouper__c =:grouper //grupList[0].Id
                                                           // and Additional_Benefit__c = True        
                                                            //  and Benefit_Type__c = 'Benefit'
                                                            and (Additional_Benefit__c = true or Additional_Limitation__c = true)
                                                            and RecordType.DeveloperName = 'Proposed_Product']);
                }else 
                        if(VFpageName == 'AIA_Custom_Benefits_Delete_BDD'){
                                BenListDisplay = new List<AIA_Benefits__c>([select Id,Parent_Benefit_Name__c,Benefit_Name__c
                                                            from AIA_Benefits__c 
                                                            where Grouper__c =:grouper //grupList[0].Id 
                                                                                                                        and (Additional_Benefit__c = true or Additional_Limitation__c = true )                                                                       
                                                           // and Additional_Benefit__c = True
                                                                       ]);
                }
                                                             
                BenefitOptions = new List<selectOption>();
                benset = new set<string>();
                
                BenefitOptions.add(new selectOption('--None--','--None--'));
                
                for(AIA_Benefits__c b:BenListDisplay){          
                    benset.add(b.Parent_Benefit_Name__c);              
                }
                for(string ben: Benset){          
                    BenefitOptions.add(new selectOption(ben,ben));           
                }
                return BenefitOptions;                
    }
    //******* capture the selected benefits/comment codes into wrappers
    public void SelectedBenfits(){    
                isBenSelected = selectedBenefit;
                // Fetch Benefit records, and put them in wrapper, based on the Benefit name selected on UI.
                if(VFpageName == 'AIA_Custom_Benefits_Delete'){
                        BenList = new List<AIA_Benefits__c>([select Id,Parent_Benefit_Name__c,Benefit_Name__c
                                                             from AIA_Benefits__c 
                                                             where Grouper__c =:grouper //grupList[0].Id
                                                             and Benefit_Type__c = 'Benefit' and Parent_Benefit_Name__c =:selectedBenefit
                                                             and Additional_Benefit__c = True
                                                             and RecordType.DeveloperName = 'Proposed_Product']);
                }else 
                    if(VFpageName == 'AIA_Custom_Benefits_Delete_BDD'){
                        BenList = new List<AIA_Benefits__c>([select Id,Parent_Benefit_Name__c,Benefit_Name__c
                                                     from AIA_Benefits__c 
                                                     where Grouper__c =:grouper //grupList[0].Id
                                                     and Additional_Benefit__c = True
                                                     and Benefit_Type__c = 'Benefit' and Parent_Benefit_Name__c =:selectedBenefit ]);
                                                    // and RecordType.DeveloperName = 'Proposed_Product']);
                    }
                    
                system.debug('&&&&&&&& BenList'+BenList);
                
                BenefitWrap = new List<MainWrapper>();
                if(BenList != null && BenList.size()>0){                                    
                        for(AIA_Benefits__c b :BenList){                        
                            BenefitWrap.add(new MainWrapper(b));                         
                        }                                                                        
                }
                
                //Fetch Limitation benefit record (benefit of type 'limitaion') based on the benefit name selected on UI.
                if(VFpageName == 'AIA_Custom_Benefits_Delete'){
                        LmtList = new List<AIA_Benefits__c>([select Id,Parent_Benefit_Name__c,Benefit_Name__c, SF_PARENT_NAME__c
                                                             from AIA_Benefits__c 
                                                             where Grouper__c =:grouper  //grupList[0].Id                                                 
                                                             and Benefit_Type__c = 'Limitation' and Parent_Benefit_Name__c =:selectedBenefit                                                             
                                                             and RecordType.DeveloperName = 'Proposed_Product' limit 1]);
                } else 
                    if(VFpageName == 'AIA_Custom_Benefits_Delete_BDD'){
                        LmtList = new List<AIA_Benefits__c>([select Id,Parent_Benefit_Name__c,Benefit_Name__c, SF_PARENT_NAME__c
                                                     from AIA_Benefits__c 
                                                     where Grouper__c =:grouper //grupList[0].Id                                                    
                                                     and Benefit_Type__c = 'Limitation' and Parent_Benefit_Name__c =:selectedBenefit ]);
                                                    // and RecordType.DeveloperName = 'Proposed_Product' limit 1]);
                    }
                system.debug('&&&&&&&& LmtList'+LmtList);
                string LmtId = '';
                if(LmtList!=null && LmtList.size()>0){
                    LmtName = LmtList[0].SF_PARENT_NAME__c;   
                    LmtId = LmtList[0].Id;
                }
                else LmtName = '<--- Limitaions Not Available --->';   
                
                //Fetch Comment codes, and put them in a wrapper, for the limitation benefit retrived above.
                if(LmtId!=null){
                        CommentCodeList = new List<Limitations__c>([select Id,MaxValue__c,MaxType__c,MaxApply__c,Maximum_Apply_Rate__c,MaxDuration__c,
                                                                    MaxDurationType__c,MaxAgeFrom__c,MaxAgeTo__c,MaxAgeType__c,comment_codes__c 
                                                                    from Limitations__c
                                                                    where Benefit__c =:LmtId and Additional_Comment__c = True
                                                                   ]);   
                        
                        CommentCodeWrap = new List<MainWrapperLmt>();
                        if(CommentCodeList != null && CommentCodeList.size()>0){                                    
                                for(Limitations__c Lmt :CommentCodeList){                        
                                    CommentCodeWrap.add(new MainWrapperLmt(Lmt));                         
                                }                                                                        
                        }
                }                                               
    }
    //*******While deleting the benefits this method will validate whether all the requried benefits have been selected or not for the deletion.
    public PageReference DeleteSelectedBenefits(List<MainWrapper> BenefitWrap){                
                        List<AIA_Benefits__c> selectedBenListForDel = new List<AIA_Benefits__c>();
                
                        boolean isBenSelected = false;
                if(BenefitWrap != null && BenefitWrap.size()>0){
                    for(MainWrapper mw: BenefitWrap){
                        if(mw.Selected == true){
                            selectedBenListForDel.add(mw.benefit);                    
                        }                                               
                    }                                    
                }
                        delete selectedBenListForDel;
                return null;
     } 
    //*******Deletetion method for CommentCodes.
    public void DeleteSelectedCommentCodes(List<MainWrapperLmt> CommentCodeWrap){
                List<Limitations__c> SelectedCClist = new List<Limitations__c>();
                    if(CommentCodeWrap != null && CommentCodeWrap.size()>0){
                        for(MainWrapperLmt mw: CommentCodeWrap){
                            if(mw.Selected == true){                            
                                SelectedCClist.add(mw.CommentCode);                        
                            }
                        }                    
                    }
                Delete SelectedCClist; 
     }
    //*******This method will invoke the delete benefits method and clean up dependencies.
    public void DeleteBenfits(){
                        List<AIA_Benefits__c> BenLmtNoCCList = new List<AIA_Benefits__c>();
                        List<AIA_Benefits__c> RemainingBenList = new  List<AIA_Benefits__c>();
        
                if(BenefitWrap!=null && BenefitWrap.size()>0){
                    DeleteSelectedBenefits(BenefitWrap);                                                      
                }
                SelectedBenfits();
        
                        if(VFpageName == 'AIA_Custom_Benefits_Delete'){
                        RemainingBenList = new List<AIA_Benefits__c>([select Id,Parent_Benefit_Name__c,Benefit_Name__c
                                                             from AIA_Benefits__c 
                                                             where Grouper__c =:grouper //grupList[0].Id
                                                             and Benefit_Type__c = 'Benefit' and Parent_Benefit_Name__c =:selectedBenefit
                                                             //and Additional_Benefit__c = True
                                                             and RecordType.DeveloperName = 'Proposed_Product']);
                }else 
                    if(VFpageName == 'AIA_Custom_Benefits_Delete_BDD'){
                        RemainingBenList = new List<AIA_Benefits__c>([select Id,Parent_Benefit_Name__c,Benefit_Name__c
                                                     from AIA_Benefits__c 
                                                     where Grouper__c =:grouper //grupList[0].Id
                                                     //and Additional_Benefit__c = True
                                                     and Benefit_Type__c = 'Benefit' and Parent_Benefit_Name__c =:selectedBenefit ]);
                                                    // and RecordType.DeveloperName = 'Proposed_Product']);
                    }        
                        
                if(RemainingBenList.size()==0 && LmtList.size()>0){
                    delete LmtList;
                }
                List<Limitations__c> ccDelList = new List<Limitations__c>([select Id
                                                                           from Limitations__c
                                                                           where Benefit__c ='']);  
                
                delete ccDelList; 
                if(VFpageName == 'AIA_Custom_Benefits_Delete'){
                        BenLmtNoCCList = [select Id from AIA_Benefits__c
                                                  where Grouper__c =:grouper  //grupList[0].Id                                                 
                                                  and Benefit_Type__c = 'Limitation'
                                                  and Count_of_CommentCode_Rec__c = 0
                                                  and RecordType.DeveloperName = 'Proposed_Product'];
                } else 
                    if(VFpageName == 'AIA_Custom_Benefits_Delete_BDD'){
                        BenLmtNoCCList = [select Id from AIA_Benefits__c
                                                  where Grouper__c =:grouper //grupList[0].Id                                                 
                                                  and Benefit_Type__c = 'Limitation'
                                                  and Count_of_CommentCode_Rec__c = 0 ];
                                                                //and RecordType.DeveloperName = 'Proposed_Product']);
                    }
                Delete BenLmtNoCCList;  
                
                SelectedBenfits();       
    }
    //*******This method will invoke the delete ComentCodes method and clean up dependencies.
    public void DeleteLimitations(){
        
                        List<AIA_Benefits__c> BenLmtNoCCList = new List<AIA_Benefits__c>();
                if(CommentCodeWrap!=null && CommentCodeWrap.size()>0){
                    DeleteSelectedCommentCodes(CommentCodeWrap); 
                    if(VFpageName == 'AIA_Custom_Benefits_Delete'){                                            
                            BenLmtNoCCList = [select Id from AIA_Benefits__c
                                                          where Grouper__c =:grouper  //grupList[0].Id                                                 
                                                          and Benefit_Type__c = 'Limitation'
                                                          and Count_of_CommentCode_Rec__c = 0                                                                           
                                                          and RecordType.DeveloperName = 'Proposed_Product'];
                    } else  
                        if(VFpageName == 'AIA_Custom_Benefits_Delete_BDD'){
                                BenLmtNoCCList = [select Id from AIA_Benefits__c
                                                          where Grouper__c =:grouper  //grupList[0].Id                                                 
                                                          and Benefit_Type__c = 'Limitation'                                                                            
                                                          and Count_of_CommentCode_Rec__c = 0 ];
                                        // and RecordType.DeveloperName = 'Proposed_Product']); 
                    }
                    Delete BenLmtNoCCList;                              
                    //SelectedBenfits();
                }
        
                        //Below section is added to uncheck the Additional_Limitation__c flag on benifits when all custom commentcodeds have been deleted.
                        //SelectedBenfits();   
                        if(LmtList.size()>0){                                        
                        List<Limitations__c> LatestCommentCodeList = new List<Limitations__c>([select Id,MaxValue__c,MaxType__c,MaxApply__c,Maximum_Apply_Rate__c,MaxDuration__c,
                                                                            MaxDurationType__c,MaxAgeFrom__c,MaxAgeTo__c,MaxAgeType__c,comment_codes__c 
                                                                            from Limitations__c
                                                                            where Benefit__c =:LmtList[0].Id and Additional_Comment__c = True
                                                                           ]);  
                
                        if(LatestCommentCodeList.isEmpty()){
                                List<AIA_Benefits__c> updateBenfits = new List<AIA_Benefits__c>([select Id,name,Parent_Benefit_Name__c, Parent_Benefit__c, Benefit_Type__c,
                                                                                             Sequence_Number__c,Sequence_Number_SF__c,Additional_Limitation__c,Benefit_Non_Standard__c
                                         from AIA_Benefits__c 
                                         where Grouper__c =:grouper 
                                         and Benefit_Type__c='Benefit' 
                                         and Parent_Benefit_Name__c =:selectedBenefit]); 
                                         //and RecordType.DeveloperName = 'Proposed_Product']);
                                system.debug('++++++++ Benefits to be updated:'+updateBenfits);           
                            
                                if(updateBenfits.size()>0){                                        
                                    for (AIA_Benefits__c Ben : updateBenfits){                                                      
                                        if(Ben.Additional_Limitation__c == true){
                                                Ben.Additional_Limitation__c = false;
                                            } 
                                        }
                                }           
                                upsert updateBenfits;
                        }  
                }
    }
    
    public void CommonDeleteMethod(){
                DeleteLimitations();
                DeleteBenfits();
    }
    
        public PageReference Cancel() {
                        pageReference pg1Ref =null;
        
                if(VFpageName == 'AIA_Custom_Benefits_Delete'){
                        pg1Ref = new pageReference('/apex/AIA_ProposedProd_Summary?id='+ppid );    
                }else 
                    if(VFpageName == 'AIA_Custom_Benefits_Delete_BDD'){
                        pg1Ref = new pageReference('/apex/AIA_BenefitDesign_Summary?id='+BDPid );  
                    } 
                pg1Ref.setRedirect(true);
                return pg1Ref;
    }
        public class MainWrapper{
                public Boolean Selected{get;set;}
                public AIA_Benefits__c benefit{get;set;}
                public MainWrapper(AIA_Benefits__c ben){
                    Selected = false;
                    benefit = ben;
                }
    }  
        public class MainWrapperLmt{
                public Boolean Selected{get;set;}
                public Limitations__c CommentCode{get;set;}
                public MainWrapperLmt(Limitations__c Lmt){
                    Selected = false;
                    CommentCode = Lmt;
                }
    } 
}