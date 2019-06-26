/*============================================================================================================
* Date         : 08/08/2016
* Developer    : Sandeep S
* Purpose      : Utility maps AIA_PCS_BenefitSummary JSON data is mapped to plan setup objects 
*                AIA_Plan__c,AIA_plan_network__c,AIA_plan_grouper__c & AIA_plan_benefit objects.
*=============================================================================================================
*                                 Update History
*                                 ---------------
* Date         Developer    Tag   Description
*============+=============+====+=============================================================================
* 08/08/2016 | Sandeep     |     | Initial Version                                         
* 12/06/2016 | Indira      | T01 | changes to add the ReferralSpecDescription__c tag       
* 12/12/2016 | Indira      | T02 | changes to update the Tiercoinsurance and deductibleApplies field
* 02/06/2017 | Asif K      | T03 | Modifications to save ThreeMonthDeductibleCarryover costshare
* 03/10/2017 | Ramakrishna | T04 | Added new fields Allowed Amount, Discount Amount in the Plan Copay 
*                                  section as part of Vision Plan.
* 03/14/2017 | Asif K      | T05 | Added code to save sequence number for cost shares
* 03/14/2017 | Asif K      | T06 | Added code to save the cost share Annual Max and modifications for 
*                                  ThreeMonthDeductibleCarryover cost share structure
* 03/29/2017 | Goutham R   | T07 | Added Code to save new TAG's related to Dental Plan.
* 04/12/2017 | Ramakrishna | T08 | Uncommented the mapping for coinsurance high low values.
* 05/11/2017 | Asif K      |     | Removed changes to save ThreeMonthDeductibleCarryover costshare because
*                                  that is to be sent in Operation 1 & because it is not network dependent
* 06/09/2017 | Asif K      | T09 | Updated logic for dental vs medical annual max display name
* 06/29/2017 | Raviteja V  | T10 | Added tags Variationid,BenefitId,GrouperID
* 07/05/2017 | Sajitha Y   | T11 | Added tags For NetworkID
* 07/10/2017 | Goutham R   | T12 | Added new Tag at Benefit Level MappingBRFBrnrfitID MandateLockdownInd US:5098
*============+=============+=====+============================================================================
*/

