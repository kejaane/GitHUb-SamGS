/*=================================================================================================
* Date         : 08/27/2017
* Developer    : Debkanti,RaviTeja,Rajesh
* Purpose      : This class is to Send email notification to Ancillary Analyst if NASCO Account no 
                 is empty on Account and also send email to Benefit_Admin_Account_Set_Up_team__c for 
                 adding the alpha prefix to products.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+=================+=====+===================================================================
* 08/27/2017| Debkanti        |     | Initial Version
* 11/03/2017| Rajesh Nagandla | T01 | Added Parplan Validation on GSRF. 
*
*===========+============+=====+===================================================================
*/

public class AIA_GSM_GSRFTriggerHelper {
    public static void sendreqmail(list<AIA_Group_Structure_Request_Form__c> gsrflst,Map<id,sObject> gsrfold,string event){
        list<account> acclst = new list<account>();
        list<AccountTeamMember> accteammemberlst = new list<AccountTeamMember>();
        set<string> accidset = new set<string>();
        map<string,Account> accgsmmap = new map<string,Account>();
        map<string,id> accnasteammap = new map<string,id>();
        map<id,id> impGsrfNs = new map<id,id>();
        map<id,id> accimpmap = new map<id,id>();
        Boolean mast=false;
        id gsrfId = null;
        List<AIA_Implementation__c> implementations = new List<AIA_Implementation__c>();
        List<Opportunity> oppor = new List<Opportunity>();
        map<id,AIA_Group_Structure_Request_Form__c> gsrfidrec=new map<id,AIA_Group_Structure_Request_Form__c>();
        map<id,List<String>> gsrfGsrfpmap = new map<id,List<String>>();
        List<AIA_Group_Structure_Form_Product__c> gsrfp=new List<AIA_Group_Structure_Form_Product__c>();
        
        //Map of Gsrf and gsrfp
        gsrfp=[select id,name,Group_Structure_Request_Form__c from AIA_Group_Structure_Form_Product__c where Group_Structure_Request_Form__c in:gsrflst];
        for(AIA_Group_Structure_Form_Product__c thisgsrfp:gsrfp){
            
            String productnames='<li>'+thisgsrfp.name+'</li>';
            //Creating map of Group_Structure_Request_Form__c and AIA_Group_Structure_Form_Product__c
            if(!gsrfGsrfpmap.containsKey(thisgsrfp.Group_Structure_Request_Form__c)){
                gsrfGsrfpmap.put(thisgsrfp.Group_Structure_Request_Form__c, new List<String>{productnames});
                
            }else{
                gsrfGsrfpmap.get(thisgsrfp.Group_Structure_Request_Form__c).add(productnames);
            }
            
        }
        
        //Iterating over group structure request form to create a map of group structure form and implementation
        for(AIA_Group_Structure_Request_Form__c gsrf:gsrflst){
            if(event!='insert'){
                if(gsrf.Status__c == 'Assigned to MAST' && ((AIA_Group_Structure_Request_Form__c)gsrfold.get(gsrf.id)).Status__c!='Assigned to MAST'){
                    mast=true;
                    impGsrfNs.put(gsrf.Implementation__c,gsrf.id);
                    gsrfidrec.put(gsrf.id,gsrf);
                    //System.debug('EnterHere2: '+impGsrfNs);
                    gsrfId = gsrf.id;
                    
                }
            }
            else{
                if(gsrf.Status__c != 'Draft - New'){
                   gsrf.addError('Please check the status.');
                    
                }
            }
        }
        
        //Fatching implementation related to group structure request form
        if(!impGsrfNs.isEmpty()){
            implementations =[SELECT id,Account__c FROM AIA_Implementation__c where id in :impGsrfNs.keySet()];
            //Iterating overAIA_Implementation__c to create a map of AIA_Implementation__c and account
            For(AIA_Implementation__c imp :implementations ){
                accimpmap.put(imp.Account__c,imp.id);
                accidset.add(imp.Account__c);
                //System.debug('EnterHere5: '+accidset);
                //System.debug('EnterHere6: '+accimpmap);
            }
        }
        
        //Checking if map of account and group structure request form is empty
        if(!accidset.isEmpty() && !impGsrfNs.isEmpty()){
            //Fatching the field required on the email template from account
            acclst = [select id, NASCO_Account_Number__c, Account_Legal_Name__c, Account_Effective_Date__c,Phone,billingstreet,billingcity,billingstate,billingPostalCode,BillingCountry ,Control_Plan__c from Account where id =: accidset];
            //System.debug('EnterHere12: '+acclst);
            //Fatching team member email id form account team
            accteammemberlst = [SELECT AccountId,Id,TeamMemberRole,UserId,User.email FROM AccountTeamMember WHERE AccountId =: accidset AND (TeamMemberRole = 'Ancillary Analyst')];
            //System.debug('EnterHere13: '+accteammemberlst);
            //Iterating over account team mamber and put on the map
            for(AccountTeamMember acctm:accteammemberlst){
                accnasteammap.put(impGsrfNs.get(accimpmap.get(acctm.AccountId)),acctm.Userid);
                //System.debug('EnterHere14: '+accnasteammap);
            }
            //Iterating over account and creating map of group structure request form and account.
            for(Account acc:acclst){
                accgsmmap.put(impGsrfNs.get(accimpmap.get(acc.id)),acc);
                //system.debug('EnterHere15: '+accgsmmap);
            }
        }
        //Checking the map and calling the email sending class for sending email.
        if(!accgsmmap.isEmpty()){
            AIA_GSM_GSRFTriggerHelper.sendemail(accgsmmap,accnasteammap,gsrfidrec);
            if(mast==true)
                AIA_GSM_GSRFTriggerHelper.sendEmailAlpha(accgsmmap,gsrfGsrfpmap,gsrfidrec);
        }
    }
    //send mail for requesting Alpha prefix
    public static void sendEmailAlpha(map<string,Account> accgsmmap,map<id,List<String>> gsrfGsrfpmap,map<id,AIA_Group_Structure_Request_Form__c> gsrfidrec ){
        //system.debug('--smsl sendemail-->'+accgsmmap);
        List<String> sendTo = new List<String>();
        list<string> emailidlst = new list<string>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        string effectivedate;
        //Id templateId;
        //templateId = [select id, name from EmailTemplate where developername = 'AIA_Alpha_Prefix_Request_Template'].id;
        //string accid;
        if(!accgsmmap.isEmpty()){
            for(string gsmid:accgsmmap.keySet()){
                //system.debug('-insendemail->'+gsmid);
                effectivedate = '';
                Datetime dt;
                AIA_Workflow_Emails__c workFlowEmails = AIA_Workflow_Emails__c.getInstance();
                //Adding to to address
                emailidlst.add(String.valueOf(workFlowEmails.Benefit_Admin_Account_Set_Up_team__c));
                //system.debug('Email address wrong: '+emailidlst);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(emailidlst);
                //Setting target object id
               // id userId= null;
               // userId = Userinfo.getUserId();
                //mail.setTargetObjectId(userId);
                //Setting what id
                //mail.setwhatId(Id.valueOf(gsmid));
                //Creating the date format as required
                if(gsrfidrec.get(gsmid).Effective_Date__c!=null){
                    dt = datetime.newInstance(gsrfidrec.get(gsmid).Effective_Date__c.year(), gsrfidrec.get(gsmid).Effective_Date__c.month(),gsrfidrec.get(gsmid).Effective_Date__c.day());
                    effectivedate = dt.format('MM/dd/yy');
                }
                //Adding the subject
                mail.setSubject(gsrfidrec.get(gsmid).Account_Legal_Name__c+' - Request for Alpha Prefix');
                //Creating the shipping address
                string shippingAddress = accgsmmap.get(gsmid).billingstreet+'<br>'+ accgsmmap.get(gsmid).billingcity + ','+accgsmmap.get(gsmid).billingstate + ' '+accgsmmap.get(gsmid).billingPostalCode+'<br>' +accgsmmap.get(gsmid).BillingCountry;
                //Creating the email body
                String body = 'Requesting Alpha Prefix(es): Account Legal Name: '+gsrfidrec.get(gsmid).Account_Legal_Name__c
                    +', Phone: '+gsrfidrec.get(gsmid).Group_Phone_Number__c
                    +', Address:  '+shippingAddress
                   +', Control Plan: '+gsrfidrec.get(gsmid).Control_Plan__c
                    +', Effective Date: '+effectivedate+'</br>';
                if(gsrfGsrfpmap.get(gsmid)!=null){
                    body +='Products:</br>';
                    body +='<ul>'+string.join(gsrfGsrfpmap.get(gsmid),'')+'</ul></br>';
                }
                body += 'Please click the link below to add or enter the Alpha Prefix(es).<br/>';
                body += '<HTML><a style="text-decoration:none" href="' +URL.getSalesforceBaseUrl().toExternalForm()+'/'+gsmid+'"> Click here</a><br><br></HTML>';
                //Addting email template
                //mail.setTemplateId(templateId);
                //Addting email body as html 
                mail.setHtmlBody(body);
                mail.saveAsActivity = false;
                mails.add(mail);
            }
            if(!Test.isRunningTest() && mails.size() > 0  && Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()){   
                Messaging.sendEmail(mails);
            }
        }
    }
    
