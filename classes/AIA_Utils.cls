/************************************************************************************************************
 *  Class            : AIA_Utils
 *  Author           : Asif Kutagulla
 *  Description      : Utility methods for AIA project code.
 *                          ======[Modification Log]======
 * ----------------------------------------------------------------------------------------------------------
 *  Author          Date-Modified      Tag      Description of Change
 * ----------------------------------------------------------------------------------------------------------
 * Asif Kutagulla    07/02/2017        T01      Initial Creation. Added method for logging errors into error
 *                                              log object
 * Raviteja V        06/07/2017        T02      Added method for date format to yymmdd format
 * Goutham Rapolu    09/08/2017        T03      Added method to check if a user has a certain custom permission
 *                                              available to his PermissionSet. This is part if US185
 *                                              Benefit Summary is Read-Only for Business QA Process.
 * Asif Kutagulla    09/28/2017        T04      Method to check if logged-in user, is a user assigned to 
 *                                              AIA Admin PermissionSet
 * Goutham Rapolu    11/13/2017        T05      Added method for:
 *                                              Encloses the given string with Quote by escaping any inner 
 *                                              quotes & Return Quote enclosed string. 
 *                                              Checks whether the given string value is null or empty & 
 *                                              Return True if NULL or Empty, False otherwise
 * Satya              2/6/2018         T06      Method to check whether the user is in Classic or lightning 
 *                                              Interface
 * Rajesh Pennam     03/13/2018        T07      Added method to get opportunity lookup id in case for autopopulations
 * Phanishankar P   04/27/2018       T08    Added method to check if user belongs to Admin profile
 * Asif Kutagulla   04/30/2018       T09    Added check for System Admin-Read Only & SysAdminIPRestricted 
 *                                              profiles
 * Asif Kutagulla    08/17/2018        T10      Added method to return if a trigger needs to be bypassed
 * Satya             04/26/2019        T11      To check if log-in user has specified Permissionset assigned or not.
 ************************************************************************************************************/
