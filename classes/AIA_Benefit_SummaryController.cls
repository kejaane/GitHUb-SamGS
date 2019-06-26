/*=================================================================================================================
 * Date         : 08/08/2016
 * Developer    : Goutham Rapolu
 * Purpose      : Benefit Summary Controller to display Benefit details from Proposed product and from Plan & 
 *                Plan related objects. Primarily to make a call to PCS and display the Data on the VF page.
 *=================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 * 10/21/2016 | Goutham Rapolu |     | Initial Version                                         
 * 11/07/2016 | Indira Das     |     | updated the get plan net codes for ASO and Risk separetely 
 * 11/30/2016 | Goutham Rapolu |     | updated To allow Collapsible feature and updated SaveandconTemp 
 * 02/13/2017 | Asif Kutagulla | T01 | Added code to save Three Month Deductible Carryover    
 * 03/06/2017 | Asif Kutagulla | T03 | Added where clause to runtime benefit object queries/sub-queries to filter
 *                                     benefits with Copay_Type_1_IsCovered__c & OON_Copay_Type_1_IsCovered__c!='N/A' 
 * 03/14/2017 | Ramakrishna    | T04 | Added logic for Vision page. 
 * 03/15/2017 | Asif Kutagulla | T06 | Added code to sort Cost Shares by Sequence_Number__c
 * 03/13/2017 | Goutham Rapolu | T08 | Added method to fetch PlanRxMandate and save to RxMandate(PP/BDP) User Story: B-03729
 * 03/24/2017 | Bill Dodson    | T09 | Merge in adjustment summary code.
 * 04/06/2017 | Ramakrishna    | T10 | Conditions on Copay_Type_1_IsCovered__c != 'N/A' and OON_Copay_Type_1_IsCovered__c != 'N/A'
 *                                     has been removed from the benefits query to show all benfits on summary page  B-03639
 * 05/15/2017 | Sree Harsha    | T11 | Added logic for user story 03947
 * 06/18/2017 | Asif Kutagulla | T12 | Added flag to make limitation non-editable based on criteria of  BRF Request Type
 *                                     is "Set-up Change - Benefit Changes" or "Set-up Change - Admin and Benefit Changes"
 *                                     and funding arrangement is "Risk" and Opportunity Market Segment is 200-999 for
 *                                     cloned BRF's. The stated request types are applicable for cloned BRFs only.
 * 06/30/2017 | Raviteja V     | T13 | Added variationid,pcsbenefitid,pcsGrouperId from setup to runtime
 * 07/03/2017 | Sajitha Y      | T14 | Added pcsGrouperId from setup to runtime
 * 07/17/2017 | Sajitha Y      | T15 | Added QA Complete Field 
 * 07/17/2017 | Raviteja V     | T16 | Added PCSbenefit is and variation id for Mandates,Limitations
 * 08/08/2017 | Rajesh Nagandla| T17 | Added Mandate Name from Setup to Runtime
 * 09/11/2017 | Goutham Rapolu | T18 | Added logic for US185 Get Benefits page is Read-Only for business - QA Complete Process
 * 1/31/2017  | Satya T        | T19 | Method to check whether the user is in Classic or lightning
 * 02/05/2018 | Sajitha Y      | T20 | Commented getPCSdata() method to stop call to PCS when User clicked on Get benefits button 
 *                                     as part of US1650 and changed error message No Benefit Information is available for the selected 
                                       Plan in PCS to No Benefit Information is available for the selected Plan
 *===========+============+========================================================================================
 */
public class AIA_Benefit_SummaryController {

    public  List<AIA_RxMandate__c> PPRxMandateRunTime{get;set;}     
    public  List<AIA_RxMandate__c> PPRxMandate{get;set;}        
    public  List<AIA_RxMandate__c> PPRxMandateReview{get;set;}
    public String BrfJur{get; set;}
    public string BRFPCSEffDate{get;set;}
    public  String resultvalue {get;set;}
    public string planId;
    public string propProdId {get; set;}
    public string propProductId;
    public string planIdValue;
    public string propProductCategoryStr             {get;set;}
    transient public AIA_PCS_BenefitSummary benftSum           {get;set;}
    public boolean showError {get;set;}
    public boolean isPCSdata {get;set;}
    public List<Proposed_Products__c> relatedMedicalPPList {get; set;}
    public boolean isASO{get;set;}
    //map to store PlanId with Plan record
    public map<Id,AIA_Plan__c> mapPlanIdToPlan = new map<Id,AIA_Plan__c>();
    public List<GrouperWrapper> grouperWrapList {get;set;}
    public List<GrouperWrapper> grouperWrapListCostShr {get;set;}
    public boolean isPPdata {get;set;}  // Whether the data should come from Propese Product schema or from the Plan Schema
    public List<AIA_Plan_Benefits__c> lstforCostShare {get; set;}
    public Map<String,AIA_Plan_Benefits__c> maplst {get;set;}
    public List<AIA_Benefits__c> bnftcostlst {get; set;}
    public Proposed_Products__c pp {get;set;}
    public string  ActualInPCPCopay = '';
    public string  ActualInSpecialistCopay = '';
    public string  ActualInPerAdmissionCopay = '';
    public string  ActualInCoinsuranceRange = '';
    public string  ActualInGeneralCoPay = '';
    public string  ActualOutPCPCopay = '';
    public string  ActualOutSpecialistCopay = '';
    public string  ActualOutPerAdmissionCopay = '';
    public string  ActualOutCoinsuranceRange = '';
    public string  ActualOutGeneralCoPay = '';
    public string CustRxPlanName{get;set;}
    public string jurpp{get;set;}
    
    public date BRFEffDate{get;set;}
    public date PPEffDate{get;set;}
    String jurisdictionFrmPP = '';
    public transient List<AIA_Plan_Grouper__c> planGrouperBenList = new List<AIA_Plan_Grouper__c>();
    public transient Set<ID> pgroupersID= new Set<ID>();
    public transient Set<String> groupNameSet = new Set<String>();
    public transient Map<String,AIA_Plan_Grouper__c> PlanMapGrouper= new Map<String,AIA_Plan_Grouper__c>();
    public transient Map<String,AIA_Plan_Benefits__c> MapGrouperBenefitsNet=new Map<String,AIA_Plan_Benefits__c>();
    // MAP :  Grouper Name, Benifit Name, In Net/OutNet, Benifit Record
    public transient Map<String, Map<String, Map<String, AIA_Plan_Benefits__c>>> benifitNetworkMap = new Map<String, Map<String, Map<String, AIA_Plan_Benefits__c>>>();
    public transient Set<id> benefitIdSet = new Set<id>();
    public transient  Map<String,set<String>> AllGrpParentBenName=new Map<String,set<String>> ();
    public transient Map<String,set<String>> AllParentBenName=new Map<String,set<String>> ();
    public transient Map<id, CopayTypeWrapper> copayBenMap = new Map<id, CopayTypeWrapper>();
    public transient CopayTypeWrapper copTypeWrapObj = new CopayTypeWrapper();
    public transient Set<String> CopayIDs=new Set<String>();
    public transient Map<String,List<Limitations__c>> ParentBenLimitationMan = new   Map<String,List<Limitations__c>>();
    public transient Map<String,List<Limitations__c>> ParentBenLimitationLimit = new   Map<String,List<Limitations__c>>();
    public transient Map<String,Set<String>> benLimitsAllMap = new  Map<String,Set<String>>();   
    public transient Set<String> PlanLimitIDs=new Set<String>();
    public list<grouperWrapper> initialgrouperWrapList;
    public transient Map<String,BenifitsrWrapper> ParentBenefitsMap=new Map<String,BenifitsrWrapper>();
    public transient  Map<string, BenifitsrWrapper> AllChildBenMap= new Map<String,BenifitsrWrapper>();
    public transient Map<String,List<Limitations__c>> ParBenLimitationMap= new Map<String,List<Limitations__c>>();
    public integer rowOrder {get;set;}
    public String grpId {get; set;}
    public integer rowHidden{get;set;}
    public decimal NoOfNW{get;set;}
    public decimal NoOfNWreview {get;set;}
    public Boolean PsetTrue{get;set;}
    public Boolean QAComplete{get;set;}
   
    //public boolean isLimitationEditableForClonedBRF {get;set;}//T12
    //constructor
    public AIA_Benefit_SummaryController(apexPages.StandardController controller){
        system.debug('SUMMARY CONSTRUCTOR');
        lstforCostShare = new List<AIA_Plan_Benefits__c>();
        pp= new Proposed_Products__c();
        isPPdata = False;
        isASO = false;
        propProdId = ApexPages.currentPage().getParameters().get('id');
        dispatcher();
        system.debug(Logginglevel.INFO,'inside ValidatePlanBenifits---grouperWrapList==='+grouperWrapList);       
    }
    public AIA_Benefit_SummaryController(){
        system.debug('SUMMARY CONSTRUCTOR');
        lstforCostShare = new List<AIA_Plan_Benefits__c>();
        pp= new Proposed_Products__c();
        isPPdata = False;
        isASO = false;
        groupNameSet = new Set<String>();
        
    }

