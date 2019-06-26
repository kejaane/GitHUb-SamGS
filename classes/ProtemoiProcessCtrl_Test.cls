/*=========================================================================================
 * Date         : 09/30/2016
 * Developer    : Rajesh Pennam
 * Purpose      : This class is used to test the functionlaity of the ProtemoiProcessCtrl
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 09/30/16  |  Rajesh Pennam   | Initial Version                                         
 *           |        | 
 *=========================================================================================
 */
@isTest
public class ProtemoiProcessCtrl_Test{
    public static testmethod void test(){
        //create Intitiative Record
        Protemoi__c ptm = new Protemoi__c();
        insert ptm;
        ApexPages.CurrentPage().getparameters().put('id', ptm.id);
        ApexPages.StandardController sc = new ApexPages.standardController(ptm);
        ProtemoiProcessCtrl obj = new ProtemoiProcessCtrl(sc);
    }
}