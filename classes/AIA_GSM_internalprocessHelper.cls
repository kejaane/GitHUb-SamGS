/*===================================================================================================================
* Date       : 9/25/2017
* Developer  : Rajesh Nagandla
* Purpose    : AIA_GSM_internalprocessHepler class is to update GSRF status to Approved/Rejected, based internal approval
responses. Used in GSM_Approval_Response__c trigger.
*                                 Update History
*                                 --------------
* Date       |     Developer        | Tag |   Description
*============+============+=========================================================================================
* 9/25/2017  | Rajesh Nagandla      |  -   | Initial creation
* 9/26/2017  | Ravi Vadapalli       |  T01 | Added logic for sending email for internal approval process rejection 
*                                             with all comments.
* 11/04/2017 | Rajesh Nagandla      |  T02 | Modified GSRF Status values on Approval/Rejection
* 11/04/2017 | Rajesh Nagandla      |  T03 | Removed dependency on AIA_GSM_SubmitforApprovalController and created local method
*============+============+=========================================================================================
*/
public class AIA_GSM_internalprocessHelper{
    public static final string approvalpending='Pending';
    public static final string approvalreject='Reject';
    public static final string gsrfreject='Rejected by Internal Team';
    public static final string gsrfapprove='Approved by Internal Team';
    Public static void renewalDateUpdate(list<GSM_Approval_Response__c> appreslst){
        set<id> gsrfset = new set<id>();
        integer i;
        set<string> statusset = new set<string>();
        list<GSM_Approval_Response__c> garlst = new list<GSM_Approval_Response__c>();
        list<AIA_Group_Structure_Request_Form__c> gsrflst = new list<AIA_Group_Structure_Request_Form__c>();
        list<AIA_Group_Structure_Request_Form__c> gsrflstupdate = new list<AIA_Group_Structure_Request_Form__c>();
        AIA_Group_Structure_Request_Form__c gsrfrec = new AIA_Group_Structure_Request_Form__c();
        map<id,list<GSM_Approval_Response__c>> gsrfresmap = new map<id,list<GSM_Approval_Response__c>>();
        map<id,AIA_Group_Structure_Request_Form__c> gsrfmap = new map<id,AIA_Group_Structure_Request_Form__c>();
        
        //trigger.new itteration 
        for(GSM_Approval_Response__c gar:appreslst){
            if(gar.Response__c != approvalpending){
                gsrfset.add(gar.Group_Structure_Request_Form__c);
            }
        }
        if(!gsrfset.isEmpty()){
            //fetching all Approval responses on GSRF.
            garlst = [select id,Comments__c,User__c,Response__c,Process_completed__c,Group_Structure_Request_Form__c,Approval_Type__c,user__r.name,
                      Group_Structure_Request_Form__r.Effective_Date__c,Group_Structure_Request_Form__r.ignore_gsa_validations__c,Group_Structure_Request_Form__r.Effective_date_format__c,Group_Structure_Request_Form__r.Account_Legal_Name__c,
                      Group_Structure_Request_Form__r.Base_Group_Impact__c,Group_Structure_Request_Form__r.Status__c from GSM_Approval_Response__c where Group_Structure_Request_Form__c =: gsrfset and 
                      Approval_Type__c = 'Internal' and Process_completed__c=false];
            //fetching Parent-GSRF Data related to Approval Response.
            gsrflst = [select id, Status__c,ignore_gsa_validations__c,Effective_Date__c,Effective_date_format__c,Account_Legal_Name__c, Base_Group_Impact__c from AIA_Group_Structure_Request_Form__c
                       where id =: gsrfset];
            for(AIA_Group_Structure_Request_Form__c gsrf:gsrflst){
                gsrfmap.put(gsrf.id,gsrf);
            }
            if(!garlst.isEmpty()){
                for(GSM_Approval_Response__c gsp:garlst){
                    if(!gsrfresmap.containsKey(gsp.Group_Structure_Request_Form__c)){
                        gsrfresmap.put(gsp.Group_Structure_Request_Form__c, new list<GSM_Approval_Response__c>{gsp});
                    }else if(gsrfresmap.containsKey(gsp.Group_Structure_Request_Form__c)){
                        gsrfresmap.get(gsp.Group_Structure_Request_Form__c).add(gsp);
                    }
                }
            }
            //system.debug('----gsrfresmap---->'+gsrfresmap);
            for(id gsrfid: gsrfset){
                i=0;
                //temp = '';
                statusset = new set<string>();
                gsrfrec = new AIA_Group_Structure_Request_Form__c();
                for(GSM_Approval_Response__c gapres:gsrfresmap.get(gsrfid)){
                    if(gapres.Response__c != approvalpending){
                        i++;
                    }
                    statusset.add(gapres.Response__c);
                }
                //system.debug('--i-->'+i+'--temp-->'+temp);
                //system.debug('----gsrfresmap.get(gsrfid).size()---->'+gsrfresmap.get(gsrfid).size());
                if(gsrfresmap.get(gsrfid).size() == i){
                    //system.debug('-----update Parent---->');
                    gsrfrec = gsrfmap.get(gsrfid);
                    if(statusset.contains('Reject')){
                        gsrfrec.Status__c = gsrfreject;
                        gsrfrec.AIA_Approval_Status__c = false;
                        gsrfrec.ignore_gsa_validations__c=true;
                    }
                    else{
                        gsrfrec.Status__c = gsrfapprove;
                        gsrfrec.AIA_Approval_Status__c = false;
                    }
                    gsrflstupdate.add(gsrfrec);
                }
                /*temp = '';
                    for(GSM_Approval_Response__c gapres:gsrfresmap.get(gsrfid)){
                    if(gapres.Response__c != approvalpending && gapres.Response__c == approvalreject){
                    temp = gsrfreject;
                    break;
                    //i++;
                    }
                    else if(gapres.Response__c != approvalpending && gapres.Response__c == gsrfreject){
                    temp = gsrfapprove;
                    //break;
                    //i++;
                    }
                    //statusset.add(gapres.Response__c);
                    }
                    gsrfrec = gsrfmap.get(gsrfid);
                    if(temp != ''){
                    gsrfrec.Status__c = temp;
                    gsrflstupdate.add(gsrfrec);
                    }*/
                
                try{
                    if(!gsrflstupdate.isEmpty()){
                        /**T03 - Start**/
                        //AIA_GSM_internalprocessHelper.getRelateddata(gsrfid,'Unlock');
                        AIA_GSM_internalprocessHelper.getRelateddata(gsrfid,'Unlock');
                        /**T03 - End**/
                        Approval.Unlock(gsrflstupdate);
                        update gsrflstupdate;
                        //T01 - start
                        sendMail(gsrfset,gsrfmap,gsrflstupdate);
                        //T01 - End
                    }
                }
                catch(exception e){
                    system.debug('----Exception--->'+e);
                    AIA_Utils errLogExp = new AIA_Utils();
                    errLogExp.logException(e);
                }
            }
            
        }
    }
    
