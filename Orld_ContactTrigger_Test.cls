/*
 * Description: Test class for Orld_ContactTrigger
 */
@IsTest
public class Orld_ContactTrigger_Test {

    
    /*
     * Description Test method to test Orld_ContactTrigger.creatGuestServicesAccount 
     */
    @IsTest
    public static void test_creatGuestServicesAccount(){
        String guestServicesRecTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guest_Services').getRecordTypeId();
        List<Contact> contacts=new List<Contact>();
        contacts.add(Orld_TestDataFactory.createContact(guestServicesRecTypeId));
        contacts.add(Orld_TestDataFactory.createContact(guestServicesRecTypeId));
        
        INSERT contacts;
    }
    
    /*
     * Description Test method to test Orld_ContactTrigger.updateGuestServicesAccount 
     */
    @IsTest
    public static void test_updateGuestServicesAccount(){
        String guestServicesRecTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guest_Services').getRecordTypeId();
        List<Contact> contacts=new List<Contact>();
        contacts.add(Orld_TestDataFactory.createContact(guestServicesRecTypeId));
        contacts.add(Orld_TestDataFactory.createContact(guestServicesRecTypeId));
        
        INSERT contacts;
        
        contacts[0].Email='Testfirst.Testlast@test.test';
        UPDATE contacts[0];
    }
    
    /*
     * Description Test method to test Orld_ContactTrigger.deleteGuestServicesAccount 
     */
    @IsTest
    public static void test_deleteGuestServicesAccount(){
        String guestServicesRecTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guest_Services').getRecordTypeId();
        List<Contact> contacts=new List<Contact>();
        contacts.add(Orld_TestDataFactory.createContact(guestServicesRecTypeId));
        contacts.add(Orld_TestDataFactory.createContact(guestServicesRecTypeId));
        
        INSERT contacts;
        
        Test.startTest();
        DELETE contacts[0];
        Test.stopTest();
        
    }
    
    /*
     * Description Test method to test Orld_ContactTrigger.updateSpecialEvents 
     */
    @IsTest
    public static void test_updateSpecialEvents(){
        Account act = Orld_TestDataFactory.createAccount(null);
        INSERT  act;
        
        Contact con=Orld_TestDataFactory.createContact(null);
        INSERT con;
        
        SpecialEvent__c specialEvt=Orld_TestDataFactory.createSpecialEvent(act.Id, con.Id);
        INSERT specialEvt;
        
        Test.startTest();
        con.Email='emailUpdated@test.test';
        Update con;
        Test.stopTest();
        
        
    }
    
    /*
     * Description Test method to test Orld_ContactTrigger.insertCampaignTeamMember 
     */
    @IsTest
    public static void test_insertCampaignTeamMember(){
        Campaign camp=Orld_TestDataFactory.createCampaign();
        INSERT camp;
        
        Account act = Orld_TestDataFactory.createAccount(null);
        act.Business_Type__c='Gradventure';
        INSERT  act;
        
		Contact con=Orld_TestDataFactory.createContact(null);
        con.AccountId=act.Id;
		INSERT con;        
    }
}