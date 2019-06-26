/*===========================================================================================================
 * Date         : 08/08/2016
 * Developer    : Indira Das
 * Purpose      : Benefit Summary Controller to display Benefit details from Proposed product
 *                and from Plan & Plan related objects.
 *                Primarily to make a call to PCS and display the Data on the VF page.
 *===========================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer     Tag   Description
 *===========================================================================================================
 * 10/29/2016 | Indira Das  |     | Initial Version
 * 11/07/2016 | Indira Das  | T01 | updated the get plan commnet codes for ASO and Risk separetely 
 * 11/22/2016 | Indira Das  | T02 | updated code to add the default copay and limitation value to the benefit 
 *                                  record on create
 * 11/29/2016 | Indira Das  | T03 | updated code to add error message if plan or pp id not found 
 * 02/14/2017 | Asif Iqbal  | T04 | Added code to display cost share three month deductible carryover
 * 03/06/2017 | Asif Iqbal  | T05 | Added where clause to runtime benefit object queries/sub-queries to filter
 *                                  benefits with Copay_Type_1_IsCovered__c & OON_Copay_Type_1_IsCovered__c!='N/A' 
 * 03/15/2017 | Asif Iqbal  | T06 | Added code to sort cost shares by Sequence_Number__c
 * 03/17/2017 | Ramakrishna | T08 | Added the logic for VISION page.
 * 03/13/2017 |Goutham Rapolu|T09 | Added method to fetch PlanRxMandate and save to RxMandate(PP/BDP) User Story: B-03729
 * 03/24/2017 | Bill Dodson | T10 | Merged in adjustment summary code.
 * 04/06/2017 | Ramakrishna  |T11 | Conditions on Copay_Type_1_IsCovered__c != 'N/A' and OON_Copay_Type_1_IsCovered__c != 'N/A'
 *                                   has been removed from the benefits query to show all benfits on summary page  B-03639
 * 07/18/2017 | Goutham R    | T12 | Added QA Complete Field 
 * 07/28/2017 | Raviteja V   | T13 | Added variationid,pcsbenefitid,pcsGrouperId from setup to runtime
 * 07/28/2017 | Sajitha Y    | T14 | Added pcsGrouperId from setup to runtime
 * 07/28/2017 | Raviteja V   | T16 | Added PCSbenefit id and variation id for Mandates,Limitations
 * 08/08/2017 | Rajesh Nagandla| T17 | Added Mandate Name from Setup to Runtime
 * 09/11/2017 | Goutham Rapolu | T18 | Added logic for US185 Get Benefits page is Read-Only for business - QA Complete Process
 * 1/17/2018  |  satya       | T19| Method to check whether the user is in Classic or lightning
 * 5/2/2018   |  Sajitha Y   | T20| Commented getPCSdata() method to stop call to PCS when User clicked on Get benefits button 
                                    as part of US1650 and changed error message No Benefit Information is available for the selected 
                                    Plan in PCS to No Benefit Information is available for the selected Plan
 *===========================================================================================================
 */
public with sharing class AIA_benefitDesign_SummaryController {
    public  String resultvalue {get;set;}
    public  List<AIA_RxMandate__c> PPRxMandateRunTime{get;set;}     
    public  List<AIA_RxMandate__c> BDPRxManReview{get;set;}    
    public string planId;  
    public string bdProdId {get; set;}  
    public string propProductId;  
    public string planIdValue;   
    public string propProductCategoryStr{get;set;}
    public AIA_PCS_BenefitSummary benftSum{get;set;} 
    public boolean showError {get;set;}
    public boolean isPCSdata {get;set;}
    //map to store PlanId with Plan record
    public List<GrouperWrapper> grouperWrapList {get;set;}
    public boolean isPPdata {get;set;}  // Whether the data should come from Propese Product schema or from the Plan Schema
    public List<AIA_Benefits__c> bnftcostlst {get; set;}
    public AIA_Benefit_Design_Product__c pp {get;set;}
    public boolean isASO{get;set;} 
    public string jurpp{get;set;}
    String jurisdictionFrmPP = '';
    List<AIA_Plan_Grouper__c> planGrouperBenList = new List<AIA_Plan_Grouper__c>();
    Set<ID> pgroupersID= new Set<ID>();
    Set<String> groupNameSet = new Set<String>();
    Map<String,AIA_Plan_Grouper__c> PlanMapGrouper= new Map<String,AIA_Plan_Grouper__c>();
    
    // MAP :  Grouper Name, Benifit Name, In Net/OutNet, Benifit Record
    Map<String, Map<String, Map<String, AIA_Plan_Benefits__c>>> benifitNetworkMap = new Map<String, Map<String, Map<String, AIA_Plan_Benefits__c>>>();
    Set<id> benefitIdSet = new Set<id>();
    Map<String,set<String>> AllGrpParentBenName=new Map<String,set<String>> ();
    Map<String,set<String>> AllParentBenName=new Map<String,set<String>> ();
    
    CopayTypeWrapper copTypeWrapObj = new CopayTypeWrapper();
    Set<String> CopayIDs=new Set<String>();
    
    Map<String,Set<String>> benLimitsAllMap = new  Map<String,Set<String>>();   
    Set<String> PlanLimitIDs=new Set<String>();
    public integer rowOrder {get;set;}      
    String grpId {get; set;}
    public integer rowHidden{get;set;}
    string  ActualInPCPCopay = '';
    string  ActualInSpecialistCopay = '';
    string  ActualInPerAdmissionCopay = '';
    string  ActualInCoinsuranceRange = '';
    string  ActualInGeneralCoPay = '';
    string  ActualOutPCPCopay = '';
    string  ActualOutSpecialistCopay = '';
    string  ActualOutPerAdmissionCopay = '';
    string  ActualOutCoinsuranceRange = '';
    string  ActualOutGeneralCoPay = ''; 
    public string CustRxPlanName{get;set;}
    date BRFEffDate{get;set;}
    string BRFPCSEffDate{get;set;}
    public decimal NoOfNW{get;set;}
    transient public decimal NoOfNWreview {get;set;}
    public Date PPEffDate{get;set;}
    public Boolean PsetTrue{get;set;}
    public Boolean QAComplete{get;set;}
    public boolean isClassic {get;set;} //T19
    /*8
    *This is the constructor of the class here we call disaptcher method which copy values from Setup to Runtime
    */
    public AIA_benefitDesign_SummaryController(apexPages.StandardController controller){
        //system.debug('SUMMARY CONSTRUCTOR');
        pp= new AIA_Benefit_Design_Product__c();
        isPPdata = False;
        isASO = false;
        isClassic = AIA_Utils.isClassic(); //T19
        bdProdId = ApexPages.currentPage().getParameters().get('id');
       
         dispatcher();
    }
    /**
    * This is the Intializing method where we will validate the Planid and planIdValue
    * We will also call getpcsdata it the isPCScallReq is true
    * We will also copy all values from setup to runtime
    */
   public pageReference mainInit(){
      try{
       //system.debug('staring isASO>>>'+isASO);
        system.debug('================inside maininit=========');
        AIA_BenefitTriggerHandler.disableAdjustmentsOnUpdates(); // Bill T10, do not allow adjustment records for benefit changes.
        showError = false;
        isPCSdata = false;
        benftSum = new AIA_PCS_BenefitSummary();
        bdProdId = ApexPages.currentPage().getParameters().get('id');
        propProductId  = ApexPages.currentPage().getParameters().get('idValue');
        //get Plan Id from Proposed Product
       list<AIA_Benefit_Design_Product__c> propProdList = new  list<AIA_Benefit_Design_Product__c> ();
            if(bdProdId!=null && bdProdId!=''){
               propProdList =[Select id,PPACA_Status__c,Plan_Name__r.Plan_Id__c,Plan_Name__r.QA_Complete__c,DHMO__c,Has_Benefit_Details__c,Plan_Name__c,Plan_Product_Name__c , Funding_Arrangement__c,Product_Category__c,Benefit_Design__c,BRF_Juridiction__c, Benefit_Design__r.Benefit_Request_Form__r.EffectiveDatePCSFormat__c,  
               Proposed_Products__r.Benefit_Request_Form__r.Benefit_Effective_Date__c 
               from AIA_Benefit_Design_Product__c Where id =: bdProdId ];
            }
            else{
                 showError = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'No proposed Product Id Found');
                 ApexPages.addMessage(myMsg);
            }

            if(propProdList != NULL && propProdList.size() > 0){
                pp=propProdList[0];
                planId = propProdList[0].Plan_Name__c; 
                planIdValue=  propProdList[0].Plan_Name__r.Plan_Id__c;
                BRFEffDate = pp.Proposed_Products__r.Benefit_Request_Form__r.Benefit_Effective_Date__c;
                BRFPCSEffDate=propProdList[0].Benefit_Design__r.Benefit_Request_Form__r.EffectiveDatePCSFormat__c;
              //  system.debug('+++++EffectiveDateBRF++++'+BRFEffDate);
               //  system.debug('propProdList[0].Funding_Arrangement__c>>>'+propProdList[0].Funding_Arrangement__c);
                if(propProdList[0].Funding_Arrangement__c!='ASO'){
               //     system.debug('isASO>>>'+isASO);
                    isASO=true;
               //     system.debug('Change isASO>>>'+isASO);
                }
            }
            
        //T18 Start
            PsetTrue = false;
            QAComplete = pp.Plan_Name__r.QA_Complete__c;
            String CPName = 'AIA_Plan_QA_Audit';
            PsetTrue = CF_CustomPermissionsReader_Helper.Permissions.PlanQAAudit;
        // T18 End
           // system.debug(Logginglevel.INFO,'PSetTrue ==='+PSetTrue);
             
             //T12-start
           if(pp.Plan_Name__r.QA_Complete__c == false && pp.Has_Benefit_Details__c == false && PsetTrue == False){ 
             showError = true;
             ApexPages.Message myMsgQA = new ApexPages.Message(ApexPages.Severity.ERROR, 'Benefits cannot be retrieved since the plan associated is not QA complete.');
             ApexPages.addMessage(myMsgQA);
             return null;
             } 
            //T12-End
            
           
            if(planId==null || planId==''){
                 showError = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'No Plan Name found for the Benefit Design Product.');
                 ApexPages.addMessage(myMsg);
            }
            if(planIdValue==null || planIdValue==''){
                 showError = true;
                 ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.FATAL, 'No PCS Plan ID  found for the selected Plan.');
                 ApexPages.addMessage(myMsg1);
            } 
            
            /*****T03 End ************/
            
            //Get Plan Record Info from Plan Id. This method has to be called before checking
            //the call out condition
            //   getPlanInfo
            IF(planId!='' && planId!=null && showError==false){
                String QueryStr=QueryBase2.getSobjectAllFieldsSOQL('AIA_Plan__c', 'Id=:planId');
                AIA_Plan__c aia_Plan = database.query(QueryStr);
                NoOfNW = aia_Plan.CountOfNetworks__c; 
                //check if Benefit Summary has data & is valid, if it doesn't then make call out to PCS
                //otherwise get data from Salesforce objects
                if(aia_Plan != NULL ){
                    if(aia_Plan != NULL && hasBnftSumry(aia_Plan)){
    
                        if(aia_Plan != NULL && isPCScallReq(aia_Plan)){
                            isPCSdata = true;
							//T20 - Start commented PCS Call as part of US1650
                            //getPCSdata();
							//T20 - End
                            dispatcher();
                            //dispatcherTemp();
                          //  
                          //  system.debug('IF PCSdata from setup  :: '+aia_Plan);  
                        }else{
                            dispatcher();
                          //  system.debug('================inside maininit else=========');
                          //  system.debug('Else PCSdata :: '+aia_Plan);  
                        }                        
                    }
                    else{
                        showError = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'No Benefit Information is available for the selected Plan');
                        ApexPages.addMessage(myMsg);
                    }
                }
    
            }
           }
            catch(exception ex){
               system.debug('Exception caught: '+ex.getLineNumber()+'- '+ex.getMessage());
             showError = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage());
                        ApexPages.addMessage(myMsg);
            }



   List<AIA_Benefit_Design_Product__c> lstpp = [select id,PPACA_Status__c,name,DHMO__c,Has_benefit_Details__c, Plan_Product_Name__c  from AIA_Benefit_Design_Product__c where id =:bdProdId];
    if(lstpp.size()>0){
        if(lstpp[0].Has_benefit_Details__c ==False){     
            saveAndContemp();    
            isPPdata =false;        
            dispatcher();
        }       
    } 
        //Get RXMandate from PP  T09        
        AIA_BRF_DeepCloneHelper BRFCloneHelper1 = new AIA_BRF_DeepCloneHelper();        
        PPRxMandateRunTime = BRFCloneHelper1.RxMandateRunTime(null,bdProdId);       
      //  system.debug('====PPRxMandateRunTime==== :: '+PPRxMandateRunTime.size());       
      //  system.debug('====PPRxMandateRunTime==== :: '+PPRxMandateRunTime);             
        return null;        
  }       
     /**
     * This method is used to save the all the edited values to the setup.
     * this method fires when we switch from one panel to another panel on UI
     */ 
     public void dispatcherTemp(){       
       // system.debug('===rowOrder======'+rowOrder);     
        if(rowOrder != null){       
        boolean isReview;//Temp     
        Set<Id> bnfId = new Set<Id>();      
        grouperWrapper gw = grouperWrapList[rowOrder];  

        
        if(gw.aiaGrouper != null){      
      //  system.debug('====aiaGrouper===='+gw.aiaGrouper.id);  
        if(pp.Funding_Arrangement__c == 'ASO'){      
        List<AIA_Benefits__c> benifitList = new List<AIA_Benefits__c>([Select id,Name,Tier_type__c , Benefit_Name__c,Benefit_Summary_Comment__c, Benefit_Record_Type__c , Copay_Type_2_Increment__c ,Copay_Type_2_Additional_Increments__c ,        
        CopayType2_Additional_InvalidIncrement__c,Copay_Type_1_Increment__c , Copay_Type_1_Additional_Increments__c ,Copay_Type_1_AdditionalInvalidIncrements__c,       
        Coinsurance_DefaultAmount__c, OON_Coinsurance_DefaultAmount__c,OON_CoInsurance_AmountValueSelected__c, Copay_Min_Payment__c,Copay_Type_1_Mandate_Name__c ,      
        Copay_Max_Payment__c,Copay_Type_1_High__c , Copay_Type_1_DefaultAmount__c,CoInsurance_AmountValueSelected__c,Copay_Type_1_AliasName__c,Copay_Type_2_High__c ,       
        Copay_Type_1_Low__c, Copay_Type_2_Low__c  ,Copay_Type_2_AliasName__c,OON_Copay_Type_1_AliasName__c,OON_Copay_Type_2_AliasName__c,Copay_Type_1_Jurisdiction__c ,         
        OON_Copay_Type_2_Additional_Increments__c, OON_Copay2_Low__c, OON_Copay2_High__c,OON_Copay2_Increment__c, OON_Copay2Additional_InvalidIncrements__c,        
        OON_Copay_Type_1_IsCovered__c,Copay_Type_1_IsCovered__c,Copay_Type_1_DeductibleApplies__c,OON_Copay_Min_Payment__c,OON_Copay_Max_Payment__c,        
        OON_Copay_Type_1_DefaultAmount__c,Copay_Type_1_AmountValueSelected__c,Copay_Type_2_AmountValueSelected__c,OON_Copay_AmountLow__c, OON_Copay_AmountHigh__c,          
        OON_Copay_Additional_Increments__c, OON_Copay_Additional_InvalidIncrements__c,OON_Copay_AmountIncrement__c, OON_Copay_Type_1_AmountValueSelected__c,        
        OON_Copay_Type_2_AmountValueSelected__c,OON_Copay_Type_1_DeductibleApplies__c,  Benefit_Type__c , Sequence_Number__c,Sequence_Number_SF__c, Copay_Type_1_Benefit_Comment_Codes__c , IS_ASO_Only__c, Mandate_Yes_No__c,IN_CostShare_3Month_DeductibleCarryover__c,ON_CostShare_3Month_DeductibleCarryover__c,Cost_Share_Type__c,
        OON_Tier_Type_Default__c, Tier_Type_Default__c, OON_Copay_Default_Max_Payment__c, OON_Copay_Default_Min_Payment__c, Copay_Type_1_Default_IsCovered__c,
        Copay_Type_1_Default_DeductibleApplies__c, Copay_Default_Min_Payment__c, Copay_Default_Max_Payment__c, OON_Copay_Type_1_Default_IsCovered__c,
        OON_Copay_1_Default_DeductibleApplies__c  ,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c,AnnualMaximumApplies__c,OON_AnnualMaximumApplies__c,
        Discount_Amount__c, ScheduledAmounts__c, Allowed_Amount__c,Discount_Amount_Percent__c, Discount_Applies__c, OON_Discount_Applies__c, //T08 Vision fields added
        OON_Allowed_Amount__c, OON_ScheduledAmounts__c,OON_Discount_Amount__c, OON_Discount_Amount_Percent__c,Davis_Benefit_Variable__c,Davis_Benefit_Variable_Default__c,Davis_Variable_customized__c
        ,OON_Coinsurance_AmountLow__c,OON_Coinsurance_AmountHigh__c, OON_Coinsurance_AmountIncrement__c, OON_Coinsurance_AddtionalIncrements__c, OON_Coinsurance_InvalidIncrements__c,
        Coinsurance_AmountLow__c, Coinsurance_AmountHigh__c, Coinsurance_AmountIncrement__c, Coinsurance_Amount_AddtionalIncrements__c, Coinsurance_Amount_InvalidIncrements__c,
        Allowed_Amount_Default__c,OON_Allowed_Amount_Default__c,Discount_Amount_Default__c,OON_Discount_Amount_Default__c,Discount_Amount_Percent_Default__c,
        OON_Discount_Amount_Percent_Default__c,Discount_Applies_Default__c,OON_Discount_Applies_Default__c,ScheduledAmounts_Default__c,OON_ScheduledAmounts_Default__c
        , INN_MandateLockDownInd__c, INN_MappingBRFBenefitID__c, ONN_MappingBRFBenefitID__c, ONN_MandateLockDownInd__c 
        ,IN_Approximate_Member_Payment_w_Discount__c,IN_Approx_Member_Payment_w_Disc_Default__c,
        ON_Approximate_Member_Payment_w_Discount__c,ON_Approx_Member_Payment_w_Disc_Default__c
         from AIA_Benefits__c 
         where Grouper__c =: gw.aiaGrouper.id //and
              //Copay_Type_1_IsCovered__c != 'N/A' and 
              //OON_Copay_Type_1_IsCovered__c != 'N/A' 
        Order by Sequence_Number_SF__c asc]);     
      //  System.debug('++++benifitList++'+benifitList);      
        for(AIA_Benefits__c benObj : benifitList) {     
        if(isReview==true){     
        if( benObj.Benefit_Type__c=='Limitation' || benObj.Benefit_Type__c=='Mandate'  ){       
        if(  benObj.Benefit_Summary_Comment__c!=null && benObj.Benefit_Summary_Comment__c!='' ||        
        ((benObj.Benefit_Summary_Comment__c=='' || benObj.Benefit_Summary_Comment__c==null)         
        && benObj.Copay_Type_1_Benefit_Comment_Codes__c=='NA'))     
        bnfId.add(benObj.id);       
        }       
        else{       
        bnfId.add(benObj.id);       
        }
        }
        else        
        bnfId.add(benObj.id);       
        }       
        List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c,Benefit_Type__c, comment_codes__c, IsSelected__c, Jurisdiction__c,       
        MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c,   ParentBenefitName__c,    
        MaxAge_Selected__c, MaxDuration_Selected__c, TierAge_Selected__c, TierLimit_Selected__c,MaxDuration__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c,IS_ASO_Only__c,         
        TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c,recordtype__c, 
        MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
        MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,    
        TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
        TierLimitTo__c, TierLimitType__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c,Effective_Date__c, Term_Date__c,CommentType__c        
        FROM Limitations__c where Benefit__c in:bnfId]);        
        Map<ID,List<Limitations__c>> maplmt = new Map<Id,List<Limitations__c>>(); 
         Boolean IsASOOnly = false;   
        //System.debug('++++ASO++Limit++'+IsASOOnly);     
        for(Limitations__c obj:lmtsn){
        //System.debug('++++ASO++obj.IS_ASO_Only__c++'+obj.IS_ASO_Only__c);   
        if(obj.IS_ASO_Only__c)
        {
            IsASOOnly = True;
        }
        List<Limitations__c> lmts=new List<Limitations__c>();       
        if(maplmt.containsKey(obj.Benefit__c)){     
        lmts=maplmt.get(obj.Benefit__c);        
        }       
        if(isReview==true){     
        if((obj.IsSelected__c==true && obj.Type__c == 'Comment' ) || (obj.Type__c != 'Comment' && (obj.MaxAge_Selected__c == true || obj.MaxDuration_Selected__c == true || obj.TierAge_Selected__c == true || obj.TierLimit_Selected__c == true) ))  
        lmts.add(obj);      
        }       
        else if(obj.Recordtype__c == 'BRF' && (obj.IsSelected__c==true && obj.Type__c == 'Comment' ) || (obj.Type__c != 'Comment' && (obj.MaxAge_Selected__c == true || obj.MaxDuration_Selected__c == true || obj.TierAge_Selected__c == true || obj.TierLimit_Selected__c == true) )) {       
        lmts.add(obj);  
        }   
        else if(obj.Recordtype__c != 'BRF'){
        lmts.add(obj);
        }
        maplmt.put(obj.Benefit__c,lmts);        
        }
      //  System.debug('++++ASO++Limit++'+IsASOOnly);     
      //  System.debug('+++maplmt++++'+maplmt);       
        List<BenifitsrWrapper> benWrapList = new List<BenifitsrWrapper>();      
        for(AIA_Benefits__c benObj : benifitList) {  
        benObj.IS_ASO_Only__c = IsASOOnly;
      //  System.debug('++++ASO++benObj.IS_ASO_Only__c++'+benObj.IS_ASO_Only__c);     
        if(benobj.Copay_Type_1_AliasName__c!='' && benobj.Copay_Type_1_AliasName__c!=null)      
        gw.Inpcpval= benobj.Copay_Type_1_AliasName__c;      
        if(benobj.Copay_Type_2_AliasName__c!='' && benobj.Copay_Type_2_AliasName__c!=null)      
        gw.Inspcpval= benobj.Copay_Type_2_AliasName__c;     
        if(benobj.OON_Copay_Type_1_AliasName__c!='' && benobj.OON_Copay_Type_1_AliasName__c!=null)      
        gw.OUTpcpval= benobj.OON_Copay_Type_1_AliasName__c;     
        if(benobj.OON_Copay_Type_2_AliasName__c!='' && benobj.OON_Copay_Type_2_AliasName__c!=null)      
        gw.Outspcpval= benobj.OON_Copay_Type_2_AliasName__c;        
        BenifitsrWrapper benWrapObj = new BenifitsrWrapper();       
        if(maplmt.containsKey(benObj.id)){      
        benWrapObj.benifitNameStr = benObj.Benefit_Name__c;     
    //    System.debug('++maplmt.get(benObj.id)++++'+maplmt.get(benObj.id));      
        benWrapObj.lstlimit = maplmt.get(benObj.id); 
        benWrapObj.lstJurisdictions = getjurdictions(benWrapObj.lstlimit);       
        }       
        else{       
        benWrapObj.benifitNameStr = benObj.Benefit_Name__c;     
        }       
     //   system.debug('Benefit name--'+benObj.Benefit_Name__c+'----'+benObj.Benefit_Type__c);        
        benWrapObj.aiaBenifitObj = benObj;      
        if(bnfId.contains(benObj.Id))       
        benWrapList.add(benWrapObj);        
        }       
        gw.benifitWrapList = benWrapList;       
    //    SYSTEM.debug('=============='+benWrapList);         
        }  
         if(pp.Funding_Arrangement__c == 'Risk'){      
        List<AIA_Benefits__c> benifitList = new List<AIA_Benefits__c>([Select id,Name, Tier_type__c , Benefit_Name__c,Benefit_Summary_Comment__c,Benefit_Record_Type__c , Copay_Type_2_Increment__c ,Copay_Type_2_Additional_Increments__c ,        
        CopayType2_Additional_InvalidIncrement__c,Copay_Type_1_Increment__c , Copay_Type_1_Additional_Increments__c ,Copay_Type_1_AdditionalInvalidIncrements__c,       
        Coinsurance_DefaultAmount__c, OON_Coinsurance_DefaultAmount__c,OON_CoInsurance_AmountValueSelected__c, Copay_Min_Payment__c,Copay_Type_1_Mandate_Name__c ,      
        Copay_Max_Payment__c,Copay_Type_1_High__c , Copay_Type_1_DefaultAmount__c,CoInsurance_AmountValueSelected__c,Copay_Type_1_AliasName__c,Copay_Type_2_High__c ,       
        Copay_Type_1_Low__c, Copay_Type_2_Low__c  ,Copay_Type_2_AliasName__c,OON_Copay_Type_1_AliasName__c,OON_Copay_Type_2_AliasName__c,Copay_Type_1_Jurisdiction__c ,         
        OON_Copay_Type_2_Additional_Increments__c, OON_Copay2_Low__c, OON_Copay2_High__c,OON_Copay2_Increment__c, OON_Copay2Additional_InvalidIncrements__c,        
        OON_Copay_Type_1_IsCovered__c,Copay_Type_1_IsCovered__c,Copay_Type_1_DeductibleApplies__c,OON_Copay_Min_Payment__c,OON_Copay_Max_Payment__c,        
        OON_Copay_Type_1_DefaultAmount__c,Copay_Type_1_AmountValueSelected__c,Copay_Type_2_AmountValueSelected__c,OON_Copay_AmountLow__c, OON_Copay_AmountHigh__c,          
        OON_Copay_Additional_Increments__c, OON_Copay_Additional_InvalidIncrements__c,OON_Copay_AmountIncrement__c, OON_Copay_Type_1_AmountValueSelected__c,        
        OON_Copay_Type_2_AmountValueSelected__c,OON_Copay_Type_1_DeductibleApplies__c,  Benefit_Type__c , Sequence_Number__c,Sequence_Number_SF__c,Copay_Type_1_Benefit_Comment_Codes__c        
        , IS_ASO_Only__c, Mandate_Yes_No__c , OON_Tier_Type_Default__c, Tier_Type_Default__c, OON_Copay_Default_Max_Payment__c, OON_Copay_Default_Min_Payment__c, Copay_Type_1_Default_IsCovered__c,
        Copay_Type_1_Default_DeductibleApplies__c, Copay_Default_Min_Payment__c, Copay_Default_Max_Payment__c, OON_Copay_Type_1_Default_IsCovered__c,
        OON_Copay_1_Default_DeductibleApplies__c  ,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c,IN_CostShare_3Month_DeductibleCarryover__c,ON_CostShare_3Month_DeductibleCarryover__c,Cost_Share_Type__c,
        Discount_Amount__c, ScheduledAmounts__c, Allowed_Amount__c,Discount_Amount_Percent__c,AnnualMaximumApplies__c,OON_AnnualMaximumApplies__c, Discount_Applies__c, OON_Discount_Applies__c, //T08 Vision fields added
        OON_Allowed_Amount__c, OON_ScheduledAmounts__c,OON_Discount_Amount__c,Davis_Variable_customized__c,Davis_Benefit_Variable_Default__c, OON_Discount_Amount_Percent__c,Davis_Benefit_Variable__c  //T08 Vision fields added
        ,OON_Coinsurance_AmountLow__c,OON_Coinsurance_AmountHigh__c, OON_Coinsurance_AmountIncrement__c, OON_Coinsurance_AddtionalIncrements__c, OON_Coinsurance_InvalidIncrements__c,
        Coinsurance_AmountLow__c, Coinsurance_AmountHigh__c, Coinsurance_AmountIncrement__c, Coinsurance_Amount_AddtionalIncrements__c, Coinsurance_Amount_InvalidIncrements__c,
        Allowed_Amount_Default__c,OON_Allowed_Amount_Default__c,Discount_Amount_Default__c,OON_Discount_Amount_Default__c,Discount_Amount_Percent_Default__c,
        OON_Discount_Amount_Percent_Default__c,Discount_Applies_Default__c,OON_Discount_Applies_Default__c,ScheduledAmounts_Default__c,OON_ScheduledAmounts_Default__c
        ,INN_MandateLockDownInd__c, INN_MappingBRFBenefitID__c, ONN_MappingBRFBenefitID__c, ONN_MandateLockDownInd__c
        
        ,IN_Approximate_Member_Payment_w_Discount__c,IN_Approx_Member_Payment_w_Disc_Default__c,
        ON_Approximate_Member_Payment_w_Discount__c,ON_Approx_Member_Payment_w_Disc_Default__c
        
        from AIA_Benefits__c 
        where Grouper__c =: gw.aiaGrouper.id AND 
              IS_ASO_Only__c = False Order by Sequence_Number_SF__c asc]);     
   //     System.debug('++++benifitList++'+benifitList);      
        for(AIA_Benefits__c benObj : benifitList) {     
        if(isReview==true){     
        if( benObj.Benefit_Type__c=='Limitation' || benObj.Benefit_Type__c=='Mandate'  ){       
        if(  benObj.Benefit_Summary_Comment__c!=null && benObj.Benefit_Summary_Comment__c!='' ||        
        ((benObj.Benefit_Summary_Comment__c=='' || benObj.Benefit_Summary_Comment__c==null)         
        && benObj.Copay_Type_1_Benefit_Comment_Codes__c=='NA'))     
        bnfId.add(benObj.id);       
        }       
        else{       
        bnfId.add(benObj.id);       
        }
        }
        else        
        bnfId.add(benObj.id);       
        }       
        List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c, Benefit_Type__c,comment_codes__c, IsSelected__c, Jurisdiction__c,       
        MaxAge_Selected__c, MaxDuration_Selected__c, TierAge_Selected__c, TierLimit_Selected__c,MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c,   ParentBenefitName__c,    
        MaxDuration__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, IS_ASO_Only__c,
        MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
        MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,          
        TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
        TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c,   recordtype__c,    
        TierLimitTo__c, TierLimitType__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c, Effective_Date__c, Term_Date__c,CommentType__c               
        FROM Limitations__c where IS_ASO_Only__c = False and Benefit__c in:bnfId]);        
        Map<ID,List<Limitations__c>> maplmt = new Map<Id,List<Limitations__c>>();  
        Boolean IsASOOnly = false;
   //     System.debug('++++Risk++IsASOOnly++'+IsASOOnly);            
        for(Limitations__c obj:lmtsn){ 
    //    System.debug('++++Risk++obj.IS_ASO_Only__c++'+obj.IS_ASO_Only__c);      
        if(obj.IS_ASO_Only__c)
        {
            IsASOOnly = True;
        }
        List<Limitations__c> lmts=new List<Limitations__c>();       
        if(maplmt.containsKey(obj.Benefit__c)){     
        lmts=maplmt.get(obj.Benefit__c);        
        }       
        if(isReview==true){     
        if((obj.IsSelected__c==true && obj.Type__c == 'Comment' ) || (obj.Type__c != 'Comment' && (obj.MaxAge_Selected__c == true || obj.MaxDuration_Selected__c == true || obj.TierAge_Selected__c == true || obj.TierLimit_Selected__c == true) ))  
        lmts.add(obj);      
        }       
       else if(obj.Recordtype__c == 'BRF' && (obj.IsSelected__c==true && obj.Type__c == 'Comment' ) || (obj.Type__c != 'Comment' && (obj.MaxAge_Selected__c == true || obj.MaxDuration_Selected__c == true || obj.TierAge_Selected__c == true || obj.TierLimit_Selected__c == true) )) {       
        lmts.add(obj);  
        }   
        else if(obj.Recordtype__c != 'BRF'){
        lmts.add(obj);
        }      
        maplmt.put(obj.Benefit__c,lmts);        
        }       
        System.debug('+++maplmt++++'+maplmt); 
        System.debug('++++Risk++IsASOOnly++'+IsASOOnly);            
        List<BenifitsrWrapper> benWrapList = new List<BenifitsrWrapper>();      
        for(AIA_Benefits__c benObj : benifitList) {   
        System.debug('++++Risk++benObj.IS_ASO_Only__c ++'+IsASOOnly);
        if(benobj.Copay_Type_1_AliasName__c!='' && benobj.Copay_Type_1_AliasName__c!=null)      
        gw.Inpcpval= benobj.Copay_Type_1_AliasName__c;      
        if(benobj.Copay_Type_2_AliasName__c!='' && benobj.Copay_Type_2_AliasName__c!=null)      
        gw.Inspcpval= benobj.Copay_Type_2_AliasName__c;     
        if(benobj.OON_Copay_Type_1_AliasName__c!='' && benobj.OON_Copay_Type_1_AliasName__c!=null)      
        gw.OUTpcpval= benobj.OON_Copay_Type_1_AliasName__c;     
        if(benobj.OON_Copay_Type_2_AliasName__c!='' && benobj.OON_Copay_Type_2_AliasName__c!=null)      
        gw.Outspcpval= benobj.OON_Copay_Type_2_AliasName__c;        
        BenifitsrWrapper benWrapObj = new BenifitsrWrapper();       
        if(maplmt.containsKey(benObj.id)){      
        benWrapObj.benifitNameStr = benObj.Benefit_Name__c;     
        System.debug('++maplmt.get(benObj.id)++++'+maplmt.get(benObj.id));      
        benWrapObj.lstlimit = maplmt.get(benObj.id);   
        benWrapObj.lstJurisdictions = getjurdictions(benWrapObj.lstlimit);     
        }       
        else{       
        benWrapObj.benifitNameStr = benObj.Benefit_Name__c;     
        }       
   //     system.debug('Benefit name--'+benObj.Benefit_Name__c+'----'+benObj.Benefit_Type__c);        
        benWrapObj.aiaBenifitObj = benObj;      
        if(bnfId.contains(benObj.Id))       
        benWrapList.add(benWrapObj);        
        }       
        gw.benifitWrapList = benWrapList;       
    //    SYSTEM.debug('=============='+benWrapList);         
        }  
        }
        
             
        }       
        saveAndContemp();  
