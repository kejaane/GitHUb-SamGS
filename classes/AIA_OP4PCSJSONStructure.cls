/*=========================================================================================
* Date     : 01/05/2017
* Developer    : Goutham Rapolu
* Purpose      : Struture for PCS Operation 4 JSON
* Class Name: AIA_PCSJSONStructure
*=========================================================================================
*                                 Update History
*                                 ---------------
* Date      | Developer         |Tag|       Description
*===========+============+================================================================
* 01/05/2017|  Goutham Rapolu    | T01| Initial Version                                         
* 05/26/2017|Sajitha Yalamanchili| T02| Modified as per latest inputs
* 06/09/2017|Raviteja Vadapalli  | T03| Modified plan fields as per user story B-04024  
*===========+============+================================================================
*
*/
public class AIA_OP4PCSJSONStructure{
    public String Plan_Name{get;set;}
    public String Option{get;set;}
    public String Plan_Id{get;set;}
    public String Product_Category{get;set;}
    public String Product_Line{get;set;}
    public String Jurisdiction{get;set;}
    public String Effective_Date{get;set;}
    public String Termination_Date{get;set;}
    public String Legal_Entity{get;set;}
    public String CDH{get;set;}
    public String CDH_Fund_Type{get;set;}
    public String CDH_Type{get;set;}
    public String Parent_Product{get;set;}
    public String All_Market_Segments{get;set;}
    public String Product_Status{get;set;}
    public String PlanType{get;set;}
    public String DeductibleAccumulatorMethod{get;set;}
    public String PriorCarrierDedCred{get;set;}
    public String OOPAccumulatorMethod{get;set;}
    public String Apply_Coinsurance_To_OOP{get;set;}
    public String Apply_Copay_To_OOP{get;set;}
    public String Apply_Deductible_To_OOP{get;set;}
    public String Apply_Per_Admission_Copay_To_OOP{get;set;}
    public String Integrated_DedIndicator{get;set;}
    public String Integrated_OOP_Indicator{get;set;}
    public String GenDispsng{get;set;}
    public String GenStepTherapy{get;set;}
    public String TierCount{get;set;}
    public String Network{get;set;}
    public String PriorAuth{get;set;}
    public String RetDispnsNMaintDaysSupp{get;set;}
    public String RetDispnsMaintDaysSupp{get;set;}
    public String FamilyDedCalculation{get;set;}
    public String FamilyOOPCalculation{get;set;}
    public String BenefitPeriodMaximum{get;set;}
    public String PrescriptionCovrdArrngmnt{get;set;}
    public String PrescriptionComments{get;set;}
    public String GenReferral{get;set;}
    public String GenReferralDescription{get;set;}
    public String ReferralSpec{get;set;}
    public String ReferralSpecDescription{get;set;}
    public String MailOrdDispnsNMaintDaysSupp{get;set;}
    public String MailOrdDispnsMaintDaysSupp{get;set;}
    public String PrevntvCovrd{get;set;}
    public String PrevntvDrugCopayAmount{get;set;}
    public String OTCCovered{get;set;}
    public String DiabeticSuppMandateApply{get;set;}
    public String DiabeticSuppCopayApply{get;set;}
    public String DiabeticSuppDedApply{get;set;}
    public String OralChemoMandateApply{get;set;}
    public String OralChemoCopayApply{get;set;}
    public String OralChemoDedApply{get;set;}
    public String MailOrderAllDrugs{get;set;}
    public String GrowthHormone{get;set;}
    public String FertilityAgents{get;set;}
    public String FertilityAgentsComment{get;set;}
    public String ErectileDysfunc{get;set;}
    public String ErectileDysfuncComment{get;set;}
    public String AllergySerums{get;set;}
    public String AllergySerumsComment{get;set;}
    public String HBSelectGeneric{get;set;}
    public String RxFundamentalApply{get;set;}
    public String RxFundamentalDedCopayRule{get;set;}
    public String PrscrbdOrlContrcptvAndDevc{get;set;}
    public String RetMailDispnsMaint{get;set;}
    public String RetMailDispnsMaintLimitation{get;set;}
    public String X05Options{get;set;}
    public String X05OptionsString{get;set;}
    public String X06RenewalPeriod{get;set;}
    public String X06RenewalPeriodString{get;set;}
    public String X07BenefitRenews{get;set;}
    public String X07BenefitRenewsString{get;set;}
    public String X08RenewalType{get;set;}
    public String Notes{get;set;}
    public String Other_Requirements{get;set;}
    public String INN_and_OON_Annual_Maximum_combined{get;set;}
    public String INN_and_OON_Lifetime_Maximum_combined{get;set;}
    public String INN_OON_Ded_Contribute_To_Each_Other{get;set;}
    public String Product_Sub_Category{get;set;}
    public String X01_Program{get;set;}
    public String Three_Month_Deductible_Carryover{get;set;}
    public String INN_and_OON_OOP_Contribute_To_Each_Other{get;set;}
    public String FundingArrangement{get;set;}
    public String Exclusions{get;set;}
    public String bdProductId{get;set;}
    public String CFProductID{get;set;}
    public String BSBSID{get;set;}
    public List<RxMandate> RxMandate{get;set;}
    public list<Cls_costShareList> costShareList{get;set;}
    public list<Cls_BenefitGrouperList> BenefitGrouperList{get;set;}
    public AIA_OP4PCSJSONStructure(){
        RxMandate = new List<RxMandate>();
        costShareList = new list<Cls_costShareList>();
        BenefitGrouperList = new list<Cls_BenefitGrouperList>();
    }
    Public Class RxMandate {
        public String MandateName{get;set;}
        public String MandateDescription{get;set;}
        public String MandateJurisdiction{get;set;}
        public String MandateEffectiveDate{get;set;}
        public String MandateTermDate{get;set;}
        public String MandateApply{get;set;}
        public String NetworkRulesAliasName{get;set;}
    }
    Public Class Cls_costShareList {
        public String CostShareName{get;set;}
        public list<Cls_networkList> NetworkList{get;set;}
        public Cls_costShareList(){
            NetworkList = new list<Cls_networkList>();
        }
    }
    Public Class Cls_networkList {
        public String Type{get;set;}
        public String NetworkID{get;set;}
        public String Amount{get;set;}
        public boolean Customized{get;set;}
    }
    Public Class Cls_BenefitGrouperList {
        public String GrouperName{get;set;}
        public String GrouperID{get;set;}
        public list<Cls_GrouperData> GrouperData{get;set;}
        public list<Cls_lstParentBenefit> lstParentBenefit{get;set;}
        public Cls_BenefitGrouperList(){
            GrouperData = new list<Cls_GrouperData>();
            lstParentBenefit = new list<Cls_lstParentBenefit>();
        }
    }
    Public Class Cls_GrouperData {
        public String Type{get;set;}
        public String NetworkID{get;set;}
        public String coinsurance{get;set;}
        public Boolean CoinsuranceCustomized{get;set;}
        public String DeductibleApplies{get;set;}
        public String IsCovered{get;set;}
        public String AnnualMaximumApplies{get;set;}
    }
    Public Class Cls_lstParentBenefit {
        public String ParentBenefitName{get;set;}
        public list<Cls_lstBenefit> lstBenefit{get;set;}
        public Cls_lstParentBenefit(){
            lstBenefit = new list<Cls_lstBenefit>();
        }
    }
    Public Class Cls_lstBenefit {
        public String BenefitName{get;set;}
        public String PlaceOfService{get;set;}
        public String MandateName{get;set;}
        public Boolean MandateInd{get;set;}
        public list<Cls_BenNetworkList> NetworkList{get;set;}
        public boolean newBenefit{get;set;}
        public String VariationConditionID{get;set;}
        public String BenefitID{get;set;}
        public String DavisBenefitVariable{get;set;}
        public String Jurisdiction{get;set;}
        public boolean Customized{get;set;}
        public Cls_lstBenefit(){
            NetworkList = new list<Cls_BenNetworkList>();
        }
    }
    Public Class Cls_BenNetworkList {
        public String Type{get;set;}
        public String NetworkID{get;set;}
        public String SpecialistCopayAmount{get;set;}
        public String PerAdmissionCopayAmount{get;set;}
        public String PCPCopayAmount{get;set;}
        public String GeneralCopayAmount{get;set;}
        public String IsCovered{get;set;}
        public String DeductibleApplies{get;set;}
        public String coinsurance{get;set;}
        public String AllowedAmount{get;set;}
        public String ScheduledAmount{get;set;}
        public String DiscountApplies{get;set;}
        public String DiscountAmount{get;set;}
        public String DiscountPercentage{get;set;}
        public String MinPayment{get;set;}
        public String MaxPayment{get;set;}
        public String TierType{get;set;}
        public String AnnualMaxApplies{get;set;}
        public list<Cls_lstCommentCode> lstCommentCode{get;set;}
        public Cls_BenNetworkList(){
            lstCommentCode = new list<Cls_lstCommentCode>();
        }
    }
    Public Class Cls_lstCommentCode {
    // Attributies from Commentcodes 
     public String LimName{get;set;}  
        public String Type{get;set;}
        public String TierLimitType{get;set;}
        public Decimal  TierLimitTo{get;set;}
        public Decimal  TierLimitFrom{get;set;}
        public String TierLimitDurationType{get;set;}
        public String TierAgeType{get;set;}
        public Decimal TierAgeTo{get;set;}
        public Decimal TierAgeFrom{get;set;}
        public Decimal MaxValue{get;set;}
        public String MaxType{get;set;}
        public String MaxDurationType{get;set;}
        public Decimal MaxDuration{get;set;}
        public String MaxApply{get;set;}
        public String MaxAgeType{get;set;}
        public Decimal MaxAgeTo{get;set;}
        public Decimal MaxAgeFrom{get;set;}
        public boolean MandateInd{get;set;}
        public String Jurisdiction{get;set;}
        public boolean IsSelected{get;set;}
        public boolean IsRequired{get;set;}
        public String IsCustom{get;set;}
        public String Comment{get;set;}
        public String Code{get;set;}
        public boolean isNew{get;set;}//newly included
        public String MandateName{get;set;}
        public String FundingArrangement{get;set;}
        public boolean isASO{get;set;}
        public String CommentType{get;set;}
    }
}