<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AIA_Implementation_create_notification_to_Implementation_Team</fullName>
        <description>AIA Implementation create notification to Implementation Team</description>
        <protected>false</protected>
        <recipients>
            <field>Imp_Coordinator__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Imp_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Implementation_Created</template>
    </alerts>
    <alerts>
        <fullName>AIA_Implementation_to_Implementation_Team</fullName>
        <description>AIA Implementation to Implementation Team</description>
        <protected>false</protected>
        <recipients>
            <field>Imp_Coordinator__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Imp_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Benefit_Request_Form_Changed_for_Implementation</template>
    </alerts>
    <fieldUpdates>
        <fullName>AIA_Imp_not_started_false</fullName>
        <field>Imp_not_started__c</field>
        <literalValue>0</literalValue>
        <name>AIA Imp not started false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_UPDATE_STATUS</fullName>
        <field>Status__c</field>
        <literalValue>In-Progress</literalValue>
        <name>AIA_UPDATE STATUS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Date_Implementation_Ended</fullName>
        <description>US 463,to update implementation ended</description>
        <field>Date_Implementation_Ended__c</field>
        <formula>TODAY()</formula>
        <name>AIA Update Date Implementation Ended</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Imp_in_progress_false</fullName>
        <field>Imp_in_progress__c</field>
        <literalValue>0</literalValue>
        <name>Imp in-progress false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCP_Error_Notes_Update</fullName>
        <field>PCP_Error_Notes__c</field>
        <formula>PCP_Error_Notes__c + BR() + $User.FirstName + ' ' + $User.LastName + ' ' + 'added a comment on' + ' ' + TEXT( Today() )+': '+ BR() + PCP_Error_Comments__c
+ BR()</formula>
        <name>PCP Error Notes Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Generate_Workplan_Stages_Value</fullName>
        <field>Generate_Workplan_Stages_Value__c</field>
        <literalValue>1</literalValue>
        <name>Set Generate Workplan Stages Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PCP_Error_Comments</fullName>
        <field>PCP_Error_Comments__c</field>
        <name>Update PCP Error Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PCP_Error_Date</fullName>
        <field>PCP_Errors_Date__c</field>
        <name>Update PCP Error Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA BRF Update on Implementation</fullName>
        <actions>
            <name>AIA_Implementation_to_Implementation_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AIA_Imp_not_started_false</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Implementation__c.Imp_not_started__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When BRF is updated on Implementation Object then an email should sent our to the implementation team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA New Implementation Created</fullName>
        <actions>
            <name>AIA_Implementation_create_notification_to_Implementation_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Imp_in_progress_false</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Implementation__c.Imp_in_progress__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When a new implementation is created with status "Inprogress/Completed" and email should sent to the implementation team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Set Generate Workplan Stages Value</fullName>
        <actions>
            <name>Set_Generate_Workplan_Stages_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Implementation__c.Generate_Workplan_Stages__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Update Date Implementation Ended</fullName>
        <actions>
            <name>AIA_Update_Date_Implementation_Ended</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Implementation__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>US 463,to update the date after everything is completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA update the PCP Error Comments</fullName>
        <actions>
            <name>PCP_Error_Notes_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_PCP_Error_Comments</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_PCP_Error_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Implementation__c.PCP_Error_Comments__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This rule update the  PCP Error Comments in to PCP Error Notes</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA_OWNER_CHANGE</fullName>
        <actions>
            <name>AIA_UPDATE_STATUS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(OwnerId), LEFT(PRIORVALUE(OwnerId), 3) = '00G', NOT(BEGINS(OwnerId, "00G")) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
