/*************************************************************************************************************************************************
*  Class            : AIA_Additional_BenefitsController
*  Author           : Satya Tirumalasetti
*  Description      : Visualforce controller for the visualforce page AIA_Additional_Benefits. Controller is used validate and 
                      benefits added on the visualforce page. The page controller creates benefits based on a predefined set of variation conditions.
*  Modification Log:
* ----------------------------------------------------------------------------------------------------------------------------------------------
*  Author          Date-Modified  Tag      Description of Change
* ----------------------------------------------------------------------------------------------------------------------------------------------
* Satya T          02/01/2017              Initial version
* Asif Kutagulla   03/05/2017     T01      Validate if both In-Network & Out-of-Network Covered are N/A if either one is N/A and validate if both 
*                                          In-Network & Out-of-Network Deductible are None if either one is None. B-03639 
* Satya            03/12/2017     TO2      If else condition to validate and avoid creating duplicate benefits
* Bill Dodson      03/15/2017     T03      Add logic to create Adjustment Summary records for added benefits.
* Ramakrishna      03/30/2017     T04      Re-designed the funcationality to add custom benefits. (The whole class has been re-designed as part of requirement chagne)  
* Ramakrishna      04/02/2017     T05      Included the BDP-benefit creation logic in this class and removed the below old class and page.
                                           - AIA_BD_Additional_BenefitsController, AIA_BD_Additional_Benefits.vsp  
                                           - A single page and controller will be used for adding custom benefits for BRF/ BDD.
* Debkanti        25/01/2018      T06      Changed the logic to redirect in lightning and classic
* Rajesh Pennam   02/28/2018      T07      Removed <Strong></Strong> in Apex Messages
*************************************************************************************************************************************************/
public class AIA_Additional_BenefitsController {
    //public String BenefitName { get; set; }   
    public List<AIA_Benefits__c> benfitList{ get; set; }
    public String propProdId { get; set; }
    public String bdProdId { get; set; }
    public double maxSeqNumber;
    public List<AIA_Grouper__c> grouperAdditionalServces;
    public Set<ID> grprIdSet;
    public boolean isValidationError = False;//T01
    public AIA_Benefits__c bnft{get;set;}
    public AIA_Benefits__c Newbnft{get;set;} 
    public list<BenWrapper> lstWrapper {get;set;}
    public string ProdID{get;set;}
   // public string grouper{get;set;} 
    public AIA_Additional_BenefitsController (){
         /* T06 Start */
             If(ApexPages.currentPage().getUrl().Contains('?bdpid='))
            {
                ProdID = 'bdpid';
                system.debug('+++ current Product Name++++ : '+ProdID);
            }
        else{
            ProdID = 'pid';
                system.debug('+++ current Product Name++++-- : '+ProdID);
        }
         /* T06 End */
            system.debug('+++ current Product Name : '+ProdID);
        system.debug('+++ current Product Name1 : '+ApexPages.currentPage().getUrl());
       //   grouper= ApexPages.currentPage().getParameters().get('Grouper');
            
            if(ProdID == 'pid'){       
                    benfitList = new List<AIA_Benefits__c>();
                    propProdId = ApexPages.currentPage().getParameters().get('pid');
                    system.debug(' +++ PP ID: '+ propProdId);
                    
                    if(propProdId != null){
                            grouperAdditionalServces = [SELECT Id, Name 
                                                        FROM AIA_Grouper__c //where Id=:grouper];
                                                        WHERE Proposed_Products__c =: propProdId AND 
                                                              Group_Type__c = 'Benefit Group' AND 
                                                              Grouper_Record_Type__c='BRF' AND 
                                                              Grouper_RecordtypeName__c='Proposed_Proposed' AND 
                                                              Name = 'Additional Services'];                   
                            grprIdSet = new Set<ID>();
                            for(AIA_Grouper__c grpr : grouperAdditionalServces){
                                grprIdSet.add(grpr.Id);                        
                            }
                    }
            }else if(ProdID == 'bdpid'){
                    benfitList = new List<AIA_Benefits__c>();
                    bdProdId = ApexPages.currentPage().getParameters().get('bdpid');
                    system.debug(' +++ bdp ID: '+ bdProdId);
                    
                    if(bdProdId != null){
                            grouperAdditionalServces = [SELECT Id, Name 
                                                        FROM AIA_Grouper__c //where Id=:grouper];
                                                        WHERE Benefit_Design_Product__c =: bdProdId AND 
                                                              Group_Type__c = 'Benefit Group' AND 
                                                            //  Grouper_Record_Type__c='BDD' AND 
                                                             // Grouper_RecordtypeName__c='Proposed_Proposed' AND 
                                                              Name = 'Additional Services'];                   
                            grprIdSet = new Set<ID>();
                            for(AIA_Grouper__c grpr : grouperAdditionalServces){
                                grprIdSet.add(grpr.Id);                        
                            }
                    }                        
            }
            
            bnft = new AIA_Benefits__c();
            Newbnft = new AIA_Benefits__c();
            
            this.lstWrapper = new list<BenWrapper>();         
            BenWrapper oWrapp = new BenWrapper(bnft);
            oWrapp.selected=true;
            oWrapp.benefit.Copay_Type_1_IsCovered__c = 'N/A';
            oWrapp.benefit.OON_Copay_Type_1_IsCovered__c = 'N/A';
            lstWrapper.add(oWrapp);  
    }
    
