({
	//Method to set the url attribute in the component
    doInit : function(component, event, helper) {
        var action = component.get("c.getUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.url", response.getReturnValue());
            }
            });
         $A.enqueueAction(action);

    },
    
})