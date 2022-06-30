trigger CaseTrigger on Case (before insert, after insert, before update, after update, after delete) {
    
    if(Orld_Utility.isTriggerActive('Case')){
    //Create an instance of CaseHelper
    CaseHelper ch = new CaseHelper();

    if (Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)) {
        //ch.setCaseEntitlement(Trigger.newMap, Trigger.oldMap, Trigger.new);
        CaseHelper.setResetCaseFields(Trigger.New,Trigger.OldMap);
    } //if before insert
    
   if (Trigger.isBefore && Trigger.isInsert) {
        CaseHelper.createContactFromEmailToCase(Trigger.New);
        CaseHelper.createContactFromCase(Trigger.New);
	}
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        
        //ch.completeMilestone(Trigger.new);
        ch.setContactPhoneNum(Trigger.newMap, Trigger.oldMap);
        ch.refundFormEmail(Trigger.newMap, Trigger.oldMap);
        ch.reasonCodeEmail(Trigger.newMap, Trigger.oldMap);
        
        
    } //after update
    
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter ){
 		CaseHelper.createFeeItem(Trigger.new, Trigger.oldMap);       
    }
    }
}