/*===========================================================================================================
 * Date         : 05/04/2017
 * Developer    : Goutham Rapolu
 * Purpose      : Primarily to call AIA_BenefitDesign_Summary VF page.
 *===========================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date          Developer     Tag       Description
 *===========================================================================================================
 * 2/2/2018    | satya       | T01   |   Changes made as a part of US651. Checking the conditions before 
 *                                       redirecting to summary page. Moving the logic from JS button
 *                                       to controller.
 *==========================================================================================================
 */
 public class AIA_BD_GetBenefits_Controller {   

     public Boolean displayPopup {get; set;}
     @testvisible public string bdpid{get;set;}
     public AIA_Benefit_Design_Product__c bdp{get;set;}
     public Boolean show {get; set;}
     public boolean isClassic {get;set;}
    //constructor
    public AIA_BD_GetBenefits_Controller(apexPages.StandardController controller){
      // RedirectToSumaryPage();
      displayPopup = true;
      isClassic = AIA_Utils.isClassic();
         
    }
    
    //T01 changes start
    //method to check if there are any validation errors on the page before redirecting to get benefits
    public PageReference updateBDP(){
   show = false;
   
   //get the ID
   bdpid = ApexPages.currentPage().getParameters().get('id');
    
    //get the BDP record with certain wehre clause conditions
    bdp = new AIA_Benefit_Design_Product__c();
    string QueryStr = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('AIA_Benefit_Design_Product__c','Id=:bdpid Limit 1','Plan_Name__r.QA_Complete__c, ');
    bdp = database.query(QueryStr);
    
    //Try to update the bdp validation flag
         if(bdp.BDP_validations_flag__c == false) {
            bdp.BDP_validations_flag__c = true;
            
         }else if(bdp.BDP_validations_flag__c == true) {
            bdp.BDP_validations_flag__c = false;
            
         }
            //update the BDP record
            Database.SaveResult sr = Database.update(bdp);
            
           // Iterate through result and check if it is success or not
              if (sr.isSuccess()) {
                    show = true;
                }else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                         ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info, err.getMessage())); 
                    }
                }
                
            
        return null;
    }
    //T01 ends
    
    
    public pageReference RedirectToSumaryPage(){
   
    bdpid = ApexPages.currentPage().getParameters().get('id');
    bdp = new AIA_Benefit_Design_Product__c();
    string QueryStr = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('AIA_Benefit_Design_Product__c','Id=:bdpid Limit 1','Plan_Name__r.QA_Complete__c, ');
    bdp = database.query(QueryStr);
                   
    ApexPages.StandardController con2 = new ApexPages.StandardController(bdp);
    AIA_BenefitDesign_SummaryController ext2 = new AIA_BenefitDesign_SummaryController(con2);
         
    if(bdp.Plan_Name__r.QA_Complete__c == true && bdp.has_benefit_details__c == False){
        ext2.createWrapListFromPlan(bdp);
        ext2.SaveAndContinuePlanBenefits(bdp);
   
  
   }
    
    pageReference pgRef = new pageReference('/apex/AIA_BenefitDesign_Summary');
    
    system.debug('Id===' + ApexPages.currentPage().getParameters().get('id')); 
    pgRef.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
    pgRef.setRedirect(true);
    return pgRef;
    }
    
  }