     /* T06 Start */
        //added to check clasic or lightning
        public Boolean getIsClassic() {
        return (UserInfo.getUiThemeDisplayed() == 'Theme3');
            }
     /* T06 End */
    
    //Method to create benefits table so that user can input the values into the fields.
    public PageReference addAdditionalBenefits() {
            pageReference pg1Ref =null;  
            isValidationError = False;//T01          
            maxSeqNumber=0;
            
            List<AggregateResult> agrmaxSeqNumber = [SELECT max(Sequence_Number_SF__c)maxNum FROM AIA_Benefits__c where Grouper__c in: grprIdSet 
                                                     and Benefit_Type__c = 'Benefit'];
            maxSeqNumber = Integer.ValueOf(agrmaxSeqNumber[0].get('maxNum'));
            if(maxSeqNumber < 49)
            maxSeqNumber = maxSeqNumber+49;
            if(maxSeqNumber == null)
               maxSeqNumber = 0;
               maxSeqNumber = maxSeqNumber+1; 
        
            AIA_BenefitTriggerHandler.enableAdjustmentsOnInserts();
            if(propProdId != null || bdProdId != null){        
                if(grouperAdditionalServces != null && grouperAdditionalServces.size() >0){                                        
                        for( BenWrapper mw :lstWrapper ){                                  
                                mw.benefit.Grouper__c               = grouperAdditionalServces[0].id;
                                mw.benefit.Benefit_Type__c          ='Benefit';
                                mw.benefit.Additional_Benefit__c    = True;
                                if(ProdID == 'pid'){
                                        mw.benefit.Benefit_Record_Type__c   ='BRF';    
                                }
                                if(ProdID == 'bdpid'){
                                        mw.benefit.Benefit_Record_Type__c   ='BDD';    
                                }                                                           
                                mw.benefit.Benefit_Name__c          = mw.benefit.Dummy_Parent_Benefit_Name__c +' - '+ mw.benefit.Place_of_Service__c ; 
                                mw.benefit.Sequence_Number__c       = maxSeqNumber;
                                mw.benefit.Sequence_Number_SF__c    = maxSeqNumber;
                            
                                if(mw.benefit.Place_of_Service__c == 'In-Patient'){
                                    mw.benefit.Copay_Type_1_AliasName__c = 'Per admission copay';
                                    mw.benefit.OON_Copay_Type_1_AliasName__c = 'Per admission copay';
                                }
                                else if(mw.benefit.Place_of_Service__c == 'Out-Patient'){
                                    mw.benefit.Copay_Type_1_AliasName__c = 'PCP'; 
                                    mw.benefit.Copay_Type_2_AliasName__c = 'Specialist Copay';
                                    mw.benefit.OON_Copay_Type_1_AliasName__c = 'PCP';                     
                                    mw.benefit.OON_Copay_Type_2_AliasName__c = 'Specialist Copay';
                                }
                                else if(mw.benefit.Place_of_Service__c == 'General'){
                                    mw.benefit.Copay_Type_1_AliasName__c = 'General Copay';
                                    mw.benefit.OON_Copay_Type_1_AliasName__c = 'General Copay';
                                }
                                                                                            
                                if(mw.benefit.Dummy_Parent_Benefit_Name__c !=null ){
                                        benfitList.add(mw.benefit);
                                        system.debug(' ++++ Benefit List before Insert:' + benfitList);
                                }                                                               
                                system.debug('all rec in wrapper:'+lstWrapper);    
                                maxSeqNumber++;
                        }
                        validateNA_NoneValues(benfitList);
                        if(!isValidationError){ 
                            upsert benfitList;                                                                                 
                          //  lstWrapper.clear();
                        } else benfitList.clear();
                } 
            }  
            if(!isValidationError ){
                pg1Ref = redirectToPropProduct(); 
            } 
            else{
                pg1Ref = null;
            }
           return pg1Ref;
    }
      
    
 /*   public PageReference callCancel() {
            pageReference pg1Ref =null;        
            if(ProdID == 'pid'){
                    pg1Ref = new pageReference('/apex/AIA_ProposedProd_Summary?scontrolCaching=1&id='+propProdId );
            }else
            if(ProdID == 'bdpid'){
                    pg1Ref = new pageReference('/apex/AIA_BenefitDesign_Summary?scontrolCaching=1&id='+bdProdId );
            }
            pg1Ref.setRedirect(true);
            return pg1Ref;
    }  */
    
