@isTest
// This test is for the CFCT_CustomToolsHomePage_controller class
private class CFCT_CustomToolsHomePage_controller_Test {
    static testMethod void CFCT_CustomToolsHomePage_controller_Test1() {   
    boolean sysAdmin;  
    CFCT_CustomToolsHomePage_controller  pageCon = new CFCT_CustomToolsHomePage_controller();   
        Test.StartTest();
        sysAdmin = pageCon.getSysAdmin();
       	pageCon.getIsClassic();
        Test.StopTest();      
    }    
}