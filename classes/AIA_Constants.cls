/*=======================================================================================================================
 * Date         : 08/08/2016
 * Developer    : Sree Harsha
 * Purpose      : AIA_Constants class to store constants values in variables and used them across other classes.
 *=======================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer            Tag   Description
 *============+======================+=====+=============================================================================
 * 08/08/2016 | Sree Harsha          |     | Initial Version                                         
 * 03/30/2017 | Sree Harsha          | T01 | Added BRF status values and Implementation status values in final constants
 * 06/29/2017 | Sajitha Yalamanchili | T02 | Added InNetwork and OutNetwork values 
 * 09/27/2017 | Sajitha Yalamanchili | T03 | Added US-87 values
 * 09/29/2017 | Asif Kutagulla       | T04 | Added BD Status Values. This is for US-165.
 * 10/02/2017 | Asif Kutagulla       | T05 | Added object names for Benefit Design(BD), Benefit Design Product(BDP) and
 *                                           Benefit Design Form(BDF). This is for US-165.
 * 10/12/2017 | Goutham Rapolu       | T06 | Added AccountTeamMember names as part of US-230. && US-110
 * 10/12/2017 | Goutham Rapolu       | T07 | Added static text for Benefit Design Product Rich Text Field default Values 
 *                                           US-149.
 * 10/12/2017 | Raviteja vadapalli   | T08 | Added IMP_MANAGER account role
 * 06/12/2017 | Rajesh Nagandla      | T09 | Replaced "Implementation Manager" role to "Implementation PM" and 
                                             "Settlements" to "Settlements Analyst"
 * 12/22/2017 | Satya                | T10 | Added as a part of US287. Removed generation of GSRF based on status    |
 * 02/08/2017 | Raviteja vadapalli   | T11 | Added Parameters that is coming from AIA_ProductSearchFilteringController
 * 02/15/2017 | Raviteja vadapalli   | T12 | Added DDPNAME for Adjustment Summary
 * 02/23/2018 | Debkanti             | T14 | Added message to display record is submitted for approval
 * 04/26/2018 | Gayathri             | T15 | Added constants related to Workplan task and sub process trigger as part 
 *                                           of US 197 and US182
 * 02/15/2017 | Raviteja vadapalli   | T16 | Added as part of US 815
 * 05/06/2018 | Laveen               | T17 | Added as part of US 1513, 462 and 362
 * 05/24/2018 | Arshia               | T18 | Added as part of US 2254 
 06/08/2018    phani               T019       Added code for role updates
 * 05/24/2018 | Arshia               | T20 | Added as part of US 890
 * 06/13/2018 | Raviteja vadapalli   | T21 | Added as part of US 1420
 * 08/30/2018 | Rajesh Nagandla      | T22 | Added BRF Business type for Off Cycle and Setup
 * 10/07/2018 | Rajesh Nagandla      | T22 | Updating Gs status as Approved. To start dependent subprocess. Replacement of Process builder.
 * 12/27/2018 | Phani				 | T23 | Added new roles
 *============+======================+=====+=============================================================================
 */

public class AIA_Constants
{
    // BRF ARC Approval Statuses
    public static final String APPROVED_BY_COMMITTEE = 'Approved by Committee'; 
    public static final String REJECTED_BY_COMMITTEE = 'Rejected by Committee';  
    
    //Benefit Design Approvers
    public static final String ANCILLARY_ANALYST = 'Ancillary Analyst';
    public static final String BENEFACT_CODER = 'Benefact Coder';
    public static final String CONTRACT_TECH = 'Contract Tech';
    public static final String QA_AUDITOR = 'QA Auditor';
    
