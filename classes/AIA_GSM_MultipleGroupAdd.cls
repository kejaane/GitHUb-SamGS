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
* 10/17/2017| Raviteja   |     	| Initial Version                                         
* 11/01/2017| Rajesh     | T01  | Auto populate effective date from Benefit Request Form if status of BRF is "NEW".
* 12/19/2017| Rajesh N   | T02  | Added logic to make Group number unique for individual Group Structure form.
* 02/01/2018| Raviteja   | T03  | Added SLDS changes
* 02/22/2018| Debkanti	 | T04  | Add refresh method to reset the page after adding the records.
*===========+============+=====+===================================================================
*/
public class AIA_GSM_MultipleGroupAdd {
    
    public List<AIA_Group__c> grps {get; set;}
    public Id gsrfid {get;set;}
    public Integer rowToRemove {get;set;}
    public Integer multipleRowsize {get;set;}
    public Boolean errorShow{get;set;}
    public String errormsg{get;set;}
    public String grpName{get;set;}
    //T03--Start
    public String msg{get; set;}
    public Boolean displayPopUp{get; set;}
    //T03--End
    //T01 - Start//
    public AIA_Group_Structure_Request_Form__c gsrfrec = new AIA_Group_Structure_Request_Form__c();
    //T01 - End//
    //    
    public AIA_GSM_MultipleGroupAdd(ApexPages.StandardController myController) {
        gsrfid = apexpages.currentpage().getparameters().get('gsrfid');
        //T01 - Start//
        gsrfrec= [select id,Implementation__r.Benefit_Request_Form__r.Request_Type__c,Implementation__r.Benefit_Request_Form__r.Benefit_Effective_Date__c from AIA_Group_Structure_Request_Form__c where id =: gsrfid];
        //T01 - End//
        grps = new List<AIA_Group__c>();
        AIA_Group__c LitOrd = new AIA_Group__c();
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
        grps.add(LitOrd);}
    //method to create multiple rows at once based on input
    public void multipleRows(){
        system.debug('multipleRowsize'+multipleRowsize);
        for(integer i=0;i<multipleRowsize;i++){
            addrow();
        }
    }
    //This method to add row in the line items
    public void addrow() {
        system.debug('grps'+grps);
        system.debug('grps'+grps.size());
        AIA_Group__c LitOrd = new AIA_Group__c();
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
        grps.add(LitOrd);
    }
    //This method to remove row in the line items
    public void removerow(){
        Integer i = grps.size();
        if(i>1){
            grps.remove(i-1);
        }
    }
    
    public void removeRowFromList(){
        //system.debug('Tesr: '+rowToRemove);
        Integer i = grps.size();
        if(i>1){
            grps.remove(rowToRemove-1);
        }
    }
     public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    //This method to save record with all the line items
    public PageReference save() {
        /**T02 - Start**/
        set<string> Gnameset = new set<string>();
        boolean noduplicates = false;
        //Checking duplicates from page entries.
        if(!grps.isEmpty()){
            for(AIA_Group__c grp:grps){
                if(Gnameset.contains(grp.name)){
                    errorShow=true;
                    grpName=grp.name;
                    errormsg='Group Number '+grp.name+' is already added, Please use a different Group Number';
                    //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Group Number '+grp.name+' is already added, Please use a different Group Number');
                    //ApexPages.addMessage(msg);
                    return null;
                }
                else if(!Gnameset.contains(grp.name)){
                    errorShow=false;
                    Gnameset.add(grp.name);
                }
            }system.debug('Gnameset'+Gnameset);
        }
        //Check duplicates for existing Groups on GSRF.
        list<AIA_Group__c> existgrlst= [select id, Name from AIA_Group__c where Group_Structure_Request_Form__c =: gsrfid];
        if(!existgrlst.isEmpty()){
            for(AIA_Group__c grp:existgrlst){system.debug('Gnameset'+Gnameset);system.debug('grp'+grp);
                if(Gnameset.contains(grp.name)){
                    errorShow=true;
                    grpName=grp.name;
                    errormsg=''+grp.name+': Group Number already being used';
                    //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,''+grp.name+': Group Number already being used');
                    //ApexPages.addMessage(msg);
                    //break;
                    return null;
                }
                else if(!Gnameset.contains(grp.name)){
                    errorShow=false;
                    Gnameset.add(grp.name);
                }
            }
        }
        /**T02 - End**/ 
        try{
            system.debug('grps'+grps);
            insert grps;
            //T03--Start
            if(!getIsClassic() || Test.isRunningTest())
            {
                msg = grps.size()+' Record(s) Saved';
            	displayPopUp = true;
                return null;
            }
            //T03--End
        }
        catch(exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(msg);
                        system.debug(msg);

            return null;
        }
        PageReference home = new PageReference('/'+ gsrfid);
        home.setRedirect(true);
        return home; }
    public PageReference cancel() {
        //system.debug('gsrfId1: '+gsrfid);
        PageReference home = new PageReference('/'+ gsrfid);
        home.setRedirect(true);
        return home;
    }
    /* T04 Start */
     public PageReference refresh() {
        PageReference home = new PageReference(ApexPages.currentPage().getUrl());
        home.setRedirect(true);
        return home;
    }
    /* T04 End */
}