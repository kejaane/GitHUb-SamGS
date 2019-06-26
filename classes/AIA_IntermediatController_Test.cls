/*
=====================================================================
Date : 06/17/2016
Developer : Laveen Kattela 
Purpose : Test Class For AIA_IntermediatController.
=====================================================================
*/
@isTest
public class AIA_IntermediatController_Test {
        
        //Positive Testing scenario
        public static testmethod void IntermediatControllerPositiveTesting()
        {   
            //Testing with AIA user - calling froom Util class         
            User currentUser=AIA_TestUtil.AIA_createUser('AIA');
            insert currentUser;     
            System.runAs (currentUser) {
            
            //Page references to the current page and passing the values 
            PageReference pageRef = Page.AIA_IntermediatPage;
            Test.setCurrentPage(pageRef);
           /* AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Active__c = true;
            wpt.Workplan_Type__c = 'Off-Cycle';
            wpt.Used_For__c = 'Pre-Sales';
            insert wpt;                     //Inserting the workplan type stage
			*/            
// Start Test
            Test.startTest();
            
           //Get RecordTypes For Workplan Type Stage
            //commented as per us 210
            /*
           Schema.DescribeSObjectResult WPTSdSobjres        = Schema.SObjectType.Workplan_Type_Stage__c; 
            Map<String,Schema.RecordTypeInfo> WPTSRecordType = WPTSdSobjres.getRecordTypeInfosByName();        
            
            //Getting the record type for both the process and sub process
            Id ProcesswptsRtid    = WPTSRecordType.get('Process').getRecordTypeId();                          
            Id SubProcesswptsRtid = WPTSRecordType.get('Sub-Process').getRecordTypeId();
            Workplan_Type_Stage__c wpts1 = new Workplan_Type_Stage__c();    //new instances created for workplan type stage
            wpts1.Workplan_Type__c = wpt.Id;                                // passing the id and respective data
            wpts1.RecordTypeId = ProcesswptsRtid;
            wpts1.Stage__c = 'RFP';
            wpts1.Active__c = true;
            insert wpts1;
            ApexPages.currentPage().getParameters().put('id', wpts1.id);                //passing the workplan type stage is as parameter for current page
            ApexPages.StandardController sc = new ApexPages.StandardController(wpts1 );
            AIA_IntermediatController controller = new AIA_IntermediatController(sc);
            controller.selectedRecordType =   SubProcesswptsRtid;
            controller.doContinue();        //Calling continue method
            controller.doCancel();          //calling cancel button
            
            // Stop Test
            Test.stopTest();
        */
        }
    }
}