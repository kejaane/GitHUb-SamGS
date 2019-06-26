public class SLDSTaskLookupController {
    // public variables 
    public String objectName{get;
                             set{
                                 if(objectName != value){
                                     objectName = value;
                                     objectLabelPlural = Schema.getGlobalDescribe().get(ObjectName).getDescribe(). getLabelPlural();
                                 }
                             }
                             
                            }
    
    public String label{
        get;
        set{
            label = value;
            uniqueComponentId = label.replace(' ', '').toLowerCase();
        }
    }
    
    public String uniqueComponentId{get;set;}
    public String objectLabelPlural{get;set;}
    
    /**
* Remote action method to send list of records
* @param  searchText 
* @return  List<Wrapper>
*/
    @RemoteAction
    public static List<Wrapper> search(String objectName, String displayFieldNames, String fieldsPattern, String photoValue,String searchText) {
        String query;
        List<String> displayFieldNamesLst;
        String photoFieldName;
        List<Wrapper> results = new List<Wrapper>();
        String finalQuery;
        String photoToDisplay;
        
        if(String.isBlank(fieldsPattern)){
            fieldsPattern = displayFieldNames;
        }
        
        //prepare a where clause
        displayFieldNamesLst = displayFieldNames.split(',');
        String whereClause = '';

        for(String fieldName : displayFieldNamesLst){
            whereClause += String.isBlank(whereClause) ? ' WHERE ' + fieldName + ' LIKE \'%{text}%\'' : ' OR ' + fieldName + ' LIKE \'%{text}%\'';
            
        }
       //  whereClause += ' GROUP BY Owner.Name,Owner.Id';
        
        //add Id field to field names if necessary
        if(!displayFieldNames.toLowerCase().contains('id')){
          displayFieldNames += ', Owner.Id';
        }
        
        //add photo field if not added
        
        if(photoValue.toLowerCase().contains('field')){
            List<String> photoValueLst = photoValue.split('->');
            if(photoValueLst.size() > 1 && !displayFieldNames.toLowerCase().contains(photoValueLst[1].toLowerCase())){
                photoFieldName = photoValueLst[1];
                displayFieldNames += ', '+photoValueLst[1];
            }
        }else if(photoValue.toLowerCase().contains('url')){
            List<String> photoValueLst = photoValue.split('->');
            if(photoValueLst.size() > 1){
                photoToDisplay = photoValueLst[1];
            }
        }
        
        query = 'SELECT ' + displayFieldNames + ' FROM ' + objectName + whereClause;
        finalQuery = query.replace('{text}', searchText);
        List<sObject> l = database.query(finalQuery);
        
        
        System.debug('AG finalQuery : ' + l);
        System.debug('AG finalQuery : ' + displayFieldNamesLst);
        Boolean isexist;
        for(Sobject sobj : database.query(finalQuery)){
            String displayValue = fieldsPattern;
            isexist = false;
            for(String fieldName : displayFieldNamesLst){
                
                String sFieldSub1 = fieldName.SubString(0,fieldName.indexof('.'));
                String sFieldSub2 = fieldName.SubString(fieldName.indexof('.') + 1,fieldName.Length()); 
                String fieldValue = String.valueOf((sobj.getSObject(sFieldSub1)).get(sFieldSub2));
                
             //         String fieldValue = sobj.get(fieldName) == null ? '' : String.valueOf(sobj.get(fieldName));
                displayValue = displayValue.replace(fieldName, fieldValue);
                
                //  System.debug('AG displayValue : ' + displayValue);
                
                if(String.isNotBlank(photoFieldName) && sobj.get(photoFieldName) != null){
                    photoToDisplay = String.valueOf(sobj.get(photoFieldName));
                }
                System.debug('AG photoFieldName : ' + photoFieldName);
            }
            for(Wrapper wr : results ){
                if(wr.displayValue == displayValue){
                    isexist = true;
                }
            }
            if(!isexist)
            results.add(new Wrapper(String.valueOf((sobj.getSObject('Owner')).get('Id')), displayValue,photoToDisplay));            
        }
        return results;
    }
    
    
    /*************************************************************************
******************************* WRAPPER **************************************
****************************************************************************/
    public class Wrapper{
        public Id recordId{get;set;}
        public String displayValue{get;set;}
        public String photoUrl{get;set;}
        public Wrapper(Id recordId, String displayValue,string photoUrl){
            this.recordId = recordId;
            this.displayValue = displayValue;
            this.photoUrl = photoUrl;
        }
    }
}