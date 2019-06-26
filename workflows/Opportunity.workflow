<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approve_Delivery_Date_Change</fullName>
        <description>Approve Delivery Date Change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Renewal_Delivery_Date_to_Sales_Approved</template>
    </alerts>
    <alerts>
        <fullName>Dead_Renewal_Email_to_be_assigned_a_NB_consultant</fullName>
        <description>Dead Renewal Email to be assigned a NB consultant</description>
        <protected>false</protected>
        <recipients>
            <recipient>Opportunity_Renewal_Marked_Dead</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Administration/Opportunity_Renewal_Marked_Dead</template>
    </alerts>
    <alerts>
        <fullName>NPN_Email_Alert</fullName>
        <ccEmails>Anne.Ward@carefirst.com; Kathy.newson@carefirst.com</ccEmails>
        <description>NPN Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>BCC_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Administration/NPN_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Reject_Delivery_Date_Change</fullName>
        <description>Reject Delivery Date Change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AIA_Email_Templates/AIA_Renewal_Delivery_Date_to_Sales_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>AIAFromOppLineItemopp</fullName>
        <field>AIAFromOpplineItem__c</field>
        <literalValue>0</literalValue>
        <name>AIAFromOppLineItem</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Change_From_Opp</fullName>
        <field>AIAFromOpplineItem__c</field>
        <literalValue>0</literalValue>
        <name>AIA Change From Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Opportunity_Dead_Marked_Date</fullName>
        <field>AIA_Date_of_marked_as_Dead__c</field>
        <formula>NOW()</formula>
        <name>AIA Opportunity Dead Marked Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Approved</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Reject</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>0</literalValue>
        <name>Approval Status Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Delete_Change_Delivery_Date_to_Sales</fullName>
        <field>Change_Renewal_Delivery_Date_to_Sales__c</field>
        <name>Delete Change Delivery Date to Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Renewal_Delivery_Date</fullName>
        <field>Renewal_Delivery_Date_to_Sales__c</field>
        <formula>Account.Final_Renewal_Date__c  - 120</formula>
        <name>Populate Renewal Delivery Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProspectingCloseDate</fullName>
        <field>ProspectingCloseDate__c</field>
        <formula>now()</formula>
        <name>ProspectingCloseDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProspectingCloseDateToNull</fullName>
        <field>ProspectingCloseDate__c</field>
        <name>ProspectingCloseDateToNull</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProspectingDate</fullName>
        <field>ProspectingDate__c</field>
        <formula>now()</formula>
        <name>ProspectingDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_For_Approval</fullName>
        <field>AIA_Approval_Status__c</field>
        <literalValue>1</literalValue>
        <name>Submitted For Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStdProbabilityWithCstProbability</fullName>
        <description>The field update helps to update the standard probability field with the custom probability field value</description>
        <field>Probability</field>
        <formula>Probability_Custom__c</formula>
        <name>UpdateStdProbabilityWithCstProbability</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_RecType_Facets_Account_3</fullName>
        <field>RecType_Facets_Account_Number__c</field>
        <formula>Account.RecordType.Name  +"_"+  LEFT(Facets_Grp_Num__c,4)</formula>
        <name>Update Account RecType_Facets_Account_#3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_With_Opprotunity_Id</fullName>
        <field>Recent_Sold_Opportunity_ID__c</field>
        <formula>Id</formula>
        <name>Update Account With Opprotunity Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Custom_Probability_Field_Dead</fullName>
        <field>Probability_Custom__c</field>
        <formula>0</formula>
        <name>Update Custom Probability Field Dead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Custom_Probability_Field_Sold</fullName>
        <field>Probability_Custom__c</field>
        <formula>1</formula>
        <name>Update Custom Probability Field Sold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Facets_Account_Number</fullName>
        <field>Facets_Account_Number__c</field>
        <formula>LEFT(Facets_Grp_Num__c, 4)</formula>
        <name>Update Facets Account Number from Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Renewal_Delivery_Date_to_Sales</fullName>
        <field>Renewal_Delivery_Date_to_Sales__c</field>
        <formula>Change_Renewal_Delivery_Date_to_Sales__c</formula>
        <name>Update Renewal Delivery Date to Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sold_Date</fullName>
        <field>Sold_Date__c</field>
        <formula>Now()</formula>
        <name>Update Sold Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Std_Probability_Field_Dead</fullName>
        <field>Probability</field>
        <formula>0</formula>
        <name>Update Std Probability Field Dead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Std_Probability_Field_Sold</fullName>
        <field>Probability</field>
        <formula>1</formula>
        <name>Update Std Probability Field Sold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA Change From Opp</fullName>
        <actions>
            <name>AIA_Change_From_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.AIAFromOpplineItem__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Opportunity Dead Marked Date</fullName>
        <actions>
            <name>AIA_Opportunity_Dead_Marked_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Dead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Renewal Delivery Date to Sales on Oppty</fullName>
        <actions>
            <name>Populate_Renewal_Delivery_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AIA Set Opportunity Sold Date</fullName>
        <actions>
            <name>Update_Sold_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Sold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>200+</value>
        </criteriaItems>
        <description>Mark Opportunity as Sold</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA_Opportunity_Recent_Sold</fullName>
        <actions>
            <name>Update_Account_With_Opprotunity_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Sold</value>
        </criteriaItems>
        <description>This workflow rule kicks off when opportunity stage is set to sold then opprotunity record id is updated on Account's Recent_Sold_Opportunity_ID__c field.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BSSWF Populate Facets Account Number from Opp</fullName>
        <actions>
            <name>Update_Facets_Account_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>51+</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Sold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Effective_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_End_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Facets_Grp_Num__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This Workflow will Populate Facets_Account_Number On Customer Account object from the most current Sold 51+ Opportunity</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NPN Update Request</fullName>
        <actions>
            <name>NPN_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AIAFromOppLineItemopp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Request_NPN__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>200+,51+</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.AIAFromOpplineItem__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This workflow rule will be triggered when the 'Request NPN' checkbox is set as true in the Opportunity page. This will trigger an email to the NPN management team to update the NPN on the associated brokers or agencies</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Renewal Marked Dead</fullName>
        <actions>
            <name>Dead_Renewal_Email_to_be_assigned_a_NB_consultant</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Renewal_Dead</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Executed when 51-199 Renewal Opportunity is Marked Dead</description>
        <formula>(ISNEW() || ISCHANGED(StageName)) 
