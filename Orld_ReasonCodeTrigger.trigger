trigger Orld_ReasonCodeTrigger on Reason_Code__c (Before Insert,After Insert,After Update) {
    if(Orld_Utility.isTriggerActive('Reason_Code__c')){
    if(Trigger.IsInsert){
        if(Trigger.IsBefore){
    		Orld_ReasonCodeTriggerHandler.preventMoreThanFiveReasonCodes(Trigger.New);        
        }else if(Trigger.IsAfter){
            Orld_ReasonCodeTriggerHandler.createMedicalForms(Trigger.New,null);
        }
    }else if(Trigger.IsUpdate){
        if(Trigger.IsAfter){
            Orld_ReasonCodeTriggerHandler.createMedicalForms(Trigger.New,Trigger.oldMap);
        }
    }
    }
}