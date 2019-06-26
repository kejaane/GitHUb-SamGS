/*******************************************************************************************************************************
*Date: 06/07/2018
*Developer: Raviteja
*Purpose: US-463 Test class is to validate AIA_Impl_TileBoard_Controller
*===============================================================================================================================
* Update History
* Date         Developer         Tag        Description
*===============================================================================================================================
*06/07/2018    Raviteja                     Initial Development
===============================================================================================================================

*******************************************************************************************************************************/
@isTest
public class AIA_Impl_TileBoard_ControllerTest {
    static Schema.DescribeSObjectResult objResult = Schema.SObjectType.Opportunity; 
    static Map<String,Schema.RecordTypeInfo> objRecordType = objResult.getRecordTypeInfosByName(); 
    static Id opp200RecTypId = objRecordType !=NULL && objRecordType.containsKey('200+') ? objRecordType.get('200+').getRecordTypeId() : NULL;  
    
    @testsetup static void CreateTestData(){
       
        User u = AIA_TestUtil.createTestUser();
        System.runAs(u) {  
            // Create Account
            AIA_Implementation__c Imp;
            Account a = AIA_TestUtil.CreateAccount('TestAccount');
            system.assertNotEquals(null,a.id);
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            system.debug('Opp'+o);
            o.recordTypeId = opp200RecTypId;
            o.Business_Type__c = 'RFP';
            update o;
            
            // Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
            system.assertNotEquals(null,p.id);
             test.startTest();
            List<AIA_Implementation__c> aiaImpList = AIA_TestUtil.CreateImpList(o.id);
            system.assertNotEquals(0,aiaImpList.size());
            
            Imp = AIA_TestUtil.UpdateImp(o.id);             
            update Imp;
            Process__c p1=new Process__c();
            p1.Implementation__c=Imp.id;
            
            insert p1;
            Sub_Process__c s1=new Sub_Process__c();
            s1.Implementation__c=Imp.id;
            s1.Process__c=p1.id;      
            insert s1;
            Workplan_Task__c wp1=new Workplan_Task__c();
            wp1.Sub_Process__c=s1.id;
            wp1.Status__c='Completed';
            insert wp1;
            
            test.stopTest();
        }
       
    }
    static testmethod void testImplTileBoard(){
       
        AIA_Implementation__c testImpl = [Select Id,Business_Type__c From AIA_Implementation__c limit 1];
        Process__c process=[Select Id from Process__c limit 1];
        PageReference pref = Page.AIA_Implementation_Dashboard;
        Test.setCurrentPage(pref);
         test.startTest();
        ApexPages.StandardController con = new ApexPages.StandardController(testImpl);
        ApexPages.currentPage().getParameters().put('Id',testImpl.id);
        AIA_Implementation_Dashboard_Extn impt=new AIA_Implementation_Dashboard_Extn(con);
        AIA_Impl_TileBoard_Controller impt1=new AIA_Impl_TileBoard_Controller();
        impt1.setprocessID(process.Id); 
        impt1.getprocessID();
        impt1.getFullListOfTiles();
        impt1.displayTaskListModalSetter();
        impt1.closeTaskListModal();
        system.assertEquals(1,impt1.lstName.size());    
        test.stopTest();        
    }
}