public with sharing class AIA_PlanTemplateMapper {
    
    public PlanWrapper pw;
    
    public String recordType;
    
    public String productCategory;//T09
    
    // Benefit Name --> BRF/BDD
    public Map<String,String> uniqueBenefitMap= new Map<String,String>();
    
    public Map<String,String> uniqueGrouperMap=new Map<String,String>();
    
    public AIA_PlanTemplateMapper(){
        pw=new PlanWrapper();
    }     
    
    
    /**
    * Method called to save JSON data into set up objects.
    * @param AIA_PCS_BenefitSummary apex JSON representation.
    * @param type as BRF or BDD
    **/
    public void saveToSetUp(AIA_PCS_BenefitSummary apb,String type){
        System.debug('inside savetosetup---->');
        List<SObject> listSobject=new List<SObject>();
        recordType=type;
        if(recordType=='BDD'){
            setUpBRFData(apb.PlanID);
        }
        Database.SaveResult []results;
        Savepoint sp=Database.setSavepoint();
        productCategory = apb.ProductCategory;//T09
        
        try{
            sp = Database.setSavepoint();
            AIA_Plan__c planSetUpObject=mapPlan(apb);
            // pw.aiaPlan=planSetUpObject;
            Schema.SObjectField aiaPlanExtField = AIA_Plan__c.Fields.Plan_Id__c;
            Database.upsert(planSetUpObject,aiaPlanExtField);
            system.debug('planSetUpObject'+planSetUpObject);
            pw.aiaPlan=planSetUpObject;
            mapPlanNetwork( apb,planSetUpObject);
            System.debug('apb--->'+apb);
            if(apb.RxMandate !=null)
            {
                mapRxMandate( apb,planSetUpObject);
                Schema.SObjectField RxMandateExtId =AIA_Plan_RxMandate__c.Fields.ExtId__c;
                Database.upsert(pw.RxMandateList, RxMandateExtId);
            } 
           if(apb.NetworkRules!= null){
                mapNetworkRules(apb,planSetUpObject);
                Schema.SObjectField NRExtId =AIA_Plan_RxMandate__c.Fields.ExtId__c;
                Database.upsert(pw.NetworkRulesList, NRExtId);
            } 
            
            Schema.SObjectField planNetworkExtId =AIA_Plan_Network__c.Fields.ExtId__c;
            Database.upsert(pw.networkList, planNetworkExtId);
            
          
            
           
             
            Schema.SObjectField planGrouperExtId = AIA_Plan_Grouper__c.Fields.ExtId__c;
            Database.upsert(pw.grouperList, planGrouperExtId);
            
            Schema.SObjectField planBenefitExtId =AIA_Plan_Benefits__c.Fields.ExtId__c;
            System.debug('Benefit Record--->'+pw.benefitList);
            Database.upsert(pw.benefitList, planBenefitExtId);
            List<AIA_Plan_Limitation__c> planLimitList=new List<AIA_Plan_Limitation__c>();
            planLimitList.addAll(pw.tierLimitList);
            planLimitList.addAll(pw.maxRowList);
            planLimitList.addAll(pw.mandateList);
            Schema.SObjectField limitExtId =AIA_Plan_Limitation__c.Fields.ExtId__c;
            Database.upsert(planLimitList, limitExtId);
            
            Schema.SObjectField copayExtId =AIA_Plan_Copay_Type__c.Fields.ExtId__c;
            Database.upsert(pw.copayTypeList, copayExtId);
            
            Schema.SObjectField benefitCommentExtId =AIA_Plan_Benefit_Comment_Codes__c.Fields.ExtId__c;
            Database.upsert(pw.benefitCommentCodeList, benefitCommentExtId);
        }catch(Exception e){
            Database.rollback(sp);
            System.debug('Error occurred--->'+e.getMessage());
            Error_log__c error=new Error_log__c(Cause__c=String.valueOf(e.getCause()),LineNumber__c=e.getLineNumber(),
                                                Message__c=e.getMessage(),StackTrace__c=e.getStackTraceString(),TypeName__c=e.getTypeName());
            insert error;
            throw e;  
        }
    }
    
    /**
    * Method called to map & save JSON data into AIA_Plan__c objects.
    * @param AIA_PCS_BenefitSummary apex JSON representation.
    * @return AIA_Plan__c
    **/    
    public AIA_Plan__c mapPlan(AIA_PCS_BenefitSummary apb){
        System.debug('Starting ---mapplan'+apb.MarketSegments);
        AIA_Plan__c  aiaPlan = new AIA_Plan__c();
        aiaPlan.Plan_Name__c=apb.CFPlanName;
        if(apb.MarketSegments!=null)
            aiaPlan.All_Market_Segments__c =getAllMarketSegments(apb.MarketSegments);
        aiaPlan.Apply_Coinsurance_To_OOP__c =apb.ApplyCoinsuranceToOOP;
        aiaPlan.Apply_Copay_To_OOP__c =apb.ApplyCopayToOOP;
        aiaPlan.Apply_Deductible_To_OOP__c =apb.ApplyDeductibleToOOP;
        aiaPlan.Apply_Per_Admission_Copay_To_OOP__c =apb.ApplyPerAdmissionCopayToOOP;
        //aiaPlan.CDH__c=apb.c field is not available in JSON
        aiaPlan.CDH_Fund_Type__c=apb.CDHFundType;
        aiaPlan.CDH_Type__c=apb.CDHType;
        aiaPlan.CF_ProductId__c=apb.CFProductID;
        if(recordType=='BRF')
            aiaPlan.Configuration_Last_Updated__c = Datetime.now();
        else if(recordType=='BDD')
            aiaPlan.BDF_Configuration_Last_Updated__c=Datetime.now();
        aiaPlan.DeductibleAccumulatorMethod__c=apb.DeductibleAccumulatorMethod;
        if(!String.isBlank(apb.EffectiveDate))
            aiaPlan.Effective_Date__c=Date.valueOf(apb.EffectiveDate);
        //aiaPlan.Has_Benefit_Summary__c=apb.
        aiaPlan.Integrated_DedIndicator__c =apb.IntegratedDedIndicator;
        aiaPlan.Integrated_OOP_Indicator__c =apb.IntegratedOOPIndicator;
        aiaPlan.Jurisdiction__c=apb.Jurisdiction; 
        aiaPlan.Legal_Entity__c=apb.LegalEntity;
        aiaPlan.OOPAccumulatorMethod__c=apb.OOPAccumulatorMethod;
        aiaPlan.Option__c=apb.Option;
        aiaPlan.Parent_Product__c=apb.ParentProductName;
        aiaPlan.Plan_Id__c=apb.PlanID;
        aiaPlan.PlanType__c=apb.PlanType;
        aiaPlan.PriorCarrierDedCred__c=apb.PriorCarrierDedCred;
        aiaPlan.Product_Category__c=apb.ProductCategory;
        //aiaPlan.Product_Last_Updated__c=System.now().Date();
        aiaPlan.Product_Line__c=apb.ProductLine;
        aiaPlan.Product_Status__c=apb.ProductStatus;
        if(!String.isBlank(apb.TermDate))
            aiaPlan.Termination_Date__c=Date.valueOf(apb.TermDate);
        aiaPlan.GenDispsng__c=apb.GenDispsng;
        aiaPlan.GenStepTherapy__c=apb.GenStepTherapy;
        if(String.isNotBlank(apb.RxTierCount))
            aiaPlan.TierCount__c=apb.RxTierCount;
        aiaPlan.RetDispnsNMaintDaysSupp__c=apb.RetDispnsNMaintDaysSupp;
        aiaPlan.MailOrdDispnsNMaintDaysSupp__c=apb.MailOrdDispnsNMaintDaysSupp;
        aiaPlan.RetDispnsMaintDaysSupp__c=apb.RetDispnsMaintDaysSupp;
        aiaPlan.MailOrdDispnsMaintDaysSupp__c=apb.MailOrdDispnsMaintDaysSupp;
        aiaPlan.PrevntvCovrd__c=apb.PrevntvCovrd;
        if(String.isNotBlank(apb.PrevntvDrugCopayAmount))
            aiaPlan.PrevntvDrugCopayAmount__c=Integer.valueOf(apb.PrevntvDrugCopayAmount);
        aiaPlan.OTCCovered__c=apb.OTCCovered;
        aiaPlan.DiabeticSuppMandateApply__c=apb.DiabeticSuppMandateApply;
        aiaPlan.DiabeticSuppCopayApply__c=apb.DiabeticSuppCopayApply;
        aiaPlan.DiabeticSuppDedApply__c=apb.DiabeticSuppDedApply;
        aiaPlan.OralChemoMandateApply__c=apb.OralChemoMandateApply;
        aiaPlan.OralChemoCopayApply__c=apb.OralChemoCopayApply;
        aiaPlan.OralChemoDedApply__c=apb.OralChemoDedApply;
        aiaPlan.PriorAuth__c=apb.PriorAuth;
        aiaPlan.MailOrderAllDrugs__c=apb.MailOrderAllDrugs;
        aiaPlan.GrowthHormone__c =apb.GrowthHormone; 
        aiaPlan.FertilityAgents__c=apb.FertilityAgents;
        aiaPlan.ErectileDysfunc__c=apb.ErectileDysfunc;
        aiaPlan.AllergySerums__c=apb.AllergySerums;
        aiaPlan.HBSelectGeneric__c=apb.HBSelectGeneric;
        aiaPlan.RxFundamentalApply__c=apb.RxFundamentalApply;
        aiaPlan.RxFundamentalDedCopayRule__c=apb.RxFundamentalDedCopayRule;
        aiaPlan.PrscrbdOrlContrcptvAndDevc__c=apb.PrscrbdOrlContrcptvAndDevc;
        //T01 changes start
        aiaPlan.ReferralSpecDescription__c=apb.ReferralSpecDescription;
        //T01 changes End
        //aiaPlan.ExtID__c='P1';
        System.debug('Returning ---mapplan'+aiaPlan);
        return aiaPlan;
    }
    
    /**
    * Method called to map & append JSON data of MarketSegments Node
    * with comma delimiter
    * @param AIA_PCS_BenefitSummary.MarketSegments marketSegment.
    * @return String ; concanetated string.
    **/ 
    public String getAllMarketSegments(List<AIA_PCS_BenefitSummary.MarketSegments> marSegments){
        List<String> strList=new List<String>();
        for(AIA_PCS_BenefitSummary.MarketSegments msegment:marSegments){
            strList.add(msegment.AliasName);
        }
        return String.join(strList,';');
    }
    
    
    public void setUpBRFData(String planId){
        
        for(AIA_Plan_Grouper__c planGrouper:[select id,Name,plan_Network__r.Name 
                                             from AIA_Plan_Grouper__c 
                                             where Record_Type__c='BRF' and    
                                                   Plan_Network__r.Plan__r.Plan_Id__c=:planId]){
            String key=planGrouper.Name+'_'+planGrouper.plan_Network__r.Name;
            if(!uniqueGrouperMap.containsKey(key)){
                uniqueGrouperMap.put(key,planGrouper.plan_Network__r.Name);
            }    
        }
        
        for(AIA_Plan_Benefits__c planBenefit:[select id,Benefit_Name__C,Benefit_Group__r.Name,Benefit_Group__r.plan_Network__r.Name 
                                              from AIA_Plan_Benefits__c 
                                              where Record_Type__c='BRF' and   
                                                    Benefit_Group__r.Plan_Network__r.Plan__r.Plan_Id__c=:planId]){
          String key=planBenefit.Benefit_Name__C+'_'+planBenefit.Benefit_Group__r.Name+'_'+planBenefit.Benefit_Group__r.plan_Network__r.Name;
          if(!uniqueGrouperMap.containsKey(key)){
              uniqueBenefitMap.put(key,planBenefit.Benefit_Group__r.plan_Network__r.Name);
          }    
      }
        
    }
    
    public boolean isExistingBRFGrouper(String key){
        if(recordType=='BDD' && uniqueGrouperMap.containsKey(key) ){
            return true;
        }else{
            return false;
        }
    }
    
    
    public boolean isExistingBRFBenefit(String key){
        if(recordType=='BDD' && uniqueBenefitMap.containsKey(key) ){
            return true;
        }else{
            return false;
        }
    }
    
    public void updateBDPBenefitGrouper(String planId){
        List<AIA_Grouper__c> runtimeGrouperList=[select id from AIA_Grouper__c where Benefit_Design_Product__r.Plan_Name__r.Plan_Id__c=:planId];
    }
    
    
    /**
    * Method called to map & save JSON data of Network Node to AIA_Plan_Network__c.
    * @param AIA_PCS_BenefitSummary .
    * @param AIA_Plan__c
    * @return List<AIA_Plan_Network__c> : list of AIA_Plan_Network__c. 
    **/ 
    public List<AIA_Plan_Network__c> mapPlanNetwork(AIA_PCS_BenefitSummary apb,AIA_Plan__c aiaPlan){
        System.debug('Starting ---mapPlanNetwork');
        List<AIA_Plan_Network__c>  planNetworkList= new List<AIA_Plan_Network__c>();
        Integer i=pw.networkList.size()+1;
        for(AIA_PCS_BenefitSummary.Network apcsn:apb.Network){
            AIA_Plan_Network__c planNetwork=new AIA_Plan_Network__c();
            AIA_Plan__c planReference= new AIA_Plan__c(Plan_Id__c=aiaPlan.Plan_Id__c);
            planNetwork.Plan__r=planReference;
            if(String.isNotBlank(apcsn.AliasName) && apcsn.AliasName=='In-Network'){
                planNetwork.Name='InNetwork';
                /*******************T11 START******************/ 
                planNetwork.InNetwork__c=apcsn.NetworkID;
                /*******************T11 End******************/ 
                }else if(String.isNotBlank(apcsn.AliasName) && apcsn.AliasName=='Out of Network'){
                planNetwork.Name='OutNetwork';
                /*******************T11 START******************/
                planNetwork.OON_OutNetwork__c=apcsn.NetworkID;
               /*******************T11 End******************/
               }
            // planNetwork.ExtID__c=aiaPlan.ExtID__c+'N'+i;
            planNetwork.ExtID__c=aiaPlan.Plan_Id__c+'N'+i;
            //planNetwork.Record_Type__c=recordType;
            planNetworkList.add(planNetwork);
            
            if(apcsn.CostShareRanges!=null){
                mapCostShareRangeGrouper(planNetwork,apcsn.CostShareRanges);
            }
            if(apcsn.Grouper!=null){
                mapBenefitPlanGrouper(planNetwork,apcsn.Grouper);  
            }
            i++;
        }
        if(planNetworkList.size()>0){
            pw.networkList.addAll(planNetworkList);
        }
        System.debug('Starting ---mapPlanNetwork');
        return planNetworkList;
    }
    
    
    public void mapCostShareRangeGrouper(AIA_Plan_Network__c apnSetup,AIA_PCS_BenefitSummary.CostShareRanges apcsn){
        AIA_Plan_Grouper__c costSharRangeGroup=new AIA_Plan_Grouper__c(); 
        String nodeName=AIA_PCS_BenefitSummary.CostShareRanges.class.getName();
        costSharRangeGroup.Name=nodeName.split('\\.').get(1);
        AIA_Plan_Network__c referenceNetwork = new AIA_Plan_Network__c(ExtID__c=apnSetup.ExtID__c);
        costSharRangeGroup.Plan_Network__r=referenceNetwork;
        costSharRangeGroup.Type__c='Cost Share Group';
        costSharRangeGroup.ExtID__c=apnSetup.ExtID__c+'CSG_'+recordType+pw.grouperList.size();
        costSharRangeGroup.Record_Type__c=recordType;
        pw.grouperList.add(costSharRangeGroup);
        mapCostSharePlanBenefit(apcsn.OutOfPocket,costSharRangeGroup);  
        mapCostSharePlanBenefit(apcsn.Deductible,costSharRangeGroup);
        mapCostSharePlanBenefit(apcsn.DeductibleCarryover,costSharRangeGroup);
        mapCostSharePlanBenefit(apcsn.LifetimeMax,costSharRangeGroup);
        mapCostSharePlanBenefit(apcsn.AnnualMax,costSharRangeGroup);
        mapCostSharePlanBenefit(apcsn.Copay,costSharRangeGroup);
        mapCostSharePlanBenefit(apcsn.CoinsuranceRange,costSharRangeGroup); //Added by Asif Oct-31 14:14
    }
    
    /**
    * Method called to map & save JSON data of CostShareRanges Node to AIA_Plan_Grouper__c.
    * @param AIA_PCS_BenefitSummary.Grouper .
    * @param AIA_Plan_Network__c
    * @return List<AIA_Plan_Grouper__c> : list of AIA_Plan_Grouper__c. 
    **/ 
    public List<AIA_Plan_Grouper__c> mapBenefitPlanGrouper(AIA_Plan_Network__c apnSetup,List<AIA_PCS_BenefitSummary.Grouper> benefitGroupList){
        Integer i=pw.grouperList.size();
        List<AIA_Plan_Grouper__c> aiaGroupList= new List<AIA_Plan_Grouper__c >();
        for(AIA_PCS_BenefitSummary.Grouper grouper:benefitGroupList){
            AIA_Plan_Grouper__c benefitGrouper= new AIA_Plan_Grouper__c();
            benefitGrouper.Name=grouper.AliasName;
            
            /*******************T10 START******************/   
            benefitGrouper.PCS_Grouper_Id__c    =grouper.GrouperId  ;
            /*******************T10 End******************/   

            benefitGrouper.Plan_Grouper_Name__c=grouper.AliasName;
            benefitGrouper.Type__c='Benefit Group';
         /*******************T07 START******************/   
         if(grouper.AnnualMaximumApplies != null){
            benefitGrouper.AnnualMaximumApplies__c = grouper.AnnualMaximumApplies;
            }
            if(grouper.DavisString!=null){
            benefitGrouper.DavisString__c = grouper.DavisString;
            }
            if(grouper.DeductibleApplies!=null){
            benefitGrouper.DeductibleApplies__c = grouper.DeductibleApplies;
            }
            if(grouper.IsCovered!=null){
            benefitGrouper.IsCovered__c = grouper.IsCovered;
            }
            if(grouper.CoinsuranceRange!=null){
                if(grouper.CoinsuranceRange.Amount!=null){
                benefitGrouper.CoInsurance__c=grouper.CoinsuranceRange.Amount;
                }
                if(grouper.CoinsuranceRange.Low!=null){
                benefitGrouper.CoInsurance_Low__c=grouper.CoinsuranceRange.Low;
                }
                if(grouper.CoinsuranceRange.High!=null){
                benefitGrouper.CoInsurance_High__c=grouper.CoinsuranceRange.High;
                }
                if(grouper.CoinsuranceRange.Increment!=null){
                benefitGrouper.CoInsurance_Increment__c=grouper.CoinsuranceRange.Increment;
                }
                if(grouper.CoinsuranceRange.AdditionalIncrements!=null){
                benefitGrouper.CoInsurance_AddIncrement__c=grouper.CoinsuranceRange.AdditionalIncrements;
                }
                if(grouper.CoinsuranceRange.InvalidIncrements!=null){
                benefitGrouper.CoInsurance_InvalidIncrement__c=grouper.CoinsuranceRange.InvalidIncrements;
                }
            }
            /*******************T07 END******************/
            if(recordType=='BRF')
                benefitGrouper.Sequence_Number__c=grouper.BRFSequence;
            if(recordType=='BDD')
                benefitGrouper.Sequence_Number__c=grouper.BDFSequence;
            AIA_Plan_Network__c referenceNetwork = new AIA_Plan_Network__c();
            referenceNetwork.ExtID__c=apnSetup.ExtID__c;
            benefitGrouper.Plan_Network__r=referenceNetwork;
            benefitGrouper.ExtID__c=apnSetup.ExtID__c+'GB_'+recordType+i;
            benefitGrouper.Record_Type__c=recordType;
            String key=grouper.AliasName+'_'+apnSetup.Name;
            if(isExistingBRFGrouper(key)){
                benefitGrouper.ISExisting_Grouper__c=TRUE;
            }
            aiaGroupList.add(benefitGrouper);
            i++;
            mapBenefitPlanBenefit(benefitGrouper,grouper,apnSetup.Name);
        }
        if(pw!=null && aiaGroupList.size()>0){
            pw.grouperList.addAll(aiaGroupList);  
        }
        System.debug('Inside benefitplan grouper---->'+aiaGroupList);
        return aiaGroupList;
    }
      
    /**
    * Method called to map & save JSON data of Grouper Node to AIA_Plan_Benefits__c.
    * @param AIA_PCS_BenefitSummary.Grouper .
    * @param AIA_Plan_Grouper__c
    * @return List<AIA_Plan_Benefits__c> : list of AIA_Plan_Benefits__c. 
    **/ 
    public List<AIA_Plan_Benefits__c>  mapBenefitPlanBenefit(AIA_Plan_Grouper__c grouperSetup,AIA_PCS_BenefitSummary.Grouper grouper,String networkName){
        system.debug('Hello HU');
        List<AIA_Plan_Benefits__c> planBenefitList= new List<AIA_Plan_Benefits__c>();
        Integer x=pw.benefitList.size();
        for(AIA_PCS_BenefitSummary.Benefit benefit:grouper.Benefit){
            AIA_Plan_Benefits__c  benefitObject= new AIA_Plan_Benefits__c();
            benefitObject.Record_Type__c=recordType;
            // benefitObject.Name=benefit.AliasName;
            String bname='';
             system.debug('Hello World1'+benefit);
            if(String.isnotblank(benefit.AliasName)){
                 system.debug('Hello World12');
                bname=benefit.AliasName;
                Integer len=bname.length()<255?bname.length():255;
                bname.substring(0,len);
            }
             system.debug('Hello World13');
            benefitObject.Benefit_Name__c=bname;
            system.debug('Hello World14'+bname);
            benefitObject.Type__c='Benefit';
            benefitObject.IS_ASO_Only__c=benefit.ASOFlag; 
            system.debug('Hello World15'+benefit.ASOFlag);
            AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
            referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
            system.debug('Hello World16'+referenceGrouper);
            benefitObject.Benefit_Group__r=referenceGrouper;
             system.debug('Hello World17'+benefitObject);
            system.debug('Hello World18'+benefitObject.Benefit_Group__r);
            //benefitObject.Benefit_Summary_Comment__c=String.join(benefit.BenefitSummaryComment,',');// this field is not available on plan benefit 
            //T08-Start
           //system.debug('Error occur: '+benefit.CoinsuranceRange.Low);
            if(benefit.CoinsuranceRange !=null){
            if(benefit.CoinsuranceRange.Low !=null)
                benefitObject.Coinsurance_AmountLow__c=benefit.CoinsuranceRange.Low;
            if(benefit.CoinsuranceRange.High !=null)
                benefitObject.Coinsurance_AmountHigh__c=benefit.CoInsuranceRange.High;
            if(benefit.CoinsuranceRange.Increment !=null )
                benefitObject.Coinsurance_AmountIncrement__c=benefit.CoInsuranceRange.Increment;
            if(benefit.CoinsuranceRange.AdditionalIncrements !=null )
                benefitObject.Coinsurance_Amount_AddtionalIncrements__c=benefit.CoInsuranceRange.AdditionalIncrements;
            if(benefit.CoinsuranceRange.InvalidIncrements !=null)
                benefitObject.Coinsurance_Amount_InvalidIncrements__c =benefit.CoInsuranceRange.InvalidIncrements; 
            }    
            //T08-End
            mapCopayRange(benefitObject,benefit.CopayRange);
            if(recordType=='BRF')
                benefitObject.Sequence_Number__c=benefit.BRFSequence;
            if(recordType=='BDD')
                benefitObject.Sequence_Number__c=benefit.BDFSequence;
            if(benefit.IsAppGlobalCoinsurance == true){
                benefitObject.IsAppGlobalCoinsurance__c = true;
            }
            if(benefit.IsAppGlobalCopay == true){
                benefitObject.IsAppGlobalCopay__c =true; 
            }
            if(benefit.IsAppGlobalCoinsurance == null){
                benefitObject.IsAppGlobalCoinsurance__c = false;
            }
            if(benefit.IsAppGlobalCopay == null){
                benefitObject.IsAppGlobalCopay__c =false; 
            } 
            /*******************T10 START******************/   
            benefitObject.PCS_Benefit_Id__c  = benefit.BenefitID;
           /*******************T10 End******************/ 
           /*******************T12 Start******************/   
            if(!String.ISBLANK(benefit.MappingBRFBrnrfitID)){
                benefitObject.MappingBRFBenefitID__c = benefit.MappingBRFBrnrfitID;
            }
            if(!String.ISBLANK(benefit.MandateLockdownInd)){
                benefitObject.MandateLockDownInd__c = benefit.MandateLockdownInd;
            }
           /*******************T12 End******************/  
            
            if(benefit.DavisBenefitString != null){
            benefitObject.Davis_Benefit_Variable__c = benefit.DavisBenefitString;
            }
            
            
            
            benefitObject.ExtID__c=grouperSetup.ExtID__c+'BF_'+recordType+x;
            
            String key=benefit.AliasName+'_'+grouperSetup.Name+'_'+networkName;
            if(isExistingBRFBenefit(key)){
                benefitObject.isExisting_Benefit__c=TRUE;
            }
            
            
            List<AIA_PCS_BenefitSummary.VariationCondition> variationConditionList=benefit.VariationCondition;
            for(AIA_PCS_BenefitSummary.VariationCondition varCondition:variationConditionList){
                //mapMaxRows(benefitObject,varCondition.MaxRows);
                benefitObject.Place_of_Service__c=varCondition.PlaceOfService;
                /*******************T10 START******************/   
                benefitObject.Variation_Condition_ID__c = varCondition.VariationID;
                /*******************T10 End******************/   
                benefitObject.Provider_Type__c=varCondition.ProviderType;
                if(varCondition.MaxRows!=null){
                    for(AIA_PCS_BenefitSummary.MaxRows maxRows:varCondition.MaxRows){
                        AIA_Plan_Limitation__c planLimitation= new AIA_Plan_Limitation__c();
                        mapMaxRowsLimit(benefitObject,planLimitation, maxRows);
                        pw.maxRowList.add(planLimitation);
                        if(maxRows.MandateInd=='Y' || maxRows.MandateInd=='Yes'){
                            AIA_Plan_Limitation__c planLimitMandate= new AIA_Plan_Limitation__c();
                            mapMandate(benefitObject, planLimitMandate, maxRows);
                            pw.mandateList.add(planLimitMandate);
                        }
                        
                    }
                }
                Integer i=1;
                if(varCondition.CopayType!=null){
                    for(AIA_PCS_BenefitSummary.CopayType copayType:varCondition.CopayType){
                        //if(i==1){
                        System.debug('Benefit AliasName--->'+benefit.AliasName);
                        if(benefit.AliasName=='Diagnostic Lab - Outpatient Facility'){
                            System.debug('Copay Values of this benefit ------>'+copayType);
                        }
                        AIA_Plan_Limitation__c planLimitation= new AIA_Plan_Limitation__c();
                        mapTierLimit(benefitObject,planLimitation, copayType);
                        //pw.tierLimitList.add(planLimitation);
                        //  i++;
                        //}
                        AIA_Plan_Copay_Type__c planCopayObject= new AIA_Plan_Copay_Type__c();
                        mapCopayType(benefitObject,planCopayObject,copayType);
                        pw.copayTypeList.add(planCopayObject);
                    }
                }
            }
            planBenefitList.add(benefitObject);
            x++;
        }
        if(planBenefitList.size()>0){
            pw.benefitList.addAll(planBenefitList);
        }
        return planBenefitList;
    }
    
    public void mapCopayRange(AIA_Plan_Benefits__c benefitObject,AIA_PCS_BenefitSummary.CopayRange copayRange){
        if(copayRange.AmountRange!=null){
            benefitObject.Copay_AmountHigh__c =copayRange.AmountRange.High;
            benefitObject.Copay_AmountLow__c =copayRange.AmountRange.Low;
            benefitObject.Copay_AmountRange_InvalidIncrements__c=copayRange.AmountRange.InvalidIncrements;
            benefitObject.Copay_AmountIncrement__c  =copayRange.AmountRange.Increment;
            benefitObject.Copay_AmountRange_AdditionalIncrements__c=copayRange.AmountRange.AdditionalIncrements;
        }
        if(copayRange.PCPCopay!=null){
            benefitObject.Copay_PCPCopay_AdditionalIncrements__c =copayRange.PCPCopay.AdditionalIncrements;
            benefitObject.Copay_PCPCopay_InvalidIncrements__c  =copayRange.PCPCopay.InvalidIncrements;
            benefitObject.Copay_PCPCopay_Amount__c  =copayRange.PCPCopay.Amount;
            benefitObject.Copay_PCPCopay_Increment__c  =copayRange.PCPCopay.Increment;
            benefitObject.Copay_PCPCopay_Low__c  =copayRange.PCPCopay.Low;
            benefitObject.Copay_PCPCopay_High__c  =copayRange.PCPCopay.High;
        }
        if(copayRange.SpecialistCopay!=null){
            benefitObject.Copay_SpecialistCopay_AddIncrements__c =copayRange.SpecialistCopay.AdditionalIncrements;
            benefitObject.Copay_SpecialistCopay_Amount__c  =copayRange.SpecialistCopay.Amount;
            benefitObject.Copay_SpecialistCopay_High__c  =copayRange.SpecialistCopay.High;
            benefitObject.Copay_SpecialistCopay_Increment__c  =copayRange.SpecialistCopay.Increment;
            benefitObject.Copay_SpecialistCopay_InvalidIncrements__c  =copayRange.SpecialistCopay.InvalidIncrements;
            benefitObject.Copay_SpecialistCopay_Low__c =copayRange.SpecialistCopay.Low;
        }
        if(copayRange.PerAdmissionCopay!=null){
            benefitObject.Copay_PerAdmissionCopay_AddtlIncrements__c  =copayRange.PerAdmissionCopay.AdditionalIncrements;
            benefitObject.Copay_PerAdmissionCopay_Amount__c   =copayRange.PerAdmissionCopay.Amount;
            benefitObject.Copay_PerAdmissionCopay_High__c   =copayRange.PerAdmissionCopay.High;
            benefitObject.Copay_PerAdmissionCopay_Increment__c   =copayRange.PerAdmissionCopay.Increment;
            benefitObject.Copay_PerAdmissionCopay_InvalidIncrement__c   =copayRange.PerAdmissionCopay.InvalidIncrements;
            benefitObject.Copay_PerAdmissionCopay_Low__c  =copayRange.PerAdmissionCopay.Low;
        }
    }
    
    /**
    * TO populate concanated string of benefitcomment codes.
    * @param List<AIA_PCS_BenefitSummary.BenefitCommentCodes>.
    * @return String
    **/ 
    public void mapBenefitCommentCodes(AIA_Plan_Copay_Type__c  planCopayType,AIA_Plan_Limitation__c  planLimitation,List<AIA_PCS_BenefitSummary.BenefitCommentCodes> lstBenefitComment){
        if(lstBenefitComment!=null){
            for(AIA_PCS_BenefitSummary.BenefitCommentCodes bfc:lstBenefitComment){
                if(bfc.type == 'Max Value Range' || bfc.type == 'Max Duration Range' || bfc.type == 'Max Value Valid'|| bfc.type == 'Max Duration Valid'){
                    continue;
                }
                AIA_Plan_Benefit_Comment_Codes__c benefitComment=new AIA_Plan_Benefit_Comment_Codes__c(); 
                if(planCopayType!=null){
                    AIA_Plan_Copay_Type__c referencePlanCopayType=new AIA_Plan_Copay_Type__c();
                    referencePlanCopayType.ExtID__c=planCopayType.ExtID__c;
                    benefitComment.Plan_Copay_Type__r=referencePlanCopayType;
                    benefitComment.ExtID__c=planCopayType.ExtID__c+'BCOM_'+recordType+pw.benefitCommentCodeList.size();
                }else if(planLimitation!=null){
                    AIA_Plan_Limitation__c referencePlanLimitation=new AIA_Plan_Limitation__c();
                    referencePlanLimitation.ExtID__c=planLimitation.ExtID__c;
                    benefitComment.Plan_Limitation__r=referencePlanLimitation;
                    benefitComment.ExtID__c=planLimitation.ExtID__c+'BCOM_'+recordType+pw.benefitCommentCodeList.size();
                }
                //benefitComment.Comment__c=bfc.Comment;
                String comment='';
                if(String.isnotblank(bfc.Comment)){
                    comment=bfc.Comment;
                    Integer len=comment.length()<131070?comment.length():131070;
                    comment.substring(0,len);
                }
                benefitComment.Type__c=bfc.Type;
                benefitComment.IsRequired__c=bfc.IsRequired;
                benefitComment.Code__c=bfc.Code;
                benefitComment.Comment__c=Comment;
                benefitComment.RecordType__c=recordType;
                benefitComment.FundingArrangement__c=bfc.FundingArrangement;
                pw.benefitCommentCodeList.add(benefitComment);
            }
        }
    }
    
    
    public void mapCopayType(AIA_Plan_Benefits__c planBenefitObject,AIA_Plan_Copay_Type__c  planCopayType,AIA_PCS_BenefitSummary.CopayType cpayType){
        planCopayType.AliasName__c=cpayType.AliasName;
        if(cpayType.TierType!=null)
            planCopayType.TierType__c=cpayType.TierType;
        if(cpayType.ScheduledAmounts!=null)
            planCopayType.Approximate_Member_Payment_w_Discount__c=cpayType.ScheduledAmounts;
        //T04 changes Start 
        if(cpayType.AllowedAmount!=null)
            planCopayType.Allowed_Amount__c=cpayType.AllowedAmount;
        if(cpayType.DiscountAmount!=null)
            planCopayType.Discount_Amount__c=cpayType.DiscountAmount;
        if(cpayType.DiscountApplies!=null)
            planCopayType.Discount_Applies__c=cpayType.DiscountApplies;    
        //T04 changes End
        
        
        if(cpayType.TierCopayAmount!=null)
            planCopayType.CopayAmount__c=cpayType.TierCopayAmount;
        if(cpayType.MinPayAmount!=null)
            planCopayType.MinPayAmount__c=cpayType.MinPayAmount;
        if(cpayType.MaxPayAmount!=null)
            planCopayType.MaxPayAmount__c=cpayType.MaxPayAmount;
        if(cpayType.IsCovered!=null)
            planCopayType.IsCovered__c=Boolean.valueOf(cpayType.IsCovered)==TRUE?'Yes':'No';
        //T02 changes Start
        if(cpayType.DeductibleApplies!=null){
            if( (cpayType.DeductibleApplies).toUpperCase()=='N/A' || (cpayType.DeductibleApplies).toUpperCase()=='NA')
                planCopayType.DeductibleApplies__c='NA';
            else
                planCopayType.DeductibleApplies__c=cpayType.DeductibleApplies;
        } 
        if(cpayType.TierCoinsuranceAmount!=null ){
            if( (cpayType.TierCoinsuranceAmount).toUpperCase()=='N/A' || (cpayType.TierCoinsuranceAmount).toUpperCase()=='NA')
                planCopayType.CoinsuranceAmount__c='NA';
            else
                planCopayType.CoinsuranceAmount__c=cpayType.TierCoinsuranceAmount;
        }
        //T02 changes End
        
        planCopayType.MandateIndicator__c=cpayType.MandateInd;
        planCopayType.MandateName__c=cpayType.MandateName;
        planCopayType.Jurisdiction__c=cpayType.Jurisdiction;
        AIA_Plan_Benefits__c  referenceBenefit= new AIA_Plan_Benefits__c();
        referenceBenefit.ExtID__c=planBenefitObject.ExtID__c;
        planCopayType.Plan_Benefits__r=referenceBenefit;
        planCopayType.ExtID__c=planBenefitObject.ExtID__c+'CP_'+recordType+pw.copayTypeList.size();
       // mapBenefitCommentCodes(planCopayType, null, cpayType.BenefitCommentCodes);
    }
    
    public void mapTierLimit(AIA_Plan_Benefits__c planBenefitObject,AIA_Plan_Limitation__c planLimitation,AIA_PCS_BenefitSummary.CopayType tierlimitType){
        planLimitation.TierLimitType__c=tierlimitType.TierLimitType;
        planLimitation.TierLimitDurationType__c=tierlimitType.TierLimitDurationType;
        planLimitation.RecordType__c=recordType;
        if(String.isNotBlank(tierlimitType.TierLimitFrom))
            planLimitation.TierLimitFrom__c=Decimal.valueOf(tierlimitType.TierLimitFrom);
        if(String.isNotBlank(tierlimitType.TierLimitTo))
            planlimitation.TierLimitTo__c=Decimal.valueOf(tierlimitType.TierLimitTo);
        if(String.isNotBlank(tierlimitType.TierAgeFrom))
            planlimitation.TierAgeFrom__c=Decimal.valueOf(tierlimitType.TierAgeFrom);
        if(String.isNotBlank(tierlimitType.TierAgeTo))
            planlimitation.TierAgeTo__c=Decimal.valueOf(tierlimitType.TierAgeTo);
        planlimitation.TierAgeType__c=tierlimitType.TierAgeType;
        planlimitation.Type__c='TierLimit';
        
        planLimitation.MandateName__c=tierlimitType.MandateName;
        planLimitation.Jurisdiction__c=tierlimitType.Jurisdiction;
        if(tierlimitType.MandateInd=='Yes' || tierlimitType.MandateInd=='Y'){
            planLimitation.MandateIndicator__c=True;
        }
        
        if(!String.isBlank(tierlimitType.EffDate))
            planLimitation.effective_Date__c = Date.valueOf(tierlimitType.EffDate);
        if(!String.isBlank(tierlimitType.EndDate))
            planLimitation.Term_Date__c = Date.valueOf(tierlimitType.EndDate);
        
        AIA_Plan_Benefits__c  referenceBenefit= new AIA_Plan_Benefits__c();
        referenceBenefit.ExtID__c=planBenefitObject.ExtID__c;
        planlimitation.Plan_Benefits__r=referenceBenefit;
        planLimitation.ExtID__c=planBenefitObject.ExtID__c+'TRL_'+recordType+pw.tierLimitList.size();
        pw.tierLimitList.add(planLimitation);
        mapBenefitCommentCodes(null, planLimitation, tierlimitType.BenefitCommentCodes);
    }
    
    public void mapMaxRowsLimit(AIA_Plan_Benefits__c planBenefitObject,AIA_Plan_Limitation__c planlimitation,AIA_PCS_BenefitSummary.MaxRows maxRows){
        planlimitation.MaxValue__c=maxrows.MaxValue;
        planlimitation.MaxType__c=maxRows.MaxType;
        planLimitation.MaxDuration__c=maxRows.MaxDuration;
        planLimitation.MaxDurationType__c=maxRows.MaxDurationType;
        planLimitation.MaxApply__c=maxRows.MaxApply;
        planLimitation.RecordType__c=recordType;
        if(String.isNotBlank(maxRows.MaxAgeFrom))
            planLimitation.MaxAgeFrom__c=Decimal.valueOf(maxRows.MaxAgeFrom);
        if(String.isNotBlank(maxRows.MaxAgeTo))
            planLimitation.MaxAgeTo__c=Decimal.valueOf(maxRows.MaxAgeTo);
        planLimitation.MaxAgeType__c=maxRows.MaxAgeType;
        planLimitation.Type__c='MaxRow';
        
        planLimitation.MandateName__c=maxRows.MandateName;
        planLimitation.Jurisdiction__c=maxRows.Jurisdiction;
        if(maxRows.MandateInd=='Yes' || maxRows.MandateInd=='Y'){
            planLimitation.MandateIndicator__c=True;
        }
        
        if(!String.isBlank(maxRows.EffDate))
            planLimitation.effective_Date__c = Date.valueOf(maxRows.EffDate);
        if(!String.isBlank(maxRows.EndDate))
            planLimitation.Term_Date__c = Date.valueOf(maxRows.EndDate);
        
        if(maxRows.BenefitCommentCodes!=null && maxRows.BenefitCommentCodes.size()>0 ){
            //planlimitation.MaxRow_Mandate_Description__c=String.join(maxRows.BenefitCommentCodes,',');
       
        for(AIA_PCS_BenefitSummary.BenefitCommentCodes commentcodes: maxrows.BenefitCommentCodes)
        {
            planLimitation.MaxRange_Type__c = commentcodes.type;
            
            if(commentcodes.type == 'Max Value Range'){
                planLimitation.MaxValue_Range__c = commentcodes.comment;
                String[] arrcomment = commentcodes.comment.split('-');                
                String[] arrComment1 = arrcomment[1].split('/'); 
                planLimitation.MaxValue_Low__c = arrcomment[0]; 
                planLimitation.MaxValue_High__c =  arrComment1[0];
                planLimitation.MaxValue_Increment__c =  arrComment1[1];
                planLimitation.MaxValue_Range__c = commentcodes.comment;
                planlimitation.MaxRow_Mandate_Description__c = '';

            }
            if(commentcodes.type == 'Max Duration Range'){
                String[] arrcomment = commentcodes.comment.split('-');                
                String[] arrComment1 = arrcomment[1].split('/'); 
                planLimitation.MaxDuration_Low__c = arrcomment[0]; 
                planLimitation.MaxDuration_High__c =  arrComment1[0];
                planLimitation.MaxDuration_Increment__c =  arrComment1[1];
                planLimitation.MaxDuration_Range__c = commentcodes.comment;
                planlimitation.MaxRow_Mandate_Description__c = '';
            }
            if(commentcodes.type == 'Max Value Valid'){
                planLimitation.MaxValue_Valid_Ranges__c = commentcodes.comment;
                planlimitation.MaxRow_Mandate_Description__c = '';
            }
            if(commentcodes.type == 'Max Duration Valid'){
                planLimitation.MaxDuration_Valid_Ranges__c = commentcodes.comment;
                planlimitation.MaxRow_Mandate_Description__c = '';
            }
        } 
      }   
        
        AIA_Plan_Benefits__c  referenceBenefit= new AIA_Plan_Benefits__c();
        referenceBenefit.ExtID__c=planBenefitObject.ExtID__c;
        planlimitation.Plan_Benefits__r=referenceBenefit;
        planlimitation.ExtID__c=planBenefitObject.ExtID__c+'MXR_'+recordType+pw.maxRowList.size();
        mapBenefitCommentCodes(null, planLimitation, maxRows.BenefitCommentCodes);
    } 
    
    public void mapMandate(AIA_Plan_Benefits__c planBenefitObject,AIA_Plan_Limitation__c planlimitation,AIA_PCS_BenefitSummary.MaxRows mandate){
        planLimitation.MandateName__c=mandate.MandateName;
        planLimitation.Jurisdiction__c=mandate.Jurisdiction;
        planLimitation.MandateIndicator__c=mandate.MandateInd=='Y'?TRUE:FALSE;
        AIA_Plan_Benefits__c  referenceBenefit= new AIA_Plan_Benefits__c();
        referenceBenefit.ExtID__c=planBenefitObject.ExtID__c;
        planlimitation.Plan_Benefits__r=referenceBenefit;
        planlimitation.ExtID__c=planBenefitObject.ExtID__c+'MANDT_'+recordType+pw.maxRowList.size();
        mapBenefitCommentCodes(null, planLimitation, mandate.BenefitCommentCodes);
    }
    
    
    /**
    * TO map JSON data of OutOfPocket,Deductible,DeductibleCarryover,LifetimeMax node to AIA_Plan_Grouper__c object.
    * @param Object : OutOfPocket,Deductible,DeductibleCarryover,LifetimeMax instance.
    * @param AIA_Plan_Grouper__c
    * @return List<AIA_Plan_Benefits__c>
    **/
    public List<AIA_Plan_Benefits__c> mapCostSharePlanBenefit(Object costShareGrouper,AIA_Plan_Grouper__c grouperSetup){
        Map<String,String> nameCustMap = new Map<String,String>();
        for( AIA_PCS_Transaction_Table__c custObj : AIA_PCS_Transaction_Table__c.getAll().values() ) {
            nameCustMap.put(custObj.PCS_Tag__c, custObj.Salesforce_Display_Name__c);
        }
        
        
        List<AIA_Plan_Benefits__c> planBenefitList= new List<AIA_Plan_Benefits__c>();
        if(costShareGrouper!=null && costShareGrouper instanceof AIA_PCS_BenefitSummary.OutOfPocket){
            AIA_PCS_BenefitSummary.OutOfPocket outOfPocket =( AIA_PCS_BenefitSummary.OutOfPocket) costShareGrouper;
            String baseNode= AIA_PCS_BenefitSummary.OutOfPocket.class.getName();
            String baseNodeNameStr;
            if(outOfPocket.Individual!=null){
                AIA_Plan_Benefits__c  individualPlanBenefit= new AIA_Plan_Benefits__c ();
                individualPlanBenefit.Type__c='Cost Share';
                individualPlanBenefit.Record_Type__c=recordType;
                AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
                referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
                individualPlanBenefit.Benefit_Group__r=referenceGrouper;
                String nodeName=AIA_PCS_BenefitSummary.Individual.class.getName();
                baseNodeNameStr = baseNode.split('\\.').get(1)+'_'+nodeName.split('\\.').get(1);
                if( nameCustMap.containsKey(baseNodeNameStr) ){
                    // individualPlanBenefit.Name = nameCustMap.get(baseNodeNameStr);
                    individualPlanBenefit.Benefit_Name__c=nameCustMap.get(baseNodeNameStr);
                }
                
                else{
                    // individualPlanBenefit.Name = baseNodeNameStr;
                    individualPlanBenefit.Benefit_Name__c = baseNodeNameStr;
                }
                
                individualPlanBenefit.Cost_Share_High__c=outOfPocket.Individual.High;
                individualPlanBenefit.Cost_Share_Low__c=outOfPocket.Individual.Low;
                individualPlanBenefit.Cost_Share_Increment__c=outOfPocket.Individual.Increment;
                individualPlanBenefit.Cost_Share_InvalidIncrements__c=outOfPocket.Individual.InvalidIncrements;
                individualPlanBenefit.Cost_Share_AdditionalIncrements__c =outOfPocket.Individual.AdditionalIncrements;
                individualPlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BOI_'+recordType+pw.benefitList.size();
                //if(!String.isBlank(outOfPocket.Individual.Amount))
                individualPlanBenefit.Cost_Share_Default_Amount__c= outOfPocket.Individual.Amount;
                //planBenefitList.add(individualPlanBenefit);
                /** T05 - Save Sequence Number for Cost Share **/
                if(recordType == 'BRF') {
                    individualPlanBenefit.Sequence_Number__c = outOfPocket.Individual.BRFSequence;
                }
                else if(recordType == 'BDD') {
                    individualPlanBenefit.Sequence_Number__c = outOfPocket.Individual.BDFSequence;
                }
                pw.benefitList.add(individualPlanBenefit);
            }
            if(outOfPocket.Family!=null){
                AIA_Plan_Benefits__c  familyPlanBenefit= new AIA_Plan_Benefits__c ();
                familyPlanBenefit.Type__c='Cost Share';
                AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
                referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
                familyPlanBenefit.Benefit_Group__r=referenceGrouper;
                familyPlanBenefit.Record_Type__c=recordType;
                String nodeName=AIA_PCS_BenefitSummary.Family.class.getName();
                //familyPlanBenefit.Name=baseNode.split('\\.').get(1)+'_'+nodeName.split('\\.').get(1);
                //String nodeName=AIA_PCS_BenefitSummary.Individual.class.getName();
                baseNodeNameStr = baseNode.split('\\.').get(1)+'_'+nodeName.split('\\.').get(1);
                if( nameCustMap.containsKey(baseNodeNameStr) ){
                    // individualPlanBenefit.Name = nameCustMap.get(baseNodeNameStr);
                    familyPlanBenefit.Benefit_Name__c=nameCustMap.get(baseNodeNameStr);
                }
                
                else{
                    // individualPlanBenefit.Name = baseNodeNameStr;
                    familyPlanBenefit.Benefit_Name__c = baseNodeNameStr;
                }
                familyPlanBenefit.Cost_Share_High__c=outOfPocket.Family.High;
                familyPlanBenefit.Cost_Share_Low__c=outOfPocket.Family.Low;
                familyPlanBenefit.Cost_Share_Increment__c=outOfPocket.Family.Increment;
                familyPlanBenefit.Cost_Share_InvalidIncrements__c=outOfPocket.Family.InvalidIncrements;
                familyPlanBenefit.Cost_Share_AdditionalIncrements__c =outOfPocket.Family.AdditionalIncrements;
                familyPlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BOF_'+recordType+pw.benefitList.size();
                //  if(!String.isBlank(outOfPocket.Family.Amount))
                familyPlanBenefit.Cost_Share_Default_Amount__c= outOfPocket.Family.Amount;
                //planBenefitList.add(familyPlanBenefit);
                /** T05 - Save Sequence Number for Cost Share **/
                if(recordType == 'BRF') {
                    familyPlanBenefit.Sequence_Number__c = outOfPocket.Family.BRFSequence;
                }
                else if(recordType == 'BDD') {
                    familyPlanBenefit.Sequence_Number__c = outOfPocket.Family.BDFSequence;
                }
                pw.benefitList.add(familyPlanBenefit);
            }
            
            if(outOfPocket.Single!=null){
                AIA_Plan_Benefits__c  singlePlanBenefit= new AIA_Plan_Benefits__c ();
                singlePlanBenefit.Type__c='Cost Share';
                singlePlanBenefit.Record_Type__c=recordType;
                AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
                referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
                singlePlanBenefit.Benefit_Group__r=referenceGrouper;
                String nodeName=AIA_PCS_BenefitSummary.Single.class.getName();
                //singlePlanBenefit.Name=baseNode.split('\\.').get(1)+'_'+nodeName.split('\\.').get(1);
                // String nodeName=AIA_PCS_BenefitSummary.Individual.class.getName();
                baseNodeNameStr = baseNode.split('\\.').get(1)+'_'+nodeName.split('\\.').get(1);
                if( nameCustMap.containsKey(baseNodeNameStr) ){
                    // individualPlanBenefit.Name = nameCustMap.get(baseNodeNameStr);
                    singlePlanBenefit.Benefit_Name__c=nameCustMap.get(baseNodeNameStr);
                }
                
                else{
                    // individualPlanBenefit.Name = baseNodeNameStr;
                    singlePlanBenefit.Benefit_Name__c = baseNodeNameStr;
                }
                singlePlanBenefit.Cost_Share_High__c=outOfPocket.Single.High;
                singlePlanBenefit.Cost_Share_Low__c=outOfPocket.Single.Low;
                singlePlanBenefit.Cost_Share_Increment__c=outOfPocket.Single.Increment;
                singlePlanBenefit.Cost_Share_InvalidIncrements__c=outOfPocket.Single.InvalidIncrements;
                singlePlanBenefit.Cost_Share_AdditionalIncrements__c =outOfPocket.Single.AdditionalIncrements;
                singlePlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BOS_'+recordType+pw.benefitList.size();
                // if(!String.isBlank(outOfPocket.Single.Amount))
                singlePlanBenefit.Cost_Share_Default_Amount__c= outOfPocket.Single.Amount;
                //planBenefitList.add(singlePlanBenefit);
                /** T05 - Save Sequence Number for Cost Share **/
                if(recordType == 'BRF') {
                    singlePlanBenefit.Sequence_Number__c = outOfPocket.Single.BRFSequence;
                }
                else if(recordType == 'BDD') {
                    singlePlanBenefit.Sequence_Number__c = outOfPocket.Single.BDFSequence;
                }
                pw.benefitList.add(singlePlanBenefit);
            }  
            
        }else if (costShareGrouper!=null && costShareGrouper instanceof AIA_PCS_BenefitSummary.Deductible){
            AIA_PCS_BenefitSummary.Deductible deductible =( AIA_PCS_BenefitSummary.Deductible) costShareGrouper;
            String baseNode= AIA_PCS_BenefitSummary.Deductible.class.getName();
            if(deductible.Individual!=null){
                AIA_Plan_Benefits__c  dedIndividualPlanBenefit= new AIA_Plan_Benefits__c ();
                dedIndividualPlanBenefit.Type__c='Cost Share';
                dedIndividualPlanBenefit.Record_Type__c=recordType;
                AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
                referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
                dedIndividualPlanBenefit.Benefit_Group__r=referenceGrouper;
                //String nodeName=AIA_PCS_BenefitSummary.Individual.class.getName();
                //dedIndividualPlanBenefit.Name=baseNode.split('\\.').get(1)+'_'+nodeName.split('\\.').get(1);
                
                String nodeName=AIA_PCS_BenefitSummary.Individual.class.getName();
                String baseNodeNameStr = baseNode.split('\\.').get(1)+'_'+nodeName.split('\\.').get(1);
                if( nameCustMap.containsKey(baseNodeNameStr) ){
                    // individualPlanBenefit.Name = nameCustMap.get(baseNodeNameStr);
                    dedIndividualPlanBenefit.Benefit_Name__c=nameCustMap.get(baseNodeNameStr);
                }
                
                else{
                    // individualPlanBenefit.Name = baseNodeNameStr;
                    dedIndividualPlanBenefit.Benefit_Name__c = baseNodeNameStr;
                }
                dedIndividualPlanBenefit.Cost_Share_High__c=deductible.Individual.High;
                dedIndividualPlanBenefit.Cost_Share_Low__c=deductible.Individual.Low;
                dedIndividualPlanBenefit.Cost_Share_Increment__c=deductible.Individual.Increment;
                dedIndividualPlanBenefit.Cost_Share_InvalidIncrements__c=deductible.Individual.InvalidIncrements;
                dedIndividualPlanBenefit.Cost_Share_AdditionalIncrements__c =deductible.Individual.AdditionalIncrements;
                dedIndividualPlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BDI_'+recordType+pw.benefitList.size();
                // if(!String.isBlank(deductible.Individual.Amount))
                dedIndividualPlanBenefit.Cost_Share_Default_Amount__c= deductible.Individual.Amount;
                // planBenefitList.add(dedIndividualPlanBenefit);
                /** Save Cost Share Sequence Number - T05 **/ 
                if(recordType == 'BRF') {
                    dedIndividualPlanBenefit.Sequence_Number__c = deductible.Individual.BRFSequence;
                }
                else if(recordType == 'BDD') {
                    dedIndividualPlanBenefit.Sequence_Number__c = deductible.Individual.BDFSequence;
                }
                
                pw.benefitList.add(dedIndividualPlanBenefit);
            }
            if(deductible.Family!=null){
                AIA_Plan_Benefits__c  deductibleFamilyPlanBenefit= new AIA_Plan_Benefits__c ();
                deductibleFamilyPlanBenefit.Type__c='Cost Share';
                deductibleFamilyPlanBenefit.Record_Type__c=recordType;
                AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
                referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
                deductibleFamilyPlanBenefit.Benefit_Group__r=referenceGrouper;
                String nodeName=AIA_PCS_BenefitSummary.Family.class.getName();
                // deductibleFamilyPlanBenefit.Name=baseNode.split('\\.').get(1)+'_'+nodeName.split('\\.').get(1);
                // String nodeName=AIA_PCS_BenefitSummary.Individual.class.getName();
                String baseNodeNameStr = baseNode.split('\\.').get(1)+'_'+nodeName.split('\\.').get(1);
                if( nameCustMap.containsKey(baseNodeNameStr) ){
                    // individualPlanBenefit.Name = nameCustMap.get(baseNodeNameStr);
                    deductibleFamilyPlanBenefit.Benefit_Name__c=nameCustMap.get(baseNodeNameStr);
                }
                else{
                    // individualPlanBenefit.Name = baseNodeNameStr;
                    deductibleFamilyPlanBenefit.Benefit_Name__c = baseNodeNameStr;
                }
                deductibleFamilyPlanBenefit.Cost_Share_High__c=deductible.Family.High;
                deductibleFamilyPlanBenefit.Cost_Share_Low__c=deductible.Family.Low;
                deductibleFamilyPlanBenefit.Cost_Share_Increment__c=deductible.Family.Increment;
                deductibleFamilyPlanBenefit.Cost_Share_InvalidIncrements__c=deductible.Family.InvalidIncrements;
                deductibleFamilyPlanBenefit.Cost_Share_AdditionalIncrements__c =deductible.Family.AdditionalIncrements;
                deductibleFamilyPlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BDI_'+recordType+pw.benefitList.size();
                // if(!String.isBlank(deductible.Family.Amount))
                deductibleFamilyPlanBenefit.Cost_Share_Default_Amount__c= deductible.Family.Amount;
                //planBenefitList.add(deductibleFamilyPlanBenefit);
                /** Save Cost Share Sequence Number - T05 **/ 
                if(recordType == 'BRF') {
                    deductibleFamilyPlanBenefit.Sequence_Number__c = deductible.Family.BRFSequence;
                }
                else if(recordType == 'BDD') {
                    deductibleFamilyPlanBenefit.Sequence_Number__c = deductible.Family.BDFSequence;
                }
                pw.benefitList.add(deductibleFamilyPlanBenefit);
            }
            
            if(deductible.Single!=null){
                AIA_Plan_Benefits__c  deductibleSinglePlanBenefit= new AIA_Plan_Benefits__c ();
                deductibleSinglePlanBenefit.Type__c='Cost Share';
                deductibleSinglePlanBenefit.Record_Type__c=recordType;
                AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
                referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
                deductibleSinglePlanBenefit.Benefit_Group__r=referenceGrouper;
                String nodeName =AIA_PCS_BenefitSummary.Single.class.getName();
                deductibleSinglePlanBenefit.Benefit_Name__c=baseNode.split('\\.').get(1)+'_'+nodeName.split('\\.').get(1);
                String baseNodeNameStr = baseNode.split('\\.').get(1)+'_'+nodeName.split('\\.').get(1);
                if( nameCustMap.containsKey(baseNodeNameStr) ){
                    // individualPlanBenefit.Name = nameCustMap.get(baseNodeNameStr);
                    deductibleSinglePlanBenefit.Benefit_Name__c=nameCustMap.get(baseNodeNameStr);
                }
                else{
                    // individualPlanBenefit.Name = baseNodeNameStr;
                    deductibleSinglePlanBenefit.Benefit_Name__c = baseNodeNameStr;
                }
                deductibleSinglePlanBenefit.Cost_Share_High__c=deductible.Single.High;
                deductibleSinglePlanBenefit.Cost_Share_Low__c=deductible.Single.Low;
                deductibleSinglePlanBenefit.Cost_Share_Increment__c=deductible.Single.Increment;
                deductibleSinglePlanBenefit.Cost_Share_InvalidIncrements__c=deductible.Single.InvalidIncrements;
                deductibleSinglePlanBenefit.Cost_Share_AdditionalIncrements__c =deductible.Single.AdditionalIncrements;
                deductibleSinglePlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BDS_'+recordType+pw.benefitList.size();
                //if(!String.isBlank(deductible.Single.Amount))
                deductibleSinglePlanBenefit.Cost_Share_Default_Amount__c= deductible.Single.Amount;
                //planBenefitList.add(deductibleSinglePlanBenefit);
                /** Save Cost Share Sequence Number - T05 **/ 
                if(recordType == 'BRF') {
                    deductibleSinglePlanBenefit.Sequence_Number__c = deductible.Single.BRFSequence;
                }
                else if(recordType == 'BDD') {
                    deductibleSinglePlanBenefit.Sequence_Number__c = deductible.Single.BDFSequence;
                }
                pw.benefitList.add(deductibleSinglePlanBenefit);
            }
            
        }else if(costShareGrouper!=null && costShareGrouper instanceof AIA_PCS_BenefitSummary.DeductibleCarryover){
            AIA_PCS_BenefitSummary.DeductibleCarryover deductibleCarryOver =( AIA_PCS_BenefitSummary.DeductibleCarryover) costShareGrouper;
            AIA_Plan_Benefits__c  deductibleCarryOverPlanBenefit= new AIA_Plan_Benefits__c ();
            deductibleCarryOverPlanBenefit.Type__c='Cost Share';
            deductibleCarryOverPlanBenefit.Record_Type__c=recordType;
            deductibleCarryOverPlanBenefit.Benefit_Name__c='DeductibleCarryOver';
            String baseNodeNameStr = 'DeductibleCarryOver';
            if( nameCustMap.containsKey(baseNodeNameStr) ){
                // individualPlanBenefit.Name = nameCustMap.get(baseNodeNameStr);
                deductibleCarryOverPlanBenefit.Benefit_Name__c=nameCustMap.get(baseNodeNameStr);
            }
            
            else{
                // individualPlanBenefit.Name = baseNodeNameStr;
                deductibleCarryOverPlanBenefit.Benefit_Name__c = baseNodeNameStr;
            }
            deductibleCarryOverPlanBenefit.Cost_Share_High__c=deductibleCarryOver.High;
            deductibleCarryOverPlanBenefit.Cost_Share_Low__c=deductibleCarryOver.Low;
            deductibleCarryOverPlanBenefit.Cost_Share_Increment__c=deductibleCarryOver.Increment;
            deductibleCarryOverPlanBenefit.Cost_Share_PeriodValue__c=deductibleCarryOver.PeriodValue;
            deductibleCarryOverPlanBenefit.Cost_Share_TimeValue__c=deductibleCarryOver.TimeValue;
            deductibleCarryOverPlanBenefit.Cost_Share_InvalidIncrements__c=deductibleCarryOver.InvalidIncrements;
            deductibleCarryOverPlanBenefit.Cost_Share_AdditionalIncrements__c =deductibleCarryOver.AdditionalIncrements;
            AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
            referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
            deductibleCarryOverPlanBenefit.Benefit_Group__r=referenceGrouper;
            deductibleCarryOverPlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BDCO_'+recordType+pw.benefitList.size();
            //planBenefitList.add(deductibleCarryOverPlanBenefit);
            pw.benefitList.add(deductibleCarryOverPlanBenefit);  
        }
        else if(costShareGrouper!=null && costShareGrouper instanceof AIA_PCS_BenefitSummary.LifetimeMax){
            AIA_PCS_BenefitSummary.LifetimeMax lifeTimeMax=(AIA_PCS_BenefitSummary.LifetimeMax)costShareGrouper;
            if(lifeTimeMax.Single!=null){
                String chidNode=AIA_PCS_BenefitSummary.Single.class.getName();
                AIA_Plan_Benefits__c  lifeTimeMaxSinglePlanBenefit= new AIA_Plan_Benefits__c ();
                lifeTimeMaxSinglePlanBenefit.Type__c='Cost Share';
                lifeTimeMaxSinglePlanBenefit.Record_Type__c=recordType;
                AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
                referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
                lifeTimeMaxSinglePlanBenefit.Benefit_Group__r=referenceGrouper;
                String nodeName=AIA_PCS_BenefitSummary.LifetimeMax.class.getName();
                lifeTimeMaxSinglePlanBenefit.Benefit_Name__c=nodeName.split('\\.').get(1)+'_'+chidNode.split('\\.').get(1);
                String baseNodeNameStr = nodeName.split('\\.').get(1)+'_'+chidNode.split('\\.').get(1);
                if( nameCustMap.containsKey(baseNodeNameStr) ){
                    // individualPlanBenefit.Name = nameCustMap.get(baseNodeNameStr);
                    lifeTimeMaxSinglePlanBenefit.Benefit_Name__c=nameCustMap.get(baseNodeNameStr);
                }
                
                else{
                    // individualPlanBenefit.Name = baseNodeNameStr;
                    lifeTimeMaxSinglePlanBenefit.Benefit_Name__c = baseNodeNameStr;
                }
                lifeTimeMaxSinglePlanBenefit.Cost_Share_High__c=lifeTimeMax.Single.High;
                lifeTimeMaxSinglePlanBenefit.Cost_Share_Low__c=lifeTimeMax.Single.Low;
                lifeTimeMaxSinglePlanBenefit.Cost_Share_Increment__c=lifeTimeMax.Single.Increment;
                lifeTimeMaxSinglePlanBenefit.Cost_Share_InvalidIncrements__c=lifeTimeMax.Single.InvalidIncrements;
                lifeTimeMaxSinglePlanBenefit.Cost_Share_AdditionalIncrements__c =lifeTimeMax.Single.AdditionalIncrements;
                lifeTimeMaxSinglePlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BLS_'+recordType+pw.benefitList.size();
                // if(!String.isBlank(lifeTimeMax.Single.Amount))
                lifeTimeMaxSinglePlanBenefit.Cost_Share_Default_Amount__c=lifeTimeMax.Single.Amount;
                //planBenefitList.add(lifeTimeMaxSinglePlanBenefit);
                /** Save Cost Share Sequence Number - T05 **/ 
                if(recordType == 'BRF') {
                    lifeTimeMaxSinglePlanBenefit.Sequence_Number__c = lifeTimeMax.Single.BRFSequence;
                }
                else if(recordType == 'BDD') {
                    lifeTimeMaxSinglePlanBenefit.Sequence_Number__c = lifeTimeMax.Single.BDFSequence;
                }
                pw.benefitList.add(lifeTimeMaxSinglePlanBenefit);
            }
        }
        /** T06 - Code to save the cost share Annual Max - Start**/
        else if(costShareGrouper!=null && costShareGrouper instanceof AIA_PCS_BenefitSummary.AnnualMax){
            AIA_PCS_BenefitSummary.AnnualMax annMax=(AIA_PCS_BenefitSummary.AnnualMax)costShareGrouper;
            if(annMax.Single!=null){
                String chidNode=AIA_PCS_BenefitSummary.Single.class.getName();
                AIA_Plan_Benefits__c  annMaxSinglePlanBenefit= new AIA_Plan_Benefits__c ();
                annMaxSinglePlanBenefit.Type__c='Cost Share';
                annMaxSinglePlanBenefit.Record_Type__c=recordType;
                AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
                referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
                annMaxSinglePlanBenefit.Benefit_Group__r=referenceGrouper;
                String nodeName=AIA_PCS_BenefitSummary.AnnualMax.class.getName();
                annMaxSinglePlanBenefit.Benefit_Name__c=nodeName.split('\\.').get(1)+'_'+chidNode.split('\\.').get(1);
                String baseNodeNameStr = nodeName.split('\\.').get(1)+'_'+chidNode.split('\\.').get(1);
                //T09 - Start
                if(productCategory == 'Dental'){
                    annMaxSinglePlanBenefit.Benefit_Name__c = nameCustMap.get('AnnualMax-Dental');
                }
                else {
                    annMaxSinglePlanBenefit.Benefit_Name__c = nameCustMap.get('AnnualMax');
                }
                
               // else if( nameCustMap.containsKey(baseNodeNameStr) ){
               //     annMaxSinglePlanBenefit.Benefit_Name__c=nameCustMap.get(baseNodeNameStr);
               //  }                
               //T09 - End
                
                annMaxSinglePlanBenefit.Cost_Share_High__c=annMax.Single.High;
                annMaxSinglePlanBenefit.Cost_Share_Low__c=annMax.Single.Low;
                annMaxSinglePlanBenefit.Cost_Share_Increment__c=annMax.Single.Increment;
                annMaxSinglePlanBenefit.Cost_Share_InvalidIncrements__c=annMax.Single.InvalidIncrements;
                annMaxSinglePlanBenefit.Cost_Share_AdditionalIncrements__c =annMax.Single.AdditionalIncrements;
                annMaxSinglePlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BZS_'+recordType+pw.benefitList.size();
                annMaxSinglePlanBenefit.Cost_Share_Default_Amount__c=annMax.Single.Amount;
                /** Save Cost Share Sequence Number - T05 **/ 
                if(recordType == 'BRF') {
                    annMaxSinglePlanBenefit.Sequence_Number__c = annMax.Single.BRFSequence;
                }
                else if(recordType == 'BDD') {
                    annMaxSinglePlanBenefit.Sequence_Number__c = annMax.Single.BDFSequence;
                }
                pw.benefitList.add(annMaxSinglePlanBenefit);
            }
        }
        /** T06 - Code to save the cost share Annual Max - End**/
        else if(costShareGrouper!=null && costShareGrouper instanceof AIA_PCS_BenefitSummary.Copay){
            System.debug('Inside Copay---');
            AIA_PCS_BenefitSummary.Copay Copay=(AIA_PCS_BenefitSummary.Copay)costShareGrouper;
            if(Copay.PCPCopay!=null){
                String chidNode=AIA_PCS_BenefitSummary.PCPCopay.class.getName();
                AIA_Plan_Benefits__c  copayPCPCopayPlanBenefit= new AIA_Plan_Benefits__c ();
                copayPCPCopayPlanBenefit.Type__c='Cost Share';
                copayPCPCopayPlanBenefit.Record_Type__c=recordType;
                AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
                referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
                copayPCPCopayPlanBenefit.Benefit_Group__r=referenceGrouper;
                String nodeName=AIA_PCS_BenefitSummary.Copay.class.getName();
                copayPCPCopayPlanBenefit.Benefit_Name__c=nodeName.split('\\.').get(1)+'_'+chidNode.split('\\.').get(1);
                String baseNodeNameStr = nodeName.split('\\.').get(1)+'_'+chidNode.split('\\.').get(1);
                if( nameCustMap.containsKey(baseNodeNameStr) ){
                    // individualPlanBenefit.Name = nameCustMap.get(baseNodeNameStr);
                    copayPCPCopayPlanBenefit.Benefit_Name__c=nameCustMap.get(baseNodeNameStr);
                }
                
                else{
                    // individualPlanBenefit.Name = baseNodeNameStr;
                    copayPCPCopayPlanBenefit.Benefit_Name__c = baseNodeNameStr;
                }
                copayPCPCopayPlanBenefit.Cost_Share_High__c=Copay.PCPCopay.High;
                copayPCPCopayPlanBenefit.Cost_Share_Low__c=Copay.PCPCopay.Low;
                copayPCPCopayPlanBenefit.Cost_Share_Increment__c=Copay.PCPCopay.Increment;
                copayPCPCopayPlanBenefit.Cost_Share_InvalidIncrements__c=Copay.PCPCopay.InvalidIncrements;
                copayPCPCopayPlanBenefit.Cost_Share_AdditionalIncrements__c =Copay.PCPCopay.AdditionalIncrements;
                copayPCPCopayPlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BCPC_'+recordType+pw.benefitList.size();
                // if(!String.isBlank(lifeTimeMax.Single.Amount))
                copayPCPCopayPlanBenefit.Cost_Share_Default_Amount__c=Copay.PCPCopay.Amount;
                //planBenefitList.add(lifeTimeMaxSinglePlanBenefit);
                /** Save Cost Share Sequence Number - T05 **/ 
                if(recordType == 'BRF') {
                    copayPCPCopayPlanBenefit.Sequence_Number__c = Copay.PCPCopay.BRFSequence;
                }
                else if(recordType == 'BDD') {
                    copayPCPCopayPlanBenefit.Sequence_Number__c = Copay.PCPCopay.BDFSequence;
                }
                pw.benefitList.add(copayPCPCopayPlanBenefit);
            }
            if(Copay.SpecialistCopay!=null){
                String chidNode=AIA_PCS_BenefitSummary.SpecialistCopay.class.getName();
                AIA_Plan_Benefits__c  SpecialistCopayPCPCopayPlanBenefit= new AIA_Plan_Benefits__c ();
                SpecialistCopayPCPCopayPlanBenefit.Type__c='Cost Share';
                SpecialistCopayPCPCopayPlanBenefit.Record_Type__c=recordType;
                AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
                referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
                SpecialistCopayPCPCopayPlanBenefit.Benefit_Group__r=referenceGrouper;
                String nodeName=AIA_PCS_BenefitSummary.Copay.class.getName();
                SpecialistCopayPCPCopayPlanBenefit.Benefit_Name__c=nodeName.split('\\.').get(1)+'_'+chidNode.split('\\.').get(1);
                String baseNodeNameStr = nodeName.split('\\.').get(1)+'_'+chidNode.split('\\.').get(1);
                if( nameCustMap.containsKey(baseNodeNameStr) ){
                    // individualPlanBenefit.Name = nameCustMap.get(baseNodeNameStr);
                    SpecialistCopayPCPCopayPlanBenefit.Benefit_Name__c=nameCustMap.get(baseNodeNameStr);
                }
                
                else{
                    // individualPlanBenefit.Name = baseNodeNameStr;
                    SpecialistCopayPCPCopayPlanBenefit.Benefit_Name__c = baseNodeNameStr;
                }
                SpecialistCopayPCPCopayPlanBenefit.Cost_Share_High__c=Copay.SpecialistCopay.High;
                SpecialistCopayPCPCopayPlanBenefit.Cost_Share_Low__c=Copay.SpecialistCopay.Low;
                SpecialistCopayPCPCopayPlanBenefit.Cost_Share_Increment__c=Copay.SpecialistCopay.Increment;
                SpecialistCopayPCPCopayPlanBenefit.Cost_Share_InvalidIncrements__c=Copay.SpecialistCopay.InvalidIncrements;
                SpecialistCopayPCPCopayPlanBenefit.Cost_Share_AdditionalIncrements__c =Copay.SpecialistCopay.AdditionalIncrements;
                SpecialistCopayPCPCopayPlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BSCPC_'+recordType+pw.benefitList.size();
                // if(!String.isBlank(lifeTimeMax.Single.Amount))
                SpecialistCopayPCPCopayPlanBenefit.Cost_Share_Default_Amount__c=Copay.SpecialistCopay.Amount;
                //planBenefitList.add(lifeTimeMaxSinglePlanBenefit);
                /** Save Cost Share Sequence Number - T05 **/ 
                if(recordType == 'BRF') {
                    SpecialistCopayPCPCopayPlanBenefit.Sequence_Number__c = Copay.SpecialistCopay.BRFSequence;
                }
                else if(recordType == 'BDD') {
                    SpecialistCopayPCPCopayPlanBenefit.Sequence_Number__c = Copay.SpecialistCopay.BDFSequence;
                }
                pw.benefitList.add(SpecialistCopayPCPCopayPlanBenefit);
            }
            if(Copay.PerAdmissionCopay !=null){
                String chidNode=AIA_PCS_BenefitSummary.PerAdmissionCopay.class.getName();
                AIA_Plan_Benefits__c  perAdmissionCopayPlanBenefit= new AIA_Plan_Benefits__c ();
                perAdmissionCopayPlanBenefit.Type__c='Cost Share';
                perAdmissionCopayPlanBenefit.Record_Type__c=recordType;
                AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
                referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
                perAdmissionCopayPlanBenefit.Benefit_Group__r=referenceGrouper;
                String nodeName=AIA_PCS_BenefitSummary.Copay.class.getName();
                perAdmissionCopayPlanBenefit.Benefit_Name__c=nodeName.split('\\.').get(1)+'_'+chidNode.split('\\.').get(1);
                String baseNodeNameStr = nodeName.split('\\.').get(1)+'_'+chidNode.split('\\.').get(1);
                if(nameCustMap.containsKey(baseNodeNameStr) )
                    perAdmissionCopayPlanBenefit.Benefit_Name__c = nameCustMap.get(baseNodeNameStr);
                else
                    perAdmissionCopayPlanBenefit.Benefit_Name__c = baseNodeNameStr;
                perAdmissionCopayPlanBenefit.Cost_Share_High__c=Copay.PerAdmissionCopay.High;
                perAdmissionCopayPlanBenefit.Cost_Share_Low__c=Copay.PerAdmissionCopay.Low;
                perAdmissionCopayPlanBenefit.Cost_Share_Increment__c=Copay.PerAdmissionCopay.Increment;
                perAdmissionCopayPlanBenefit.Cost_Share_InvalidIncrements__c=Copay.PerAdmissionCopay.InvalidIncrements;
                perAdmissionCopayPlanBenefit.Cost_Share_AdditionalIncrements__c =Copay.PerAdmissionCopay.AdditionalIncrements;
                perAdmissionCopayPlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BPAC_'+recordType+pw.benefitList.size();
                // if(!String.isBlank(lifeTimeMax.Single.Amount))
                perAdmissionCopayPlanBenefit.Cost_Share_Default_Amount__c=Copay.PerAdmissionCopay.Amount;
                //planBenefitList.add(lifeTimeMaxSinglePlanBenefit);
                /** Save Cost Share Sequence Number - T05 **/ 
                if(recordType == 'BRF') {
                    perAdmissionCopayPlanBenefit.Sequence_Number__c = Copay.PerAdmissionCopay.BRFSequence;
                }
                else if(recordType == 'BDD') {
                    perAdmissionCopayPlanBenefit.Sequence_Number__c = Copay.PerAdmissionCopay.BDFSequence;
                }
                pw.benefitList.add(perAdmissionCopayPlanBenefit);
            }
        }else if(costShareGrouper!=null && costShareGrouper instanceof AIA_PCS_BenefitSummary.CoinsuranceRange){
            System.debug('Inside CoinsuranceRange---');
            AIA_PCS_BenefitSummary.CoinsuranceRange cRange=(AIA_PCS_BenefitSummary.CoinsuranceRange)costShareGrouper;
            AIA_Plan_Benefits__c  coinsuranceRangePlanBenefit= new AIA_Plan_Benefits__c ();
            coinsuranceRangePlanBenefit.Type__c='Cost Share';
            coinsuranceRangePlanBenefit.Record_Type__c=recordType;
            //Added by Asif Oct-31 14:14 Start
            String nodeName=AIA_PCS_BenefitSummary.CoinsuranceRange.class.getName();          
            String baseNodeNameStrCR = nodeName.split('\\.').get(1);
            if( nameCustMap.containsKey(baseNodeNameStrCR) ){              
                coinsuranceRangePlanBenefit.Benefit_Name__c=nameCustMap.get(baseNodeNameStrCR);              
            }            
            else{          
                coinsuranceRangePlanBenefit.Benefit_Name__c = baseNodeNameStrCR;              
            }          
            //Added by Asif Oct-31 14:14 End
            coinsuranceRangePlanBenefit.Cost_Share_High__c=cRange.High;
            coinsuranceRangePlanBenefit.Cost_Share_Low__c=cRange.Low;
            coinsuranceRangePlanBenefit.Cost_Share_Increment__c=cRange.Increment;
            coinsuranceRangePlanBenefit.Cost_Share_InvalidIncrements__c=cRange.InvalidIncrements;
            coinsuranceRangePlanBenefit.Cost_Share_AdditionalIncrements__c =cRange.AdditionalIncrements;
            AIA_Plan_Grouper__c referenceGrouper=new AIA_Plan_Grouper__c();
            referenceGrouper.ExtID__c=grouperSetup.ExtID__c;
            coinsuranceRangePlanBenefit.Benefit_Group__r=referenceGrouper;
            coinsuranceRangePlanBenefit.ExtID__c=grouperSetup.ExtID__c+'BCOIR_'+recordType+pw.benefitList.size();
            coinsuranceRangePlanBenefit.Cost_Share_Default_Amount__c=cRange.Amount;
            //planBenefitList.add(deductibleCarryOverPlanBenefit);
            /** Save Cost Share Sequence Number - T05 **/ 
            if(recordType == 'BRF') {
                coinsuranceRangePlanBenefit.Sequence_Number__c = cRange.BRFSequence;
            }
            else if(recordType == 'BDD') {
                coinsuranceRangePlanBenefit.Sequence_Number__c = cRange.BDFSequence;
            }
            pw.benefitList.add(coinsuranceRangePlanBenefit);  
            
        }
        
        if(planBenefitList.size()>0){
            //pw.benefitList.addAll(planBenefitList);
        }       
        return planBenefitList; 
        
    }
    
    /**
    * Method called to map & save JSON data of Network Node to AIA_Plan_RxMandate__c.
    * @param AIA_PCS_BenefitSummary .
    * @param AIA_Plan__c
    * @return List<AIA_Plan_RxMandate__c> : list of AIA_Plan_RxMandate__c. 
    **/ 
     public RecordType RXRecordTypeId;   
     public List<AIA_Plan_RxMandate__c> mapRxMandate(AIA_PCS_BenefitSummary apb,AIA_Plan__c aiaPlan){
        System.debug('Starting ---mapRxMandate');
        RXRecordTypeId = [select Id, Name, sObjectType from RecordType where sObjectType = 'AIA_Plan_RxMandate__c' and developername = 'Plan_Rx_Mandate'];  
        List<AIA_Plan_RxMandate__c>  RxManList= new List<AIA_Plan_RxMandate__c>();
        Integer i=pw.RxMandateList.size()+1;
        for(AIA_PCS_BenefitSummary.RxMandate aiapcsrx:apb.RxMandate){
            AIA_Plan_RxMandate__c PlanRx=new AIA_Plan_RxMandate__c();
            AIA_Plan__c planReference= new AIA_Plan__c(Plan_Id__c=aiaPlan.Plan_Id__c);
            PlanRx.Plan__r=planReference;
            
            // RxMandate Field Mapping
            PlanRx.recordtypeId = RXRecordTypeId.id;
            PlanRx.Mandate_Name__c=aiapcsrx.MandateName;    
            PlanRx.Mandate_Apply__c=aiapcsrx.MandateApply;
            PlanRx.Mandate_Description__c=aiapcsrx.MandateDescription;
            PlanRx.Mandate_Jurisdiction__c=aiapcsrx.MandateJurisdiction;
            PlanRx.ExtID__c=aiaPlan.Plan_Id__c+'Rx'+i;
            
            if(!String.isBlank(aiapcsrx.MandateEffectiveDate))
            PlanRx.Mandate_Effective_Date__c=Date.valueOf(aiapcsrx.MandateEffectiveDate);
            if(!String.isBlank(aiapcsrx.MandateTermDate))
            PlanRx.Mandate_Term_Date__c=Date.valueOf(aiapcsrx.MandateTermDate);
        
            RxManList.add(PlanRx);
            
            
            i++;
        }
        if(RxManList.size()>0){
            pw.RxMandateList.addAll(RxManList);
        }
        System.debug('Starting ---mapRxMandate');
        return RxManList;
    }

 /**
    * Method called to map & save JSON data of Network Node to AIA_Plan_RxMandate__c.
    * @param AIA_PCS_BenefitSummary .
    * @param AIA_Plan__c
    * @return List<NetworkRulesList> : list of AIA_Plan_RxMandate__c. 
    **/ 
     public RecordType NRRecordTypeId;   
     public List<AIA_Plan_RxMandate__c> mapNetworkRules(AIA_PCS_BenefitSummary apb,AIA_Plan__c aiaPlan){
        System.debug('Starting ---mapNetworkRules');
        NRRecordTypeId = [select Id, Name, sObjectType from RecordType where sObjectType = 'AIA_Plan_RxMandate__c' and developername = 'Network_Rules'];  
        List<AIA_Plan_RxMandate__c>  NRList= new List<AIA_Plan_RxMandate__c>();
        Integer i=pw.NetworkRulesList.size()+1;
        for(AIA_PCS_BenefitSummary.NetworkRules aiapcsnr:apb.NetworkRules){
            AIA_Plan_RxMandate__c PlanNR=new AIA_Plan_RxMandate__c();
            AIA_Plan__c planReference= new AIA_Plan__c(Plan_Id__c=aiaPlan.Plan_Id__c);
            PlanNR.Plan__r=planReference;
            
            // RxMandate Field Mapping
            PlanNR.recordtypeId= NRRecordTypeId.id;
            PlanNR.Network_Rules_AliasName__c =aiapcsnr.AliasName;    
            PlanNR.ExtID__c=aiaPlan.Plan_Id__c+'NR'+i;
            
        
            NRList.add(PlanNR);
            
            
            i++;
        }
        if(NRList.size()>0){
            pw.NetworkRulesList.addAll(NRList);
        }
        System.debug('Starting ---mapRxMandate');
        return NRList;
    }    
        
    /**
    * Wrapper clas to hold populated data from  AIA_PCS_BenefitSummary object.
    **/
    public class PlanWrapper{
        public AIA_Plan__c aiaPlan{get;set;}
        public List<AIA_Plan_Network__c> networkList{get;set;}
        public List<AIA_Plan_Grouper__c> grouperList{get;set;}
        public List<AIA_Plan_Benefits__c> benefitList{get;set;}
        public List<AIA_Plan_Limitation__c> tierLimitList{get;set;}
        public List<AIA_Plan_Limitation__c> maxRowList{get;set;}
        public List<AIA_Plan_Limitation__c> mandateList{get;set;}
        public List<AIA_Plan_Copay_Type__c> copayTypeList{get;set;}
        public List<AIA_Plan_Benefit_Comment_Codes__c> benefitCommentCodeList{get;set;}
        public List<AIA_Plan_RxMandate__c> RxMandateList{get;set;}
        public List<AIA_Plan_RxMandate__c> NetworkRulesList{get;set;}
        public PlanWrapper(){
            networkList=new List<AIA_Plan_Network__c>();
            grouperList= new List<AIA_Plan_Grouper__c>();
            benefitList= new List<AIA_Plan_Benefits__c>(); 
            tierLimitList=new List<AIA_Plan_Limitation__c>();
            maxRowList=new List<AIA_Plan_Limitation__c>();
            copayTypeList=new List<AIA_Plan_Copay_Type__c>();
            benefitCommentCodeList=new List<AIA_Plan_Benefit_Comment_Codes__c>();
            mandateList=new List<AIA_Plan_Limitation__c>(); 
            RxMandateList= new List<AIA_Plan_RxMandate__c>();
            NetworkRulesList = new List<AIA_Plan_RxMandate__c>();
        }
    }
    
    
}