    //send mail for requesting NASCO number
    public static void sendemail(map<string,Account> accgsmmap,map<string,id> accnasteammap,map<id,AIA_Group_Structure_Request_Form__c> gsrfidrec ){
        List<String> sendTo = new List<String>();
        Id emailidlst ;
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        string effectivedate;
        String body;
        Id templateId;
        //AIA_Group_Structure_Request_Form__c gsrfId1 = [Select id from AIA_Group_Structure_Request_Form__c];
        templateId = [select id, name from EmailTemplate where developername = 'AIA_NASCO_field_update_Template'].id;
        //system.debug('-insendemail 179->'+accgsmmap.keySet());
        //string accid;
        if(!accgsmmap.isEmpty()){
            //system.debug('-insendemail 179->'+accgsmmap.keySet());
            //Iteraing over the account 
            for(string gsmid:accgsmmap.keySet()){
                String nasco=accgsmmap.get(gsmid).NASCO_Account_Number__c;
                //system.debug('-nasco->'+nasco);
                if(nasco == '' || nasco == null){
                //system.debug('-insendemail->'+gsmid);
                //Creating the date format as required
                effectivedate = '';
                Datetime dt;
                //accid = '0016300000QgbdY';
                //Adding email to email list
                if(!accnasteammap.isEmpty()){
                    emailidlst=accnasteammap.get(gsmid);
                }
                else{
                    gsrfidrec.get(gsmid).addError('Please Add Anscillary Analyst role in Accoun team',false);  
                 }
                //Instantiate the mail service
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //Setting target object id
                //system.debug('-emailidlst->'+emailidlst);
                mail.setTargetObjectId(emailidlst);
                //Setting what id
                mail.setwhatId(Id.valueOf(gsmid));
                //Adding to to address
                //mail.setToAddresses(emailidlst);
                //Date field convert
                if(accgsmmap.get(gsmid).Account_Effective_Date__c!=null){
                    dt = datetime.newInstance(accgsmmap.get(gsmid).Account_Effective_Date__c.year(), accgsmmap.get(gsmid).Account_Effective_Date__c.month(),accgsmmap.get(gsmid).Account_Effective_Date__c.day());
                    effectivedate = dt.format('MM/dd/yy');
                }
                //Creating the email body
                //mail.setSubject(accgsmmap.get(gsmid).Account_Legal_Name__c+' - '+effectivedate+' - NASCO Account Number Request - Proposed group structure');
                //body = 'Attached is the '+accgsmmap.get(gsmid).Account_Legal_Name__c+' - '+effectivedate+' - I would like to request an NASCO Account Number for the proposed group structure.<br><br>';
                //body += 'Please click the link below to add or enter the NASCO account number.<br/>';
                //body += '<HTML><a style="text-decoration:none" href="' +URL.getSalesforceBaseUrl().toExternalForm()+'/'+accgsmmap.get(gsmid).id+'"> Click here</a><br><br></HTML>';
                
                //Addting email template
                mail.setTemplateId(templateId);
                //Addting email body as html              
                mail.setHtmlBody(body);
                mail.saveAsActivity = false;
                mails.add(mail);
                }
            }
            if(!Test.isRunningTest() && mails.size() > 0  && Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()){   
                Messaging.sendEmail(mails);
            }
        }
    }
    /**T01 Start**/
    public static void parplanvalidation(list<AIA_Group_Structure_Request_Form__c> gsrflst ){
        
        string str = '';
        for(AIA_Group_Structure_Request_Form__c gsrf:gsrflst){
            if(gsrf.Par_Plan__c != '' && gsrf.Par_Plan__c != null){
                str = gsrf.Par_Plan__c;
                //system.debug('------->'+str);
                if(str.contains(';')){
                    if((gsrf.National_or_Local__c == 'National' && gsrf.Is_it_a_National_Account_With_Par_Plans__c == true) || gsrf.Alternate_Networks_Requested__c == true){
                        //system.debug('--in if-->');
                    }
                    else{
                        gsrf.Par_Plan__c.addError('If the Account is National AND a National Account with Par Plans, OR the Account has Alternate Networks Requested, then this field admits multiple values. Otherwise ParPlan field only admits a single value',false);
                    }
                }
            }
        }
        
    }
    /**T01 End**/
}