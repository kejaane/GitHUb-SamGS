<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AIA_BD_Case_Notification</fullName>
        <description>AIA BD Case Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>AIA_BD_Closed_Case_Notification</fullName>
        <description>AIA BD Closed Case Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_BD_Closed_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Assignment</fullName>
        <description>AIA Case Notification to Account Manager</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Case_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_For_High_Priority_Cases</fullName>
        <description>Email Alert For High Priority Cases</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/SLA_For_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_For_Low_Priority_Cases</fullName>
        <description>Email Alert For Low Priority Cases</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/SLA_For_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_For_Medium_Priority_Cases</fullName>
        <description>Email Alert For Medium Priority Cases</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/SLA_For_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_For_Urgent_Priority_Cases</fullName>
        <description>Email Alert For Urgent Priority Cases</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/SLA_For_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_sent_to_case_creator</fullName>
        <description>Email sent to case creator</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SAMPLECaseResponse</template>
    </alerts>
    <alerts>
        <fullName>SFDC_Case_has_been_closed</fullName>
        <description>SFDC Case has been closed</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>SFDC_Support_Queue</fullName>
        <description>SFDC Support Queue</description>
        <protected>false</protected>
        <recipients>
            <recipient>alex.friedman@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eve.firmani@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kathy.newson@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lynn.whye@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>robert.dunn@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomas.barrett@carefirst.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SFDC_Support_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>BSSWF_Resolution_Reason_date_update</fullName>
        <field>Resolution_Reason_Posted_Date__c</field>
        <formula>now()</formula>
        <name>BSSWF Resolution Reason date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BSSWF_Update_Case_Owner_to_Elite_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Elite_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>BSSWF Update Case Owner to Elite Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BSSWF_Update_Case_Owner_to_Preferred_Que</fullName>
        <field>OwnerId</field>
        <lookupValue>Preferred_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>BSSWF Update Case Owner to Preferred Que</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BSSWF_Update_Case_Owner_to_Premier_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Premier_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>BSSWF Update Case Owner to Premier Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BSSWF_Update_Case_Owner_to_SELECT_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Non_Platinum_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>BSSWF Update Case Owner to SELECT Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Web_Case_Owner_to_Queue</fullName>
        <description>This field update will change the case owner to Community Cases Queue</description>
        <field>OwnerId</field>
        <lookupValue>Community_Cases</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Web Case Owner to Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SBU_Update_Case_Received_Date</fullName>
        <description>This field update will input the current date and time of the Case received date when the status of a case changes to in Progress</description>
        <field>Received_Date__c</field>
        <formula>Now()</formula>
        <name>SBU Update Case Received Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SBU_Update_Case_Status_To_Assigned</fullName>
        <description>This field update will change the status to Assigned</description>
        <field>Status</field>
        <literalValue>Assigned</literalValue>
        <name>SBU Update Case Status to Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SBU_Update_Case_Status_to_In_Queue</fullName>
        <description>This Field update will change a case status Back to In-queue</description>
        <field>Status</field>
        <literalValue>In-Queue</literalValue>
        <name>SBU_Update Case Status to In-Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SBU_Update_Received_Day</fullName>
        <field>Received_Day__c</field>
        <formula>TODAY()</formula>
        <name>SBU Update Received Day</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BST_to_Elite</fullName>
        <field>Broker_Service_Team__c</field>
        <literalValue>Elite</literalValue>
        <name>Update BST to Elite</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BST_to_Preferred</fullName>
        <field>Broker_Service_Team__c</field>
        <literalValue>Preferred</literalValue>
        <name>Update BST to Preferred</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BST_to_Premier</fullName>
        <field>Broker_Service_Team__c</field>
        <literalValue>Premier</literalValue>
        <name>Update BST to Premier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BST_to_Small_Medium_Group</fullName>
        <field>Broker_Service_Team__c</field>
        <literalValue>Small Medium Group</literalValue>
        <name>Update BST to Small Medium Group</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Received_Date</fullName>
        <description>This field update will input the current date and time of the Case received date when the status of a case changes to in Progress</description>
        <field>Received_Date__c</field>
        <formula>Now()</formula>
        <name>Update Case Received Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_To_Assigned</fullName>
        <field>Status</field>
        <literalValue>Assigned</literalValue>
        <name>Update Case Status to Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Group_ID_Field</fullName>
        <field>Group_ID__c</field>
        <formula>LEFT( Group__r.Group_ID__c, 4)</formula>
        <name>Update Group ID Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_New_Email_Field_to_Null</fullName>
        <field>New_Email__c</field>
        <name>Update New Email Field to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Reason_Code_to_Null</fullName>
        <field>Reason__c</field>
        <name>Update Reason Code to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <description>this field update will update the case record type to SBU Broker Support</description>
        <field>RecordTypeId</field>
        <lookupValue>SBU_Broker_Support_Internal</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SLA_Category_to_Select</fullName>
        <field>SLA_Category__c</field>
        <literalValue>SELECT</literalValue>
        <name>Update SLA Category to Select</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SLA_to_Elite</fullName>
        <field>SLA_Category__c</field>
        <literalValue>Elite</literalValue>
        <name>Update SLA to Elite</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SLA_to_Preferred</fullName>
        <field>SLA_Category__c</field>
        <literalValue>Preferred</literalValue>
        <name>Update SLA to Preferred</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SLA_to_Premier</fullName>
        <field>SLA_Category__c</field>
        <literalValue>Premier</literalValue>
        <name>Update SLA to Premier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_priority_to_Medium</fullName>
        <field>Priority</field>
        <literalValue>Medium</literalValue>
        <name>Update case priority to Medium</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_priority_to_high</fullName>
        <description>For Elite and Premier SLA</description>
        <field>Priority</field>
        <literalValue>High</literalValue>
        <name>Update case priority to high</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Public_Case_Comment_Field_Nul</fullName>
        <field>Public_Case_Comments__c</field>
        <literalValue>0</literalValue>
        <name>Update the Public Case Comment Field Nul</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA BD Case Notification</fullName>
        <actions>
            <name>AIA_BD_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will fire if the case owner is updated or any other updates made on case</description>
        <formula>IF(RecordType.DeveloperName = 'AIA_BD_Cases',IF( ISNEW() || (Text( Status )!='Closed' &amp;&amp; ISCHANGED ( OwnerId )),true,false),false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA BD Closed Case Notification</fullName>
        <actions>
            <name>AIA_BD_Closed_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>AIA Benefit Design Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>This workflow will fire if the case is closed which is created for BD</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Case Approval By Account manager</fullName>
        <actions>
            <name>Case_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>AIA NCR Cases</value>
        </criteriaItems>
        <description>When a case is assigned to a account manager, an email should fire to him for his approval or rejection</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Email Notification for High Priority Cases</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>AIA Account Issue</value>
        </criteriaItems>
        <description>If an Issue (Case) with Priority = "High" and it is not closed within 1 week from the time of creation  then application will send an email to the Issue(Case) Onwer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_For_High_Priority_Cases</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA Email Notification for Low Priority Cases</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Low</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>AIA Account Issue</value>
        </criteriaItems>
        <description>If an Issue (Case) with Priority = "Low" and it is not closed within 1 week from the time of creation  then application will send an email to the Issue(Case) Onwer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_For_Low_Priority_Cases</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA Email Notification for Medium Priority Cases</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Medium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>AIA Account Issue</value>
        </criteriaItems>
        <description>If an Issue (Case) with Priority = "Medium" and it is not closed within 1 week from the time of creation  then application will send an email to the Issue(Case) Onwer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_For_Medium_Priority_Cases</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AIA Email Notification for Urgent Priority Cases</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Urgent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>AIA Account Issue</value>
        </criteriaItems>
        <description>If an Issue with Priority = Urgent has not been closed within 4 hours from the 
time of creation, the Application sends a notification to the Issue owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_For_Urgent_Priority_Cases</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Received</fullName>
        <actions>
            <name>Email_sent_to_case_creator</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Thread</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Employer Group Portal Account Update Error</value>
        </criteriaItems>
        <description>Sent to users when they email SFDCSupport@Carefirst.com</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ZZ SFDC Email Support</fullName>
        <actions>
            <name>SFDC_Support_Queue</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email,Email Thread</value>
        </criteriaItems>
        <description>Send to SFDC Team when email is sent to queue</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case Acceptance</fullName>
        <actions>
            <name>Update_Case_Received_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Status_To_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow will be triggered when a case is accepted by an internal User</description>
        <formula>(RecordType.DeveloperName ='SBU_Group_Case' || RecordType.DeveloperName ='SBU_Member_Case' ||  RecordType.DeveloperName ='SBU_Non_Member_Case' ||  RecordType.DeveloperName ='SBU_Broker_Support_Internal') &amp;&amp; Owner:User.IsActive &amp;&amp; OR($Profile.Name = "SBU Administrative Assistant", $Profile.Name = "SBU Broker Service Manager",$Profile.Name = "SBU Broker Service Rep") &amp;&amp; isblank( Received_Date__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case Acceptance 01</fullName>
        <actions>
            <name>SBU_Update_Case_Received_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SBU_Update_Case_Status_To_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SBU_Update_Received_Day</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow will be triggered when a case is accepted by an internal User</description>
        <formula>(RecordType.DeveloperName ='SBU_Group_Case' || RecordType.DeveloperName ='SBU_Member_Case' ||  RecordType.DeveloperName ='SBU_Non_Member_Case'  || RecordType.DeveloperName ='SBU_Broker_Support_Internal')  &amp;&amp; Owner:User.IsActive &amp;&amp; OR($Profile.Name = "SBU Administrative Assistant", $Profile.Name = "SBU Broker Service Manager",$Profile.Name = "SBU Broker Service Rep") &amp;&amp; isblank( Received_Date__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case Acceptance 02</fullName>
        <actions>
            <name>SBU_Update_Case_Status_To_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow will be triggered when a case is accepted by an internal User</description>
        <formula>(RecordType.DeveloperName ='SBU_Group_Case' || RecordType.DeveloperName ='SBU_Member_Case' ||  RecordType.DeveloperName ='SBU_Non_Member_Case'  || RecordType.DeveloperName ='SBU_Broker_Support_Internal') &amp;&amp; Owner:User.IsActive &amp;&amp; OR($Profile.Name = "SBU Administrative Assistant", $Profile.Name = "SBU Broker Service Manager",$Profile.Name = "SBU Broker Service Rep")</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case Closed in Fasets</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Facets_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Non-Member Case,Member Case</value>
        </criteriaItems>
        <description>This workflow will send notification to Case owner when a case is closed in facets</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case Closure</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Non-Member Case,Member Case</value>
        </criteriaItems>
        <description>This workflow will be triggered when a case is Closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case Comments Notification</fullName>
        <active>false</active>
        <description>If the case have published comments then the public comments checkbox on case object will be updated to true. Now if this field is true then an email notification will be send to the contact of the case</description>
        <formula>( Public_Case_Comments__c  )=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case Elite SLA Notification 4 hours</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.SLA_Category__c</field>
            <operation>equals</operation>
            <value>Elite</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Assigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In-Queue</value>
        </criteriaItems>
        <description>This workflow will trigger a notification to selected 'Users' when an 'Elite' inquiry is not 'Accepted' from queue within 4 hours after received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case Elite SLA Notification 5 Days</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Member Case,Non-Member Case,SBU Broker Support Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,In-Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SLA_Category__c</field>
            <operation>equals</operation>
            <value>Elite</value>
        </criteriaItems>
        <description>This workflow will trigger a notification to ‘Case Owner’ when an 'Elite' inquiry is not 'Closed' within 5 days.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Case.Received_Day__c</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case Pushed to Queue</fullName>
        <actions>
            <name>SBU_Update_Case_Status_to_In_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR 3 OR 4 OR 7 OR 8) AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Broker Compliance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Platinum Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Non-Platinum Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Broker Sales Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Non-Member Case,Member Case,SBU Broker Support Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Assigned,Awaiting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Broker Escalation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Community Cases</value>
        </criteriaItems>
        <description>This workflow will update the case status to In-Queue when the case is owned by a Queue</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case SLA Notification 14 Days</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Non-Member Case,Member Case,SBU Broker Support Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>In-Queue,Closed</value>
        </criteriaItems>
        <description>This workflow will be used to send notification when the case stays open past 14 Days of case Not being closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Case.Received_Day__c</offsetFromField>
            <timeLength>343</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case SLA Notification 21 Days</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Non-Member Case,Member Case,SBU Broker Support Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>In-Queue,Closed</value>
        </criteriaItems>
        <description>This workflow will be used to send notification when the case stays open past 21 Days of case Not being closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Case.Received_Day__c</offsetFromField>
            <timeLength>511</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case SLA Notification 7 Days</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Non-Member Case,Member Case,SBU Broker Support Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>In-Queue,Closed</value>
        </criteriaItems>
        <description>This workflow will be used to send notification when the case stays open past 7 Days of case Not being closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Case.Received_Day__c</offsetFromField>
            <timeLength>175</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Case in Progress</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Non-Member Case,Member Case,SBU Broker Support Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Phone</value>
        </criteriaItems>
        <description>This workflow will send Notification to the contact when the case has contact associated to it .</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Change Web Case Owner to Queue</fullName>
        <actions>
            <name>Change_Web_Case_Owner_to_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In-Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Customer Community Plus Login User</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Customer Community Plus User</value>
        </criteriaItems>
        <description>This workflow will change the case owner of a community Created case into a Community Case Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Internal%3A Case has comment</fullName>
        <active>false</active>
        <description>This workflow will send notification to ‘Case Owner’ when there’s a ‘New Comment’ added to an inquiry which is still ‘In-Progress’.</description>
        <formula>(RecordType.DeveloperName ='SBU_Group_Case' || RecordType.DeveloperName ='SBU_Member_Case' ||  RecordType.DeveloperName ='SBU_Non_Member_Case') &amp;&amp;  NOT(ISPICKVAL(Status, 'Closed')) &amp;&amp;  ISCHANGED( Case_Comment_Count__c ) &amp;&amp; ( ISPICKVAL($User.UserType, 'PowerCustomerSuccess') || ISPICKVAL($User.UserType, 'CustomerSuccess') )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Internal%3A New Email</fullName>
        <active>false</active>
        <description>This workflow will send notification to ‘Case Owner’ when there’s a ‘New Email’ added to an inquiry which is still ‘In-Progress’.</description>
        <formula>(RecordType.DeveloperName ='SBU_Group_Case' || RecordType.DeveloperName ='SBU_Member_Case' ||  RecordType.DeveloperName ='SBU_Non_Member_Case') &amp;&amp;  NOT(ISPICKVAL(Status, 'Closed')) &amp;&amp;  ISCHANGED( Number_of_Emails_Received__c ) &amp;&amp; (Number_of_Emails_Received__c &gt; 0) &amp;&amp; BEGINS( $User.Username , 'spmss.process@carefirst.com')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Notify owner on New Email to Closed Case</fullName>
        <actions>
            <name>Update_New_Email_Field_to_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This worflow will Notify a case owner when there is a new email on a closed case.</description>
        <formula>New_Email__c &gt; 0 &amp;&amp; (RecordType.DeveloperName ='SBU_Group_Case' || RecordType.DeveloperName ='SBU_Member_Case' ||  RecordType.DeveloperName ='SBU_Non_Member_Case')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Reset Reason Code to Null</fullName>
        <actions>
            <name>Update_Reason_Code_to_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow will send notification to Case owner when a case is closed in facets</description>
        <formula>AND(ISPICKVAL(PRIORVALUE( Status  ), "Closed"), ISPICKVAL( Status , "In Progress"), (RecordType.DeveloperName ='SBU_Group_Case' || RecordType.DeveloperName ='SBU_Member_Case' ||  RecordType.DeveloperName ='SBU_Non_Member_Case') )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Update Case Owner to Elite Queue</fullName>
        <actions>
            <name>BSSWF_Update_Case_Owner_to_Elite_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.SLA_Category__c</field>
            <operation>equals</operation>
            <value>Elite</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Member Case,Non-Member Case,SBU Broker Support Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In-Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Phone,In-Person Conversation,Correspondence</value>
        </criteriaItems>
        <description>Change Case Owner to Elite Queue when SLA Category changes to Elite</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Update Case Owner to Preferred Queue</fullName>
        <actions>
            <name>BSSWF_Update_Case_Owner_to_Preferred_Que</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.SLA_Category__c</field>
            <operation>equals</operation>
            <value>Preferred</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Member Case,Non-Member Case,SBU Broker Support Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In-Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Phone,In-Person Conversation,Correspondence</value>
        </criteriaItems>
        <description>Change Case Owner to Preferred Queue when SLA Category changes to Preferred</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Update Case Owner to Premier Queue</fullName>
        <actions>
            <name>BSSWF_Update_Case_Owner_to_Premier_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.SLA_Category__c</field>
            <operation>equals</operation>
            <value>Premier</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Member Case,Non-Member Case,SBU Broker Support Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In-Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Phone,In-Person Conversation,Correspondence</value>
        </criteriaItems>
        <description>Change Case Owner to Premier Queue when SLA Category changes to Premier</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Update Case Owner to SELECT Queue</fullName>
        <actions>
            <name>BSSWF_Update_Case_Owner_to_SELECT_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.SLA_Category__c</field>
            <operation>equals</operation>
            <value>Select</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Group Case,Member Case,Non-Member Case,SBU Broker Support Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In-Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Phone,In-Person Conversation,Correspondence</value>
        </criteriaItems>
        <description>Change Case Owner to SELECT Queue when SLA Category changes to SELECT</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Update SLA Category Elite</fullName>
        <actions>
            <name>Update_BST_to_Elite</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_SLA_to_Elite</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_priority_to_high</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Contact_Tier_Level__c</field>
            <operation>equals</operation>
            <value>Elite</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Community User Contact</value>
        </criteriaItems>
        <description>Change SLA Category to "Elite" when Tier Level on contact changes to "Elite"</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Update SLA Category to Preferred</fullName>
        <actions>
            <name>Update_BST_to_Preferred</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_SLA_to_Preferred</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_priority_to_Medium</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Contact_Tier_Level__c</field>
            <operation>equals</operation>
            <value>Preferred</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Community User Contact</value>
        </criteriaItems>
        <description>Change SLA Category to "Preferred" when Tier Level on contact changes to "Preferred"</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Update SLA Category to Premier</fullName>
        <actions>
            <name>Update_BST_to_Premier</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_SLA_to_Premier</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_priority_to_high</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Contact_Tier_Level__c</field>
            <operation>equals</operation>
            <value>Premier</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Community User Contact</value>
        </criteriaItems>
        <description>Change SLA Category to "Premier" when Tier Level on contact changes to "Premier"</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWF Update SLA Category to Select</fullName>
        <actions>
            <name>Update_BST_to_Small_Medium_Group</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_SLA_Category_to_Select</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_priority_to_Medium</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Contact_Tier_Level__c</field>
            <operation>equals</operation>
            <value>SELECT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Community User Contact</value>
        </criteriaItems>
        <description>Change SLA Category to "SELECT" when Tier Level on contact changes to "SELECT"</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_BSSWV Populate Group ID</fullName>
        <actions>
            <name>Update_Group_ID_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow will be used to update group ID field on case. The work flow will re-evaluate every time the criteria matches on the record and will update group ID on case where group Id is changed and  is not routed to facets or closed on contact</description>
        <formula>(RecordType.DeveloperName ='SBU_Group_Case' || RecordType.DeveloperName ='SBU_Member_Case' ||  RecordType.DeveloperName ='SBU_Broker_Support_Internal' || RecordType.DeveloperName ='SBU_Non_Member_Case') &amp;&amp;  (ISCHANGED( Group__c ) ||  ISNEW() ) &amp;&amp; NOT(ISPICKVAL(Status, "Closed") &amp;&amp;  ISPICKVAL( Facets_Status__c, "Closed" )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_Case Comments Notification</fullName>
        <actions>
            <name>Update_the_Public_Case_Comment_Field_Nul</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>If the case have published comments then the public comments checkbox on case object will be updated to true. Now if this field is true then an email notification will be send to the contact of the case</description>
        <formula>( Public_Case_Comments__c )=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ_Update Resolution Reason posted Date</fullName>
        <actions>
            <name>BSSWF_Resolution_Reason_date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Broker_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Update Resolution Reason posted Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