for(integer i=0;i<grouperWrapList.size();i++){      
        if(i!= rowOrder)
            {                          
                 grouperWrapList[i].benifitWrapList = new List<BenifitsrWrapper>();         
            }       
        }       
        }
       /*
     * This method is used to Copay all values of PP , Groper ,Limitation,Comment codes to set up
     * Entited involved : AIA_Benefit_Design_Product__c,AIA_Plan_Limitation__c,AIA_Plan_Benefit_Comment_Codes__c
     * 
     */   
            public void dispatcher() {
                system.debug('================inside dispatcher=========');
                isPPdata = False;
                Boolean isIntegrationCall = False;
                showError=false;
                propProductCategoryStr = '';
                 try{
                bdProdId = ApexPages.currentPage().getParameters().get('id');
                String planIdStr;
                       String QueryStr=QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefits__c', 'Grouper__r.Group_Type__c =\'Cost Share Group\' and Grouper__r.Benefit_Design_Product__c=:bdProdId');
                       /**T06 - Added Order by clause to sort cost shares by Sequence_Number__c **/
                       QueryStr = QueryStr + ' Order By Sequence_Number__c ASC';
            /*****T03 Start ************/
                    List<AIA_Benefit_Design_Product__c> ppList = new List<AIA_Benefit_Design_Product__c> ();
                    List<AIA_Benefits__c> aiaBDBenefitList=new  List<AIA_Benefits__c>();
                       if(bdProdId!=null && bdProdId!=''){
                     
                             aiaBDBenefitList = [Select id, Benefit_Name__c From AIA_Benefits__c 
                                                                  Where Grouper__r.Benefit_Design_Product__c =: bdProdId and RecordType.Name= 'BD Product' and Benefit_Record_Type__c='BDD'];
                
                               ppList = [Select id,PPACA_Status__c,name,DHMO__c,Has_benefit_Details__c,Plan_Product_Name__c,Funding_Arrangement__c,Plan_Name__c,Product_Category__c ,BRF_Juridiction__c
                                                                      from AIA_Benefit_Design_Product__c  Where id =: bdProdId ];
                            /**T06 - Added Order by clause to sort cost shares by Sequence_Number__c **/                                          
                            bnftcostlst = new List<AIA_Benefits__c>([select id,name,Benefit_Name__c, Cost_Share_Default_Amount__c, OON_Cost_Share_Default_Amount__c,Cost_Share_Low__c,Benefit_Record_Type__c,
                                                                 Cost_Share_High__c,Cost_Share_Increment__c, Cost_Share_AdditionalIncrements__c, Cost_Share_InvalidIncrements__c,   
                                                                 OON_Cost_Share_InvalidIncrements__c, OON_Cost_Share_AdditionalIncrements__c,OON_Cost_Share_Low__c,OON_Cost_Share_High__c,
                                                                 OON_Cost_Share_Increment__c,OON_Cost_Share_SelectedAmount__c,Cost_Share_SelectedAmount__c,IN_CostShare_3Month_DeductibleCarryover__c,
                                                                 ON_CostShare_3Month_DeductibleCarryover__c,Cost_Share_Type__c,Tier_type__c , IS_ASO_Only__c, Mandate_Yes_No__c  
                                                                 from AIA_Benefits__c 
                                                                 where Grouper__r.Group_Type__c ='Cost Share Group' and 
                                                                       Grouper__r.Benefit_Design_Product__c=:bdProdId and 
                                                                       Grouper__r.Grouper_RecordtypeName__c='BD_Product'
                                                                 order by Sequence_Number__c asc]);
                 //       system.debug('bnftcostlst size---->'+bnftcostlst.size());
                        for(AIA_Benefits__c bnfcost:bnftcostlst)
                        {
                            if(bnfcost.Benefit_Name__c== 'PCP Copay')
                            {
                                ActualInPCPCopay = bnfcost.Cost_Share_SelectedAmount__c;
                                ActualOutPCPCopay = bnfcost.OON_Cost_Share_SelectedAmount__c;
                            }
                            else if(bnfcost.Benefit_Name__c== 'Specialist Copay')
                            {
                                ActualInSpecialistCopay = bnfcost.Cost_Share_SelectedAmount__c;
                                ActualOutSpecialistCopay = bnfcost.OON_Cost_Share_SelectedAmount__c;
                            }
                            else if(bnfcost.Benefit_Name__c== 'Per Admission Copay')
                            {
                                ActualInPerAdmissionCopay = bnfcost.Cost_Share_SelectedAmount__c;
                                ActualOutPerAdmissionCopay = bnfcost.OON_Cost_Share_SelectedAmount__c;
                            }
                            else if(bnfcost.Benefit_Name__c== 'Coinsurance')
                            {
                                ActualInCoinsuranceRange = bnfcost.Cost_Share_SelectedAmount__c;
                                ActualOutCoinsuranceRange = bnfcost.OON_Cost_Share_SelectedAmount__c;
                            }
                            else if(bnfcost.Benefit_Name__c == 'General Copay')
                            {
                                ActualInGeneralCoPay = bnfcost.Cost_Share_SelectedAmount__c;
                                ActualOutGeneralCoPay = bnfcost.OON_Cost_Share_SelectedAmount__c;
                            }
                        }
                   //     system.debug('ppList---'+ppList.size()+'----'+ppList[0].id);
                       }
                     else{
                          showError = true;
                         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'No Benefit Design Product Id Found');
                         ApexPages.addMessage(myMsg);
                     }
                     
                if( ppList != null && ppList.size()>0 ) {
                    pp=ppList[0];
                    planIdStr = ppList[0].Plan_Name__c;
                    propProductCategoryStr = ppList[0].Product_Category__c;
                }
                 
                  
                     if(planIdStr==null || planIdStr==''){
                         showError = true;
                         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'No Plan is added for the Benefit Design Product. Update the Plan name for the Benefit Design Product.');
                         ApexPages.addMessage(myMsg);
                    } /*****T03 End ************/
                isPPdata = false;
             //   system.debug('isPPdata---'+isPPdata);
        
                if(ppList[0].Has_benefit_Details__c==true && showError==false) {
                    isPPdata = True;
                    //createListFromPP(bdProdId,false);
                    createListFromPPTemp(bdProdId,false);
        
                }else if( showError==false) {
                    isPPdata = False;
//                    system.debug('isPPdata---'+isPPdata);
           //         system.debug('================inside dispatcher else get from setup =========');
                    if(planIdStr != null && planIdStr != '') {
        
                        createWrapListFromPlan(ppList[0]);
                    }
                }
                 }
                    catch(exception ex){
                       system.debug('Exception caught: '+ex.getLineNumber()+'- '+ex.getMessage());
                     showError = true;
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage());
                                ApexPages.addMessage(myMsg);
                    }
        
        
            }
            /**
            *
            */
            public pageReference reviewInit(){
                try{
                    bdProdId = ApexPages.currentPage().getParameters().get('id');
                    String QSReview=QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('AIA_Benefit_Design_Product__c','Id=:bdProdId','Plan_Name__r.CountOfNetworks__c,');
                    AIA_Benefit_Design_Product__c PPNoofNW = database.query(QSReview);
                    NoOfNWreview = PPNoofNW.Plan_Name__r.CountOfNetworks__c;
                    
                    String planIdStr;
                     List<AIA_Grouper__c> aiaGrouperList=  [Select id,Sequence_Number__c, Name,Grouper_Record_Type__c , OON_IsCovered__c, OON_DeductibleApplies__c, OON_AnnualMaximumApplies__c, OON_DavisString__c, OON_CoInsurance__c,
                                                            IsCovered__c, DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, CoInsurance__c  
                                                                 From AIA_Grouper__c Where Benefit_Design_Product__c =: bdProdId AND Group_Type__c = 'Benefit Group'];
                     List<AIA_Benefit_Design_Product__c> ppList = [Select PPACA_Status__c,Plan_Name__c,DHMO__c,Plan_Product_Name__c ,Has_Benefit_Details__c,BRF_Juridiction__c,Product_Category__c,Benefit_Design__c, Benefit_Design__r.Jurisdiction__c,Funding_Arrangement__c  
                                                                  from AIA_Benefit_Design_Product__c Where id =: bdProdId ];
                    /**T06 - Added Order by clause to sort cost shares by Sequence_Number__c **/
                     bnftcostlst = new List<AIA_Benefits__c>([select id,name,Benefit_Name__c, Benefit_Record_Type__c,
                                                             OON_Cost_Share_SelectedAmount__c,Cost_Share_SelectedAmount__c,Cost_Share_Type__c, 
                                                              IS_ASO_Only__c, Mandate_Yes_No__c  
                                                             from AIA_Benefits__c 
                                                             where Grouper__r.Group_Type__c ='Cost Share Group' and 
                                                                   Grouper__r.Benefit_Design_Product__c=:bdProdId and 
                                                                   Grouper__r.Grouper_RecordtypeName__c='BD_Product'
                                                             order by Sequence_Number__c asc]);
                //    system.debug('ppList---'+ppList.size()+'----'+ppList[0].id);
                    if( ppList != null && ppList.size()>0 ) {
                        pp=ppList[0];
                        planIdStr = ppList[0].Plan_Name__c;
                        propProductCategoryStr = ppList[0].Product_Category__c;
                    }
                    isPPdata = false;
               //     system.debug('isPPdata---'+isPPdata);
                    System.debug('+++aiaGrouperList++'+aiaGrouperList);
                    if(aiaGrouperList.size()>0) {
                        isPPdata = True;
                        createListFromPP(bdProdId,true);
                    }
                    if(pp.Product_Category__c == 'Drug'){
                        AIA_GetCustomRxPlanName_BD objCustRxName = new AIA_GetCustomRxPlanName_BD();
                        CustRxPlanName = objCustRxName.getCustomRxPlanName(bdProdId,pp.Plan_Product_Name__c); 
                        //Get RXMandate from BDP   T09      
                        AIA_BRF_DeepCloneHelper BRFCloneHelperx = new AIA_BRF_DeepCloneHelper();        
                        BDPRxManReview = BRFCloneHelperx.RxMandateRunTime(null,bdProdId);       
                 //       system.debug('====PPRxMandateRunTime==== :: '+PPRxMandateRunTime.size());       
                  //      system.debug('====PPRxMandateRunTime==== :: '+PPRxMandateRunTime);         
                    }
                }
                catch(Exception ex){
                     system.debug('Exception caught: '+ex.getLineNumber()+'- '+ex.getMessage());
                    
                }
                return null; 
            }
     /**
     * This method is used to save the plandebenefits
    */     
  public pageReference saveAndContemp(){         
        pageReference pgRef = null;     
        boolean isModified = false;     
     //   System.debug('++++++grouperWrapList++++'+grouperWrapList);      
    //    system.debug('@@ in saveAndCon');
             
        SaveAndContinuePlanBenefits( pp);  
     if(pp.product_category__c == 'Dental'){
         DentalBenupdate(pp);          
     }    
        return null;//pgRef;        
    }

    /**
     * This method is used to save the plandebenefits and redirect to AIA_BenefitDEsign_Review page
    */
    public pageReference saveAndCon(){
        try{
            pageReference pgRef = null;
            boolean isModified = false;
         //   System.debug('++++++grouperWrapList++++'+grouperWrapList);
    
          //  system.debug('@@ in saveAndCon');
            SaveAndContinuePlanBenefits(pp);
           if(pp.product_category__c == 'Dental'){
            DentalBenupdate(pp);     
            }
            pgRef = new pageReference('/apex/AIA_BenefitDEsign_Review');
    
            pgRef.getParameters().put('planId',pp.Plan_Name__c);
    
    
            pgRef.getParameters().put('id',bdProdId);
            pgRef.setRedirect(true);
            return pgRef;
        }
        catch(DMLException dex){
            system.debug('Exception caught: '+dex.getLineNumber()+'- '+dex.getMessage());
           showError = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, dex.getMessage() +'--'+ dex.getDmlMessage(0));
                        ApexPages.addMessage(myMsg);
           
        }
        catch (Exception ex){
             system.debug('Exception caught: '+ex.getLineNumber()+'- '+ex.getMessage());
             showError = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage());
                        ApexPages.addMessage(myMsg);
        }
        return null;
    }
/**
     * This method is used get the data from Grouper and forma a groupwrapper and add to the wrapper list
    */
