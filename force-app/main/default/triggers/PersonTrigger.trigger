trigger PersonTrigger on Person__c (before insert,after insert, before update, after update){

    switch on Trigger.operationType{

        when BEFORE_INSERT {
            PersonTriggerHandler.beforeInsert(Trigger.new);
        }

        when BEFORE_UPDATE {
            PersonTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }

        when AFTER_UPDATE {
            PersonTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
    