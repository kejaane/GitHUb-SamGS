<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AIA_Update_task_assigned_date</fullName>
        <field>AIA_Task_Assigned_Date__c</field>
        <formula>IF( OR(TEXT(PRIORVALUE( Status__c )) &lt;&gt;  TEXT( Status__c ), PRIORVALUE( OwnerId )&lt;&gt;  OwnerId ),TODAY(), PRIORVALUE( AIA_Task_Assigned_Date__c ) )</formula>
        <name>AIA Update task assigned date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FU_AIA_Update_Actual_SLA_in_WorkplanTask</fullName>
        <description>Field Updated (FU) for the workflow rule AIA Update Actual SLA in Workplan Task</description>
        <field>End_Date__c</field>
        <formula>TODAY()</formula>
        <name>FU_AIA Update Actual SLA in WorkplanTask</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_ID_on_Workplan_Task</fullName>
        <field>AccountID__c</field>
        <formula>IF(NOT(ISBLANK(Opportunity__c)),Opportunity__r.AccountId,Implementation__r.Account__c)</formula>
        <name>Update Account ID on Workplan Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Start_Date</fullName>
        <field>Start_Date__c</field>
        <formula>If(AND( ISCHANGED(Status__c),Text( PRIORVALUE(Status__c ) )!='In Progress'),TODAY(), PRIORVALUE( Start_Date__c ))</formula>
        <name>Update Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ZZ AIA Update AccountID%5F%5Fc Field</fullName>
        <actions>
            <name>Update_Account_ID_on_Workplan_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Workflow rule to update the field AccountID__c from associated Implementation or Opportunity</description>
        <formula>NOT(ISBLANK(Opportunity__c) || ISBLANK(Implementation__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA Update Actual SLA in Workplan Task</fullName>
        <actions>
            <name>FU_AIA_Update_Actual_SLA_in_WorkplanTask</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Workplan_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA Update Assigned Date</fullName>
        <actions>
            <name>AIA_Update_task_assigned_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISPICKVAL(Status__c , 'In Progress') &amp;&amp; ISCHANGED( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
