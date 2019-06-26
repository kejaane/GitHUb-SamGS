/* =========================================================================================
 * Date         : 08/01/2016
 * Developer    : Laveen Kattela
 * Purpose      : This Controller is for SBU_Communities_My_Cases_Page. It handles all the controller part of that page. 
 *                It has  My cases And Agency Cases Tab  
 *                1. "MY CASES"  - Which only visiable's to Broker Agent & Asiistant    -  Filters logic in place, you can filter the cases based on input value on the particular field  
 *                2. "AGENCY CASES" - (visiable to  Assistant)  - Filters logic in place
 *                3.  Eight fields are displayed for the quick view on the page
 *                   
 *=========================================================================================
 * Update History
 *  ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 08/01/16   |  Ashish            | Initial Version 
 * 08/15/16   |  Laveen Kattela   | Added logic for My cases, Agency Cases & fields.                                     
 *===========+============+================================================================
 */
global with sharing class SBU_MyCasesPageController{
    
    //Query to get all case fields
    public final static String CASE_QUERY_FIELDS ='SELECT CaseNumber,ClosedDate,CreatedById,Communitie_Group_ID__c,Group__c,Group__r.Group_id__c,CreatedDate,Origin,IsClosed,OwnerId,Priority,Broker_Status__c,Resolution_Reason_Posted_Date__c,Reason,Status,Subject,Type,Group_ID__c,Subscriber_ID__c ';
    
    @RemoteAction
   global static Communities_Case_Model.HomePageSummary getCaseSummary() {
        Communities_Case_Model.HomePageSummary cm = new Communities_Case_Model.HomePageSummary();
        //Query user record to know if he is assitant or not - to show the user accordingly  to his role
        User user = [Select id, Broker_Role__c,ContactId from user where id =:UserInfo.getUserId() ];
        List<Communities_Case_Model.CaseRecord> caseRecords = new List<Communities_Case_Model.CaseRecord>();
        //checking the user based on their Role if he is assistant
        if(user.Broker_Role__c != null && user.Broker_Role__c == 'Assistant')
        {
                cm.isShowAgencyCasses = true;       //Shows the Agency cases - Making flag as true based on thrie role
                cm.isShowMyCasses = true;
                id uid = userinfo.getUserId();
                id conid = user.ContactId;                
                String QueryString = CASE_QUERY_FIELDS+' From Case where contactid = :conId ORDER BY CreatedDate DESC ';   //query the case with where claues & owner id records             
                List<Case> myclist = Database.query(QueryString);
                //created a list called Myclist which hold the values to pass to visual force page
                //Getting Values for For "My cases" Section 
                cm.caseList = Communities_HomePage.getCaseModelRecords(myclist);
                //storing that to List<CaseRecords> CaseList declared in Case_model class         
                cm.mycaseList = Communities_HomePage.getCaseModelRecords(myclist); 
                //Getting vaules for Agency Cases section
                List<Case> agentclist = Database.query(CASE_QUERY_FIELDS+' From Case ORDER BY CreatedDate DESC ');      // Query the case from case object with order by
                cm.AgencyCasesList = Communities_HomePage.getCaseModelRecords(agentclist); 
        }
        //If the user role is Broker Agent
        if(user.Broker_Role__c != null && user.Broker_Role__c == 'Broker Agent')
        {
            if(user.ContactId != null)
            {
                cm.isShowAgencyCasses = false;                                                //Setting the flag to false for agency cases
                cm.isShowMyCasses = true;                                                     //setting the flag to true for my cases
                String QueryString = CASE_QUERY_FIELDS+' From Case ORDER BY CreatedDate DESC';  //quering the records from the case 
                List<Case> myclist = Database.query(QueryString);                               //storing that list of records in Myclist
                cm.caseList = Communities_HomePage.getCaseModelRecords(myclist);             //Assigning that list to CaseList
                cm.mycaseList = Communities_HomePage.getCaseModelRecords(myclist);     
            
            }
        
        }        
        
        return cm;
     
   }
    global static String getContacts() {
     return JSON.serialize([select id, CaseNumber,Subject,Group_ID__c,Communitie_Group_ID__c, Subscriber_Id__c ,Status , createddate from case  ]);
   }
}