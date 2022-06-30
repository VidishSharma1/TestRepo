/*
* Description: Trigger for Travel Party Object
*/
trigger Orld_TravelPartyTrigger on Orld_Travel_Party__c(Before Insert,Before Update) {
	
	if(Orld_Utility.isTriggerActive('Orld_Travel_Party__c')){
		if(Trigger.IsBefore){
			if(Trigger.IsInsert){
				Orld_TravelPartyTriggerHandler.beforeInsert(Trigger.New);
			}else if(Trigger.IsUpdate){
				Orld_TravelPartyTriggerHandler.beforeUpdate(Trigger.OldMap,Trigger.New);
			}
		}
	}
}