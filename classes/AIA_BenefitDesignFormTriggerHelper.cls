/*=============================================================================================================
 * Date         : 03/02/2018
 * Developer    : Phanishankar P
 * Purpose      : Helper class for AIA_BenefitDesignFormTriggerHandler which makes corresponding medical BDPs available 
 * 				  for new BDF creation, if existing BDF is deleted         
 *=============================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date        | Developer   | Tag  | Description
 *=============+=============+==================================================================================
 * 03/02/2018  | Phani       |      | Initial Version        
 * 04/02/2018  | Phani		 |	T01	| Added code to make some BDP fields blank before deletion of 
 * 									  corresponding BDF(DEFECT:38925)
 * 04/11/2018  | Raviteja	 |	T02	| Method to revert all bdp values to none on clicking cancel on mcp form
 *=============+=============+==================================================================================
 */
public class AIA_BenefitDesignFormTriggerHelper {
    
    public static void updateBdpStatus(){
        List<AIA_Benefit_Design_Product__c> bdpList = new List<AIA_Benefit_Design_Product__c>();
   		bdpList = [ SELECT ID,SelectBDP__c 
                   FROM AIA_Benefit_Design_Product__c 
                   WHERE Benefit_Design_Form__c IN :Trigger.oldMap.keySet() AND Product_Category__c ='Medical' ];
         for(AIA_Benefit_Design_Product__c bdp : bdpList){
             bdp.SelectBDP__c = false; 
             //T01 --Start
             bdp.AIA_INN_Contracted_Provider_Penalty__c = '';
 			 bdp.Fully_Insured__c='';
 			 bdp.AIA_Percent_and_Dollar_Penalty__c='';
             bdp.AIA_Dollar_Penalty__c=NULL;
             bdp.Percentage_and_Dollar_Penalty_Other_Nons__c='';
             bdp.AIA_Percent_Penalty__c='';
             bdp.AIA_Up_to__c=NULL;
             bdp.Percentage_Penalty_Other_Nonstandard__c='';
             bdp.AIA_Magellan_Behavioral_Health__c='';
             //T01 --End
         }
     update bdpList;    
    }
    //T02	-	start
    //method to revert all bdp values to none on clicking cancel on mcp form
    public static void updateBdpStatusfromCancel(id bdid){
        List<AIA_Benefit_Design_Product__c> bdpList = new List<AIA_Benefit_Design_Product__c>();
   		bdpList = [select id, name, SelectBDP__c, AIA_Magellan_Behavioral_Health__c, AIA_INN_Contracted_Provider_Penalty__c,
            Fully_Insured__c, AIA_Percent_and_Dollar_Penalty__c, AIA_Dollar_Penalty__c, 
            Percentage_and_Dollar_Penalty_Other_Nons__c, AIA_Percent_Penalty__c, AIA_Up_to__c,
            Percentage_Penalty_Other_Nonstandard__c,Plan_Product_Name__c, Benefit_Design_Form__c 
                   from AIA_Benefit_Design_Product__c 
                   where Benefit_Design__c= :bdid
           		   AND Product_Category__c ='Medical'] ; 
         for(AIA_Benefit_Design_Product__c bdp : bdpList){
             bdp.SelectBDP__c = false; 
             //T01 --Start
             bdp.AIA_INN_Contracted_Provider_Penalty__c = '';
 			 bdp.Fully_Insured__c='';
 			 bdp.AIA_Percent_and_Dollar_Penalty__c='';
             bdp.AIA_Dollar_Penalty__c=NULL;
             bdp.Percentage_and_Dollar_Penalty_Other_Nons__c='';
             bdp.AIA_Percent_Penalty__c='';
             bdp.AIA_Up_to__c=NULL;
             bdp.Percentage_Penalty_Other_Nonstandard__c='';
             bdp.AIA_Magellan_Behavioral_Health__c='';
             //T01 --End
         }
     update bdpList;    
    }
	//T02	-	End
}