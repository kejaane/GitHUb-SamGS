<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AIA_Email_To_Creator_of_GSRF</fullName>
        <description>AIA Email To Creator of GSRF</description>
        <protected>false</protected>
        <recipients>
            <recipient>jeannette.parr@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melissa.caudill@carefirst.com.lg</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Send_Update_about_Status_incomplete</template>
    </alerts>
    <alerts>
        <fullName>AIA_Email_To_MAST_team</fullName>
        <description>AIA Email To MAST team</description>
        <protected>false</protected>
        <recipients>
            <recipient>jeannette.parr@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melissa.caudill@carefirst.com.lg</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Send_Update_about_Status</template>
    </alerts>
    <alerts>
        <fullName>AIA_GSM_Alpha_Prefix_Filled</fullName>
        <description>AIA GSM Alpha Prefix Filled</description>
        <protected>false</protected>
        <recipients>
            <recipient>jeannette.parr@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melissa.caudill@carefirst.com.lg</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_GSM_Alpha_Prefix_Filled</template>
    </alerts>
    <alerts>
        <fullName>AIA_GSM_BGI_Notification_Alert</fullName>
        <ccEmails>MAIN@carefirst.com; kris.Livengood@carefirst.com</ccEmails>
        <description>AIA GSM BGI Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>jeannette.parr@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melissa.caudill@carefirst.com.lg</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_GSM_BGI_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_GSM_Gsrf_Approved_Email_Alert</fullName>
        <description>AIA GSM Gsrf Approved Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>jeannette.parr@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melissa.caudill@carefirst.com.lg</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_GSM_Approved_internal</template>
    </alerts>
    <alerts>
        <fullName>AIA_GSM_Rejected_by_Account</fullName>
        <description>AIA GSM Rejected by Account</description>
        <protected>false</protected>
        <recipients>
            <recipient>jeannette.parr@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melissa.caudill@carefirst.com.lg</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_GSM_Rejected_by_Account</template>
    </alerts>
    <fieldUpdates>
        <fullName>update_gsa_ignore_validation</fullName>
        <description>after assigning to mast ,validations should work after submit for approval</description>
        <field>ignore_gsa_validations__c</field>
        <literalValue>0</literalValue>
        <name>update gsa ignore validation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA GSM Alpha Prefix Filled</fullName>
        <actions>
            <name>AIA_GSM_Alpha_Prefix_Filled</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Group_Structure_Request_Form__c.Alpha_Prefix_is_missing__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>US - 181 The system will send a notification to MAST tech mast@carefirst.com only after all the Alpha prefixes have been filled out.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA GSM Approved internal</fullName>
        <actions>
            <name>AIA_GSM_Gsrf_Approved_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Group_Structure_Request_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved by Internal Team</value>
        </criteriaItems>
        <description>US 86 Send email on status Approved internally to Mast@carefirst.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA GSM Send BGI Notification</fullName>
        <actions>
            <name>AIA_GSM_BGI_Notification_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Group_Structure_Request_Form__c.Base_Group_Impact__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>US - 198 The system will send a notification to MAST tech MAIN@carefirst.com when BGI is true</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Send update on Status</fullName>
        <actions>
            <name>AIA_Email_To_MAST_team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>update_gsa_ignore_validation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>US-78 An email notification must be sent out the MAST team (MAST@carefirst.com) that the GSRF is assigned to MAST role on the Account team.</description>
        <formula>AND(ISCHANGED( Status__c ), ISPICKVAL(Status__c , 'Assigned to MAST'))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Send update on Status incomplete</fullName>
        <actions>
            <name>AIA_Email_To_Creator_of_GSRF</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If any information is missing on the GSRF, the MAST can move the GSRF status to Draft-Incomplete (by clicking a button or changing the status field), and the creator of the GSRFwill get a notification that more details are needed.</description>
        <formula>AND(ISCHANGED( Status__c ), ISPICKVAL(Status__c , 'Draft - Incomplete'))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA GSM Rejected by Account</fullName>
        <actions>
            <name>AIA_GSM_Rejected_by_Account</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AIA_Group_Structure_Request_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected by Account</value>
        </criteriaItems>
        <description>US 117 Send mail to Mast@carefirst.com when Rejected by Account</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
