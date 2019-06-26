@isTest
public class LookupFieldControllerTest {
    
    @isTest
    public static void test() {
        LookupFieldController.getInfo('Account');
        LookupFieldController.getInfo('User');        
        LookupFieldController.generateQuery('opportunity', 'test', false,'','');
        LookupFieldController.generateQuery('user', 'test', false,'','');
        LookupFieldController.generateQuery('contact', 'test', false,'','');
        //LookupFieldController.generateQuery('proposal_request_form__c', 'test', false,'','');
        LookupFieldController.generateQuery('benfit_request_form__c', 'test', false,'','');
        LookupFieldController.generateQuery('proposed_products__c', 'test', false,'','');
        LookupFieldController.generateQuery('account', 'test', false,'','');
        LookupFieldController.generateQuery('case', 'test', false,'','');
        LookupFieldController.generateQuery('contract', 'test', false,'','');
        LookupFieldController.generateQuery('lead', 'test', false,'','');
        LookupFieldController.generateQuery('product2', 'test', false,'','');
     
       // LookupFieldController.generateQuery('user', 'test', false,'','');
        
        //LookupFieldController.showRecentViewed('contact');
        LookupFieldController.obtainObjectById('', 'contact');
        LookupFieldController.obtainObjectList('test', 'contact', null, null);
        
        String expected = 'SELECT Id,CaseNumber,Subject FROM case  WHERE LastViewedDate != null ORDER BY LastViewedDate DESC  LIMIT 5';
        String testQuery = LookupFieldController.generateQuery('case', '', true,'','');
        System.assertEquals(expected, testQuery);
        
        /*
        
        // below code added by raj for code coverage start 
        // 
         LookupFieldController.generateQuery('contract', 'test', false,'','');
            LookupFieldController.generateQuery('order', 'test', false,'','');
         LookupFieldController.generateQuery('orderitem', 'test', false,'','');
        
            
         String expected1 = 'SELECT Id,ContractNumber  FROM contract  WHERE LastViewedDate != null ORDER BY LastViewedDate DESC  LIMIT 5';
        String testQuery1 = LookupFieldController.generateQuery('contract', '', true,'','');
        System.assertEquals(expected1, testQuery1);
        
         String expected2 = 'SELECT Id,OrderNumber FROM order  WHERE LastViewedDate != null ORDER BY LastViewedDate DESC  LIMIT 5';
        String testQuery2 = LookupFieldController.generateQuery('order', '', true,'','');
        System.assertEquals(expected2, testQuery2);
        
         String expected3 = 'SELECT Id,OrderItemNumber FROM orderitem  WHERE LastViewedDate != null ORDER BY LastViewedDate DESC  LIMIT 5';
        String testQuery3 = LookupFieldController.generateQuery('orderitem', '', true,'','');
        System.assertEquals(expected3, testQuery3);
        
        // below code added by raj for code coverage end 
        // */
    }
    
}