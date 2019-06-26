public with sharing class TransactionManager {


 public static Integer getTransactionID() {
       return Math.round(Math.random()*1000000);
 }

 public static Datetime timeStamp() {
     return Datetime.now();
}

}