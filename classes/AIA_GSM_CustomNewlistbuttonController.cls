/*===================================================================================================================
 * Date       : 9/18/2017
 * Developer  : Rajesh Nagandla
 * Purpose    : New Button Functionality for all Group structure request form line items. Checks GSRF is locked or
 *              not and redirects page accordingly. 
 *                                 Update History
 *                                 ---------------
 * Date       |     Developer        | Tag |   Description
 *============+============+=========================================================================================
 * 9/21/2017  | Rajesh Nagandla      |     | Initial Creation
 *============+============+=========================================================================================
*/
//Removing With sharing as we are locking/Unlocking from here
public class AIA_GSM_CustomNewlistbuttonController  {
    public AIA_Group_Structure_Request_Form__c gsrfrec{get;set;}
    AIA_Utils errLogExp = new AIA_Utils();
    public string msg {get;set;}
    public string objype {get;set;}
    public Id gsrfid {get;set;}
    public Boolean displaypopup{get;set;}
    public static final string lockedmsg='Record is Locked';
    
    public AIA_GSM_CustomNewlistbuttonController (ApexPages.StandardController controller) {
        gsrfrec = new AIA_Group_Structure_Request_Form__c();
        gsrfid = apexpages.currentpage().getparameters().get('gsrfid');
        objype = apexpages.currentpage().getparameters().get('type');
        //gsrfrec = [select id,name from AIA_Group_Structure_Request_Form__c where id =: gsrfid];
        //system.debug('--gsrfid-->'+gsrfid+' '+objype);
        displayPopup = false;
    }
    
    //Checking all the validation before allowing user to create new record
    public pagereference parentislocked(){
        msg='';
        string tmpurl='';
        if(Approval.islocked(gsrfid)){
            msg = lockedmsg;
            displayPopup = true; 
            return null;
        }
        else{
            system.debug('--else-->'+tmpurl);
            system.debug('---->'+objype);
            if( objype == 'Group'){
                system.debug('---->'+objype);
                tmpurl = '/apex/AIA_GSM_MultipleGroupAddVF?gsrfid='+gsrfid;
            }
            else if( objype == 'Package'){
                tmpurl = '/apex/AIA_GSM_MultiplePackageAddVF?gsrfid='+gsrfid;
            }
            else if( objype == 'Department'){
                tmpurl = '/apex/AIA_MultipleDepartmentAdd?gsrfid='+gsrfid;
            }
            else if( objype == 'Facet'){
                tmpurl = '/apex/AIA_MultipleFacetGroupsAdd?gsrfid='+gsrfid;
            }
            else if( objype == 'FacetsubGroup'){
                tmpurl = '/apex/AIA_GSM_MultipleFacetSubGroupAdd?gsrfid='+gsrfid;
            }
            else if( objype == 'Facetclass'){
                tmpurl = '/apex/AIA_GSM_MultipleFacetAdd?gsrfid='+gsrfid;
            }
            system.debug('---->'+tmpurl);
            PageReference pref = new PageReference(tmpurl);
            pref.setRedirect(true);
            return pref;
        }
    }
    
    //Page redirection to gsrf.
    public pagereference backtogsrf(){
        PageReference pref = new PageReference('/'+gsrfid);
        pref.setRedirect(true);
        return pref;
    }
}