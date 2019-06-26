/*NOT IN USE. As per new enhancements in the functionality not using this class. 11/4/2016
/*=========================================================================================
 * Date     : 08/08/2016
 * Developer    : Goutham Rapolu
 * Purpose      : Benefit Summary TransportObject Class for Run Time objects
 *                
 *               
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 08/08/2016|  Goutham Rapolu    | Initial Version                                         
 *           |                 | 
 *===========+============+================================================================
 */

public class AIA_PCS_BenefitSummary_TO {
  /*  public static AIA_PCS_BenefitSummary_JSON_TO ben_SumTO {get;set;}
    public static string planId;
    public static final string PLAN_IN_NETWORK = 'InNetwork';
    public static final string PLAN_OUT_NETWORK = 'OutNetwork';
    public static final string COST_SHARE_GROUP = 'Cost Share Group';
    //map to store PlanId with Plan record
    private static map<Id,AIA_Plan__c> mapPlanIdToPlan = new map<Id,AIA_Plan__c>();
    //map to store Plan NetworkId with Plan Network record
    private static map<Id,AIA_Plan_Network__c> mapPlanNwIdToPlanNw = new map<Id,AIA_Plan_Network__c>();
    //map to store Plan Network Name with Plan Network record Id
    private static map<string,string> mapPlanNwNameToPlanNwId = new map<String,String>();
    //map to store Plan Group Name with Plan Network record Id
    private static map<string,string> mapPlanGrpNameToPlanGrpId = new map<String,String>();
    //map to store PlanId with all related Plan Network records
    private static map<string,List<AIA_Plan_Network__c>> mapPlanIdToPlanNwList = new map<string,List<AIA_Plan_Network__c>>();
    //map to store Plan group Id with Plan Group record
    private static map<Id,AIA_Plan_Grouper__c> mapPlanGrpIdToPlanGrp = new map<Id,AIA_Plan_Grouper__c>();
    //map to store Plan Network Id with all related Plan Group records
    private static map<string,List<AIA_Plan_Grouper__c>> mapPlanNwIdToPlanGrpList = new map<string,List<AIA_Plan_Grouper__c>>();
    //map to store Plan Benefit Id with Plan Benefit record
    private static map<Id,AIA_Plan_Benefits__c> mapPlanBnftIdToPlanBnft = new map<Id,AIA_Plan_Benefits__c>();
    //map to store Plan Group Id with all related Plan Benefit records
    private static map<string,List<AIA_Plan_Benefits__c>> mapPlanGrpIdToPlanBnftList = new map<string,List<AIA_Plan_Benefits__c>>();
    
    public static AIA_PCS_BenefitSummary bnftSum = new AIA_PCS_BenefitSummary();
    static list<AIA_PCS_BenefitSummary.Grouper> bsGrouper = new list<AIA_PCS_BenefitSummary.Grouper>();
    
    */
    //This method will control the execution flow of other methods and will be called from 
    //AIA_ProposedProd_SummaryController class
   /* public static AIA_PCS_BenefitSummary_JSON_TO genBenefitSumData(){
        system.debug('PLANID in TO:: '+planId);

     
        //get plan info first
        getPlanInfo();
        //get plan Network second
        getPlanNwInfo();
        //get Plan Grouper third
        getPlanGroupInfo();
        //get Plan Benefits fourth
        getPlanBenefitInfo();
        //ben_sum.Network = new list<AIA_PCS_BenefitSummary.Network>();
        //ben_sum.Network.Grouper = new list<AIA_PCS_BenefitSummary.Grouper>();
        //ben_sum.Network.Grouper.Benefit = new list<AIA_PCS_BenefitSummary.Benefit>();
        generateCostShare();
        return ben_SumTO;
    }
    
    
    
     public static AIA_PCS_BenefitSummary_JSON_TO genBenefitSumDesignData(){
        system.debug('PLANID in Design TO:: '+planId);
        //get plan info first
        getPlanInfo();
        //get plan Network second
        getPlanNwInfo();
        //get Plan Grouper third
        getPlanGroupDesignInfo();
        //get Plan Benefits fourth
        getPlanBenefitDesignInfo();
        //ben_sum.Network = new list<AIA_PCS_BenefitSummary.Network>();
        //ben_sum.Network.Grouper = new list<AIA_PCS_BenefitSummary.Grouper>();
        //ben_sum.Network.Grouper.Benefit = new list<AIA_PCS_BenefitSummary.Benefit>();
        generateCostShare();
        return ben_SumTO;
    }
    
    
    
    public static AIA_PCS_BenefitSummary getBS_Info(){
        bnftSum.Network = new list<AIA_PCS_BenefitSummary.Network>();
        list<AIA_PCS_BenefitSummary.Grouper> grouperList = new list<AIA_PCS_BenefitSummary.Grouper>();
        for(AIA_Plan_Network__c planNw : mapPlanNwIdToPlanNw.values()){
            //if(planNw.Name == 'InNetwork'){
            AIA_PCS_BenefitSummary.Network nw = new AIA_PCS_BenefitSummary.Network();
            nw.AliasName = planNw.Name;
            nw.CostShareRanges = new AIA_PCS_BenefitSummary.CostShareRanges();
            nw.CostShareRanges.OutOfPocket = new AIA_PCS_BenefitSummary.OutOfPocket();
            nw.CostShareRanges.Deductible  = new AIA_PCS_BenefitSummary.Deductible();
            nw.CostShareRanges.DeductibleCarryover = new AIA_PCS_BenefitSummary.DeductibleCarryover();
            nw.CostShareRanges.LifetimeMax = new AIA_PCS_BenefitSummary.LifetimeMax();
            nw.Grouper = new list<AIA_PCS_BenefitSummary.Grouper>();
            for(AIA_Plan_Grouper__c grper : mapPlanNwIdToPlanGrpList.get(planNw.Id)){
                AIA_PCS_BenefitSummary.Grouper grp = new AIA_PCS_BenefitSummary.Grouper();
                grp.AliasName = grper.Name;
                grp.Benefit = new list<AIA_PCS_BenefitSummary.Benefit>();
                for(AIA_Plan_Benefits__c benefit : mapPlanGrpIdToPlanBnftList.get(grper.Id)){
                    AIA_PCS_BenefitSummary.Benefit bnft = new AIA_PCS_BenefitSummary.Benefit();
                    bnft.AliasName = benefit.Name;
                    if(grper.Name == 'OutOfPocket'){
                        setCostShareRangesOutOfPocket(nw,benefit);
                    }
                    if(grper.Name == 'Deductible'){
                       setCostShareRangesDeductible(nw,benefit);
                    }
                    if(grper.Name == 'DeductibleCarryover'){
                        setCostShareRangesDeductibleCarry(nw,benefit);
                    }
                    if(grper.Name == 'LifetimeMax'){
                        setCostShareRangesLifetime(nw,benefit);
                    }
                    
                    grp.Benefit.add(bnft);
                    system.debug('grp:: '+grp);
                }
                nw.Grouper.add(grp);
            }
            bnftSum.Network.add(nw); 
            //}
            system.debug('bnftsum: '+bnftSum);
        }
        return bnftSum; 
    }
    
   private static void setCostShareRangesOutOfPocket(AIA_PCS_BenefitSummary.Network nw, AIA_Plan_Benefits__c benefit){
        if(benefit.Name.contains('Individual')){
            nw.CostShareRanges.OutOfPocket.Individual = new AIA_PCS_BenefitSummary.Individual();
            nw.CostShareRanges.OutOfPocket.Individual.High = benefit.Cost_Share_High__c != NULL ? benefit.Cost_Share_High__c : '0';
            nw.CostShareRanges.OutOfPocket.Individual.Low = benefit.Cost_Share_Low__c != NULL ? benefit.Cost_Share_Low__c : '0';
            nw.CostShareRanges.OutOfPocket.Individual.Increment = benefit.Cost_Share_Increment__c != NULL ? benefit.Cost_Share_Increment__c : '0'; 
            nw.CostShareRanges.OutOfPocket.Individual.Amount = benefit.Cost_Share_Default_Amount__c != NULL ? benefit.Cost_Share_Default_Amount__c : '0';
        }
        if(benefit.Name.contains('Family')){
            nw.CostShareRanges.OutOfPocket.Family = new AIA_PCS_BenefitSummary.Family();
            nw.CostShareRanges.OutOfPocket.Family.High = benefit.Cost_Share_High__c != NULL ? benefit.Cost_Share_High__c : '0';
            nw.CostShareRanges.OutOfPocket.Family.Low = benefit.Cost_Share_Low__c != NULL ? benefit.Cost_Share_Low__c: '0';
            nw.CostShareRanges.OutOfPocket.Family.Increment = benefit.Cost_Share_Increment__c != NULL ? benefit.Cost_Share_Increment__c : '0';
            nw.CostShareRanges.OutOfPocket.Family.Amount = benefit.Cost_Share_Default_Amount__c != NULL ? benefit.Cost_Share_Default_Amount__c : '0';
        }
        if(benefit.Name.contains('Single')){
            nw.CostShareRanges.OutOfPocket.Single = new AIA_PCS_BenefitSummary.Single();
            nw.CostShareRanges.OutOfPocket.Single.High = benefit.Cost_Share_High__c != NULL ? benefit.Cost_Share_High__c : '0';
            nw.CostShareRanges.OutOfPocket.Single.Low = benefit.Cost_Share_Low__c != NULL ? benefit.Cost_Share_Low__c : '0';
            nw.CostShareRanges.OutOfPocket.Single.Increment = benefit.Cost_Share_Increment__c != NULL ? benefit.Cost_Share_Increment__c : '0';
            nw.CostShareRanges.OutOfPocket.Single.Amount = benefit.Cost_Share_Default_Amount__c != NULL ? benefit.Cost_Share_Default_Amount__c : '0';
        }
    }
    
    private static void setCostShareRangesDeductible(AIA_PCS_BenefitSummary.Network nw, AIA_Plan_Benefits__c benefit){
        if(benefit.Name.contains('Individual')){
            nw.CostShareRanges.Deductible.Individual = new AIA_PCS_BenefitSummary.Individual();
            nw.CostShareRanges.Deductible.Individual.High = benefit.Cost_Share_High__c != NULL ? benefit.Cost_Share_High__c : '0';
            nw.CostShareRanges.Deductible.Individual.Low = benefit.Cost_Share_Low__c != NULL ? benefit.Cost_Share_Low__c : '0';
            nw.CostShareRanges.Deductible.Individual.Increment = benefit.Cost_Share_Increment__c != NULL ? benefit.Cost_Share_Increment__c : '0';
            nw.CostShareRanges.Deductible.Individual.Amount = benefit.Cost_Share_Default_Amount__c != NULL ? benefit.Cost_Share_Default_Amount__c: '0';
        }
        if(benefit.Name.contains('Family')){
            nw.CostShareRanges.Deductible.Family = new AIA_PCS_BenefitSummary.Family();
            nw.CostShareRanges.Deductible.Family.High = benefit.Cost_Share_High__c != NULL ? benefit.Cost_Share_High__c : '0';
            nw.CostShareRanges.Deductible.Family.Low = benefit.Cost_Share_Low__c != NULL ? benefit.Cost_Share_Low__c : '0';
            nw.CostShareRanges.Deductible.Family.Increment = benefit.Cost_Share_Increment__c != NULL ?benefit.Cost_Share_Increment__c : '0';
            nw.CostShareRanges.Deductible.Family.Amount = benefit.Cost_Share_Default_Amount__c != NULL ?benefit.Cost_Share_Default_Amount__c : '0';
        }
        if(benefit.Name.contains('Single')){
            nw.CostShareRanges.Deductible.Single = new AIA_PCS_BenefitSummary.Single();
            nw.CostShareRanges.Deductible.Single.High = benefit.Cost_Share_High__c != NULL ? benefit.Cost_Share_High__c : '0';
            nw.CostShareRanges.Deductible.Single.Low = benefit.Cost_Share_Low__c != NULL ? benefit.Cost_Share_Low__c : '0';
            nw.CostShareRanges.Deductible.Single.Increment = benefit.Cost_Share_Increment__c != NULL ? benefit.Cost_Share_Increment__c: '0';
            nw.CostShareRanges.Deductible.Single.Amount = benefit.Cost_Share_Default_Amount__c != NULL ? benefit.Cost_Share_Default_Amount__c : '0';
        }
    }

  private static void setCostShareRangesDeductibleCarry(AIA_PCS_BenefitSummary.Network nw, AIA_Plan_Benefits__c benefit){
        nw.CostShareRanges.DeductibleCarryover.High = benefit.Cost_Share_High__c != NULL ? benefit.Cost_Share_High__c : '0';
        nw.CostShareRanges.DeductibleCarryover.Low = benefit.Cost_Share_Low__c != NULL ? benefit.Cost_Share_Low__c : '0';
        nw.CostShareRanges.DeductibleCarryover.Increment = benefit.Cost_Share_Increment__c != NULL ? benefit.Cost_Share_Increment__c : '0';
        nw.CostShareRanges.DeductibleCarryover.PeriodValue = benefit.Cost_Share_PeriodValue__c != NULL ? benefit.Cost_Share_PeriodValue__c: '0';
        nw.CostShareRanges.DeductibleCarryover.TimeValue = benefit.Cost_Share_TimeValue__c != NULL ? benefit.Cost_Share_TimeValue__c : '0';
     }

  private static void setCostShareRangesLifetime(AIA_PCS_BenefitSummary.Network nw, AIA_Plan_Benefits__c benefit){
        nw.CostShareRanges.LifetimeMax.Single  = new AIA_PCS_BenefitSummary.Single();
        nw.CostShareRanges.LifetimeMax.Single.High = benefit.Cost_Share_High__c != NULL ? benefit.Cost_Share_High__c : '0';
        nw.CostShareRanges.LifetimeMax.Single.Low = benefit.Cost_Share_Low__c != NULL ? benefit.Cost_Share_Low__c : '0';
        nw.CostShareRanges.LifetimeMax.Single.Increment = benefit.Cost_Share_Increment__c != NULL ? benefit.Cost_Share_Increment__c : '0';
        nw.CostShareRanges.LifetimeMax.Single.Amount = benefit.Cost_Share_Default_Amount__c != NULL ? string.valueOf(benefit.Cost_Share_Default_Amount__c) : '0';
     }


    
    private static void generateCostShare(){
        ben_SumTO = new AIA_PCS_BenefitSummary_JSON_TO();
        ben_SumTO.mapPlanGrpIdToPlanBnftList = mapPlanGrpIdToPlanBnftList;
        ben_SumTO.mapPlanGrpIdToPlanGrp = mapPlanGrpIdToPlanGrp;
        ben_SumTO.mapPlanNwIdToPlanGrpList = mapPlanNwIdToPlanGrpList;
        ben_SumTO.mapPlanNwIdToPlanNw = mapPlanNwIdToPlanNw;
        /*  if(mapPlanNwIdToPlanNw != NULL && mapPlanNwIdToPlanNw.size() > 0){
//ben_sum.Network = new list<AIA_PCS_BenefitSummary.Network>();
if(mapPlanNwNameToPlanNwId != NULL && mapPlanNwNameToPlanNwId.size() > 0){
if(mapPlanNwNameToPlanNwId.containsKey(PLAN_IN_NETWORK))
ben_SumTO.planBenefitList = getGrpBenft(PLAN_IN_NETWORK,COST_SHARE_GROUP);
if(mapPlanNwNameToPlanNwId.containsKey(PLAN_OUT_NETWORK))
ben_SumTO.planBenefitList2 = getGrpBenft(PLAN_OUT_NETWORK,COST_SHARE_GROUP);

}

//for(AIA_Plan_Network__c planNw : mapPlanNwIdToPlanNw.values()){
//AIA_PCS_BenefitSummary.Network  benSmNw = new AIA_PCS_BenefitSummary.Network();
//benSmNw.AliasName = planNw.Name;
//benSmNw.CostShareRanges = new AIA_PCS_BenefitSummary.CostShareRanges();

//}    
}
    }
    
    public static list<AIA_Plan_Benefits__c> getGrpBenft(string nwType, string grpType){
        list<AIA_Plan_Benefits__c> planBenefitList = new list<AIA_Plan_Benefits__c>();
        AIA_Plan_Network__c planInNw =  mapPlanNwIdToPlanNw.get(mapPlanNwNameToPlanNwId.get(nwType));   
        if(mapPlanNwIdToPlanGrpList != NULL && mapPlanNwIdToPlanGrpList.size() > 0){
            list<AIA_Plan_Grouper__c> grouperList = new list<AIA_Plan_Grouper__c>();
            if(planInNw != NULL && mapPlanNwIdToPlanGrpList.containsKey(planInNw.Id)){
                grouperList = mapPlanNwIdToPlanGrpList.get(planInNw.Id);
                AIA_Plan_Grouper__c costShareGrp = new AIA_Plan_Grouper__c();
                for(AIA_Plan_Grouper__c grp : grouperList){
                    if(grp.Type__c == grpType){
                        costShareGrp = grp;
                        break;
                    }    
                }//for loop ends
                if(mapPlanGrpIdToPlanBnftList != NULL && mapPlanGrpIdToPlanBnftList.size() > 0 && costShareGrp != NULL && mapPlanGrpIdToPlanBnftList.containsKey(costShareGrp.Id)){
                    planBenefitList = mapPlanGrpIdToPlanBnftList.get(costShareGrp.Id);
                }
            }
        }
        return planBenefitList;
    }
    //Get Plan record in a map
    public static map<Id,AIA_Plan__c> getPlanInfo(){
        system.debug('Get Plan Info');
        mapPlanIdToPlan = new map<Id,AIA_Plan__c>();
        for(AIA_Plan__c plan : (list<AIA_Plan__c>)getQueryResults('AIA_Plan__c',new set<Id>{PlanId}, 'Id')){
            mapPlanIdToPlan.put(plan.Id, plan);    
        }
        return mapPlanIdToPlan;
    }
    
    //get plan network info
    public static void getPlanNwInfo(){
        //mapPlanNwIdToPlanNw = new map<Id,AIA_Plan_Network__c>([Select Id,ExtID__c,Plan__c from AIA_Plan_Network__c where Plan__c =:planId ]);
        for(AIA_Plan_Network__c planNw : (list<AIA_Plan_Network__c>)getQueryResults('AIA_Plan_Network__c',new set<Id>{PlanId}, 'Plan__c')){
            mapPlanNwIdToPlanNw.put(planNw.Id, planNw); 
            mapPlanNwNameToPlanNwId.put(planNw.Name.trim(), planNw.Id);   
        }
        if(mapPlanNwIdToPlanNw != NULL && mapPlanNwIdToPlanNw.size() > 0){
            for(AIA_Plan_Network__c planNw : mapPlanNwIdToPlanNw.values()){
                if(mapPlanIdToPlanNwList.containsKey(planNw.Plan__c))
                    mapPlanIdToPlanNwList.get(planNw.Plan__c).add(planNw);
                else
                    mapPlanIdToPlanNwList.put(planNw.Plan__c, new list<AIA_Plan_Network__c>{planNw});
            }   
        }
    }
    
    //get plan group info
    public static void getPlanGroupInfo(){
        //mapPlanGrpIdToPlanGrp = new map<Id,AIA_Plan_Grouper__c>([select Id,ExtID__c,Plan_Network__c,Type__c from AIA_Plan_Grouper__c]);
        // where Plan_Network__c =: mapPlanIdToPlanNwList]);
        if(mapPlanNwIdToPlanNw != NULL && mapPlanNwIdToPlanNw.size() >0){
            for(AIA_Plan_Grouper__c planGrp : (list<AIA_Plan_Grouper__c>)getQueryResults('AIA_Plan_Grouper__c',mapPlanNwIdToPlanNw.keySet(), 'Plan_Network__c')){
                mapPlanGrpIdToPlanGrp.put(planGrp.Id, planGrp);
                mapPlanGrpNameToPlanGrpId.put(planGrp.Name, planGrp.Id);
            }
        }
        if(mapPlanGrpIdToPlanGrp != NULL && mapPlanGrpIdToPlanGrp.size() > 0){
            for(AIA_Plan_Grouper__c planGroup : mapPlanGrpIdToPlanGrp.values()){
                if(mapPlanNwIdToPlanGrpList.containsKey(planGroup.Plan_Network__c))
                    mapPlanNwIdToPlanGrpList.get(planGroup.Plan_Network__c).add(planGroup);
                else
                    mapPlanNwIdToPlanGrpList.put(planGroup.Plan_Network__c, new list<AIA_Plan_Grouper__c>{planGroup});
            }   
        }
    }
    
    
    public static void getPlanGroupDesignInfo(){
        //mapPlanGrpIdToPlanGrp = new map<Id,AIA_Plan_Grouper__c>([select Id,ExtID__c,Plan_Network__c,Type__c from AIA_Plan_Grouper__c]);
        // where Plan_Network__c =: mapPlanIdToPlanNwList]);
        if(mapPlanNwIdToPlanNw != NULL && mapPlanNwIdToPlanNw.size() >0){
            for(AIA_Plan_Grouper__c planGrp : (list<AIA_Plan_Grouper__c>)getQueryResults('AIA_Plan_Grouper__c',mapPlanNwIdToPlanNw.keySet(), ' Record_Type__c=\'BDD\' and Plan_Network__c')){
                mapPlanGrpIdToPlanGrp.put(planGrp.Id, planGrp);
                mapPlanGrpNameToPlanGrpId.put(planGrp.Name, planGrp.Id);
            }
        }
        if(mapPlanGrpIdToPlanGrp != NULL && mapPlanGrpIdToPlanGrp.size() > 0){
            for(AIA_Plan_Grouper__c planGroup : mapPlanGrpIdToPlanGrp.values()){
                if(mapPlanNwIdToPlanGrpList.containsKey(planGroup.Plan_Network__c))
                    mapPlanNwIdToPlanGrpList.get(planGroup.Plan_Network__c).add(planGroup);
                else
                    mapPlanNwIdToPlanGrpList.put(planGroup.Plan_Network__c, new list<AIA_Plan_Grouper__c>{planGroup});
            }   
        }
    }
    
     public static void getPlanBenefitDesignInfo(){
        //mapPlanBnftIdToPlanBnft = new map<Id,AIA_Plan_Benefits__c>([select Id,Benefit__c,Benefit_Group__c,Copay_AmountLow__c,Copay_AmountHigh__c from AIA_Plan_Benefits__c]);
        //where Benefit_Group__c =: mapPlanNwIdToPlanGrpList]);
        if(mapPlanGrpIdToPlanGrp != NULL && mapPlanGrpIdToPlanGrp.size() >0){
            for(AIA_Plan_Benefits__c planBnft : (list<AIA_Plan_Benefits__c>)getQueryResults('AIA_Plan_Benefits__c',mapPlanGrpIdToPlanGrp.keySet(), ' Record_Type__c=\'BDD\' Benefit_Group__c')){
                mapPlanBnftIdToPlanBnft.put(planBnft.Id, planBnft);    
            }
        }
        if(mapPlanBnftIdToPlanBnft != NULL && mapPlanBnftIdToPlanBnft.size() > 0){
            for(AIA_Plan_Benefits__c planBenefits : mapPlanBnftIdToPlanBnft.values()){
                if(mapPlanGrpIdToPlanBnftList.containsKey(planBenefits.Benefit_Group__c))
                    mapPlanGrpIdToPlanBnftList.get(planBenefits.Benefit_Group__c).add(planBenefits);
                else
                    mapPlanGrpIdToPlanBnftList.put(planBenefits.Benefit_Group__c, new list<AIA_Plan_Benefits__c>{planBenefits});
            }
            
            for(string plnGrpId : mapPlanGrpIdToPlanBnftList.keySet()){
                if(mapPlanGrpIdToPlanBnftList.get(plnGrpId).size() == 0){
                    mapPlanGrpIdToPlanBnftList.remove(plnGrpId);    
                }   
            }
            
        }
        
    }
    
    
    //get plan benefit info
    public static void getPlanBenefitInfo(){
        //mapPlanBnftIdToPlanBnft = new map<Id,AIA_Plan_Benefits__c>([select Id,Benefit__c,Benefit_Group__c,Copay_AmountLow__c,Copay_AmountHigh__c from AIA_Plan_Benefits__c]);
        //where Benefit_Group__c =: mapPlanNwIdToPlanGrpList]);
        if(mapPlanGrpIdToPlanGrp != NULL && mapPlanGrpIdToPlanGrp.size() >0){
            for(AIA_Plan_Benefits__c planBnft : (list<AIA_Plan_Benefits__c>)getQueryResults('AIA_Plan_Benefits__c',mapPlanGrpIdToPlanGrp.keySet(), 'Benefit_Group__c')){
                mapPlanBnftIdToPlanBnft.put(planBnft.Id, planBnft);    
            }
        }
        if(mapPlanBnftIdToPlanBnft != NULL && mapPlanBnftIdToPlanBnft.size() > 0){
            for(AIA_Plan_Benefits__c planBenefits : mapPlanBnftIdToPlanBnft.values()){
                if(mapPlanGrpIdToPlanBnftList.containsKey(planBenefits.Benefit_Group__c))
                    mapPlanGrpIdToPlanBnftList.get(planBenefits.Benefit_Group__c).add(planBenefits);
                else
                    mapPlanGrpIdToPlanBnftList.put(planBenefits.Benefit_Group__c, new list<AIA_Plan_Benefits__c>{planBenefits});
            }
            
            for(string plnGrpId : mapPlanGrpIdToPlanBnftList.keySet()){
                if(mapPlanGrpIdToPlanBnftList.get(plnGrpId).size() == 0){
                    mapPlanGrpIdToPlanBnftList.remove(plnGrpId);    
                }   
            }
            
        }
        
    }
    
    //variable to store object name
    private static String objType;
    //list to store list of fields accessible on an object
    private static List<String> accessibleFields;
    
    /*
    *   @param1: string - sobject API name 
    *   @param2: set<Id> - set of Ids used to filter data in query
    *   @param3: string - field name to be used in where condition of query
    *   @return: list<sObject> - list of records
    */
   /* public static list<sObject> getQueryResults(string objName, set<Id> IdSet, string whereClause){
        sObject sObj = Schema.getGlobalDescribe().get(objName).newSObject(); 
        setObjectType(sObj);
        discoverAccessibleFields(sObj);
        list<sObject> results = queryDB(IdSet,whereClause);
        return results;
    }
    
    
    // The sObject type as a string
    public static String getObjectType() {
        return objType;
    }
    //sets the value of "objType" variable
    public static String setObjectType(sObject newObj) {
        objType = newObj.getSObjectType().getDescribe().getName();
        return objType;
    }
    
    // List of accessible fields on the sObject
    public static List<String> getAccessibleFields() {
        return accessibleFields;
    }
    
    //checks which fields are accessible for an object and adds them to a list
    private static void discoverAccessibleFields(sObject newObj) {
        accessibleFields = new List<String>();
        Map<String, Schema.SobjectField> fields = newObj.getSObjectType().getDescribe().fields.getMap();
        for (String s : fields.keySet()) {
            if ((s != 'Name') && (fields.get(s).getDescribe().isAccessible())) {
                accessibleFields.add(s);
            }
        }
    }
    
    /*  
    *   Method to query data from DB. It will use list of fields, object name & filter condition at run time
    *   to generate a query string. The generated string is used to query database.
    *   @param1: set<Id> - set of Ids which will be used to filter records in query
    *   @param2: string - Id field on which filter has to be applied
    */
  /* private static list<sObject> queryDB(set<Id> IdSet, string whereClause) {
        String theQuery = 'SELECT Name, ' + joinList(getAccessibleFields(), ', ') + 
            ' FROM ' + getObjectType() + 
            ' WHERE '+ whereClause +' IN :IdSet';
        system.debug('theQuery - AIA_Plan__c'+theQuery);
        return(Database.query(theQuery));       
    }
    
    // Join an Apex List of fields into a SELECT fields list string
    private static String joinList(List<String> theList, String separator) {
        
        if (theList == null)   { return null; }
        if (separator == null) { separator = ''; }
        
        String joined = '';
        Boolean firstItem = true;
        for (String item : theList) {
            if(null != item) {
                if(firstItem){ firstItem = false; }
                else { joined += separator; }
                joined += item;
            }
        }
        return joined;
    }*/
    
}