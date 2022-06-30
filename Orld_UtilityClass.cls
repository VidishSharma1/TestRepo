public with sharing class Orld_UtilityClass {

    public Boolean fieldListPermission(String sObjectType,List<String> fieldNameList, String operation){

     SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);

     Map<String, SObjectField> fields= schemaType.getDescribe().fields.getMap();

     for(String fieldName : fieldNameList){

         DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();

         if(operation.containsIgnoreCase('C')){

             if(!(fieldDescribe.isCreateable())){

                 return false;

             }

         }

         if(operation.containsIgnoreCase('R')){

             if(!(fieldDescribe.isAccessible())){

                 return false;

             }

         }

         if(operation.containsIgnoreCase('U')){

             if(!(fieldDescribe.isUpdateable())){

                 return false;

             }

         }

     }

    return true;

 }

 public Boolean fieldListIsAccessible(String sObjectType,List<String> fieldNameList){

     SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);

     Map<String, SObjectField> fields= schemaType.getDescribe().fields.getMap();

     for(String fieldName : fieldNameList){

         DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();

         if(!(fieldDescribe.isAccessible())){

             return false;

         }

     }

    return true;

 }

 /*public Boolean fieldListIsCreateable(String sObjectType,List<String> fieldNameList){

     SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);

     Map<String, SObjectField> fields= schemaType.getDescribe().fields.getMap();

     for(String fieldName : fieldNameList){

         DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();

         if(!(fieldDescribe.isCreateable())){

             return false;

         }

     }

    return true;

 }*/

 public Boolean objectPermission(String sObjectType , String operation){

     SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);

         if(operation.containsIgnoreCase('C')){

             if(!(schemaType.getDescribe().isCreateable())){

                 return false;

             }

         }

         if(operation.containsIgnoreCase('R')){

             if(!(schemaType.getDescribe().isAccessible())){

                 return false;

             }

         }

         if(operation.containsIgnoreCase('U')){

             if(!(schemaType.getDescribe().isUpdateable())){

                 return false;

             }

         }

         if(operation.containsIgnoreCase('D')){

             if(!(schemaType.getDescribe().isDeletable())){

                 return false;

             }

         }

         if(operation.containsIgnoreCase('Q')){

             if(!(schemaType.getDescribe().isQueryable())){

                 return false;

             }

         }

     return true;

 }

 public List<String> getDefaultStandardObjects(){

     List<String> listOfDefaultStandardObjectNames = new List<String>();

     listOfDefaultStandardObjectNames.add('Lead');

     listOfDefaultStandardObjectNames.add('Opportunity');

     listOfDefaultStandardObjectNames.add('Contact');

     listOfDefaultStandardObjectNames.add('Account');

     return listOfDefaultStandardObjectNames;

 }

 public Boolean fieldIsAccessible(String sObjectType, String fieldName)

 {

     SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);

     Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();

     DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();

     return fieldDescribe.isAccessible();

 }

 /*public Boolean fieldIsCreateable(String sObjectType, String fieldName)

 {

     SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);

     Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();

     DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();

     return fieldDescribe.isCreateable();

 }

 public Boolean fieldIsUpdateable(String sObjectType, String fieldName)

 {

     SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);

     Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();

     DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();

     return fieldDescribe.isUpdateable();

 }*/

 public Boolean objectIsAccessible(String sObjectType)

 {

     SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);

     return schemaType.getDescribe().isAccessible();

 }

 public Boolean objectIsQueryable(String sObjectType)

 {

     SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);

     return schemaType.getDescribe().isQueryable();

 }

 /*public Boolean objectIsCreateable(String sObjectType)

 {

     SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);

     return schemaType.getDescribe().isCreateable();

 }

 public Boolean objectIsUpdateable(String sObjectType)

 {

     SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);

     return schemaType.getDescribe().isUpdateable();

 }

 public Boolean objectIsDeletable(String sObjectType)

 {

     SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);

     return schemaType.getDescribe().isDeletable();

 }*/

}