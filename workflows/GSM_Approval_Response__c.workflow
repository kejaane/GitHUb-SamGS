<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GSM_Approval_Response_Email_Alert</fullName>
        <description>AIA GSM Approval Response Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_GSRF_Approve_Email_Template</template>
    </alerts>
    <rules>
        <fullName>AIA GSM Approval Response Email</fullName>
        <actions>
            <name>GSM_Approval_Response_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GSM_Approval_Response__c.CreatedById</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <description>US-106 after creation of GSM Approval Response it will send email to user lookup</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
