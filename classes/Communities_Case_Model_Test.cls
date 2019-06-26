@isTest
private class Communities_Case_Model_Test{

    // This test method can access private members of another class 
    // that are annotated with @TestVisible.
    static testmethod void Case_Model_Test() {
        Communities_Case_Model.CaseRecord  crec = new Communities_Case_Model.CaseRecord();
      crec.CaseNumber='cnumb';     // For Case Number
      crec.Subject ='Test Subject';        // For Subject    
      crec.GroupNameID='Gid';    // For Group__c
      crec.SubscriberID='sid';   // For Subscriber_ID__c
      crec.Status='status';         // For Broker_Status__c
      crec.Createdon= system.now();    // For CreatedDate
      crec.cid=null;                // For case ID
      crec.Origin='origin';         // For Case Origin
      crec.Closedon=system.now();     // Resolution Reson posted date/case closed date

        
        // Access private inner class
        Communities_Case_Model.HomePageSummary emp = 
            new Communities_Case_Model.HomePageSummary ();
            
      emp.myCases=1;             //used to get all Mycases 
      emp.openCases=1;           //used to get all Open cases 
      emp.INprogressCases=1;
      emp.closedCases=1;
      
      emp.AgencyCases=1;
      emp.AopenCases=1;
      emp.AresolvedCases=1;
      emp.AclosedCases=1; 
      // For My Cases Section 
      emp.caseList= new List<Communities_Case_Model.CaseRecord>{crec};
      emp.mycaseList=new List<Communities_Case_Model.CaseRecord>{crec};               //To get all list of case related to particular user
      emp.openCasesList= new List<Communities_Case_Model.CaseRecord>{crec};
      emp.INprogressCasesList= new List<Communities_Case_Model.CaseRecord>{crec};
      emp.closedCasesList= new List<Communities_Case_Model.CaseRecord>{crec};
      //For Agency Cases Section
      emp.AgencyCasesList= new List<Communities_Case_Model.CaseRecord>{crec}; 
      emp.AopenCasesList= new List<Communities_Case_Model.CaseRecord>{crec};
      emp.AINprogressCasesList= new List<Communities_Case_Model.CaseRecord>{crec};
      emp.AclosedCasesList= new List<Communities_Case_Model.CaseRecord>{crec};
      emp.isShowAgencyCasses= true;
      emp.isShowMyCasses= true;
      emp.user=null;    
        
        Communities_Case_Model.dummyMethod();
    }
    
    // This test method can throw private exception defined in another class
    
    
   
}