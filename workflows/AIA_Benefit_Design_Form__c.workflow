<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BDF_Update_DC_VA_Jurisdiction</fullName>
        <field>Child_Dependent_Mandates__c</field>
        <literalValue>DC/VA</literalValue>
        <name>BDF Update DC/VA Jurisdiction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BDF_Update_MD_Jurisdiction</fullName>
        <field>Child_Dependent_Mandates__c</field>
        <literalValue>Maryland</literalValue>
        <name>BDF Update MD Jurisdiction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BDF_Update_Other_Jurisdiction</fullName>
        <field>Child_Dependent_Mandates__c</field>
        <literalValue>Custom</literalValue>
        <name>BDF Update Other Jurisdiction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ZZ AIA BDF Update DC%2FVA Jurisdiction</fullName>
        <actions>
            <name>BDF_Update_DC_VA_Jurisdiction</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>AIA_Benefit_Design_Form__c.Jurisdiction__c</field>
            <operation>equals</operation>
            <value>DC</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIA_Benefit_Design_Form__c.Jurisdiction__c</field>
            <operation>equals</operation>
            <value>VA</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA BDF Update MD Jurisdiction</fullName>
        <actions>
            <name>BDF_Update_MD_Jurisdiction</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AIA_Benefit_Design_Form__c.Jurisdiction__c</field>
            <operation>equals</operation>
            <value>MD</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA BDF Update Other Jurisdiction</fullName>
        <actions>
            <name>BDF_Update_Other_Jurisdiction</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AIA_Benefit_Design_Form__c.Jurisdiction__c</field>
            <operation>equals</operation>
            <value>Other - Cede Required</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
