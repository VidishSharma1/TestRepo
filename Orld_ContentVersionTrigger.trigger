trigger Orld_ContentVersionTrigger on ContentVersion (after insert) {
    
    if(Orld_Utility.isTriggerActive('ContentVersion')){
    Id profileId=userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    system.debug('ProfileName'+profileName);
    String ContentdocumentIds;
    String filetitle;
    String filetypes;
    ContentVersion cvObj = new ContentVersion();
    if(profileName.containsIgnoreCase('Guest Services Orlando') || Test.isRunningTest()){
        
        for(ContentVersion cv : [SELECT Id, FileExtension,FileType,ContentDocumentId,title  FROM ContentVersion where Id IN : Trigger.Newmap.keySet()])
        {
            cvObj.id = cv.id;
            system.debug('fileType'+cv.fileType);
            filetitle = cv.title;
            filetypes = cv.FileType;
            ContentdocumentIds  = cv.ContentDocumentId;
            String s = orld_res_file_type__c.getOrgDefaults().File_Type__c+orld_res_file_type__c.getOrgDefaults().File_Type2__c+orld_res_file_type__c.getOrgDefaults().File_Type3__c; //Fetching the value from custom setting
            
            /** if(cv.FileType =='png')
{

cv.Id.addError('File having this extension could not be attached,Please try some other extension.');
} **/
            if(s.containsIgnoreCase(cv.FileType+',') || (cv.FileType).containsIgnoreCase('UNKNOWN'))
            {
                cv.addError('File having this extension could not be attached,Please try some other extension.'); 
                
            }
        } 
        String caseId = '';
        for(ContentDocumentLink cd : [Select LinkedEntityId from ContentDocumentLink  where contentDocumentID =:ContentdocumentIds ]){
            String sObjName = cd.LinkedEntityId.getSObjectType().getDescribe().getName();
            system.debug('sObjNAme'+sObjName);
            if(sObjName.equalsIgnoreCase('Case')){
                caseId = cd.LinkedEntityId;
            }
            else if(Test.isRunningTest()){
                List<Case> caseList = new List<Case>([Select id from case limit 1]);
                system.debug('caseList '+caseList);
                if(caseList.size()>0){
                    caseId = caseList[0].id;
                }
            }
        }
        //system.debug('case ID '+caseId);
        
        
        //   String sObjName = caseId.getSObjectType().getDescribe().getName();
        if(caseId != ''){
            Case cs = [Select OwnerId from case where id =: caseId];
            User uRId = [Select UserRoleId from User where id=: cs.OwnerID limit 1];
            system.debug('case Owner Role '+uRId);
            Id uID = UserInfo.getUserId();
            User loggedInUserRole = [Select UserRoleId from User where id=: uID limit 1];
            UserRole ur = [SELECT Id, Name, RollupDescription, ForecastUserId FROM UserRole where Name= 'Guest Services Coordinator Orlando'];
            system.debug('loggedInUserRole.UserRoleId '+loggedInUserRole.UserRoleId);
            if(String.valueOf(loggedInUserRole.UserRoleId).equalsIgnoreCase(ur.id)){
                if(String.valueOf(uRId.UserRoleId).equalsIgnoreCase(ur.id)){
                    system.debug('inside same role ');
                    if(cs.OwnerId != UserInfo.getUserId()){
                        if(Trigger.isInsert){
                        for(ContentVersion cv : [SELECT Id, FileExtension,FileType,ContentDocumentId  FROM ContentVersion where Id IN : Trigger.Newmap.keySet()])
                        {
                            cv.Id.addError('You are not auhtorize to upload the attchment in this case');
                        }
                        }
                       
                    }
                    
                }
                else{
                    for(ContentVersion cv : [SELECT Id, FileExtension,FileType,ContentDocumentId  FROM ContentVersion where Id IN : Trigger.Newmap.keySet()])
                    {
                        cv.Id.addError('You are not auhtorize to upload the attchment in this case');
                    }
                }
            }  
             
             FeedItem f = new FeedItem();
                        f.ParentId = caseId;
                        f.Body = filetitle +'.'+fileTypes+ ' File Uploaded Successfully';
                        Insert f;
            
        }
    }
    }
}