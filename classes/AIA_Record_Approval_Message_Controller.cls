/*
 **********************************************************************************************
 * Date         : 23/02/2018
 * Developer    : Debkanti
 * Purpose      : This is the class to fetch the approval message and sned to component
 **********************************************************************************************
 *                    =======[Update History]======= 
 * Date           Developer          Tag        Description
 **********************************************************************************************
 * 23/02/2018     Debkanti 	  					Initial build

 ********************************************************************************************** */

public class AIA_Record_Approval_Message_Controller {
    @AuraEnabled public string displayMsg{get;set;}
    @AuraEnabled public string displayMsgEnd{get;set;}
    @AuraEnabled
     public static AIA_Record_Approval_Message_Controller getMsg(){
         AIA_Record_Approval_Message_Controller obj = new AIA_Record_Approval_Message_Controller();
         obj.displayMsg = AIA_Constants.approvalMsg;
         obj.displayMsgEnd = AIA_Constants.approvalMsgEnd;
         System.debug('Messageis: '+obj.displayMsg);
         return obj;
     }

}