<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contract_Internal_Approval_Complete</fullName>
        <description>Contract - Internal Approval Complete</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AIA_Email_Templates/AIA_Contract_Approved_Internal</template>
    </alerts>
    <alerts>
        <fullName>Contract_Internal_Approvals_Rejected</fullName>
        <description>Contract - Internal Approvals Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Contract_Rejected_Internal</template>
    </alerts>
    <alerts>
        <fullName>Contract_Sales_Approval_Complete</fullName>
        <description>Contract - Sales Approval Complete</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Contract_Approved_Sales</template>
    </alerts>
    <alerts>
        <fullName>Contract_Sales_Approval_Rejected</fullName>
        <description>Contract - Sales Approval Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Contract_Rejected_Sales</template>
    </alerts>
    <fieldUpdates>
        <fullName>AIA_Contract_Update_Sales_Approval_Flag</fullName>
        <field>AIA_Status__c</field>
        <literalValue>Customer Approval</literalValue>
        <name>AIA Contract -Update Sales Approval Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Contract_Status_Post_Intern</fullName>
        <field>AIA_Status__c</field>
        <literalValue>Post Internal Review Document Creation</literalValue>
        <name>AIA_Update Contract Status - Post Intern</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Approved</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Approved_Internal</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Approved Internal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Reject</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Reject_Internal</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Reject Internal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Update_Internal_Approval_Flag</fullName>
        <field>Approved_Internal__c</field>
        <literalValue>1</literalValue>
        <name>Contract - Update Internal Approval Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Update_Sales_Approval_Flag</fullName>
        <field>Approved_Sales__c</field>
        <literalValue>1</literalValue>
        <name>Contract - Update Sales Approval Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_For_Approval</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>1</literalValue>
        <name>Submitted For Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_For_Internal_Contract_Approval</fullName>
        <description>US:750
To check if the record is submitted for approval or not</description>
        <field>AIA_Approval_Status__c</field>
        <literalValue>1</literalValue>
        <name>Submitted For Internal Contract Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contract_Status_Customer_Approval</fullName>
        <field>AIA_Status__c</field>
        <literalValue>Customer Approval</literalValue>
        <name>Update Contract Status Customer Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