public void createListFromPPTemp(String bdProdId, Boolean isReview){        
    grouperWrapList = new List<GrouperWrapper>();       
  //  System.debug('+++++grpId+='+grpId);     
      for(AIA_Grouper__c grp: [Select id, Name,IsCovered__c,Grouper_Record_Type__c , DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c,  
                      OON_IsCovered__c, OON_DeductibleApplies__c, OON_AnnualMaximumApplies__c, OON_DavisString__c, OON_CoInsurance__c,OON_CoInsurance_Low__c,OON_CoInsurance_High__c,OON_CoInsurance_Increment__c,OON_CoInsurance_AddIncrement__c,OON_CoInsurance_InvalidIncrement__c 
                      From AIA_Grouper__c Where Benefit_Design_Product__c =: bdProdId AND Group_Type__c = 'Benefit Group'        
        order by Sequence_Number__c ]){      
        GrouperWrapper grpNameWrapObj = new GrouperWrapper(grp, grouperWrapList.size());        
        grouperWrapList.add(grpNameWrapObj);     

       
}       
}

    Map<String,AIA_Grouper__c> ExistingBRFGrouper= new  Map<String,AIA_Grouper__c>();  
    Map<String,Map<String,AIA_Benefits__c>> ExistingBRFGrouperBenefits= new  Map<String,Map<String,AIA_Benefits__c>>();
    Map<String,MAp<String,Limitations__c>> mapBenlmt = new Map<String,MAp<String,Limitations__c>> ();

    /**
     * This method is used get the data from Grouper Based on BDP and put vaues in ExistingBRFGrouperBenefits and mapBenlmt
     * ExistingBRFGrouperBenefits is map where Key as Group Name and Value as AIA_Benefits__c
     * mapBenlmt is map where Key as Benefit__r.benefit_name__C+' - '+obj.Benefit__r.Benefit_Type__c and Value as Limitations__c
    */
    public void createListBDPExisting(String bdProdId) {
        grouperWrapList = new List<GrouperWrapper>();
        
         List<AIA_Grouper__c> planGrouperBenList = [Select id, Name,IsCovered__c,Grouper_Record_Type__c , DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c  ,
                 OON_IsCovered__c, OON_DeductibleApplies__c, OON_AnnualMaximumApplies__c, OON_DavisString__c, OON_CoInsurance__c,OON_CoInsurance_Low__c,OON_CoInsurance_High__c,OON_CoInsurance_Increment__c,OON_CoInsurance_AddIncrement__c,OON_CoInsurance_InvalidIncrement__c ,
                 (Select id,Name, Benefit_Name__c,    Benefit_Record_Type__c,
                OON_CoInsurance_AmountValueSelected__c, Copay_Min_Payment__c,CoInsurance_AmountValueSelected__c,
                OON_Copay_Type_1_IsCovered__c,Copay_Type_1_IsCovered__c,Copay_Type_1_DeductibleApplies__c,OON_Copay_Min_Payment__c,OON_Copay_Max_Payment__c,
                OON_Copay_Type_1_DefaultAmount__c,Copay_Type_1_AmountValueSelected__c,Copay_Type_2_AmountValueSelected__c,OON_Copay_AmountLow__c, OON_Copay_AmountHigh__c,  
                OON_Copay_Type_1_AmountValueSelected__c,Copay_Type_1_Mandate_Name__c,Copay_Type_1_Jurisdiction__c,Copay_Type_1_Benefit_Comment_Codes__c,
                OON_Copay_Type_2_AmountValueSelected__c,OON_Copay_Type_1_DeductibleApplies__c,  Benefit_Type__c , Sequence_Number__c,Sequence_Number_SF__c,
                IS_ASO_Only__c, Mandate_Yes_No__c, Tier_type__c,IN_CostShare_3Month_DeductibleCarryover__c,ON_CostShare_3Month_DeductibleCarryover__c,Cost_Share_Type__c,
                Discount_Amount__c, ScheduledAmounts__c, Allowed_Amount__c,Discount_Amount_Percent__c, Discount_Applies__c, OON_Discount_Applies__c, //T08 Vision fields added
                OON_Allowed_Amount__c, OON_ScheduledAmounts__c,OON_Discount_Amount__c, OON_Discount_Amount_Percent__c,AnnualMaximumApplies__c,OON_AnnualMaximumApplies__c  //T08 Vision fields added
                ,OON_Coinsurance_AmountLow__c,OON_Coinsurance_AmountHigh__c, OON_Coinsurance_AmountIncrement__c, OON_Coinsurance_AddtionalIncrements__c, OON_Coinsurance_InvalidIncrements__c,
                Coinsurance_AmountLow__c, Coinsurance_AmountHigh__c, Coinsurance_AmountIncrement__c, Coinsurance_Amount_AddtionalIncrements__c, Coinsurance_Amount_InvalidIncrements__c
                ,INN_MandateLockDownInd__c, INN_MappingBRFBenefitID__c, ONN_MappingBRFBenefitID__c, ONN_MandateLockDownInd__c  
                ,IN_Approximate_Member_Payment_w_Discount__c,IN_Approx_Member_Payment_w_Disc_Default__c,
                ON_Approximate_Member_Payment_w_Discount__c,ON_Approx_Member_Payment_w_Disc_Default__c from Benefit__r Order by Sequence_Number_SF__c asc) 
                From AIA_Grouper__c 
                Where Benefit_Design_Product__c =: bdProdId AND Group_Type__c = 'Benefit Group' order by Sequence_Number__c];
        Set<Id> bnfId = new Set<Id>();

        for(AIA_Grouper__c groupObj : planGrouperBenList) {
            ExistingBRFGrouper.put(groupObj.name, groupObj);
            MAp<String,AIA_Benefits__c> benset= new  MAp<String,AIA_Benefits__c>();

            for(AIA_Benefits__c benObj : groupObj.Benefit__r) {

                bnfId.add(benObj.id);
                if(benObj.Benefit_Type__c=='Benefit')
                    benset.put(benObj.Benefit_Name__c,benobj);
                else if(benObj.Benefit_Type__c!='Benefit')
                    benset.put(benObj.Benefit_Name__c+' - '+benObj.Benefit_Type__c,benobj);
           //     system.debug('adding limitation==='+benObj.Benefit_Name__c);

            }
            if(benset.size()>0)
                ExistingBRFGrouperBenefits.put(groupObj.name, benset);
        }
        List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c,Benefit_Type__c, Benefit__r.benefit_name__C,Benefit__r.Benefit_Type__c,comment_codes__c, IsSelected__c, Jurisdiction__c, 
                                                                MaxAge_Selected__c, MaxDuration_Selected__c, TierAge_Selected__c, TierLimit_Selected__c,OldMax_TierVal__c,
                                                                MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c, 
                                                               MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
                                                               MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,  
                                                               MaxDuration__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, 
                                                               TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
                                                               TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c, RecordType__c ,Effective_Date__c, Term_Date__c, 
                                                               TierLimitTo__c, TierLimitType__c, Type__c, MaxRow_Value__c,IS_ASO_Only__c, Tier_Value__c, Code__c, IsRequired__c , ParentBenefitName__c,CommentType__c
                                                               FROM Limitations__c where Benefit__c in:bnfId]);
        Map<ID,List<Limitations__c>> maplmt = new Map<Id,List<Limitations__c>>();
        for(Limitations__c obj:lmtsn){
            List<Limitations__c> lmts=new List<Limitations__c>();
            Map<String,Limitations__c> benll=new Map<String,Limitations__c>();
            String key= obj.Benefit__r.benefit_name__C+' - '+obj.Benefit__r.Benefit_Type__c;
            if(maplmt.containsKey(obj.Benefit__c)){
                lmts=maplmt.get(obj.Benefit__c);
                benll=mapBenlmt.get(key);
            }

            lmts.add(obj);
            if(obj.type__c=='MaxRow'|| obj.type__c=='TierLimit' )
                benll.put(obj.OldMax_TierVal__c,obj);
            else
                benll.put(String.valueof(obj.Code__c),obj);


            mapBenlmt.put(key, benll);
            maplmt.put(obj.Benefit__c,lmts);
        }
        System.debug('+++maplmt++++'+maplmt);
        lmtsn.clear();
        planGrouperBenList.clear();
    }

    /**
     * This method is used get the data from Grouper Based on PP and put vaues in grpNameWrapObj
     * grpNameWrapObj is a wrapper class where we store all the values of grouper and limitaions 
     * grouperWrapList is List where it holds the list of grpNameWrapObj wrapper objects
    */
    public void createListFromPP(String bdProdId, Boolean isReview) {
        grouperWrapList = new List<GrouperWrapper>();
        if(pp.Funding_Arrangement__c == 'ASO'){
       List<AIA_Grouper__c> planGrouperBenList = [Select id, Name,Sequence_Number__c,Grouper_Record_Type__c , IsCovered__c, DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c  ,
                 OON_IsCovered__c, OON_DeductibleApplies__c, OON_AnnualMaximumApplies__c, OON_DavisString__c, OON_CoInsurance__c,OON_CoInsurance_Low__c,OON_CoInsurance_High__c,OON_CoInsurance_Increment__c,OON_CoInsurance_AddIncrement__c,OON_CoInsurance_InvalidIncrement__c ,
                 (Select id,Name, Benefit_Name__c,Benefit_Summary_Comment__c, Copay_Type_2_Increment__c ,Copay_Type_2_Additional_Increments__c ,Benefit_Record_Type__c,
                CopayType2_Additional_InvalidIncrement__c,Copay_Type_1_Increment__c , Copay_Type_1_Additional_Increments__c ,Copay_Type_1_AdditionalInvalidIncrements__c,
                Coinsurance_DefaultAmount__c, OON_Coinsurance_DefaultAmount__c,OON_CoInsurance_AmountValueSelected__c, Copay_Min_Payment__c,Copay_Type_1_Mandate_Name__c,
                Copay_Max_Payment__c,Copay_Type_1_High__c , Copay_Type_1_DefaultAmount__c,CoInsurance_AmountValueSelected__c,Copay_Type_1_AliasName__c,Copay_Type_2_High__c , 
                Copay_Type_1_Low__c, Copay_Type_2_Low__c  ,Copay_Type_2_AliasName__c,OON_Copay_Type_1_AliasName__c,OON_Copay_Type_2_AliasName__c,Copay_Type_1_Jurisdiction__c,  
                OON_Copay_Type_2_Additional_Increments__c, OON_Copay2_Low__c, OON_Copay2_High__c,OON_Copay2_Increment__c, OON_Copay2Additional_InvalidIncrements__c, 
                OON_Copay_Type_1_IsCovered__c,Copay_Type_1_IsCovered__c,Copay_Type_1_DeductibleApplies__c,OON_Copay_Min_Payment__c,OON_Copay_Max_Payment__c,
                OON_Copay_Type_1_DefaultAmount__c,Copay_Type_1_AmountValueSelected__c,Copay_Type_2_AmountValueSelected__c,OON_Copay_AmountLow__c, OON_Copay_AmountHigh__c,  
                OON_Copay_Additional_Increments__c, OON_Copay_Additional_InvalidIncrements__c,OON_Copay_AmountIncrement__c, OON_Copay_Type_1_AmountValueSelected__c,
                OON_Copay_Type_2_AmountValueSelected__c,OON_Copay_Type_1_DeductibleApplies__c,  Benefit_Type__c , Sequence_Number__c,Sequence_Number_SF__c, Copay_Type_1_Benefit_Comment_Codes__c
                , IS_ASO_Only__c, Mandate_Yes_No__c  , Tier_type__c ,ON_CostShare_3Month_DeductibleCarryover__c,IN_CostShare_3Month_DeductibleCarryover__c,Cost_Share_Type__c,
                OON_Tier_Type_Default__c, Tier_Type_Default__c, OON_Copay_Default_Max_Payment__c, OON_Copay_Default_Min_Payment__c, Copay_Type_1_Default_IsCovered__c,
                Copay_Type_1_Default_DeductibleApplies__c, Copay_Default_Min_Payment__c, Copay_Default_Max_Payment__c, OON_Copay_Type_1_Default_IsCovered__c,
                OON_Copay_1_Default_DeductibleApplies__c  ,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c,AnnualMaximumApplies__c,OON_AnnualMaximumApplies__c,
                Discount_Amount__c, ScheduledAmounts__c, Allowed_Amount__c,Discount_Amount_Percent__c, Discount_Applies__c, OON_Discount_Applies__c, //T08 Vision fields added
                OON_Allowed_Amount__c, OON_ScheduledAmounts__c,OON_Discount_Amount__c, OON_Discount_Amount_Percent__c, Davis_Benefit_Variable__c  //T08 Vision fields added
                ,OON_Coinsurance_AmountLow__c,OON_Coinsurance_AmountHigh__c, OON_Coinsurance_AmountIncrement__c, OON_Coinsurance_AddtionalIncrements__c, OON_Coinsurance_InvalidIncrements__c,
                Coinsurance_AmountLow__c, Coinsurance_AmountHigh__c, Coinsurance_AmountIncrement__c, Coinsurance_Amount_AddtionalIncrements__c, Coinsurance_Amount_InvalidIncrements__c,
                Allowed_Amount_Default__c,OON_Allowed_Amount_Default__c,Discount_Amount_Default__c,OON_Discount_Amount_Default__c,Discount_Amount_Percent_Default__c,
                OON_Discount_Amount_Percent_Default__c,Discount_Applies_Default__c,OON_Discount_Applies_Default__c,ScheduledAmounts_Default__c,OON_ScheduledAmounts_Default__c
                ,INN_MandateLockDownInd__c, INN_MappingBRFBenefitID__c, ONN_MappingBRFBenefitID__c, ONN_MandateLockDownInd__c   
                ,IN_Approximate_Member_Payment_w_Discount__c,IN_Approx_Member_Payment_w_Disc_Default__c,
                ON_Approximate_Member_Payment_w_Discount__c,ON_Approx_Member_Payment_w_Disc_Default__c  from Benefit__r Order by Sequence_Number_SF__c asc)
                From AIA_Grouper__c 
                Where Benefit_Design_Product__c =: bdProdId AND Group_Type__c = 'Benefit Group' order by Sequence_Number__c];
        Set<Id> bnfId = new Set<Id>();

        for(AIA_Grouper__c groupObj : planGrouperBenList) {
            MAp<String,AIA_Benefits__c> benset= new  MAp<String,AIA_Benefits__c>();

            for(AIA_Benefits__c benObj : groupObj.Benefit__r) {
                if(isReview==true){
                    if( benObj.Benefit_Type__c=='Limitation' || benObj.Benefit_Type__c=='Mandate'  ){
                        if(  benObj.Benefit_Summary_Comment__c!=null && benObj.Benefit_Summary_Comment__c!='' ||
                                ((benObj.Benefit_Summary_Comment__c=='' || benObj.Benefit_Summary_Comment__c==null) 
                                        && benObj.Copay_Type_1_Benefit_Comment_Codes__c=='NA'))
                            bnfId.add(benObj.id);
                    }  
                    else{
                        bnfId.add(benObj.id);
                    }

                }
                else{
                    bnfId.add(benObj.id);
                    benset.put(benObj.Benefit_Name__c,benobj);
           //         system.debug('adding limitation==='+benObj.Benefit_Name__c);
                }

            }
        }
        List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit_Type__c,Benefit__c, Benefit__r.benefit_name__C,Benefit__r.Benefit_Type__c,comment_codes__c, IsSelected__c, Jurisdiction__c, 
                                                               MaxAge_Selected__c, MaxDuration_Selected__c, TierAge_Selected__c, TierLimit_Selected__c,
                                                               MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c, ParentBenefitName__c,
                                                               MaxDuration__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, 
                                                               MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
                                                               MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,  
                                                               TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
                                                               TierAgeFrom__c, TierAgeTo__c, TierAgeType__c,IS_ASO_Only__c, TierLimitDurationType__c, TierLimitFrom__c, RecordType__c ,
                                                               TierLimitTo__c, TierLimitType__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c,Effective_Date__c, Term_Date__c,CommentType__c   
                                                               FROM Limitations__c where Benefit__c in:bnfId]);
        Map<ID,List<Limitations__c>> maplmt = new Map<Id,List<Limitations__c>>();
        for(Limitations__c obj:lmtsn){
            List<Limitations__c> lmts=new List<Limitations__c>();
            Map<String,Limitations__c> benll=new Map<String,Limitations__c>();
            if(maplmt.containsKey(obj.Benefit__c)){
                lmts=maplmt.get(obj.Benefit__c);
                benll=mapBenlmt.get(obj.Benefit__r.benefit_name__C+' - '+obj.Benefit__r.Benefit_Type__c );
            }
            if(isReview==true){
                if((obj.IsSelected__c==true && obj.Type__c == 'Comment' ) || (obj.Type__c != 'Comment' && (obj.MaxAge_Selected__c == true || obj.MaxDuration_Selected__c == true || obj.TierAge_Selected__c == true || obj.TierLimit_Selected__c == true) ))  {
                    lmts.add(obj);
                  }  
            }
            
        else if(obj.Recordtype__c == 'BRF' && (obj.IsSelected__c==true && obj.Type__c == 'Comment' ) || (obj.Type__c != 'Comment' && (obj.MaxAge_Selected__c == true || obj.MaxDuration_Selected__c == true || obj.TierAge_Selected__c == true || obj.TierLimit_Selected__c == true) )) {       
        lmts.add(obj);  
        }   
        else if(obj.Recordtype__c != 'BRF'){
        lmts.add(obj);
        
               
                if((obj.type__c=='MaxRow' || obj.type__c=='TierLimit' )&& obj.MaxRow_Value__c!=null  )
                    benll.put(obj.MaxRow_Value__c,obj);
                else
                    benll.put(String.valueof(obj.Code__c),obj);
            }
            if(isReview==false) 
                mapBenlmt.put(obj.Benefit__r.benefit_name__C+' - '+obj.Benefit__r.Benefit_Type__c , benll);
            maplmt.put(obj.Benefit__c,lmts);
        }
        System.debug('+++maplmt++++'+maplmt);
        for(AIA_Grouper__c groupObj : planGrouperBenList) {
            GrouperWrapper grpNameWrapObj = new GrouperWrapper();

            grpNameWrapObj.aiaGrouper = groupObj;
            List<BenifitsrWrapper> benWrapList = new List<BenifitsrWrapper>();

            for(AIA_Benefits__c benObj : groupObj.Benefit__r) {
                if(benobj.Copay_Type_1_AliasName__c!='' && benobj.Copay_Type_1_AliasName__c!=null)
                    grpNameWrapObj.Inpcpval= benobj.Copay_Type_1_AliasName__c;
                if(benobj.Copay_Type_2_AliasName__c!='' && benobj.Copay_Type_2_AliasName__c!=null)
                    grpNameWrapObj.Inspcpval= benobj.Copay_Type_2_AliasName__c;
                if(benobj.OON_Copay_Type_1_AliasName__c!='' && benobj.OON_Copay_Type_1_AliasName__c!=null)
                    grpNameWrapObj.OUTpcpval= benobj.OON_Copay_Type_1_AliasName__c;
                if(benobj.OON_Copay_Type_2_AliasName__c!='' && benobj.OON_Copay_Type_2_AliasName__c!=null)
                    grpNameWrapObj.Outspcpval= benobj.OON_Copay_Type_2_AliasName__c;

                BenifitsrWrapper benWrapObj = new BenifitsrWrapper();
                if(maplmt.containsKey(benObj.id)){
                    benWrapObj.benifitNameStr = benObj.Benefit_Name__c;
                 //   System.debug('++maplmt.get(benObj.id)++++'+maplmt.get(benObj.id));
                    benWrapObj.lstlimit = maplmt.get(benObj.id);
                    benWrapObj.lstJurisdictions = getjurdictions(benWrapObj.lstlimit);
                }
                else{
                    benWrapObj.benifitNameStr = benObj.Benefit_Name__c;
                }

                benWrapObj.aiaBenifitObj = benObj;
                if(bnfId.contains(benObj.Id))
                    benWrapList.add(benWrapObj);
            }
            grpNameWrapObj.benifitWrapList = benWrapList;
            grouperWrapList.add(grpNameWrapObj);

        }
        planGrouperBenList=null;
        maplmt=null;
        lmtsn=null;
        bnfId=null;
     //   system.debug('@@grouperWrapList line 478'+grouperWrapList);
    }
         if(pp.Funding_Arrangement__c == 'Risk'){
        List<AIA_Grouper__c> planGrouperBenList = [Select id, Name,Sequence_Number__c,Grouper_Record_Type__c , IsCovered__c, DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c  ,
                 OON_IsCovered__c, OON_DeductibleApplies__c, OON_AnnualMaximumApplies__c, OON_DavisString__c, OON_CoInsurance__c,OON_CoInsurance_Low__c,OON_CoInsurance_High__c,OON_CoInsurance_Increment__c,OON_CoInsurance_AddIncrement__c,OON_CoInsurance_InvalidIncrement__c ,
                 (Select id,Name, Benefit_Name__c,Benefit_Summary_Comment__c, Copay_Type_2_Increment__c ,Copay_Type_2_Additional_Increments__c ,Benefit_Record_Type__c,
                CopayType2_Additional_InvalidIncrement__c,Copay_Type_1_Increment__c , Copay_Type_1_Additional_Increments__c ,Copay_Type_1_AdditionalInvalidIncrements__c,
                Coinsurance_DefaultAmount__c, OON_Coinsurance_DefaultAmount__c,OON_CoInsurance_AmountValueSelected__c, Copay_Min_Payment__c,Copay_Type_1_Mandate_Name__c,
                Copay_Max_Payment__c,Copay_Type_1_High__c , Copay_Type_1_DefaultAmount__c,CoInsurance_AmountValueSelected__c,Copay_Type_1_AliasName__c,Copay_Type_2_High__c , 
                Copay_Type_1_Low__c, Copay_Type_2_Low__c  ,Copay_Type_2_AliasName__c,OON_Copay_Type_1_AliasName__c,OON_Copay_Type_2_AliasName__c,Copay_Type_1_Jurisdiction__c,  
                OON_Copay_Type_2_Additional_Increments__c, OON_Copay2_Low__c, OON_Copay2_High__c,OON_Copay2_Increment__c, OON_Copay2Additional_InvalidIncrements__c, 
                OON_Copay_Type_1_IsCovered__c,Copay_Type_1_IsCovered__c,Copay_Type_1_DeductibleApplies__c,OON_Copay_Min_Payment__c,OON_Copay_Max_Payment__c,
                OON_Copay_Type_1_DefaultAmount__c,Copay_Type_1_AmountValueSelected__c,Copay_Type_2_AmountValueSelected__c,OON_Copay_AmountLow__c, OON_Copay_AmountHigh__c,  
                OON_Copay_Additional_Increments__c, OON_Copay_Additional_InvalidIncrements__c,OON_Copay_AmountIncrement__c, OON_Copay_Type_1_AmountValueSelected__c,
                OON_Copay_Type_2_AmountValueSelected__c,OON_Copay_Type_1_DeductibleApplies__c,  Benefit_Type__c , Sequence_Number__c,Sequence_Number_SF__c, 
                Copay_Type_1_Benefit_Comment_Codes__c
                , IS_ASO_Only__c, Mandate_Yes_No__c , Tier_type__c ,ON_CostShare_3Month_DeductibleCarryover__c,IN_CostShare_3Month_DeductibleCarryover__c,Cost_Share_Type__c,
                OON_Tier_Type_Default__c, Tier_Type_Default__c, OON_Copay_Default_Max_Payment__c, OON_Copay_Default_Min_Payment__c, Copay_Type_1_Default_IsCovered__c,
                Copay_Type_1_Default_DeductibleApplies__c, Copay_Default_Min_Payment__c, Copay_Default_Max_Payment__c, OON_Copay_Type_1_Default_IsCovered__c,
                OON_Copay_1_Default_DeductibleApplies__c  ,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c,
                Discount_Amount__c, ScheduledAmounts__c, Allowed_Amount__c,Discount_Amount_Percent__c, AnnualMaximumApplies__c,OON_AnnualMaximumApplies__c, Discount_Applies__c, OON_Discount_Applies__c, //T08 Vision fields added
                OON_Allowed_Amount__c, OON_ScheduledAmounts__c,OON_Discount_Amount__c, OON_Discount_Amount_Percent__c,Davis_Benefit_Variable__c  //T08 Vision fields added
                ,OON_Coinsurance_AmountLow__c,OON_Coinsurance_AmountHigh__c,Davis_Benefit_Variable_Default__c,Davis_Variable_customized__c, OON_Coinsurance_AmountIncrement__c, OON_Coinsurance_AddtionalIncrements__c, OON_Coinsurance_InvalidIncrements__c,
                Coinsurance_AmountLow__c, Coinsurance_AmountHigh__c, Coinsurance_AmountIncrement__c, Coinsurance_Amount_AddtionalIncrements__c, Coinsurance_Amount_InvalidIncrements__c,
                Allowed_Amount_Default__c,OON_Allowed_Amount_Default__c,Discount_Amount_Default__c,OON_Discount_Amount_Default__c,Discount_Amount_Percent_Default__c,
                OON_Discount_Amount_Percent_Default__c,Discount_Applies_Default__c,OON_Discount_Applies_Default__c,ScheduledAmounts_Default__c,OON_ScheduledAmounts_Default__c
                ,INN_MandateLockDownInd__c, INN_MappingBRFBenefitID__c, ONN_MappingBRFBenefitID__c, ONN_MandateLockDownInd__c  
                ,IN_Approximate_Member_Payment_w_Discount__c,IN_Approx_Member_Payment_w_Disc_Default__c,
                ON_Approximate_Member_Payment_w_Discount__c,ON_Approx_Member_Payment_w_Disc_Default__c
                from Benefit__r 
                where IS_ASO_Only__c= false Order by Sequence_Number_SF__c asc) 
        From AIA_Grouper__c Where Benefit_Design_Product__c =: bdProdId AND Group_Type__c = 'Benefit Group' order by Sequence_Number__c];
        Set<Id> bnfId = new Set<Id>();

        for(AIA_Grouper__c groupObj : planGrouperBenList) {
            MAp<String,AIA_Benefits__c> benset= new  MAp<String,AIA_Benefits__c>();

            for(AIA_Benefits__c benObj : groupObj.Benefit__r) {
                if(isReview==true){
                    if( benObj.Benefit_Type__c=='Limitation' || benObj.Benefit_Type__c=='Mandate'  ){
                        if(  benObj.Benefit_Summary_Comment__c!=null && benObj.Benefit_Summary_Comment__c!='' ||
                                ((benObj.Benefit_Summary_Comment__c=='' || benObj.Benefit_Summary_Comment__c==null) 
                                        && benObj.Copay_Type_1_Benefit_Comment_Codes__c=='NA'))
                            bnfId.add(benObj.id);
                    }  
                    else{
                        bnfId.add(benObj.id);
                    }

                }
                else{
                    bnfId.add(benObj.id);
                    benset.put(benObj.Benefit_Name__c,benobj);
            //        system.debug('adding limitation==='+benObj.Benefit_Name__c);
                }

            }
        }
        List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c,Benefit_Type__c, Benefit__r.benefit_name__C,Benefit__r.Benefit_Type__c,comment_codes__c, IsSelected__c, Jurisdiction__c, 
                                                               MaxAge_Selected__c, MaxDuration_Selected__c, TierAge_Selected__c, TierLimit_Selected__c,
                                                               MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c, ParentBenefitName__c,
                                                               MaxDuration__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, 
                                                               MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
                                                               MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,  
                                                               TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
                                                               TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c, RecordType__c ,CommentType__c,
                                                               TierLimitTo__c, TierLimitType__c,IS_ASO_Only__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c, Effective_Date__c, Term_Date__c  
                                                               FROM Limitations__c where IS_ASO_Only__c = false and Benefit__c in:bnfId]);
        Map<ID,List<Limitations__c>> maplmt = new Map<Id,List<Limitations__c>>();
        for(Limitations__c obj:lmtsn){
            List<Limitations__c> lmts=new List<Limitations__c>();
            Map<String,Limitations__c> benll=new Map<String,Limitations__c>();
            if(maplmt.containsKey(obj.Benefit__c)){
                lmts=maplmt.get(obj.Benefit__c);
                benll=mapBenlmt.get(obj.Benefit__r.benefit_name__C+' - '+obj.Benefit__r.Benefit_Type__c );
            }
            if(isReview==true){
                if((obj.IsSelected__c==true && obj.Type__c == 'Comment' ) || (obj.Type__c != 'Comment' && (obj.MaxAge_Selected__c == true || obj.MaxDuration_Selected__c == true || obj.TierAge_Selected__c == true || obj.TierLimit_Selected__c == true) ))  {
                    lmts.add(obj);
                  }  
            }
            
            else if(obj.Recordtype__c == 'BRF' && (obj.IsSelected__c==true && obj.Type__c == 'Comment' ) || (obj.Type__c != 'Comment' && (obj.MaxAge_Selected__c == true || obj.MaxDuration_Selected__c == true || obj.TierAge_Selected__c == true || obj.TierLimit_Selected__c == true) )) {       
        lmts.add(obj);  
        }   
        else if(obj.Recordtype__c != 'BRF'){
        lmts.add(obj);
        
               
                if((obj.type__c=='MaxRow' || obj.type__c=='TierLimit' )&& obj.MaxRow_Value__c!=null  )
                    benll.put(obj.MaxRow_Value__c,obj);
                else
                    benll.put(String.valueof(obj.Code__c),obj);
            }
            if(isReview==false) 
                mapBenlmt.put(obj.Benefit__r.benefit_name__C+' - '+obj.Benefit__r.Benefit_Type__c , benll);
            maplmt.put(obj.Benefit__c,lmts);
        }
      //  System.debug('+++maplmt++++'+maplmt);
        for(AIA_Grouper__c groupObj : planGrouperBenList) {
            GrouperWrapper grpNameWrapObj = new GrouperWrapper();

            grpNameWrapObj.aiaGrouper = groupObj;
            List<BenifitsrWrapper> benWrapList = new List<BenifitsrWrapper>();

            for(AIA_Benefits__c benObj : groupObj.Benefit__r) {
                if(benobj.Copay_Type_1_AliasName__c!='' && benobj.Copay_Type_1_AliasName__c!=null)
                    grpNameWrapObj.Inpcpval= benobj.Copay_Type_1_AliasName__c;
                if(benobj.Copay_Type_2_AliasName__c!='' && benobj.Copay_Type_2_AliasName__c!=null)
                    grpNameWrapObj.Inspcpval= benobj.Copay_Type_2_AliasName__c;
                if(benobj.OON_Copay_Type_1_AliasName__c!='' && benobj.OON_Copay_Type_1_AliasName__c!=null)
                    grpNameWrapObj.OUTpcpval= benobj.OON_Copay_Type_1_AliasName__c;
                if(benobj.OON_Copay_Type_2_AliasName__c!='' && benobj.OON_Copay_Type_2_AliasName__c!=null)
                    grpNameWrapObj.Outspcpval= benobj.OON_Copay_Type_2_AliasName__c;

                BenifitsrWrapper benWrapObj = new BenifitsrWrapper();
                if(maplmt.containsKey(benObj.id)){
                    benWrapObj.benifitNameStr = benObj.Benefit_Name__c;
              //      System.debug('++maplmt.get(benObj.id)++++'+maplmt.get(benObj.id));
                    benWrapObj.lstlimit = maplmt.get(benObj.id);
                    benWrapObj.lstJurisdictions = getjurdictions(benWrapObj.lstlimit);
                }
                else{
                    benWrapObj.benifitNameStr = benObj.Benefit_Name__c;
                }

                benWrapObj.aiaBenifitObj = benObj;
                if(bnfId.contains(benObj.Id))
                    benWrapList.add(benWrapObj);
            }
            grpNameWrapObj.benifitWrapList = benWrapList;
            grouperWrapList.add(grpNameWrapObj);

        }
        planGrouperBenList=null;
        maplmt=null;
        lmtsn=null;
        bnfId=null;
   //     system.debug('@@grouperWrapList line 478'+grouperWrapList);
        }   
    }
