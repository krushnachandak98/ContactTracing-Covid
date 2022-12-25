trigger LocationTrigger on Location__c (before insert, before update) {
    switch on Trigger.operationType{

        when BEFORE_INSERT{
            LocationTriggerHandler.beforeInsert(Trigger.new);

        }

        when BEFORE_UPDATE{
            LocationTriggerHandler.beforeUpdate(Trigger.new,Trigger.oldMap);

        }

        when AFTER_UPDATE{
            LocationTriggerHandler.afterUpdate(Trigger.new,Trigger.oldMap);

        }
    }

}