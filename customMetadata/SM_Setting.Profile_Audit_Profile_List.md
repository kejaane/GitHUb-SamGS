<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Profile Audit: Profile List</label>
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
        <value xsi:type="xsd:string">This record is used to support a profile audit in production and sandboxes.  Enter profile names  in the &apos;Text Area 255&apos; field separated by comma that should be audited.  If left blank the default will be &apos;System Administrator&apos;.

This record uses the &apos;Text Area 255&apos; field only.</value>
    </values>
    <values>
        <field>Text_Area_255__c</field>
        <value xsi:type="xsd:string">System Administrator, System Administrator - Custom, System Administrator - Read Only, System Administrator 2FA - custom</value>
    </values>
</CustomMetadata>