public without sharing class AIA_Utils { 
    
    /** T01 - Method to insert single record into error log object **/
    public void logException(Exception e){
        Error_log__c error = InitErrorLogRecod(e);
        insert error;
    }
    
    /** T01 - Method to initialize single error log record and return the same **/
    public Error_log__c InitErrorLogRecod(Exception e){
        Error_log__c errLogRec = new Error_log__c(Cause__c=String.valueOf(e.getCause()),
                                                  LineNumber__c=e.getLineNumber(),
                                                  Message__c=e.getMessage(),
                                                  StackTrace__c=e.getStackTraceString());
        return errLogRec;
    }
    
    /** T02 - Method to insert single record into error log object **/
    public static string getDateInYYDDMMFormat(Date d){
        return d.year() + '-' + d.month() + '-' + d.day();
    }
  
    //T03 Start  --  Not in USE. Have a diff class with same functionality (CF_CustomPermissionsReader)
    /*public Boolean CustomPermissionCheck(ID userid,String CustomPermissionName){
    boolean CPSetTrue;
    List<CustomPermission> CPSet = [SELECT Id, DeveloperName,(SELECT SetupEntityId FROM SetupEntityAccessItems WHERE SetupEntityType='CustomPermission'
            AND ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId=:userid)) FROM CustomPermission
            WHERE DeveloperName=:CustomPermissionName];

    //checking if list has records and setting boolean to TRUE if list.size>0
        if(!CPSet.isempty()){
            CPSetTrue = true;
        }
    return CPSetTrue;  
    } */
    //T03 End
  
    /** T04 - Start - Method to check if logged-in user, is a user assigned to AIA Admin PermissionSet **/
    public static Boolean checkIf_AIA_Admin_User() {
        boolean isAIA_Admin_User = False; //variable for both vf component and vf page
        final string AIA_ADMIN_PERMSET = 'AIA_Admin';
        list<PermissionSetAssignment> lstPSassignment = new list<PermissionSetAssignment>();
        lstPSassignment = [SELECT Id, Assignee.Name, PermissionSet.Name 
                           FROM PermissionSetAssignment 
                           WHERE PermissionSet.Name = :AIA_ADMIN_PERMSET AND 
                                 Assignee.Name = :UserInfo.getName()];
        if(!lstPSassignment.isEmpty()) { isAIA_Admin_User = True; } 
        return isAIA_Admin_User;
    }
    /** T04 - End - Method to check if logged-in user, is a user assigned to AIA Admin PermissionSet **/
    
    /** T08 - Start - Added method to check if user belongs to Admin profile **/    
    public static Boolean checkIf_AIA_Admin_Profile_User(){
        boolean isAIA_Admin_Profile_User = False;
        String profileName;
        final String sysAdmin = 'System Administrator';
        final String sysAdminCustom = 'System Administrator - Custom';
        final String sysAdmin2FACustom ='System Administrator 2FA - custom';
        final String sysAdminReadOnly = 'System Administrator - Read Only';     //T09
        final String sysAdminIPRestricted = 'SysAdminIPRestricted';             //T09
        Profile usrProfile =  [Select Name from Profile WHERE ID = :UserInfo.getProfileId()];
        profileName = usrProfile.Name;
        if(profileName.equals(sysAdmin) || profileName.equals(sysAdminCustom) || profileName.equals(sysAdmin2FACustom) ||
            profileName.equals(sysAdminReadOnly) || profileName.equals(sysAdminIPRestricted) )   //T09
        {
            isAIA_Admin_Profile_User = True;
        }
        return isAIA_Admin_Profile_User;
    }
    /**T08 - End **/
    
    /** T05 - Start **/
    /* Checks whether the given string value is null or empty
     * Return True if NULL or Empty, False otherwise
     */
    public static Boolean isNullOrEmpty(String param){
        
        if( param==null || param.trim().length() == 0){
            return true;
        }    
        return false;
    }
    /* Encloses the given string with Quote by escaping any inner quotes.
     * Return Quote enclosed string
     */
    public static String getEnclosedByQuote(String param)
    {
        if(!isNullOrEmpty(param)){
            return '\''+ String.escapeSingleQuotes(param) +'\'';
        }   
        return null;        
    }
    /** T05 - END **/
    

   //T06--changes Start
    public static Boolean isClassic() {
        final string THEME = 'classic_theme';
        boolean isClassic = False;
        AIA_Configurations__mdt DName = [Select id,DeveloperName,Parameter_Value__c 
                                         from AIA_Configurations__mdt 
                                         where DeveloperName =:THEME];
        if(DName.Parameter_Value__c == UserInfo.getUiThemeDisplayed())
        { 
            isClassic = true;    
        }
        return isClassic;
    }//T06--End
    
    //T07 Changes starts Here
    public static string Case_Oppty_Lkup () {
      return null;
    }
    //T07 Changes Ends Here
    
    //T10 Changes start here
    public static boolean isTriggerBypassed(String objName) {
        map<String,Apex_Trigger_Control__c> trigCtrl = Apex_Trigger_Control__c.getAll();
        if(trigCtrl.size() == 0) {
            return false;
        }
        else { 
            if(trigCtrl.containsKey(objName)) {
                if(trigCtrl.get(objName).Bypass_Trigger_Execution__c) {
                    return true;
                }
                else {
                    return false;
                }
          }
            else {
                return false;
            }
        }
        return false;
    }
    //T10 Changes end here
   
   //T11 changes start 
    public static Boolean checkIf_user_has_PS(Id userId, string PSName) {
        boolean isUser_has_ps = False; //variable for both vf component and vf page
        final string AIA_PERMSET = PSName ;
        list<PermissionSetAssignment> lstPSassignment = new list<PermissionSetAssignment>();
        lstPSassignment = [SELECT Id, Assignee.Name,AssigneeId, PermissionSet.Name 
                           FROM PermissionSetAssignment 
                           WHERE PermissionSet.Name = :AIA_PERMSET AND 
                                 AssigneeId = :userId];
        if(!lstPSassignment.isEmpty()) { isUser_has_ps = True; } 
        return isUser_has_ps;
    }
    
   //T11 changes end 
}