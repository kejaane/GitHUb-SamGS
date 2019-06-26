/*=========================================================================================
 * Date         : 08/03/2016
 * Developer    : Rajesh Pennam
 * Purpose      : This class is used to test the functionlaity of the InitiativeProcessCtrl
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 07/14/16  |  Rajesh Pennam   | Initial Version                                         
 *           |        | 
 *=========================================================================================
 */
@isTest
public class InitiativeProcessCtrl_Test{
    public static testmethod void test(){
        //create Intitiative Record
        Initiative__c ini = new Initiative__c();
        insert ini;
        ApexPages.CurrentPage().getparameters().put('id', ini.id);
        ApexPages.StandardController sc = new ApexPages.standardController(ini);
        InitiativeProcessCtrl obj = new InitiativeProcessCtrl(sc);
    }
}