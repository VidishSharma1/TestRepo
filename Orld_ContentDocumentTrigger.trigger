trigger Orld_ContentDocumentTrigger on ContentDocument (before delete) {

    if(Orld_Utility.isTriggerActive('ContentDocument')){
     Id profileId=userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    system.debug('ProfileName'+profileName);
    String ContentdocumentIds;
    String filetitle;
    String filetypes;
     String caseId = '';
    ID cdId;
    ContentVersion cvObj = new ContentVersion();
    if(profileName.containsIgnoreCase('Guest Services Orlando') || Test.isRunningTest()){
         for(ContentDocument cd : [SELECT Id, FileExtension,FileType,title  FROM ContentDocument where Id IN : Trigger.oldMap.keySet()])
                        {
                            cdId = cd.id;
                            filetitle = cd.Title;
                            filetypes = cd.FileType;
                           // cd.addError('You are not auhtorize to upload the attchment in this case');
                        }
        for(ContentDocumentLink cd : [Select LinkedEntityId from ContentDocumentLink  where contentDocumentID =:cdId ]){
            String sObjName = cd.LinkedEntityId.getSObjectType().getDescribe().getName();
            if(sObjName.equalsIgnoreCase('Case')){
                caseId = cd.LinkedEntityId;
            }
        }
        system.debug('caseId '+caseId);
        if(caseId != ''){
            system.debug('Inside Cdocument');
            
         FeedItem f = new FeedItem();
                        f.ParentId = caseId;
                        f.Body = filetitle +'.'+fileTypes+ ' File Deleted Successfully';
                        Insert f;
        }
    }
    }
}