&amp;&amp;
TEXT(StageName) = "Dead" &amp;&amp;
TEXT(Market_Segment_New__c) = "51-199" &amp;&amp;
TEXT(Business_Type__c)  = "Renewal"</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ProspectingCLoseDateToNull</fullName>
        <actions>
            <name>ProspectingCloseDateToNull</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CloseProspect__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospecting</value>
        </criteriaItems>
        <description>This rule makes the field to blank value when the close prospecting check box is false</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ProspectingCloseDate</fullName>
        <actions>
            <name>ProspectingCloseDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CloseProspect__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospecting</value>
        </criteriaItems>
        <description>This rules captures the close date of prospecting Opportunity</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ProspectingDate</fullName>
        <actions>
            <name>ProspectingDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Prospecting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospecting</value>
        </criteriaItems>
        <description>This captures the date of the prospecting opportunity</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update std probability field with custom probability</fullName>
        <actions>
            <name>UpdateStdProbabilityWithCstProbability</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow rule will auto populate the standard probability field with the value in the custom probability field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update the Opportunity Field when marked dead</fullName>
        <actions>
            <name>Update_Custom_Probability_Field_Dead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Std_Probability_Field_Dead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Dead</value>
        </criteriaItems>
        <description>This workflow helps the auto populate the probability field to 0% when stage marked as dead</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update the Opportunity Field when marked sold</fullName>
        <actions>
            <name>Update_Custom_Probability_Field_Sold</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Std_Probability_Field_Sold</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Sold</value>
        </criteriaItems>
        <description>This workflow helps the auto populate the probability field to 100% when stage marked as sold</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Renewal_Dead</fullName>
        <assignedTo>denise.archer@carefirst.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Opportunity Marked as Dead</subject>
    </tasks>
</Workflow>
