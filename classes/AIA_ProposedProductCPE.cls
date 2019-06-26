/*=================================================================================================
* Date         : 2/07/2018
* Developer    : Raviteja
* Purpose      : This class function is to auto-populate the BRF,Fundingarrangement,Account,Product category values.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 2/07/2018| Raviteja    |     | Initial Version                                         
*
*===========+============+=====+===================================================================
*/
public with Sharing class AIA_ProposedProductCPE {
    public Proposed_Products__c rec{get;set;}
    public Id recid;
    public Id brfid;
    public Id accid;
    public String fundingArrangement; 
    public AIA_ProposedProductCPE(ApexPages.StandardController controller) {
        
        rec = new Proposed_Products__c();
        //get all the parameters passed to the VF page
        recid = apexpages.currentpage().getparameters().get(AIA_Constants.RecordType);
        brfid = apexpages.currentpage().getparameters().get(AIA_Constants.brfid);
        accid = apexpages.currentpage().getparameters().get(AIA_Constants.accid);
        fundingArrangement = apexpages.currentpage().getparameters().get(AIA_Constants.fundingArrangement);
        rec = (Proposed_Products__c)controller.getRecord();
        //Auto populate the values on the VF page
        rec.RecordTypeId = recid;
        rec.Benefit_Request_Form__c=brfid;
        if(fundingArrangement!=AIA_Constants.fundingArrangementBoth && fundingArrangement!=AIA_Constants.fundingArrangementOther){
        rec.Funding_Arrangement__c=fundingArrangement;
        }
        rec.BRF_Account__c=accid;
    }
    public pagereference cancel(){
        //To redirect to the page from which it is opened
        PageReference pg=new PageReference('/apex/AIA_ProductSearchFiltering');
        pg.getParameters().put('brfId',brfId);
        pg.setRedirect(true);
        return pg;
        
    }
    
}