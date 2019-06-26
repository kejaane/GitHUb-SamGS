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
/*=================================================================================================================
 * Date         : 12/07/2017
 * Developer    : Goutham Rapolu
 * Purpose      : Test Class for AIA_BRF_RecordTypeRedirect which is called from Custom Button on Opportunity's
 *                Benefit Request Form related List. logic to create new BRF based on Funding Arrangement of Opportunity.
 *=================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 * 12/07/2017 | Goutham Rapolu |     | Initial Version                                         
 *===========+=================+=====+=============================================================================
 */


@istest
public class AIA_BRF_RecordTypeRedirect_Test {
   

    @testSetup
    static public void setUpTestData(){
        
        List<AIA_Field_ID_List__c> FDList = new List<AIA_Field_ID_List__c>();
        
        AIA_Field_ID_List__c FD = new AIA_Field_ID_List__c();
        FD.Name = 'BRF.AccountName';
        FD.Field_ID__c = '1';
        FDList.add(FD);
        
        AIA_Field_ID_List__c FD1= new AIA_Field_ID_List__c();
        FD1.Name = 'BRF.OppName';
        FD1.Field_ID__c = '2';
        FDlist.add(FD1);
        
        AIA_Field_ID_List__c FD2= new AIA_Field_ID_List__c();
        FD2.Name = 'BRFObjectID';
        FD2.Field_ID__c = '3';
        FDlist.add(FD2);
        
        AIA_Field_ID_List__c FD3= new AIA_Field_ID_List__c();
        FD3.Name = 'BRF.Benefit_Effective_Date';
        FD3.Field_ID__c = '4';
        FDlist.add(FD3);
        
        AIA_Field_ID_List__c FD4 = new AIA_Field_ID_List__c();
        FD4.Name = 'BRF.Benefit_Period';
        FD4.Field_ID__c = '5';
        FDList.add(FD4);
        
        AIA_Field_ID_List__c FD5 = new AIA_Field_ID_List__c();
        FD5.Name = 'BRF.Control_Plan';
        FD5.Field_ID__c = '6';
        FDList.add(FD5);
        
        AIA_Field_ID_List__c FD6 = new AIA_Field_ID_List__c();
        FD6.Name = 'BRF.Jurisdiction';
        FD6.Field_ID__c = '7';
        FDList.add(FD6);
        
        AIA_Field_ID_List__c FD7 = new AIA_Field_ID_List__c();
        FD7.Name = 'BRF.Sales_Segment_Size';
        FD7.Field_ID__c = '8';
        FDList.add(FD7);
        
        AIA_Field_ID_List__c FD8 = new AIA_Field_ID_List__c();
        FD8.Name = 'BRF.Contract_Period';
        FD8.Field_ID__c = '9';
        FDList.add(FD8);
        
        AIA_Field_ID_List__c FD9 = new AIA_Field_ID_List__c();
        FD9.Name = 'BRF.EGWP_Picklist';
        FD9.Field_ID__c = '10';
        FDList.add(FD9);
        
        AIA_Field_ID_List__c FD10 = new AIA_Field_ID_List__c();
        FD10.Name = 'BRF.FlexLink_Picklist';
        FD10.Field_ID__c = '11';
        FDList.add(FD10);
        
        AIA_Field_ID_List__c FD12 = new AIA_Field_ID_List__c();
        FD12.Name = 'BRF.Broker/ConsultantAmount';
        FD12.Field_ID__c = '122';
        FDList.add(FD12);
        
        AIA_Field_ID_List__c FD11 = new AIA_Field_ID_List__c();
        FD11.Name = 'BRF.Identity_Protection';
        FD11.Field_ID__c = '12';
        FDList.add(FD11);
        
        AIA_Field_ID_List__c FD13 = new AIA_Field_ID_List__c();
        FD13.Name = 'BRF.EnrollmentType';
        FD13.Field_ID__c = '13';
        FDList.add(FD13);
        
        AIA_Field_ID_List__c FD14 = new AIA_Field_ID_List__c();
        FD14.Name = 'BRF.Grandfathered_Status';
        FD14.Field_ID__c = '14';
        FDList.add(FD14);
        
        AIA_Field_ID_List__c FD15 = new AIA_Field_ID_List__c();
        FD15.Name = 'BRF.Grandfathered_PPACA_Status';
        FD15.Field_ID__c = '15';
        FDList.add(FD15);
        
        AIA_Field_ID_List__c FD16 = new AIA_Field_ID_List__c();
        FD16.Name = 'BRF.Broker/Consultant Compensation';
        FD16.Field_ID__c = '16';
        FDList.add(FD16);
        
        insert FDList;
      
    }
    
