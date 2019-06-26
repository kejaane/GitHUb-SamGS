/************************************************************************************************************
 *  Class            : Messages_And_Alerts_Controller
 *  Author           : Arshia Gulati
 *  Description      : Message alert on Home Page to switch to Google Chrome for better Lightning experience.
 *                          
 * ----------------------------------------------------------------------------------------------------------
 *  Author          Date-Modified      Tag      Description of Change
 * ----------------------------------------------------------------------------------------------------------
 *
 */
public class Messages_And_Alerts_Controller {
    public Boolean IsClassic{get; set;}
    public string ChromeMessage{get; set;}    
 	public Messages_And_Alerts_Controller(ApexPages.StandardController controller){
     	User objUser = (User)controller.getRecord();
     	IsClassic = AIA_Utils.isClassic();
        List<Messages_and_Alerts__mdt> objConfig = [Select id,DeveloperName,Parameter_Value__c from Messages_and_Alerts__mdt];
    	for(Messages_and_Alerts__mdt config:objConfig)
        {
            if(config.DeveloperName=='Messages_and_Alerts')
            {
                ChromeMessage = config.Parameter_Value__c;
            }
        }     	
   }   
}