    //T23-Start
    public static final	String Benefit_Coder= 'Benefit Coder';
    public static final	String Benefit_Tester= 'Benefit Tester';
    public static final	String Pharmacy_Management='Pharmacy Management';
    public static final	String Pharmacy_Operations='Pharmacy Operations';
    public static final	String Vision_Analyst='Vision Analyst';
	//T23-END
    //Account Team Member Roles
    public static final String AUDIT= 'Auditor';    
    //public static final String CC_CONTACT= 'C&C Contact';    
    //Renamed the role C&C Contact to Benefit Contract Specialist
    public static final String CC_CONTACT= 'Benefit Contract Specialist';    
    public static final String CONTRACT_SUPERVISOR= 'Contract Manager';    //T019
    public static final String LEGAL= 'Legal';   
    //Renamed the role Sales Service Rep - Account Manager 
    //public static final String SALES_SERVICE_REP= 'Sales Service Rep';  
    public static final String SALES_SERVICE_REP = 'Account Manager';    
    public static final String NASCO_BENEFIT_CODER = 'NASCO Benefit Coder';
    public static final String MAST_TECH = 'MAST Tech';
    public static final String SALES_ASSISTANT = 'Sales Assistant';
  
    //T01 start
    // BRF Status values used in AIA_BRFTriggerHelper
    public static final String Sold = 'Sold';                 
    public static final String SoldInactive = 'Sold-Inactive'; 
  
    //Implementation Status values
    public static final String NotStarted = 'Not Started'; 
    public static final String InProgress = 'In-Progress'; 
    public static final String Completed = 'Completed'; 
    //T01 end  
  
    public static final String PCSPlanID = 'No PCS Plan ID  found for the selected Plan'; 
   
    //T02 start
    //Operation 4 values used in AIA_OP4PCSIntializeGroupersLimitations
    public static final String InNetwork= 'InNetwork'; 
    public static final String OutNetwork= 'OutNetwork';
    public static final string costsharestr = 'Cost Share Group';
    public static final string Benefitstr = 'Benefit Group';
    public static final string spccostr = 'Specialist Copay';
    public static final string peradstr = 'Per Admission Copay';
    public static final string pcpcostr = 'PCP Copay';
    public static final string gencostr = 'General Copay';
    //T02 end
    public static final String IMPLEMENTATIONSTR = 'Implementation'; // T23 10/7/18
    public static final String Opportunity = 'Opportunity';
    public static final String BenifitRequestForm = 'Benfit_Request_Form__c';
    public static final String Implementation = 'AIA_Implementation__c';
    public static final String AIADocument = 'AIA_Document__c';
    public static final String GrpStrReqForm = 'AIA_Group_Structure_Request_Form__c';
    public static final String BenefitDesign = 'AIA_Benefit_Design__c';
    
    /** T05 - Start **/
    public static final String BD = 'AIA_Benefit_Design__c';
    public static final String BDF = 'AIA_Benefit_Design_Form__c';
    public static final String BDP = 'AIA_Benefit_Design_Product__c';
    /** T05 - End **/
    
    //GSRF Status
    //T03 - Start
    public static final string ERRMSG='GSRF cannot be exported since status is not Approved by Account';
    public static final string GSRFERRMSG='This user is not authorized to export the Group Structure. Only IM/AM/MAST/Automated Enrollment Tech user can use this feature.'; //T10 Changes
    public static final string GSERRMSG='This user is not authorized to export the Group Structure. Only MAST Tech user can use this feature.'; //T10 Changes
    public static final string DDPNAME= 'Group Structure Request Form';
    public static final string Status= 'Approved by Account';
    public static final string GSRF_Status_Draft='Draft - New';
    public static final string GSRF_Status_DraftIncomplete='Draft - Incomplete';
    public static final string GSRF_Status_Rejected='Rejected by Internal Team';
    public static final string GSRF_Status_RejectedbyAccount='Rejected by Account';
    public static final string GSRF_Status_AssignedtoMAST='Assigned to MAST';
    public static final string PROFILE200= 'AIA 200+ Standard User - Custom';
    public static final string PROFILE51= '51+ Standard User - Custom';
    public static final string PROFILESYSADMIN= 'System Administrator';
    public static final string ROLEMAST= 'MAST Tech';
    //T21 start
    public static final string ROLEAEBE= 'Automated Enrollment Tech';
    //T21 end
    public static final string DOCTYPE='Group structure Request Form Document';
    public static final string DOCTYPEGSD='Group Structure Document';
    public static final string GSEDITEDBYBACKEND= 'backend';   
    public static final string GSEDITEDBYUI= 'ui';   
    //T03 - End
    //T16   start
    public static final string OBJNAMEGROUP= 'groups';   
    public static final string OBJNAMEGSP= 'GSP';   
    public static final string OBJNAMEPACKAGES= 'packages';   
    public static final string OBJNAMEDEPS= 'deps';   
    public static final string OBJNAMEFACETGROUP= 'facetgroup';   
    public static final string OBJNAMEFACETCLASS= 'facetclass';   
    public static final string OBJNAMEFACETSUBGROUP= 'Facet sub group';   
    //T16   End

