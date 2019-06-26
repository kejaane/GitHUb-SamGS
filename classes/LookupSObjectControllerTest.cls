/**
 * (c) Tony Scott. This code is provided as is and without warranty of any kind.
 *
 * This work by Tony Scott is licensed under a Creative Commons Attribution 3.0 Unported License.
 * http://creativecommons.org/licenses/by/3.0/deed.en_US
 */
@isTest
private class LookupSObjectControllerTest {
    @isTest static void testSearch() {
        // Create some accounts
        Account abc = new Account(Name = 'ABC Account');
        Account xyz = new Account(Name = 'XYZ Account');

        List<Account> accounts = new List<Account> { abc, xyz };

        insert accounts;

        Id[] fixedSearchResults = new Id[] { xyz.Id };
        Test.setFixedSearchResults(fixedSearchResults);
        List<LookupSObjectController.Result> results = LookupSObjectController.lookup('xy', 'Account', 'id<>NULL', '', '');

        System.assertEquals(1, results.size());
        System.assertEquals(xyz.Name, results[0].SObjectLabel);
        System.assertEquals(xyz.Id, results[0].SObjectId);
        
        //raw query
        List<LookupSObjectController.Result> results2 = LookupSObjectController.lookup('xy', 'Account', ''
			, 'SELECT name, id FROM Account WHERE name LIKE \'searchString%\' Limit 1'
                                                                                      ,'');
        
        System.assertEquals(1, results2.size());
        System.assertEquals(xyz.Name, results2[0].SObjectLabel);
        System.assertEquals(xyz.Id, results2[0].SObjectId);
    
   }   
}