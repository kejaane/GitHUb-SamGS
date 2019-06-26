<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contact_Employer_Group_Portal_Activated</fullName>
        <ccEmails>sfdcTeam@carefirst.com</ccEmails>
        <description>Contact Employer Group Portal Activated</description>
        <protected>false</protected>
        <recipients>
            <recipient>katherine.mortensen@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Administration/Contact_Employer_Group_Portal_Activated</template>
    </alerts>
    <alerts>
        <fullName>Contact_Employer_Group_Portal_Deactivated</fullName>
        <ccEmails>EmployerPortalUseraccountrequest@carefirst.com</ccEmails>
        <ccEmails>sfdcTeam@carefirst.com</ccEmails>
        <description>Contact Employer Group Portal Deactivated</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Administration/Contact_Employer_Group_Portal_Deactivated</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Contact_RecType_Broker_NPN_1</fullName>
        <description>This field update function updates the RecType_Broker_NPN field with the concatenation of record type and Broker NPN</description>
        <field>RecType_Broker_NPN__c</field>
        <formula>RecordType.Name +"_"+ Broker_NPN__c</formula>
        <name>Update Contact RecType_Broker_NPN #1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_RecType_Broker_NPN_2</fullName>
        <field>RecType_Broker_NPN__c</field>
        <name>Update Contact Broker_NPN #2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_RecType_Enitity_ID_1</fullName>
        <description>This field update function updates the  RecType_Enitity_ID field with the concatenation of record type and entity Id</description>
        <field>RecType_Entity_ID__c</field>
        <formula>RecordType.Name +"_"+ Entity_ID__c</formula>
        <name>Update Contact RecType_Enitity_ID #1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_RecType_Enitity_ID_2</fullName>
        <field>RecType_Entity_ID__c</field>
        <name>Update Contact RecType_Enitity_ID #2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_Rectype_Entity_Id</fullName>
        <description>This field update function updates the  RecType_Enitity_ID field with the concatenation of record type and entity Id</description>
        <field>RecType_Entity_ID__c</field>
        <formula>RecordType.Name +"_"+ Entity_ID__c</formula>
        <name>Update Contact RecType_Enitity_ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BSSWF Populate Contact RecType_Entity_ID</fullName>
        <actions>
            <name>Update_Contact_Rectype_Entity_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Entity_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Community User Contact</value>
        </criteriaItems>
        <description>This workflow will populate the Concatenation of recordtype + "_" + Entity_ID into RecType_Entity_ID field on contact object IF rule criteria - contact record type is not Community User Contact</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BSSWF Populate Contact RecType_Entity_ID %231</fullName>
        <actions>
            <name>Update_Contact_RecType_Enitity_ID_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Entity_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow will populate the Concatenation of recordtype + "_" + Entity_ID into RecType_Entity_ID field on contact object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BSSWF Populate Contact RecType_Entity_ID %232</fullName>
        <actions>
            <name>Update_Contact_RecType_Enitity_ID_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Entity_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This workflow will populate null value  into RecType_Entity_ID field on contact object when entity id cleared</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact Employer Group Portal Activated</fullName>
        <actions>
            <name>Contact_Employer_Group_Portal_Activated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Fires when the Contact is currently a deactivated Employer Group Portal and then activated or is a new contact selected as active Employer Group Portal</description>
        <formula>Employer_Group_Portal__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact Employer Group Portal Deactivated</fullName>
        <actions>
            <name>Contact_Employer_Group_Portal_Deactivated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Fires when the Contact is currently an active Employer Group Portal and then deactivated.</description>
        <formula>ISCHANGED(Employer_Group_Portal__c) &amp;&amp; NOT(Employer_Group_Portal__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Contact RecType_Broker_NPN %231</fullName>
        <actions>
            <name>Update_Contact_RecType_Broker_NPN_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Broker_NPN__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Entity_Type_SB__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>51+</value>
        </criteriaItems>
        <description>This workflow will populate the Concatenation of recordtype + "_" + Broker_NPN into Rec_Type_Broker_NPN field on account object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Contact RecType_Broker_NPN %232</fullName>
        <actions>
            <name>Update_Contact_RecType_Broker_NPN_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Broker_NPN__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This workflow will clear the Record type Broker_NPN field if the Broker NPN is blank</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
