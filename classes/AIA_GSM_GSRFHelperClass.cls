/*****************************************************************************************************
*Date: 24/08/2017
*Developer: Debkanti
*Purpose: US-60 AIA_GSM_GSRFHelperClass is to validate only one GSRF for the implementation
*=========================================================================================
* Update History
* Date         Developer         Tag        Description
*==================================================================================
*09/20/2017    Raviteja                     Initial Development
*09/25/2017    Rajesh Nagandla   T01        Added Send email notification for Account Team on approved by account
*09/29/2017    Raviteja          T02        Added logic for checking account team before assigning to Mast
*02/11/2017    Rajesh Nagandla   T03        Added logic for checking account team role "Ancillary Analyst" before
*                                           assigning to Mast.
                                            Errormessages Modifications
*==================================================================================

*******************************************************************************************************/

public with sharing class AIA_GSM_GSRFHelperClass {
    public static boolean hasSkipGSRFs_CustPerm = CF_CustomPermissionsReader_Helper.Permissions.skipGSRFVRs;//T01
    public static final string mastrole='MAST Tech';
    public static final string accountManager='Account Manager';
    public static final string imrole='Implementation Manager';
    public static final string btrole='Billing Tech';
    /*T03 Start*/
    public static final string ancrole='Ancillary Analyst';
    /*T03 End*/
    public static final string settlementsrole='Settlements Analyst';
    public static final string aebarole='Automated Enrollment Tech';
    public static final String addMast='MAST Tech role missing. Contact AIA Admin/Area Manager.\r\n';
    public static final String addAM='Account Manager role missing. Contact AIA Admin/Area Manager.\r\n';
    public static final String addIM='Implementation Manager role missing. Contact AIA Admin/Area Manager.\r\n';
  public static final String addBT='Billing Tech role missing. Contact AIA Admin/Area Manager.\r\n';
    public static final String addS='Settlements Analyst role missing. Contact AIA Admin/Area Manager.\r\n';
    public static final String addAEBA='Automated Enrollment Tech role missing. Contact AIA Admin/Area Manager.\r\n';
    /*T03 Start*/
    public static final string addAnci='Ancillary Analyst role missing. Contact AIA Admin/Area Manager.\r\n';
    /*T03 End*/ 
    public static string accstatus='';
    public static void numberofgsrfrecords(list<AIA_Group_Structure_Request_Form__c> lstgsrf){
        Set<Id> impIds = new Set<Id>();
        string singleGSRF='Only 1 Group Structure Request Form can be created per Implementation.\r\n';
        //map with implemetations and list of GSRFs
        Map<Id,List<AIA_Group_Structure_Request_Form__c>> impGSRFMap=new Map<Id,List<AIA_Group_Structure_Request_Form__c>>();
        Set<Id> imps=new Set<Id>();
        Map<id,integer> impGsrfsize=new Map<id,integer>();
        
        for(AIA_Group_Structure_Request_Form__c gsrf :lstgsrf){
            imps.add(gsrf.Implementation__c);
        }
        
        List<AIA_Group_Structure_Request_Form__c> implist=[select id,implementation__c from AIA_Group_Structure_Request_Form__c where Implementation__c=: imps];
        for(AIA_Group_Structure_Request_Form__c thisGsrf:implist){
            if(impGSRFMap.containsKey(thisGsrf.Implementation__c)){
                impGSRFMap.get(thisGsrf.Implementation__c).add(thisGsrf);
            }
            else{
                impGSRFMap.put(thisGsrf.Implementation__c,new List<AIA_Group_Structure_Request_Form__c>{thisGsrf} );
            }
            
        }
        if(!impGSRFMap.isEmpty()) {
            String msg='';
            //T02 - start
            AIA_GSM_GSRFHelperClass gsrfh=new AIA_GSM_GSRFHelperClass();
            map<id,String> gsrfmsg=gsrfh.checkListOfRoles(lstgsrf);
            //system.debug('gsrfmsg'+gsrfmsg);
            //T02 - end
            for(AIA_Group_Structure_Request_Form__c thisGsrf:lstgsrf)
            {
                //if the size of gsrfs is greater than one it will throw an error
                if(impGSRFMap.get(thisGsrf.Implementation__c).size()>=1 ){
                    //if custom permission is given in the profile,it will bypass the error and continue creating GSRF
                    if(!hasSkipGSRFs_CustPerm){
                        msg += singleGSRF;
                    }
                }
                //T02 - start
                
                msg +=gsrfmsg.get(thisGsrf.Implementation__c);
                //system.debug('msggg'+msg);
                if(msg!='' && !msg.contains('null') ){
                    thisGsrf.addError(msg,false);
                }
                
                if(msg.contains('null')){
                    //thisGsrf.addError(addMast+'\r\n'+addAM+'\r\n'+addIM+'\r\n'+addBT+'\r\n'+addS+'\r\n'+addAEBA+'\r\n'+addAnci,false);
                    thisGsrf.addError(addMast,false);
                    thisGsrf.addError(addAM,false);
                    thisGsrf.addError(addIM,false);
                    thisGsrf.addError(addBT,false);
                    thisGsrf.addError(addS,false);
                     thisGsrf.addError(addAEBA,false);
                    thisGsrf.addError(addAnci,false);
                    
                }
                //T02 - end
            }
        }
    }
    //T02 - start
    //US 180
    //Check whether the AM/IM,  MAST,  AE BA, Settlements and Billing Tech are present or not while creating GSRF.
    public map<id,String> checkListOfRoles(list<AIA_Group_Structure_Request_Form__c> lstgsrf){
        set<string> impset = new set<string>();
        map<id,String> gsrfmsg=new map<id,String>();
        map<Id,Id> gsrimpmap = new map<Id,Id>();
        
        
        map<string,set<AccountTeamMember>> teammemmap = new map<string,set<AccountTeamMember>>();
        for(AIA_Group_Structure_Request_Form__c gsrf:lstgsrf){
            impset.add(gsrf.Implementation__c);
            //gsrimpmap.put(gsrf.id,gsrf.Implementation__c);
        }
        if(!impset.isEmpty()){
            //get all account team members related to this implementations set
            teammemmap = AIA_GSM_GSRFHelperClass.accountteammembers(impset);
            //system.debug('teammemmap'+teammemmap);
           // system.debug('gsrimpmap'+gsrimpmap);
        } 
        if(!teammemmap.isEmpty()){
            //Boolean mast,AM,Account Manager=false;
            //Boolean AM=false;
            for(Id thisImp:impset){
               // System.debug('teammemmap.get(thisImp)'+teammemmap.get(thisImp));
                String msg='';
                Boolean AM=false;
                Boolean IM=false;
                
                Boolean AEBA=false;
                Boolean settlements=false;
                Boolean BTvar=false;
                Boolean MAST=false;
                /*T03 Start*/
                Boolean Ancillary=false;
                /*T03 End*/
                for(AccountTeamMember thisMem:teammemmap.get(thisImp) ) {
                    if(thisMem.TeamMemberRole==mastrole){
                        MAST=true;
                    }
                    if(thisMem.TeamMemberRole==accountManager){
                        AM=true;
                    }
                    if(thisMem.TeamMemberRole==imrole){
                        IM=true;
                    }
                    if(thisMem.TeamMemberRole==btrole){
                        BTvar=true;
                    }
                    if(thisMem.TeamMemberRole==settlementsrole){
                        settlements=true;
                    }
                    if(thisMem.TeamMemberRole==aebarole){
                        AEBA=true;
                    }
                    /*T03 Start*/
                    if(thisMem.TeamMemberRole==ancrole){
                        Ancillary=true;
                    }
                    /*T03 End*/
                }
                
                if(!MAST){
                    msg +=addMast;
                }
                if(!AM){
                    msg +=addAM;
                }
                if(!IM){
                    msg +=addIM;
                }
                if(!BTvar){
                    msg +=addBT;
                }
                if(!settlements){
                    msg +=addS;
                }
                if(!AEBA){
                    msg +=addAEBA;
                }
                /*T03 Start*/
                if(!Ancillary){
                    msg +=addAnci;
                }
                /*T03 End*/
                gsrfmsg.put(thisImp, msg);
            }
        }
        system.debug('gsrfmsg 1st'+gsrfmsg);
        return gsrfmsg;
    }
    //T02 - end
    //Notification to account team member on account  rejection
    public static void accRejectedEmail(list<AIA_Group_Structure_Request_Form__c> lstgsrf,Map<id,sObject> oldgsrf){
        //system.debug('--in accapprovedEmail-->');
        set<string> impset = new set<string>();
        map<string,string> impgsrmap = new map<string,string>();
        map<string,set<AccountTeamMember>> teammemmap = new map<string,set<AccountTeamMember>>();
        for(AIA_Group_Structure_Request_Form__c gsrf:lstgsrf){
            if((gsrf.Status__c == AIA_Constants.GSRF_Status_RejectedbyAccount 
                && ((AIA_Group_Structure_Request_Form__c)oldgsrf.get(gsrf.id)).Status__c!=AIA_Constants.GSRF_Status_RejectedbyAccount)
              ){
                accstatus='Rejected';  
                impset.add(gsrf.Implementation__c);
                impgsrmap.put(gsrf.Implementation__c,gsrf.id);
            }
        }
        if(!impset.isEmpty()){
            teammemmap = AIA_GSM_GSRFHelperClass.accountteammembers(impset);
        }
        if(!teammemmap.isEmpty()){
            AIA_GSM_GSRFHelperClass.sendemail(teammemmap,impgsrmap);
        }
    }

    //Notification to account team member on account approval and rejection
    public static void accapprovedEmail(list<AIA_Group_Structure_Request_Form__c> lstgsrf,Map<id,sObject> oldgsrf){
        //system.debug('--in accapprovedEmail-->');
        set<string> impset = new set<string>();
        map<string,string> impgsrmap = new map<string,string>();
        map<string,set<AccountTeamMember>> teammemmap = new map<string,set<AccountTeamMember>>();
        for(AIA_Group_Structure_Request_Form__c gsrf:lstgsrf){
            if((gsrf.Status__c == AIA_Constants.Status && ((AIA_Group_Structure_Request_Form__c)oldgsrf.get(gsrf.id)).Status__c!=AIA_Constants.Status)){
                accstatus='approved';  
                impset.add(gsrf.Implementation__c);
                impgsrmap.put(gsrf.Implementation__c,gsrf.id);
            }
        }
        if(!impset.isEmpty()){
            teammemmap = AIA_GSM_GSRFHelperClass.accountteammembers(impset);
        }
        if(!teammemmap.isEmpty()){
            AIA_GSM_GSRFHelperClass.sendemail(teammemmap,impgsrmap);
        }
    }
    
    //Fetching Account team members with respect to account id.
    //changing teammemmap map from accmemid to teammemmap
    public static map<string,set<AccountTeamMember>> accountteammembers(set<string> impset){
        //system.debug('--in accountteammembers-->');
        set<string> accset = new set<string>();
        map<string,set<AccountTeamMember>> teammemmap = new map<string,set<AccountTeamMember>>();
        map<string,string> accimpmap = new map<string,string>();
        list<AIA_Implementation__c> implst = [select id, Account__c from AIA_Implementation__c where id =:impset and Account__c!=''];
        for(AIA_Implementation__c imp:implst){
            accset.add(imp.Account__c);
            accimpmap.put(imp.Account__c,imp.id);
            
        }
        list<AccountTeamMember> accteamlst = [SELECT AccountId,TeamMemberRole,Title,UserId FROM AccountTeamMember WHERE AccountId =: accset];
        for(AccountTeamMember acteam:accteamlst){
            if(!teammemmap.containsKey(accimpmap.get(acteam.AccountId))){
                //T02 putting map value with record ratherthan id .changed from acteam.UserId
                teammemmap.put(accimpmap.get(acteam.AccountId), new set<AccountTeamMember>{acteam});
            }else if(teammemmap.containsKey(accimpmap.get(acteam.AccountId))){
                teammemmap.get(accimpmap.get(acteam.AccountId)).add(acteam);
            }
        }
        system.debug('--in accountteammembers-->'+teammemmap);
        return teammemmap;
    }
    //T01 - start
    public static void sendemail(map<string,set<AccountTeamMember>> teammemmap,map<string,string> impgsrmap){
        //system.debug('--in sendemail-->');
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        string userid;
        String body;
        Id templateId;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(accstatus=='approved'){
        templateId = [select id, name from EmailTemplate where developername = 'AIA_GSRF_Approved_by_account'].id;
        }else{
        templateId = [select id, name from EmailTemplate where developername = 'AIA_GSM_Rejected_by_Account'].id;
        }
        if(!teammemmap.isEmpty()){
            //Iteraing implementation keyset
            for(string impid:teammemmap.keySet()){
                for(AccountTeamMember usid:teammemmap.get(impid)){
                    mail = new Messaging.SingleEmailMessage();  
                    //T02 - changed from usid to usid.UserId
                    mail.setTargetObjectId(usid.UserId);
                    mail.setwhatId(Id.valueOf(impgsrmap.get(impid)));
                    mail.setTemplateId(templateId);
                    //Addting email body as html              
                    mail.setHtmlBody(body);
                    mail.saveAsActivity = false;
                    mails.add(mail);
                }
            }
            system.debug('--in sendemail-->'+mails);
            if(!Test.isRunningTest() && mails.size() > 0  && Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()){   
                Messaging.sendEmail(mails);
            }
        }
    }
    //T01 - end
}