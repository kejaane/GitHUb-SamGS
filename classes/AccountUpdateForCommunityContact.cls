/*=========================================================================================
 * Date      : 10/12/2016
 * Developer : Rajesh Pennam
 * Purpose   : This class is having the logic to update the account name of the  Community Contact.
              
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer         Description
 *===========+============+================================================================
 * 10/18/2016  |  Rajesh Pennam    | Initial Version                                         
 *             |          | 
 *=============+==========+================================================================
 */
public class AccountUpdateForCommunityContact{
     public static void UpdateAccountForCommunityContact(List<Contact> ConLst){
         try{
         Account Acc = [select Id From Account where Name = 'Community_User_Account'];
         system.debug('Acc ' +Acc);
         
         Id RecId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Community_User_Contact'].Id;
         for(Contact C: ConLst)
         {       
             if( C.RecordTypeId == RecId)
                 C.AccountId = Acc.Id; 
         }
        }catch(Exception ex){system.debug('Exception: '+ex);}
     }
}