    /** T04 - Start **/
    public static final string BD_STATUS_IN_PROGRESS = 'In Progress';
    public static final string BD_STATUS_IN_REVIEW = 'In Review';
    public static final string BD_STATUS_DOC_GEN = 'Generating Documents';
    public static final string BD_STATUS_APPROVED = 'Approved';
    public static final string BD_STATUS_REJECTED = 'Rejected';
    //T12   Start
    public static final string BD_ADJUSTMENT_DDPNAME= 'Adjustment Summary';
    public static final string BDDDPmsg='Benefit Design status should be Approved to generate output';
    //T12   End
    /** T04 - End **/
    
    /** T06 - Start **/
    public static final string ACCOUNTEXECUTIVE = 'Account Executive';
    public static final string PROPOSALSPECIALIST = 'Proposal Specialist';
    public static final string UNDERWRITER = 'Underwriter';
    public static final string SLA_OneDay_Before = 'SLA Violation before 1 day for WP Tasks'; 
    public static final string SLA_OneDay_After = 'SLA Violation After 1 day for WP Tasks'; 
    /** T08 - Start **//** T09 - Start **/
    public static final string IMP_MANAGER = 'Implementation Manager';
    /** T08 - END **//** T09 - END **/
    /** T06 - END **/
    
    /** T07 - Start **/
    public static final string Religious_Exemption_Benefit_Selection ='If Religious Exemption Prerequisite is &quot;Yes&quot;, the Group is Exempt from covering the services listed below. <br>(Carefirst DOES NOT provide <b>payment </b>for these services per ACA.) If Part Religious Exemption <br>Prerequisite selection is &quot;No&quot;, the Group is not Exempt from covering the services listed below.<ul><li>Exemption is available to Non-grandfathered groups that satisfy exemption requirements of Religious Exemption Prerequisite.</li><li>Grandfathered groups may elect the Full Exclusion regardless of religious organization status.</li></ul><b><u>Full Exclusion:</u></b><ul><li>Female Sterilization.</li><li>Family Planning Services; and</li><li>Contraceptive Drugs (Including emergency Contraception) and devices, and any related medical exams.</li></ul>';
    public static final string Benefit_Selection_Description = 'If Religious Accommodation Prerequisite selections are &quot;Yes&quot;, the group is accommodated to exclude the services listed below. (Carefirst will provide <b>payment</b> for the services.) If Religious Accommodation Prerequisite selections are &quot;No&quot;, the group is not eligible for an Accommodation.';
    public static final string Emergency_Contraception_Exclusion_Desc ='<ul><li>Emergency Contraception and any related Medical Exams.</li></ul>';
    public static final string Full_Exclusion_Description = '<ul><li>Female Sterilization.</li><li>Family Planning Services; and</li><li>Contraceptive Drugs (Including emergency Contraception) and devices, and any related medical exams.</li></ul>';
    /** T07 - END **/           

    /** T11 -   Start   For AIA_ProposedProductCPE class **/
    public static final string RecordType = 'RecordType';
    public static final string brfid = 'brfid';
    public static final string accid = 'accid';
    public static final string fundingArrangement = 'fundingArrangement';
    public static final string fundingArrangementBoth = 'Both';
    public static final string fundingArrangementOther = 'Other';
    
    /** T11 -   End     **/

    /** T13 -   Start   For AIA_ProposedProductCPE class **/
    public static final string GSID = 'gsid';
    public static final string GSIDINDVB = 'gsID';
    public static final string GSRECORDID = 'gsrecordid';
    public static final string DVB = 'DVB';
    public static final string SINGLEDVB = 'Only one DVB product can exist for one Group Structure. Please refer to the already existing DVB product in the Group Structure Product list';
    public static final string IMP_ACCID = 'accid';
    public static final string IMPID = 'impid'; 
    /** T13 -   End     **/
    
