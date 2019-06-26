({
	doInit : function(component, event, helper)  {
          //call apex class method
        var action = component.get('c.getMsg');
        action.setCallback(this,function(response){
             //store state of response
            var state = response.getState();
            if (state === "SUCCESS"){
                 //set response value in objClassController attribute on component
                component.set('v.objClassController', response.getReturnValue());
            }
        });
         $A.enqueueAction(action);
	},
})