/*=========================================================================================
 * Date         : 01/25/2018
 * Developer    : Gayathri Palanisamy
 * Purpose      : This is the controller class for the Lightning Component AIA_HomePage_CustomLinks.
 *                It will contain method to get the parameter values from AIA Configuration Metadata type.
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer          Tag        Description
 *===========+=================+=====+===========================================================
 *=========================================================================================
 */

public with sharing class AIA_HomePage_CustomLinks_Controller {

    //Method to retun map for assigning the URL's of the links in Lightning Home Page
    @AuraEnabled
    public static Map<String,String> getUrl()
    {
        Map<String,String> parameterValue = new Map<String,String>();
        List<AIA_Configurations__mdt> AIAConfig = [Select id,DeveloperName,Parameter_Value__c from AIA_Configurations__mdt];
    	for(AIA_Configurations__mdt config:AIAConfig)
        {
            parameterValue.put(config.DeveloperName,config.Parameter_Value__c);
        }
    	return parameterValue;
    }
        
         
}