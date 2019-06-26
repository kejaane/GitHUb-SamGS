<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AIA_BAA_Approval_Email</fullName>
        <description>AIA BAA Approval Email</description>
        <protected>false</protected>
        <recipients>
            <field>Docusign_Sender__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BAA_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>AIA_BAA_Rejection_Email</fullName>
        <description>AIA BAA Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <field>Docusign_Sender__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BAA_Rejection_Email</template>
    </alerts>
    <alerts>
        <fullName>AIA_Billing_Settlement_Rejection</fullName>
        <description>AIA Billing / Settlement Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Sales_Service_Rep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AIA_Email_Templates/Billing_Settlement_Rejection_Email</template>
    </alerts>
    <alerts>
        <fullName>AIA_Billing_Settlement_Rejection2</fullName>
        <description>AIA Billing / Settlement Rejection2</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Implementation_Team__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/Billing_Settlement_Rejection_Email</template>
    </alerts>
    <alerts>
        <fullName>AIA_Document_Notification_on_Quote_Upload</fullName>
        <description>US171:Send notification automatically to Sales to deliver quote and Upload the signed document</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Executive_Account_Team__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Document_Notification_on_Quote_Upload</template>
    </alerts>
    <alerts>
        <fullName>AIA_Group_Structure_Document_Approval_to_Implementation_Team</fullName>
        <description>AIA Group Structure Document Approval to Implementation Team</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Implementation_Team__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AIA_Email_Templates/AIA_Group_Structure_Document_Quality_Audit_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_Group_Structure_Document_Approved</fullName>
        <description>AIA Group Structure Document Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Team_Vision_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AIA_Email_Templates/AIA_Group_Structure_Document_Approved</template>
    </alerts>
    <alerts>
        <fullName>AIA_New_Cede_Document</fullName>
        <description>AIA New Cede Document</description>
        <protected>false</protected>
        <recipients>
            <recipient>network.process@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Notify_Cede_Document</template>
    </alerts>
    <alerts>
        <fullName>AIA_Sales_Data_Analyst_Request</fullName>
        <description>AIA Bid Meeting Document type Sales Data Analyst Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>network.process@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Sales_Data_Analyst_Request</template>
    </alerts>
    <alerts>
        <fullName>AIA_Sales_Service_Rep_Approval</fullName>
        <description>AIA Sales Service Rep Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Sales_Service_Rep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AIA_Email_Templates/AIA_Group_Structure_Document_Quality_Audit_Approval</template>
    </alerts>
    <alerts>
        <fullName>AIA_Step_6_Account_Approval_Account_Implementation</fullName>
        <description>AIA Step 6: Account Approval (Account Implementation)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Implementation Coordinator</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Step_6_Account_Approval_Account_Implementation</template>
    </alerts>
    <alerts>
        <fullName>AIA_Step_7_Account_Approval_Sales_Service_Rep</fullName>
        <description>AIA Step 7: Account Approval (Sales Service Rep)</description>
        <protected>false</protected>
        <recipients>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Step_7_Account_Approval_Sales_Service_Rep</template>
    </alerts>
    <alerts>
        <fullName>AIA_Unsigned_Quote_Document_Approved</fullName>
        <description>AIA Unsigned Quote Document Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Sales_User_email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Unsigned_quote_Document_Approved</template>
    </alerts>
    <alerts>
        <fullName>Approval_Rejection_Email</fullName>
        <description>Approval Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <field>LGIT_Tech__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/Quality_Audit_Approval_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Billing_Tech_Approval</fullName>
        <description>Billing Tech Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Billing_Tech__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AIA_Email_Templates/AIA_Group_Structure_Document_Quality_Audit_Approval</template>
    </alerts>
    <alerts>
        <fullName>GS_Document_approved</fullName>
        <description>AIA Group Structure Document Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Team_Pharmacy_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AIA_Email_Templates/AIA_Group_Structure_Document_Approved</template>
    </alerts>
    <alerts>
        <fullName>Mock_ID_Card_Approved</fullName>
        <description>Mock ID Card Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_MockID_Card_Approved</template>
    </alerts>
    <alerts>
        <fullName>Mock_ID_Card_Rejected</fullName>
        <description>Mock ID Card Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_MockID_Card_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Notify_PRF_Owner</fullName>
        <description>Notify PRF Owner</description>
        <protected>false</protected>
        <recipients>
            <field>PRF_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/Notify_PRF_Owner</template>
    </alerts>
    <alerts>
        <fullName>Producction_ID_Card_Rejected</fullName>
        <description>Producction ID Card Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ProductionID_Card_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Production_ID_Card_Approved</fullName>
        <description>Production ID Card Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ProductionID_Card_Approved</template>
    </alerts>
    <alerts>
        <fullName>Production_ID_Card_Rejected</fullName>
        <description>Production ID Card Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ProductionID_Card_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Quality_Audit_Approval</fullName>
        <description>Quality Audit Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>QA Auditor</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AIA_Email_Templates/AIA_Group_Structure_Document_Quality_Audit_Approval</template>
    </alerts>
    <alerts>
        <fullName>Quote_Rejection_Process</fullName>
        <description>Quote Rejection Process</description>
        <protected>false</protected>
        <recipients>
            <field>Sales_User_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BRF_Quote_Rejection_Process</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_BRF_Owner</fullName>
        <description>Send Email to BRF Owner</description>
        <protected>false</protected>
        <recipients>
            <field>Sales_User_email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BRF_Quote_Upload</template>
    </alerts>
    <alerts>
        <fullName>Settlement_Tech_Approval</fullName>
        <description>Settlement Tech Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Settlements_Tech__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AIA_Email_Templates/AIA_Group_Structure_Document_Quality_Audit_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>AIA_FU_Update_ReadyForFilenet_flag</fullName>
        <description>used to update ready for filenet flag when category is not bd, bdp, bdf</description>
        <field>Ready_for_Filenet__c</field>
        <literalValue>1</literalValue>
        <name>AIA_FU_Update ReadyForFilenet flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Group_Structure_Document_Approved</fullName>
        <field>Group_Structure_Document_Approval_Stage__c</field>
        <literalValue>Step 7-Approved</literalValue>
        <name>AIA Group Structure Document Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Group_Structure_Document_Step_6</fullName>
        <field>Group_Structure_Document_Approval_Stage__c</field>
        <literalValue>Step 6-New Business - Account Implementation</literalValue>
        <name>AIA Group Structure Document Step 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Group_Structure_Document_Step_7</fullName>
        <field>Group_Structure_Document_Approval_Stage__c</field>
        <literalValue>Step 7-Existing Business - Sales / Service Rep</literalValue>
        <name>AIA Group Structure Document Step 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Std_to_Non_Std</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Non_Standard</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>AIA Std to Non Std</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Approval_Status_In_Approval</fullName>
        <description>AIA - Update Approval Status to In Approval</description>
        <field>Approval_Status__c</field>
        <literalValue>In Approval</literalValue>
        <name>AIA - Update Approval Status=In Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Approval_Status_To_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>AIA - Update Approval Status To Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Approval_Status_To_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>AIA - Update Approval Status To Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Quote_Status_To_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>AIA - Update Quote Status To Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Quote_Status_To_In_Approval</fullName>
        <field>Approval_Status__c</field>
        <literalValue>In Approvals</literalValue>
        <name>AIA - Update Quote Status To In Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Quote_Status_To_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>AIA - Update Quote Status To Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Date_Time_Update</fullName>
        <field>Approval_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Approval Date Time Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Document_Status</fullName>
        <field>Document_Status__c</field>
        <literalValue>Final</literalValue>
        <name>Approval Document Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Reject_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Reject Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>In Approval</literalValue>
        <name>Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Approved_ASO_v4</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Approved ASO v4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Approved_ID_Cards</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Approved ID Cards</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Approved_Mock_ID</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Approved Mock ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Approved_RISK_v4</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Approved RISK v4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Approved_Unsigned</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Approved Unsigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Approval Status - Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Reject_ASO_v4</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Reject ASO v4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Reject_ID_Cards</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Reject ID Cards</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Reject_Mock_ID</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Reject Mock ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Reject_RISK_v4</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Reject RISK v4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Reject_Unsigned</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Reject Unsigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approver_Information_Update</fullName>
        <field>Approver_name__c</field>
        <formula>$User.Username</formula>
        <name>Approver Information Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Document_Approval_Date_Update</fullName>
        <field>Document_Approval_Date__c</field>
        <formula>Now()</formula>
        <name>Document Approval Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Document_Final_Status_Update</fullName>
        <field>Document_Status__c</field>
        <literalValue>Final</literalValue>
        <name>Document Final Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Document_Status_Final</fullName>
        <field>Document_Status__c</field>
        <literalValue>Final</literalValue>
        <name>Document Status - Final</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_Date</fullName>
        <field>Approval_Date_Time__c</field>
        <formula>Now()</formula>
        <name>Final Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_Update</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Final Approval Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_For_Approval_ASO_v4</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>1</literalValue>
        <name>Submitted For Approval ASO v4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_For_Approval_ID_Cards</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>1</literalValue>
        <name>Submitted For Approval ID Cards</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_For_Approval_Mock_ID</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>1</literalValue>
        <name>Submitted For Approval Mock ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_For_Approval_RISK_v4</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>1</literalValue>
        <name>Submitted For Approval RISK v4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_For_Approval_Unsigned</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>1</literalValue>
        <name>Submitted For Approval Unsigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sales_User_Email</fullName>
        <field>Sales_User_email__c</field>
        <formula>Owner:User.Email</formula>
        <name>Update Sales User Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sales_User_Email1</fullName>
        <field>Sales_User_email__c</field>
        <formula>Opportunity__r.Owner.Email</formula>
        <name>Update_Sales_User_Email1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA BAA Approvals Email</fullName>
        <actions>
            <name>AIA_BAA_Approval_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>AIA_Document__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>Custom BAA</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA BAA Rejection Email</fullName>
        <actions>
            <name>AIA_BAA_Rejection_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Document__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>Custom BAA</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA BRF Quote Upload</fullName>
        <actions>
            <name>Send_Email_to_BRF_Owner</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Sales_User_Email1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( Document_Name__c !=NULL &amp;&amp;   ISPICKVAL(Document_Type__c , 'Quote'))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AIA Document Notification on UnSigned Quote Upload</fullName>
        <actions>
            <name>AIA_Document_Notification_on_Quote_Upload</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>Unsigned Quote</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Document__c.Source__c</field>
            <operation>equals</operation>
            <value>Benefit Request Form</value>
        </criteriaItems>
        <description>us171: Send notification automatically to Sales to deliver quote and Upload the signed document</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AIA Group Structure Document Step 6-New Business - Account Implementation</fullName>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Document__c.Group_Structure_Document_Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Step 6-New Business - Account Implementation</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_Step_6_Account_Approval_Account_Implementation</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA Group Structure Document Step 7%3A Account Approval Step 7 Sales Service Rep</fullName>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Document__c.Group_Structure_Document_Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Step 7-Existing Business - Sales / Service Rep</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_Step_7_Account_Approval_Sales_Service_Rep</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA New Cede Document Upload</fullName>
        <actions>
            <name>AIA_New_Cede_Document</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>Cede Document</value>
        </criteriaItems>
        <description>New Cede Document Uploaded</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Sales Data Analyst Request Filenet</fullName>
        <actions>
            <name>AIA_Sales_Data_Analyst_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>Sales Data Analyst Request</value>
        </criteriaItems>
        <description>When Document type is "Sales Data Analyst Request Filenet" Email notification to networkaccess@carefirst.com</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AIA Sts to Non Std</fullName>
        <actions>
            <name>AIA_Std_to_Non_Std</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>Custom BAA</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Update Ready For FileNet</fullName>
        <actions>
            <name>AIA_FU_Update_ReadyForFilenet_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Document__c.Document_Type__c</field>
            <operation>notEqual</operation>
            <value>Custom BAA</value>
        </criteriaItems>
        <description>workflow to update the flag ready for filenet when category is not BD , BDP, BDF. for these categories it will be updated through benefit design trigger helper code.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Update Sales User Email</fullName>
        <actions>
            <name>Update_Sales_User_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>AIA_Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>Unsigned Quote</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GS Approved with drug products</fullName>
        <actions>
            <name>GS_Document_approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Approval_Status__c,"Approved") &amp;&amp; ISPICKVAL(Document_Type__c,"Group Structure Document") &amp;&amp; Implementation__r.Benefit_Request_Form__r.Count_Drug_Proposed_Products__c &gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
