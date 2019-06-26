/* =========================================================================================
 * Date         : 08/01/2016
 * Developer    : Laveen Kattela
 * Purpose      : This Apex controller is for Communities_Homepage(VF Page). This class holds the total functionality of "community Home Page" body section.
 *                
 *                1.It has logic for "MY CASES" section to left side      -  logic for Open Cases , Resolved Cases & Closed Cases 
 *                2.It has logic for "AGENCY CASES" section to Right side  - logic for Open Cases , Resolved Cases & Closed Cases 
 *                3.It has Logic for "Recent Cases" section grid view - when the User logged in, it defaults to shows the Recently created Cases.
 *                4.It has Logic behind the The Grid View Contains list of fields to display - Case Number,Subject ,Group Name ID,Subscriber ID,Status & Created on.
 *                5.It has Logic behind the Click on "Case Number" or "Subject" Hyper link navigate to "Case Detail page"
 *                  
 *=========================================================================================
 * Update History
 *  ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 08/01/16   |  Laveen Kattela    | Initial Version                                          
 *===========+============+================================================================
 */

global with sharing class Communities_HomePage {
    //Query to get all case fields
    public final static String CASE_QUERY_FIELDS ='SELECT CaseNumber,ClosedDate,CreatedById,Communitie_Group_ID__c,CreatedDate,Origin,IsClosed,OwnerId,Group__r.Group_id__c,Priority,Broker_Status__c,Resolution_Reason_Posted_Date__c,Group__c,Reason,Status,Subject,Type,Group_ID__c,Subscriber_ID__c ';
   
    // Remote action to get the data Dynamcially loaded at one go when ones the user entered into community
    @RemoteAction
    global static Communities_Case_Model.HomePageSummary getCaseSummary() {
    
        Communities_Case_Model.HomePageSummary cm = new Communities_Case_Model.HomePageSummary();
        //Query user record to know if he is assitant or not - to show the user accordingly  to his role
        User user = [Select id, Broker_Role__c,ContactId from user where id =:UserInfo.getUserId() ];
        List<Communities_Case_Model.CaseRecord> caseRecords = new List<Communities_Case_Model.CaseRecord>();
        
        //checking the user based on their Role if he is assistant
        if(user.Broker_Role__c != null && user.Broker_Role__c == 'Assistant')
        {
            if(user.ContactId != null)              //Checking user Contact exist or not
            {
                cm.isShowAgencyCasses = true;       //Shows the Agency cases - Making flag as true based on thrie role
                cm.isShowMyCasses = true;           //Shows the My cases - Making flag as true based on thrie role   
                // Recent cases : on load to show recent case for the Assistant.
               
                //getCaseRecords(cm); 
                //Getting the information of logged in User id 
                id uid = userinfo.getUserId();
                id conid = user.ContactId;
                String QueryString = CASE_QUERY_FIELDS+' From Case where Contactid = : conid ORDER BY CreatedDate DESC ';   //query the case with where claues & owner id records             
                List<Case> myclist = Database.query(QueryString);                                                      //created a list called Myclist which hold the values to pass to visual force page
                //Getting Values for For "My cases" Section 
                cm.caseList = getCaseModelRecords(myclist);                                                             //Getting all list of cases and storing that to List<CaseRecords> CaseList declared in Case_model class         
                cm.mycaseList = getCaseModelRecords(myclist);                                                           //Getting all list of user cases and storing that to List<CaseRecords> mycaseList 
                cm.openCasesList = getCaseModelRecords(myclist,'Open');                                                 //Getting all list of Open cases and storing that to List<CaseRecords> openCasesList 
                cm.INprogressCasesList = getCaseModelRecords(myclist,'In-Progress');                                    //Getting all list of In-Progress cases and storing that to List<CaseRecords> InprogressList 
                cm.closedCasesList = getCaseModelRecords(myclist,'Closed');                                             //Getting all list of Closed cases and storing that to List<CaseRecords> ClosedCasesList 
                
                //Getting vaules for Agency Cases section
                List<Case> agentclist = Database.query(CASE_QUERY_FIELDS+' From Case ORDER BY CreatedDate DESC ');      // Query the case from case object with order by
                cm.AgencyCasesList = getCaseModelRecords(agentclist);                                                   // Getting all list of Agency cases and storing that to List<CaseRecords> AgencyCasesList 
                cm.AopenCasesList = getCaseModelRecords(agentclist,'Open');                                             //Getting all list of open Agency cases and storing that to List<CaseRecords> AopenCasesList 
                cm.AINprogressCasesList = getCaseModelRecords(agentclist,'In-Progress');                                //Getting all list of In-progress Agency cases and storing that to List<CaseRecords> AInprogressCasesList 
                cm.AclosedCasesList = getCaseModelRecords(agentclist,'Closed');                                         //Getting all list of Closed Agency cases and storing that to List<CaseRecords> AclosedCasesList 
            }
        
        }
        
        //If the user role is Broker Agent
        if(user.Broker_Role__c != null && user.Broker_Role__c == 'Broker Agent')
        {
            if(user.ContactId != null)
            {
                cm.isShowAgencyCasses = false;                                                //Setting the flag to false for agency cases
                cm.isShowMyCasses = true;                                                     //setting the flag to true for my cases
                // Recent cases : on load to show recent case for the Broker Agent.
                //Set<id> cids = getRecentCaseVeiwRecords();              
               
                getCaseRecords(cm);            //Calling the method - where all the list of open, in-progess & closed cases from case object for that particular user 
            
            }
        
        }        
        
        return cm;
    }
    
    global static List<Communities_Case_Model.CaseRecord> getCaseModelRecords(List<Case> clist) {
        List<Communities_Case_Model.CaseRecord> caseRecords= new List<Communities_Case_Model.CaseRecord>();
        if(clist != null && clist.size()>0){
            for(Case cobj: clist ){
                caseRecords.add(getCaseModelRecord(cobj));
            }       
        }
        return caseRecords;
    }
    global static List<Communities_Case_Model.CaseRecord> getCaseModelRecords(List<Case> clist,String Status) {
        List<Communities_Case_Model.CaseRecord> caseRecords= new List<Communities_Case_Model.CaseRecord>();
        if(clist != null && clist.size()>0){
            for(Case cobj: clist ){
                if(cobj.Broker_Status__c == Status)
                {                   
                    caseRecords.add(getCaseModelRecord(cobj));
                }
            }       
        }
        return caseRecords;
    }
    
    
    public static void getCaseRecords(Communities_Case_Model.HomePageSummary  cm){
    
            String QueryString = CASE_QUERY_FIELDS+' From Case ORDER BY CreatedDate DESC';  //quering the records from the case 
            List<Case> myclist = Database.query(QueryString);                               //storing that list of records in Myclist
            cm.caseList = getCaseModelRecords(myclist);                                     //Assigning that list to CaseList
            cm.mycaseList = getCaseModelRecords(myclist);                                   //Assigning that to MycaseList
            cm.openCasesList = getCaseModelRecords(myclist,'Open');                         // Getting all the open cases and storing that to OpenCasesList
            cm.INprogressCasesList = getCaseModelRecords(myclist,'In-Progress');            // Getting all the In-progress cases and storing that to INprogressCasesList 
            cm.closedCasesList = getCaseModelRecords(myclist,'Closed');                     // Getting all the Closed cases and storing that to closedCasesList 
    }
    
    
    
    
    //Method to get the case records by passing the Case obj as parameter 
    public static Communities_Case_Model.CaseRecord getCaseModelRecord(Case cobj) {
        Communities_Case_Model.CaseRecord cr = new Communities_Case_Model.CaseRecord();   //Creating the instants
        cr.CaseNumber = cobj.CaseNumber;                                                  //Assigning the CaseNumber field API to "CaseNumber" declared in Case model class(CaseRecord - class)
        cr.Subject = cobj.Subject;                                                        //Assigning the Subject field  to "Subject " declared in Case model class(CaseRecord - class)
        cr.Status = cobj.Broker_Status__c;                                                //Assigning the Broker_Status__c field  to "Status " declared in Case model class(CaseRecord - class)
        cr.Createdon = cobj.CreatedDate;                                                  //Assigning the CreatedDate field  to "Createdon " declared in Case model class(CaseRecord - class)
        //cr.GroupNameID = cobj.Group__r.Group_id__c;                                                   //Assigning the Group__c field  to "GroupNameID " declared in Case model class(CaseRecord - class)
        cr.SubscriberID= cobj.Subscriber_ID__c;                                           //Assigning the Subscriber_ID__c field  to "SubscriberID" declared in Case model class(CaseRecord - class)
        cr.cid = cobj.id;                                                                 //Assigning the Case ID field  to "Cid" declared in Case model class
        cr.Origin = cobj.Origin;
        cr.Closedon = cobj.Resolution_Reason_Posted_Date__c;                              //Assigning the Resolution_Reason_Posted_Date__c field  to "Closedon " declared in Case model class(CaseRecord - class)
        cr.GroupNameID = cobj.Communitie_Group_ID__c;
        return cr;                                                                        // return the cr
        
    
    }
   
    
}