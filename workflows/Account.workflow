<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AIA_Account_Legal_Name_Has_Changed</fullName>
        <description>AIA Account Legal Name Has Changed</description>
        <protected>false</protected>
        <recipients>
            <field>AIA_Admin_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Dedicated_Representative_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Executive_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Auditor_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Automated_Enrollment_Tech_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>BeneFact_Coder_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Benefit_Coder_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Benefit_Contract_Specialist_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Benefit_Tester_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Billing_Tech_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Blue_Rewards_Tech_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Contract_Coordinator_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Contract_Manager_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Contract_Tech_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Enrollment_Tech_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Facets_Migration_Contact_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Implementation_Coordinator_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Legal_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Mast_Tech_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Pharmacy_Operations_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Production_ID_Card_Tech_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Proposal_Specialist_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>QA_Auditor_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Sales_Assistant_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Settlements_Analyst_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Underwriter_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Vision_Analyst_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Wellness_Tech_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AIA_Email_Templates/AIA_Account_Legal_Name_has_Changed</template>
    </alerts>
    <alerts>
        <fullName>AIA_Email_Mast_tech_account_team</fullName>
        <description>AIA Email Mast tech account team</description>
        <protected>false</protected>
        <recipients>
            <field>Mast_Tech_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Account_Nasco</template>
    </alerts>
    <alerts>
        <fullName>AIA_UW_30_day_reminder</fullName>
        <description>AIA_UW - 30 day reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Underwriter_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_UW_30_day_reminder</template>
    </alerts>
    <alerts>
        <fullName>New_Cede_Document_Notification</fullName>
        <description>New Cede Document Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/New_Cede_Document_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>AIA_Copy_Renewal_Date</fullName>
        <field>Copy_from_Renewal_Date__c</field>
        <formula>Renewal_Date__c</formula>
        <name>AIA Copy Renewal Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Prior_Value_Acc_Legal_Name</fullName>
        <description>This Field update is used to capture the prior value of Account Legal Name</description>
        <field>Previous_Account_Legal_Name__c</field>
        <formula>PRIORVALUE( Account_Legal_Name__c )</formula>
        <name>AIA Prior Value Acc Legal Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previous_Account_Legal_Name</fullName>
        <field>Previous_Account_Legal_Name__c</field>
        <formula>PRIORVALUE(Account_Legal_Name__c )</formula>
        <name>Previous Account Legal Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_RecType_Agency_NPN_1</fullName>
        <description>This field update function updates the Rec_Type_Agency_NPN__c field with the concatenation of record type and Agency NPN</description>
        <field>RecType_Agency_NPN__c</field>
        <formula>RecordType.Name +"_"+ Agency_NPN__c</formula>
        <name>Update Account RecType_Agency_NPN #1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_RecType_Agency_NPN_2</fullName>
        <description>This field update function updates the Rec_Type_Agency_NPN__c to null if the Agency_NPN__c is</description>
        <field>RecType_Agency_NPN__c</field>
        <name>Update Account RecType_Agency_NPN #2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_RecType_Entity_Id_1</fullName>
        <description>This field update function updates the RecType_Entity_Id__c field with the concatination of record type and entity Id</description>
        <field>RecType_Entity_ID__c</field>
        <formula>RecordType.Name +"_"+ Entity_ID__c</formula>
        <name>Update Account RecType_Entity_Id #1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_RecType_Entity_Id_2</fullName>
        <field>RecType_Entity_ID__c</field>
        <name>Update Account RecType_Entity_Id #2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_RecType_Facets_Account_1</fullName>
        <description>This field update function updates the RecType_Facets_Account_Number field with the concatenation of record type and Facets Account Number</description>
        <field>RecType_Facets_Account_Number__c</field>
        <formula>RecordType.Name +"_"+  Facets_Account_Number__c</formula>
        <name>Update Account RecType_Facets_Account_#1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_RecType_facets_Acc_No_2</fullName>
        <field>RecType_Facets_Account_Number__c</field>
        <name>Update Account RecType_facets_Acc_No_ #2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Tier_Level_to_Select</fullName>
        <description>Update Tier Level to Select</description>
        <field>Tier_Level__c</field>
        <literalValue>SELECT</literalValue>
        <name>Update Tier Level to Select</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA Account Legal Name Change</fullName>
        <actions>
            <name>AIA_Account_Legal_Name_Has_Changed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AIA_Prior_Value_Acc_Legal_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow is used to send an email to all AIA groups if the account legal name is updated</description>
        <formula>ISCHANGED( Account_Legal_Name__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Copy Renewal Date</fullName>
        <actions>
            <name>AIA_Copy_Renewal_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Renewal_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Send Update On Nasco</fullName>
        <actions>
            <name>AIA_Email_Mast_tech_account_team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>US-24 send notification to MAST tech (account team role) and MAST@carefirst.com  mailbox once account number is entered.</description>
        <formula>AND(ISCHANGED(NASCO_Account_Number__c),NOT(   ISBLANK(NASCO_Account_Number__c) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BSSWF Account Tier level Update to Select</fullName>
        <actions>
            <name>Update_Tier_Level_to_Select</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>51+</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <description>BSSWF Account Tier level Update to Select</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>BSSWF Populate Account RecType_Facets_Account_Number_%231</fullName>
        <actions>
            <name>Update_Account_RecType_Facets_Account_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Customer,Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Facets_Account_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>2-50</value>
        </criteriaItems>
        <description>This workflow will populate the Concatenation of recordtype + "_" + Facets_Account_Number into RecType_Facets_Account_Number field on account object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BSSWF Populate Account RecType_Facets_Account_Number_%232</fullName>
        <actions>
            <name>Update_Account_RecType_facets_Acc_No_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Customer,Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Facets_Account_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This workflow will clear out RecType_Facets_Account_Number__c if Facets_Account_Number__c is blank on the account object</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BSSWF Populate Account RecType_Facets_Account_Number_%233</fullName>
        <actions>
            <name>Update_Account_RecType_Facets_Account_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Customer,Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Facets_Account_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>51+</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>System Administrator - Custom</value>
        </criteriaItems>
        <description>This workflow will populate the Concatenation of recordtype + "_" + Facets_Account_Number into RecType_Facets_Account_Number field on account object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BSSWF Update Account RecType_Entity_ID %231</fullName>
        <actions>
            <name>Update_Account_RecType_Entity_Id_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Entity_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <description>This workflow will populate the Concatenation of recordtype + "_" + Entity_ID into RecType_Entity_ID field on account object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BSSWF Update Account RecType_Entity_ID %232</fullName>
        <actions>
            <name>Update_Account_RecType_Entity_Id_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Entity_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <description>This workflow will clear out RecType_Entity_Id__c if Entity_ID__c is blank on the account object</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Account RecType_Agency_NPN %231</fullName>
        <actions>
            <name>Update_Account_RecType_Agency_NPN_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Agency_NPN__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>51+</value>
        </criteriaItems>
        <description>This workflow will populate the Concatenation of recordtype + "_" + Agency_NPN into Rec_Type_Agency_NPN field on account object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Account RecType_Agency_NPN %232</fullName>
        <actions>
            <name>Update_Account_RecType_Agency_NPN_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Agency_NPN__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This workflow will populate null value into RecType Agency NPN field  when Agency NPN is cleared</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA New Cede Document Notification</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Final_Renewal_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>51+</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Cede_Document_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Final_Renewal_Date__c</offsetFromField>
            <timeLength>-180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ZZ AIA UW - 30 day reminder</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Account_Legal_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIA_UW_30_day_reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Renewal_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
