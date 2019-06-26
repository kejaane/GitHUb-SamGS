/*===================================================================================================
 * Date         : 11/14/2014
 * Developer    : Kirat Gill
 * Purpose      : This is a base class to log any kind of request or response
 *                as part of Integration logging and transaction frameworks.
 
 *===================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+==========================================================================
 * 11/14/14  |       KG        | Initial Version                                         
 *           |                 | 
 * 01/06/18  |Sree Uma Ponnoju | [US514]Added a new method signature for request/response as a blob
             |                 | and few custom fields as part of extending logging framework
 *===========+============+==========================================================================
 */


public with sharing class Integration {

 public static void log( List<IntegrationMessage> messages) {
   if(messages == null || messages.size() == 0) 
     return;
   List<IntegrationLog__c> logEntries = new List<IntegrationLog__c>();
   IntegrationLog__c entry;  
   for( IntegrationMessage m : messages) {
     entry = Integration.buildLogEntry(m);
     logEntries.add(entry);
   }
   insert logEntries;
 }
 
 public static void log(IntegrationMessage m) {
    IntegrationLog__c log = new IntegrationLog__c();
    log = Integration.buildLogEntry(m);
    insert log;
 }
 
 //To implement request/response as an attachment
 public static void log(IntegrationMessage m, blob mBlob) {
    IntegrationLog__c log = new IntegrationLog__c();    
    log = Integration.buildLogEntry(m);
    
    if (mBlob.size() <= 500) {
    log.msgData__c = m.msgData; 
    log.AttachmentSize__c = mBlob.size();  
    insert log;    
    }
    else{
    log = Integration.buildLogEntry(m);
    log.msgData__c = 'The relevant'+ ' ' +m.msgType+ ' ' +'file can be found in Notes and Attachments section';
    log.AttachmentSize__c = mBlob.size();
    insert log;
    
        if (mBlob != null && log.id!=null) {
        Attachment attch = new Attachment(parentId = log.Id);
           attch.Name = m.source + '-' + m.target + '-' + m.msgType + m.TransactionId;
           System.debug('*** Blob size is ' + mBlob.size());       
           attch.body = mBlob;
           attch.ContentType = 'text/plain';
           insert attch;        
        } 
    } 
 }
 
 public static void log(IntegrationLog__c log) {
   insert log;
 }
 
 public static void log(List<IntegrationLog__c> logs) {
   insert logs;
 }
 
 public static IntegrationLog__c buildLogEntry(IntegrationMessage m) {
    if( m == null) 
      return null;
    IntegrationLog__c log = new IntegrationLog__c();
    log.timeStamp__c = m.timeStamp;
    log.transactionID__c = m.transactionID;
    log.Name = m.source+'-'+m.target+'-'+m.msgType;
    log.msgType__c = m.msgType;
    log.result__c = m.result;    
    log.target__c = m.target;
    log.targetAddress__c = m.targetAddress;
    log.source__c = m.source;
    log.sourceAddress__c = m.sourceAddress;
    log.relatedData__c = m.relatedData;
    log.msgData__c = m.msgData; 
    //[US514]-Added new fields as part of extending logging framework
    log.Status__c = m.responseStatus;
    log.StatusCode__c = m.responseStatusCode;
    log.StatusDescription__c = m.responseStatusDescription;
    log.ReqTimeStamp__c = m.rqTimeStp;
    log.ResTimeStamp__c = m.rsTimeStp;    
    log.ResponseTime__c = m.responseTime;   
    return log;
 }
 
 
}