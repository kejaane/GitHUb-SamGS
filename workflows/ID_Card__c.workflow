<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AIA_ID_Card_Change_Owner</fullName>
        <description>AIA ID Card Change Owner</description>
        <protected>false</protected>
        <recipients>
            <recipient>MAST Tech</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ID_Card_sent_for_approvals</template>
    </alerts>
    <alerts>
        <fullName>AIA_ID_Card_email</fullName>
        <description>AIA ID Card email</description>
        <protected>false</protected>
        <recipients>
            <field>Mast_Tech_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ID_Card_sent_for_approvals</template>
    </alerts>
    <alerts>
        <fullName>send_email_to_record_owner_when_ID_Card_application_is_rejected</fullName>
        <description>send email to record owner when ID Card application is rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ID_Card_Rejection_emails</template>
    </alerts>
    <alerts>
        <fullName>sned_email_to_record_owner_once_it_ID_Card_application_is_approved</fullName>
        <description>send email to record owner once ID Card application is approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>debra.foreman@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jessica.strothers@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_ID_Card_Approval_emails</template>
    </alerts>
    <fieldUpdates>
        <fullName>AIA_ID_Card_status_update</fullName>
        <field>Status__c</field>
        <literalValue>In Review</literalValue>
        <name>AIA ID Card status update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>uncheck_sent_for_approval_field_upon_app</fullName>
        <field>sent_to_approval__c</field>
        <literalValue>0</literalValue>
        <name>uncheck sent for approval field upon app</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>uncheck_upon_rejection</fullName>
        <field>sent_to_approval__c</field>
        <literalValue>0</literalValue>
        <name>uncheck upon rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_the_Approver_Notified</fullName>
        <field>Approver_Notified__c</field>
        <literalValue>1</literalValue>
        <name>update the Approver Notified field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA ID Card Change Owner</fullName>
        <actions>
            <name>AIA_ID_Card_Change_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>Not(IsNew()) &amp;&amp; IsChanged(Mast_Tech_Approver__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA ID Card Rejection email</fullName>
        <actions>
            <name>send_email_to_record_owner_when_ID_Card_application_is_rejected</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>uncheck_upon_rejection</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ID_Card__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA ID Card approval</fullName>
        <actions>
            <name>AIA_ID_Card_email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AIA_ID_Card_status_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_the_Approver_Notified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ID_Card__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>ID_Card__c.sent_to_approval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>ID_Card__c.products_selected_count__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>ID_Card__c.products_selected_count__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ID_Card__c.Member_level_Products__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA ID Card approval email</fullName>
        <actions>
            <name>sned_email_to_record_owner_once_it_ID_Card_application_is_approved</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>uncheck_sent_for_approval_field_upon_app</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ID_Card__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
