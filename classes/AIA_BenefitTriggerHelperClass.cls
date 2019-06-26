/*****************************************************************************************************
*Date: 11-22-2016 
*Developer: Indira Das
*Purpose: Triger helper class for Benefits handler
This is used to check if iscustom is true for any of the benfits then pp iscustom sould be checked as true
*=========================================================================================
* Update History
* Date         Developer               Description
*==================================================================================
*11-22-2016   Indira Das     Initial Development
*==================================================================================
*02-22-2017   Satya        Added code to update drug pp cost share fields when there is change in related Medical PP cost share 
                           fields depending upon Rx Integration and Rx OOP MAX Integration fields on related Medical PP
*03-27-2017   Bill         Remove adjustment summary code no longer used.
*03-31-2017   Sree Harsha      T01   Added null check and changed query for Defect 35338.
*04-10-2017   Goutham Rapolu   T02   Update Custom on PP when the Benefit Value is changed US B-03783
*07-24-2017    satya       |T03|  Added conditions to make Benefit non-standard when ranges are NA.
*******************************************************************************************************/



public class AIA_BenefitTriggerHelperClass {
    
  //T02 Start
    public static void UpdatecustomizedProperties(List<AIA_Benefits__c> newbenefits)
    {
        boolean custom = false;
        boolean nonstandard = false;
        string ppid = null;
        string bdpid = null;
        List<id> Grouperids = new List<id>();
        List<AIA_Benefits__c> BenList = New List<AIA_Benefits__c>();
        for(AIA_Benefits__c aiaben: newbenefits)
        {
            aiaben.Benefit_Non_Standard__c = false;
            aiaben.Benefit_Custom__c = false;
            //checking if any of the value is customized. 
            if(aiaben.IN_3Month_DedCarryover_Customized__c  == true || aiaben.OON_3Month_DedCarryover_Customized__c  == true || aiaben.OON_Coinsurance_Customized__c  == true
              || aiaben.OON_Copay_Max_Payment_Customized__c  == true  || aiaben.OON_Copay_Min_Payment_Customized__c  == true  || aiaben.OON_Copay_Type_1_Amount_Customized__c  == true
              || aiaben.OON_Copay_Type_1_Deductible_Customized__c  == true  || aiaben.OON_Copay_Type_1_IsCovered_Customized__c  == true  || aiaben.OON_Copay_Type_2_Customized__c  == true
              || aiaben.OON_Cost_Share_Customized__c  == true  || aiaben.OON_Tier_Type_Customized__c  == true  || aiaben.Tier_Type_Customized__c  == true
              || aiaben.CoInsurance_Customized__c  == true  || aiaben.Copay_Max_Payment_Customized__c  == true  || aiaben.Copay_Min_Payment_Customized__c  == true
              || aiaben.Copay_Type_1_Amount_Customized__c  == true  || aiaben.Copay_Type_1_Deductible_Customized__c  == true || aiaben.Copay_Type_1_IsCovered_Customized__c  == true
              || aiaben.Copay_Type_2_Amount_Customized__c  == true || aiaben.Cost_Share_Customized__c  == true || aiaben.Allowed_Amount_Customized__c == true || aiaben.Discount_Amount_Customized__c == true
              || aiaben.ScheduledAmounts_Customized__c == true || aiaben.OON_Allowed_Amount_Customized__c == true || aiaben.OON_Discount_Amount_Customized__c == true 
              || aiaben.OON_ScheduledAmounts_Customized__c == true || aiaben.Discount_Amount_Percent_Customized__c == true || aiaben.OON_Discount_Amount_Percent_Customized__c == true
              || aiaben.DentalOONAnnualMaximumApplies_Customized__c == true || aiaben.Dental_AnnualMaximumApplies_Customized__c == true || aiaben.Dental_CoInsurance_Customized__c == true
              || aiaben.Dental_DeductibleApplies_Customized__c ==  true || aiaben.Dental_IsCovered_Customized__c == true || aiaben.Dental_OON_CoInsurance_Customized__c == true || aiaben.Dental_OON_DeductibleApplies_Customized__c == true
              || aiaben.Dental_OON_IsCovered_Customized__c == true || aiaben.Discount_Applies_customized__c == true || aiaben.OON_Discount_Applies_Customized__c == true || aiaben.CommentCode_NonStandard__c == true)
            {
                aiaben.Benefit_Non_Standard__c = true;
            }
            boolean isOutofRange = false;
            if(!validateCopayValues(aiaben.Copay_Type_1_High__c,aiaben.Copay_Type_1_Low__c,aiaben.Copay_Type_1_Increment__c,aiaben.Copay_Type_1_Additional_Increments__c,aiaben.Copay_Type_1_AdditionalInvalidIncrements__c,aiaben.Copay_Type_1_AmountValueSelected__c)){ isOutofRange = true; //code coverage
            }
            if(!validateCopayValues(aiaben.Copay_Type_2_High__c,aiaben.Copay_Type_2_Low__c,aiaben.Copay_Type_2_Increment__c,aiaben.Copay_Type_2_Additional_Increments__c,aiaben.CopayType2_Additional_InvalidIncrement__c,aiaben.Copay_Type_2_AmountValueSelected__c)){isOutofRange = true;
            }
            if(!validateCopayValues(aiaben.OON_Copay_AmountHigh__c,aiaben.OON_Copay_AmountLow__c,aiaben.OON_Copay2_Increment__c,aiaben.OON_Copay_Additional_Increments__c,aiaben.OON_Copay_Additional_InvalidIncrements__c,aiaben.OON_Copay_Type_1_AmountValueSelected__c)){isOutofRange = true;
            }
            if(!validateCopayValues(aiaben.OON_Copay2_High__c,aiaben.OON_Copay2_Low__c,aiaben.OON_Copay2_Increment__c,aiaben.OON_Copay_Type_2_Additional_Increments__c,aiaben.OON_Copay2Additional_InvalidIncrements__c,aiaben.OON_Copay_Type_2_AmountValueSelected__c)){isOutofRange = true;
            }
            if(!validateCopayValues(aiaben.Cost_Share_High__c,aiaben.Cost_Share_Low__c,aiaben.Cost_Share_Increment__c,aiaben.Cost_Share_AdditionalIncrements__c,aiaben.Cost_Share_InvalidIncrements__c,aiaben.Cost_Share_SelectedAmount__c)){isOutofRange = true;
            }
            if(!validateCopayValues(aiaben.OON_Cost_Share_High__c,aiaben.OON_Cost_Share_Low__c,aiaben.OON_Cost_Share_Increment__c,aiaben.OON_Cost_Share_AdditionalIncrements__c,aiaben.OON_Cost_Share_InvalidIncrements__c,aiaben.OON_Cost_Share_SelectedAmount__c)){isOutofRange = true;
            }
            if(!validateCopayValues(aiaben.Coinsurance_AmountHigh__c,aiaben.Coinsurance_AmountLow__c,aiaben.Coinsurance_AmountIncrement__c,aiaben.Coinsurance_Amount_AddtionalIncrements__c,aiaben.Coinsurance_Amount_InvalidIncrements__c,aiaben.CoInsurance_AmountValueSelected__c)){isOutofRange = true;
            }
            if(!validateCopayValues(aiaben.OON_Coinsurance_AmountHigh__c,aiaben.OON_Coinsurance_AmountLow__c,aiaben.OON_Coinsurance_AmountIncrement__c,aiaben.OON_Coinsurance_AddtionalIncrements__c,aiaben.OON_Coinsurance_InvalidIncrements__c,aiaben.OON_CoInsurance_AmountValueSelected__c)){ isOutofRange = true;
            }
            if(((aiaben.Copay_Type_1_High__c == '' || aiaben.Copay_Type_1_Low__c == '' ) && aiaben.Copay_Type_1_Amount_Customized__c == TRUE)||
                
               (( aiaben.Copay_Type_2_High__c == '' || aiaben.Copay_Type_2_Low__c == '' ) && aiaben.Copay_Type_2_Amount_Customized__c == TRUE)||
                
               (( aiaben.OON_Copay_AmountHigh__c == '' || aiaben.OON_Copay_AmountLow__c == '' ) && aiaben.OON_Copay_Type_1_Amount_Customized__c == TRUE)||
                
               (( aiaben.OON_Copay2_High__c == '' || aiaben.OON_Copay2_Low__c == '') && aiaben.OON_Copay_Type_2_Customized__c == TRUE) ||
                
               (( aiaben.Cost_Share_High__c == '' || aiaben.Cost_Share_Low__c == '') && aiaben.Cost_Share_Customized__c == TRUE) ||
                
               (( aiaben.OON_Cost_Share_High__c == '' || aiaben.OON_Cost_Share_Low__c == '') && aiaben.OON_Cost_Share_Customized__c == TRUE) ||
                
               (( aiaben.Coinsurance_AmountLow__c == '' || aiaben.Coinsurance_AmountHigh__c == '') && aiaben.CoInsurance_Customized__c == TRUE)||
                
               (( aiaben.OON_Coinsurance_AmountLow__c== '' || aiaben.OON_Coinsurance_AmountHigh__c== '') && aiaben.OON_Coinsurance_Customized__c == TRUE) || aiaben.CommentCode_Custom__c == true){isOutofRange = true;
            }
            
            //T03 changes: check if the field ranges are NA, if so then make product type as Non Standard if none of custom conditions are satisfied
            if(((aiaben.Copay_Type_1_High__c == 'NA' || aiaben.Copay_Type_1_Low__c == 'NA') && (aiaben.Copay_Type_1_Increment__c == '' || aiaben.Copay_Type_1_Increment__c == 'NA' || aiaben.Copay_Type_1_Increment__c != 'NA') && aiaben.Copay_Type_1_Amount_Customized__c == TRUE)||
                
               (( aiaben.Copay_Type_2_High__c == 'NA' || aiaben.Copay_Type_2_Low__c == 'NA') && (aiaben.Copay_Type_2_Increment__c == '' || aiaben.Copay_Type_2_Increment__c == 'NA'|| aiaben.Copay_Type_2_Increment__c != 'NA')&& aiaben.Copay_Type_2_Amount_Customized__c == TRUE)||
                
               (( aiaben.OON_Copay_AmountHigh__c == 'NA' || aiaben.OON_Copay_AmountLow__c == 'NA') && (aiaben.OON_Copay_AmountIncrement__c == '' || aiaben.OON_Copay_AmountIncrement__c == 'NA' || aiaben.OON_Copay_AmountIncrement__c != 'NA') && aiaben.OON_Copay_Type_1_Amount_Customized__c == TRUE)||
                
               (( aiaben.OON_Copay2_High__c == 'NA' || aiaben.OON_Copay2_Low__c == 'NA') && (aiaben.OON_Copay2_Increment__c == '' || aiaben.OON_Copay2_Increment__c == 'NA' || aiaben.OON_Copay2_Increment__c != 'NA') && aiaben.OON_Copay_Type_2_Customized__c == TRUE) ||
                
               (( aiaben.Cost_Share_High__c == 'NA' || aiaben.Cost_Share_Low__c == 'NA') && (aiaben.Cost_Share_Increment__c == '' || aiaben.Cost_Share_Increment__c == 'NA' || aiaben.Cost_Share_Increment__c != 'NA') && aiaben.Cost_Share_Customized__c == TRUE) ||
                
               (( aiaben.OON_Cost_Share_High__c == 'NA' || aiaben.OON_Cost_Share_Low__c == 'NA') && (aiaben.OON_Cost_Share_Increment__c == '' || aiaben.OON_Cost_Share_Increment__c == 'NA' || aiaben.OON_Cost_Share_Increment__c != 'NA') && aiaben.OON_Cost_Share_Customized__c == TRUE) ||
                
               (( aiaben.Coinsurance_AmountLow__c == 'NA' || aiaben.Coinsurance_AmountHigh__c == 'NA') && (aiaben.Coinsurance_AmountIncrement__c == '' || aiaben.Coinsurance_AmountIncrement__c == 'NA' || aiaben.Coinsurance_AmountIncrement__c != 'NA') && aiaben.CoInsurance_Customized__c == TRUE)||
                
               (( aiaben.OON_Coinsurance_AmountLow__c== 'NA' || aiaben.OON_Coinsurance_AmountHigh__c== 'NA') && (aiaben.OON_Coinsurance_AmountIncrement__c== '' || aiaben.OON_Coinsurance_AmountIncrement__c== 'NA' || aiaben.OON_Coinsurance_AmountIncrement__c!= 'NA') && aiaben.OON_Coinsurance_Customized__c == TRUE)|| aiaben.CommentCode_NonStandard__c == true){aiaben.Benefit_Non_Standard__c = true;
            }
            
            //T03 changes ends
            
            if(isOutofRange == true){aiaben.Benefit_Custom__c = true;
            }
            if(aiaben.Additional_Benefit__c == True || aiaben.additional_limitation__c == true)
            {
                aiaben.Benefit_Non_Standard__c = true;
                aiaben.Benefit_Custom__c = true;
               
            }
           
          //capturing Proposed_Product && Benefit Design Product ID.  
           ppid = aiaben.PPid__c;
           bdpid = aiaben.BDPid__c;
           Grouperids.add(aiaben.grouper__c);
           BenList.add(aiaben);
        }
        
        List<AIA_Grouper__c> AIAGrpList = New List<AIA_Grouper__c>();
        List<AIA_Grouper__c> AIAGrpListFinal = New List<AIA_Grouper__c>();
        String QS1 = querybase2.getSobjectAllFieldsSOQL('AIA_Grouper__c','id IN :Grouperids');
        AIAGrpList = Database.query(QS1);
        system.debug('@@@GrpList@@@'+AIAGrpList);
        
         for(AIA_Benefits__c aiaben2: BenList){
            //if(custom == false){
                if(aiaben2.Benefit_Custom__c == True){
                    custom = True;
                }
            //}
            //if(NonStandard == false){
                if(aiaben2.Benefit_Non_Standard__c == True){
                    NonStandard = True;
                }
            //}
            
        }   
 
        boolean grpcustom = false;
        boolean grpnonstandard = false;
        for(AIA_Grouper__c AIAGrp: AIAGrpList){
            //AIAGrp.Benefit_Custom__c = false;
            //AIAGrp.Benefit_Non_Standard__c = false;
            if(Custom == True){
                AIAGrp.Benefit_Custom__c = True;
                grpcustom = true;
            }
           // else {AIAGrp.Benefit_Custom__c = false;}
            if(NonStandard == True){
                AIAGrp.Benefit_Non_Standard__c = True;
                grpnonstandard = true;
            }
           // else{AIAGrp.Benefit_Non_Standard__c = false;}
            
            AIAGrpListFinal.add(AIAGrp);
            system.debug('@@@AIAGrpListFinal@@@'+AIAGrpListFinal);
        }
        if(!AIAGrpListFinal.IsEmpty()){
            update AIAGrpListFinal;
            updateppbdp(ppid,bdpid,grpcustom,grpnonstandard);
        }
        
           
    }
    
   
    public static void updateppbdp(string ppid, string bdpid,boolean Custom,boolean NonStandard){
        boolean CustomGrp = Custom;
        boolean NonStandardGrp = NonStandard;
        proposed_products__c updatepp = new proposed_products__c();
        AIA_Benefit_Design_Product__c updatebdp = new AIA_Benefit_Design_Product__c();
        
        list<proposed_products__c> updateppfinal = new list<proposed_products__c>();
        list<AIA_Benefit_Design_Product__c> updatebdpfinal = new list<AIA_Benefit_Design_Product__c>();
        
        //boolean CustomGrp = False;
        //boolean NonStandardGrp = false;
        List<AIA_Grouper__c> GRPList = new List<AIA_Grouper__c>();
        
        
        if(ppid != null && bdpid == null){
            
            GRPList = [select id, benefit_Custom__c, Benefit_Non_Standard__c, Proposed_Products__c, Benefit_Design_Product__c from AIA_Grouper__c where Proposed_Products__c=:ppid];
        }
        if( Bdpid != null){
            GRPList = [select id, benefit_Custom__c, Benefit_Non_Standard__c, Proposed_Products__c, Benefit_Design_Product__c from AIA_Grouper__c where Benefit_Design_Product__c=:bdpid];
        }
        if(!GRPList.IsEmpty()){for(AIA_Grouper__c GRP: GRPList){
            if(GRP.benefit_Custom__c == TRUE && CustomGrp == False){
                CustomGrp = True;
                NonStandardGrp = True;
            }
            if(GRP.Benefit_Non_Standard__c == TRUE && NonStandardGrp == False){
                NonStandardGrp = True;
            }
        }
        
        
        
        if(ppid != null && ppid != '' && (bdpid == null || bdpid == '')){
        updatepp = [select id, name, Custom_New__c from proposed_products__c where id =:ppid Limit 1];
        updatepp.Custom_New__c = '';
        if(customGrp == true){ updatepp.Custom_New__c = 'Custom'; updateppfinal.add(updatepp);}
        else if (customGrp == false && NonStandardGrp == true && updatepp.Custom_New__c != 'Custom'){ updatepp.Custom_New__c = 'Non - Standard'; updateppfinal.add(updatepp);}
        else if (customGrp  == false && NonStandardGrp == false && updatepp.Custom_New__c != 'Custom' && updatepp.Custom_New__c != 'Non - Standard'){ updatepp.Custom_New__c = 'Standard'; updateppfinal.add(updatepp);}
        
    
        } 
        
        //update PP Custom field as criteria matches
        if(!updateppfinal.ISEMPTY()){
            AIA_ProposedProductsHandler.firstRun = true;
            AIA_ProposedProductsHandler.afterInsert = true;
            AIA_ProposedProductsHandler.afterUpdate = true;

            update updateppfinal;
        }
        
        if(bdpid != null && bdpid != ''){
        updatebdp = [select id, name, Custom_New__c from AIA_Benefit_Design_Product__c where id =:bdpid Limit 1];
        updatebdp.Custom_New__c = '';
        if(customGrp == true){ updatebdp.Custom_New__c = 'Custom'; updatebdpfinal.add(updatebdp);}
        else if (customGrp == false && NonStandardGrp == true){ updatebdp.Custom_New__c = 'Non - Standard'; updatebdpfinal.add(updatebdp);}
        else if (customGrp == false && NonStandardGrp == false){ updatebdp.Custom_New__c = 'Standard'; updatebdpfinal.add(updatebdp);}
        
     
        }
        
        //update BDP Custom field as criteria matches
        if(!updatebdpfinal.ISEMPTY()){update updatebdpfinal;}
      }
    }
       
