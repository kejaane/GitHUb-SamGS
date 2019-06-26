<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_BC_Plan_Codes_to</fullName>
        <field>BC_Plan_Codes__c</field>
        <formula>'190'</formula>
        <name>Update BC - Plan Codes to 190</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BC_Plan_Codes_to_080</fullName>
        <field>BC_Plan_Codes__c</field>
        <formula>'080'</formula>
        <name>Update BC - Plan Codes to 080</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BS_Plan_Codes_to_580</fullName>
        <field>BS_Plan_Codes__c</field>
        <formula>'580'</formula>
        <name>Update BS - Plan Codes to 580</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BS_Plan_Codes_to_690</fullName>
        <field>BS_Plan_Codes__c</field>
        <formula>'690'</formula>
        <name>Update BS - Plan Codes to 690</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA BC BS Code Update For Par Plan 580</fullName>
        <actions>
            <name>Update_BC_Plan_Codes_to</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BS_Plan_Codes_to_690</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Benefit_Design_Form__r.Control_Plan__c  = '580'</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AIA BC BS Code Update For Par Plan 690</fullName>
        <actions>
            <name>Update_BC_Plan_Codes_to_080</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BS_Plan_Codes_to_580</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Benefit_Design_Form__r.Control_Plan__c  = '690'</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
