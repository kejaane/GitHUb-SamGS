/*=========================================================================================
 * Date         : 06/19/2017
 * Developer    : Seyitbek Usmanov
 * Purpose      : This is a test class for UserProvisioningContactCreator
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 06/19/17  |  SU    | Initial Version                                         
 *           |        | 
 *=========================================================================================
 */
 
 
@isTest()
public class UserProvisioningContactCreator_Tests {


    static testmethod  void TestContactCreation(){
        UserProvisioningService.Configuration cfg = new UserProvisioningService.Configuration();
        
       // cfg.communityContactRecordTypeID =  '012110000005OXvAAM';
        string RtId = querybase.getRecordtypeId('contact', 'Community_User_Contact');
        cfg.communityContactRecordTypeID = rtid;
        Map<String,String> att = new map <String, String> ();
        
        att.put('TRN_MSG_TYPE','BAA');
        att.put('UID','FF117-9992003301');
        att.put('USER_ID','spmss.process@carefirst');
        att.put('FRST_NM','Seyit');
        att.put('MID_NM','Nothing');
        att.put('LAST_NM','Usmanov');
        att.put('EMAL_ADDR','usmanoff@man.com');
        att.put('SSN','123321456');
        att.put('BRKR_TITL','Principal Broker');
        att.put('TAX_IDNTN_NBR','101123332');
        att.put('DSTBR_NM','Kyrgyzstan');
        att.put('ASST_BRKR_INDC','N');
    
UserProvisioningContactCreator ucc = new UserProvisioningContactCreator(att,cfg);

//User U = [Select ID from user where username = 'spmss.process@carefirst.com.dev3'];

//System.runas (u) {
//System.enqueueJob(ucc);
Test.starttest();
ID JID = System.enqueueJob(ucc);
Test.stoptest();
//}

}

}