    //T01 - start
    //send email for rejection
    public static void sendMail(Set<id> gsrfset,map<id,AIA_Group_Structure_Request_Form__c> gsrfmap,list<AIA_Group_Structure_Request_Form__c> allrejectedgsrfs){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        AIA_Workflow_Emails__c workFlowEmails = AIA_Workflow_Emails__c.getInstance();
        list<string> emailidlst = new list<string>();
        emailidlst.add(workFlowEmails.Email_To_MAST_team__c); 
        map<id,list<GSM_Approval_Response__c>> gsrfresmap = new map<id,list<GSM_Approval_Response__c>>();
        List<GSM_Approval_Response__c> allrejectedresp=[select id,Response__c,Process_completed__c,user__r.name,Comments__c,Group_Structure_Request_Form__r.Status__c from GSM_Approval_Response__c 
                                                        where Group_Structure_Request_Form__c in: allrejectedgsrfs];
        system.debug('Hello: '+allrejectedresp);
        
        if(!allrejectedresp.isEmpty()){
            for(GSM_Approval_Response__c gsp:allrejectedresp){
                system.debug('gsp.Group_Structure_Request_Form__r.Status__c'+gsp.Group_Structure_Request_Form__r.Status__c);
                if(!gsrfresmap.containsKey(gsp.Group_Structure_Request_Form__c) && gsp.Group_Structure_Request_Form__r.Status__c == gsrfreject && gsp.Process_completed__c==false){
                    gsrfresmap.put(gsp.Group_Structure_Request_Form__c, new list<GSM_Approval_Response__c>{gsp});
                    system.debug('Hello1: '+gsrfresmap);
                }else if(gsrfresmap.containsKey(gsp.Group_Structure_Request_Form__c) && gsp.Group_Structure_Request_Form__r.Status__c == gsrfreject && gsp.Process_completed__c==false){
                    gsrfresmap.get(gsp.Group_Structure_Request_Form__c).add(gsp);
                    system.debug('Hello2: '+gsrfresmap);
                }
                gsp.Process_completed__c=true;
            }
            update allrejectedresp;
            for(Id gsrfid:gsrfresmap.keySet()){
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(emailidlst);
                String yesno='';
                if(gsrfmap.get(gsrfid).Base_Group_Impact__c==True){
                    yesno='Y';
                }
                else{
                    yesno='N'; 
                }
                mail.setSubject(gsrfmap.get(gsrfid).Account_Legal_Name__c+' - Effective Date '+gsrfmap.get(gsrfid).Effective_date_format__c +' - Rejected group structure.');
                String body=''+gsrfmap.get(gsrfid).Account_Legal_Name__c+' - Effective Date '+gsrfmap.get(gsrfid).Effective_date_format__c  + ' BGI = '+yesno+' - Rejected group structure.<br><br>';
                String rejectcomments='';
                rejectcomments+='Comments:<br/>';
                for(GSM_Approval_Response__c gresp:gsrfresmap.get(gsrfid)){
                    if(gresp.Response__c==approvalreject){
                        rejectcomments += gresp.Comments__c;
                    }
                }
                body += rejectcomments;
                //  body += '<a style="text-decoration:none" href="' +URL.getSalesforceBaseUrl().toExternalForm()+'/'+gsrfid+'"> Click here</a> for GSRF.<br><br>';
                system.debug('body'+body);
                mail.setHtmlBody(body);
                mails.add(mail);
                
            }
            if(!Test.isRunningTest() && mails.size() > 0  && Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()){   
                Messaging.sendEmail(mails);
            }
        }
    }
    //T01 - End
    /**T03 - Start**/
    public static void getRelateddata(id gsrfid, string str){
        list<AIA_Group_Structure_Form_Product__c> gsplst = new list<AIA_Group_Structure_Form_Product__c>();
        list<AIA_Group__c> glst = new list<AIA_Group__c>();
        list<AIA_Package__c> plst = new list<AIA_Package__c>();
        list<AIA_Department__c> dlst = new list<AIA_Department__c>();
        list<AIA_FACET_Class__c> fclst = new list<AIA_FACET_Class__c>();
        list<AIA_FACET_Group__c> fglst = new list<AIA_FACET_Group__c>();
        list<AIA_FACET_Sub_Group__c> fsblst = new list<AIA_FACET_Sub_Group__c>();
        
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
    /**T03 - End**/
}