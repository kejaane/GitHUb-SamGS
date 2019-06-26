/*==================================================================================================================
 * Date         : 01/17/2017
 * Developer    : RamaKrishna
 * Purpose      : Extension for Custom Limitations page for user to enter data under Benefit.           
 *
 *===================================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+================+======================================================================================
 * 01/17/2017| RamaKrishna 	  | 	|		Initial Version  
 * 03/21/2017| Bill Dodson 	  | 	|		Add call to enable the creation of adjustment records when
 *                           				inserting a new Limitation.     
 * 08/21/2017| Goutham Rapolu | T03 | 		Added Selecting MaxDuration & MaxAge when additional Limitation is added
 * 02/14/2018| Debkanti		  | T04 |		Added to distinguish between classic and lightning using 
 * 											custom metadata.                                     
 *===========+============+==========================================================================================
*/
public class AIA_Cust_BDD_Limitations {
   
   // public AIA_Benefit_Design_Product__c ppc{get;set;}  
    public AIA_Grouper__c grup{get;set;}
    public AIA_Benefits__c benfitObj;
   // public AIA_Benefits__c benfitRec{get;set;}
    public Limitations__c MaxRows{get;set;}    
    public List<AIA_Benefits__c> benefitList{get;set;} 
    public List<AIA_Benefits__c> benefitList1{get;set;} 
    public string bdpid{get;set;}
    public ApexPages.StandardController ctler{get; set;} 
    public string selectedBenefit{get;set;}
    public List<selectOption> BenefitOptions{get;set;}            
    public RecordType BDDRecordTypeId;   
    public string LmtType{get;set;}
    public string diableFlag{get;Set;}  
  //  public string BenefitName{get;set;}
    public List<AIA_Benefits__c> updateBen;
    public double maxSeqNumber;
    public List<AggregateResult> agrmaxSeqNumber;  
    public List<AIA_Benefits__c> BenListDisplay{get;set;}
    public set<string> benset{get;set;}
    public string grouper{get;set;}
    public boolean isClassic {get;set;} //T04 change
    
    public AIA_Cust_BDD_Limitations(ApexPages.StandardController controller){
        ctler=controller;
        isClassic = AIA_Utils.isClassic(); //T04 change
        //ppc = (AIA_Benefit_Design_Product__c)controller.getRecord();
        bdpid= ApexPages.currentPage().getParameters().get('id'); 
        system.debug('&&&&&&&&&&&&&&&&&& bdpid:' +bdpid);  
        grouper= ApexPages.currentPage().getParameters().get('Grouper');              
             
        grup = [select id,name from AIA_Grouper__c 
                where Id =:grouper ];
             /*   and Benefit_Design_Product__c =:bdpid ];
                and name ='Additional Services'
                and RecordType.DeveloperName='BD_Product'];      */                                           
        system.debug('&&&&&&&&&&&&&&& Grouper Id:'+grup);
        
        BDDRecordTypeId = [select Id, Name, sObjectType from RecordType where sObjectType = 'AIA_Benefits__c' 
                            and developername = 'BD_Product'];              
        system.debug('&&&&&&&&&&&&& BDDRecordTypeId:'+BDDRecordTypeId);
        MaxRows = new Limitations__c();
        benfitObj = new AIA_Benefits__c();

     }
    
    public void Actions(){
        LmtType='';
        getBenefitNames();
        doDisable();
     /*   benefitList1 = new List<AIA_Benefits__c>(); 
        benefitList1 = [select Id,name from AIA_Benefits__c 
                        where Grouper__c =:grup.Id 
                        and Benefit_Type__c ='Benefit' 
                       // and recordtypeId=:BDDRecordTypeId.Id 
                        and Parent_Benefit_Name__c =:selectedBenefit limit 1];  
       system.debug('&&&&&&&&&&&&&&&&benefitlist1:'+benefitList1);
        if(benefitList1.size()==0){ 
            displayError('Benefit not exist. Please create a new Benefit or select existing benefit before adding Limitation.');            
        } */
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
               // and recordtypeId=:BDDRecordTypeId.Id 
                and Parent_Benefit_Name__c =:selectedBenefit limit 1];  
        system.debug('++++++++ benefitList1 - Benifit List:++++++'+benefitList1);  
                benefitList = new List<AIA_Benefits__c>();   
                benefitList = [select Id,name from AIA_Benefits__c 
                               where Grouper__c =:grup.Id 
                               and Type__c ='Benefit' 
                               and Benefit_Type__c ='Limitation' 
                              // and recordtypeId=:BDDRecordTypeId.Id 
                               and Benefit_Name__c =:selectedBenefit limit 1];  
        system.debug('++++++++++ limitation Benifit Record:++++++++++'+benefitList);                      
                
