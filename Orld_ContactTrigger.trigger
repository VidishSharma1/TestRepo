trigger Orld_ContactTrigger on Contact (Before Insert,After Update,After Delete) {
    if(Orld_Utility.isTriggerActive('Contact')){
    if(Trigger.IsInsert){
        if(Trigger.IsBefore){
            Orld_ContactTriggerHandler.creatGuestServicesAccount(Trigger.New);
        }
       	Orld_ContactTriggerHandler.insertCampaignTeamMember(Trigger.New);
    }else if(Trigger.IsUpdate){
        if(Trigger.IsAfter){
        	Orld_ContactTriggerHandler.updateGuestServicesAccount(Trigger.New,Trigger.OldMap);  
            Orld_ContactTriggerHandler.updateSpecialEvents(Trigger.OldMap,Trigger.NewMap);
        }
    }else if(Trigger.IsDelete){
        if(Trigger.IsAfter){
        	Orld_ContactTriggerHandler.deleteGuestServicesAccount(Trigger.Old);    
        }
    }
    }
}