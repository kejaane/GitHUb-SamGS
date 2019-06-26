/*******************************************************************************************************
 * Date         : 04-12-2017
 * Developer    : Bill Dodson
 * Purpose      : Controller extension which is used to submit a BRF for Arc Approval. 
 *======================================================================================================
 *                      =======[Update History]=======
 * Date         Developer       Tag        Description
 *======================================================================================================
 * 04-12-2017   Bill Dodson    |   |  Initial Development
 * 04-23-2017   Bill Dodson           Use BRF_Opp_Link__c in notifications.  Lock record when
 *                                    submitted.
 * 04-25-2017   Bill Dodson    |T01|  Send chatter to BRF record owner, not account owner.   
 *                                    Add invocable method to unlock the BRF.  Do not lock
 *                                    record for auto approval.
 * 04-26-2017   Bill Dodson    |T02|  Correct spelling in exception message.  Add test visible
 *                                    to methods to enable testing.
 * 05-01-2017   Bill Dodson    |T03|  Change roll up summary fields used to determine committee
 *                                    members for Wellness.
 * 05-02-2017   Bill Dodson    |T04|  Split Pharmacy Management and RX Marketing into two groups.
 * 05-08-2017   Bill Dodson    |T05|  Make auto approve groups visible to the test class so that
 *                                    the test class can validate the correctness of the groups.
 * 05-30-2017   Bill Dodson    |T06|  Correct approve by committe logic to determine if wellness
 *                                    is a group member. 
 * 05-31-2017   Bill Dodson    |T07|  Add Sales Management Approval Status to message.
 * 06-07-2017   Bill Dodson    |T08|  Modify logic to determine auto approval.  Enhance error
 *                                    messages.
 * 07-05-2017   Bill Dodson    |T09|  Add logic so that BCM has to approve an Auto Approved BRF
 *                                    that contain one or more Risk Non Standard products.
 * 07-11-2017   Bill Dodson    |T10|  Always use BCM department email address instead of each
 *                                    user in the BCM public group emails.
 * 07-13-2017   Bill Dodson    |T11|  Add BCM for Committee Approval when the BRF contains Risk
 *                                    non-standard drug or dental.
 * 09-21-2017   Bill Dodson    |T12|  Add check to insure zip code validation is fill in for VA
 *                                    jurisdictions.
 * 10-27-2017   Debkanti       |T13|  Added dental email from custom setting to send email
 *                                    for approval process.
 * 12-01-2017   Rajesh Pennma  |T14|  Commented the method setHtmlBody in place of setPlainTextBody
 *                                    to solve the issue with RichText Field 
 * 12-08-2017   Goutham Rapolu |T15|  Submit to Underwriting once the ARC is Approved/Auto-Approved.  
 * 12-08-2017   Goutham Rapolu |T16|  Submit to Sales Mgmt Approval if BRF is Off-Cycle once the ARC 
 *                                    is Approved/Auto-Approved.    
 * 12-08-2017   Goutham Rapolu |T17|  Check if Current User is having a Manager to send for Sales 
 *                                    Management Approval  
 * 02-23-2018   Debkanti       |T18|  Added the logic to update the AIA_Apporval_Status field to 
 *                                    true/false based on the approval condition
 * 02-26-2017   Goutham Rapolu |T19|  Resubmit ARC if ARC is rejected. & Reset 
 *                                    Escalated_to_Senior_Management__c checkbox if already true.
 * 02-28-2018   Sajitha        |T20|  Modified Null check as part of INC0397820
 * 03-23-2018   Raviteja       |T21|  Code change If the Non-Standard Fee Schedule field has a 'Yes' 
 *                                    value upon submitting the BRF for approval, then the system 
 *                                    shall require ARC approval from UW,  BeneFACT Coder, and NASCO 
 *                                    Benefit Coder.
 * 05-30-2018    Satya         |T22|  Post a chatter message to each user who needsto approve the ARC.
 *                                    Added as a part of US2861 
 * 07-24-2018    Satya         |T23|  Corrected the spelling in the error msg as a part of production retrofit
 * 09-05-2018    Arshia Gulati |T24|  Remove MHP check from errors US-771
 * 11-29-2018    Gayathri      |T25|  Replacing NASCO Benefit Coder with Benefit Coder and Benefit Tester - US1730
 * 11-29-2018    Chaithra      |T26|  Replacing Ancilliary Analyst with Vision analyst -US1702
 * 01-16-2019    Satya         |T27|  Made changes as a part of defect fix. Added Benefact coding and 
                                      Benefit Coding groups for Nonstandard condition
 * 01_31-2019 	 Chaithra 	   |T28|  Changes made to replace standard AccountTeamMember object with Custom object as part of US6713
 *******************************************************************************************************/
 
 public class AIA_BRFSubmitArcApprovalCtrlExtension
 {
    private ApexPages.StandardController stdCon;
    public Boolean displayPopup {get; set;}
    public String msg {get; set;}
    @TestVisible public String brfRecId; 
    
    // Strings that correspond to the ARC Committee public groups.
    @TestVisible private static final String NASCO_BENEFIT_CODING = 'AIA NASCO Benefit Coding';
    @TestVisible private static final String BENEFACT_CODING = 'AIA BeneFACT Coding';
    @TestVisible private static final String VISION_ANALYST='Vision Analyst';//T26
    @TestVisible private static final String BENEFIT_CODING='AIA Benefit Coder';//T25
    @TestVisible private static final String BENEFIT_TESTING='AIA Benefit Tester';//T25
    @TestVisible private static final String MAST = 'AIA MAST';
    @TestVisible private static final String AIA_VISION_GROUP='AIA Vision Analyst';//T26
    @TestVisible private static final String UWG = 'Underwriter';//T27
    //T-21 Start
    @TestVisible private static final String UW = 'Underwriter';
    @TestVisible private static final String BeneFACT_Coder = 'BeneFact Coder';
    @TestVisible private static final String NASCO_Benefit_Coder = 'NASCO Benefit Coder';
   // @TestVisible private static final String PHARMACY_OPERATIONS_ROLE='Pharmacy Operations';//T26
    @TestVisible public Boolean nonStandard;
    @TestVisible public Boolean Standard;
    public Map<string,Id> roleIdMap=new Map<string,Id>();
    //T21 End
    @TestVisible private static final String BCM = 'AIA BCM';
   // @TestVisible private static final String ANCILLARY_ANALYST_SETUP = 'AIA Ancillary Analyst Setup'; T26
    @TestVisible private static final String PHARMACY_MANAGEMENT = 'AIA Pharmacy Management'; // T04
    @TestVisible private static final String RX_MARKETING = 'AIA RX Marketing'; // T04
    @TestVisible private static final String WELLNESS = 'AIA Wellness';
    @TestVisible private static final String DENTAL_TEAM = 'AIA Dental Team';
    @TestVisible private static final String CDH_TEAM = 'AIA CDH Team';
    @TestVisible private static final String ARC_UW_Approved = 'Rejecting Request because the Benefit Request Form has been ARC approved and also Submitted to UnderWriting.';
    @TestVisible private static final String Salesmgmtsubmitted = 'Benefit Request Form has already been submitted to Sales Management Approval.';
    // The list of groups that will be notified when auto approving a BRF.
    @TestVisible List<String> autoApproveGrpList = null; // T05
    //T25 Start
    @TestVisible public Boolean nonStandard_Custom_Medical;
    @TestVisible private static final String Benefit_Tester = 'Benefit Tester';
    @TestVisible private static final String Benefit_Coder = 'Benefit Coder';
    //T25 End
    @TestVisible public Boolean nonStandard_Custom_Vision; //T26 
    
    public AIA_BRFSubmitArcApprovalCtrlExtension(ApexPages.StandardController stdController)
    {
        stdCon = stdController;
        brfRecId = (String)stdCon.getRecord().id;
        displayPopup = false;
    } 
    
    public PageReference returnToBrf()
    {
        return new PageReference('/' + brfRecId);
    }     
 
     public PageReference submitBrfForArchApproval()
    {     
        //T17
         user u = [select id, managerId from User where id =: UserInfo.getUserId()];
         Id CurrentUserID = UserInfo.getUserId();
         
         
         system.debug(' @@@Manager @@@'+ u);
         Boolean managerpresent = false;
         system.debug('@@  AIA_Utils.isNullOrEmpty(u.managerId) '+AIA_Utils.isNullOrEmpty(u.managerId));
         if(!AIA_Utils.isNullOrEmpty(u.managerId)){
             managerpresent = true;
             system.debug(' @@@ Manager present @@@');
          }

        set<string> requesttype = new set<string>{'Off-Cycle','Off-Cycle - Administrative Change','Off-Cycle - Benefit Change','Off-Cycle - Administrative and Benefit Change'};
        Benfit_Request_Form__c brfRec = [SELECT 
                                         ARC_Approval_Status__c,AIA_Approval_Status__c, BRF_Link__c, Count_of_Proposed_Products__c, 
                                         //MHP_Required__c, MHP_Test_Result__c,         //T24
                                         Request_Type__c, Sales__c,
                                         Source_Benefit_Request_Form__c, Source_Benefit_Request_Form__r.Status__c,
                                         Count_of_Custom_Products__c, Count_of_Medical_CDH_BlueFund__c,
                                         Count_of_Medical_Custom_Wellness__c, Count_of_Medical_FSA_BlueFund__c,
                                         Count_of_Risk_Non_Standard_Drug_Dental__c, Name, Owner__c, Account__r.Name,
                                         Opportunity__r.name, LastModifiedById, Count_Vision_Products__c,
                                         Count_Drug_Proposed_Products__c,Escalated_to_Senior_Management__c,
                                         Count_Dental_Products__c, Count_of_CDH_Products__c,
                                         Count_of_Custom_Dental_Products__c, Count_of_Nonstandard_Dental_Products__c,
                                         Count_of_Custom_Drug_Products__c, Count_of_Nonstandard_Drug_Products__c,
                                         Count_of_Custom_Vision_Products__c, ARC_Comments__c, BRF_Opp_Link__c,
                                         CreatedById, Count_of_Integrated_DM_Wellness__c,
                                         Count_of_Stand_Alone_Disease_or_Wellness__c,Account__r.id,
                                         Count_of_Risk_Non_Standard__c, Zip_Code_Validation__c, Verified_By__c,
                                         Verification_Date__c, Jurisdiction__c, Submit_to_Underwriting__c,Account__r.Ownerid,
                                         Account__r.owner.email, Account_Legal_Name__c,Account__c,Funding_Arrangements__c,Stop_Loss__c,
                                         (Select Id, Document_Type__c from File_Net_Documents__r where Document_Type__c =: 'Census Information')
                                         ,Opportunity__r.Business_Type__c,Proposal_Request_Form__c
                                         FROM Benfit_Request_Form__c 
                                         WHERE id = :brfRecId];
         List<Contact> cntList = [select id, Email from Contact where AccountId =: brfRec.Account__c limit 1];
         ID AccountOwnerID = brfRec.Account__r.Ownerid;
         system.debug('@@  cntList '+ cntList + ' @@ ' + cntList.ISEMPTY());
         /**T19 Start**/
            if(brfRec.ARC_Approval_Status__c =='Rejected by Committee'){
                brfRec.ARC_Approval_Status__c = '';
            }
        /**T19 END**/ 
        
        //T20 - START
        if(brfRec.File_Net_Documents__r.ISEMPTY() && (string.isblank(brfRec.Proposal_Request_Form__c)) && brfRec.Opportunity__r.Business_Type__c == 'New') //T20 - END
            {
                msg = 'The related Account is new and there is no Proposal Request Form related to this Benefit Request Form. '+
                      'Please attach a Census Information File to the Benefit Request Form before submitting it to ARC/Underwriting';
                displayPopup = true; 
        
        return null; 
           }
        if(cntList.ISEMPTY() && brfRec.Request_Type__c.startsWith('Off-Cycle')){
            msg = 'Error : Associated Account does not have a contact to submit BRF for Sales Management Approval'; //T23
            system.debug(' @@@ no contact @@@');
            displayPopup = true; 
        
        return null;   
         }
        
        
         
        else if(brfRec.Count_of_Proposed_Products__c == 0)
        {
            msg = 'The Benefit Request Form cannot be submitted for ARC Approval since there are no products related to it';
        }    
        //T24 - Start
        /*
        else if(brfRec.MHP_Required__c == 'Yes' && brfRec.MHP_Test_Result__c == 'Fail')
        {
            msg = 'The Benefit Request Form cannot be submitted for ARC Approval since the Mental Health Parity Test has failed';
        }
        else if(brfRec.MHP_Required__c == 'Yes' && 
               (brfRec.MHP_Test_Result__c == 'Pending' || brfRec.MHP_Test_Result__c == '' || brfRec.MHP_Test_Result__c == null))
        {
            msg = 'The Benefit Request Form cannot be submitted for ARC Approval since the Mental Health Parity Test has not been completed';
        }
        */
        //T24 - End
         
        // T12
        else if((brfRec.Zip_Code_Validation__c == null || brfRec.Zip_Code_Validation__c == '' || 
                 brfRec.Verified_By__c == null || brfRec.Verified_By__c == '' || brfRec.Verification_Date__c == NULL) &&
                 brfRec.Jurisdiction__c == 'VA')
        {
            msg = 'Please complete Zip Code verification before submitting the BRF for ARC approval';
        }
        
        //ARC Approval & Sales Management Approval below.
        //T16 START
        
        else if(brfRec.ARC_Approval_Status__c != null && brfRec.ARC_Approval_Status__c != '' && brfRec.Submit_to_Underwriting__c == True)
        {
            msg = 'Rejecting request because the ARC Approval Status is not blank, status: ' + brfRec.ARC_Approval_Status__c;
            msg += ' and BRF is already submitted to Underwriting.';
            displayPopup = true; 
            return null; 
        }
        //T16 END 
        //T24-Start
        //else if((((brfRec.Funding_Arrangements__c == 'ASO' || brfRec.Funding_Arrangements__c == 'Other') && brfRec.Stop_Loss__c != 'CareFirst'  && (brfRec.Request_Type__c == 'Off-Cycle - Benefit Change' || brfRec.Request_Type__c == 'Off-Cycle - Administrative and Benefit Change')) || (brfRec.MHP_Required__c == null || brfRec.Request_Type__c == 'Off-Cycle - Administrative Change'))
        else if((((brfRec.Funding_Arrangements__c == 'ASO' || brfRec.Funding_Arrangements__c == 'Other') && brfRec.Stop_Loss__c != 'CareFirst'  && (brfRec.Request_Type__c == 'Off-Cycle - Benefit Change' || brfRec.Request_Type__c == 'Off-Cycle - Administrative and Benefit Change')) || ( brfRec.Request_Type__c == 'Off-Cycle - Administrative Change'))
        //T24-End
        
        && (brfRec.ARC_Approval_Status__c == 'Approved by Committee' || brfRec.ARC_Approval_Status__c == 'Auto-Approved by System'))
        {
            msg = 'EBRF006: Cannot Submit to Underwriting if in BRF:';
            //   msg += '1. MHP Required is blank (or)';        //T24
            msg += '2. For ASO/Other BRF, either Off cycle - Administrative and Benefit or Benefit Changes, if Stoploss is not CareFirst (or)';
            msg += '3. Offcycle changes - Administrative Changes';
            
        }
        
        //T24-Start        
        //else if((((brfRec.Funding_Arrangements__c == 'ASO' || brfRec.Funding_Arrangements__c == 'Other') && brfRec.Stop_Loss__c != 'CareFirst'  && (brfRec.Request_Type__c == 'Set-up Change - Benefit Changes' || brfRec.Request_Type__c == 'Set-up Change - Admin and Benefit Changes')) || ((brfRec.MHP_Required__c == null ||  brfRec.Request_Type__c == 'Set-up Change - Administrative Changes')) )
        else if((((brfRec.Funding_Arrangements__c == 'ASO' || brfRec.Funding_Arrangements__c == 'Other') && brfRec.Stop_Loss__c != 'CareFirst'  && (brfRec.Request_Type__c == 'Set-up Change - Benefit Changes' || brfRec.Request_Type__c == 'Set-up Change - Admin and Benefit Changes')) || ( brfRec.Request_Type__c == 'Set-up Change - Administrative Changes') )
        //T24-End
        && (brfRec.ARC_Approval_Status__c == 'Approved by Committee' || brfRec.ARC_Approval_Status__c == 'Auto-Approved by System'))
        {
            msg = 'EBRF021: Cannot Submit to Underwriting if in BRF:';
        //    msg += '1. MHP Required is blank (or)';       //T24
            msg += '2. For ASO/Other BRF, either Set-up Change - Admin and Benefit Changes or Benefit Changes, if Stoploss is not CareFirst (or)';
            msg += '3. Set-up Change - Administrative Changes';
             
        }        
        
        else if(brfRec.ARC_Approval_Status__c == 'Pending'){
            msg = 'Cannot submit for approval since BRF is in ARC Approval process';
            displayPopup = true; 
            return null; 
        }
        else if(brfRec.Request_Type__c.startsWith('Off-Cycle') && (brfRec.Sales__c != 'In Review' && brfRec.Sales__c != 'Approved' && brfRec.Submit_to_Underwriting__c == False)){
              if(managerpresent==true){
                  System.debug('@@AIASalesManagementApproval: ');
                  AIASalesManagementApproval.SubmittoSalesManagementApproval(brfRec.id,brfRec.Account__r.id);
                  msg = 'Successfully submitted for Sales Management Approval.';
                  displayPopup = true; 
                  return null; 
                  //return new PageReference('/' + brfRecId);
              }else{
                  System.debug('AIASalesManagementApprovalERROR ');
                  msg = 'Failed to send BRF to Sales Management Approval as Manager does not exist for the submitter.';
                  displayPopup = true; 
                  return null; 
              }
        } 
        
        else if(brfRec.Request_Type__c.startsWith('Off-Cycle') && brfRec.Sales__c != 'Approved'){
            msg = 'Cannot submit to ARC Approval since BRF is Off-Cycle and Sales Management is not Approved yet.';
            displayPopup = true; 
            return null;
        }
        
        else if(AIA_Utils.isNullOrEmpty(brfRec.ARC_Approval_Status__c) && brfRec.Submit_to_Underwriting__c == false
        && ((brfRec.Request_Type__c.startsWith('Off-Cycle') && brfRec.Sales__c == 'Approved') 
        || brfRec.Request_Type__c.indexof('Off-Cycle') < 0))
        {
            //T21   -   Start
             List<Proposed_Products__c> pps=[select id,Non_Standard_Fee_Schedule__c,Custom_New__c,
                                             Product_Category__c,Benefit_Request_Form__r.Funding_Arrangements__c
                                            from Proposed_Products__c
                                            where Benefit_Request_Form__c=:brfRec.Id
                                           ];
            nonStandard=false;
            Standard=true;
            
            for(Proposed_Products__c pp:pps){
                if(pp.Non_Standard_Fee_Schedule__c=='Yes'){
                    nonStandard=true;
                    break;
                }
            }
            
            for(Proposed_Products__c pp:pps){
                if(pp.Custom_New__c =='Non - Standard' || pp.Custom_New__c =='Custom'){
                    Standard=False;
                    break;
                }
            }
            //T21   -   End
            //T25 -- Start
            nonStandard_Custom_Medical = false;
            nonStandard_Custom_Vision = false;//T26
            
            for(Proposed_Products__c pp:pps){
                if((pp.Custom_New__c == 'Non - Standard' || pp.Custom_New__c == 'Custom') && pp.Product_Category__c == 'Medical'){
                    nonStandard_Custom_Medical=true;
                    //break;
                }
                //T26 -- Start
                else if((pp.Custom_New__c == 'Non - Standard' || pp.Custom_New__c == 'Custom') && pp.Product_Category__c == 'Vision'){
                    nonStandard_Custom_Vision=true;
                   
                }
                
                //T26 -- End
            }
            //T25 End
           system.debug('pps'+pps.size());
            
            //Send for Approval conditions below.
            if(brfRec.Source_Benefit_Request_Form__c != NULL && brfRec.Source_Benefit_Request_Form__r.Status__c == 'Sold' &&
                   AIA_Utils.isNullOrEmpty(msg) && (brfRec.Request_Type__c == 'Renew As-is' || brfRec.Request_Type__c == 'Renewal - Administrative Changes'))
                {          
                    if(brfRec.Count_of_Risk_Non_Standard__c > 0) // T09
                    {
                        System.debug('BCM approval via first condition set');
                        processSubmitForBcmApproval(brfRec); // T09
                    }
                    else
                    { 
                        system.debug('nonStandard'+nonStandard);
                        if(nonStandard){
                            processSubmitForApprovalForNonStandard(brfRec,false);
                        }
                        else{
                            System.debug('Auto approved via first condition set');
                            processAutoApproved(brfRec);
                        }
                    }
                }
            else if(brfRec.Request_Type__c != 'Renew As-is' && brfRec.Request_Type__c != 'Renewal - Administrative Changes' &&            
                    brfRec.Count_of_Custom_Products__c == 0 && brfRec.Count_of_Medical_CDH_BlueFund__c == 0 &&
                    brfRec.Count_of_Medical_Custom_Wellness__c == 0 && brfRec.Count_of_Medical_FSA_BlueFund__c == 0 &&
                    brfRec.Count_of_Risk_Non_Standard_Drug_Dental__c == 0)  // T08, replaced roll up field.  
            {          
                if(brfRec.Count_of_Risk_Non_Standard__c > 0) // T09
                {
                    System.debug('BCM approval via second condition set');
                    processSubmitForBcmApproval(brfRec); // T09
                }
                else
                { 
           system.debug('nonStandard1'+nonStandard);
                     if(nonStandard){
                            processSubmitForApprovalForNonStandard(brfRec,Standard);
                     }
                    else{
                        System.debug('Auto approved via second condition set');
                        processAutoApproved(brfRec);
                    }
                }
            }  
            else if(AIA_Utils.isNullOrEmpty(brfRec.ARC_Approval_Status__c))
            {                   
                // Submit for committee approval.
                processSubmitForApproval(brfRec);
            }
        }
        else if((brfRec.ARC_Approval_Status__c == 'Approved by Committee' || brfRec.ARC_Approval_Status__c == 'Auto-Approved by System') && brfRec.Submit_to_Underwriting__c == false)
           {
            try{
                system.debug('underwriting!@@'+brfRec.Submit_to_Underwriting__c +'@@'+brfRec.ARC_Approval_Status__c);
                brfRec.Submit_to_Underwriting__c = True;
                update brfRec;
                return new PageReference('/' + brfRecId);
            }catch(exception e){
                msg = string.valueof(e);
            }
        }
        
        system.debug('@@before email');
            if(!AIA_Utils.isNullOrEmpty(msg) && msg.IndexOf('Successfully') < 0 && CurrentUserID != AccountOwnerID){
                    List<String> sendToEmailList = new List<String>();
                    sendToEmailList.add(brfRec.Account__r.owner.email);
                    String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                     
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(sendToEmailList); 
                    mail.setSubject('Errors for '+brfRec.Account_Legal_Name__c+' '+brfRec.Name);
                    String htmlBody;        
                    htmlBody = 'Hello,<br/><br/>';       
                    htmlBody += 'The following BRF for '+brfRec.Account_Legal_Name__c+' has the following validation issues.';
                    htmlBody += ' Please complete the List of Changes below and then Re-Submit the BRF for Approval';
                    htmlBody += '<br/><br/>1. '+ msg;
                    htmlBody += '<br/><br/>'+brfRec.Name+': '+sfdcBaseURL+'/'+brfRec.id;
                    htmlBody += '<br/><br/>Thank you,<br/>Salesforce Automation.';   
                    mail.sethtmlBody(htmlBody); 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
               system.debug('@@inside email');    
               system.debug('@@email list'+sendToEmailList); 
            } 
        System.debug('At the bottom of submitBrfForArchApproval, msg: ' + msg);
         
        displayPopup = true; 
        
        return null;   
    }
    
    // This is a helper method that will perform processing needed when a BRF is auto approved.
    @TestVisible // T02
    private void processAutoApproved(Benfit_Request_Form__c brfRec)
    {          
        System.debug('At the top of processAutoApproved');
            
        Savepoint sp = Database.setSavepoint(); 
        
        try
        {        
            // Set the BRF submitted and approved ARC date.  Days to approve is a formula field.
            /* T18 Start */
            updateBrfRec(Date.today(), 'Auto-Approved by System',false);
            /* T18 End */
                
            postToChatter(brfRec.createdById,  // T01
                        'The Benefit Request Form ' + brfRec.Name + 
                        ' under Opportunity ' + brfRec.Opportunity__r.name + ' has been approved by ARC<br/>' +
                        'Opportunity: ' + brfRec.BRF_Opp_Link__c + '<br/>' +
                        'Benefit Request Form: ' + brfRec.BRF_link__c);         

            // Get a list of all the groups who should be emailed.
            autoApproveGrpList = getAutoApproveGroups(brfRec);  // T05
            
            // Get a list of email addresses for all the group members.
            List<String> toAddresses = getGroupMemberEmailAddresses(autoApproveGrpList);  // T05

            // Email members of the approval.
            String subject = 'Benefit Request Form for Account ' + brfRec.Account__r.Name + ' has been ARC Auto-Approved';
            String body = 'The Benefit Request Form ' + brfRec.Name + ' for Account ' + brfRec.Account__r.Name + ' has been ARC Auto-Approved.<br/><br/>' + 
                          'For details on the Benefit Request Form, click here: ' + brfRec.BRF_Link__c + '<br/><br/>' +
                          'Thanks,<br/>AIA Automation';
            sendEmail(toAddresses, subject, body);
                
            msg = 'Successfully Auto Approved the Benefit Request Form';     
        }        
            
        catch (Exception e)
        {
            msg = 'Failed during auto approval, aborted: ' + e;
            Database.rollback(sp);
        }                                                   
    } 
    
    
       
    // This helper method will submit the BRF to be approved by BCM. 
    // T09 begin
    @TestVisible
    private void processSubmitForBcmApproval(Benfit_Request_Form__c brfRec)   
    {
        System.debug('At the top of processSubmitForBcmApproval');
              
        Savepoint sp = Database.setSavepoint(); 
        
        try
        {        
            // Set the BRF submitted and approved ARC date.  Days to approve is a formula field.
            /* T18 Start */
            updateBrfRec(null, 'Pending',true);
            /* T18 End */
                
            // BCM will be the only approver.
            List<String> grpList = new List<String>{BCM};
             //T21  -   start
            if(nonStandard){   
                List<String> nonStandardgrpList = getArcCommitteeGroupsforNonStandard(brfRec,false);
                grpList.addAll(nonStandardgrpList);
            }
            //T21   -   End
            // Generate ARC Approval record for BCM.
            createApprovalRecords(grpList);
            
            // Get BCM department email address.
            AIA_Workflow_Emails__c workFlowEmails = AIA_Workflow_Emails__c.getInstance();
            System.debug('BCM Email: ' + workFlowEmails.ARC_Approval_Request_BCM_Email__c);
            List<String> toAddresses = new List<String>{workFlowEmails.ARC_Approval_Request_BCM_Email__c};
                
            //T21   -   Start
            if(nonStandard){  
                List<String> toAddressesNonStandard = getGroupMemberEmailAddressesforNonStandard(grpList);
                toAddresses.addAll(toAddressesNonStandard);
            }
            //T21   -   End
            
            // Email members of the approval.
            String subject = 'Approval Required on Benefit Request Form for Account ' + brfRec.Account__r.Name;
            String body = 'The Benefit Request Form ' + brfRec.Name + ' for Account ' + brfRec.Account__r.Name + 
                          ' has been submitted to ARC and requires your approval.<br/><br/>';
            body += 'ARC Comments: ' + brfRec.ARC_Comments__c + '<br/><br/>';
            body += 'Please review the Benefit Request Form, click here: ' + brfRec.BRF_Link__c + '<br/><br/>' +
                    'Thanks,<br/>AIA Automation';
                    
            sendEmail(toAddresses, subject, body); 
            
            lockBrfRec(brfRec);
            
            msg = 'Successfully submitted the Benefit Request Form for BCM Approval';
        }
        catch (Exception e)
        {
            msg = 'Failure during ARC submit for BCM approval, submit aborted: ' + e;
            Database.rollback(sp);
        }    
    } // T09 end     
    
    // This is a helper method that will perform processing needed when a BRF needs committe approval.
    @TestVisible // T02
    private void processSubmitForApproval(Benfit_Request_Form__c brfRec)
    {              
        System.debug('At the top of processSubmitForApproval');
        List<FeedItem> fItems = new List<FeedItem>();
              
        Savepoint sp = Database.setSavepoint(); 
        
        try
        {        
            // Set the BRF submitted and approved ARC date.  Days to approve is a formula field.
            /* T18 Start */
            updateBrfRec(null, 'Pending',true);
            /* T18 End */
                
            // Get a list of all the groups who are involved in the approval.
            List<String> grpList = getArcCommitteeGroups(brfRec);
            
            // Generate ARC Approval records, one for each group involved.
            createApprovalRecords(grpList);
            
            // Get a list of email addresses for all the group members.
            List<String> toAddresses = getGroupMemberEmailAddresses(grpList);
            
            /*T22 CHANGES START*/
            //Post a chatter message to each member
            for(User usr:[SELECT id,email FROM User WHERE email IN :toAddresses]){
                FeedItem post = new FeedItem(); 
                post.ParentId = usr.id; 
                String body = 'The Benefit Request Form ' + brfRec.Name + ' for Account ' + brfRec.Account__r.Name + 
                          ' has been submitted to ARC and requires your approval. ';
                body += 'Please review the Benefit Request Form, click here: ' + brfRec.BRF_Link__c;          
                post.Body = body ;
                fItems.add(post);
            }
            
             if(!fItems.isEmpty()){
                insert fItems;
             }
             /*T22 Changes Ends*/
             
            // Email members of the approval.
            String subject = 'Approval Required on Benefit Request Form for Account ' + brfRec.Account__r.Name;
            String body = 'The Benefit Request Form ' + brfRec.Name + ' for Account ' + brfRec.Account__r.Name + 
                          ' has been submitted to ARC and requires your approval.<br/><br/>';
            body += 'ARC Comments: ' + brfRec.ARC_Comments__c + '<br/><br/>';
            body += 'Please review the Benefit Request Form, click here: ' + brfRec.BRF_Link__c + '<br/><br/>' +
                    'Thanks,<br/>AIA Automation';
                    
            //sendEmail(toAddresses, subject, body); -T22 Change, Commented as a part of US2861
            
            lockBrfRec(brfRec);
            
            msg = 'Successfully submitted the Benefit Request Form';
        }
        catch (Exception e)
        {
            msg = 'Failure during ARC submit to committee, submit aborted: ' + e;
            Database.rollback(sp);
        }   
    }
   
     //T21 start
     @TestVisible // T02
    private void processSubmitForApprovalForNonStandard(Benfit_Request_Form__c brfRec, Boolean temp)
    {              
        System.debug('At the top of processSubmitForApproval');
        List<FeedItem> fItems = new List<FeedItem>();
              
        Savepoint sp = Database.setSavepoint(); 
        
        try
        {        
            // Set the BRF submitted and approved ARC date.  Days to approve is a formula field.
            /* T18 Start */
            updateBrfRec(null, 'Pending',true);
            /* T18 End */
                
            // Get a list of all the groups who are involved in the approval.
            List<String> grpList = getArcCommitteeGroupsforNonStandard(brfRec,temp);
            
            // Generate ARC Approval records, one for each group involved.
            createApprovalRecords(grpList);
            
            // Get a list of email addresses for all the group members.
            //List<String> toAddresses = getGroupMemberEmailAddressesforNonStandard(grpList);//commented as a part of T27 change
            List<String> toAddresses = getGroupMemberEmailAddresses(grpList);//T27
            
            /*T22 CHANGES START*/
            //Post a chatter message to each member
            for(User usr:[SELECT id,email FROM User WHERE email IN :toAddresses]){
                FeedItem post = new FeedItem(); 
                post.ParentId = usr.id; 
                String body = 'The Benefit Request Form ' + brfRec.Name + ' for Account ' + brfRec.Account__r.Name + 
                          ' has been submitted to ARC and requires your approval. ';
                body += 'Please review the Benefit Request Form, click here: ' + brfRec.BRF_Link__c;          
                post.Body = body ;
                fItems.add(post);
            }
            
             if(!fItems.isEmpty()){
                insert fItems;
             }
             /*T22 Changes Ends*/
             
            // Email members of the approval.
            String subject = 'Approval Required on Benefit Request Form for Account ' + brfRec.Account__r.Name;
            String body = 'The Benefit Request Form ' + brfRec.Name + ' for Account ' + brfRec.Account__r.Name + 
                          ' has been submitted to ARC and requires your approval.<br/><br/>';
            body += 'ARC Comments: ' + brfRec.ARC_Comments__c + '<br/><br/>';
            body += 'Please review the Benefit Request Form, click here: ' + brfRec.BRF_Link__c + '<br/><br/>' +
                    'Thanks,<br/>AIA Automation';
                    
            //sendEmail(toAddresses, subject, body); -T22 Change, Commented as a part of US2861
            
            lockBrfRec(brfRec);
            
            msg = 'Successfully submitted the Benefit Request Form';
        }
        catch (Exception e)
        {
            msg = 'Failure during ARC submit to committee, submit aborted: ' + e;
            Database.rollback(sp);
        }   
    }
    //T21 end
     
     
    // Helper method to update BRF record that was submitted for approval.
    @TestVisible // T08 /* T18 Start */
    private void updateBrfRec(Date approvalDate, String status,boolean aiaStatus) /* T18 End */
    {
        Boolean errFlag = false;

        // Set the BRF submitted and approved ARC date.  Days to approve is a formula field.
        Benfit_Request_Form__c brfRecUpdate = new Benfit_Request_Form__c(id = brfRecId,
                                                                         ARC_Approval_Initial_Submission_Date__c = Date.today(),
                                                                         ARC_Approval_Date__c = approvalDate,
                                                                         ARC_Approval_Status__c = status,
                                                                         AIA_Approval_Status__c = aiaStatus,
                                                                         Escalated_to_Senior_Management__c = false); 
             
        try // T08
        {
             update brfRecUpdate;
        }
        catch (Exception e) // T08
        {
            System.debug('Thowing failed to update BRF exception'+e);
            throw new ProcessingException('ERROR failed to update BRF record: ' + e); // T08
        }  
        id brfid = brfRecId;
        string querystring = QueryBase2.getSobjectAllFieldsSOQL('Benfit_Request_Form__c','id =:brfId');
        Benfit_Request_Form__c brf = database.query(querystring);
        list<Benfit_Request_Form__c> brflist = new list<Benfit_Request_Form__c>();
        brflist.add(brf);
        Map<id,Benfit_Request_Form__c> brfmap = new Map<id, Benfit_Request_Form__c>();
        brfmap.put(brf.id,brf);
        //method call to submit for next approval        
        AIA_BRFTriggerHelper.Send_For_SalesMgmt_or_ARC_or_UW_Approval(brflist,brfmap);  
    }   
    
    // Helper method to post to chatter.
    private void postToChatter(String ownerId, String body)
    {
        Boolean errFlag = false;
        
        // Notify BRF record owner via a chatter post.           
        FeedItem post = new FeedItem(); 
        post.ParentId = ownerId;           
        post.Body = body;
                
        // Let any exception propagate up to the caller's catch.  
        insert post; 
    } 
    
    // Helper method to get all the auto approved groups.
    private List<String> getAutoApproveGroups(Benfit_Request_Form__c brfRec)
    {
        // Determine Public Groups to notify by looking at BRF roll up summary fields.
        List<String> grpList = new List<String>();
        //grpList.add(NASCO_BENEFIT_CODING);//T25
        grpList.add(BENEFACT_CODING);
        grpList.add(MAST);
        grpList.add(BCM);       
        
      /* T26 commented 
        if(brfRec.Count_Vision_Products__c > 0 || brfRec.Count_Drug_Proposed_Products__c > 0)
        {
            grpList.add(ANCILLARY_ANALYST_SETUP);
        }T26 ends */
        
      
        
        if(brfRec.Count_Drug_Proposed_Products__c > 0) 
        {
            grpList.add(PHARMACY_MANAGEMENT);//T04
           
            grpList.add(RX_MARKETING); // T04
        }
        
        if(brfRec.Count_of_Integrated_DM_Wellness__c > 0) // T03, changed roll up summary field
        {
            grpList.add(WELLNESS );
        }
        
        if(brfRec.Count_Dental_Products__c > 0)
        {
            grpList.add(DENTAL_TEAM);
        }
        
        if(brfRec.Count_of_CDH_Products__c > 0)
        {
            grpList.add(CDH_Team);
        }        
        
        return grpList;     
    }

    // Helper method to get all the groups that must approve the BRF.
    @TestVisible // T08
    private List<String> getArcCommitteeGroups(Benfit_Request_Form__c brfRec)
    {
        // Determine Public Groups to who must approve the BRF.
        List<String> grpList = new List<String>();
        //T21   -   Start
        
        if(nonStandard){
            //Add business areas of UW,BeneFACT Coder and Benefit Coder.Replaced NASCO Benefit Coder as part of T25.
            grpList.add(UW);
            //grpList.add(BeneFACT_Coder);
            //grpList.add(Benefit_Coder) ;
            //grpList.add(NASCO_Benefit_Coder); //T25 commented
            }
        //T21   -   End
        //T25 Start
        if(nonStandard_Custom_Medical)
        {
           //grpList.add(Benefit_Tester);
           grpList.add(BENEFIT_CODING);
           grpList.add(BENEFIT_TESTING); 
           
        }
        
        //T25 End
        //T26 Start
        if(brfRec.Request_Type__c.contains('New') && nonStandard_Custom_Vision)
        {
           grpList.add(AIA_VISION_GROUP); 
        }
        else if(brfRec.Request_Type__c.contains('Renewal') && nonStandard_Custom_Vision)
        {
           grpList.add(VISION_ANALYST); 
        }
      
        //T26 End
        
        if(brfRec.Request_Type__c.contains('New') || brfRec.Request_Type__c.contains('Renewal'))
        {
            if(brfRec.Count_of_Custom_Products__c > 0 || brfRec.Count_of_Medical_Custom_Wellness__c > 0)
            {
                //grpList.add(NASCO_BENEFIT_CODING);//T25
                grpList.add(BENEFACT_CODING);
                grpList.add(MAST);
            }
        }
        else
        {
            //grpList.add(NASCO_BENEFIT_CODING);//T25
            grpList.add(BENEFACT_CODING);
            grpList.add(MAST);
        }
            
        if(brfRec.Count_of_Custom_Products__c > 0 || 
           brfRec.Count_of_Risk_Non_Standard_Drug_Dental__c > 0) // T11, added additional condition
        {
            grpList.add(BCM); 
        }      
        /*  commented as part of T26
        if(brfRec.Count_of_Custom_Drug_Products__c > 0 || brfRec.Count_of_Custom_Vision_Products__c > 0)
        {
            grpList.add(ANCILLARY_ANALYST_SETUP);
        }*/
        
        if(brfRec.Count_of_Custom_Drug_Products__c > 0 || brfRec.Count_of_Nonstandard_Drug_Products__c > 0)
        {
            grpList.add(PHARMACY_MANAGEMENT); // T04
            grpList.add(RX_MARKETING); // T04
        }
        
        if(brfRec.Count_of_Medical_Custom_Wellness__c > 0 ||  
           (brfRec.Count_of_Stand_Alone_Disease_or_Wellness__c > 0 &&  // T06, added Set-up and Off-Cycle condition.
            !brfRec.Request_Type__c.contains('Set-up') && !brfRec.Request_Type__c.contains('Off-Cycle')))
        {
            grpList.add(WELLNESS);
        }      
        
        if(brfRec.Count_of_Custom_Dental_Products__c > 0 || brfRec.Count_of_Nonstandard_Dental_Products__c > 0)
        {
            grpList.add(DENTAL_TEAM);
        }
        
        if(brfRec.Count_of_Medical_CDH_BlueFund__c > 0 || brfRec.Count_of_Medical_FSA_BlueFund__c > 0)
        {
            grpList.add(CDH_Team);
        }    
        
        if(grpList.size() == 0) // T08
        {
            System.debug('Thowing empty group list exception');
            throw new ProcessingException('ERROR no ARC committe groups were found'); // T08
        }    
        
        return grpList;     
    }
    
    //T21- start
     @TestVisible 
    private List<String> getArcCommitteeGroupsforNonStandard(Benfit_Request_Form__c brfRec,Boolean temp1)
    {
         // Determine Public Groups to who must approve the BRF.
        List<String> grpList = new List<String>();
        
            //Add business areas of UW,  BeneFACT Coder, and NASCO Benefit Coder.
           // grpList.add(UW);
            //grpList.add(BeneFACT_Coder); //pha
            //T25 -- Start
            //grpList.add(Benefit_Coder); //pha
            //grpList.add(NASCO_Benefit_Coder);
            //T25 -- End
            
           //T27 Changes start
           if(temp1 == false){
            grpList.add(BENEFACT_CODING);
            grpList.add(BENEFIT_CODING);
            grpList.add(BENEFIT_TESTING);
            grpList.add(UWG);
           } else {
            grpList.add(BENEFACT_CODING);
            grpList.add(BENEFIT_CODING);
            grpList.add(UWG);
           }
            //T27 Changes end
       
        return grpList;     
    }
    //T21 end 
     
    // Helper to create one record for each ARC Committe Group required for approval.
    private void createApprovalRecords(List<String> grpList)
    {        
        delete [SELECT ID FROM Approval_Response__c WHERE Benefit_Request_Form__c = :brfRecId];
    
        List<Approval_Response__c> aprvList = new List<Approval_Response__c>();
        
        for(String grp : grpList)
        {
            Approval_Response__c aprvRec = new Approval_Response__c(Benefit_Request_Form__c = brfRecId,
                                                                    Business_Area__c = grp);
            aprvList.add(aprvRec);                                                        
        }

        // Let any exception propagate up to the caller's catch.
        insert aprvList; 
        
    }
    
     Private void shareRecordstoUWBCNC(){
         List<Approval_Response__Share> apprShareList=new List<Approval_Response__Share>();
         //T25 -- Adding Benefit Coder and Benefit Tester in the query filter
         //T26 -- Adding Vision Analyst in the query filter
         List<Approval_Response__c> apprL=[select id,Business_Area__c 
                                           from Approval_Response__c
                                           where Benefit_Request_Form__c=:brfRecId and
                                           (Business_Area__c='Underwriter' or
                                            Business_Area__c='NASCO Benefit Coder' or Business_Area__c='BeneFact Coder' or Business_Area__c='Benefit Tester'
                                           or Business_Area__c='Benefit Coder' or Business_Area__c='Vision Analyst' )];
         for(Approval_Response__c appr:apprL){
             system.debug('roleIdMap'+roleIdMap);
             Id userId=roleIdMap.get(appr.Business_Area__c);
             system.debug('appr.Business_Area__c'+appr.Business_Area__c);
             system.debug('userId'+userId);
             if(userId!=null && userId!=system.UserInfo.getUserId() ){
             Approval_Response__Share apprShare=new Approval_Response__Share();
             apprShare.ParentId=appr.Id;
             apprShare.UserOrGroupId=userId;
             apprShare.AccessLevel='Edit';
             apprShareList.add(apprShare);
             }
         }  
         try{
         insert apprShareList;
         system.debug('apprShareList'+apprShareList);
         }
         catch(Exception e){
             system.debug('exce'+e);
            throw new ProcessingException('ERROR: Sharing records insertion failed'); 
         }
     }
    // Helper method to get a list of email addresses for the group members.
    @TestVisible 
    private List<String> getGroupMemberEmailAddresses(List<String> grpList)
    {
        List<String> toAddresses  = new List<String>();
        List<String> grpListNoBCM = new List<String>(); // T10
        Boolean bcmGroupFoundFlag = false; // T10
        Boolean UWBCNCFoundFlag = false; // T21
        Boolean grpBCBC = false;//T27
        Boolean userUW = false;
        List<String> grpBCBClst = new List<String>();
        
        // T10 begin
        // Create a list of groups without the BCM group.
        for(String grp : grpList)
        {
            if(grp == BCM)
            {
                bcmGroupFoundFlag = true;
            }
            
            //T27 changes start
            else if(grp == BENEFACT_CODING || grp ==  BENEFIT_CODING || grp == BENEFIT_TESTING){
                   grpBCBClst.add(grp);        
            }
            else if(grp == UWG ){
                  userUW = true;          
            }
            //t27 changes End
            
            //T21   -   start
            else if(grp == UW || grp == BeneFACT_Coder || grp == Benefit_Tester ||grp == Benefit_Coder || grp == VISION_ANALYST ){// || grp == NASCO_Benefit_Coder||grp == PHARMACY_OPERATIONS_ROLE//T25
                UWBCNCFoundFlag=true;
            }
            //T21   -   End
            else
            {
                grpListNoBCM.add(grp);
            }
            
        }
        // T10 end
        
        // Get a list of all User IDs for all the Public Groups.
        //T27 changes start
        //T28 Starts
       /* if(userUW){
            Benfit_Request_Form__c brf = [select id, Account__c from Benfit_Request_Form__c where id =:brfrecId ];
            String myValue = 'My Value';
            String query = 'SELECT AccountId,TeamMemberRole,Title,UserId,User.email FROM AccountTeamMember';
            query = query+' WHERE AccountId =\''+brf.Account__c+'\' and (TeamMemberRole = \'Underwriter\')';           
            system.debug('----query 102---->'+query);
            list<AccountTeamMember> accteamlst = Database.query(query);
            
            for(AccountTeamMember acteam:accteamlst){
                 toAddresses.add(acteam.User.email);
                
            } 
        }*/ //Commented as part of T28
        if(userUW){
            Benfit_Request_Form__c brf = [select id, Account__c from Benfit_Request_Form__c where id =:brfrecId ];
            String myValue = 'My Value';
            String query = 'SELECT AccountId__c,TeamMemberRole__c,UserId__c,UserId__r.email FROM Account_Team__c';
            query = query+' WHERE AccountId__c =\''+brf.Account__c+'\' and (TeamMemberRole__c = \'Underwriter\')';           
            system.debug('----query 102---->'+query);
            list<Account_Team__c> accteamlst = Database.query(query);
            
            for(Account_Team__c acteam:accteamlst){
                 toAddresses.add(acteam.UserId__r.email);
                
            } 
        }
        //T28 changes Ends
        //
        if(grpBCBClst.size()>0){
           List<GroupMember> gmList = [SELECT Id, Group.Name, UserOrGroupId FROM GroupMember
                                        WHERE Group.Name IN :grpBCBClst]; 
            System.debug('gmList2.size(): ' + gmList.size());
            List<String> usrIdList = new List<String>();
            for(GroupMember gm : gmList)
            {
                usrIdList.add(gm.UserOrGroupId);
            }
            
            // Get the email addresses of the group members.
            List<User> usrList = [SELECT email FROM User WHERE ID IN :usrIdList];
            System.debug('usrList2.size(): ' + usrList.size());
            for(User usr : usrList)
            {
                toAddresses.add(usr.email);
                System.debug('email: ' + usr.email);
            } 
        }
        //T27 changes End
        
        if(grpListNoBCM.size()>0){
            List<GroupMember> gmList = [SELECT Id, Group.Name, UserOrGroupId FROM GroupMember
                                        WHERE Group.Name IN :grpListNoBCM]; // T10
            System.debug('gmList.size(): ' + gmList.size());
            List<String> usrIdList = new List<String>();
            for(GroupMember gm : gmList)
            {
                usrIdList.add(gm.UserOrGroupId);
            }
            
            // Get the email addresses of the group members.
            List<User> usrList = [SELECT email FROM User WHERE ID IN :usrIdList];
            System.debug('usrList.size(): ' + usrList.size());
            for(User usr : usrList)
            {
                toAddresses.add(usr.email);
                System.debug('email: ' + usr.email);
            }
        }
        
        // T10 begin
        // If BCM was in the group list then add their department email
        // address to the list.
        if(bcmGroupFoundFlag)
        {
            AIA_Workflow_Emails__c workFlowEmails = AIA_Workflow_Emails__c.getInstance();
            System.debug('BCM Email: ' + workFlowEmails.ARC_Approval_Request_BCM_Email__c);
            toAddresses.add(workFlowEmails.ARC_Approval_Request_BCM_Email__c);
        }
        // T10 end

        //t21 start
        if(UWBCNCFoundFlag)
        {
            List<string> accteamset=fetchAccountteammembers(brfrecId);
            shareRecordstoUWBCNC();
            toAddresses.addAll(accteamset);
        }     
        //t21 End
        if(toAddresses.size() == 0) // T08
        {
            System.debug('Thowing empty address list exception');
            throw new ProcessingException('ERROR no group member email addresses were found'); // T08
        }
        
        return toAddresses;
    }       
     
     @TestVisible // T21 start
    private List<String> getGroupMemberEmailAddressesforNonStandard(List<String> grpList)
    {
        List<String> toAddresses  = new List<String>();
           List<string> accteamset=fetchAccountteammembers(brfrecId);
            shareRecordstoUWBCNC();
            toAddresses.addAll(accteamset);
            
        //t21 End
        if(toAddresses.size() == 0) // T08
        {
            System.debug('Thowing empty address list exception');
            throw new ProcessingException('ERROR no group member email addresses were found'); // T08
        }
        
        return toAddresses;
    } 
    //T21 end
    
    //T21 start
     public List<string> fetchAccountteammembers(id brfrecId){
        List<string> teamuemail = new List<string>();
            Benfit_Request_Form__c brf = [select id, Account__c from Benfit_Request_Form__c where id =:brfrecId ];
            /*T02 - Start*/
            String myValue = 'My Value';
         	//T28 ChnagesStarts
            /*String query = 'SELECT AccountId,TeamMemberRole,Title,UserId,User.email FROM AccountTeamMember';
            query = query+' WHERE AccountId =\''+brf.Account__c+'\' and (TeamMemberRole = \'Underwriter\'or TeamMemberRole = \'NASCO Benefit Coder\' or TeamMemberRole = \'BeneFact Coder\' or TeamMemberRole = \'Benefit Tester\' or TeamMemberRole= \'Benefit Coder\' or TeamMemberRole = \'Vision Analyst\')';//T25 - Added Benefit Tester and Benefit Coder //T26 - Added Vision Analyst*/
           String query = 'SELECT AccountId__c,TeamMemberRole__c,UserId__c,UserId__r.email FROM Account_Team__c';
            query = query+' WHERE AccountId__c =\''+brf.Account__c+'\' and (TeamMemberRole__c = \'Underwriter\'or TeamMemberRole__c = \'NASCO Benefit Coder\' or TeamMemberRole__c = \'BeneFact Coder\' or TeamMemberRole__c = \'Benefit Tester\' or TeamMemberRole__c= \'Benefit Coder\' or TeamMemberRole__c = \'Vision Analyst\')';
            system.debug('----query 102---->'+query);//T28
         //list<AccountTeamMember> accteamlst = Database.query(query);
            list<Account_Team__c> accteamlst = Database.query(query);
            /*list<AccountTeamMember> accteamlst = [SELECT AccountId,TeamMemberRole,Title,UserId 
                                                  FROM AccountTeamMember 
                                                  WHERE AccountId =: imp.Account__c 
                                                  and (TeamMemberRole = 'Implementation Manager' or TeamMemberRole='Account Manager' )];*/
            /*T02 - End*/
            //for(AccountTeamMember acteam:accteamlst){ T28 commented
            for(Account_Team__c acteam:accteamlst){    
                teamuemail.add(acteam.UserId__r.email);
                roleIdMap.put(acteam.TeamMemberRole__c, acteam.UserId__c);
                system.debug('roleidmap'+roleIdMap);
            }
        return teamuemail;
    }
    //T21 End
     
    // Used to throw an exception.
    public class ProcessingException extends Exception{ }
    
    // Helper method for sending emails.
    @TestVisible // T02
    private void sendEmail(String[] toAddresses, String subject, String body)
    {
        // First, reserve email capacity for the current Apex transaction to ensure
        // that we won't exceed our daily email limits when sending email after
        // the current transaction is committed.
        Messaging.reserveSingleEmailCapacity(2);

        // Now create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  

        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);

        // Specify the subject line for your email address.
        mail.setSubject(subject);

        //mail.setPlainTextBody(body);  Rajesh Commented this becuse rich text is not supported in this method
        mail.setHtmlBody(body); //T14

        // Send the email you have created.
        Messaging.SendEmailResult[] emlRslts = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    // Helper method to lock the BRF Record.
    @TestVisible // T02
    private void lockBrfRec(Benfit_Request_Form__c brfRec)
    {
        System.debug('Locking the BRF record');
    
        Approval.LockResult lr = Approval.lock(brfRec);   
    }
    
    // This method is called by the flow to unlock the record after all responses have been received.
    @InvocableMethod // T01, new method.
    public static void unlockBrf(List<ID> brfIds)
    {
        System.debug('At the top of unlockBrf');
        
        if(brfIds == NULL || brfIds.size() == 0)
        {
            System.debug('Thowing empty ID list exception');
            throw new ProcessingException('ERROR unlocking BRF record, no ID was passed to unlockBrf'); // T02
        }
        id brfid = brfIds[0];
        string querystring = QueryBase2.getSobjectAllFieldsSOQL('Benfit_Request_Form__c','id =:brfId');
        Benfit_Request_Form__c brf = database.query(querystring);
        list<Benfit_Request_Form__c> brflist = new list<Benfit_Request_Form__c>();
        brflist.add(brf);
        Map<id,Benfit_Request_Form__c> brfmap = new Map<id, Benfit_Request_Form__c>();
        brfmap.put(brf.id,brf);
        
        Approval.UnlockResult ulr = Approval.unlock(new Benfit_Request_Form__c(id = brfIds[0]));    
        
        System.debug('At the bottom of unlockBrf');     
        
        //method call to submit for next approval        
        AIA_BRFTriggerHelper.Send_For_SalesMgmt_or_ARC_or_UW_Approval(brflist,brfmap);     
    }       
 }