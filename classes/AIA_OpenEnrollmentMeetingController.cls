/*------------------------------------------------------------------------------------------
 * Author    : Sree Harsha,Sandeep S 
 * Purpose   : This controller fetches Open Enrollment Meetings records based on the meeting
 *             status filters(Open/Full/Completed)
 *
 *                      ----===[ HISTORY ]===---
 * Date        Developer           Tag   Description
 *-------------------------------------------------------------------------------------------
 * 06/06/2016  Sree Harsha Akkala        This class is the controller for visualforce Page
 *                                       AIA_OpenEnrollmentMeetings. It is used to get and 
 *                                       display a list of open enrollment meetings
 * 07/17/2016  Sandeep S                 Restructured complete class , refactored methods. 
 *                                       Added pagination.
 * 02/06/2018  Rajesh Pennam       T01   Added isclassic metadata component reference

 *-------------------------------------------------------------------------------------------
 */
public class AIA_OpenEnrollmentMeetingController {

    public List<Event> events{get;set;}
    public Integer pageSize{get;set;}
    public Integer noOfPages{get;set;}
    public Integer pageNumber{get;set;}
    public boolean isClassic {get;set;} //T01
    private Id oemRtypeId= Schema.SObjectType.event.RecordTypeInfosByName.get('AIA Open Enrollment Meeting').RecordTypeId; // Record Id for the Open Meeting Enrollment event
    public Integer totalNoOfRecs{get;set;}
    public boolean isOpen{get;set;} // Checkbox to get enrollments with a status of open
    public boolean isFull{get;set;} // Checkbox to get enrollments that have reached maxed
    public boolean isCompleted{get;set;}
    private static final string Open= 'Open'; 
    private static final string Full= 'Full'; 
    private static final string Completed= 'Completed';
    
    
       
    public AIA_OpenEnrollmentMeetingController() {
        pageSize = 10;
        isOpen=true;
        isFull=false;
        isCompleted=false;
        getInitialEventSet();
        isClassic = AIA_Utils.isClassic();  //T01
    }
    
/**
* @This method helps in preparing picklist with differen pagesize values.
*
* @param - None  
* @Output - Pick List of Page Size 
*/
public List<SelectOption> getPickList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(String.valueOf(5),String.valueOf(5)));
        options.add(new SelectOption(String.valueOf(10),String.valueOf(10)));
        options.add(new SelectOption(String.valueOf(20),String.valueOf(20)));
        options.add(new SelectOption(String.valueOf(30),String.valueOf(30)));
        return options;     
    }
    
/**
* @Method to get total record count for the given qualifiers.
*
* @param - None  
* @Output - Integer - number of records
*/    
public Integer getRecordCount(){
    String query = 'select count() from Event where  recordtype.id=:oemRtypeId and '+getMeetingStatusFilter();
    Integer recordCount;
    try{
        recordCount = Database.countQuery(query);
    }
    catch(Exception e){
        ApexPages.addMessages(e);
    }
    return recordCount;
}
    

/**
* @Method to sets and initialize required parameters for pagination 
* and in turn invokes queryevents which actually perform projection 
* on event object .
* @param - None  
* @Output - PageReference - returns flow to same page.
*/
public PageReference getInitialEventSet(){
    system.debug('page size--->'+pageSize);        
    pageNumber = 1;
    queryEvents();
    return null;  
}
    
/**
* @Method helps in nevigating to next page . 
* @PageNumber is incremented by 1 .
* @param - None  
* @Output - PageReference - returns flow to same page.
*/
public PageReference next(){
    pageNumber++; 
    queryEvents();
    return null;
}
    
/**
* @Method helps in nevigating to previous page . 
* @PageNumber is decremented by 1 .
* @param - None  
* @Output - PageReference - returns flow to same page.
*/
public PageReference previous(){
    pageNumber--;
    if (pageNumber < 1)
        return null;
    queryEvents();
    return null;    
}

/**
* @Method helps in nevigating to first page . 
* @PageNumber is set to  1 .
* @param - None  
* @Output - PageReference - returns flow to same page.
*/
public PageReference firstPage(){
    pageNumber = 1;
    queryEvents();
    return null;
}

    
/**
* @Method helps in nevigating to last page . 
* @PageNumber is set to  the number of total number of pages .
* @param - None  
* @Output - PageReference - returns flow to same page.
*/
public PageReference lastPage(){
    pageNumber = noOfPages;
    queryEvents();
    return null;
}

/**
* @Method prepared qualifier for query based on open/Full/IsComplete flags . 
* @PageNumber is set to  the number of total number of pages .
* @param - None  
* @Output - String - qualifier string.
*/    
private String getMeetingStatusFilter(){
    String meetingStatusfilter;
    
    if(isOpen && isFull && isCompleted)
        meetingStatusfilter = ' ( Meeting_Status__c=:Open OR Meeting_Status__c=:Full OR Meeting_Status__c=:Completed)';
    else if(isOpen && isFull){
        system.debug('@@1'+meetingStatusfilter );
        meetingStatusfilter = '( Meeting_Status__c=:Open OR Meeting_Status__c=:Full)';
        system.debug('@@2'+meetingStatusfilter );
    }
    else if(isFull && isCompleted)
        meetingStatusfilter = '( Meeting_Status__c=:Full OR Meeting_Status__c=:Completed)'; 
    else if(isFull)
        meetingStatusfilter = ' Meeting_Status__c=:Full';
    else if(isCompleted)
        meetingStatusfilter = ' Meeting_Status__c=:Completed';
    else
        meetingStatusfilter = ' Meeting_Status__c=:Open';
    
    return meetingStatusfilter;
}
    
/**
* @Method prepares query with help of getmeetingstatusfilter and projects it on event object .
* @Prepared offset to be used with query for pagination with help of pagenumber and pagesize.
* @Invoke getRecordCount to get total number of record counts to calculate number of pages.
* @PageNumber is set to  the number of total number of pages .
* @param - None  
* @Output - None.
*/
public void queryEvents(){
        
    totalNoOfRecs=getRecordCount();
    noOfPages = totalNoOfRecs/pageSize;
    if (Math.mod(totalNoOfRecs, pageSize) > 0)
        noOfPages++;  
    
    Integer offset = (pageNumber-1) * pageSize;
    String baseQuery = 'select id,subject,ActivityDate,Name_Of_Account__c,Capacity__c,Signed_Up__c,Meeting_Status__c,recordtype.id from event where  recordtype.id=:oemRtypeId and '+getMeetingStatusFilter()+' order by activitydate desc';
    String query = baseQuery + ' limit '+pageSize +' offset '+ offset;
    System.debug('Query is'+query);
    try{
        events = Database.query(query);
    }
    catch(Exception e){
        ApexPages.addMessages(e);
    }
        
}


}