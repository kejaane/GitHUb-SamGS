/*===================================================================================================================
 * Date       : 06/13/2017
 * Developer  : Sajitha Yalamanchili
 * Purpose    : AIA_PCSIntializeGroupersLimitations to query all values and map to the JSON structure
 *              in class AIA_PCSJSONStructure
 *                                 Update History
 *                                 ---------------
 * Date       |     Developer        | Tag |   Description
 *============+============+=========================================================================================
 * 06/13/2017 | Sajitha Yalamanchili |     | Initial Version
 * 06/13/2017 | Ravi Teja Vadapalli  | T01 | Initialize AIA_PCSInitializePlans for passing BDP ID to populate plans 
 *                                           method
 * 07/05/2017| Rajesh Nagandla      | T02 | Added code to pass Network Ids and PCS tag column name to costshare Grouper US:20 
 *                                           And Modularized the code by putting separate methods 
 *============+============+=========================================================================================
*/
public class AIA_OP4PCSIntializeGroupersLimitations{
    public Static Set<ID> bdpId = new Set<Id>();
    public Static Set<ID> grouperIds = new Set<Id>();
    public AIA_OP4PCSJSONStructure pcsjsonObj= new  AIA_OP4PCSJSONStructure();
    public Map<String,list<AIA_Benefits__c>> costsharemap = new Map<String,list<AIA_Benefits__c>>();
    public map<string,string> grouperset = new map<string,string>();
    public map<string,string> pcstranslationmap =new map<string,string>();
    public Map<string,Map<string,list<AIA_Benefits__c>>> grouperbenmap = new Map<string,Map<string,list<AIA_Benefits__c>>>();
    public Map<string,set<string>> grouperparbennamemap = new Map<string,set<string>>(); 
    public void generateJSONContentForBPD(String bpdid){
        //T01-start
        //populate plan fields and append to pcsjsonObj
        AIA_OP4_PCS_InitPlanHeaderAttributes populateplans=new AIA_OP4_PCS_InitPlanHeaderAttributes();
        populateplans.getPlans(bpdid);
        pcsjsonObj=populateplans.pcsjsonObj;
        //T01-End
        String grouperquery;
        String benefitquery;
        String limitationsquery;
        String translationquery;
        String tempstring;
        map<String,List<Limitations__c>> mapBenfitIdToLstMitations = new map<String,List<Limitations__c>>();
        
        translationquery = 'select PCS_Tag__c,Salesforce_Display_Name__c from AIA_PCS_Transaction_Table__c';
        
        grouperquery = 'Select id,Name,Group_Type__c,Grouper_Record_Type__c from AIA_Grouper__c where Benefit_Design_Product__c =:bpdid';
        
        for(AIA_Grouper__c grouperObj: Database.query(grouperquery)){
            grouperIds.add(grouperObj.id);
        }
        //T02 - Start
        benefitquery = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('AIA_Benefits__c','Grouper__c =:grouperIds AND (Benefit_Type__c = \'Benefit\')','Grouper__r.Group_Type__c,Grouper__r.CoInsurance__c,Grouper__r.PCS_Grouper_Id__c,Grouper__r.name,Grouper__r.DeductibleApplies__c,Grouper__r.IsCovered__c,Grouper__r.AnnualMaximumApplies__c,Grouper__r.OON_CoInsurance__c,Grouper__r.OON_DeductibleApplies__c,Grouper__r.OON_IsCovered__c,Grouper__r.OON_AnnualMaximumApplies__c,Grouper__r.InNetwork__c,Grouper__r.OON_OutNetwork__c,Grouper__r.CoInsurance_Default__c,Grouper__r.OON_CoInsurance_Default__c,Grouper__r.Benefit_Design_Product__r.Product_Category__c, ');
        //T02 - End
        
        limitationsquery = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Limitations__c','Benefit__r.Grouper__r.Benefit_Design_Product__c =:bpdid AND (Benefit__r.Benefit_Type__c = \'Limitation\' OR Benefit__r.Benefit_Type__c = \'Mandate\') AND ((IsSelected__c=true AND Type__c = \'Comment\') OR ( Type__c != \'Comment\' AND (TierLimit_Selected__c=true OR TierAge_Selected__c=true OR MaxDuration_Selected__c=true OR MaxAge_Selected__c=true)))','Benefit__r.Benefit_Name__c,Benefit__r.Copay_Type_1_Jurisdiction__c,Benefit__r.Benefit_Type__c,Benefit__r.Parent_Benefit_Name__c, ');
       
        for(AIA_PCS_Transaction_Table__c transdata: Database.query(translationquery)){
            pcstranslationmap.put(transdata.Salesforce_Display_Name__c,transdata.PCS_Tag__c);
        }
        //fetching the Limitations with Benefit Name+benefittype tempstring and put those on map
        for(Limitations__c limitaObj: Database.query(limitationsquery)){
            tempstring = limitaObj.Benefit__r.Parent_Benefit_Name__c +' '+limitaObj.Benefit__r.Benefit_Type__c;
            if(tempstring != null){
                if(!mapBenfitIdToLstMitations.containsKey(tempstring)){
                    mapBenfitIdToLstMitations.put(tempstring, new list<Limitations__c>{limitaObj});
                }else if(mapBenfitIdToLstMitations.containsKey(tempstring)){
                     mapBenfitIdToLstMitations.get(tempstring).add(limitaObj);
                }
            }
        }
        system.debug('key'+mapBenfitIdToLstMitations);
        //Optimized by SMSL
        for(AIA_Benefits__c benefitObj: Database.query(benefitquery)){
            if(benefitObj.Grouper__r.Group_Type__c == AIA_Constants.costsharestr){
                if(!costsharemap.containsKey(AIA_Constants.costsharestr)){
                    costsharemap.put(AIA_Constants.costsharestr, new list<AIA_Benefits__c>{benefitObj});
                }else if(costsharemap.containsKey(AIA_Constants.costsharestr)){
                     costsharemap.get(AIA_Constants.costsharestr).add(benefitObj);
                }
            }
            else if(benefitObj.Grouper__r.Group_Type__c == AIA_Constants.Benefitstr){
                grouperset.put(benefitObj.Grouper__r.name,benefitObj.Grouper__r.PCS_Grouper_Id__c);
                if(!grouperparbennamemap.containsKey(benefitObj.Grouper__r.name)){
                     grouperparbennamemap.put(benefitObj.Grouper__r.name, new set<string>{benefitObj.Parent_Benefit_Name__c});
                }else if(grouperparbennamemap.containsKey(benefitObj.Grouper__r.name)){
                     grouperparbennamemap.get(benefitObj.Grouper__r.name).add(benefitObj.Parent_Benefit_Name__c);
                }
                if(!grouperbenmap.containsKey(benefitObj.Grouper__r.name)){
                    grouperbenmap.put(benefitObj.Grouper__r.name, new Map<String, list<AIA_Benefits__c>>());
                }
                if(!grouperbenmap.get(benefitObj.Grouper__r.name).containsKey(benefitObj.Parent_Benefit_Name__c)){
                    grouperbenmap.get(benefitObj.Grouper__r.name).put(benefitObj.Parent_Benefit_Name__c, new list<AIA_Benefits__c>{benefitObj});
                }
                else{
                    grouperbenmap.get(benefitObj.Grouper__r.name).get(benefitObj.Parent_Benefit_Name__c).add(benefitObj);
                }
            }
        }
        
       //Costshare Json
        costsharegrouperjson(costsharemap,pcstranslationmap,AIA_Constants.costsharestr);
       //Benefit json
        benifitsharejson(grouperset, grouperbenmap, mapBenfitIdToLstMitations, grouperparbennamemap);
    }//Method End// 
    
