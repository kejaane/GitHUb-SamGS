global class Enrollment_DeleteData_schedule implements Schedulable{ 
//Alex Update 6/23 - 1
//Alex Update 6/24 - 1
//Alex Update 6/24 - 2
//Alex Update 6/24 - 3
    Enrollment_DeleteData d = new Enrollment_DeleteData();         
    {
        d.query = 'SELECT id FROM Enrollment_Import__c';
    }
    global void execute(SchedulableContext SC){
        ID batchprocessId = Database.executeBatch(d);      
   }
}