/*
**********************************************************************************************
* Date         : 09/03/2018
* Developer    : Debkanti
* Purpose      : This is the test class for AIA_Record_Approval_Message_Controller
**********************************************************************************************
*                    =======[Update History]======= 
* Date           Developer          Tag        Description
**********************************************************************************************
* 09/03/2018     Debkanti                      Initial build

********************************************************************************************** */
@istest
public class AIA_Record_Approval_Message_Con_Test {
    public static testmethod void testerrormsgs(){
        AIA_Record_Approval_Message_Controller obj = new AIA_Record_Approval_Message_Controller();
        obj.displayMsg = 'Test msg';
        obj.displayMsgEnd = 'Test Msg end';
        AIA_Record_Approval_Message_Controller.getMsg();
        
    }
}