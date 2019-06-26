/*=================================================================================================================
 * Date         : 02/22/2017
 * Developer    : Sree Harsha
 * Purpose      : AIA_BD_DeepCloneHelper to Clone Benefit Design and all the selected Benefit Design Products (BDP) and related AIA Documents
 *                    Selected BD Products will be cloned along with Grouper > Benefit > Limitations/CommentCode. 
 *                    BDP clone will clone User Defined/Customized values from Source BDP and other values from Setup Plan.
 *                    applicable for Cost Share, Benefit, CommentCode.
 *=================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 * 03/08/2017 | Sree Harsha |     | Initial Version                                         
 * 
 *  
 *===========+============+========================================================================================
 */

public without sharing class AIA_BD_DeepCloneHelper {
// initializing variables
public transient Set<String> CopayIDs=new Set<String>();
public Map<String, CopayTypeWrapper> copayBenMap = new Map<string, CopayTypeWrapper>();
public Map<String,Set<String>> benLimitsAllMap = new  Map<String,Set<String>>(); 
public Set<String> PlanLimitIDs=new Set<String>();
public Set<ID> pgroupersID= new Set<ID>();
public Set<ID> benefitIdSet= new Set<ID>();
public Map<String,List<Limitations__c>> ParentBenLimitationMan = new   Map<String,List<Limitations__c>>();
public Map<String,List<Limitations__c>> ParentBenLimitationLimit = new   Map<String,List<Limitations__c>>();
public Map<String,string> costShareOldValMap=new map <String,string>();
public Map<String,AIA_Plan_Benefits__c> mapIDTobenefit = new Map<String,AIA_Plan_Benefits__c>(); 
public Map<String,AIA_Plan_Benefits__c> maplst = new Map<String,AIA_Plan_Benefits__c>();
public List<AIA_Benefit_Design_Product__c> bdProductList{get;set;}
public AIA_Benefit_Design_Product__c bdp;
//public string BDPJurisdiction;
public boolean selected;
public Map<String,AIA_Benefit_Design_Product__c > mapbenefitNameToBDPID = new Map<String,AIA_Benefit_Design_Product__c >();
public String JFromBDP;
/**
* @Author: Sree Harsha 
* @This Method is called from AIA_BD_DeepClone_Final and it is used to crete Grouper, benefit
* @param -  Void
* @Output - 
*/
public void getCopaysFromPlan(string planid,string Rtype,AIA_Benefit_Design_Product__c bdp,AIA_Benefit_Design__c BD){
    Set<string> setInNetworkBenifitIds = new Set<String>();
    Set<string> setOutNetworkBenifitIds = new Set<String>();
    List<AIA_Plan_Copay_Type__c> copTypeList= new  List<AIA_Plan_Copay_Type__c>();
    List<AIA_Plan_Copay_Type__c> copTypeList2= new  List<AIA_Plan_Copay_Type__c>();
    
    CopayIDs= new Set<String>();
    copayBenMap = new Map<string, CopayTypeWrapper>();
    string jurisdictionFrmBDP = bdp.Jurisdiction__c;
    system.debug('======planid====='+planid);
    system.debug('======BD====='+BD);
    string bdpid = BD.id;
    List<AIA_Plan_Grouper__c> grprListToClr = [Select id, Name, Sequence_Number__c,Record_Type__c, Plan_Network__c,Type__c, Plan_Network__r.Name 
                                               From AIA_Plan_Grouper__c Where PlanId__c=:planid AND Type__c = 'Benefit Group' 
                                                   AND Record_Type__c =:Rtype Order By Sequence_Number__c,Plan_Network__r.Name]; 
    system.debug('================inside getGroupersFromPlan  ========='+grprListToClr.size());
    for( AIA_Plan_Grouper__c groupObj : grprListToClr ) {           
        pgroupersID.add(groupObj.id);
       
    }
    system.debug('======pgroupersID====='+pgroupersID);
    List<AIA_Plan_Benefits__c>  benifitObjlist= [Select id,Parent_Benefit_Name__c, Benefit_Name__c,Benefit_Group__r.Sequence_Number__c,Benefit_Group__r.Name,Record_Type__c, Name, Sequence_Number__c ,Coinsurance_DefaultAmount__c , 
                                                     Benefit_Group__c, Benefit_Group__r.Plan_Network__c,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c, Benefit_Group__r.Plan_Network__r.Name , IS_ASO_Only__c,Cost_Share_Type__c
                                                     from AIA_Plan_Benefits__c 
                                                     Where Plan__c = :planid AND Record_Type__c =:Rtype and Type__c='Benefit' and  Benefit_Group__c in :pgroupersID 
                                                     Order By  Benefit_Group__r.Sequence_Number__c,Sequence_Number__c ];
     system.debug('======benifitObjlist====='+benifitObjlist);
     for( AIA_Plan_Benefits__c benifitObj : benifitObjlist) {
        System.debug('+++++benifitObj ++'+benifitObj);
        if(benifitObj.Benefit_Group__r.Plan_Network__r.Name == 'InNetwork')
            setInNetworkBenifitIds.add(benifitObj.id);
        else if(benifitObj.Benefit_Group__r.Plan_Network__r.Name == 'OutNetwork')
            setOutNetworkBenifitIds.add(benifitObj.id);
        benefitIdSet.add(benifitObj.id);
     }

    system.debug('======benefitIdSet====='+benefitIdSet);
    system.debug('======setOutNetworkBenifitIds====='+setOutNetworkBenifitIds);
    system.debug('======setInNetworkBenifitIds====='+setInNetworkBenifitIds);

    String QueryString8=QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefits__c', 'Grouper__r.Benefit_Design_Product__c=:bdpid limit 1000');
    List<AIA_Benefits__c> AIABenlst =  database.query(queryString8); 
    Set<String> lstExtids = new Set<String>();
    for(AIA_Benefits__c aiabenefit: AIABenlst)
    {
    
      lstExtids.add(aiabenefit.InNetwork_ExtID_Copay1__c);
      lstExtids.add(aiabenefit.InNetwork_ExtID_Copay2__c);
      lstExtids.add(aiabenefit.OutNetwork_ExtID_Copay1__c);
      lstExtids.add(aiabenefit.OutNetwork_ExtID_Copay2__c);
    }
       
    List<AIA_Plan_Copay_Type__c> AIAPCTlstNew = new List<AIA_Plan_Copay_Type__c>();
    Map<String,AIA_Plan_Copay_Type__c> mapExtidToAIAPlan = new Map<String,AIA_Plan_Copay_Type__c>();      
    AIAPCTlstNew= [Select id,Name,Plan_Benefits__c,Plan_Benefits__r.benefit_name__C,Discount_Amount__c,Allowed_Amount__c,MandateName__c,Approximate_Member_Payment_w_Discount__c
                  ,Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,
                  MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c, IsASOOnly__c, Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c , 
                  Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c, ExtID__c
                  ,Plan_Benefits__r.IS_ASO_Only__c, Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c from AIA_Plan_Copay_Type__c where PlanID__c=:planid AND ExtID__c In: lstExtids limit 1000];     
    system.debug('======AIAPCTlstNew====='+AIAPCTlstNew.size());      
    for(AIA_Plan_Copay_Type__c AIAPCT: AIAPCTlstNew)
    {
      mapExtidToAIAPlan.put(AIAPCT.ExtID__c,AIAPCT);
    }
   
    System.debug('+++++mapExtidToAIAPlan++AIA_Benefits__c++'+mapExtidToAIAPlan);  
     
   copTypeList= [Select id,Name,AliasName__c, Plan_Benefits__r.Record_Type__c,Allowed_Amount__c,AnnualMaximumApplies__c,Benefit_Sequence_Number__c,CoinsuranceAmount__c,Copay_Additional_Increments__c,
                CopayAmount__c,Copay_High__c,Copay_Increment__c,Copay_Low__c,Copay_Sequence_Number__c,DeductibleApplies__c,Discount_Amount__c,Discount_Amount_Percent__c,
                DiscountApplies__c,Discount_Applies__c,Effective_Date__c,ExtID__c,Grouper_Name__c,IsASOOnly__c,IsCovered__c,Jurisdiction__c,Jurisdiction_for_BRF__c,
                MandateIndicator__c,MandateName__c,MaxPayAmount__c,MinPayAmount__c,Plan_Benefits__c,PlanID__c,Approximate_Member_Payment_w_Discount__c,Term_Date__c,TierType__c,
                Plan_Benefits__r.benefit_name__C,Plan_Benefits__r.Parent_Benefit_Name__c,Copay_Additional_InvalidIncrements__c,Plan_Benefits__r.IS_ASO_Only__c,
                Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c,Plan_Benefits__r.Davis_Benefit_Variable__c,
                Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c,
                Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c,Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c
                from AIA_Plan_Copay_Type__c Where Plan_Benefits__c IN: benefitIdSet 
                  and (jurisdiction__c = 'Federal' OR jurisdiction__c = 'FD')
                  order by   Plan_Benefits__r.benefit_name__C limit 1000];

    If(bdp.Product_Category__c =='Drug' ){
    copTypeList2= [Select id,Name,Plan_Benefits__c,Grouper_Name__c,Plan_Benefits__r.Record_Type__c,Plan_Benefits__r.benefit_name__C,Discount_Amount__c,Allowed_Amount__c,MandateName__c,Approximate_Member_Payment_w_Discount__c,
                Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,
                   MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,IsASOOnly__c, Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c , 
                   Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c, ExtID__c,Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c
                   ,Plan_Benefits__r.IS_ASO_Only__c, Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c from AIA_Plan_Copay_Type__c Where Plan_Benefits__c IN: benefitIdSet and jurisdiction__c != 'Federal' and jurisdiction__c != 'FD' 
                   AND ( (MandateIndicator__c = 'Yes' AND Jurisdiction_for_BRF__c=:jurisdictionFrmBDP) OR 
                           MandateIndicator__c = 'No' OR  MandateIndicator__c = '' )
                           order by   Plan_Benefits__r.benefit_name__C,Copay_Sequence_Number__c desc];
    }
    if(bdp.Product_Category__c =='Medical' ){
   copTypeList2= [Select id,Name,Plan_Benefits__c,Grouper_Name__c,Plan_Benefits__r.Record_Type__c,Plan_Benefits__r.benefit_name__C,Discount_Amount__c,Allowed_Amount__c,MandateName__c,Approximate_Member_Payment_w_Discount__c
               ,Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,
               MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,Plan_Benefits__r.IS_ASO_Only__c, IsASOOnly__c, Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c , 
               Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c, ExtID__c,Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c
               , Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c from AIA_Plan_Copay_Type__c Where Plan_Benefits__c IN: benefitIdSet and jurisdiction__c != 'Federal' and jurisdiction__c != 'FD' 
               AND ( (MandateIndicator__c = 'Yes' AND Jurisdiction_for_BRF__c=:jurisdictionFrmBDP) OR MandateIndicator__c = 'No' OR  MandateIndicator__c = '') order by   Plan_Benefits__r.benefit_name__C,Copay_Sequence_Number__c desc];
   }    
    if( bdp.Product_Category__c =='Vision' )  {   // T04  start
            copTypeList2= [Select id,Name,Grouper_Name__c,Plan_Benefits__r.Record_Type__c,Plan_Benefits__c,Plan_Benefits__r.benefit_name__C,MandateName__c ,Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,
                           MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,Plan_Benefits__r.IS_ASO_Only__c, IsASOOnly__c, Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c , 
                           Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c, ExtID__c,AnnualMaximumApplies__c,Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c
                           , Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c, Discount_Amount__c, Approximate_Member_Payment_w_Discount__c, Allowed_Amount__c,Plan_Benefits__r.Davis_Benefit_Variable__c,Discount_Applies__c, 
                            Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c, Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c
                           from AIA_Plan_Copay_Type__c Where Plan_Benefits__c IN: benefitIdSet and jurisdiction__c != 'Federal' and jurisdiction__c != 'FD' 
                           AND ( (MandateIndicator__c = 'Yes' AND Jurisdiction_for_BRF__c=:jurisdictionFrmBDP) OR 
                                MandateIndicator__c = 'No' OR  MandateIndicator__c = '')
                           order by   Plan_Benefits__r.benefit_name__C,Copay_Sequence_Number__c desc];
        } //T04 End
   if( bdp.Product_Category__c =='Dental' )  {      
            copTypeList2= [Select id,Name,Grouper_Name__c,Plan_Benefits__r.Record_Type__c,Plan_Benefits__c,Plan_Benefits__r.benefit_name__C,MandateName__c ,Plan_Benefits__r.Parent_Benefit_Name__c,TierType__c,Jurisdiction_for_BRF__c,DeductibleApplies__c,AliasName__c,IsCovered__c,     
                            MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,Plan_Benefits__r.IS_ASO_Only__c, IsASOOnly__c, Copay_High__c , Copay_Increment__c, Copay_Low__c,MinPayAmount__c ,       
                            Copay_Additional_InvalidIncrements__c, Copay_Additional_Increments__c , Benefit_Sequence_Number__c,MaxPayAmount__c,Copay_Sequence_Number__c, ExtID__c       
                            , Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c,AnnualMaximumApplies__c,Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c,
                             Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c, Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c
                             from AIA_Plan_Copay_Type__c Where Plan_Benefits__c IN: benefitIdSet and jurisdiction__c != 'Federal' and jurisdiction__c != 'FD'      
                            AND ( (MandateIndicator__c = 'Yes' AND Jurisdiction_for_BRF__c=:jurisdictionFrmBDP) OR       
                            MandateIndicator__c = 'No'  OR  MandateIndicator__c = '' )      
                            order by   Plan_Benefits__r.benefit_name__C,Copay_Sequence_Number__c desc];         
            }                  

   copTypeList.addAll(copTypeList2);
   for(AIA_Plan_Copay_Type__c copType : copTypeList)
        {
           
            System.debug('++++copType++'+'=====benefit name ====='+copType.Plan_Benefits__r.benefit_name__C+'-----'+copType.Name+'====='+ copType.MandateIndicator__c+'===='+copType.Copay_Sequence_Number__c);
            CopayTypeWrapper ct= new CopayTypeWrapper();
            if(copayBenMap.containsKey(copType.Plan_Benefits__r.benefit_name__C)){
                ct=copayBenMap.get(copType.Plan_Benefits__r.benefit_name__C);
                System.debug('+++++ct++++'+ct); 
            }
            else{
                ct= new CopayTypeWrapper();
            }
            if(setInNetworkBenifitIds.contains(copType.Plan_Benefits__c) && ct.copayTypeSelectedObj.id==null)
            {
                ct.copayTypeSelectedObj = copType;
                CopayIDs.add(copType.id); 
            }
            else if(setInNetworkBenifitIds.contains(copType.Plan_Benefits__c) && ct.copayTypePecSpecObj.id==null)
            {
                 Boolean isprev=false;
               //  if( ct.copayTypeSelectedObj.jurisdiction__c=='Federal' && ct.copayTypeSelectedObj.jurisdiction__c== copType.jurisdiction__c  )
                  if( ct.copayTypeSelectedObj.jurisdiction__c=='Federal' &&  ct.copayTypeSelectedObj.jurisdiction__c=='FD'  )
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
                //ct.copayTypePecSpecObj = copType;
            }
            if(setOutNetworkBenifitIds.contains(copType.Plan_Benefits__c) && ct.copayTypeSelectedObj2.id==null)
            {
                ct.copayTypeSelectedObj2 = copType;
                CopayIDs.add(copType.id); 
            }
            else if(setOutNetworkBenifitIds.contains(copType.Plan_Benefits__c) && ct.copayTypePecSpecObj2.id==null)
            {
                 Boolean isprev=false;
                  if( ct.copayTypeSelectedObj2.jurisdiction__c=='Federal' &&  ct.copayTypeSelectedObj2.jurisdiction__c=='FD'  )
                    isprev=true;
                else   if( ct.copayTypeSelectedObj2.jurisdiction__c!='Federal' && ct.copayTypeSelectedObj2.jurisdiction__c!='FD' && ct.copayTypeSelectedObj2.MandateIndicator__c=='Yes' 
                    && ct.copayTypeSelectedObj2.MandateIndicator__c== copType.MandateIndicator__c &&
                    ct.copayTypeSelectedObj2.Jurisdiction_for_BRF__c== copType.Jurisdiction_for_BRF__c  )

                    isprev=true;
                else if( ct.copayTypeSelectedObj2.jurisdiction__c!='Federal' && ct.copayTypeSelectedObj2.jurisdiction__c!='FD' && ct.copayTypeSelectedObj2.MandateIndicator__c=='No' 
                    && ct.copayTypeSelectedObj2.MandateIndicator__c== copType.MandateIndicator__c   )
                    isprev=true;
                else
                    isprev=false;
                if(isprev==true)
                {
                    AIA_Plan_Copay_Type__c c1= new AIA_Plan_Copay_Type__c();
                    c1=copType;
                    ct.copayTypePecSpecObj2 =c1;
                    system.debug('copType=====ct2===='+c1.name+'======'+ct);
                    CopayIDs.add(copType.id);
                }
                //ct.copayTypePecSpecObj2 = copType;
            }           
            
            copayBenMap.put(copType.Plan_Benefits__r.benefit_name__C, ct);
            mapbenefitNameToBDPID.put(copType.Plan_Benefits__r.benefit_name__C,bdp); 
            System.debug('+++++copayBenMap++++'+copayBenMap); 
        }
       
    }
    
/**
* @Author: Sree Harsha 
* @this is wrapper class to store AIA_Plan_Copay_Type__c data
* @param -  
* @Output - 
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
* @Author: Sree Harsha 
* @This Method is called from AIA_BD_DeepClone_Final and it is used to crete Limitation
* @param -  Void
* @Output - 
*/
    public void getPlanLimitation(Set<id> benefitIdSet,AIA_Benefit_Design_Product__c bdp){
        
        JFromBDP = bdp.Jurisdiction__c;
        benLimitsAllMap = new  Map<String,Set<String>>(); 
        PlanLimitIDs=new Set<String>();
        ParentBenLimitationMan = new   Map<String,List<Limitations__c>>();
        ParentBenLimitationLimit = new   Map<String,List<Limitations__c>>();
        Date PPEffDate = bdp.Effective_Date__c;
        List<AIA_Plan_Limitation__c> PLimitTION = [select id, RecordType__c,Plan_Benefits__r.Name,Plan_Benefits__r.Benefit_Name__c,Plan_Benefits__r.Parent_Benefit_Name__c,MaxAgeType__c ,Plan_Benefits__r.Benefit_Group__c,Type__c,
                                                   Jurisdiction__c,TierLimitType__c,MandateIndicator__c,MaxRow_Mandate_Description__c,Plan_Benefits__r.Grouper_Name__c, Effective_Date__c, Term_Date__c ,
                                                   MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, ExtID__c,
                                                   MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c, 
                                                   TierLimitDurationType__c,MaxRow_Value__c,Tier_Value__c,MaxAgeTo__c ,MaxValue__c,TierAgeTo__c,TierLimitFrom__c ,TierAgeType__c ,TierAgeFrom__c,TierLimitTo__c ,MaxApply__c,
                                                   MaxType__c,MaxDuration__c,MaxDurationType__c,MaxAgeFrom__c ,Plan_Benefits__r.IS_ASO_Only__c,IS_ASO_Only__c, ParentBenefitName__c from AIA_Plan_Limitation__c 
                                                   where Plan_Benefits__c in:benefitIdSet AND (Effective_Date__c <=:PPEffDate AND Term_Date__c >=:PPEffDate) order by Plan_Benefits__r.Parent_Benefit_Name__c,MandateIndicator__c desc,type__c];

        for(AIA_Plan_Limitation__c obj:PLimitTION){

            System.debug('++++limitation++'+obj);
            PlanLimitIDs.add(obj.id);

            String limitBenParentName=obj.Plan_Benefits__r.Parent_Benefit_Name__c;
            Set<String> benlimit=new Set<String>();
            String ltype= '';
            String benlimitname=obj.Plan_Benefits__r.Parent_Benefit_Name__c;  
             if(bdp.funding_Arrangement__c == 'ASO')
            {
                if(obj.MandateIndicator__c==true){
                    ltype='M';
                     benlimitname=benlimitname +' - Mandate';
                }else if(obj.MandateIndicator__c==false){
                    ltype='L';
                     benlimitname=benlimitname +' - Limitation'; 
                }
            }
            if(bdp.funding_Arrangement__c == 'Risk')
            {
                if(obj.MandateIndicator__c==true && (obj.Jurisdiction__c == 'Federal' || obj.Jurisdiction__c==JFromBDP || obj.Jurisdiction__c=='FD')){
                    ltype='M';
                     benlimitname=benlimitname +' - Mandate';
                }else if(obj.MandateIndicator__c==false){
                    ltype='L';
                     benlimitname=benlimitname +' - Limitation'; 
                }
                
            }
            set<String> st= new Set<String>();

            Limitations__c tempLimit= new Limitations__c();
            if(obj.IS_ASO_Only__c != null && obj.IS_ASO_Only__c != '')
            {
                if(obj.IS_ASO_Only__c == 'No'|| obj.IS_ASO_Only__c == 'N' )
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
                    tempLimit.IsSelected__c=true;
                    tempLimit.Recordtype__c= obj.RecordType__c;
                    tempLimit.MaxAgeFrom__c=null;
                    tempLimit.MaxAgeTo__c=null;
                    tempLimit.MaxValue__c=null;
                    tempLimit.MaxDuration__c=null;
                    tempLimit.Limitation_ExtID__c = obj.ExtID__c;
                    if(obj.Effective_Date__c!=null){        
                    tempLimit.Effective_Date__c = obj.Effective_Date__c;        
                    }       
                    if(obj.Term_Date__c!=null){     
                    tempLimit.Term_Date__c = obj.Term_Date__c;      
                    }
                    IF(!(STRING.isblank(obj.Jurisdiction__c))){
                    tempLimit.Jurisdiction__c = obj.Jurisdiction__c;
                    }
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
                    tempLimit.Recordtype__c=obj.RecordType__c;
                    tempLimit.Limitation_ExtID__c = obj.ExtID__c;
                    if(obj.Effective_Date__c!=null){        
                    tempLimit.Effective_Date__c = obj.Effective_Date__c;        
                    }       
                    if(obj.Term_Date__c!=null){     
                    tempLimit.Term_Date__c = obj.Term_Date__c;      
                    }
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
                
                 if( obj.Plan_Benefits__r.IS_ASO_Only__c == 'Yes' || obj.Plan_Benefits__r.IS_ASO_Only__c == 'Y'){
                    
                    tempLimit.IS_ASO_Only__c= true;
                    }
                    if( obj.Plan_Benefits__r.IS_ASO_Only__c == 'No' || obj.Plan_Benefits__r.IS_ASO_Only__c == 'N'){
                    
                    tempLimit.IS_ASO_Only__c= false;
                    }
                       
                }
                benLimitsAllMap.put(limitBenParentName, st);
            }/*else if(obj.Type__c =='' && obj.MandateName__c!=null && obj.MandateName__c!='' && (obj.Jurisdiction__c==jurisdictionFrmBDP || obj.Jurisdiction__c=='Federal' || obj.Jurisdiction__c=='FD')){

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
      //getPlanCommentCodes(bdp);

    }
    
/**
* @Author: Sree Harsha 
* @This Method is called from AIA_BD_DeepClone_Final and it is used to crete CommentCodes
* @param -  Void
* @Output - 
*/
    public void getPlanCommentCodes(AIA_Benefit_Design_Product__c bdp){
        Map<String, Set<DEcimal>> parentMandateCodemap=new Map<String, Set<DEcimal>>();
        //Beging Change for 11/7/2016|
        //updating the code to handle the Comment codes for ASO and Risk separately
        Date PPEffDate = bdp.Effective_Date__c;
        List<AIA_Plan_Benefit_Comment_Codes__c> PlanCommentCodes= new List<AIA_Plan_Benefit_Comment_Codes__c> ();
        List<AIA_Plan_Benefit_Comment_Codes__c> PlanCommentCodesf= new List<AIA_Plan_Benefit_Comment_Codes__c> ();
        If(bdp.Funding_Arrangement__c=='Risk')
        PlanCommentCodes=  [select id,name,Plan_Benefit_Grouper_Name__c,Plan_Benefit_Parent_Name__c,IsMandateTrue__c,RecordType__c,type__c,FundingArrangement__c,ParentBenefitName__c,
                            Plan_Limitation__r.MandateIndicator__c,Code__c,Comment__c,Plan_Limitation__r.IS_ASO_Only__c, Plan_Limitation__r.ParentBenefitName__c,
                            Jurisdiction__c, IS_ASO_Only__c,Is_Required__c,Plan_Copay_Type__c,Plan_Limitation__c,Limitation_Type__c,ExtID__c,Plan_Limitation__r.Plan_Benefits__r.IS_ASO_Only__c,
                            Plan_Limitation__r.Effective_Date__c,Plan_Limitation__r.Term_Date__c from AIA_Plan_Benefit_Comment_Codes__c 
                            where  (Is_Required__c=true AND (Plan_Limitation__c in :PlanLimitIDs) AND jurisdiction__c=:JFromBDP )
        order by Plan_Benefit_Parent_Name__c,Sequence_Number__c desc,Code__c ]; 
        else{
            PlanCommentCodes=  [select id,name,Plan_Benefit_Grouper_Name__c,Plan_Benefit_Parent_Name__c,IsMandateTrue__c,RecordType__c,type__c,FundingArrangement__c,ParentBenefitName__c,
                                Plan_Limitation__r.MandateIndicator__c,Code__c,Comment__c, Plan_Limitation__r.IS_ASO_Only__c, Plan_Limitation__r.ParentBenefitName__c,
                                Jurisdiction__c, IS_ASO_Only__c,Is_Required__c,Plan_Copay_Type__c,Plan_Limitation__c,Limitation_Type__c, ExtID__c,Plan_Limitation__r.Plan_Benefits__r.IS_ASO_Only__c,
                                Plan_Limitation__r.Effective_Date__c,Plan_Limitation__r.Term_Date__c from AIA_Plan_Benefit_Comment_Codes__c 
                                where  ( (Plan_Limitation__c in :PlanLimitIDs) )
            order by Plan_Benefit_Parent_Name__c,Sequence_Number__c desc,Code__c ]; 


        }
        system.debug('PlanCommentCodes***'+ PlanCommentCodes);
        system.debug('PlanLimitIDs***'+ PlanLimitIDs);
        system.debug('CopayIDs***'+ CopayIDs);
        
        //End Change for 11/7/2016|
        Boolean IsReqTrue=false;
        for(AIA_Plan_Benefit_Comment_Codes__c comm:PlanCommentCodes)  {
            IsReqTrue=false;
            Limitations__c tempLimit= new Limitations__c();
            String commBenParentName=comm.Plan_Benefit_Parent_Name__c;
            tempLimit.ParentBenefitName__c = comm.ParentBenefitName__c;
         /*   if(comm.IsMandateTrue__c==true)       
             benlimitname=commBenParentName +' - Mandate';       
            else        
             benlimitname=commBenParentName +' - Limitation'; */
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
                tempLimit.CommentType__c = comm.type__c;        
                IF(!(STRING.isblank(comm.Jurisdiction__c))){        
                tempLimit.Jurisdiction__c = comm.Jurisdiction__c;       
                }
                tempLimit.type__c='Comment';
                tempLimit.Recordtype__c=comm.RecordType__c;//'BRF';//
                tempLimit.IsSelected__c=comm.Is_Required__c;
                tempLimit.ParentBenefitName__c = comm.ParentBenefitName__c;
               //tempLimit.ParentBenefitName__c = comm.Plan_Limitation__r.ParentBenefitName__c;
                tempLimit.Limitation_ExtID__c = comm.ExtID__c;
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

            }

            benLimitsAllMap.put(commBenParentName, ls);

            List<Limitations__c> limtls= new List<Limitations__c>();
            Set<DEcimal> codes=new   Set<DEcimal>();
            if( tempLimit.Type__c!='' && tempLimit.Type__c!=null && tempLimit!=null){
                   if(bdp.funding_arrangement__c == 'Risk')
                {
                    if(comm.Type__c =='Mandate' && comm.FundingArrangement__c == 'Risk'){
                        if(ParentBenLimitationMan!= null && ParentBenLimitationMan.containsKey(commBenParentName)){
                            if(parentMandateCodemap!= null &&  parentMandateCodemap.containsKey(commBenParentName))
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
                    }else if(comm.Type__c !='Mandate' && comm.FundingArrangement__c == 'Risk'){
                        if(ParentBenLimitationLimit!= null &&  ParentBenLimitationLimit.containsKey(commBenParentName))
                            limtls=(ParentBenLimitationLimit.get(commBenParentName));
                        else
                            limtls= new List<Limitations__c>();
                        if(parentMandateCodemap != null && parentMandateCodemap.containsKey(commBenParentName)) {
                            if(parentMandateCodemap!= null &&  !parentMandateCodemap.get(commBenParentName).contains(comm.Code__c))
                                limtls.add(tempLimit);
                        }
                        else
                            limtls.add(tempLimit);
                        
                        ParentBenLimitationLimit.put(commBenParentName,limtls);
                    }
                }
               if(bdp.funding_arrangement__c == 'ASO')
                {
                    if(comm.Type__c =='Mandate' ){
                        if(ParentBenLimitationMan!=null && ParentBenLimitationMan.containsKey(commBenParentName)){
                            if(parentMandateCodemap!=null && parentMandateCodemap.containsKey(commBenParentName))
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
                        if(ParentBenLimitationLimit!=null && ParentBenLimitationLimit.containsKey(commBenParentName))
                            limtls=(ParentBenLimitationLimit.get(commBenParentName));
                        else
                            limtls= new List<Limitations__c>();
                        if(parentMandateCodemap != null && parentMandateCodemap.containsKey(commBenParentName)) {
                            if(parentMandateCodemap!=null && !parentMandateCodemap.get(commBenParentName).contains(comm.Code__c))
                                limtls.add(tempLimit);
                        }
                        else
                            limtls.add(tempLimit);
                        
                        ParentBenLimitationLimit.put(commBenParentName,limtls);
                    }
                }
            }
        }
        
        system.debug('final ParentBenLimitationMan---'+ParentBenLimitationMan);
        system.debug('final ParentBenLimitationLimit---'+ParentBenLimitationLimit);
        
    }
    
    public void createWrapListFromPlanCostShr(String planIdStr,AIA_Benefit_Design_Product__c bdp) {
        String jurisdictionFrmBDP = '';
        
        jurisdictionFrmBDP = bdp.Benefit_Design__r.Jurisdiction__c;
        costShareOldValMap=new map <String,string>();

        //grouperWrapListCostShr = new List<GrouperWrapper>();
        List<AIA_Plan_Network__c> planNetworkList = [Select id, Name from AIA_Plan_Network__c Where Plan__c =: planIdStr];
        List<AIA_Plan_Grouper__c> planGrouperBenList = new List<AIA_Plan_Grouper__c>();
        System.debug('+++++createWrapListFromPlanCostShrplanNetworkList++++'+planNetworkList);

        Set<String> groupNameSet = new Set<String>();

        List<AIA_Plan_Grouper__c> grprListToClr = [Select id, Name, Plan_Network__c,Type__c, Record_Type__c, Plan_Network__r.Name 
                                                   From AIA_Plan_Grouper__c 
                                                   Where Plan_Network__c IN: planNetworkList AND Type__c = 'Cost Share Group' AND Record_Type__c = 'BDD' Order By Plan_Network__r.Name limit 1000]; 
        for( AIA_Plan_Grouper__c groupObj : grprListToClr ) {
            //if(!groupNameSet.contains(groupObj.Name)) {
                //planGrouperBenList.add(groupObj);
                //groupNameSet.add(groupObj.Name);
            //}
        }
        System.debug('+++++createWrapListFromPlanCostShr++++grprListToClr++++'+grprListToClr);
        //planNetworkList.clear();
        //groupNameSet.clear();
        mapIDTobenefit = new Map<String,AIA_Plan_Benefits__c>();    
        // MAP :  Grouper Name, Benifit Name, In Net/OutNet, Benifit Record
        Map<String, Map<String, Map<String, AIA_Plan_Benefits__c>>> benifitNetworkMap = new Map<String, Map<String, Map<String, AIA_Plan_Benefits__c>>>();
        Set<id> benefitIdSet = new Set<id>();
        
        maplst = new Map<String,AIA_Plan_Benefits__c>();
        for( AIA_Plan_Benefits__c benifitObj : [Select id,Record_Type__c,name, Benefit_Name__c,Benefit_Group__r.Name, Cost_Share_Increment__c,Three_Month_Deductible_Carryover__c,
                                                Cost_Share_AdditionalIncrements__c ,IS_ASO_Only__c, Cost_Share_InvalidIncrements__c, Cost_Share_Low__c,Cost_Share_High__c,
                                                Cost_Share_Default_Amount__c,Coinsurance_DefaultAmount__c ,IsAppGlobalCopay__c,IsAppGlobalCoinsurance__c, Benefit_Group__c, 
                                                Benefit_Group__r.Plan_Network__c, benefit_Group__r.Plan_Network__r.Name, Cost_Share_Type__c
                                                from AIA_Plan_Benefits__c 
                                                Where Benefit_Group__c IN: grprListToClr AND Record_Type__c = 'BDD' limit 1000]) {
                                                    
            System.debug('+++++createWrapListFromPlanCostShr++++benifitObj++++'+benifitObj);
            if(benifitObj.Benefit_Group__r.Plan_Network__r.Name.contains('InNetwork')){
                //lstforCostShare.add(benifitObj);
                 mapIDTobenefit.put(benifitObj.Benefit_Name__c,benifitObj);
                String val;
                if(benifitObj.Cost_Share_Type__c=='Dropdown_Yes_No')
                val=(benifitObj.Three_Month_Deductible_Carryover__c!=null?String.valueof(benifitObj.Three_Month_Deductible_Carryover__c):'');
                else
                val=(benifitObj.Cost_Share_Default_Amount__c!=null?String.valueof(benifitObj.Cost_Share_Default_Amount__c):'');
                
                costShareOldValMap.put(benifitObj.Benefit_Name__c, val+'_');
            }
            if(benifitObj.Benefit_Group__r.Plan_Network__r.Name.contains('OutNetwork')){
                maplst.put(benifitObj.Benefit_Name__c,benifitObj);
                 String val;
                 if(benifitObj.Cost_Share_Type__c=='Dropdown_Yes_No')
                 val=costShareOldValMap.get(benifitObj.Benefit_Name__c)+
                     (benifitObj.Three_Month_Deductible_Carryover__c!=null?String.valueof(benifitObj.Three_Month_Deductible_Carryover__c):'');
                 else
                 val=costShareOldValMap.get(benifitObj.Benefit_Name__c)+
                     (benifitObj.Cost_Share_Default_Amount__c!=null?String.valueof(benifitObj.Cost_Share_Default_Amount__c):'');
                costShareOldValMap.put(benifitObj.Benefit_Name__c, val);
            }
        }
        
        System.debug('+++++createWrapListFromPlanCostShr++++mapIDTobenefit++++'+mapIDTobenefit);
    }

/**
* @Author: Sree Harsha 
* @This Method is called from AIA_BD_DeepClone_Final and it is used to delete Document list and BD
* @param -  Void
* @Output - 
*/
   public void cancelButton(AIA_Benefit_Design__c newBD)
    {
                if(newBD != null && newBD.id != null)
        {
            List<AIA_Document__c> AIADocLst = [Select id FROM AIA_Document__c WHERE Benefit_Design__c =:newBD.id];
            system.debug('==AIABRFLst==Delete== :: '+AIADocLst);
            if(AIADocLst!= null && AIADocLst.size()>0){
                delete AIADocLst;
            }        
            delete newBD;
        }    
    }
    
}