    /** T14 -   Start   **/
    Public static final string approvalMsg = 'This record is submitted for approval.';
    Public static final string approvalMsgEnd = 'Please try to edit only after it is approved or rejected';
    /** T14 -   End     **/
    
    /** T15 - Start  **/
    public static final string COMPLETED_STATUS = 'Completed';
    public static final string NOTSTARTED_STATUS = 'Not Started';
    public static final string INPROGRESS_STATUS = 'In Progress';
    public static final string INREVIEW_STATUS = 'In Review';
    public static final string INPENDING_STATUS = 'Pending';
    public static final string CALENDER_TYPE = 'Calendar';
    /** T15 - End **/
    
    
    /**T17 Start **/
    //Pre-sales or post-sales Subprocess Stages 
    public static final String  GROUP_STRUCTURE = 'Group Structure';
    public static final String  EDC = 'Enrollment Data Card';
    public static final String  BENEFIT_SETUP= 'Benefit Setup';
    public static final String  CSR  = 'Change System Request';
    public static final String  PERF_GUARANTEE = 'Performance Guarantee';
    public static final String  GENERATE_POST_SALE_SBCS = 'Summary of Benefits and Coverage';
    public static final String  ACCOUNT_KICK_OFF_MEETING = 'Account Kick-off Meeting';
    public static final String  MARKETING_MATERIALS = 'Marketing Materials';
    public static final String  BR_WELLNESS   = 'Blue Rewards and Wellness';
    public static final String  SETUP_MAGELLAN  = 'Setup Magellan';
    public static final String  PROCESS_ENROLLMENT = 'Process Enrollment';
    public static final String  PP_CFL  = 'Par Plan Custom Letters';
    public static final String  ACCM_CNT_SVCS = 'Accommodation of Contraceptive Services';
    public static final String  CREATE_BENEFIT_CONTRACT  = 'Benefit Contract';
    public static final String  IMPLEMENTATION_PLAN  = 'Implementation Plan';
    public static final String  BENEFIT_DESIGN_DOC  = 'Benefit Design';//'Benefit Design Doc'
    public static final String  CYC  = 'CYC';
    public static final String  SETUP_CVS = 'Setup Pharmacy';
    public static final String  SETUP_FACETS_DENTAL  = 'Setup Dental';
    public static final String  CARVE_OUT_RX = 'Carve-Out Pharmacy';
    public static final String  ID_CARDS = 'ID Cards';
    public static final String  ACCOUNT_FINANCIAL_CONTRACTS = 'Administrative Service Agreement';
    public static final String  BAA = 'Business Associate Agreement and Confirmation (BAA/BAC)';
    public static final String  RFP   = 'RFP';
    public static final String  BENEFIT_REQUEST  = 'Benefit Request';
    public static final String  ARC_APPROVAL   = 'ARC Approval';
    public static final String  UNDERWRITING = 'Underwriting';
    public static final String  QUOTE_DELIVERED= 'Quote Delivered';
    public static final String  SALESSOLD = 'Sold';
    public static final String  DEAD  = 'Dead';
    public static final String  PROSPECTING = 'Prospecting';
    public static final String  PROPOSAL = 'Proposal';
    public static final String  CREATE_MM = 'Marketing Materials';
    public static final String  BLUEFUND  = 'BlueFund';
    public static final String  ASA = 'Administrative Service Agreement';
    public static final String  BAC = 'BAC';
    public static final String  GENERATE_MONTHLY_INVOICES = 'Monthly Invoices';
    public static final String  CREATE_MICROSITE = 'Microsite';
    public static final String  MYACCOUNT= 'MyAccount';
    public static final String  SEARCHLIGHT_HEALTHCHECK = 'Searchlight HealthCheck';
    public static final String  SETUP_DAVIS = 'Setup Vision';
    
    //Opp Business Type
    public static final String OPP_BUSNIESSTYPE = 'New';
    
