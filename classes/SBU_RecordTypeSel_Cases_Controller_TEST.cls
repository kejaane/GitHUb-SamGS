@isTest
private class  SBU_RecordTypeSel_Cases_Controller_TEST {
//Variable declaration
   public Static Case objCase;
   static id rtid ;
   Public Static void CreateCase(){
   RecordType rt = [select id,Name from RecordType where SobjectType='Case'and IsActive!=False Limit 1];
   rtid = querybase.getrecordtypeid('case', 'SBU_Member_Case');
   // Id RTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Group_Case').getRecordTypeId();
  //  system.debug('REcordtypeid:::'+RTypeId);
    objCase = new Case();
    objCase.RecordTypeid= rt.id;
    insert objCase;
   
   }
    static testMethod void testValidate(){
    Test.StartTest();
    CreateCase();
    Test.StopTest();
    SBU_RecordTypeSelection_Cases_Controller  ctrlRecord = new SBU_RecordTypeSelection_Cases_Controller(new ApexPages.StandardController(objCase));
    
    ctrlRecord.getRecordTypes();
    ctrlRecord.getselop();
    string selected='rt.name';
    ctrlRecord.Continuous();
    ctrlRecord.selected = rtid;
    ctrlRecord.Continuous();
   
    }
   }