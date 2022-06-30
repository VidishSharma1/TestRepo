/*
 *Description: Controller class for case comments lwc 
*/
public class orld_CaseCommentController {
    
     @AuraEnabled(cacheable=true)
    public static list<QuickText> getQuickText(){
        system.debug('Inside QuickText');
        List<QuickText> lst = new List<QuickText>([SELECT Id, Name FROM QuickText where Active__c = true]);
        system.debug('lst '+lst);
        return lst;
    }
    
    /*
 *Description: method to get quick text based on quick text ID
*/
      @AuraEnabled
    public static String getQuickMessage(String qID){
        system.debug('Inside QuickTextMessage'+qID);
        String message='';
        for(QuickText q : [SELECT Id, Message FROM QuickText where id=: qID]){
            message = q.message;
        }
        system.debug('message '+message);
        return message;
    }
    
    /*
 *Description: method to save case comments in feed item
*/
    @AuraEnabled
    public static void postComment(string caseId, String comment){
        system.debug('inside postComment'+caseId+'------'+comment);
        //String buzzName = [Select Id,Name from Buzzword__c where id =:picklistVal limit 1].Name;
       // List<Buzzword_distribution__c> buzzlst = new List<Buzzword_distribution__c>([SELECT Id, Name, Email__c FROM Buzzword_distribution__c WHERE Active__c = true AND Buzzword__c = :picklistVal ]);
        system.debug('caseId '+caseId);
        if(caseId != null && comment != ''){
        if(comment.containsIgnoreCase('<br>')){
            comment = comment.replaceAll('<br>', '<p>&nbsp;</p>');
            system.debug('comment' +comment);
        }
        if(comment.containsIgnoreCase('<strike>')){
            comment = comment.replaceAll('<strike>', '<s>');
            comment = comment.replaceAll('</strike>', '</s>');
            system.debug('comment' +comment);
        }
        if(comment.containsIgnoreCase('<em>')){
            comment = comment.replaceAll('<em>', '<i>');
            comment = comment.replaceAll('</em>', '</i>');
            system.debug('comment' +comment);
        }
        if(comment.containsIgnoreCase('<strong>')){
            comment = comment.replaceAll('<strong>', '<b>');
            comment = comment.replaceAll('</strong>', '</b>');
            system.debug('comment' +comment);
        }
            try{
        FeedItem f = new FeedItem();
                f.ParentID = caseId;
        		f.Body = comment;
        		f.IsRichText = true;
              //  c.Buzzword__c = buzzName;
              Insert f;
        FeedItem ff = [Select createddate,Id,Body from feedItem where id=:f.id];
        Case cs = new Case();
        cs.Id = caseId;
        cs.orld_Case_Comment__c  = ff.createddate+'-'+ff.Body;
        Update cs;
            }
            catch(Exception e){
                
            }
    }
    }

}