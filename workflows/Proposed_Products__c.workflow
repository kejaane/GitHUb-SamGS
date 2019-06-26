<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AIA_Blue_Rewards_for_Risk</fullName>
        <field>Blue_Rewards__c</field>
        <literalValue>Standard</literalValue>
        <name>AIA Blue Rewards for Risk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_DM_Wellness_Field_Update</fullName>
        <field>DM_Wellness_Rules1__c</field>
        <formula>'&lt;img src="/servlet/servlet.FileDownload?file=0150z000001lF1P"&gt;&lt;/img&gt;'</formula>
        <name>AIA DM/Wellness Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_RX_Integration_ARC_Approval</fullName>
        <field>Is_RX_Integration_ARC_Approval_Required__c</field>
        <literalValue>1</literalValue>
        <name>AIA RX Integration ARC Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIA_Update_Count_Of_Network_In_PP</fullName>
        <description>This field update is used to update the count of network field from plan object Count of Networks field</description>
        <field>Count_of_Network_Drawloop__c</field>
        <formula>Plan_Name__r.CountOfNetworks__c</formula>
        <name>AIA Update Count Of Network In PP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Proposed_Product_is_prepopulated_Risk</fullName>
        <description>If Funding Arrangement on the Benefit Request Form = “Risk”, then the Funding Arrangement on the Proposed Product is prepopulated as “Risk”</description>
        <field>Funding_Arrangement__c</field>
        <literalValue>Risk</literalValue>
        <name>Proposed Product is prepopulated “Risk"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Proposed_Product_is_prepopulated_as_ASO</fullName>
        <description>If Funding Arrangement on the Benefit Request Form = “ASO”, then the Funding Arrangement on the Proposed Product is prepopulated as “ASO”</description>
        <field>Funding_Arrangement__c</field>
        <literalValue>ASO</literalValue>
        <name>Proposed Product is prepopulated “ASO"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proposed_Products_with_Non_Grand</fullName>
        <description>If Benefit Request Form is of type Non-Grandfathered then PP should be populated with "Non-Grandfatherd"</description>
        <field>Grandfathered_Status__c</field>
        <literalValue>Non-Grandfathered</literalValue>
        <name>Update Proposed Products with Non-Grand</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_of_Grandfatherd_Status_On_PP</fullName>
        <description>If the Benefit Request Form is of type "Grandfathered" then Proposed Products should be populated as Grandfathered</description>
        <field>Grandfathered_Status__c</field>
        <literalValue>Grandfathered</literalValue>
        <name>Update of Grandfatherd Status On PP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AIA Blue Rewards for Risk</fullName>
        <actions>
            <name>AIA_Blue_Rewards_for_Risk</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Proposed_Products__c.Funding_Arrangement__c</field>
            <operation>equals</operation>
            <value>Risk</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AIA Proposed Product DM%2FWellness Rules</fullName>
        <actions>
            <name>AIA_DM_Wellness_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Proposed_Products__c.Product_Category__c</field>
            <operation>equals</operation>
            <value>Medical</value>
        </criteriaItems>
        <criteriaItems>
            <field>Proposed_Products__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Medical ASO,Medical Risk</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AIA RX Integration ARC Approval</fullName>
        <actions>
            <name>AIA_RX_Integration_ARC_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(RXIntegration__c =='Integrated', RXIntegration__c =='Integrated - Carved-Out'), OR((TEXT(Out_of_Pocket_Max__c)!= Text(Related_Medical_Product__r.Out_of_Pocket_Max__c)),(TEXT(Deductible__c)!= Text(Related_Medical_Product__r.Deductible__c))) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AIA Update Count of Network</fullName>
        <actions>
            <name>AIA_Update_Count_Of_Network_In_PP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is used to update the count of network from Plan to PP</description>
        <formula>Not(ISBLANK( Plan_Name__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Proposed Product is populated with GrandFathered Status</fullName>
        <actions>
            <name>Update_of_Grandfatherd_Status_On_PP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Grandfathered_Status__c</field>
            <operation>equals</operation>
            <value>Grandfathered</value>
        </criteriaItems>
        <description>If Grandfathered status on Benefit Request form is "Grandfathered" then the Grandfathered status on Proposed Products should be populated as "Grandfatehred"</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Proposed Product is populated with Non-GrandFathered Status</fullName>
        <actions>
            <name>Update_Proposed_Products_with_Non_Grand</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Grandfathered_Status__c</field>
            <operation>equals</operation>
            <value>Non-Grandfathered</value>
        </criteriaItems>
        <description>If Grandfathered status on Benefit Request form is "Non-Grandfathered" then the Grandfathered status on Proposed Products should be populated as "Grandfatehred"</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Proposed Product is prepopulated as ASO</fullName>
        <actions>
            <name>Proposed_Product_is_prepopulated_as_ASO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Funding_Arrangements__c</field>
            <operation>equals</operation>
            <value>ASO</value>
        </criteriaItems>
        <description>If Funding Arrangement on the Benefit Request Form = “ASO”, then the Funding Arrangement on the Proposed Product is prepopulated as “ASO”</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Proposed Product is prepopulated as Risk</fullName>
        <actions>
            <name>Proposed_Product_is_prepopulated_Risk</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Benfit_Request_Form__c.Funding_Arrangements__c</field>
            <operation>equals</operation>
            <value>Risk</value>
        </criteriaItems>
        <description>If Funding Arrangement on the Benefit Request Form = “Risk”, then the Funding Arrangement on the Proposed Product is prepopulated as “Risk”</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA Identity Protection Mandate For ASO</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Proposed_Products__c.Funding_Arrangement__c</field>
            <operation>equals</operation>
            <value>ASO</value>
        </criteriaItems>
        <description>For ASO Medical Products, Identity Production Mandate should be Null by default</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA Identity Protection Mandate For DC%2FVA</fullName>
        <active>false</active>
        <booleanFilter>(1 AND 2) AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Proposed_Products__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Medical</value>
        </criteriaItems>
        <criteriaItems>
            <field>Proposed_Products__c.Funding_Arrangement__c</field>
            <operation>equals</operation>
            <value>Risk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Proposed_Products__c.Jurisdiction__c</field>
            <operation>equals</operation>
            <value>DC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Proposed_Products__c.Jurisdiction__c</field>
            <operation>equals</operation>
            <value>VA</value>
        </criteriaItems>
        <description>For Risk Medical Products, if the jurisdiction is "DC/VA" then Identity Production Mandate should be only "Yes"</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZZ AIA Identity Protection Mandate For MD</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Proposed_Products__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Medical</value>
        </criteriaItems>
        <criteriaItems>
            <field>Proposed_Products__c.Funding_Arrangement__c</field>
            <operation>equals</operation>
            <value>Risk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Proposed_Products__c.Jurisdiction__c</field>
            <operation>equals</operation>
            <value>MD</value>
        </criteriaItems>
        <description>For Risk Medical Products, if the jurisdiction is "MD" then Identity Production Mandate should be only "NO"</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
