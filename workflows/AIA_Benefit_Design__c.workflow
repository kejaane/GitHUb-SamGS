<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AIA_BD_Approval_remainder_notification_for_Anciallary_Tech</fullName>
        <description>AIA BD Approval remainder notification for Anciallary Tech</description>
        <protected>false</protected>
        <recipients>
            <recipient>Ancillary Analyst</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Remainder_Notification_for_BD_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Approval_remainder_notification_for_Benefact_Coder</fullName>
        <description>AIA BD Approval remainder notification for Benefact Coder</description>
        <protected>false</protected>
        <recipients>
            <field>AIA_Approver_Benefact_Coder__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Remainder_Notification_for_BD_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Approval_remainder_notification_for_Benefit_Coder</fullName>
        <description>AIA BD Approval remainder notification for Benefit Coder</description>
        <protected>false</protected>
        <recipients>
            <field>AIA_Approver_Benefit_Coder__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Remainder_Notification_for_BD_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Approval_remainder_notification_for_Benefit_Tester</fullName>
        <description>AIA BD Approval remainder notification for Benefit Tester</description>
        <protected>false</protected>
        <recipients>
            <field>AIA_Approver_Benefit_Tester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Remainder_Notification_for_BD_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Approval_remainder_notification_for_Contract_Tech</fullName>
        <description>AIA BD Approval remainder notification for Contract Tech</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Contract_Tech__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Remainder_Notification_for_BD_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Approval_remainder_notification_for_MAST_Tech</fullName>
        <description>AIA BD Approval remainder notification for MAST Tech</description>
        <protected>false</protected>
        <recipients>
            <field>AIA_Approver_MAST_Tech__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Remainder_Notification_for_BD_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Approval_remainder_notification_for_NASCO_Benefit_Coder</fullName>
        <description>AIA BD Approval remainder notification for NASCO Benefit Coder</description>
        <protected>false</protected>
        <recipients>
            <recipient>NASCO Benefit Coder</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Remainder_Notification_for_BD_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Approval_remainder_notification_for_Pharmacy_Operations</fullName>
        <description>AIA BD Approval remainder notification for Pharmacy Operations</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Pharmacy_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Remainder_Notification_for_BD_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Approval_remainder_notification_for_QA_Auditor</fullName>
        <description>AIA BD Approval remainder notification for QA Auditor</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_QA_Auditor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Remainder_Notification_for_BD_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Approval_remainder_notification_for_Vision_Analyst</fullName>
        <description>AIA BD Approval remainder notification for Vision Analyst</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Vision_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Remainder_Notification_for_BD_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Benefact_Coder_changed_Approver_Notification</fullName>
        <description>AIA BD Benefact Coder changed Approver Notification</description>
        <protected>false</protected>
        <recipients>
            <field>AIA_Approver_Benefact_Coder__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Initial_Approver_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Benefit_Coder_changed_Approver_Notification</fullName>
        <description>AIA BD Benefit Coder changed Approver Notification</description>
        <protected>false</protected>
        <recipients>
            <field>AIA_Approver_Benefit_Coder__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Initial_Approver_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Benefit_Tester_changed_Approver_Notification</fullName>
        <description>AIA BD Benefit Tester changed Approver Notification</description>
        <protected>false</protected>
        <recipients>
            <field>AIA_Approver_Benefit_Tester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Initial_Approver_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Contract_Tech_changed_Approver_Notification</fullName>
        <description>AIA BD Contract Tech changed Approver Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Contract_Tech__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Initial_Approver_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Final_Approver_Notification</fullName>
        <description>AIA BD Approval Request Notification</description>
        <protected>false</protected>
        <recipients>
            <field>QA_Auditor__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Final_Approver_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Initial_Approver_Notification</fullName>
        <description>AIA BD Initial Approver Notification</description>
        <protected>false</protected>
        <recipients>
            <field>AIA_Approver_Benefact_Coder__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AIA_Approver_Benefit_Coder__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AIA_Approver_Benefit_Tester__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AIA_Approver_MAST_Tech__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_Contract_Tech__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_Pharmacy_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_QA_Auditor__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_Vision_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Initial_Approver_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_MAST_Tech_changed_Approver_Notification</fullName>
        <description>AIA BD MAST Tech changed Approver Notification</description>
        <protected>false</protected>
        <recipients>
            <field>AIA_Approver_MAST_Tech__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Initial_Approver_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_NASCO_Benefit_Coder_changed_Approver_Notification</fullName>
        <description>AIA BD NASCO Benefit Coder changed Approver Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Benefit_Coder__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Initial_Approver_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_PO_changed_Approver_Notification</fullName>
        <description>AIA BD PO changed Approver Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Pharmacy_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Initial_Approver_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_QA_Auditor_changed_Approver_Notification</fullName>
        <description>AIA BD QA Auditor changed Approver Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_QA_Auditor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Initial_Approver_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_VA_changed_Approver_Notification</fullName>
        <description>AIA BD VA changed Approver Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Vision_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Initial_Approver_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_changed_Approver_Notification</fullName>
        <description>AIA BD AA changed Approver Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Ancillary_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Initial_Approver_Notification</template>
    </alerts>
    <alerts>
        <fullName>Benefit_Design_Approval_Requested</fullName>
        <description>Benefit Design Approval Requested</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Benefit_Design_Approval_Requested</template>
    </alerts>
    <alerts>
        <fullName>Benefit_Design_Approved_Email</fullName>
        <description>Benefit Design Approved Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>AIA_BD_Approved_Notification_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Final_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>Benefit_Design_Rejected_Email</fullName>
        <description>Benefit Design Rejected Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Mail_Account_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Benefit_Design_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>AIAReset_QA_Auditor_Initial_Notification</fullName>
        <description>Resets the QA Auditor Initial Notification field.</description>
        <field>QA_Auditor_Initial_Notification__c</field>
        <literalValue>0</literalValue>
        <name>AIAReset QA Auditor Initial Notification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Ancillary_Tech_Approval_Start_Date</fullName>
        <description>Updates the Ancillary Tech Approval Start Date field by current date</description>
        <field>Ancillary_Tech_Approval_Start_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA Ancillary Tech Approval Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Ancillary_Tech_Response_Date</fullName>
        <description>AIA Ancillary Tech Response Date</description>
        <field>Ancillary_Tech_Response_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA Ancillary Tech Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Approval_Status_Benefact_code</fullName>
        <description>If the Benefact coder is blank then the status for Benefact Code will be N/A</description>
        <field>AIA_Approval_Status_Benefact_Coder__c</field>
        <literalValue>N/A</literalValue>
        <name>AIA Approval Status - Benefact code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Approval_Status_Benefit_Coder</fullName>
        <field>AIA_Approval_Status_Benefit_Coder__c</field>
        <literalValue>N/A</literalValue>
        <name>AIA Approval Status -Benefit Coder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Approval_Status_Benefit_Tester</fullName>
        <description>If the Benefit Tester is blank then the approval status for the Benefit Tester will be N/A</description>
        <field>AIA_Approval_Status_Benefit_Tester__c</field>
        <literalValue>N/A</literalValue>
        <name>AIA Approval Status -Benefit Tester</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Approval_Status_Contract_tech</fullName>
        <description>If the Contract Tech is Blank then the approval status for Contract Tech will be N/A</description>
        <field>AIA_Approval_Status_Contract_Tech__c</field>
        <literalValue>N/A</literalValue>
        <name>AIA Approval Status - Contract tech</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Approval_Status_MAST_Tech</fullName>
        <description>If the MAST Tech coder is blank then the approval process for MAST tech will be N/A</description>
        <field>Approval_Status_MAST_Tech__c</field>
        <literalValue>N/A</literalValue>
        <name>AIA Approval Status - MAST Tech</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Approval_Status_NASCO_Benefit_code</fullName>
        <description>If the NASCO Benefit Coder is blank then the approval status for the Benefact Coder will be N/A</description>
        <field>AIA_Approval_Status_NASCO_Benefit_Coder__c</field>
        <literalValue>N/A</literalValue>
        <name>AIA Approval Status -NASCO Benefit code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Approval_Status_Pharmacy_Management</fullName>
        <field>AIA_Approval_Status_Pharmacy_Management__c</field>
        <literalValue>N/A</literalValue>
        <name>AIA Approval Status -Pharmacy Management</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Approver_Notes_Update</fullName>
        <field>AIA_Approver_Notes__c</field>
        <formula>$User.FirstName + ' ' + $User.LastName + ' ' + 'added a comment on' + ' ' + TEXT( Today() )+': '+ BR() +  AIA_Approver_Comments__c  + BR()