    //BRF Request Types
    public static final String PROSPECT_OR_NEW = 'Prospect/New';
    public static final String RENEW_AS_IS = 'Renew As-is';
    public static final String RENEWAL_ADMINISTRATIVE_CHANGES = 'Renewal - Administrative Changes';
    public static final String RENEWAL_BENEFIT_CHANGES = 'Renewal - Benefit Changes';
    public static final String RENEWAL_ADMIN_AND_BENEFIT_CHANGES = 'Renewal - Admin and Benefit Changes';
    public static final String RENEWAL = 'Renewal';
    /**T22-Start**/
    public static final String OFF_ADMIN_CHANGE = 'Off-Cycle - Administrative Change';
    public static final String OFF_BENEFIT_CHANGE = 'Off-Cycle - Benefit Change';
    public static final String OFF_ADMIN_BENEFIT_CHANGE = 'Off-Cycle - Administrative and Benefit Change';
    public static final String SETUP_ADMIN_CHANGE = 'Set-up Change - Administrative Changes';
    public static final String SETUP_BENEFIT_CHANGE = 'Set-up Change - Benefit Changes';
    public static final String SETUP_ADMIN_BENEFIT_CHANGE = 'Set-up Change - Admin and Benefit Changes';
    /**T22-END**/
    //BRF Funding Arrangement
    public static final String ASO = 'ASO';
    public static final String BOTH = 'Both';
    
    //opportunity
    public static final String OPPRFP = 'RFP';
    public static final String OPPBENEFIT_REQUEST = 'Benefit Request';
    public static final String OPPARC_APPROVAL = 'ARC Approval';
    public static final String OPPUNDERWRITING = 'Underwriting';
    public static final String OPPQUOTE_DELIVERED = 'Quote Delivered';
    public static final String OPPDEAD = 'Dead';
    public static final String OPPPROPOSAL = 'Proposal';
    public static final String OPPSOLD = 'Sold';
    public static final String OPPBUSINESSTYPENEW = 'New';
    
    // BRF Religious Accommodation
    public static final String EMERGENCY_CONTRACEPTION_ACCOMODATION = 'Emergency Contraception Accommodation';
    public static final String ACCOMODATION = 'Accommodation';
    /*T17 -End **/
    
    /** T18 - Start **/
    public static final string WPTask_STATUS_COMPLETED = 'Completed';
    public static final string WPTask_STATUS_NOTREQUIRED = 'Not Required';
    public static final string WPTask_STATUS_BLOCKED = 'Blocked';
    public static final string WPTask_STATUS_INPROGRESS = 'In Progress';
    public static final string ERRMESSAGE_SELECTTASKS = 'Please select a task to Block'; 
    public static final string ERRMESSAGE_MORETHANFIFTY = 'Please select upto 50 tasks to Block';
    public static final string ERRMESSAGE_MORETHANONE = 'Please select only 1 task';
    public static final string ERRMESSAGE_SELFOWNED = 'Please select In-Progress tasks owned by You'; 
    public static final string ERRMESSAGE_SUBPROCESS = 'Please select a Sub Process'; 
    public static final string ERRMESSAGE_TASK = 'Please select a Task';    
   
    /** T18 - End **/
    Public static final string GSADJDDP = 'GS Adjustment Summary';
    Public static final string RULPROFILE = 'AIA RUL Custom';
    Public static final string ONEGSRF = 'Only one GSRF can be created per Implementation. Please view the Implementation related list to find the GSRF';
    /** T20 - Start **/
    public static final string ERRMESSAGE_TASKNAME = 'Please enter New Task Name.'; 
    public static final string ERRMESSAGE_TASKDESCRIPTION = 'Please enter Task Description.';
    public static final string ERRMESSAGE_TEAMROLE = 'Please select Team Role.'; 
    public static final string ERRMESSAGE_TEAMMEMBER = 'Please select Team Member.'; 
    public static final string ERRMESSAGE_TOTALDAYS = 'Please enter Total Days to Complete Task (SLA).'; 
    public static final string STATUS_INPROGRESS = 'In-Progress';
    public static final string STATUS_NOTSTARTED = 'Not Started';
    public static final string STATUS_NOTREQUIRED = 'Not Required';
    /** T20 - End **/
}