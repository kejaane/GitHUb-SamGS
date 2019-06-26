<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AIA_Populate_ID</fullName>
        <field>AIA_UserId__c</field>
        <formula>Area_Manager__r.Id</formula>
        <name>AIA Populate ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA Populate UserID</fullName>
        <actions>
            <name>AIA_Populate_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Area_Manager__c.Area_Manager__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <description>To populate User's ID in UserID Field on mapping object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
