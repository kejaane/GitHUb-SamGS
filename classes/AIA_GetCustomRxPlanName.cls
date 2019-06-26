/*=================================================================================================================
* Date         : 03/14/2017
* Developer    : Ramakrishna
* Purpose      : This class contains logic to derive custom Rx plan name for Drug products.
*=================================================================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 03/14/2017 | Ramakrishna    | T04 | Initial Version. 
* 2/21/2018  | Satya T        | T05 | Made changes as a part of Defect 38775. Added to accomodate the grouper that 
*                                     are with and without ' - ' in their name
*===========+============+========================================================================================*/
public class AIA_GetCustomRxPlanName {
    String CustRxPlanName;
    public String CustomRxPlanName(String propProdId){
        string a='NC'+'/'+ 'NC' +'/'+ 'NC' +'/'+ 'NC';
        string b='NC'+'/'+ 'NC' +'/'+ 'NC' +'/'+ 'NC';
        string c='NC'+'/'+ 'NC' +'/'+ 'NC' +'/'+ 'NC';
        string d='NC'+'/'+ 'NC' +'/'+ 'NC' +'/'+ 'NC';
        string Indoop = 'NC';
        string Foop = 'NC';
        string IndDed = 'NC';
        string FDed = 'NC';   
        
        Proposed_Products__c ppRec = [select Id,name, Integrated_Deductible_Integrator__c, Integrated_OOP_Integration__c, Plan_Product_Name__c,Product_Parent_Name__c
                                      from Proposed_Products__c 
                                      where Id =:propProdId];
        list<AIA_Grouper__c> grouper = [select Id, name 
                                        from AIA_Grouper__c 
                                        where (Name like '%Retail NonMaintenance%' OR Name like '%Retail Non-Maintenance%') and
                                            Proposed_Products__c =:propProdId and
                                            RecordType.DeveloperName = 'Proposed_Proposed' 
                                        limit 1]; 
        if(grouper.size()>0){                            
            List<AIA_Benefits__c> BenList = [select Id,Benefit_Name__c,Copay_Type_1_AmountValueSelected__c, CoInsurance_AmountValueSelected__c, 
                                                    Copay_Min_Payment__c, Copay_Max_Payment__c,Copay_Type_1_IsCovered__c 
                                             from AIA_Benefits__c 
                                             where Grouper__c =:grouper[0].Id];
            // and RecordType.DeveloperName = 'Proposed_Product'];
            if(BenList!=null && BenList.size()>0){
                for(AIA_Benefits__c Ben : BenList){
                    String copay = checkInvalidValues(Ben.Copay_Type_1_AmountValueSelected__c)?'NC':('$'+Ben.Copay_Type_1_AmountValueSelected__c);
                    String coInsur = checkInvalidValues(Ben.CoInsurance_AmountValueSelected__c)?'NC':(Ben.CoInsurance_AmountValueSelected__c+'%');
                    String copayMin = checkInvalidValues(Ben.Copay_Min_Payment__c)?'NC':('$'+ Ben.Copay_Min_Payment__c + ' ' + 'Min Pay');
                    String copayMax = checkInvalidValues(Ben.Copay_Max_Payment__c)?'NC':('$'+ Ben.Copay_Max_Payment__c + ' ' + 'Max Pay');    
                    
                    //T05 changes start                
                                    
                    if((Ben.Benefit_Name__c == 'Retail NonMaintenance Generic' || Ben.Benefit_Name__c == 'Retail Non-Maintenance Generic') && Ben.Copay_Type_1_IsCovered__c =='Yes'){
                        a = copay + '/' + coInsur + '/' + copayMin + '/' + copayMax ;   
                    }
                    else if((Ben.Benefit_Name__c == 'Retail NonMaintenance Generic' || Ben.Benefit_Name__c == 'Retail Non-Maintenance Generic') && Ben.Copay_Type_1_IsCovered__c =='No')
                        a = 'NC' + '/' + 'NC' + '/' + 'NC' + '/' + 'NC' ; 
                    
                    if((Ben.Benefit_Name__c == 'Retail NonMaintenance NonPreferred Brand' || Ben.Benefit_Name__c == 'Retail Non-Maintenance Non-Preferred Brand') && Ben.Copay_Type_1_IsCovered__c =='Yes'){
                        b = copay + '/' + coInsur + '/' + copayMin + '/' + copayMax;
                    }
                    else if((Ben.Benefit_Name__c == 'Retail NonMaintenance NonPreferred Brand' || Ben.Benefit_Name__c == 'Retail Non-Maintenance Non-Preferred Brand') && Ben.Copay_Type_1_IsCovered__c =='No')
                        b = 'NC' + '/' + 'NC' + '/' + 'NC' + '/' + 'NC' ;
                    
                    if((Ben.Benefit_Name__c == 'Retail NonMaintenance Preferred Brand'|| Ben.Benefit_Name__c == 'Retail Non-Maintenance Preferred Brand') && Ben.Copay_Type_1_IsCovered__c =='Yes'){
                        c = copay + '/' + coInsur + '/' + copayMin + '/' + copayMax;
                    }
                    else if((Ben.Benefit_Name__c == 'Retail NonMaintenance Preferred Brand' || Ben.Benefit_Name__c == 'Retail Non-Maintenance Preferred Brand') && Ben.Copay_Type_1_IsCovered__c =='No')
                        c = 'NC' + '/' + 'NC' + '/' + 'NC' + '/' + 'NC' ;
                    
                    if((Ben.Benefit_Name__c == 'Retail NonMaintenance Self-Injectable' || Ben.Benefit_Name__c == 'Retail Non-Maintenance Self-Injectable') && Ben.Copay_Type_1_IsCovered__c =='Yes'){
                        d = copay + '/' + coInsur + '/' + copayMin + '/' + copayMax;
                    }
                    else if((Ben.Benefit_Name__c == 'Retail NonMaintenance Self-Injectable' || Ben.Benefit_Name__c == 'Retail Non-Maintenance Self-Injectable') && Ben.Copay_Type_1_IsCovered__c =='No')
                        d = 'NC' + '/' + 'NC' + '/' + 'NC' + '/' + 'NC' ;
                }
            }
        } //T05 changes end
        
        List<AIA_Grouper__c> CostSharegrouper = [select Id, name 
                                                 from AIA_Grouper__c 
                                                 where Name = 'CostShareRanges' 
                                                         and Proposed_Products__c =:propProdId
                                                         and RecordType.DeveloperName = 'Proposed_Proposed' limit 1];
        if(CostSharegrouper!=null && CostSharegrouper.size()>0){                                      
            List<AIA_Benefits__c> CostshareBenList = [select Id,Benefit_Name__c,Cost_Share_SelectedAmount__c
                                                      from AIA_Benefits__c 
                                                      where Grouper__c =:CostSharegrouper[0].Id];
            if(CostshareBenList!=null && CostshareBenList.size()>0){                                                     
                for(AIA_Benefits__c CostBen : CostshareBenList){
                    String CostShare =checkInvalidValues(CostBen.Cost_Share_SelectedAmount__c)?'NC':('$'+CostBen.Cost_Share_SelectedAmount__c);                                   
                        
                    if(CostBen.Benefit_Name__c == 'Individual Out Of Pocket'){
                        Indoop = checkInvalidValues(CostBen.Cost_Share_SelectedAmount__c)?'NC':('$'+CostBen.Cost_Share_SelectedAmount__c);  
                    } 
                    if(CostBen.Benefit_Name__c == 'Family Out Of Pocket'){
                        Foop = checkInvalidValues(CostBen.Cost_Share_SelectedAmount__c)?'NC':('$'+CostBen.Cost_Share_SelectedAmount__c);
                    }
                    if(CostBen.Benefit_Name__c == 'Individual Deductible'){
                        IndDed = checkInvalidValues(CostBen.Cost_Share_SelectedAmount__c)?'NC':('$'+CostBen.Cost_Share_SelectedAmount__c);
                    }
                    if(CostBen.Benefit_Name__c == 'Family Deductible'){
                        FDed = checkInvalidValues(CostBen.Cost_Share_SelectedAmount__c)?'NC':('$'+CostBen.Cost_Share_SelectedAmount__c);
                    }   
                }
            }
        }
        
        If(ppRec.Integrated_Deductible_Integrator__c == 'Yes' && ppRec.Integrated_OOP_Integration__c == 'Yes'){   
            if(grouper.size()>0){
                CustRxPlanName = 'Rx' + ' ' + a + ' ' + b + ' ' + c + ' ' + d;
            }
            else
                CustRxPlanName = ppRec.Product_Parent_Name__c; 
        }else
            if(ppRec.Integrated_Deductible_Integrator__c == 'No' && ppRec.Integrated_OOP_Integration__c == 'Yes'){
                if(grouper.size()>0){
                    CustRxPlanName = 'Rx'  + ' ' +  Indoop +'/'+ Foop + ' ' + 'OOP'  + ' ' +  a  + ' ' +  b  + ' ' +  c  + ' ' +  d;
                }else 
                    CustRxPlanName = ppRec.Product_Parent_Name__c;
            }else
                if(ppRec.Integrated_Deductible_Integrator__c == 'No' && ppRec.Integrated_OOP_Integration__c == 'No'){
                    if(grouper.size()>0){
                        CustRxPlanName = 'Rx'  + ' ' +  IndDed +'/'+ FDed + ' ' + 'DED' + ' ' + Indoop +'/'+ Foop + ' ' + 'OOP'  + ' ' +  a  + ' ' +  b  + ' ' +  c  + ' ' +  d;
                    } else 
                        CustRxPlanName = ppRec.Product_Parent_Name__c;
                }  
        return CustRxPlanName;        
    }  
    
    /**Method returns True for Invalid Value and False for Valid Values**/
    public Boolean checkInvalidValues(String selectedValue){
        if(String.isBlank(selectedValue) || selectedValue == 'N/A' || selectedValue == 'NA') {
            return True;
        }
        return False;
    }
    
}