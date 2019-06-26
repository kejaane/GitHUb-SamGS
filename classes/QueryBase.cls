/****************************************************************************************************
 *  @Author: Acumen Solutions
 *  @Purpose: Provide a base class for all SOQL queries, to prevent duplication
 *---------------------------------------------------------------------------------------------------
 *                      ----===[ HISTORY ]===---
 * Date        Developer        Description
 *---------------------------------------------------------------------------------------------------
 * 12/03/2012 Varun Nagarajan   Removed the old fields (AVP__c, Business__c and Market_Segment__c) 
 *                              and newly created fields: Business_Type__c and Market_Segment_New__c 
 *                              are used to represent the new ReOrg. Additionally, two new fields: 
 *                              Division__c and SBU__c are also added to the query.
 *
 * 03/14/2013 Tom Barrett       Added the Facets, Luminex and Nasco fields to the query in the 
 *                              getOpportunityById method so that they can now be included in the
 *                              cloning process when the clone button is clicked
 *
 * 02/16/2013 Tom Barrett (TPB) Added the getAllActivePricebookEntryIds method     
 * 02/28/2013 Tom Barrett (TPB) Added the  idIsOfSOb method   
 *
 * 03/27/2013 Varun Nagarajan   Added Network Leasing field to the query in the getOpportunityByid
 *                              method so that they can now be included in the cloning process
 *                              when the clone button is clicked 
 
 * 07/23/2013 Tom Barrett (TPB) Created new method isProductionOrg  
 
 * 07/25/2013 Tom Barrett (TPB) Added the National_Alliance_ID__c field to the select query in the
 *                              getOpportunityById method.  This makes sure that the field is cloned  
 *
 * 12/19/2013 Tom Barrett (TPB) Added the Contract_End_Date__c field to the select query in the
 *                              getOpportunityById method. This makes sure the new field is cloned
 *                              and this addition was done for the Gap Date Effort for Sprint 13  
 * 
 *                              Also added a new method named isAdman which returns true if 
 *                              the current user is an administrator; otherwise it returns false 
 * 
 * 06/06/2014 Tom Barrett (TPB) Removed the Won_Lost_Reason__c field from the query in the 
 *                              getOpportunityById method because the user know longer wanted it to clone.
 *                              Also added the Compensation_Owner__c to the query in the 
 *                              getOpportunityById method below so it clones       
 * 07/13/2014 Ashsih Ojha       Added getrecordtypeid method 
                                Let you pass the Object name and recordtype name to return
                                Record type id
 *07/14/2015 Ashish Ojha        Added  getAllOpportunitySurveyContact method to fetch Opportunity survey contact Records
 *07/14/2015 Ashish Ojha        Added  getAllOpportunityPrograms method to fetch Opportunity programs Records
 *07/14/2016 Rajesh Pennam      Replaced Contact__c field with ContactName__c and ContactID__c fields
 *07/18/2016 Rajesh Pennam      Updated Queries for Batch Jobs (UpdateSurveyContactsToNull,UpdateSurveyContactsToValue)
 * 12/17/2016 Ken Gill          Modify getRecordTypeId to address SOQL 101 errors from unit tests because the method is called
 *                              too many times (>100 governor limt) causing the tests to fail. This method now uses a static map recordTypeToIdMap 
 *                              to save SOQL queries within the same transaction context.
 *
 *10/17/2017 Vivek Sharma (VS) |T01|  Added field to Opportunity queiry for termination tracking opportunities 
 *                                    B-05295
 * 09/04/2018 Naeem T-Pearson  |T02|  For the purpose of test classes we are assuming that if the record type is medical then the retun is medical ASO
 * 9/5/2018    Arshia		   |T03|     Update Record Type for US-771
 ****************************************************************************************************
*/

