/*=================================================================================================
* Date         : 10/17/2017
* Developer    : Raviteja
* Purpose      : This class to add multiple line items functionality for Facet class object.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 10/17/2017| Raviteja   |     | Initial Version                                         
* 11/01/2017| Rajesh     |T01  | Auto populate effective date from Benefit Request Form if status of BRF is "NEW".
* 02/09/2018| Raviteja   | T02 | Added SLDS changes
* 02/22/2018| Debkanti	 | T03 | Add refresh method to reset the page after adding the records.
*===========+============+=====+===================================================================
*/
public class AIA_GSM_MultipleFacetAdd {
    public List<AIA_FACET_Class__c> facets {get; set;}
    private final AIA_Group_Structure_Request_Form__c parGrp;
    public Id gsrfid {get;set;}
    public Integer rowToRemove {get;set;}
    public Integer multipleRowsize {get;set;}
    //T01 - Start//
    public AIA_Group_Structure_Request_Form__c gsrfrec = new AIA_Group_Structure_Request_Form__c();
    //T01 - End//
    //T02--Start
    public String msg{get; set;}
    public Boolean displayPopUp{get; set;}
    //T02--End
    public AIA_GSM_MultipleFacetAdd(ApexPages.StandardController myController) {
        //parGrp=(AIA_Group_Structure_Request_Form__c)myController.getrecord();
        gsrfid = apexpages.currentpage().getparameters().get('gsrfid');
        //T01 - Start//
        gsrfrec= [select id,Implementation__r.Benefit_Request_Form__r.Request_Type__c,Implementation__r.Benefit_Request_Form__r.Benefit_Effective_Date__c from AIA_Group_Structure_Request_Form__c where id =: gsrfid];
        //T01 - End//
        facets = new List<AIA_FACET_Class__c>();
        AIA_FACET_Class__c LitFct = new AIA_FACET_Class__c();
        //LitOrd.Group_Structure_Request_Form__c = gsrfid.id;
        LitFct.Group_Structure_Request_Form__c = gsrfid;
        //T01 - Start//
        if(gsrfrec.Implementation__r.Benefit_Request_Form__r.Request_Type__c == 'Prospect/New'){
            LitFct.Effective_new_Date__c = gsrfrec.Implementation__r.Benefit_Request_Form__r.Benefit_Effective_Date__c;
        }
        else{
            LitFct.Effective_new_Date__c = null;
        }
        //T01 - End//
        facets.add(LitFct);}
    //method to create multiple rows at once based on input
    public void multipleRows(){
        for(integer i=0;i<multipleRowsize;i++){
            addrow();
        }
    }
    //This method to add row in the line items
    public void addrow() {
        AIA_FACET_Class__c LitFct = new AIA_FACET_Class__c();
        //LitOrd.Group_Structure_Request_Form__c = gsrfid.id;
        LitFct.Group_Structure_Request_Form__c = gsrfid;
        //T01 - Start//
        if(gsrfrec.Implementation__r.Benefit_Request_Form__r.Request_Type__c == 'Prospect/New'){
            LitFct.Effective_new_Date__c = gsrfrec.Implementation__r.Benefit_Request_Form__r.Benefit_Effective_Date__c;
        }
        else{
            LitFct.Effective_new_Date__c = null;
        }
        //T01 - End//
        facets.add(LitFct);}
    
    //This method to remove row in the line items
    public void removerow(){
        Integer i = facets.size();
        if(i>1){
            facets.remove(i-1);}
    }
    public void removeRowFromList(){
        //system.debug('Tesr: '+rowToRemove);
        Integer i = facets.size();
        if(i>1){
            facets.remove(rowToRemove-1);
        }
    }
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    //This method to save records in the line items
    public PageReference save() {
        try{
            insert facets;
            //T02--Start
            if(!getIsClassic() || Test.isRunningTest())
            {
                msg = facets.size()+' Record(s) Saved';
            	displayPopUp = true;
                return null;
            }
            //T02--End
        }
        catch(exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(msg);
            return null;
        }
        //system.debug('gsrfId: '+gsrfid);
        PageReference home = new PageReference('/'+ gsrfid);
        home.setRedirect(true);
        return home; }
    public PageReference cancel() {
       // system.debug('gsrfId1: '+gsrfid);
        PageReference home = new PageReference('/'+ gsrfid);
        home.setRedirect(true);
        return home;
    }
     /* T03 Start */
     public PageReference refresh() {
        PageReference home = new PageReference(ApexPages.currentPage().getUrl());
        home.setRedirect(true);
        return home;
    }
    /* T03 End */
}