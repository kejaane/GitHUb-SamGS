/*===================================================================================================================
* Date       : 09/07/2017
* Developer  : Raviteja
* Purpose    : US-79 This is controller class to AIA_GSRF_AssigntoOwner VF page.
               Allow user to change status to Draft - Incomplete.
*                                 Update History
*                                 ---------------
* Date       |      Developer        | Tag |   Description
*============+============+=========================================================================================
* 09/07/2017 |      Raviteja         |     | Initial Version
* 02/09/2018 |   Rajesh Nagandla     | T03 | Added SLDS to all components in page
* 03/07/2018 |	 Debkanti			 | T04 | Added logic to throw error if must tech change the status to "Draft Incomplete"
											 from "Approved by Internal Team"
*============+============+=========================================================================================
*/

public class AIA_GSRF_AssignToOwner {
    AIA_Group_Structure_Request_Form__c rec;
    public static final string errorGSRF='GSRF cannot be changed,please check the status.';
    public string errorGSRFRec='Please review below Errors:</br>'; //T04
    public boolean showError=false; //T04
    
    //T01  -   start
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    //T01  -   end
    public AIA_GSRF_AssignToOwner(ApexPages.StandardController stdController) {
        String msg = ''; //T04
        //id = apexpages.currentpage().getparameters().get('id');    
         rec = (AIA_Group_Structure_Request_Form__c)stdController.getRecord();
        //check the conditions and then assigned to mast
        /* T04 -- Start */
        if( (rec.Status__c =='Assigned to MAST') && msg =='' ){
            rec.Status__c='Draft - Incomplete';  
        }
        else{
            errorGSRFRec += 'Incorrect Status selected.</br>';
            showError=true;
        }
        /* T04 -- End */
    }
  /*  public pagereference saveRec(){
         update rec;
         PageReference pr = new PageReference('/'+rec.id );
         pr.setRedirect(true);
         return pr; 
         //return null;     
        
    }*/
    /* T04 -- Start */
    public pagereference saveRec(){
        //If it is not one of the above statuses,then throw error
        if(showError){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,errorGSRFRec);
            ApexPages.addMessage(msg);
            return null;
        }else{
            try{
                update rec;
            }
            catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error '+e.getMessage()+' in line '+e.getLineNumber());
                ApexPages.addMessage(myMsg);
                return null;
            }
            PageReference pref = new PageReference('/'+rec.id );
            pref.setRedirect(true);
            return pref;      
        }
    }
    /* T04 -- End */
    public pagereference backtogsrf(){
        PageReference pref = new PageReference('/'+rec.id );
        pref.setRedirect(true);
        return pref;
    }
}