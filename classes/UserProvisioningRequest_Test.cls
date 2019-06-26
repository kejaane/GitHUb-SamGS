@isTest()
public class UserProvisioningRequest_Test {

    static testmethod  void TestUserProvisioningRequest(){ 
    
    Map<String,String> att = new map <String, String> ();
    
    Map<String,String> att1 = new map <String, String> ();
        
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
    
    UserProvisioningRequest req = new UserProvisioningRequest( att );
        UserProvisioningRequest req2 = new UserProvisioningRequest( att1 );
    UserProvisioningRequest req1 = new UserProvisioningRequest();
    
    req.relatedRecords = att;
    
    
    }
    }