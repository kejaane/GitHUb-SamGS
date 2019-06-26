<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AIA_Notification_when_dental_product_is_added_to_PRF</fullName>
        <ccEmails>DentalSalesIncoming@carefirst.com</ccEmails>
        <description>AIA Notification when dental product is added to PRF</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Notification_when_Dental_Added_to_PRF</template>
    </alerts>
    <rules>
        <fullName>AIA Notification when Dental Added to PRF</fullName>
        <actions>
            <name>AIA_Notification_when_dental_product_is_added_to_PRF</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PRF__c.Dental_Employer_Sponsored__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PRF__c.Dental_Voluntary__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When the user adds dental products to a Proposal Request Form, and this Proposal Request Form did not have dental products before, the system sends a notification to DentalSalesIncoming@carefirst.com</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
