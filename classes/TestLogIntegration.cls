/*=========================================================================================
 * Date         : 01/06/2018
 * Developer    : Sree Uma Ponnoju
 * Purpose      :  Test Class for extending logging framework
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 01/06/18  |  Sree Uma Ponnoju    | Initial Version
 *           |        | 
 *=========================================================================================
 */
@isTest
public class TestLogIntegration {
@isTest static void test_logEntry(){
            Test.startTest();
            Blob mBlob = Blob.valueOf('Test Data'); 
            IntegrationLog__c iL = new IntegrationLog__c();
            List<IntegrationLog__c> iLS = new List<IntegrationLog__c>(); 
            iLS.add(new IntegrationLog__c(msgData__c = 'Relevant Request/response', msgType__c = 'Request', source__c ='SFDC', target__c =' FDL',
                                          timeStamp__c = datetime.newInstance(2018,1,5),transactionID__c = 826374));
            IntegrationMessage iM = new IntegrationMessage();
            List<IntegrationMessage> iMS = new List<IntegrationMessage>();
            iM.source = 'SFDC';
            iM.target = 'FDL';
            iM.transactionID = 826374;
            iL.source__c = 'SFDC';
            iL.target__c = 'FDL';
            iL.msgData__c = 'Succesful Retrieval';
            iL.timeStamp__c = datetime.newInstance(2018,1,5);
            iL.transactionID__c = 826374;            
            IntegrationLog__c log = new IntegrationLog__c(Name='Test Log'); 
            log.source__c = 'SFDC';
            log.target__c = 'FDL';
            log.msgData__c = 'Succesful Retrieval';
            log.timeStamp__c = datetime.newInstance(2018,1,5);
            log.transactionID__c = 826374;
            insert log ;   
            Integration.log(iM);
            Blob b = Blob.valueOf('Test Blob Data');
            Integration.log(iM, mBlob);
            Attachment attachment = new Attachment();
            attachment.ParentId = log.Id;
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            insert(attachment);
            Integration.log(iMS);
            Integration.log(iL);
            Integration.log(iLS);
            Test.stopTest();
    }
   }