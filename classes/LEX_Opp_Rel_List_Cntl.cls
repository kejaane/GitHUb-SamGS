public with sharing class LEX_Opp_Rel_List_Cntl {
    @AuraEnabled
    public static Id getOppIdforFSPGP(Id fsp_gp_id) {
        Opportunity objOpp = new Opportunity();
        Id oppid = [SELECT id,Opportunity__c
                             FROM FSP_GP__c
                             WHERE id =: fsp_gp_id limit 1][0].Opportunity__c;        
        return oppid;
    }
    @AuraEnabled
    public static Id getOppIdforContactRole(Id contact_role_id) {
        Opportunity objOpp = new Opportunity();
        Id oppid = [SELECT id,Opportunity__c
                             FROM Opportunity_Contact_Role__c
                             WHERE id =: contact_role_id limit 1][0].Opportunity__c;        
        return oppid;
    }
    @AuraEnabled
    public static Id getOppIdforPartner(Id partner_id) {
        Opportunity objOpp = new Opportunity();
        Id oppid = [SELECT id,Opportunity__c
                             FROM Partner__c
                             WHERE id =: partner_id limit 1][0].Opportunity__c;        
        return oppid;
    }
}