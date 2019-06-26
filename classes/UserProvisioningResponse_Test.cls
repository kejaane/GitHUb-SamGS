@isTest()
public class UserProvisioningResponse_Test {


    static testmethod  void TestUserProvisioningResponse(){ 
    
    
    
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
    
    
    UserProvisioningRequest req = new UserProvisioningRequest( att );
    UserProvisioningService.Configuration cfg = new UserProvisioningService.Configuration();
    UserProvisioningService.Response resp = new UserProvisioningService.Response(0,'Success');
    
    UserProvisioningResponse res = new UserProvisioningResponse(req);
    UserProvisioningResponse res1 = new UserProvisioningResponse (req, resp, cfg);
    
    res.setServiceResponse(resp);
    res1.setServiceResponse(resp);
    
    res.setServiceConfiguration(cfg);
    res1.setServiceConfiguration(cfg);
    
    res.status = 'Success';
    res.statusCode = '0';
    res.statusDescription = 'Success Message Description';
    
    }
    }