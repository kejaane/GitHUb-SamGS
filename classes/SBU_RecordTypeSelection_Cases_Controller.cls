/*########################################################################################################################
Class        :   SBU_RecordTypeSelection_Cases_Controller 
Author       :   Ashish Ojha
Created Date :   8/28/2016
Description  :   This is the controller class being used by the Visualforce page SBU_RecordTypeSelection_Cases.    
                 this class helps redirect a case based on the Record type selected. if it is Member Case it redirects to  
                 Member Case Visual force page or it will redirect to standard page to edit mode. Also, this class is with Sharing
                 so it will comply with the current user's security settings
                 
Note         : 
*/
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
//====================================================================================================

public with sharing class  SBU_RecordTypeSelection_Cases_Controller {

public string selected{get;set;}
public case cas;
  public SBU_RecordTypeSelection_Cases_Controller (ApexPages.StandardController controller)   
   {
       cas = new case();
       this.cas= (Case)controller.getRecord();  //assign the id of the case that we are changing the record type for
   }
         public list<RecordType> getRecordTypes()
       {
         list<recordtype> rectypelst = New List <recordtype>();
         //quering on case active record types
         list<RecordType> rtLst= [select Id, Name, Description, IsActive from RecordType where sObjectType='Case' and IsActive!=False ORDER by Name];
         For(recordtype rt: rtlst){
         
         //  have created a label  Named SBU_Record_type where the allowed record type for sbu unit is stored. we are getting the values from there.
             if(system.label.SBU_Record_type.contains(rt.name)){
             rectypelst.add(rt);
             }
             
         }
         return rectypelst;
    
       }
    
/************getselop method displays record type picklist values ******************/  
   public List<selectOption> getselop()
     {
        List<SelectOption> options = new List<SelectOption>();

     Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
     Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();

      for(id rtId: rtMapById.keyset())
       {
            
            if(system.label.SBU_Record_type.contains(rtMapById.get(rtId).getName())) // condition to only show restricted record type available in SBU_Record_Type label
              {
            
                options.add(new selectoption(rtId,rtMapById.get(rtId).getName())); // Option list to show record type value in pick list   
              }            
       }        
        return options;
   } 
   
   /*************************continuous method is for updating the existing case record type to selected one********************/
   public pageReference Continuous(){
       cas.recordTypeid =  selected; // new record type id added to the case
       
       if(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Member Case').getRecordTypeId() != selected){
        //redirecting to standard page of case to change existing case record type
           pageReference pg = new pageReference( '/' + cas.id+'/e?retURL=%2F'+ cas.id +'&RecordType=' + selected);
           pg.setRedirect(true);
           system.debug('first case: ' + selected);
           return pg;
           
           
       }else{
       //redirecting to custom vf page of SBU_Member_Case to change existing case record type
           pageReference pg = new pageReference( '/apex/SBU_Member_Case?id=' + cas.id+'&retURL=%2F'+ cas.id +'&RecordType=' + selected);
           pg.setRedirect(true);
           system.debug('2nd case: ' + selected);

           return pg;
       }
   }
   
}