public without sharing class QueryBase {
    
/* SOQL queries */

    // map to cache recordtypeId queries. Used by getRecordTypeId() method KG 12/17
public static Map<String,ID> recordTypeIdMap = new Map<String,ID>();

/*
* @purpose : The static method used to fetch Account Records by Ids
* @param : Ids - set of Account Ids
* @return: List of Account 
*/

    public static List<Account> getAllAccountByIds(Set<Id> Ids){
        List<Account> accList = new List<Account>();
        try{
            accList = [ Select a.OwnerId, a.Name, a.Test_Account_URL__c, a.id From Account a where a.id in : Ids];
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getAllAccountByIds is :' + qe);
        }
        return accList;
    }
    
/*
* @purpose : The static method used to fetch Opportunity Records by Ids
* @param : Ids - set of Opportunity Ids
* @return: List of Opportunity 
*/          
    public static List<Opportunity> getAllOpportunityByIds(Set<Id> Ids){
        List<Opportunity> oppList = new List<Opportunity>();
        try{
            oppList = [ Select o.Related_Products_Sold__c, o.Related_Products_Sold_Quantity__c, o.Related_Products_Offered__c, 
                        o.Related_Products_Offered_Quantity__c, o.Name, o.Id  
                        From Opportunity o where o.id in : Ids];
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getAllOpportunityByIds is :' + qe);
        }
        return oppList;
    }   
 
 /*
* @purpose : The static method used to fetch Opportunity Records by its Id
* @param : Ids - Opportunity Id
* @return: Opportunity 
*/    
    public static Opportunity getOpportunityById(Id oppId){
        Opportunity opp = new Opportunity();
        String q;
        try{
            q = 'Select Compensation_Owner__c, Facets_Grp_Num__c, National_Alliance_ID__c, NASCO_Acct_ID__c, Luminex__c, Net_Lease_Group_ID__c, Weaknesses__c, Underwriting_Status__c, Underwriting_Entity__c,'+ 
                'Underwriting_Completed__c,Effective_Date__c, Contract_End_Date__c,CloseDate ,Account.Name,MissingPartner__c ,Lead_Rep__c,Lead_Rep_Number__c, Lead_Rep_Name__c,  '+ 
                'Underwriter__c, Type, Transitioned__c, System__c, Strengths__c, StageName, Spec_Ded_Sold__c, Spec_Ded_Offered_4__c,'+ 
                'Spec_Ded_Offered_3__c, Spec_Ded_Offered_2__c, Spec_Ded_Offered_1__c, Sold_By_Carrier__c, Service_Rep__c,'+
                'Sent_to_Underwriting__c, Sent_to_NCAS_Underwriting__c, Sent_To_Market__c, SL_Comments__c, SL_Analyst__c, Risk_Non_Risk__c,'+
                'Received_by_Underwriting__c, Recd_Quote_Request__c, Radar__c, RFP_Strategy__c, RFP_Requested__c,'+ 
                'RFP_Expected_Receipt_Date__c, RFP_Due_Date__c, RFP_Comment__c, RFP_Actual_Receipt_Date__c, Proposal_Sent__c, Probability,'+ 
                'Pricebook2Id, Potential_Contracts__c, OwnerId, Other_Sold_Carrier__c, Market_Segment_New__c, MD_DC_DE_Underwriter_Comments__c,'+ 
                'Lead_Rep_Name_User__c, LeadSource, Last_Modified_By_User__c, IsWon, HasOpportunityLineItem,'+ 
                'HB_Sold__c, HB_Offered__c, GeneralProducer__c, FullServiceProducer__c, ForecastCategoryName, ForecastCategory, FiscalYear,'+ 
                'FiscalQuarter, Fiscal, Estimated_Actual_Contracts__c, Est_Actual_Contracts__c, Enrollment__c, Description, Declined_Reason__c,'+ 
                'Deadline_Date__c, Competitor__c, Business_Type__c, Division__c, SBU__c, Agg_Spec_Ded_Sold__c, Agg_Spec_Ded_Offered_4__c, Agg_Spec_Ded_Offered_3__c,'+ 
                 // T01 - BEGIN CHANGE VS 10/17/2017 
                'recordTypeID,number_of_Contracts__c,number_of_Member_Months__c,Rating_Type__c,Actual_Increase__c,Demo_Increase__c,Blend_Increase__c,Delivered_Increase__c,'+
                'Floor__c,Pooled_Amount__c,Gain_Loss__c,Overall_Loss_as_a_of_Revenue__c,Final_Rate_Increase__c,U_W_Sales_Management_Involved__c,Successor_Benefit_Comparison__c,'+
                'Savings__c,Loss_Ratio_Year_1__c,Loss_Ratio_Year_2__c,Loss_Ratio_Year_3__c,'+ 
                 //T01 - END CHANGE VS 10/17/2017 
                'Agg_Spec_Ded_Offered_2__c, Agg_Spec_Ded_Offered_1__c, Admin_Sold__c,Won_Lost_Reason__c,Incumbent_Successor__c, Admin_Offered__c, Account_in_Jeopardy__c, AccountId From Opportunity WHERE Id=\'' + oppId + '\' LIMIT 1';
                 
            opp = Database.query(q);        
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getOpportunityById is :' + qe);
        }
        
        return opp;
    }
    
/*
* @purpose : The static method used to fetch User Records by Ids
* @param : Ids - set of User Ids
* @return: List of User 
*/ 
    public static List<User >getUserByIds(Set <ID> Ids){
        List<User> user = new List<User>();
        try{
            user = [ Select u.Name, u.LastName, u.Id, u.FirstName, u.Email From User u where u.id in : Ids];
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getUserByIds is :' + qe);
        }
        return user;
    }
    
    /*
* @purpose : The static method used to fetch User Record by Id
* @param : Id - User Id
* @return:  User 
*/ 
    public static User getUserById(ID Id){
        User user = new User();
        try{
            user = [ Select u.Name, u.LastName,u.IsActive, u.Id, u.FirstName, u.Email From User u where u.id =: Id LIMIT 1];
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getUserById is :' + qe);
        }
        return user;
    }

/*
 * @purpose : The static method used to fetch current logged in User
 * @param : 
 * @return: User 
 */     
    public static User getCurrentUser(){
        
        User currentUser = new User();
        try{
            currentUser = [Select email, Name , id from User where username = :UserInfo.getUserName() limit 1];
        }
        catch(QueryException qe){
            System.debug('QueryException in QueryBase.getCurrentUser is :' + qe);   
        }
        return currentUser;
    }
 
/*
 * @purpose : The static method used to fetch OpportunityLineItem Records by Opportunity Ids
 * @param : oppIds - set of Opportunity Ids
 * @return: List of OpportunityLineItem 
 */    
    public static List<OpportunityLineItem> getAllOpportunityLineItemByOpportunityIds(Set<Id> oppIds){
        List<OpportunityLineItem> oppProductList = new List<OpportunityLineItem> ();
        try{
            oppProductList = [ Select  o.TotalPrice, o.Quantity, o.Product_Sold__c, o.PricebookEntry.Pricebook2Id,
                               o.PricebookEntry.Name, o.PricebookEntryId, o.OpportunityId, o.ListPrice, o.Id, o.Description 
                               From OpportunityLineItem o 
                               where o.OpportunityId in : oppIds];
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getAllOpportunityLineItemByOpportunityIds is :' + qe);
        }
        return oppProductList;
    }

/*
 * @purpose : The static method used to fetch OpportunityLineItem Records by Opportunity Id
 * @param : oppId - Opportunity Id
 * @return: List of OpportunityLineItem 
 */    
    public static List<OpportunityLineItem> getAllOpportunityLineItemByOpportunityId(Id oppId){
        List<OpportunityLineItem> oppProductList = new List<OpportunityLineItem> ();
        try{
            oppProductList = [ Select  o.TotalPrice, o.Quantity, o.Product_Sold__c, o.PricebookEntry.Pricebook2Id,o.PricebookEntry.IsActive, 
                               o.PricebookEntry.Name, o.PricebookEntryId, o.OpportunityId, o.ListPrice, o.Description 
                               From OpportunityLineItem o 
                               where o.OpportunityId  =: oppId and o.PricebookEntry.IsActive = true];
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getAllOpportunityLineItemByOpportunityId is :' + qe);
        }
        return oppProductList;
    }

/*
 * @purpose : The static method used to fetch OpportunityContactRole Records by Opportunity Id
 * @param : oppId - Opportunity Id
 * @return: List of OpportunityContactRole 
 */     
    public static List<OpportunityContactRole> getAllOpportunityContactRoleByOpportunityId(Id oppId){
        List<OpportunityContactRole> oppContactRoleList = new List<OpportunityContactRole> ();
        try{
            oppContactRoleList = [  Select o.Role, o.IsPrimary, o.Id, o.ContactId 
                                    From OpportunityContactRole o where o.OpportunityId  =: oppId];
            System.debug('Opportunity Contact Roles are :' + oppContactRoleList);                       
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getAllOpportunityContactRoleByOpportunityId is :' + qe);
        }
        return oppContactRoleList;
    }  
/*
 * @purpose : The static method used to fetch custom OpportunityContactRole Records by Opportunity Id
 * @param : oppId - Opportunity Id
 * @return: List of OpportunityContactRole 
 */     
    public static List<Opportunity_Contact_Role__c> getAllcustomOpportunityContactRoleByOpportunityId(Id oppId){
        List<Opportunity_Contact_Role__c> oppContactRoleList = new List<Opportunity_Contact_Role__c> ();
        try{            
            oppContactRoleList = [  Select o.Role__c, o.Primary__c, o.Id,o.Effective_Date__c,o.End_Date__c, o.Contact_Name__c 
                                    From Opportunity_Contact_Role__c o where o.Opportunity__c  =: oppId];
            System.debug('Opportunity custom Contact Roles are >>> :' + oppContactRoleList);                       
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getAllOpportunityContactRoleByOpportunityId is :' + qe);
        }
        return oppContactRoleList;
    }   
    
    /*
 * @purpose : The static method used to fetch custom OpportunityContactRole Records by Opportunity Id
 * @param : oppId - Opportunity Id
 * @return: List of OpportunityContactRole 
 */     
    public static List<FSP_GP__c> getAllcustomFSPGPByOpportunityId(Id oppId){
        List<FSP_GP__c> oppFSPGPList = new List<FSP_GP__c> ();
        try{            
            oppFSPGPList = [  Select o.Partner__c, o.Primary__c, o.Id, o.FSP_GP__c,o.Account__c,o.Effective_Date__c,o.End_Date__c
                                    From FSP_GP__c o where o.Opportunity__c  =: oppId];
            System.debug('Opportunity custom oppFSPGP are >>> :' + oppFSPGPList);                       
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getAllOpportunityContactRoleByOpportunityId is :' + qe);
        }
        return oppFSPGPList;
    } 
    
/*  public static List<APT__c> getAllAPTByOpportunityId(Id oppId){
        List<APT__c> aptList = new List<APT__c> ();
        try{
            aptList = [ Select a.Name, a.Meeting_Date__c, a.Functional_Area__c, 
                        a.Date_APT_Requested__c, a.Comments__c, a.APT_Type__c 
                        From APT__c a where  a.Opportunity_Name__c =: oppId];
                        
            System.debug('APT are :' + aptList);                        
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getAllAPTByOpportunityId() is :' + qe);
        }
        return aptList;
    }
*/

/*
 * @purpose : The static method used to fetch OpportunityPartner Records 
 * @param : oldOppId - Opportunity Id
 * @param : newAccountId - Account Id
 * @return: List of OpportunityPartner 
 */   
    public static List<OpportunityPartner> getAllOpportunityPartner(Id oldOppId , Id newAccountId){
        List<OpportunityPartner> oppPartnerList = new List<OpportunityPartner> ();
        try{
            oppPartnerList =[Select o.Role, o.OpportunityId, o.IsPrimary, o.AccountToId 
                             From OpportunityPartner o 
                             where o.OpportunityId =:oldOppId AND o.AccountToId <>: newAccountId ];
                    
            System.debug('OpportunityPartner are :' + oppPartnerList);                      
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getAllOpportunityPartner() is :' + qe);
        }
        return oppPartnerList;
    }
    
    /*
 * @purpose : The static method used to fetch Partner__c Records 
 * @param : oldOppId - Opportunity Id
 * @param : newAccountId - Account Id
 * @return: List of Partner__c 
 */   
    public static List<Partner__c> getAllcustomOpportunityPartner(Id oldOppId , Id newAccountId){
        List<Partner__c> oppPartnerList = new List<Partner__c> ();
        try{
            oppPartnerList =[Select o.Role__c, o.Opportunity__c, o.Primary__c, o.Partner__c,o.Effective_Date__c,o.End_Date__c 
                             From Partner__c o 
                             where o.Opportunity__c =:oldOppId AND o.Partner__c <>: newAccountId];
                    
            System.debug('Partner__c are :' + oppPartnerList);                      
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getAllOpportunityPartner() is :' + qe);
        }
        return oppPartnerList;
    }

/* 
 * @created : Ashish Ojha
 * @purpose : The static method used to fetch OpportunityProgram Records 
 * @param : oldOppId - Opportunity Id
 * @param : newAccountId - Account Id
 * @return: List of OpportunityPrograms 
 */   
    public static List<Programs__c> getAllOpportunityPrograms(Id oldOppId){
        List<Programs__c> oppProgramList = new List<Programs__c> ();
        try{
            oppProgramList =[Select id, Name, Denial_Reason__c, Off_Cycle_Program_Term_Date__c,
                             Opportunity_Name__c, Program_Decision__c, Program_Effective_Date__c
                             ,Program_Offered__c
                             From Programs__c  
                             where Opportunity_Name__c =:oldOppId ];
                    
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getAllOpportunityPrograms() is :' + qe);
        }
        return oppProgramList;
    }
/* 
 * @created : Ashish Ojha
 * @purpose : The static method used to fetch OpportunitySurveyContact Records 
 * @param : oldOppId - Opportunity Id
 * @return: List of OpportunitySurveyContacts 
 * @Comments : Rajesh Pennam
 * BEGIN CHANGE RP 07/14/2016 - Updated the Contact ID and Contact Name fields with Contact lookup field
 */   
    public static List<Survey_Contacts__c> getAllOpportunitySurveyContact(Id oldOppId){
        List<Survey_Contacts__c> oppSurvContact = new List<Survey_Contacts__c> ();
        try{
            //07/18/2016 Rajesh Pennam      
            /*   oppSurvContact =[Select id, Name, ContactID__c, Contact_Name__c,
                             Opportunity__c, Phone__c, Surveys__c
                             ,Title__c ,Email__c 
                             From Survey_Contacts__c  
                             where Opportunity__c =:oldOppId ]; */
               oppSurvContact =[Select id, Name, Contact__c,
                             Opportunity__c, Phone__c, Surveys__c
                             ,Title__c ,Email__c 
                             From Survey_Contacts__c  
                             where Opportunity__c =:oldOppId ];
                    
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getAllOpportunitySurveyContact() is :' + qe);
        }
        return oppSurvContact;
    }    
/* Insert , Update Stataments   */

/*
 * @purpose : The static method used to update Account Records
 * @param : acc - List of Account
 * @return: List of Account
 */ 
     public static List<Account> updateAccountRecords(List<Account> acc){
        
        if(acc.size()> 0){
            acc = (List<Account>)updateRecords(acc);        
        }
            System.debug('QueryBase: updated Account Records :' + acc.size());
            return acc;
    }
    
/*
 * @purpose : The static method used to update Opportunity Records
 * @param : opp - List of Opportunity
 * @return: List of Opportunity
 */     
    public static List<Opportunity> updateOpportunityRecords(List<Opportunity> opp){
        
        if(opp.size()> 0){
            opp = (List<Opportunity>)updateRecords(opp);     
        }
            System.debug('QueryBase: updated Opportunity Records :' + opp.size());
            return opp;
    }
    
/*
 * @purpose : The static method used to insert Opportunity Record
 * @param : opp - Opportunity Record
 * @return: Opportunity
 */     
    public static Opportunity insertOpportunity(Opportunity opp){
        
        try{
            insert opp;
        }
        catch(System.DmlException ex){
            System.debug('Exception During Opportunity Insert Process: ' + ex.getMessage());
            opp.addError('Click your browser\'s back button to continue');
            throw ex;            
        }
        return opp;
    }

/*
 * @purpose : The static method used to insert Opportunity Records
 * @param : opp - List of Opportunity Records
 * @return: List of Opportunity
 */     
    public static List<Opportunity> insertOpportunityRecords(List<Opportunity> opp){
        
        if(opp.size()> 0){
            opp = (List<Opportunity>)insertRecords(opp);
        }
            System.debug('QueryBase: insert Opportunity Records :' + opp.size());
            return opp;
    }

/*
 * @purpose : The static method used to insert OpportunityLineItem Records
 * @param : opp - List of OpportunityLineItem Records
 * @return: List of OpportunityLineItem
 */    
    public static List<OpportunityLineItem> insertOpportunityLineItemRecords(List<OpportunityLineItem> oppLineItems){
        
        if(oppLineItems.size()> 0){
            oppLineItems = (List<OpportunityLineItem>)insertRecords(oppLineItems);            
        }
            System.debug('QueryBase: insert OpportunityLineItem Records :' + oppLineItems.size());
            return oppLineItems;
    }

/*
 * @purpose : The static method used to insert OpportunityLineItem Records
 * @param : opp - List of OpportunityLineItem Records
 * @return: List of OpportunityLineItem
 */     
      public static List<OpportunityContactRole> insertOpportunityContactRoleRecords(List<OpportunityContactRole> oppContactRoles){
        
        if(oppContactRoles.size()> 0){
            oppContactRoles = (List<OpportunityContactRole>)insertRecords(oppContactRoles);            
        }
            System.debug('QueryBase: insert OpportunityContactRole Records :' + oppContactRoles.size());
            return oppContactRoles;
    }
    
        /*
 * @purpose : The static method used to insert OpportunityLineItem Records
 * @param : opp - List of OpportunityLineItem Records
 * @return: List of OpportunityLineItem
 */     
      public static List<Opportunity_Contact_Role__c> insertCustomOpportunityContactRoleRecords(List<Opportunity_Contact_Role__c> oppContactRoles){
        
        if(oppContactRoles.size()> 0){
            oppContactRoles = (List<Opportunity_Contact_Role__c>)insertRecords(oppContactRoles);            
        }
            System.debug('QueryBase: insert OpportunityContactRole Records :' + oppContactRoles.size());
            return oppContactRoles;
    }

/*
 * @Created : Ashish Ojha
 * @purpose : The static method used to insert Program Records
 * @param : opp - List of Program Records
 * @return: List of Program
 */     
      public static List<Programs__c> insertProgramRecords(List<Programs__c> programs){
        
        if(programs.size()> 0){
            programs = (List<Programs__c>)insertRecords(programs);            
        }
        return programs;
    }
/*
 * @Created : Ashish Ojha
 * @purpose : The static method used to insert SurveyContact Records
 * @param : opp - List of SurveyContact Records
 * @return: List of SurveyContact 
 */     
      public static List<Survey_Contacts__c> insertSurveyContactRecords(List<Survey_Contacts__c> surveys){
        
        if(surveys.size()> 0){
            surveys = (List<Survey_Contacts__c>)insertRecords(surveys);            
        }
        return surveys;
    }
/*
 * @purpose : The static method used to insert Partner Records
 * @param : partners - List of Partner Records
 * @return: List of Partner
 */    
    public static List<Partner> insertOpportunityPartnerRecords(List<Partner> partners){
        
        if(partners.size()> 0){
            partners = (List<Partner>)insertRecords(partners);            
        }
            System.debug('QueryBase: insert insertPartner Records :' + partners.size());
            return partners;
    }
    /*
 * @purpose : The static method used to insert Partner Records
 * @param : partners - List of Partner Records
 * @return: List of Partner
 */    
    public static List<Partner__c> insertCustomOpportunityPartnerRecords(List<Partner__c> partners){
        
        if(partners.size()> 0){
            partners = (List<Partner__c>)insertRecords(partners);            
        }
            System.debug('QueryBase: insert insertPartner Records :' + partners.size());
            return partners;
    }
    
      /*
 * @purpose : The static method used to insert Partner Records
 * @param : fspgp - List of Partner Records
 * @return: List of Partner
 */    
    public static List<FSP_GP__c> insertFSPGPRecords(List<FSP_GP__c> fspgp){
        
        if(fspgp.size()> 0){
            fspgp = (List<FSP_GP__c>)insertRecords(fspgp);            
        }
            System.debug('QueryBase: insert fspgp Records :' + fspgp.size());
            return fspgp;
    }
    
/*
 * @purpose : The private static method used to insert sObject Records
 * @param : records - List of sObject Records
 * @return: List of sObject
 */    
    
     private static List<sObject>  insertRecords(List<sObject> records) {
        try{
            insert records;
            System.debug('QueryBase: No of inserted records :' + records.size());
        }
        catch(System.DmlException ex){
            System.debug('Exception During Insert Process: ' + ex.getMessage());
         }
         
         return records;
        
    }
/*
 * @purpose : The private static method used to update sObject Records
 * @param : records - List of sObject Records
 * @return: List of sObject
 */    
      private static List<sObject>  updateRecords(List<sObject> records) {
        try{
            update records;
            System.debug('QueryBase: No of updated records :' + records.size());
        }
        catch(System.DmlException ex){
            System.debug('Exception During Update Process: ' + ex.getMessage());
         }
         
         return records;
        
    }
    
/* TPB      : 02/16/2013
 * @purpose : The public static method used to retrieve a Map of active PricebookEntry
 *            product names and Ids.  The names are converted to uppercase before adding 
 *            them to the Map.
 * @param   : Pricebook2 ID (Currently we are using '01s3000000005gYAAQ')
 * @return  : Map of PricebookEntry names and associated ids
 * Usage    : Map<String, ID> Products = QueryBase.getAllActivePricebookEntryIds('01s3000000005gYAAQ');
 *            String results = Products.get('tpA - Cfa'.toUpperCase());
 */  
/*    public static Map<String, Id> getAllActivePricebookEntryIds(Id Pricebook2Id) {
        List<PricebookEntry> pbes = [SELECT Id, Name FROM PricebookEntry 
                                     WHERE isActive = TRUE AND Pricebook2Id = :PriceBook2Id ];
        Map<String, Id> ActivePricebookEntryIdsMap = new Map<String, Id>();
        for ( PricebookEntry pbe : pbes) {
            ActivePricebookEntryIdsMap.put(pbe.Name.toUpperCase(), pbe.id);
        }        
        System.debug('QueryBase.getAllActivePricebookEntryIds: ' + ActivePricebookEntryIdsMap.size()); 
        return ActivePricebookEntryIdsMap;
    }  
*/

/* TPB      : 04/04/2013
 * @purpose : The public static method used to retrieve a Map of active or inactive PricebookEntry
 *            product names and Ids.  The names are converted to uppercase before adding 
 *            them to the Map.
 * @param   : Pricebook2 Name (Currently we are using 'Standard Price Book')
 * @return  : Map of PricebookEntry names and associated ids
 * Usage    : Map<String, ID> Products = QueryBase.getAllPricebookEntryIds('Standard Price Book');
 *            String results = Products.get('tpA - Cfa'.toUpperCase());
 */  
    public static Map<String, Id> getAllPricebookEntryIds(String PriceBookName) {        
        Id pb2Id = [ SELECT id FROM PriceBook2 WHERE Name = :PriceBookName limit 1 ].id;  //added by rajesh word limit 1      
        List<PricebookEntry> pbes = [SELECT Id, Name FROM PricebookEntry 
                                     WHERE Pricebook2Id = :pb2Id ];
        Map<String, Id> ActivePricebookEntryIdsMap = new Map<String, Id>();
        for ( PricebookEntry pbe : pbes) {
            ActivePricebookEntryIdsMap.put(pbe.Name.toUpperCase(), pbe.id);
        }        
        System.debug('QueryBase.getAllActivePricebookEntryIds: ' + ActivePricebookEntryIdsMap.size()); 
        return ActivePricebookEntryIdsMap;
    }      


/* TPB      : 02/28/2013
 * @purpose : To detect if the supplied id matches the supplied object name            
 * @param   : SobjectName is  a name of any object i.e.: 'Account'
 *          : theId is the id of an object record.
 * @return  : Returns true if the id matches the supplied object name type
 * Usage    : Boolean Matches;
 *          : Matches = QueryBase.idIsofSobj('Account', '0016000000MEugU');
 */  
    public static Boolean idIsOfSObj(String SObjName, ID theId) {
        Map<String, Schema.SObjectType> sobjToSobjDescribeMap = null;
        if (sobjToSobjDescribeMap == null) 
            sobjToSobjDescribeMap= Schema.getGlobalDescribe();
            
        String idKeyPrefix = theId != null ? ((String) theId).substring(0,3) : null;
        if (sobjToSobjDescribeMap.get(SObjName).getDescribe().getKeyPrefix() == idKeyPrefix) return true;
        return false;    
    }
    
/* TPB      : 07/16/2013
 * @purpose : To detect if the current ORG is production.  It assumes the org id is: 00D300000000DlXEAU
 * @param   : None
 * @return  : Boolean
 * @Usage   : booleanVariable = QueryBase.isProductionOrg();
 *       Or : if ( QueryBase.isProductionOrg() ) {...
 */  
    public static Boolean isProductionOrg() {
        Boolean ProductionOrg;
        ProductionOrg = False;
        Organization CurrentOrg;
        CurrentOrg = [ SELECT Id FROM Organization LIMIT 1 ];        
        if ( CurrentOrg.Id == '00D300000000DlXEAU') {
            ProductionOrg = True;
        }  
        return ProductionOrg;
    } 
    
/* TPB      : 12/19/2013
 * @purpose : To detect if the logged in user is an administrator
 * @param   : None
 * @return  : Boolean
 * @Usage   : if the user is an admin return TRUE; otherwise FALSE
 */ 
    public static Boolean isAdmin() {
       integer sysAdmin = 0;
        boolean adminLoggedIn = false;
        id proId = UserInfo.getProfileId();
   
        sysAdmin = [ SELECT Count() FROM profile WHERE id = :proId and Name = 'System Administrator'];
        if  (sysAdmin == 1 ) {
            adminLoggedIn = true;
        } 
        return adminLoggedIn; 
    }
    
      /*
* @purpose : The static method used to fetch the Recordtype Id 
* @param : object name, Record type name
* @return:  Record type id
*           This method uses a static map to save SOQL queries within the same transaction context KG 12/17/16
*/ 
       
    public static ID getRecordtypeId(string objName, string RecordtypeName){
        // first try to use saved ID. The static map is good within same transaction and prevents SOQL 101 errors
        // as this method is called many times. KG 12/17/16
        // T02 Begin - for the purpose of test classes we are assuming that if the record type is medical then the retun is medical ASO
      /*  If(RecordTypeName == 'Medical')
        {
            RecordTypeName = 'Medical_ASO';
        }
*/
        // T02 End
        // T03-Begin
        if(RecordTypeName == 'Medical' && (objName=='Proposed_Products__c' || objName=='AIA_Benefit_Design_Product__c'))
             RecordtypeName='Medical_Risk';
		//T03-End
		
        Id savedId = recordTypeIdMap.get( objName + RecordtypeName);
        if( savedId != null) return savedId;

        Recordtype Rt = new Recordtype();
        try{
            //T03-Begin
            If(RecordTypeName == 'Medical' && (objName=='Proposed_Products__c' || objName=='AIA_Benefit_Design_Product__c')){
                Rt = [SELECT id FROM RecordType where SobjectType =: objName and DeveloperName = 'Medical_Risk'];
            }
            else{
            	Rt = [SELECT id FROM RecordType where SobjectType =: objName and DeveloperName=: RecordtypeName];
            }
            //T03-End
            if( Rt != null) recordTypeIdMap.put( objName + RecordtypeName, Rt.Id); 
        }
        catch (QueryException qe) {
            System.debug('QueryException in QueryBase.getRecordtypeId is :' + qe);
        }
        return Rt.id;
    }       
    
/*
        Author : Rajesh Pennam
        Purpose : This Method will return query for batch class of survey contact update TO Null
        param : string of query
        BEGIN CHANGE RP 07/18/2016 - Added queries for bathc jobs (UpdateSurveyContactsToNull and UpdateSurveyContactsToValue)
*/  
    public static string querytoNull = '';
    public static string getQueryToNull(){
         //Get Survey Contact List based on Conditions we have on Opportunity.
        querytoNull = '';
        querytoNull += 'select Id,Contact__c from Survey_Contacts__c Where Contact__c != null';
        querytoNull += ' AND (Opportunity__r.RecordType.Name = \'51+\' OR Opportunity__r.RecordType.Name = \'200+\') ';
        querytoNull += ' AND (Opportunity__r.StageName = \'Proposal\' OR Opportunity__r.StageName = \'Sold\')';
        querytoNull += ' AND Opportunity__r.SBU__c = \'Large\'';
        querytoNull += ' AND (Opportunity__r.Market_Segment_New__c = \'200-999\' OR Opportunity__r.Market_Segment_New__c = \'1000+\')';

        querytoNull += ' AND (Surveys__c = \'Executive;Day to Day\' OR Surveys__c = \'Executive\' OR Surveys__c = \'Day to Day\')';
        return querytoNull;
    }
    /*
        Author : Rajesh Pennam
        Purpose : This Method will return query for batch class of survey contact update To Value
        param : string of query
    */  
    public static string querytoValue = '';
    public static string getQueryToValue(){
         //Get Survey Contact List based on Conditions we have on Opportunity.
        querytoValue += 'select Id,Contact__c from Survey_Contacts__c Where Contact__c != null';
        querytoValue += ' AND (Opportunity__r.RecordType.Name = \'51+\' OR Opportunity__r.RecordType.Name = \'200+\') ';
        querytoValue += ' AND (Opportunity__r.StageName = \'Proposal\' OR Opportunity__r.StageName = \'Sold\')';
        querytoValue += ' AND Opportunity__r.SBU__c = \'Large\'';
        querytoValue += ' AND (Opportunity__r.Market_Segment_New__c = \'200-999\' OR Opportunity__r.Market_Segment_New__c = \'1000+\')';
        querytoValue += ' AND Opportunity__r.Effective_Date__c <= Today';
        querytoValue += ' AND Opportunity__r.Contract_End_Date__c > Today';
        querytoValue += ' AND (Surveys__c = \'Executive;Day to Day\' OR Surveys__c = \'Executive\' OR Surveys__c = \'Day to Day\')';       
        return querytoValue;
    }  
}