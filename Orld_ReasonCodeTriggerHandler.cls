/*
 * Description: Handler class for ReasonCodeTrigger
 * 
*/
public class Orld_ReasonCodeTriggerHandler {
	/*
	 *Description:  Method to prevent adding more than 5 reason code record on case 
	 * 
	*/
    public static void preventMoreThanFiveReasonCodes(List<Reason_Code__c> reasonCodes){
        Set<Id> caseIds=new Set<Id>();
        Map<String,Integer> caseIdToReasonCountMap=new Map<String,Integer>();
        
        String guestOrlandoRecTypeId=Schema.SObjectType.Reason_Code__c.getRecordTypeInfosByDeveloperName().get('Orld_Guest_Communications_Orlando').getRecordTypeId();
        
        for(Reason_Code__c reasonCode:reasonCodes){
            if(reasonCode.RecordTypeId==guestOrlandoRecTypeId){
            	caseIds.add(reasonCode.Case_Lookup__c);    
            }
        }
        
        AggregateResult[] aggResults=[Select Count(Id),Case_Lookup__c FROM Reason_Code__c WHERE Case_Lookup__c IN :caseIds Group By Case_Lookup__c ];
        
        if(!aggResults.IsEmpty()){
            
            
            for(AggregateResult aggResult:aggResults){
                caseIdToReasonCountMap.put((String)aggResult.get('Case_Lookup__c'),(Integer)aggResult.get('expr0'));
                
            }  
            
            for(Reason_Code__c reasonCode:reasonCodes){
                if(reasonCode.Case_Lookup__c != null)
                if(caseIdToReasonCountMap.get(reasonCode.Case_Lookup__c)!=null && caseIdToReasonCountMap.get(reasonCode.Case_Lookup__c)>=5){
                    reasonCode.addError('Only five reason codes are allowed for a case');
                }
            }
        }
    }
    
    /*
	 *Description:  Method to create medical forms if reason code is medical 
	 * 
	*/
    public static void createMedicalForms(List<Reason_Code__c> reasonCodes,Map<Id,Reason_Code__c> oldReasonCodeMap){
        Map<String,Orld_Medical_Code_Mapping__mdt> medicalCodeConfigMap=new Map<String,Orld_Medical_Code_Mapping__mdt>();
        Map<String,Case> caseMap=new  Map<String,Case>();
        
        
        for(Orld_Medical_Code_Mapping__mdt medicalCodeConfig:[SELECT Id, Label, DeveloperName FROM Orld_Medical_Code_Mapping__mdt WHERE Orld_Active__c=true]){
            medicalCodeConfigMap.put(medicalCodeConfig.Label, medicalCodeConfig);
        }
        
        List<Orld_Medical_Form__c> medicalFormsToInsert=new List<Orld_Medical_Form__c>();
        
        for(Reason_Code__c rc:reasonCodes){
            if((medicalCodeConfigMap.get(rc.Orld_Location__c)!=null && Trigger.IsInsert) || (Trigger.IsUpdate && medicalCodeConfigMap.get(rc.Orld_Location__c)!=null && rc.Orld_Location__c!=oldReasonCodeMap.get(rc.Id).Orld_Location__c)){
                medicalFormsToInsert.add(new Orld_Medical_Form__c(Orld_Case__c=rc.Case_Lookup__c,Orld_Reason_Code__c=rc.Id));
                if(caseMap.get(rc.Case_Lookup__c)==null){
                    caseMap.put(rc.Case_Lookup__c, new Case(Id=rc.Case_Lookup__c,Orld_Medical__c=true));
                }
            }
        }
        
        if(!medicalFormsToInsert.isEmpty()){
            INSERT medicalFormsToInsert;
        }
        
        if(caseMap.size()>0){
            UPDATE caseMap.values();
        }
        
    }
}