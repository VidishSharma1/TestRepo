/*
 * Description: Test class for Orld_TravelPartyTrigger, Orld_TravelPartyTriggerHandler
 * */
@IsTest
public class Orld_TravelPartyTrigger_Test {
	
    @TestSetup
    public static void createTestData(){
        String guestServicesRecTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guest_Services').getRecordTypeId();
        List<Contact> contacts=new List<Contact>();
        contacts.add(Orld_TestDataFactory.createContact(guestServicesRecTypeId));
        contacts.add(Orld_TestDataFactory.createContact(guestServicesRecTypeId));
        //Contact cont=Orld_TestDataFactory.createContact(guestServicesRecTypeId);
        INSERT contacts;
        String guestOrlandoRecTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Orld_Guest_Communications_Orlando').getRecordTypeId();
        Case c=Orld_TestDataFactory.createCase(guestOrlandoRecTypeId);
        INSERT c;
        
        List<Orld_Travel_Party__c> travelParties=new List<Orld_Travel_Party__c>();
        travelParties.add(Orld_TestDataFactory.createTravelParty(contacts[0].Id, c.Id));
        travelParties.add(Orld_TestDataFactory.createTravelParty(contacts[1].Id, c.Id));
        //Orld_Travel_Party__c travelParty=Orld_TestDataFactory.createTravelParty(cont.Id, c.Id);
        INSERT travelParties;
	}
    
    @IsTest
    public static void test_preventDupTravelPartyMembersOnInsert(){
        
        Contact cont=[Select Id FROM Contact LIMIT 1];
        Case cs=[Select Id FROM Case LIMIT 1];
        Test.startTest();
        try{
        	Orld_Travel_Party__c travelParty=Orld_TestDataFactory.createTravelParty(cont.Id, cs.Id);
        	INSERT travelParty;    
        }catch(Exception e){
            System.assert(e.getMessage().contains('Duplicate Travel Party Member'));
        }
        
        Test.stopTest();
    }
    
    @IsTest
    public static void test_preventDupTravelPartyMembersOnUpdate(){
        
        List<Contact> conts=[Select Id FROM Contact];
        Case cs=[Select Id FROM Case LIMIT 1];
        Test.startTest();
        try{
        	Orld_Travel_Party__c tp=[Select Orld_Case__c,Orld_Contact__c FROM Orld_Travel_Party__c WHERE Orld_Contact__c=:conts[0].Id limit 1];
        	tp.Orld_Contact__c=conts[1].Id;
            UPDATE tp;    
        }catch(Exception e){
            System.assert(e.getMessage().contains('Duplicate Travel Party Member'));
        }
        
        Test.stopTest();
    }
}