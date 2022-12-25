public with sharing class AccountContactService {
    public static void updateActiveContacts(Set<Id> accountIds){
        List <AggregateResult> results = [
                                SELECT AccountId,COUNT(Id) totalContacts 
                                FROM Contact 
                                WHERE Active__c = TRUE AND AccountId IN :accountIds 
                                GROUP BY AccountId
                                ];

            Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
            for(AggregateResult result : results){
                  // get account id and num of active contacts
                  String accId = String.valueOf(result.get('AccountId'));
                  Integer totalContacts = Integer.valueOf(result.get('totalContacts'));

                  Account acc = new Account(Id=accId, Active_Contacts__c=totalContacts);
                  accountsToUpdate.put(accId, acc);

                  //OR accountsToUpdate.add(new Account(Id=accId, Active_Contacts__c=totalContacts));
            }
            // update accounts with zero active contacts
            for(Id accId : accountIds){
                if(!accountsToUpdate.containsKey(accId)){
                    accountsToUpdate.put(accId, new Account(Id=accId, Active_Contacts__c= 0));
                }
            }
            update accountsToUpdate.values();

    }
   
}
