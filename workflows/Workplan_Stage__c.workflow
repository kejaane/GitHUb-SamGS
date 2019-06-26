<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AIA_Update_No_of_Asgmnts_Not_Required</fullName>
        <field>of_Completed_Tasks__c</field>
        <formula>of_Total_Tasks__c</formula>
        <name>AIA Update No of Asgmnts Not Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_No_of_Assignments</fullName>
        <field>of_Total_Tasks__c</field>
        <formula>Workplan_Type_Stage__r.Number_of_Assignments__c</formula>
        <name>AIA Update No of Assignments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA Update No of Asgmnts Not Required</fullName>
        <actions>
            <name>AIA_Update_No_of_Asgmnts_Not_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Workplan_Stage__c.Status__c</field>
            <operation>equals</operation>
            <value>Not Required</value>
        </criteriaItems>
        <criteriaItems>
            <field>Workplan_Stage__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sub-Process</value>
        </criteriaItems>
        <description>Update the No of assignments when Workplan stage is marked Not Required</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Update No of Assignments</fullName>
        <actions>
            <name>AIA_Update_No_of_Assignments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Workplan_Stage__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sub-Process</value>
        </criteriaItems>
        <description>Update no of assignments in Workplan stage sub process record from PreSales</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
