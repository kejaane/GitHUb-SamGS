<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Profile Audit: Sandbox Limit List</label>
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
        <value xsi:type="xsd:string">This record controls which sandboxes are audited.  If you leave the &apos;Text Area 255&apos; field blank then all sandboxes that are setup through Named Credentials will be used; otherwise, the sandboxes listed are used. Separate sandbox names by a comma only.

This record uses the &apos;Text Area 255&apos; field only.</value>
    </values>
    <values>
        <field>Text_Area_255__c</field>
        <value xsi:type="xsd:string">int, uat, techtest</value>
    </values>
</CustomMetadata>