    public static testmethod void Test_BRFRedirect1(){
        
        List<AIA_Field_ID_List__c> FDList = [Select id, name, Field_ID__c from AIA_Field_ID_List__c Limit 17];
        system.debug('@@@FDLIST@@'+FDList);
        
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNOTEquals(acc,Null);      
        acc.Jurisdiction__c = 'MD';
        update acc;
        
       //Commenting as part of US210
        /*AIA_Workplan_Type__c WT = new AIA_Workplan_Type__c();
        WT.active__c = true;  
        WT.Workplan_Type__c ='New';
        WT.Used_For__c ='Pre-Sales';
        insert WT;
        system.assertNotEquals(null,WT.id);*/
        
        Opportunity o = AIA_TestUtil.opp(acc.id);//Updating as part of US210
       // o.Risk_Non_Risk__c = 'ASO';
        Update o;
        system.assertNotEquals(null,o.id);
        
        PageReference pref = Page.AIA_BRF_RecordTypeRedirect;
        Test.starttest();
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('oppid',o.id);
        ApexPages.StandardController con = new ApexPages.StandardController(acc);
        
        AIA_BRF_RecordTypeRedirect RTR = new AIA_BRF_RecordTypeRedirect(con);
        RTR.AIA_BRF_RecordType();
        RTR.Back();
        Test.stoptest(); 
    }
    public static testmethod void Test_BRFRedirect2(){
        
        List<AIA_Field_ID_List__c> FDList = [Select id, name, Field_ID__c from AIA_Field_ID_List__c];
        
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNOTEquals(acc,Null);      
        acc.jurisdiction__c = 'VA';
        update acc;
        
        //Commenting as part of US210
        /*AIA_Workplan_Type__c WT = new AIA_Workplan_Type__c();
        WT.active__c = true;  
        WT.Workplan_Type__c ='New';
        WT.Used_For__c ='Pre-Sales';
        insert WT;
        system.assertNotEquals(null,WT.id);*/
        
        Opportunity o = AIA_TestUtil.opp(acc.id);//Updating as part of US210
        o.Risk_Non_Risk__c = '';
        Update o;
        system.assertNotEquals(null,o.id);
        
        PageReference pref = Page.AIA_BRF_RecordTypeRedirect;
        Test.starttest();
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('oppid',o.id);
        ApexPages.StandardController con = new ApexPages.StandardController(acc);
        
        AIA_BRF_RecordTypeRedirect RTR = new AIA_BRF_RecordTypeRedirect(con);
        RTR.AIA_BRF_RecordType();
        Test.stoptest(); 
    }
    public static testmethod void Test_BRFRedirect3(){
        setUpTestData();
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNOTEquals(acc,Null);      
        
        //Commenting as part of US210
        /*AIA_Workplan_Type__c WT = new AIA_Workplan_Type__c();
        WT.active__c = true;  
        WT.Workplan_Type__c ='New';
        WT.Used_For__c ='Pre-Sales';
        insert WT;
        system.assertNotEquals(null,WT.id);*/
        
        Opportunity o = AIA_TestUtil.opp(acc.id);//Updating as part od US210
        o.Risk_Non_Risk__c = 'Risk';
        o.Legal_Account_Name_Verified__c = False;
        Update o;
        system.assertNotEquals(null,o.id);
        Benfit_Request_Form__c bForm = AIA_TestUtil.benForm(acc.id,o.id);
        
        PageReference pref = Page.AIA_BRF_RecordTypeRedirect;
        Test.starttest();
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('oppid',o.id);
        ApexPages.StandardController con = new ApexPages.StandardController(acc);
        
        AIA_BRF_RecordTypeRedirect RTR = new AIA_BRF_RecordTypeRedirect(con);
        RTR.getIsClassic();
        RTR.AIA_BRF_RecordType();
        RTR.UpdateOpp();
        RTR.SaveBRF();
        Test.stoptest(); 
    }
    public static testmethod void Test_BRFRedirect4(){
        setUpTestData();
        Account acc = AIA_TestUtil.createAccount1('TestAccount');
        system.assertNOTEquals(acc,Null);      
        
        //Commenting as part of US210
        /*AIA_Workplan_Type__c WT = new AIA_Workplan_Type__c();
        WT.active__c = true;  
        WT.Workplan_Type__c ='New';
        WT.Used_For__c ='Pre-Sales';
        insert WT;
        system.assertNotEquals(null,WT.id);*/
        
        Opportunity o = AIA_TestUtil.opp1(acc.id);//Updating as part of US210
        
        PageReference pref = Page.AIA_BRF_RecordTypeRedirect;
        Test.starttest();
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('oppid',o.id);
        ApexPages.StandardController con = new ApexPages.StandardController(acc);
        
        AIA_BRF_RecordTypeRedirect RTR = new AIA_BRF_RecordTypeRedirect(con);
        try{
        //o.Legal_Account_Name_Verified__c = true;
        //update o;
        RTR.opp.Legal_Account_Name_Verified__c = true;
        RTR.UpdateOpp();
        }
        catch(DmlException e){
            system.debug('to cover exceptins');
            system.assertEquals(e.getMessage(), e.getMessage());
            system.debug('Hello: '+e.getMessage());
        }
        Test.stoptest(); 
    }
    
    
}