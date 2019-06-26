// this is a test class for Enrollment_SetRanking_TEST
// 02/09/2015 :Ashish ojha
/*****************************************************************************************************
*Date: 04-13-2017
*Developer: Rajesh Pennam
*Purpose: Code coverage for Enrollment_DeleteData Class 
*=========================================================================================
* Update History
* Date         Developer        Tag        Description
*==================================================================================
*04-13-2017    Rajesh Pennam    T01        Code Coverage for Enrollment_SetRanking
*09-06-2017    Arshia Gulati    T02        Call SetPDB() - Ranking Updates for PDB 
*==================================================================================

*******************************************************************************************************/

@isTest
public class Enrollment_SetRanking_TEST{    
    static testMethod void testMethod1(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

        System.runAs(u) {
            Test.StartTest(); //T01
            TestUtil.createTestenrollmentsForRanking();
            TestUtil.createTestAccountsForRanking();
            TestUtil.createTestContactsForRanking();
            Test.StopTest();
            TestUtil.Create_Enrollment_Data_ForHIX_mgrn(); 
            TestUtil.createDynamicCodeDataStore();  
            TestUtil.createChatterGroups();             
        }
                
        //try { 
          //  Test.StartTest(); //T02   
            Enrollment_SetRanking brap = new Enrollment_SetRanking();
            //T01 Changes Start Here
            
             brap.GetBeginYear();
        	 brap.ClearAccountRankings();
             brap.ClearContactRankings();
             brap.SetAG();
             brap.SetGP();
             brap.SetFSP();
             brap.SetSB();
             brap.SetPDB();         //T02    

             brap.SendEmail();      
             string bdy='test body';
             //brap.PostToChatter(bdy);
             //T01 Changes Ends Here
            //Test.StopTest();       //T02
        //}catch( exception e ){
         //   RETURN;   
        //}           
    }
        
    static testMethod void testMethod2(){            
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

        System.runAs(u) {
            Test.StartTest(); //T01
            TestUtil.createTestenrollmentsForRanking();
            TestUtil.createTestAccountsForRanking(); 
            Test.StopTest();  
            TestUtil.createTestContactsForRanking();
            TestUtil.createChatterGroups();                                
        }   
            
        try {     
            Enrollment_SetRanking brap = new Enrollment_SetRanking();
            //T01 Changes Starts Here
            
                brap.GetBeginYear();
                brap.ClearAccountRankings();
                brap.ClearContactRankings();
                brap.SetAG();
                brap.SetGP();
                brap.SetFSP();
                brap.SetSB();
                brap.SetPDB();              //T02
              
            	brap.SendEmail();
                string body='test body';
              //  brap.PostToChatter(body);
              //T01 Changes Ends Here
            
        }catch( exception e ){
            RETURN;   
        }             
    }     
}