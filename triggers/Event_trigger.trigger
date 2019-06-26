/***********************************************************************************
     Date: 12/21/2011
Developer: Tom Barrett
  Purpose: To handle any programmatic Event functionality required through a trigger   
------------------------------------------------------------------------------------
                       ----===[ HISTORY ]===---
Date        Developer        Description
------------------------------------------------------------------------------------
12/22/2011  Tom Barrett      Origin: To force the Related To field to be an 
                             Engagement record if the Event is of RecordType 
                             Training Session, House Meeting, or Debrief Meeting.
***********************************************************************************/
trigger Event_trigger on Event (before insert, before update){
    if ( trigger.isBefore ) {    
//===== BEGIN Handle forcing Engagement for the Related To field if the Record Type(EVENT) is Training Session, House Meeting or Debrief Meeting
        // Retrieve all recordtype ids for the defined meeting types Training Session, House Meeting and Debrief Meeting for the Event object
        List<RecordType> recTypes = [ Select Id From RecordType Where Name IN('DPS: Training Session', 'DPS: House Meeting', 'DPS: Internal Team Meeting') and SobjectType = 'Event' ];
        
        // Get the first three characters of the Engagement record id.  This will be used below to determine if an Engagement is selected
        // This has to be done this way because SF does not expose that Event field to my knowledge
        List<Engagements__c> te = [ Select id From Engagements__c LIMIT 1 ];
        if ( te.size() > 0 ) { // IF statement is only really needed until the first Engagement record is created
            String EngagementId3 = te[0].id;
            EngagementId3 = EngagementId3.substring(0,3);          
            for (Event evt : Trigger.new) {               
                If ( evt.RecordTypeId <> null ) {  // This will be null everytime when pushed to SF from Salesforce for Outlook
                    // Check if the Event's record type matches one in the recTypes List
                    if ( String.valueOf(recTypes).contains(evt.RecordTypeId) ) { 
                        // Since the Event WhatId always starts witht the same characters for an Enagement 
                        // we were able to use it to force the user to select an Engagement record
                        if ( evt.WhatId == null || !String.valueOf(evt.WhatId).startsWith(EngagementId3) ) {
                            evt.WhatId.addError('A related Enagement must be selected');
                        }
                    }
                }
            }
        }
//===== END Handle forcing Engagement for the Related To field if the Record Type(EVENT) is Training Session, House Meeting or Internal Team Meeting
    }
}