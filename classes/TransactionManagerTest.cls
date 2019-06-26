@isTest
private class TransactionManagerTest {
    
static testMethod void TransactionManagerTest() {
    Integer transactionId;
    Datetime timeStamp;
    
    System.Test.startTest();
    
    transactionId = TransactionManager.getTransactionID();
    timeStamp = TransactionManager.timeStamp();
    
    System.Test.stopTest();
    
    System.assert( transactionId > 0);
    System.assert( timestamp > Datetime.now() -100);
    System.debug( 'Generated Transaction ID= ' + transactionId);
    System.debug( 'Generated Timestamp= ' + timeStamp);
    }

}