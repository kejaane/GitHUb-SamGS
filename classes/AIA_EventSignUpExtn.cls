/*===========================================================================================
* Date         : 01/21/2018
* Developer    : Rajesh Pennam
* Purpose      : This is the controller for VF Page AIA_EventSignUp, this adds the user who 
*                is clicking the button as an attendee to the event.
*============================================================================================
*                                 Update History
*                                 ---------------
* Date          Developer         Tag       Description
*============================================================================================
* 01/26/2018 | Rajesh Pennam    | T01   | Intial Development. 
*============================================================================================
*/
public with sharing class AIA_EventSignUpExtn {
    //Variable Inilization
    private ApexPages.StandardController stdController;
    public String redirectUrl {public get; private set;}
    public Boolean shouldRedirect {public get; private set;}        
    Public Event eventSignUp ;
    public boolean isClassic {get;set;}   
    private static final string COMPLETED = 'Completed';
    private static final string FULL = 'FULL';
    private static final string Full_Error = 'This enrollment meeting has already reached capacity.';
    private static final string Comp_Error = 'This enrollment meeting has already been completed.';
    private static final string Dup_Error = 'You have already signed up for the meeting or the meeting date is over';
    
    
    public AIA_EventSignUpExtn(ApexPages.StandardController stdcontroller) {
      this.stdController = stdController;
      shouldRedirect = false;
      isClassic = AIA_Utils.isClassic();
    
      eventSignUp = new Event();
     
      id EventId = stdController.getRecord().Id;
      eventSignUp = [Select id,Meeting_Status__c  From Event Where Id=:EventId ];        
    }
    
    // This method is used to show the pop up depending on the meeting status
    public pagereference SignUpOnload(){
         try{ 
               if(eventSignUp.Meeting_Status__c == FULL){           
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Full_Error));
              
               }
               else if (eventSignUp.Meeting_Status__c == COMPLETED){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Comp_Error));
            
               }       
               else{
                 AIA_OpenEnrollmentMeetingSignUp.signUp(eventSignUp.Id);
                 shouldRedirect = true;
                 redirectUrl = stdController.view().getUrl();        
               }
           
           }
           catch(exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Dup_Error ));
           }
        return null;
    }
}