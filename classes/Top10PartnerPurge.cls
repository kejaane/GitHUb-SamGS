//================================================================
//     Date: 06/11/2010
//Developer: Tom Barrett
//  Purpose: To purge all records in the Top10PartnersOppTotal 
//           custom object        
//================================================================
public class Top10PartnerPurge {
    public void purgeIt() {
        List<Top10PartnersOppTotal__c> top10; 
        top10 = [ Select t.partner__c
                From Top10PartnersOppTotal__c t ];
        Delete top10;
    }
}