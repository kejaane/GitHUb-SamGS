<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AAA_Zip_Code_Notification_For_Sales_Users</fullName>
        <description>Zip Code Notification For Sales Users</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Zip_Code_Notification_Within_the_CareFirst_service_area</template>
    </alerts>
    <alerts>
        <fullName>AIA_ARC_Approved_Notification</fullName>
        <description>AIA ARC Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ARC_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BCM_ARC_Email</fullName>
        <description>AIA BCM ARC Email</description>
        <protected>false</protected>
        <recipients>
            <field>Custom_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ARC_Approval_Process</template>
    </alerts>
    <alerts>
        <fullName>AIA_BCM_ARC_Email1</fullName>
        <description>AIA BCM ARC Email</description>
        <protected>false</protected>
        <recipients>
            <field>Custom_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ARC_Approval_Process</template>
    </alerts>
    <alerts>
        <fullName>AIA_BCM_ARC_Email2</fullName>
        <description>AIA BCM ARC Email2</description>
        <protected>false</protected>
        <recipients>
            <field>Custom_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ARC_Approval_Process</template>
    </alerts>
    <alerts>
        <fullName>AIA_BRF_Implementation_Others_Notification</fullName>
        <description>AIA_BRF_Implementation_Others_Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Billing Tech</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Underwriter</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BRF_Implementation_Others_Notification1</template>
    </alerts>
    <alerts>
        <fullName>AIA_BRF_Implementation_PM_Notification</fullName>
        <description>AIA_BRF_Implementation_PM_Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BRF_Implementation_PM_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_Benefit_Request_Form_Submitted_to_Underwriting_Notification</fullName>
        <description>AIA Benefit Request Form Submitted to Underwriting Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Underwriter_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Benefit_Request_Form_Submitted_to_Underwriting</template>
    </alerts>
    <alerts>
        <fullName>AIA_Email_Notification_when_Formulary_is_Changed</fullName>
        <ccEmails>Rebecca.Hobin@CVSHealth.com</ccEmails>
        <description>AIA Email Notification when Formulary is Changed</description>
        <protected>false</protected>
        <recipients>
            <recipient>helen.schruefer@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_hen_formulary_changes_for_an_account</template>
    </alerts>
    <alerts>
        <fullName>AIA_Email_Notification_when_Maintenance_Choice_is_Changed</fullName>
        <ccEmails>Rebecca.Hobin@CVSHealth.com</ccEmails>
        <description>AIA Email Notification when Maintenance Choice is Changed</description>
        <protected>false</protected>
        <recipients>
            <recipient>helen.schruefer@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Send_Email_to_CVS_Maintenance_Choice_Changes</template>
    </alerts>
    <alerts>
        <fullName>AIA_Email_Notification_when_Maintenance_Choice_is_not_N_A_and_BRF_Sold</fullName>
        <ccEmails>Rebecca.Hobin@CVSHealth.com</ccEmails>
        <description>AIA Email Notification when Maintenance Choice is not &lt;&gt; 'N/A' and BRF &lt;&gt; Sold</description>
        <protected>false</protected>
        <recipients>
            <recipient>helen.schruefer@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Send_Email_to_CVS_Maintenance_Choice_N_A</template>
    </alerts>
    <alerts>
        <fullName>AIA_RX_Carve_Out_Approval</fullName>
        <description>AIA RX Carve-Out Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Owners_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_RX_Carve_Out_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_RX_Carve_Out_Rejection</fullName>
        <description>AIA RX Carve-Out Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Executive_Account_Team__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Manager_Account_Team__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_RX_Carve_Out_Rejection</template>
    </alerts>
    <alerts>
        <fullName>AIA_Rejection_Notification</fullName>
        <description>AIA Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>AIA_Admin_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ARC_Rejection_Process</template>
    </alerts>
    <alerts>
        <fullName>AIA_Send_Notification_to_Medical_Management</fullName>
        <ccEmails>chidananda.nagaraj@infosys.com.dev1aia</ccEmails>
        <description>AIA Send Notification to Medical Management</description>
        <protected>false</protected>
        <recipients>
            <recipient>AIA_Medical_Management_Area</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Send_Notification_to_Medical_Management</template>
    </alerts>
    <alerts>
        <fullName>AIA_Zip_Code_Notification_For_Outside_CareFirst_Service_Area_Denied</fullName>
        <description>Zip Code Notification For Outside CareFirst Service Area - Denied</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Zip_Code_Notification_Outside_CareFirst_Service_Area_Denied</template>
    </alerts>
    <alerts>
        <fullName>AIA_Zip_Code_Notification_For_Outside_CareFirst_Service_Area_Request_Cede</fullName>
        <description>Zip Code Notification For Outside CareFirst Service Area - Request Cede</description>
        <protected>false</protected>
        <recipients>
            <recipient>network.process@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Zip_Code_Notification_Outside_CareFirst_Service_Area_Request_Cede</template>
    </alerts>
    <alerts>
        <fullName>ARC_Senior_Managment_Notification</fullName>
        <description>ARC Senior Managment Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>ARC_Senior_Management</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/ARC_Senior_Management_Notification</template>
    </alerts>
    <alerts>
        <fullName>ARC_Senior_Managment_Notification_with_PRF</fullName>
        <description>ARC Senior Managment Notification with PRF</description>
        <protected>false</protected>
        <recipients>
            <recipient>ARC_Senior_Management</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/ARC_Senior_Management_Notification_with_PRF</template>
    </alerts>
    <alerts>
        <fullName>Arc_Notifiaction</fullName>
        <description>Arc Notifiaction</description>
        <protected>false</protected>
        <recipients>
            <recipient>helen.schruefer@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lucia.ward-alexander@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ARC_Approval_Process_Notification1</template>
    </alerts>
    <alerts>
        <fullName>BRF_Sold_Vision_products</fullName>
        <description>BRF Sold Vision products</description>
        <protected>false</protected>
        <recipients>
            <recipient>Pharmacy Operations</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Vision Analyst</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Sold_Vision_Products</template>
    </alerts>
    <alerts>
        <fullName>BRF_Sold_wAncillary_Products</fullName>
        <description>BRF Sold wAncillary Products</description>
        <protected>false</protected>
        <recipients>
            <recipient>jennifer.taylor@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>joree.watson@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>milton.curry@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sean.patterson@carefirst.com.lg</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Sold_with_Cafeteria_Ancillaries</template>
    </alerts>
    <alerts>
        <fullName>Benefit_Request_Review_MHP_Result_Notification</fullName>
        <description>Benefit Request: Review MHP Result Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>ed.butler@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shruti.sheth@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Notification_Send_to_Actuarial_Team</template>
    </alerts>
    <alerts>
        <fullName>Cede_Document_Request_New_Account_Notification</fullName>
        <description>Cede Document Request New Account Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>network.process@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/Cede_Document_Request_New_Account_Notification</template>
    </alerts>
    <alerts>
        <fullName>Cede_Document_Request_New_Account_Notification1</fullName>
        <description>Cede Document Request New Account Notification1</description>
        <protected>false</protected>
        <recipients>
            <recipient>network.process@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/Cede_Document_Request_New_Account_Notification1</template>
    </alerts>
    <alerts>
        <fullName>Cede_Document_Request_Renewal_Account_Notification</fullName>
        <description>Cede Document Request Renewal Account Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>network.process@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/Cede_Document_Request_Renewal_Account_Notification1</template>
    </alerts>
    <alerts>
        <fullName>Send_Stop_Loss_Email_Notification</fullName>
        <description>Send Stop Loss Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Stop_Loss_Notification_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Stop_Loss_Notification_Email_2__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Stop_Loss_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>Zip_Code_Verify</fullName>
        <description>Zip Code Verify</description>
        <protected>false</protected>
        <recipients>
            <recipient>network.process@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Zip_Code_Verification_for_BRF</template>
    </alerts>
    <fieldUpdates>
        <fullName>AIA_ARC_Approval_Date</fullName>
        <field>ARC_Approval_Date__c</field>
        <formula>Today()</formula>
        <name>AIA ARC Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_ARC_Approval_Skipped</fullName>
        <description>Updates ARC Approval Status field to Approved by committee if ARC Approval is skipped.</description>
        <field>ARC_Approval_Status__c</field>
        <literalValue>Approved by Committee</literalValue>
        <name>AIA ARC Approval Skipped</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_ARC_Approval_Status</fullName>
        <field>ARC_Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>AIA ARC Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_ARC_Approval_Status_Approved</fullName>
        <field>ARC_Approval_Status__c</field>
        <literalValue>Approved by Committee</literalValue>
        <name>AIA ARC Approval Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_ARC_Approval_Status_Rejected</fullName>
        <field>ARC_Approval_Status__c</field>
        <literalValue>Rejected by Committee</literalValue>
        <name>AIA ARC Approval Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_BCM_ARC_Update</fullName>
        <field>Custom_Email__c</field>
        <formula>"BCMARCApprovalRequests@carefirst.com"</formula>
        <name>AIA BCM ARC Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_BCM_ARC_Update1</fullName>
        <field>Custom_Email__c</field>
        <formula>"BCMARCApprovalRequests@carefirst.com"</formula>
        <name>AIA BCM ARC Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_BCM_ARC_Update2</fullName>
        <field>Custom_Email__c</field>
        <formula>"BCMARCApprovalRequests@carefirst.com"</formula>
        <name>AIA BCM ARC Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_BRF_Inactive_Date_Fields</fullName>
        <field>BRF_Inactive_Date_field__c</field>
        <formula>NOW()</formula>
        <name>AIA BRF Inactive Date Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_BRF_Inactive_Date_field</fullName>
        <field>BRF_Inactive_Date_field__c</field>
        <formula>NOW()</formula>
        <name>AIA BRF Inactive Date field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Identity_Protection_Mandate_ASO</fullName>
        <field>Identity_Protection_Mandate_ASO__c</field>
        <literalValue>No</literalValue>
        <name>AIA Identity Protection Mandate ASO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Jurisdiction_field_update_to_DC</fullName>
        <field>Jurisdiction__c</field>
        <literalValue>DC</literalValue>
        <name>AIA Jurisdiction field update to "DC"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Jurisdiction_field_update_to_MD</fullName>
        <field>Jurisdiction__c</field>
        <literalValue>MD</literalValue>
        <name>AIA Jurisdiction field update to "MD"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Jurisdiction_field_update_to_Other</fullName>
        <field>Jurisdiction__c</field>
        <literalValue>Other - Cede Required</literalValue>
        <name>AIA Jurisdiction field update to "Other"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Jurisdiction_field_update_to_VA</fullName>
        <field>Jurisdiction__c</field>
        <literalValue>VA</literalValue>
        <name>AIA Jurisdiction field update to "VA"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_SetInitialARCApprovalSubmissionDate</fullName>
        <field>ARC_Approval_Initial_Submission_Date__c</field>
        <formula>IF  (ISBLANK(ARC_Approval_Initial_Submission_Date__c), 
Today(),
ARC_Approval_Initial_Submission_Date__c)</formula>
        <name>AIA-SetInitialARCApprovalSubmissionDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Stop_Loss_email_field_update1</fullName>
        <field>Stop_Loss_Notification_Email_1__c</field>
        <formula>$Setup.AIA_Workflow_Emails__c.Stop_Loss_Notification_Email_1__c</formula>
        <name>AIA Stop Loss email field update1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Stop_Loss_email_field_update2</fullName>
        <field>Stop_Loss_Notification_Email_2__c</field>
        <formula>$Setup.AIA_Workflow_Emails__c.Stop_Loss_Notification_Email_2__c</formula>
        <name>AIA Stop Loss email field update2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Verified_By</fullName>
        <field>Verified_By__c</field>
        <formula>$User.FirstName + " " +$User.LastName</formula>
        <name>Update Verified By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Verified_Date</fullName>
        <field>Verification_Date__c</field>
        <formula>Today()</formula>
        <name>Update Verified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Prior_Value_For_Fromulary</fullName>
        <field>Email_Formulary__c</field>
        <formula>TEXT(PRIORVALUE( Formulary__c ))</formula>
        <name>Capture Prior Value For Fromulary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Prior_Value_For_Maintenance</fullName>
        <field>Email_Maintenance_Choice__c</field>
        <formula>TEXT(PRIORVALUE(  Maintenance_Choice__c  ))</formula>
        <name>Capture Prior Value For Maintenance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Request_Cede_Document_Checkbox</fullName>
        <description>Resets the Request Cede Document Checkbox after the User has checked this and once the email sent.</description>
        <field>Request_Cede_Document__c</field>
        <literalValue>0</literalValue>
        <name>Reset Request Cede Document Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Submit_for_ARC_Approval_Flag</fullName>
        <field>Submit_to_ARC_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Reset Submit for ARC Approval Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Submit_for_ARC_Approval_Flag1</fullName>
        <field>Submit_to_ARC_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Reset Submit for ARC Approval Flag1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Mang_App_Stat_Blank</fullName>
        <field>Sales__c</field>
        <name>Sales Mang App Stat Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ARC_Approval_Status_To_Pending</fullName>
        <field>ARC_Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Set ARC Approval Status To Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ARC_Approval_Status_to_Approved</fullName>
        <field>ARC_Approval_Status__c</field>
        <literalValue>Approved by Committee</literalValue>
        <name>Set ARC Approval Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ARC_Approval_Status_to_Blank</fullName>
        <field>ARC_Approval_Status__c</field>
        <name>Set ARC Approval Status to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Send_to_Actuarial_Team_to_False</fullName>
        <field>Send_to_Actuarial_Team__c</field>
        <literalValue>0</literalValue>
        <name>Set Send to Actuarial Team to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Submit_for_ARC_Approval_Flag</fullName>
        <field>Submit_to_ARC_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Set Submit for ARC Approval Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_With_BRF_Id</fullName>
        <field>Recent_Sold_BRF_ID__c</field>
        <formula>Id</formula>
        <name>Update Account With BRF Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Escalate_to_Senior_Management</fullName>
        <field>Escalated_to_Senior_Management__c</field>
        <literalValue>1</literalValue>
        <name>Update Escalate to Senior Management</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA ARC Senior Management Notification</fullName>
        <actions>
            <name>ARC_Senior_Managment_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Escalate_to_Senior_Management</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Escalated_to_Senior_Management__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.PRF__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA ARC Senior Management Notification with PRF</fullName>
        <actions>
            <name>ARC_Senior_Managment_Notification_with_PRF</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Escalate_to_Senior_Management</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Escalated_to_Senior_Management__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.PRF__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA BRF Ancillary Products</fullName>
        <actions>
            <name>BRF_Sold_wAncillary_Products</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Sold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Enrollment_Type__c</field>
            <operation>equals</operation>
            <value>Non Parallel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Count_of_Dug_With_Cafeteria__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Count_of_Vision_With_Cafeteria__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA BRF InactiveDate field</fullName>
        <actions>
            <name>AIA_BRF_Inactive_Date_Fields</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_BRF_Inactive_Date_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Inactive</value>
        </criteriaItems>
        <description>This workflow updates the BRF inactive Date fields when the BRF status is Inactive</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA BRF Vision%2FDrug Products</fullName>
        <actions>
            <name>BRF_Sold_Vision_products</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Sold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Count_Vision_Products__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Count_Drug_Proposed_Products__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Identity Protection Mandate ASO</fullName>
        <actions>
            <name>AIA_Identity_Protection_Mandate_ASO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Identity_Protection_Mandate_ASO__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Jurisdiction field update on BRF to %22DC%22</fullName>
        <actions>
            <name>AIA_Jurisdiction_field_update_to_DC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Jurisdiction field on BRF should be updated to "DC" if the Jurisdiction of its account is "DC"</description>
        <formula>TEXT(Opportunity__r.Account.Jurisdiction__c) = 'DC'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Jurisdiction field update on BRF to %22MD%22</fullName>
        <actions>
            <name>AIA_Jurisdiction_field_update_to_MD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Jurisdiction field on BRF should be updated to "MD" if the Jurisdiction of its account is "MD"</description>
        <formula>TEXT(Opportunity__r.Account.Jurisdiction__c) = 'MD'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Jurisdiction field update on BRF to %22Other%22</fullName>
        <actions>
            <name>AIA_Jurisdiction_field_update_to_Other</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Jurisdiction field on BRF should be updated to "VA" if the Jurisdiction of its account is "Other"</description>
        <formula>TEXT(Opportunity__r.Account.Jurisdiction__c) = 'Other'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Jurisdiction field update on BRF to %22VA%22</fullName>
        <actions>
            <name>AIA_Jurisdiction_field_update_to_VA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Jurisdiction field on BRF should be updated to "VA" if the Jurisdiction of its account is "VA"</description>
        <formula>TEXT(Opportunity__r.Account.Jurisdiction__c) = 'VA'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA RX Carve-Out Approval</fullName>
        <actions>
            <name>AIA_RX_Carve_Out_Approval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Carve_Out_RX_Approval__c</field>
            <operation>equals</operation>
            <value>Pending Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.ARC_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA RX Carve-Out Rejection</fullName>
        <actions>
            <name>AIA_RX_Carve_Out_Rejection</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Carve_Out_RX_Approval__c</field>
            <operation>equals</operation>
            <value>Not Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Reset ARC Approval Status</fullName>
        <actions>
            <name>Set_ARC_Approval_Status_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If ARC Approval Skipped is changed from false to true then reset ARC Approval Status</description>
        <formula>ISCHANGED(ARC_Approval_Skipped__c) &amp;&amp;  PRIORVALUE(ARC_Approval_Skipped__c)=TRUE &amp;&amp;  ISPICKVAL(ARC_Approval_Status__c,'Approved by Committee')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Sales Management Approval Blank</fullName>
        <actions>
            <name>Sales_Mang_App_Stat_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>Off-Cycle - Administrative Change</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>Off-Cycle - Benefit Change</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>Off-Cycle - Administrative and Benefit Change</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Send Email to CVS_Formulary Changes</fullName>
        <actions>
            <name>AIA_Email_Notification_when_Formulary_is_Changed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Capture_Prior_Value_For_Fromulary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>An email is send when the formulary value changes</description>
        <formula>AND(TEXT( Status__c ) = 'Sold',ISCHANGED(  Formulary__c  ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Send Email to CVS_Maintenance Choice Changes</fullName>
        <actions>
            <name>AIA_Email_Notification_when_Maintenance_Choice_is_Changed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Capture_Prior_Value_For_Maintenance</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>An email is sent to users when the Maintenance Choice vlaues changes</description>
        <formula>AND(TEXT( Status__c ) = 'Sold',ISCHANGED( Maintenance_Choice__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Send Notification to Medical Management</fullName>
        <actions>
            <name>AIA_Send_Notification_to_Medical_Management</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Sold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>Prospect/New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Contract_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>2500</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Send Stoploss Notification</fullName>
        <actions>
            <name>Send_Stop_Loss_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Funding_Arrangements__c</field>
            <operation>equals</operation>
            <value>ASO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Stop_Loss__c</field>
            <operation>equals</operation>
            <value>Preferred - HM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Stop_Loss__c</field>
            <operation>equals</operation>
            <value>Preferred - Symetra</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Submit_to_Underwriting__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>AIA Story B-03247</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Stop Loss email field update</fullName>
        <actions>
            <name>AIA_Stop_Loss_email_field_update1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Stop_Loss_email_field_update2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Stop_Loss_Notification_Email_1__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Stop_Loss_Notification_Email_2__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Submit Benefit Request Form to Underwriting</fullName>
        <actions>
            <name>AIA_Benefit_Request_Form_Submitted_to_Underwriting_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Submit_to_Underwriting__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Zip Code Verification Outside CareFirst Service Area - Denied</fullName>
        <actions>
            <name>AIA_Zip_Code_Notification_For_Outside_CareFirst_Service_Area_Denied</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AIA_Update_Verified_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Update_Verified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND((ISPICKVAL(Zip_Code_Validation__c,"Outside CareFirst Service Area - Denied")),ISCHANGED(Zip_Code_Validation__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Zip Code Verification Outside CareFirst Service Area - Request Cede</fullName>
        <actions>
            <name>AIA_Zip_Code_Notification_For_Outside_CareFirst_Service_Area_Request_Cede</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AIA_Update_Verified_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Update_Verified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND((ISPICKVAL(Zip_Code_Validation__c,"Outside CareFirst Service Area - Request Cede")),ISCHANGED(Zip_Code_Validation__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Zip Code Verification Within the CareFirst Service Area</fullName>
        <actions>
            <name>AAA_Zip_Code_Notification_For_Sales_Users</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AIA_Update_Verified_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Update_Verified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND((ISPICKVAL(Zip_Code_Validation__c,"Within the CareFirst service area")),ISCHANGED(Zip_Code_Validation__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA_BRF_Recent_Sold</fullName>
        <actions>
            <name>Update_Account_With_BRF_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Sold</value>
        </criteriaItems>
        <description>This workflow rule kicks off when Benefit Request Form Status is set to sold . Then BRF record id is updated on Recent_Sold_BRF_ID__c of Account.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA_BRF_Sold</fullName>
        <actions>
            <name>AIA_BRF_Implementation_Others_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AIA_BRF_Implementation_PM_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Sold</value>
        </criteriaItems>
        <description>Sends e-mail to Implementation PM and other people when BRF is marked as Sold.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA_Benefit_Request_Review_MHP_Result</fullName>
        <actions>
            <name>Benefit_Request_Review_MHP_Result_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Send_to_Actuarial_Team_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Send_to_Actuarial_Team__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.zzzMHP_Required__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA_Cede_Document_New_Request</fullName>
        <actions>
            <name>Cede_Document_Request_New_Account_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_Request_Cede_Document_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Opportunity_Type__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Request_Cede_Document__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Jurisdiction__c</field>
            <operation>equals</operation>
            <value>VA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.X200_Account__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA_Cede_Document_New_Request1</fullName>
        <actions>
            <name>Cede_Document_Request_New_Account_Notification1</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_Request_Cede_Document_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Opportunity_Type__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Request_Cede_Document__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Jurisdiction__c</field>
            <operation>notEqual</operation>
            <value>DC,MD,VA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.X200_Account__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA_Cede_Document_Renewal_Request</fullName>
        <actions>
            <name>Cede_Document_Request_Renewal_Account_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Opportunity_Type__c</field>
            <operation>equals</operation>
            <value>Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Request_Cede_Document__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.X200_Account__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA_Send Email to CVS_Maintenance Choice is Not Equal to NA</fullName>
        <actions>
            <name>AIA_Email_Notification_when_Maintenance_Choice_is_not_N_A_and_BRF_Sold</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Sold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Maintenance_Choice__c</field>
            <operation>notEqual</operation>
            <value>N/A</value>
        </criteriaItems>
        <description>An email notification is send only when the BRF is sold and Maintenance Choice is not  'N/A'</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA ARC Approval Skipped</fullName>
        <actions>
            <name>AIA_ARC_Approval_Skipped</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.ARC_Approval_Skipped__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updates the ARC Approval Status field to Approved by Committee if the ARC Approval process is skipped.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