    public pageReference mainInit(){
        try{
            system.debug('staring isASO>>>'+isASO);
            system.debug('================inside maininit=========');
            AIA_BenefitTriggerHandler.disableAdjustmentsOnUpdates(); // Bill T09, do not allow adjustment records for benefit changes.
            showError = false;
            isPCSdata = false;
            //isLimitationEditableForClonedBRF = '';//T12
            benftSum = new AIA_PCS_BenefitSummary();
            propProdId = ApexPages.currentPage().getParameters().get('id');
            propProductId  = ApexPages.currentPage().getParameters().get('idValue');
            //get Plan Id from Proposed Product
            // /*****T03 Start ************/
            list<Proposed_Products__c> propProdList = new  list<Proposed_Products__c> ();
            //T15 Added QA complete in Query
            if(propProdId!=null && propProdId!=''){
             propProdList=[Select id,Grandfathered_PPACA_Status__c,Plan_Name__r.Plan_Id__c,Plan_Name__r.QA_Complete__c,DHMO__c,Has_Benefit_Details__c,Plan_Name__c,Funding_Arrangement__c,Jurisdiction__c,
                                  Product_Category__c,Benefit_Request_Form__c, Benefit_Request_Form__r.Benefit_Effective_Date__c,Effective_Date__c,
                                  Benefit_Request_Form__r.Jurisdiction__c,Related_Medical_Product__c,Integrated_Non_Integrated__c,RX_OOP_Max_Integration__c,  
                                  Benefit_Request_Form__r.Status__c,Benefit_Request_Form__r.ARC_Approval_Status__c,Benefit_Request_Form__r.EffectiveDatePCSFormat__c,
                                  Benefit_Request_Form__r.Opportunity__r.Market_Segment_New__c,Benefit_Request_Form__r.Request_Type__c
                          from Proposed_Products__c 
                          Where id =: propProdId ]; //T11,T12
            }
            else{
                 showError = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'No proposed Product Id Found');
                 ApexPages.addMessage(myMsg);
            }
         
        //T18 Start
            PsetTrue = false;
            QAComplete = propProdList[0].Plan_Name__r.QA_Complete__c;
            String CPName = 'AIA_Plan_QA_Audit';
            PsetTrue = CF_CustomPermissionsReader_Helper.Permissions.PlanQAAudit;
        // T18 End
        
        //T15-start
         if(propProdList[0].Plan_Name__r.QA_Complete__c == false && propProdList[0].Has_Benefit_Details__c == false && PsetTrue == False){
         showError = true;
         ApexPages.Message myMsgQA = new ApexPages.Message(ApexPages.Severity.ERROR, 'Benefits cannot be retrieved since the plan associated is not QA complete. Please add a Marked-Up Benefit Summary');
         ApexPages.addMessage(myMsgQA);
         return null;
        } 
        //T15-End


            if(propProdList != NULL && propProdList.size() > 0){
                // system.debug('PLAN ID::'+propProdList[0].Plan_Name__c);
                pp=propProdList[0];
                planId = propProdList[0].Plan_Name__c; 
                planIdValue=  propProdList[0].Plan_Name__r.Plan_Id__c;
                BRFEffDate = pp.Benefit_Request_Form__r.Benefit_Effective_Date__c;
                BRFPCSEffDate = pp.Benefit_Request_Form__r.EffectiveDatePCSFormat__c;
                BrfJur = pp.Benefit_Request_Form__r.Jurisdiction__c;
                //T12-Added if statement
               /*isLimitationEditableForClonedBRF = true;
                if(pp.Funding_Arrangement__c == 'Risk' &&
                   pp.Benefit_Request_Form__r.Opportunity__r.Market_Segment_New__c == '200-999' && 
                   (pp.Benefit_Request_Form__r.Request_Type__c == 'Set-up Change - Benefit Changes' || 
                    pp.Benefit_Request_Form__r.Request_Type__c == 'Set-up Change - Admin and Benefit Changes'))
                {
                    isLimitationEditableForClonedBRF = false;
                } */
                system.debug('+++++EffectiveDateBRF++++'+BRFEffDate);
                system.debug('propProdList[0].Funding_Arrangement__c>>>'+propProdList[0].Funding_Arrangement__c);
                if(propProdList[0].Funding_Arrangement__c!='ASO'){
                    system.debug('isASO>>>'+isASO);
                    isASO=true;
                    system.debug('Change isASO>>>'+isASO);
                }
                
                //T11 start
                system.debug('pp.Benefit_Request_Form__r.Status__c'+pp.Benefit_Request_Form__r.Status__c+':'+planId);
                if(pp.Benefit_Request_Form__r.Status__c == 'Sold'){
                 showError = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Benefit Request Form cannot be modified after it has been sold.');
                 ApexPages.addMessage(myMsg);
                 return null;
                }
                if(!string.IsBlank(pp.Benefit_Request_Form__r.ARC_Approval_Status__c)){ 
                 showError = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Benefit Request Form cannot be modified after it has been submitted for ARC Approval.');
                 ApexPages.addMessage(myMsg);
                 return null;
                } //T11 end

                }
        
                    
            if(planId==null || planId==''){
                 showError = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'No Plan Name found for the Proposed Product .');
                 ApexPages.addMessage(myMsg);
            }
            if(planIdValue==null || planIdValue==''){
                 showError = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'No PCS Plan ID  found for the selected Plan .');
                 ApexPages.addMessage(myMsg);
            } 
           
            /*****T03 End ************/
            //Get Plan Record Info from Plan Id. This method has to be called before checking
            //the call out condition
            
            IF(planId!='' && planId!=null && showError==false){
                String QueryStr=QueryBase2.getSobjectAllFieldsSOQL('AIA_Plan__c', 'Id=:planId');
                AIA_Plan__c aia_Plan = database.query(QueryStr);
                NoOfNW = aia_Plan.CountOfNetworks__c; 
                //check if Benefit Summary has data & is valid, if it doesn't then make call out to PCS
                //otherwise get data from Salesforce objects
                
                if( !hasPPBnftDetails(pp))      
                {

                if(aia_Plan != NULL ){
                    if(aia_Plan != NULL && hasBnftSumry(aia_Plan)){
                 system.debug('IN hasBnftSumry');

                        if(aia_Plan != NULL && isPCScallReq(aia_Plan)){
                          system.debug('IN isPCScallReq');

                            isPCSdata = true;
                            // T20 - Start Commented PCS call as part of US1650
                            //getPCSdata();
                            // T20 - End
                            dispatcher();
                            system.debug('IF PCSdata from setup  :: '+aia_Plan);  
                        }else{
                            // getBenefitSummary_TO();
                              dispatcher();
                            system.debug('================inside maininit else=========');
                            system.debug('Else PCSdata :: '+aia_Plan);  
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
        }
        catch(exception ex){
            system.debug('Exception caught: '+ex.getLineNumber()+'- '+ex.getMessage());
            if(showError==False){
                showError=true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'ex-1'+ ex.getMessage());
                        ApexPages.addMessage(myMsg);
            }
        }
        system.debug('================propProdId ========='+propProdId );
        List<AIA_Grouper__c> aiaGrouperList= [Select id,IsCovered__c, DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, Name,OON_AnnualMaximumApplies__c,OON_DeductibleApplies__c,OON_DavisString__c,OON_IsCovered__c,
                                            CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c,
                                            OON_CoInsurance__c,OON_CoInsurance_AddIncrement__c,OON_CoInsurance_High__c,OON_CoInsurance_Increment__c,OON_CoInsurance_InvalidIncrement__c
                                            ,OON_CoInsurance_Low__c From AIA_Grouper__c Where Proposed_Products__c =: propProdId AND Group_Type__c = 'Benefit Group'];
        system.debug('===============aiaGrouperList========'+aiaGrouperList);
            if(aiaGrouperList.size()==0){
                saveAndContemp();
                isPPdata =false;
                dispatcher();
       if(pp.Product_Category__c == 'Drug'){
        //Get RXMandate from Plan     T08             
        AIA_BRF_DeepCloneHelper BRFCloneHelper = new AIA_BRF_DeepCloneHelper();     
        PPRxMandate = BRFCloneHelper.PlanRxMandate(Planid,pp,BRFEffDate,BrfJur);
        }        
        }       
        //Get RXMandate from PP     T08
      if(pp.Product_Category__c == 'Drug'){
       AIA_BRF_DeepCloneHelper BRFCloneHelper1 = new AIA_BRF_DeepCloneHelper();        
       PPRxMandateRunTime = BRFCloneHelper1.RxMandateRunTime(propProdId,null);          
       system.debug('====PPRxMandateRunTime==== :: '+PPRxMandateRunTime.size());        
       system.debug('====PPRxMandateRunTime==== :: '+PPRxMandateRunTime);  
       }
       return null; 
    }

    public void dispatcherTemp(){
        system.debug('===rowOrder======'+rowOrder);
        /*if(rowOrder==null){
            rowOrder = 0;
        }*/
        
        system.debug(Logginglevel.INFO,'inside dispatcherTemp---rowOrder==='+rowOrder);
        
        if(rowOrder != null){
            system.debug(Logginglevel.INFO,'inside dispatcherTemp---grouperWrapList==='+grouperWrapList);
            boolean isReview;//Temp
            Set<Id> bnfId = new Set<Id>();
            grouperWrapper gw = grouperWrapList[rowOrder];
            
            if(gw.aiaGrouper != null){
             system.debug('====aiaGrouper===='+gw.aiaGrouper.id);
            
               if(pp.funding_Arrangement__c == 'Risk'){
              //  List<AIA_Benefits__c> benifitList = new List<AIA_Benefits__c>();
              //  String qrybenifitList = QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefits__c', 'IS_ASO_Only__c = False and Grouper__c =: gw.aiaGrouper.id Order by Sequence_Number_SF__c asc');
              //  benifitList = Database.query(qrybenifitList);
             List<AIA_Benefits__c> benifitList = new List<AIA_Benefits__c>([Select id,Name, Benefit_Name__c,Benefit_Summary_Comment__c, Copay_Type_2_Increment__c ,Copay_Type_2_Additional_Increments__c ,
                            CopayType2_Additional_InvalidIncrement__c,Copay_Type_1_Increment__c , Copay_Type_1_Additional_Increments__c ,Copay_Type_1_AdditionalInvalidIncrements__c,
                            Coinsurance_DefaultAmount__c, OON_Coinsurance_DefaultAmount__c,OON_CoInsurance_AmountValueSelected__c, Copay_Min_Payment__c,Copay_Type_1_Mandate_Name__c ,
                            Copay_Max_Payment__c,Copay_Type_1_High__c , Copay_Type_1_DefaultAmount__c,CoInsurance_AmountValueSelected__c,Copay_Type_1_AliasName__c,Copay_Type_2_High__c , 
                            Copay_Type_1_Low__c, Copay_Type_2_Low__c  ,Copay_Type_2_AliasName__c,OON_Copay_Type_1_AliasName__c,OON_Copay_Type_2_AliasName__c,Copay_Type_1_Jurisdiction__c ,  
                            OON_Copay_Type_2_Additional_Increments__c, OON_Copay2_Low__c, OON_Copay2_High__c,OON_Copay2_Increment__c, OON_Copay2Additional_InvalidIncrements__c, 
                            OON_Copay_Type_1_IsCovered__c,Copay_Type_1_IsCovered__c,Copay_Type_1_DeductibleApplies__c,OON_Copay_Min_Payment__c,OON_Copay_Max_Payment__c,
                            OON_Copay_Type_1_DefaultAmount__c,Copay_Type_1_AmountValueSelected__c,Copay_Type_2_AmountValueSelected__c,OON_Copay_AmountLow__c, OON_Copay_AmountHigh__c,  
                            OON_Copay_Additional_Increments__c, OON_Copay_Additional_InvalidIncrements__c,OON_Copay_AmountIncrement__c, OON_Copay_Type_1_AmountValueSelected__c,
                            OON_Copay_Type_2_AmountValueSelected__c,OON_Copay_Type_1_DeductibleApplies__c,  Benefit_Type__c , Sequence_Number__c,Sequence_Number_SF__c, 
                            Copay_Type_1_Benefit_Comment_Codes__c
                            ,IS_ASO_Only__c, Tier_type__c ,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c, Mandate_Yes_No__c ,IN_CostShare_3Month_DeductibleCarryover__c, ON_CostShare_3Month_DeductibleCarryover__c,
                            OON_Tier_Type_Default__c, Tier_Type_Default__c, OON_Copay_Default_Max_Payment__c, OON_Copay_Default_Min_Payment__c, Copay_Type_1_Default_IsCovered__c,
                            Copay_Type_1_Default_DeductibleApplies__c, Copay_Default_Min_Payment__c, Copay_Default_Max_Payment__c, OON_Copay_Type_1_Default_IsCovered__c,
                            OON_Copay_1_Default_DeductibleApplies__c,Cost_Share_Type__c, Discount_Amount__c, ScheduledAmounts__c, Allowed_Amount__c,Discount_Amount_Percent__c,Discount_Applies__c, OON_Discount_Applies__c,
                            OON_Allowed_Amount__c, OON_ScheduledAmounts__c, OON_Discount_Amount__c, OON_Discount_Amount_Percent__c,Davis_Benefit_Variable__c,AnnualMaximumApplies__c,Davis_Variable_customized__c, Davis_Benefit_Variable_Default__c, OON_AnnualMaximumApplies__c  //T04 Vision fields added
                            ,OON_Coinsurance_AmountLow__c,OON_Coinsurance_AmountHigh__c, OON_Coinsurance_AmountIncrement__c, OON_Coinsurance_AddtionalIncrements__c, OON_Coinsurance_InvalidIncrements__c,
                            Coinsurance_AmountLow__c, Coinsurance_AmountHigh__c, Coinsurance_AmountIncrement__c, Coinsurance_Amount_AddtionalIncrements__c, Coinsurance_Amount_InvalidIncrements__c,
                            Allowed_Amount_Default__c,OON_Allowed_Amount_Default__c,Discount_Amount_Default__c,OON_Discount_Amount_Default__c,Discount_Amount_Percent_Default__c,
                            OON_Discount_Amount_Percent_Default__c,Discount_Applies_Default__c,OON_Discount_Applies_Default__c,ScheduledAmounts_Default__c,OON_ScheduledAmounts_Default__c
                            ,INN_MandateLockDownInd__c, INN_MappingBRFBenefitID__c, ONN_MappingBRFBenefitID__c, ONN_MandateLockDownInd__c
                            ,IN_Approximate_Member_Payment_w_Discount__c,IN_Approx_Member_Payment_w_Disc_Default__c,
                            ON_Approximate_Member_Payment_w_Discount__c,ON_Approx_Member_Payment_w_Disc_Default__c
                             from AIA_Benefits__c 
                            where IS_ASO_Only__c = False and 
                                  Grouper__c =: gw.aiaGrouper.id //and
                                 // Copay_Type_1_IsCovered__c != 'N/A' and 
                                 // OON_Copay_Type_1_IsCovered__c != 'N/A' 
                            Order by Sequence_Number_SF__c asc]);
                            
                            
                              System.debug('++++benifitList++'+benifitList);
                for(AIA_Benefits__c benObj : benifitList) {
                    
                    /*if(benObj.Benefit_Name__c== 'PCP Copay')
                        ActualInPCPCopay = benObj.Cost_Share_SelectedAmount__c;
                    else if(benObj.Benefit_Name__c== 'Specialist Copay')
                        ActualInSpecialistCopay = benObj.Cost_Share_SelectedAmount__c;
                    else if(benObj.Benefit_Name__c== 'Per Admission Copay')
                        ActualInPerAdmissionCopay = benObj.Cost_Share_SelectedAmount__c;
                    else if(benObj.Benefit_Name__c== 'Coinsurance')
                        ActualInCoinsuranceRange = benObj.Cost_Share_SelectedAmount__c; */
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
            
            
            List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c, comment_codes__c, IsSelected__c, Jurisdiction__c, Limitation_ExtID__c, Limitations_NonEditable__c, Benefit_Type__c,
                                                                   MaxAge_Selected__c, MaxDuration_Selected__c, TierAge_Selected__c, TierLimit_Selected__c,MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c, 
                                                                   MaxDuration__c, ParentBenefitName__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, 
                                                                    MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
                                                               MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,  
                                                               TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c, TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
                                                                   TierLimitTo__c, TierLimitType__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c , Effective_Date__c, Term_Date__c,CommentType__c
                                                                   FROM Limitations__c where Benefit__c in:bnfId]);
            Map<ID,List<Limitations__c>> maplmt = new Map<Id,List<Limitations__c>>();
            
            for(Limitations__c obj:lmtsn){
                List<Limitations__c> lmts=new List<Limitations__c>();
                if(maplmt.containsKey(obj.Benefit__c)){
                    lmts=maplmt.get(obj.Benefit__c);
                }
                if(isReview==true){
                    if(obj.IsSelected__c==true || obj.MaxAge_Selected__c == true || obj.MaxDuration_Selected__c == true || obj.TierAge_Selected__c == true || obj.TierLimit_Selected__c == true)
                        lmts.add(obj);
                }
                else
                    lmts.add(obj);
                maplmt.put(obj.Benefit__c,lmts);
            }
            System.debug('+++maplmt++++'+maplmt);
            
            List<BenifitsrWrapper> benWrapList = new List<BenifitsrWrapper>();
    
            for(AIA_Benefits__c benObj : benifitList) {
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
                    //benWrapObj.benifitlmt=String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxValue__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxType__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxApply__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxDuration__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxDurationType__c);
                    System.debug('++maplmt.get(benObj.id)++++'+maplmt.get(benObj.id));
                    benWrapObj.lstlimit = maplmt.get(benObj.id);
                    
                    benWrapObj.lstJurisdictions = getjurdictions(benWrapObj.lstlimit);
                }
                else{
                    benWrapObj.benifitNameStr = benObj.Benefit_Name__c;
                }
                system.debug('Benefit name--'+benObj.Benefit_Name__c+'----'+benObj.Benefit_Type__c);
                benWrapObj.aiaBenifitObj = benObj;
                SYSTEM.debug('dispatcherTemp===benObj==========='+benObj);   
                if(bnfId.contains(benObj.Id))
                    benWrapList.add(benWrapObj);
            }
            gw.benifitWrapList = benWrapList;
            SYSTEM.debug('=============='+benWrapList);   
            }
        
                       if(pp.funding_Arrangement__c== 'ASO'){
              //  List<AIA_Benefits__c> benifitList = new List<AIA_Benefits__c>();
             //  String qrybenifitList = QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefits__c', 'Grouper__c in: gw.aiaGrouper.id Order by Sequence_Number_SF__c asc');
             //   benifitList = Database.query(qrybenifitList);
             List<AIA_Benefits__c> benifitList = new List<AIA_Benefits__c>([Select id,Name, Benefit_Name__c,Benefit_Summary_Comment__c, Copay_Type_2_Increment__c ,Copay_Type_2_Additional_Increments__c ,
                            CopayType2_Additional_InvalidIncrement__c,Copay_Type_1_Increment__c , Copay_Type_1_Additional_Increments__c ,Copay_Type_1_AdditionalInvalidIncrements__c,
                            Coinsurance_DefaultAmount__c, OON_Coinsurance_DefaultAmount__c,OON_CoInsurance_AmountValueSelected__c, Copay_Min_Payment__c,Copay_Type_1_Mandate_Name__c ,
                            Copay_Max_Payment__c,Copay_Type_1_High__c , Copay_Type_1_DefaultAmount__c,CoInsurance_AmountValueSelected__c,Copay_Type_1_AliasName__c,Copay_Type_2_High__c , 
                            Copay_Type_1_Low__c, Copay_Type_2_Low__c  ,Copay_Type_2_AliasName__c,OON_Copay_Type_1_AliasName__c,OON_Copay_Type_2_AliasName__c,Copay_Type_1_Jurisdiction__c ,  
                            OON_Copay_Type_2_Additional_Increments__c, OON_Copay2_Low__c, OON_Copay2_High__c,OON_Copay2_Increment__c, OON_Copay2Additional_InvalidIncrements__c, 
                            OON_Copay_Type_1_IsCovered__c,Copay_Type_1_IsCovered__c,Copay_Type_1_DeductibleApplies__c,OON_Copay_Min_Payment__c,OON_Copay_Max_Payment__c,
                            OON_Copay_Type_1_DefaultAmount__c,Copay_Type_1_AmountValueSelected__c,Copay_Type_2_AmountValueSelected__c,OON_Copay_AmountLow__c, OON_Copay_AmountHigh__c,  
                            OON_Copay_Additional_Increments__c, OON_Copay_Additional_InvalidIncrements__c,OON_Copay_AmountIncrement__c, OON_Copay_Type_1_AmountValueSelected__c,
                            OON_Copay_Type_2_AmountValueSelected__c,OON_Copay_Type_1_DeductibleApplies__c,  Benefit_Type__c , Sequence_Number__c,Sequence_Number_SF__c, 
                            Copay_Type_1_Benefit_Comment_Codes__c
                            ,IS_ASO_Only__c, Tier_type__c ,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c, Mandate_Yes_No__c ,IN_CostShare_3Month_DeductibleCarryover__c, ON_CostShare_3Month_DeductibleCarryover__c,
                            OON_Tier_Type_Default__c, Tier_Type_Default__c, OON_Copay_Default_Max_Payment__c, OON_Copay_Default_Min_Payment__c, Copay_Type_1_Default_IsCovered__c,
                            Copay_Type_1_Default_DeductibleApplies__c, Copay_Default_Min_Payment__c, Copay_Default_Max_Payment__c, OON_Copay_Type_1_Default_IsCovered__c,
                            OON_Copay_1_Default_DeductibleApplies__c,Cost_Share_Type__c, Discount_Amount__c, ScheduledAmounts__c, Allowed_Amount__c,Discount_Amount_Percent__c,Discount_Applies__c, OON_Discount_Applies__c,
                            OON_Allowed_Amount__c, OON_ScheduledAmounts__c, OON_Discount_Amount__c, OON_Discount_Amount_Percent__c,Davis_Benefit_Variable__c,AnnualMaximumApplies__c,Davis_Variable_customized__c, Davis_Benefit_Variable_Default__c, OON_AnnualMaximumApplies__c  //T04 Vision fields added
                            ,OON_Coinsurance_AmountLow__c,OON_Coinsurance_AmountHigh__c, OON_Coinsurance_AmountIncrement__c, OON_Coinsurance_AddtionalIncrements__c, OON_Coinsurance_InvalidIncrements__c,
                            Coinsurance_AmountLow__c, Coinsurance_AmountHigh__c, Coinsurance_AmountIncrement__c, Coinsurance_Amount_AddtionalIncrements__c, Coinsurance_Amount_InvalidIncrements__c,
                            Allowed_Amount_Default__c,OON_Allowed_Amount_Default__c,Discount_Amount_Default__c,OON_Discount_Amount_Default__c,Discount_Amount_Percent_Default__c,
                            OON_Discount_Amount_Percent_Default__c,Discount_Applies_Default__c,OON_Discount_Applies_Default__c,ScheduledAmounts_Default__c,OON_ScheduledAmounts_Default__c
                            ,INN_MandateLockDownInd__c, INN_MappingBRFBenefitID__c, ONN_MappingBRFBenefitID__c, ONN_MandateLockDownInd__c,
                            IN_Approximate_Member_Payment_w_Discount__c,IN_Approx_Member_Payment_w_Disc_Default__c,
                            ON_Approximate_Member_Payment_w_Discount__c,ON_Approx_Member_Payment_w_Disc_Default__c 
                            from AIA_Benefits__c 
                            where Grouper__c =: gw.aiaGrouper.id  
                            Order by Sequence_Number_SF__c asc]);
                            
                            
                              System.debug('++++benifitList++'+benifitList);
                for(AIA_Benefits__c benObj : benifitList) {
                    
                    /*if(benObj.Benefit_Name__c== 'PCP Copay')
                        ActualInPCPCopay = benObj.Cost_Share_SelectedAmount__c;
                    else if(benObj.Benefit_Name__c== 'Specialist Copay')
                        ActualInSpecialistCopay = benObj.Cost_Share_SelectedAmount__c;
                    else if(benObj.Benefit_Name__c== 'Per Admission Copay')
                        ActualInPerAdmissionCopay = benObj.Cost_Share_SelectedAmount__c;
                    else if(benObj.Benefit_Name__c== 'Coinsurance')
                        ActualInCoinsuranceRange = benObj.Cost_Share_SelectedAmount__c; */
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
            
            
            List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c, comment_codes__c, IsSelected__c, Jurisdiction__c, Limitation_ExtID__c, Limitations_NonEditable__c,Benefit_Type__c,
                                                                   MaxAge_Selected__c, MaxDuration_Selected__c, TierAge_Selected__c, TierLimit_Selected__c,MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c,
                                                                   MaxDuration__c, ParentBenefitName__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, 
                                                                    MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
                                                               MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,  
                                                               TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c, TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
                                                                   TierLimitTo__c, TierLimitType__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c, Effective_Date__c, Term_Date__c,CommentType__c
                                                                   FROM Limitations__c where Benefit__c in:bnfId]);
            Map<ID,List<Limitations__c>> maplmt = new Map<Id,List<Limitations__c>>();
            
           
           for(Limitations__c obj:lmtsn){
                List<Limitations__c> lmts=new List<Limitations__c>();
                if(maplmt.containsKey(obj.Benefit__c)){
                    lmts=maplmt.get(obj.Benefit__c);
                }
                if(isReview==true){
                    if(obj.IsSelected__c==true || obj.MaxAge_Selected__c == true || obj.MaxDuration_Selected__c == true || obj.TierAge_Selected__c == true || obj.TierLimit_Selected__c == true)
                        lmts.add(obj);
                }
                else
                    lmts.add(obj);
                maplmt.put(obj.Benefit__c,lmts);
            }
            System.debug('+++maplmt++++'+maplmt);
            
            List<BenifitsrWrapper> benWrapList = new List<BenifitsrWrapper>();
    
            for(AIA_Benefits__c benObj : benifitList) {
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
                    //benWrapObj.benifitlmt=String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxValue__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxType__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxApply__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxDuration__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxDurationType__c);
                    System.debug('++maplmt.get(benObj.id)++++'+maplmt.get(benObj.id));
                    benWrapObj.lstlimit = maplmt.get(benObj.id);
                    benWrapObj.lstJurisdictions = getjurdictions(benWrapObj.lstlimit);
                }
                else{
                    benWrapObj.benifitNameStr = benObj.Benefit_Name__c;
                }
                system.debug('Benefit name--'+benObj.Benefit_Name__c+'----'+benObj.Benefit_Type__c);
                benWrapObj.aiaBenifitObj = benObj;
                SYSTEM.debug('benObj===ASO==========='+benObj);   
                if(bnfId.contains(benObj.Id))
                    benWrapList.add(benWrapObj);
            }
            gw.benifitWrapList = benWrapList;
            SYSTEM.debug('benWrapList=============='+benWrapList);   
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
    
    
  public void dispatcher() {
        try{
            showError=false;
             system.debug('================inside dispatcher=========');
            isPPdata = False;
            Boolean isIntegrationCall = False;
            propProductCategoryStr = '';
            propProdId = ApexPages.currentPage().getParameters().get('id');
            String planIdStr;
          /*****T03 Start ************/
            List<Proposed_Products__c> ppList = new List<Proposed_Products__c> ();
             List<AIA_Grouper__c> aiaGrouperList=new  List<AIA_Grouper__c>();
            if(propProdId!=null && propProdId!=''){
                 ppList= [Select Plan_Name__c,Grandfathered_PPACA_Status__c,DHMO__c,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Related_Medical_Product__c,
                                                 Benefit_Request_Form__c, Benefit_Request_Form__r.Jurisdiction__c  
                                                 from Proposed_Products__c Where id =: propProdId ];
                aiaGrouperList=  [Select id,IsCovered__c, DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, Name,OON_AnnualMaximumApplies__c,OON_DeductibleApplies__c,OON_DavisString__c,OON_IsCovered__c,
                                CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c,
                                OON_CoInsurance__c,OON_CoInsurance_AddIncrement__c,OON_CoInsurance_High__c,OON_CoInsurance_Increment__c,OON_CoInsurance_InvalidIncrement__c
                                ,OON_CoInsurance_Low__c From AIA_Grouper__c Where Proposed_Products__c =: propProdId AND Group_Type__c = 'Benefit Group'];
                /** Added order by clause to sort cost shares by Sequence Number - T06**/
                bnftcostlst = new List<AIA_Benefits__c>([select id,name,Benefit_Name__c, Cost_Share_Default_Amount__c, OON_Cost_Share_Default_Amount__c,Cost_Share_Low__c,Cost_Share_Type__c,
                                                         Cost_Share_High__c,Cost_Share_Increment__c,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c, Cost_Share_AdditionalIncrements__c, Cost_Share_InvalidIncrements__c,   
                                                         OON_Cost_Share_InvalidIncrements__c,IsRelatedCostShareCheck__c, OON_Cost_Share_AdditionalIncrements__c,OON_Cost_Share_Low__c,OON_Cost_Share_High__c,IN_CostShare_3Month_DeductibleCarryover__c, ON_CostShare_3Month_DeductibleCarryover__c,
                                                         OON_Cost_Share_Increment__c,OON_Cost_Share_SelectedAmount__c,Cost_Share_SelectedAmount__c ,IS_ASO_Only__c, Tier_type__c , Mandate_Yes_No__c, Grouper__r.Proposed_Products__r.Related_Medical_Product__c,Grouper__r.Proposed_Products__r.Integrated_Non_Integrated__c,Grouper__r.Proposed_Products__r.RX_OOP_Max_Integration__c 
                                                         from AIA_Benefits__c 
                                                         where Grouper__r.Group_Type__c ='Cost Share Group' and Grouper__r.Proposed_Products__c=:propProdId and 
                                                         Grouper__r.Proposed_Products__c=:propProdId and 
                                                         Grouper__r.Grouper_RecordtypeName__c='Proposed_Proposed'
                                                         order by Sequence_Number__c asc]);
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
                                                 
                system.debug('ppList---'+ppList.size()+'----'+ppList[0].id);
            }
            else{
                 showError = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Proposed Product Id Not Found');
                 ApexPages.addMessage(myMsg);
            }
           
            if( ppList != null && ppList.size()>0 ) {
                pp=ppList[0];
                planIdStr = ppList[0].Plan_Name__c;
                propProductCategoryStr = ppList[0].Product_Category__c;
            }
           
           
            if(aiaGrouperList.size()>0 && ppList[0].Has_Benefit_Details__c==false ){
                 showError = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Benefit Details are already added for proposed product. Update Has benefits details to true');
                 ApexPages.addMessage(myMsg);
            }
             if(planIdStr==null || planIdStr==''){
                 showError = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'No Plan is added for the PP. Update the Plan name for the PP');
                 ApexPages.addMessage(myMsg);
            } /*****T03 End ************/
            isPPdata = false;
            system.debug('isPPdata---'+isPPdata);
    
            system.debug(Logginglevel.INFO,'inside dispatcher---aiaGrouperList==='+aiaGrouperList);
            system.debug(Logginglevel.INFO,'inside dispatcher---showError==='+showError);           
            if(aiaGrouperList.size()>0 && showError==false) {
                isPPdata = True;
               // createListFromPP(propProdId,false);
                createListFromPPTemp(propProdId,false);
                system.debug(Logginglevel.INFO,'inside dispatchershowError---grouperWrapList==='+grouperWrapList);
            }else  if(aiaGrouperList.isEmpty() && showError==false){
                isPPdata = False;
                system.debug('isPPdata---'+isPPdata);
                system.debug(Logginglevel.INFO,'inside dispatcher---grouperWrapList==='+grouperWrapList);
                system.debug(Logginglevel.INFO,'inside dispatcher---planIdStr==='+planIdStr);                   
                system.debug('================inside dispatcher else get from setup =========');
                if(planIdStr != null && planIdStr != '') {
    
                    createWrapListFromPlan(ppList[0]);
                    createWrapListFromPlanCostShr(planIdStr); 
                }
                system.debug(Logginglevel.INFO,'inside dispatcherAfter---grouperWrapList==='+grouperWrapList);
            }
        }
        
        catch (Exception ex){
             system.debug('Exception caught: '+ex.getLineNumber()+'- '+ex.getMessage());
               if(showError==False){
                    showError=true;
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'ex-3'+ ex.getMessage());
                            
                }
        }
       

    }

    public pageReference reviewInit(){
        try{
            propProdId = ApexPages.currentPage().getParameters().get('id');
            
            String QSReview=QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Proposed_Products__c','Id=:propProdId','Plan_Name__r.CountOfNetworks__c,');
            Proposed_Products__c PPNoofNW = database.query(QSReview);
            NoOfNWreview = PPNoofNW.Plan_Name__r.CountOfNetworks__c;
            
            String planIdStr;
            List<AIA_Grouper__c> aiaGrouperList=   [Select id,IsCovered__c, DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, Name,OON_AnnualMaximumApplies__c,OON_DeductibleApplies__c,OON_DavisString__c,OON_IsCovered__c,
                                                CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c,
                                                OON_CoInsurance__c,OON_CoInsurance_AddIncrement__c,OON_CoInsurance_High__c,OON_CoInsurance_Increment__c,OON_CoInsurance_InvalidIncrement__c
                                                ,OON_CoInsurance_Low__c From AIA_Grouper__c Where Proposed_Products__c =: propProdId AND Group_Type__c = 'Benefit Group'];
            List<Proposed_Products__c> ppList = [Select Grandfathered_PPACA_Status__c,Plan_Name__c,DHMO__c,Has_Benefit_Details__c,Product_Category__c,Benefit_Request_Form__c, Benefit_Request_Form__r.Jurisdiction__c, Funding_Arrangement__c,Jurisdiction__c ,Related_Medical_Product__c 
                                                 from Proposed_Products__c Where id =: propProdId ];
            /** Added order by clause to sort cost shares by Sequence Number - T06**/
            bnftcostlst = new List<AIA_Benefits__c>([select id,name,Benefit_Name__c, Cost_Share_Default_Amount__c, OON_Cost_Share_Default_Amount__c,Cost_Share_Low__c,IN_CostShare_3Month_DeductibleCarryover__c, ON_CostShare_3Month_DeductibleCarryover__c,
                                                     Cost_Share_High__c,Cost_Share_Increment__c, IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c,Cost_Share_AdditionalIncrements__c, Cost_Share_InvalidIncrements__c,   
                                                     OON_Cost_Share_InvalidIncrements__c, OON_Cost_Share_AdditionalIncrements__c,OON_Cost_Share_Low__c,OON_Cost_Share_High__c,Cost_Share_Type__c,
                                                     OON_Cost_Share_Increment__c,OON_Cost_Share_SelectedAmount__c,Cost_Share_SelectedAmount__c ,IS_ASO_Only__c, Tier_type__c , Mandate_Yes_No__c 
                                                     from AIA_Benefits__c 
                                                     where Grouper__r.Group_Type__c ='Cost Share Group' and 
                                                     Grouper__r.Proposed_Products__c=:propProdId and 
                                                     Grouper__r.Grouper_RecordtypeName__c='Proposed_Proposed'
                                                     order by Sequence_Number__c asc]);
            system.debug('ppList---'+ppList.size()+'----'+ppList[0].id);
            if( ppList != null && ppList.size()>0 ) {
                pp=ppList[0];
                planIdStr = ppList[0].Plan_Name__c;
                propProductCategoryStr = ppList[0].Product_Category__c;
            }
            isPPdata = false;
            system.debug('isPPdata---'+isPPdata);

            if(aiaGrouperList.size()>0) {
                isPPdata = True;
                createListFromPP(propProdId,true);
            }
            if(pp.Product_Category__c == 'Drug'){
                AIA_GetCustomRxPlanName rxObjName = new AIA_GetCustomRxPlanName();
                CustRxPlanName = rxObjName.CustomRxPlanName(propProdId); 
                // T08
                AIA_BRF_DeepCloneHelper BRFCloneHelper2 = new AIA_BRF_DeepCloneHelper();        
                PPRxMandateReview = BRFCloneHelper2.RxMandateReview(pp);        
                system.debug('====PPRxMandateReview==== :: '+PPRxMandateReview.size());     
                system.debug('====PPRxMandateReview==== :: '+PPRxMandateReview);   
            }
        }
        catch(Exception ex){
            system.debug('Exception caught: '+ex.getLineNumber()+'- '+ex.getMessage());
            ApexPages.addMessages(ex);
        }
        return null; 
    }

     public pageReference saveAndContemp(){
        // system.debug('@@ initialgrouperWrapList in saveandcon'+initialgrouperWrapList);
        //saveAndContSfdc();
        pageReference pgRef = null;
        boolean isModified = false;
        System.debug('++++++grouperWrapList++++'+grouperWrapList);
        showError = false;
        system.debug('@@ in saveAndCon');
       /* if(ValidatePlanBenifits(pp))
        {
            SaveAndContinuePlanBenefits( pp);
        }
        else
        {
            system.debug('@@showError' + showError);
            showError = true;
        }*/
        ValidatePlanBenifits(pp);
        SaveAndContinuePlanBenefits( pp);
        DentalBenupdate(pp);
        //pgRef = new pageReference('/apex/AIA_ProposedProd_Review');

       // pgRef.getParameters().put('planId',pp.Plan_Name__c);


       // pgRef.getParameters().put('id',propProdId);
       // pgRef.setRedirect(true);
        return null;//pgRef;
    }
    
    
        public pageReference saveAndCon(){
        try{
             pageReference pgRef = null;
            boolean isModified = false;
            System.debug('++++++grouperWrapList++++'+grouperWrapList);
    
            system.debug('@@ in saveAndCon');
            /*if(ValidatePlanBenifits(pp))
            {
                SaveAndContinuePlanBenefits( pp);
            }
            else
            {
                showError = true;
            }*/
            ValidatePlanBenifits(pp);
            SaveAndContinuePlanBenefits( pp);
            DentalBenupdate(pp);
            pgRef = new pageReference('/apex/AIA_ProposedProd_Review');
    
            pgRef.getParameters().put('planId',pp.Plan_Name__c);
    
    
            pgRef.getParameters().put('id',propProdId);
            pgRef.setRedirect(true);
            return pgRef;
        }
          catch(DMLException dex){
            system.debug('Exception caught: '+dex.getLineNumber()+'- '+dex.getMessage());
            if(showError==False){
                showError=true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'ex-5'+ dex.getMessage());
                        ApexPages.addMessage(myMsg);
            }
               return null;
        }
         catch(Exception ex){
            system.debug('Exception caught: '+ex.getLineNumber()+'- '+ex.getMessage());
           if(showError==False){
                showError=true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'ex-6'+ ex.getMessage());
                        ApexPages.addMessage(myMsg);
            }
             return null;
        }
         
       
    }


    public void createListFromPPTemp(String propProdId, Boolean isReview){
        grouperWrapList = new List<GrouperWrapper>();       
    System.debug('+++++grpId+='+grpId); 
        Set<Id> grouperId = new Set<Id>();
        Map<String,List<AIA_Benefits__c>> mapGrpIdToLstBenifit = new Map<String,List<AIA_Benefits__c>>();
      /*for(AIA_Grouper__c grp: [Select id, Name,IsCovered__c,Grouper_Record_Type__c , DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c,  
                      OON_IsCovered__c, OON_DeductibleApplies__c, OON_AnnualMaximumApplies__c, OON_DavisString__c, OON_CoInsurance__c,OON_CoInsurance_Low__c,OON_CoInsurance_High__c,OON_CoInsurance_Increment__c,OON_CoInsurance_AddIncrement__c,OON_CoInsurance_InvalidIncrement__c 
                      From AIA_Grouper__c Where Benefit_Design_Product__c =: propProdId AND Group_Type__c = 'Benefit Group'        
        order by Sequence_Number__c ]){      
        GrouperWrapper grpNameWrapObj = new GrouperWrapper(grp, grouperWrapList.size());        
        grouperWrapList.add(grpNameWrapObj);*/

        List<AIA_Grouper__c> planGrouperBenList = [Select id,IsCovered__c, DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, Name,OON_AnnualMaximumApplies__c,OON_DeductibleApplies__c,OON_DavisString__c,OON_IsCovered__c,
                                CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c,
                                OON_CoInsurance__c,OON_CoInsurance_AddIncrement__c,OON_CoInsurance_High__c,OON_CoInsurance_Increment__c,OON_CoInsurance_InvalidIncrement__c
                                ,OON_CoInsurance_Low__c From AIA_Grouper__c Where Proposed_Products__c =: propProdId AND Group_Type__c = 'Benefit Group' 
                                 and Grouper_Record_Type__c='BRF' and Grouper_RecordtypeName__c='Proposed_Proposed' order by Sequence_Number__c ];
        
        for(AIA_Grouper__c groupObj : planGrouperBenList) {
            GrouperWrapper grpNameWrapObj = new GrouperWrapper(groupObj, grouperWrapList.size());        
            grouperWrapList.add(grpNameWrapObj);
            //grouperId.add(groupObj.id);
        }
       List<AIA_Benefits__c> lstAIABenefit = new List<AIA_Benefits__c>();
        String qrylstAIABenefit = QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefits__c', 'Grouper__c IN: grouperId Order by Sequence_Number_SF__c asc');
        lstAIABenefit = Database.query(qrylstAIABenefit);
        
        for(AIA_Benefits__c BenefitObj : lstAIABenefit) {
            if(mapGrpIdToLstBenifit.containsKey(BenefitObj.Grouper__c))
            {
                mapGrpIdToLstBenifit.get(BenefitObj.Grouper__c).add(BenefitObj);
            }
            else{
                mapGrpIdToLstBenifit.put(BenefitObj.Grouper__c,new List<AIA_Benefits__c>{BenefitObj});
            }
        }
       //Grouper__c
       Set<Id> bnfId = new Set<Id>();
        system.debug(Logginglevel.INFO,'inside createListFromPPTemp---planGrouperBenList==='+planGrouperBenList);
        for(AIA_Benefits__c benefitObj : lstAIABenefit) {
            bnfId.add(benefitObj.id);            
        }
        List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c, comment_codes__c, IsSelected__c, Jurisdiction__c, Limitation_ExtID__c, Limitations_NonEditable__c, Benefit_Type__c,
                                                               MaxAge_Selected__c, MaxDuration_Selected__c, TierAge_Selected__c, TierLimit_Selected__c,MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c, 
                                                               MaxDuration__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
                                                                MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
                                                               MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,  
                                                               TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c, Effective_Date__c, Term_Date__c,
                                                               TierLimitTo__c, TierLimitType__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c , ParentBenefitName__c,CommentType__c
                                                               FROM Limitations__c where Benefit__c in:bnfId]);
        Map<ID,List<Limitations__c>> maplmt = new Map<Id,List<Limitations__c>>();
        system.debug(Logginglevel.INFO,'inside createListFromPPTemp---lmtsn==='+lmtsn);
       for(Limitations__c obj:lmtsn){
            List<Limitations__c> lmts=new List<Limitations__c>();
            if(maplmt.containsKey(obj.Benefit__c)){
                lmts=maplmt.get(obj.Benefit__c);
            }
            lmts.add(obj);
            maplmt.put(obj.Benefit__c,lmts);
        }
        system.debug(Logginglevel.INFO,'inside createListFromPPTemp---maplmt==='+maplmt);
        System.debug('+++maplmt++++'+maplmt);
        for(GrouperWrapper grpNameWrapObj : grouperWrapList) {
            //GrouperWrapper grpNameWrapObj = new GrouperWrapper();
            AIA_Grouper__c groupObj = grpNameWrapObj.aiaGrouper;
            //grpNameWrapObj.aiaGrouper = groupObj;
            List<BenifitsrWrapper> benWrapList = new List<BenifitsrWrapper>();
            List<AIA_Benefits__c> tmplstAIABenefit = new List<AIA_Benefits__c>();
            if(mapGrpIdToLstBenifit.containsKey(groupObj.id))
            {
                tmplstAIABenefit = mapGrpIdToLstBenifit.get(groupObj.id);
            }
            for(AIA_Benefits__c benObj : tmplstAIABenefit) {               
                BenifitsrWrapper benWrapObj = new BenifitsrWrapper();
                if(maplmt.containsKey(benObj.id)){
                    benWrapObj.benifitNameStr = benObj.Benefit_Name__c;
                    //benWrapObj.benifitlmt=String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxValue__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxType__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxApply__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxDuration__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxDurationType__c);
                    System.debug('++maplmt.get(benObj.id)++++'+maplmt.get(benObj.id));
                    List<Limitations__c> LiLimitation= new List<Limitations__c>();
                    LiLimitation = maplmt.get(benObj.id);
                    for(Limitations__c obj:LiLimitation){ 
                        if(benObj.Benefit_Type__c == 'Limitation'){      
                            obj.IsSelected__c = false;      
                            obj.TierLimit_Selected__c = false;      
                            obj.TierAge_Selected__c = false;        
                            obj.MaxDuration_Selected__c = false;        
                            obj.MaxAge_Selected__c = false;     
                        }
                    }                   
                    benWrapObj.lstlimit = LiLimitation;
                    benWrapObj.lstJurisdictions = getjurdictions(benWrapObj.lstlimit);
                }
                else{
                    benWrapObj.benifitNameStr = benObj.Benefit_Name__c;
                }
                system.debug('Benefit name--'+benObj.Benefit_Name__c+'----'+benObj.Benefit_Type__c);
                benWrapObj.aiaBenifitObj = benObj;
                system.debug('@@grouperWrapList line 478===benObj'+benObj);
                if(bnfId.contains(benObj.Id))
                    benWrapList.add(benWrapObj);
            }
            grpNameWrapObj.benifitWrapList = benWrapList;
            //grouperWrapList.add(grpNameWrapObj);

        }
    }


    public void createListFromPP(String propProdId, Boolean isReview) {
        grouperWrapList = new List<GrouperWrapper>();
        if(pp.funding_Arrangement__c == 'Risk'){
        // Start Change to add the Copay_Type_1_Jurisdiction__c and Copay_Type_1_Mandate_Name__c in query.
        List<AIA_Grouper__c> planGrouperBenList =  [Select id,IsCovered__c, DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, Name, CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c,
                                                    OON_CoInsurance__c,OON_CoInsurance_AddIncrement__c,OON_CoInsurance_High__c,OON_CoInsurance_Increment__c,OON_CoInsurance_InvalidIncrement__c,OON_AnnualMaximumApplies__c,OON_DeductibleApplies__c,OON_DavisString__c,OON_IsCovered__c
                                                    ,OON_CoInsurance_Low__c,(Select id,Name, Benefit_Name__c,Benefit_Summary_Comment__c, Copay_Type_2_Increment__c ,Copay_Type_2_Additional_Increments__c ,
                                                     CopayType2_Additional_InvalidIncrement__c,Copay_Type_1_Increment__c , Copay_Type_1_Additional_Increments__c ,Copay_Type_1_AdditionalInvalidIncrements__c,
                                                     Coinsurance_DefaultAmount__c, OON_Coinsurance_DefaultAmount__c,OON_CoInsurance_AmountValueSelected__c, Copay_Min_Payment__c,Copay_Type_1_Mandate_Name__c ,
                                                     Copay_Max_Payment__c,Copay_Type_1_High__c , Copay_Type_1_DefaultAmount__c,CoInsurance_AmountValueSelected__c,Copay_Type_1_AliasName__c,Copay_Type_2_High__c , 
                                                     Copay_Type_1_Low__c, Copay_Type_2_Low__c  ,Copay_Type_2_AliasName__c,OON_Copay_Type_1_AliasName__c,OON_Copay_Type_2_AliasName__c,Copay_Type_1_Jurisdiction__c ,  
                                                     OON_Copay_Type_2_Additional_Increments__c, OON_Copay2_Low__c, OON_Copay2_High__c,OON_Copay2_Increment__c, OON_Copay2Additional_InvalidIncrements__c, 
                                                     OON_Copay_Type_1_IsCovered__c,Copay_Type_1_IsCovered__c,Copay_Type_1_DeductibleApplies__c,OON_Copay_Min_Payment__c,OON_Copay_Max_Payment__c,
                                                     OON_Copay_Type_1_DefaultAmount__c,Copay_Type_1_AmountValueSelected__c,Copay_Type_2_AmountValueSelected__c,OON_Copay_AmountLow__c, OON_Copay_AmountHigh__c,  
                                                     OON_Copay_Additional_Increments__c, OON_Copay_Additional_InvalidIncrements__c,OON_Copay_AmountIncrement__c, OON_Copay_Type_1_AmountValueSelected__c,
                                                     OON_Copay_Type_2_AmountValueSelected__c,OON_Copay_Type_1_DeductibleApplies__c,  Benefit_Type__c , Sequence_Number__c,Sequence_Number_SF__c, 
                                                     Copay_Type_1_Benefit_Comment_Codes__c
                                                     ,IS_ASO_Only__c, Tier_type__c , Mandate_Yes_No__c ,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c,Cost_Share_Type__c,
                                                     OON_Tier_Type_Default__c, Tier_Type_Default__c, OON_Copay_Default_Max_Payment__c, OON_Copay_Default_Min_Payment__c, Copay_Type_1_Default_IsCovered__c,
                                                     Copay_Type_1_Default_DeductibleApplies__c, Copay_Default_Min_Payment__c, Copay_Default_Max_Payment__c, OON_Copay_Type_1_Default_IsCovered__c,
                                                     OON_Copay_1_Default_DeductibleApplies__c,IN_CostShare_3Month_DeductibleCarryover__c, ON_CostShare_3Month_DeductibleCarryover__c,
                                                     IN_CostShare_3Month_DedCarryover_Default__c, OON_CostShare_3MonthDedCarryover_Default__c,Discount_Amount__c, ScheduledAmounts__c, Allowed_Amount__c, Discount_Amount_Percent__c,Discount_Applies__c, OON_Discount_Applies__c,
                                                     OON_Allowed_Amount__c, OON_ScheduledAmounts__c, OON_Discount_Amount__c, OON_Discount_Amount_Percent__c,Davis_Benefit_Variable__c,Davis_Variable_customized__c,Davis_Benefit_Variable_Default__c,AnnualMaximumApplies__c,OON_AnnualMaximumApplies__c    //T04                                                 
                                                     ,OON_Coinsurance_AmountLow__c,OON_Coinsurance_AmountHigh__c, OON_Coinsurance_AmountIncrement__c, OON_Coinsurance_AddtionalIncrements__c, OON_Coinsurance_InvalidIncrements__c,
                                                     Coinsurance_AmountLow__c, Coinsurance_AmountHigh__c, Coinsurance_AmountIncrement__c, Coinsurance_Amount_AddtionalIncrements__c, Coinsurance_Amount_InvalidIncrements__c,
                                                     Allowed_Amount_Default__c,OON_Allowed_Amount_Default__c,Discount_Amount_Default__c,OON_Discount_Amount_Default__c,Discount_Amount_Percent_Default__c,
                                                     OON_Discount_Amount_Percent_Default__c,Discount_Applies_Default__c,OON_Discount_Applies_Default__c,ScheduledAmounts_Default__c,OON_ScheduledAmounts_Default__c
                                                     , INN_MandateLockDownInd__c, INN_MappingBRFBenefitID__c, ONN_MappingBRFBenefitID__c, ONN_MandateLockDownInd__c,
                                                     IN_Approximate_Member_Payment_w_Discount__c,IN_Approx_Member_Payment_w_Disc_Default__c,
                                                    ON_Approximate_Member_Payment_w_Discount__c,ON_Approx_Member_Payment_w_Disc_Default__c
                                                     from Benefit__r 
                                                     where IS_ASO_Only__c= False 
                                                     Order by Sequence_Number_SF__c asc ) //T03 
                                                       From AIA_Grouper__c Where Proposed_Products__c =: propProdId AND Group_Type__c = 'Benefit Group' 
                                                       and Grouper_Record_Type__c='BRF' and Grouper_RecordtypeName__c='Proposed_Proposed' order by Sequence_Number__c];

        Set<Id> bnfId = new Set<Id>();

        for(AIA_Grouper__c groupObj : planGrouperBenList) {
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
                else
                    bnfId.add(benObj.id);
            }
        }
        List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c, comment_codes__c, IsSelected__c, Jurisdiction__c, Limitation_ExtID__c, Limitations_NonEditable__c, Benefit_Type__c,
                                                               MaxAge_Selected__c, MaxDuration_Selected__c, TierAge_Selected__c, TierLimit_Selected__c,MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c, 
                                                               MaxDuration__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
                                                                MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
                                                               MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,  
                                                               TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c, Effective_Date__c, Term_Date__c,
                                                               TierLimitTo__c, TierLimitType__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c , ParentBenefitName__c,CommentType__c
                                                               FROM Limitations__c where Benefit__c in:bnfId]);
        Map<ID,List<Limitations__c>> maplmt = new Map<Id,List<Limitations__c>>();
        for(Limitations__c obj:lmtsn){
            List<Limitations__c> lmts=new List<Limitations__c>();
            if(maplmt.containsKey(obj.Benefit__c)){
                lmts=maplmt.get(obj.Benefit__c);
            }
            if(isReview==true){
             if(obj.IsSelected__c==true || obj.MaxAge_Selected__c == true || obj.MaxDuration_Selected__c == true || obj.TierAge_Selected__c == true || obj.TierLimit_Selected__c == true){
                    lmts.add(obj);
                    }
            }
            else
                lmts.add(obj);
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
                    //benWrapObj.benifitlmt=String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxValue__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxType__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxApply__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxDuration__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxDurationType__c);
                    System.debug('++maplmt.get(benObj.id)++++'+maplmt.get(benObj.id));
                    benWrapObj.lstlimit = maplmt.get(benObj.id);
                    benWrapObj.lstJurisdictions = getjurdictions(benWrapObj.lstlimit);
                }
                else{
                    benWrapObj.benifitNameStr = benObj.Benefit_Name__c;
                }
                system.debug('Benefit name--'+benObj.Benefit_Name__c+'----'+benObj.Benefit_Type__c);
                benWrapObj.aiaBenifitObj = benObj;
                system.debug('@@grouperWrapList line 478===benObj'+benObj);
                if(bnfId.contains(benObj.Id))
                    benWrapList.add(benWrapObj);
            }
            grpNameWrapObj.benifitWrapList = benWrapList;
            grouperWrapList.add(grpNameWrapObj);

        }
        system.debug('@@grouperWrapList line 478'+grouperWrapList);
        initialgrouperWrapList = grouperWrapList;
        //system.assertEquals(grouperWrapList,null);
    }
             if(pp.funding_Arrangement__c == 'ASO'){
        // Start Change to add the Copay_Type_1_Jurisdiction__c and Copay_Type_1_Mandate_Name__c in query.
        List<AIA_Grouper__c> planGrouperBenList =  [Select id,IsCovered__c, DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, Name,CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c,
                                                    OON_CoInsurance__c,OON_CoInsurance_AddIncrement__c,OON_CoInsurance_High__c,OON_CoInsurance_Increment__c,OON_CoInsurance_InvalidIncrement__c,OON_AnnualMaximumApplies__c,OON_DeductibleApplies__c,OON_DavisString__c,OON_IsCovered__c
                                                    ,OON_CoInsurance_Low__c, (Select id,Name, Benefit_Name__c,Benefit_Summary_Comment__c, INN_MandateLockDownInd__c, INN_MappingBRFBenefitID__c, ONN_MappingBRFBenefitID__c, ONN_MandateLockDownInd__c,
                                                    Copay_Type_2_Increment__c ,Copay_Type_2_Additional_Increments__c ,
                                                    CopayType2_Additional_InvalidIncrement__c,Copay_Type_1_Increment__c , Copay_Type_1_Additional_Increments__c ,Copay_Type_1_AdditionalInvalidIncrements__c,
                                                    Coinsurance_DefaultAmount__c, OON_Coinsurance_DefaultAmount__c,OON_CoInsurance_AmountValueSelected__c, Copay_Min_Payment__c,Copay_Type_1_Mandate_Name__c ,
                                                    Copay_Max_Payment__c,Copay_Type_1_High__c , Copay_Type_1_DefaultAmount__c,CoInsurance_AmountValueSelected__c,Copay_Type_1_AliasName__c,Copay_Type_2_High__c , 
                                                    Copay_Type_1_Low__c, Copay_Type_2_Low__c  ,Copay_Type_2_AliasName__c,OON_Copay_Type_1_AliasName__c,OON_Copay_Type_2_AliasName__c,Copay_Type_1_Jurisdiction__c ,  
                                                    OON_Copay_Type_2_Additional_Increments__c, OON_Copay2_Low__c, OON_Copay2_High__c,OON_Copay2_Increment__c, OON_Copay2Additional_InvalidIncrements__c, 
                                                    OON_Copay_Type_1_IsCovered__c,Copay_Type_1_IsCovered__c,Copay_Type_1_DeductibleApplies__c,OON_Copay_Min_Payment__c,OON_Copay_Max_Payment__c,
                                                    OON_Copay_Type_1_DefaultAmount__c,Copay_Type_1_AmountValueSelected__c,Copay_Type_2_AmountValueSelected__c,OON_Copay_AmountLow__c, OON_Copay_AmountHigh__c,  
                                                    OON_Copay_Additional_Increments__c, OON_Copay_Additional_InvalidIncrements__c,OON_Copay_AmountIncrement__c, OON_Copay_Type_1_AmountValueSelected__c,
                                                    OON_Copay_Type_2_AmountValueSelected__c,OON_Copay_Type_1_DeductibleApplies__c,  Benefit_Type__c , Sequence_Number__c,Sequence_Number_SF__c, 
                                                    Copay_Type_1_Benefit_Comment_Codes__c
                                                    ,IS_ASO_Only__c, Tier_type__c , Mandate_Yes_No__c ,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c,IN_CostShare_3Month_DeductibleCarryover__c, ON_CostShare_3Month_DeductibleCarryover__c,
                                                    IN_CostShare_3Month_DedCarryover_Default__c, OON_CostShare_3MonthDedCarryover_Default__c,
                                                    OON_Tier_Type_Default__c, Tier_Type_Default__c, OON_Copay_Default_Max_Payment__c, OON_Copay_Default_Min_Payment__c, Copay_Type_1_Default_IsCovered__c,
                                                    Copay_Type_1_Default_DeductibleApplies__c, Copay_Default_Min_Payment__c, Copay_Default_Max_Payment__c, OON_Copay_Type_1_Default_IsCovered__c,
                                                    OON_Copay_1_Default_DeductibleApplies__c,Cost_Share_Type__c,Discount_Amount__c, ScheduledAmounts__c, Allowed_Amount__c, Discount_Amount_Percent__c,AnnualMaximumApplies__c,OON_AnnualMaximumApplies__c,Discount_Applies__c, OON_Discount_Applies__c,
                                                    OON_Allowed_Amount__c, OON_ScheduledAmounts__c, OON_Discount_Amount__c, OON_Discount_Amount_Percent__c,Davis_Benefit_Variable__c,Davis_Benefit_Variable_Default__c,Davis_Variable_customized__c    //T04
                                                    ,OON_Coinsurance_AmountLow__c,OON_Coinsurance_AmountHigh__c, OON_Coinsurance_AmountIncrement__c, OON_Coinsurance_AddtionalIncrements__c, OON_Coinsurance_InvalidIncrements__c,
                                                    Coinsurance_AmountLow__c, Coinsurance_AmountHigh__c, Coinsurance_AmountIncrement__c, Coinsurance_Amount_AddtionalIncrements__c, Coinsurance_Amount_InvalidIncrements__c,
                                                    Allowed_Amount_Default__c,OON_Allowed_Amount_Default__c,Discount_Amount_Default__c,OON_Discount_Amount_Default__c,Discount_Amount_Percent_Default__c,
                                                    OON_Discount_Amount_Percent_Default__c,Discount_Applies_Default__c,OON_Discount_Applies_Default__c,ScheduledAmounts_Default__c,OON_ScheduledAmounts_Default__c
                                                    ,IN_Approximate_Member_Payment_w_Discount__c,IN_Approx_Member_Payment_w_Disc_Default__c,
                                                    ON_Approximate_Member_Payment_w_Discount__c,ON_Approx_Member_Payment_w_Disc_Default__c
                                                    from Benefit__r 
                                                    Order by Sequence_Number_SF__c asc )//T03
                                                    From AIA_Grouper__c Where Proposed_Products__c =: propProdId AND Group_Type__c = 'Benefit Group' 
                                                    and Grouper_Record_Type__c='BRF' and Grouper_RecordtypeName__c='Proposed_Proposed' order by Sequence_Number__c];

        Set<Id> bnfId = new Set<Id>();

        for(AIA_Grouper__c groupObj : planGrouperBenList) {
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
                else
                    bnfId.add(benObj.id);
            } 
        }
        List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c, comment_codes__c, IsSelected__c, Jurisdiction__c, Limitation_ExtID__c, Limitations_NonEditable__c, Benefit_Type__c,
                                                               MaxAge_Selected__c, MaxDuration_Selected__c, TierAge_Selected__c, TierLimit_Selected__c,MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c, 
                                                               MaxDuration__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
                                                                MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
                                                               MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,  
                                                               TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c, Effective_Date__c, Term_Date__c,
                                                               TierLimitTo__c, TierLimitType__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c , ParentBenefitName__c,CommentType__c
                                                               FROM Limitations__c where Benefit__c in:bnfId]);
        Map<ID,List<Limitations__c>> maplmt = new Map<Id,List<Limitations__c>>();
        for(Limitations__c obj:lmtsn){
            List<Limitations__c> lmts=new List<Limitations__c>();
            if(maplmt.containsKey(obj.Benefit__c)){
                lmts=maplmt.get(obj.Benefit__c);
            }
            if(isReview==true){
             if(obj.IsSelected__c==true || obj.MaxAge_Selected__c == true || obj.MaxDuration_Selected__c == true || obj.TierAge_Selected__c == true || obj.TierLimit_Selected__c == true){
                    lmts.add(obj);
                    }
            }
            else
                lmts.add(obj);
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
                    //benWrapObj.benifitlmt=String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxValue__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxType__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxApply__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxDuration__c)+' '+String.valueOf(maplmt.get(benObj.id).Benefit__r.Copay_Type_1_MaxDurationType__c);
                    System.debug('++maplmt.get(benObj.id)++++'+maplmt.get(benObj.id));
                    benWrapObj.lstlimit = maplmt.get(benObj.id);
                    benWrapObj.lstJurisdictions = getjurdictions(benWrapObj.lstlimit);
                }
                else{
                    benWrapObj.benifitNameStr = benObj.Benefit_Name__c;
                }
                system.debug('Benefit name--'+benObj.Benefit_Name__c+'----'+benObj.Benefit_Type__c);
                benWrapObj.aiaBenifitObj = benObj;
                system.debug('@@grouperWrapList line 805===benObj'+benObj);
                if(bnfId.contains(benObj.Id))
                    benWrapList.add(benWrapObj);
            }
            grpNameWrapObj.benifitWrapList = benWrapList;
            grouperWrapList.add(grpNameWrapObj);

        }
        system.debug('@@grouperWrapList line 478'+grouperWrapList);
        initialgrouperWrapList = grouperWrapList;
        //system.assertEquals(grouperWrapList,null);
    }
    }



    /*Indira code for Groupers from plan*/
    public void getGroupersFromPlan(String planid,string Rtype){

        system.debug('================inside getGroupersFromPlan  =========');
        //T13 added PCS_Grouper_Id__c in query
        List<AIA_Plan_Grouper__c> grprListToClr =  [Select id,IsCovered__c,DeductibleApplies__c,PCS_Grouper_Id__c, AnnualMaximumApplies__c, DavisString__c, Name, Sequence_Number__c,Record_Type__c, Plan_Network__c,Type__c, Plan_Network__r.Name,Plan_Network__r.InNetwork__c,
                                                   CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c,Plan_Network__r.OON_OutNetwork__c
                                                   From AIA_Plan_Grouper__c Where PlanId__c=:planid AND Type__c = 'Benefit Group' 
                                                   AND Record_Type__c =:Rtype Order By Sequence_Number__c,Plan_Network__r.Name]; 
        system.debug('================inside getGroupersFromPlan  ========='+grprListToClr.size());
        system.debug('**list of groupers'+grprListToClr);
        for( AIA_Plan_Grouper__c groupObj : grprListToClr ) {
            if(!groupNameSet.contains(groupObj.Name)) {
                planGrouperBenList.add(groupObj);
                system.debug('**grouper object'+groupObj);
                groupNameSet.add(groupObj.Name);
            }
            pgroupersID.add(groupObj.id);
            String grpname= groupObj.Name+'_'+(groupObj.Plan_Network__r.Name.contains('In')?'In':'Out');
            PlanMapGrouper.put(grpname,groupObj);
        }
        System.debug('+++++grprListToClr ++'+grprListToClr.size());
    }


    public void getBenefitsForPlan(String planid,string Rtype){
        //T14 added Variation_Condition_ID__c, PCS_Benefit_Id__c in query
        List<AIA_Plan_Benefits__c>  benifitObjlist= [Select id,Parent_Benefit_Name__c, Benefit_Name__c,Benefit_Group__r.Sequence_Number__c,Variation_Condition_ID__c,PCS_Benefit_Id__c,Benefit_Group__r.Name,Record_Type__c, Name, Sequence_Number__c ,Coinsurance_DefaultAmount__c , 
                                                     Benefit_Group__c, Benefit_Group__r.Plan_Network__c,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c, Benefit_Group__r.Plan_Network__r.Name , IS_ASO_Only__c,Cost_Share_Type__c,Davis_Benefit_Variable__c 
                                                     from AIA_Plan_Benefits__c 
                                                     Where Plan__c = :planid AND Record_Type__c =:Rtype and Type__c='Benefit' and  Benefit_Group__c in :pgroupersID
                                                     Order By  Benefit_Group__r.Sequence_Number__c,Sequence_Number__c ];

        for( AIA_Plan_Benefits__c benifitObj : benifitObjlist) {
            System.debug('+++++benifitObj ++'+benifitObj);

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
                system.debug('grpname----'+grpname+'--benifitObj.Parent_Benefit_Name__c--'+benifitObj.Parent_Benefit_Name__c);
            }
            AllGrpParentBenName.put(grpname,st);

            st= new set<String>();                                     
            String parbenname=benifitObj.Parent_Benefit_Name__c;

            if(AllParentBenName.containsKey(parbenname)){
                st=AllParentBenName.get(parbenname);
            }
            if(!st.contains(benifitObj.Benefit_Name__c)) {
                st.add(benifitObj.Benefit_Name__c);
                system.debug('parbenname----'+parbenname+'--benifitObj.Benefit_Name__c--'+benifitObj.Benefit_Name__c);
            }
            AllParentBenName.put(parbenname,st);                               
        }                                     

        System.debug('++++++++AllGrpParentBenName+++'+AllGrpParentBenName); 
        System.debug('++++++++AllParentBenName+++'+AllParentBenName);
        System.debug('++++++++benifitNetworkMap+++'+benefitIdSet.size()+'++++MapGrouperBenefitsNet.size------'+MapGrouperBenefitsNet.size());  



    }

    Transient Map<String,AIA_Plan_Copay_Type__c> ParentBenifitMandateName= new Map<String,AIA_Plan_Copay_Type__c>();

    public void getCopaysFromPlan(){

        List<AIA_Plan_Copay_Type__c> copTypeList= new  List<AIA_Plan_Copay_Type__c>();
        List<AIA_Plan_Copay_Type__c> copTypeList2= new  List<AIA_Plan_Copay_Type__c>();




        copTypeList= [Select id,Name,AliasName__c, Allowed_Amount__c,AnnualMaximumApplies__c,Benefit_Sequence_Number__c,CoinsuranceAmount__c,Copay_Additional_Increments__c,
                    CopayAmount__c,Copay_High__c,Copay_Increment__c,Copay_Low__c,Copay_Sequence_Number__c,DeductibleApplies__c,Discount_Amount__c,Discount_Amount_Percent__c,
                    DiscountApplies__c,Discount_Applies__c,Effective_Date__c,ExtID__c,Grouper_Name__c,IsASOOnly__c,IsCovered__c,Jurisdiction__c,Jurisdiction_for_BRF__c,
                    MandateIndicator__c,MandateName__c,MaxPayAmount__c,MinPayAmount__c,Plan_Benefits__c,PlanID__c,Approximate_Member_Payment_w_Discount__c,ScheduledAmounts__c,Term_Date__c,TierType__c,
                    Plan_Benefits__r.benefit_name__C,Plan_Benefits__r.Parent_Benefit_Name__c,Copay_Additional_InvalidIncrements__c,Plan_Benefits__r.IS_ASO_Only__c,
                    Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c,Plan_Benefits__r.Davis_Benefit_Variable__c,
                    Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c,
                    Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c, Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c 
                    from AIA_Plan_Copay_Type__c Where Plan_Benefits__c IN: benefitIdSet   //T04
                      and (jurisdiction__c = 'Federal' OR jurisdiction__c = 'FD')
                      and jurisdiction__c!='' order by   Plan_Benefits__r.benefit_name__C];


      If(pp.Product_Category__c =='Drug' ){
     
        copTypeList2= [Select id,Name,Plan_Benefits__c,Plan_Benefits__r.benefit_name__C,MandateName__c ,Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,
                       MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,IsASOOnly__c, Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c , 
                       Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c, ExtID__c,AnnualMaximumApplies__c
                       ,Plan_Benefits__r.IS_ASO_Only__c, Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c,Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c,
                        Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c, Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c 
                       from AIA_Plan_Copay_Type__c Where Plan_Benefits__c IN: benefitIdSet and jurisdiction__c != 'Federal' and jurisdiction__c != 'FD'
                       AND ( (MandateIndicator__c = 'Yes' AND Jurisdiction_for_BRF__c=:jurisdictionFrmPP) OR 
                               MandateIndicator__c = 'No' OR  MandateIndicator__c = '' )
                               order by   Plan_Benefits__r.benefit_name__C,Copay_Sequence_Number__c desc];
                               }
                               
      else if( pp.Product_Category__c =='Medical' )  {
           copTypeList2= [Select id,Name,Plan_Benefits__c,Plan_Benefits__r.benefit_name__C,MandateName__c ,Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,
                       MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,Plan_Benefits__r.IS_ASO_Only__c, IsASOOnly__c, Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c , 
                       Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c, ExtID__c,AnnualMaximumApplies__c
                       , Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c,Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c,
                        Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c, Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c 
                       from AIA_Plan_Copay_Type__c Where Plan_Benefits__c IN: benefitIdSet and jurisdiction__c != 'Federal' and jurisdiction__c != 'FD'
                       AND ( (MandateIndicator__c = 'Yes' AND Jurisdiction_for_BRF__c=:jurisdictionFrmPP) OR 
                              ( (MandateIndicator__c = 'No' OR  MandateIndicator__c = '') and jurisdiction__c = ''))
                               order by   Plan_Benefits__r.benefit_name__C,Copay_Sequence_Number__c desc];
                               }               
    else if( pp.Product_Category__c =='Vision' )  {   // T04  start
            copTypeList2= [Select id,Name,Plan_Benefits__c,Plan_Benefits__r.benefit_name__C,MandateName__c ,Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,
                           MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,Plan_Benefits__r.IS_ASO_Only__c, IsASOOnly__c, Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c , 
                           Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c, ExtID__c,AnnualMaximumApplies__c,Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c
                           , Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c, Discount_Amount__c, Approximate_Member_Payment_w_Discount__c,ScheduledAmounts__c, Allowed_Amount__c,Plan_Benefits__r.Davis_Benefit_Variable__c,Discount_Applies__c, 
                            Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c, Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c
                           from AIA_Plan_Copay_Type__c Where Plan_Benefits__c IN: benefitIdSet and jurisdiction__c != 'Federal' and jurisdiction__c != 'FD'
                           AND ( (MandateIndicator__c = 'Yes' AND Jurisdiction_for_BRF__c=:jurisdictionFrmPP) OR 
                                MandateIndicator__c = 'No' OR  MandateIndicator__c = '')
                           order by   Plan_Benefits__r.benefit_name__C,Copay_Sequence_Number__c desc];
        } //T04 End
   else if( pp.Product_Category__c =='Dental' )  {      
            copTypeList2= [Select id,Name,Plan_Benefits__c,Plan_Benefits__r.benefit_name__C,MandateName__c ,Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,     
                            MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,Plan_Benefits__r.IS_ASO_Only__c, IsASOOnly__c, Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c ,       
                            Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c, ExtID__c       
                            , Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c,AnnualMaximumApplies__c,Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c,
                             Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c, Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c
                             from AIA_Plan_Copay_Type__c Where Plan_Benefits__c IN: benefitIdSet and jurisdiction__c != 'Federal' and jurisdiction__c != 'FD'     
                            AND ( (MandateIndicator__c = 'Yes' AND Jurisdiction_for_BRF__c=:jurisdictionFrmPP) OR       
                            MandateIndicator__c = 'No'  OR  MandateIndicator__c = '' )      
                            order by   Plan_Benefits__r.benefit_name__C,Copay_Sequence_Number__c desc];         
            }              
        copTypeList.addAll(copTypeList2);
        for(AIA_Plan_Copay_Type__c copType : copTypeList)
        {
            System.debug('++++copType++'+'=====benefit name ====='+copType.Plan_Benefits__r.benefit_name__C+'-----'+copType.Name+'====='+ copType.MandateIndicator__c+'===='+copType.Copay_Sequence_Number__c);
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
                system.debug('copType===ct1===='+c1.name+'======'+ct );
            }
            else  if(ct.copayTypePecSpecObj.id==null ) {
                Boolean isprev=false;
               // if( ct.copayTypeSelectedObj.jurisdiction__c=='Federal' && ct.copayTypeSelectedObj.jurisdiction__c== copType.jurisdiction__c  )
                 if( ct.copayTypeSelectedObj.jurisdiction__c=='Federal' ||  ct.copayTypeSelectedObj.jurisdiction__c=='FD'  )
                    isprev=true;
                else   if( ct.copayTypeSelectedObj.jurisdiction__c!='Federal' && ct.copayTypeSelectedObj.jurisdiction__c!='FD' && ct.copayTypeSelectedObj.MandateIndicator__c=='Yes' 
                    && ct.copayTypeSelectedObj.MandateIndicator__c== copType.MandateIndicator__c &&
                    ct.copayTypeSelectedObj.Jurisdiction_for_BRF__c== copType.Jurisdiction_for_BRF__c  )

                    isprev=true;
                else if( ct.copayTypeSelectedObj.jurisdiction__c!='Federal' && ct.copayTypeSelectedObj.jurisdiction__c!='FD' && ct.copayTypeSelectedObj.MandateIndicator__c=='No' 
                    && ct.copayTypeSelectedObj.MandateIndicator__c== copType.MandateIndicator__c   )
                    isprev=true;
                else
                    isprev=false;
                if(isprev==true)
                {
                    AIA_Plan_Copay_Type__c c1= new AIA_Plan_Copay_Type__c();
                    c1=copType;
                    ct.copayTypePecSpecObj =c1;
                    system.debug('copType=====ct2===='+c1.name+'======'+ct);
                    CopayIDs.add(copType.id);
                }
            }    
           // else
                system.debug('+++++++copType=====ct3==='+copType.name+'======'+ct);
            copayBenMap.put(copType.Plan_Benefits__c, ct);
        }
        System.debug('+++++copayBenMap++++'+copayBenMap);    

        copTypeList.clear();
        copTypeList2.clear();
        //return copayBenMap;
    }


    public void getPlanLimitation(){
    
        List<Proposed_Products__c> ppList = [Select Benefit_Request_Form__c,Benefit_Request_Form__r.Jurisdiction__c  ,Effective_Date__c,Related_Medical_Product__c
                                             , Benefit_Request_Form__r.Benefit_Effective_Date__c   from Proposed_Products__c Where id =:propProdId];
        
        Proposed_Products__c pplimit = pplist[0];
        PPEffDate = pplimit.Effective_Date__c;
        jurpp = pplimit.Benefit_Request_Form__r.Jurisdiction__c;
        system.debug('+++++PPEffDate++++'+PPEffDate);
        //T17 
        List<AIA_Plan_Limitation__c> PLimitTION = [select MandateName__c,Plan_Benefits__r.Name,Plan_Benefits__r.Benefit_Name__c,Plan_Benefits__r.Parent_Benefit_Name__c,MaxAgeType__c ,Plan_Benefits__r.Benefit_Group__c,Type__c,
                                                   Jurisdiction__c,TierLimitType__c,MandateIndicator__c,MaxRow_Mandate_Description__c, ParentBenefitName__c,ExtID__c ,Plan_Benefits__r.IS_ASO_Only__c,
                                                    MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
                                                   MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,  Plan_Benefits__r.Variation_Condition_ID__c, Plan_Benefits__r.PCS_Benefit_Id__c,
                                                   TierLimitDurationType__c,MaxRow_Value__c,Tier_Value__c,MaxAgeTo__c ,MaxValue__c,TierAgeTo__c,TierLimitFrom__c ,TierAgeType__c ,TierAgeFrom__c,TierLimitTo__c ,MaxApply__c,
                                                   MaxType__c,MaxDuration__c,MaxDurationType__c,IS_ASO_Only__c, MaxAgeFrom__c, Effective_Date__c, Term_Date__c  from AIA_Plan_Limitation__c 
                                                   where Plan_Benefits__c in:benefitIdSet and Effective_Date__c <=:PPEffDate AND Term_Date__c >=:PPEffDate order by Plan_Benefits__r.Parent_Benefit_Name__c,MandateIndicator__c desc,type__c];

         for(AIA_Plan_Limitation__c obj:PLimitTION){

            System.debug('++++limitation++'+obj);
            PlanLimitIDs.add(obj.id);

            String limitBenParentName=obj.Plan_Benefits__r.Parent_Benefit_Name__c;
            Set<String> benlimit=new Set<String>();
            String ltype= '';
            if(pp.funding_Arrangement__c == 'ASO')
            {
                if(obj.MandateIndicator__c==true){
                    ltype='M';
                }else if(obj.MandateIndicator__c==false){
                    ltype='L';
                }
            }
            if(pp.funding_Arrangement__c == 'Risk')
            {
                if(obj.MandateIndicator__c==true && (obj.Jurisdiction__c == 'Federal' || obj.Jurisdiction__c == 'FD' || obj.Jurisdiction__c==jurpp )){
                    ltype='M';
                }else if(obj.MandateIndicator__c==false){
                    ltype='L';
                }
                
            }
            set<String> st= new Set<String>();

            Limitations__c tempLimit= new Limitations__c();
            if(obj.IS_ASO_Only__c != null && obj.IS_ASO_Only__c != '')
            {
                if(obj.IS_ASO_Only__c == 'No'|| obj.IS_ASO_Only__c == 'N' )
                    tempLimit.IS_ASO_Only__c=false;
                else
                    tempLimit.IS_ASO_Only__c=true;
            }
            if(obj.Type__c =='TierLimit'  && obj.Tier_Value__c!=null && obj.Tier_Value__c!=''){
                System.debug('++++TierLimit++'+obj.Tier_Value__c);
                
                tempLimit.ParentBenefitName__c = obj.ParentBenefitName__c;
                if(benLimitsAllMap.containsKey(limitBenParentName)){
                    st=benLimitsAllMap.get(limitBenParentName);

                }
                if(!st.contains(obj.Tier_Value__c + obj.MandateIndicator__c + obj.Jurisdiction__c)){
                    st.add(obj.Tier_Value__c + obj.MandateIndicator__c +obj.Jurisdiction__c);

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
                    tempLimit.Type__c=obj.Type__c;
                 //   tempLimit.IsSelected__c=true;
                    //T17 - Start
                    tempLimit.MandateName__c = obj.MandateName__c;
                    //T17 - End
                    tempLimit.Recordtype__c='BRF';
                    tempLimit.MaxAgeFrom__c=null;
                    tempLimit.MaxAgeTo__c=null;
                    tempLimit.MaxValue__c=null;
                    tempLimit.MaxDuration__c=null;
                    tempLimit.Jurisdiction__c = obj.Jurisdiction__c;
                    tempLimit.Variation_Condition_ID__c = obj.Plan_Benefits__r.Variation_Condition_ID__c;
                    tempLimit.PCS_Benefit_Id__c = obj.Plan_Benefits__r.PCS_Benefit_Id__c;
                    
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
                    
                    
                    tempLimit.Limitation_ExtID__c = obj.ExtID__c;
                    if(obj.Effective_Date__c!=null){
                    tempLimit.Effective_Date__c = obj.Effective_Date__c;
                    }
                    if(obj.Term_Date__c!=null){
                    tempLimit.Term_Date__c = obj.Term_Date__c;
                    }
                  if( obj.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || obj.Plan_Benefits__r.IS_ASO_Only__c == 'Y'){
                   tempLimit.IS_ASO_Only__c= true;
                   }
                  if( obj.Plan_Benefits__r.IS_ASO_Only__c == 'No' || obj.Plan_Benefits__r.IS_ASO_Only__c == 'N'){
                   tempLimit.IS_ASO_Only__c= false;
                   }
                    
                }
                benLimitsAllMap.put(limitBenParentName, st);
            } else if(obj.Type__c =='MaxRow' && obj.MaxRow_Value__c!=null && obj.MaxRow_Value__c!=''){
                tempLimit.ParentBenefitName__c = obj.ParentBenefitName__c;              
                if(benLimitsAllMap.containsKey(limitBenParentName)){
                    st=benLimitsAllMap.get(limitBenParentName);

                }
                if(!st.contains(obj.MaxRow_Value__c + obj.MandateIndicator__c + obj.Jurisdiction__c)){
                    st.add(obj.MaxRow_Value__c + obj.MandateIndicator__c + obj.Jurisdiction__c);
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
                    tempLimit.Jurisdiction__c = obj.Jurisdiction__c;
                    if(obj.MaxValue__c!=null )
                    tempLimit.MaxValue__c=obj.MaxValue__c;
                    tempLimit.TierAgeFrom__c=null;
                    tempLimit.TierAgeTo__c=null;
                    tempLimit.TierLimitTo__c=null;
                    tempLimit.OldMax_TierVal__c=obj.MaxRow_Value__c;
                    tempLimit.Type__c=obj.Type__c;
                  //  tempLimit.IsSelected__c=true;
                    //T17 - Start
                    tempLimit.MandateName__c = obj.MandateName__c;
                    //T17 - Stop
                    tempLimit.Recordtype__c='BRF';
                    tempLimit.Limitation_ExtID__c = obj.ExtID__c;
                    //T17 - Start
                    tempLimit.MandateName__c = obj.MandateName__c;
                    //T17 - End
                    tempLimit.Variation_Condition_ID__c = obj.Plan_Benefits__r.Variation_Condition_ID__c;
                    tempLimit.PCS_Benefit_Id__c = obj.Plan_Benefits__r.PCS_Benefit_Id__c;
                    
                    //tempLimit.TierLimit_Selected__c = true;
                    //tempLimit.TierAge_Selected__c = true;
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
                if(obj.MaxDuration__c!=null)
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
                if(obj.MaxValue__c == 0 || obj.MaxValue__c == null){
                tempLimit.MaxDuration_Selected_Value__c ='';
                }    
               if( tempLimit.MaxDuration_Selected_Value__c !='' || tempLimit.MaxDuration_Selected_Value__c !=null)
                   tempLimit.MaxDuration_Selected__c = true;
               if( tempLimit.MaxAge_Selected_Value__c !='' || tempLimit.MaxAge_Selected_Value__c !=null)    
                   tempLimit.MaxAge_Selected__c = true;  
                        
                    
                    if(obj.Effective_Date__c!=null){
                    tempLimit.Effective_Date__c = obj.Effective_Date__c;
                    }
                    if(obj.Term_Date__c!=null){ 
                    tempLimit.Term_Date__c = obj.Term_Date__c;
                    }
                     //RG Update 5/15 Start MaxRow Ranges
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
                        
                      //RG Update 5/15 End 
                     if( obj.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || obj.Plan_Benefits__r.IS_ASO_Only__c == 'Y'){
                       tempLimit.IS_ASO_Only__c= true;
                       }
                     if( obj.Plan_Benefits__r.IS_ASO_Only__c == 'No' || obj.Plan_Benefits__r.IS_ASO_Only__c == 'N'){
                       tempLimit.IS_ASO_Only__c= false;
                       }    
                }
                benLimitsAllMap.put(limitBenParentName, st);
            }/*else if(obj.Type__c =='' && obj.MandateName__c!=null && obj.MandateName__c!='' && (obj.Jurisdiction__c==jurisdictionFrmPP || obj.Jurisdiction__c=='Federal' || obj.Jurisdiction__c=='FD')){

        }*/
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

        }

        system.debug('ParentBenLimitationMan1---'+ParentBenLimitationMan);
        system.debug('ParentBenLimitationLimit-1--'+ParentBenLimitationLimit);


    }