    public void costsharegrouperjson(Map<String,list<AIA_Benefits__c>> costsharemap, map<string,string> pcstranslationmap,string costsharestr){
        //Costshare variable initialisation 
        AIA_OP4PCSJSONStructure.Cls_costShareList  costShareGrouper= new AIA_OP4PCSJSONStructure.Cls_costShareList();
        AIA_OP4PCSJSONStructure.Cls_networkList costsharenetwork = new AIA_OP4PCSJSONStructure.Cls_networkList();
        list<AIA_OP4PCSJSONStructure.Cls_networkList> costsharenetworklst = new list<AIA_OP4PCSJSONStructure.Cls_networkList>();
        
        //costshare data 
        if(costsharemap.containsKey(AIA_Constants.costsharestr)){
            for(AIA_Benefits__c benefitcashObj:costsharemap.get(AIA_Constants.costsharestr)){
                costShareGrouper= new AIA_OP4PCSJSONStructure.Cls_costShareList();
                costsharenetwork = new AIA_OP4PCSJSONStructure.Cls_networkList();
                costsharenetworklst = new list<AIA_OP4PCSJSONStructure.Cls_networkList>();
                if(pcstranslationmap.containsKey(benefitcashObj.Benefit_Name__c)){
                    costShareGrouper.CostShareName = pcstranslationmap.get(benefitcashObj.Benefit_Name__c);
                }
                else{
                    costShareGrouper.CostShareName = benefitcashObj.Benefit_Name__c;
                }
                costsharenetwork.Type = AIA_Constants.InNetwork;
                costsharenetwork.NetworkID = benefitcashObj.Grouper__r.InNetwork__c;
                costsharenetwork.Amount = benefitcashObj.Cost_Share_SelectedAmount__c;
                costsharenetwork.Customized = benefitcashObj.Cost_Share_Customized__c;
                costsharenetworklst.add(costsharenetwork);
                costsharenetwork = new AIA_OP4PCSJSONStructure.Cls_networkList();
                if(benefitcashObj.Grouper__r.OON_OutNetwork__c!=null){
                costsharenetwork.Type = AIA_Constants.OutNetwork;
                costsharenetwork.NetworkID =benefitcashObj.Grouper__r.OON_OutNetwork__c;
                costsharenetwork.Amount = benefitcashObj.OON_Cost_Share_SelectedAmount__c;
                costsharenetwork.Customized = benefitcashObj.OON_Cost_Share_Customized__c;
                costsharenetworklst.add(costsharenetwork);
                }
                costShareGrouper.networkList.addall(costsharenetworklst);
                pcsjsonObj.costShareList.add(costShareGrouper);
                
            }
        }//Costshare data if end
    }//costsharegrouperjson method ends
    public void benifitsharejson(map<string,string> grouperset, Map<string,Map<string,list<AIA_Benefits__c>>> grouperbenmap, map<String,List<Limitations__c>> mapBenfitIdToLstMitations, Map<string,set<string>> grouperparbennamemap){
       //Benefit variable initialisation
        AIA_OP4PCSJSONStructure.Cls_BenefitGrouperList bengrp = new AIA_OP4PCSJSONStructure.Cls_BenefitGrouperList();
        list<AIA_OP4PCSJSONStructure.Cls_BenefitGrouperList> bengrplst = new list<AIA_OP4PCSJSONStructure.Cls_BenefitGrouperList>();
        AIA_OP4PCSJSONStructure.Cls_GrouperData bengrpdata = new AIA_OP4PCSJSONStructure.Cls_GrouperData();
        list<AIA_OP4PCSJSONStructure.Cls_GrouperData> bengrpdatalst = new list<AIA_OP4PCSJSONStructure.Cls_GrouperData>();
        AIA_OP4PCSJSONStructure.Cls_lstParentBenefit parentben = new AIA_OP4PCSJSONStructure.Cls_lstParentBenefit();
        list<AIA_OP4PCSJSONStructure.Cls_lstParentBenefit> parentbenlst = new list<AIA_OP4PCSJSONStructure.Cls_lstParentBenefit>();
        AIA_OP4PCSJSONStructure.Cls_lstBenefit bendata = new AIA_OP4PCSJSONStructure.Cls_lstBenefit();
        list<AIA_OP4PCSJSONStructure.Cls_lstBenefit> benlst = new list<AIA_OP4PCSJSONStructure.Cls_lstBenefit>();
        AIA_OP4PCSJSONStructure.Cls_BenNetworkList bennetwork = new AIA_OP4PCSJSONStructure.Cls_BenNetworkList();
        list<AIA_OP4PCSJSONStructure.Cls_BenNetworkList> bennetworklst = new list<AIA_OP4PCSJSONStructure.Cls_BenNetworkList>();
        AIA_OP4PCSJSONStructure.Cls_lstCommentCode bencomments = new AIA_OP4PCSJSONStructure.Cls_lstCommentCode();
        list<AIA_OP4PCSJSONStructure.Cls_lstCommentCode> bencommentslst = new list<AIA_OP4PCSJSONStructure.Cls_lstCommentCode>();
        for(string grpname:grouperset.keySet()){ 
            if(grouperbenmap.containsKey(grpname)){
                bengrp = new AIA_OP4PCSJSONStructure.Cls_BenefitGrouperList();
                bengrp.GrouperName = grpname;
                bengrp.GrouperID = grouperset.get(grpname);
                 for(string curparentname:grouperparbennamemap.get(grpname)){
                    benlst = new list<AIA_OP4PCSJSONStructure.Cls_lstBenefit>(); 
                    for(AIA_Benefits__c benObj:grouperbenmap.get(grpname).get(curparentname)){
                        bengrplst = new list<AIA_OP4PCSJSONStructure.Cls_BenefitGrouperList>();
                        bengrpdata = new AIA_OP4PCSJSONStructure.Cls_GrouperData();
                        bengrpdatalst = new list<AIA_OP4PCSJSONStructure.Cls_GrouperData>();
                        parentben = new AIA_OP4PCSJSONStructure.Cls_lstParentBenefit();
                        parentbenlst = new list<AIA_OP4PCSJSONStructure.Cls_lstParentBenefit>();
                        bendata = new AIA_OP4PCSJSONStructure.Cls_lstBenefit();
                        bennetwork = new AIA_OP4PCSJSONStructure.Cls_BenNetworkList();
                        bennetworklst = new list<AIA_OP4PCSJSONStructure.Cls_BenNetworkList>();
                        bencomments = new AIA_OP4PCSJSONStructure.Cls_lstCommentCode();
                        bencommentslst = new list<AIA_OP4PCSJSONStructure.Cls_lstCommentCode>();
                        //Innetwork Data Mapping
                        bengrpdata.Type = AIA_Constants.InNetwork;
                        bengrpdata.NetworkID = benObj.Grouper__r.InNetwork__c;
                        bengrpdata.coinsurance = benObj.Grouper__r.CoInsurance__c;
                        bengrpdata.DeductibleApplies = benObj.Grouper__r.DeductibleApplies__c;
                        bengrpdata.IsCovered = benObj.Grouper__r.IsCovered__c;
                        bengrpdata.AnnualMaximumApplies = benObj.Grouper__r.AnnualMaximumApplies__c;
                        if(benObj.Grouper__r.CoInsurance__c != benObj.Grouper__r.CoInsurance_Default__c && benObj.Grouper__r.Benefit_Design_Product__r.Product_Category__c == 'Dental' ){
                        bengrpdata.CoinsuranceCustomized = True;
                        }
                        if(benObj.Grouper__r.CoInsurance__c == benObj.Grouper__r.CoInsurance_Default__c && benObj.Grouper__r.Benefit_Design_Product__r.Product_Category__c == 'Dental'){
                        bengrpdata.CoinsuranceCustomized = False;
                        }
                        bengrpdatalst.add(bengrpdata);
                        bengrpdata = new AIA_OP4PCSJSONStructure.Cls_GrouperData();
                        //OutNetwork Data Mapping
                        if(benObj.Grouper__r.OON_OutNetwork__c!=null)
                        {
                        bengrpdata.Type = AIA_Constants.OutNetwork;
                        bengrpdata.NetworkID = benObj.Grouper__r.OON_OutNetwork__c;
                        bengrpdata.coinsurance = benObj.Grouper__r.OON_CoInsurance__c;
                        bengrpdata.DeductibleApplies = benObj.Grouper__r.OON_DeductibleApplies__c;
                        bengrpdata.IsCovered = benObj.Grouper__r.OON_IsCovered__c;
                        bengrpdata.AnnualMaximumApplies = benObj.Grouper__r.OON_AnnualMaximumApplies__c;
                        if(benObj.Grouper__r.OON_CoInsurance__c != benObj.Grouper__r.OON_CoInsurance_Default__c){
                        bengrpdata.CoinsuranceCustomized = True;
                        }
                        if(benObj.Grouper__r.OON_CoInsurance__c == benObj.Grouper__r.OON_CoInsurance_Default__c){
                        bengrpdata.CoinsuranceCustomized = False;
                        }
                        bengrpdatalst.add(bengrpdata);
                        }
                        
                        
                        parentben.ParentBenefitName = benObj.Parent_Benefit_Name__c;
                        bendata.BenefitName = benObj.Benefit_Name__c; 
                        bendata.PlaceOfService = benObj.Place_of_Service__c;  
                        if(benObj.Copay_Type_1_Mandate_Name__c != '' && benObj.Copay_Type_1_Mandate_Name__c != null){
                        bendata.MandateName = benObj.Copay_Type_1_Mandate_Name__c;  
                        }
                        else{
                        bendata.MandateName = benObj.Parent_Benefit_Name__c;
                        }
                       
                        bennetwork.Type = AIA_Constants.InNetwork;
                        bennetwork.NetworkID = benObj.InNetwork_Id__c;
                        bennetwork.GeneralCopayAmount = benObj.Copay_Type_1_AmountValueSelected__c;
                        if(benObj.Copay_Type_1_AliasName__c == AIA_Constants.spccostr){
                            bennetwork.SpecialistCopayAmount = benObj.Copay_Type_1_AmountValueSelected__c;
                        }
                        if(benObj.Copay_Type_2_AliasName__c== AIA_Constants.spccostr){
                            bennetwork.SpecialistCopayAmount = benObj.Copay_Type_2_AmountValueSelected__c;
                        }
                        if(benObj.Copay_Type_1_AliasName__c == AIA_Constants.peradstr){
                            bennetwork.PerAdmissionCopayAmount = benObj.Copay_Type_1_AmountValueSelected__c;
                        }
                        if(benObj.Copay_Type_2_AliasName__c== AIA_Constants.peradstr){
                            bennetwork.PerAdmissionCopayAmount = benObj.Copay_Type_2_AmountValueSelected__c;
                        }
                        if(benObj.Copay_Type_2_AliasName__c== AIA_Constants.pcpcostr){
                            bennetwork.PCPCopayAmount = benObj.Copay_Type_2_AmountValueSelected__c;
                        }
                        if(benObj.Copay_Type_2_AliasName__c== AIA_Constants.pcpcostr){
                            bennetwork.PCPCopayAmount = benObj.Copay_Type_2_AmountValueSelected__c;
                        }
                        if(benObj.Copay_Type_1_AliasName__c == AIA_Constants.gencostr){
                            bennetwork.GeneralCopayAmount = benObj.Copay_Type_1_AmountValueSelected__c;
                        }
                        if(benObj.Copay_Type_2_AliasName__c== AIA_Constants.gencostr){
                            bennetwork.GeneralCopayAmount = benObj.Copay_Type_2_AmountValueSelected__c;
                        }
                        //Benefit Level Mapping
                        bennetwork.IsCovered = benObj.Copay_Type_1_IsCovered__c;
                        bennetwork.DeductibleApplies = benObj.Copay_Type_1_DeductibleApplies__c;
                        bennetwork.Coinsurance = benObj.CoInsurance_AmountValueSelected__c;
                        bennetwork.AllowedAmount = benObj.Allowed_Amount__c ;
                        bennetwork.ScheduledAmount = benObj.IN_Approximate_Member_Payment_w_Discount__c;
                        bennetwork.DiscountApplies = benObj.Discount_Applies__c;
                        bennetwork.DiscountAmount = benObj.Discount_Amount__c;
                        bennetwork.DiscountPercentage = benObj.Discount_Amount_Percent__c;
                        bennetwork.MinPayment = benObj.Copay_Min_Payment__c;
                        bennetwork.MaxPayment = benObj.Copay_Max_Payment__c;
                        bennetwork.TierType = benObj.Tier_type__c;
                        bennetwork.AnnualMaxApplies = benObj.AnnualMaximumApplies__c;
                        boolean mandateyesno = false;
                        List<String> lstBenefitTypes = new List<String>();
                        lstBenefitTypes.add('Mandate');
                        lstBenefitTypes.add('Limitation'); 
                       for(String benefitType:lstBenefitTypes)
                        {
                            system.debug('Check type'+benObj.Parent_Benefit_Name__c + ' ' +benefitType);
                       if(mapBenfitIdToLstMitations.containsKey(benObj.Parent_Benefit_Name__c + ' ' +benefitType))
                        {
                           for(Limitations__c limitationObj: mapBenfitIdToLstMitations.get(benObj.Parent_Benefit_Name__c+' '+benefitType)){
                                //Limitation Level Mapping for TierLimit/MaxRow.
                                bencommentslst = new list<AIA_OP4PCSJSONStructure.Cls_lstCommentCode>();
                                bencomments = new AIA_OP4PCSJSONStructure.Cls_lstCommentCode();
                                bencomments.Type = limitationObj.Type__c;
                                
                               if(limitationObj.TierLimit_Selected__c==true) {
                                bencomments.TierLimitType = limitationObj.TierLimitType__c;
                                bencomments.TierLimitTo = limitationObj.TierLimitTo__c;
                                bencomments.TierLimitFrom = limitationObj.TierLimitFrom__c;
                                bencomments.TierLimitDurationType = limitationObj.TierLimitDurationType__c;
                               }
                               if(limitationObj.TierAge_Selected__c==true){ 
                                bencomments.TierAgeType = limitationObj.TierAgeType__c;
                                bencomments.TierAgeTo = limitationObj.TierAgeTo__c;
                                bencomments.TierAgeFrom = limitationObj.TierAgeFrom__c;
                               }
                               if(limitationObj.MaxDuration_Selected__c== true){ 
                                bencomments.MaxValue = Integer.valueof(limitationObj.MaxValue__c);
                                bencomments.MaxType = limitationObj.MaxType__c;
                                bencomments.MaxDurationType = limitationObj.MaxDurationType__c;
                                bencomments.MaxDuration = limitationObj.MaxDuration__c;
                                bencomments.MaxApply = limitationObj.MaxApply__c;
                               }
                               if(limitationObj.MaxAge_Selected__c==true){ 
                                bencomments.MaxAgeType = limitationObj.MaxAgeType__c;
                                bencomments.MaxAgeTo = limitationObj.MaxAgeTo__c;
                                bencomments.MaxAgeFrom = limitationObj.MaxAgeFrom__c;
                                }
                                
                                if(limitationObj.Benefit_Type__c == 'Mandate' || limitationObj.MandateIndicator__c == True){
                                 bencomments.MandateInd = true;
                                 bencomments.MandateName = limitationObj.Benefit_Mandate_Name__c;
                                 bencomments.Jurisdiction = limitationObj.Mandate_Jurisdiction__c;
                                 mandateyesno = true;
                                }
                                else {
                                    bencomments.MandateInd = false;
                                    mandateyesno = false;
                                }
                               //Limitation Level Mapping for CommentCode.
                                bencomments.IsSelected = limitationObj.IsSelected__c;
                                bencomments.IsRequired = limitationObj.IsRequired__c;
                                bencomments.IsCustom = limitationObj.IsCustom__c;
                                bencomments.Comment = limitationObj.comment_codes__c;
                                bencomments.Code = limitationObj.Code__c;
                                bencomments.isNew = limitationObj.Additional_Comment__c;//Included in V7
                                bencomments.FundingArrangement = limitationObj.FundingArrangement__c;//Included in V7
                                bencomments.CommentType = limitationObj.CommentType__c;
                                bencomments.isASO = limitationObj.IS_ASO_Only__c;
                                bencommentslst.add(bencomments); 
                                bennetwork.lstCommentCode.addAll(bencommentslst);
                                }//limitation for ends//
                            
                        }//Limitation Map Contains condition ends//     
                        }
                       //added by RG 8/3 start
                       bendata.MandateInd = mandateyesno;
                       //added by RG 8/3 end
                        bennetworklst.add(bennetwork);
                        bennetwork = new AIA_OP4PCSJSONStructure.Cls_BenNetworkList();
                        if(benObj.OON_OutNetwok_Id__c!=null){
                        //Copay Level mapping for Out-Network   
                        bennetwork.Type = AIA_Constants.OutNetwork;
                        bennetwork.NetworkID = benObj.OON_OutNetwok_Id__c;
                        bennetwork.GeneralCopayAmount = benObj.OON_Copay_Type_1_AmountValueSelected__c;
                        if(benObj.OON_Copay_Type_1_AliasName__c == AIA_Constants.spccostr){
                            bennetwork.SpecialistCopayAmount = benObj.OON_Copay_Type_1_AmountValueSelected__c;
                        }
                        if(benObj.OON_Copay_Type_2_AliasName__c == AIA_Constants.spccostr){
                            bennetwork.SpecialistCopayAmount = benObj.OON_Copay_Type_2_AmountValueSelected__c;
                        }
                        if(benObj.OON_Copay_Type_1_AliasName__c == AIA_Constants.peradstr){
                            bennetwork.PerAdmissionCopayAmount = benObj.OON_Copay_Type_1_AmountValueSelected__c;
                        }
                        if(benObj.OON_Copay_Type_2_AliasName__c == AIA_Constants.peradstr){
                            bennetwork.PerAdmissionCopayAmount = benObj.OON_Copay_Type_2_AmountValueSelected__c;
                        }
                        if(benObj.OON_Copay_Type_2_AliasName__c == AIA_Constants.pcpcostr){
                            bennetwork.PCPCopayAmount = benObj.OON_Copay_Type_2_AmountValueSelected__c;
                        }
                        if(benObj.OON_Copay_Type_2_AliasName__c == AIA_Constants.pcpcostr){
                            bennetwork.PCPCopayAmount = benObj.OON_Copay_Type_2_AmountValueSelected__c;
                        }
                        if(benObj.OON_Copay_Type_1_AliasName__c == AIA_Constants.gencostr){
                            bennetwork.GeneralCopayAmount = benObj.OON_Copay_Type_1_AmountValueSelected__c;
                        }
                        if(benObj.OON_Copay_Type_2_AliasName__c == AIA_Constants.gencostr){
                            bennetwork.GeneralCopayAmount = benObj.OON_Copay_Type_2_AmountValueSelected__c;
                        }
                        
                        bennetwork.IsCovered = benObj.OON_Copay_Type_1_IsCovered__c;
                        bennetwork.DeductibleApplies = benObj.OON_Copay_Type_1_DeductibleApplies__c;
                        bennetwork.Coinsurance = benObj.OON_CoInsurance_AmountValueSelected__c;
                        bennetwork.AllowedAmount = benObj.OON_Allowed_Amount__c ;
                        bennetwork.ScheduledAmount = benObj.ON_Approximate_Member_Payment_w_Discount__c;
                        bennetwork.DiscountApplies = benObj.OON_Discount_Applies__c;
                        bennetwork.DiscountAmount = benObj.OON_Discount_Amount__c;
                        bennetwork.DiscountPercentage = benObj.OON_Discount_Amount_Percent__c;
                        bennetwork.TierType = benObj.OON_Tier_Type__c;
                        bennetwork.AnnualMaxApplies = benObj.OON_AnnualMaximumApplies__c;
                        bennetworklst.add(bennetwork);
                        }
                        bendata.NetworkList.addAll(bennetworklst);
                        bendata.newBenefit = benObj.Additional_Benefit__c;
                        bendata.VariationConditionID = benObj.Variation_Condition_ID__c;
                        bendata.BenefitID = benObj.PCS_Benefit_Id__c;
                        bendata.DavisBenefitVariable = benObj.Davis_Benefit_Variable__c;
                        bendata.Jurisdiction = benObj.Copay_Type_1_Jurisdiction__c;//new added in V7
                        bendata.Customized = benObj.Benefit_Customized__c;
                        benlst.add(bendata);
                       }
                      parentben.lstBenefit.addAll(benlst);
                      parentbenlst.add(parentben);
                      bengrp.lstParentBenefit.addAll(parentbenlst);
                  }
                bengrp.GrouperData.addAll(bengrpdatalst);
                bengrplst.add(bengrp);
                pcsjsonObj.BenefitGrouperList.addAll(bengrplst);
            }
        }//End of benefit data  
    }//Benefitsharegrouperjson method ends
}