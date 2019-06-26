/*********************************************************************************************************  
*  Class            : AIA_GetBenefitRedirection
*  Author           : Debkanti
*  Version History  : 1.0
*  Creation         : 01/25/2018
*  Description      : Class is created to implement the functionality of Page redirection.
**********************************************************************************************************
*  DATE             OWNER          TAG               DESCRIPTION
**********************************************************************************************************
* 01/25/2018 |	 Debkanti		 | T01 |			 Updated the class to add the logic so that each parent object
* 
**********************************************************************************************************/

public class AIA_GetBenefitRedirection {
    
    public String inputText {get; set;}
    public ApexPages.StandardController ctler{get; set;}
    public Boolean displayPopUp{get; set;}
    public String msg{get; set;}
    //Constructor for standared page
    public AIA_GetBenefitRedirection (ApexPages.StandardController controller){
        //inputText = '';
        ctler=controller;
        inputText=ApexPages.currentPage().getParameters().get('id');
        system.debug('Hello'+inputText);
    }
    //Method for redirection based on the benefit
    public PageReference redirect() {
        system.debug('hello1: '+inputText);
        //Inilitizing pagereferance
        PageReference newPage;
        //Instantiating proposed product
        Proposed_Products__c proplan = new Proposed_Products__c();
        //searching proposed product plan name
        proplan =[Select id,Plan_Name__c from Proposed_Products__c where id=:inputText limit 1];
        system.debug('hello2: '+inputText);
        system.debug('hello3: '+proplan);
        //storing in string format
        string planId = proplan.Plan_Name__c;
        System.debug('Hello4: '+planId);
        AIA_PlanDataCall.getPlanDetails(planId);
        system.debug('Hello5: '+AIA_PlanDataCall.getPlanDetails(planId));
        //Checking if benefit is present or not
        if(AIA_PlanDataCall.getPlanDetails(planId)==true){
            //Redirecting to getbenefit page
            newPage = new PageReference('/apex/AIA_ProposedProd_Summary?id='+inputText);
            newPage.setRedirect(true);  
            //return newPage;
        }
        return newPage;
    }
    //If proposed product donot have benfit's
    public PageReference redirectOld() {
        PageReference oldPage;
        //Instantiating proposed product
        Proposed_Products__c proplan = new Proposed_Products__c();
        //searching proposed product plan name
        proplan =[Select id,Plan_Name__c from Proposed_Products__c where id=:inputText limit 1];
        string planId = proplan.Plan_Name__c;
        AIA_PlanDataCall.getPlanDetails(planId);
        //Checking if benefit is present or not
        if(AIA_PlanDataCall.getPlanDetails(planId)==false){
            //Redirecting to proposed product page
            oldPage = new PageReference('/' +inputText);
            oldPage.setRedirect(true); 
        }
        return oldPage;
    }
    
    //For displaying popup
    public void popUp() {
        msg = 'Benefits not available for this plan in PCS';
        displayPopUp = true;
    }
    
}