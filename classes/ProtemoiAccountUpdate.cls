/*=========================================================================================
 * Date      : 10/19/2016
 * Developer : Rajesh Pennam
 * Purpose   : This class is having the logic to update the account name of the Contact when
               a Protemoi is created for that contact
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer         Description
 *===========+============+================================================================
 * 07/08/2016  |  Rajesh Pennam    | Initial Version                                         
 *             |          | 
 *=============+==========+================================================================
 */
public class ProtemoiAccountUpdate {
    public static set<String> ConIds;
    public static List<Contact> ConLst;
    public static void UpdateAccount(List<Protemoi__c> Recs){
        ConIds = new Set<string>();
        ConLst = new List<Contact>();
        system.debug('Protemoi Records  '+Recs);
        for(Protemoi__c p: Recs)
        {
            if(p.Contact_Name__c != null){
                ConIds.add(p.Contact_Name__c);
            }
        }
        system.debug('Set Ids '+ConIds);
        ConLst = [select Id,AccountId from Contact where Id IN : ConIds];
        system.debug('Contact List '+ConLst);
        for(Protemoi__c pro:Recs){
            for(Contact Con: ConLst){
                system.debug(pro.Contact_Name__c);
                system.debug(con.Id);
                if(pro.Contact_Name__c == Con.Id){
                    pro.Account__c = Con.AccountId;
                }
            }
        }
    }
}