    public static boolean validateCopayValues(string high,string low,string increment,string additionalincrement,string invalidincrement,string currentvalue)
    {
    //Validate the High, Low, Increment, AddIncrement, InvalidIncrement.
    system.debug('**high'+high); 
        system.debug('**low'+low);
        system.debug('**increment'+increment);
        system.debug('**additionalincrement'+additionalincrement);
        system.debug('**currentvalue'+currentvalue);
        if(currentvalue != '' && currentvalue != 'NA' && currentvalue != null)
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
            if(high==null || high=='')
                return true;
          
           if(Integer.valueOf(currentvalue) <= Integer.valueOf(high)) {
                system.debug('Entered==Step4==' + (Integer.valueOf(currentvalue) <= Integer.valueOf(high)));
                if(low==null || low=='')
                    return true;
                if(Integer.valueOf(currentvalue) < Integer.valueOf(low)) {
                    system.debug('Entered==Step5==' + (Integer.valueOf(currentvalue) < Integer.valueOf(low)));
                    
                    return false;
                }
                else {                                                         
                    
                    system.debug('Integer.valueOf(currentvalue)==' + Integer.valueOf(currentvalue));
                    system.debug('increment==' + increment);
                    
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
                               
                                if(setinvalidincrement.contains(currentvalue))
                                {
                                    system.debug('Entered==Step9==' + setinvalidincrement);                                   
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
                            return false;
                        }
                    }                   
                }                              
            }
            
