({
   doInit : function(component, event, helper) {
   		var urlEvent = $A.get("e.force:navigateToURL");   		
        var action = component.get("c.getOppIdforPartner");
        action.setParams({ partner_id : component.get("v.recordId") });
        action.setCallback(this, function(response) {
	        var state = response.getState();
            if (state === "SUCCESS") {
                var oppid = response.getReturnValue();         
           		 if(urlEvent) {
        			urlEvent.setParams({
           				"url": "/apex/Partner_RelatedList_Page?oppid="+oppid,
           				"isredirect": "true"
         		 	});
         			urlEvent.fire();
				  } 
             }
         })
         $A.enqueueAction(action);
    }
})