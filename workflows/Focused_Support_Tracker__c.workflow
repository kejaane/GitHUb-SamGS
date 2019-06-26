<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Focused_Support_Tracker_Send_Email_when_ticket_is_resolved</fullName>
        <ccEmails>sfdclightningsupport@carefirst.com</ccEmails>
        <description>Focused Support Tracker - Send Email when ticket is resolved</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Opened_By__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Reported_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Focused_Support_Tracker_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_ticket_assignment_email_Focused_Support_Tracker_Object</fullName>
        <ccEmails>sfdclightningsupport@carefirst.com</ccEmails>
        <description>Send ticket assignment email - Focused Support Tracker Object</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Focused_Support_Tracker_Assigned</template>
    </alerts>
    <alerts>
        <fullName>Send_ticket_created_email_Focused_Support_Tracker_Object</fullName>
        <ccEmails>sfdclightningsupport@carefirst.com</ccEmails>
        <description>Send ticket created email - Focused Support Tracker Object</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Opened_By__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Reported_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/Focused_Support_Tracker_Created</template>
    </alerts>
    <rules>
        <fullName>Send ticket assignment email - Focused Support Tracker Object</fullName>
        <actions>
            <name>Send_ticket_assignment_email_Focused_Support_Tracker_Object</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to opened by when ticket is assigned.</description>
        <formula>ISCHANGED( Assigned_To__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send ticket closure email - Focused Support Tracker Object</fullName>
        <actions>
            <name>Focused_Support_Tracker_Send_Email_when_ticket_is_resolved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Focused_Support_Tracker__c.Status__c</field>
            <operation>equals</operation>
            <value>Resolved</value>
        </criteriaItems>
        <description>Send email to opened by when ticket is closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send ticket created email - Focused Support Tracker Object</fullName>
        <actions>
            <name>Send_ticket_created_email_Focused_Support_Tracker_Object</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to reported by when ticket is created.</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
