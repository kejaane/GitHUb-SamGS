/*==================================================================================================
 * Date      : 12/06/2016
 * Developer : Rajesh Pennam
 * Purpose   : This class is having the logic to insert the implementation record when the 
 *              case is approved
 *===================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer                              Description
 *===========+============+==========================================================================
 * 12/06/2016  |  Rajesh Pennam    | Initial Version                                         
 * 01/29/2019  |  Satya T          | T01              | Changed the Account Team member references  
 *                                                      from Standard to Custom object
 *=============+==========+==========================================================================
 */
 
public class ImplementationInsertForApprovedCases {
    public static List<Account> Acc = new List<Account>();//This List is used to store the accounts which queried from related opportunity
    //public static List<AccountTeamMember> AccTeam = new List<AccountTeamMember>();//T01 
    public static List<Account_Team__c> AccTeam = new List<Account_Team__c>();//This List is used to store the account team members queried from related account
    public static List<User> usr = new List<User>();
    public static List<Opportunity> Opp = new List<Opportunity>();//This List is used to store the opportunities
    public static List<Benfit_Request_Form__c> SoldBRF = new List<Benfit_Request_Form__c>();//This List is used to store the related Sold BRF for particular Opportunity
    public static Map<Id,AIA_Implementation__c> ImpleMap = new Map<Id,AIA_Implementation__c>();
    
    //This method is used to populate the case owner once the case is created
    
    public static void populateOwner(Case cse){
        system.debug('in method');
        try{
            system.debug('in try');
            if(cse != null){
                system.debug('in if');
                Opp = [select Id,Name,AccountId from Opportunity where Id = :cse.Opportunity__c];
                system.debug(Opp);
                if(Opp.size()>0){
                    Acc = [select Id,Name,Has_Sub_Groups__c from Account where Id = :Opp[0].AccountId];
                    System.debug('Account Details'+Acc);
                    if(Acc.size()>0)
                    
                    //T01 changes start
                     //AccTeam = [select Id,AccountId,TeamMemberRole,UserId from AccountTeamMember where AccountId = :Acc[0].Id AND TeamMemberRole = 'Account Manager'];
                     AccTeam = [select Id,AccountId__c,TeamMemberRole__c,UserId__c from Account_Team__c where AccountId__c = :Acc[0].Id AND TeamMemberRole__c = 'Account Manager'];
                    //T01 changes end
                    
                    system.debug('Account Team'+AccTeam);
                    if(AccTeam.size()>0)
                        cse.OwnerId = AccTeam[0].UserId__c;
                 }
             }
        }catch(Exception ex){
            system.debug(ex+'');
        }
    }
    
    //This method is used to insert the implementation once the case owner changes the status of the case to "Approved"
    
    public static void InsertImplementation(Case cse){
        Id RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA NCR Cases').getRecordTypeId();  
        List<AIA_Implementation__c> ImpleLst = [select Id,Case__c from AIA_Implementation__c];
        for(AIA_Implementation__c imp: ImpleLst){
            ImpleMap.put(imp.Case__c,imp);
        }
        system.debug('in method');
        try{
            system.debug('in try');
            if(cse != null){
                system.debug('in if');
                Opp = [select Id,Name,AccountId from Opportunity where Id = :cse.Opportunity__c];
                system.debug(Opp);
                if(Opp.size()>0){
                    Acc = [select Id,Name,Has_Sub_Groups__c from Account where Id = :Opp[0].AccountId];
                    System.debug(Acc);
                    SoldBRF = [select Id,Name from Benfit_Request_Form__c where Opportunity__c = :Opp[0].Id AND Status__c = 'Sold'];
                    System.debug(SoldBRF);
                    if(cse.Status == 'Approved' && cse.RecordTypeId == RecordTypeId && !ImpleMap.containsKey(cse.Id)){
                        system.debug('in if if');
                        AIA_Implementation__c newObj = new AIA_Implementation__c();
                        If(Acc.size()>0)
                            newObj.Account__c = Acc[0].Id;
                        if(Opp.size()>0)
                            newObj.Opportunity__c = Opp[0].Id;
                        system.debug('before');
                        if(SoldBRF.size()>0 && !Acc[0].Has_Sub_Groups__c)
                            newObj.Benefit_Request_Form__c = SoldBRF[0].Id;
                        system.debug('after');
                        newObj.Business_Type__c = 'NCR';
                        newObj.Case__c = cse.Id;
                        insert newObj;
                        system.debug(newObj.Id);
                        system.debug('end');
                    }
                }
            }
        }catch(DMLException ex){
            System.debug(ex+'');
        }
    } 
}