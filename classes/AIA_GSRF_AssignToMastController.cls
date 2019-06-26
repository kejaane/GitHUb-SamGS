/*===================================================================================================================
* Date       : 09/07/2017
* Developer  : Raviteja
* Purpose    : US-78 controller class is to allow user to change Group structure status to Assigned to Mast.
               validation for checking MAST Tech, Account Manager/Implementation Manager, Billing Tech, Settlements,
               AE BA roles available on Account team before submitting to Mast tech.
*                                 Update History
*                                 ---------------
* Date       |      Developer        | Tag |   Description
*============+============+==========+==============================================================================
* 07/09/2017 |      Raviteja         |     | Initial Version
* 11/02/2017 |      Debkanti         | T01 | Added for checking account team role "Ancillary Analyst" before
*                                            assigning to Mast
* 11/02/2017 |      Raviteja         | T02 | Added logic for checking required fields before submitting to MAST user
* 02/08/2018 |   Rajesh Nagandla     | T03 | Added SLDS to all components in page
*============+=======================+==============================================================================
*/

public with sharing class AIA_GSRF_AssignToMastController {
    
    //T03  -   start
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    //T03  -   end
    AIA_Group_Structure_Request_Form__c rec;
    public string errorGSRF='Please review below Errors:</br>';
    public boolean showError=false;
    public static final String addMast='MAST Tech role missing. Contact AIA Admin/Area Manager.</br>';
    public static final String addAMIM='Account Manager/Implementation Manager role missing. Contact AIA Admin/Area Manager.</br>';
    public static final String addBT='Billing Tech role missing. Contact AIA Admin/Area Manager.</br>';
    public static final String addS='Settlements Analyst role missing. Contact AIA Admin/Area Manager.</br>';
    public static final String addAEBA='Automated Enrollment Tech role missing. Contact AIA Admin/Area Manager.</br>';
    /*T01 Start*/
    public static final string addAnci='Ancillary Analyst role missing. Contact AIA Admin/Area Manager.</br>';
    /*T01 End*/
    public AIA_GSRF_AssignToMastController(ApexPages.StandardController stdController) {
        //id = apexpages.currentpage().getparameters().get('id');    
        rec = (AIA_Group_Structure_Request_Form__c)stdController.getRecord();
        //check if the roles are present or not before assigning to mast
        List<AIA_Group_Structure_Request_Form__c> lstgsrf=new List<AIA_Group_Structure_Request_Form__c>();
        lstgsrf.add(rec);
        AIA_GSM_GSRFHelperClass gsrfh=new AIA_GSM_GSRFHelperClass();
        map<id,String> gsrfmsg=gsrfh.checkListOfRoles(lstgsrf);
        String msg =gsrfmsg.get(rec.Implementation__c);
        system.debug('msg-'+msg+'-');
        //check the conditions and then assigned to mast
        if((rec.Status__c==AIA_Constants.GSRF_Status_Draft || rec.Status__c==AIA_Constants.GSRF_Status_DraftIncomplete||
            rec.Status__c==AIA_Constants.GSRF_Status_Rejected || rec.Status__c==AIA_Constants.GSRF_Status_RejectedbyAccount)
           && ( msg=='')){
               //check required fields are filled or not
               Boolean requiredFieldsFilled=checkRequiredGSPs(rec.id);
               if(requiredFieldsFilled==true){
               rec.Status__c=AIA_Constants.GSRF_Status_AssignedtoMAST;  
               }
               else{
                   errorGSRF += 'Please make sure all required fields on each Group Structure Product are populated before assigning the Group Structure Request Form to MAST.</br>';
                showError=true;
               }
           }
        else{
            /*if(rec.Processing_Type__c == null){
errorGSRF += 'Processing Type needs to be mandatory when the status is "Assigned to MAST"</br>';
}
else{*/
            //}
            if(msg!=''&& msg!=null){
                errorGSRF+=msg+'</br>';
            }
            if(msg==null){                         
                errorGSRF+=addMast+addAMIM+addBT+addS+addAEBA+addAnci;
            }
            if(msg==''){
                errorGSRF += 'Incorrect Status selected.</br>';
            }
            showError=true;
        }
        
    }
    
    public Boolean checkRequiredGSPs(Id gsrfid){
        List<AIA_Group_Structure_Form_Product__c> allGsps=[select id,Gsp_Opened__c 
                                                           from AIA_Group_Structure_Form_Product__c
                                                           where Group_Structure_Request_Form__c=:gsrfid];
        Boolean allfilled=true;
        for(AIA_Group_Structure_Form_Product__c thisGSP:allGsps){
            if(!thisGSP.Gsp_Opened__c){
                allfilled=false;
                break;
            }
        }
        return allfilled;
    }
    
    public pagereference saveRec(){
        //If it is not one of the above statuses,then throw error
        if(showError){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,errorGSRF);
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
    
    public pagereference backtogsrf(){
        PageReference pref = new PageReference('/'+rec.id );
        pref.setRedirect(true);
        return pref;
    }
}