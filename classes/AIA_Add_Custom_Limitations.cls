/*=========================================================================================
 * Date         : 01/17/2017
 * Developer    : RamaKrishna
 * Purpose      : Extension for Custom Limitations page for user to enter data under Benefit.           
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Tag     Description
 *===========+================+=====+===========================================================
 * 01/17/2017| RamaKrishna    |         | Initial Version   
 * 03/24/2017| Bill Dodson    |         | Add call to enable the creation of adjustment records when
 *                                        inserting a new Limitation.        
 * 08/21/2017| Goutham Rapolu | T03 | Added Selecting MaxDuration & MaxAge when additional Limitation is added
 * 01/24/2018|Rajesh Nagandla | T04 | Added SLDS to page.                                     
 *===========+============+================================================================
*/
public class AIA_Add_Custom_Limitations {
   
   // public Proposed_Products__c ppc{get;set;}   
    public AIA_Grouper__c grup{get;set;}
    public AIA_Benefits__c benfitObj;
  //  public AIA_Benefits__c benfitRec{get;set;}
    public Limitations__c MaxRows{get;set;}    
    public List<AIA_Benefits__c> benefitList{get;set;} 
    public List<AIA_Benefits__c> benefitList1{get;set;} 
    public string ppid{get;set;}
    public ApexPages.StandardController ctler{get; set;} 
    public string selectedBenefit{get;set;}
    public List<selectOption> BenefitOptions{get;set;}            
    public RecordType BRFRecordTypeId;   
    public string LmtType{get;set;}
    public string diableFlag{get;Set;}  
 //   public string BenefitName{get;set;}
    public List<AIA_Benefits__c> updateBen;
    public double maxSeqNumber;
    public List<AggregateResult> agrmaxSeqNumber;
    public date BRFEffDate;
    public List<AIA_Benefits__c> BenListDisplay{get;set;}
    public set<string> benset{get;set;}
    public string grouper{get;set;}
    /*T04 - Start*/
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    /*T04 - End*/
    public AIA_Add_Custom_Limitations(ApexPages.StandardController controller){
        ctler=controller;
       // ppc = (Proposed_Products__c)controller.getRecord();
        ppid= ApexPages.currentPage().getParameters().get('id');        
        grouper= ApexPages.currentPage().getParameters().get('Grouper');
    system.debug('+++++++++++ PPID:' +ppid);  
         
        grup = [select id,name,Proposed_Products__r.Benefit_Request_Form__r.Benefit_Effective_Date__c 
                from AIA_Grouper__c 
        where Id =:grouper];
         /*       and Proposed_Products__c =:ppid
        and name ='Additional Services' 
        and RecordType.DeveloperName='Proposed_Proposed'];  */
        
        BRFEffDate = grup.Proposed_Products__r.Benefit_Request_Form__r.Benefit_Effective_Date__c;
        
        BRFRecordTypeId = [select Id, Name, sObjectType 
                         from RecordType 
                 where sObjectType = 'AIA_Benefits__c' 
                 and developername = 'Proposed_Product'];              
        MaxRows = new Limitations__c();
        benfitObj = new AIA_Benefits__c();              
     }
    
    public void Actions(){
        LmtType='';        
        getBenefitNames();
        doDisable(); 
    }    
         
    public void doDisable() {
        if (LmtType == 'MaxRow') 
            { diableFlag = 'MaxRow'; } 
        else if(LmtType == 'Comment') 
                { diableFlag = 'Comment'; }  
            else diableFlag = '';
    }
    
    public list<selectOption> getLimitationType(){
        list<selectOption> options = new list<selectOption>();
        
        options.add(new SelectOption('--Select--','--Select--'));
        options.add(new SelectOption('MaxRow','MaxRow'));
        options.add(new SelectOption('Comment','Comment'));
        /*list<Schema.PicklistEntry> values = Limitations__c.Type__c.getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values)
        { 
         options.add(new SelectOption(a.getLabel(), a.getValue())); 
        } */        
        return options;
    } 
    