/**
     * This method is used update the dental realted grouper      *
    */
public void DentalBenupdate(AIA_Benefit_Design_Product__c pp){      
  List<AIA_Benefits__c> DentalBenFinalList = new List<AIA_Benefits__c>();       
  List<AIA_Grouper__c> DentalGrpList       = new List<AIA_Grouper__c>();        
  List<AIA_Benefits__c> DentalBenList      = new List<AIA_Benefits__c>();       
  string ppid = pp.id;          
  string BenefitGroup = 'Benefit Group';        
  string rtype = 'BDD';
  string Benefit = 'Benefit';     
  if(pp.product_category__c == 'Dental'){       
     String DentalGrpStr = QueryBase2.getSobjectAllFieldsSOQL('AIA_Grouper__c', 'Benefit_Design_Product__c=:ppid and Group_Type__c =:BenefitGroup and Grouper_Record_Type__c=:rtype');      
     DentalGrpList = database.query(DentalGrpStr);      
            
     String DentalBenStr = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('AIA_Benefits__c', 'Grouper__r.Benefit_Design_Product__c=:ppid and Grouper__r.Grouper_Record_Type__c=:rtype  and Type__c =:Benefit and Benefit_Type__c =:Benefit','Grouper__r.id, ');        
     DentalBenList = database.query(DentalBenStr);      
            
     for(AIA_Grouper__c DentalGrp:DentalGrpList){       
       for(AIA_Benefits__c DentalBen:DentalBenList){        
          if(DentalBen.Grouper__r.id == DentalGrp.id){      
                 DentalBen.CoInsurance_AmountValueSelected__c = DentalGrp.CoInsurance__c;       
                 DentalBen.Copay_Type_1_IsCovered__c= DentalGrp.IsCovered__c;       
                 DentalBen.Copay_Type_1_DeductibleApplies__c = DentalGrp.DeductibleApplies__c;      
                 DentalBen.AnnualMaximumApplies__c = DentalGrp.AnnualMaximumApplies__c;     
                        
                        
                 DentalBen.OON_CoInsurance_AmountValueSelected__c= DentalGrp.OON_CoInsurance__c;        
                 DentalBen.OON_Copay_Type_1_IsCovered__c= DentalGrp.OON_IsCovered__c;       
                 DentalBen.OON_Copay_Type_1_DeductibleApplies__c= DentalGrp.OON_DeductibleApplies__c;       
                 DentalBen.OON_AnnualMaximumApplies__c= DentalGrp.OON_AnnualMaximumApplies__c;      
                    DentalBenFinalList.add(DentalBen);          
                  }     
                    
             }          
            if(DentalBenFinalList.size()>0)     
            update DentalBenFinalList;      
         }      
        
      }     
        
  }  


    /**
     * This method is used All the values of AIA_Plan_Benefits__c,AIA_Plan_Grouper__c,AIA_Plan_Limitation__c,AIA_Plan_Benefit_Comment_Codes__c to Wrapper class and all wrapper record the list of wrapper class *
    */
    public  void createWrapListFromPlan(AIA_Benefit_Design_Product__c pp) {
        grouperWrapList = new List<GrouperWrapper>();
        Map<String,AIA_Plan_Benefits__c> MapGrouperBenefitsNet=new Map<String,AIA_Plan_Benefits__c>();
        Map<id, CopayTypeWrapper> copayBenMap = new Map<id, CopayTypeWrapper>();
        jurisdictionFrmPP = pp.BRF_Juridiction__c;
   //     System.debug('+++++jurisdictionFrmPP ++'+jurisdictionFrmPP );
        String  planIdStr = String.valueof(pp.Plan_Name__c).left(15);
        createListBDPExisting(pp.id);
        getGroupersFromPlan(planIdStr,'BDD');
        MapGrouperBenefitsNet = getBenefitsForPlan(planIdStr,'BDD');
        // MAP: Benifit Id, 2 Copay Records
   //     System.debug('++++++++++++benefitIdSet++++++++++++++'+benefitIdSet);   

        copayBenMap = getCopaysFromPlan();
    
    Map<String,List<Limitations__c>> ParentBenLimitationMan = new   Map<String,List<Limitations__c>>();
    Map<String,List<Limitations__c>> ParentBenLimitationLimit = new   Map<String,List<Limitations__c>>();
        Map<String,Map<String,List<Limitations__c>>> planLimitationmap = getPlanLimitation();
     //   system.debug(LoggingLevel.INFO,'planLimitationmap---'+planLimitationmap);
        if(planLimitationmap != null)
        {
            if(planLimitationmap.containsKey('ParentBenLimitationMan'))
                ParentBenLimitationMan = planLimitationmap.get('ParentBenLimitationMan');
            if(planLimitationmap.containsKey('ParentBenLimitationLimit'))
                ParentBenLimitationLimit = planLimitationmap.get('ParentBenLimitationLimit');
        }
        
        getPlanCommentCodes(ParentBenLimitationLimit,ParentBenLimitationMan);
     //   system.debug(LoggingLevel.INFO,'createWrapListFromPlan--ParentBenLimitationLimit---'+ParentBenLimitationLimit);
         String QueryStr=QueryBase2.getSobjectAllFieldsSOQL('AIA_Plan__c', 'Id=:planId');
                List<AIA_Plan__c> lstAIA_Plan = new List<AIA_Plan__c>();
                 lstAIA_Plan = database.query(QueryStr);
                 if(lstAIA_Plan != null && lstAIA_Plan.size()>0)
                 {
                    NoOfNW = lstAIA_Plan[0].CountOfNetworks__c;
                }
        FormatDataFromPlanIntoWrapper(pp,ParentBenLimitationLimit,ParentBenLimitationMan,MapGrouperBenefitsNet,copayBenMap);
      //   system.debug(LoggingLevel.INFO,'createWrapListFromPlan--FormatDataFromPlanIntoWrapper---'+ParentBenLimitationLimit);
    }

    /*Indira code for Groupers from plan*/
    /**
     * This method is used get all the plan grouper assosiated to the planid and benefit group type
    */
    public void getGroupersFromPlan(String planid,string Rtype){

     //   system.debug('================inside getGroupersFromPlan  =========');
          List<AIA_Plan_Grouper__c> grprListToClr = [Select id, Name, Sequence_Number__c,Record_Type__c,ISExisting_Grouper__c, Plan_Network__c,Type__c, Plan_Network__r.Name, Plan_Network__r.InNetwork__c,
                                                    IsCovered__c, PCS_Grouper_Id__c, DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, Plan_Network__r.OON_OutNetwork__c,
                                                      CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c  
                                                   From AIA_Plan_Grouper__c Where PlanId__c=:planid AND Type__c = 'Benefit Group' 
                                                       AND Record_Type__c =:Rtype Order By Sequence_Number__c,Plan_Network__r.Name]; 
   //     system.debug('================inside getGroupersFromPlan  ========='+grprListToClr.size());
       
        for( AIA_Plan_Grouper__c groupObj : grprListToClr ) {
            if(!groupNameSet.contains(groupObj.Name)) {
                planGrouperBenList.add(groupObj);
                groupNameSet.add(groupObj.Name);
            }
            pgroupersID.add(groupObj.id);
            String grpname= groupObj.Name+'_'+(groupObj.Plan_Network__r.Name.contains('In')?'In':'Out');
            PlanMapGrouper.put(grpname,groupObj);
        }
     //   System.debug('+++++grprListToClr ++'+grprListToClr.size());
        grprListToClr.clear();
        }
        
    

    /**
     * This method is used get all the Benefits based on planid
    */
    public Map<String,AIA_Plan_Benefits__c> getBenefitsForPlan(String planid,string Rtype){
        Map<String,AIA_Plan_Benefits__c> MapGrouperBenefitsNet=new Map<String,AIA_Plan_Benefits__c>();
        List<AIA_Plan_Benefits__c>  benifitObjlist= [Select id,Parent_Benefit_Name__c, Benefit_Name__c,Benefit_Group__r.Sequence_Number__c,Benefit_Group__r.Name,Record_Type__c, Name, Sequence_Number__c ,Coinsurance_DefaultAmount__c , 
                                                     Variation_Condition_ID__c,PCS_Benefit_Id__c, Benefit_Group__c, Benefit_Group__r.Plan_Network__c, Benefit_Group__r.Plan_Network__r.Name ,ISExisting_Benefit__c,
                                                     IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c, Cost_Share_Type__c, Three_Month_Deductible_Carryover__c,Davis_Benefit_Variable__c
                                                     from AIA_Plan_Benefits__c 
                                                     Where Plan__c = :planid AND Record_Type__c =:Rtype and Type__c='Benefit' and  Benefit_Group__c in :pgroupersID
                                                     Order By  Benefit_Group__r.Sequence_Number__c,Sequence_Number__c ];
    //    System.debug('+++++benifitObj list size ++'+benifitObjlist.size());
        pgroupersID.clear();
        for( AIA_Plan_Benefits__c benifitObj : benifitObjlist) {
       //     System.debug('+++++benifitObj ++'+benifitObj);

            benefitIdSet.add(benifitObj.id);

            String key=benifitObj.Benefit_Group__r.Name+'_'+benifitObj.Benefit_Name__c+'_'+(benifitObj.Benefit_Group__r.Plan_Network__r.Name.contains('In')?'In':'Out');
            if(!MapGrouperBenefitsNet.containsKey(key)) 
                MapGrouperBenefitsNet.put(key,benifitObj);

            set<String> st= new set<String>();
            String grpname=benifitObj.Benefit_Group__r.Name;


            if(AllGrpParentBenName.containsKey(grpname)) 
            {
                st=AllGrpParentBenName.get(grpname);
            }
            if(!st.contains(benifitObj.Parent_Benefit_Name__c)) {
                st.add(benifitObj.Parent_Benefit_Name__c);
       //         system.debug('grpname----'+grpname+'--benifitObj.Parent_Benefit_Name__c--'+benifitObj.Parent_Benefit_Name__c);
            }
            AllGrpParentBenName.put(grpname,st);

            st= new set<String>();                                     
            String parbenname=benifitObj.Parent_Benefit_Name__c;

            if(AllParentBenName.containsKey(parbenname)){
                st=AllParentBenName.get(parbenname);
            }
            if(!st.contains(benifitObj.Benefit_Name__c)) {
                st.add(benifitObj.Benefit_Name__c);
          //      system.debug('parbenname----'+parbenname+'--benifitObj.Benefit_Name__c--'+benifitObj.Benefit_Name__c);
            }
            AllParentBenName.put(parbenname,st);                               
        }                                     

        System.debug('++++++++AllGrpParentBenName+++'+AllGrpParentBenName); 
        System.debug('++++++++AllParentBenName+++'+AllParentBenName);
        System.debug('++++++++benifitNetworkMap+++'+benefitIdSet.size());  

        benifitObjlist.clear();
        return MapGrouperBenefitsNet;
    }

    Map<String,AIA_Plan_Copay_Type__c> ParentBenifitMandateName= new Map<String,AIA_Plan_Copay_Type__c>();
    /**
     * This method is used get all the Copays  based on planid
    */
    public Map<id, CopayTypeWrapper> getCopaysFromPlan(){
        List<AIA_Plan_Copay_Type__c> copTypeList= new  List<AIA_Plan_Copay_Type__c>();
        List<AIA_Plan_Copay_Type__c> copTypeList2= new  List<AIA_Plan_Copay_Type__c>();
        Map<id, CopayTypeWrapper> copayBenMap = new Map<id, CopayTypeWrapper>();



        copTypeList= [Select id,Name,AliasName__c, Allowed_Amount__c,AnnualMaximumApplies__c,Benefit_Sequence_Number__c,CoinsuranceAmount__c,Copay_Additional_Increments__c,
                    CopayAmount__c,Copay_High__c,Copay_Increment__c,Copay_Low__c,Copay_Sequence_Number__c,DeductibleApplies__c,Discount_Amount__c,Discount_Amount_Percent__c,
                    DiscountApplies__c,Discount_Applies__c,Effective_Date__c,ExtID__c,Grouper_Name__c,IsASOOnly__c,IsCovered__c,Jurisdiction__c,Jurisdiction_for_BRF__c,
                    MandateIndicator__c,MandateName__c,MaxPayAmount__c,MinPayAmount__c,Plan_Benefits__c,PlanID__c,ScheduledAmounts__c,Approximate_Member_Payment_w_Discount__c,Term_Date__c,TierType__c,
                    Plan_Benefits__r.benefit_name__C,Plan_Benefits__r.Parent_Benefit_Name__c,Copay_Additional_InvalidIncrements__c,Plan_Benefits__r.IS_ASO_Only__c,
                    Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c,Plan_Benefits__r.Davis_Benefit_Variable__c,
                    Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c,
                    Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c 
                    ,Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c 
                      from AIA_Plan_Copay_Type__c 
                      Where Plan_Benefits__c IN: benefitIdSet and
                      (jurisdiction__c = 'Federal' OR jurisdiction__c = 'FD')
                      order by   Plan_Benefits__r.benefit_name__C];


          If(pp.Product_Category__c =='Drug' ){
     
        copTypeList2= [Select id,Name,Plan_Benefits__c,Plan_Benefits__r.benefit_name__C,MandateName__c ,Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,
                       MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,  Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c ,AnnualMaximumApplies__c, 
                       Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c
                       , IsASOOnly__c  ,Plan_Benefits__r.IS_ASO_Only__c,  Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c
                       ,Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c, Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c  
                       , Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c  
                       from AIA_Plan_Copay_Type__c 
                       Where Plan_Benefits__c IN: benefitIdSet and jurisdiction__c != 'Federal' and jurisdiction__c != 'FD' 
                       AND ( (MandateIndicator__c = 'Yes' AND Jurisdiction_for_BRF__c=:jurisdictionFrmPP) OR 
                               MandateIndicator__c = 'No' OR  MandateIndicator__c = '' )
                               order by   Plan_Benefits__r.benefit_name__C,Copay_Sequence_Number__c desc];
                               }
                               
      else if( pp.Product_Category__c =='Medical' )  {
           copTypeList2= [Select id,Name,Plan_Benefits__c,Plan_Benefits__r.benefit_name__C,MandateName__c ,Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,
                       MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,  Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c , AnnualMaximumApplies__c,
                       Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c
                       , IsASOOnly__c  ,Plan_Benefits__r.IS_ASO_Only__c,  Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c
                        ,Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c, Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c  
                        , Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c 
                          from AIA_Plan_Copay_Type__c 
                          Where Plan_Benefits__c IN: benefitIdSet and jurisdiction__c != 'Federal' and jurisdiction__c != 'FD'
                       AND ( (MandateIndicator__c = 'Yes' AND Jurisdiction_for_BRF__c=:jurisdictionFrmPP) OR 
                               MandateIndicator__c = 'No' )
                               order by   Plan_Benefits__r.benefit_name__C,Copay_Sequence_Number__c desc];
                               }
            else if( pp.Product_Category__c =='Vision' )  { //T08 added section for Vision
                    copTypeList2= [Select id,Name,Plan_Benefits__c,Plan_Benefits__r.benefit_name__C,MandateName__c ,Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,
                                    MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,  Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c , AnnualMaximumApplies__c,
                                    Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c
                                    , IsASOOnly__c  ,Plan_Benefits__r.IS_ASO_Only__c,  Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c,
                                    Discount_Amount__c, ScheduledAmounts__c, Approximate_Member_Payment_w_Discount__c,Allowed_Amount__c,Discount_Amount_Percent__c , Discount_Applies__c, Plan_Benefits__r.Davis_Benefit_Variable__c //T07 Vision fields added
                                    ,Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c, Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c 
                                    , Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c 
                                   from AIA_Plan_Copay_Type__c 
                                   Where Plan_Benefits__c IN: benefitIdSet and jurisdiction__c != 'Federal' and jurisdiction__c != 'FD'
                                    AND ( (MandateIndicator__c = 'Yes' AND Jurisdiction_for_BRF__c=:jurisdictionFrmPP) OR 
                                    MandateIndicator__c = 'No' OR  MandateIndicator__c = '' )
                                    order by   Plan_Benefits__r.benefit_name__C,Copay_Sequence_Number__c desc];
            }
              else if( pp.Product_Category__c =='Dental' )  {      
            copTypeList2= [Select id,Name,Plan_Benefits__c,Plan_Benefits__r.benefit_name__C,MandateName__c ,Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,     
                            MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,Plan_Benefits__r.IS_ASO_Only__c, IsASOOnly__c, Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c ,       
                            Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c, ExtID__c       
                            , Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c,AnnualMaximumApplies__c 
                             ,Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c, Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c 
                            , Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c 
                           from AIA_Plan_Copay_Type__c 
                           Where Plan_Benefits__c IN: benefitIdSet and jurisdiction__c != 'Federal'  and jurisdiction__c != 'FD'    
                            AND ( (MandateIndicator__c = 'Yes' AND Jurisdiction_for_BRF__c=:jurisdictionFrmPP) OR       
                            MandateIndicator__c = 'No'  OR  MandateIndicator__c = '' )      
                            order by   Plan_Benefits__r.benefit_name__C,Copay_Sequence_Number__c desc];         
            }   

        copTypeList.addAll(copTypeList2);
        for(AIA_Plan_Copay_Type__c copType : copTypeList)
        {
            System.debug('++++copType++'+copType +'=====benefit name ====='+copType.Plan_Benefits__r.benefit_name__C);
            CopayTypeWrapper ct= new CopayTypeWrapper(); 
            if(copayBenMap.containsKey(copType.Plan_Benefits__c)){
                ct=copayBenMap.get(copType.Plan_Benefits__c);
            }
            else{
                ct= new CopayTypeWrapper();
            }
            if( ct.copayTypeSelectedObj.id==null) {  
                AIA_Plan_Copay_Type__c c1= new AIA_Plan_Copay_Type__c();
                String key=copType.Plan_Benefits__r.Parent_Benefit_Name__c;
                if(!ParentBenifitMandateName.containsKey(key) && copType.MandateName__c!='' && copType.MandateName__c!=null )
                    ParentBenifitMandateName.put(key,copType );
                c1=copType;
                ct.copayTypeSelectedObj =c1;
                CopayIDs.add(copType.id);
                system.debug('ct1===='+ct);
            }
            else  if(ct.copayTypePecSpecObj.id==null ) {
                Boolean isprev=false;
               // if( ct.copayTypeSelectedObj.jurisdiction__c=='Federal' && ct.copayTypeSelectedObj.jurisdiction__c== copType.jurisdiction__c  )
               if( ct.copayTypeSelectedObj.jurisdiction__c=='Federal' || ct.copayTypeSelectedObj.jurisdiction__c=='FD' )
                    isprev=true;
                else   if( ct.copayTypeSelectedObj.jurisdiction__c!='Federal' && ct.copayTypeSelectedObj.jurisdiction__c!='FD' && ct.copayTypeSelectedObj.MandateIndicator__c=='Yes' 
                    && ct.copayTypeSelectedObj.MandateIndicator__c== copType.MandateIndicator__c &&
                    ct.copayTypeSelectedObj.Jurisdiction_for_BRF__c== copType.Jurisdiction_for_BRF__c  )

                    isprev=true;
                else if( ct.copayTypeSelectedObj.jurisdiction__c!='Federal' && ct.copayTypeSelectedObj.jurisdiction__c!='FD' && ct.copayTypeSelectedObj.MandateIndicator__c=='No' 
                    && ct.copayTypeSelectedObj.MandateIndicator__c== copType.MandateIndicator__c  )
                    isprev=true;
                else
                    isprev=false;
                if(isprev==true)
                {
                    AIA_Plan_Copay_Type__c c1= new AIA_Plan_Copay_Type__c();
                    c1=copType;
                    ct.copayTypePecSpecObj =c1;
                    system.debug('ct2===='+ct);
                    CopayIDs.add(copType.id);
                }
            }     
            system.debug('+++++++ct3===='+ct);
            copayBenMap.put(copType.Plan_Benefits__c, ct);
        }
        System.debug('+++++copayBenMap++++'+copayBenMap);    

        copTypeList.clear();
        copTypeList2.clear();
        return copayBenMap;
    }

    /**
     * This method is used get all the Plan Limitaions and fill the values in the  maps
    */
    public Map<String,Map<String,List<Limitations__c>>> getPlanLimitation(){
    Map<String,List<Limitations__c>> ParentBenLimitationMan = new   Map<String,List<Limitations__c>>();
    Map<String,List<Limitations__c>> ParentBenLimitationLimit = new   Map<String,List<Limitations__c>>();
    Map<String,Map<String,List<Limitations__c>>> limitaionMap = new Map<String,Map<String,List<Limitations__c>>>();
     List<AIA_Benefit_Design_Product__c> ppList = [Select id,PPACA_Status__c,Plan_Name__r.Plan_Id__c,Has_Benefit_Details__c,Plan_Name__c,Plan_Product_Name__c , Funding_Arrangement__c,Product_Category__c,Benefit_Design__c,BRF_Juridiction__c,
                                           Proposed_Products__r.Benefit_Request_Form__r.Benefit_Effective_Date__c, Proposed_Products__r.Benefit_Request_Form__r.Jurisdiction__c 
                                           from AIA_Benefit_Design_Product__c Where id =: bdProdId];
      
                 
        AIA_Benefit_Design_Product__c pplimit = pplist[0];
        Date PPEffDate = pplimit.Proposed_Products__r.Benefit_Request_Form__r.Benefit_Effective_Date__c;
        jurpp = pplimit.Proposed_Products__r.Benefit_Request_Form__r.Jurisdiction__c;
        system.debug('+++++PPEffDate++++'+PPEffDate);

        List<AIA_Plan_Limitation__c> PLimitTION = [select MandateName__c, Plan_Benefits__r.Name,Plan_Benefits__r.Benefit_Name__c,Plan_Benefits__r.Parent_Benefit_Name__c,MaxAgeType__c ,Plan_Benefits__r.Benefit_Group__c,Type__c,
                                                   Jurisdiction__c,TierLimitType__c,MandateIndicator__c,MaxRow_Mandate_Description__c,Plan_Benefits__r.Grouper_Name__c, Effective_Date__c, Term_Date__c ,
                                                   MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
                                                   MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,  Plan_Benefits__r.Variation_Condition_ID__c, Plan_Benefits__r.PCS_Benefit_Id__c,
                                                   TierLimitDurationType__c,MaxRow_Value__c,Tier_Value__c,MaxAgeTo__c ,MaxValue__c,TierAgeTo__c,TierLimitFrom__c ,TierAgeType__c ,TierAgeFrom__c,TierLimitTo__c ,MaxApply__c,
                                                   MaxType__c,MaxDuration__c,MaxDurationType__c,MaxAgeFrom__c ,Plan_Benefits__r.IS_ASO_Only__c,IS_ASO_Only__c, ParentBenefitName__c from AIA_Plan_Limitation__c 
                                                   where Plan_Benefits__c in:benefitIdSet and Effective_Date__c <=:PPEffDate AND Term_Date__c >=:PPEffDate order by Plan_Benefits__r.Parent_Benefit_Name__c,MandateIndicator__c desc,type__c];
            
        for(AIA_Plan_Limitation__c obj:PLimitTION){
            System.debug('++++limitationEffective_Date__c++'+obj.Effective_Date__c );
            
            System.debug('++++limitationTerm_Date__c++'+obj.Term_Date__c ); 
             System.debug('++++limitationBRFEffDate++'+BRFEffDate   ); 
            AIA_Benefits__c existBen=  new AIA_Benefits__c();

            System.debug('++++limitation++'+obj);
            PlanLimitIDs.add(obj.id);

            String limitBenParentName=obj.Plan_Benefits__r.Parent_Benefit_Name__c;
            Set<String> benlimit=new Set<String>();
            String ltype= '';
            String benlimitname=obj.Plan_Benefits__r.Parent_Benefit_Name__c;    
            if(pp.funding_Arrangement__c == 'ASO')
            {
                //system.debug(LoggingLevel.INFO,'AIA_Plan_Limitation__c---'+obj);
                if(obj.MandateIndicator__c==true){
                    ltype='M';
                    benlimitname=benlimitname +' - Mandate';
                }else if(obj.MandateIndicator__c==false){
                    ltype='L';
                    benlimitname=benlimitname +' - Limitation'; 
                }
            }
            if(pp.funding_Arrangement__c == 'Risk')
            {
                if(obj.MandateIndicator__c==true && (obj.Jurisdiction__c == 'Federal' || obj.Jurisdiction__c == 'FD' || obj.Jurisdiction__c==jurisdictionFrmPP)){
                    ltype='M';
                    benlimitname=benlimitname +' - Mandate';
                }else if(obj.MandateIndicator__c==false){
                    ltype='L';
                    benlimitname=benlimitname +' - Limitation';
                }
                
            }
            set<String> st= new Set<String>();
            Boolean does_Exist=false;
            Boolean BenPresent=false;
            Limitations__c tempLimit= new Limitations__c();
            System.debug('++++obj.IS_ASO_Only__c++'+obj.IS_ASO_Only__c);
            if(obj.IS_ASO_Only__c != null && obj.IS_ASO_Only__c != '')
            {
                if(obj.IS_ASO_Only__c == 'No' || obj.IS_ASO_Only__c == 'N')
                    tempLimit.IS_ASO_Only__c=false;
                if(obj.IS_ASO_Only__c == 'Yes' || obj.IS_ASO_Only__c == 'Y')
                    tempLimit.IS_ASO_Only__c=true;
            }
            if(obj.Type__c =='TierLimit'  && obj.Tier_Value__c!=null && obj.Tier_Value__c!=''){
                System.debug('++++TierLimit++'+obj.Tier_Value__c);
                 tempLimit.ParentBenefitName__c = obj.ParentBenefitName__c;

                if(benLimitsAllMap.containsKey(limitBenParentName)){
                    st=benLimitsAllMap.get(limitBenParentName);
                }
                if(!st.contains(obj.Tier_Value__c + obj.MandateIndicator__c + obj.Jurisdiction__c)){
                    st.add(obj.Tier_Value__c + obj.MandateIndicator__c + obj.Jurisdiction__c);
                    if(ExistingBRFGrouperBenefits.size()>0 && ExistingBRFGrouperBenefits.containskey(obj.Plan_Benefits__r.Grouper_Name__c) && ExistingBRFGrouperBenefits.get(obj.Plan_Benefits__r.Grouper_Name__c).containskey(benlimitname)){

                        if(mapbenlmt.size()>0 && mapbenlmt.containsKey(benlimitname) && mapbenlmt.get(benlimitname).containskey(obj.Tier_Value__c)){
 							tempLimit =mapbenlmt.get(benlimitname).get(obj.Tier_Value__c);
                            does_Exist=true;
                        }
                        BenPresent=true;
                        tempLimit.Benefit__c=ExistingBRFGrouperBenefits.get(obj.Plan_Benefits__r.Grouper_Name__c).get(benlimitname).id;
                    }
                    if( does_Exist==false){
                        
                        if(obj.TierAgeFrom__c!=null && obj.TierAgeType__c!='' && obj.TierAgeType__c!=null)
                            tempLimit.TierAgeFrom__c=obj.TierAgeFrom__c;
                        if(obj.TierAgeTo__c!=null && obj.TierAgeType__c!='' && obj.TierAgeType__c!=null)
                            tempLimit.TierAgeTo__c=obj.TierAgeTo__c;
                        else
                            tempLimit.TierAgeTo__c=null;
                        tempLimit.TierAgeType__c=obj.TierAgeType__c;
                        tempLimit.TierLimitDurationType__c=obj.TierLimitDurationType__c;
                        if(obj.TierLimitFrom__c!=null && obj.TierLimitType__c!='' && obj.TierLimitType__c!=null)
                            tempLimit.TierLimitFrom__c=obj.TierLimitFrom__c;
                        else 
                            tempLimit.TierLimitFrom__c=null;
                        if(obj.TierLimitTo__c!=null && obj.TierLimitType__c!='' && obj.TierLimitType__c!=null)
                            tempLimit.TierLimitTo__c=obj.TierLimitTo__c;
                        else
                            tempLimit.TierLimitTo__c=null;
                        tempLimit.TierLimitType__c=obj.TierLimitType__c;
                        tempLimit.OldMax_TierVal__c=obj.Tier_Value__c;
                        //T17-start
                        tempLimit.MandateName__c = obj.MandateName__c;
                        //T17-End
                        tempLimit.Type__c=obj.Type__c;
                        tempLimit.IsSelected__c=true;
                        tempLimit.MaxAgeFrom__c=null;
                        tempLimit.MaxAgeTo__c=null;
                        tempLimit.MaxValue__c=null;
                        tempLimit.MaxDuration__c=null;
                        tempLimit.Recordtype__c='BDD';
                        tempLimit.Variation_Condition_ID__c = obj.Plan_Benefits__r.Variation_Condition_ID__c;
                        tempLimit.PCS_Benefit_Id__c = obj.Plan_Benefits__r.PCS_Benefit_Id__c;
                        IF(!(STRING.isblank(obj.Jurisdiction__c))){
                         tempLimit.Jurisdiction__c = obj.Jurisdiction__c;
                        }
                        tempLimit.Effective_Date__c = obj.Effective_Date__c;        
                        tempLimit.Term_Date__c = obj.Term_Date__c;
                        
                       // tempLimit.TierLimit_Selected__c = true;
                       // tempLimit.TierAge_Selected__c = true;
                       // tempLimit.MaxDuration_Selected__c = true;
                       // tempLimit.MaxAge_Selected__c = true; 
                        tempLimit.TierLimit_Selected_Value__c = '';
                        tempLimit.TierAge_Selected_Value__c  = '';
                        
                if(obj.TierLimitFrom__c!=null)
                    tempLimit.TierLimit_Selected_Value__c += obj.TierLimitFrom__c + ' ';
                if(obj.TierLimitFrom__c!=null && obj.TierLimitTo__c!=null)
                    tempLimit.TierLimit_Selected_Value__c += 'to' + ' ';
                if(obj.TierLimitTo__c!=null)
                    tempLimit.TierLimit_Selected_Value__c += obj.TierLimitTo__c + ' ';  
                if(obj.TierLimitType__c!=null)
                    tempLimit.TierLimit_Selected_Value__c += obj.TierLimitType__c + ' ';
                if(obj.TierLimitDurationType__c!=null)
                    tempLimit.TierLimit_Selected_Value__c += obj.TierLimitDurationType__c;
                
                if(obj.TierAgeFrom__c!=null)
                    tempLimit.TierAge_Selected_Value__c += obj.TierAgeFrom__c + ' ';
                if(obj.TierAgeFrom__c!=null && obj.TierAgeTo__c!=null)
                    tempLimit.TierAge_Selected_Value__c += 'to' + ' ';
                if(obj.TierAgeTo__c!=null)
                    tempLimit.TierAge_Selected_Value__c += obj.TierAgeTo__c + ' ';  
                if(obj.TierAgeType__c!=null)
                    tempLimit.TierAge_Selected_Value__c += obj.TierAgeType__c; 
                
               if( tempLimit.TierLimit_Selected_Value__c !='' || tempLimit.TierLimit_Selected_Value__c!=null)
                   tempLimit.TierLimit_Selected__c = true;
               if( tempLimit.TierAge_Selected_Value__c !='' || tempLimit.TierAge_Selected_Value__c!=null)    
                   tempLimit.TierAge_Selected__c = true;     
                        
                       if( obj.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || obj.Plan_Benefits__r.IS_ASO_Only__c == 'Y'){
                       
                       tempLimit.IS_ASO_Only__c= true;
                       }
                        if( obj.Plan_Benefits__r.IS_ASO_Only__c == 'No' || obj.Plan_Benefits__r.IS_ASO_Only__c == 'N'){
                       
                       tempLimit.IS_ASO_Only__c= false;
                       }
                    }

                }
                benLimitsAllMap.put(limitBenParentName, st);
            } else if(obj.Type__c =='MaxRow' && obj.MaxRow_Value__c!=null && obj.MaxRow_Value__c!=''){
                 tempLimit.ParentBenefitName__c = obj.ParentBenefitName__c;
                if(benLimitsAllMap.containsKey(limitBenParentName)){
                    st=benLimitsAllMap.get(limitBenParentName);

                }
                system.debug('@@@outsideDoes_Exist');
                if(!st.contains(obj.MaxRow_Value__c + obj.MandateIndicator__c + obj.Jurisdiction__c)){
                    st.add(obj.MaxRow_Value__c + obj.MandateIndicator__c + obj.Jurisdiction__c);
//system.debug('@@@Inside::1::Does_Exist');
//system.debug('@@@Inside::1::ExistingBRFGrouperBenefits'+ExistingBRFGrouperBenefits.size());
                    if(ExistingBRFGrouperBenefits.size()>0 && ExistingBRFGrouperBenefits.containskey(obj.Plan_Benefits__r.Grouper_Name__c) 
                            && ExistingBRFGrouperBenefits.get(obj.Plan_Benefits__r.Grouper_Name__c).containskey(benlimitname)){
/*	system.debug('@@@Inside::2::Does_Exist'+obj);
system.debug('@@@Inside::2::Does_Exist MaxRow::'+obj.MaxRow_Value__c);
system.debug('@@@Inside::2::Does_Exist mapbenlmt.get(benlimitname)::'+mapbenlmt.get(benlimitname));
system.debug('@@@Inside::2::Does_Exist mapbenlmt.size()::'+mapbenlmt.size());
system.debug('@@@Inside::2::Does_Exist mapbenlmt.containsKey(benlimitname)::'+mapbenlmt.containsKey(benlimitname));
system.debug('@@@Inside::2::Does_Exist mapbenlmt.get(benlimitname).containskey(obj.MaxRow_Value__c)::'+mapbenlmt.get(benlimitname).containskey(obj.MaxRow_Value__c));
*/
              if(mapbenlmt.size()>0 && mapbenlmt.containsKey(benlimitname) && mapbenlmt.get(benlimitname).containskey(obj.MaxRow_Value__c)){//&& obj.MaxRow_Value__c == mapbenlmt.get(benlimitname).get('99 Hearing Aid Per Breast Per 99 Months=Limitations__c')){
                            tempLimit =mapbenlmt.get(benlimitname).get(obj.MaxRow_Value__c);
                            does_Exist=true;
//system.debug('@@@Inside::3::Does_Exist');
system.debug('@@@Inside::3::Does_Exist:: Limit value::'+tempLimit);
/*system.debug('@@@Inside::3::Does_Exist:: Limit value:OldMax_TierVal__c:'+tempLimit.OldMax_TierVal__c);
system.debug('@@@Inside::3::Does_Exist:: Limit MaxRow_Value__c value::'+mapbenlmt.get(benlimitname).containskey(obj.MaxRow_Value__c));
system.debug('@@@Inside::3::Does_Exist:: Benefit Name::'+ExistingBRFGrouperBenefits.get(obj.Plan_Benefits__r.Grouper_Name__c));
*/
                        }
//system.debug('@@@Inside::4::Does_Exist');
                        BenPresent=true;
                        tempLimit.Benefit__c=ExistingBRFGrouperBenefits.get(obj.Plan_Benefits__r.Grouper_Name__c).get(benlimitname).id;
                    }
//system.debug('@@@Inside::5::Does_Exist Value::'+does_Exist);
                    if(does_Exist==false){
                       // system.debug('@@@Inside::6::Does_Exist::False');
                       // system.debug('@@@Inside::6::Does_Exist::False:: Benefit Name::'+obj.Plan_Benefits__r.Benefit_Name__c);
                        if(obj.MaxAgeFrom__c!=null)
                            tempLimit.MaxAgeFrom__c=obj.MaxAgeFrom__c;
                        if(obj.MaxAgeTo__c!=null)
                            tempLimit.MaxAgeTo__c=obj.MaxAgeTo__c;
                        tempLimit.MaxAgeType__c=obj.MaxAgeType__c;
                        if(obj.MaxDuration__c!=null )
                            tempLimit.MaxDuration__c=obj.MaxDuration__c;
                        tempLimit.MaxApply__c=obj.MaxApply__c;
                        tempLimit.MaxDurationType__c=obj.MaxDurationType__c;
                        tempLimit.MaxType__c=obj.MaxType__c;
                        tempLimit.MaxRow_Mandate_Description__c=obj.MaxRow_Mandate_Description__c;
                        IF(!(STRING.isblank(obj.Jurisdiction__c))){
                         tempLimit.Jurisdiction__c = obj.Jurisdiction__c;
                        }
                        if(obj.MaxValue__c!=null )
                            tempLimit.MaxValue__c=obj.MaxValue__c;
                        tempLimit.TierAgeFrom__c=null;
                        tempLimit.TierAgeTo__c=null;
                        tempLimit.TierLimitTo__c=null;
                        tempLimit.OldMax_TierVal__c=obj.MaxRow_Value__c;
                        tempLimit.Type__c=obj.Type__c;
                        tempLimit.IsSelected__c=true;
                        tempLimit.Recordtype__c='BDD';
                        tempLimit.Effective_Date__c = obj.Effective_Date__c;        
                        tempLimit.Term_Date__c = obj.Term_Date__c;
                        //T17-start
                        tempLimit.MandateName__c = obj.MandateName__c;
                        //T17-End
                        tempLimit.Variation_Condition_ID__c = obj.Plan_Benefits__r.Variation_Condition_ID__c;
                        tempLimit.PCS_Benefit_Id__c = obj.Plan_Benefits__r.PCS_Benefit_Id__c;
                        
                       // tempLimit.TierLimit_Selected__c = true;
                       // tempLimit.TierAge_Selected__c = true;
                       // tempLimit.MaxDuration_Selected__c = true;
                       // tempLimit.MaxAge_Selected__c = true;
                        
                        tempLimit.MaxDuration_Selected_Value__c ='';
                        tempLimit.MaxAge_Selected_Value__c  = '';
                    
                if(obj.MaxValue__c!=null)
                    tempLimit.MaxDuration_Selected_Value__c += obj.MaxValue__c + ' ';
                if(obj.MaxType__c!=null)
                    tempLimit.MaxDuration_Selected_Value__c += obj.MaxType__c + ' ';    
                if(obj.MaxApply__c!=null)
                    tempLimit.MaxDuration_Selected_Value__c += obj.MaxApply__c + ' ';
                if(obj.MaxDuration__c!=null && string.valueof(obj.MaxDuration__c)!='')
                    tempLimit.MaxDuration_Selected_Value__c += 'Per' + ' ';  
                if(obj.MaxDuration__c!=null)
                    tempLimit.MaxDuration_Selected_Value__c += obj.MaxDuration__c + ' ';
                if(obj.MaxDurationType__c!=null)
                    tempLimit.MaxDuration_Selected_Value__c += obj.MaxDurationType__c ;
                    
                if(obj.MaxAgeFrom__c!=null)
                    tempLimit.MaxAge_Selected_Value__c += obj.MaxAgeFrom__c + ' ';
                if(obj.MaxAgeFrom__c!=null && obj.MaxAgeTo__c!=null)
                    tempLimit.MaxAge_Selected_Value__c += 'to' + ' ';
                if(obj.MaxAgeTo__c!=null)
                    tempLimit.MaxAge_Selected_Value__c += obj.MaxAgeTo__c + ' ';    
                if(obj.MaxAgeType__c!=null)
                    tempLimit.MaxAge_Selected_Value__c += obj.MaxAgeType__c ; 
                
                
               if( tempLimit.MaxDuration_Selected_Value__c !='' || tempLimit.MaxDuration_Selected_Value__c !=null)
                   tempLimit.MaxDuration_Selected__c = true;
               if( tempLimit.MaxAge_Selected_Value__c !='' || tempLimit.MaxAge_Selected_Value__c !=null)    
                   tempLimit.MaxAge_Selected__c = true;      

                                        
                        //RG update 5/15 Start
                        tempLimit.MaxDuration_High__c  = obj.MaxDuration_High__c;
                        tempLimit.MaxDuration_Increment__c  = obj.MaxDuration_Increment__c ;
                        tempLimit.MaxDuration_Low__c  = obj.MaxDuration_Low__c;
                        tempLimit.MaxDuration_Range__c  = obj.MaxDuration_Range__c;
                        tempLimit.MaxDuration_Valid_Ranges__c  = obj.MaxDuration_Valid_Ranges__c;
                        tempLimit.MaxRange_Type__c  = obj.MaxRange_Type__c;
                        tempLimit.MaxValue_High__c  = obj.MaxValue_High__c;
                        tempLimit.MaxValue_Increment__c  = obj.MaxValue_Increment__c;
                        tempLimit.MaxValue_Low__c  = obj.MaxValue_Low__c;
                        tempLimit.MaxValue_Range__c  = obj.MaxValue_Range__c;
                        tempLimit.MaxValue_Valid_Ranges__c  = obj.MaxValue_Valid_Ranges__c;
                        tempLimit.MaxRow_InValid_Ranges__c  = obj.MaxRow_InValid_Ranges__c;
                        //T17 - Start
                        tempLimit.MandateName__c = obj.MandateName__c;
                        //T17 - End
                        tempLimit.Variation_Condition_ID__c = obj.Plan_Benefits__r.Variation_Condition_ID__c;
                        tempLimit.PCS_Benefit_Id__c = obj.Plan_Benefits__r.PCS_Benefit_Id__c;
                        
                        //RG 5/15 Update End  
                         if( obj.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || obj.Plan_Benefits__r.IS_ASO_Only__c == 'Y'){
                       
                       tempLimit.IS_ASO_Only__c= true;
                       }
                        if( obj.Plan_Benefits__r.IS_ASO_Only__c == 'No' || obj.Plan_Benefits__r.IS_ASO_Only__c == 'N'){
                       
                       tempLimit.IS_ASO_Only__c= false;
                       }
                    }

                }
                benLimitsAllMap.put(limitBenParentName, st);
            } 
            //system.debug(LoggingLevel.INFO,'benLimitsAllMap-1--'+benLimitsAllMap);
            //system.debug(LoggingLevel.INFO,'tempLimit.Type__c-1--'+tempLimit.Type__c);
            //system.debug(LoggingLevel.INFO,'tltype--'+ltype);
            List<Limitations__c> ls= new List<Limitations__c>();
            if( tempLimit.Type__c!='' && tempLimit.Type__c!=null && tempLimit!=null){
                if(ltype=='L'){
                    if(ParentBenLimitationLimit.containsKey(limitBenParentName))
                        ls=ParentBenLimitationLimit.get(limitBenParentName);
                    else
                        ls= new List<Limitations__c>();

                        ls.add(tempLimit);
                        ParentBenLimitationLimit.put(limitBenParentName,ls); 
                }else if(ltype=='M'){
                    if(ParentBenLimitationMan.containsKey(limitBenParentName))
                        ls=ParentBenLimitationMan.get(limitBenParentName);
                    else
                        ls= new List<Limitations__c>();
                        ls.add(tempLimit);
                        ParentBenLimitationMan.put(limitBenParentName,ls); 
                }
            }
            //system.debug(LoggingLevel.INFO,'ParentBenLimitationMan1--Inside'+ParentBenLimitationMan);
            //system.debug(LoggingLevel.INFO,'ParentBenLimitationLimit--Inside'+ParentBenLimitationMan);
        }
        PLimitTION.clear();
        
     //   system.debug(LoggingLevel.INFO,'ParentBenLimitationMan1---'+ParentBenLimitationMan);
     //   system.debug(LoggingLevel.INFO,'ParentBenLimitationLimit-1--'+ParentBenLimitationLimit);
        limitaionMap.put('ParentBenLimitationMan',ParentBenLimitationMan);
        limitaionMap.put('ParentBenLimitationLimit',ParentBenLimitationLimit);
    //    system.debug(LoggingLevel.INFO,'limitaionMap-1--'+limitaionMap);
        return limitaionMap;
    }
    /**
     * This method is used get all the Comment codes  and fill the values in the  maps
    */
    public void getPlanCommentCodes(Map<String,List<Limitations__c>> ParentBenLimitationLimit , Map<String,List<Limitations__c>> ParentBenLimitationMan){

        Map<String, Set<String>> parentMandateCodemap=new Map<String, Set<String>>();
        //Beging Change for 11/7/2016|
        //updating the code to handle the Comment codes for ASO and Risk separately
        List<AIA_Plan_Benefit_Comment_Codes__c> PlanCommentCodes= new List<AIA_Plan_Benefit_Comment_Codes__c> ();
        List<AIA_Plan_Benefit_Comment_Codes__c> PlanCommentCodesf= new List<AIA_Plan_Benefit_Comment_Codes__c> ();
      //  system.debug(LoggingLevel.INFO,'First-1--');
        /*************T01 --- Start****************/
        If(pp.Funding_Arrangement__c=='Risk')
        PlanCommentCodes=  [select id,name, PCS_Benefit_Id__c,Variation_Condition_ID__c, Plan_Benefit_Grouper_Name__c,Type__c,FundingArrangement__c,Plan_Benefit_Parent_Name__c,IsMandateTrue__c,
                            Plan_Limitation__r.MandateIndicator__c,Code__c,Comment__c, Plan_Limitation__r.ParentBenefitName__c,
                            Jurisdiction__c, Is_Required__c,Plan_Copay_Type__c,ParentBenefitName__c, IS_ASO_Only__c,Plan_Limitation__r.IS_ASO_Only__c,Plan_Limitation__c,Limitation_Type__c
                            ,Plan_Limitation__r.Plan_Benefits__r.IS_ASO_Only__c,Plan_Limitation__r.Effective_Date__c, Plan_Limitation__r.Term_Date__c,Plan_Limitation__r.Plan_Benefits__c from AIA_Plan_Benefit_Comment_Codes__c 
                            where  (Is_Required__c=true AND (Plan_Limitation__c in :PlanLimitIDs) AND FundingArrangement__c = 'Risk' AND jurisdiction__c=:jurpp)
        order by Plan_Benefit_Parent_Name__c,Sequence_Number__c desc,Code__c ];  
        else{
            PlanCommentCodes=  [select id,name,PCS_Benefit_Id__c,Variation_Condition_ID__c,Plan_Benefit_Grouper_Name__c,Plan_Benefit_Parent_Name__c,IsMandateTrue__c,type__c,FundingArrangement__c,ParentBenefitName__c,
                                Plan_Limitation__r.MandateIndicator__c,Code__c,Comment__c, Plan_Limitation__r.IS_ASO_Only__c, Plan_Limitation__r.ParentBenefitName__c,
                                Jurisdiction__c, IS_ASO_Only__c,Is_Required__c,Plan_Copay_Type__c,Plan_Limitation__c,Limitation_Type__c, ExtID__c,Plan_Limitation__r.Effective_Date__c, Plan_Limitation__r.Term_Date__c,
                                Plan_Limitation__r.Plan_Benefits__r.IS_ASO_Only__c
                                ,Plan_Limitation__r.Plan_Benefits__c 
                                from AIA_Plan_Benefit_Comment_Codes__c 
                                where  (Plan_Limitation__c in :PlanLimitIDs  )
            order by Plan_Benefit_Parent_Name__c,Sequence_Number__c desc,Code__c ]; 

        }

//system.debug(LoggingLevel.INFO,'comm.Code__c==--' + PlanCommentCodes);
//system.debug(LoggingLevel.INFO,'benLimitsAllMap==--' + benLimitsAllMap);
      //      system.debug(LoggingLevel.INFO,'mapbenlmt==--' + mapbenlmt);
      //      system.debug(LoggingLevel.INFO,'ParentBenLimitationMan==--' + ParentBenLimitationMan);
      //      system.debug(LoggingLevel.INFO,'ParentBenLimitationLimit==--' + ParentBenLimitationLimit);
      //      system.debug(LoggingLevel.INFO,'ExistingBRFGrouperBenefits==--' + ExistingBRFGrouperBenefits);
      //      system.debug(LoggingLevel.INFO,'ParentBenLimitationLimit==--' + ParentBenLimitationLimit);
        //  /*************T01 --- End****************/
        for(AIA_Plan_Benefit_Comment_Codes__c comm:PlanCommentCodes)  {

            Limitations__c tempLimit= new Limitations__c();
       //     system.debug('====comm.Plan_Limitation__r.IS_ASO_Only__c====='+comm.Plan_Limitation__r.IS_ASO_Only__c );
              String commBenParentName=comm.Plan_Benefit_Parent_Name__c;
             tempLimit.ParentBenefitName__c = comm.ParentBenefitName__c;
            
          
        
            Boolean does_Exist=false;
            Boolean BenPresent=false;
            String benlimitname='';  
           
           

            if(comm.Type__c == 'Mandate')
                benlimitname=commBenParentName +' - Mandate';
            else 
                benlimitname=commBenParentName +' - Limitation';
                


         //   system.debug('====benlimitname====='+benlimitname);
            
            
            Set<String> ls=new Set<String>();
            if( benLimitsAllMap.containsKey(commBenParentName)){
                ls=benLimitsAllMap.get(commBenParentName);
            }
            if(!ls.contains(String.valueOF(comm.Code__c) + comm.Type__c)){
                ls.add(String.valueOF(comm.Code__c) + comm.Type__c);
                system.debug('=====has existing comment CODE::'+ comm.Code__c + ' ::TYPE::'+ comm.Type__c);
                if(ExistingBRFGrouperBenefits.containskey(comm.Plan_Benefit_Grouper_Name__c) && ExistingBRFGrouperBenefits.get(comm.Plan_Benefit_Grouper_Name__c).containskey(benlimitname)){
					system.debug('=====has existing comment ExistingBRFGrouperBenefits.get(comm.Plan_Benefit_Grouper_Name__c)===='+ExistingBRFGrouperBenefits.get(comm.Plan_Benefit_Grouper_Name__c));
                    system.debug('=====has existing comment mapbenlmt.size()===='+mapbenlmt.size());
                    system.debug('=====has existing comment mapbenlmt.containsKey(benlimitname)===='+mapbenlmt.containsKey(benlimitname));
                    system.debug('=====has existing comment mapbenlmt.get(benlimitname)===='+mapbenlmt.get(benlimitname));
                    system.debug('=====has existing comment benlimitname===='+benlimitname);
                    
                    if(mapbenlmt.size()>0 && mapbenlmt.containsKey(benlimitname) && mapbenlmt.get(benlimitname).containskey(String.valueof(comm.Code__c))){
                        tempLimit =mapbenlmt.get(benlimitname).get(String.valueOF(comm.Code__c));
                        does_Exist=true;
                       // if(tempLimit.IsSelected__c==false)
                         //   tempLimit.Recordtype__c='BDD';
                        system.debug('=====has existing comment===='+tempLimit.RecordType__c);
                    }
                    BenPresent=true;
                    tempLimit.Benefit__c=ExistingBRFGrouperBenefits.get(comm.Plan_Benefit_Grouper_Name__c).get(benlimitname).id;
                }
                if(does_Exist==false){
                    tempLimit.Code__c=String.valueOF(comm.Code__c) ;
                    tempLimit.comment_codes__c=comm.Comment__c;
                    tempLimit.IsRequired__c= comm.Is_Required__c;
                    tempLimit.type__c='Comment';
                    tempLimit.Recordtype__c='BDD';
                    tempLimit.IsSelected__c=comm.Is_Required__c;
                    tempLimit.CommentType__c = comm.type__c;
                    //t16 - start added variation condition id and pcs benefit id for benefit type limitation
                    tempLimit.Variation_Condition_ID__c=comm.Variation_Condition_ID__c;
                    tempLimit.PCS_Benefit_Id__c=comm.PCS_Benefit_Id__c;
                    //t16 - end
                    //T14-start Added Funding Arrangement
                   tempLimit.FundingArrangement__c = comm.FundingArrangement__c;
                     //T14-End
                    IF(!(STRING.isblank(comm.Jurisdiction__c))){
                    tempLimit.Jurisdiction__c = comm.Jurisdiction__c;
                    }
                    tempLimit.ParentBenefitName__c = comm.ParentBenefitName__c;
                    if(comm.Plan_Limitation__r.Effective_Date__c!=null){        
                    tempLimit.Effective_Date__c = comm.Plan_Limitation__r.Effective_Date__c;        
                    }       
                  if(comm.Plan_Limitation__r.Term_Date__c!=null){       
                    tempLimit.Term_Date__c = comm.Plan_Limitation__r.Term_Date__c;      
                    }
                     if( comm.Plan_Limitation__r.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || comm.Plan_Limitation__r.Plan_Benefits__r.IS_ASO_Only__c == 'Y'){
                       
                       tempLimit.IS_ASO_Only__c= true;
                       }
                      if( comm.Plan_Limitation__r.Plan_Benefits__r.IS_ASO_Only__c == 'No' || comm.Plan_Limitation__r.Plan_Benefits__r.IS_ASO_Only__c == 'N'){
                       
                       tempLimit.IS_ASO_Only__c= false;
                       }  
                   
                   
               
                    
           //         system.debug('=====doo not existing comment===='+tempLimit.RecordType__c);
                }

            }     
            benLimitsAllMap.put(commBenParentName, ls);
            
            List<Limitations__c> limtls= new List<Limitations__c>();
            Set<String> codesd=new   Set<String>();
            if( tempLimit.Type__c!='' && tempLimit.Type__c!=null && tempLimit!=null){
            /*    if(pp.funding_arrangement__c == 'Risk')
                {
                    if(comm.IsMandateTrue__c==true && comm.FundingArrangement__c == 'Risk'){
                        if(ParentBenLimitationMan.containsKey(commBenParentName)){
                            codesd=parentMandateCodemap.get(commBenParentName);
                            limtls=(ParentBenLimitationMan.get(commBenParentName));
                        }
                        else{
                            limtls= new List<Limitations__c>();
                            codesd=new Set<String>();
                        }
                        system.debug('comm.Code__c==='+comm.Code__c);
                        if(comm!=null && comm.Code__c!=null && codesd!=null)
                            codesd.add(String.valueof(comm.Code__c));
                        limtls.add(tempLimit);
                        parentMandateCodemap.put(commBenParentName, codesd);
                        ParentBenLimitationMan.put(commBenParentName,limtls); 
                    }else if(comm.IsMandateTrue__c==false){
                        if(ParentBenLimitationLimit.containsKey(commBenParentName))
                            limtls=(ParentBenLimitationLimit.get(commBenParentName));
                        else
                            limtls= new List<Limitations__c>();
                            if(parentMandateCodemap.containsKey(commBenParentName)) {
                                if( !parentMandateCodemap.get(commBenParentName).contains(String.valueof(comm.Code__c)))
                                    limtls.add(tempLimit);
                            }
                            else
                                limtls.add(tempLimit);

                            ParentBenLimitationLimit.put(commBenParentName,limtls); 
                    }
                }
                else if(pp.funding_arrangement__c == 'ASO')
                { */
                    if(comm.Type__c =='Mandate'){
                        
                        if(ParentBenLimitationMan.containsKey(commBenParentName)){
                            codesd=parentMandateCodemap.get(commBenParentName);
                            limtls=(ParentBenLimitationMan.get(commBenParentName));
                        }
                        else{
                            limtls= new List<Limitations__c>();
                            codesd=new Set<String>();
                        }
                        
                        system.debug('comm.Code__c==='+comm.Code__c);
                        if(comm!=null && comm.Code__c!=null && codesd!=null)
                            codesd.add(String.valueof(comm.Code__c));
                        limtls.add(tempLimit);
                        
                        parentMandateCodemap.put(commBenParentName, codesd);
                        ParentBenLimitationMan.put(commBenParentName,limtls); 
                        
                    }else if(comm.Type__c !='Mandate'){
              //          system.debug(LoggingLevel.INFO,'ParentBenLimitationLimit==--' + ParentBenLimitationLimit);
              //          system.debug(LoggingLevel.INFO,'parentMandateCodemap==--' + parentMandateCodemap);
              //          system.debug(LoggingLevel.INFO,'Step1==--');
                        if(ParentBenLimitationLimit.containsKey(commBenParentName))
                            limtls=(ParentBenLimitationLimit.get(commBenParentName));
                        else
                            limtls= new List<Limitations__c>();
                        
               //         system.debug(LoggingLevel.INFO,'Step2==--');
               //         system.debug(LoggingLevel.INFO,'Step2-1==--' + parentMandateCodemap.containsKey(commBenParentName));
               //         system.debug(LoggingLevel.INFO,'Step2-1==--');
                            if(parentMandateCodemap.containsKey(commBenParentName)) {
                //                system.debug(LoggingLevel.INFO,'Step3==--');
                                
                   //             system.debug(LoggingLevel.INFO,'Step5==--' + limtls);
                                Set<String> tmpset = parentMandateCodemap.get(commBenParentName);
                    //            system.debug(LoggingLevel.INFO,'Step5-comm.Code__c==--' + comm.Code__c);
                                if(tmpset != null && tmpset.size()>0 && comm.Code__c != null)
                                {
                                    if( !tmpset.contains(String.valueof(comm.Code__c)))
                                        limtls.add(tempLimit);
                     //               system.debug(LoggingLevel.INFO,'Step5-2==--' + limtls);
                                }
                               
                            }
                            else
                                limtls.add(tempLimit);
                   //     system.debug(LoggingLevel.INFO,'Step2-3==--');
                            ParentBenLimitationLimit.put(commBenParentName,limtls);
//system.debug(LoggingLevel.INFO,'Step6==--');                            
                    }
              //  }
            }
        }
       // system.debug(LoggingLevel.INFO,'PlanCommentCodes==--' + PlanCommentCodes);
        PlanCommentCodes.clear();
        benLimitsAllMap.clear();
       // system.debug(LoggingLevel.INFO,'benLimitsAllMap==--' + benLimitsAllMap);
      //  system.debug('final ParentBenLimitationMan---'+ParentBenLimitationMan);
      //  system.debug('final ParentBenLimitationLimit---'+ParentBenLimitationLimit);

    }

    /**
     * This method is used get all the data using maps and forma list of wrapper class
    */
    public void FormatDataFromPlanIntoWrapper(AIA_Benefit_Design_Product__c PP,Map<String,List<Limitations__c>> ParentBenLimitationLimit , Map<String,List<Limitations__c>> ParentBenLimitationMan,Map<String,AIA_Plan_Benefits__c> MapGrouperBenefitsNet,Map<id, CopayTypeWrapper> copayBenMap){
        grouperWrapList = new List<GrouperWrapper>();
        String RType = 'BDD';       
        string planif = PP.Plan_Name__c;        
        List<AIA_Plan_Grouper__c> grpOUT= [Select id,IsCovered__c, DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, Name, Sequence_Number__c,Record_Type__c, Plan_Network__c,Type__c, Plan_Network__r.Name, Plan_Network__r.InNetwork__c,      
                                                   CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c, Plan_Network__r.OON_OutNetwork__c        
                                                   From AIA_Plan_Grouper__c Where PlanId__c=:planif AND Type__c = 'Benefit Group'       
                                                   AND Record_Type__c =:RType AND Plan_Network__r.Name = 'OutNetwork' Order By Sequence_Number__c,Plan_Network__r.Name];        
      //  system.debug('@@@@@grpOUT@@@---'+grpOUT);   
        Schema.DescribeSObjectResult d = Schema.SObjectType.AIA_Grouper__c; 
        Map<String,Schema.RecordTypeInfo> GrpRTMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo grprtByName = GrpRTMapByName.get('BD Product');

        Schema.DescribeSObjectResult d2 = Schema.SObjectType.AIA_Benefits__c; 
        Map<String,Schema.RecordTypeInfo> BenRTMapByName = d2.getRecordTypeInfosByName();
        Schema.RecordTypeInfo benrtByName = BenRTMapByName.get('BD Product');

        Integer grpSeq=1;
        for(AIA_Plan_Grouper__c planGroupObj : planGrouperBenList) {
            GrouperWrapper  grpNameWrapObj = new GrouperWrapper();
            AIA_Grouper__c aiaGrpObj = new AIA_Grouper__c();
            if(ExistingBRFGrouper.containsKey(planGroupObj.Name)){
                aiaGrpObj=ExistingBRFGrouper.get(planGroupObj.Name);
            }
            else{
                aiaGrpObj.Name = planGroupObj.Name;
                aiaGrpObj.Benefit_Design_Product__c = bdProdId;
                aiaGrpObj.Group_Type__c = 'Benefit Group';
            
            if(planGroupObj.Plan_Network__r.Name.contains('InNetwork')){
                //T14-Start Added InNetwork Id to the Benefit Grouper
            aiaGrpObj.InNetwork__c=planGroupObj.Plan_Network__r.InNetwork__c;
               //T14-End       
            if(planGroupObj.IsCovered__c == 'True' || planGroupObj.IsCovered__c == 'Yes' || planGroupObj.IsCovered__c =='Y'){       
            aiaGrpObj.IsCovered__c = 'Yes';         
            }       
            else{       
                aiaGrpObj.IsCovered__c = 'No';      
                }       
            if(planGroupObj.DeductibleApplies__c == 'Y' || planGroupObj.DeductibleApplies__c == 'Yes'){     
            aiaGrpObj.DeductibleApplies__c = 'Yes';         
            }       
            else{       
                aiaGrpObj.DeductibleApplies__c = 'No';      
                }       
            if(planGroupObj.AnnualMaximumApplies__c == 'Y' || planGroupObj.AnnualMaximumApplies__c == 'Yes'){       
            aiaGrpObj.AnnualMaximumApplies__c = 'Yes';          
            }       
            else{       
                aiaGrpObj.AnnualMaximumApplies__c = 'No';       
                }       
            aiaGrpObj.DavisString__c = planGroupObj.DavisString__c;     
            if(planGroupObj.CoInsurance__c != null || planGroupObj.CoInsurance__c !=''){        
                aiaGrpObj.CoInsurance__c = planGroupObj.CoInsurance__c;     
                aiaGrpObj.CoInsurance_Low__c = planGroupObj.CoInsurance_Low__c;     
                aiaGrpObj.CoInsurance_High__c= planGroupObj.CoInsurance_High__c;        
                aiaGrpObj.CoInsurance_Increment__c= planGroupObj.CoInsurance_Increment__c;      
                aiaGrpObj.CoInsurance_InvalidIncrement__c= planGroupObj.CoInsurance_InvalidIncrement__c;        
                aiaGrpObj.CoInsurance_AddIncrement__c= planGroupObj.CoInsurance_AddIncrement__c;        
                }       
            }       
            for(aia_plan_grouper__c grouperout: grpOUT){        
            if(grouperout.Name == planGroupObj.Name){       
            if(grouperout.Plan_Network__r.Name.contains('OutNetwork')){
            //T14-Start Added OutNetwork Id to the Benefit Grouper
             aiaGrpObj.OON_OutNetwork__c=grouperout.Plan_Network__r.OON_OutNetwork__c;
            //T14-End               
            if(grouperout.IsCovered__c == 'True' || grouperout.IsCovered__c == 'Yes' || grouperout.IsCovered__c =='Y'){     
            aiaGrpObj.OON_IsCovered__c = 'Yes';         
            }       
            else{       
                aiaGrpObj.OON_IsCovered__c = 'No';      
                }       
            if(grouperout.DeductibleApplies__c == 'Y' || grouperout.DeductibleApplies__c == 'Yes'){     
            aiaGrpObj.OON_DeductibleApplies__c= 'Yes';      
            }       
            else{       
                aiaGrpObj.OON_DeductibleApplies__c= 'No';       
                }       
            if(grouperout.AnnualMaximumApplies__c == 'Y' || grouperout.AnnualMaximumApplies__c == 'Yes'){       
            aiaGrpObj.OON_AnnualMaximumApplies__c= 'Yes';       
            }       
            else{       
                aiaGrpObj.OON_AnnualMaximumApplies__c= 'No';        
                }       
            aiaGrpObj.OON_DavisString__c = grouperout.DavisString__c;       
            if(grouperout.CoInsurance__c != null || grouperout.CoInsurance__c !=''){        
                aiaGrpObj.OON_CoInsurance__c= grouperout.CoInsurance__c;        
                aiaGrpObj.OON_CoInsurance_Low__c= grouperout.CoInsurance_Low__c;        
                aiaGrpObj.OON_CoInsurance_High__c= grouperout.CoInsurance_High__c;      
                aiaGrpObj.OON_CoInsurance_Increment__c= grouperout.CoInsurance_Increment__c;        
                aiaGrpObj.OON_CoInsurance_InvalidIncrement__c= grouperout.CoInsurance_InvalidIncrement__c;      
                aiaGrpObj.OON_CoInsurance_AddIncrement__c= grouperout.CoInsurance_AddIncrement__c;      
                }       
            }       
            }       
            }    
                aiaGrpObj.Grouper_Record_Type__c='BDD';
                aiaGrpObj.RecordTypeId=grprtByName.recordtypeid;
                // T14-Start Added PCS_Grouper_Id__c
            if((aiaGrpObj.PCS_Grouper_Id__c =='' || aiaGrpObj.PCS_Grouper_Id__c == null) && aiaGrpObj.Grouper_Record_Type__c == 'BDD'){
               aiaGrpObj.PCS_Grouper_Id__c=planGroupObj.PCS_Grouper_Id__c;
               }
                //T14-End
            }
            aiaGrpObj.Sequence_Number__c=grpSeq++;
            grpNameWrapObj.aiaGrouper= aiaGrpObj;
            Integer benSeq=0;
            List<BenifitsrWrapper> benifitWrapList = new List<BenifitsrWrapper>();
       //     system.debug('planGroupObj.Name---'+planGroupObj.Name);
            if(AllGrpParentBenName.containskey(planGroupObj.Name)){
                for(String pName : AllGrpParentBenName.get(planGroupObj.Name)) {
                   system.debug('pName---'+pName);
                    if(ParentBenLimitationMan.containsKey(pName)){
               //         System.debug('has mandate--'+'++++benSeq+++'+benSeq); 
                        benSeq=benSeq+1;
                        BenifitsrWrapper benWrapObjm = new BenifitsrWrapper();
                        String mName=pname;// + ' - Mandate - Yes';
                        String mNamekey=pname+' - Mandate';
                        benWrapObjm.benifitNameStr = mName;
                        benWrapObjm.GrpName=planGroupObj.Name;
                        AIA_Benefits__c benObjTo = new AIA_Benefits__c();
                        if(ExistingBRFGrouperBenefits.containsKey(planGroupObj.Name) && ExistingBRFGrouperBenefits.get(planGroupObj.Name).containskey(mNamekey))
                        {
                            benObjTo=ExistingBRFGrouperBenefits.get(planGroupObj.Name).get(mNamekey);
                            system.debug('@@inside if existing benefit 2088'+mNamekey);
                        }
                        else{
                            benObjTo.Benefit_Record_Type__c='BDD';
                            benObjTo.Benefit_Name__c=mName;
                            benObjTo.Type__c='Benefit';
                            benObjTo.Benefit_Type__c='Mandate';
                            benObjTo.Copay_Type_1_IsCovered__c = '';
                            benObjTo.OON_Copay_Type_1_IsCovered__c = '';
                            benObjTo.RecordTypeId=benrtByName.recordtypeid;
                            benObjTo.DefaultPlanBenefitValue__c='_________';
                            //added on Nov 16 2016 -- B-03274 -- to show the mandate name and teh juridiction
                            if(ParentBenifitMandateName.containsKey(pname)){
                                benObjTo.Copay_Type_1_Mandate_Name__c=ParentBenifitMandateName.get(pname).MandateName__c;
                                benObjTo.Copay_Type_1_Jurisdiction__c=ParentBenifitMandateName.get(pname).Jurisdiction_for_BRF__c;
                                system.debug('Hello: '+ParentBenifitMandateName.get(pname).Jurisdiction_for_BRF__c);
                            }
                            else{
                                    benObjTo.Copay_Type_1_Mandate_Name__c=pname;
                            }
                        }

                        benObjTo.Sequence_Number_SF__c=benSeq ;
                        if( benObjTo.Mandate_Yes_No__c == '' ||  benObjTo.Mandate_Yes_No__c == null){
                        benObjTo.Mandate_Yes_No__c = 'Yes';
                        }
                        List<Limitations__c> ManLimitation=ParentBenLimitationMan.get(pName);
                        for(Limitations__c obj:ManLimitation){                         
                            if(benObjTo.Benefit_Type__c == 'Limitation'){
                                obj.TierLimit_Selected__c = false;       
                                obj.TierAge_Selected__c = false;     
                                obj.MaxDuration_Selected__c = false;     
                                obj.MaxAge_Selected__c = false;
                             }
                        }
                        benWrapObjm.lstlimit=ManLimitation;
                        benWrapObjm.lstJurisdictions = getjurdictions(benWrapObjm.lstlimit);
                        Boolean IsASOOnly = true;
                      system.debug('@@benifitWrapList line 624 ManLimitation'+ManLimitation);
                        for(Limitations__c obj:ManLimitation){ 
                        benObjTo.Copay_Type_1_Mandate_Name__c=ManLimitation[0].MandateName__c;
                        benObjTo.Copay_Type_1_Jurisdiction__c=ManLimitation[0].Jurisdiction__c;/* Need to Check */
                            system.debug('Hello2: '+ManLimitation[0].Jurisdiction__c);
                  //          System.debug('++++obj.IS_ASO_Only__c++'+obj.IS_ASO_Only__c);        
                            if(!obj.IS_ASO_Only__c)
                            {
                                IsASOOnly = false;
                            }
                        //t16 start added variationid,pcssbenefit id from mandate to benefit type limitation    
                         if(benObjTo.Benefit_Record_Type__c != 'BRF')
                         benObjTo.Variation_Condition_ID__c=obj.Variation_Condition_ID__c;
                         if(benObjTo.Benefit_Record_Type__c != 'BRF')
                         benObjTo.PCS_Benefit_Id__c=obj.PCS_Benefit_Id__c;
                        //t16 end
                        }
                        // RG UPDATE benObjTo.IS_ASO_Only__c = IsASOOnly;
                    //    system.debug('@@benifitWrapList line 624 benObjTo.IS_ASO_Only__c'+benObjTo.IS_ASO_Only__c);
                    //    system.debug('@@benifitWrapList line 624 mandate'+benifitWrapList);
                        benWrapObjm.aiaBenifitObj=benObjTo;
                        benifitWrapList.add(benWrapObjm);
                   //     system.debug('@@benifitWrapList line 624 mandate'+benifitWrapList);
                    }else if(ParentBenifitMandateName.containsKey(pname)){
                   //     System.debug('has mandate 2--'+'++++benSeq+++'+benSeq); 
                        benSeq=benSeq+1;
                        BenifitsrWrapper benWrapObjm = new BenifitsrWrapper();
                        String mName=pname;// + ' - Mandate - Yes';
                        String mNamekey=pname+' - Mandate';
                        benWrapObjm.benifitNameStr = mName;
                        benWrapObjm.GrpName=planGroupObj.Name;
                        AIA_Benefits__c benObjTo = new AIA_Benefits__c();
                        if(ExistingBRFGrouperBenefits.containsKey(planGroupObj.Name) && ExistingBRFGrouperBenefits.get(planGroupObj.Name).containskey(mNamekey))
                        {
                            benObjTo=ExistingBRFGrouperBenefits.get(planGroupObj.Name).get(mNamekey);
                            system.debug('@@inside if existing benefit 2161'+mNamekey);
                        }
                        else{
                            benObjTo.Benefit_Record_Type__c='BDD';
                            benObjTo.Benefit_Name__c=mName;
                            benObjTo.Type__c='Benefit';
                            benObjTo.Benefit_Type__c='Mandate';
                            benObjTo.Copay_Type_1_IsCovered__c = '';
                            benObjTo.OON_Copay_Type_1_IsCovered__c = '';
                            benObjTo.RecordTypeId=benrtByName.recordtypeid;
                            benObjTo.DefaultPlanBenefitValue__c='_________';
                            //added on Nov 16 2016 -- B-03274 -- to show the mandate name and teh juridiction
                            if(ParentBenifitMandateName.containsKey(pname)){
                                benObjTo.Copay_Type_1_Mandate_Name__c=ParentBenifitMandateName.get(pname).MandateName__c;
                                benObjTo.Copay_Type_1_Jurisdiction__c=ParentBenifitMandateName.get(pname).Jurisdiction_for_BRF__c;
                                system.debug('Hello3: '+ParentBenifitMandateName.get(pname).Jurisdiction_for_BRF__c);
                            }
                            else{
                                    benObjTo.Copay_Type_1_Mandate_Name__c=pname;
                                 
                            }
                        }

                        benObjTo.Sequence_Number_SF__c=benSeq ;
                        if( benObjTo.Mandate_Yes_No__c == '' ||  benObjTo.Mandate_Yes_No__c == null){
                        benObjTo.Mandate_Yes_No__c = 'Yes';
                        }
                        benObjTo.Copay_Type_1_Benefit_Comment_Codes__c  ='NA';
                        List<Limitations__c> ManLimitation=new List<Limitations__c>();
                        benWrapObjm.lstlimit=ManLimitation;
                        benWrapObjm.lstJurisdictions = getjurdictions(benWrapObjm.lstlimit);
                        Boolean IsASOOnly = true;
                        for(Limitations__c obj:ManLimitation){ 
                    //        System.debug('++++obj.IS_ASO_Only__c++'+obj.IS_ASO_Only__c);        
                            if(!obj.IS_ASO_Only__c)
                            {
                                IsASOOnly = false;
                            }
                       //t16 start added variationid,pcssbenefit id from mandate to benefit type limitation    
                       if(benObjTo.Benefit_Record_Type__c != 'BRF')
                       benObjTo.Variation_Condition_ID__c=obj.Variation_Condition_ID__c;
                       if(benObjTo.Benefit_Record_Type__c != 'BRF')
                       benObjTo.PCS_Benefit_Id__c=obj.PCS_Benefit_Id__c;
                       //t16 end    
                        }
                        // RG UPDATE benObjTo.IS_ASO_Only__c = IsASOOnly;
                   //     system.debug('@@benifitWrapList line 624 benObjTo.IS_ASO_Only__c'+benObjTo.IS_ASO_Only__c);
                        benWrapObjm.aiaBenifitObj=benObjTo;
                        benifitWrapList.add(benWrapObjm);
                  //      system.debug('@@benifitWrapList line 624 mandate'+benifitWrapList);

                    }  //END--added on Nov 16 2016 -- B-03274 -- to show the mandate name and teh juridiction


              //      system.debug('pnmae===='+pName);
                    for(String benNames : AllParentBenName.get(pName)) {
             //           system.debug('benNames----'+benNames +'---'+pName +'++++benSeq+++'+benSeq); 
                        benSeq=benSeq+1;
                        AIA_Benefits__c benObjTo = new AIA_Benefits__c();
                        BenifitsrWrapper benWrapObjb = new BenifitsrWrapper();
                        benWrapObjb.GrpName=planGroupObj.Name;
                        benWrapObjb.benifitlmt=pName;
                        benWrapObjb.benifitNameStr = benNames;
                        benObjTo.Benefit_Name__c=benNames;
                        benObjTo.Type__c='Benefit';
                        benObjTo.Benefit_Type__c='Benefit';
                        if(ExistingBRFGrouperBenefits.containsKey(planGroupObj.Name) && ExistingBRFGrouperBenefits.get(planGroupObj.Name).containskey(benNames))
                        {
                            benObjTo=ExistingBRFGrouperBenefits.get(planGroupObj.Name).get(benNames);
                            benObjTo.Benefit_Record_Type__c='BRF';
                        }
                        else{

                            benObjTo.Benefit_Record_Type__c='BDD';
                            benObjTo.RecordTypeId=benrtByName.recordtypeid;


                            AIA_Plan_Benefits__c benIn=new AIA_Plan_Benefits__c();
                            AIA_Plan_Benefits__c benOut=new AIA_Plan_Benefits__c();
                            String key=planGroupObj.Name+'_'+benNames+'_';
                 //           system.debug('key+++'+key);
                            
                               /************************* T02 -- start ********************************/
                             benObjTo.DefaultPlanBenefitValue__c='';
                             if (MapGrouperBenefitsNet.containsKey(key+'In')){
                                benIn=MapGrouperBenefitsNet.get(key+'In');
                                benObjTo.Sequence_Number__c=benIn.Sequence_Number__c;
                                //T14-Start Added Benefit ID and Variation Condition Id
                                if(benObjTo.Benefit_Record_Type__c != 'BRF')
                                benObjTo.PCS_Benefit_Id__c=benIn.PCS_Benefit_Id__c;
                                if(benObjTo.Benefit_Record_Type__c != 'BRF')
                                benObjTo.Variation_Condition_ID__c=benIn.Variation_Condition_ID__c;
                               //T14-End
                        
                                if(copayBenMap.containsKey(benIn.Id)){
                                    AIA_Plan_Copay_Type__c copayTypeSelected=copayBenMap.get(benIn.Id).copayTypeSelectedObj ;
                                    AIA_Plan_Copay_Type__c copayTypePecSpec=copayBenMap.get(benIn.Id).copayTypePecSpecObj;
                                    if(copayTypeSelected!=null){
                                        benWrapObjb.copayTypeWrapObj.copayTypeSelectedObj=copayTypeSelected;
                                        benObjTo.Copay_Type_1_Mandate_Name__c=copayTypeSelected.MandateName__c;
                    //                    system.debug('copayTypeSelected+++ in 1'+benIn.benefit_name__C+'======'+copayTypeSelected);
                                        }
                                    if(copayTypePecSpec!=null && pp.Product_Category__c=='Medical'){
                                        benWrapObjb.copayTypeWrapObj.copayTypePecSpecObj=copayTypePecSpec;
                                  //      system.debug('copayTypeSelected+++ in 2'+benIn.benefit_name__C+'======'+copayTypeSelected);
                                        benObjTo.Copay_Type_2_Mandate_Name__c=copayTypePecSpec.MandateName__c;
                                    }
                                }
                                
                            }
                            
                             if (MapGrouperBenefitsNet.containsKey(key+'Out')){
                                 
                                benOut=MapGrouperBenefitsNet.get(key+'Out');
                                if(copayBenMap.containsKey(benOut.Id)){
                                    AIA_Plan_Copay_Type__c copayTypeSelected=copayBenMap.get(benOut.Id).copayTypeSelectedObj ;// != null?copayBenMap.get(benIn.Id).copayTypeSelectedObj:new AIA_Plan_Copay_Type__c();  
                                    AIA_Plan_Copay_Type__c copayTypePecSpec=copayBenMap.get(benOut.Id).copayTypePecSpecObj;// != null?copayBenMap.get(benIn.Id).copayTypePecSpecObj:new AIA_Plan_Copay_Type__c();  
                                    if(copayTypeSelected!=null){
                                        benWrapObjb.copayTypeWrapObj.copayTypeSelectedObj2=copayTypeSelected;
                                        benObjTo.OON_Copay_Type_1_Mandate_Name__c=copayTypeSelected.MandateName__c;
                                  //      system.debug('copayTypeSelected+++ out 1'+benIn.benefit_name__C+'======'+copayTypeSelected);
                                         }
                                    
                                    if(copayTypePecSpec!=null && pp.Product_Category__c=='Medical'){
                                        benWrapObjb.copayTypeWrapObj.copayTypePecSpecObj2=copayTypePecSpec;
                                        benObjTo.OON_Copay_Type_2_Mandate_Name__c=copayTypePecSpec.MandateName__c;
                                  //      system.debug('copayTypeSelected+++ out 2'+benIn.benefit_name__C+'======'+copayTypeSelected);
                                    }
                                } 
                                 
        
                            }
                            
                            /************************* T02 -- END ********************************/
                   
                        }
                        benObjTo.Sequence_Number_SF__c=benSeq;
                        benWrapObjb.aiaBenifitObj=benObjTo;
                        benifitWrapList.add(benWrapObjb);
                       // system.debug('@@benifitWrapList line 822'+benifitWrapList);
                    }
                    if(ParentBenLimitationLimit.containsKey(pName)){

                     //   System.debug('has limit--'+pname +'++++benSeq+++'+benSeq);
                        benSeq=benSeq+1;
                        BenifitsrWrapper benWrapObj = new BenifitsrWrapper();
                        String lname=pname ;//+ ' - Limitation';
                        String lnameKey=pname + ' - Limitation';
                        benWrapObj.benifitNameStr = lname;
                        benWrapObj.GrpName=planGroupObj.Name;
                        AIA_Benefits__c benObjTo = new AIA_Benefits__c();

                        if(ExistingBRFGrouperBenefits.containsKey(planGroupObj.Name) && ExistingBRFGrouperBenefits.get(planGroupObj.Name).containskey(lnameKey))
                        {
                            benObjTo=ExistingBRFGrouperBenefits.get(planGroupObj.Name).get(lnameKey);
                     //       system.debug('@@inside if existing benefit 835'+lnameKey);
                        }
                        else{

                            benObjTo.Benefit_Name__c=lname;
                            benObjTo.Type__c='Benefit';
                            benObjTo.Benefit_Type__c='Limitation';
                            benObjTo.Benefit_Record_Type__c='BDD';
                            benObjTo.Copay_Type_1_IsCovered__c = '';
                            benObjTo.OON_Copay_Type_1_IsCovered__c = '';
                            benObjTo.RecordTypeId=benrtByName.recordtypeid;
                            benObjTo.DefaultPlanBenefitValue__c='_________';
                     //       system.debug('@@inside else existing benefit 835'+lname);
                        }
                        benObjTo.Sequence_Number_SF__c=benSeq;
                        List<Limitations__c> LiLimitation=ParentBenLimitationLimit.get(pName);
                        benWrapObj.lstlimit=LiLimitation;
                        Boolean IsASOOnly = true;
                        for(Limitations__c obj:LiLimitation){ 
                    //        System.debug('++++obj.IS_ASO_Only__c++'+obj.IS_ASO_Only__c);        
                            if(!obj.IS_ASO_Only__c)
                            {
                                IsASOOnly = false;
                            }
                       //t16 start added variationid,pcssbenefit id from mandate to benefit type limitation    
                       if(benObjTo.Benefit_Record_Type__c != 'BRF')
                       benObjTo.Variation_Condition_ID__c=obj.Variation_Condition_ID__c;
                       if(benObjTo.Benefit_Record_Type__c != 'BRF')
                       benObjTo.PCS_Benefit_Id__c=obj.PCS_Benefit_Id__c;
                       //t16 end    
                        }
                        // RG UPDATE benObjTo.IS_ASO_Only__c = IsASOOnly;
                        benWrapObj.aiaBenifitObj=benObjTo;
                        benifitWrapList.add(benWrapObj);
                     //   system.debug('@@benifitWrapList line 624  limitation'+benifitWrapList);
                    }
                } 
            }

            grpNameWrapObj.benifitWrapList = benifitWrapList;
            grouperWrapList.add(grpNameWrapObj);
        }
        PlanMapGrouper.clear();
        AllGrpParentBenName.clear();
        AllParentBenName.clear();
        benefitIdSet.clear();
   //     system.debug('@@grouperWrapList line 624'+grouperWrapList);        
    }
    
 
    /********==================================SAVE Benefits On save and Cntinue ===============================================*******************/
    /**
     * This method is used get the data using the data in the grouperWrapList 
    */
    public void SaveAndContinuePlanBenefits(AIA_Benefit_Design_Product__c pp){
        Map<String,BenifitsrWrapper> ParentBenefitsMap=new Map<String,BenifitsrWrapper>();
        Map<string, BenifitsrWrapper> AllChildBenMap= new Map<String,BenifitsrWrapper>();
        Map<String,List<Limitations__c>> ParBenLimitationMap= new Map<String,List<Limitations__c>>();



        if(grouperWrapList.size()>0){
            List<AIA_Grouper__c> groupPPListToUpdate = new List<AIA_Grouper__c>();
            List<AIA_Benefits__c> benifitPPListToUpdate = new List<AIA_Benefits__c>();
            List<Limitations__c> lmtlst = new List<Limitations__c>();
            if(pp.Has_Benefit_Details__c)
                isPPData=true;
            else 
                isPPData=false;

      //      system.debug('+++inside SaveAndContinuePlanBenefits-----'+isPPdata);

            if(isPPdata){
                // For Cost Share Part


         //       System.debug('++++grouperWrapList+++'+grouperWrapList);
                for( GrouperWrapper grpWrapObj : grouperWrapList ) {
                    if(grpWrapObj.aiaGrouper.id != null){
                        groupPPListToUpdate.add(grpWrapObj.aiaGrouper);
                    }

                    for( BenifitsrWrapper benWrapObj : grpWrapObj.benifitWrapList ) {
                        if(benWrapObj.aiaBenifitObj.id != null){
           //                 System.debug('======grpWrapObj.benifitWrapList==aiaBenifitObj==='+benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c);
                            benifitPPListToUpdate.add(benWrapObj.aiaBenifitObj);
                        }
                         for(Limitations__c li:benWrapObj.lstlimit ){
                                 Limitations__c pbl= new Limitations__c();
                                pbl=li;
                               /************************* T02 -- start ********************************/
       /*   if(li.benefit_type__c == 'Limitation'){
            li.MaxAge_Selected__c  =  true;
            li.MaxDuration_Selected__c = true;
            li.TierAge_Selected__c = true;
            li.TierLimit_Selected__c = true;
            } */
            
            if(li.MaxAgeType__c=='' || li.MaxAgeType__c==null){
                pbl.MaxAgeFrom__c=null;
                pbl.MaxAgeTo__c=null;
         //        system.debug('+++++++++++ pb inside maxtype');
            }
             if((li.MaxApply__c=='' || li.MaxApply__c==null) && (li.MaxType__c=='' || li.MaxType__c==null) )
                pbl.MaxValue__c=null;
             if(li.MaxDurationType__c=='' || li.MaxDurationType__c==null  )
                pbl.MaxDuration__c=null;
             if(li.TierAgeType__c=='' || li.TierAgeType__c==null){
                pbl.TierAgeFrom__c=null;
                pbl.TierAgeTo__c=null;
            }
             if((li.TierLimitType__c==null || li.TierLimitType__c=='')  && (li.TierLimitDurationType__c==null || li.TierLimitDurationType__c=='' )){
                    pbl.TierLimitTo__c=null;
                    pbl.TierLimitFrom__c=null;
                }
            if(li.TierLimit_Selected__c == true || li.TierAge_Selected__c == true || li.MaxDuration_Selected__c == true || li.MaxAge_Selected__c == true){
              if(pbl.Type__c != 'Comment'){
              pbl.IsSelected__c = true;
              }
              }
      //         system.debug('+++++++++++pb limit name pbl ++++++'+pbl);
              li.TierLimit_Selected_Value__c = ''; 
              li.TierAge_Selected_Value__c = '';
              li.MaxDuration_Selected_Value__c = ''; 
              li.MaxAge_Selected_Value__c = ''; 
                 
            if(li.TierLimit_Selected__c == true ){
                if(li.TierLimitFrom__c!=null)
                    li.TierLimit_Selected_Value__c += li.TierLimitFrom__c + ' ';
                if(li.TierLimitFrom__c!=null && li.TierLimitTo__c!=null)
                    li.TierLimit_Selected_Value__c += 'to' + ' ';
                if(li.TierLimitTo__c!=null)
                    li.TierLimit_Selected_Value__c += li.TierLimitTo__c + ' ';  
                if(li.TierLimitType__c!=null)
                    li.TierLimit_Selected_Value__c += li.TierLimitType__c + ' ';
                if(li.TierLimitDurationType__c!=null)
                    li.TierLimit_Selected_Value__c += li.TierLimitDurationType__c;
                //li.TierLimit_Selected_Value__c = li.TierLimitFrom__c==null?'':li.TierLimitFrom__c  + ' ' + li.TierLimitTo__c==null?'':li.TierLimitTo__c + ' ' + li.TierLimitType__c==null?'':li.TierLimitType__c  + ' ' + li.TierLimitDurationType__c==null?'':li.TierLimitDurationType__c ;   
             }
            if(li.TierAge_Selected__c == true){
                if(li.TierAgeFrom__c!=null)
                    li.TierAge_Selected_Value__c += li.TierAgeFrom__c + ' ';
                if(li.TierAgeFrom__c!=null && li.TierAgeTo__c!=null)
                    li.TierAge_Selected_Value__c += 'to' + ' ';
                if(li.TierAgeTo__c!=null)
                    li.TierAge_Selected_Value__c += li.TierAgeTo__c + ' ';  
                if(li.TierAgeType__c!=null)
                    li.TierAge_Selected_Value__c += li.TierAgeType__c;                
                //li.TierAge_Selected_Value__c = li.TierAgeFrom__c==null?'':li.TierAgeFrom__c  + ' ' + li.TierAgeTo__c==null?'':li.TierAgeTo__c  + ' ' + li.TierAgeType__c==null?'':li.TierAgeType__c;
            }
            if(li.MaxDuration_Selected__c == true){
                if(li.MaxValue__c!=null)
                    li.MaxDuration_Selected_Value__c += li.MaxValue__c + ' ';
                if(li.MaxType__c!=null)
                    li.MaxDuration_Selected_Value__c += li.MaxType__c + ' ';    
                    
                if(li.MaxApply__c!=null)
                    li.MaxDuration_Selected_Value__c += li.MaxApply__c + ' ';
                if(li.MaxType__c!=null || li.MaxDurationType__c!=null)
                    li.MaxDuration_Selected_Value__c +='Per' + ' ';
                if(li.MaxDuration__c!=null)
                    li.MaxDuration_Selected_Value__c += li.MaxDuration__c + ' ';
                if(li.MaxDurationType__c!=null)
                    li.MaxDuration_Selected_Value__c += li.MaxDurationType__c;
                //li.MaxDuration_Selected_Value__c = li.MaxValue__c==null?:li.MaxValue__c; //  + ' ' + li.MaxType__c==null?'':li.MaxType__c  + ' ' + li.MaxApply__c==null?'':li.MaxApply__c  + ' ' + li.MaxDuration__c==null?'':li.MaxDuration__c + ' ' + li.MaxDurationType__c==null?'':li.MaxDurationType__c ;
            }
            
            if(li.MaxAge_Selected__c  ==  true){
                if(li.MaxAgeFrom__c!=null)
                    li.MaxAge_Selected_Value__c += li.MaxAgeFrom__c + ' ';
                if(li.MaxAgeFrom__c!=null && li.MaxAgeTo__c!=null)
                    li.MaxAge_Selected_Value__c += 'to' + ' ';
                if(li.MaxAgeTo__c!=null)
                    li.MaxAge_Selected_Value__c += li.MaxAgeTo__c + ' ';    
                if(li.MaxAgeType__c!=null)
                    li.MaxAge_Selected_Value__c += li.MaxAgeType__c;              
               //li.MaxAge_Selected_Value__c = li.MaxAgeFrom__c==null?'':li.MaxAgeFrom__c  + ' ' + li.MaxAgeTo__c==null?'':li.MaxAgeTo__c  + ' ' + li.MaxAgeType__c==null?'':li.MaxAgeType__c ;
            }
            
            if(li.MaxAge_Selected_Value__c == '' || li.MaxAge_Selected_Value__c == null){
            li.MaxAge_Selected__c = false;
            }
            if(li.MaxDuration_Selected_Value__c == '' || li.MaxDuration_Selected_Value__c == null){
            li.MaxDuration_Selected__c = false;
            }
            if(li.TierLimit_Selected_Value__c == '' || li.TierLimit_Selected_Value__c == null){
            li.TierLimit_Selected__c = false;
            }
            if(li.TierAge_Selected_Value__c == '' || li.TierAge_Selected_Value__c == null){
            li.TierAge_Selected__c = false;
            }
       /************************* T02 -- END ********************************/
                                 lmtlst.add(pbl);
                            }
                    }
                }

                if(groupPPListToUpdate.size()>0)
                    update groupPPListToUpdate;
                if(benifitPPListToUpdate.size()>0)
                    update benifitPPListToUpdate; 
                if(lmtlst.size()>0 && lmtlst != null) 
                    update lmtlst;//Modified by Asif, changed update to upsert 5/8/2017
                // Reset the static flag so that adjustment records can be created if benefits
                // are updated below.  This is needed because two updates in one transaction.
                AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag(); // Bill, T10                    
            }
            else {
                /***********************for benefits Groupers and benefit and limitation **************************/
                // AllChildBenMap= new Map
                List< AIA_Grouper__c> lstGroup = new List<AIA_Grouper__c>();
                List< AIA_Grouper__c> lstGroupup = new List<AIA_Grouper__c>();
                List< AIA_Grouper__c> lstGroupList= new List<AIA_Grouper__c>();
                Map<String,  AIA_Grouper__c> grpmap=new Map<String,  AIA_Grouper__c>();
                List<AIA_Benefits__c> parentBenIns= new List<AIA_Benefits__c>();
                List<AIA_Benefits__c> parentBenInsList= new List<AIA_Benefits__c>();
                List<AIA_Benefits__c> parentBenUp= new List<AIA_Benefits__c>();
                List<AIA_Benefits__c> childBenList= new List<AIA_Benefits__c>();
                List<AIA_Benefits__c> childBenListUp= new List<AIA_Benefits__c>();
                Map<String,AIA_Benefits__c> Allbenefits= new Map<String,AIA_Benefits__c>();
                List<Limitations__c> LimitationList= new List<Limitations__c>();
                if(grouperWrapList.size()>0){
                    for(GrouperWrapper gw:grouperWrapList){
                        AIA_Grouper__c grp= new AIA_Grouper__c();
                        grp=gw.aiaGrouper;
                        grp.Sequence_Number__c=gw.aiaGrouper.Sequence_Number__c;
                        /** T13 Start**/
                        if((grp.PCS_Grouper_Id__c =='' || grp.PCS_Grouper_Id__c == null) && grp.Grouper_Record_Type__c == 'BDD'){
                        grp.PCS_Grouper_Id__c=gw.aiaGrouper.PCS_Grouper_Id__c;
                        }
                        /** T13 End**/
                        if(gw.benifitWrapList.size()>0){
                            for(BenifitsrWrapper benwr: gw.benifitWrapList ){
                              //  system.debug('benefit wrapsss===='+benwr);
                                if(benwr.aiaBenifitObj!=null){
                                    AIA_Benefits__c  ben= benwr.aiaBenifitObj;
                                 //   system.debug('benfit===='+ben);
                                    if(ben.Benefit_Type__c=='Mandate' || ben.Benefit_Type__c=='Limitation')
                                    {
                                        ParentBenefitsMap.put(ben.Benefit_Name__c+' - '+ben.Benefit_Type__c, benwr);
                                        if(benwr.lstlimit.size()>0)
                                            ParBenLimitationMap.put(ben.Benefit_Name__c+' - '+ben.Benefit_Type__c, benwr.lstlimit   );
                                    }

                                    else if(ben.Benefit_Type__c=='Benefit')
                                    {
                                        AllChildBenMap.put(ben.Benefit_Name__c, benwr);
                                    }
                                }

                            }
                        }

                        if(grp.id!=null)
                            lstGroupup.add(grp);
                        else
                            lstGroup.add(grp);
                 //       system.debug('====grp name==='+grp);
                    }

                  //  system.debug('+++ParentBenefitsMap++++---'+ParentBenefitsMap);
                 //   system.debug('+++ParBenLimitationMap++++---'+ParBenLimitationMap);
               //     system.debug('+++AllChildBenMap++++---'+AllChildBenMap);

                //    system.debug('lstGroupup----'+lstGroupup.size()+'--lstGroup----'+lstGroup.size());
                    insert lstGroup;
                    update lstGroupup;
                 //   system.debug('+lstGroup+++++++'+lstGroup.size());
                    String query= QueryBase2.getSobjectAllFieldsSOQL('AIA_Grouper__c', 'id in :lstGroup or id in :lstGroupup');
                    lstGroupList.clear();
                    lstGroupList= database.query(query);
                //    system.debug('+lstGroup+++++++'+lstGroupList.size());
                    for(AIA_Grouper__c a:lstGroupList){
                        grpmap.put(a.name, a);
                    }
                    //insert parent mandate or limit benefits
                    for(BenifitsrWrapper pBen:ParentBenefitsMap.values()){
                  //      system.debug('+insert parent mandate/limita+++++++'+pBen);
                        AIA_Benefits__c benObjTo = new AIA_Benefits__c();
                        if(grpmap.containsKey(pBen.grpName)){
                  //          system.debug('++++parent has grouper+++++++'+grpmap.get(pBen.grpName));
                            benObjTo=pBen.aiaBenifitObj;
                            
                            Boolean IsASOOnly = true;
                            for(Limitations__c obj:pBen.lstlimit){ 
                    //            System.debug('++++obj.IS_ASO_Only__c++'+obj.IS_ASO_Only__c);        
                                if(!obj.IS_ASO_Only__c)
                                {
                                    IsASOOnly = false;
                                }
                            }
                            // RG UPDATE benObjTo.IS_ASO_Only__c = IsASOOnly;
                            benObjTo.Grouper__c=grpmap.get(pBen.grpName).Id;
                            benObjTo.Sequence_Number_SF__c= pBen.aiaBenifitObj.Sequence_Number_SF__c;
                   //         system.debug('inside parent benObjTo----'+benObjTo.Benefit_Name__c+'----'+benObjTo.Sequence_Number_SF__c);
                            if(benObjTo.id==null)
                                parentBenIns.add(benObjTo);
                            else
                                parentBenUp.add(benObjTo);
                        }
                    }
                    if (parentBenIns.size()>0)
                        insert parentBenIns;
                    update parentBenUp;

                 //   system.debug('parentBenIns----'+parentBenIns.size()+'--parentBenUp----'+parentBenUp.size());
                    query= QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefits__c', 'id in :parentBenIns or id in :parentBenUp');
                    parentBenInsList.clear();
                    parentBenInsList= database.query(query);
               //     system.debug('++++parentBenIns+++++++'+parentBenIns.size()+'++++++++++++++'+  parentBenIns);
                    set<id> pblIdSet = new set<id>();
                    for(AIA_Benefits__c pb:parentBenInsList){
                        Allbenefits.put(pb.Benefit_Name__c+' - '+pb.Benefit_Type__c, pb);
                 //       system.debug('pb---'+pb);
                        List<Limitations__c> benLimit=new List<Limitations__c>();
                        if(ParBenLimitationMap.containsKey(pb.Benefit_Name__c+' - '+pb.Benefit_Type__c)){
                            benLimit=ParBenLimitationMap.get(pb.Benefit_Name__c+' - '+pb.Benefit_Type__c);
                    //        system.debug('benLimit---'+benLimit);

                            for(Limitations__c li:benLimit){
                      //          system.debug('+++++++++++limit name++++++'+li);
                                Limitations__c pbl= new Limitations__c();
                                pbl=li;
                                pbl.Benefit__c=pb.Id;
                        if(pb.Copay_Type_1_Jurisdiction__c != pbl.Jurisdiction__c && pb.Benefit_Type__c == 'Mandate'){
                                pbl.IsSelected__c = false;
                                pbl.TierLimit_Selected__c = false;
                                pbl.TierAge_Selected__c = false;
                                pbl.MaxDuration_Selected__c = false;
                                pbl.MaxAge_Selected__c = false;
                        }
                        if(pb.Copay_Type_1_Jurisdiction__c == pbl.Jurisdiction__c && pb.Benefit_Type__c == 'Mandate'){
                            pbl.IsSelected__c = true;
                            pbl.TierLimit_Selected__c = true;
                            pbl.TierAge_Selected__c = true;
                            pbl.MaxDuration_Selected__c = true;
                            pbl.MaxAge_Selected__c = true;
                         
                         }   
                               if(li.MaxAgeType__c=='' || li.MaxAgeType__c==null){
                                    pbl.MaxAgeFrom__c=null;
                                    pbl.MaxAgeTo__c=null;
                        //             system.debug('+++++++++++ pb inside maxtype');
                                }
                                 if((li.MaxApply__c=='' || li.MaxApply__c==null) && (li.MaxType__c=='' || li.MaxType__c==null) )
                                    pbl.MaxValue__c=null;
                                 if(li.MaxDurationType__c=='' || li.MaxDurationType__c==null  )
                                    pbl.MaxDuration__c=null;
                                 if(li.TierAgeType__c=='' || li.TierAgeType__c==null){
                                    pbl.TierAgeFrom__c=null;
                                    pbl.TierAgeTo__c=null;
                                }
                                 if((li.TierLimitType__c==null || li.TierLimitType__c=='')  && (li.TierLimitDurationType__c==null || li.TierLimitDurationType__c=='' )){
                                        pbl.TierLimitTo__c=null;
                                        pbl.TierLimitFrom__c=null;
                                    }
                                if(pbl.id!=null){
                                    pblIdSet.add(pbl.id);
                                    if(!pblIdSet.contains(pbl.id))
                                        LimitationList.add(pbl);
                                }
                                else{
                                    LimitationList.add(pbl);
                                }
                            }
                        }

                    }
                    if(LimitationList.size()>0)
                        upsert LimitationList;

                    for(BenifitsrWrapper cBen :AllChildBenMap.values()){
                   //     system.debug('+++childbenname++++---'+cBen);
                        AIA_Benefits__c benObjTo = new AIA_Benefits__c();
                        if(grpmap.containsKey(cBen.grpName)){

                       //     system.debug('+++got benefit name ++++---'+cBen.benifitNameStr);
                            benObjTo=cBen.aiaBenifitObj;
                            benObjTo.Sequence_Number_SF__c= cBen.aiaBenifitObj.Sequence_Number_SF__c;
                            benObjTo.Grouper__c=grpmap.get(cBen.grpName).Id;
                        //    system.debug('inside each child bene benObjTo----'+cBen.aiaBenifitObj.Benefit_Name__c+'----'+cBen.aiaBenifitObj.Sequence_Number_SF__c);
                            String Mname= cben.benifitlmt+' - Mandate';
                            String LName=cben.benifitlmt+' - Limitation';
                      //      system.debug('+++Mname++++---'+Mname);
                      //      system.debug('+++LName++++---'+LName);
                            if(Allbenefits.containsKey(Mname)){
                                benObjTo.Parent_Mandate_Benefit__c=Allbenefits.get(Mname).ID;
                      //          system.debug('+++has mandate++++---'+Allbenefits.get(Mname).ID);
                            }

                            if(Allbenefits.containsKey(LName)){
                                benObjTo.Parent_Benefit__c=Allbenefits.get(LName).ID;
                        //        system.debug('+++has Limitatiopn++++---'+Allbenefits.get(LName).ID);
                            }
                            if(benObjTo.Id==null){
                                AIA_Plan_Copay_Type__c copayTypeSelected=new AIA_Plan_Copay_Type__c();
                                if(cBen.copayTypeWrapObj.copayTypeSelectedObj!=null){
                                    copayTypeSelected=cBen.copayTypeWrapObj.copayTypeSelectedObj;
                           //         system.debug('copayTypeSelected1+++'+copayTypeSelected);
                            //        system.debug('++pp.Product_Category__c++++'+pp.Product_Category__c);
                                    IF(pp.Product_Category__c=='Medical' || pp.Product_Category__c=='Vision' || pp.Product_Category__c=='Dental'){ //T08 included the condition for Vision

                                benObjTo.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                benObjTo.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c; 
                                
                                benObjTo.INN_MandateLockDownInd__c = copayTypeSelected.Plan_Benefits__r.MandateLockDownInd__c;
                                benObjTo.INN_MappingBRFBenefitID__c = copayTypeSelected.Plan_Benefits__r.MappingBRFBenefitID__c;
                                
                                benObjTo.Coinsurance_AmountLow__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_AmountLow__c; 
                                benObjTo.Coinsurance_AmountHigh__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_AmountHigh__c; 
                                benObjTo.Coinsurance_AmountIncrement__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_AmountIncrement__c; 
                                benObjTo.Coinsurance_Amount_AddtionalIncrements__c= copayTypeSelected.Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c; 
                                benObjTo.Coinsurance_Amount_InvalidIncrements__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c; 
                                
                                benObjTo.Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                benObjTo.Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                
                                benObjTo.Copay_Type_1_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                                benObjTo.Copay_Type_1_Default_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                                
                                benObjTo.Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                benObjTo.Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                                if(pp.Product_Category__c=='Dental'){                                               
                                if(copayTypeSelected.AnnualMaximumApplies__c == 'Yes' || copayTypeSelected.AnnualMaximumApplies__c == 'Y'){             
                                benObjTo.AnnualMaximumApplies__c= 'Yes' ;               
                                }               
                                if(copayTypeSelected.AnnualMaximumApplies__c == 'No' || copayTypeSelected.AnnualMaximumApplies__c == 'N'){              
                                benObjTo.AnnualMaximumApplies__c= 'No' ;                
                                }       
                                } 
                                benObjTo.Copay_Type_1_Low__c = copayTypeSelected.Copay_Low__c;
                                benObjTo.Copay_Type_1_High__c = copayTypeSelected.Copay_High__c;               
                                benObjTo.Copay_Type_1_Increment__c = copayTypeSelected.Copay_Increment__c;
                                benObjTo.Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;
                                benObjTo.Copay_Type_1_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
                                benObjTo.Copay_Type_1_AdditionalInvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;
                                
                                benObjTo.Copay_Type_1_Jurisdiction__c = copayTypeSelected.Jurisdiction__c;
                                        system.debug('Hello1: '+copayTypeSelected.Jurisdiction__c);
                                
                                if(pp.Product_Category__c=='Vision'){    //T08 added for Vision
                                   benObjTo.Discount_Amount__c = copayTypeSelected.Discount_Amount__c;
                                benObjTo.Discount_Amount_Default__c = copayTypeSelected.Discount_Amount__c;
                                
                                benObjTo.IN_Approximate_Member_Payment_w_Discount__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
                                benObjTo.IN_Approx_Member_Payment_w_Disc_Default__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
                                
                                benObjTo.Allowed_Amount__c = copayTypeSelected.Allowed_Amount__c;
                                benObjTo.Allowed_Amount_Default__c= copayTypeSelected.Allowed_Amount__c;
                                
                                benObjTo.Discount_Applies__c = copayTypeSelected.Discount_Applies__c;
                                benObjTo.Discount_Applies_Default__c= copayTypeSelected.Discount_Applies__c;
                                    benObjTo.Davis_Benefit_Variable__c = copayTypeSelected.Plan_Benefits__r.Davis_Benefit_Variable__c;
                                    benObjTo.Davis_Benefit_Variable_Default__c = copayTypeSelected.Plan_Benefits__r.Davis_Benefit_Variable__c;
                                }
                                
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Y'){
                                benObjTo.IS_ASO_Only__c = True; 
                                }
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'N'){
                                benObjTo.IS_ASO_Only__c = False;
                                }
                                
                                benObjTo.IsAppGlobalCoinsurance__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCoinsurance__c;
                                benObjTo.IsAppGlobalCopay__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCopay__c;
                                 }
                          else if(pp.Product_Category__c=='Drug'){
                                benObjTo.Copay_Type_1_Jurisdiction__c = copayTypeSelected.Jurisdiction__c;
                                
                                benObjTo.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                benObjTo.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c; 
                                
                                benObjTo.INN_MandateLockDownInd__c = copayTypeSelected.Plan_Benefits__r.MandateLockDownInd__c;
                                benObjTo.INN_MappingBRFBenefitID__c = copayTypeSelected.Plan_Benefits__r.MappingBRFBenefitID__c;
                                
                                benObjTo.Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                benObjTo.Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                
                                benObjTo.Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                benObjTo.Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                                
                                benObjTo.Copay_Min_Payment__c = copayTypeSelected.MinPayAmount__c;
                                benObjTo.Copay_Default_Min_Payment__c = copayTypeSelected.MinPayAmount__c;
                                
                                benObjTo.Copay_Max_Payment__c = copayTypeSelected.MaxPayAmount__c;
                                benObjTo.Copay_Default_Max_Payment__c = copayTypeSelected.MaxPayAmount__c;
                                
                                benObjTo.Tier_type__c=copayTypeSelected.TierType__c; 
                                benObjTo.Tier_Type_Default__c=copayTypeSelected.TierType__c; 
                                
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Y'){
                                benObjTo.IS_ASO_Only__c = True; 
                                }
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'N'){
                                benObjTo.IS_ASO_Only__c = False;
                                }
                                benObjTo.IsAppGlobalCoinsurance__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCoinsurance__c;
                                benObjTo.IsAppGlobalCopay__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCopay__c;
                                    }

                                }
                                if(cBen.copayTypeWrapObj.copayTypePecSpecObj!=null && pp.Product_Category__c=='Medical'){
                                    copayTypeSelected=cBen.copayTypeWrapObj.copayTypePecSpecObj;
                                //    system.debug('copayTypePecSpec1+++'+copayTypeSelected);
                                    benObjTo.Copay_Type_2_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                    benObjTo.Copay_Type_2_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                                      
                                    benObjTo.Copay_Type_2_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                    benObjTo.Copay_Type_2_Low__c = copayTypeSelected.Copay_Low__c;
                                    benObjTo.Copay_Type_2_High__c = copayTypeSelected.Copay_High__c;
                                    benObjTo.Copay_Type_2_Increment__c = copayTypeSelected.Copay_Increment__c;
                                    benObjTo.CopayType2_Additional_InvalidIncrement__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;
                                    benObjTo.Copay_Type_2_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
                                    benObjTo.Copay_Type_2_AliasName__c = copayTypeSelected.AliasName__c;
                                    if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Y'){
                                    benObjTo.IS_ASO_Only__c = True; 
                                    }
                                    if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'N'){
                                    benObjTo.IS_ASO_Only__c = False;
                                    }
                                }
                                if(cBen.copayTypeWrapObj.copayTypeSelectedObj2!=null ){
                                    copayTypeSelected=cBen.copayTypeWrapObj.copayTypeSelectedObj2;
                                //    system.debug('copayTypeSelected2+++'+copayTypeSelected);
                                    if(pp.Product_Category__c=='Medical' || pp.Product_Category__c=='Vision' || pp.Product_Category__c=='Vision'){  //T08 added for Vision
                                benObjTo.OON_CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                benObjTo.OON_Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;
                                
                                benObjTo.ONN_MandateLockDownInd__c = copayTypeSelected.Plan_Benefits__r.MandateLockDownInd__c;
                                benObjTo.ONN_MappingBRFBenefitID__c = copayTypeSelected.Plan_Benefits__r.MappingBRFBenefitID__c;
                                
                                benObjTo.OON_Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                benObjTo.OON_Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                
                                benObjTo.OON_Copay_Type_1_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                                benObjTo.OON_Copay_1_Default_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                                
                                benObjTo.OON_Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                benObjTo.OON_Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                                if(pp.Product_Category__c=='Dental'){                                               
                                if(copayTypeSelected.AnnualMaximumApplies__c == 'Yes' || copayTypeSelected.AnnualMaximumApplies__c == 'Y'){             
                                benObjTo.OON_AnnualMaximumApplies__c= 'Yes' ;               
                                }               
                                if(copayTypeSelected.AnnualMaximumApplies__c == 'No' || copayTypeSelected.AnnualMaximumApplies__c == 'N'){              
                                benObjTo.OON_AnnualMaximumApplies__c= 'No' ;                
                                }       
                                }     
                                benObjTo.OON_Copay_Type_1_AliasName__c = copayTypeSelected.AliasName__c;
                                benObjTo.OON_Copay_AmountLow__c = copayTypeSelected.Copay_Low__c;
                                benObjTo.OON_Copay_AmountHigh__c = copayTypeSelected.Copay_High__c;               
                                benObjTo.OON_Copay_AmountIncrement__c = copayTypeSelected.Copay_Increment__c;
                                
                                 if(pp.Product_Category__c=='Vision'){  //T08 added for Vision
                                   benObjTo.OON_Discount_Amount__c = copayTypeSelected.Discount_Amount__c;
                                benObjTo.OON_Discount_Amount_Default__c = copayTypeSelected.Discount_Amount__c;
                                
                                benObjTo.ON_Approximate_Member_Payment_w_Discount__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
                                benObjTo.ON_Approx_Member_Payment_w_Disc_Default__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
                                
                                benObjTo.OON_Allowed_Amount__c = copayTypeSelected.Allowed_Amount__c;
                                benObjTo.OON_Allowed_Amount_Default__c= copayTypeSelected.Allowed_Amount__c;
                                
                                benObjTo.OON_Discount_Applies__c = copayTypeSelected.Discount_Applies__c;
                                benObjTo.OON_Discount_Applies_Default__c = copayTypeSelected.Discount_Applies__c;
                                }
                                
                                benObjTo.OON_Copay_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;benObjTo.OON_Copay_Additional_InvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Y'){
                                benObjTo.IS_ASO_Only__c = True; 
                                }
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'N'){
                                benObjTo.IS_ASO_Only__c = False;
                                }

                           }else if(pp.Product_Category__c=='Drug'){
                                benObjTo.OON_CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                benObjTo.OON_Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;
                                
                                benObjTo.ONN_MandateLockDownInd__c = copayTypeSelected.Plan_Benefits__r.MandateLockDownInd__c;
                                benObjTo.ONN_MappingBRFBenefitID__c = copayTypeSelected.Plan_Benefits__r.MappingBRFBenefitID__c;
                                
                                benObjTo.OON_Coinsurance_AmountLow__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_AmountLow__c; 
                                benObjTo.OON_Coinsurance_AmountHigh__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_AmountHigh__c; 
                                benObjTo.OON_Coinsurance_AmountIncrement__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_AmountIncrement__c; 
                                benObjTo.OON_Coinsurance_AddtionalIncrements__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c; 
                                benObjTo.OON_Coinsurance_InvalidIncrements__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c; 
                                
                                benObjTo.OON_Copay_Type_1_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                benObjTo.OON_Copay_Type_1_Default_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                
                                benObjTo.OON_Copay_Type_1_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                benObjTo.OON_Copay_Type_1_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                                
                                benObjTo.OON_Copay_Min_Payment__c = copayTypeSelected.MinPayAmount__c;
                                benObjTo.OON_Copay_Default_Min_Payment__c = copayTypeSelected.MinPayAmount__c;
                                
                                benObjTo.OON_Copay_Max_Payment__c = copayTypeSelected.MaxPayAmount__c;
                                benObjTo.OON_Copay_Default_Max_Payment__c = copayTypeSelected.MaxPayAmount__c;
                                
                                benObjTo.OON_Tier_Type__c=copayTypeSelected.TierType__c;
                                benObjTo.OON_Tier_Type_Default__c=copayTypeSelected.TierType__c;
                                
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Y'){
                                benObjTo.IS_ASO_Only__c = True; 
                                }
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'N'){
                                benObjTo.IS_ASO_Only__c = False;
                                }
                              }
                            }
                                if(cBen.copayTypeWrapObj.copayTypePecSpecObj2!=null && pp.Product_Category__c=='Medical'){
                                    copayTypeSelected=cBen.copayTypeWrapObj.copayTypePecSpecObj2;
                                 //   system.debug('copayTypePecSpec2+++'+copayTypeSelected);
                                    benObjTo.OON_Copay_Type_2_AmountValueSelected__c = copayTypeSelected.CopayAmount__c;
                                    benObjTo.OON_Copay_Type_2_DefaultAmount__c = copayTypeSelected.CopayAmount__c;
                                    
                                    benObjTo.OON_Copay_Type_2_IsCovered__c = copayTypeSelected.IsCovered__c=='Yes'?'Yes':'No';
                                    benObjTo.OON_Copay_Type_2_DeductibleApplies__c = copayTypeSelected.DeductibleApplies__c;
                                    benObjTo.OON_Copay2_Low__c = copayTypeSelected.Copay_Low__c;
                                    benObjTo.OON_Copay2_High__c = copayTypeSelected.Copay_High__c;
                                    benObjTo.OON_Copay_Type_2_AliasName__c = copayTypeSelected.AliasName__c;
                                    benObjTo.OON_Copay2_Increment__c = copayTypeSelected.Copay_Increment__c;
                                    benObjTo.OON_Copay2Additional_InvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c ;
                                    benObjTo.OON_Copay_Type_2_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Y'){
                                benObjTo.IS_ASO_Only__c = True; 
                                }
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'N'){
                                benObjTo.IS_ASO_Only__c = False;
                                }
                            }
                                childBenList.add(benObjTo);
                            }   
                            else
                                childBenListup.add(benObjTo);

                        }

                    }

                    if(childBenList.size()>0)
                        insert childBenList ;
                    update   childBenListUp ;
                    
                      if(pp.Has_Benefit_Details__c==false){
                       pp.Has_Benefit_Details__c=true;
                        update pp;
                    }
                }
            }
           
        }

    }

    //returns true if Benefit summary data is available, false otherwise
    public boolean hasBnftSumry(AIA_Plan__c aia_Plan){
        boolean result = false;
        if(aia_Plan.Has_Benefit_Summary__c){//if checkbox is checked
            result = true;
        }
        return result;
    }

    //returns true if PCS API call has to be made, false otherwise
    public boolean isPCScallReq(AIA_Plan__c aia_Plan){
        boolean result = false;
        //check if Product Last Updated is greater than Config Last updated. If true get new data from PCS
        if(aia_Plan.Product_Last_Updated__c > aia_Plan.BDF_Configuration_Last_Updated__c || aia_Plan.BDF_Configuration_Last_Updated__c == null){

            result = true;
        }
        return result;
    }



    //get data from PCS
