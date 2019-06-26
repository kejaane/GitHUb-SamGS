<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AIA_Plan_HAsBenefitsSummaryFalse</fullName>
        <field>Has_Benefit_Summary__c</field>
        <literalValue>0</literalValue>
        <name>AIA_Plan_HAsBenefitsSummaryFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Plan_QA_Completed_by</fullName>
        <description>Track who completed QA Complete on AIA Plan.</description>
        <field>QA_Completed_by__c</field>
        <formula>LastModifiedBy.FirstName + ' ' + LastModifiedBy.LastName</formula>
        <name>AIA Plan QA Completed by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Plan_QA_Completed_on</fullName>
        <field>QA_Completed_Date__c</field>
        <formula>LastModifiedDate</formula>
        <name>AIA Plan QA Completed on</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Has_Benefit_Summary_Flag</fullName>
        <field>Has_Benefit_Summary__c</field>
        <literalValue>1</literalValue>
        <name>AIA_Update_Has_Benefit_Summary_Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Product_Category_to_Drug_FU</fullName>
        <field>Product_Category__c</field>
        <literalValue>Drug</literalValue>
        <name>AIA Update Product Category to Drug-FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Product_Last_Updated_Date</fullName>
        <field>Product_Last_Updated__c</field>
        <formula>DATETIMEVALUE( 
LEFT(Product_Last_Updated_String_Format__c , 11) + 
if( CONTAINS(Product_Last_Updated_String_Format__c, 'PM'), (IF(MID(Product_Last_Updated_String_Format__c,13, 2)='12', 
'00', 
TEXT(VALUE(MID(Product_Last_Updated_String_Format__c,13, 2) )+12))), 
MID(Product_Last_Updated_String_Format__c,13,2)) 
+MID(Product_Last_Updated_String_Format__c ,15, 6) )</formula>
        <name>AIA_Update_Product_Last_Updated_Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA Plan QA Completed by</fullName>
        <actions>
            <name>AIA_Plan_QA_Completed_by</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AIA_Plan_QA_Completed_on</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Plan__c.QA_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Track who completed QA Complete on AIA Plan.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Update Product Category to Drug</fullName>
        <actions>
            <name>AIA_Update_Product_Category_to_Drug_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Plan__c.Product_Category__c</field>
            <operation>equals</operation>
            <value>Pharmacy</value>
        </criteriaItems>
        <description>workflow rule is used to update product category to drug if the value received from PCS is pharmacy</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA_Plan_HAsBenefitsSummaryFalse</fullName>
        <actions>
            <name>AIA_Plan_HAsBenefitsSummaryFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Has_Benefit_Summary__c =true, (ISBLANK( Product_Last_Updated_String_Format__c ) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA_Plan_HAsBenefitsSummaryTrue</fullName>
        <actions>
            <name>AIA_Update_Has_Benefit_Summary_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Has_Benefit_Summary__c =false ,  NOT(ISBLANK(Product_Last_Updated_String_Format__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA_Update_Product_Last_Updated_Date</fullName>
        <actions>
            <name>AIA_Update_Product_Last_Updated_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED( Product_Last_Updated_String_Format__c ),  ISCHANGED( Product_Last_Updated__c ),  AND( !ISNULL(Product_Last_Updated_String_Format__c ), OR(ISNEW() ,ISCLONE()) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
