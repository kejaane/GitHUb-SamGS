/* =========================================================================================
 * Date         : 04/25/2018
 * Developer    : Rajesh Pennam
 * Purpose      : This is the Test Class For SLDSTeamMemberLookupController
 *                
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer        Tag         Description
 *============================================================================================
   04/25/2018|Rajesh Pennam| T01   | Intial Developement
 *=========================================================================================
 
*/
 @isTest
 Public class SLDSTeamMemberLookupControllerTest{
 
      
  public static user createTestRecords(){
	User u = new User(
    	ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
         LastName = 'last',
         Email = 'Test@Care.com',
         Username = 'Test@Care.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
        );
  
    insert u;
     return u;
 
  }

private static testMethod void generateUniqueComponentIdTest() {

   User u = new User();
   u= SLDSTeamMemberLookupControllerTest.createTestRecords();
   
   system.runAs(u){  
       SLDSTeamMemberLookupController controller = new SLDSTeamMemberLookupController();         
       controller.Label = 'opportunity';
       controller.objectName = 'Opportunity';         
       System.assertEquals('opportunity', controller.uniqueComponentId);
    }
  
  }

     private static testmethod void searchTest(){
         
         User u = new User();
         u= SLDSTeamMemberLookupControllerTest.createTestRecords();
         
         system.runAs(u){ 
             //Dummy string and code has no action on the data from string.
             String userMap = '{00560000004vaOiAAI=Rajesh Pennam, 005600000068mAJAAY=Satya Tirumalasetti, 0051F000000oE3VQAU=Phanishankar Polisetty, 00560000001egXhAAI=Alex Friedman}';
             List<SLDSTeamMemberLookupController.Wrapper> lst = SLDSTeamMemberLookupController.search('opportunity', 'Name','Name','url->www.google.com','Alex',userMap);
             SLDSTeamMemberLookupController  ct = new SLDSTeamMemberLookupController();
             ct.testnMethod();
             
         }
     }

 }