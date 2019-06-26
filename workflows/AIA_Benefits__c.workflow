<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AIA_Tier_Type_Default_Update</fullName>
        <field>Tier_Type_Default__c</field>
        <literalValue>Preferred Brand</literalValue>
        <name>AIA Tier Type Default Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Tier_Type_Update</fullName>
        <field>Tier_type__c</field>
        <literalValue>Preferred Brand</literalValue>
        <name>AIA Tier Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Tier_Type_Update_Non_Preferred</fullName>
        <field>Tier_type__c</field>
        <literalValue>Non-Preferred Brand</literalValue>
        <name>AIA Tier Type Update Non-Preferred</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Tier_Type_Default_N_P_Field</fullName>
        <field>Tier_Type_Default__c</field>
        <literalValue>Non-Preferred Brand</literalValue>
        <name>AIA Update Tier Type Default N-P Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA Update Tier Type Non-Preferred Field</fullName>
        <actions>
            <name>AIA_Tier_Type_Update_Non_Preferred</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Update_Tier_Type_Default_N_P_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( TEXT( Tier_type__c )='Non-Preferred',true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Update Tier Type Preferred Field</fullName>
        <actions>
            <name>AIA_Tier_Type_Default_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Tier_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( TEXT( Tier_type__c )='Preferred',true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
