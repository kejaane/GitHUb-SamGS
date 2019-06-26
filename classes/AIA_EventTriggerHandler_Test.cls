/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
//Test Class for AIA_EventTriggerHandler
@isTest
private class AIA_EventTriggerHandler_Test{
    public static Id rt_acc_51= QueryBase.getRecordtypeId('Event', 'AIA_Meeting');
    public static Id rt_OpenEE= QueryBase.getRecordtypeId('Event', 'AIA_Open_Enrollment_Meeting');
    
    /*******************************************************************
Purpose:  This  testmethod tests the logic of eventhandler
Parameters: None
Returns: None                                                        
********************************************************************/
    static testmethod void testPrevDuplicateBidDecisions(){
        try{
            test.startTest();
            PRF__c prf = new PRF__c(name='TestPRF');
            insert prf;
            
            event noDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=prf.id,Bid_Meeting_Decision__c='No Decision',Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert noDecisionEvent ;
            event NoBidDecisionEvent= new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=prf.id,Bid_Meeting_Decision__c='No Bid',No_Bid_Comments__c='Did not like the deal',Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert NoBidDecisionEvent;
            event BidDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=prf.id,Bid_Meeting_Decision__c='No Bid',No_Bid_Comments__c='Did not like the deal',Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert BidDecisionEvent ;
            event BidDecisionEvent2 = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=prf.id,Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert BidDecisionEvent2;
            
            BidDecisionEvent.subject = 'call';
            update BidDecisionEvent;
            NoBidDecisionEvent.subject = 'Call';
            update NoBidDecisionEvent;
            
            
            test.stopTest();
        }
        catch(exception e){
            system.debug('exception'+e.getMessage());
            /****************************************************
Boolean expectedExceptionThrown =  e.getMessage().contains('You cannot create another event when it is already') ? true : false;
System.AssertEquals(expectedExceptionThrown, false);
*****************************************************/
        }      
        
    }
    static testmethod void testPrevDuplicateBidDecisionsnullForBrf(){
        try{
            test.startTest();
            PRF__c prf = new PRF__c(name='TestPRF');
            insert prf;
            Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
            
            User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = pro.Id,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
            insert user;   
            
            Account acc =AIA_TestUTIL.createAccount('TestAccount');
            //Replacing standard AccountTeamMember with Account_Team__c object
            /*AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'Implementation Manager';
            atm.AccountId =acc.id;
            atm.UserId = user.id;
            insert atm;*/
            Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=user.id;
                 atmRole1.TeamMemberRole__c='Implementation Manager';
                 atmRole1.AccountId__c =acc.id;   
            insert atmRole1;
            opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);
            
            //PRF__c prf = AIA_TestUtil.createPRF(opp.id);
            //Benfit_Request_Form__c brf = AIA_TestUtil.createBRF(prf.id,acc.id);
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            //  brf.Control_Plan__c='MD';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            //brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = opp.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;
            system.debug('erecordtype:'+rt_OpenEE);
            //insert
            event noDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=brf.id,Bid_Meeting_Decision__c='Bid',Meeting_Type__c='ARC Approval Meeting',recordTypeId=rt_acc_51,Approval_Meeting_Decision__c='arc');
            //insert noDecisionEvent ;
            event NoBidDecisionEvent= new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=brf.id,Bid_Meeting_Decision__c=Null,No_Bid_Comments__c='Did not like the deal',Meeting_Type__c='ARC Approval Meeting',recordTypeId=rt_acc_51,Approval_Meeting_Decision__c='arc');
            //insert NoBidDecisionEvent;
            event BidDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=brf.id,Bid_Meeting_Decision__c=Null,No_Bid_Comments__c='Did not like the deal',Meeting_Type__c='ARC Approval Meeting',recordTypeId=rt_acc_51,Approval_Meeting_Decision__c='arc');
            //insert BidDecisionEvent ;
            event BidDecisionEvent2 = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=brf.id,Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            //insert BidDecisionEvent2;    
            
            List<event> e=new List<event>();
            e.add(noDecisionEvent);e.add(NoBidDecisionEvent);e.add(BidDecisionEvent);e.add(BidDecisionEvent2);	
			insert e; 
            
            BidDecisionEvent.subject = 'call';
            //update BidDecisionEvent;
            NoBidDecisionEvent.subject = 'Call';
            //update NoBidDecisionEvent;
            
            AIA_EventTriggerHandler.updateBRF(e);
            
            test.stopTest();
        }
        catch(exception e){
            system.debug('exception'+e.getMessage());
            /****************************************************
Boolean expectedExceptionThrown =  e.getMessage().contains('You cannot create another event when it is already') ? true : false;
System.AssertEquals(expectedExceptionThrown, false);
*****************************************************/
        }      
        
    }
    
    static testmethod void testPrevDuplicateBidDecisionsnullForAcc(){
        try{
            test.startTest();
            PRF__c prf = new PRF__c(name='TestPRF');
            insert prf;
            Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
            
            User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = pro.Id,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
            insert user;   
            
            Account acc =AIA_TestUTIL.createAccount('TestAccount');
            /*AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'Implementation Manager';
            atm.AccountId =acc.id;
            atm.UserId = user.id;
            insert atm;*/
            Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=user.id;
                 atmRole1.TeamMemberRole__c='Implementation Manager';
                 atmRole1.AccountId__c =acc.id;   
            insert atmRole1;
            system.debug('erecordtype:'+rt_OpenEE);
            //insert
            event noDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=acc.id,Bid_Meeting_Decision__c='Bid',Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert noDecisionEvent ;
            event NoBidDecisionEvent= new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=acc.id,Bid_Meeting_Decision__c=Null,No_Bid_Comments__c='Did not like the deal',Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert NoBidDecisionEvent;
            event BidDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=acc.id,Bid_Meeting_Decision__c=Null,No_Bid_Comments__c='Did not like the deal',Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert BidDecisionEvent ;
            event BidDecisionEvent2 = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=acc.id,Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert BidDecisionEvent2;    
            
            List<event> e=new List<event>();
            e.add(noDecisionEvent);e.add(NoBidDecisionEvent);e.add(BidDecisionEvent);e.add(BidDecisionEvent2);
            noDecisionEvent.RecordTypeId=rt_OpenEE;
            NoBidDecisionEvent.RecordTypeId=rt_OpenEE;
            BidDecisionEvent.RecordTypeId=rt_OpenEE;
            BidDecisionEvent2.RecordTypeId=rt_OpenEE;
            BidDecisionEvent.subject = 'call';
            update BidDecisionEvent;
            NoBidDecisionEvent.subject = 'Call';
            update NoBidDecisionEvent;
            
            update e;
            AIA_EventTriggerHandler.updateBRF(e);
            
            test.stopTest();
        }
        catch(exception e){
            system.debug('exception'+e.getMessage());
            /****************************************************
Boolean expectedExceptionThrown =  e.getMessage().contains('You cannot create another event when it is already') ? true : false;
System.AssertEquals(expectedExceptionThrown, false);
*****************************************************/
        }      
        
    }
    
    static testmethod void testPrevDuplicateBidDecisionsnull(){
        try{
            test.startTest();
            PRF__c prf = new PRF__c(name='TestPRF');
            insert prf;
            
            
            event noDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=prf.id,Bid_Meeting_Decision__c='Bid',Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert noDecisionEvent ;
            event NoBidDecisionEvent= new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=prf.id,Bid_Meeting_Decision__c=Null,No_Bid_Comments__c='Did not like the deal',Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert NoBidDecisionEvent;
            event BidDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=prf.id,Bid_Meeting_Decision__c=Null,No_Bid_Comments__c='Did not like the deal',Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert BidDecisionEvent ;
            event BidDecisionEvent2 = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=prf.id,Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert BidDecisionEvent2;
            
            
            
            List<event> e=new List<event>();
            e.add(noDecisionEvent);e.add(NoBidDecisionEvent);e.add(BidDecisionEvent);e.add(BidDecisionEvent2);
            //e.add(brfnoDecisionEvent);e.add(brfNoBidDecisionEvent);e.add(brfBidDecisionEvent);e.add(brfBidDecisionEvent2);
            BidDecisionEvent.subject = 'call';
            update BidDecisionEvent;
            NoBidDecisionEvent.subject = 'Call';
            update NoBidDecisionEvent;
            AIA_EventTriggerHandler.updateBRF(e);
            
            test.stopTest();
        }
        catch(exception e){
            system.debug('exception'+e.getMessage());
            /****************************************************
Boolean expectedExceptionThrown =  e.getMessage().contains('You cannot create another event when it is already') ? true : false;
System.AssertEquals(expectedExceptionThrown, false);
*****************************************************/
        }      
        
    }
    static testmethod void testNoBidDecisions(){
        try{
            test.startTest();
            PRF__c prf = new PRF__c(name='TestPRF');
            insert prf;
            
            event noDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),Bid_Meeting_Decision__c=null,whatId=prf.id,Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert noDecisionEvent ;
            event BidDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=prf.id,Bid_Meeting_Decision__c='No Bid',No_Bid_Comments__c='Did not like the deal',Meeting_Type__c='Bid Meeting',recordTypeId=rt_acc_51);
            insert BidDecisionEvent ;
            BidDecisionEvent.subject = 'call';
            update BidDecisionEvent;
            test.stopTest();
        }
        catch(exception e){}
    }
    static testmethod void testBidDecisions(){
        try{
            test.startTest();
            PRF__c prf = new PRF__c(name='TestPRF',Original_Bid_Date__c=null,Final_Decision_Date__c=null);
            insert prf;  
            event noDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=prf.id,Bid_Meeting_Decision__c='No Decision');
            insert noDecisionEvent ;           
            event BidDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=prf.id,Bid_Meeting_Decision__c='Bid');
            insert BidDecisionEvent ;
            test.stopTest();
        }
        catch(exception e){
            system.debug('exception'+e.getMessage());
        }
    }
    static testmethod void PrevEditing(){
        try{
            test.startTest();
            PRF__c prf = new PRF__c(name='TestPRF');
            insert prf;
            event BidDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=prf.id,Bid_Meeting_Decision__c='No Bid',No_Bid_Comments__c='Did not like the deal');
            insert BidDecisionEvent ;
            BidDecisionEvent.subject = 'Call';
            update BidDecisionEvent ;
            test.stopTest();
        }
        catch(exception e){
            system.debug('exception'+e.getMessage());
            /***************************************
Boolean expectedExceptionThrown =  e.getMessage().contains('You cannot edit this record') ? true : false;
System.AssertEquals(expectedExceptionThrown, true);
***************************************/
        }      
    }
    static testmethod void testUpdateBRF(){
        try{
            test.startTest();
            Account acc =AIA_TestUTIL.createAccount('TestAccount');
            opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);
            
            //PRF__c prf = AIA_TestUtil.createPRF(opp.id);
            //Benfit_Request_Form__c brf = AIA_TestUtil.createBRF(prf.id,acc.id);
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            //  brf.Control_Plan__c='MD';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = opp.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;
            //insert brf;
            event ArcDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=brf.id,Approval_Meeting_Decision__c='Approved',ARC_Meeting_Comments__c='Did not like the deal',Meeting_Type__c='ARC Approval Meeting',recordTypeId=rt_acc_51);
            insert ArcDecisionEvent ;
            test.stopTest();
        }
        catch(exception e){
            system.debug('exception'+e.getMessage());            
        } 
    }
    
    static testmethod void testUpdateRejectBRF(){
        try{
            test.startTest();
            Account acc =AIA_TestUTIL.createAccount('TestAccount');
            opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);
            
            // PRF__c prf = AIA_TestUtil.createPRF(opp.id);
            //Benfit_Request_Form__c brf = AIA_TestUtil.createBRF(prf.id,acc.id);
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            //    brf.Control_Plan__c='MD';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = opp.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;
            update brf;
            //insert brf;
            event ArcDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=brf.id,Approval_Meeting_Decision__c='Rejected',ARC_Meeting_Comments__c='Did not like the deal',Meeting_Type__c='ARC Approval Meeting',recordTypeId=rt_acc_51);
            insert ArcDecisionEvent ;
            update ArcDecisionEvent;
            List<event> e=new List<event>();
            e.add(ArcDecisionEvent);
            AIA_EventTriggerHandler.updateBRF(e);
            test.stopTest();
        }
        catch(exception e){
            system.debug('exception'+e.getMessage());            
        } 
    }
    
    public static testmethod void testUpdateBRFNoRole(){
        try{
            test.startTest();
            AIA_EventTriggerHandler EHandler = new AIA_EventTriggerHandler();
            
            Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
            
            User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = pro.Id,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
            insert user;
            system.assertNotEquals(null,user.id);
            Account acc =AIA_TestUTIL.createAccount('TestAccount');
            
            /*AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit coder';
            atm.AccountId =acc.id;
            atm.UserId = user.id;
            insert atm;*/
            Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=user.id;
                 atmRole1.TeamMemberRole__c='Benefit coder';
                 atmRole1.AccountId__c =acc.id;   
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);
            
            opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);
            
            //insert brf;
            system.RunAs(user){
                event ArcDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=acc.id,Meeting_Status__c='Open',recordTypeId=rt_OpenEE);
                insert ArcDecisionEvent ;
                ArcDecisionEvent.whatId = acc.id;
                system.debug('ArcDecisionEvent.whatId'+ArcDecisionEvent.whatId);
                ArcDecisionEvent.Approval_Meeting_Decision__c='Approved';
                Update ArcDecisionEvent;
            }
            
        }
        catch(exception e){
            system.debug('exception'+e.getMessage());            
        } 
        test.stopTest();
    }
    public static testmethod void testUpdateBRFRole(){
        try{
            test.startTest();
            AIA_EventTriggerHandler EHandler = new AIA_EventTriggerHandler();
            
            Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
            
            User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = pro.Id,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
            insert user;
            system.assertNotEquals(null,user.id);
            Account acc =AIA_TestUTIL.createAccount('TestAccount');
            
            /*AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'Implementation Manager';
            atm.AccountId =acc.id;
            atm.UserId = user.id;
            insert atm;*/
            Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=user.id;
                 atmRole1.TeamMemberRole__c='Implementation Manager';
                 atmRole1.AccountId__c =acc.id;   
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);
            
            opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);
            
            //insert brf;
            system.RunAs(user){
                event ArcDecisionEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=acc.id,Meeting_Status__c='Open',recordTypeId=rt_OpenEE);
                insert ArcDecisionEvent ;
                ArcDecisionEvent.whatId = acc.id;
                system.debug('ArcDecisionEvent.whatId'+ArcDecisionEvent.whatId);
                ArcDecisionEvent.Approval_Meeting_Decision__c='Approved';
                Update ArcDecisionEvent;
            }
            
        }
        catch(exception e){
            system.debug('exception'+e.getMessage());            
        } 
        test.stopTest();
    }
    
    
}