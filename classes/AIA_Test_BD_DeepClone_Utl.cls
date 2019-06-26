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
//=========================================================================================
// Date: 07/28/2017
// Developer: Goutham Rapolu
// Purpose: Used to create test class for AIA_BD_DeepClone Class
//
//=========================================================================================

@IsTest
public class AIA_Test_BD_DeepClone_Utl {
    
    //Creating Test Data for AIA_Config__c
    public static AIA_Config__c conf(){
        AIA_Config__c aiaCon =  new AIA_Config__c();
        aiaCon.Run__c = true;
        aiaCon.Name = 'BDTHelper.createBenefitDesignProduct';
        Insert aiaCon;
        Return aiaCon;
    }
    //Creating Test data for AIA_Benefit_Design_Form__c
    Public Static AIA_Benefit_Design_Form__c aiaBenf(String bend){
    AIA_Benefit_Design_Form__c aiaBDF = new AIA_Benefit_Design_Form__c();       
    aiaBDF.Benefit_Design__c = bend;        
    aiaBDF.Michelle_s_Law_4a__c = 'Yes';        
    aiaBDF.Child_Dependents_Limit_Age_4a__c =26;        
    aiaBDF.Michelle_s_Law_Waiver_4a__c = 'Yes';     
    aiaBDF.Students_Limit_Age_4a__c = 26;       
    aiaBDF.Child_Dependents_Removal_Method_4a__c = 'End of Calendar Month';     
    aiaBDF.Students_Removal_Method_4a__c = 'End of Calendar Month';     
    aiaBDF.Part_time_Students_with_Disabilities_4a__c ='No';      
    aiaBDF.Number_Of_Eligibles__c='10';
    //aiaBDF.External_Review_Processing_Comments__c = 'Hello';
    insert aiaBDF;
    Return aiaBDF;
    }
    
    Public Static AIA_Benefit_Design_Form__c aiaBenf1(){
    AIA_Benefit_Design_Form__c aiaBDF = new AIA_Benefit_Design_Form__c();       
    //aiaBDF.Benefit_Design__c = bend;        
    aiaBDF.Michelle_s_Law_4a__c = 'Yes';        
    aiaBDF.Child_Dependents_Limit_Age_4a__c =26;        
    aiaBDF.Michelle_s_Law_Waiver_4a__c = 'Yes';     
    aiaBDF.Students_Limit_Age_4a__c = 26;       
    aiaBDF.Child_Dependents_Removal_Method_4a__c = 'End of Calendar Month';     
    aiaBDF.Students_Removal_Method_4a__c = 'End of Calendar Month';     
    aiaBDF.Part_time_Students_with_Disabilities_4a__c ='No';      
    aiaBDF.Number_Of_Eligibles__c='10';
    //aiaBDF.External_Review_Processing_Comments__c = 'Hello';
    //insert aiaBDF;
    Return aiaBDF;
    }
    //Creating Test data for AIA_Benefit_Design__c
    Public Static AIA_Benefit_Design__c aiaBen(String imp, String acc, String benrf){
    AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
    aiaBD.Implementation__c = imp;
    aiaBD.Account__c = acc;
    aiaBD.Benefit_Request_Form__c = benrf;
    insert aiaBD;
    Return aiaBD;
    }

}