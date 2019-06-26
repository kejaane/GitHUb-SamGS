/*===================================================================================================================
 * Date       : 9/18/2017
 * Developer  : Rajesh Nagandla
 * Purpose    : US-86 AIA_GSM_SubmitforApprovalController is to submit for approval on GSRF internally to Account team.
 *                                 Update History
 *                                 ---------------
 * Date        |     Developer        | Tag |   Description
 *=============+======================+=========================================================================================
 * 09/21/2017  | Rajesh Nagandla      |     | Initial Creation
 * 11/03/2017  | Rajesh Nagandla      | T01 | Added logic for throw error message if GSRF is already submitted,US233.
 * 11/05/2017  | Rajesh Nagandla      | T02 | Added logic for sending approval for IM/AM based request type.
 * 02/13/2018  | Phanishankar P       | T03 | Added SLDS to all components in page
 *============+============+=========================================================================================
*/
//Removing With sharing as we are locking/Unlocking from here
public class AIA_GSM_SubmitforApprovalController {
    //T03  -   start
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    //T03  -   end
    public AIA_Group_Structure_Request_Form__c gsrfrec{get;set;}
    AIA_Utils errLogExp = new AIA_Utils();
    public string msg {get;set;}
    public Boolean displaypopup{get;set;}
    public static final string pendingstatus='Pending';
    public static final string approvalType='Internal';
    public static final string successmsg='Successfully submitted the Group Structure Request Form.';
    public static final string errormsgImpl='Cannot submit for Approval if Implementation is null.';
    public static final string errormsgNasco='NASCO Account number is missing and not available to submit for Approval. Contact Ancillary Team to obtain NASCO Account number';
    /*'Nasco Account number is not available to submit for Approval';*/
    public static final string errormsgAlpha='Alpha Prefix value is missing and not available to submit for Approval. Contact MAIN team to obtain Alpha Prefix value';
    /*'Alpha Prefix value is not available to submit for Approval';*/
    public static final string errorProcessingtype='Processing Type is missing  and not available to submit for Approval';
    /*'Processing Type needs to be mandatory when the status is "Assigned to MAST"';
    public static final string errormsgsubmitted='Already submited for Internal process. can\'t submit again';*/
    public static final string errorStatus='Incorrect Status selected.';
    /*T01 Start*/
    public static final string errorSubmit='Group Structure Request Form has already been submitted for Approval.';
    /*T01 End*/
        
