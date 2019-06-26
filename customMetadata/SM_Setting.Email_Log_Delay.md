<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Email Log Delay</label>
    <protected>false</protected>
    <values>
        <field>Checkbox__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Module_Name__c</field>
        <value xsi:type="xsd:string">Application Level</value>
    </values>
    <values>
        <field>Number__c</field>
        <value xsi:type="xsd:double">20.0</value>
    </values>
    <values>
        <field>Record_Description__c</field>
        <value xsi:type="xsd:string">Allows a slight delay before the Log table is read and emailed out.  This is necessary to ensure the log was written to the table before attempting to read it.  The value represents delay in seconds.  

This record uses the &apos;Number&apos; field only.</value>
    </values>
    <values>
        <field>Text_Area_255__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
