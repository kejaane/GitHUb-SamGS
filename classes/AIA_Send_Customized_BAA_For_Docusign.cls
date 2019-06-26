/*=======================================================================================================
* Date         : 11/29/2017
* Developer    : Satya Tirumalasetti
* Purpose      : Controller for the VF page which is called when Send For Docusign button is clicked
*                on the AIA Document record. This will redirect the page to Docusign page.
*=======================================================================================================
*                                 Update History
*                                 ---------------
* Date      +  Developer   + Tag + Description
*===========+==============+============================================================================
* 11/29/2017|  Satya       |     | Initial Version.
* 12/01/2017|  Satya       | T01 | Added skip validation rules hasSkipVRs_CustPerm, so for users having 
*                                  this permission set, won't get any VR error 
* 12/26/2017|  Satya       | T02 | Changes as a part of US527. Replaced Imp Manger to IMP PM. Also changed 
 *                                  code to get roles directly from Acc Team roles (Earlier used to get 
 *                                  from BRF.) 
* 01/30/2019 | Satya T     | T03 | Replaced standard Account Team Member with Custom Account Team Member.            
*===========+==============+=====+======================================================================
*/

public without sharing class AIA_Send_Customized_BAA_For_Docusign {
    public Id DocID {get;set;}
    public AIA_Document__c DocObject;
    public Id UserId;
    public string Profile;
    public string Email;
    public string UserName;
   // public list<AccountTeamMember> accteamlst; T03
    public list<Account_Team__c> accteamlst; //T03
    public set<string> teamuidNew = new set<string>(); //New business
    public set<string> teamuidRenewal = new set<string>(); //Renewal business
    public final string SYSADMIN ='System Administrator';
    Public final string F2SYSADMIN ='System Administrator 2FA - custom';
    Public final string APPROVED ='Approved';
    Public final string ERRORMSG ='This User is not authorized to send document for signature';
    public static boolean hasSkipVRs_CustPerm = CF_CustomPermissionsReader_Helper.Permissions.Docusign_ignoreVRs;//T01
    //Constructor
    public AIA_Send_Customized_BAA_For_Docusign(ApexPages.StandardController controller){
        DocID =controller.getId();
        //get the AIA Document record in context
        DocObject =[select id,Approval_Status__c,Name,Account_Legal_Name__c,Implementation__r.Benefit_Request_Form__c,Implementation__r.Benefit_Request_Form__r.Opportunity_Type__c,
                            Implementation__r.Benefit_Request_Form__r.Implementation_Manager_Account_Team__c,Implementation__r.Benefit_Request_Form__r.Account_Executive_Account_Team__c,
                            Implementation__r.Benefit_Request_Form__r.Account_Manager_Account_Team__c,BAA_Customized_Email_Body__c,Docusign_Recipient_user_email__c,Docusign_send_user_name__c,
                            Implementation__r.Account__c
                    from AIA_Document__c 
                    where id =:DocID ];
        //Get the current user details
        UserId =UserInfo.getUserId();
        Profile =[select id, name from profile where Id =:UserInfo.getProfileId()].Name;
        Email =UserInfo.getUserEmail();
        UserName =UserInfo.getName();
        /* T03 -- Start*/
        /* //T02 changes starts
      accteamlst = [SELECT UserId,TeamMemberRole 
                      FROM AccountTeamMember 
                      WHERE AccountId =: DocObject.Implementation__r.Account__c And 
                            (TeamMemberRole ='Account Executive' OR 
                             TeamMemberRole ='Implementation Manager' OR 
                             TeamMemberRole ='Account Manager')];
       
           for(AccountTeamMember acteam:accteamlst){
                // put the Account team members id in set
                If(acteam.TeamMemberRole == 'Implementation Manager'){teamuidNew.add(acteam.UserId);}
                If(acteam.TeamMemberRole != 'Implementation Manager'){teamuidRenewal.add(acteam.UserId);}   
                
           } 
           //T02  changes ends*/
            accteamlst = [SELECT UserId__c,TeamMemberRole__c,AccountId__c
                      FROM Account_Team__c
                      WHERE AccountId__c =: DocObject.Implementation__r.Account__c And 
                            (TeamMemberRole__c ='Account Executive' OR 
                             TeamMemberRole__c ='Implementation Manager' OR 
                             TeamMemberRole__c ='Account Manager')];
       
           for(Account_Team__c acteam:accteamlst){
                // put the Account team members id in set
                If(acteam.TeamMemberRole__c == 'Implementation Manager'){teamuidNew.add(acteam.UserId__c);}
                If(acteam.TeamMemberRole__c != 'Implementation Manager'){teamuidRenewal.add(acteam.UserId__c);}   
                
           } 
            /* T03 -- End*/
    }
    //method to redirect to Docusign page upon succesful validation check
    public PageReference sendToBAADocusign(){
        string name =DocObject.Account_Legal_Name__c ;
        string sourceId =DocObject.id ;
        string remail = DocObject.Docusign_Recipient_user_email__c;
        string rname = DocObject.Docusign_send_user_name__c;
        string msg = DocObject.BAA_Customized_Email_Body__c; 
        msg = (!String.isBlank(msg))?msg.replaceAll('<br>', '\n'):'';
        
        string VPName;
        string VPEmail;
        
        For(AIA_Configurations__mdt DName :[Select id,DeveloperName,Parameter_Value__c from AIA_Configurations__mdt where (DeveloperName ='Docusign_VP_Name' OR DeveloperName ='Docusign_VP_Email' )]){
            if(DName.DeveloperName == 'Docusign_VP_Name'){VPName = DName.Parameter_Value__c ;}
            if(DName.DeveloperName == 'Docusign_VP_Email'){VPEmail = DName.Parameter_Value__c;}
        }
        string RC='';
        string RSL='';
        string RSRO='';
        string RROS='';
        string CCRM='';
        string CCTM='';
        string CCNM='';
        string CRL='Email~'+remail+';LastName~'+rname+';RoutingOrder~1;Role~Signer 1,Email~'+VPEmail+';LastName~'+VPName+';RoutingOrder~3;Role~Signer 3';
        string CRCL='';  //string CRL='Email~'+remail+';LastName~'+rname+';RoutingOrder~1;Role~Signer 1,Email~lakshmianusha.adabala@carefirst.com;LastName~Lakshmi;RoutingOrder~3;Role~Signer 3';
        string OCO='';
        string DST='';
        string LA='';
        string CEM=msg;
        string CES='Business Associate Agreement (BAA) for ';
        string STB='';
        string SSB='';
        string SES='';
        string SEM='';
        string SRS='';
        string SCS ='';
        string RES='';
        //to send document for signature, current user should be one of IM/AE/AM role
        system.debug('DocObject.Approval_Status__c==APPROVED' + DocObject.Approval_Status__c);
        system.debug('DocObject.Approval_Status__c==APPROVED' + APPROVED);
        system.debug('DocObject.Approval_Status__c==APPROVED' + (DocObject.Approval_Status__c==APPROVED));
        system.debug('DocObject.Implementation__r.Benefit_Request_Form__c!=null' + DocObject.Implementation__r.Benefit_Request_Form__c!=null);
        system.debug('UserId ==DocObject.Implementation__r.Benefit_Request_Form__r.Implementation_Manager_Account_Team__c' + (UserId ==DocObject.Implementation__r.Benefit_Request_Form__r.Implementation_Manager_Account_Team__c));
        system.debug('DocObject.Implementation__r.Benefit_Request_Form__r.Opportunity_Type__c ==' + (DocObject.Implementation__r.Benefit_Request_Form__r.Opportunity_Type__c=='New'));
        
        if(DocObject.Approval_Status__c==APPROVED && 
           DocObject.Implementation__r.Benefit_Request_Form__c!=null && 
           ((DocObject.Implementation__r.Benefit_Request_Form__r.Opportunity_Type__c =='New' && 
             (teamuidNew.contains(UserId) || hasSkipVRs_CustPerm)) || 
            (DocObject.Implementation__r.Benefit_Request_Form__r.Opportunity_Type__c =='Renewal' && 
             (teamuidRenewal.contains(UserId)|| hasSkipVRs_CustPerm )))) //T01,T02
        {
            String pgRefURL = '/apex/dsfs__DocuSign_CreateEnvelope?DSEID=0&SourceID='+sourceId;
            pgRefURL = pgRefURL + '&RC='+RC+'&RSL='+RSL+'&RSRO='+RSRO+'&RROS='+RROS+'&CCRM='+CCRM+'&CCTM='+CCTM+'&CRCL='+CRCL+'&CRL='+CRL;
            pgRefURL = pgRefURL + '&OCO='+OCO+'&DST='+DST+'&CCNM='+CCNM+'&LA='+LA+'&CEM='+CEM+'&CES='+CES+name;
            pgRefURL = pgRefURL + '&SRS='+SRS+'&STB='+STB+'&SSB='+SSB+'&SES='+SES+'&SEM='+SEM+'&SRS='+SRS+'&SCS='+SCS+'&RES='+RES;
            //to redirect user to Docusign page 
            PageReference pgRef =new PageReference(pgRefURL);   
            pgRef.setRedirect(true); 
            return pgRef;
        }else{
            ApexPages.Message myMsg =new ApexPages.Message(ApexPages.severity.error,ERRORMSG);
            ApexPages.AddMessage(myMsg);
        }
        return null; 
    }
    //method to go back to AIA Document record
    public PageReference Back(){
        return new PageReference('/'+DocObject.id);
    }
}