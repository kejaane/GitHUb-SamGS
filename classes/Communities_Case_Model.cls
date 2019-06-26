/* =========================================================================================
 * Date         : 08/01/2016
 * Developer    : Laveen Kattela
 * Purpose      : This Apex Class is used for brokar portal Communities as generic Case Model, its a Global class used for Community Home Page. 
 *                
 *                1.A sub-class called HomPageSummary - which holds all the variables delclared in it(For "My cases" and "Agency Cases"). It is Used to pass the values from Apex to UI.   
 *                2.A sub-class called CaseRecord - all varibale declared to hold Some field on Case object 
 *                  
 *=========================================================================================
 * Update History
 *  ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 08/01/16   |  Laveen Kattela    | Initial Version                                          
 *===========+============+================================================================
 */
global  with sharing class Communities_Case_Model
{

  // Home Page Models
  global class HomePageSummary {
  
      Public Integer myCases;             //used to get all Mycases 
      Public Integer openCases;           //used to get all Open cases 
      Public Integer INprogressCases;
      Public Integer closedCases;
      
      Public Integer AgencyCases;
      Public Integer AopenCases;
      Public Integer AresolvedCases;
      Public Integer AclosedCases; 
      // For My Cases Section 
      public List<CaseRecord> caseList;                 //To get all list of case list for a User
      public List<CaseRecord> mycaseList;               //To get all list of case related to particular user
      public List<CaseRecord> openCasesList;            //To get list of In-Progress cases 
      public List<CaseRecord> INprogressCasesList;      //To get list of Closed cases
      public List<CaseRecord> closedCasesList;
      //For Agency Cases Section
      public List<CaseRecord> AgencyCasesList;          //To get all list of Agency case list 
      public List<CaseRecord> AopenCasesList;           //To get all list of Agency cases which are open Status 
      public List<CaseRecord> AINprogressCasesList;     //To get all list of agency cases which are In-progress
      public List<CaseRecord> AclosedCasesList;         //To get all list of Agency cases which are in closed status
      public Boolean isShowAgencyCasses;                //The Flag to show the Agency cases section
      public Boolean isShowMyCasses;                    //Flag to show Mycases section 
      public User user;                                 //To get the user  
  
  }
  
  // Case record Model - This class holds the list of fields on Case object 
  global class CaseRecord{
      Public String CaseNumber;     // For Case Number
      Public String Subject;        // For Subject    
      public String GroupNameID;    // For Group__c
      public String SubscriberID;   // For Subscriber_ID__c
      public String Status;         // For Broker_Status__c
      Public DateTime Createdon;    // For CreatedDate
      Public ID cid;                // For case ID
      Public String Origin;         // For Case Origin
      public DateTime Closedon;     // Resolution Reson posted date/case closed date
  
  
  }
  public static void dummyMethod(){
  }
}