/*------------------------------------------------------------------------------------
 *                      ----===[ HISTORY ]===---
 * Date        Developer        Description
 *------------------------------------------------------------------------------------
 * 12/03/2012 Varun Nagarajan   Modified code where Business__c and Market_Segment__c 
 *                              fields have been replaced with Business_Type__c and 
 *                              Market_Segment_New__c matching today's world requirements 
 *                              at CareFirst.  
 *************************************************************************************
 */


@isTest
private class OppPartnerExtension_TEST {
    // used to create account record that will be related to the opportunity
    static Account acc = new Account();
    // used to create the relationship to the Opportunity Partner record
    static Account acc2 = new Account();
    // used to create opportunity record
    static Opportunity opp = new Opportunity();    
    // used to create partner record
    static List<Partner> insertPartners = new List<Partner>();  
    static List<OpportunityPartner> partners = new List<OpportunityPartner>();              
    static Partner newPartner = new Partner();
    
    static testMethod void Test_With_Partner() {
        //String url = 'https://na7.salesforce.com/' ;
        //PageReference pageRef = new PageReference(url);
        
        Test.startTest();
        
        //Test.setCurrentPage(pageRef);
        
        // create new account record to be related to the oppourtnity
        acc.Name = 'TESTING';
        acc.Type = 'Customer';        
        insert acc;
        // create a new account record used to related the partner record
        acc2.Name = 'TESTING2';
        acc2.Type = 'Customer';
        insert acc2;        
                
         // create new Opportunity record
        Date closedDate = date.newinstance(2009, 1, 1);        
        Date effectiveDate = date.newinstance(2009, 2, 1);
        opp.Name = 'TESTING';
        opp.ACCOUNTID = acc.Id;
        opp.STAGENAME = 'Proposal';
        opp.PROBABILITY = 50;
        opp.TYPE = 'Dental Only';
        opp.AVP__C = 'Carl Repetti';
        opp.ACCOUNT_IN_JEOPARDY__C = 'No';
        opp.CLOSEDATE = closedDate;
        opp.EFFECTIVE_DATE__C = effectiveDate;
        //opp.BUSINESS__C = '51-199 Renewal Sales';
        opp.Business_Type__c = 'Renewal';
        opp.COMPETITOR__C = 'UNKNOWN';
        opp.ENROLLMENT__C = 'DBE/Admin';
        opp.EST_ACTUAL_CONTRACTS__C = 0; 
        opp.FULLSERVICEPRODUCER__C = 'Kelly & Associates Insurance Group';
        //opp.GENERALPRODUCER__C = 'BenefitMall';
        opp.LEAD_REP_NAME__C = 'June Swears';
        //opp.MARKET_SEGMENT__C = '1-50';
        opp.Market_Segment_New__c = '2-50';
        opp.POTENTIAL_CONTRACTS__C = 5;
        opp.PRODUCTS_OFFERED__C = 'Dental';
        //opp.PRODUCTS_SOLD__c = 'Dental';
        opp.RADAR__C = FALSE;
        opp.RISK_NON_RISK__C = 'Risk';
        opp.SERVICE_REP__C = 'Lisa Quigg';
        opp.SYSTEM__C = 'NASCO';  
        opp.TRANSITIONED__C = FALSE;
        opp.UNDERWRITING_ENTITY__C = 'DC';
        opp.Est_Actual_Contracts__c = 0;
//TPB 12/19/13
        Opp.Contract_End_Date__c = date.newinstance(2009, 3, 31); 
             
        insert opp;           
       
        // create related list partner record       
        newPartner.AccountToId = acc2.id;                
        newPartner.OpportunityId = Opp.Id;                
        newPartner.IsPrimary= true;                
        newPartner.Role = 'Broker';                
        insertPartners.add(newPartner);                 
        insert insertPartners;            
    
        // Construct the standard controller
        //ApexPages.StandardController con = new ApexPages.StandardController(opp);               
        OppPartnerExtension opExt = new OppPartnerExtension(new ApexPages.StandardController(opp));
        
        System.assert(opExt.getHasPartners() == true);        
        Test.stopTest(); 
    }
    
    static testMethod void Test_Without_Partner() {
        //String url = 'https://na7.salesforce.com/' ;
        //PageReference pageRef = new PageReference(url);
        
        Test.StartTest();
        
        //Test.setCurrentPage(pageRef);
        
         delete insertPartners;
               
        OppPartnerExtension opExt = new OppPartnerExtension(new ApexPages.StandardController(opp));
        
        System.assert(opExt.getHasPartners() == false);        
        Test.stopTest();  
    }
}