//T20 - Start Commented getPCSdata() to stop data from PCS as part of US1650
   /** public pageReference getPCSdata(){
      //  system.debug('getting plan data from PCS webservice'+ planId);
        AIA_PCSIntegrationHandler.callPCS(planIdValue,'BDD',bdProdId,BRFPCSEffDate);
        isPCSdata = true;
        system.debug(isPCSdata+' PCS Service Call Result :: ');//+benftSum);
        return null;
    }**/
//T20 - End


    public String prodBtnClicked {
        get;
        // *** setter is NOT being called ***
        set {
            prodBtnClicked = value;
        //    System.debug('value: '+value);
        }
    }

    /**
     * This is the wrapper class used to hold AIA_Grouper__c,AIA_Plan_Grouper__c , List<BenifitsrWrapper> values 
    */
    public class GrouperWrapper {
        public AIA_Grouper__c      aiaGrouper          {get; set;}  // if data comming from Proposed Product
        public AIA_Plan_Grouper__c grouperObj          {get; set;} 
        public List<BenifitsrWrapper> benifitWrapList  {get; set;}
        public String INpcpVal                         {get; set;}
        public String INspcpVal                        {get; set;}
        public String OutpcpVal                         {get; set;}
        public String OutspcpVal                        {get; set;}
        public Integer order                            {get;set;}


        public GrouperWrapper(){
            this.aiaGrouper = new AIA_Grouper__c();
            this.grouperObj = new AIA_Plan_Grouper__c();
            this.benifitWrapList = new List<BenifitsrWrapper>();
        }
        public GrouperWrapper(AIA_Grouper__c grp, Integer index){       
            this.aiaGrouper = grp;      
            this.grouperObj = new AIA_Plan_Grouper__c();        
            this.benifitWrapList = new List<BenifitsrWrapper>();        
            this.order = index;     
        }
    }
    /**
     * This is the wrapper class used to hold List<AIA_Plan_Benefit_Comment_Codes__c>,ist<AIA_Plan_Limitation__c>,List<NetworkTypeWrapper>,List<SelectOption>,CopayTypeWrapper  values 
    */
    public class BenifitsrWrapper {
        public String   benifitNameStr                 {get; set;}
        public String   benifitlmt                     {get; set;}
        public List<AIA_Plan_Benefit_Comment_Codes__c> MaxPlanCodelst {get; set;}
        public String maxPlan {get;set;}
        Public String GrpName {get;set;}
        public Boolean madateCheck {get; set;}
        public String tierPlan {get;set;}
        public List<AIA_Plan_Limitation__c>  lstPlanlimit  {get; set;}
        public List<Limitations__c> lstlimit {get; set;}
        public AIA_Benefits__c aiaBenifitObj           {get; set;}   // if data comming from Proposed Product
        public List<NetworkTypeWrapper> networkWrapList   {get; set;}
        public CopayTypeWrapper copayTypeWrapObj  {get;set;} 
        public List<SelectOption> lstJurisdictions { get;set; }
        public BenifitsrWrapper(){
            this.GrpName='';
            this.madateCheck = false;
            this.MaxPlanCodelst= new List<AIA_Plan_Benefit_Comment_Codes__c>();
            this.lstlimit = new List<Limitations__c>();
            this.lstPlanlimit = new List<AIA_Plan_Limitation__c>();
            this.aiaBenifitObj = new AIA_Benefits__c();
            this.networkWrapList = new List<NetworkTypeWrapper>();
            this.copayTypeWrapObj = new CopayTypeWrapper();
            this.lstJurisdictions = new List<SelectOption>();
        }

    }    
    /**
     * This is the wrapper class used to hold AIA_Plan_Benefits__c,AIA_Plan_Copay_Type__c , CopayTypeWrapper values 
    */
    public class NetworkTypeWrapper {
        String networkTypeStr;
        public AIA_Plan_Benefits__c benifitNetworkObj      {get; set;}
        public AIA_Plan_Copay_Type__c copayTypeForDrugObj  {get; set;}    // For Drug 
        public CopayTypeWrapper copayTypeWrapObj           {get; set;}

        public NetworkTypeWrapper(){
            this.benifitNetworkObj = new AIA_Plan_Benefits__c();
            this.copayTypeForDrugObj = new AIA_Plan_Copay_Type__c();
            this.copayTypeWrapObj = new CopayTypeWrapper();
        }
    }

    // Will be used in Medical scenerio.
    /**
     * This is the wrapper class used to hold AIA_Plan_Copay_Type__c values 
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
     * This Method is used to redirect back to previous page
    */
    public pageReference back(){
        pageReference pg1Ref = null;       
        bdProdId = ApexPages.currentPage().getParameters().get('id');
        pg1Ref = new pageReference('/apex/AIA_BenefitDesign_Summary?scontrolCaching=1&id='+bdProdId );

        pg1Ref.setRedirect(true);
        return pg1Ref;
    }
    /**
     * This Method is used to redirect to the next step
    */
    public PageReference saveandRedirct(){
         bdProdId = ApexPages.currentPage().getParameters().get('id');
        system.debug('saveandRedirct bdProductId'+bdProdId);
        List<AIA_Benefit_Design_Product__c> propsdPrdctLst =[Select PPACA_Status__c,Benefit_Design__r.id, Name from AIA_Benefit_Design_Product__c  where id = :bdProdId];
        PageReference  pgRef = new pageReference('/'+propsdPrdctLst[0].Benefit_Design__r.id);
        return pgRef;

    }
    /**
     * This Method is used to return all the juridiction in the limitation 
    */
    private List<SelectOption> getjurdictions(List<Limitations__c> lstLimitaions){      
        Set<string> setjurdiction = new Set<string>();      
        List<SelectOption> lstJurisdictions = new List<SelectOption>();     
        for(Limitations__c limitObj: lstLimitaions)     
        {       
            string juridiction = '';        
            if(limitObj.Jurisdiction__c != null && limitObj.Jurisdiction__c != '')      
            {       
                juridiction = limitObj.Jurisdiction__c;     
            }       
            if(!setjurdiction.contains(juridiction))        
            {       
                        
                lstJurisdictions.add(new SelectOption(juridiction,juridiction));        
                setjurdiction.add(juridiction);     
            }       
        }       
        lstJurisdictions.sort();        
        return lstJurisdictions;        
     }
}