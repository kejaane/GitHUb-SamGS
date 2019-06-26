<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Concatenate_Agency_and_agent_id</fullName>
        <field>Agency_Agent_Id__c</field>
        <formula>Agency_ID__c +'_'+  Agent_ID__c</formula>
        <name>Concatenate Agency and agent id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Market_Segment</fullName>
        <description>This field update will change the market segment to 51+</description>
        <field>Market_Segment__c</field>
        <literalValue>51+</literalValue>
        <name>Update Market Segment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BSSWF Concatenate Agency Agent field on Group Table</fullName>
        <actions>
            <name>Concatenate_Agency_and_agent_id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Group__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This work flow Concatenates Agency Id and Agent ID field into Agency_Agent_id__c.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BSSWF update group agent table market segment</fullName>
        <actions>
            <name>Update_Market_Segment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Group__c.Market_Segment__c</field>
            <operation>notEqual</operation>
            <value>2-50</value>
        </criteriaItems>
        <description>This workflow will update the market segment of all Group Agent table record that are not of type 2-50 to 51+</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
