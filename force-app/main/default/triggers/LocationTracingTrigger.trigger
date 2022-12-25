trigger LocationTracingTrigger on Location_Tracing__c (before insert) {
    switch on Trigger.operationType{
        when BEFORE_INSERT{
            LocationTracingTriggerHandler.beforeInsert(Trigger.new);

        }
    }
}