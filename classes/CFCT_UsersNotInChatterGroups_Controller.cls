//=========================================================================================
//      Date: 12/27/2012
// Developer: Tom Barrett (TPB)
//   Purpose: This class controller is used to produce a list of FULL LICENSED users who are 
//            not in the supplied Chatter Group(s).
//            The CFCT_UsersNotInChatterGroups visualforce page references this controller
//     
//            There are 3 public methods that 3 buttons on the vf page reference
//            1. Emails to the person executing the code the list shown on the vf page.
//               If it is detected that none of the supplied Chatter Groups exist then a
//               message is displayed.
//               if it is detected that one or more of the supplied Chatter Groups entered 
//               do not exist as an actual Chatter Group then the page will display the issue
//               and the email will display the list of missing Chatter Groups at the footer
//               of the HTML table the HTML table.
//            2. Excludes selected userfrom the QA process by setting the 
//               Exclude_From_Chatter_QA__c checkbox field on the User object.
//            3. Add User to Group adds the selected users to the associated Chatter Group        
//=========================================================================================
//                                 Update History
// Date          Developer      Description
//=========================================================================================
// 05/09/2016    TPB            Removed restriction of only the Salesforce license on the 
//                              WHERE clause and added the UserLicense field to the SELECT
//                              so that it could be used by the Visualforce page.
//08/14/2018 Debkanti	|T01|	Added method to check classic or lightning      
//=========================================================================================
public class CFCT_UsersNotInChatterGroups_Controller {
    public  String ChatterGroupsMissingMessage { get; set; }
    public  List<HelperClass> UserChatterGroupList { get; set; }
    private List<HelperClass> UsersMissingInChatterGroups = new List<HelperClass>();  
    private List<User> userList;
    private List<CFCT_UsersNotInChatterGroups__c> CGList = CFCT_UsersNotInChatterGroups__c.getall().values();     
    private Map<id, String> userMap = new Map<id, String>();
    private Map<id, String> ChatterGroupUserMap = new Map<id, String>();
    private Map<String, Id> ChatterGroupUserMap2 = new Map<String, Id>();       
    private Boolean ChatterGroupMissing = false;  
    private Boolean ChatterGroupExists = false; 
    private String htmlBody = '<table border="1"><tr><th>Chatter Group</th><th>User Name</th></tr>';
    private String plainTextBody = '';    
    transient private ApexPages.Message PageMessage;
    transient private String Msg = '';  
       
    public void startProcess() {      
        ChatterGroupsMissingMessage = ''; 
                    
        // Get a list and map of all full license users that are active
        // WHERE isActive = TRUE AND User.Profile.UserLicense.Name = 'Salesforce' // TPB 05/09/2016 replaced with line below
        
        String query='SELECT id, Name, User.Profile.UserLicense.Name FROM User WHERE isActive = TRUE AND Exclude_From_Chatter_QA__c = FALSE AND UserType != \'PowerCustomerSuccess\'';
        if(Test.isRunningTest())
        query = query+' Limit 1';
        /*userList = [ SELECT id, Name, User.Profile.UserLicense.Name
                     FROM User
                     WHERE isActive = TRUE 
                       AND Exclude_From_Chatter_QA__c = FALSE ]; */
           userList = Database.query(query);

        // Loop through the list of Chatter Groups that should have full license users
        // building a continuous list of full licensed users that do not exist in each 
        // each of those Chatter Groups
        CGList.sort();
        for ( CFCT_UsersNotInChatterGroups__c cg : CGList ) {
            BuildList( cg.ChatterGroup__c );
        } 
        RemoveCommaOnFooterMessage();
        UserChatterGroupList = UsersMissingInChatterGroups;        
        if (ChatterGroupExists) {    
            msg = 'The Email Results button emails the entire list to you.  The Exclude User button will exclude ';
            msg += 'any selected users from showing on the list in the future.  ';
            msg += 'The Add User To Group button adds the selected users to the corresponding Chatter Group.';                
            PageMessage = new ApexPages.Message(ApexPages.Severity.INFO, msg); 
            ApexPages.addMessage(PageMessage); 
        } else {
            msg = 'No Chatter Groups Found!  Check to see if the Chatter Groups listed in the Custom Settings matches an existing Chatter Group.';           
            PageMessage = new ApexPages.Message(ApexPages.Severity.INFO, msg); 
            ApexPages.addMessage(PageMessage);         
        }        
    }
          
    // Get Chatter Group List then Interate through the User List while building the UsersMissingChatterGroup list
    private void BuildList( String ChatterGroupName ) {           
        List<CollaborationGroupMember> chatterGroupList = [ SELECT MemberId, collaborationGroup.Name, CollaborationGroupId
                                                            FROM CollaborationGroupMember
                                                            WHERE collaborationGroup.Name = :ChatterGroupName                     
                                                            ORDER BY collaborationGroup.Name ];  
                                                        
        if ( chatterGroupList.size() > 0 ) {
            ChatterGroupExists = true;
            for ( CollaborationGroupMember cg : chatterGroupList ) {            
                ChatterGroupUserMap.put(cg.MemberId, cg.collaborationGroup.Name);
                ChatterGroupUserMap2.put(cg.CollaborationGroup.Name, cg.CollaborationGroupId);                
            }            
            for ( User u : userList) {        
                if ( !chatterGroupUserMap.ContainsKey(u.Id) ) {                                                              
                    HelperClass UserMissingInChatterGroup = new HelperClass();                    
                    UserMissingInChatterGroup.GroupId = ChatterGroupUserMap2.get(ChatterGroupName); 
                    UserMissingInChatterGroup.recordSelect = FALSE;
                    UserMissingInChatterGroup.UserId = u.id;                  
                    UserMissingInChatterGroup.UserName = u.Name;
                    UserMissingInChatterGroup.LicenseType = u.Profile.UserLicense.Name;
                    UserMissingInChatterGroup.ChatterGroupName = ChatterGroupName;
                    UsersMissingInChatterGroups.add(UserMissingInChatterGroup);
                }               
            } 
        } 
        if ( chatterGroupList.size() == 0 ) {
            ChatterGroupMissing = true;           
            ChatterGroupsMissingMessage += ChatterGroupName + ', ';
        }        
    } 
       
