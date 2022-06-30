/*
* Test class for Orld_FeeItemTrigger and Orld_FeedItemTriggerHandler
*/
@IsTest
public class Orld_FeedTrigger_Test {
    
    @TestSetup
    public static void createTestData(){
        String guestOrlandoRecTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Orld_Guest_Communications_Orlando').getRecordTypeId();
        Case cs=Orld_TestDataFactory.createCase(guestOrlandoRecTypeId);
        INSERT cs;
        
        FeedItem fItem=Orld_TestDataFactory.createFeedItem(cs.Id);
        INSERT fItem;
        
        
    }

    @IsTest
    public static void test_preventCommentDelete(){
        Profile pf= [Select Id from profile where Name='Guest Services Orlando']; 
        List<String> roleNames=System.Label.Orld_Roles_Feed_Item_Comment_Delete.split(',');
		List<UserRole> orlandoUserRoles=[SELECT Id, Developername,name FROM UserRole WHERE Developername IN :roleNames];
        
        User usr=Orld_TestDataFactory.createUser(pf.Id,orlandoUserRoles[0].Id);
        INSERT usr;
        FeedItem fItem=[Select Id,body FROM FeedItem Limit 1 ];
        DELETE fItem; 
    }
}