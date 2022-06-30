trigger Orld_FeedItemTrigger on FeedItem (after insert,before delete) {
    
    
    if(Orld_Utility.isTriggerActive('FeedItem')){
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            Orld_FeedItemTrigggerHandler.preventCommentDelete(Trigger.Old);
        }
    }
    }
    /*
    else if(Trigger.isAfter){
        if(Trigger.isInsert){
            Map<Id, FeedItem> contentversionIdToFeedItemMap = new Map<Id, FeedItem>();
            for(FeedItem fi : trigger.new){
                if(fi.type == 'ContentPost')
                    contentversionIdToFeedItemMap.put(fi.RelatedRecordId, fi);
            }
            for(ContentVersion cv : [SELECT Id, FileExtension,FileType FROM ContentVersion where Id IN :contentversionIdToFeedItemMap.keySet()])
            {
                system.debug('fileType'+cv.fileType);
                if(cv.FileType =='png')
                {
                    contentversionIdToFeedItemMap.get(cv.Id).addError('File having this extension could not be attached,Please try some other extension.');
                }
            }
        }
        
    }   
    */
    
}