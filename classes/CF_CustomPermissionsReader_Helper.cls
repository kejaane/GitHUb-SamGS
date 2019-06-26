/*********************************************************************************************************************************
 * Class            : CF_CustomPermissionsReader_Helper
 * Author           : Asif Kutagulla
 * Version History  : 1.0
 * Creation         : 11/06/2016
 * Description      : Helper class for CF_CustomPermissionsReader
 * MODIFICATION LOG:
 * --------------------------------------------------------------------------------------------------------------------------------
 *     AUTHOR          DATE      TAG    DESCRIPTION OF CHANGE                                    
 * --------------------------------------------------------------------------------------------------------------------------------
 * Asif Kutagulla   11/06/2016          Initial version
 * Goutham Rapolu   09/08/2017   T01   Added method to check if a user has a certain custom permission
 *                                      available to his PermissionSet. This is part if US185
 *                                      Benefit Summary is Read-Only for Business QA Process.
 * Satya            12/1/2017     T02   Added to bypass validaton rules of Docusign in Apex classes for the user
                                        having vthis permission set 
 *********************************************************************************************************************************/
public class CF_CustomPermissionsReader_Helper {

    /**
     * Exposes typed representation of the Applications Custom Permissions
     **/
    public static final PermissionsFactory Permissions = new PermissionsFactory();
 
    /**
     * Returns if the logged in user is assigned to specific custom permissions
     **/
    public class PermissionsFactory extends CF_CustomPermissionsReader
    {        
        public Boolean ignoreVRs { get { return hasPermission('Ignore_Validation_Rules'); } }
        public Boolean skipBRFVRs { get { return hasPermission('AIA_Ignore_BRF_Validation_Rules'); } }     
        public Boolean skipGSRFVRs { get { return hasPermission('AIA_Ignore_GSRF_Validation_Rules'); } }
        public Boolean PlanQAAudit { get { return hasPermission('AIA_Plan_QA_Audit'); } }     //T01
        public Boolean AIAAdmin_ignoreVRs { get { return hasPermission('AIA_Admin_Ignore_Validation_Rules'); } } 
        public Boolean Docusign_ignoreVRs { get { return hasPermission('AIA_Ignore_Docusign_Validation_Rules'); } } 

    }
}