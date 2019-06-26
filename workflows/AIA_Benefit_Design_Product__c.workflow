<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AIA_ACIN_Defalut_Value_DC</fullName>
        <description>0391</description>
        <field>ACIN__c</field>
        <formula>"MDC1"</formula>
        <name>AIA ACIN Defalut Value - DC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_ACIN_Defalut_Value_MD</fullName>
        <description>3910</description>
        <field>ACIN__c</field>
        <formula>"MMD1"</formula>
        <name>AIA ACIN Defalut Value - MD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_ACIN_Defalut_Value_VA</fullName>
        <description>3910</description>
        <field>ACIN__c</field>
        <formula>"MVA1"</formula>
        <name>AIA ACIN Defalut Value - VA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_PCAG_Default_Non_Risk</fullName>
        <description>03910</description>
        <field>PCAG__c</field>
        <formula>"DNOR"</formula>
        <name>AIA PCAG Default - Non Risk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_PCAG_Default_Risk</fullName>
        <description>03910</description>
        <field>PCAG__c</field>
        <formula>"DRSK"</formula>
        <name>AIA PCAG Default -  Risk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Count_Of_Network_In_BDP</fullName>
        <description>This field update is used to update the count of network field from plan object Count of Networks field</description>
        <field>Count_of_Network_Drawloop__c</field>
        <formula>Plan_Name__r.CountOfNetworks__c</formula>
        <name>AIA Update Count Of Network In BDP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA ACIN Defalut Value - DC</fullName>
        <actions>
            <name>AIA_ACIN_Defalut_Value_DC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design_Product__c.Jurisdiction__c</field>
            <operation>equals</operation>
            <value>DC</value>
        </criteriaItems>
        <description>User Story  03910 2.ACIN (data type: text) - Help Text: Claim Interest - default value per jurisdiction -  
MDC1(DC)

MMD1(MD) 

MVA1(VA)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AIA ACIN Defalut Value - MD</fullName>
        <actions>
            <name>AIA_ACIN_Defalut_Value_MD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design_Product__c.Jurisdiction__c</field>
            <operation>equals</operation>
            <value>MD</value>
        </criteriaItems>
        <description>User Story  03910 2.ACIN (data type: text) - Help Text: Claim Interest - default value per jurisdiction -  
MDC1(DC)

MMD1(MD) 

MVA1(VA)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AIA ACIN Defalut Value - VA</fullName>
        <actions>
            <name>AIA_ACIN_Defalut_Value_VA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design_Product__c.Jurisdiction__c</field>
            <operation>equals</operation>
            <value>VA</value>
        </criteriaItems>
        <description>User Story  03910 2.ACIN (data type: text) - Help Text: Claim Interest - default value per jurisdiction -  
MDC1(DC)

MMD1(MD) 

MVA1(VA)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AIA PCAG Default -  Risk</fullName>
        <actions>
            <name>AIA_PCAG_Default_Risk</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design_Product__c.Funding_Arrangement__c</field>
            <operation>equals</operation>
            <value>Risk</value>
        </criteriaItems>
        <description>14.PCAG (data type: text) - default value per Funding Arrangement value -  
DNOR      (Non-Risk)

DRSK     (Risk)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AIA PCAG Default - Non Risk</fullName>
        <actions>
            <name>AIA_PCAG_Default_Non_Risk</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIA_Benefit_Design_Product__c.Funding_Arrangement__c</field>
            <operation>equals</operation>
            <value>ASO</value>
        </criteriaItems>
        <description>14.PCAG (data type: text) - default value per Funding Arrangement value -  
DNOR      (Non-Risk)

DRSK     (Risk)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AIA Update Count Of Network In BDP</fullName>
        <actions>
            <name>AIA_Update_Count_Of_Network_In_BDP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is used to update the count of network from Plan to BDP</description>
        <formula>Not(ISBLANK( Plan_Name__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ testing</fullName>
        <active>false</active>
        <criteriaItems>
            <field>AIA_Benefit_Design_Product__c.drawloop_product__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