public void getPlanCommentCodes(){
        Map<String, Set<DEcimal>> parentMandateCodemap=new Map<String, Set<DEcimal>>();
        //Beging Change for 11/7/2016|
        //updating the code to handle the Comment codes for ASO and Risk separately
        List<AIA_Plan_Benefit_Comment_Codes__c> PlanCommentCodes= new List<AIA_Plan_Benefit_Comment_Codes__c> ();
        List<AIA_Plan_Benefit_Comment_Codes__c> PlanCommentCodesf= new List<AIA_Plan_Benefit_Comment_Codes__c> ();
        If(pp.Funding_Arrangement__c=='Risk')
        PlanCommentCodes=  [select id,name,PCS_Benefit_Id__c,Variation_Condition_ID__c,Plan_Benefit_Grouper_Name__c,Plan_Benefit_Parent_Name__c,IsMandateTrue__c,type__c,FundingArrangement__c,ParentBenefitName__c,
                            Plan_Limitation__r.MandateIndicator__c,Code__c,Comment__c,Plan_Limitation__r.IS_ASO_Only__c, Plan_Limitation__r.ParentBenefitName__c,
                            Jurisdiction__c, IS_ASO_Only__c,Is_Required__c,Plan_Copay_Type__c,Plan_Limitation__c,Limitation_Type__c,ExtID__c,Plan_Limitation__r.Effective_Date__c, Plan_Limitation__r.Term_Date__c
                            from AIA_Plan_Benefit_Comment_Codes__c 
                            where  Plan_Limitation__c in :PlanLimitIDs AND (Is_Required__c=true AND FundingArrangement__c = 'Risk' AND (Plan_Limitation__r.Effective_Date__c <=:PPEffDate AND Plan_Limitation__r.Term_Date__c >=:PPEffDate) AND Jurisdiction__c=:jurpp)
        order by Plan_Benefit_Parent_Name__c,Sequence_Number__c desc,Code__c ];
        else{
            PlanCommentCodes=  [select id,name,PCS_Benefit_Id__c,Variation_Condition_ID__c,Plan_Benefit_Grouper_Name__c,Plan_Benefit_Parent_Name__c,IsMandateTrue__c,type__c,FundingArrangement__c,ParentBenefitName__c,
                                Plan_Limitation__r.MandateIndicator__c,Code__c,Comment__c, Plan_Limitation__r.IS_ASO_Only__c, Plan_Limitation__r.ParentBenefitName__c,
                                Jurisdiction__c, IS_ASO_Only__c,Is_Required__c,Plan_Copay_Type__c,Plan_Limitation__c,Limitation_Type__c, ExtID__c,Plan_Limitation__r.Effective_Date__c, Plan_Limitation__r.Term_Date__c
                                from AIA_Plan_Benefit_Comment_Codes__c 
                                where  (Plan_Limitation__c in :PlanLimitIDs AND (Plan_Limitation__r.Effective_Date__c <=:PPEffDate AND Plan_Limitation__r.Term_Date__c >=:PPEffDate) )
            order by Plan_Benefit_Parent_Name__c,Sequence_Number__c desc,Code__c ]; 


        }


        //End Change for 11/7/2016|
       
        for(AIA_Plan_Benefit_Comment_Codes__c comm:PlanCommentCodes)  {
            
            Limitations__c tempLimit= new Limitations__c();
            String commBenParentName=comm.Plan_Benefit_Parent_Name__c;
            
            tempLimit.IS_ASO_Only__c=comm.IS_ASO_Only__c;
            Set<String> ls=new Set<String>();
            if( benLimitsAllMap.containsKey(commBenParentName)){
                ls=benLimitsAllMap.get(commBenParentName);
            }
            if(!ls.contains(String.valueOF(comm.Code__c) + comm.Type__c)){
                ls.add(String.valueOF(comm.Code__c) + comm.Type__c);
                tempLimit.Code__c=String.valueOF(comm.Code__c) ;
                tempLimit.comment_codes__c=comm.Comment__c;
                tempLimit.IsRequired__c= comm.Is_Required__c;
                tempLimit.type__c='Comment';
                tempLimit.Recordtype__c='BRF';
                tempLimit.IsSelected__c=comm.Is_Required__c;
                tempLimit.Jurisdiction__c = comm.Jurisdiction__c;
                tempLimit.ParentBenefitName__c = comm.ParentBenefitName__c;
                tempLimit.CommentType__c = comm.type__c;
                //T16 - start added variation condition id and pcs benefit id for benefit type limitation
                tempLimit.Variation_Condition_ID__c=comm.Variation_Condition_ID__c;
                tempLimit.PCS_Benefit_Id__c=comm.PCS_Benefit_Id__c;
                //T16 - end
                //T14-start Added Funding Arrangement
                tempLimit.FundingArrangement__c = comm.FundingArrangement__c;
                //T14-End
                //tempLimit.ParentBenefitName__c = comm.Plan_Limitation__r.ParentBenefitName__c;
                tempLimit.Limitation_ExtID__c = comm.ExtID__c;
                if(comm.Plan_Limitation__r.Effective_Date__c!=null){        
                tempLimit.Effective_Date__c = comm.Plan_Limitation__r.Effective_Date__c;        
                }       
                if(comm.Plan_Limitation__r.Term_Date__c!=null){       
                tempLimit.Term_Date__c = comm.Plan_Limitation__r.Term_Date__c;      
                }
               

            }

            benLimitsAllMap.put(commBenParentName, ls);

            List<Limitations__c> limtls= new List<Limitations__c>();
            Set<DEcimal> codes=new   Set<DEcimal>();
            if( tempLimit.Type__c!='' && tempLimit.Type__c!=null && tempLimit!=null){
               // if(pp.funding_arrangement__c == 'Risk'){
               /*     if(comm.Type__c =='Mandate'){
                        if(ParentBenLimitationMan.containsKey(commBenParentName)){
                            codes=parentMandateCodemap.get(commBenParentName);
                            limtls=(ParentBenLimitationMan.get(commBenParentName));
                        }
                        else
                            limtls= new List<Limitations__c>();
                        // if(codes!=null)
                        codes.add(comm.Code__c);
                        limtls.add(tempLimit);
                        parentMandateCodemap.put(commBenParentName, codes);
                        ParentBenLimitationMan.put(commBenParentName,limtls); 
                    }else if(comm.Type__c !='Mandate'){
                        if(ParentBenLimitationLimit.containsKey(commBenParentName))
                            limtls=(ParentBenLimitationLimit.get(commBenParentName));
                        else
                            limtls= new List<Limitations__c>();
                        if(parentMandateCodemap.containsKey(commBenParentName)) {
                            if( !parentMandateCodemap.get(commBenParentName).contains(comm.Code__c))
                                limtls.add(tempLimit);
                        }
                        else
                            limtls.add(tempLimit);
                        
                        ParentBenLimitationLimit.put(commBenParentName,limtls);
                    }    */
               // }
               // if(pp.funding_arrangement__c == 'ASO'){
                    if(comm.Type__c =='Mandate' ){
                        if(ParentBenLimitationMan.containsKey(commBenParentName)){
                            codes=parentMandateCodemap.get(commBenParentName);
                            limtls=(ParentBenLimitationMan.get(commBenParentName));
                        }
                        else
                            limtls= new List<Limitations__c>();
                        if(codes!=null)
                        codes.add(comm.Code__c);
                        limtls.add(tempLimit);
                        parentMandateCodemap.put(commBenParentName, codes);
                        ParentBenLimitationMan.put(commBenParentName,limtls); 
                    }else if(comm.Type__c !='Mandate'){
                        if(ParentBenLimitationLimit.containsKey(commBenParentName))
                            limtls=(ParentBenLimitationLimit.get(commBenParentName));
                        else
                            limtls= new List<Limitations__c>();
                        if(parentMandateCodemap.containsKey(commBenParentName)) {
                            //if( !parentMandateCodemap.get(commBenParentName).contains(comm.Code__c))
                                limtls.add(tempLimit);
                        }
                        else
                            limtls.add(tempLimit);
                        
                        ParentBenLimitationLimit.put(commBenParentName,limtls);
                    }
              //  }
            }
        }
        
        system.debug('final ParentBenLimitationMan---'+ParentBenLimitationMan);
        system.debug('final ParentBenLimitationLimit---'+ParentBenLimitationLimit);
        
    }


    public void FormatDataFromPlanIntoWrapper(Proposed_Products__c PP){
        grouperWrapList = new List<GrouperWrapper>();
        string tempbefhifen;
        String RType = 'BRF';
        string planif = PP.Plan_Name__c;
        List<AIA_Plan_Grouper__c> grpOUT= [Select id,IsCovered__c, DeductibleApplies__c, AnnualMaximumApplies__c, DavisString__c, Name, Sequence_Number__c,Record_Type__c, Plan_Network__c,Type__c, Plan_Network__r.Name,Plan_Network__r.InNetwork__c,
                                                   CoInsurance__c,CoInsurance_Low__c,CoInsurance_High__c,CoInsurance_Increment__c,CoInsurance_AddIncrement__c,CoInsurance_InvalidIncrement__c,PCS_Grouper_Id__c,Plan_Network__r.OON_OutNetwork__c
                                                   From AIA_Plan_Grouper__c Where PlanId__c=:planif AND Type__c = 'Benefit Group' 
                                                   AND Record_Type__c =:RType AND Plan_Network__r.Name = 'OutNetwork' Order By Sequence_Number__c,Plan_Network__r.Name]; 
        system.debug('@@@@@grpOUT@@@---'+grpOUT);    
        Schema.DescribeSObjectResult d = Schema.SObjectType.AIA_Grouper__c; 
        Map<String,Schema.RecordTypeInfo> GrpRTMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo grprtByName = GrpRTMapByName.get('Proposed Product');
            
        Schema.DescribeSObjectResult d2 = Schema.SObjectType.AIA_Benefits__c; 
        Map<String,Schema.RecordTypeInfo> BenRTMapByName = d2.getRecordTypeInfosByName();
        Schema.RecordTypeInfo benrtByName = BenRTMapByName.get('Proposed Product');
        system.debug('@@@@@planGrouperBenList---'+planGrouperBenList);
        
        Integer grpSeq=1;
        for(AIA_Plan_Grouper__c planGroupObj : planGrouperBenList) {
            system.debug('@@@@@planGroupObj.Name ---'+planGroupObj.Plan_Network__r.Name);
            GrouperWrapper  grpNameWrapObj = new GrouperWrapper();
            AIA_Grouper__c aiaGrpObj = new AIA_Grouper__c();
            aiaGrpObj.Name = planGroupObj.Name;
            aiaGrpObj.Proposed_Products__c = propProdId;
            aiaGrpObj.Group_Type__c = 'Benefit Group';
            aiaGrpObj.Sequence_Number__c=grpSeq++;
            //T14-Start Added PCS_Grouper_Id__c
            aiaGrpObj.PCS_Grouper_Id__c=planGroupObj.PCS_Grouper_Id__c;
            //T14-End
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
            aiaGrpObj.Grouper_Record_Type__c='BRF';
            aiaGrpObj.RecordTypeId=grprtByName.recordtypeid;
            grpNameWrapObj.aiaGrouper= aiaGrpObj;
            Integer benSeq=0;
            List<BenifitsrWrapper> benifitWrapList = new List<BenifitsrWrapper>();
            system.debug('planGroupObj.Name---'+planGroupObj.Name);
            system.debug('AllGrpParentBenName---'+AllGrpParentBenName);
            if(AllGrpParentBenName.containsKey(planGroupObj.Name)){//Asif 25-Apr Fix for groupers with no benefits
            for(String pName : AllGrpParentBenName.get(planGroupObj.Name)) {
                system.debug('pName---'+pName);
                if(ParentBenLimitationMan.containsKey(pName)){
                    System.debug('has mandate--'+'++++benSeq+++'+benSeq); 
                    benSeq=benSeq+1;
                    BenifitsrWrapper benWrapObjm = new BenifitsrWrapper();
                    benWrapObjm.benifitNameStr = pname ;//+ ' - Mandate - Yes';
                    benWrapObjm.GrpName=planGroupObj.Name;
                    AIA_Benefits__c benObjTo = new AIA_Benefits__c();
                    benObjTo.Sequence_Number_SF__c=benSeq ;
                    tempbefhifen = '';
                  //  if(pname.contains('-')){
                  //      tempbefhifen = pname.substringBefore('-');
                  //  }
                  //  else{
                        tempbefhifen = pname;
                  //  }
                    benObjTo.Benefit_Name__c=tempbefhifen ;//+ ' - Mandate - Yes';
                    //benObjTo.Benefit_Name__c=pname ;//+ ' - Mandate - Yes';
                    benObjTo.Type__c='Benefit';
                    benObjTo.Benefit_Type__c='Mandate';
                    benObjTo.Benefit_Record_Type__c='BRF';
                    benObjTo.Mandate_Yes_No__c = 'Yes';
                    benObjTo.Copay_Type_1_IsCovered__c = '';
                    benObjTo.OON_Copay_Type_1_IsCovered__c = '';
                    benObjTo.RecordTypeId=benrtByName.recordtypeid;
                     //added on Nov 16 2016 -- B-03274 -- to show the mandate name and teh juridiction
                    
                    if(ParentBenifitMandateName.containsKey(pname)){
                     benObjTo.Copay_Type_1_Mandate_Name__c=ParentBenifitMandateName.get(pname).MandateName__c;
                     benObjTo.Copay_Type_1_Jurisdiction__c=ParentBenifitMandateName.get(pname).Jurisdiction_for_BRF__c;    
                    }
                    else{
                        benObjTo.Copay_Type_1_Mandate_Name__c=pname;
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
                    for(Limitations__c obj:ManLimitation){ 
                        benObjTo.Copay_Type_1_Mandate_Name__c=ManLimitation[0].MandateName__c;
                        benObjTo.Copay_Type_1_Jurisdiction__c=ManLimitation[0].Jurisdiction__c;
                        System.debug('++++obj.IS_ASO_Only__c++'+obj.IS_ASO_Only__c);      
                        if(!obj.IS_ASO_Only__c)
                        {
                            IsASOOnly = false;
                        }
                        //T16 start added variationid,pcssbenefit id from limitation to benefit typelimitation    
                        benObjTo.Variation_Condition_ID__c=obj.Variation_Condition_ID__c;
                        benObjTo.PCS_Benefit_Id__c=obj.PCS_Benefit_Id__c;
                        //T16 end
                    }
                    benObjTo.IS_ASO_Only__c = IsASOOnly;
                    system.debug('@@benifitWrapList line 624 FormatDataFromPlanIntoWrapper==benWrapObjm.aiaBenifitObj=='+benWrapObjm.aiaBenifitObj);
                    benWrapObjm.aiaBenifitObj=benObjTo;
                    benifitWrapList.add(benWrapObjm); system.debug('@@benifitWrapList line 624 mandate'+benifitWrapList);
                }  
                //START--added on Nov 16 2016 -- B-03274 -- to show the mandate name and teh juridiction
                else if(ParentBenifitMandateName.containsKey(pname)){
                    System.debug('has mandate name only --'+'++++benSeq+++'+benSeq); 
                    benSeq=benSeq+1;
                    BenifitsrWrapper benWrapObjm = new BenifitsrWrapper();
                    benWrapObjm.benifitNameStr = pname ;//+ ' - Mandate - Yes';
                    benWrapObjm.GrpName=planGroupObj.Name;
                    AIA_Benefits__c benObjTo = new AIA_Benefits__c();
                    benObjTo.Sequence_Number_SF__c=benSeq ;
                    tempbefhifen = '';
                     tempbefhifen = pname;
           /*  if(!test.isrunningtest()){      
              if(pname.contains('-')){
                        tempbefhifen = pname.substringBefore('-');
                    }
                    else{
                        tempbefhifen = pname;
                    }
                  }*/
                    benObjTo.Benefit_Name__c=tempbefhifen ;//+ ' - Mandate - Yes';
                    //benObjTo.Benefit_Name__c=pname ;//+ ' - Mandate - Yes';
                    benObjTo.Type__c='Benefit';
                    benObjTo.Benefit_Type__c='Mandate';
                    benObjTo.Benefit_Record_Type__c='BRF';
                    benObjTo.Mandate_Yes_No__c = 'Yes';
                    benObjTo.Copay_Type_1_IsCovered__c = '';
                    benObjTo.OON_Copay_Type_1_IsCovered__c = '';
                    benObjTo.RecordTypeId=benrtByName.recordtypeid;
                    
                    if(ParentBenifitMandateName.containsKey(pname)){
                        benObjTo.Copay_Type_1_Mandate_Name__c=ParentBenifitMandateName.get(pname).MandateName__c;
                        benObjTo.Copay_Type_1_Jurisdiction__c=ParentBenifitMandateName.get(pname).Jurisdiction_for_BRF__c;
                    }
                    else{
                        benObjTo.Copay_Type_1_Mandate_Name__c=pname;
                    }
                    
                    benObjTo.Copay_Type_1_Benefit_Comment_Codes__c  ='NA';
                    List<Limitations__c> ManLimitation=new List<Limitations__c>();
                    benWrapObjm.lstlimit=ManLimitation;
                    benWrapObjm.lstJurisdictions = getjurdictions(benWrapObjm.lstlimit);
                    system.debug('@@benifitWrapList line 624 FormatDataFromPlanIntoWrapper2==benWrapObjm.aiaBenifitObj'+benWrapObjm.aiaBenifitObj);
                    benWrapObjm.aiaBenifitObj=benObjTo;
                    benifitWrapList.add(benWrapObjm);
                    system.debug('@@benifitWrapList line 624 mandate 2'+benifitWrapList);

                }  //END--added on Nov 16 2016 -- B-03274 -- to show the mandate name and teh juridiction
                system.debug('pnmae===='+pName);
  //List<AIA_Plan_Benefits__c> PlanBenList = new List<AIA_Plan_Benefits__c>([select Id,Benefit_Name__c,Davis_Benefit_Variable__c from AIA_Plan_Benefits__c where Benefit_Group__c =:PlanGroupObj.Id]);              
                for(String benNames : AllParentBenName.get(pName)) {
                    system.debug('benNames----'+benNames +'---'+pName +'++++benSeq+++'+benSeq); 
                    benSeq=benSeq+1;
                    AIA_Benefits__c benObjTo = new AIA_Benefits__c();
                    BenifitsrWrapper benWrapObjb = new BenifitsrWrapper();
                    benWrapObjb.GrpName=planGroupObj.Name;
                    benWrapObjb.benifitlmt=pName;
                    benWrapObjb.benifitNameStr = benNames;
                    benObjTo.Benefit_Name__c=benNames;
                    benObjTo.Type__c='Benefit';
                    benObjTo.Benefit_Type__c='Benefit';
                    benObjTo.Benefit_Record_Type__c='BRF';
                    benObjTo.RecordTypeId=benrtByName.recordtypeid;
                    benObjTo.Sequence_Number_SF__c=benSeq;
                    AIA_Plan_Benefits__c benIn=new AIA_Plan_Benefits__c();
                    AIA_Plan_Benefits__c benOut=new AIA_Plan_Benefits__c();
                    String key=planGroupObj.Name+'_'+benNames+'_';
                    system.debug('key+++'+key);
                    
                    
               
                     /************************* T02 -- start ********************************/
                     
                    if (MapGrouperBenefitsNet.containsKey(key+'In')){
                        benIn=MapGrouperBenefitsNet.get(key+'In');
                        benObjTo.Sequence_Number__c=benIn.Sequence_Number__c;
                        //T14-Start Added Benefit ID and Variation Condition Id
                        benObjTo.PCS_Benefit_Id__c=benIn.PCS_Benefit_Id__c;
                        benObjTo.Variation_Condition_ID__c=benIn.Variation_Condition_ID__c;
                        //T14-End
                    if(copayBenMap.containsKey(benIn.Id)){
                            AIA_Plan_Copay_Type__c copayTypeSelected=copayBenMap.get(benIn.Id).copayTypeSelectedObj ;
                            AIA_Plan_Copay_Type__c copayTypePecSpec=copayBenMap.get(benIn.Id).copayTypePecSpecObj;
                            system.debug('AIA_Plan_Copay_Type__c==copayTypeSelected===='+copayTypeSelected);
                            system.debug('AIA_Plan_Copay_Type__c==copayTypePecSpec===='+copayTypePecSpec);
                            if(copayTypeSelected!=null){
                                benWrapObjb.copayTypeWrapObj.copayTypeSelectedObj=copayTypeSelected;
                                benObjTo.Copay_Type_1_Mandate_Name__c=copayTypeSelected.MandateName__c;
                                system.debug('copayTypeSelected+++ in 1'+benIn.benefit_name__C+'======'+copayTypeSelected);
                                
               
                            }
                            if(copayTypePecSpec!=null && pp.Product_Category__c=='Medical'){
                                benWrapObjb.copayTypeWrapObj.copayTypePecSpecObj=copayTypePecSpec;
                                system.debug('copayTypeSelected+++ in 2'+benIn.benefit_name__C+'======'+copayTypeSelected);
                                benObjTo.Copay_Type_2_Mandate_Name__c=copayTypePecSpec.MandateName__c;
                            }
                        }
                       
                    }
                    
                    
                    
                    if (MapGrouperBenefitsNet.containsKey(key+'Out')){
                        benOut=MapGrouperBenefitsNet.get(key+'Out');
                        if(copayBenMap.containsKey(benOut.Id)){
                            AIA_Plan_Copay_Type__c copayTypeSelected=copayBenMap.get(benOut.Id).copayTypeSelectedObj ;// != null?copayBenMap.get(benIn.Id).copayTypeSelectedObj:new AIA_Plan_Copay_Type__c();  
                            AIA_Plan_Copay_Type__c copayTypePecSpec=copayBenMap.get(benOut.Id).copayTypePecSpecObj;// != null?copayBenMap.get(benIn.Id).copayTypePecSpecObj:new AIA_Plan_Copay_Type__c();  
                             system.debug('OUTAIA_Plan_Copay_Type__c==copayTypeSelected===='+copayTypeSelected);
                            system.debug('OUTAIA_Plan_Copay_Type__c==copayTypePecSpec===='+copayTypePecSpec);
                            if(copayTypeSelected!=null){
                                benWrapObjb.copayTypeWrapObj.copayTypeSelectedObj2=copayTypeSelected;
                                benObjTo.OON_Copay_Type_1_Mandate_Name__c=copayTypeSelected.MandateName__c;
                                system.debug('copayTypeSelected+++ out 1'+benIn.benefit_name__C+'======'+copayTypeSelected);
                                 }
                            if(copayTypePecSpec!=null && pp.Product_Category__c=='Medical'){
                                benWrapObjb.copayTypeWrapObj.copayTypePecSpecObj2=copayTypePecSpec;
                                benObjTo.OON_Copay_Type_2_Mandate_Name__c=copayTypePecSpec.MandateName__c;
                                system.debug('copayTypeSelected+++ out 2'+benIn.benefit_name__C+'======'+copayTypeSelected);
                                system.debug('default val out 2---'+ benObjTo.Benefit_Name__c+'---'+ benObjTo.DefaultPlanBenefitValue__c);
                            }
                            } 

                    }
                       
                    /************************* T02 -- END ********************************/
                    system.debug('@@benifitWrapList line 624 FormatDataFromPlanIntoWrapper3==benWrapObjm.aiaBenifitObj=='+benWrapObjb.aiaBenifitObj);
                    benWrapObjb.aiaBenifitObj=benObjTo;
                    benifitWrapList.add(benWrapObjb);
                    system.debug('@@benifitWrapList line 624'+benifitWrapList);
                }
                if(ParentBenLimitationLimit.containsKey(pName)){

                    System.debug('has limit--'+pname +'++++benSeq+++'+benSeq);
                    benSeq=benSeq+1;
                    BenifitsrWrapper benWrapObj = new BenifitsrWrapper();
                    benWrapObj.benifitNameStr = pname;// + ' - Limitation';
                    benWrapObj.GrpName=planGroupObj.Name;
                    AIA_Benefits__c benObjTo = new AIA_Benefits__c();
                    benObjTo.Sequence_Number_SF__c=benSeq;
                    tempbefhifen = '';
                    tempbefhifen = pname;
                   /* if(pname.contains('-')){
                        tempbefhifen = pname.substringBefore('-');
                    }
                    else{
                        tempbefhifen = pname;
                    } */
                    benObjTo.Benefit_Name__c=tempbefhifen ;//+ ' - Limitation';
                    //benObjTo.Benefit_Name__c=pname ;//+ ' - Limitation';
                    benObjTo.Type__c='Benefit';
                    benObjTo.Benefit_Type__c='Limitation';
                    benObjTo.Benefit_Record_Type__c='BRF';
                    benObjTo.Copay_Type_1_IsCovered__c = '';
                    benObjTo.OON_Copay_Type_1_IsCovered__c = '';
                    benObjTo.RecordTypeId=benrtByName.recordtypeid;
                    List<Limitations__c> LiLimitation=ParentBenLimitationLimit.get(pName);
                    benWrapObj.lstlimit=LiLimitation;
                    benWrapObj.lstJurisdictions = getjurdictions(benWrapObj.lstlimit);
                    Boolean IsASOOnly = true;
                    for(Limitations__c obj:LiLimitation){ 
                        System.debug('++++obj.IS_ASO_Only__c++'+obj.IS_ASO_Only__c);        
                        if(!obj.IS_ASO_Only__c)
                        {
                            IsASOOnly = false;
                        }
                        //T16 start added variationid,pcssbenefit id from limitation to benefit typelimitation    
                        benObjTo.Variation_Condition_ID__c=obj.Variation_Condition_ID__c;
                        benObjTo.PCS_Benefit_Id__c=obj.PCS_Benefit_Id__c;
                        //T16 end
                    }
                    benObjTo.IS_ASO_Only__c = IsASOOnly;
                    system.debug('@@benifitWrapList line 624 FormatDataFromPlanIntoWrapper4==benWrapObjm.aiaBenifitObj=='+benWrapObj.aiaBenifitObj);
                    benWrapObj.aiaBenifitObj=benObjTo;
                    benifitWrapList.add(benWrapObj);
                    system.debug('@@benifitWrapList line 624  limitation'+benifitWrapList);
                }
            }
        }
            grpNameWrapObj.benifitWrapList = benifitWrapList;
            grouperWrapList.add(grpNameWrapObj);
        }

        system.debug('@@grouperWrapList line 624'+grouperWrapList);
    }

   private boolean ValidatePlanBenifits(Proposed_Products__c pp)
    {
        List< AIA_Grouper__c> lstGroup = new List<AIA_Grouper__c>();
        Map<String,  AIA_Grouper__c> grpmap=new Map<String,  AIA_Grouper__c>();
        system.debug('+++inside ValidatePlanBenifits-----grouperWrapList'+grouperWrapList);
        system.debug(Logginglevel.INFO,'inside ValidatePlanBenifits---grouperWrapList==='+grouperWrapList);
        //system.debug(Logginglevel.INFO,'inside ValidatePlanBenifits---grouperWrapList.size==='+grouperWrapList.size());
        boolean isValid = true;
        if(grouperWrapList!= null &&  grouperWrapList.size()>0){
            List<AIA_Grouper__c> groupPPListToUpdate = new List<AIA_Grouper__c>();
            List<AIA_Benefits__c> benifitPPListToUpdate = new List<AIA_Benefits__c>();
            List<Limitations__c> lmtlst = new List<Limitations__c>();
            if(pp.Has_Benefit_Details__c)
                isPPData=true;
            else 
                isPPData=false;

            system.debug('+++inside ValidatePlanBenifits-----'+isPPdata);
            system.debug(Logginglevel.INFO,'ValidatePlanBenifits==='+isPPdata);
            if(isPPdata){
                // For Cost Share Part
                String InPCPCopay = '';
                String InSpecialistCopay = '';
                String InPerAdmissionCopay = '';
                String InCoinsuranceRange = '';
                String InGeneralCopay = '';
                String OutPCPCopay = '';
                String OutSpecialistCopay = '';
                String OutPerAdmissionCopay = '';
                String OutCoinsuranceRange = '';
                String OutGeneralCopay = '';
                
                if(bnftcostlst.size()>0 && bnftcostlst != null){
                    for(AIA_Benefits__c bnfcost:bnftcostlst)
                    {
                        system.debug('bnfcost.Cost_Share_SelectedAmount__c==' + bnfcost.Cost_Share_SelectedAmount__c);
                        system.debug('bnfcost.Benefit_Name__c==' + bnfcost.Benefit_Name__c);
                        if(bnfcost.Benefit_Name__c== 'PCP Copay')
                        {
                            InPCPCopay = bnfcost.Cost_Share_SelectedAmount__c;
                            OutPCPCopay = bnfcost.OON_Cost_Share_SelectedAmount__c;
                        }
                        else if(bnfcost.Benefit_Name__c== 'Specialist Copay')
                        {
                            InSpecialistCopay = bnfcost.Cost_Share_SelectedAmount__c;
                            OutSpecialistCopay = bnfcost.OON_Cost_Share_SelectedAmount__c;
                        }
                        else if(bnfcost.Benefit_Name__c== 'Per Admission Copay')
                        {
                            InPerAdmissionCopay = bnfcost.Cost_Share_SelectedAmount__c;
                            OutPerAdmissionCopay = bnfcost.OON_Cost_Share_SelectedAmount__c;
                        }
                        else if(bnfcost.Benefit_Name__c== 'General Copay')
                        {
                            InGeneralCopay = bnfcost.Cost_Share_SelectedAmount__c;
                            OutGeneralCopay = bnfcost.OON_Cost_Share_SelectedAmount__c;
                        }
                        else if(bnfcost.Benefit_Name__c== 'Coinsurance')
                        {
                            InCoinsuranceRange = bnfcost.Cost_Share_SelectedAmount__c;
                            OutCoinsuranceRange = bnfcost.OON_Cost_Share_SelectedAmount__c;
                        }
                    }
                    
                    for( GrouperWrapper grpWrapObj : grouperWrapList ) {
                        for( BenifitsrWrapper benWrapObj : grpWrapObj.benifitWrapList ) {
                            system.debug('benWrapObj.aiaBenifitObj.Cost_Share_High__c==' + benWrapObj.aiaBenifitObj.Copay_Type_1_High__c);
                            system.debug('benWrapObj.aiaBenifitObj.Cost_Share_Low__c==' + benWrapObj.aiaBenifitObj.Copay_Type_1_Low__c);
                            system.debug('benWrapObj.aiaBenifitObj.Cost_Share_Increment__c==' + benWrapObj.aiaBenifitObj.Copay_Type_1_Increment__c);
                            system.debug('benWrapObj.aiaBenifitObj.Cost_Share_AdditionalIncrements__c==' + benWrapObj.aiaBenifitObj.Copay_Type_1_Additional_Increments__c);
                            system.debug('benWrapObj.aiaBenifitObj.Cost_Share_InvalidIncrements__c==' + benWrapObj.aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c);
                            system.debug('benWrapObj.aiaBenifitObj.IN_Copay1_RunTime==' + benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c);
                            system.debug('benWrapObj.aiaBenifitObj.benWrapObj.benifitNameStr==' + benWrapObj.benifitNameStr);
                            system.debug('benWrapObj.aiaBenifitObj.IsAppGlobalCopay__c==' + benWrapObj.aiaBenifitObj.IsAppGlobalCopay__c);
                            system.debug('InPCPCopay==' + InPCPCopay);
                            system.debug('InSpecialistCopay==' + InSpecialistCopay);
                            system.debug('InPerAdmissionCopay==' + InCoinsuranceRange);
                            system.debug('ActualInPCPCopay==' + ActualInPCPCopay);
                            system.debug('ActualInSpecialistCopay==' + ActualInSpecialistCopay);
                            system.debug('benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c==' + benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c);
                            system.debug('benWrapObj==' + benWrapObj);
                            //Copay_Type_1_AliasName__c   
                            boolean test = true;
                            boolean test2 = true;                           
                            //system.debug('test==' + test);
                            if(benWrapObj.aiaBenifitObj.IsAppGlobalCopay__c)
                            {                           
                                if(InPCPCopay!=ActualInPCPCopay && benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c == ActualInPCPCopay && benWrapObj.aiaBenifitObj.Copay_Type_1_AliasName__c == 'PCP Copay' )
                                {
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test = validateCopayValues(benWrapObj.aiaBenifitObj.Copay_Type_1_High__c,benWrapObj.aiaBenifitObj.Copay_Type_1_Low__c,benWrapObj.aiaBenifitObj.Copay_Type_1_Increment__c,benWrapObj.aiaBenifitObj.Copay_Type_1_Additional_Increments__c,benWrapObj.aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c,InPCPCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test)
                                        benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = InPCPCopay;
                                }
                                else if(InSpecialistCopay!=ActualInSpecialistCopay && benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c == ActualInSpecialistCopay && benWrapObj.aiaBenifitObj.Copay_Type_1_AliasName__c == 'Specialist Copay' )
                                {
                                    system.debug('InSpecialistCopay==Inside' + InSpecialistCopay);
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test = validateCopayValues(benWrapObj.aiaBenifitObj.Copay_Type_1_High__c,benWrapObj.aiaBenifitObj.Copay_Type_1_Low__c,benWrapObj.aiaBenifitObj.Copay_Type_1_Increment__c,benWrapObj.aiaBenifitObj.Copay_Type_1_Additional_Increments__c,benWrapObj.aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c,InSpecialistCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test)
                                        benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = InSpecialistCopay;
                                }
                                else if(InGeneralCopay!=ActualInGeneralCoPay && benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c == ActualInGeneralCoPay && benWrapObj.aiaBenifitObj.Copay_Type_1_AliasName__c == 'General Copay' )
                                {
                                    system.debug('InPerAdmissionCopay==Inside' + InGeneralCopay);
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test = validateCopayValues(benWrapObj.aiaBenifitObj.Copay_Type_1_High__c,benWrapObj.aiaBenifitObj.Copay_Type_1_Low__c,benWrapObj.aiaBenifitObj.Copay_Type_1_Increment__c,benWrapObj.aiaBenifitObj.Copay_Type_1_Additional_Increments__c,benWrapObj.aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c,InGeneralCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test)
                                        benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = InGeneralCopay;
                                }
                                else if(InPerAdmissionCopay!=ActualInPerAdmissionCopay && benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c == ActualInPerAdmissionCopay && benWrapObj.aiaBenifitObj.Copay_Type_1_AliasName__c == 'Per Admission Copay' )
                                {
                                    system.debug('InSpecialistCopay==Inside' + InPerAdmissionCopay);
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test = validateCopayValues(benWrapObj.aiaBenifitObj.Copay_Type_1_High__c,benWrapObj.aiaBenifitObj.Copay_Type_1_Low__c,benWrapObj.aiaBenifitObj.Copay_Type_1_Increment__c,benWrapObj.aiaBenifitObj.Copay_Type_1_Additional_Increments__c,benWrapObj.aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c,InPerAdmissionCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test)
                                        benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = InPerAdmissionCopay;
                                }
                                
                                
                                if(InSpecialistCopay!=ActualInSpecialistCopay && benWrapObj.aiaBenifitObj.Copay_Type_2_AmountValueSelected__c == ActualInSpecialistCopay && benWrapObj.aiaBenifitObj.Copay_Type_2_AliasName__c == 'Specialist Copay' )
                                {
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test2 = validateCopayValues(benWrapObj.aiaBenifitObj.Copay_Type_2_High__c,benWrapObj.aiaBenifitObj.Copay_Type_2_Low__c,benWrapObj.aiaBenifitObj.Copay_Type_2_Increment__c,benWrapObj.aiaBenifitObj.Copay_Type_2_Additional_Increments__c,benWrapObj.aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c,InPCPCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test2)
                                        benWrapObj.aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = InSpecialistCopay;
                                }
                                else if(InPCPCopay!=ActualInPCPCopay && benWrapObj.aiaBenifitObj.Copay_Type_2_AmountValueSelected__c == ActualInPCPCopay && benWrapObj.aiaBenifitObj.Copay_Type_2_AliasName__c == 'PCP Copay' )
                                {
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test2 = validateCopayValues(benWrapObj.aiaBenifitObj.Copay_Type_2_High__c,benWrapObj.aiaBenifitObj.Copay_Type_2_Low__c,benWrapObj.aiaBenifitObj.Copay_Type_2_Increment__c,benWrapObj.aiaBenifitObj.Copay_Type_2_Additional_Increments__c,benWrapObj.aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c,InSpecialistCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test2)
                                        benWrapObj.aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = InPCPCopay;
                                }
                                else if(InGeneralCopay!=ActualInGeneralCoPay && benWrapObj.aiaBenifitObj.Copay_Type_2_AmountValueSelected__c == ActualInGeneralCoPay && benWrapObj.aiaBenifitObj.Copay_Type_2_AliasName__c == 'General Copay' )
                                {
                                    system.debug('InPerAdmissionCopay==Inside' + InGeneralCopay);
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test2 = validateCopayValues(benWrapObj.aiaBenifitObj.Copay_Type_2_High__c,benWrapObj.aiaBenifitObj.Copay_Type_2_Low__c,benWrapObj.aiaBenifitObj.Copay_Type_2_Increment__c,benWrapObj.aiaBenifitObj.Copay_Type_2_Additional_Increments__c,benWrapObj.aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c,InGeneralCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test2)
                                        benWrapObj.aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = InGeneralCopay;
                                }
                                else if(InPerAdmissionCopay!=ActualInPerAdmissionCopay && benWrapObj.aiaBenifitObj.Copay_Type_2_AmountValueSelected__c == ActualInPerAdmissionCopay && benWrapObj.aiaBenifitObj.Copay_Type_2_AliasName__c == 'Per Admission Copay' )
                                {
                                    system.debug('InSpecialistCopay==Inside' + InPerAdmissionCopay);
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test2 = validateCopayValues(benWrapObj.aiaBenifitObj.Copay_Type_2_High__c,benWrapObj.aiaBenifitObj.Copay_Type_2_Low__c,benWrapObj.aiaBenifitObj.Copay_Type_2_Increment__c,benWrapObj.aiaBenifitObj.Copay_Type_2_Additional_Increments__c,benWrapObj.aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c,InPerAdmissionCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test2)
                                        benWrapObj.aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = InPerAdmissionCopay;
                                }
                                
                                //Out Network
                                if(OutPCPCopay!=ActualOutPCPCopay && benWrapObj.aiaBenifitObj.OON_Copay_Type_1_AmountValueSelected__c == ActualOutPCPCopay && benWrapObj.aiaBenifitObj.OON_Copay_Type_1_AliasName__c == 'PCP Copay' )
                                {
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test = validateCopayValues(benWrapObj.aiaBenifitObj.OON_Copay_AmountHigh__c,benWrapObj.aiaBenifitObj.OON_Copay_AmountLow__c,benWrapObj.aiaBenifitObj.OON_Copay2_Increment__c,benWrapObj.aiaBenifitObj.OON_Copay_Additional_Increments__c,benWrapObj.aiaBenifitObj.OON_Copay_Additional_InvalidIncrements__c,OutPCPCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test)
                                        benWrapObj.aiaBenifitObj.OON_Copay_Type_1_AmountValueSelected__c = OutPCPCopay;
                                }
                                else if(OutSpecialistCopay!=ActualOutSpecialistCopay && benWrapObj.aiaBenifitObj.OON_Copay_Type_1_AmountValueSelected__c == ActualOutSpecialistCopay && benWrapObj.aiaBenifitObj.OON_Copay_Type_1_AliasName__c == 'Specialist Copay' )
                                {
                                    system.debug('OutSpecialistCopay==Inside' + OutSpecialistCopay);
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test = validateCopayValues(benWrapObj.aiaBenifitObj.OON_Copay_AmountHigh__c,benWrapObj.aiaBenifitObj.OON_Copay_AmountLow__c,benWrapObj.aiaBenifitObj.OON_Copay2_Increment__c,benWrapObj.aiaBenifitObj.OON_Copay_Additional_Increments__c,benWrapObj.aiaBenifitObj.OON_Copay_Additional_InvalidIncrements__c,OutSpecialistCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test)
                                        benWrapObj.aiaBenifitObj.OON_Copay_Type_1_AmountValueSelected__c = OutSpecialistCopay;
                                }
                                else if(OutGeneralCopay!=ActualOutGeneralCoPay && benWrapObj.aiaBenifitObj.OON_Copay_Type_1_AmountValueSelected__c == ActualOutGeneralCoPay && benWrapObj.aiaBenifitObj.OON_Copay_Type_1_AliasName__c == 'General Copay' )
                                {
                                    system.debug('OutPerAdmissionCopay==Inside' + OutGeneralCopay);
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test = validateCopayValues(benWrapObj.aiaBenifitObj.OON_Copay_AmountHigh__c,benWrapObj.aiaBenifitObj.OON_Copay_AmountLow__c,benWrapObj.aiaBenifitObj.OON_Copay2_Increment__c,benWrapObj.aiaBenifitObj.OON_Copay_Additional_Increments__c,benWrapObj.aiaBenifitObj.OON_Copay_Additional_InvalidIncrements__c,OutGeneralCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test)
                                        benWrapObj.aiaBenifitObj.OON_Copay_Type_1_AmountValueSelected__c = OutGeneralCopay;
                                }
                                else if(OutPerAdmissionCopay!=ActualOutPerAdmissionCopay && benWrapObj.aiaBenifitObj.OON_Copay_Type_1_AmountValueSelected__c == ActualOutPerAdmissionCopay && benWrapObj.aiaBenifitObj.OON_Copay_Type_1_AliasName__c == 'Per Admission Copay' )
                                {
                                    system.debug('OutSpecialistCopay==Inside' + OutPerAdmissionCopay);
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test = validateCopayValues(benWrapObj.aiaBenifitObj.OON_Copay_AmountHigh__c,benWrapObj.aiaBenifitObj.OON_Copay_AmountLow__c,benWrapObj.aiaBenifitObj.OON_Copay2_Increment__c,benWrapObj.aiaBenifitObj.OON_Copay_Additional_Increments__c,benWrapObj.aiaBenifitObj.OON_Copay_Additional_InvalidIncrements__c,OutPerAdmissionCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test)
                                        benWrapObj.aiaBenifitObj.OON_Copay_Type_1_AmountValueSelected__c = OutPerAdmissionCopay;
                                }
                                
                                
                                if(OutSpecialistCopay!=ActualOutSpecialistCopay && benWrapObj.aiaBenifitObj.OON_Copay_Type_2_AmountValueSelected__c == ActualOutSpecialistCopay && benWrapObj.aiaBenifitObj.Copay_Type_2_AliasName__c == 'Specialist Copay' )
                                {
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test2 = validateCopayValues(benWrapObj.aiaBenifitObj.OON_Copay2_High__c,benWrapObj.aiaBenifitObj.OON_Copay2_Low__c,benWrapObj.aiaBenifitObj.OON_Copay2_Increment__c,benWrapObj.aiaBenifitObj.OON_Copay_Type_2_Additional_Increments__c,benWrapObj.aiaBenifitObj.OON_Copay2Additional_InvalidIncrements__c,OutPCPCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test2)
                                        benWrapObj.aiaBenifitObj.OON_Copay_Type_2_AmountValueSelected__c = OutSpecialistCopay;
                                }
                                else if(OutPCPCopay!=ActualOutPCPCopay && benWrapObj.aiaBenifitObj.OON_Copay_Type_2_AmountValueSelected__c == ActualOutPCPCopay && benWrapObj.aiaBenifitObj.Copay_Type_2_AliasName__c == 'PCP Copay' )
                                {
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test2 = validateCopayValues(benWrapObj.aiaBenifitObj.OON_Copay2_High__c,benWrapObj.aiaBenifitObj.OON_Copay2_Low__c,benWrapObj.aiaBenifitObj.OON_Copay2_Increment__c,benWrapObj.aiaBenifitObj.OON_Copay_Type_2_Additional_Increments__c,benWrapObj.aiaBenifitObj.OON_Copay2Additional_InvalidIncrements__c,OutSpecialistCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test2)
                                        benWrapObj.aiaBenifitObj.OON_Copay_Type_2_AmountValueSelected__c = OutPCPCopay;
                                }
                                else if(OutGeneralCopay!=ActualOutGeneralCoPay && benWrapObj.aiaBenifitObj.OON_Copay_Type_2_AmountValueSelected__c == ActualOutGeneralCoPay && benWrapObj.aiaBenifitObj.Copay_Type_2_AliasName__c == 'General Copay' )
                                {
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        system.debug('OutPerAdmissionCopay==Inside' + OutGeneralCopay);
                                    test2 = validateCopayValues(benWrapObj.aiaBenifitObj.OON_Copay2_High__c,benWrapObj.aiaBenifitObj.OON_Copay2_Low__c,benWrapObj.aiaBenifitObj.OON_Copay2_Increment__c,benWrapObj.aiaBenifitObj.OON_Copay_Type_2_Additional_Increments__c,benWrapObj.aiaBenifitObj.OON_Copay2Additional_InvalidIncrements__c,OutGeneralCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test2)
                                        benWrapObj.aiaBenifitObj.OON_Copay_Type_2_AmountValueSelected__c = OutGeneralCopay;
                                }
                                else if(OutPerAdmissionCopay!=ActualOutPerAdmissionCopay && benWrapObj.aiaBenifitObj.OON_Copay_Type_2_AmountValueSelected__c == ActualOutPerAdmissionCopay && benWrapObj.aiaBenifitObj.Copay_Type_2_AliasName__c == 'Per Admission Copay' )
                                {
                                    system.debug('OutSpecialistCopay==Inside' + OutPerAdmissionCopay);
                                    if(pp.funding_Arrangement__c == 'Risk')
                                        test2 = validateCopayValues(benWrapObj.aiaBenifitObj.OON_Copay2_High__c,benWrapObj.aiaBenifitObj.OON_Copay2_Low__c,benWrapObj.aiaBenifitObj.OON_Copay2_Increment__c,benWrapObj.aiaBenifitObj.OON_Copay_Type_2_Additional_Increments__c,benWrapObj.aiaBenifitObj.OON_Copay2Additional_InvalidIncrements__c,OutPerAdmissionCopay,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                    if(test2)
                                        benWrapObj.aiaBenifitObj.OON_Copay_Type_2_AmountValueSelected__c = OutPerAdmissionCopay;
                                }
                            
                            }
                           if(benWrapObj.aiaBenifitObj.IsAppGlobalCoinsurance__c)
                            {
                                if(InCoinsuranceRange!=ActualInCoinsuranceRange && benWrapObj.aiaBenifitObj.CoInsurance_AmountValueSelected__c == ActualInCoinsuranceRange)
                                {
                                    if(pp.funding_Arrangement__c == 'Risk'){
                                     if(benWrapObj.aiaBenifitObj.Coinsurance_AmountLow__c != '' || benWrapObj.aiaBenifitObj.Coinsurance_AmountLow__c != null){
                                        test = validateCopayValues(benWrapObj.aiaBenifitObj.Coinsurance_AmountHigh__c,benWrapObj.aiaBenifitObj.Coinsurance_AmountLow__c,benWrapObj.aiaBenifitObj.Coinsurance_AmountIncrement__c,benWrapObj.aiaBenifitObj.Coinsurance_Amount_AddtionalIncrements__c,benWrapObj.aiaBenifitObj.Coinsurance_Amount_InvalidIncrements__c,InCoinsuranceRange,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                     }else{
                                        test = ValidateCoInsurance(InCoinsuranceRange,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                        }
                                        }
                                    if(test)
                                        benWrapObj.aiaBenifitObj.CoInsurance_AmountValueSelected__c = InCoinsuranceRange;
                                }
                                if(OutCoinsuranceRange!=ActualOutCoinsuranceRange && benWrapObj.aiaBenifitObj.OON_CoInsurance_AmountValueSelected__c == ActualOutCoinsuranceRange)
                                {
                                    if(pp.funding_Arrangement__c == 'Risk'){
                                      if(benWrapObj.aiaBenifitObj.OON_Coinsurance_AmountLow__c != '' || benWrapObj.aiaBenifitObj.OON_Coinsurance_AmountLow__c != null){
                                         test2 = validateCopayValues(benWrapObj.aiaBenifitObj.OON_Coinsurance_AmountHigh__c,benWrapObj.aiaBenifitObj.OON_Coinsurance_AmountLow__c,benWrapObj.aiaBenifitObj.OON_Coinsurance_AmountIncrement__c,benWrapObj.aiaBenifitObj.OON_Coinsurance_AddtionalIncrements__c,benWrapObj.aiaBenifitObj.OON_Coinsurance_InvalidIncrements__c,OutCoinsuranceRange,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                     }else{
                                         test2 = ValidateCoInsurance(OutCoinsuranceRange,benWrapObj.aiaBenifitObj.Benefit_Name__c);
                                         }
                                         }
                                    if(test2)
                                        benWrapObj.aiaBenifitObj.OON_CoInsurance_AmountValueSelected__c = OutCoinsuranceRange;
                                }
                            }
                            if(!test || !test2)
                            {
                                system.debug('isValid==' + isValid);
                                isValid = false;
                            }
                            //if() InPCPCopay = bnfcost.Cost_Share_SelectedAmount__c;
                            
                        }
                    }
                    system.debug('grouperWrapList==' + grouperWrapList);
                    system.debug(Logginglevel.INFO,'grouperWrapList==='+grouperWrapList);
                }
            }
        }
        return isValid;
    }
    @testVisible private boolean ValidateCoInsurance(string Value,string benifitName)
    {
        
       system.debug('ValidateCoInsurance==Value' + Value); 
        if(Value != '' && Value != 'NA')
        {                        
            if(integer.valueOf(Value) <= 100 && integer.valueOf(Value) >= 0)
            {
                return true;
            }                        
            else
            {
                //showError = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Benefit:'+ benifitName + ' cannot be changed. Coinsurance value entered should be between 0 and 100');
                ApexPages.addMessage(myMsg);
                return false;
            }
        }
        return true;       
        
    }
    @testVisible private boolean isMultipleofActual (integer currentvalue,Integer Increment)
    {
        while ( currentvalue > 0 )
            currentvalue = currentvalue - Increment;
     
        system.debug('isMultipleofActual==currentvalue==' + currentvalue);
        system.debug('isMultipleofActual==Increment==' + Increment);
        if ( currentvalue == 0 )
            return true;
     
        return false;
    }
    @testVisible private boolean validateCopayValues(string high,string low,string increment,string additionalincrement,string invalidincrement,string currentvalue,String benifitName)
    {
        
        system.debug('Entered==high==' + high);
        system.debug('Entered==low==' + low);
        system.debug('Entered==increment==' + increment);
        system.debug('Entered==additionalincrement==' + additionalincrement);
        system.debug('Entered==currentvalue==' + currentvalue);
        system.debug('Entered==benifitName==' + benifitName);
        if(currentvalue != '' && currentvalue != 'NA')
        {
            system.debug('Entered==Step1==' + currentvalue);
            if(additionalincrement != '' && additionalincrement != 'NA' && additionalincrement != null)
            {
                List<String> lstadditionalincrement = additionalincrement.split(',');
            
                Set<String> setadditionalincrement = new Set<string>();
                setadditionalincrement.addAll(lstadditionalincrement);
                system.debug('Entered==Step2==' + setadditionalincrement);
                if(setadditionalincrement.contains(currentvalue))
                {
                    system.debug('Entered==Step3==' + 'True');
                    return true;
                }
            }
            
            
            if(!(High == 'NA' || Low == 'NA' || Increment == 'NA' || High == '' || Low == '' || Increment == '')) {
                //var High = parseInt(sHigh); var Low = parseInt(sLow); var Increment = parseInt(sIncrement);
                //console.log(valueEnteredByUser+"--"+High+"--"+Low+"--"+Increment+"--"+Inclusions+"--"+Exclusions+"--"+HTMLelementID);
            if(high==null || high=='')
                return true;
            if(Integer.valueOf(currentvalue) <= Integer.valueOf(high)) {
                system.debug('Entered==Step4==' + (Integer.valueOf(currentvalue) <= Integer.valueOf(high)));
                if(low==null || low=='')
                    return true;
                if(Integer.valueOf(currentvalue) < Integer.valueOf(low)) {
                    system.debug('Entered==Step5==' + (Integer.valueOf(currentvalue) < Integer.valueOf(low)));
                    //console.log('invalid value - Low');  
                    //alert('Value Range should be '+ Low +' to '+ High +' with increment of '+ Increment +' and additional valid increments of '+ Inclusions +' and Invalid increments of '+ Exclusions);
                    showError = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Benefit: '+ benifitName +' cannot be changed. Please enter a value within the ranges provided' );
                    
                    //
                    ApexPages.addMessage(myMsg);
                    return false;
                }
                else {                                                         
                    //console.log('Increment--'+Increment);
                    //console.log('modulo--'+valueEnteredByUser % Increment);
                    system.debug('Integer.valueOf(currentvalue)==' + Integer.valueOf(currentvalue));
                    system.debug('increment==' + increment);
                    //system.debug('Integer.valueOf(increment)==' + Integer.valueOf(increment));
                    //system.debug('Entered==Step6==' + isMultipleofActual(Integer.valueOf(currentvalue),Integer.valueOf(increment)));
                    if(increment != null && increment != '')
                    {   
                    if(isMultipleofActual(Integer.valueOf(currentvalue),Integer.valueOf(increment))) {
                        system.debug('Entered==Step7==' + invalidincrement);
                        if(invalidincrement != '' && invalidincrement != 'NA' && invalidincrement != null)
                        {
                                
                              List<String> lstinvalidincrement = invalidincrement.split(',');
                                Set<String> setinvalidincrement  = new Set<string>();
                            setinvalidincrement.addAll(lstinvalidincrement);
                            system.debug('Entered==Step8==' + setinvalidincrement);
                            //var exclusionResult = isValueExcluded(valueEnteredByUser,Exclusions,HTMLelementID);
                            if(setinvalidincrement.contains(currentvalue))
                            {
                                system.debug('Entered==Step9==' + setinvalidincrement);
                                //console.log('Eventhough this value follows the High Low Increment Logic, it is excluded as per PCS configurations');   
                                //alert('Value Range should be '+ Low +' to '+ High +' with increment of '+ Increment +' and additional valid increments of '+ Inclusions +' and Invalid increments of For Benifit -' + benifitName);
                                showError = true;
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Benefit: '+ benifitName +' cannot be changed. Please enter a value within the ranges provided');
                                //'Eventhough this value follows the High Low Increment Logic, it is excluded as per PCS configurations For Benifit -' + benifitName );//(ApexPages.Severity.FATAL, 'Value Range should be '+ low +' to '+ high +' with increment of '+ Increment +' and additional valid increments of '+ additionalincrement +' and Invalid increments of '+ invalidincrement);
                                ApexPages.addMessage(myMsg);
                                return false;
                            } 
                            else
                            {
                                return true;
                            }                           
                        }
                        else
                        {
                            return true;
                        }
                    }
                    else {
                        system.debug('Entered==Step10==' + 'False');
                        //console.log('invalid value - Not a multiple');
                        //alert('Value Range should be '+ Low +' to '+ High +' with increment of '+ Increment +' and additional valid increments of '+ Inclusions +' and Invalid increments of '+ Exclusions);
                        showError = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Benefit: '+ benifitName +' cannot be changed. Please enter a value within the ranges provided' );
                        ApexPages.addMessage(myMsg);
                        return false;
                    }
}                   
                }                              
            }
            else
            {
                system.debug('Entered==Step11==' + 'False');
                //console.log('invalid value - High');  
                //alert('Value Range should be '+ Low +' to '+ High +' with increment of '+ Increment +' and additional valid increments of '+ Inclusions +' and Invalid increments of '+ Exclusions);
                showError = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Value Range should be '+ low +' to '+ high +' with increment of '+ Increment +' and additional valid increments of '+ additionalincrement +' and Invalid increments of '+ invalidincrement +' For Benifit -' + benifitName);
                ApexPages.addMessage(myMsg);
                return false;
            } 
        }
        
    
        }
        return true;
    }
    
    
    
    public void SaveAndContinuePlanBenefits(Proposed_Products__c pp){

        List< AIA_Grouper__c> lstGroup = new List<AIA_Grouper__c>();
        Map<String,  AIA_Grouper__c> grpmap=new Map<String,  AIA_Grouper__c>();
        if(grouperWrapList!= null && grouperWrapList.size()>0){
            List<AIA_Grouper__c> groupPPListToUpdate = new List<AIA_Grouper__c>();
            List<AIA_Benefits__c> benifitPPListToUpdate = new List<AIA_Benefits__c>();
            List<Limitations__c> lmtlst = new List<Limitations__c>();
            if(pp.Has_Benefit_Details__c)
                isPPData=true;
            else 
                isPPData=false;

            system.debug('+++inside SaveAndContinuePlanBenefits-----'+isPPdata);

            if(isPPdata){
            //For Mandates    T08  
            if(PPRxMandateRunTime!= null && PPRxMandateRunTime.size()>0){       
            update PPRxMandateRunTime;      
            }
                // For Cost Share Part
                if(bnftcostlst.size()>0 && bnftcostlst != null){
                    update bnftcostlst;
                    // Reset the static flag so that adjustment records can be created if benefits
                    // are updated below.  This is needed because two updates in once transaction.
                    AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag(); // Bill, T09
                }
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
                System.debug('++++grouperWrapList+++'+grouperWrapList);
                for( GrouperWrapper grpWrapObj : grouperWrapList ) {
                    if(grpWrapObj.aiaGrouper.id != null){
                        groupPPListToUpdate.add(grpWrapObj.aiaGrouper);
                    }

                    for( BenifitsrWrapper benWrapObj : grpWrapObj.benifitWrapList ) {
                        if(benWrapObj.aiaBenifitObj.id != null){
                            System.debug('======grpWrapObj.benifitWrapList==aiaBenifitObj==='+benWrapObj.aiaBenifitObj.Copay_Type_1_AmountValueSelected__c);
                            benifitPPListToUpdate.add(benWrapObj.aiaBenifitObj);
                        }
                        for(Limitations__c li:benWrapObj.lstlimit ){
                             Limitations__c pbl= new Limitations__c();
                            pbl=li;
        
        /************************* T02 -- start ********************************/
            
         /*   if(benWrapObj.aiaBenifitObj.Benefit_Type__c == 'Mandate' && benWrapObj.aiaBenifitObj.Mandate_Yes_No__c == 'No'){      
                       
                pbl.TierLimit_Selected__c = false;       
                pbl.TierAge_Selected__c = false;     
                pbl.MaxDuration_Selected__c = false;     
                pbl.MaxAge_Selected__c = false;      
                    
             }
             if(benWrapObj.aiaBenifitObj.Benefit_Type__c == 'Limitation' && benWrapObj.aiaBenifitObj.Mandate_Yes_No__c == 'Yes'){
                pbl.TierLimit_Selected__c = false;       
                pbl.TierAge_Selected__c = false;     
                pbl.MaxDuration_Selected__c = false;     
                pbl.MaxAge_Selected__c = false;      
                    
             } */
            if(li.MaxAgeType__c=='' || li.MaxAgeType__c==null){
                pbl.MaxAgeFrom__c=null;
                pbl.MaxAgeTo__c=null;
                 system.debug('+++++++++++ pb inside maxtype');
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
             if((li.TierLimit_Selected__c == true || li.TierAge_Selected__c == true || li.MaxDuration_Selected__c == true || li.MaxAge_Selected__c == true) && (li.Type__c == 'MaxRow' || li.Type__c == 'TierLimit'))
                 pbl.IsSelected__c = true;
               system.debug('+++++++++++pb limit name pbl ++++++'+pbl);
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
            if(li.MaxValue__c == null || li.MaxValue__c == 0){
            li.MaxDuration_Selected__c = false;
            }
              if(li.MaxDuration_Selected__c == true){
                if(li.MaxValue__c!=null)
                    li.MaxDuration_Selected_Value__c += li.MaxValue__c + ' ';
                if(li.MaxType__c!=null)
                    li.MaxDuration_Selected_Value__c += li.MaxType__c + ' ';    
                    
                if(li.MaxApply__c!=null)
                    li.MaxDuration_Selected_Value__c += li.MaxApply__c + ' ';
                  
                if(li.MaxDuration__c!=null)
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
                system.debug('+++++++++++groupPPListToUpdate ++++++'+groupPPListToUpdate); 
                system.debug('+++++++++++benifitPPListToUpdate ++++++'+benifitPPListToUpdate);  
                system.debug('+++++++++++lmtlst ++++++'+lmtlst); 
                system.debug(Logginglevel.INFO,'groupPPListToUpdate==='+groupPPListToUpdate);
                system.debug(Logginglevel.INFO,'benifitPPListToUpdate==='+benifitPPListToUpdate);
                system.debug(Logginglevel.INFO,'lmtlst==='+lmtlst);
                
                               
                if(groupPPListToUpdate.size()>0)
                    update groupPPListToUpdate;
                if(benifitPPListToUpdate.size()>0)
                    update benifitPPListToUpdate; 
                if(lmtlst.size()>0 && lmtlst != null) 
                    update lmtlst;
            }
            else {
                Integer seq=1;
                if(lstforCostShare.size()>0 && lstforCostShare !=null){
                    Integer count=0;
                    AIA_Grouper__c objgpr;
                    
                    
                // Satya - This piece of code is used to copy some cost share fields from medical PP tp related Drug PP depending upon Rx Integration
                // and Rx OOP Max Integration fields on Medical PP.
                String FOOP_Cost_Share_SelectedAmount = '';
                        String IOOP_Cost_Share_SelectedAmount = '';
                        String FD_Cost_Share_SelectedAmount = '';
                        String ID_Cost_Share_SelectedAmount = '';
                        system.debug('+++++++++++pp.Product_Category__c ++++++'+pp.Product_Category__c);
                        List<Proposed_Products__c> relatedMedicalPPList = new List<Proposed_Products__c>();
                if(pp.Product_Category__c == 'Drug' && pp.Related_Medical_Product__c != null ){
                    
                    relatedMedicalPPList = [Select id,Plan_Name__r.Plan_Id__c,Has_Benefit_Details__c,Plan_Name__c,Funding_Arrangement__c,
                                                      Product_Category__c,Benefit_Request_Form__c,Related_Medical_Product__c, 
                                                      Benefit_Request_Form__r.Jurisdiction__c,Integrated_Non_Integrated__c,RX_OOP_Max_Integration__c  
                                                      from Proposed_Products__c 
                                                      Where id =: pp.Related_Medical_Product__c ];
                    system.debug('+++++++++++pp.Product_Category__c ++++++'+pp.Product_Category__c); 
                    Integer grprcount = [select count() from AIA_Grouper__c where Proposed_Products__c = : pp.id];
                    system.debug('+++++++++++pp.grprcount ++++++'+grprcount); 
                    //if(grprcount == 0 && relatedMedicalPPList.size() > 0 && (relatedMedicalPPList[0].Integrated_Non_Integrated__c == 'Integrated' || relatedMedicalPPList[0].RX_OOP_Max_Integration__c == 'Integrated')){
                       if(relatedMedicalPPList.size() > 0 && relatedMedicalPPList != null){
                        system.debug('+++++++++++relatedMedicalPPList ++++++'+relatedMedicalPPList); 
                            /** Added order by clause to sort cost shares by Sequence Number - T06**/
                        List<AIA_Benefits__c> medicalBenefitList = new List<AIA_Benefits__c>([select id,name,Benefit_Name__c, Cost_Share_Default_Amount__c, OON_Cost_Share_Default_Amount__c,Cost_Share_Low__c,Cost_Share_Type__c,
                                                         Cost_Share_High__c,Cost_Share_Increment__c,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c, Cost_Share_AdditionalIncrements__c, Cost_Share_InvalidIncrements__c,   
                                                         OON_Cost_Share_InvalidIncrements__c, OON_Cost_Share_AdditionalIncrements__c,OON_Cost_Share_Low__c,OON_Cost_Share_High__c,IN_CostShare_3Month_DeductibleCarryover__c, ON_CostShare_3Month_DeductibleCarryover__c,
                                                         OON_Cost_Share_Increment__c,OON_Cost_Share_SelectedAmount__c,Cost_Share_SelectedAmount__c ,IS_ASO_Only__c, Tier_type__c , Mandate_Yes_No__c
                                                         ,Grouper__r.Proposed_Products__r.Product_Category__c,Grouper__r.Proposed_Products__r.Related_Medical_Product__c,Grouper__r.Proposed_Products__r.Integrated_Non_Integrated__c,Grouper__r.Proposed_Products__r.RX_OOP_Max_Integration__c
                                                         from AIA_Benefits__c 
                                                         where Grouper__r.Group_Type__c ='Cost Share Group' and 
                                                         Grouper__r.Proposed_Products__c=:pp.Related_Medical_Product__c and 
                                                         Grouper__r.Grouper_RecordtypeName__c='Proposed_Proposed'
                                                          order by Sequence_Number__c asc]);
                         system.debug('+++++++++++medicalBenefitList ++++++'+medicalBenefitList);                               
                        for(AIA_Benefits__c bnfcost:medicalBenefitList){
                            if(bnfcost.Benefit_Name__c== 'Family Out Of Pocket'){
                                FOOP_Cost_Share_SelectedAmount = bnfcost.Cost_Share_SelectedAmount__c;
                            }
                            if(bnfcost.Benefit_Name__c== 'Individual Out Of Pocket'){
                                IOOP_Cost_Share_SelectedAmount = bnfcost.Cost_Share_SelectedAmount__c;
                            }
                            if(bnfcost.Benefit_Name__c== 'Family Deductible'){
                                FD_Cost_Share_SelectedAmount = bnfcost.Cost_Share_SelectedAmount__c;
                            }
                            if(bnfcost.Benefit_Name__c== 'Individual Deductible'){
                                ID_Cost_Share_SelectedAmount = bnfcost.Cost_Share_SelectedAmount__c;
                            }
                        }   
                                               
                    }
                }
                system.debug('+++++++++++lstforCostShare ++++++'+lstforCostShare); 
                /*End of changes Satya*/
                
                    system.debug('+++++++++++lstforCostShare ++++++'+lstforCostShare); 
                    List<AIA_Benefits__c> lstobj = new List<AIA_Benefits__c>();
                    for(AIA_Plan_Benefits__c obj:lstforCostShare){
                        count=count+1;
                        if(count==1){
                            objgpr = new AIA_Grouper__c();
                            objgpr.Proposed_Products__c = propProdId;
                            objgpr.Name=obj.Benefit_Group__r.Name;
                            objgpr.Group_Type__c = 'Cost Share Group';
                            //T14-start Added InNetwork ID for Cost Share Grouper
                            objgpr.InNetwork__c=obj.Benefit_Group__r.Plan_Network__r.InNetwork__c;
                            //T14-End
                            objgpr.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
                            insert objgpr;  
                        } 
                        system.debug('+++++++++++obj ++++++'+obj);
                        AIA_Benefits__c objbnf =new AIA_Benefits__c();
                        objbnf.Benefit_Name__c = obj.Benefit_Name__c;
                        objbnf.RecordTypeId = Schema.SObjectType.AIA_Benefits__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
                        objbnf.Type__c ='Cost Share';
                        objbnf.Benefit_Type__c = 'Benefit';
                        //objbnf.Sequence_Number_SF__c=seq;
                        //objbnf.Sequence_Number__c=seq++;
                        /** T06 - Copy Sequence Number for cost shares from setup to run time objects **/
                        objbnf.Sequence_Number_SF__c=obj.Sequence_Number__c;
                        objbnf.Sequence_Number__c=obj.Sequence_Number__c;
                        /** T13 Start**/
                        objbnf.PCS_Benefit_Id__c=obj.PCS_Benefit_Id__c;
                        objbnf.Variation_Condition_ID__c=obj.Variation_Condition_ID__c;
                        /** T13 End **/
                         objbnf.Benefit_Record_Type__c = 'BRF';
                        if(obj.IS_ASO_Only__c== 'Yes' || obj.IS_ASO_Only__c == 'Y'){
                            objbnf.IS_ASO_Only__c = True; 
                        }
                        if(obj.IS_ASO_Only__c== 'No' || obj.IS_ASO_Only__c== 'N'){
                            objbnf.IS_ASO_Only__c = False;
                        }
                        objbnf.Cost_Share_Type__c = obj.Cost_Share_Type__c;
                        
                        if(objbnf.Benefit_Name__c == 'Three Month Carryover Deductible')
                        {
                        objbnf.Cost_Share_SelectedAmount__c = (obj.Three_Month_Deductible_Carryover__c!=''?obj.Three_Month_Deductible_Carryover__c:'');//T01
                        objbnf.Cost_Share_Default_Amount__c = (obj.Three_Month_Deductible_Carryover__c!=''?obj.Three_Month_Deductible_Carryover__c:'');//T01
                         }
                        system.debug('+++++++++++obj2 ++++++'+obj.Benefit_Name__c);
                        
                        objbnf.DefaultPlanBenefitValue__c= costShareOldValMap.get(obj.Benefit_Name__c);
                        objbnf.Cost_Share_Low__c = (obj.Cost_Share_Low__c!=''?obj.Cost_Share_Low__c:'0');
                        objbnf.Cost_Share_High__c = (obj.Cost_Share_High__c!=''?obj.Cost_Share_High__c:'0');
                        objbnf.Cost_Share_Increment__c = (obj.Cost_Share_Increment__c!=''?obj.Cost_Share_Increment__c:'0');
                        /*11-22-2016 change by indira -- as it was erroring out to check the new and old value*/
                        
                        if(objbnf.Benefit_Name__c != 'Three Month Carryover Deductible'){
                        objbnf.Cost_Share_SelectedAmount__c = (obj.Cost_Share_Default_Amount__c!=''?obj.Cost_Share_Default_Amount__c:'');
                        objbnf.Cost_Share_Default_Amount__c = (obj.Cost_Share_Default_Amount__c!=''?obj.Cost_Share_Default_Amount__c:'');
                        }
                        objbnf.Cost_Share_InvalidIncrements__c = (obj.Cost_Share_InvalidIncrements__c!=''?obj.Cost_Share_InvalidIncrements__c:'0');
                        objbnf.Cost_Share_AdditionalIncrements__c = (obj.Cost_Share_AdditionalIncrements__c!=''?obj.Cost_Share_AdditionalIncrements__c:'0'); objbnf.Grouper__c = objgpr.id;
                        
                        system.debug('+++++++++++maplst ++++++'+maplst);
                        if(maplst.containskey(obj.Benefit_Name__c)){

                            if(maplst.get(obj.Benefit_Name__c).Benefit_Name__c == 'Three Month Carryover Deductible'){
                            objbnf.OON_Cost_Share_SelectedAmount__c = (maplst.get(obj.Benefit_Name__c).Three_Month_Deductible_Carryover__c!=''?maplst.get(obj.Benefit_Name__c).Three_Month_Deductible_Carryover__c:'');//T01
                            objbnf.OON_Cost_Share_Default_Amount__c = (maplst.get(obj.Benefit_Name__c).Three_Month_Deductible_Carryover__c!=''?maplst.get(obj.Benefit_Name__c).Three_Month_Deductible_Carryover__c:'');//T01
                            }
                            //T14 start Added outNetwork ID for Cost Share Grouper
                            objgpr.OON_OutNetwork__c = maplst.get(obj.Benefit_Name__c).benefit_Group__r.Plan_Network__r.OON_OutNetwork__c;
                            update objgpr;
                            //T14 End
                            objbnf.OON_Cost_Share_Low__c = (maplst.get(obj.Benefit_Name__c).Cost_Share_Low__c!=''?maplst.get(obj.Benefit_Name__c).Cost_Share_Low__c:'0');
                            objbnf.OON_Cost_Share_High__c = (maplst.get(obj.Benefit_Name__c).Cost_Share_High__c!=''?maplst.get(obj.Benefit_Name__c).Cost_Share_High__c:'0');
                            objbnf.OON_Cost_Share_Increment__c = (maplst.get(obj.Benefit_Name__c).Cost_Share_Increment__c!=''?maplst.get(obj.Benefit_Name__c).Cost_Share_Increment__c:'0');
                            /*11-22-2016 change by indira -- as it was erroring out to check the new and old value*/
                            objbnf.OON_Cost_Share_SelectedAmount__c = (maplst.get(obj.Benefit_Name__c).Cost_Share_Default_Amount__c!=''?maplst.get(obj.Benefit_Name__c).Cost_Share_Default_Amount__c:'');
                            objbnf.OON_Cost_Share_Default_Amount__c = (maplst.get(obj.Benefit_Name__c).Cost_Share_Default_Amount__c!=''?maplst.get(obj.Benefit_Name__c).Cost_Share_Default_Amount__c:'');
                            
                            objbnf.OON_Cost_Share_InvalidIncrements__c = (maplst.get(obj.Benefit_Name__c).Cost_Share_InvalidIncrements__c!=''?maplst.get(obj.Benefit_Name__c).Cost_Share_InvalidIncrements__c:'0');                     
                            objbnf.OON_Cost_Share_AdditionalIncrements__c = (maplst.get(obj.Benefit_Name__c).Cost_Share_AdditionalIncrements__c!=''?maplst.get(obj.Benefit_Name__c).Cost_Share_AdditionalIncrements__c:'0');
                            
                            
                            
                        }
                        
                        
                        // Satya - This piece of code is used to copy some cost share fields from medical PP tp related Drug PP depending upon Rx Integration
                        // and Rx OOP Max Integration fields on Medical PP.
                        system.debug('+++++++++++FOOP_Cost_Share_SelectedAmount ++++++'+FOOP_Cost_Share_SelectedAmount); 
                        system.debug('+++++++++++relatedMedicalPPList2 ++++++'+relatedMedicalPPList); 
                        if(relatedMedicalPPList.size() > 0){
                            if(relatedMedicalPPList[0].Integrated_Non_Integrated__c == 'Integrated' && relatedMedicalPPList[0].RX_OOP_Max_Integration__c == 'Integrated'){
                                system.debug('+++++++++++If 1 ++++++'+FOOP_Cost_Share_SelectedAmount); 
                                if(objbnf.Benefit_Name__c == 'Family Out Of Pocket' && FOOP_Cost_Share_SelectedAmount != ''){
                                    objbnf.Cost_Share_SelectedAmount__c = FOOP_Cost_Share_SelectedAmount ;
                                    objbnf.IsRelatedCostShareCheck__c = true;
                                }
                                if(objbnf.Benefit_Name__c == 'Individual Out Of Pocket' && IOOP_Cost_Share_SelectedAmount != ''){
                                    objbnf.Cost_Share_SelectedAmount__c = IOOP_Cost_Share_SelectedAmount;
                                    objbnf.IsRelatedCostShareCheck__c = true;
                                }
                                if(objbnf.Benefit_Name__c == 'Family Deductible' && FD_Cost_Share_SelectedAmount != ''){
                                    objbnf.Cost_Share_SelectedAmount__c = FD_Cost_Share_SelectedAmount;
                                    objbnf.IsRelatedCostShareCheck__c = true;
                                }
                                if(objbnf.Benefit_Name__c == 'Individual Deductible' && ID_Cost_Share_SelectedAmount != ''){
                                    objbnf.Cost_Share_SelectedAmount__c = ID_Cost_Share_SelectedAmount;
                                    objbnf.IsRelatedCostShareCheck__c = true;
                                }
                            }else if(relatedMedicalPPList[0].Integrated_Non_Integrated__c == 'Non-Integrated' && relatedMedicalPPList[0].RX_OOP_Max_Integration__c == 'Integrated'){
                                system.debug('+++++++++++If else 1 ++++++'+FOOP_Cost_Share_SelectedAmount); 
                                if(objbnf.Benefit_Name__c == 'Family Out Of Pocket' && FOOP_Cost_Share_SelectedAmount != ''){
                                    objbnf.Cost_Share_SelectedAmount__c = FOOP_Cost_Share_SelectedAmount ;
                                    objbnf.IsRelatedCostShareCheck__c = true;
                                }
                                if(objbnf.Benefit_Name__c == 'Individual Out Of Pocket' && IOOP_Cost_Share_SelectedAmount != ''){
                                    objbnf.Cost_Share_SelectedAmount__c = IOOP_Cost_Share_SelectedAmount;
                                    objbnf.IsRelatedCostShareCheck__c = true;
                                }
                                
                            }
                        }                       
                        /*End of changes Satya*/
                        lstobj.add(objbnf);
                    }
                    if(lstobj.size()>0 && lstobj != null){
                        insert lstobj;

                    }
                }
                /***********************for benefits Groupers and benefit and limitation **************************/

                Map<String,BenifitsrWrapper> ParentBenefitsMap=new Map<String,BenifitsrWrapper>();
                Map<string, BenifitsrWrapper> AllChildBenMap= new Map<String,BenifitsrWrapper>();
                Map<String,List<Limitations__c>> ParBenLimitationMap= new Map<String,List<Limitations__c>>();
                List<AIA_Benefits__c> parentBenIns= new List<AIA_Benefits__c>();
                List<AIA_Benefits__c> childBenList= new List<AIA_Benefits__c>();
                Map<String,AIA_Benefits__c> Allbenefits= new Map<String,AIA_Benefits__c>();
                List<Limitations__c> LimitationList= new List<Limitations__c>();
                system.debug('+++ParentBenefitsMap++++---'+ParentBenefitsMap);
                system.debug('+++ParBenLimitationMap++++---'+ParBenLimitationMap);
                system.debug('+++AllChildBenMap++++---'+AllChildBenMap);

                for(GrouperWrapper gw:grouperWrapList){
                    AIA_Grouper__c grp= new AIA_Grouper__c();
                    grp=gw.aiaGrouper;
                    grp.Sequence_Number__c=gw.aiaGrouper.Sequence_Number__c;
                    /** T13 Start**/
                    grp.PCS_Grouper_Id__c=gw.aiaGrouper.PCS_Grouper_Id__c;
                    /** T13 End**/
                    if(gw.benifitWrapList.size()>0){
                        for(BenifitsrWrapper benwr: gw.benifitWrapList ){
                            system.debug('benefit wrapsss===='+benwr);
                            if(benwr.aiaBenifitObj!=null){
                                AIA_Benefits__c  ben= benwr.aiaBenifitObj;
                                system.debug('benfit===='+ben);
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
                    lstGroup.add(grp);
                    system.debug('====grp name==='+grp);
                }
                insert lstGroup;
                system.debug('+lstGroup+++++++'+lstGroup.size());
                String query= QueryBase2.getSobjectAllFieldsSOQL('AIA_Grouper__c', 'id in :lstGroup');
                lstGroup= database.query(query);
                system.debug('+lstGroup+++++++'+lstGroup);
                for(AIA_Grouper__c a:lstGroup){
                    grpmap.put(a.name, a);
                }
                //insert parent mandate or limit benefits
                for(BenifitsrWrapper pBen:ParentBenefitsMap.values()){
                    system.debug('+insert parent mandate/limita+++++++'+pBen);
                    AIA_Benefits__c benObjTo = new AIA_Benefits__c();
                    if(grpmap.containsKey(pBen.grpName)){
                        system.debug('++++parent has grouper+++++++'+grpmap.get(pBen.grpName));
                        benObjTo=pBen.aiaBenifitObj;
                        benObjTo.Grouper__c=grpmap.get(pBen.grpName).Id;
                        parentBenIns.add(benObjTo);
                    }
                }
                if (parentBenIns.size()>0)
                    insert parentBenIns;
                
                query= QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefits__c', 'id in :parentBenIns');
                parentBenIns= database.query(query);
                system.debug('++++parentBenIns+++++++'+parentBenIns.size()+'++++++++++++++'+  parentBenIns);
                
           /*     List<AIA_Benefits__c> MExist = new List<AIA_Benefits__c>();
                List<AIA_Benefits__c> LExist = new List<AIA_Benefits__c>();
                
                
                string queryME= QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefits__c', 'id in :parentBenIns AND Benefit_Name__c');
                List<AIA_Benefits__c> parentBenME= database.query(queryME);
                boolean MandateExist = false;
                for(AIA_Benefits__c ME:parentBenIns){
                if(ME.Benefit_Type__c == 'Limitation'){ 
                LExist.add(ME);
                }
                if(ME.Benefit_Type__c == 'Mandate'){
                MExist.add(ME);
                }
                
                for(AIA_Benefits__c ABME:MExist){
                    for(AIA_Benefits__c ABLE:LExist){
                    if(ABME.Benefit_Name__c == ABLE.Benefit_Name__c){
                       MandateExist = True
                      }
                    }
                  }  */
                
                for(AIA_Benefits__c pb:parentBenIns){
                    Allbenefits.put(pb.Benefit_Name__c+' - '+pb.Benefit_Type__c, pb);
                    system.debug('pb.Benefit_Name__c---'+pb.Benefit_Name__c);
                    List<Limitations__c> benLimit=new List<Limitations__c>();
                    if(ParBenLimitationMap.containsKey(pb.Benefit_Name__c+' - '+pb.Benefit_Type__c)){
                        benLimit=ParBenLimitationMap.get(pb.Benefit_Name__c+' - '+pb.Benefit_Type__c);
                        system.debug('benLimit---'+benLimit);
                        for(Limitations__c li:benLimit){
                            system.debug('+++++++++++ pb limit name++++++'+li);
                            Limitations__c pbl= new Limitations__c();
                            pbl=li;
                            pbl.Benefit__c=pb.Id;
             /*           if(pb.Copay_Type_1_Jurisdiction__c != pbl.Jurisdiction__c && pb.Benefit_Type__c == 'Mandate' && pb.Mandate_Yes_No__c == 'Yes'){      
                            pbl.IsSelected__c = false;      
                            pbl.TierLimit_Selected__c = false;      
                            pbl.TierAge_Selected__c = false;        
                            pbl.MaxDuration_Selected__c = false;        
                            pbl.MaxAge_Selected__c = false;     
                        }       
                        if(pb.Copay_Type_1_Jurisdiction__c == pbl.Jurisdiction__c && pb.Benefit_Type__c == 'Mandate' && pb.Mandate_Yes_No__c == 'Yes'){      
                            pbl.IsSelected__c = true;       
                            pbl.TierLimit_Selected__c = true;       
                            pbl.TierAge_Selected__c = true;     
                            pbl.MaxDuration_Selected__c = true;     
                            pbl.MaxAge_Selected__c = true;      
                                
                         }
                         if(pb.Copay_Type_1_Jurisdiction__c == pbl.Jurisdiction__c && pb.Benefit_Type__c == 'Limitation' && pb.Mandate_Yes_No__c == 'No'){      
                            pbl.IsSelected__c = true;       
                            pbl.TierLimit_Selected__c = true;       
                            pbl.TierAge_Selected__c = true;     
                            pbl.MaxDuration_Selected__c = true;     
                            pbl.MaxAge_Selected__c = true;      
                                
                         }     */
        /************************* T02 -- start ********************************/
                            if(li.MaxAgeType__c=='' || li.MaxAgeType__c==null){
                                pbl.MaxAgeFrom__c=null;
                                pbl.MaxAgeTo__c=null;
                                 system.debug('+++++++++++ pb inside maxtype');
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
                             
                               system.debug('+++++++++++pb limit name pbl ++++++'+pbl);   
        /************************* T02 -- END ********************************/
                            LimitationList.add(pbl);
                        }
                    }

                }
                if(LimitationList.size()>0)
                    insert LimitationList;

                for(BenifitsrWrapper cBen :AllChildBenMap.values()){
                    system.debug('+++childbenname++++---'+cBen);
                    AIA_Benefits__c benObjTo = new AIA_Benefits__c();
                    if(grpmap.containsKey(cBen.grpName)){
                        system.debug('+++got grouper++++---'+cBen.benifitNameStr);
                        benObjTo=cBen.aiaBenifitObj;
                        benObjTo.Grouper__c=grpmap.get(cBen.grpName).Id;
                        String Mname= cben.benifitlmt+' - Mandate';
                        String LName=cben.benifitlmt+' - Limitation';
                        system.debug('+++Mname++++---'+Mname);
                        system.debug('+++LName++++---'+LName);
                        if(Allbenefits.containsKey(Mname)){
                            benObjTo.Parent_Mandate_Benefit__c=Allbenefits.get(Mname).ID;
                            system.debug('+++has mandate++++---'+Allbenefits.get(Mname).ID);
                        }

                        if(Allbenefits.containsKey(LName)){
                            benObjTo.Parent_Benefit__c=Allbenefits.get(LName).ID;
                            system.debug('+++has Limitatiopn++++---'+Allbenefits.get(LName).ID);
                        }

                        AIA_Plan_Copay_Type__c copayTypeSelected=new AIA_Plan_Copay_Type__c();
                        if(cBen.copayTypeWrapObj.copayTypeSelectedObj!=null){
                            copayTypeSelected=cBen.copayTypeWrapObj.copayTypeSelectedObj;
                            system.debug('copayTypeSelected1+++'+copayTypeSelected);
                            system.debug('++pp.Product_Category__c++++'+pp.Product_Category__c);
                            IF(pp.Product_Category__c=='Medical' || pp.Product_Category__c=='Vision'  || pp.Product_Category__c =='Dental' ){        //T04 || pp.Product_Category__c=='Drug'
                                
                                benObjTo.InNetwork_ExtID_Copay1__c= copayTypeSelected.ExtID__c;

                                benObjTo.INN_MandateLockDownInd__c = copayTypeSelected.Plan_Benefits__r.MandateLockDownInd__c;
                                benObjTo.INN_MappingBRFBenefitID__c = copayTypeSelected.Plan_Benefits__r.MappingBRFBenefitID__c;
                                
                                
                                benObjTo.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                benObjTo.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;
                                
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
                                
                                benObjTo.Copay_Type_1_Jurisdiction__c = copayTypeSelected.Jurisdiction__c;
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
                if(pp.Product_Category__c=='Vision'){           //T04  start
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
                                 }           //T04  end
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
                            
                            benObjTo.InNetwork_ExtID_Copay1__c= copayTypeSelected.ExtID__c;
                            
                                benObjTo.INN_MandateLockDownInd__c = copayTypeSelected.Plan_Benefits__r.MandateLockDownInd__c;
                                benObjTo.INN_MappingBRFBenefitID__c = copayTypeSelected.Plan_Benefits__r.MappingBRFBenefitID__c;
                                
                                benObjTo.CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                benObjTo.Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c; 
                                
                                benObjTo.Coinsurance_AmountLow__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_AmountLow__c; 
                                benObjTo.Coinsurance_AmountHigh__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_AmountHigh__c; 
                                benObjTo.Coinsurance_AmountIncrement__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_AmountIncrement__c; 
                                benObjTo.Coinsurance_Amount_AddtionalIncrements__c= copayTypeSelected.Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c; 
                                benObjTo.Coinsurance_Amount_InvalidIncrements__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c;  
                                
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
                                benObjTo.IsAppGlobalCoinsurance__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCoinsurance__c;
                                benObjTo.IsAppGlobalCopay__c = copayTypeSelected.Plan_Benefits__r.IsAppGlobalCopay__c;
                                
                                benObjTo.Copay_Type_1_Jurisdiction__c = copayTypeSelected.Jurisdiction__c;
                            }
                                       
                        }
                        if(cBen.copayTypeWrapObj.copayTypePecSpecObj!=null && pp.Product_Category__c=='Medical' && cBen.copayTypeWrapObj.copayTypePecSpecObj.id != cBen.copayTypeWrapObj.copayTypeSelectedObj.id){
                            copayTypeSelected=cBen.copayTypeWrapObj.copayTypePecSpecObj;
                            system.debug('copayTypePecSpec1+++'+copayTypeSelected);
                            
                            benObjTo.InNetwork_ExtID_Copay2__c= copayTypeSelected.ExtID__c;
                            
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
                            system.debug('copayTypeSelected2+++'+copayTypeSelected);
                            if(pp.Product_Category__c=='Medical' || pp.Product_Category__c=='Vision' || pp.Product_Category__c == 'Dental' ){  //T04 || pp.Product_Category__c=='Drug'
                                
                                benObjTo.OutNetwork_ExtID_Copay1__c= copayTypeSelected.ExtID__c;
                                
                                benObjTo.ONN_MandateLockDownInd__c = copayTypeSelected.Plan_Benefits__r.MandateLockDownInd__c;
                                benObjTo.ONN_MappingBRFBenefitID__c = copayTypeSelected.Plan_Benefits__r.MappingBRFBenefitID__c;
                            
                                benObjTo.OON_CoInsurance_AmountValueSelected__c = copayTypeSelected.CoinsuranceAmount__c;
                                benObjTo.OON_Coinsurance_DefaultAmount__c = copayTypeSelected.CoinsuranceAmount__c;
                                
                                benObjTo.OON_Coinsurance_AmountLow__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_AmountLow__c; 
                                benObjTo.OON_Coinsurance_AmountHigh__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_AmountHigh__c; 
                                benObjTo.OON_Coinsurance_AmountIncrement__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_AmountIncrement__c; 
                                benObjTo.OON_Coinsurance_AddtionalIncrements__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c; 
                                benObjTo.OON_Coinsurance_InvalidIncrements__c = copayTypeSelected.Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c;  
                                
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
                                benObjTo.OON_Copay_Additional_Increments__c = copayTypeSelected.Copay_Additional_Increments__c;benObjTo.OON_Copay_Additional_InvalidIncrements__c = copayTypeSelected.Copay_Additional_InvalidIncrements__c;
                if(pp.Product_Category__c=='Vision'){    //T04  start
                                benObjTo.OON_Discount_Amount__c = copayTypeSelected.Discount_Amount__c;
                                benObjTo.OON_Discount_Amount_Default__c = copayTypeSelected.Discount_Amount__c;
                                
                                benObjTo.ON_Approximate_Member_Payment_w_Discount__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
                                benObjTo.ON_Approx_Member_Payment_w_Disc_Default__c = copayTypeSelected.Approximate_Member_Payment_w_Discount__c;
                                
                                benObjTo.OON_Allowed_Amount__c = copayTypeSelected.Allowed_Amount__c;
                                benObjTo.OON_Allowed_Amount_Default__c= copayTypeSelected.Allowed_Amount__c;
                                
                                benObjTo.OON_Discount_Applies__c = copayTypeSelected.Discount_Applies__c;
                                benObjTo.OON_Discount_Applies_Default__c = copayTypeSelected.Discount_Applies__c;
                                
                }       //T04  end
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Yes' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'Y'){
                                benObjTo.IS_ASO_Only__c = True; 
                                }
                                if(copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'No' || copayTypeSelected.Plan_Benefits__r.IS_ASO_Only__c== 'N'){
                                benObjTo.IS_ASO_Only__c = False;
                                }
                benObjTo.OON_Copay_Min_Payment__c = copayTypeSelected.MinPayAmount__c;
                                benObjTo.OON_Copay_Default_Min_Payment__c = copayTypeSelected.MinPayAmount__c;
                                
                                benObjTo.OON_Copay_Max_Payment__c = copayTypeSelected.MaxPayAmount__c;
                                benObjTo.OON_Copay_Default_Max_Payment__c = copayTypeSelected.MaxPayAmount__c;
                                
                                benObjTo.OON_Tier_Type__c=copayTypeSelected.TierType__c;
                                benObjTo.OON_Tier_Type_Default__c=copayTypeSelected.TierType__c;
                }   
                            else if(pp.Product_Category__c=='Drug'){
                            
                            benObjTo.OutNetwork_ExtID_Copay1__c= copayTypeSelected.ExtID__c;

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
                        if(cBen.copayTypeWrapObj.copayTypePecSpecObj2!=null && pp.Product_Category__c=='Medical' && cBen.copayTypeWrapObj.copayTypePecSpecObj2.id != cBen.copayTypeWrapObj.copayTypeSelectedObj2.id){
                            copayTypeSelected=cBen.copayTypeWrapObj.copayTypePecSpecObj2;
                            system.debug('copayTypePecSpec2+++'+copayTypeSelected);
                            
                            benObjTo.OutNetwork_ExtID_Copay2__c= copayTypeSelected.ExtID__c;
                            
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

                }

                if(childBenList.size()>0)
                    insert childBenList;
                if(pp.Has_Benefit_Details__c==false && childBenList.size()>0 ){
                    pp.Has_Benefit_Details__c=true;
                    update pp;
                }
            }
        }
        
    }

 public void DentalBenupdate(Proposed_Products__c pp){
  List<AIA_Benefits__c> DentalBenFinalList = new List<AIA_Benefits__c>();
  List<AIA_Grouper__c> DentalGrpList       = new List<AIA_Grouper__c>();
  List<AIA_Benefits__c> DentalBenList      = new List<AIA_Benefits__c>();
  string ppid = pp.id;   
  string BenefitGroup = 'Benefit Group';
  string Benefit = 'Benefit';
  if(pp.product_category__c == 'Dental'){
     String DentalGrpStr = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('AIA_Grouper__c', 'Proposed_Products__c=:ppid and Group_Type__c =:BenefitGroup','Proposed_Products__r.DHMO__c, ');
     DentalGrpList = database.query(DentalGrpStr);
     
     String DentalBenStr = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('AIA_Benefits__c', 'Grouper__r.Proposed_Products__c=:ppid and Type__c =:Benefit and Benefit_Type__c =:Benefit','Grouper__r.id, ');
     DentalBenList = database.query(DentalBenStr);

     for(AIA_Grouper__c DentalGrp:DentalGrpList){
       if(DentalGrp.Proposed_Products__r.DHMO__c == false){
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
           }
         }
   if(DentalBenFinalList.size()>0)
   update DentalBenFinalList; 
      }
 
  }  

    public  void createWrapListFromPlan(Proposed_Products__c pp) {
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        jurisdictionFrmPP = pp.Benefit_Request_Form__r.Jurisdiction__c;
        System.debug('+++++jurisdictionFrmPP ++'+jurisdictionFrmPP );
        String  planIdStr = String.valueof(pp.Plan_Name__c).left(15);

        getGroupersFromPlan(planIdStr,'BRF');
        getBenefitsForPlan(planIdStr,'BRF');
        // MAP: Benifit Id, 2 Copay Records
        System.debug('++++++++++++benefitIdSet++++++++++++++'+benefitIdSet);   

        getCopaysFromPlan();

        getPlanLimitation();

        getPlanCommentCodes();        
        String QueryStr=QueryBase2.getSobjectAllFieldsSOQL('AIA_Plan__c', 'Id=:planId');
                List<AIA_Plan__c> lstAIA_Plan = new List<AIA_Plan__c>();
                 lstAIA_Plan = database.query(QueryStr);
                 if(lstAIA_Plan != null && lstAIA_Plan.size()>0)
                 {
                    //AIA_Plan__c aia_Plan
                    NoOfNW = lstAIA_Plan[0].CountOfNetworks__c;
                }

        FormatDataFromPlanIntoWrapper(pp);

    }
 Map<String,string> costShareOldValMap=new map <String,string>();

    public void createWrapListFromPlanCostShr(String planIdStr) {
        String jurisdictionFrmPP = '';
        //List<Proposed_Products__c> ppList = [Select Plan_Name__c,Benefit_Request_Form__c, Benefit_Request_Form__r.Jurisdiction__c, Funding_Arrangement__c from Proposed_Products__c Where id =: propProdId ];
        // if( ppList != null && ppList.size()>0 && ppList[0].Benefit_Request_Form__c != null ) {
        jurisdictionFrmPP = pp.Benefit_Request_Form__r.Jurisdiction__c;
        // }

        grouperWrapListCostShr = new List<GrouperWrapper>();
        List<AIA_Plan_Network__c> planNetworkList = [Select id, Name from AIA_Plan_Network__c Where Plan__c =: planIdStr];
        List<AIA_Plan_Grouper__c> planGrouperBenList = new List<AIA_Plan_Grouper__c>();


        Set<String> groupNameSet = new Set<String>();
       //T14 Added InNetworkId and OutNetworkId to query
        List<AIA_Plan_Grouper__c> grprListToClr = [Select id, Name, Plan_Network__c,Type__c, Record_Type__c, Plan_Network__r.Name, Plan_Network__r.InNetwork__c,Plan_Network__r.OON_OutNetwork__c
                                                   From AIA_Plan_Grouper__c 
                                                   Where Plan_Network__c IN: planNetworkList AND Type__c = 'Cost Share Group' AND Record_Type__c = 'BRF' Order By Plan_Network__r.Name]; 
        for( AIA_Plan_Grouper__c groupObj : grprListToClr ) {
            if(!groupNameSet.contains(groupObj.Name)) {
                planGrouperBenList.add(groupObj);
                groupNameSet.add(groupObj.Name);
            }
        }
        //planNetworkList.clear();
        groupNameSet.clear();

        // MAP :  Grouper Name, Benifit Name, In Net/OutNet, Benifit Record
        Map<String, Map<String, Map<String, AIA_Plan_Benefits__c>>> benifitNetworkMap = new Map<String, Map<String, Map<String, AIA_Plan_Benefits__c>>>();
        Set<id> benefitIdSet = new Set<id>();
        lstforCostShare = new List<AIA_Plan_Benefits__c>();
        maplst = new Map<String,AIA_Plan_Benefits__c>();
        /** T06 - Added Sequence Number to the query **/
        /** T013 - Added benefitid,variationid to the query **/
        /** T14 - Added InNetwork,OutNetwork to the query **/
        for( AIA_Plan_Benefits__c benifitObj : [Select id,Variation_Condition_ID__c ,PCS_Benefit_Id__c,Record_Type__c,name, Benefit_Name__c,Benefit_Group__r.Name, Cost_Share_Increment__c,Three_Month_Deductible_Carryover__c,
                                                Cost_Share_AdditionalIncrements__c ,IS_ASO_Only__c, Cost_Share_InvalidIncrements__c, Cost_Share_Low__c,Cost_Share_High__c,
                                                Cost_Share_Default_Amount__c,Coinsurance_DefaultAmount__c ,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c, Benefit_Group__c, 
                                                Benefit_Group__r.Plan_Network__c, benefit_Group__r.Plan_Network__r.Name,benefit_Group__r.Plan_Network__r.InNetwork__c,benefit_Group__r.Plan_Network__r.OON_OutNetwork__c,Cost_Share_Type__c,Sequence_Number__c
                                                from AIA_Plan_Benefits__c 
                                                Where Benefit_Group__c IN: grprListToClr AND Record_Type__c = 'BRF']){
                if(benifitObj.Benefit_Group__r.Plan_Network__r.Name.contains('InNetwork')){
                lstforCostShare.add(benifitObj);
                String val=(benifitObj.Cost_Share_Default_Amount__c!=null?String.valueof(benifitObj.Cost_Share_Default_Amount__c):'');
                costShareOldValMap.put(benifitObj.Benefit_Name__c, val+'_');
            }
            if(benifitObj.Benefit_Group__r.Plan_Network__r.Name.contains('OutNetwork')){
                maplst.put(benifitObj.Benefit_Name__c,benifitObj);
                String val=costShareOldValMap.get(benifitObj.Benefit_Name__c)+
                     (benifitObj.Cost_Share_Default_Amount__c!=null?String.valueof(benifitObj.Cost_Share_Default_Amount__c):'');
                costShareOldValMap.put(benifitObj.Benefit_Name__c, val);
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
    //returns true if Proposed Product Benefit details data is available, false otherwise       
    public boolean hasPPBnftDetails(Proposed_Products__c pp){       
        boolean result = false;     
        if(pp.Has_Benefit_Details__c){//if checkbox is checked      
            result = true;      
        }
        return result;
    }
    //returns true if PCS API call has to be made, false otherwise
    public boolean isPCScallReq(AIA_Plan__c aia_Plan){
        boolean result = false;
        //check if Product Last Updated is greater than Config Last updated. If true get new data from PCS
        if(aia_Plan.Product_Last_Updated__c > aia_Plan.Configuration_Last_Updated__c || aia_Plan.Configuration_Last_Updated__c == null){

            result = true;
        }
        return result;
    }



    //get data from PCS
  // T20 - Start Commented getPCSdata() to stop data from PCS as part of US1650
      /** public pageReference getPCSdata(){
        system.debug('getting plan data from PCS webservice'+ planId);
        benftSum = AIA_PCSIntegrationHandler.callPCS(planIdValue,'BRF',propProdId,BRFPCSEffDate);
        isPCSdata = true;
        system.debug(isPCSdata+' PCS Service Call Result :: '+benftSum);
        return null;
    } **/
  // T20 - End
    //Get data from Salesforce objects
    public void getBenefitSummary_TO(){
        system.debug('getting plan data from Salesforce Objects'+planId);
        if(string.isNotBlank(planId)){
            system.debug('benftSum from SFDC:: '+benftSum);

        }
    }

    public String prodBtnClicked {
        get;
        // *** setter is NOT being called ***
        set {
            prodBtnClicked = value;
            System.debug('value: '+value);
        }
    }
    
    
    //T19--Start--Method to check whether the user is in Classic or lightning
    public Boolean getIsClassic() {
    return (UserInfo.getUiThemeDisplayed() == 'Theme3');
    }
    //T19--End


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

    public class BenifitsrWrapper {
        public String   benifitNameStr                 {get; set;}
        public String   benifitlmt                     {get; set;}
        public List<AIA_Plan_Benefit_Comment_Codes__c> MaxPlanCodelst {get; set;}
        //public String maxPlan {get;set;}
        Public String GrpName {get;set;}
        public Boolean madateCheck {get; set;}
        //public String tierPlan {get;set;}
        public List<AIA_Plan_Limitation__c>  lstPlanlimit  {get; set;}
        public List<Limitations__c> lstlimit {get; set;}
        public AIA_Benefits__c aiaBenifitObj           {get; set;}   // if data comming from Proposed Product
        //public List<NetworkTypeWrapper> networkWrapList   {get; set;}
        public CopayTypeWrapper copayTypeWrapObj  {get;set;}
        public List<SelectOption> lstJurisdictions { get;set; }     
        public BenifitsrWrapper(){
            this.GrpName='';
            this.madateCheck = false;
            this.MaxPlanCodelst= new List<AIA_Plan_Benefit_Comment_Codes__c>();
            this.lstlimit = new List<Limitations__c>();
            this.lstPlanlimit = new List<AIA_Plan_Limitation__c>();
            this.aiaBenifitObj = new AIA_Benefits__c();
            //this.networkWrapList = new List<NetworkTypeWrapper>();
            this.copayTypeWrapObj = new CopayTypeWrapper();
            this.lstJurisdictions = new List<SelectOption>();
        }

    }    


    // Will be used in Medical scenerio.
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

    public pageReference back(){
        pageReference pg1Ref = null;       
        propProdId = ApexPages.currentPage().getParameters().get('id');
        //pg1Ref = new pageReference('/apex/dupsummaryPage?scontrolCaching=1&id='+propProductId);
        pg1Ref = new pageReference('/apex/AIA_ProposedProd_Summary?scontrolCaching=1&id='+propProdId );

        pg1Ref.setRedirect(true);
        return pg1Ref;
    }

    public PageReference saveandRedirct(){
        /*system.debug('saveandRedirct propProductId'+propProductId);
    List<Proposed_Products__c> propsdPrdctLst =[Select Benefit_Request_Form__r.id,Funding_Arrangement__c, Name from Proposed_Products__c where id = :propProductId];*/
        propProdId = ApexPages.currentPage().getParameters().get('id');
        system.debug('saveandRedirct propProductId'+propProdId);
        // List<Proposed_Products__c> propsdPrdctLst =[Select Benefit_Request_Form__r.id, Name  from Proposed_Products__c where id = :propProdId];
        // if(propsdPrdctLst.size() > 0)
        PageReference  pgRef = new pageReference('/'+pp.Benefit_Request_Form__r.id);
        return pgRef;

    }

    public PageReference addPlan() {
        String planId = ApexPages.currentPage().getParameters().get('planId');
        String ppid=ApexPages.currentPage().getParameters().get('id');
        String brfId='';
        System.debug('addplan----ppid--->'+ppid);
        if(String.isNotBlank(ppid)){
            //  List<Proposed_Products__c> ppList=[select id, Benefit_Request_Form__c from Proposed_Products__c where id=:ppid];
            //  if(ppList!=null && ppList.size()>0){
            brfId=pp.Benefit_Request_Form__c;
            // }
        }
        PageReference pgRef=new PageReference('/apex/AIA_ProductSearchFiltering');
        system.debug('prodBtnClicked--'+prodBtnClicked);
        if(system.Test.isRunningTest()){
            prodBtnClicked=ApexPages.currentPage().getParameters().get('planType');
        }
        if(prodBtnClicked == 'Drug') {
            pgRef.getParameters().put('addPlan','Drug');
        }
        else if(prodBtnClicked == 'Dental') {
            pgRef.getParameters().put('addPlan','Dental');
        }
        else if(prodBtnClicked == 'Vision') {
            pgRef.getParameters().put('addPlan','Vision');
        }

        pgRef.getParameters().put('brfId',brfId);
        pgRef.getParameters().put('ppid',ppid);
        pgRef.getParameters().put('planId',planId);
        system.debug('url redirect.....'+pgRef.getUrl());
        pgRef.setRedirect(True);

        return pgRef;
    }
     public void hideErrorpanel(){
         showError = false;
         
     }
     
     private List<SelectOption> getjurdictions(List<Limitations__c> lstLimitaions)
     {
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