/*=========================================================================================
* Date     : 05/13/2017
* Developer    : RaviTeja
* Purpose      : To intitialize all the plan attributes at the header level of the JSON
*
*=========================================================================================
*                                 Update History
*                                 ---------------
* Date      |     Developer         Tag   Description
*===========+============+================================================================
* 05/13/2017|     Raviteja        |     | Initial Version  
*===========+============+================================================================
*/


public class AIA_OP4_PCS_InitPlanHeaderAttributes {
    
    public AIA_OP4PCSJSONStructure PCSJsonObj= new  AIA_OP4PCSJSONStructure();
    public Integer bdpListSize;
    
    //get all the plans from the bdp id
    public void getPlans(String IDbpd){
        try{
            //get all the Rxmandates and append to pcsjsonobj
            AIA_OP4PCSInitializeRXmandates populaterx=new AIA_OP4PCSInitializeRXmandates();
            populaterx.getrx(IDbpd);
            PCSJsonObj=populaterx.PCSJsonObj;
            
            Set<ID> bdpId = new Set<Id>(); // set of BDP Ids
            
            String QueryStringForBDP= QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefit_Design_Product__c','id=:IDbpd');
            List<AIA_Benefit_Design_Product__c> AIABDPFieldsList=Database.query(QueryStringForBDP);
            
            List<AIA_Benefit_Design_Product__c> AIABDPList=[Select CDH_Fund_Type__c,CDH_Type__c,Product_Line__c,Product_Category__c,
                                                            Funding_Arrangement__c,Jurisdiction__c,Out_of_Pocket_Max__c,BRF_Juridiction__c,IS_BRFCustom__c,Deductible__c,Exclusions__c,
                                                            Plan_Name__r.Plan_Name__c,Plan_Name__r.Option__c,Plan_Name__r.Plan_Id__c,Plan_Name__r.Product_Category__c,Plan_Name__r.Product_Line__c,
                                                            Plan_Name__r.Jurisdiction__c,Plan_Name__r.Effective_Date__c,Plan_Name__r.Termination_Date__c,Plan_Name__r.Legal_Entity__c,
                                                            Plan_Name__r.CDH__c,Plan_Name__r.CDH_Fund_Type__c,Plan_Name__r.CDH_Type__c,Plan_Name__r.Parent_Product__c,
                                                            Plan_Name__r.All_Market_Segments__c,Plan_Name__r.Product_Status__c,Plan_Name__r.PlanType__c,Plan_Name__r.DeductibleAccumulatorMethod__c,Plan_Name__r.PriorCarrierDedCred__c,
                                                            Plan_Name__r.OOPAccumulatorMethod__c,Plan_Name__r.Apply_Coinsurance_To_OOP__c,Plan_Name__r.Apply_Copay_To_OOP__c,Plan_Name__r.Apply_Deductible_To_OOP__c,
                                                            Plan_Name__r.Apply_Per_Admission_Copay_To_OOP__c,Plan_Name__r.Integrated_DedIndicator__c,Plan_Name__r.Integrated_OOP_Indicator__c,Plan_Name__r.GenDispsng__c,
                                                            Plan_Name__r.GenStepTherapy__c,Plan_Name__r.TierCount__c,Plan_Name__r.Network__c,Plan_Name__r.PriorAuth__c,Plan_Name__r.RetDispnsNMaintDaysSupp__c,Plan_Name__r.RetDispnsMaintDaysSupp__c,
                                                            Plan_Name__r.FamilyDedCalculation__c,Plan_Name__r.FamilyOOPCalculation__c,Plan_Name__r.BenefitPeriodMaximum__c,Plan_Name__r.PrescriptionCovrdArrngmnt__c,Plan_Name__r.PrescriptionComments__c,
                                                            Plan_Name__r.GenReferral__c,Plan_Name__r.GenReferralDescription__c,Plan_Name__r.ReferralSpec__c,Plan_Name__r.ReferralSpecDescription__c,
                                                            Plan_Name__r.MailOrdDispnsNMaintDaysSupp__c,Plan_Name__r.MailOrdDispnsMaintDaysSupp__c,Plan_Name__r.PrevntvCovrd__c,Plan_Name__r.PrevntvDrugCopayAmount__c,Plan_Name__r.OTCCovered__c,
                                                            Plan_Name__r.DiabeticSuppMandateApply__c,Plan_Name__r.DiabeticSuppCopayApply__c,Plan_Name__r.DiabeticSuppDedApply__c,Plan_Name__r.OralChemoMandateApply__c,Plan_Name__r.OralChemoCopayApply__c,
                                                            Plan_Name__r.OralChemoDedApply__c,Plan_Name__r.MailOrderAllDrugs__c,Plan_Name__r.GrowthHormone__c,Plan_Name__r.FertilityAgents__c,Plan_Name__r.FertilityAgentsComment__c,
                                                            Plan_Name__r.ErectileDysfunc__c,Plan_Name__r.ErectileDysfuncComment__c,Plan_Name__r.AllergySerums__c,Plan_Name__r.AllergySerumsComment__c,Plan_Name__r.HBSelectGeneric__c,
                                                            Plan_Name__r.RxFundamentalApply__c,Plan_Name__r.RxFundamentalDedCopayRule__c,Plan_Name__r.PrscrbdOrlContrcptvAndDevc__c,Plan_Name__r.RetMailDispnsMaint__c,Plan_Name__r.RetMailDispnsMaintLimitation__c,
                                                            Plan_Name__r.X05Options__c,Plan_Name__r.X05OptionsString__c,Plan_Name__r.X06RenewalPeriod__c,Plan_Name__r.X06RenewalPeriodString__c,Plan_Name__r.X07BenefitRenews__c,Plan_Name__r.X07BenefitRenewsString__c,
                                                            Plan_Name__r.X08RenewalType__c,Plan_Name__r.Notes__c,Plan_Name__r.Other_Requirements__c,Plan_Name__r.INN_and_OON_Annual_Maximum_combined__c,Plan_Name__r.INN_and_OON_Lifetime_Maximum_combined__c,
                                                            Plan_Name__r.INN_OON_Ded_Contribute_To_Each_Other__c,Plan_Name__r.Product_Sub_Category__c,Plan_Name__r.X01_Program__c,Plan_Name__r.Three_Month_Deductible_Carryover__c,Plan_Name__r.INN_and_OON_OOP_Contribute_To_Each_Other__c
                                                            From AIA_Benefit_Design_Product__c 
                                                            where id=:IDbpd];
            bdpListSize=AIABDPList.size();
            if(AIABDPList.size()>0 && AIABDPFieldsList.size()>0)
            {
                AIA_Benefit_Design_Product__c AIABDPObj= AIABDPList[0];
                for(AIA_Benefit_Design_Product__c obj:AIABDPList){
                    bdpId.add(obj.id); //Add Ids to set
                }
                
                AIA_Benefit_Design_Product__c AIABDPListFields= AIABDPFieldsList[0];
                PCSJsonObj.Plan_Name=AIABDPObj.Plan_Name__r.Plan_Name__c;
                PCSJsonObj.Option=AIABDPObj.Plan_Name__r.Option__c;
                PCSJsonObj.Plan_Id=AIABDPObj.Plan_Name__r.Plan_Id__c;
                if(AIABDPListFields.Product_Category__c == 'Drug'){
                     PCSJsonObj.Product_Category='Pharmacy';
                 }
                else{
                     PCSJsonObj.Product_Category=AIABDPListFields.Product_Category__c;
                }
                PCSJsonObj.Product_Line=AIABDPListFields.Product_Line__c;
                PCSJsonObj.Jurisdiction=AIABDPListFields.Jurisdiction__c;
                PCSJsonObj.Effective_Date=String.valueOf(AIABDPListFields.Effective_Date__c);
                PCSJsonObj.Termination_Date=String.valueOf(AIABDPObj.Plan_Name__r.Termination_Date__c);
                if(AIABDPListFields.Product_Category__c == 'Medical'){
                    PCSJsonObj.Legal_Entity=AIABDPListFields.Legal_Entity_Medical__c;//from BDP ,api differs from plan
                }
                else{
                    PCSJsonObj.Legal_Entity=AIABDPListFields.Legal_Entity_Ancillary__c;//from BDP ,api differs from plan
                }
                system.debug('--id-->'+AIABDPListFields.id+'-Cat->');
                PCSJsonObj.CDH=AIABDPListFields.CDH__c;
                PCSJsonObj.CDH_Fund_Type=AIABDPListFields.CDH_Fund_Type__c;
                PCSJsonObj.CDH_Type=AIABDPListFields.CDH_Type__c;
                PCSJsonObj.Parent_Product=AIABDPObj.Plan_Name__r.Parent_Product__c;
                PCSJsonObj.All_Market_Segments=AIABDPListFields.All_Market_Segments__c;
                PCSJsonObj.Product_Status=AIABDPObj.Plan_Name__r.Product_Status__c;
                PCSJsonObj.PlanType=AIABDPObj.Plan_Name__r.PlanType__c;
                PCSJsonObj.DeductibleAccumulatorMethod=AIABDPListFields.DeductibleAccumulatorMethod__c;
                PCSJsonObj.PriorCarrierDedCred=AIABDPListFields.Prior_Carrier_Ded_Credit__c;//differs from plan and bdp
                PCSJsonObj.OOPAccumulatorMethod=AIABDPListFields.OOPAccumulatorMethod__c;
                PCSJsonObj.Apply_Coinsurance_To_OOP=AIABDPListFields.Apply_Coinsurance_To_OOP__c;
                PCSJsonObj.Apply_Copay_To_OOP=AIABDPListFields.Apply_Copay_to_OOP__c;
                PCSJsonObj.Apply_Deductible_To_OOP=AIABDPListFields.Apply_Deductible_To_OOP__c;
                PCSJsonObj.Apply_Per_Admission_Copay_To_OOP=String.valueOf(AIABDPObj.Plan_Name__r.Apply_Per_Admission_Copay_To_OOP__c);
                PCSJsonObj.Integrated_DedIndicator=AIABDPListFields.Integrated_Ded_Indicator__c;//picklist value
                PCSJsonObj.Integrated_OOP_Indicator=AIABDPListFields.Integrated_OOP_Integration__c;//api differs from bdp and plan
                PCSJsonObj.GenDispsng=AIABDPListFields.GenDispsng__c;
                PCSJsonObj.GenStepTherapy=AIABDPListFields.GenStepTherapy__c;
                PCSJsonObj.TierCount=AIABDPListFields.TierCount__c;
                PCSJsonObj.Network=AIABDPListFields.Network__c;
                PCSJsonObj.PriorAuth=AIABDPListFields.PriorAuth__c;
                PCSJsonObj.RetDispnsNMaintDaysSupp=String.valueOf(AIABDPListFields.RetDispnsNMaintDaysSupp__c);
                PCSJsonObj.RetDispnsMaintDaysSupp=String.valueOf(AIABDPListFields.RetDispnsMaintDaysSupp__c);
                PCSJsonObj.FamilyDedCalculation=AIABDPListFields.Family_Deductible_Calculation__c;//api differs from bdp and plan
                PCSJsonObj.FamilyOOPCalculation=AIABDPListFields.Family_OPP_Calculation__c;//and differs in plan
                PCSJsonObj.BenefitPeriodMaximum=AIABDPListFields.Benefit_Period_Maximum__c;//api,data type differ in bdp
                PCSJsonObj.PrescriptionCovrdArrngmnt=AIABDPListFields.Prescription_Covered_Arrangement__c;//api differs in bdp and plan
                PCSJsonObj.PrescriptionComments=AIABDPListFields.Prescription_Covered_Arrangement_comment__c;//api differs in bdp and plan
                PCSJsonObj.GenReferral=AIABDPListFields.General_Referrals__c;//picklist
                PCSJsonObj.GenReferralDescription=AIABDPListFields.Gen_Referal_Mandate_Description__c;//name, api differs in bdp and plan
                PCSJsonObj.ReferralSpec=AIABDPListFields.Referral_to_a_Specialist_or_Nonphysician__c;//name,api not found in bdp
                PCSJsonObj.ReferralSpecDescription=AIABDPListFields.Ref_to_Splecialist_or_Nphy_Spl_Man_Desc__c;//api not found so updated from bdp
                PCSJsonObj.MailOrdDispnsNMaintDaysSupp=String.valueOf(AIABDPListFields.MailOrdDispnsNMaintDaysSupp__c);
                PCSJsonObj.MailOrdDispnsMaintDaysSupp=String.valueOf(AIABDPListFields.MailOrdDispnsMaintDaysSupp__c);
                PCSJsonObj.PrevntvCovrd=AIABDPListFields.PrevntvCovrd__c;
                PCSJsonObj.PrevntvDrugCopayAmount=String.valueOf(AIABDPListFields.PrevntvDrugCopayAmount__c);
                PCSJsonObj.OTCCovered=AIABDPListFields.OTCCovered__c;
                PCSJsonObj.DiabeticSuppMandateApply=AIABDPListFields.DiabeticSuppMandateApply__c;
                PCSJsonObj.DiabeticSuppCopayApply=AIABDPListFields.DiabeticSuppCopayApply__c;
                PCSJsonObj.DiabeticSuppDedApply=AIABDPListFields.DiabeticSuppDedApply__c;
                PCSJsonObj.OralChemoMandateApply=AIABDPListFields.OralChemoMandateApply__c;
                PCSJsonObj.OralChemoCopayApply=AIABDPListFields.OralChemoCopayApply__c;
                PCSJsonObj.OralChemoDedApply=AIABDPListFields.OralChemoDedApply__c;
                PCSJsonObj.MailOrderAllDrugs=AIABDPListFields.MailOrderAllDrugs__c;
                PCSJsonObj.GrowthHormone=AIABDPListFields.GrowthHormone__c;
                PCSJsonObj.FertilityAgents=AIABDPListFields.FertilityAgents__c;
                PCSJsonObj.FertilityAgentsComment=AIABDPListFields.Fertility_Agents_Limitation_Others__c;
                PCSJsonObj.ErectileDysfunc=AIABDPListFields.ErectileDysfunc_c__c;//diff api in bdp,plan
                PCSJsonObj.ErectileDysfuncComment=AIABDPListFields.Erectile_Dysfunction_Limitation_Others__c;
                PCSJsonObj.AllergySerums=AIABDPListFields.AllergySerums__c;
                PCSJsonObj.AllergySerumsComment=AIABDPListFields.Allergy_Serums_Limitation_Others__c;//diff api in bdp,plan
                PCSJsonObj.HBSelectGeneric=AIABDPListFields.HBSelectGeneric__c;
                PCSJsonObj.RxFundamentalApply=AIABDPListFields.RxFundamentalApply__c;
                PCSJsonObj.RxFundamentalDedCopayRule=AIABDPListFields.RxFundamentalDedCopayRule__c;
                PCSJsonObj.PrscrbdOrlContrcptvAndDevc=AIABDPListFields.Prescribed_Oral_Contraceptives_Devic__c;//diff in bdp,plan
                PCSJsonObj.RetMailDispnsMaint=AIABDPListFields.RetMailDispnsMaint__c;
                PCSJsonObj.RetMailDispnsMaintLimitation=AIABDPListFields.RetMailDispnsMaintLimitation__c;
                PCSJsonObj.X05Options=AIABDPListFields.X05_Options__c;//bdp and plan
                PCSJsonObj.X05OptionsString=AIABDPListFields.X05_Options_String__c;
                PCSJsonObj.X06RenewalPeriod=AIABDPListFields.X06_Renewal_Period__c;
                PCSJsonObj.X06RenewalPeriodString=AIABDPListFields.X06_Renewal_Period_String__c;
                PCSJsonObj.X07BenefitRenews=AIABDPListFields.X07_Benefit_Renews__c;
                PCSJsonObj.X07BenefitRenewsString=AIABDPListFields.X07_Benefit_Renews_String__c;
                PCSJsonObj.X08RenewalType=AIABDPListFields.X08_Renewal_Type__c;
                PCSJsonObj.Notes=AIABDPListFields.Notes__c;
                PCSJsonObj.Other_Requirements=AIABDPListFields.Other_Requirements__c;
                PCSJsonObj.INN_and_OON_Annual_Maximum_combined=AIABDPListFields.INN_and_OON_Annual_Maximum_combined__c;
                PCSJsonObj.INN_and_OON_Lifetime_Maximum_combined=AIABDPListFields.INN_and_OON_Lifetime_Maximum_combined__c;
                PCSJsonObj.INN_OON_Ded_Contribute_To_Each_Other=AIABDPListFields.INN_OON_Ded_Contribute_To_Each_Other__c;
                PCSJsonObj.Product_Sub_Category=AIABDPObj.Plan_Name__r.Product_Sub_Category__c;
                PCSJsonObj.X01_Program=AIABDPListFields.X01_Program__c;
                PCSJsonObj.Three_Month_Deductible_Carryover=AIABDPListFields.Three_Month_Deductible__c;
                PCSJsonObj.INN_and_OON_OOP_Contribute_To_Each_Other=AIABDPListFields.INN_and_OON_OOP_Contribute_To_Each_Other__c;
                PCSJsonObj.FundingArrangement=AIABDPListFields.Funding_Arrangement__c;
                PCSJsonObj.Exclusions=AIABDPListFields.Exclusions__c;
                PCSJsonObj.bdProductId=AIABDPListFields.id;
                PCSJsonObj.CFProductID=AIABDPListFields.PDPD_ID__c;
                PCSJsonObj.BSBSID=AIABDPListFields.BSBS__c;
                
            }
            system.debug('plans obj'+PCSJsonObj);
        }
        
        catch(Exception e){
            AIA_Utils util=new AIA_Utils();
            util.logException(e); 
        }
    }
}