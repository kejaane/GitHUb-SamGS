public class OppPartnerExtension {
    private boolean hasPartners = false;    

    // Check for any related partner records
    public OppPartnerExtension(ApexPages.StandardController controller) {
       if([select count() from OpportunityPartner where opportunityId = :controller.getRecord().id] > 0){
           hasPartners = true;
       }
    }
    
    public boolean getHasPartners(){
        return hasPartners;
    }
}