    // ***********To redirect to the limitations page*****************
 /*   public PageReference redirectToLimitation() {
            //pageReference pg1Ref = new pageReference('/apex/AIA_Custom_Limitations?scontrolCaching=1&id='+propProdId+'&BenefitName='+BenefitName );
            pageReference pg1Ref =null;        
            if(ProdID == 'pid'){
                    pg1Ref = new pageReference('/apex/AIA_Custom_Limitations?scontrolCaching=1&id='+propProdId+'&Grouper='+grouperAdditionalServces[0].Id);
            }else           
            if(ProdID == 'bdpid'){
                    pg1Ref = new pageReference('/apex/AIA_Cust_BDD_Limit?scontrolCaching=1&id='+bdProdId+'&Grouper='+grouperAdditionalServces[0].Id);
            }
            pg1Ref.setRedirect(true);
            return pg1Ref;
    }  */
    
    //*****************To redirect back to the Benefits summary page*****************
    public PageReference redirectToPropProduct() {
           pageReference pg1Ref =null;        
            if(ProdID == 'pid'){
                system.debug('Hello Error: '+ProdID);
                system.debug('Hello Error1: '+propProdId);
                    pg1Ref = new pageReference('/apex/AIA_ProposedProd_Summary?scontrolCaching=1&id='+propProdId );
            }else
            if(ProdID == 'bdpid'){
                    pg1Ref = new pageReference('/apex/AIA_BenefitDesign_Summary?scontrolCaching=1&id='+bdProdId );
            }
                system.debug('Hello Error2: '+ProdID);
                system.debug('Hello Error3: '+propProdId);
            pg1Ref.setRedirect(true);
            return pg1Ref;
    }    
    
    /* T01 - Validate if both In-Network & Out-of-Network Covered are N/A if either one is N/A    *
     * and validate if both In-Network & Out-of-Network Deductible are None if either one is None */
    public boolean validateNA_NoneValues(list<AIA_Benefits__c> lstBenefits) {
            Apexpages.Message validationMsg; 
            for(AIA_Benefits__c ab : lstBenefits){
                    if((ab.Copay_Type_1_IsCovered__c == 'N/A') &&
                        (ab.Copay_Type_1_IsCovered__c != ab.OON_Copay_Type_1_IsCovered__c))
                    {
                        validationMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'  If In-Network "Covered" is "N/A", then Out-of-Network "Covered" must be "N/A", for this Benefit : '+ab.Benefit_Name__c+'');//T07 Removed <Stong></Strong>
                        Apexpages.addmessage(validationMsg);
                        isValidationError = True;
                    }
                    
                    if((ab.Copay_Type_1_DeductibleApplies__c == null && ab.OON_Copay_Type_1_DeductibleApplies__c != null)) 
                       //|| (ab.Copay_Type_1_DeductibleApplies__c != null && ab.OON_Copay_Type_1_DeductibleApplies__c == null))
                    {
                        validationMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'  If In-Network "Deductible" is "none", then Out-of-Network "Deductible" must be "none", for this Benefit : '+ab.Benefit_Name__c+''); //T07 Removed <Stong></Strong>
                        Apexpages.addmessage(validationMsg);
                        isValidationError = True;
                    }
                    
                    if((ab.Dummy_Parent_Benefit_Name__c == null || ab.Place_of_Service__c == '--None--')) 
                    {
                        validationMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'  Please Check Benefit name and place of service, for this Benefit : '+ab.Benefit_Name__c+'');//T07 Removed <Stong></Strong>
                        Apexpages.addmessage(validationMsg);
                        isValidationError = True;
                    }
            }
            return isValidationError;
    }
    
    //T01 - Method to return picklist values for Covered dropdown on Visualforce page
    public List<SelectOption> getCoveredPicklistValues() {
        Schema.DescribeFieldResult fieldResult = AIA_Benefits__c.Copay_Type_1_IsCovered__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<SelectOption> options = new List<SelectOption>();
        for(Schema.PicklistEntry f : ple)
        {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public PageReference AddRecord() {
        newbnft = new AIA_Benefits__c();        
        BenWrapper oWrapp = new BenWrapper(newbnft);
        oWrapp.selected=false;
        oWrapp.benefit.Copay_Type_1_IsCovered__c = 'N/A';
        oWrapp.benefit.OON_Copay_Type_1_IsCovered__c = 'N/A';
        lstWrapper.add(oWrapp);
        
        return null;
    } 
    
    public class BenWrapper{          
          public Boolean Selected{get;set;}
          public AIA_Benefits__c benefit{get;set;}
          
          public BenWrapper(AIA_Benefits__c ben){
                    Selected = false;
                    benefit = ben;
                } 
      } 
    
    
}