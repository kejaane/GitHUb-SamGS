/*=========================================================================================
 * Date     : 10/02/2015
 * Developer    : Ken Gill
 * Purpose      : This class is the extension point of the Trigger Framework for adding CaseComment trigger handlers.
 *                
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/02/15  |  KG    | Initial Version                                         
 *           |        | 
 *===========+============+================================================================
 */

public with sharing class CaseCommentTriggerHandler extends TriggerHandler {

    public CaseCommentTriggerHandler() {}
    
        /* context override */

    protected override void afterInsert() {
		processFacetsIntegrationAfterCaseCommentInsertORUpdate();		
    }
    
    protected override void afterUpdate() {		
    	processFacetsIntegrationAfterCaseCommentInsertORUpdate();
    }

	// Entry point for processing CaseComment after insert event for Facets integration - KGill 10/3/15
	private void processFacetsIntegrationAfterCaseCommentInsertORUpdate() {
			if(System.isBatch() || System.isFuture()) {
				System.debug('CaseCommentTriggerHandler: Bypassing Facets Integration CaseComment AfterInsert trigger processing when called from Batch or Future job');
				return;
			}
		 // Note on casting below:
		  // Outside a trigger, the trigger collections Trigger.new,.old have to be explicitly cast to the SOBject type
		  // When working inside a trigger, this casting happens implicitly
		  FCI_FacetsService.processNewCaseComments(( Map<Id,CaseComment>) Trigger.newMap);
	}

}