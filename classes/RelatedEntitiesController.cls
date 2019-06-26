/*=========================================================================================
 * Date         : 11/4/17
 * Developer    : Arshia Gulati
 * Purpose      : This class provides a service layer for the rest of the application to access functionality of
 * 				  the Facets Data LookUp Service to fetch Related Entities for a Group. 
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/04/17  |  AG    | Initial Version developed for User story B-03752                                         
 *=========================================================================================
 */

public With Sharing class RelatedEntitiesController {
    public Related_Entity__c objRelEnt {get;set;}   
    public Related_Entity__c selectedRE {get;set;}
    public List<Related_Entity__c> lstRelEnt {get;set;}   
    public Boolean showREList {get;set;} 
    public Boolean showREDet {get;set;} 
    public string selectedEntityId {get;set;} 
      
    public RelatedEntitiesController(ApexPages.StandardController controller) {
        lstRelEnt = new List<Related_Entity__c>();
        objRelEnt = (Related_entity__c) controller.getRecord();
        showREList = false;   
        showREDet = false;        
    }   
  
 /************************************************************************************************
 * Purpose   : Call Facets DataLookUp Service to retrieve related entities. This method is called 
 * 			   when user clicks the button 'Get Related Entities' from Related Entities Page.
 *             
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************************/ 
   public void getRelatedEntities(){
       showREList = false;
       showREDet = false;
       selectedEntityId = null;
       selectedRE = null;
       if( objRelEnt.Group_ID__c == '' || objRelEnt.Group_ID__c == Null)       
                 {
                     System.Debug('groupid : ' + objRelEnt.Group_ID__c);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a Group ID.')); // show error if Group ID is blank
                    Return;
                 }
        if((!pattern.matches('[a-zA-Z0-9]+',objRelEnt.Group_ID__c)) || (objRelEnt.Group_ID__c.length() != 4)){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Group Id entered is not valid.'));
           Return;
       }
         else
         {
         
       lstRelEnt.clear();
       FDL_FacetsDataLookUpRequest objRERequest = new FDL_FacetsDataLookUpRequest();
       objRERequest.groupID = objRelEnt.Group_ID__c;
       FDL_FacetsDataLookUpResponse objREResponse = FDL_FacetsDataLookUpService.getRelatedEntities(objRERequest);
           
       System.Debug('objRelatedEntities : ' + objREResponse);
       System.Debug('status :' + objREResponse.status);
             
       objRelEnt.Group_ID__c = objREResponse.groupId; 
       if(objREResponse.status != 'SUCCESS')
       {
           if (objREResponse.statusCode == 'E006')
           {
           	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Group ID entered does not exist in Facets system.')); 
           }
           else 
           {
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error response received from Facets Service. Support team has been notified.')); 
           }                      
           Return;
       }
       for(FDL_FacetsDataLookUpResponse.FDL_RelatedEntity objRE : objREResponse.relatedEntity)
       {
           objRelEnt = new Related_Entity__c();
           	objRelEnt.Name =  objRE.relatedEntityName;
           	objRelEnt.Category__c = objRE.groupRelationshipCategory;
            if(objRE.relatedEntityType.split('-').size() > 0)   objRelEnt.Type_Code__c = objRE.relatedEntityType.split('-')[0] ; 
            if(objRE.relatedEntityType.split('-').size() > 1)   objRelEnt.Type_Desc__c = objRE.relatedEntityType.split('-')[1] ; 
            String sDate = objRE.groupRelationshipEffDt.substring(6,6+4) + '-' + objRE.groupRelationshipEffDt.substring(0,2) + '-' + objRE.groupRelationshipEffDt.substring(3,5) + ' 00:00:00';
    		objRelEnt.Effective_Date__c = Date.valueOf(sDate);
            sDate = objRE.groupRelationshipTermDt.substring(6,6+4) + '-' + objRE.groupRelationshipTermDt.substring(0,2) + '-' + objRE.groupRelationshipTermDt.substring(3,5) + ' 00:00:00';
         	objRelEnt.Termination_Date__c = Date.valueOf(sDate);
         	objRelEnt.Entity_ID__c = objRE.relatedEntityID ;
        	objRelEnt.Email__c = objRE.relatedEntityEmail  ;
           if(!(string.isEmpty(objRE.relatedEntityFax) || string.isBlank(objRE.relatedEntityFax))) {
				objRelEnt.Fax__c = '(' + objRE.relatedEntityFax.substring(0,3) + ') ' + objRE.relatedEntityFax.substring(3,6) + '-' + objRE.relatedEntityFax.substring(6,10);
           }
            if(!(string.isEmpty(objRE.relatedEntityPhone) || string.isBlank(objRE.relatedEntityPhone))) {
				objRelEnt.Phone__c = '(' + objRE.relatedEntityPhone.substring(0,3) + ') ' + objRE.relatedEntityPhone.substring(3,6) + '-' + objRE.relatedEntityPhone.substring(6,10);
           }
        	if(objRE.groupRelationshipTermReason.split('-').size() > 0) objRelEnt.Relationship_Term_Reason_Code__c = objRE.groupRelationshipTermReason.split('-')[0] ;
            if(objRE.groupRelationshipTermReason.split('-').size() > 1) objRelEnt.Relationship_Term_Reason_Desc__c = objRE.groupRelationshipTermReason.split('-')[1] ;
        	objRelEnt.AddressLine1__c = objRE.relatedEntityAddrline1  ;
        	objRelEnt.AddressLine2__c = objRE.relatedEntityAddrline2 ;
           objRelEnt.AddressLine3__c = objRE.relatedEntityAddrline3 ;
           if(!(string.isEmpty(objRE.relatedEntityCounty) || string.isBlank(objRE.relatedEntityCounty))) {
               objRelEnt.County__c = objRE.relatedEntityCounty + ' County'; 
           }           
           objRelEnt.AddressLine4__c = objRE.relatedEntityCity + ', ' + objRE.relatedEntityState + ' '+ objRE.relatedEntityZip ; 
           if(objRelEnt.AddressLine4__c.deleteWhitespace().equals(',')) {
               objRelEnt.AddressLine4__c = objRelEnt.County__c;
               objRelEnt.County__c = '';
           }
           if(string.isEmpty(objRelEnt.AddressLine3__c) || string.isBlank(objRelEnt.AddressLine3__c)) {
               objRelEnt.AddressLine3__c = objRelEnt.AddressLine4__c; 
               objRelEnt.AddressLine4__c = objRelEnt.County__c;
               objRelEnt.County__c = '';
           }
           if(string.isEmpty(objRelEnt.AddressLine2__c) || string.isBlank(objRelEnt.AddressLine2__c)) {
               objRelEnt.AddressLine2__c = objRelEnt.AddressLine3__c; 
               objRelEnt.AddressLine3__c = objRelEnt.AddressLine4__c; 
               objRelEnt.AddressLine4__c = objRelEnt.County__c;
               objRelEnt.County__c = '';
           }           
            objRelEnt.City__c = objRE.relatedEntityCity ;           
           	lstRelEnt.add(objRelEnt);
       }
       if(lstRelEnt.size() > 0) showREList = true;
      
         }
   
    }
    
 /************************************************************************************************
 * Purpose   : Show Related Entities Details when user selects a related entity record in the list
 *             
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************************/ 
    public void ShowREDetails(){     
     for(Related_Entity__c obj : lstRelEnt)
     {
         System.Debug('obj.Entity_ID__c: '+ obj.Entity_ID__c + '-' + obj.Type_Code__c);
         System.Debug('selectedEntityId: '+ selectedEntityId);
         if(obj.Entity_ID__c + '-' + obj.Type_Code__c == selectedEntityId )
         {
             selectedRE = obj;             
             showREDet = true;
             break;
         }         
     }      
    }
 /************************************************************************************************
 * Purpose   : Refresh the Related Entities page when user clicks the cancel button.
 *             
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************************/ 
    public pagereference CustomCancel(){
      pagereference pg = New Pagereference('/apex/RelatedEntityPage');
      pg.setredirect(true);
      return pg;
      }
}