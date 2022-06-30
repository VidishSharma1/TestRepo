/*
* Description: Class for Dynamic Email template for Executive Alerts
*/
public class CustomTemplateController {
    static Map<String, Schema.SObjectField> fieldMap;
    static Map<String, Schema.SObjectType> schemaMap=Schema.getGlobalDescribe();
    
    static{
        String objType='Case';
        Schema.SObjectType objSchema = schemaMap.get(objType);
        fieldMap = objSchema.getDescribe().fields.getMap();
    }
    
    /*
*Description: method to create html email body for email template 
*/
    public static String prepareData(String caseId,Orld_BuzzWord__c buzzword){
        if(buzzword!=null){
            Map<String,Orld_Buzzword_Template_Mapping__mdt> buzzTmpMapConfig=new Map<String,Orld_Buzzword_Template_Mapping__mdt>();
            Map<String,Orld_Buzzword_Template_Mapping__mdt> caseTmpMapConfig=new Map<String,Orld_Buzzword_Template_Mapping__mdt>();
            Map<String,Orld_Buzzword_Template_Mapping__mdt> contTmpMapConfig=new Map<String,Orld_Buzzword_Template_Mapping__mdt>();
            for(Orld_Buzzword_Template_Mapping__mdt buzzTmpMap:[SELECT Id, Orld_Buzzword_Name__c,Orld_Heading_Name__c,Orld_Child_Relationship_Name__c,Orld_Object_API_Name__c,Orld_Fields__c,Orld_Sort_Order__c   FROM Orld_Buzzword_Template_Mapping__mdt WHERE Orld_Buzzword_Name__c=:buzzword.Name and Orld_Active__c=true Order By Orld_Sort_Order__c ]){
                if(buzzTmpMap.Orld_Object_API_Name__c=='Case'){
                    caseTmpMapConfig.put(buzzTmpMap.Orld_Object_API_Name__c,buzzTmpMap);
                }else if(buzzTmpMap.Orld_Object_API_Name__c=='Contact'){
                    contTmpMapConfig.put(buzzTmpMap.Orld_Object_API_Name__c, buzzTmpMap);
                }else{
                    buzzTmpMapConfig.put(buzzTmpMap.Orld_Child_Relationship_Name__c,buzzTmpMap);    
                }
            }
            
            if(caseTmpMapConfig.get('Case')!=null){
                String query='Select '+caseTmpMapConfig.get('Case')?.Orld_Fields__c;
                if(contTmpMapConfig.get('Contact')?.Orld_Fields__c!=null){
                    query+=','+contTmpMapConfig.get('Contact').Orld_Fields__c;
                }
                
                String subquery='';
                
                List<String> subqueries=new List<String>();
                for(String key:buzzTmpMapConfig.keySet()){
                    subqueries.add('( Select '+buzzTmpMapConfig.get(key)?.Orld_Fields__c+' FROM '+key+')');
                }
                
                if(!subqueries.isEmpty()){
                    subquery=String.join(subqueries, ',');
                }
                
                if(subQuery!=''){
                    query+=','+subQuery+' FROM Case WHERE Id=\''+caseId+'\'';
                }else{
                    query+=' FROM Case WHERE Id=\''+caseId+'\'';
                }
                System.debug(query);
                
                List<Case> cases=Database.query(query);
                
                String emailbody = 'Hi, </br></br>';
                if(buzzword.Orld_Buzzword_Description__c!=null){
                    emailbody += buzzword.Orld_Buzzword_Description__c+'</b></br></br>';
                }
                
                if(contTmpMapConfig.get('Contact')!=null){
                    emailbody +='</br><b>'+contTmpMapConfig.get('Contact').Orld_Heading_Name__c+'</b></br>';
                    for(String field:contTmpMapConfig.get('Contact').Orld_Fields__c.split(',')){
                        if(field.contains('.')){
                            list<String> mergeFields=field.split('\\.');
                            String label=schemaMap.get(mergeFields[0]).getDescribe().fields.getMap().get(mergeFields[1]).getDescribe().getLabel();
                            if(cases[0].getSobject(mergeFields[0])?.get(mergeFields[1])!=null){
                                emailbody+=label+' : '+cases[0].getSobject(mergeFields[0])?.get(mergeFields[1])+'</br>';
                            }else{
                            	emailbody+=label+' : </br>';    
                            }
                            
                        }   
                    }
                }
                
                if(caseTmpMapConfig.get('Case')!=null){
                    emailbody +='</br><b>'+caseTmpMapConfig.get('Case').Orld_Heading_Name__c+'</b></br>';
                    for(String field:caseTmpMapConfig.get('Case').Orld_Fields__c.split(',')){
                        if(field.contains('.')){
                            list<String> mergeFields=field.split('\\.');
                            String label=schemaMap.get(mergeFields[0]).getDescribe().fields.getMap().get(mergeFields[1]).getDescribe().getLabel();
                            emailbody+=label+' : '+cases[0].getSobject(mergeFields[0])?.get(mergeFields[1]) +'</br>';
                        }else{
                            if(cases[0].get(field)!=null){
                                emailbody+=fieldMap.get(field).getDescribe().getLabel()+' : '+cases[0].get(field) +'</br>';
                            }else{
                            	emailbody+=fieldMap.get(field).getDescribe().getLabel()+' : </br>';    
                            }
                            
                        }
                    }
                }
                
                for(String key:buzzTmpMapConfig.keySet()){
                    emailbody+='</br> <b>'+buzzTmpMapConfig.get(key).Orld_Heading_Name__c+'</b> </br>';
                    Map<String, Schema.SObjectField> objectFieldMap=schemaMap.get(buzzTmpMapConfig.get(key).Orld_Object_API_Name__c).getDescribe().fields.getMap();
                    for(Sobject sobj:cases[0].getSobjects(key)){
                        for(String field:buzzTmpMapConfig.get(key).Orld_Fields__c.split(',')){
                            if(sobj.get(field)!=null){
                            	emailbody+=objectFieldMap.get(field).getDescribe().getLabel()+' : '+sobj.get(field)+'</br>';    
                            }else{
                                emailbody+=objectFieldMap.get(field).getDescribe().getLabel()+' : </br>';    
                            }
                            
                        }
                        emailbody+='</br>';
                    }
                }
                emailbody += '</br> Regards,</br>';
                emailbody += 'Management Team </br>';
                emailbody += 'Orlando Guest Communications </br>';
                
                return emailbody;
            }
        }
        return '';
    }
}