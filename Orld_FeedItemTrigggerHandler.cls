/*
*  TriggerHandler class for trigger for Orld_FeeItemTrigger
*/
public class Orld_FeedItemTrigggerHandler {
    
    static List<String> roleNames=System.Label.Orld_Roles_Feed_Item_Comment_Delete.split(',');
	static  Map<Id,User> coordinatorUserMap=new Map<Id,User>();
    static List<UserRole> orlandoUserRoles=[SELECT Id, Developername,name FROM UserRole WHERE Id=:UserInfo.getUserRoleId() and Developername IN :roleNames];
    
    /*
	*Description: method to prevent deletion for coordinators & seniors & supervisors
	*/
    public static void preventCommentDelete(list<FeedItem> oldFeedItems){
        Set<String> createdByIds=new Set<String>();
        
        for(FeedItem fitem:oldFeedItems){
            if(fitem.Type=='TextPost' && String.valueOf(fitem.ParentId).startsWith('500') && !orlandoUserRoles.isEmpty()){
                fitem.addError(System.Label.Orld_Prevent_Feed_Deletion_Message);
            }            
        }
    }
}