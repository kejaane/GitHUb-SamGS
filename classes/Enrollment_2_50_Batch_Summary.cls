/**********************************************************************************************************
* Name        - Enrollment_2_50_Batch_Summary
* Description - Batch class to handle Summarizing the 2-50 Enrollment records
*               into the Summary object, so we can do some reporting.
*               This is how you call it:
*               List<Enrollment__c> lE = [SELECT Id FROM Enrollment__c LIMIT 5];
*               database.executebatch(new Enrollment_2_50_Batch_Summary(lE));
*                   
* Modification Log :
* ---------------------------------------------------------------------------------------------------------
* Developer            Date         Tag       Description
* ---------------------------------------------------------------------------------------------------------
* jmasters (EP)        12-09-2014           Created 
* Tom Barrett (TPB)    08/18/2015   TPB     Updated to remove hard coded email reference
*                                           and commented out Error check because we
*                                           want an email sent when job completes 
*                                           whether it passes or fails.   
*                            
* Tom Barrett (TPB)    03/26/2016   TPB     Made changes to handle a new custom setting field that will allow for
*                                           muliple email addresses to be entered dynamically without changing code
* Thejaswi Ganesh      05/30/2018   T01     Added StartDate condition to the query for 
*                                           Enrollment Deletion Batch Job Evolution.                                            
************************************************************************************************************/
global without sharing class Enrollment_2_50_Batch_Summary implements Database.Batchable<sObject> {
    //BEGIN CHANGE TPB 03/26/2016 - Commented code between 08/18/2015 Changes
    // BEGIN CHANGE TPB 08/18/2015    
    //private static DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('sfdcTeamEmail');
    //private static string notificationRecipientEmail = cs.Email__c;
    // END CHANGE TPB 08/18/2015
    private static DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');
    private static string[] toAddresses = cs.Text_255__c.Split(',');
    // END CHANGE TPB 03/26/2016
    // NOTE: When testing comment out static varible line above and uncomment line below
    //private static string notificationRecipientEmail = 'someone@carefirst.com';
    private string enrollment2_50RecordTypeID = '';
    private string enrollment51RecordTypeId = '';
    private string summary2_50RecordTypeID = '';
    private string summary51RecordTypeID = '';
    
    // Map for the Totals
    // ex: 20140101MD, 5103
    global Map<String, Decimal> totalContracts = new Map<String, Decimal>();        // line 1
    global Map<String, Decimal> onCycleContracts = new Map<String, Decimal>();      // lines 2 & 3
    global Map<String, Decimal> termedContracts = new Map<String, Decimal>();       // line 4
    global Map<String, Decimal> onCycleContractTerms = new Map<String, Decimal>();  // lines 5 & 6
    global Map<String, Decimal> newContracts = new Map<String, Decimal>();          // line 7
    
    global Map<String, Decimal> totalGroups = new Map<String, Decimal>();           // line 1
    global Map<String, Decimal> onCycleGroups = new Map<String, Decimal>();         // lines 2 & 3
    global Map<String, Decimal> termedGroups = new Map<String, Decimal>();          // line 4
    global Map<String, Decimal> onCycleGroupTerms = new Map<String, Decimal>();     // lines 5 & 6
    global Map<String, Decimal> newGroups = new Map<String, Decimal>();             // line 7
    
    // 12-12-2014 jhm: This is our core query.    
    String StartDate = String.valueOf(System.Today().year()-2)+'-01-01';//T01
    private string query = 'SELECT Rpt_Dt__c, Opportunity__r.Account.Rating_State__c, Contracts__c, Groups__c, On_Cycle__c, ' +
        'New_Business_Indicator__c, Status__c, RecordTypeId, Renewal_Anniversary_Date__c, ' +
        'Reporting_Checkbox__c, Summary_Checkbox__c ' +
        'FROM Enrollment__c ' +
        'WHERE Processed_Type__c = \'M\' ' +
        'AND Opportunity__r.Account.Rating_State__c != null ' +
        'AND Account_Number__c NOT IN (\'1RA7\', \'1RA8\', \'1RA9\') '+
        'AND Rpt_Dt__c >= \''+StartDate+'\''; //T01 
    //'AND Opportunity__r.Account.Rating_State__c = \'V\' ' +
    //'AND Account_Number__c NOT IN (\'1RA7\', \'1RA8\', \'1RA9\') '+//;
    //'AND (Rpt_Dt__c = \'201311\' OR Renewal_Anniversary_Date__c = 2013-11-01)';  
    
    
    // Constructor
    global Enrollment_2_50_Batch_Summary( List<Enrollment__c> enrollments ) {
        // get the Record Type ID
        enrollment2_50RecordTypeID = (string)QueryBase.getRecordtypeId('Enrollment__c', 'X2_50' );
        enrollment51RecordTypeID = (string)QueryBase.getRecordtypeId('Enrollment__c', 'X51' );
        // Add the record type to the query
        //query += 'AND RecordTypeID = \'' + enrollment2_50RecordTypeID + '\'';
        
        // get the summary record types
        summary2_50RecordTypeId = (string)QueryBase.getRecordtypeId( 'Enrollment_Summary__c', 'X2_50' );
        summary51RecordTypeId = (string)QueryBase.getRecordtypeId( 'Enrollment_Summary__c', 'X51' );
    }
    
    global Database.QueryLocator start( Database.BatchableContext BC ) {
        // Clear out existing data
        deleteExistingSummaryData();
        // Get the 51+ Termed magic number
        get51PlusMagicNumbers();
        
        return Database.getQueryLocator(query);
    }
    
    global void execute( Database.BatchableContext Info, List<Sobject> batch) {
        // repopulate the maps, so we total everything; not just one batch.
        rePopulateMaps();
        // do some stuff with the batch
        summarizeBatch( batch );
    }
    
    global void finish( Database.BatchableContext BC ) {
        // Get the record for this job
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob
                          WHERE Id = :BC.getJobId()];
        
        //TPB 08/18/2015        if( a.NumberOfErrors > 0 ) {       
        // If so, let someone know about them.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // BEGIN CHANGE TPB 03/26/2016
        //String[] toAddresses = new String[] {notificationRecipientEmail};  // Add others, if necessary.
        // END CHANGE TPB 03/26/2016
        
        mail.setToAddresses( toAddresses );
        mail.setSubject( 'Batch Enrollment Summary Job ' + a.Status );
        mail.setPlainTextBody( 'The batch job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures.' );
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] {mail} );
        //TPB 08/18/2015       }       
    }
    
    // Delete existing data
    private void deleteExistingSummaryData() {
        // Clear everything out.
        List<Enrollment_Summary__c> lES = [SELECT Id FROM Enrollment_Summary__c];
        delete lES;
    }
    
    // Add any other methods we need to actually do some work.
    public void summarizeBatch( List<sObject> batch ) {
        List<Enrollment__c> enrollments = (List<Enrollment__c>)batch;
        
        for( Enrollment__c e : enrollments ) {
            // Maryland
            if( e.Opportunity__r.Account.Rating_State__c == 'M' ||
               e.Opportunity__r.Account.Rating_State__c == 'R' ) {
                   if( enrollment2_50RecordTypeId == e.RecordTypeId ) {
                       if( 'N' == e.New_Business_Indicator__c ) {
                           // See if there's already a TOTAL entry for this date/jurisdiction
                           if( 'Active' == e.Status__c  ) {
                               if( totalContracts.containsKey( e.Rpt_Dt__c + 'MD' + e.RecordTypeId ) ) {
                                   // update
                                   if( null != e.Contracts__c ) {
                                       totalContracts.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, totalContracts.get(e.Rpt_Dt__c + 'MD' + e.RecordTypeId) + e.Contracts__c );
                                   }
                               } else {
                                   // create it
                                   if( null != e.Contracts__c ) {
                                       totalContracts.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, e.Contracts__c );
                                   }
                               }
                               // total groups, too
                               if( totalGroups.containsKey( e.Rpt_Dt__c + 'MD' + e.RecordTypeId ) ) {
                                   // update
                                   if( null != e.Groups__c ) {
                                       totalGroups.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, totalGroups.get(e.Rpt_Dt__c + 'MD' + e.RecordTypeId) + e.Groups__c );
                                   }
                               } else {
                                   // create it
                                   if( null != e.Groups__c ) {
                                       totalGroups.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, e.Groups__c );
                                   }
                               }
                               // See if there's already an ON-CYCLE entry for this date/jurisdiction
                               // 12-15-2014 jhm: Can't use the check-box determine on/off cycle, per Salman
                               // 12-16-2014 jhm: Use different check-box and Renewal Anniversary Date, instead.
                               if( null != e.Renewal_Anniversary_Date__c && true == e.Summary_Checkbox__c ) {
                                   String sDate = formatDate( e.Renewal_Anniversary_Date__c );
                                   if( onCycleContracts.containsKey( formatDate( e.Renewal_Anniversary_Date__c ) + 'MD' + e.RecordTypeId ) ) {
                                       // update
                                       if( null != e.Contracts__c ) {
                                           onCycleContracts.put( formatDate( e.Renewal_Anniversary_Date__c ) + 'MD' + e.RecordTypeId, onCycleContracts.get(formatDate( e.Renewal_Anniversary_Date__c ) + 'MD' + e.RecordTypeId) + e.Contracts__c );
                                       }
                                   } else {
                                       // create it
                                       if( null != e.Contracts__c ) {
                                           onCycleContracts.put( formatDate( e.Renewal_Anniversary_Date__c ) + 'MD' + e.RecordTypeId, e.Contracts__c );
                                       }
                                   }
                                   // groups, too
                                   if( onCycleGroups.containsKey( formatDate( e.Renewal_Anniversary_Date__c ) + 'MD' + e.RecordTypeId ) ) {
                                       // update
                                       if( null != e.Groups__c ) {
                                           onCycleGroups.put( formatDate( e.Renewal_Anniversary_Date__c ) + 'MD' + e.RecordTypeId, onCycleGroups.get(formatDate( e.Renewal_Anniversary_Date__c ) + 'MD' + e.RecordTypeId) + e.Groups__c );
                                       }
                                   } else {
                                       // create it
                                       if( null != e.Groups__c ) {
                                           onCycleGroups.put( formatDate( e.Renewal_Anniversary_Date__c ) + 'MD' + e.RecordTypeId, e.Groups__c );
                                       }
                                   }
                               }
                           } else if( ( 'Termed' == e.Status__c && enrollment2_50RecordTypeID == e.RecordTypeId ) ||       // <-- 2-50 criteria
                                     ( enrollment51RecordTypeID == e.RecordTypeId && e.Opportunity__r.StageName == 'Dead' ) ) {
                                         //( enrollment51RecordTypeID == e.RecordTypeId && e.Opportunity__r.StageName == 'Dead' &&
                                         // The below criteria, provided by Salman, yield no results.
                                         //e.Opportunity__r.SBU__c == 'Small/Medium' && e.Opportunity__r.Market_Segment_New__c == '51-199' ) ) {
                                         // See if there's already a TERMED entry for this date/jurisdiction
                                         if( termedContracts.containsKey( e.Rpt_Dt__c + 'MD' + e.RecordTypeId ) ) {
                                             // update
                                             if( null != e.Contracts__c ) {
                                                 termedContracts.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, termedContracts.get(e.Rpt_Dt__c + 'MD' + e.RecordTypeId) + e.Contracts__c );
                                             }
                                         } else {
                                             // create it
                                             if( null != e.Contracts__c ) {
                                                 termedContracts.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, e.Contracts__c );
                                             }
                                         }
                                         // groups, too
                                         if( termedGroups.containsKey(e.Rpt_Dt__c + 'MD' + e.RecordTypeId ) ) {
                                             // update
                                             if( null != e.Groups__c ) {
                                                 termedGroups.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, termedGroups.get(e.Rpt_Dt__c + 'MD' + e.RecordTypeId) + e.Groups__c );
                                             }
                                         } else {
                                             // create it
                                             if( null != e.Groups__c ) {
                                                 termedGroups.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, e.Groups__c );
                                             }
                                         }
                                         // See if there's already an on-cycle TERMED entry for this date/jurisdiction
                                         // 12-15-2014 jhm: Can't use the check-box determine on/off cycle, per Salman
                                         // 12-16-2014 jhm: Use different check-box and Renewal Anniversary Date, instead.
                                         if( null != e.Renewal_Anniversary_Date__c && true == e.Summary_Checkbox__c ) {
                                             if( true == e.Reporting_Checkbox__c || true == e.Summary_Checkbox__c ) {        // ON CYCLE
                                                 if( onCycleContractTerms.containsKey( formatDate(e.Renewal_Anniversary_Date__c) + 'MD' + e.RecordTypeId ) ) {
                                                     // update
                                                     if( null != e.Contracts__c ) {
                                                         onCycleContractTerms.put( formatDate(e.Renewal_Anniversary_Date__c) + 'MD' + e.RecordTypeId, onCycleContractTerms.get(formatDate(e.Renewal_Anniversary_Date__c) + 'MD' + e.RecordTypeId) + e.Contracts__c );
                                                     }
                                                 } else {
                                                     // create it
                                                     if( null != e.Contracts__c ) {
                                                         onCycleContractTerms.put( formatDate(e.Renewal_Anniversary_Date__c) + 'MD' + e.RecordTypeId, e.Contracts__c );
                                                     }
                                                 }
                                                 // groups, too
                                                 if( onCycleGroupTerms.containsKey(formatDate(e.Renewal_Anniversary_Date__c) + 'MD' + e.RecordTypeId ) ) {
                                                     // update
                                                     if( null != e.Groups__c ) {
                                                         onCycleGroupTerms.put( formatDate(e.Renewal_Anniversary_Date__c) + 'MD' + e.RecordTypeId, onCycleGroupTerms.get(formatDate(e.Renewal_Anniversary_Date__c) + 'MD' + e.RecordTypeId) + e.Groups__c );
                                                     }
                                                 } else {
                                                     // create it
                                                     if( null != e.Groups__c ) {
                                                         onCycleGroupTerms.put( formatDate(e.Renewal_Anniversary_Date__c) + 'MD' + e.RecordTypeId, e.Groups__c );
                                                     }
                                                 }
                                             }
                                         }
                                     } // termed
                       }  // new business
                       if('Y' == e.New_Business_Indicator__c ) {
                           if( newContracts.containsKey( e.Rpt_Dt__c + 'MD' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Contracts__c ) {
                                   newContracts.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, newContracts.get(e.Rpt_Dt__c + 'MD' + e.RecordTypeId) + e.Contracts__c );
                               }
                           } else {
                               // create it
                               if( null != e.Contracts__c ) {
                                   newContracts.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, e.Contracts__c );
                               }
                           }
                           // Groups
                           if( newGroups.containsKey( e.Rpt_Dt__c + 'MD' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Groups__c ) {
                                   newGroups.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, newGroups.get(e.Rpt_Dt__c + 'MD' + e.RecordTypeId) + e.Groups__c );
                               }
                           } else {
                               // create it
                               if( null != e.Groups__c ) {
                                   newGroups.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, e.Groups__c );
                               }
                           }
                       }
                       // For 51+, the New Business Indicator and Status are apparently irrelevant
                   } else if( enrollment51RecordTypeId == e.RecordTypeId ) {
                       if( 'N' == e.New_Business_Indicator__c ) {
                           if( totalContracts.containsKey( e.Rpt_Dt__c + 'MD' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Contracts__c ) {
                                   totalContracts.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, totalContracts.get(e.Rpt_Dt__c + 'MD' + e.RecordTypeId) + e.Contracts__c );
                               }
                           } else {
                               // create it
                               if( null != e.Contracts__c ) {
                                   totalContracts.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, e.Contracts__c );
                               }
                           }
                       } else if( 'Y' == e.New_Business_Indicator__c ){    // New Business
                           if( newContracts.containsKey( e.Rpt_Dt__c + 'MD' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Contracts__c ) {
                                   newContracts.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, newContracts.get(e.Rpt_Dt__c + 'MD' + e.RecordTypeId) + e.Contracts__c );
                               }
                           } else {
                               // create it
                               if( null != e.Contracts__c ) {
                                   newContracts.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, e.Contracts__c );
                               }
                           }
                           // Groups
                           if( newGroups.containsKey( e.Rpt_Dt__c + 'MD' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Groups__c ) {
                                   newGroups.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, newGroups.get(e.Rpt_Dt__c + 'MD' + e.RecordTypeId) + e.Groups__c );
                               }
                           } else {
                               // create it
                               if( null != e.Groups__c ) {
                                   newGroups.put( e.Rpt_Dt__c + 'MD' + e.RecordTypeId, e.Groups__c );
                               }
                           }
                       }
                   }
                   // DC
               } else if( e.Opportunity__r.Account.Rating_State__c == 'D' ) {
                   if( enrollment2_50RecordTypeId == e.RecordTypeId ) {
                       if( 'N' == e.New_Business_Indicator__c ) {
                           // See if there's already a TOTAL entry for this date/jurisdiction
                           if( 'Active' == e.Status__c  ) {
                               if( totalContracts.containsKey( e.Rpt_Dt__c + 'DC' + e.RecordTypeId ) ) {
                                   // update
                                   if( null != e.Contracts__c ) {
                                       totalContracts.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, totalContracts.get(e.Rpt_Dt__c + 'DC' + e.RecordTypeId) + e.Contracts__c );
                                   }
                               } else {
                                   // create it
                                   if( null != e.Contracts__c ) {
                                       totalContracts.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, e.Contracts__c );
                                   }
                               }
                               // total groups, too
                               if( totalGroups.containsKey( e.Rpt_Dt__c + 'DC' + e.RecordTypeId ) ) {
                                   // update
                                   if( null != e.Groups__c ) {
                                       totalGroups.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, totalGroups.get(e.Rpt_Dt__c + 'DC' + e.RecordTypeId) + e.Groups__c );
                                   }
                               } else {
                                   // create it
                                   if( null != e.Groups__c ) {
                                       totalGroups.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, e.Groups__c );
                                   }
                               }
                               // See if there's already an ON-CYCLE entry for this date/jurisdiction
                               // 12-15-2014 jhm: Can't use the check-box determine on/off cycle, per Salman
                               // 12-16-2014 jhm: Use different check-box and Renewal Anniversary Date, instead.
                               if( null != e.Renewal_Anniversary_Date__c && true == e.Summary_Checkbox__c ) {
                                   String sDate = formatDate( e.Renewal_Anniversary_Date__c );
                                   if( onCycleContracts.containsKey( formatDate( e.Renewal_Anniversary_Date__c ) + 'DC' + e.RecordTypeId ) ) {
                                       // update
                                       if( null != e.Contracts__c ) {
                                           onCycleContracts.put( formatDate( e.Renewal_Anniversary_Date__c ) + 'DC' + e.RecordTypeId, onCycleContracts.get(formatDate( e.Renewal_Anniversary_Date__c ) + 'DC' + e.RecordTypeId) + e.Contracts__c );
                                       }
                                   } else {
                                       // create it
                                       if( null != e.Contracts__c ) {
                                           onCycleContracts.put( formatDate( e.Renewal_Anniversary_Date__c ) + 'DC' + e.RecordTypeId, e.Contracts__c );
                                       }
                                   }
                                   // groups, too
                                   if( onCycleGroups.containsKey( formatDate( e.Renewal_Anniversary_Date__c ) + 'DC' + e.RecordTypeId ) ) {
                                       // update
                                       if( null != e.Groups__c ) {
                                           onCycleGroups.put( formatDate( e.Renewal_Anniversary_Date__c ) + 'DC' + e.RecordTypeId, onCycleGroups.get(formatDate( e.Renewal_Anniversary_Date__c ) + 'DC' + e.RecordTypeId) + e.Groups__c );
                                       }
                                   } else {
                                       // create it
                                       if( null != e.Groups__c ) {
                                           onCycleGroups.put( formatDate( e.Renewal_Anniversary_Date__c ) + 'DC' + e.RecordTypeId, e.Groups__c );
                                       }
                                   }
                               }
                           } else if( 'Termed' == e.Status__c && enrollment2_50RecordTypeID == e.RecordTypeId ) {
                               // See if there's already a TERMED entry for this date/jurisdiction
                               if( termedContracts.containsKey( e.Rpt_Dt__c + 'DC' + e.RecordTypeId ) ) {
                                   // update
                                   if( null != e.Contracts__c ) {
                                       termedContracts.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, termedContracts.get(e.Rpt_Dt__c + 'DC' + e.RecordTypeId) + e.Contracts__c );
                                   }
                               } else {
                                   // create it
                                   if( null != e.Contracts__c ) {
                                       termedContracts.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, e.Contracts__c );
                                   }
                               }
                               // groups, too
                               if( termedGroups.containsKey(e.Rpt_Dt__c + 'DC' + e.RecordTypeId ) ) {
                                   // update
                                   if( null != e.Groups__c ) {
                                       termedGroups.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, termedGroups.get(e.Rpt_Dt__c + 'DC' + e.RecordTypeId) + e.Groups__c );
                                   }
                               } else {
                                   // create it
                                   if( null != e.Groups__c ) {
                                       termedGroups.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, e.Groups__c );
                                   }
                               }
                               // See if there's already an on-cycle TERMED entry for this date/jurisdiction
                               // 12-15-2014 jhm: Can't use the check-box determine on/off cycle, per Salman
                               // 12-16-2014 jhm: Use different check-box and Renewal Anniversary Date, instead.
                               if( null != e.Renewal_Anniversary_Date__c && (true == e.Reporting_Checkbox__c || true == e.Summary_Checkbox__c ) ) {
                                   if( true == e.Reporting_Checkbox__c || true == e.Summary_Checkbox__c ) {        // ON CYCLE
                                       if( onCycleContractTerms.containsKey( formatDate(e.Renewal_Anniversary_Date__c) + 'DC' + e.RecordTypeId ) ) {
                                           // update
                                           if( null != e.Contracts__c ) {
                                               onCycleContractTerms.put( formatDate(e.Renewal_Anniversary_Date__c) + 'DC' + e.RecordTypeId, onCycleContractTerms.get(formatDate(e.Renewal_Anniversary_Date__c) + 'DC' + e.RecordTypeId) + e.Contracts__c );
                                           }
                                       } else {
                                           // create it
                                           if( null != e.Contracts__c ) {
                                               onCycleContractTerms.put( formatDate(e.Renewal_Anniversary_Date__c) + 'DC' + e.RecordTypeId, e.Contracts__c );
                                           }
                                       }
                                       // groups, too
                                       if( onCycleGroupTerms.containsKey(formatDate(e.Renewal_Anniversary_Date__c) + 'DC' + e.RecordTypeId ) ) {
                                           // update
                                           if( null != e.Groups__c ) {
                                               onCycleGroupTerms.put( formatDate(e.Renewal_Anniversary_Date__c) + 'DC' + e.RecordTypeId, onCycleGroupTerms.get(formatDate(e.Renewal_Anniversary_Date__c) + 'DC' + e.RecordTypeId) + e.Groups__c );
                                           }
                                       } else {
                                           // create it
                                           if( null != e.Groups__c ) {
                                               onCycleGroupTerms.put( formatDate(e.Renewal_Anniversary_Date__c) + 'DC' + e.RecordTypeId, e.Groups__c );
                                           }
                                       }
                                   }
                               }
                           } // termed
                       }  // new business
                       if('Y' == e.New_Business_Indicator__c ) {
                           if( newContracts.containsKey( e.Rpt_Dt__c + 'DC' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Contracts__c ) {
                                   newContracts.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, newContracts.get(e.Rpt_Dt__c + 'DC' + e.RecordTypeId) + e.Contracts__c );
                               }
                           } else {
                               // create it
                               if( null != e.Contracts__c ) {
                                   newContracts.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, e.Contracts__c );
                               }
                           }
                           // Groups
                           if( newGroups.containsKey( e.Rpt_Dt__c + 'DC' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Groups__c ) {
                                   newGroups.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, newGroups.get(e.Rpt_Dt__c + 'DC' + e.RecordTypeId) + e.Groups__c );
                               }
                           } else {
                               // create it
                               if( null != e.Groups__c ) {
                                   newGroups.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, e.Groups__c );
                               }
                           }
                       }
                       // For 51+, the New Business Indicator and Status are apparently irrelevant
                   } else if( enrollment51RecordTypeId == e.RecordTypeId ) {
                       if( 'N' == e.New_Business_Indicator__c ) {
                           if( totalContracts.containsKey( e.Rpt_Dt__c + 'DC' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Contracts__c ) {
                                   totalContracts.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, totalContracts.get(e.Rpt_Dt__c + 'DC' + e.RecordTypeId) + e.Contracts__c );
                               }
                           } else {
                               // create it
                               if( null != e.Contracts__c ) {
                                   totalContracts.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, e.Contracts__c );
                               }
                           }
                       } else if( 'Y' == e.New_Business_Indicator__c ){    // New Business
                           if( newContracts.containsKey( e.Rpt_Dt__c + 'DC' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Contracts__c ) {
                                   newContracts.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, newContracts.get(e.Rpt_Dt__c + 'DC' + e.RecordTypeId) + e.Contracts__c );
                               }
                           } else {
                               // create it
                               if( null != e.Contracts__c ) {
                                   newContracts.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, e.Contracts__c );
                               }
                           }
                           // Groups
                           if( newGroups.containsKey( e.Rpt_Dt__c + 'DC' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Groups__c ) {
                                   newGroups.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, newGroups.get(e.Rpt_Dt__c + 'DC' + e.RecordTypeId) + e.Groups__c );
                               }
                           } else {
                               // create it
                               if( null != e.Groups__c ) {
                                   newGroups.put( e.Rpt_Dt__c + 'DC' + e.RecordTypeId, e.Groups__c );
                               }
                           }
                       }
                   }
                   // Virginia
               } else if( e.Opportunity__r.Account.Rating_State__c == 'V' ) {
                   if( enrollment2_50RecordTypeId == e.RecordTypeId ) {
                       if( 'N' == e.New_Business_Indicator__c ) {
                           // See if there's already a TOTAL entry for this date/jurisdiction
                           if( 'Active' == e.Status__c  ) {
                               if( totalContracts.containsKey( e.Rpt_Dt__c + 'VA' + e.RecordTypeId ) ) {
                                   // update
                                   if( null != e.Contracts__c ) {
                                       totalContracts.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, totalContracts.get(e.Rpt_Dt__c + 'VA' + e.RecordTypeId) + e.Contracts__c );
                                   }
                               } else {
                                   // create it
                                   if( null != e.Contracts__c ) {
                                       totalContracts.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, e.Contracts__c );
                                   }
                               }
                               // total groups, too
                               if( totalGroups.containsKey( e.Rpt_Dt__c + 'VA' + e.RecordTypeId ) ) {
                                   // update
                                   if( null != e.Groups__c ) {
                                       totalGroups.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, totalGroups.get(e.Rpt_Dt__c + 'VA' + e.RecordTypeId) + e.Groups__c );
                                   }
                               } else {
                                   // create it
                                   if( null != e.Groups__c ) {
                                       totalGroups.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, e.Groups__c );
                                   }
                               }
                               // See if there's already an ON-CYCLE entry for this date/jurisdiction
                               // 12-15-2014 jhm: Can't use the check-box determine on/off cycle, per Salman
                               // 12-16-2014 jhm: Use different check-box and Renewal Anniversary Date, instead.
                               if( null != e.Renewal_Anniversary_Date__c && true == e.Summary_Checkbox__c ) {
                                   String sDate = formatDate( e.Renewal_Anniversary_Date__c );
                                   if( onCycleContracts.containsKey( formatDate( e.Renewal_Anniversary_Date__c ) + 'VA' + e.RecordTypeId ) ) {
                                       // update
                                       if( null != e.Contracts__c ) {
                                           onCycleContracts.put( formatDate( e.Renewal_Anniversary_Date__c ) + 'VA' + e.RecordTypeId, onCycleContracts.get(formatDate( e.Renewal_Anniversary_Date__c ) + 'VA' + e.RecordTypeId) + e.Contracts__c );
                                       }
                                   } else {
                                       // create it
                                       if( null != e.Contracts__c ) {
                                           onCycleContracts.put( formatDate( e.Renewal_Anniversary_Date__c ) + 'VA' + e.RecordTypeId, e.Contracts__c );
                                       }
                                   }
                                   // groups, too
                                   if( onCycleGroups.containsKey( formatDate( e.Renewal_Anniversary_Date__c ) + 'VA' + e.RecordTypeId ) ) {
                                       // update
                                       if( null != e.Groups__c ) {
                                           onCycleGroups.put( formatDate( e.Renewal_Anniversary_Date__c ) + 'VA' + e.RecordTypeId, onCycleGroups.get(formatDate( e.Renewal_Anniversary_Date__c ) + 'VA' + e.RecordTypeId) + e.Groups__c );
                                       }
                                   } else {
                                       // create it
                                       if( null != e.Groups__c ) {
                                           onCycleGroups.put( formatDate( e.Renewal_Anniversary_Date__c ) + 'VA' + e.RecordTypeId, e.Groups__c );
                                       }
                                   }
                               }
                           } else if( 'Termed' == e.Status__c && enrollment2_50RecordTypeID == e.RecordTypeId ) {
                               // See if there's already a TERMED entry for this date/jurisdiction
                               if( termedContracts.containsKey( e.Rpt_Dt__c + 'VA' + e.RecordTypeId ) ) {
                                   // update
                                   if( null != e.Contracts__c ) {
                                       termedContracts.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, termedContracts.get(e.Rpt_Dt__c + 'VA' + e.RecordTypeId) + e.Contracts__c );
                                   }
                               } else {
                                   // create it
                                   if( null != e.Contracts__c ) {
                                       termedContracts.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, e.Contracts__c );
                                   }
                               }
                               // groups, too
                               if( termedGroups.containsKey(e.Rpt_Dt__c + 'VA' + e.RecordTypeId ) ) {
                                   // update
                                   if( null != e.Groups__c ) {
                                       termedGroups.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, termedGroups.get(e.Rpt_Dt__c + 'VA' + e.RecordTypeId) + e.Groups__c );
                                   }
                               } else {
                                   // create it
                                   if( null != e.Groups__c ) {
                                       termedGroups.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, e.Groups__c );
                                   }
                               }
                               // See if there's already an on-cycle TERMED entry for this date/jurisdiction
                               // 12-15-2014 jhm: Can't use the check-box determine on/off cycle, per Salman
                               // 12-16-2014 jhm: Use different check-box and Renewal Anniversary Date, instead.
                               if( null != e.Renewal_Anniversary_Date__c && (true == e.Reporting_Checkbox__c || true == e.Summary_Checkbox__c ) ) {
                                   if( true == e.Reporting_Checkbox__c || true == e.Summary_Checkbox__c ) {        // ON CYCLE
                                       if( onCycleContractTerms.containsKey( formatDate(e.Renewal_Anniversary_Date__c) + 'VA' + e.RecordTypeId ) ) {
                                           // update
                                           if( null != e.Contracts__c ) {
                                               onCycleContractTerms.put( formatDate(e.Renewal_Anniversary_Date__c) + 'VA' + e.RecordTypeId, onCycleContractTerms.get(formatDate(e.Renewal_Anniversary_Date__c) + 'VA' + e.RecordTypeId) + e.Contracts__c );
                                           }
                                       } else {
                                           // create it
                                           if( null != e.Contracts__c ) {
                                               onCycleContractTerms.put( formatDate(e.Renewal_Anniversary_Date__c) + 'VA' + e.RecordTypeId, e.Contracts__c );
                                           }
                                       }
                                       // groups, too
                                       if( onCycleGroupTerms.containsKey(formatDate(e.Renewal_Anniversary_Date__c) + 'VA' + e.RecordTypeId ) ) {
                                           // update
                                           if( null != e.Groups__c ) {
                                               onCycleGroupTerms.put( formatDate(e.Renewal_Anniversary_Date__c) + 'VA' + e.RecordTypeId, onCycleGroupTerms.get(formatDate(e.Renewal_Anniversary_Date__c) + 'VA' + e.RecordTypeId) + e.Groups__c );
                                           }
                                       } else {
                                           // create it
                                           if( null != e.Groups__c ) {
                                               onCycleGroupTerms.put( formatDate(e.Renewal_Anniversary_Date__c) + 'VA' + e.RecordTypeId, e.Groups__c );
                                           }
                                       }
                                   }
                               }
                           } // termed
                       }  // new business
                       if('Y' == e.New_Business_Indicator__c ) {
                           if( newContracts.containsKey( e.Rpt_Dt__c + 'VA' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Contracts__c ) {
                                   newContracts.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, newContracts.get(e.Rpt_Dt__c + 'VA' + e.RecordTypeId) + e.Contracts__c );
                               }
                           } else {
                               // create it
                               if( null != e.Contracts__c ) {
                                   newContracts.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, e.Contracts__c );
                               }
                           }
                           // Groups
                           if( newGroups.containsKey( e.Rpt_Dt__c + 'VA' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Groups__c ) {
                                   newGroups.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, newGroups.get(e.Rpt_Dt__c + 'VA' + e.RecordTypeId) + e.Groups__c );
                               }
                           } else {
                               // create it
                               if( null != e.Groups__c ) {
                                   newGroups.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, e.Groups__c );
                               }
                           }
                       }
                       // For 51+, the New Business Indicator and Status are apparently irrelevant
                   } else if( enrollment51RecordTypeId == e.RecordTypeId ) {
                       if( 'N' == e.New_Business_Indicator__c ) {
                           if( totalContracts.containsKey( e.Rpt_Dt__c + 'VA' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Contracts__c ) {
                                   totalContracts.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, totalContracts.get(e.Rpt_Dt__c + 'VA' + e.RecordTypeId) + e.Contracts__c );
                               }
                           } else {
                               // create it
                               if( null != e.Contracts__c ) {
                                   totalContracts.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, e.Contracts__c );
                               }
                           }
                       } else if( 'Y' == e.New_Business_Indicator__c ){    // New Business
                           if( newContracts.containsKey( e.Rpt_Dt__c + 'VA' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Contracts__c ) {
                                   newContracts.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, newContracts.get(e.Rpt_Dt__c + 'VA' + e.RecordTypeId) + e.Contracts__c );
                               }
                           } else {
                               // create it
                               if( null != e.Contracts__c ) {
                                   newContracts.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, e.Contracts__c );
                               }
                           }
                           // Groups
                           if( newGroups.containsKey( e.Rpt_Dt__c + 'VA' + e.RecordTypeId ) ) {
                               // update
                               if( null != e.Groups__c ) {
                                   newGroups.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, newGroups.get(e.Rpt_Dt__c + 'VA' + e.RecordTypeId) + e.Groups__c );
                               }
                           } else {
                               // create it
                               if( null != e.Groups__c ) {
                                   newGroups.put( e.Rpt_Dt__c + 'VA' + e.RecordTypeId, e.Groups__c );
                               }
                           }
                       }
                   }
               }
        }  // for
        System.debug( '--------> totalContracts has this many records: ' + totalContracts.size() );
        
        // put in the DB
        upsertSummaryData();        
    }
    
    // insert the data
    public void upsertSummaryData() {
        
        // Now spin back through my maps to build up the table.
        // Total Contracts
        Set<String> sTotalDates = totalContracts.keySet();
        List<Enrollment_Summary__c> lE1 = new List<Enrollment_Summary__c>();
        for( String s : sTotalDates ) {
            Enrollment_Summary__c e = new Enrollment_Summary__c(    Date__c = s.substring(0,6),
                                                                Jurisdiction__c = s.substring(6,8),
                                                                Unique_ID__c = s,
                                                                Total_Contracts__c = totalContracts.get(s) );
            if( enrollment2_50RecordTypeID == s.substring(8,26) ) {
                e.RecordTypeId = summary2_50RecordTypeId;
            } else {
                e.RecordTypeId = summary51RecordTypeId;
            }
            lE1.add(e);         
        }
        System.debug( 'upserting records: ' + lE1.size() );
        upsert lE1 Unique_ID__c;
        // On Cycle Contracts
        // 12-15-2014 jhm: Can't use the check-box determine on/off cycle, per Salman
        Set<String> sOnCycleContractDates = onCycleContracts.keySet();
        List<Enrollment_Summary__c> lE2 = new List<Enrollment_Summary__c>();
        for( String s : sOnCycleContractDates ) {
            Enrollment_Summary__c e = new Enrollment_Summary__c(    Date__c = s.substring(0,6),
                                                                Jurisdiction__c = s.substring(6,8),
                                                                Unique_ID__c = s,
                                                                On_Cycle_Contracts__c = onCycleContracts.get(s) );
            if( enrollment2_50RecordTypeID == s.substring(8,26) ) {
                e.RecordTypeId = summary2_50RecordTypeId;
            } else {
                e.RecordTypeId = summary51RecordTypeId;
            }
            lE2.add(e);         
        }
        System.debug( 'upserting records: ' + lE2.size() );
        upsert lE2 Unique_ID__c;
        // Contract Terms
        Set<String> sContractTerms = termedContracts.keySet();
        List<Enrollment_Summary__c> lE3 = new List<Enrollment_Summary__c>();
        for( String s : sContractTerms ) {
            Enrollment_Summary__c e = new Enrollment_Summary__c(    Date__c = s.substring(0,6),
                                                                Jurisdiction__c = s.substring(6,8),
                                                                Unique_ID__c = s,
                                                                Total_Termed_Contracts__c = termedContracts.get(s) );
            if( enrollment2_50RecordTypeID == s.substring(8,26) ) {
                e.RecordTypeId = summary2_50RecordTypeId;
            } else {
                e.RecordTypeId = summary51RecordTypeId;
            }
            lE3.add(e);         
        }
        System.debug( 'upserting records: ' + lE3.size() );
        upsert lE3 Unique_ID__c;
        // On Cycle Terms
        Set<String> sOnCycleTerms = onCycleContractTerms.keySet();
        List<Enrollment_Summary__c> lE4 = new List<Enrollment_Summary__c>();
        for( String s : sOnCycleTerms ) {
            Enrollment_Summary__c e = new Enrollment_Summary__c(    Date__c = s.substring(0,6),
                                                                Jurisdiction__c = s.substring(6,8),
                                                                Unique_ID__c = s,
                                                                On_Cycle_Termed_Contracts__c = onCycleContractTerms.get(s) );
            if( enrollment2_50RecordTypeID == s.substring(8,26) ) {
                e.RecordTypeId = summary2_50RecordTypeId;
            } else {
                e.RecordTypeId = summary51RecordTypeId;
            }
            lE4.add(e);         
        }
        System.debug( 'upserting records: ' + lE4.size() );
        upsert lE4 Unique_ID__c;
        // Total Groups
        Set<String> sTotalGroupDates = totalGroups.keySet();
        List<Enrollment_Summary__c> lE5 = new List<Enrollment_Summary__c>();
        for( String s : sTotalGroupDates ) {
            Enrollment_Summary__c e = new Enrollment_Summary__c(    Date__c = s.substring(0,6),
                                                                Jurisdiction__c = s.substring(6,8),
                                                                Unique_ID__c = s,
                                                                Total_Groups__c = totalGroups.get(s) );
            if( enrollment2_50RecordTypeID == s.substring(8,26) ) {
                e.RecordTypeId = summary2_50RecordTypeId;
            } else {
                e.RecordTypeId = summary51RecordTypeId;
            }
            lE5.add(e);         
        }
        System.debug( 'upserting records: ' + lE5.size() );
        upsert lE5 Unique_ID__c;
        // On Cycle Groups
        Set<String> sOnCycleGroupDates = onCycleGroups.keySet();
        List<Enrollment_Summary__c> lE6 = new List<Enrollment_Summary__c>();
        for( String s : sOnCycleGroupDates ) {
            Enrollment_Summary__c e = new Enrollment_Summary__c(    Date__c = s.substring(0,6),
                                                                Jurisdiction__c = s.substring(6,8),
                                                                Unique_ID__c = s,
                                                                On_Cycle_Groups__c = onCycleGroups.get(s) );
            if( enrollment2_50RecordTypeID == s.substring(8,26) ) {
                e.RecordTypeId = summary2_50RecordTypeId;
            } else {
                e.RecordTypeId = summary51RecordTypeId;
            }
            lE6.add(e);         
        }
        System.debug( 'upserting records: ' + lE6.size() );
        upsert lE6 Unique_ID__c;
        // Group Terms
        Set<String> sGroupTerms = termedGroups.keySet();
        List<Enrollment_Summary__c> lE7 = new List<Enrollment_Summary__c>();
        for( String s : sGroupTerms ) {
            Enrollment_Summary__c e = new Enrollment_Summary__c(    Date__c = s.substring(0,6),
                                                                Jurisdiction__c = s.substring(6,8),
                                                                Unique_ID__c = s,
                                                                Total_Termed_Groups__c = termedGroups.get(s) );
            if( enrollment2_50RecordTypeID == s.substring(8,26) ) {
                e.RecordTypeId = summary2_50RecordTypeId;
            } else {
                e.RecordTypeId = summary51RecordTypeId;
            }
            lE7.add(e);         
        }
        System.debug( 'upserting records: ' + lE7.size() );
        upsert lE7 Unique_ID__c;
        // On Cycle Group Terms
        Set<String> sOnCycleGroupTerms = onCycleGroupTerms.keySet();
        List<Enrollment_Summary__c> lE8 = new List<Enrollment_Summary__c>();
        for( String s : sOnCycleGroupTerms ) {
            Enrollment_Summary__c e = new Enrollment_Summary__c(    Date__c = s.substring(0,6),
                                                                Jurisdiction__c = s.substring(6,8),
                                                                Unique_ID__c = s,
                                                                On_Cycle_Termed_Groups__c = onCycleGroupTerms.get(s) );
            if( enrollment2_50RecordTypeID == s.substring(8,26) ) {
                e.RecordTypeId = summary2_50RecordTypeId;
            } else {
                e.RecordTypeId = summary51RecordTypeId;
            }
            lE8.add(e);         
        }
        System.debug( 'upserting records: ' + lE8.size() );
        upsert lE8 Unique_ID__c;
        // New Contracts
        Set<String> sNewContracts = newContracts.keySet();
        List<Enrollment_Summary__c> lE9 = new List<Enrollment_Summary__c>();
        for( String s : sNewContracts ) {
            Enrollment_Summary__c e = new Enrollment_Summary__c(    Date__c = s.substring(0,6),
                                                                Jurisdiction__c = s.substring(6,8),
                                                                Unique_ID__c = s,
                                                                New_Contracts__c = newContracts.get(s) );
            if( enrollment2_50RecordTypeID == s.substring(8,26) ) {
                e.RecordTypeId = summary2_50RecordTypeId;
            } else {
                e.RecordTypeId = summary51RecordTypeId;
            }
            lE9.add(e);         
        }
        System.debug( 'upserting records: ' + lE9.size() );
        upsert lE9 Unique_ID__c;
        // New Groups
        Set<String> sNewGroups = newGroups.keySet();
        List<Enrollment_Summary__c> lE10 = new List<Enrollment_Summary__c>();
        for( String s : sNewGroups ) {
            Enrollment_Summary__c e = new Enrollment_Summary__c(    Date__c = s.substring(0,6),
                                                                Jurisdiction__c = s.substring(6,8),
                                                                Unique_ID__c = s,
                                                                New_Groups__c = newGroups.get(s) );
            if( enrollment2_50RecordTypeID == s.substring(8,26) ) {
                e.RecordTypeId = summary2_50RecordTypeId;
            } else {
                e.RecordTypeId = summary51RecordTypeId;
            }
            lE10.add(e);            
        }
        System.debug( 'upserting records: ' + lE10.size() );
        upsert lE10 Unique_ID__c;
    }
    
    // 12-12-2014 jhm: Batch variables are apparently reinitialized with each batch, so I have to reload them each time.    
    public void rePopulateMaps() {
        List<Enrollment_Summary__c> lES = [SELECT Name, Date__c, Jurisdiction__c, Total_Contracts__c, Total_Groups__c,
                                           On_Cycle_Contracts__c, On_Cycle_Groups__c, Total_Termed_Contracts__c, Total_Termed_Groups__c,
                                           On_Cycle_Termed_Contracts__c, On_Cycle_Termed_Groups__c, New_Contracts__c, New_Groups__c,
                                           Unique_Id__c     
                                           FROM Enrollment_Summary__c];
        for( Enrollment_Summary__c ES : lES ) {
            
            totalContracts.put(         ES.Unique_Id__c,    ES.Total_Contracts__c );
            onCycleContracts.put(       ES.Unique_Id__c,    ES.On_Cycle_Contracts__c );
            termedContracts.put(        ES.Unique_Id__c,    ES.Total_Termed_Contracts__c );
            onCycleContractTerms.put(   ES.Unique_Id__c,    ES.On_Cycle_Termed_Contracts__c );
            newContracts.put(           ES.Unique_Id__c,    ES.New_Contracts__c );
            
            totalGroups.put(            ES.Unique_Id__c,    ES.Total_Groups__c );
            onCycleGroups.put(          ES.Unique_Id__c,    ES.On_Cycle_Groups__c );
            termedGroups.put(           ES.Unique_Id__c,    ES.Total_Termed_Groups__c );
            onCycleGroupTerms.put(      ES.Unique_Id__c,    ES.On_Cycle_Termed_Groups__c );
            newGroups.put(              ES.Unique_Id__c,    ES.New_Groups__c );
        }
    }
    
    //  Returns the date in the same format as the Report Date
    public string formatDate( Date dt ) {
        String sDate = string.valueOf(dt.year());
        if( string.valueOf( dt.month()).length() == 1 ) {
            sDate += '0';
        }
        sDate += string.valueOf( dt.Month() );
        /* We don't want the day, anyway */
        /*
if( string.valueof( dt.Day() ).length == 1 ) {
sDate += '0';
}
sDate += string.valueOf( dt.Day() );
*/
        return sDate;
    }
    
    private void get51PlusMagicNumbers() {
        
        AggregateResult[] fiftyOnePlus = [SELECT Account.Rating_State__c State, Count(Id) Groups, SUM(Account.Latest_Medical_Enrollment__c) Contracts
                                          FROM Opportunity
                                          WHERE Account.RecordTypeID = :QueryBase.getRecordtypeId( 'Account', 'X51')
                                          AND StageName = 'Dead'
                                          AND Account.Rating_State__c != null
                                          GROUP BY Account.Rating_State__c];
        
        // delete existing record
        List<Enrollment_Summary_51_Terms__c> oldSettings = [SELECT Id FROM Enrollment_Summary_51_Terms__c];
        if( 0 < oldSettings.size() && !Test.isRunningTest() ) {
            delete oldSettings;
        }
        
        // 12-17-2014 jhm: Put new values in our custom setting
        List<Enrollment_Summary_51_Terms__c> newSettings = new List<Enrollment_Summary_51_Terms__c>();
        for( AggregateResult ar : fiftyOnePlus ) {
            Enrollment_Summary_51_Terms__c setting = new Enrollment_Summary_51_Terms__c();
            String Jurisdiction = '';
            if( String.valueOf( ar.get('State') ) == 'M' ||
               String.valueOf( ar.get('State') ) == 'R' ) {
                   
                   Jurisdiction = 'MD';
               } else if( String.valueOf( ar.get('State') ) == 'V' ) {
                   Jurisdiction = 'VA';
               } else if( String.valueOf( ar.get('State') ) == 'D' ) {
                   Jurisdiction = 'DC';
               }
            setting.name = string.valueOf(Date.Today() + '_' + Jurisdiction );
            setting.Jurisdiction__c = Jurisdiction;
            setting.Contracts__c = Integer.valueOf( ar.get('Groups') );
            setting.Groups__c = Integer.valueOf( ar.get('Contracts') );
            newSettings.add( setting );
        }
        insert newSettings;
    } 
}