                agrmaxSeqNumber = new List<AggregateResult>();
                agrmaxSeqNumber = [SELECT max(Sequence_Number_SF__c)maxNum FROM AIA_Benefits__c 
                                   where Grouper__c =: grup.Id 
                                   and Benefit_Type__c='Benefit' 
                                   and Parent_Benefit_Name__c =:selectedBenefit]; 
                                 //  and RecordType.DeveloperName = 'BD_Product'];        
                system.debug('&&&&&&&&&&&&&&&&&&&&agrmaxSeqNumber'+agrmaxSeqNumber);    
                maxSeqNumber = Integer.ValueOf(agrmaxSeqNumber[0].get('maxNum'));
                system.debug('&&&&&&&&&&&&&&&&&&&&maxSeqNumber:'+maxSeqNumber);
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
                benfitObj.Benefit_Record_Type__c =  'BDD';              
                benfitObj.RecordTypeId = BDDRecordTypeId.Id;
                benfitObj.Sequence_Number__c = maxSeqNumber;
                benfitObj.Sequence_Number_SF__c = maxSeqNumber;
                benfitObj.Additional_Benefit__c = True;
                 
                insert benfitObj;
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&new benifit ID:'+benfitObj.Id);
                
                updateBen = new List<AIA_Benefits__c>();
                //updateBen = [select Id,Benefit_Name__c,Parent_Benefit_Name__c from AIA_Benefits__c where Id=:benfitObj.Id];
                updateBen = [select Id,name,Parent_Benefit_Name__c, Parent_Benefit__c, Benefit_Type__c,Sequence_Number__c,Sequence_Number_SF__c,
                                    Additional_Limitation__c 
                             from AIA_Benefits__c 
                             where Grouper__c =:grup.Id 
                             and Benefit_Type__c='Benefit' 
                             and Parent_Benefit_Name__c =:selectedBenefit]; 
                //  and RecordType.DeveloperName = 'BD_Product'];
        
                system.debug('&&&&&&&Benefits to be updated:'+updateBen);       
                
                if(updateBen.size()>0){                                        
                    for (AIA_Benefits__c Ben : updateBen){                        
                        Ben.Parent_Benefit__c = benfitObj.Id;  
                        if(Ben.Additional_Limitation__c == false){
                                Ben.Additional_Limitation__c = true;
                            }
                        }
                    }           
                update updateBen;  
            }
            else {
                    displayError('Please select benefit before adding Limitation.');
                }
            }    
        }

        //updateBen.Benefit_Name__c = updateBen.Parent_Benefit_Name__c;
        //      upsert updateBen;               
    

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
                MaxRows.Recordtype__c = 'BDD';
                MaxRows.Type__c = LmtType;
                MaxRows.IsRequired__c = true;
                MaxRows.Additional_Comment__c = True;
          //Selecting MaxDuration & MaxAge when additional Limitation is added. RG 08/21
                MaxRows.MaxDuration_Selected__c = True;
                MaxRows.MaxAge_Selected__c = True;
                AIA_BenefitCommentCodesTriggerHandler.enableAdjustmentsOnInserts(); // Bill, added 3/16/2017
                upsert MaxRows;
                
                List<AIA_Benefits__c> updateBenfits = new List<AIA_Benefits__c>([select Id,name,Parent_Benefit_Name__c, Parent_Benefit__c, Benefit_Type__c,
                                                                                 Sequence_Number__c,Sequence_Number_SF__c,Additional_Limitation__c,Benefit_Non_Standard__c
                             from AIA_Benefits__c 
                             where Grouper__c =:grup.Id 
                             and Benefit_Type__c='Benefit' 
                             and Parent_Benefit_Name__c =:selectedBenefit ]);
                            // and RecordType.DeveloperName = 'Proposed_Product']);
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
                //pageRef = new pageReference('/apex/AIA_BenefitDesign_Summary?scontrolCaching=1&id='+ppid );                
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
        pageReference pg1Ref = new pageReference('/apex/AIA_BenefitDesign_Summary?scontrolCaching=1&id='+bdpid );

        pg1Ref.setRedirect(true);
        return pg1Ref;
    }
    public PageReference BackToAddAdditionalBenefits() {
        pageReference pg1Ref = new pageReference('/apex/AIA_Additional_Benefits?bdpid='+bdpid);

        pg1Ref.setRedirect(true);
        return pg1Ref;
    }
}