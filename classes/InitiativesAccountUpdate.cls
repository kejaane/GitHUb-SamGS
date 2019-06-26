/*=========================================================================================
 * Date      : 07/08/2016
 * Developer : Rajesh Pennam
 * Purpose   : This class is having the logic to update the account name of the Opportunity
               when the Initiative is created from Opportunity.
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer         Description
 *===========+============+================================================================
 * 07/08/2016  |  Rajesh Pennam    | Initial Version                                         
 *             |          | 
 *=============+==========+================================================================
 */
public class InitiativesAccountUpdate {
    public static set<String> OppIds;
    public static List<Opportunity> OppLst;
    public static void UpdateAccount(List<Initiative__c> Recs){
        OppIds = new Set<string>();
        OppLst = new List<Opportunity>();
        system.debug('Intiative Records  '+Recs);
        for(Initiative__c i: Recs)
        {
            if(i.Opportunity_Name__c != null){
                OppIds.add(i.Opportunity_Name__c);
            }
        }
        system.debug('Set Ids '+OppIds);
        OppLst = [select Id,AccountId from Opportunity where Id IN : OppIds];
        system.debug('Opportunity List '+OppLst);
        for(Initiative__c i:Recs){
            for(Opportunity opp: OppLst){
                system.debug(i.Opportunity_Name__c);
                system.debug(opp.Id);
                if(i.Opportunity_Name__c == opp.Id){
                    i.Account_Name__c = opp.AccountId;
                }
            }
        }
    }
}