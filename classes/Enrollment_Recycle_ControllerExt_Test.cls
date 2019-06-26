/*****************************************************************************************************
*Date: 04-13-2017
*Developer: Rajesh Pennam
*Purpose: Code coverage for Enrollment_DeleteData Class 
*=========================================================================================
* Update History
* Date         Developer        Tag        Description
*==================================================================================
*04-13-2017    Rajesh Pennam    T01         Removed see all data true and inserted data
*==================================================================================

*******************************************************************************************************/

@isTest() //T01
public class Enrollment_Recycle_ControllerExt_Test {
    // Test with selected Recycle records
    static testMethod void testSelected(){    
        testUtil.createEnrollmentTestData(); 
        TestUtil.Create_Error_Message(); //T01
         //TestUtil.Create_Enrollment_Import();
         //TestUtil.createTestOpportunities();
        /*List<Enrollment_Recycle__c> ers = [ SELECT id, Rpt_Dt__c, Account_Name__c, Account_Number__c, Contracts__c, Error_Message__c,
                                                   Sales_Rep__c, Error_Number__c, Processed_Type__c, SFDC_Product__c, Risk__c, Run_Dt__c, System__c, Rating_State__c, New_Business_Indicator__c  
                                            FROM Enrollment_Recycle__c LIMIT 10];                                          

        System.assert(ers.size() > 0);        
        */
       
       //T01 Changes Starts Here
         Id enRecordTypeId = Schema.SObjectType.Enrollment__c.getRecordTypeInfosByName().get('51+').getRecordTypeId();
 
        
         Date LastMonth = Date.today().toStartofMonth()-1; // Get last month
        String MM = String.valueOf(LastMonth.month());
        if ( LastMonth.month() < 10 ) {
            MM = ('0' + String.valueOf(LastMonth.month())); 
        }
        String YYYY = String.valueOf(LastMonth.Year());
        String RptDt = YYYY + MM;               // Format CCYYMM
        String RunDt = Date.Today().format() + ' 5:00:00'; // Format MM/DD/CCYYY HH:MM:SS        
          List<Enrollment_Recycle__c> erList = new List<Enrollment_Recycle__c>();  
        // Create a record that has no known product
        Enrollment_Recycle__c er = new Enrollment_Recycle__c();           
        er.Account_Name__c = 'Any Account';
        er.Account_Number__c = 'CE12';        
        er.System__c =  'Facets'; 
        er.Contracts__c = 100;            
        er.Processed_Type__c = 'M';
        er.Error_Message__c = 'No Salesforce Product found! Contact sfdcSupport@carefirst.com';
        er.Error_Number__c = '0001';
        er.Opportunity_Name__c = null;
        er.Risk__c = 'Risk';
        er.Rpt_dt__c = RptDt;
        er.Run_Dt__c = RunDt;
        er.Sales_Rep__c = 'Tester';
        er.SFDC_Product__c = 'NOTFOUND';                 
        erList.add(er);
        
        
        // Create a record that has no known system
        Enrollment_Recycle__c er2 = new Enrollment_Recycle__c();           
        er2.Account_Name__c = 'Any Account';
        er2.Account_Number__c = 'CE12';        
        er2.System__c =  'NASCO'; 
        er2.Contracts__c = 100;            
        er2.Processed_Type__c = 'M';
        er2.Error_Message__c = 'System not found in Salesforce';
        er2.Error_Number__c = '0002';
        er2.Opportunity_Name__c = null;
        er2.Risk__c = 'Risk';
        er2.Rpt_dt__c = RptDt;
        er2.Run_Dt__c = RunDt;
        er2.Sales_Rep__c = 'Tester';
        er2.SFDC_Product__c = 'BC Advantage';                 
        erList.add(er2); 
        
        // Create a record that has no known system
        Enrollment_Recycle__c er10 = new Enrollment_Recycle__c();           
        er10.Account_Name__c = 'Any Account';
        er10.Account_Number__c = 'CE12';        
        er10.System__c =  'Test'; 
        er10.Contracts__c = 100;            
        er10.Processed_Type__c = 'M';
        er10.Error_Message__c = 'System not found in Salesforce';
        er10.Error_Number__c = '002';
        er10.Opportunity_Name__c = null;
        er10.Risk__c = 'Risk';
        er10.Rpt_dt__c = RptDt;
        er10.Run_Dt__c = RunDt;
        er10.Sales_Rep__c = 'Tester';
        er10.SFDC_Product__c = 'Test123';                 
        erList.add(er10); 
        
        // Create a record that has no known system
        Enrollment_Recycle__c er3 = new Enrollment_Recycle__c();           
        er3.Account_Name__c = 'Any Account';
        er3.Account_Number__c = 'CE12';        
        er3.System__c =  'LuminX'; 
        er3.Contracts__c = 100;            
        er3.Processed_Type__c = 'M';
        er3.Error_Message__c = 'System not found in Salesforce';
        er3.Error_Number__c = '0002';
        er3.Opportunity_Name__c = null;
        er3.Risk__c = 'Risk';
        er3.Rpt_dt__c = RptDt;
        er3.Run_Dt__c = RunDt;
        er3.Sales_Rep__c = 'Tester';
        er3.SFDC_Product__c = 'BC Advantage';                 
        erList.add(er3); 
        
        
        // Create a record that has no known system
        Enrollment_Recycle__c er21= new Enrollment_Recycle__c();           
        er21.Account_Name__c = 'Any Account';
        er21.Account_Number__c = '12345';        
        er21.System__c =  'National Alliance'; 
        er21.Contracts__c = 100;            
        er21.Processed_Type__c = 'M';
        er21.Error_Message__c = 'System not found in Salesforce';
        er21.Error_Number__c = '0002';
        er21.Opportunity_Name__c = null;
        er21.Risk__c = 'Risk';
        er21.Rpt_dt__c = RptDt;
        er21.Run_Dt__c = RunDt;
        er21.Sales_Rep__c = 'Tester';
        er21.SFDC_Product__c = 'BC Advantage';                 
        erList.add(er21); 
        
        // Create a record that has no known system
        Enrollment_Recycle__c er12  = new Enrollment_Recycle__c();           
        er12 .Account_Name__c = 'Any Account';
        er12 .Account_Number__c = 'CE12';        
        er12 .System__c =  'Network Lease'; 
        er12 .Contracts__c = 100;            
        er12 .Processed_Type__c = 'M';
        er12 .Error_Message__c = 'System not found in Salesforce';
        er12 .Error_Number__c = '0002';
        er12 .Opportunity_Name__c = null;
        er12 .Risk__c = 'Risk';
        er12 .Rpt_dt__c = RptDt;
        er12 .Run_Dt__c = RunDt;
        er12 .Sales_Rep__c = 'Tester';
        er12 .SFDC_Product__c = 'BC Advantage';                 
        erList.add(er12 );        

        if  ( erList.size() > 0 ) {         
            insert erList; 
        }
        
        Enrollment_Import__c EnImp = new Enrollment_Import__c();
        EnImp.Account_Name__c = 'TestAccount';
        EnImp.Account_Number__c = '1220';        
        EnImp.System__c = 'NASCO';
        EnImp.Contracts__c = 50;
        EnImp.Processed__c = FALSE;
        EnImp.Processed_Type__c = 'M';
        EnImp.Risk__c = 'Non-Risk';
        EnImp.Rpt_dt__c = RptDt;
        EnImp.Run_Dt__c = RptDt;
        EnImp.SFDC_Product__c = 'Standard Price Book1';    
        
        insert EnImp;
        
        Enrollment_Import__c EnImp2 = new Enrollment_Import__c();
        EnImp2.Account_Name__c = 'TestAccount';
        EnImp2.Account_Number__c = '1220';        
        EnImp2.System__c = 'NASCO';
        EnImp2.Contracts__c = 50;
        EnImp2.Processed__c = FALSE;
        EnImp2.Processed_Type__c = 'M';
        EnImp2.Risk__c = 'Non-Risk';
        EnImp2.Rpt_dt__c = RptDt;
        EnImp2.Run_Dt__c = RptDt;
        EnImp2.SFDC_Product__c = 'Standard Price Book';    
        
        insert EnImp2;
        system.debug('---EnImp2------'+EnImp2 +'--EnImp------'+EnImp);
        //T01 Changes Ends Here
        
        Test.StartTest();
           /* ApexPages.StandardSetController setCon = new ApexPages.standardSetController(ers);
            setCon.setSelected(ers);    
            Enrollment_Recycle_ControllerExt ext = new Enrollment_Recycle_ControllerExt(setCon);
            ext.ProcessSelection();
            */
            try{
            ApexPages.StandardSetController setCon = new ApexPages.standardSetController(erList);
            setCon.setSelected(erList);    
            Enrollment_Recycle_ControllerExt ext = new Enrollment_Recycle_ControllerExt(setCon);
            ext.getIsClassic();
            ext.ProcessSelection();
            }catch(exception e){}
        Test.StopTest();
    } 
    // Test without selected Recycle Records //T01
    static testMethod void testNoneSelected() {
        //TestUtil.Create_Error_Message();
        TestUtil.Create_Enrollment_Import();
    Date LastMonth = Date.today().toStartofMonth()-1; // Get last month
        String MM = String.valueOf(LastMonth.month());
        if ( LastMonth.month() < 10 ) {
            MM = ('0' + String.valueOf(LastMonth.month())); 
        }
        String YYYY = String.valueOf(LastMonth.Year());
        String RptDt = 'NO REC';               // Format CCYYMM
        String RunDt = Date.Today().format() + ' 5:00:00'; // Format MM/DD/CCYYY HH:MM:SS        
          List<Enrollment_Recycle__c> erList = new List<Enrollment_Recycle__c>();  
        // Create a record that has no known product
        Enrollment_Recycle__c er = new Enrollment_Recycle__c();           
        er.Account_Name__c = 'Any Account';
        er.Account_Number__c = 'CE12';        
        er.System__c =  'LuminX'; 
        er.Contracts__c = 100;            
        er.Processed_Type__c = 'M';
        er.Error_Message__c = 'No Salesforce Product found! Contact sfdcSupport@carefirst.com';
        er.Error_Number__c = '0001';
        er.Opportunity_Name__c = null;
        er.Risk__c = 'Risk';
        er.Rpt_dt__c = RptDt;
        er.Run_Dt__c = RunDt;
        er.Sales_Rep__c = 'Tester';
        er.SFDC_Product__c = 'NOTFOUND';                 
        erList.add(er);
        
       Id enRecordTypeId = Schema.SObjectType.Enrollment__c.getRecordTypeInfosByName().get('51+').getRecordTypeId();

        // Create a record that has no known system
        Enrollment_Recycle__c er2 = new Enrollment_Recycle__c();           
        er2.Account_Name__c = 'Any Account';
        er2.Account_Number__c = 'CE12';        
        er2.System__c =  'NoSuchSystem'; 
        //er2.System__c =  'NASCO';
        er2.Contracts__c = 100;            
        er2.Processed_Type__c = 'M';
        er2.Error_Message__c = 'System not found in Salesforce';
        er2.Error_Number__c = '0002';
        er2.Opportunity_Name__c = null;
        er2.Risk__c = 'Risk';
        er2.Rpt_dt__c = RptDt;
        er2.Run_Dt__c = RunDt;
        er2.Sales_Rep__c = 'Tester';
        er2.SFDC_Product__c = 'BC Advantage';                 
        erList.add(er2);
        
        Enrollment_Recycle__c er3 = new Enrollment_Recycle__c();           
        er3.Account_Name__c = 'Any Account';
        er3.Account_Number__c = 'CE12';        
        //er3.System__c =  'NoSuchSystem'; 
        er3.System__c =  'NASCO';
        er3.Contracts__c = 100;            
        er3.Processed_Type__c = 'M';
        er3.Error_Message__c = 'System not found in Salesforce';
        er3.Error_Number__c = '0002';
        er3.Opportunity_Name__c = null;
        er3.Risk__c = 'Risk';
        er3.Rpt_dt__c = 'NO REC';
        er3.Run_Dt__c = RunDt;
        er3.Sales_Rep__c = 'Tester';
        er3.SFDC_Product__c = 'BC Advantage'; 
        er3.New_Business_Indicator__c='N';                
        //erList.add(er3);          
        insert er3;
         // if  ( erList.size() > 0 ) {         
            insert erList; 
             system.debug('---er3-----'+er3+'---erList----'+erList+'--size---'+erList.size());
      //  }
        //Date dt = Date.Today();   
       // String RptDt = dt.year() + '02';
        
        Enrollment_Import__c EnImp = new Enrollment_Import__c();
        EnImp.Account_Name__c = 'TestAccount';
        EnImp.Account_Number__c = '1220';        
        EnImp.System__c = 'NASCO';
        EnImp.Contracts__c = 50;
        EnImp.Processed__c = FALSE;
        EnImp.Processed_Type__c = 'M';
        EnImp.Risk__c = 'Non-Risk';
        EnImp.Rpt_dt__c = RptDt;
        EnImp.Run_Dt__c = RptDt;
        EnImp.SFDC_Product__c = 'Standard Price Book1';    
        
        insert EnImp;
        Enrollment_Import__c EnImp2 = new Enrollment_Import__c();
        EnImp2.Account_Name__c = 'TestAccount';
        EnImp2.Account_Number__c = '1220';        
        EnImp2.System__c = 'NASCO';
        EnImp2.Contracts__c = 50;
        EnImp2.Processed__c = FALSE;
        EnImp2.Processed_Type__c = 'M';
        EnImp2.Risk__c = 'Non-Risk';
        EnImp2.Rpt_dt__c = RptDt;
        EnImp2.Run_Dt__c = RptDt;
        EnImp2.SFDC_Product__c = 'Standard Price Book1';    
        
        insert EnImp2;
        system.debug('---EnImp2------'+EnImp2 +'--erList------'+erList);
        /* Error_Message__c ee3=new Error_Message__c();
    ee3.Error_Number__c='0002';
    ee3.Error_Message__c='test3';
    ee3.Error_Number_Type__c='User';
    ee3.Source_Type__c='Enrollment';
    insert ee3;*/
        testUtil.createEnrollmentTestData(); 
        // T01 Changes Ends Here
       List<Enrollment_Recycle__c> ers = [ SELECT id, Rpt_Dt__c, Account_Name__c, Account_Number__c, Contracts__c, Error_Message__c,
                                                   Sales_Rep__c, Error_Number__c, Processed_Type__c, SFDC_Product__c, Risk__c, Run_Dt__c, System__c, Rating_State__c, New_Business_Indicator__c  
                                           FROM Enrollment_Recycle__c Where Rpt_Dt__c = 'NO REC' and id=:er3.id];     
        system.debug('---ers ------'+ers);
        ApexPages.StandardSetController setCon = new ApexPages.standardSetController(ers);
        Test.StartTest();     
        try{
            Enrollment_Recycle_ControllerExt ext = new Enrollment_Recycle_ControllerExt(setCon);
            ext.ProcessSelection();
            
          }catch(exception e){}
        Test.StopTest();  
    }  
}