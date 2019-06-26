/*=======================================================================================================
 * Date         : 08/08/2016
 * Developer    : Sandeep S
 * Purpose      : This is Apex representation of JSON response from PCS               
 *=======================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date        Developer    Tag   Description
 *===========+============+=====+========================================================================
 * 08/08/2016| Sandeep    |     | Initial Version                                         
 * 12/06/2016| Indira     | T01 | added field  ReferralSpecDescription__c to AIA_PCS_BenefitSummary class       
 * 02/06/2017| Asif       | T02 | Added tag ThreeMonthCarryoverDed
 * 03/14/2017| Asif       | T03 | Added tag BRFSequence & BDFSequence for Cost Shares and added a new 
 *                                cost share AnnualMax
 * 03/16/2017| Asif       | T04 | Added inner class for json object ThreeMonthCarryoverDed_Pg 
 * 03/27/2017| Goutham R  | T05 | Added new Tag realeted to Dental Plan at Grouper Level
 * 06/29/2017| Raviteja V | T06 | Added new Tag related VariationId,GrouperId,BenefitId
 * 07/10/2017| Goutham R  | T07 | Added new Tag at Benefit Level MappingBRFBrnrfitID MandateLockdownInd US:5098
 *===========+============+==============================================================================
 */
global class AIA_PCS_BenefitSummary{
    global String Message;
    global String CFPlanName;    
    global String Option;    
    global String ParentProductName;     
    global String CFProductID;   
    global String PlanID;    
    global String PreRenewalPlanID;   
    global String ProductCategory;   
    global String ProductLine;   
    global MarketSegments[] MarketSegments;
    global String ProductStatus;     
    global String EffectiveDate;     
    global String TermDate;  
    global String PlanType;  
    global String Jurisdiction;  
    global String LegalEntity;   
    global String DeductibleAccumulatorMethod;   
    global String CDHType;   
    global String CDHFundType;   
    global String PriorCarrierDedCred;   
    global String OOPAccumulatorMethod;  
    global String IntegratedDedIndicator;    
    global String IntegratedOOPIndicator;    
    global String ApplyCopayToOOP;   
    global String ApplyCoinsuranceToOOP;     
    global String ApplyDeductibleToOOP;  
    global String ApplyPerAdmissionCopayToOOP;   
    global String GenDispsng;    
    global String GenStepTherapy;    
    global String RxTierCount;   
    global Integer RetDispnsNMaintDaysSupp;  
    global Integer MailOrdDispnsNMaintDaysSupp;  
    global Integer RetDispnsMaintDaysSupp;   
    global Integer MailOrdDispnsMaintDaysSupp;   
    global String PrevntvCovrd;  
    global String PrevntvDrugCopayAmount;    
    global String OTCCovered;    
    global String DiabeticSuppMandateApply;  
    global String DiabeticSuppCopayApply;    
    global String DiabeticSuppDedApply;  
    global String OralChemoMandateApply;     
    global String OralChemoCopayApply;   
    global String OralChemoDedApply;     
    global String PriorAuth;     
    global String MailOrderAllDrugs;     
    global String GrowthHormone;     
    global String FertilityAgents;   
    global String FertilityAgentsComment;    
    global String ErectileDysfunc;   
    global String ErectileDysfuncComment;    
    global String AllergySerums;     
    global String AllergySerumsComment;  
    global String HBSelectGeneric;   
    global String RxFundamentalApply;    
    global String RxFundamentalDedCopayRule;     
    global String PrscrbdOrlContrcptvAndDevc;    
    global String RxNetwork;     
    global String RetMailDispnsMaint;    
    global String RetMailDispnsMaintLimitation; 
    global String X05Options;    
    global String X05OptionsString;  
    global String X06RenewalPeriod;  
    global String X06RenewalPeriodString;    
    global String X07BenefitRenews;  
    global String X07BenefitRenewsString;    
    global String X08RenewalType;
      //  T01 changes start
    global String ReferralSpecDescription;
      //  T01 changes End
    global NetworkRules[] NetworkRules{get;set;}  
    global RxMandate[] RxMandate{get;set;}  
    global Network[] Network {get;set;}
    global class MarketSegments {
        global String AliasName;     
    }
    global class NetworkRules{
    global string AliasName{get;set;}
    }
    global class RxMandate {
        global String MandateName{get;set;} 
        global String MandateDescription{get;set;} 
        global String MandateJurisdiction{get;set;} 
        global String MandateEffectiveDate{get;set;} 
        global String MandateTermDate{get;set;} 
        global String MandateApply{get;set;} 
    }
    global class Network {
        global String AliasName {get;set;}  
        global CostShareRanges CostShareRanges {get;set;}
        global Grouper[] Grouper {get;set;}
        global String NetworkID {get;set;}  
    }
    global class CostShareRanges {
        global OutOfPocket OutOfPocket {get;set;}
        global Deductible Deductible {get;set;}
        global DeductibleCarryover DeductibleCarryover {get;set;}
        global Copay Copay {get;set;}
        global CoinsuranceRange CoinsuranceRange {get;set;}
        global ThreeMonthCarryoverDed_Pg ThreeMonthCarryoverDed_Pg {get; set;}
        global LifetimeMax LifetimeMax {get;set;}
        global AnnualMax AnnualMax {get;set;}//T03
    }
    /** T04-Added new JSON object ThreeMonthCarryoverDed_Pg for capturing ThreeMonthCarryoverDed & its related sequence numbers **/
    global class ThreeMonthCarryoverDed_Pg {
        global String ThreeMonthCarryoverDed {get; set;}//T02
        global Integer BRFSequence {get;set;} 
        global Integer BDFSequence {get;set;} 
    }
    global class OutOfPocket {
        global Individual Individual {get;set;}
        global Family Family {get;set;}
        global Single Single {get;set;}
    }
    global class Individual {
        global Integer BRFSequence {get;set;} //T03 - Added Tag
        global Integer BDFSequence {get;set;} //T03 - Added Tag
        global String Low {get;set;}     
        global String High {get;set;} 
        global String Increment {get;set;}   
        global String Amount {get;set;}  
        global String AdditionalIncrements {get;set;}    
        global String InvalidIncrements {get;set;}   
    }
    global class Family {
        global Integer BRFSequence {get;set;} //T03 - Added Tag
        global Integer BDFSequence {get;set;} //T03 - Added Tag
        global String Low {get;set;}     
        global String High {get;set;} 
        global String Increment {get;set;}
        global String Amount {get;set;}  
        global String AdditionalIncrements {get;set;}    
        global String InvalidIncrements {get;set;}   
    }
    global class Single {
        global Integer BRFSequence {get;set;} //T03 - Added Tag
        global Integer BDFSequence {get;set;} //T03 - Added Tag
        global String High {get;set;}    
        global String Low {get;set;}     
        global String Increment {get;set;}   
        global String Amount {get;set;}  
        global String AdditionalIncrements {get;set;}    
        global String InvalidIncrements {get;set;}   
    }
    global class Deductible {
        global Individual Individual {get;set;}
        global Family Family {get;set;}
        global Single Single {get;set;}
    }
    global class DeductibleCarryover {
        global String Low {get;set;}     
        global String High {get;set;}    
        global String Increment {get;set;}   
        global String PeriodValue {get;set;}     
        global String TimeValue {get;set;}   
        global String AdditionalIncrements {get;set;}    
        global String InvalidIncrements {get;set;}   
    }
    global class Copay {
        global PCPCopay PCPCopay {get;set;}
        global SpecialistCopay SpecialistCopay {get;set;}
        global PerAdmissionCopay PerAdmissionCopay {get;set;}
    }
    global class PCPCopay {
        global String High {get;set;}    
        global String Low {get;set;}     
        global String Increment {get;set;}   
        global String Amount {get;set;}  
        global String AdditionalIncrements {get;set;} 
        global String InvalidIncrements {get;set;} 
        global Integer BRFSequence {get;set;} //T03 - Added Tag
        global Integer BDFSequence {get;set;} //T03 - Added Tag
    }
    global class SpecialistCopay {
        global String High {get;set;}    
        global String Low {get;set;}     
        global String Increment {get;set;}   
        global String Amount {get;set;}  
        global String AdditionalIncrements {get;set;}    
        global String InvalidIncrements {get;set;}   
        global Integer BRFSequence {get;set;} //T03 - Added Tag
        global Integer BDFSequence {get;set;} //T03 - Added Tag
    }
    global class PerAdmissionCopay {
        global String High {get;set;}    
        global String Low {get;set;}
        global String Increment {get;set;} 
        global String Amount {get;set;}
        global String AdditionalIncrements {get;set;}    
        global String InvalidIncrements {get;set;}   
        global Integer BRFSequence {get;set;} //T03 - Added Tag
        global Integer BDFSequence {get;set;} //T03 - Added Tag
    }
    global class CoinsuranceRange {
        global String Low {get;set;} 
        global String High {get;set;}    
        global String Increment {get;set;}   
        global String AdditionalIncrements {get;set;}    
        global String InvalidIncrements {get;set;}
        global String Amount;
        global Integer BRFSequence {get;set;} //T03 - Added Tag
        global Integer BDFSequence {get;set;} //T03 - Added Tag
    }
    
    global class LifetimeMax {
        global Single Single {get;set;}
    }
    
    //T03 - Added new cost share Annual Max
    global class AnnualMax {
        global Single Single {get;set;}
    }
    
    /*
    global class ThreeMonthCarryoverDed {
        global String ThreeMonthCarryoverDedTag {get;set;}
    }
    */
    
    global class Grouper {
        global String AliasName {get;set;}   
        global Integer BRFSequence {get;set;}   
        global Integer BDFSequence {get;set;} 
    /*****************T05 Start**************/
        global String IsCovered {get;set;}
        global String DeductibleApplies{get;set;}
        global String AnnualMaximumApplies{get;set;} 
        global String DavisString{get;set;} 
        global CoinsuranceRange CoinsuranceRange{get;set;} 
    /*****************T05 END**************/
    /*****************T06 Start**************/ 
       global String GrouperID {get;set;} 
    /*****************T06 END**************/    
        
        global Benefit[] Benefit {get;set;}
    }
    
    global class Benefit {
        global String AliasName{get;set;}    
        global Integer BRFSequence {get;set;} 
        global Integer BDFSequence {get;set;} 
        global BenefitSummaryComment[] BenefitSummaryComment {get;set;}
        global String ASOFlag {get;set;}     
        global MinPayment MinPayment {get;set;}
        global MaxPayment MaxPayment {get;set;}
        global CoinsuranceRange CoinsuranceRange {get;set;}
        global CopayRange CopayRange {get;set;}
        global VariationCondition[] VariationCondition {get;set;}
        global boolean IsAppGlobalCoinsurance {get;set;}
        global boolean IsAppGlobalCopay {get;set;}
        global String DavisBenefitString {get;set;}
        /*****************T06 Start**************/ 
        global String BenefitID {get;set;} 
        /*****************T06 END**************/ 
        /*****************T07 Start**************/
        global String MappingBRFBrnrfitID{get;set;}
        global String MandateLockdownInd {get;set;}
        /*****************T07 END**************/
    }
    global class BenefitSummaryComment {
        global String Comment {get;set;}     
    }
    global class MinPayment {
        /*Can be uncommented when max payment and min payment logic is written in AIA PCS handler class*/
        global String Low {get;set;}   
        global String High {get;set;}
        global String Increment {get;set;}   
        global String AdditionalIncrements {get;set;}    
        global String InvalidIncrements {get;set;}   
    }
    global class MaxPayment {
         /*Can be uncommented when max payment and min payment logic is written in AIA PCS handler class*/
        global String Low {get;set;}     
        global String High {get;set;}    
        global String Increment {get;set;}   
        global String AdditionalIncrements {get;set;}    
        global String InvalidIncrements {get;set;}  
    }
    global class CopayRange {
        global AmountRange AmountRange {get;set;}
        global PCPCopay PCPCopay {get;set;}
        global SpecialistCopay SpecialistCopay {get;set;}
        global PerAdmissionCopay PerAdmissionCopay {get;set;}
    }
    global class AmountRange {
        global String Low {get;set;} 
        global String High {get;set;} 
        global String Increment {get;set;}   
        global String AdditionalIncrements {get;set;}    
        global String InvalidIncrements {get;set;}   
    }
    global class VariationCondition {
        global String PlaceOfService {get;set;}  
        global String ProviderType {get;set;}    
        global MaxRows[] MaxRows {get;set;}
        global CopayType[] CopayType {get;set;}
        /*****************T06 Start**************/ 
        global String VariationID {get;set;}  
        /*****************T06 END**************/ 
    }
    global class MaxRows {
        global Integer MaxValue {get;set;}
        global String MaxType {get;set;}
        global Integer MaxDuration {get;set;}
        global String MaxDurationType {get;set;}
        global String MaxApply {get;set;}
        global String MaxAgeFrom {get;set;}
        global String MaxAgeTo {get;set;}
        global String MaxAgeType {get;set;}
        global String MandateInd {get;set;}
        global String MandateName {get;set;}
        global String Jurisdiction {get;set;}
        global String EffDate {get;set;}
        global String EndDate {get;set;}
        global BenefitCommentCodes[] BenefitCommentCodes {get;set;}
    }
    global class BenefitCommentCodes {
        global String Comment {get;set;}     
        global Integer Code {get;set;}   
        global String Type {get;set;}
        global String IsRequired {get;set;}
        global String FundingArrangement {get;set;} 
    }
    global class CopayType {
        global String MinPayAmount {get;set;}
        global String MaxPayAmount {get;set;}
        global String TierType {get;set;}
        global String AliasName {get;set;}   
        global String TierCopayAmount {get;set;}
        global String TierCoinsuranceAmount {get;set;} 
        global boolean IsCovered {get;set;}
        global String DeductibleApplies {get;set;} 
        global String TierLimitType {get;set;}
        global String TierLimitDurationType {get;set;}   
        global String TierLimitFrom {get;set;}
        global String TierLimitTo {get;set;}
        global String TierAgeFrom {get;set;}
        global String TierAgeTo {get;set;}
        global String TierAgeType {get;set;} 
        global String MandateInd {get;set;}
        global String MandateName {get;set;}
        global String Jurisdiction {get;set;}
        global String AllowedAmount {get;set;}
        global String DiscountAmount {get;set;}
        global String ScheduledAmounts  {get;set;}
        global String DiscountApplies  {get;set;}
        global String EffDate {get;set;}
        global String EndDate {get;set;}
        global BenefitCommentCodes[] BenefitCommentCodes {get;set;}
    }

   global static AIA_PCS_BenefitSummary parse(String json){
        return (AIA_PCS_BenefitSummary) System.JSON.deserialize(json, AIA_PCS_BenefitSummary.class);
    }
    
}