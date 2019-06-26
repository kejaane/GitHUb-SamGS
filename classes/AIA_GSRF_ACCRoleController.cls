/*===================================================================================================================
* Date       : 09/21/2017
* Developer  : Sajitha Y
* Purpose    : DrawLoop - Allowing team members to Export GSRF only when the status is Approved by Account.
*                                 Update History
*                                 ---------------
* Date       |     Developer        | Tag |   Description
*============+============+=========================================================================================
* 09/21/2017 |     Sajitha Y        |     | Initial Version
* 02/09/2018 | Rajesh Nagandla      | T01 | Added SLDS to all components in page
*============+============+=========================================================================================
*/
public class AIA_GSRF_ACCRoleController {
    //T01  -   start
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    //T01  -   end
    public final ApexPages.StandardController stdController;
    public AIA_Group_Structure_Request_Form__c gsrfrec{get;set;}
    public final AIA_Implementation__c imp;
    public final list<AccountTeamMember> accteamlst;
    public final AIA_Drawloop_Package_ID__c ddppackage;
    public set<string> teamuid = new set<string>();
    public String ddpid ='';
    public boolean showError=false;
    public PageReference pageref;
    public ApexPages.Message msg;
    public AIA_GSRF_ACCRoleController(ApexPages.StandardController stdController) {
        // Initialize the object
        gsrfrec = new AIA_Group_Structure_Request_Form__c();
        gsrfrec = (AIA_Group_Structure_Request_Form__c)stdController.getRecord();
        // Get the implementation by passing GSRF ID
        imp = [select id, Account__c from AIA_Implementation__c where id =:gsrfrec.Implementation__c ];
        // Fetch the Account team memebers by passing Account Id and role
                accteamlst = [SELECT UserId FROM AccountTeamMember WHERE AccountId =: imp.Account__c 
                      And (TeamMemberRole ='MAST Tech' OR TeamMemberRole ='Implementation Manager' OR TeamMemberRole ='Account Manager')];
                for(AccountTeamMember acteam:accteamlst){
            // put the Account team members id in set
            teamuid.add(acteam.UserId);
        }
        ddppackage = AIA_Drawloop_Package_ID__c.getValues(AIA_Constants.DDPNAME);
        ddpid = ddppackage.DDP_ID__c;
        // checking the Account team member set does not contains loggedin User id and GSRf status not equals to Approved by Account
        if(!teamuid.contains(userinfo.getUserId()) && gsrfrec.Status__c != AIA_Constants.Status)
        {
            showError=true;
        }
        
    }
    // Page Redirection Based on Status and Account teaM member role
    public pagereference custombuttonvalidation(){
        if(showError==false){
            pageref = new PageReference('/apex/loop__looplus?sessionId='+UserInfo.getSessionId()+'&eid='+gsrfrec.id+'&hidecontact=true&ddpIds='+ddpid);
            pageref.setRedirect(true);
            return pageRef;
        }
        else{
            msg = new ApexPages.Message(ApexPages.Severity.ERROR,AIA_Constants.ERRMSG);
            ApexPages.addMessage(msg);
            return null;
        }   
        
    }
   
}