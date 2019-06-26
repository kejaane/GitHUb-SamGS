/*
*============+=================+=====+===================================================================
* Date         : 05/15/2018
* Developer    : Sajitha Y
* Purpose      : This class function is to Add default Account team automatically from user 
*				 when  account is getting Created. 
*============+=================+=====+===================================================================
*                                 Update History
*                                 ---------------
* Date        Developer        Tag     Description
*============+=================+=====+===================================================================
* 05/15/2018 | Sajitha Y       |     | Initial Version 
* 07/02/2018 | Asif Kutagulla  | T02 | Added condition for filtering inactive users
*============+=================+=====+===================================================================
*/
public without sharing class AIA_CreateDefaultAccountTeamMember {
    public static void getAccounts(List<Account> accts){
        List<UserAccountTeamMember> DefaultAccountteam = New List<UserAccountTeamMember>();
        List<Accountteammember> AccountTeam = New List<Accountteammember>();
        
        //Query to get Account Team Members for logged in User. T02 Change to add filter for inactive users
        DefaultAccountteam = [SELECT AccountAccessLevel,CaseAccessLevel,ContactAccessLevel,OpportunityAccessLevel,
                              		 OwnerId,SystemModstamp,TeamMemberRole,UserId 
                              FROM UserAccountTeamMember 
                              WHERE User.IsActive = TRUE AND
                              		OwnerId = :UserInfo.getUserId() ];
        
        If(!DefaultAccountteam.ISEMPTY()){
            for(Account acc:accts){
                for(UserAccountTeamMember UATM: DefaultAccountteam){
                    // Populate Accountteammember values from UserAccountTeamMember
                    Accountteammember AT = new Accountteammember();
                    AT.AccountAccessLevel     = UATM.AccountAccessLevel;
                    AT.TeamMemberRole         = UATM.TeamMemberRole;
                    AT.CaseAccessLevel        = UATM.CaseAccessLevel;
                    AT.ContactAccessLevel     = UATM.ContactAccessLevel;
                    AT.OpportunityAccessLevel = UATM.OpportunityAccessLevel;
                    AT.UserId                 = UATM.UserId;
                    AT.AccountID              = acc.id;
                    AccountTeam.add(AT);
                }
            }
            
            if(!AccountTeam.isEmpty()){
                try{
                    system.debug('AccountTeam'+AccountTeam);
                    insert AccountTeam;
                }
                catch(Exception e) { AIA_Utils errLogExp = new AIA_Utils(); errLogExp.logException(e); }
            }
        }
    }
}