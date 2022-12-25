public with sharing class PersonTriggerHandler {
    public static void beforeInsert(List<Person__c>newPer) {

        for(Person__c person: newPer){
            person.Health_Status__c = 'Green';
            person.Token__c = CTPersonController.getToken(person.Mobile__c);

        }
    }
    
    public static void beforeUpdate(List<Person__c> newPer, Map<Id,Person__c> oldMapPerson){
        for(Person__c person :newPer){
            if(person.Health_Status__c != oldMapPerson.get(person.Id).Health_Status__c){
                person.Status_Update_Date__c= Date.Today();
            }
        }
    }

    public static void afterUpdate(List<Person__c> newPer, Map<Id,Person__c> oldMapPerson){
        Set<id> statusChange = new Set<Id>();
        Set<id> redStatus = new Set<Id>();
        for(Person__c person: newPer){
            if(person.Health_Status__c != oldMapPerson.get(person.Id).Health_Status__c){
                statusChange.add(person.Id);                
            }
            if(person.Health_Status__c == 'Red' && oldMapPerson.get(person.Id).Health_Status__c !='Red'){
                redStatus.add(person.Id);
                
            }
        }

        Set<Id> alreadyProcessed = new Set<Id>();
        alreadyProcessed.addAll(redStatus);

        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();

        List<Person__c> personToUpdate = new List<Person__c>();

        orangeStatus.addAll(CTPersonController.getCohabitants(redStatus,alreadyProcessed));

        Set<Id> primaryContacts = CTPersonController.getPrimaryContacts(redStatus,alreadyProcessed);
        orangeStatus.addAll(primaryContacts);

        yellowStatus.addAll(CTPersonController.getNeighbours(redStatus,alreadyProcessed));
        
        yellowStatus.addAll(CTPersonController.getSecondaryContacts(primaryContacts,alreadyProcessed));

        for(Id pid : orangeStatus){
            personToUpdate.add(new Person__c(Id=pid, Health_Status__c = 'Orange'));
        }

        for(Id pid : yellowStatus){
            personToUpdate.add(new Person__c(Id=pid, Health_Status__c = 'Yellow'));
        }

        if(personToUpdate.size() > 0){
            update personToUpdate;
        }

        List<Location_Tracing__c> locationtraces = CTLocationTracingController.getLocationsByPersonIds(statusChange);
        if(locationtraces != null && locationtraces.size() > 0){
            Set<Id> locationIds = new Set<Id>();
            for(Location_Tracing__c trace : locationtraces){
                locationIds.add(trace.Location__c);
            }

        }
        
    }
}