    public AIA_GSM_SubmitforApprovalController(ApexPages.StandardController controller) {
        gsrfrec = new AIA_Group_Structure_Request_Form__c();
        gsrfrec = (AIA_Group_Structure_Request_Form__c)controller.getRecord();
         displayPopup = false;
    }
    //Checking all the validation before submiting for approval
    public pagereference submitforapproval(){
        msg='';
        set<string> accteamset = new set<string>();
        if(gsrfrec.NASCO_Account_Number__c != null && gsrfrec.Alpha_Prefix_is_missing__c && !Approval.isLocked(gsrfrec.id) && (gsrfrec.Status__c =='Assigned to MAST' && gsrfrec.Processing_Type__c != null)){
            if(gsrfrec.Implementation__c != null || gsrfrec.Implementation__c != ''){
                accteamset = fetchAccountteammembers(gsrfrec.Implementation__c);
                createApprovalresponses(accteamset,gsrfrec.id);
                /*T01 Start*/
                gsrfrec.Status__c = 'Awaiting Internal Approval';
                gsrfrec.AIA_Approval_Status__c = true;
                update gsrfrec;
                /*T01 Start*/
                msg=successmsg;
            }
            else{
                msg=errormsgImpl;
            }
        }
        else{
            /*if(gsrfrec.Status__c =='Assigned to MAST' && gsrfrec.Processing_Type__c == null){*/
            if(gsrfrec.Processing_Type__c == null){
                msg = msg+errorProcessingtype+'<br/>';
            }
            if(gsrfrec.NASCO_Account_Number__c == null){
                msg = msg+errormsgNasco+'<br/>';
            }
            if(!gsrfrec.Alpha_Prefix_is_missing__c){
                msg = msg+errormsgAlpha+'<br/>';
            }
            /*if(Approval.isLocked(gsrfrec.id)){
                msg = msg+errormsgsubmitted+'<br/>'; 
            }*/
            if(gsrfrec.Status__c !='Assigned to MAST'){
                msg = msg+errorStatus+'<br/>';
            }
            /*T01 Start*/
            if(gsrfrec.Status__c =='Awaiting Internal Approval' || gsrfrec.Status__c =='Approved by Internal Team' ||gsrfrec.Status__c =='Rejected by Internal Team' ||gsrfrec.Status__c =='Approved by Account' ||gsrfrec.Status__c =='Rejected by Account' ){
                msg = msg+errorSubmit+'<br/>';
            }
            /*T01 End*/
        }
        displayPopup = true;
        /*T01 Start
        gsrfrec.Status__c = 'Awaiting Internal Approval';
        T01 End*/
        return null;
    } 
    //fetching 'Implementation Manager' and TeamMemberRole='Account Manager' from Accountteam.
    public set<string> fetchAccountteammembers(id impid){
        set<string> teamuid = new set<string>();
            AIA_Implementation__c imp = [select id, Account__c, BRF_Request_Type__c from AIA_Implementation__c where id =:impid ];
            /*T02 - Start*/
            String myValue = 'My Value';
            String query = 'SELECT AccountId,TeamMemberRole,Title,UserId FROM AccountTeamMember';
            query = query+' WHERE AccountId =\''+imp.Account__c+'\' and ';
            if(imp.BRF_Request_Type__c == 'Prospect/New'){
                query = query+' TeamMemberRole = \'Implementation Manager\'';
            }
            else{
                query = query+' TeamMemberRole = \'Account Manager\'';
            }
            system.debug('----query 102---->'+query);
            list<AccountTeamMember> accteamlst = Database.query(query);
            /*list<AccountTeamMember> accteamlst = [SELECT AccountId,TeamMemberRole,Title,UserId 
                                                  FROM AccountTeamMember 
                                                  WHERE AccountId =: imp.Account__c 
                                                  and (TeamMemberRole = 'Implementation Manager' or TeamMemberRole='Account Manager' )];*/
            /*T02 - End*/
            for(AccountTeamMember acteam:accteamlst){
                teamuid.add(acteam.UserId);
            }
        return teamuid;
    }
    //Creating GSM Approval response records.
    public void createApprovalresponses(set<string> accteamset,id gsrfid){
        list<GSM_Approval_Response__c> appreslst = new list<GSM_Approval_Response__c>();
        GSM_Approval_Response__c appres = new GSM_Approval_Response__c();
        if(!accteamset.isEmpty()){
            for(string str:accteamset){
                appres = new GSM_Approval_Response__c();
                appres.Group_Structure_Request_Form__c = gsrfid;
                appres.User__c = str;
                appres.Response__c = pendingstatus;
                appres.Approval_Type__c = approvalType;
                appreslst.add(appres);
            }
        }
        if(!appreslst.isEmpty()){
            try{
                insert appreslst;
            }
            catch(Exception e){
                errLogExp.logException(e);
                ApexPages.Message PageMessage = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()); 
                ApexPages.addMessage(PageMessage); 
            }
        }
        //locking all related records.
        AIA_GSM_SubmitforApprovalController.getRelateddata(gsrfid,'lock');
        Approval.lock(gsrfid);
    }
    //Fetcing all related list data for locking once approval is submitted
    public static void getRelateddata(id gsrfid, string str){
        list<AIA_Group_Structure_Form_Product__c> gsplst = new list<AIA_Group_Structure_Form_Product__c>();
        list<AIA_Group__c> glst = new list<AIA_Group__c>();
        list<AIA_Package__c> plst = new list<AIA_Package__c>();
        list<AIA_Department__c> dlst = new list<AIA_Department__c>();
        list<AIA_FACET_Class__c> fclst = new list<AIA_FACET_Class__c>();
        list<AIA_FACET_Group__c> fglst = new list<AIA_FACET_Group__c>();
        list<AIA_FACET_Sub_Group__c> fsblst = new list<AIA_FACET_Sub_Group__c>();
        //list<AIA_Document__c> doclst = new list<AIA_Document__c>();
        
        gsplst = [select id,Group_Structure_Request_Form__c from AIA_Group_Structure_Form_Product__c where Group_Structure_Request_Form__c =: gsrfid];
        glst = [select id,Group_Structure_Request_Form__c from AIA_Group__c where Group_Structure_Request_Form__c =: gsrfid];
        plst = [select id,Group_Structure_Request_Form__c from AIA_Package__c where Group_Structure_Request_Form__c =: gsrfid];
        dlst = [select id,Group_Structure_Request_Form__c from AIA_Department__c where Group_Structure_Request_Form__c =: gsrfid];
        fclst = [select id,Group_Structure_Request_Form__c from AIA_FACET_Class__c where Group_Structure_Request_Form__c =: gsrfid];
        fglst = [select id,Group_Structure_Request_Form__c from AIA_FACET_Group__c where Group_Structure_Request_Form__c =: gsrfid];
        fsblst = [select id,Group_Structure_Request_Form__c from AIA_FACET_Sub_Group__c where Group_Structure_Request_Form__c =: gsrfid];
        //doclst = [select id,Group_Structure_Request_Form__c from AIA_Document__c where Group_Structure_Request_Form__c =: gsrfid];
        
        if(!gsplst.isEmpty()){
            if(str == 'lock'){
                Approval.lock(gsplst);
            }
            else{
                Approval.unlock(gsplst);
            }
        }
        if(!glst.isEmpty()){
            if(str == 'lock'){
                Approval.lock(glst);
            }
            else{
                Approval.unlock(glst);
            }
        }
        if(!plst.isEmpty()){
            if(str == 'lock'){
                Approval.lock(plst);
            }
            else{
                Approval.unlock(plst);
            }
        }
        if(!dlst.isEmpty()){
            if(str == 'lock'){
                Approval.lock(dlst);
            }
            else{
                Approval.unlock(dlst);
            }
        }
        if(!fclst.isEmpty()){
            if(str == 'lock'){
                Approval.lock(fclst);
            }
            else{
                Approval.unlock(fclst);
            }
        }
        if(!fglst.isEmpty()){
            if(str == 'lock'){
                Approval.lock(fglst);
            }
            else{
                Approval.unlock(fglst);
            }
        }
        if(!fsblst.isEmpty()){
            if(str == 'lock'){
                Approval.lock(fsblst);
            }
            else{
                Approval.unlock(fsblst);
            }
        }
    }
    
    //Page redirection to gsrf.
    public pagereference backtogsrf(){
        
        PageReference pref = new PageReference('/'+gsrfrec.id );
        pref.setRedirect(true);
        return pref;
    }
}