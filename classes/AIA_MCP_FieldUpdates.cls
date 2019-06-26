/*===========================================================================================================================
* Date         : 8/31/2017
* Developer    : Sajitha Y
* Purpose      : Benefit Design Form MCP US-123.
*============================================================================================================================
*                                 Update History
*                                 --------------
* Date       |  Developer       | Tag | Description
*============+==================+=====+======================================================================================
* 08/31/2017 |  Sajitha Y       |     | Initial Version
* 12/22/2017 |  Asif Kutagulla  |     | Commented because no other class is calling this class
*============+==================+=====+======================================================================================
*/
public class AIA_MCP_FieldUpdates{
	/****************Commented because no other class is calling this class******************
    // Method to populate fields during update operation
    public static void updatevendorph(list<AIA_Benefit_Design_Form__c> lstBDf){
        for(AIA_Benefit_Design_Form__c bdf :lstBDf)
        {
            if(bdf.Vendor_Name__c == 'Care Management - Includes IP mental health/substance abuse'){
                bdf.Vendor_Phone__c='1-866-773-2884';
                bdf.MCP_Other_Vendor_Name__c ='';
                bdf.MCP_Other_Vendor_Phone__c ='';
            }
            else if(bdf.Vendor_Name__c == 'Care Management & Magellan Mental Health /Substance Abuse'){
                bdf.Vendor_Phone__c='1-866-773-2884 – Care Management,1-800-245-7013 – Magellan'; 
                bdf.MCP_Other_Vendor_Name__c ='';
                bdf.MCP_Other_Vendor_Phone__c ='';
            }
            else if(bdf.Vendor_Name__c == 'Other')
                bdf.Vendor_Phone__c='';
            if(bdf.Funding_Arrangement__c=='ASO' && bdf.Integrated_DM_Wellness__c=='Yes')
            {
                bdf.Stand_Alone_Disease_Management__c='No';
                bdf.Stand_Alone_Wellness__c='No';
                bdf.Customized_Wellness_Services__c='No';
            }
        }       
    }
	*****************************************************************************************/
}