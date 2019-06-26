/*=========================================================================================
 * Date         : 07/31/2016
 * Developer    : Rajesh Pennam
 * Purpose      : This class contains the logic for Communities Create Case Page
 *                
 *               
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 07/31/16  |  Rajesh Pennam    | Initial Version                                         
 *           |        | 
 *===========+============+================================================================
 */
public with sharing class Communities_NewCasePage{
    public static Attachment Attach{get
    {    if(Attach == null)
            Attach = new Attachment();
        return Attach;
    }set;}
    public static Integer FileSize{get;set;}
    public static Case NewCase = new Case();
    public static Contact ConDetails{get;set;}
    public static string userID{get;set;}
    public static User user{get;set;}
    //public static string BrokerAgent{get;set;}
    public static string BrokerPhone{get;set;}
    //public static string BrokerEmail{get;set;}
    public static string GroupId{get;set;}
    public static string SubId{get;set;}
    public static string MemType{get;set;}
    public static string Subject{get;set;}
    public static string Description{get;set;}
    public static string PhnNumber; 
    public Communities_NewCasePage(){
            displayUserDetails();
    }

// This method is used to create a case by checking all the required validations     
    public static PageReference createNewCase(){
        system.debug('In create Case');
        system.debug('in file null checck if ');
        getContactDetails(); // This function used to get the contact details of the community user
        system.debug('contact phn number '+ConDetails.Phone);
        system.debug('page phn number '+BrokerPhone);
        if(ConDetails.Phone != BrokerPhone){
            system.debug('after diffrence check');
            
            //To check whether the phone number is having 10 digits or else populate an alert message
           //Checking phone number on the page is same in the contact record if not update
            
            if(BrokerPhone.length() == 10 && BrokerPhone.isNumeric()){
                system.debug('after number digit check');
                ConDetails.Phone = BrokerPhone;
                try{
                    update ConDetails;
                }catch(DMLException ex){
                    system.debug(ex+'');
                }
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,  '‘Contact Phone’ shall be 10 numeric characters'); 
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        
         //This part is used to check whether Group ID has 4 characters or else populate an alert message
        //Check if the GroupID entered in the page exists in the Salesforce Group Object
       //If exists populate the GroupName in the Group lookup field in the case or else populate in the New Group ID field
        
        if(GroupId != null && GroupId != ''){
            if(GroupId.length() == 4){
                system.debug('i am if 1');
                List<Group__c> GroupList = new List<Group__c>();
                try{
                    GroupList = [select Id,Name,Group_ID__c from Group__c where Group_ID__c = :GroupId];
                    system.debug('search List Result '+GroupList);
                    if(GroupList != null && GroupList.size()>0){
                        system.debug('i am if 2');
                        NewCase.Group__c = GroupList[0].ID;
                    }else{
                        system.debug('i am else 1');
                        NewCase.New_Group_ID__c = GroupId;
                    }                   
                }catch(QueryException ex){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,' '+ex.getMessage());
                    ApexPages.addMessage(myMsg);
                    return null;
                }                   
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,  'The ‘Group ID’ entered is incorrect, please ensure its 4 characters in length.');
                ApexPages.addMessage(myMsg);
                return null;
            }           
        }
        
         //This part is used to check whether Subscriber ID is having 10 numeric characters or else populate an alert message
        //And also checking, if Subscriber ID is entered then Member type field is mandatory and mapping with the respective fields in salesforce
        
        NewCase.Subscriber_ID__c = SubId;
        NewCase.Member_Type__c = MemType;
        if(SubId != null && SubId != ''){
            if(SubId.length() == 9 && SubId.isNumeric() ){
                system.debug('in sub id if condition after validation');
                if(MemType == null || MemType == ''){
                    system.debug('in mwm type if condition after validation');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,  'Member Type is required to submit Subscriber/Member related inquiry');
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,  'Subscriber ID shall be 9 numeric characters');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        NewCase.Subject = Subject;
        NewCase.Description = Description;
        NewCase.Origin = 'Web';
        system.debug('case details '+NewCase);
        try{
            if(NewCase != null){
                system.debug('file size '+FileSize);
                    if(FileSize > 10000000){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The total size of attached file cannot exceed 10MB. ');
                        ApexPages.addMessage(myMsg);
                        return null;
                    }else if(ApexPages.hasMessages(ApexPages.severity.ERROR)) {
                        System.debug('The total size of attached file cannot exceed 10MB. Please reduce the file size, abort processing. ApexPages.getMessages() ' + ApexPages.getMessages());            
                        return null;
                    }
                    else{
                        insert NewCase;
                        System.debug('\n cLog:'+NewCase);
                        if(FileSize != null){
                            if(NewCase.Id != null){
                                system.debug('In Creating Attachment');
                                Attach.OwnerId = UserInfo.getUserId();
                                Attach.ParentId = NewCase.Id; // the file is attached to The Above Case
                                Attach.IsPrivate = False;
                                system.debug('before insert attachment '+Attach);
                                try{
                                    if(Attach != null)
                                        insert Attach;
                                }catch(DMLException ex){
                                    system.debug(ex+'');
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'');
                                    ApexPages.addMessage(myMsg);
                                    return null;
                                }
                                system.debug('after insert attachment '+Attach);    
                            }
                        }    
                    }       
            }
        }catch(DMLException ex){
            system.debug(ex+'');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,  ''+ex.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
         system.debug('****after insert**** '+NewCase);
        Case CN = new Case();
        if(NewCase != null){
            try{
                CN = [select Id,CaseNumber from Case where Id = :NewCase.Id]; 
            }catch(QueryException ex){
                system.debug(ex+'');
            }
        }  
        return new PageReference('/apex/SBU_Communities_My_Cases_Page?casenumber='+CN.CaseNumber);           
    }
    
    //This function is used to get the user details from the related contact
    
    public static void displayUserDetails(){
        userID = Userinfo.getUserId();
        system.debug('userID '+userID);
        if(userID != null && userID != ''){
            user = [select Id,ContactId from User where Id = :userID];
            system.debug('user '+user);
            if(user.ContactId != null){
                ConDetails = [select Id,Name,Email,Phone from Contact where Id = :user.ContactId];
                if(ConDetails.Phone != null)
                    BrokerPhone = ConDetails.Phone;
            }
            
        }
    }
    
    // This function used to get the contact details of the community user
    
    public static void getContactDetails(){
        userID = Userinfo.getUserId();
        system.debug('userID '+userID);
        if(userID != null && userID != ''){
            user = [select Id,ContactId from User where Id = :userID];
            system.debug('user '+user);
            if(user.ContactId != null){
                ConDetails = [select Id,Name,Email,Phone from Contact where Id = :user.ContactId];
            }
        }
    }
}