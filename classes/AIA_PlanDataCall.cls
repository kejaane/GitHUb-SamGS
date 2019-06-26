/*=========================================================================================
 * Date     : 10/01/2016
 * Developer    : Satya PhaniTirumalasetti
 * Purpose      : to get has benfit summary value from Plan to  check for validation in detail button click.
 *               
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/01/2016|  Satya phani Tirumalasetti | Initial Version                                         
 *           |        | 
 *===========+============+================================================================
 */
global class AIA_PlanDataCall { 
  webService static Boolean getPlanDetails(String planId) {
        if(!String.isBlank(planId)){
            AIA_Plan__c plndata = [select id, Has_Benefit_Summary__c from AIA_Plan__c where id = :planId Limit 1];
            return plndata.Has_Benefit_Summary__c; 
        }else{
            return false;
        }   
    }
}