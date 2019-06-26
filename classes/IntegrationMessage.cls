/*=========================================================================================
 * Date         : 10/21/2014
 * Developer    : Ken Gill
 * Purpose      : This is a base class to represent any kind of request or response
 *                It implements the necessary interface and fields to allow participation in the Integration
 *                logging and transaction frameworks.
 *                
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/21/14  |  KG    | Initial Version                                         
 *           |        | 
 * 01/06/18  |Sree Uma Ponnoju |[US514] Additional structured data to be passed into logger
 *===========+============+================================================================
 */

 public virtual class IntegrationMessage {

 public static final String REQUEST = 'REQUEST';
 public static final String RESPONSE = 'RESPONSE';
 
 public static final String STATUS_SUCCESS= 'SUCCESS';
 public static final String STATUS_ERROR = 'ERROR';
 public static final String SOURCE_ERROR = 'SOURCE_ERROR';
 public static final String REMOTE_ERROR = 'REMOTE_ERROR';
 
  public Datetime timeStamp { get; set; }
  public Integer  transactionID { get; set; }
  public String  result { get; set; }
  public String  msgType    { get; set; }
  public String  source { get; set; }
  public String  sourceAddress  { get; set; }
  public String  target { get; set; }
  public String  targetAddress  { get; set; } 
  public String  msgData    { get; set; }
  public String  relatedData    { get; set; }
  
  //US514 - Additional structured data to be passed into logger 
  public String  responseStatus { get; set; }
  public String responseStatusCode {get; set; }
  public String responseStatusDescription {get; set;} 
  public String responseTime { get; set; }
  public String rqTimeStp{ get; set; }
  public String rsTimeStp{ get; set; } 
  public Integer attchSize{ get; set;}
   
  public IntegrationMessage() {
    
    timeStamp = TransactionManager.timeStamp();
     transactionID = TransactionManager.getTransactionID();
  }
 }