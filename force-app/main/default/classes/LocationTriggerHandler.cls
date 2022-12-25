public with sharing class LocationTriggerHandler {
    public static void beforeInsert(List<Location__c> newLoc) {
        
        for(Location__c Location : newLoc){
            Location.Status__c = 'Green';
        }
    }

    public static void beforeUpdate(List<Location__c> newLoc, Map<Id,Location__c> mapOldLocation){
        for(Location__c Location : newLoc){
            if(Location.Status__c != mapOldLocation.get(Location.Id).Status__c){
                Location.Status_Update_Date__c = Date.today();
            }
        }                  
    }
    // If location status changes to Red
    // Mark all people yellow who have visited the location in the last 10 days - except the red and orange ones

    public static void afterUpdate(List<Location__c> newLoc, Map<Id,Location__c> mapOfLocation) {
        Set<Id> statusChange = new Set<Id>();
        for(Location__c Location: newLoc){
            if(Location.Status__c != mapOfLocation.get(Location.Id).Status__c){
                Location.Status__c = 'Red';
                statusChange.add(Location.Id);
            }
        }
        
        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationByLocationIds(statusChange);
        Set<Id> personIds = new Set<Id>();
        for(Location_Tracing__c trace : locationTraces){
            personIds.add(trace.Person__c);
        }

        List<Person__c> peopleToUpdate = new List<Person__c>();
        for(Id pid: personIds){
            peopleToUpdate.add(new Person__c(Id=pid,Health_Status__c='Yellow'));
        }

        if(peopleToUpdate.size()>0){
            update peopleToUpdate;

        }

    }
}
