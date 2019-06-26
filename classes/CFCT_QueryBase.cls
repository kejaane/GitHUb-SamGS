/*****************************************************************************************
//=========================================================================================
//     Date: 08/02/2011
//Developer: Tom Barrett
//  Purpose: Provide a base class for all SOQL queries associated with
//           CareFirst Custom Tools to help prevent code duplication
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//11/07/2014  Rajesh Tella  Processing only Record types that are 51+ 
//=========================================================================================
// 03/02/2015 Ashish Ojha    Added Methods getOppsInproposalFor_200Plus()
//            Tom Barrett                  getOppsInproposalFor_51to199() 
//
// 06/30/2016 Tom Barrett    Modified to include 200+ recordtype where applicable due to
//                           the AiA project introducing 200+ recordtype.
//                                          
//=========================================================================================
*****************************************************************************************/
public without sharing class CFCT_QueryBase {

/************************************************************************
 * purpose: To determine if the current user is a System Administrator
 *   param: None
 *  return: boolean - true if the current user is an admin
 *                    false otherwise
 ************************************************************************/
    public static boolean adminLoggedIn(){
        integer sysAdmin = 0;
        boolean adminLoggedIn;
        id proId = UserInfo.getProfileId();
        try{
            sysAdmin = [ SELECT Count() FROM profile WHERE id = :proId and Name = 'System Administrator'];
            if  (sysAdmin == 0 ) {
                adminLoggedIn = false;
            } else {
                adminLoggedIn = true;
            }                        
        } catch (QueryException qe) {
            System.debug('QueryException in CFCT_QueryBase.adminLoggedIn is :' + qe);
        } catch (Exception ex) {
            System.debug('Exception in CFCT_QueryBase.adminLoggedIn is :' + ex);
        } 
        return adminLoggedIn; 
    }

    
/************************************************************************* 
 *purpose: To retrieve a list of opportunities the current logged in
 *          user owns.  The query criteria is Effective_Date great than
 *          or equal to LAST_YEAR and Stage in ('Proposal', 'Sold') 
 *   param: None
 *  return: List of Opportunity type
 *************************************************************************/
    public static List<Opportunity> getOppsCurUserOwnsDateLimit() {
        id userId = UserInfo.getUserId();
        String RtId51Plus = querybase.getRecordtypeId('Opportunity', 'X51');
        String RtId200plus = Querybase.getRecordTypeId('Opportunity', 'AIA_200'); //ADD CHANGE TPB 06/30/2016
        List<Opportunity> oppList = new Opportunity[]{};
        try{
            //ADD CHANGE TPB 06/30/2016 below in WHERE clause 'RecordTypeId = :RtId' to 'RecordTypeId IN (:RtId51Plus, :RtId200Plus)'
            for ( Opportunity o : [ SELECT id, name, owner.id, owner.email, owner.Name, Lead_Rep_Name_User__c
                                    FROM Opportunity 
                                    WHERE StageName IN('Sold' , 'Proposal')
                                        AND Effective_Date__c >= LAST_YEAR 
                                        AND owner.id = :userId 
                                        AND owner.isActive = true    
                                        AND RecordTypeId IN(:RtId51Plus, :RtId200Plus)                                                                                 
                                    ORDER BY name] ) {          
                If ( o.owner.id <> o.lead_rep_Name_user__c ) {
                    oppList.add(o);                            
                }
            }       
        } catch (QueryException qe) {
                System.debug('QueryException in CFCT_QueryBase.getOppsCurUserOwnsDateLimit :' + qe);
        } catch (Exception ex) {
            System.debug('Exception in CFCT_QueryBase.getOppsCurUserOwnsDateLimit is :' + ex);
        } 
        return oppList;     
    }
    
    
/*************************************************************************
 * purpose: To retrieve a list of opportunities The query criteria is
 *          Effective_Date great than or equal to LAST_YEAR
 *          and StageName IN('Sold' , 'Proposal') 
 *   param: None
 *  return: List of Opportunity type
 *************************************************************************/
    public static List<Opportunity> getOppsDateLimit() {     
        String RtId51Plus = querybase.getRecordtypeId('Opportunity', 'X51');  
        String RtId200plus = Querybase.getRecordTypeId('Opportunity', 'AIA_200'); //ADD CHANGE TPB 06/30/2016
        List<Opportunity> oppList = new Opportunity[]{};
        try{
             //ADD CHANGE TPB 06/30/2016 below in WHERE clause 'RecordTypeId = :RtId' to 'RecordTypeId IN (:RtId51Plus, :RtId200Plus)'
            for ( Opportunity o : [ SELECT id, name, owner.id, owner.email, owner.Name, Lead_Rep_Name_User__c
                                    FROM Opportunity 
                                    WHERE StageName IN('Sold' , 'Proposal')
                                        AND Effective_Date__c >= LAST_YEAR 
                                        AND owner.isActive = true    
                                        AND RecordTypeId IN(:RtId51Plus, :RtId200Plus)                                    
                                    ORDER BY owner.name, name] ) {          
                If ( o.owner.id <> o.lead_rep_Name_user__c ) {
                    oppList.add(o);                            
                }
            }
       
        } catch (QueryException qe) {
                System.debug('QueryException in CFCT_QueryBase.getOppsDateLimit :' + qe);
        } catch (Exception ex) {
            System.debug('Exception in CFCT_QueryBase.getOppsDateLimit is :' + ex);  
        } 
        return oppList;     
    }
    
  
/**************************************************************************
 *purpose: To retrieve a list of opportunities without Partners the current 
 *         logged in user owns.  The query criteria is Effective_Date 
 *         great than or equal to LAST_YEAR 
 *         and StageName IN('Sold' , 'Proposal')
 *   param: None
 *  return: List of Opportunity type
 ***************************************************************************/
    public static List<Opportunity> getOppsCurUserOwnsDateLimitWithoutPartners() {
        String RtId51Plus = querybase.getRecordtypeId('Opportunity', 'X51');
        String RtId200plus = Querybase.getRecordTypeId('Opportunity', 'AIA_200'); //ADD CHANGE TPB 06/30/2016
        id userId = UserInfo.getUserId();
        List<Opportunity> oppList = new Opportunity[]{};
        try{
            //ADD CHANGE TPB 06/30/2016 below in WHERE clause 'RecordTypeId = :RtId' to 'RecordTypeId IN (:RtId51Plus, :RtId200Plus)'
            for ( Opportunity o : [ SELECT o.Owner.Name, o.Name, o.StageName, o.Effective_Date__c 
                                    FROM Opportunity o WHERE Id NOT IN (SELECT OpportunityId
                                                                          FROM OpportunityPartner) 
                                        AND StageName IN('Sold' , 'Proposal')
                                        AND o.OwnerId = :userId                                    
                                        AND Effective_Date__c >= LAST_YEAR
                                        AND o.Owner.isActive = true
                                        AND RecordTypeId IN(:RtId51Plus, :RtId200Plus)
                                    ORDER BY o.Owner.Name, o.Name ] ) {                
                    oppList.add(o);              
            }       
        } catch (QueryException qe) {
                System.debug('QueryException in CFCT_QueryBase.getOppsCurUserOwnsDateLimitWithoutPartners :' + qe);
        } catch (Exception ex) {
            System.debug('Exception in CFCT_QueryBase.getOppsCurUserOwnsDateLimitWithoutPartners is :' + ex);
        } 
        return oppList;     
    }
    
    
/***************************************************************************
 * purpose: To retrieve a list of opportunities without Partners.  The query
 *          criteria is Effective_Date great than or equal to LAST_YEAR
 *          and StageName IN('Sold' , 'Proposal') 
 *   param: None
 *  return: List of Opportunity type
 ***************************************************************************/
    public static List<Opportunity> getOppsDateLimitWithoutPartners() {  
        String RtId51Plus = querybase.getRecordtypeId('Opportunity', 'X51');
        String RtId200plus = Querybase.getRecordTypeId('Opportunity', 'AIA_200'); //ADD CHANGE TPB 06/30/2016
        List<Opportunity> oppList = new Opportunity[]{};
        try{
            //ADD CHANGE TPB 06/30/2016 below in WHERE clause 'RecordTypeId = :RtId' to 'RecordTypeId IN (:RtId51Plus, :RtId200Plus)'
            for ( Opportunity o : [ SELECT o.Owner.Name, o.Name, o.StageName, o.Effective_Date__c 
                                    FROM Opportunity o WHERE Id NOT IN (SELECT OpportunityId
                                                                FROM OpportunityPartner) 
                                        AND StageName IN('Sold' , 'Proposal')                                                             
                                        AND Effective_Date__c >= LAST_YEAR
                                        AND o.Owner.isActive = true
                                        AND RecordTypeId IN(:RtId51Plus, :RtId200Plus)
                                    ORDER BY o.Owner.Name, o.Name ] ) {                
                    oppList.add(o);        
               }
        } catch (QueryException qe) {
                System.debug('QueryException in CFCT_QueryBase.getOppsDateLimitWithoutPartners :' + qe);
        } catch (Exception ex) {
            System.debug('Exception in CFCT_QueryBase.getOppsDateLimitWithoutPartners is :' + ex);
        } 
        return oppList;     
    }    
    

/*************************************************************************
 * purpose: To retrieve the id of an email template           
 *   param: String - name of an email template
 *  return: ID - template
 *************************************************************************/
    public static String getTemplateId(String TemplateName) {
        String Id = '';
        try {
            EmailTemplate templateId = [ SELECT id 
                                         FROM EmailTemplate
                                         WHERE DeveloperName = :TemplateName
                                         LIMIT 1 ];
            Id = templateId.Id; 
        } catch (QueryException qe) {
                System.debug('QueryException in CFCT_QueryBase.getTemplateId :' + qe);
        } catch (Exception ex) {
            System.debug('Exception in CFCT_QueryBase.getTemplateId is :' + ex);
        }
        return Id;
    }   
    
 // BEGIN ADD 03/02/2015 Ashish Ojha / Tom Barrett
 /**************************************************************************
 *purpose: To retrieve market segment 200+ stale opportunities for a all users
 *   param: None
 *  return: List of Opportunity type
 ***************************************************************************/
    public static List<Opportunity> getOppsInProposalFor_200Plus() {
        String RtId51Plus = querybase.getRecordtypeId('Opportunity', 'X51');
        String RtId200Plus = QueryBase.getRecordTypeId('Opportunity', 'AIA_200'); //ADD CHANGE TPB 06/30/2016
        List<Opportunity> oppList = new Opportunity[]{};      
        Date dToday = Date.Today();         
        // Used only for testing to trick today in being a fixed 
        // predefined date for the test class to work
        if ( System.Test.isRunningTest() ) dToday = Date.newInstance(2015, 3, 1);
        // Manual Testing Only
        //dToday = Date.newInstance(2015, 3, 3);
        Date Days14Backward = dToday + 14;
        Date Days14Forward = dToday - 14;  
        System.debug('Today: ' + dToday); 
        try{
            //ADD CHANGE TPB 06/30/2016 below in WHERE clause 'RecordTypeId = :RtId' to 'RecordTypeId IN (:RtId51Plus, :RtId200Plus)'
            //                          Kept 51+ record type in the WHERE clause for historical purposes.  Ideally, the 51+ record
            //                          type won't be needed a few months down the road.
            for ( Opportunity o : [ SELECT o.Owner.Name, o.Name, o.StageName, o.Effective_Date__c 
                                    FROM Opportunity o 
                                    WHERE Market_Segment_New__c IN ('200-999', '1000+') AND
                                          StageName ='Proposal' AND 
                                          o.Owner.isActive = true AND 
                                          RecordTypeId IN(:RtId51Plus, :RtId200Plus) AND 
                                          (Effective_Date__c = :Days14Backward OR 
                                          Effective_Date__c = :dToday OR
                                          Effective_Date__c = :Days14Forward)                                         
                                    ORDER BY o.Owner.Name, o.Name ] ) {                
                    oppList.add(o);              
            }       
        } catch (QueryException qe) {
                System.debug('QueryException in CFCT_QueryBase.getOppsinproposalfor_200Plus:' + qe);
        } catch (Exception ex) {
            System.debug('Exception in CFCT_QueryBase.getOppsinproposalfor_200Plus is :' + ex);
        } 
        return oppList;     
    }
    
 /*************************************************************************
 *   purpose: To retrieve market segment 51-199 stale opportunities for all users.
 *   For business type New it will only get opportunity that is 30 days after effective date
 *   For business type Renewal it will only get opportunity where effective date is 10 days before or 
 *   14 days after or the day of effective date
 *   param: None
 *   return: List of Opportunity type
 *************************************************************************/
    public static List<Opportunity> getOppsInProposalFor_51to199() {
        String RtId51Plus = querybase.getRecordtypeId('Opportunity', 'X51');
        id userId = UserInfo.getUserId();
        List<Opportunity> oppList = new Opportunity[]{};
        Date dToday = Date.Today();         
        // Used only for testing to trick today in being a fixed 
        // predefined date for the test class to work
        if ( System.Test.isRunningTest() ) dToday = Date.newInstance(2015, 3, 1);
        
        //---------------------------------------------------------------------------
        // Manual Testing Only - make sure to comment out before moving to production
        //dToday = Date.newInstance(2015, 3, 3);
        //---------------------------------------------------------------------------
        
        Date Days10Backward = dToday + 10;       
        Date Days14Forward = dToday - 14;
        Date Days30Forward = dToday - 30;
        
        try{
            for ( Opportunity o : [ SELECT o.Owner.Name, o.Name, o.StageName, o.Effective_Date__c, o.business_type__c 
                                    FROM Opportunity o 
                                    WHERE Market_Segment_New__c = '51-199' AND
                                          StageName = 'Proposal' AND 
                                          o.Owner.isActive = true AND 
                                          RecordTypeId =:RtId51Plus AND                                          
                                          ((Business_type__c = 'renewal' AND (Effective_Date__c = :Days10Backward OR 
                                          Effective_Date__c = :dTODAY OR
                                          Effective_Date__c = :Days14Forward))  OR (Business_type__c = 'New' and Effective_Date__c = :Days30Forward)) 
                                                                                                                       
                                    ORDER BY o.Owner.Name, o.Name ] ) {                
                    oppList.add(o);              
            }       
        } catch (QueryException qe) {
                System.debug('QueryException in CFCT_QueryBase.getOppsinproposalfor_51to199:' + qe);
        } catch (Exception ex) {
            System.debug('Exception in CFCT_QueryBase.getOppsinproposalfor_51to199 is :' + ex);
        } 
        return oppList;     
    }
    // END ADD 03/02/2015 Ashish Ojha / Tom Barrett
 
}