+ AIA_Approver_Notes__c  + BR()</formula>
        <name>Approver Notes Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_BD_QA_Auditor_Notification</fullName>
        <field>QA_Auditor_Initial_Notification__c</field>
        <literalValue>1</literalValue>
        <name>AIA BD QA Auditor Notification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Benefact_Coder_Approval_Start_Date</fullName>
        <description>Updates the Benefact Coder Approval Start Date field on Benefit Design with current date.</description>
        <field>Benefact_Coder_Approval_Start_Date__c</field>
        <formula>Today()</formula>
        <name>AIA Benefact Coder Approval Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Benefact_Coder_Response_Date</fullName>
        <description>AIA Benefact Coder Response Date set to current date</description>
        <field>Benefact_Coder_Response_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA Benefact Coder Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Benefit_Coder_Apvl_Start_Date</fullName>
        <field>AIA_Benefit_Coder_Approval_Start_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA Benefit Coder Apvl Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Benefit_Coder_Response_Date</fullName>
        <field>AIA_Benefit_Coder_Response_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA Benefit Coder Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Benefit_Tester_Apvl_Start_Date</fullName>
        <field>AIA_Benefit_Tester_Approval_Start_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA Benefit Tester Apvl Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Benefit_Tester_Response_Date</fullName>
        <description>AIA Benefit Tester Response Date set to current date</description>
        <field>AIA_Benefit_Tester_Response_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA Benefit Tester Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Clear_Approver_Comments</fullName>
        <field>AIA_Approver_Comments__c</field>
        <name>Clear Approver Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Contract_Tech_Approval_Start_Date</fullName>
        <description>Updates the Contract Tech Approval Start Date to current date</description>
        <field>Contract_Tech_Approval_Start_Date__c</field>
        <formula>Today()</formula>
        <name>AIA Contract Tech Approval Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Contract_Tech_Response_Date</fullName>
        <description>AIA Contract Tech Response Date sets to current date</description>
        <field>Contract_Tech_Response_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA Contract Tech Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_MAST_Tech_Approval_Start_Date</fullName>
        <description>Updates the MAST Tech Approval Start Date field on Benefit Design with current date.</description>
        <field>MAST_Tech_Approval_Start_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA MAST Tech Approval Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_MAST_Tech_Response_Date</fullName>
        <description>AIA MAST Tech Response Date set to current date</description>
        <field>MAST_Tech_Response_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA MAST Tech Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_NASCO_Benefit_Coder_Apvl_Start_Date</fullName>
        <description>Updates the NASCO Benefit Coder Approval Start Date to current date</description>
        <field>NASCO_Benefit_Coder_Approval_Start_Date__c</field>
        <formula>Today()</formula>
        <name>AIA NASCO Benefit Coder Apvl Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_NASCO_Benefit_Coder_Response_Date</fullName>
        <description>AIA NASCO Benefit Coder Response Date set to current date</description>
        <field>NASCO_Benefit_Coder_Response_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA NASCO Benefit Coder Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Pharmacy_Operation_Approval_Start_Da</fullName>
        <description>Updates the Pharmacy Operation Approval Start Date field by current date</description>
        <field>Pharmacy_Operations_Approval_Start_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA Pharmacy Operation Approval Start Da</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Pharmacy_Operation_Response_Date</fullName>
        <field>Pharmacy_Operations_Response_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA Pharmacy Operation Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_QA_Auditor_Final_Notification</fullName>
        <description>AIA QA Auditor Final Notification</description>
        <field>QA_Auditor_Final_Notification__c</field>
        <literalValue>1</literalValue>
        <name>AIA QA Auditor Final Notification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_QA_Auditor_final_approval_field</fullName>
        <field>QA_Auditor_Final_Notification__c</field>
        <literalValue>1</literalValue>
        <name>AIA QA Auditor final approval field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Renewal_Effective_Date_Drawloop_Ch2</fullName>
        <field>Renewal_Effective_Date_Drawloop_Checker__c</field>
        <literalValue>0</literalValue>
        <name>AIA Renewal Effective Date Drawloop Chec</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Renewal_Effective_Date_Drawloop_Chec</fullName>
        <field>Renewal_Effective_Date_Drawloop_Checker__c</field>
        <literalValue>1</literalValue>
        <name>AIA Renewal Effective Date Drawloop Chec</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Reset_AS_2</fullName>
        <field>AIA_Approval_Status_Benefact_Coder__c</field>
        <name>Reset AS 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Reset_AS_3</fullName>
        <field>AIA_Approval_Status_Contract_Tech__c</field>
        <name>Reset AS 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Reset_AS_4</fullName>
        <field>Approval_Status_MAST_Tech__c</field>
        <name>Reset AS 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Reset_AS_5</fullName>
        <field>AIA_Approval_Status_Benefit_Tester__c</field>
        <name>Reset AS 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Reset_Ancillary_Tech_Response_Date</fullName>
        <description>AIA Resets Ancillary Tech Response Date</description>
        <field>Ancillary_Tech_Response_Date__c</field>
        <name>AIA Reset Ancillary Tech Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Reset_Benefact_Coder_Response_Date</fullName>
        <description>AIA Resets Benefact Coder Response Date</description>
        <field>Benefact_Coder_Response_Date__c</field>
        <name>AIA Reset Benefact Coder Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Reset_Benefit_Tester_Response_Date</fullName>
        <field>AIA_Benefit_Tester_Response_Date__c</field>
        <name>AIA Reset_Benefit Tester Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Reset_Contract_Tech_Response_Date</fullName>
        <description>AIA Resets Contract Tech Response Date</description>
        <field>Contract_Tech_Response_Date__c</field>
        <name>AIA Reset Contract Tech Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Reset_MAST_Tech_Response_Date</fullName>
        <description>AIA Resets MAST Tech Response Date</description>
        <field>MAST_Tech_Response_Date__c</field>
        <name>AIA Reset MAST Tech Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Reset_NASCO_Benefit_Coder_Response_D</fullName>
        <description>AIA Resets NASCO Benefit Coder Response Date</description>
        <field>NASCO_Benefit_Coder_Response_Date__c</field>
        <name>AIA Reset NASCO Benefit Coder Response D</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Reset_QA_Auditor_Final_Notification</fullName>
        <description>Resets the QA Auditor Final Notification field.</description>
        <field>QA_Auditor_Final_Notification__c</field>
        <literalValue>0</literalValue>
        <name>AIA Reset QA Auditor Final Notification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Ancillary_Tech_Approval_Stat</fullName>
        <description>If the Ancillary tech is blank then the approval status will be N/A</description>
        <field>Approval_Status_Analyst__c</field>
        <literalValue>N/A</literalValue>
        <name>AIA Update Ancillary Tech Approval Stat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Approver_notified</fullName>
        <field>AIA_Approvers_Notified__c</field>
        <literalValue>1</literalValue>
        <name>Update Approver notified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Approver_notified_to_False</fullName>
        <field>AIA_Approvers_Notified__c</field>
        <literalValue>0</literalValue>
        <name>Update Approver notified to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_BD_Approval_Date</fullName>
        <description>3535</description>
        <field>BD_Approval_Date__c</field>
        <formula>Today()</formula>
        <name>AIA Update BD Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_BD_Status_to_Rejectec</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update BD Status to Rejectec</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Pharmacy_Approval_Status</fullName>
        <description>If the Pharmacy operation is blank then the approval status will be N/A</description>
        <field>Approval_Status_Pharmacy_Operations__c</field>
        <literalValue>N/A</literalValue>
        <name>AIA Update Pharmacy Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Vision_Analyst_Approval_Statu</fullName>
        <description>If the Vision Analyst is blank then the approval status will be N/A</description>
        <field>Approval_Status_Vision_Analyst__c</field>
        <literalValue>N/A</literalValue>
        <name>AIA Update Vision Analyst Approval Statu</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Vision_Analyst_Approval_Start_Date</fullName>
        <description>Updates the Vision Analyst Approval Start Date field by current date</description>
        <field>Vision_Analyst_Approval_Start_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA Vision Analyst Approval Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Vision_Analyst_Response_Date</fullName>
        <field>Vision_Analyst_Response_Date__c</field>
        <formula>TODAY()</formula>
        <name>AIA Vision Analyst Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Benefit_Design_ApprovalStatus_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Benefit Design ApprovalStatus - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Benefit_Design_Status_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Benefit Design Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Approval_Status</fullName>
        <field>Approval_Status_Analyst__c</field>
        <name>Clear Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Approval_Status_Pharmacy</fullName>
        <field>Approval_Status_Pharmacy_Operations__c</field>
        <name>Clear Approval Status Pharmacy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Approval_Status_Vision</fullName>
        <field>Approval_Status_Vision_Analyst__c</field>
        <name>Clear Approval Status Vision</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_AS_6</fullName>
        <field>AIA_Approval_Status_Benefit_Coder__c</field>
        <name>Reset AS 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Ancillary_Tech_Approval_Start_Date</fullName>
        <description>Resets the Ancillary Tech Approval Start Date</description>
        <field>Ancillary_Tech_Approval_Start_Date__c</field>
        <name>Reset Ancillary Tech Approval Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Benefact_Coder_Approval_Start_Date</fullName>
        <description>Resets Benefact Coder Approval Start Date</description>
        <field>Benefact_Coder_Approval_Start_Date__c</field>
        <name>Reset Benefact Coder Approval Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Benefit_Tester_Approval_Start_date</fullName>
        <field>AIA_Benefit_Tester_Approval_Start_Date__c</field>
        <name>Reset Benefit Tester Approval Start date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Contract_Tech_Approval_Start_Date</fullName>
        <description>Resets Contract Tech Approval Start Date</description>
        <field>Contract_Tech_Approval_Start_Date__c</field>
        <name>Reset Contract Tech Approval Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_MAST_Tech_Approval_Start_Date</fullName>
        <description>Resets MAST Tech Approval Start Date</description>
        <field>MAST_Tech_Approval_Start_Date__c</field>
        <name>Reset MAST Tech Approval Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_NASCO_Benefit_Coder_Approval_Start</fullName>
        <description>Resets NASCO Benefit Coder Approval Start Date</description>
        <field>NASCO_Benefit_Coder_Approval_Start_Date__c</field>
        <name>Reset NASCO Benefit Coder Approval Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Initiating Benefit Design Restart</literalValue>
        <name>Set Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Waiting for Benefit Design Meeting Approval</literalValue>
        <name>Update Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_QA_Audit_field</fullName>
        <description>Update the field with a group email address as " NAEGS.Audit@carefirst.com"</description>
        <field>QA_Auditor__c</field>
        <formula>$Setup.AIA_Workflow_Emails__c.QA_Auditor__c</formula>
        <name>Update QA Audit field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA Approval Status - Benefact code</fullName>
        <actions>
            <name>AIA_Approval_Status_Benefact_code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approver_Benefact_Coder__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the Approver for Benefact Coder is Blank, approval status for Benefact Code should be N/A</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Approval Status - Benefit Coder</fullName>
        <actions>
            <name>AIA_Approval_Status_Benefit_Coder</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approver_Benefit_Coder__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the Approver for Benefit coder is Blank, approval status for Benefit Coder should be N/A</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Approval Status - Benefit Tester</fullName>
        <actions>
            <name>AIA_Approval_Status_Benefit_Tester</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approver_Benefit_Tester__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the Approver for Benefit tester is Blank, approval status for Benefit Tester should be N/A</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Approval Status - Contract Tech</fullName>
        <actions>
            <name>AIA_Approval_Status_Contract_tech</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the Approver for Contract Tech is Blank, approval status for Contract Tech should be N/A</description>
        <formula>ISBLANK( Approver_Contract_Tech__c  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Approval Status - MAST Tech</fullName>
        <actions>
            <name>AIA_Approval_Status_MAST_Tech</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approver_MAST_Tech__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the Approver for MAST coder is Blank, approval status for MAST Code should be N/A</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Approval Status - Pharmacy Operation</fullName>
        <actions>
            <name>AIA_Update_Pharmacy_Approval_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approver_Pharmacy_Operations__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the Approver for Pharmacy Operation is Blank, approval status for Pharmacy Operation should be N/A</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Approval Status - Vision Analyst</fullName>
        <actions>
            <name>AIA_Update_Vision_Analyst_Approval_Statu</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approver_Vision_Analyst__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the Approver for Vision Analyst is Blank, approval status for Vision Analyst should be N/A</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA BD AA changed Approver Notification</fullName>
        <actions>
            <name>AIA_BD_changed_Approver_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNEW())  &amp;&amp;  ISCHANGED( Approver_Ancillary_Analyst__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA BD Approval Remainder notification for Benefact Coder</fullName>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c ,'In Review') , ISBLANK( text( AIA_Approval_Status_Benefact_Coder__c )), NOT(ISBLANK( AIA_Approver_Benefact_Coder__c  )) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_BD_Approval_remainder_notification_for_Benefact_Coder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AIA_Benefit_Design__c.Benefact_Coder_Approval_Start_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA BD Approval Remainder notification for Benefit Coder</fullName>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c ,'In Review') , ISBLANK( text( AIA_Approval_Status_Benefit_Coder__c)), NOT(ISBLANK( AIA_Approver_Benefit_Coder__c)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_BD_Approval_remainder_notification_for_Benefit_Coder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AIA_Benefit_Design__c.AIA_Benefit_Coder_Approval_Start_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA BD Approval Remainder notification for Benefit Tester</fullName>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c ,'In Review') , ISBLANK( text( AIA_Approval_Status_Benefit_Tester__c)), NOT(ISBLANK( AIA_Approver_Benefit_Tester__c)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_BD_Approval_remainder_notification_for_Benefit_Tester</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AIA_Benefit_Design__c.AIA_Benefit_Tester_Approval_Start_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA BD Approval Remainder notification for Contract Tech</fullName>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c ,'In Review') , ISBLANK( text(  AIA_Approval_Status_Contract_Tech__c  )), NOT(ISBLANK( Approver_Contract_Tech__c  )) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_BD_Approval_remainder_notification_for_Contract_Tech</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AIA_Benefit_Design__c.Contract_Tech_Approval_Start_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA BD Approval Remainder notification for MAST Tech</fullName>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c ,'In Review') , ISBLANK( text(  Approval_Status_MAST_Tech__c )), NOT(ISBLANK( AIA_Approver_MAST_Tech__c )) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_BD_Approval_remainder_notification_for_MAST_Tech</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AIA_Benefit_Design__c.MAST_Tech_Approval_Start_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA BD Approval Remainder notification for Pharmacy Operations</fullName>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c ,'In Review') , ISBLANK( text( Approval_Status_Pharmacy_Operations__c)), NOT(ISBLANK( Approver_Pharmacy_Operations__c)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_BD_Approval_remainder_notification_for_Pharmacy_Operations</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AIA_Benefit_Design__c.Pharmacy_Operations_Approval_Start_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA BD Approval Remainder notification for QA Auditor</fullName>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c ,'In Review') , NOT(ISBLANK( QA_Auditor_Approval_Start_Date__c )), NOT(ISBLANK(  Approver_QA_Auditor__c  )) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_BD_Approval_remainder_notification_for_QA_Auditor</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AIA_Benefit_Design__c.QA_Auditor_Approval_Start_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA BD Approval Remainder notification for Vision Analyst</fullName>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c ,'In Review') , ISBLANK( text( Approval_Status_Vision_Analyst__c)), NOT(ISBLANK( Approver_Vision_Analyst__c)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_BD_Approval_remainder_notification_for_Vision_Analyst</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AIA_Benefit_Design__c.Vision_Analyst_Approval_Start_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA BD Benefact Coder changed Approver Notification</fullName>
        <actions>
            <name>AIA_BD_Benefact_Coder_changed_Approver_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNEW())  &amp;&amp;  ISCHANGED(  AIA_Approver_Benefact_Coder__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA BD Benefit Coder changed Approver Notification</fullName>
        <actions>
            <name>AIA_BD_Benefit_Coder_changed_Approver_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNEW()) &amp;&amp; ISCHANGED( AIA_Approver_Benefit_Coder__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA BD Benefit Tester changed Approver Notification</fullName>
        <actions>
            <name>AIA_BD_Benefit_Tester_changed_Approver_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNEW()) &amp;&amp; ISCHANGED( AIA_Approver_Benefit_Tester__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA BD Contract Tech changed Approver Notification</fullName>
        <actions>
            <name>AIA_BD_Contract_Tech_changed_Approver_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNEW())  &amp;&amp;  ISCHANGED(     Approver_Contract_Tech__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA BD Initial Approver Notification</fullName>
        <actions>
            <name>AIA_BD_Initial_Approver_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8</booleanFilter>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Status__c</field>
            <operation>equals</operation>
            <value>In Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_Vision_Analyst__c</field>
            <operation>notEqual</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_Benefact_Coder__c</field>
            <operation>notEqual</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_Contract_Tech__c</field>
            <operation>notEqual</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_MAST_Tech__c</field>
            <operation>notEqual</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_Benefit_Tester__c</field>
            <operation>notEqual</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_Pharmacy_Operations__c</field>
            <operation>notEqual</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_Benefit_Coder__c</field>
            <operation>notEqual</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA BD MAST Tech changed Approver Notification</fullName>
        <actions>
            <name>AIA_BD_MAST_Tech_changed_Approver_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNEW())  &amp;&amp;  ISCHANGED(    AIA_Approver_MAST_Tech__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA BD PO changed Approver Notification</fullName>
        <actions>
            <name>AIA_BD_PO_changed_Approver_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNEW())  &amp;&amp;  ISCHANGED( Approver_Pharmacy_Operations__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA BD QA Auditor Notification</fullName>
        <actions>
            <name>AIA_BD_QA_Auditor_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approvers_Notified__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA BD QA Auditor changed Approver Notification</fullName>
        <actions>
            <name>AIA_BD_QA_Auditor_changed_Approver_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNEW())  &amp;&amp;  ISCHANGED(     Approver_QA_Auditor__c   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA BD VA changed Approver Notification</fullName>
        <actions>
            <name>AIA_BD_VA_changed_Approver_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNEW())  &amp;&amp;  ISCHANGED( Approver_Vision_Analyst__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Benefact Coder Response Date</fullName>
        <actions>
            <name>AIA_Benefact_Coder_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_Benefact_Coder__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Benefit Coder Response Date</fullName>
        <actions>
            <name>AIA_Benefit_Coder_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_Benefit_Coder__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Benefit Tester Response Date</fullName>
        <actions>
            <name>AIA_Benefit_Tester_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_Benefit_Tester__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Contract Tech Response Date</fullName>
        <actions>
            <name>AIA_Contract_Tech_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_Contract_Tech__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA MAST Tech Response Date</fullName>
        <actions>
            <name>AIA_MAST_Tech_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_MAST_Tech__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA NASCO Benefit Coder Response Date</fullName>
        <actions>
            <name>AIA_NASCO_Benefit_Coder_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_NASCO_Benefit_Coder__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Pharmacy Operation Response Date</fullName>
        <actions>
            <name>AIA_Pharmacy_Operation_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_Pharmacy_Operations__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approver_Pharmacy_Operations__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA QA Auditor Final notification</fullName>
        <actions>
            <name>AIA_QA_Auditor_final_approval_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8)</booleanFilter>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Status__c</field>
            <operation>equals</operation>
            <value>In Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_Benefact_Coder__c</field>
            <operation>contains</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_MAST_Tech__c</field>
            <operation>contains</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_Benefit_Coder__c</field>
            <operation>contains</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_Benefit_Tester__c</field>
            <operation>contains</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approval_Status_Contract_Tech__c</field>
            <operation>contains</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_Pharmacy_Operations__c</field>
            <operation>contains</operation>
            <value>Approved,Rejected,N/A</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_Vision_Analyst__c</field>
            <operation>contains</operation>
            <value>Approved,Rejected,N/A</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Renewal Effective Date Drawloop Checker</fullName>
        <actions>
            <name>AIA_Renewal_Effective_Date_Drawloop_Chec</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(ISBLANK( Renewal_Effective_Date_Drawloop__c ),false,true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Renewal Effective Date Drawloop Checker2</fullName>
        <actions>
            <name>AIA_Renewal_Effective_Date_Drawloop_Ch2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(ISBLANK( Renewal_Effective_Date_Drawloop__c ),true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Update Approval Start Date Fields</fullName>
        <actions>
            <name>AIA_Benefact_Coder_Approval_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Benefit_Coder_Apvl_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Benefit_Tester_Apvl_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Contract_Tech_Approval_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_MAST_Tech_Approval_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_NASCO_Benefit_Coder_Apvl_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Status__c</field>
            <operation>equals</operation>
            <value>In Review</value>
        </criteriaItems>
        <description>Updates the Approval Start date fields on the Benefit Design as and when the the user clicks on Send for Approval custom button</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Update BD Approver Notes</fullName>
        <actions>
            <name>AIA_Approver_Notes_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Clear_Approver_Comments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approver_Comments__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Update Pharmacy Operation fields</fullName>
        <actions>
            <name>AIA_Pharmacy_Operation_Approval_Start_Da</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approver_Pharmacy_Operations__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Status__c</field>
            <operation>equals</operation>
            <value>In Review</value>
        </criteriaItems>
        <description>Updates the Pharmacy Operation date fields on the Benefit Design if the Approver - Pharmacy Operation  is not null and when the the user clicks on Send for Approval custom button</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Update Vision Analyst fields</fullName>
        <actions>
            <name>AIA_Vision_Analyst_Approval_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approver_Vision_Analyst__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Status__c</field>
            <operation>equals</operation>
            <value>In Review</value>
        </criteriaItems>
        <description>Updates the Vision Analyst date fields on the Benefit Design if the Approver - Vision Analyst  is not null and when the the user clicks on Send for Approval custom button</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Vision Analyst Response Date</fullName>
        <actions>
            <name>AIA_Vision_Analyst_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_Vision_Analyst__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approver_Vision_Analyst__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Pharmacy Operation Approval Status after Reject</fullName>
        <actions>
            <name>Clear_Approval_Status_Pharmacy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_Pharmacy_Operations__c</field>
            <operation>notEqual</operation>
            <value>N/A</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Vision Analyst Approval Status after Reject</fullName>
        <actions>
            <name>Clear_Approval_Status_Vision</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_Vision_Analyst__c</field>
            <operation>notEqual</operation>
            <value>N/A</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA Ancillary Tech Response Date</fullName>
        <actions>
            <name>AIA_Ancillary_Tech_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_Analyst__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approver_Ancillary_Analyst__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA Approval Status - Ancillary Tech</fullName>
        <actions>
            <name>AIA_Update_Ancillary_Tech_Approval_Stat</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approver_Ancillary_Analyst__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the Approver fro Ancillary Tech is Blank, approval status for Ancillary Tech should be N/A</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA Approval Status - NASCO Benefit Coder</fullName>
        <actions>
            <name>AIA_Approval_Status_NASCO_Benefit_code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approver_Benefit_Coder__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the Approver for NASCO Benefit coder is Blank, approval status for Benefactt Code should be N/A</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA Approval Status - Pharmacy Management</fullName>
        <actions>
            <name>AIA_Approval_Status_Pharmacy_Management</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.AIA_Approver_Pharmacy_Management__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the Approver for Pharmacy Manahement is Blank, approval status for Pharmacy Management should be N/A</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA BD Approval Remainder notification for Ancillary Tech</fullName>
        <active>false</active>
        <formula>AND( ISPICKVAL( Status__c ,'In Review') , ISBLANK( text( Approval_Status_Analyst__c )), NOT(ISBLANK( Approver_Ancillary_Analyst__c )) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_BD_Approval_remainder_notification_for_Anciallary_Tech</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AIA_Benefit_Design__c.Ancillary_Tech_Approval_Start_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ZZ AIA BD Approval Remainder notification for NASCO Benefit Coder</fullName>
        <active>false</active>
        <formula>AND( ISPICKVAL( Status__c ,'In Review') , ISBLANK( text(  AIA_Approval_Status_NASCO_Benefit_Coder__c )), NOT(ISBLANK( Approver_Benefit_Coder__c  )) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_BD_Approval_remainder_notification_for_NASCO_Benefit_Coder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AIA_Benefit_Design__c.NASCO_Benefit_Coder_Approval_Start_Date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ZZ AIA BD NASCO Benefit Coder changed Approver Notification</fullName>
        <actions>
            <name>AIA_BD_NASCO_Benefit_Coder_changed_Approver_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>NOT(ISNEW()) &amp;&amp; ISCHANGED( Approver_Benefit_Coder__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA Benefit Design Rejected Actions</fullName>
        <actions>
            <name>AIA_Reset_Ancillary_Tech_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Reset_Benefact_Coder_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Reset_Contract_Tech_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Reset_MAST_Tech_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Reset_NASCO_Benefit_Coder_Response_D</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reset_Ancillary_Tech_Approval_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reset_Benefact_Coder_Approval_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reset_Contract_Tech_Approval_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reset_MAST_Tech_Approval_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reset_NASCO_Benefit_Coder_Approval_Start</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Resets several fields after BD is rejected</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA Update Ancillary Tech fields</fullName>
        <actions>
            <name>AIA_Ancillary_Tech_Approval_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approver_Ancillary_Analyst__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Status__c</field>
            <operation>equals</operation>
            <value>In Review</value>
        </criteriaItems>
        <description>Updates the Ancillary Tech date fields on the Benefit Design if the Approver - Ancillary Tech is not null and when the the user clicks on Send for Approval custom button</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA Update Revision Number on Benefit Design</fullName>
        <active>false</active>
        <description>B-03127: Auto increment the Revision Number</description>
        <formula>ISCHANGED(Status__c) &amp;&amp; ISPICKVAL(Status__c,'Approved')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ Update Ancillary Tech Approval Status after Reject</fullName>
        <actions>
            <name>Clear_Approval_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design__c.Approval_Status_Analyst__c</field>
            <operation>notEqual</operation>
            <value>N/A</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
