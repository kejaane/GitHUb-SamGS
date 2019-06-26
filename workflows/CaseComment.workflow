<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Count_Number_of_case_comments</fullName>
        <description>This field update will update case field and count the number of comments added</description>
        <field>Case_Comment_Count__c</field>
        <formula>IF(ISNULL(Parent.Case_Comment_Count__c) , 1,  Parent.Case_Comment_Count__c+1)</formula>
        <name>Count Number of case comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Public_Case_Comment_Field</fullName>
        <field>Public_Case_Comments__c</field>
        <literalValue>1</literalValue>
        <name>Update the Public Case Comment Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>ZZ_BSSW Count Number of comments</fullName>
        <actions>
            <name>Count_Number_of_case_comments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>System Administrator - Custom,Integration - Custom</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Non-Member Case,Member Case</value>
        </criteriaItems>
        <description>This workflow will every time a case comment is added to a case or a case comment is edited. It is used to count the number of times a case comment is updated or added.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_Update Public Case Comment field</fullName>
        <actions>
            <name>Update_the_Public_Case_Comment_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>CaseComment.IsPublished</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CaseComment.CommentBody</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow updates the public case comments field on cases object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
