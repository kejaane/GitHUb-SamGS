<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AIA_Docusign_Approval_Response_Date</fullName>
        <field>Response_Date__c</field>
        <formula>NOW()</formula>
        <name>AIA Docusign Approval Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA Docusign Approval Response Date</fullName>
        <actions>
            <name>AIA_Docusign_Approval_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Fills in the Response date when Approver accept/Reject the AIA Document</description>
        <formula>ISCHANGED( Response__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
