/*===================================================================================================
 * Date         : 01/06/2018
 * Developer    : Sree Uma Ponnoju
 * Purpose      : To calculate pre callout timestamp for integration logging
 *===================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+==========================================================================
 * 01/06/18  |       Sree Uma Ponnoju       | Initial Version
 *===========+============+==========================================================================
 */


 public with sharing class IntegrationRequest extends IntegrationMessage {
    
    private DateTime treq = System.now();
    public Integer Req_ts = 0;
    public boolean isValid = true;  // default

    public IntegrationRequest() {
        super();
        this.msgType = IntegrationMessage.REQUEST;
        this.isValid = true;    // by default 
        transactionID = TransactionManager.getTransactionID();
        
        String year= string.valueOf(treq.year());
        String month = string.valueOf(treq.month());
        String day = string.valueOf(treq.day());
        String hour = string.valueOf(treq.hour());
        String minute = string.valueOf(treq.minute());
        String second = string.valueOf(treq.second());
        String millisecond = string.valueOf(treq.millisecond());
        System.debug('The Value of millisecond is REQUEST CLASS '+ millisecond);
        
        this.rqTimeStp =  year+'-'+month+'-'+day+'-'+hour+'-'+minute+'-'+second+'-'+millisecond;
        System.debug('The Value of this.rqTimeStp '+rqTimeStp );
        // Capure timstamp in milliseconds, to be used in response time calculation
        //Calculationg pre callout timestamp        
        this.Req_ts = (treq.minute()*60000) + (treq.second()*1000) + (treq.millisecond()); 
        System.debug('The Value of this.Req_ts ' +this.Req_ts);
        
    }
    public boolean isValid() {
        return isValid;
    }
 
    public void setIsValid(boolean isValid) { 
        this.isValid = isValid; 
        result = isValid? IntegrationMessage.STATUS_SUCCESS : IntegrationMessage.STATUS_ERROR;
    }
    
   
}