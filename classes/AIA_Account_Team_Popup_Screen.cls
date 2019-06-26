/*=================================================================================================================
* Date         : 09/20/2017
* Developer    : Goutham Rapolu
* Purpose      : Controller to check if Default Account Team Roles are added when an Account is created and throw a
*                Popup message on screen to verify the default Account team members as per US174
*============+================+=====+=============================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 09/20/2017 | Goutham Rapolu |     | Initial Version
* 05/30/2018  | Sajitha Y     | T01  | Modified class as per US 1789
* 01/29/2019  |  Satya T      | T02  | Changed the Account Team member references  
*                                     from Standard to Custom object
*===========+============+========================================================================================
*/

public without sharing class AIA_Account_Team_Popup_Screen{
    //T01 - Start
    @InvocableMethod  
    public static void getAccountNames(List<ID> ids) {
        // New List to get AccountTeamMember
       // List<AccountTeamMember> ateamlist = new List<AccountTeamMember>(); T02
       List<Account_Team__c> ateamlist = new List<Account_Team__c>(); //T02
        List<Account> accsToUpdate = new List<Account>();

        //Query Account
        List<Account> Acclist = [Select id, AIA_Display_Account_Team_PopUp__c, LastModifiedDate, CreatedDate from Account WHERE Id in :ids];
        //Query AccountTeamMember
        for(Account acc:Acclist){
           // ateamlist = [SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId FROM AccountTeamMember where AccountId =: acc.id]; T02
            ateamlist = [SELECT AccountId__c,Id,TeamMemberRole__c,UserId__c FROM Account_Team__c where AccountId__c=: acc.id]; //T02
            
            if(Acc.AIA_Display_Account_Team_PopUp__c == False)
            {
                if(!ateamlist.ISEMPTY() && Acc.LastModifiedDate == Acc.CreatedDate){
                    //Setting AIA_Display_Account_Team_PopUp__c as True if AccountTeamMember exists & if Account is created.
                    Acc.AIA_Display_Account_Team_PopUp__c = True;
                } 
                accsToUpdate.add(acc);
                
            }
        }
        if(!accsToUpdate.isEmpty()){
        try{
                system.debug('accsToUpdate'+accsToUpdate);
                Update accsToUpdate;
            }
            catch(Exception e){AIA_Utils errLogExp = new AIA_Utils();
           errLogExp.logException(e); 
            }
        }
    }
    //T01 - End
}