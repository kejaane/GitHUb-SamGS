<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_New_Email_Field</fullName>
        <field>New_Email__c</field>
        <formula>IF(ISNULL(Parent.New_Email__c ) , 1,Parent.New_Email__c +1)</formula>
        <name>Update New Email Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_email_count_on_case</fullName>
        <description>to increment the email count on case</description>
        <field>Number_of_Emails_Received__c</field>
        <formula>IF(ISNULL(Parent.Number_of_Emails_Received__c ), 1, Parent.Number_of_Emails_Received__c +1)</formula>
        <name>Update email count on case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>BSSWF Update New_Email%5F%5Fc field on Closed Case</fullName>
        <actions>
            <name>Update_New_Email_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SBU Broker Support Internal,Group Case,Member Case,Non-Member Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email received on Case</fullName>
        <actions>
            <name>Update_email_count_on_case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>This rule will update the count of Number_of_Emails_Received__c field on Case object when an email is received via Email-To-Case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