            else
            {
                system.debug('Entered==Step11==' + 'False');
                if(!(High == 'NA' || Low == 'NA' || Increment == 'NA')){             
                return false;
                }
            } 
        }
        }
      return true;
    }
    
    private static boolean isMultipleofActual (integer currentvalue,Integer Increment)
    {
      //checking if the selected value is a Increment or Out od range
        while ( currentvalue > 0 )
            currentvalue = currentvalue - Increment;
        
        system.debug('isMultipleofActual==currentvalue==' + currentvalue);
        system.debug('isMultipleofActual==Increment==' + Increment);
        if ( currentvalue == 0 )
            return true;
        
        return false;
    }


    
    //This method is called from BenefitTriggerHandler to update values to Drug PP when there is change in related Medical PP cost share 
    //fields depending upon Rx Integration and Rx OOP MAX Integration on Medical PP.
    public static void drugBenefitUpdate(List<AIA_Benefits__c> newlstBenefits,map<Id,AIA_Benefits__c> oldBenftMap){
        Map<Id,AIA_Benefits__c> medicalBenefitMap = new Map<Id,AIA_Benefits__c>([Select Id,Benefit_Name__c,Cost_Share_SelectedAmount__c,Grouper__r.Group_Type__c,Grouper__r.Proposed_Products__c,Grouper__r.Proposed_Products__r.Product_Category__c, Grouper__r.Proposed_Products__r.Integrated_Non_Integrated__c,Grouper__r.Proposed_Products__r.RX_OOP_Max_Integration__c from AIA_Benefits__c where id in: newlstBenefits and Grouper__r.Group_Type__c ='Cost Share Group']); //T01
        //Set<ID> relatedMedicalPPset = new Set<ID>();
        Map<Id,AIA_Benefits__c> medicalBenefitPPMap = new Map<Id,AIA_Benefits__c>();
        String FOOP_Cost_Share_SelectedAmount = '';
        String IOOP_Cost_Share_SelectedAmount = '';
        String FD_Cost_Share_SelectedAmount = '';
        String ID_Cost_Share_SelectedAmount = '';
        for(AIA_Benefits__c benft : newlstBenefits){
            AIA_Benefits__c medicalBenift = (AIA_Benefits__c)medicalBenefitMap.get(benft.id);
            
            if(benft.Benefit_Name__c == 'Family Out Of Pocket' && (oldBenftMap.get(benft.id).Cost_Share_SelectedAmount__c != benft.Cost_Share_SelectedAmount__c)){
                    FOOP_Cost_Share_SelectedAmount = benft.Cost_Share_SelectedAmount__c;
                }else if(benft.Benefit_Name__c == 'Individual Out Of Pocket' && (oldBenftMap.get(benft.id).Cost_Share_SelectedAmount__c != benft.Cost_Share_SelectedAmount__c)){
                    IOOP_Cost_Share_SelectedAmount = benft.Cost_Share_SelectedAmount__c;
                }else if(benft.Benefit_Name__c == 'Family Deductible' && (oldBenftMap.get(benft.id).Cost_Share_SelectedAmount__c != benft.Cost_Share_SelectedAmount__c)){
                    FD_Cost_Share_SelectedAmount = benft.Cost_Share_SelectedAmount__c;
                }else if(benft.Benefit_Name__c == 'Individual Deductible' && (oldBenftMap.get(benft.id).Cost_Share_SelectedAmount__c != benft.Cost_Share_SelectedAmount__c)){
                    ID_Cost_Share_SelectedAmount = benft.Cost_Share_SelectedAmount__c;
                }           

            if(medicalBenift!=null){ //T01
                if(medicalBenift.Grouper__r!=null){             //T01
                    if(!medicalBenefitPPMap.containsKey(medicalBenift.Grouper__r.Proposed_Products__c))
                    medicalBenefitPPMap.put(medicalBenift.Grouper__r.Proposed_Products__c,medicalBenift);               
                }
            }
            
        }
        system.debug('+++++++++++medicalBenefitPPMap++++++'+medicalBenefitPPMap); 
        //Map<Id,AIA_Benefits__c> drugBenefitMap = new Map<Id,AIA_Benefits__c> ([Select Id,Benefit_Name__c,Cost_Share_SelectedAmount__c,Grouper__r.Group_Type__c,Grouper__r.Proposed_Products__c,Grouper__r.Proposed_Products__r.Product_Category__c, Grouper__r.Proposed_Products__r.Integrated_Non_Integrated__c,Grouper__r.Proposed_Products__r.RX_OOP_Max_Integration__c from AIA_Benefits__c where Grouper__r.Proposed_Products__r.Related_Medical_Product__c in: medicalBenefitPPMap.keySet()]);
        List<AIA_Benefits__c> drugBenefitList = [Select Id,Benefit_Name__c,Cost_Share_SelectedAmount__c,Grouper__r.Group_Type__c,Grouper__r.Proposed_Products__c,Grouper__r.Proposed_Products__r.Product_Category__c,Grouper__r.Proposed_Products__r.Related_Medical_Product__c, Grouper__r.Proposed_Products__r.Integrated_Non_Integrated__c,Grouper__r.Proposed_Products__r.RX_OOP_Max_Integration__c from AIA_Benefits__c where Grouper__r.Proposed_Products__r.Product_Category__c = 'Drug' and Grouper__r.Group_Type__c = 'Cost Share Group' and Grouper__r.Proposed_Products__r.Related_Medical_Product__c in: medicalBenefitPPMap.keySet()];
        system.debug('+++++++++++drugBenefitList++++++'+drugBenefitList); 
        for(AIA_Benefits__c drugBnft : drugBenefitList){
            AIA_Benefits__c medicalBeniftPP = (AIA_Benefits__c)medicalBenefitPPMap.get(drugBnft.Grouper__r.Proposed_Products__r.Related_Medical_Product__c);
            system.debug('+++++++++++medicalBeniftPP++++++'+medicalBeniftPP); 
          //  if(medicalBeniftPP.Grouper__r.Group_Type__c == 'Cost Share Group' )
          {
                system.debug('+++++++++++medicalBeniftPP.Grouper__r.Proposed_Products__r.Integrated_Non_Integrated__c ++++++'+medicalBeniftPP.Grouper__r.Proposed_Products__r.Integrated_Non_Integrated__c);            
                if(medicalBeniftPP.Grouper__r.Proposed_Products__r.Integrated_Non_Integrated__c == 'Integrated' && medicalBeniftPP.Grouper__r.Proposed_Products__r.RX_OOP_Max_Integration__c == 'Integrated'){
                    system.debug('+++++++++++medicalBeniftPP.Benefit_Name__c++++++'+medicalBeniftPP.Benefit_Name__c); 
                    if(drugBnft.Benefit_Name__c == 'Family Out Of Pocket' && FOOP_Cost_Share_SelectedAmount != ''){
                        drugBnft.Cost_Share_SelectedAmount__c = FOOP_Cost_Share_SelectedAmount ;
                    }
                    if(drugBnft.Benefit_Name__c == 'Individual Out Of Pocket' && IOOP_Cost_Share_SelectedAmount != ''){
                        drugBnft.Cost_Share_SelectedAmount__c = IOOP_Cost_Share_SelectedAmount;
                    }
                    if(drugBnft.Benefit_Name__c == 'Family Deductible' && FD_Cost_Share_SelectedAmount != ''){
                        drugBnft.Cost_Share_SelectedAmount__c = FD_Cost_Share_SelectedAmount;
                    }
                    if(drugBnft.Benefit_Name__c == 'Individual Deductible' && ID_Cost_Share_SelectedAmount != ''){
                        drugBnft.Cost_Share_SelectedAmount__c = ID_Cost_Share_SelectedAmount;
                    }
                }else if(medicalBeniftPP.Grouper__r.Proposed_Products__r.Integrated_Non_Integrated__c == 'Non-Integrated' && medicalBeniftPP.Grouper__r.Proposed_Products__r.RX_OOP_Max_Integration__c == 'Integrated'){
                    system.debug('+++++++++++Else medicalBeniftPP.Benefit_Name__c++++++'+medicalBeniftPP.Benefit_Name__c); 
                    if(drugBnft.Benefit_Name__c == 'Family Out Of Pocket' && FOOP_Cost_Share_SelectedAmount != ''){
                        drugBnft.Cost_Share_SelectedAmount__c = FOOP_Cost_Share_SelectedAmount ;
                    }
                    if(drugBnft.Benefit_Name__c == 'Individual Out Of Pocket' && IOOP_Cost_Share_SelectedAmount != ''){
                        drugBnft.Cost_Share_SelectedAmount__c = IOOP_Cost_Share_SelectedAmount;
                    }                                
                }
            }
        }   
        if(drugBenefitList.size()>0)
                upsert drugBenefitList;        
    }
    
    
}