/*===========================================================================================================
 * Date         : 05/04/2017
 * Developer    : Goutham Rapolu
 * Purpose      : Primarily to call AIA_ProposedProd_Summary VF page.
 *===========================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer     Tag   Description
 *===========================================================================================================
 * 1/17/2018    satya         T01   Added as a part of lightning migration, since javascript in buttons is 
 *                                  not supported in lightning.
 *===========================================================================================================
 */
 public class AIA_BRF_GetBenefits_Controller {   

    public Boolean displayPopup {get; set;}
    @testvisible public string bdpid{get;set;}
    public Proposed_Products__c bdp{get;set;}
    public Boolean show {get; set;}
    //constructor
    public AIA_BRF_GetBenefits_Controller(apexPages.StandardController controller){
      // RedirectToSumaryPage();
      displayPopup = true;
      
     bdpid = ApexPages.currentPage().getParameters().get('id');
    
    bdp = new Proposed_Products__c();
    String QueryStr=QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Proposed_Products__c','Id=:bdpid Limit 1','Benefit_Request_Form__r.status__c,Benefit_Request_Form__r.ARC_Approval_Status__c,Benefit_Request_Form__r.Jurisdiction__c,Plan_Name__r.QA_Complete__c, ');
   
    bdp = database.query(QueryStr);
    
    //T01 Changes start
    show = AIA_PlanDataCall.getPlanDetails(bdp.Plan_Name__c);
    
    if(!show){
    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Benefits not available for this plan in PCS'));
    }
     //T01 changes Ends 
    }
    
    
    //T01--Start--Method to check whether the user is in Classic or lightning
    public Boolean getIsClassic() {
    return (UserInfo.getUiThemeDisplayed() == 'Theme3');
    }
    //T01--End
    
    public pageReference RedirectToSumaryPage(){
         
      
     system.debug('GETBENEFITS==='+bdp.has_benefit_details__c+bdp.Plan_Name__r.QA_Complete__c+bdp.Benefit_Request_Form__r.status__c+bdp.Benefit_Request_Form__r.ARC_Approval_Status__c);
     system.debug(Logginglevel.INFO,'GETBENEFITS==='+bdp.has_benefit_details__c+bdp.Plan_Name__r.QA_Complete__c+bdp.Benefit_Request_Form__r.status__c+bdp.Benefit_Request_Form__r.ARC_Approval_Status__c);
     
    if(bdp.has_benefit_details__c == False && bdp.Plan_Name__r.QA_Complete__c == True && bdp.Benefit_Request_Form__r.status__c != 'Sold' && ((!string.IsBlank(bdp.Benefit_Request_Form__r.ARC_Approval_Status__c)) || bdp.Benefit_Request_Form__r.ARC_Approval_Status__c != null)){
        ApexPages.StandardController con2 = new ApexPages.StandardController(bdp);
        AIA_Benefit_SummaryController ext2 = new AIA_Benefit_SummaryController(con2);
    
        ext2.SaveAndContinuePlanBenefits(bdp);
        ext2.DentalBenupdate(bdp);
    } 
         system.debug('GETBENEFITS222==='+bdp.has_benefit_details__c+bdp.Plan_Name__r.QA_Complete__c+bdp.Benefit_Request_Form__r.status__c+bdp.Benefit_Request_Form__r.ARC_Approval_Status__c);
         system.debug(Logginglevel.INFO,'GETBENEFITS222==='+bdp.has_benefit_details__c+bdp.Plan_Name__r.QA_Complete__c+bdp.Benefit_Request_Form__r.status__c+bdp.Benefit_Request_Form__r.ARC_Approval_Status__c);

        pageReference pgRef = new pageReference('/apex/AIA_ProposedProd_Summary');
        
         //pgRef.getParameters().put('planId',pp.Plan_Name__c);        
        system.debug('Id===' + ApexPages.currentPage().getParameters().get('id')); 
         pgRef.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
         pgRef.setRedirect(true);
        return pgRef;//pgRef;
    
    }
    }