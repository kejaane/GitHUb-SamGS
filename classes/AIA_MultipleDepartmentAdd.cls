/*=================================================================================================
* Date         : 10/17/2017
* Developer    : Raviteja
* Purpose      : This class to add multiple line items functionality for Group object.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 10/17/2017| Raviteja   |     | Initial Version                                         
* 11/01/2017| Rajesh     |T01  | Auto populate effective date from Benefit Request Form if status of BRF is "Prospect/New".
* 02/06/2018| Raviteja   | T02 | Added SLDS changes
*02/22/2018	| Debkanti	 | T03 | Add refresh method to reset the page after adding the records.
*===========+============+=====+===================================================================
*/
public class AIA_MultipleDepartmentAdd {
    public List<AIA_Department__c> objectRecords {get; set;}
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
    public AIA_MultipleDepartmentAdd(ApexPages.StandardController myController) {
        gsrfid = apexpages.currentpage().getparameters().get('gsrfid');
        //T01 - Start//
        gsrfrec= [select id,Implementation__r.Benefit_Request_Form__r.Request_Type__c,Implementation__r.Benefit_Request_Form__r.Benefit_Effective_Date__c from AIA_Group_Structure_Request_Form__c where id =: gsrfid];
        //T01 - End//
        objectRecords = new List<AIA_Department__c>();
        AIA_Department__c LitOrd = new AIA_Department__c();
        LitOrd.Group_Structure_Request_Form__c = gsrfid;
        //T01 - Start//
        if(gsrfrec.Implementation__r.Benefit_Request_Form__r.Request_Type__c == 'Prospect/New'){
            LitOrd.Effective_new_Date__c = gsrfrec.Implementation__r.Benefit_Request_Form__r.Benefit_Effective_Date__c;
        }
        else{
            LitOrd.Effective_new_Date__c = null;
        }
        //T01 - End//
        objectRecords.add(LitOrd);
    }
    //method to create multiple rows at once based on input
    public void multipleRows(){
        for(integer i=0;i<multipleRowsize;i++){
            addrow();
        }
    }
    public void addrow() {
        AIA_Department__c LitOrd = new AIA_Department__c();
        //LitOrd.Group_Structure_Request_Form__c = gsrfid.id;
        LitOrd.Group_Structure_Request_Form__c = gsrfid;
        //T01 - Start//
        if(gsrfrec.Implementation__r.Benefit_Request_Form__r.Request_Type__c == 'Prospect/New'){
            LitOrd.Effective_new_Date__c = gsrfrec.Implementation__r.Benefit_Request_Form__r.Benefit_Effective_Date__c;
        }
        else{
            LitOrd.Effective_new_Date__c = null;
        }
        //T01 - End//
        objectRecords.add(LitOrd);}
    
    
    public void removerow(){
        Integer i = objectRecords.size();
        if(i>1){
            objectRecords.remove(i-1);
        }
    }
    
    public void removeRowFromList(){
        Integer i = objectRecords.size();
        if(i>1){
            objectRecords.remove(rowToRemove-1);
        }
    }
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    public PageReference save() {
        try{
            insert objectRecords;
            //T02--Start
            if(!getIsClassic() || Test.isRunningTest())
            {
                msg = objectRecords.size()+' Record(s) Saved';
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
        PageReference home = new PageReference('/'+ gsrfid);
        home.setRedirect(true);
        return home; }
    public PageReference cancel() {
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