 /*   public void BenefitNames(){
        BenefitOptions = new List<selectOption>();        
            for(AIA_Benefits__c ben: benefitList){
                BenefitOptions.add(new selectOption(ben.Full_Benefit_Name__c,ben.Full_Benefit_Name__c));        
        }  
    } */
    
        //*******get the parent benefit names which are currently available under for a grouper.
    public list<selectOption> getBenefitNames(){
                        
                BenListDisplay = new List<AIA_Benefits__c>([select Id,Parent_Benefit_Name__c,Benefit_Name__c
                                                            from AIA_Benefits__c 
                                                            where Grouper__c =:grup.Id]);
                                                            //  and Benefit_Type__c = 'Benefit'
                                                            // and RecordType.DeveloperName = 'Proposed_Product']);                                
                BenefitOptions = new List<selectOption>();
                benset = new set<string>();
                
                BenefitOptions.add(new selectOption('--Select--','--Select--'));
        
                for(AIA_Benefits__c b:BenListDisplay){          
                    benset.add(b.Parent_Benefit_Name__c);              
                }
                for(string ben: Benset){          
                    BenefitOptions.add(new selectOption(ben,ben));           
                }
                return BenefitOptions;        
    }         
    
    public void CreateBenefit(){
    benefitList1 = new List<AIA_Benefits__c>(); 
    benefitList1 = [select Id,name from AIA_Benefits__c 
        where Grouper__c =:grup.Id 
        and Benefit_Type__c ='Benefit' 
        and recordtypeId=:BRFRecordTypeId.Id 
        and Parent_Benefit_Name__c =:selectedBenefit limit 1];  
    
    system.debug('++++++++ benefitList1 - Benifit List:++++++'+benefitList1);
    benefitList = new List<AIA_Benefits__c>(); 
        benefitList = [select Id,name from AIA_Benefits__c 
                       where Grouper__c =:grup.Id 
                       and Type__c ='Benefit' 
                       and Benefit_Type__c ='Limitation'  
                       and recordtypeId=:BRFRecordTypeId.Id 
                       and Benefit_Name__c =:selectedBenefit limit 1];  
        system.debug('++++++++ limitation Benifit Record:'+benefitList);          
            
             
        agrmaxSeqNumber = new List<AggregateResult>();
        agrmaxSeqNumber = [SELECT max(Sequence_Number_SF__c)maxNum FROM AIA_Benefits__c 
                           where Grouper__c =: grup.Id 
                           and Benefit_Type__c='Benefit' 
                           and Parent_Benefit_Name__c =:selectedBenefit 
                           and RecordType.DeveloperName = 'Proposed_Product'];        
        system.debug('++++++++ agrmaxSeqNumber'+agrmaxSeqNumber);    
        
        maxSeqNumber = Integer.ValueOf(agrmaxSeqNumber[0].get('maxNum'));
        system.debug('++++++++ maxSeqNumber:'+maxSeqNumber);
        
        if(maxSeqNumber == null){
            maxSeqNumber = 0;
        }                
        maxSeqNumber = maxSeqNumber+0.5;
                
        if(benefitList.size() ==0 ){
            if(benefitList1.size()>0){                            
                benfitObj.Grouper__c = grup.Id;                                
                benfitObj.Benefit_Name__c = selectedBenefit; 
                benfitObj.Type__c ='Benefit';
                benfitObj.Benefit_Type__c = 'Limitation';                               
                benfitObj.Benefit_Record_Type__c =  'BRF';
                benfitObj.RecordTypeId = BRFRecordTypeId.Id;
                benfitObj.Sequence_Number__c = maxSeqNumber;
                benfitObj.Sequence_Number_SF__c = maxSeqNumber;
                benfitObj.Additional_Benefit__c = True;
                
                insert benfitObj;
                system.debug('++++++++ newly created Limitation - benifit ID:'+benfitObj.Id);
            
                updateBen = new List<AIA_Benefits__c>();
                updateBen = [select Id,name,Parent_Benefit_Name__c, Parent_Benefit__c, Benefit_Type__c,Sequence_Number__c,Sequence_Number_SF__c,
                                    Benefit_Custom__c,Benefit_Non_Standard__c,Additional_Limitation__c
                             from AIA_Benefits__c 
                             where Grouper__c =:grup.Id 
                             and Benefit_Type__c='Benefit' 
                             and Parent_Benefit_Name__c =:selectedBenefit 
                             and RecordType.DeveloperName = 'Proposed_Product'];
                system.debug('++++++++ Benefits to be updated:'+updateBen);           
                
                if(updateBen.size()>0){                                        
                    for (AIA_Benefits__c Ben : updateBen){                        
                        Ben.Parent_Benefit__c = benfitObj.Id;      
                        if(Ben.Additional_Limitation__c == false){
                                Ben.Additional_Limitation__c = true;
                            }                        
                        }
                }           
                upsert updateBen;
                system.debug('++++++++ Benefits after updated:'+updateBen); 
            }
                else {
                    displayError('Please select benefit before adding Limitation.');
                }   
        }
    }

