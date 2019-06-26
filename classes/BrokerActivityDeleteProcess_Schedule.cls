//========================================================================================
//      Date: 08/26/2014
// Developer: Ashish Ojha 
//   Purpose: This class is the BrokerActivityDeleteProcess scheduler class.
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================
global class BrokerActivityDeleteProcess_Schedule implements Schedulable{
    global void execute(SchedulableContext SC){
        SObject_Records_Delete_Process bc = new SObject_Records_Delete_Process('Broker_Import_2_50__c',True,'Processed__c = true');
        database.executeBatch(bc);
   }
}