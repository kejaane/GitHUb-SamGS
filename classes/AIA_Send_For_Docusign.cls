/*=======================================================================================================
 * Date         : 11/02/2017
 * Developer    : Satya Tirumalasetti
 * Purpose      : Controller for the VF page which is called when Send For Docusign button is clicked
 *                on the Implementation record
 *=======================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date      +  Developer   + Tag + Description
 *===========+==============+============================================================================
 * 11/02/2017|  Satya       |     | Initial Version.
 * 12/26/2017|  Satya       | T01 | Changes as a part of US527. Replaced Imp Manger to IMP PM. Also changed 
 *                                  code to get roles directly from Acc Team roles (Earlier used to get 
 *                                  from BRF.)
 * 02/12/2018|  Satya       | T02 | Added to distinguish between classic and lightning interface
 * 01/30/2019| Satya T      | T03 | Replaced standard Account Team Member with Custom Account Team Member.
 *===========+==============+=====+======================================================================
*/

public class AIA_Send_For_Docusign {
    public ID ImpID{get;set;}
    public AIA_Implementation__c ImpObject;
   // public list<AccountTeamMember> accteamlst; T03
    public list<Account_Team__c> accteamlst; //T03
    public set<string> teamuidNew = new set<string>(); //New business
    public set<string> teamuidRenewal = new set<string>(); //Renewal business
    public Id UserId;
    public string Profile;
    public boolean isClassic {get;set;} //T02 change
    public string Email;
    public string UserName;
    private final string SysAdmin = 'System Administrator';
    private final string F2SysAdmin = 'System Administrator 2FA - custom';
    public static boolean hasSkipVRs_CustPerm = CF_CustomPermissionsReader_Helper.Permissions.Docusign_ignoreVRs;
    private final string NO_ACCESS_TO_SEND_FOR_SIGNATURE_ERR_MSG = 'This User cannot send document for signature. ' + 
                                                                   '<br></br>' + 
                                                                   'For New business only an Implementation Manager can send documents for Signature. ' + 
                                                                   '<br></br>' + 
                                                                   'For Renewals only an AE/AM can send documents for Signature.';
    
    //Controller
    public AIA_Send_For_Docusign(ApexPages.StandardController controller) {
      ImpID = controller.getId();
      isClassic = AIA_Utils.isClassic(); //T02 change
      //get the implementation record in context
      ImpObject = [select id,Account__c,Benefit_Request_Form__c,Benefit_Request_Form__r.Account_Executive_Account_Team__c,Benefit_Request_Form__r.Account_Manager_Account_Team__c,
                    Benefit_Request_Form__r.Implementation_Manager_Account_Team__c, Benefit_Request_Form__r.Opportunity_Type__c,Docusign_Document_sending_user__c
                     from AIA_Implementation__c where id =:ImpID ];
      //Get the current user id
      UserId = UserInfo.getUserId();
      Profile = [select id, name from profile where Id =:UserInfo.getProfileId()].Name;
      Email = UserInfo.getUserEmail();
      UserName = UserInfo.getName();
    /* T03 -- Start*/
    /*  //T01 changes starts
      accteamlst = [SELECT UserId,TeamMemberRole 
                      FROM AccountTeamMember 
                      WHERE AccountId =: ImpObject.Account__c And 
                            (TeamMemberRole ='Account Executive' OR 
                             TeamMemberRole ='Implementation Manager' OR 
                             TeamMemberRole ='Account Manager')];
       
           for(AccountTeamMember acteam:accteamlst){
                // put the Account team members id in set
                If(acteam.TeamMemberRole == 'Implementation Manager'){teamuidNew.add(acteam.UserId);}
                If(acteam.TeamMemberRole != 'Implementation Manager'){teamuidRenewal.add(acteam.UserId);}   
                
           } 
           //T01  changes ends*/
            //T01 changes starts
      accteamlst = [SELECT UserId__c,TeamMemberRole__c,AccountId__c
                      FROM Account_Team__c
                      WHERE AccountId__c =: ImpObject.Account__c And 
                            (TeamMemberRole__c='Account Executive' OR 
                             TeamMemberRole__c='Implementation Manager' OR 
                             TeamMemberRole__c='Account Manager')];
       
           for(Account_Team__c acteam:accteamlst){
                // put the Account team members id in set
                If(acteam.TeamMemberRole__c== 'Implementation Manager'){teamuidNew.add(acteam.UserId__c);}
                If(acteam.TeamMemberRole__c!= 'Implementation Manager'){teamuidRenewal.add(acteam.UserId__c);}   
                
           } 
           //T01  changes ends
           /*T03 --- End*/
       }
       
              
    
    //method to redirect to Drawloop page upon succesful validation check
    public PageReference sendToDocusign() {
    
      //to send document for signature, current user should be one of IM since it is New business 
      //if(ImpObject.Benefit_Request_Form__c != null && ImpObject.Benefit_Request_Form__r.Opportunity_Type__c == 'New' && (UserId == ImpObject.Benefit_Request_Form__r.Implementation_Manager_Account_Team__c || Profile == SysAdmin || Profile == F2SysAdmin)){
        if(ImpObject.Benefit_Request_Form__c != null && ImpObject.Benefit_Request_Form__r.Opportunity_Type__c == 'New' && (teamuidNew.contains(UserId)|| Profile == SysAdmin || Profile == F2SysAdmin)){ //T01 Change
         
        //update Implementation record Docusign sender field with current user
         ImpObject.Docusign_Document_sending_user__c = Email;
         ImpObject.Docusign_Document_sending_user_Name__c = UserName;
         update ImpObject;
        
        //get the DDP Id's from cutom settings    
        AIA_Docusign_Document__c aiaDocSign = AIA_Docusign_Document__c.getValues('ID');
        String bbaDocIdString = aiaDocSign.BAA_Document__c+','+aiaDocSign.BAC_Document__c;
         
        PageReference pgRef = new PageReference('/apex/loop__looplus?&eid='+ImpObject.id+'&ddpIds='+bbaDocIdString+'&accountId='+ImpObject.Account__c+'&sessionId='+UserInfo.getSessionId());   
         pgRef.setRedirect(true); 
          return pgRef;
      }
      //to send document for signature, current user should be one of AE/AM since it is Renewal business
      else if(ImpObject.Benefit_Request_Form__c != null && ImpObject.Benefit_Request_Form__r.Opportunity_Type__c == 'Renewal' && (teamuidRenewal.contains(UserId)|| Profile == SysAdmin || Profile == F2SysAdmin)){ //T01 Change
        
        //update Implementation record Docusign sender field with current user
        ImpObject.Docusign_Document_sending_user__c = Email;
        ImpObject.Docusign_Document_sending_user_Name__c = UserName;
        update ImpObject;
        
        //get the DDP Id's from cutom settings    
        AIA_Docusign_Document__c aiaDocSign = AIA_Docusign_Document__c.getValues('ID');
        String bbaDocIdString = aiaDocSign.BAA_Document__c+','+aiaDocSign.BAC_Document__c;
         
        PageReference pgRef = new PageReference('/apex/loop__looplus?&eid='+ImpObject.id+'&ddpIds='+bbaDocIdString+'&accountId='+ImpObject.Account__c+'&sessionId='+UserInfo.getSessionId());   
         pgRef.setRedirect(true); 
          return pgRef;
      }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.error, NO_ACCESS_TO_SEND_FOR_SIGNATURE_ERR_MSG);
            ApexPages.AddMessage(myMsg);
      }
       return null; 
    }

        //method to go back to implementation record
        public PageReference Back() {
        return new PageReference('/'+ImpObject.id);
    }
}