    private void displayError(string errorMsg){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.error, errorMsg);
        ApexPages.AddMessage(myMsg); 
    } 
    
    public PageReference save(){        
        System.debug('Inside save method');
        PageReference pageRef=null;                
        try{      
                maxSeqNumber =0;
                CreateBenefit();
                
                if(benefitList.size() ==0){
                    MaxRows.Benefit__c =  benfitObj.Id; 
                }
                else {
                    MaxRows.Benefit__c =  benefitList[0].Id;    
                }                
                MaxRows.Recordtype__c = benfitObj.Benefit_Record_Type__c;
                MaxRows.Type__c = LmtType;
                MaxRows.IsRequired__c = True;
                MaxRows.Effective_Date__c = BRFEffDate;
                MaxRows.Term_Date__c = BRFEffDate;
                MaxRows.Additional_Comment__c = True;
           //Selecting MaxDuration & MaxAge when additional Limitation is added. RG 08/21    T03
                MaxRows.MaxDuration_Selected__c = True;
                MaxRows.MaxAge_Selected__c = True;
                MaxRows.Recordtype__c = 'BRF';
                AIA_BenefitCommentCodesTriggerHandler.enableAdjustmentsOnInserts(); // Bill, added 3/24/2017                
                upsert MaxRows;
            
                 
                List<AIA_Benefits__c> updateBenfits = new List<AIA_Benefits__c>([select Id,name,Parent_Benefit_Name__c, Parent_Benefit__c, Benefit_Type__c,
                                                                                 Sequence_Number__c,Sequence_Number_SF__c,Additional_Limitation__c,Benefit_Non_Standard__c
                             from AIA_Benefits__c 
                             where Grouper__c =:grup.Id 
                             and Benefit_Type__c='Benefit' 
                             and Parent_Benefit_Name__c =:selectedBenefit 
                             and RecordType.DeveloperName = 'Proposed_Product']);
                system.debug('++++++++ Benefits to be updated:'+updateBenfits);           
                
                if(updateBenfits.size()>0){                                        
                    for (AIA_Benefits__c Ben : updateBenfits){                                                      
                        if(Ben.Additional_Limitation__c == false){
                                Ben.Additional_Limitation__c = true;
                            } 
                        }
                }           
                upsert updateBenfits;  
            
                pageRef = apexpages.Currentpage();
                //pageRef = new pageReference('/apex/AIA_Custom_Limitations?scontrolCaching=1&id='+ppid );                
                pageRef.setRedirect(true); 
        }
        catch(DMLException dmlex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,dmlex.getDmlMessage(0));
            ApexPages.addMessage(myMsg);
            return null;
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }               
        return pageRef;         
    }
    public PageReference Cancel() {
        pageReference pg1Ref = new pageReference('/apex/AIA_ProposedProd_Summary?scontrolCaching=1&id='+ppid );

        pg1Ref.setRedirect(true);
        return pg1Ref;
    }
    public PageReference BackToAddAdditionalBenefits() {
        pageReference pg1Ref = new pageReference('/apex/AIA_Additional_Benefits?pid='+ppid);

        pg1Ref.setRedirect(true);
        return pg1Ref;
    }
}