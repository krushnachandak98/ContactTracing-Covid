({
    fetchLocationInformation : function (component) {
        const recordId = component.get("v.recordId");
        const action = component.get("c.getLocationDetails");
        action.setParams({
            recordId
        });
        action.setCallback(this, function (response) {
            const state = response.getState();

            if(state === "SUCCESS"){
                const resp = response.getReturnValue();
                //check if user found
                if (!resp || !resp.name) {
                    component.set("v.locationFound", false);
                    this.showToast("ERROR","Please enter valid location id", "error");
                } else {
                    component.set("v.locationFound", true);
                    component.set("v.locationInfo", resp);
                }
            } else {
                component.set("v.locationFound", false);
                this.showToast("ERROR", "Please enter valid location id", "error");
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function(title, message, type) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title,
            message,
            type
        });
        toastEvent.fire();
    }
});
