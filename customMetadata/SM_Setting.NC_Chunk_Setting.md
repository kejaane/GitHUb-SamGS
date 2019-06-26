<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>NC Chunk Setting</label>
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
        <value xsi:type="xsd:double">3.0</value>
    </values>
    <values>
        <field>Record_Description__c</field>
        <value xsi:type="xsd:string">This record is used to control the number of sandboxes that are passed to the QueueableDispatch class for processing in chunks.  This helps to reduce the number of Queueables executed and also reduces the overall possible Timeout that can occur if a given call-out takes too long to process.  The values entered can be from 1 to 10.  

This record uses the &apos;Number&apos; field only.</value>
    </values>
    <values>
        <field>Text_Area_255__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
