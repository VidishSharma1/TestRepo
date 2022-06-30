@IsTest
public class Orld_TestDataFactory {
    
    public static String getUnassignedQId(){
        List<Group> groups=[SELECT Id, Name, DeveloperName, Type FROM Group WHERE Type ='Queue' and DeveloperName='Orld_Unassigned'];
        if(!groups.isEmpty()){
            return groups[0].Id;
        }
        return null;
    }

    public static Case createCase(String recordTypeId){
        Case c=new Case();
        c.Subject='Issue With Electricity';
        c.SuppliedEmail='test@test.test';
        c.SuppliedName='Test Test';
        c.RecordTypeId=recordTypeId;
        c.Origin='Email';
        c.orld_Case_Comment__c='Test Case Comments';
      	return c;  
    }
    
    public static Reason_Code__c createReasonCode(String recordTypeId,String caseId){
        Reason_Code__c reasonCode=new Reason_Code__c();
        reasonCode.Case_Lookup__c=caseId;
        reasonCode.RecordTypeId=recordTypeId;
        reasonCode.Orld_Resort__c='UOR';
        reasonCode.Sentiment__c='Neutral';
        reasonCode.Orld_Location__c='Medical Form';
        
        return reasonCode;
    }
    
    public static Orld_BuzzWord__c createBuzzword(){
        Orld_BuzzWord__c bz =  new Orld_BuzzWord__c();
        bz.Orld_Active__c = true;
        bz.Orld_Buzzword_Description__c = 'Test Description';
        bz.Name = 'Fire Emergency';
        return bz;
    }
    
    public static Orld_Buzzword_distribution__c createBuzzwordDist(String buzzwordId){
        Orld_Buzzword_distribution__c bzd =  new Orld_Buzzword_distribution__c();
        bzd.Orld_Active__c = true;
        bzd.Orld_Buzzword__c = buzzwordId;
        bzd.Name = 'Test BuzzDis';
        bzd.Orld_Email__c = 'vidish@mirketa.com;prajyot@mirketa.com';
        return bzd;
    }
    
    public static Orld_Travel_Party__c createTravelParty(String contactId,String caseId){
        Orld_Travel_Party__c travelParty=new Orld_Travel_Party__c();
        travelParty.Orld_Case__c=caseId;
        travelParty.Orld_Contact__c=contactId;
        travelParty.Orld_Role__c='Travel Party';
        return travelParty;
    }
    
    public static Account createAccount(String recordTypeId){
        Account newAcc=new Account();
        newAcc.Name='Test Account';
        newAcc.Segment__c='HOTEL';
        if(newAcc.RecordTypeId!=null){
            newAcc.RecordTypeId=recordTypeId;
        }
        return newAcc;
    }
    
    public static Contact createContact(String recordTypeId){
        Contact newContact=new Contact();
        newContact.FirstName='FirstNameTest';
        newContact.LastName='LastNameTest';
        newContact.Email='FirstNameTest.LastNameTest@testdomain.test';
        newContact.Phone='8765654345';
        if(newContact.RecordTypeId!=null){
            newContact.RecordTypeId=recordTypeId;
        }
        return newContact;
    }
    
    public static FeedItem createFeedItem(String parentId){
        FeedItem fItem = new FeedItem();
        fItem.ParentID = parentId;
        fItem.Body = 'Test Comment';
        fItem.IsRichText = true;
        return fItem;
    }
    
    public static User createUser(String profile,String role){
        User usr=new User();
        usr.firstname = 'firstNameTest';
        usr.lastName = 'lastNameTest';
        usr.email = 'firstNameTest.lastNameTest@test.test'; 
        usr.Username = 'ush.chatter@nbcuni.com.test';
        usr.EmailEncodingKey = 'ISO-8859-1'; 
        usr.Alias = 'flname'; 
        usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr.LocaleSidKey = 'en_US';
        usr.LanguageLocaleKey = 'en_US'; 
        usr.ProfileId = profile;
        usr.UserRoleId=role;
        return usr;
    }
    
    public static SpecialEvent__c createSpecialEvent(String accountId,String contactId){
        SpecialEvent__c splEvent = new SpecialEvent__c();
        splEvent.Account__c=accountId;
        splEvent.Event_Contact__c=contactId;
        splEvent.Name='Test Special Event';
        splEvent.Minimum_Guarantee__c = 1000;
        splEvent.Status__c='Interest';
        splEvent.Event_Type__c='Picnic';
        return splEvent;
    }
    

    public static Campaign createCampaign(){
        Campaign camp = new Campaign();
        camp.name = 'Gradventure';
        return camp;
    }    
}