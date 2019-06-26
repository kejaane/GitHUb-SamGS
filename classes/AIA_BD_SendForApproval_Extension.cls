/*=======================================================================================================
 * Date         : 02/05/2017
 * Developer    : Asif Kutagulla
 * Purpose      : Controller for the VF page which is called when Send For Approval button is clicked
 *                on the Benefit Design record. This is created to replace existing onclick javascript
 *=======================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date      +  Developer   + Tag + Description
 *===========+==============+============================================================================
 * 02/05/2017|  Asif K      |     | Initial Version. This is used to update status to In Review and set
 *                                  the fields on Benefit Design record. 
 * 08/03/2017|  satya       |  T01| Getting value from custom setting and using it to bypass the validation rule
                                    when record is submitted for Approval process
 * 1/17/2018 |  satya       |  T02| Method to check whether the user is in Classic or lightning
 * 
 * 02/23/2018|  Debkanti    | T03 | Added the logic to update the AIA_Approval_Status based on approval criteria
 *===========+==============+=====+======================================================================
*/
public with sharing class AIA_BD_SendForApproval_Extension {
    public AIA_Benefit_Design__c objBenefitDesign;
    public boolean showMsg {get;set;}
    public boolean isClassic {get;set;}
    public AIA_BD_SendForApproval_Extension(ApexPages.StandardController sc) {
        showMsg = False;
        isClassic = AIA_Utils.isClassic();//T02
        objBenefitDesign =[SELECT Status__c, Id, QA_Auditor_Initial_Notification__c,
                                  Approval_Initial_Submission_Date__c, AIA_Approvers_Notified__c
                           FROM  AIA_Benefit_Design__c
                           WHERE Id = :sc.getId()]; 
    }
    
    public PageReference updateBD() {
        String status = objBenefitDesign.Status__c; 
        if(status == 'In Progress') 
        {
           //T01 Changes start
           BDApprovalValidation__c variable = BDApprovalValidation__c.getOrgDefaults();
           IF(!test.isrunningtest()){
            variable.IsAppProcess__c = true;update variable;
            //T01 changes end
            }
            objBenefitDesign.Status__c = 'In Review';
            /* T03 Start */
            objBenefitDesign.AIA_Approval_Status__c = true;
            /* T03 End */
            objBenefitDesign.AIA_Approvers_Notified__c = True; 
            objBenefitDesign.QA_Auditor_Initial_Notification__c= True; 
            if(objBenefitDesign.Approval_Initial_Submission_Date__c == NULL) {
                objBenefitDesign.Approval_Initial_Submission_Date__c = Date.today();
            }
            
            try {
                Database.update(objBenefitDesign);
                IF(!test.isrunningtest()){
                    variable.IsAppProcess__c = false;update variable;
                }
                PageReference pgRef = new PageReference('/'+objBenefitDesign.Id);   
                return pgRef;
            }
            
            catch(Exception e) {
                showMsg = True;
                ApexPages.Message Msg = new ApexPages.Message(ApexPages.severity.error, e.getMessage());
                ApexPages.AddMessage(Msg);
            }
        } 
        else {
            showMsg = True;
            String errMsg = 'You may not submit the Benefit Design for approval if the status is not In Progress.';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.error, errMsg);
            ApexPages.AddMessage(myMsg);
        }
        return null;
    }
    
    public PageReference Back() {
        return new PageReference('/'+objBenefitDesign.Id);
    }
}