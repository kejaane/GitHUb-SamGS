<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>APT_Notify_SAS</fullName>
        <ccEmails>strategicaccountsolutions@carefirst.com</ccEmails>
        <description>APT Notify SAS</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Administration/APT_Created_Or_Updated</template>
    </alerts>
    <rules>
        <fullName>APT Created Or Updated</fullName>
        <actions>
            <name>APT_Notify_SAS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Executes every time an APT record is created or edited</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
