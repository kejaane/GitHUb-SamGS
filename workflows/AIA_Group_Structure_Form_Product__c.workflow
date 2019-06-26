<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AIA_GSM_Edited_atleast_once</fullName>
        <description>US 247</description>
        <field>Gsp_Opened__c</field>
        <literalValue>1</literalValue>
        <name>AIA GSM Edited atleast once</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA GSM Edited atleast once</fullName>
        <actions>
            <name>AIA_GSM_Edited_atleast_once</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is used to update the  Gsp_Opened__c to true so that it make will make sure that the required fields are all filled before submitting to GSRF</description>
        <formula>NOT(ISBLANK(Employee_Status__c  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
