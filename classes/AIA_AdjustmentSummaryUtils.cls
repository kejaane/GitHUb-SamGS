/*****************************************************************************************************
 *Date: 03-01-2017
 *Developer: Bill Dodson
 *Purpose: Helper class for Adjustment Summary operations. 
 *====================================================================================================
 * Update History
 * Date         Developer               Description
 *====================================================================================================
 * 03-01-2017    Bill Dodson  |   |  Initial Development
 * 03-15-2016    Bill Dodson  |   |  Add new method to create adjustment records after 
 *                                   a new record is inserted or deleted.
 * 03-23-2017    Bill Dodson  |   |  Add logic to exclude fields.
 * 03-27-2017    Bill Dodson  |T01|  Only set one parent field, BRF or BD.
 * 03-29-2017    Bill Dodson  |T02|  Add more fields to the exclude fields list.
 * 04-05-2017    Bill Dodson  |   |  Modify to use field sets to identify fields to exclude.
 * 04-25-2017    Bill Dodson  |T03|  Modify to use field sets to identify fields in include.
 * 05-03-2017    Bill Dodson  |T04|  Add support for Grouper and RX Mandates. Add Product Name
 *                                   to Form Changed on Benefit, Limitation, RX Mandates.
 * 05-06-2017    Bill Dodson  |T05|  Add flag to disable adjustment summary.
 * 05-18-2017    Bill Dodson  |T06|  Add product name to Form Changed for PP and BDP products.
 *                                   Create a helper method to compute Form Changed field.
 * 05-18-2017    Bill Dodson  |T07|  Create helper method to format field values.
 * 07-14-2017    Bill Dodson  |T08|  New method to summarize adjustment records.
 * 07-25-2017    Bill Dodson  |T09|  Correct copy/paste error.
 * 08-04-2017    Bill Dodson  |T10|  Do not delete manually created Adjustment Summary records.
 * 08-09-2017    Bill Dodson  |T11|  Add logic to populate Adjustment Category field.
 * 08-14-2017    Bill Dodson  |T12|  Add integer to each Category so that drawloop can group by product.
 * 08-18-2017    Bill Dodson  |T13|  Add logic to process account adjustment records.
 * 08-21-2017    Bill Dodson  |T14|  Append name onto the end of Limitation for Form Changed.
 * 08-25-2017    Bill Dodson  |T15|  Modify Form Changed for Benefit Design Form records.
 * 08-28-2017    Bill Dodson  |T16|  Add Product Name to Form Changed for BDP.
 * 08-30-2017    Bill Dodson  |T17|  Group categories by BDP Name within the Form Changed field.
 * 09-01-2017    Bill Dodson  |T18|  Append comment code to field affected instead of form changed.
 * 09-14-2017    Bill Dodson  |T19|  Add logic to not filter out New records when appropriate.
 * 10-06-2017    Bill Dodson  |T20|  Add without sharing to the class definition.
 * 02-26-2018   Goutham Rapolu|T21|  Added logic to track Approval Response on BRF when BRF is resubmitted for ARC.
 *                                   as part of US713
 *======================================================================================================

 *******************************************************************************************************/
 
 public without sharing class AIA_AdjustmentSummaryUtils 
 {
    private static Boolean disableAdjustmentSummary = false;  // T05.
    
    public static void disableAdjustmentSummary() { disableAdjustmentSummary = true;  } // T05
    public static void enableAdjustmentSummary()  { disableAdjustmentSummary = false; } // T05
 
    // This method will create Adjustment Summary records when it is determined that a field has changed
    // value.
    public static void populateAdjustmentSummary(List<sObject> objList,    
                                                 Map<id, sObject> oldObjMap)
    {
        System.debug('At the top of populateAdjustmentSummary, objList.size(): ' + objList.size());
        
        if(disableAdjustmentSummary) // T05
        {
            System.debug('In populateAdjustmentSummary, returning because disableAdjustmentSummary is true');
            return;
        }
        
        // Only process records that originated from an update.  If the record originated from an insert
        // then remove it from the list.
        List<sObject> objUpdateList = removeNewObjects(objList, oldObjMap);                
    
        // If the list is empty then return.
        if(objUpdateList.size() == 0)
        {
            System.debug('In populateAdjustmentSummary, returning because objUpdateList is empty');
            return;
        }
        
        // Maps for the IDs which will point to the parent records.
        Map<id, id> objToBrfMap = getObjToBrfMap(objList);
        Map<id, id> objToBdMap  = getObjToBdMap(objList);
    
        Schema.DescribeSObjectResult r = objList[0].getSobjectType().getDescribe();
        
        // Call a local method to get the fields names and remove fields that should not be processed.
        Map<String, Schema.SObjectField> fieldMap = getFieldMap(r);
               
        // For each type of object that is a reference, build up a map of object IDs to object names.
        // This is done so that the object names can be retrieved in a bulkified fashion.
        Map<String,  Map <Id, String> > lookupRecordsMap = new Map<String,  Map <Id, String> >();
        //System.debug(logginglevel.FINE, 'objList>>' + objUpdateList);
        for(sObject objRec : objUpdateList)
        {        
            for(String apiName : fieldMap.keySet())
            {
                System.debug('apiName>>' + apiName);
                System.debug('Label Name>>' + fieldMap.get(apiName).getDescribe().getLabel());
                System.debug(apiName + '- old: ' + oldObjMap.get(objRec.id).get(apiName) + ', new: ' + objRec.get(apiName));
                if(objRec.get(apiName) != oldObjMap.get(objRec.id).get(apiName))
                {      
                    System.debug(apiName + ' has changed');    
                    //System.debug(logginglevel.FINE,'%%%%%apiName>>'+apiName);
                    //System.debug(logginglevel.FINE,'%%%%&&Label Name>>'+fieldMap.get(apiName).getDescribe().getLabel());
                    //System.debug(logginglevel.FINE,'%%%%&&Label Name>>'+fieldMap.get(apiName).getDescribe().getType());
                    String fieldType = String.valueOf(fieldMap.get(apiName).getDescribe().getType());
                    //System.debug(logginglevel.FINE,'%%%%%fieldType >>'+fieldType );
                    if(fieldType.equalsIgnoreCase('REFERENCE'))
                    {
                        Id newLookupId  = (id)(objRec.get(apiName));
                        Id oldLookupId  = (id)(oldObjMap.get(objRec.id).get(apiName));
                        String sObjName;
                        if(newLookupId != NULL)
                        {
                            sObjName = newLookupId.getSObjectType().getDescribe().getName();
                        }
                        else
                        {
                            sObjName = oldLookupId.getSObjectType().getDescribe().getName();
                        }
                        //System.debug(logginglevel.FINE, '%%%%%sObjName >>'+sObjName );                 
                        if (lookupRecordsMap.get(sObjName) == null)
                        {
                            lookupRecordsMap.put(sObjName, new Map <Id, String>());
                        }
                        lookupRecordsMap.get(sObjName).put(newLookupId, null);
                        lookupRecordsMap.get(sObjName).put(oldLookupId, null);
                    } 
                }
            }       
        }
        //System.debug(logginglevel.FINE, '%%%%%lookupRecordsMap >>'+lookupRecordsMap);
        for(String objectName : lookupRecordsMap.keySet())
        {
            Set<Id> recIds=lookupRecordsMap.get(objectName).keySet();
            for(sObject obj : Database.query('Select Id,Name from '+objectName+' where id in :recIds'))
            {
                lookupRecordsMap.get(objectName).put(Id.valueOf(obj.id),string.valueOf(obj.get('Name')));
            }            
        }
        
        List<Adjustment__c> listAdjustments = new List<Adjustment__c>();          
        
        //System.debug(logginglevel.FINE, 'objList>>' + objUpdateList);
        for(sObject objRec : objUpdateList)
        {
            for(String apiName : fieldMap.keySet())
            {
                System.debug('apiName2>>' + apiName);
                System.debug('Label Name2>>' + fieldMap.get(apiName).getDescribe().getLabel());
                if(objRec.get(apiName) != oldObjMap.get(objRec.id).get(apiName)) 
                {
                    System.debug(apiName + ' has changed, create adjustment summary record');
                    String fieldType = String.valueOf(fieldMap.get(apiName).getDescribe().getType());
                    System.debug(logginglevel.FINE, 'fieldType2 >>'+fieldType );
                    Adjustment__c adjustmentRec = new Adjustment__c();
                    
                    if(fieldType.equalsIgnoreCase('REFERENCE'))
                    {
                        System.debug('Reference field has changed');
                        //System.debug(logginglevel.FINE, 'fieldType2 0 >>'+fieldType );
                        Id newLookupId  = (id)(objRec.get(apiName));
                        Id oldLookupId  = (id)(oldObjMap.get(objRec.id).get(apiName));
                        String sObjName;
                        if(newLookupId != NULL)
                        {
                            sObjName = newLookupId.getSObjectType().getDescribe().getName();
                        }
                        else
                        {
                            sObjName = oldLookupId.getSObjectType().getDescribe().getName();
                        }             
                        if (lookupRecordsMap.get(sObjName) != null)
                        {
                            System.debug(logginglevel.FINE, 'sObjName >>'+lookupRecordsMap.get(sObjName).get(oldLookupId));
                            adjustmentRec.Previous_Value__c = lookupRecordsMap.get(sObjName).get(oldLookupId);
                            adjustmentRec.New_Value__c = lookupRecordsMap.get(sObjName).get(newLookupId);
                        }                                          
                        System.debug(logginglevel.FINE, 'adjustmentRec >>'+adjustmentRec);
                    }
                    
                    else
                    {
                        adjustmentRec.Previous_Value__c  = formatFieldValue(fieldType, oldObjMap.get(objRec.id).get(apiName)); // T07 String.ValueOf(oldObjMap.get(objRec.id).get(apiName));
                        adjustmentRec.New_Value__c       = formatFieldValue(fieldType, objRec.get(apiName));                   // T07 String.ValueOf(objRec.get(apiName));
                    }
                    
                    adjustmentRec.Form_changed__c        = getFormChanged(objRec); // T06              
                    adjustmentRec.Field_Affected__c      = getFieldAffected(fieldMap.get(apiName).getDescribe().getLabel(), objRec); // T18
                    adjustmentRec.Changed_by_User__c     = (Id)objRec.get('LastModifiedById');
                    adjustmentRec.DateTime_of_Change__c  = (Datetime)objRec.get('lastmodifieddate'); 
                    adjustmentRec.Adjustment_Category__c = getCategory(objRec); // T11
                    
                    system.debug('@@@@adjustmentRec@@:::'+adjustmentRec);
                                     
                    // T01, Only set one parent field. 
                    if(objToBdMap.get(objRec.Id) != NULL)
                    {
                        adjustmentRec.Benefit_Design__c = objToBdMap.get(objRec.Id);                         
                    }
                    else if(objToBrfMap.get(objRec.Id) != NULL) // T13
                    {
                        adjustmentRec.Benefit_Request_Form__c = objToBrfMap.get(objRec.Id); 
                    }
                    else if(adjustmentRec.Form_changed__c=='Approval Response') // T13
                    {
                        adjustmentRec.Benefit_Request_Form__c = objToBrfMap.get(objRec.Id); 
                    }
                    else
                    {
                        adjustmentRec.Account__c = objRec.Id; // T13   
                    }
                    
                    listAdjustments.add(adjustmentRec);
                    System.debug('@@@@adjustmentRec::: ' + adjustmentRec);
                }
            }
            
        }
        
        System.debug('In populateAdjustmentSummary, number of new Adjustment Summary records: ' + listAdjustments.size());
        
        if(listAdjustments.size() > 0)
        {   
            // Let exceptions propagate up.
            insert listAdjustments;
                
            System.debug('In populateAdjustmentSummary, successfully inserted: ' + listAdjustments.size() + ' records');
        } 
    }
    
    // Helper method to compute the Form Changed field value on the adjustment record.
    // T18, added this method.
    private static String getFieldAffected(String fieldLabel, sObject objRec) 
    {
        String fieldAffected = fieldLabel;
    
        String sObjName = objRec.getSObjectType().getDescribe().getName();
    
        if (sObjName == 'Limitations__c')
        {
            String type = (String)objRec.get('type__c');
            if(type == 'Comment')
            {
                fieldAffected = fieldAffected + ' - ' + ((String)objRec.get('comment_codes__c'));
            }
            else if(type == 'MaxRow')
            {
                fieldAffected = fieldAffected + ' - ' + ((String)objRec.get('maxrow_value__c'));
            }
            else if(type == 'TierLimit')
            {
                fieldAffected = fieldAffected + ' - ' + ((String)objRec.get('tier_value__c'));
            }                      
        }     
        
        return fieldAffected;
    } 
    
    // Helper method to format field values.
    private static String formatFieldValue(String fieldType, Object fieldValue) // T07
    {
        System.debug('At the top of formatFieldValue');
    
        String formattedFieldValue = '';
        
        if(fieldType.equalsIgnoreCase('DATE'))
        {
            System.debug('In formatFieldValue, field value: ' + String.ValueOf(fieldValue));
            
            if(fieldValue != NULL)
            {
                // For Date fields strip off the time portion so only the Date is shown.
                formattedFieldValue = ((Date)fieldValue).format();
            }
        }
        else
        {
            formattedFieldValue = String.ValueOf(fieldValue);
        }
        
        System.debug('At the bottom of formatFieldValue, formattedFieldValue: ' + formattedFieldValue);
    
        return formattedFieldValue;
    }
    
    // Helper method to compute the Form Changed field value on the adjustment record.
    private static String getFormChanged(sObject objRec) // T06
    {
        String formChanged;
    
        String sObjName = objRec.getSObjectType().getDescribe().getName();
    
        if (sObjName == 'AIA_Benefits__c')
        {   // T04
            formChanged = getProductName(objRec) + ' - ' + (String)objRec.get('benefit_name__c');
        }
        else if (sObjName == 'Limitations__c')
        {   // T04
            formChanged = getProductName(objRec) + ' - ' + (String)objRec.get('limitation_name__c');                     
        }     
        else if (sObjName == 'AIA_RxMandate__c')
        {   // T04
            formChanged = getProductName(objRec) + ' - ' + (String)objRec.get('Mandate_Name__c');
        }  
        else if (sObjName == 'AIA_Grouper__c')
        {   // T06
            formChanged = getProductName(objRec) + ' - ' + (String)objRec.get('Name');
        }  
        else if (sObjName == 'AIA_Benefit_Design_Product__c')
        {   // T06, T16
            formChanged = (String)objRec.get('Name') + ' - ' + (String)objRec.get('Product_Parent_Name__c');
        } 
        else if (sObjName == 'Proposed_Products__c')
        {   // T06
            formChanged = (String)objRec.get('Name') + ' - ' + objRec.getSObjectType().getDescribe().getLabel();
        }
        else if (sObjName == 'AIA_Benefit_Design_Form__c')
        {   // T15
            formChanged = (String)objRec.get('Name') + ' - ' + (String)objRec.get('form_type__c'); 
        }  
        else if (sObjName == 'Approval_Response__c') //T21 START
        {   
            formChanged = 'ARC' + ' - ' + (String)objRec.get('Business_Area__c'); 
        }    //T21 END                                                         
        else
        {
            formChanged = objRec.getSObjectType().getDescribe().getLabel();
        }   
        
        return formChanged;  
    }
    
    // Helper method to get the product name. // T04
    private static String getProductName(sObject objRec)
    {
        String productName;
        
        productName = (String)objRec.get('BDPName__c');
        
        if(productName == null)
        {
            productName = (String)objRec.get('PPName__c');
        }
        
        return productName;
    }
    
    // Helpter method to determine the category of the adjustment.
    // T11 begin
    private static String getCategory(sObject objRec)
    {        
        String category = '';
    
        String sObjName = objRec.getSObjectType().getDescribe().getName();
    
        if (sObjName == 'AIA_Benefits__c')
        {   
            category = (String)objRec.get('product_category__c');
        }
        else if (sObjName == 'Limitations__c')
        {   
            category = (String)objRec.get('product_category__c');
        }     
        else if (sObjName == 'AIA_RxMandate__c')
        {  
            category = (String)objRec.get('product_category__c');
        }  
        else if (sObjName == 'AIA_Grouper__c')
        {   
             category = (String)objRec.get('product_category__c');
        }  
        else if (sObjName == 'AIA_Benefit_Design_Product__c')
        {   
            category = (String)objRec.get('product_category__c');
        }    
        else if (sObjName == 'AIA_Benefit_Design_Form__c')
        {   
            category = (String)objRec.get('form_type__c');
        }           
        else if (sObjName == 'AIA_Benefit_Design__c')
        {   
            category = 'Benefit Design';
        } 
        else if (sObjName == 'Account') // T13
        {   
            category = 'Account';
        }
        else if (sObjName == 'Approval_Response__c') // T21
        {   
            category = 'Benefit Request Form';
        }                                                                                   
        else
        {
            System.debug('No Adjustment Category assigned to: ' + sObjName);
        }   
        
        return category;      
    }
    // T11 end
    
    // Any objects that don't have their system fields set yet are new records so remove them from 
    // the list.  We do not want to create Adjustment Summary records for newly inserted records.
    private static List<sObject> removeNewObjects(List<sObject> objList,    
                                                  Map<id, sObject> oldObjMap)
    {
        System.debug('At the top of removeNewObjects, objList.size(): ' + objList.size());
    
        List<sObject> objUpdateList = new List<sObject>();
        
        for(sObject objRec : objList)
        {
            if(oldObjMap.get(objRec.id).get('CreatedById') != null)
            {
                objUpdateList.add(objRec);
            }
        }
        
        System.debug('At the bottom of removeNewObjects, objUpdateList.size(): ' + objUpdateList.size());
        
        return objUpdateList;
    }
    
    // Get a map of object ID to Benefit Request Form object ID.
    private static Map<id, id> getObjToBrfMap(List<sObject> objList)
    {
        System.debug('At the top of getObjToBrfMap');
        
        Map<id, id> objToBrfMap = new Map<id, id>();
        
        String sObjName = objList[0].getSObjectType().getDescribe().getName();
        
        if(sObjName == 'Proposed_Products__c')
        {
            List<Proposed_Products__c> ppList = [SELECT Id, Benefit_Request_Form__c 
                                                 FROM Proposed_Products__c 
                                                 WHERE id IN: objList];
                                                 
            for(Proposed_Products__c pp : ppList)
            {
               objToBrfMap.put(pp.id, pp.Benefit_Request_Form__c); 
            }                                     
        }

        else if(sObjName == 'Benfit_Request_Form__c')
        {                                                 
            for(sObject obj : objList)
            {
               objToBrfMap.put(obj.id, obj.id); 
            }                                     
        } 
        else if(sObjName == 'AIA_Benefits__c')
        {                                                 
            List<AIA_Benefits__c> benList = [SELECT Id, Grouper__r.Proposed_Products__r.Benefit_Request_Form__c 
                                             FROM AIA_Benefits__c 
                                             WHERE id IN: objList];
                                
            for(AIA_Benefits__c ben : benList)
            {
               objToBrfMap.put(ben.id, ben.Grouper__r.Proposed_Products__r.Benefit_Request_Form__c);
            }  
        }  
        else if(sObjName == 'Limitations__c')
        {                                                 
            List<Limitations__c> limList = [SELECT Id, Benefit__r.Grouper__r.Proposed_Products__r.Benefit_Request_Form__c
                                            FROM Limitations__c 
                                            WHERE id IN: objList];
                                   
            for(Limitations__c lim: limList)
            {
               objToBrfMap.put(lim.id, lim.Benefit__r.Grouper__r.Proposed_Products__r.Benefit_Request_Form__c);
            }            
        }  
        else if(sObjName == 'AIA_Benefit_Design__c')
        {
            List<AIA_Benefit_Design__c> bdList = [SELECT Id, Benefit_Request_Form__c 
                                                  FROM AIA_Benefit_Design__c
                                                  WHERE id IN: objList];
                                                 
            for(AIA_Benefit_Design__c bd : bdList)
            {
               objToBrfMap.put(bd.id, bd.Benefit_Request_Form__c); 
            }                                     
        }     
        else if(sObjName == 'AIA_Benefit_Design_Product__c')
        {
            List<AIA_Benefit_Design_Product__c> bdpList = [SELECT Id, Benefit_Design__r.Benefit_Request_Form__c 
                                                           FROM AIA_Benefit_Design_Product__c
                                                           WHERE id IN: objList];
                                                 
            for(AIA_Benefit_Design_Product__c bdp : bdpList)
            {
               objToBrfMap.put(bdp.id, bdp.Benefit_Design__r.Benefit_Request_Form__c); 
            }                                     
        }  
        
        else if(sObjName == 'AIA_Grouper__c') // T04
        {                                                 
            List<AIA_Grouper__c> gprList = [SELECT Id, Proposed_Products__r.Benefit_Request_Form__c
                                            FROM AIA_Grouper__c
                                            WHERE id IN: objList];
                                    
            for(AIA_Grouper__c gpr: gprList)
            {
               objToBrfMap.put(gpr.id, gpr.Proposed_Products__r.Benefit_Request_Form__c);
            }            
        }         
        else if(sObjName == 'AIA_RxMandate__c') // T04
        {                                                 
            List<AIA_RxMandate__c> rxmList = [SELECT Id, Proposed_Products__r.Benefit_Request_Form__c 
                                              FROM AIA_RxMandate__c
                                              WHERE id IN: objList AND Proposed_Products__c != null];
                                
            for(AIA_RxMandate__c rxm: rxmList)
            {
               objToBrfMap.put(rxm.id, rxm.Proposed_Products__r.Benefit_Request_Form__c);
            }  
        }  
          else if(sObjName == 'Approval_Response__c') // T21 START
        {                                                 
            List<Approval_Response__c> ARList = [SELECT Id, Benefit_Request_Form__c ,Business_Area__c
                                              FROM Approval_Response__c
                                              WHERE id IN: objList AND Benefit_Request_Form__c != null];
                                
            for(Approval_Response__c rxm: ARList )
            {
               objToBrfMap.put(rxm.id, rxm.Benefit_Request_Form__c);
            }  
        }          //T21 END  
        else
        {
            System.debug(loggingLevel.ERROR, 'In getObjToBrfMap, unsupported object being processed: ' + sObjName);
        }                 
        
        System.debug('At the bottom of getObjToBrfMap, sObjName: ' + sObjName + ', objToBrfMap.size(): ' + objToBrfMap.size());
        
        return objToBrfMap;
    }
    
    // Get a map of object ID to Benefit Design object ID.
    private static Map<id, id> getObjToBdMap(List<sObject> objList)
    {
        System.debug('At the top of getObjToBdMap');
        
        Map<id, id> objToBdMap = new Map<id, id>();
        
        String sObjName = objList[0].getSObjectType().getDescribe().getName();
        
        if(sObjName == 'AIA_Benefit_Design__c')
        {
            List<AIA_Benefit_Design__c> bdList = [SELECT Id 
                                                  FROM AIA_Benefit_Design__c
                                                  WHERE id IN: objList];
                                                 
            for(AIA_Benefit_Design__c bd : bdList)
            {
               objToBdMap.put(bd.id, bd.id); 
            }                                     
        }   
        else if(sObjName == 'AIA_Benefit_Design_Form__c')
        {
            List<AIA_Benefit_Design_Form__c> bdfList = [SELECT Id, Benefit_Design__c
                                                        FROM AIA_Benefit_Design_Form__c
                                                        WHERE id IN: objList];
                                                 
            for(AIA_Benefit_Design_Form__c bdf : bdfList)
            {
               objToBdMap.put(bdf.id, bdf.Benefit_Design__c); 
            }         
        }
        else if(sObjName == 'AIA_Benefit_Design_Product__c')
        {
            List<AIA_Benefit_Design_Product__c> bdpList = [SELECT Id, Benefit_Design__c
                                                           FROM AIA_Benefit_Design_Product__c
                                                           WHERE id IN: objList];
                                                 
            for(AIA_Benefit_Design_Product__c bdp : bdpList)
            {
               objToBDMap.put(bdp.id, bdp.Benefit_Design__c); 
            }                                     
        } 
        else if(sObjName == 'AIA_Benefits__c')
        {                                                 
            List<AIA_Benefits__c> benList = [SELECT Id, Grouper__r.Benefit_Design_Product__r.Benefit_Design__c
                                             FROM AIA_Benefits__c 
                                             WHERE id IN: objList AND Grouper__r.Benefit_Design_Product__c != NULL];
                                                 
            for(AIA_Benefits__c ben : benList)
            {
               objToBdMap.put(ben.id, ben.Grouper__r.Benefit_Design_Product__r.Benefit_Design__c); 
            }                                     
        }  
        else if(sObjName == 'Limitations__c')
        {                                                 
            List<Limitations__c> limList = [SELECT Id, Benefit__r.Grouper__r.Benefit_Design_Product__r.Benefit_Design__c
                                            FROM Limitations__c 
                                            WHERE id IN: objList AND Benefit__r.Grouper__r.Benefit_Design_Product__c != NULL];
                                                 
            for(Limitations__c lim: limList)
            {
               objToBdMap.put(lim.id, lim.Benefit__r.Grouper__r.Benefit_Design_Product__r.Benefit_Design__c); 
            }                                     
        }          
        else if(sObjName == 'AIA_Grouper__c') // T04
        {                                                 
            List<AIA_Grouper__c> gprList = [SELECT Id, Benefit_Design_Product__r.Benefit_Design__c
                                            FROM AIA_Grouper__c
                                            WHERE id IN: objList AND Benefit_Design_Product__c != NULL];
                                                 
            for(AIA_Grouper__c gpr: gprList)
            {
               objToBdMap.put(gpr.id, gpr.Benefit_Design_Product__r.Benefit_Design__c); 
            }                                     
        }        
        else if(sObjName == 'AIA_RxMandate__c') // T04
        {                                                 
            List<AIA_RxMandate__c> rxmList = [SELECT Id, Benefit_Design_Product__r.Benefit_Design__c
                                              FROM AIA_RxMandate__c
                                              WHERE id IN: objList AND Benefit_Design_Product__c != NULL];
                                                 
            for(AIA_RxMandate__c rxm: rxmList)
            {
               objToBdMap.put(rxm.id, rxm.Benefit_Design_Product__r.Benefit_Design__c); 
            }                                     
        }         
        else
        {
            // There will not be a Benefit Design value when processing BRF objects.
            System.debug('In getObjToBdMap, unsupported object being processed: ' + sObjName);
        }    
        
        System.debug('At the bottom of getObjToBdMap, sObjName: ' + sObjName + ', objToBdMap.size(): ' + objToBdMap.size());        
        
        return objToBdMap;
    }    
    
    // Get a map of the fields that should have Adjustment Summary records created.
    private static Map<String, Schema.SObjectField> getFieldMap(Schema.DescribeSObjectResult r)
    {
        String sObjName = r.getName();
        
        // T03 Begin
        Map<String, Schema.SObjectField> myFieldMap = new Map<String, Schema.SObjectField>();
        
        System.debug('At top of getFieldMap, sObjName: ' + sObjName);
         
        List<Schema.FieldSetMember> fieldsToInclude = NULL;
       
        if(sObjName == 'Benfit_Request_Form__c')
        {     
            fieldsToInclude = SObjectType.Benfit_Request_Form__c.FieldSets.Include_on_Adjustment_Summary.getFields();                                                                                                                       
        }
        else if(sObjName == 'Proposed_Products__c')
        {
            fieldsToInclude = SObjectType.Proposed_Products__c.FieldSets.Include_on_Adjustment_Summary.getFields();
        }
        else if(sObjName == 'AIA_Benefits__c')
        { 
            fieldsToInclude = SObjectType.AIA_Benefits__c.FieldSets.Include_on_Adjustment_Summary.getFields();
        }
        else if(sObjName == 'AIA_Benefit_Design__c')
        {
            fieldsToInclude = SObjectType.AIA_Benefit_Design__c.FieldSets.Include_on_Adjustment_Summary.getFields();
        }   
        else if(sObjName == 'AIA_Benefit_Design_Form__c')
        {
            fieldsToInclude = SObjectType.AIA_Benefit_Design_Form__c.FieldSets.Include_on_Adjustment_Summary.getFields();
        }
        else if(sObjName == 'AIA_Benefit_Design_Product__c')
        {
            fieldsToInclude = SObjectType.AIA_Benefit_Design_Product__c.FieldSets.Include_on_Adjustment_Summary.getFields();
        }
        else if(sObjName == 'Limitations__c')
        {
            fieldsToInclude = SObjectType.Limitations__c.FieldSets.Include_on_Adjustment_Summary.getFields();
        }  
        else if(sObjName == 'AIA_RxMandate__c') // T04
        {
            fieldsToInclude = SObjectType.AIA_RxMandate__c.FieldSets.Include_on_Adjustment_Summary.getFields();
        } 
        else if(sObjName == 'AIA_Grouper__c') // T04
        {
            fieldsToInclude = SObjectType.AIA_Grouper__c.FieldSets.Include_on_Adjustment_Summary.getFields();
        }  
        else if(sObjName == 'Account') // T13
        {
            fieldsToInclude = SObjectType.Account.FieldSets.Include_on_Adjustment_Summary.getFields();
        }
        else if(sObjName == 'Approval_Response__c') // T21 START
        {
            fieldsToInclude = SObjectType.Approval_Response__c.FieldSets.Include_on_Adjustment_Summary.getFields();
        }         //T21 END
        else
        {
            System.debug(LoggingLevel.WARN, 'No fields will be included for ' + sObjName);
        }
        
        Map<String, Schema.SObjectField> fieldMap = r.fields.getMap();
        
        if(fieldsToInclude != NULL)
        {
            // Add fields we want Adjustment Summary records for.
            for(Schema.FieldSetMember f : fieldsToInclude)
            {
                System.debug('Include: ' + f.getFieldPath().toLowerCase());
                myFieldMap.put(f.getFieldPath().toLowerCase(), fieldMap.get(f.getFieldPath().toLowerCase()));
            }        
        }
        // T03 end
        
        System.debug('At bottom of getFieldMap for ' + sObjName + ', size: ' + myFieldMap.size());
        
        return myFieldMap;
    }
    
    // This method is used to create adjustment summary records after records are inserted.
    // Call this method after the record is inserted. Pass in a list of objects and IDs that
    // represent the parent(s) of the objects.
    public static void populateAdjustmentSummaryAfterInsert(List<sObject> objList)
    {
        System.debug('In populateAdjustmentSummaryAfterInsert');
        
        if(disableAdjustmentSummary) // T05
        {
            System.debug('In populateAdjustmentSummaryAfterInsert, returning because disableAdjustmentSummary is true');
            return;
        }        
        populateAdjustmentSummaryAfter(objList, 'New Record');   
    }
    
    // This method is used to create adjustment summary records after records are deleted.
    // Call this method after the record is deleted. Pass in a list of objects and IDs that
    // represent the parent(s) of the objects.
    public static void populateAdjustmentSummaryAfterDelete(List<sObject> objList)
    {
        if(disableAdjustmentSummary) // T05
        {
            System.debug('In populateAdjustmentSummaryAfterDelete, returning because disableAdjustmentSummary is true');
            return;
        }      
        System.debug('***list'+objList);
        System.debug('In populateAdjustmentSummaryAfterDelete');
        
        populateAdjustmentSummaryAfter(objList, 'Deleted');
    }        
    
    // This method is used to create adjustment summary records after records are inserted or deleted.
    @testVisible private static void populateAdjustmentSummaryAfter(List<sObject> objList, String reason)
    {
        System.debug('At top of populateAdjustmentSummaryAfter, objList.size(): ' + objList.size());
        
        // Maps for the IDs which will point to the parent records.
        Map<id, id> objToBrfMap = getObjToBrfMap(objList);
        Map<id, id> objToBdMap  = getObjToBdMap(objList);
        
        List<Adjustment__c> listAdjustments = new List<Adjustment__c>();
        
        // Create an adjustment record for each object.
        for(sObject objRec : objList)
        {
            Adjustment__c adjustmentRec = new Adjustment__c();
            
            adjustmentRec.Field_Affected__c = reason;
            
            adjustmentRec.Form_changed__c       = getFormChanged(objRec); // T06              
            adjustmentRec.Changed_by_User__c    = (Id)objRec.get('LastModifiedById');
            adjustmentRec.DateTime_of_Change__c = (Datetime)objRec.get('lastmodifieddate');  
            
            // T01, Only set one parent field. 
            if(objToBdMap.get(objRec.Id) != NULL)
            {
                adjustmentRec.Benefit_Design__c = objToBdMap.get(objRec.Id);                         
            }
            else
            {
                adjustmentRec.Benefit_Request_Form__c = objToBrfMap.get(objRec.Id); 
            }
            
            listAdjustments.add(adjustmentRec);                                      
            
            System.debug('In populateAdjustmentSummaryAfter ' +
                         ', BRF: ' + adjustmentRec.Benefit_Request_Form__c + 
                         ', BD: '  + adjustmentRec.Benefit_Design__c +
                         ', changed by: ' + adjustmentRec.Changed_by_User__c +
                         ', form: '  + adjustmentRec.Form_changed__c +
                         ', field: ' + adjustmentRec.Field_Affected__c +
                         ', prev: '  + adjustmentRec.Previous_Value__c +
                         ', new: '   + adjustmentRec.New_Value__c +
                         ', time: '  + adjustmentRec.DateTime_of_Change__c);            
        }
        
        System.debug('In populateAdjustmentSummaryAfter, number of new Adjustment Summary records: ' + 
                     listAdjustments.size());
        
        if(listAdjustments.size() > 0)
        {   
            // Let exceptions propagate up.
            insert listAdjustments;
                
            System.debug('In populateAdjustmentSummaryAfter, successfully inserted: ' + 
                         listAdjustments.size() + ' records');
        }
    }

    // A utility method used to write a list of adjustment records to the debug log.  This is 
    // intended to be used in test classes.
    public static void printDbAdjustmentRecords(List<Adjustment__c> adjList)
    {                                      
        System.debug('In printDbAdjustmentRecords, number of Adjustment records: ' + adjList.size());
            
        for(Adjustment__c adj : adjList)
        {
            System.debug('In printDbAdjustmentRecords: BRF: ' + adj.Benefit_Request_Form__r.Name + 
                         ', BD: ' + adj.Benefit_Design__r.Name +
                         ', changed by: ' + adj.Changed_by_User__r.Name +
                         ', form: ' + adj.Form_changed__c +
                         ', field: ' + adj.Field_Affected__c +
                         ', prev: ' + adj.Previous_Value__c +
                         ', new: ' + adj.New_Value__c +
                         ', Category: ' + adj.Adjustment_Category__c); // T11
        }
    } 
    
    // T12 begin
    // A utility method used to write a list of adjustment summary records to the debug log.  This is 
    // intended to be used in test classes.
    public static void printDbAdjustmentSummaryRecords(List<Adjustment_Summary__c> adjList)
    {                                      
        System.debug('In printDbAdjustmentRecords, number of Adjustment records: ' + adjList.size());
            
        for(Adjustment_Summary__c adj : adjList)
        {
            System.debug('In printDbAdjustmentRecords: BD: ' + adj.Benefit_Design__r.Name +
                         ', changed by: ' + adj.Changed_by_User__r.Name +
                         ', form: ' + adj.Form_changed__c +
                         ', field: ' + adj.Field_Affected__c +
                         ', prev: ' + adj.Previous_Value__c +
                         ', new: ' + adj.New_Value__c +
                         ', Category: ' + adj.Adjustment_Category__c); // T11
        }
    } // T12 end    
    
    // T08 begin
    // This method will generate Adjustment Summary records for either Benefit Request Form or
    // Benefit Design Form.  One list will be valid and the other should be NULL.  
    public static void summarizeAdjustmentRecords(List<Benfit_Request_Form__c> brfList,
                                                  List<AIA_Benefit_Design__c> bdList)
    {
        List<Adjustment__c> adjList;
        
        if(brfList != null)
        {
            adjList = [SELECT Form_changed__c, Field_Affected__c, CreatedDate, Previous_Value__c, New_Value__c,
                       Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name,
                       Benefit_Request_Form__c, Benefit_Design__c, DateTime_of_Change__c, Changed_by_User__c,
                       Adjustment_Category__c // T11  
                       FROM Adjustment__c
                       WHERE Benefit_Request_Form__c IN :brfList
                       ORDER BY Form_Changed__c, DateTime_of_Change__c DESC];  
        
            // Remove old summary records if any exist.
            delete [SELECT id FROM Adjustment_Summary__c
                    WHERE Benefit_Request_Form__c IN :brfList AND Auto_Generated__c = TRUE]; // T10                                                
        }
        else
        {
            adjList = [SELECT Form_changed__c, Field_Affected__c, CreatedDate, Previous_Value__c, New_Value__c,
                       Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name,
                       Benefit_Request_Form__c, Benefit_Design__c, DateTime_of_Change__c, Changed_by_User__c,
                       Adjustment_Category__c, // T11
                       Benefit_Design__r.Account__c, Benefit_Design__r.createdDate // T13
                       FROM Adjustment__c
                       WHERE Benefit_Design__c IN :bdList
                       ORDER BY Form_Changed__c, DateTime_of_Change__c DESC];
                       
            // Add any associated account adjustment records to the list.  The records will have their
            // Benefit_Design__c lookup so that all subsequent processing will function correctly.           
            adjList.addAll(getAcctAdjRecs(adjList));           
        
            // Remove old summary records if any exist.
            delete [SELECT id FROM Adjustment_Summary__c
                    WHERE Benefit_Design__c IN :bdList AND Auto_Generated__c = TRUE]; // T10                               
        } 
        
        System.debug('In summarizeAdjustmentRecords, retrieved records');                          
        printDbAdjustmentRecords(adjList);        
        
        // No adjustments found so return.
        if(adjList.size() == 0)
        {
            System.debug('No adjustment records read from database');
        }
        else
        {
            // Sort the adjustment records by BRF or BD and place into a map so they can be processed
            // as groups of records associated to a common parent object.
            map<String, List<Adjustment__c>> idAdjListMap = new map<String, List<Adjustment__c>>();
            for(Adjustment__c adj : adjList)
            {
               String id;
               
               if(adj.Benefit_Request_Form__c != NULL)
               {
                  id = adj.Benefit_Request_Form__c;   
               }
               else if(adj.Benefit_Design__c != NULL)
               {
                  id = adj.Benefit_Design__c;
               } 
               
               List<Adjustment__c> adjSubList = idAdjListMap.get(id);
               
               if(adjSubList == NULL)
               {
                   adjSubList = new List<Adjustment__c>();
               
                   idAdjListMap.put(id, adjSubList);
               }
               
               adjSubList.add(adj);
            }
            
            // Summarize each group of adjustment records that are stored in the map.
            List<Adjustment_Summary__c> adjSumMasterList = new List<Adjustment_Summary__c>();
            
            for(String id : idAdjListMap.keySet())
            {
               List<Adjustment_Summary__c> adjSumList = generateAdjustmentSummaryRecords(idAdjListMap.get(id));
               
               if(adjSumList != NULL)
               {
                  adjSumMasterList.addAll(adjSumList); 
               }
            }
        
            // Save the summary records to the database.
            if(adjSumMasterList.size() == 0)
            {
                System.debug('No adjustment summary records were generated, skipping database insert');
            }
            else
            {
                saveAdjustmentSummaryRecords(adjSumMasterList); 
            }
        }
    }
    
    // T13 begin
    // This method will retrieve the adjustment records related to the BDs and create a list of adj
    // records with the Benefit_Design__c lookup value set.  These will not be written to the database.
    private static List<Adjustment__c> getAcctAdjRecs(List<Adjustment__c> adjList)
    {
        System.debug('In getAcctAdjRecs, adjList.size(): ' + adjList);
    
        // Create a map of Account to BDs, create map of BD to created date.
        Map<String, Set<String>> acctToBds = new Map<String, Set<String>>(); 
        Map<String, DateTime> bdToCreatedDate = new Map<String, DateTime>();
        for(Adjustment__c adjRec : adjList)
        {           
            Set<String> bdSet = acctToBds.get(adjRec.Benefit_Design__r.Account__c);
            
            if(bdSet == NULL)
            {
               bdSet = new Set<String>();
               acctToBds.put(adjRec.Benefit_Design__r.Account__c, bdSet); 
            }
            
            bdSet.add(adjRec.Benefit_Design__c);
            
            bdToCreatedDate.put(adjRec.Benefit_Design__c, adjRec.Benefit_Design__r.createdDate);
        }
        
        System.debug('In getAcctAdjRecs, acctToBds.size(): ' + acctToBds.size() + 
                     ', bdToCreatedDate.size(): ' + bdToCreatedDate.size());
        
        // Retrieve the accounts adjustment records that are associated with the BD records.
        List<Adjustment__c> acctAdjList = [SELECT Form_changed__c, Field_Affected__c, CreatedDate, 
                                           Previous_Value__c, New_Value__c, Changed_by_User__r.Name,
                                           DateTime_of_Change__c, Changed_by_User__c, Adjustment_Category__c,
                                           Account__c
                                           FROM Adjustment__c
                                           WHERE Account__c IN :acctToBds.keySet()];
                                           
        System.debug('In getAcctAdjRecs, acctAdjList.size(): ' + acctAdjList);                                   
        
        // Create a list of account adjustment records with the BD lookup.  These will not be written
        // to the database.  In memory process only.
        List<Adjustment__c> acctBdAdjList = new List<Adjustment__c>();
        
        for(Adjustment__c acctAdjRec : acctAdjList)
        {
            Set<String> bdSet = acctToBds.get(acctAdjRec.Account__c);
            
            for(String bdId : bdSet)
            {
                // If account change was made since the BD was created.
                if(bdToCreatedDate.get(bdId) <= acctAdjRec.DateTime_of_Change__c)
                {
                    // Copy the account adj rec and set the BD id.
                    Adjustment__c adjRec = acctAdjRec.clone();
                    adjRec.Benefit_Design__c = bdId;
                    acctBdAdjList.add(adjRec);
                }      
            }
        }
        
        System.debug('In getAcctAdjRecs, acctBdAdjList.size(): ' + acctBdAdjList); 

        // Return the list of adjustment records.
        return acctBdAdjList;
        
    } // T13 end
    
    // This method will generate Adjustment Summary records. Pass in a list of records that is related to
    // one BRf or BD form. 
    private static List<Adjustment_Summary__c> generateAdjustmentSummaryRecords(List<Adjustment__c> adjList)
    {                    
        // Process Deleted records.  If a Form gets deleted we do not want to 
        // report on adjustements.  If the deleted Form was added then
        // we do not want to report on the delete.  The following while loop
        // will remove adjust records accordingly.
        Integer i = 0;
        while(i < adjList.size())
        {
            String curForm = adjList[i].Form_changed__c;
            
            if(adjList[i].Field_Affected__c == 'Deleted')
            {
                Integer j = i + 1;
                Boolean newFoundFlag = false;
                
                System.debug('Found Deleted record at index: ' + i);
                
                // Find out where the next group for form/field starts.
                while(j < adjList.size())
                {
                    if(adjList[j].Form_changed__c != curForm)
                    {
                        break;
                    }
                    else if(adjList[j].Field_Affected__c == 'New Record')
                    {
                        newFoundFlag = true;
                        break;
                    }
                     
                    ++j;    
                }
                
                System.debug('After searching, j: ' + j + ', newFoundFlag: ' + newFoundFlag);
            
                // If a New Record adjustment was found for this form.
                if(newFoundFlag)
                {
                    // Remove Deleted and New Record and all records in between.
                    for(Integer x = i; x <= j; ++x)
                    {
                       System.debug('Removing record at: ' + x);
                       adjList.remove(i); // Records move up so keep index the same.
                    }
                }
                else if(j > i + 1)
                {
                    // More than one record exists for this form and New Record
                    // not found.  So remove all adjustments but keep Deleted.
                    for(Integer x = i + 1; x < j; ++x)
                    {
                       System.debug('Removing record at: ' + x);
                       adjList.remove(i + 1); // Records move up so keep index the same. 
                    }
                    ++i;                 
                }
                else
                {
                    // The Deleted record is the only record for this form.
                    ++i;
                }
            }
            else
            {
                // Current record is not Deleted so continue.
                ++i;
            }
        }
        
        // No adjustments left so return.
        if(adjList.size() == 0)
        {
            System.debug('No adjustment records after processing deletes');
            return null;
        }        
        
        System.debug('In summarizeAdjustmentRecords, after deletes are processed.');                          
        printDbAdjustmentRecords(adjList);
        
        // Copy records into wrapper so they can be sorted to determine changed fields.
        List<AdjustmentWrapper> adjWrapList = new List<AdjustmentWrapper>();
        for(Adjustment__c adj : adjList)
        {
            adjWrapList.add(new  AdjustmentWrapper(adj));   
        } 
        
        adjWrapList.sort();
        
        // Copy sorted objects back into an Adjustment list.
        List<Adjustment__c> sortedAdjList = new List<Adjustment__c>();
        for(AdjustmentWrapper adjWrap : adjWrapList)
        {
            sortedAdjList.add(adjWrap.adj);
        }
        
        System.debug('In summarizeAdjustmentRecords, after sorting.');                          
        printDbAdjustmentRecords(sortedAdjList);        
        
        // Process records for field changes.
        i = 0;
        while(i < sortedAdjList.size())
        {                
            String curForm  = sortedAdjList[i].Form_changed__c;
            String curField = sortedAdjList[i].Field_Affected__c;
            
            // Do not filter out New or Deleted records.  That processing has already been performed above.
            if(curField == 'Deleted' || curField == 'New Record') // T19
            {
                ++i;
                continue;
            }
            
            System.debug('Form: ' + curForm + ', Field: ' + curField);
            
            Integer j = i + 1;
            
            // Find out where the next form/field starts.
            while(j < sortedAdjList.size())
            {
                if(sortedAdjList[j].Form_changed__c   != curForm ||
                   sortedAdjList[j].Field_Affected__c != curField)
                {
                    break;
                }
                 
                ++j;    
            }
            
            System.debug('i: ' + i + ', j: ' + j);
            
            // If more than one record exists for this field.
            if(j > i + 1)
            {
                // Set offset assuming field has not changed across the records.
                Integer startOffset = 0;
            
                // Check if field has changed.
                if(sortedAdjList[j - 1].Previous_Value__c != sortedAdjList[i].New_Value__c)
                {
                    System.debug('Field value has changed');
                    
                    // Set offset so the record at index i is not removed.
                    startOffset = 1;
                    
                    sortedAdjList[i].Previous_Value__c = sortedAdjList[j - 1].Previous_Value__c;
                }
            
                // Remove other adjustment records associted with this field.
                for(Integer x = i + startOffset; x < j; ++x)
                {
                   System.debug('Removing record at: ' + x);
                   sortedAdjList.remove(i + startOffset); // Records move up so keep index the same. 
                }
                
                i = i + startOffset;             
            } 
            else
            {
                // Only one record for this field so go to the next one.
                ++i;
            }         
        }
        
        if(sortedAdjList.size() == 0) // T09
        {
            System.debug('No adjustment records after processing field changes');
            return null;
        }  
        
        System.debug('In summarizeAdjustmentRecords, after field change processing.');                          
        printDbAdjustmentRecords(sortedAdjList); 
        
        // Copy the resulting list into a list of Adjustment Summary records.
        List<Adjustment_Summary__c> adjSumList = new List<Adjustment_Summary__c>();
        for(Adjustment__c adj : sortedAdjList)
        {
           Adjustment_Summary__c adjSum = new Adjustment_Summary__c();
           adjSum.Benefit_Design__c = adj.Benefit_Design__c; 
           adjSum.Benefit_Request_Form__c = adj.Benefit_Request_Form__c;
           adjSum.Changed_by_User__c = adj.Changed_by_User__c;
           adjSum.DateTime_of_Change__c = adj.DateTime_of_Change__c;
           adjSum.Field_Affected__c = adj.Field_Affected__c;
           adjSum.Form_Changed__c = adj.Form_Changed__c;
           adjSum.New_Value__c = adj.New_Value__c;
           adjSum.Previous_Value__c = adj.Previous_Value__c;
           adjSum.Auto_Generated__c = TRUE; // T10
           adjSum.Adjustment_Category__c = adj.Adjustment_Category__c; // T11
           
           adjSumList.add(adjSum);
        }             
        
        // Append a number to the end of the category to identify product groups.
        return setProductCategories(adjSumList); // T12                      
    }  
    
    // Helper method to set the category so that records can be grouped by product on the document generated
    // by drawloop.  T12
    @testVisible
    private static List<Adjustment_Summary__c> setProductCategories(List<Adjustment_Summary__c> adjSumList)
    {
        // Sort the list by product as primary field and and date changed as the secondary field.
        List<AdjustmentSummaryWrapper> wrpList = new List<AdjustmentSummaryWrapper>();
        for(Adjustment_Summary__c adjRec : adjSumList)
        {
            wrpList.add(new AdjustmentSummaryWrapper(adjRec));
        }
        wrpList.sort();
        List<Adjustment_Summary__c> sortedList = new List<Adjustment_Summary__c>();
        for(AdjustmentSummaryWrapper adjWrp : wrpList)
        {
            sortedList.add(adjWrp.adj);
        }
        
        // Counters used to append to the category string so that summary records can be grouped by product.
        Integer medicalCtr = 0;
        Integer dentalCtr  = 0;
        Integer visionCtr  = 0;
        Integer drugCtr    = 0;
        
        String curBdpName = ''; // T17
        String curCategory = '';
   
        // Append a number to the end of the category so that drawloop can groups the records by product.
        for(Adjustment_Summary__c adjRec : sortedList)
        {
            // Only append a number onto the end of certain categories.
            if(adjRec.Adjustment_Category__c == 'Medical' ||
               adjRec.Adjustment_Category__c == 'Dental'  ||
               adjRec.Adjustment_Category__c == 'Vision'  ||
               adjRec.Adjustment_Category__c == 'Drug')
            {           
                // T17 begin 
                String adjBdpName = getBdpName(adjRec.Form_changed__c);
                
                // Each time a new product grouping is reached compute the category string.
                if(adjBdpName != curBdpName )
                {
                    curBdpName = getBdpName(adjRec.Form_changed__c);
                    // T17 end
                    
                    if(adjRec.Adjustment_Category__c == 'Medical')
                    {
                        ++medicalCtr;
                        curCategory = adjRec.Adjustment_Category__c + ' ' + medicalCtr;
                    }
                    else if(adjRec.Adjustment_Category__c == 'Dental')
                    {
                        ++dentalCtr;
                        curCategory = adjRec.Adjustment_Category__c + ' ' + dentalCtr;
                    }
                    else if(adjRec.Adjustment_Category__c == 'Drug')
                    {
                        ++drugCtr;
                        curCategory = adjRec.Adjustment_Category__c + ' ' + drugCtr;
                    }
                    else if(adjRec.Adjustment_Category__c == 'Vision')
                    {
                        ++visionCtr;
                        curCategory = adjRec.Adjustment_Category__c + ' ' + visionCtr;
                    }               
                }
                
                adjRec.Adjustment_Category__c = curCategory; 
            }
        }    
    
        return sortedList;
    } // T12
    
    // Helper method to get BDP Name from the Form Changed field.
    // T17, new method
    private static String getBdpName(String formChanged)
    {
        String bdpName = formChanged.left(formChanged.indexOf('-', 5));
        
        System.debug('bdpName = ' + bdpName + ', formChanged = ' + formChanged); 
        
        return bdpName;
    }
    
    // Helper method to save the adjustment summary records.
    private static void saveAdjustmentSummaryRecords(List<Adjustment_Summary__c> adjSumList)
    {
        // Save the adjustment summary records.
        System.debug('Inserting ' + adjSumList.size() + ' adjustment summary records'); 
        
        // Let exceptions propogate up.
        insert adjSumList;                   
    } 
    
    // Wrapper class used to sort a list of Adjustment Summary records.
    @testVisible // T12
    private class AdjustmentSummaryWrapper implements Comparable
    {
        public Adjustment_Summary__c adj;
        
        // Constructor
        public AdjustmentSummaryWrapper (Adjustment_Summary__c adjIn)
        {
            adj= adjIn;
        }
        
        // Compare opportunities based on the opportunity amount.
        public Integer compareTo(Object compareTo)
        {
            // Cast argument to AdjustmentSummaryWrapper 
            AdjustmentSummaryWrapper compareToAdj = (AdjustmentSummaryWrapper)compareTo;
            
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            
            if (adj.Form_changed__c > compareToAdj.adj.Form_changed__c)
            {
                // Set return value to a positive value.
                returnValue = 1;
            } 
            else if (adj.Form_changed__c < compareToAdj.adj.Form_changed__c)
            {
                // Set return value to a negative value.
                returnValue = -1;
            }   
            else if (adj.DateTime_of_Change__c < compareToAdj.adj.DateTime_of_Change__c)
            {
                // Set return value to a positive value.
                returnValue = 1;
            } 
            else if (adj.DateTime_of_Change__c > compareToAdj.adj.DateTime_of_Change__c)
            {
                // Set return value to a negative value.
                returnValue = -1;
            }             
            
            return returnValue;       
        }
    } // T12
    
    // Wrapper class used to sort a list of Adjustment records.
    @testVisible // T09
    private class AdjustmentWrapper implements Comparable
    {
        public Adjustment__c adj;
        
        // Constructor
        public AdjustmentWrapper (Adjustment__c adjIn)
        {
            adj= adjIn;
        }
        
        // Compare opportunities based on the opportunity amount.
        public Integer compareTo(Object compareTo)
        {
            // Cast argument to AdjustmentWrapper
            AdjustmentWrapper compareToAdj = (AdjustmentWrapper)compareTo;
            
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            if (adj.Form_changed__c > compareToAdj.adj.Form_changed__c)
            {
                // Set return value to a positive value.
                returnValue = 1;
            } 
            else if (adj.Form_changed__c < compareToAdj.adj.Form_changed__c)
            {
                // Set return value to a negative value.
                returnValue = -1;
            }
            else if (adj.Field_Affected__c > compareToAdj.adj.Field_Affected__c)
            {
                // Set return value to a positive value.
                returnValue = 1;
            } 
            else if (adj.Field_Affected__c < compareToAdj.adj.Field_Affected__c)
            {
                // Set return value to a negative value.
                returnValue = -1;
            }    
            else if (adj.DateTime_of_Change__c < compareToAdj.adj.DateTime_of_Change__c)
            {
                // Set return value to a positive value.
                returnValue = 1;
            } 
            else if (adj.DateTime_of_Change__c > compareToAdj.adj.DateTime_of_Change__c)
            {
                // Set return value to a negative value.
                returnValue = -1;
            }             
            
            return returnValue;       
        }
    }
    // T08 end
 }