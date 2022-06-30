public without sharing class Orld_Utility {
    static Map<String,Boolean> triggerStatusMap=new Map<String,Boolean>();
    static final String ALL_TRIGGERS='All_Triggers';

    static{
        for(Orld_Trigger_Config__mdt triggerConfig:[SELECT Id, DeveloperName, Active__c, Orld_Object_API_Name__c FROM Orld_Trigger_Config__mdt]){
            triggerStatusMap.put(triggerConfig.Orld_Object_API_Name__c,triggerConfig.Active__c);
        }

    }

    /*
    * Description: Method to check if there is active entry in Trigger Config custom metadata
    */
    public static Boolean isTriggerActive(String ObjectAPIName){
        if(triggerStatusMap.get(ObjectAPIName) && triggerStatusMap.get(ALL_TRIGGERS)){
            return true;
        }else{
            return false;
        }
    }
}