<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Profile Audit: Exclude Frozen Users</label>
    <protected>false</protected>
    <values>
        <field>Checkbox__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Module_Name__c</field>
        <value xsi:type="xsd:string">Profile Audit</value>
    </values>
    <values>
        <field>Number__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Record_Description__c</field>
        <value xsi:type="xsd:string">This record is used to support a profile audit in production and sandboxes.  

If the checkbox is checked then the PA Audit process does not include a user who is frozen; otherwise, they are included in the Sandbox Manager Log.  

This record uses the &apos;Checkbox&apos; field only.</value>
    </values>
    <values>
        <field>Text_Area_255__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