    private void BuildEmailMessage() {
        String priorCGN = '';
        for ( HelperClass hc : UsersMissingInChatterGroups ) {
            if ( priorCGN !='' && priorCGN !=hc.ChatterGroupName ) { 
                htmlBody += '<tr><td align="center">====================</td><td align="center">===========</td></tr>';
            }
            htmlBody += '<tr><td>' + hc.ChatterGroupName + '</td><td>' + hc.UserName + '</td></tr>';
            plainTextBody += hc.ChatterGroupName + '\t' + hc.UserName + '\n';
            priorCGN = hc.ChatterGroupName;
        }        
        if ( ChatterGroupMissing ) {
            ChatterGroupsMissingMessage  =+ ChatterGroupsMissingMessage;
            htmlBody +='<tr><td align="center" bgcolor="yellow">' + ChatterGroupsMissingMessage + '</td></tr>';
            plainTextBody += '\n' + ChatterGroupsMissingMessage;            
        }
        htmlBody += '</table>';    
    }      

    public void EmailList() {
        try {  
            BuildEmailMessage();
            sendEmail();         
            msg = 'List Successfully Emailed';        
            PageMessage = new ApexPages.Message(ApexPages.Severity.INFO, msg); 
        } catch (Exception e) {
            msg = 'Something went wrong!  Email was not sent!';        
            PageMessage = new ApexPages.Message(ApexPages.Severity.ERROR, msg + ' - ' + e.getMessage()); 
        } finally {
            ApexPages.addMessage(PageMessage); 
        }        
    }
    
    private void sendEmail() {
        User currentUser = new User();
        currentUser = QueryBase.getCurrentUser();
        List<String> toAddresses = new List<String> {currentUser.Email};
        String replyToAddress = currentUser.Email;        
        Utils.EmailUtil email = new Utils.EmailUtil(toAddresses);
        email.plainTextBody(plainTextBody);
        email.htmlBody(htmlBody);
        email.senderDisplayName(currentUser.Name);
        email.subject('Users Not In Chatter Groups');
        email.replyTo(replyToAddress);
        email.sendEmail();
    }        
    
    // Update the user records that are selected from the visualforce page
    // This method excludes the selected user(s) from this QA process
    // in the future.
    public PageReference ExcludeUserFromProcess(){ 
        if ( UserChatterGroupList.size() > 0 ) {        
            Set<id> selectedRecords = new Set<id>();         
            for ( HelperClass rec : UserChatterGroupList ) {
                if ( rec.recordSelect ) {
                    selectedRecords.add(rec.UserId);       
                }
            }
            List<User> users = [ Select Exclude_From_Chatter_QA__c From User Where id = :selectedRecords ];
            for ( User u : users ) {
                u.Exclude_From_Chatter_QA__c = TRUE;
            }
            update users;
        }
        
        PageReference pageRef = ApexPages.currentPage();
        return pageRef.setRedirect(true);
    }
    
    // Update the selected Chatter Group that is selected on the 
    // visualforce page with the user id which the end result is the
    // selected user is added to the Chatter Group
    public PageReference AddUserToGroup(){
        if ( UserChatterGroupList.size() > 0 ) {
            List<CollaborationGroupMember> cgm = new List<CollaborationGroupMember>();            
            for ( HelperClass rec : UserChatterGroupList ) {
                if ( rec.recordSelect ) {
                    CollaborationGroupMember cgmRec = new CollaborationGroupMember();
                    cgmRec.CollaborationGroupId = rec.GroupId;
                    cgmRec.MemberId = rec.UserId;
                    cgm.add(cgmRec);
                    System.debug('zzz: ' + rec.Groupid + ', ' + rec.UserId);
                }            
            } 
            upsert cgm;
        }                      
        PageReference pageRef = ApexPages.currentPage();
        return pageRef.setRedirect(true);   
    }
    
    // Add the main message to the list of ChatterGroupsMissingMessage and remove the ending comma
    private void RemoveCommaOnFooterMessage() {
        if ( ChatterGroupMissing ) {
            ChatterGroupsMissingMessage = 'NOTE: The following supplied Chatter Groups could not be found: ' + ChatterGroupsMissingMessage; 
            ChatterGroupsMissingMessage = ChatterGroupsMissingMessage.removeEnd(', ');
        }
    }
                   
    // Helper Class
    public class HelperClass {
        public boolean recordSelect {get; set;}    
        public Id GroupId {get; set;}  
        public id UserId {get; set;}   
        public String UserName {get; set;}
        public String ChatterGroupName {get; set;}
        public String LicenseType {get; set;}
    }
    /*-T01-Start-*/
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    /*-T01-End-*/
}