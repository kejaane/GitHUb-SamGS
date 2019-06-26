({
   doInit : function(component, event, helper) {
   		var urlEvent = $A.get("e.force:navigateToURL");   		      
        var action = component.get("c.getOppIdforFSPGP");
        action.setParams({ fsp_gp_id : component.get("v.recordId") });
        action.setCallback(this, function(response) {
	        var state = response.getState();
            if (state === "SUCCESS") {
                var oppid = response.getReturnValue();         
           		 if(urlEvent) {
        			urlEvent.setParams({
           				"url": "/apex/FSP_GP_RelatedList_Page?oppid="+oppid,
           				"isredirect": "true"
         		 	});
         			urlEvent.fire();
				  } 
             }
         })
         $A.enqueueAction(action);
    }
})