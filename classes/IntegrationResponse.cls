/*===================================================================================================
 * Date         : 01/06/2018
 * Developer    : Sree Uma Ponnoju
 * Purpose      : To calculate post callout timestamp and response time for integration logging
 *===================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+==========================================================================
 * 01/06/18  |       Sree Uma Ponnoju       | Initial Version
 *===========+============+==========================================================================
 */
 
 public with sharing class IntegrationResponse extends IntegrationMessage {

    private DateTime tres = System.now();
    public Integer Res_ts = 0;
    
    public IntegrationResponse(IntegrationRequest request) {
        super();
        msgType = IntegrationMessage.RESPONSE;
        system.debug('msgType value is : ' +msgType);
        
        this.source = request.source;
        this.target = request.target;
        this.sourceAddress = request.sourceAddress;
        this.targetAddress = request.targetAddress;
        this.transactionID = request.transactionID;
         
        String year= string.valueOf(tres.year());
        String month = string.valueOf(tres.month());
        String day = string.valueOf(tres.day());
        String hour = string.valueOf(tres.hour());
        String minute = string.valueOf(tres.minute());
        String second = string.valueOf(tres.second());
        String millisecond = string.valueOf(tres.millisecond());        
        System.debug(' The Value of millisecond in RESPONSE CLASS is '+ millisecond);         
        
        this.rsTimeStp =  year+'-'+month+'-'+day+'-'+hour+'-'+minute+'-'+second+'-'+millisecond;
        System.debug('The Value of this.rsTimeStp in RESPONSE CLASS is '+rsTimeStp );
        
        this.rqTimeStp = request.rqTimeStp;        
        //Calculating post callout timestamp
        this.Res_ts = (tres.minute()*60000) + (tres.second()*1000) + (tres.millisecond());
        system.debug('this.Res_ts value in RESPONSE CLASS is ' +this.Res_ts);
        
        //Calculating difference between pre and post callout timestamps
        this.responseTime = (this.Res_ts-request.Req_ts) + ' milliseconds';
        system.debug('responseTime value in RESPONSE CLASS is ' +this.responseTime);
    }
}