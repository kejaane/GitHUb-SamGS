/*=================================================================================================
* Date         : 2/19/2018
* Developer    : Raviteja
* Purpose      : This class function is to auto-populate the Account,implementation values.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 2/19/2018| Raviteja    |     | Initial Version                                         
* 3/08/2018| Phanishankar| T01 | Minor  changes in constructor 
*===========+============+=====+===================================================================
*/
public with Sharing class AIA_ContractRelatedPage {
    public Contract rec{get;set;}
    public Id impid;
    public Id accid;
    public String fundingArrangement; 
    public AIA_ContractRelatedPage(ApexPages.StandardController controller) {
        
        rec = new Contract();
        //get all the parameters passed to the VF page
        impid = apexpages.currentpage().getparameters().get(AIA_CONSTANTS.IMPID);
        accid = apexpages.currentpage().getparameters().get(AIA_CONSTANTS.IMP_ACCID);
        rec = (Contract)controller.getRecord();
        //Auto populate the values on the VF page
        rec.AccountId = accid;     
        //Query Account Address to push into Contract
        Account acc=[select id,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account where id=:accid];
		system.debug('acc.BillingCountry'+acc.BillingCountry);
        rec.BillingCity=acc.BillingCity;
		rec.BillingStreet=acc.BillingStreet;
		rec.BillingState=acc.BillingState  ;
        rec.BillingCountry=acc.BillingCountry;
        rec.BillingPostalCode=acc.BillingPostalCode;
        rec.Implementation__c=impid;
         //T01-Start
        rec.Status='Draft';
        rec.ownerId=userInfo.getUserId();
        //T01-End
    }
     public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    public pagereference cancel(){
        //To redirect to the page from which it is opened
        PageReference pg=new PageReference('/'+impid);
        pg.setRedirect(true);
        return pg;
        
    }
    
}