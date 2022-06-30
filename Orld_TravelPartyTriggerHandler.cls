/*
* Description: TriggerHandler for Orld_TravelPartyTrigger Trigger
*/
public class Orld_TravelPartyTriggerHandler {
    
    /*
	* Description: method for before insert logic
	*/
    public static void beforeInsert(List<Orld_Travel_Party__c> newTravelParties){
        
        Set<Id> caseIds=new Set<Id>();
        Set<Id> contactIds=new Set<Id>();
        
        for(Orld_Travel_Party__c tp:newTravelParties){
            caseIds.add(tp.Orld_Case__c);
            contactIds.add(tp.Orld_Contact__c);
        }
        if(!contactIds.isEmpty()){
        	setTravelPartyName(contactIds,newTravelParties);    
        }
        
        preventDupTravelPartyMembers(caseIds,newTravelParties);
    }
    
    /*
	* Description: method for before update logic
	*/
    public static void beforeUpdate(Map<Id,Orld_Travel_Party__c> oldTravelPartyMap,List<Orld_Travel_Party__c> newTravelParties){
        
        Set<Id> caseIds=new Set<Id>();
        Set<Id> contactIds=new Set<Id>();
        
        for(Orld_Travel_Party__c tp:newTravelParties){
            if(tp.Orld_Case__c!=oldTravelPartyMap.get(tp.Id).Orld_Case__c || tp.Orld_Contact__c!=oldTravelPartyMap.get(tp.Id).Orld_Contact__c ||
              tp.Orld_Role__c!=oldTravelPartyMap.get(tp.Id).Orld_Role__c){
                caseIds.add(tp.Orld_Case__c);
            }
            if(tp.Orld_Contact__c!=oldTravelPartyMap.get(tp.Id).Orld_Contact__c){
                contactIds.add(tp.Orld_Contact__c);
            }
            
        }
        if(!contactIds.isEmpty()){
        	setTravelPartyName(contactIds,newTravelParties);    
        }
        preventDupTravelPartyMembers(caseIds,newTravelParties);
    }
    
    /*
	* Description: method to prevent duplicate travel party members
	*/
    public static void preventDupTravelPartyMembers(Set<Id> caseIds,List<Orld_Travel_Party__c> newTravelParties){
        Map<String,String> existingTpCombination=new  Map<String,String>();
        List<Orld_Travel_Party__c> existingTps=[Select Orld_Case__c,Orld_Contact__c,Orld_Role__c from Orld_Travel_Party__c WHERE Orld_Case__c IN :caseIds  ];
        for(Orld_Travel_Party__c eTp:existingTps){
            String travelPartyCombination=eTp.Orld_Case__c+''+eTp.Orld_Contact__c+''+eTp.Orld_Role__c;
            existingTpCombination.put(travelPartyCombination,travelPartyCombination);
        }
        
        if(!existingTpCombination.isEmpty()){
            for(Orld_Travel_Party__c tp:newTravelParties){
                String travelPartyCombination=tp.Orld_Case__c+''+tp.Orld_Contact__c+''+tp.Orld_Role__c;
                if(existingTpCombination.get(travelPartyCombination)!=null){
                    tp.addError(System.Label.DuplicatePartyMemberMsg);
                }
            }
        }
    }
    
    public static void setTravelPartyName(Set<Id> contactIds,List<Orld_Travel_Party__c> newTravelParties){
        Map<Id,Contact> contactMap=new Map<Id,Contact>([Select Id,Name FROM Contact WHERE Id IN :contactIds]);
        
        for(Orld_Travel_Party__c tp:newTravelParties){
            tp.Name = contactMap.get(tp.Orld_Contact__c).Name;
        }
    }
    
}