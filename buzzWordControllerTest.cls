/*
 * Description: Test class for buzzWordControllerTest
 * */
@isTest
public class buzzWordControllerTest {
    
    @isTest
    public static void testMethod1(){
        String guestServicesRecTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guest_Services').getRecordTypeId();
        Contact con=Orld_TestDataFactory.createContact(guestServicesRecTypeId);
		con.MailingCity = 'Test';
        con.MailingCountry = 'United State';
        con.Description='Guest Services Test Contact';
        insert con;
        
        String guestOrlandoRecTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Orld_Guest_Communications_Orlando').getRecordTypeId();
        Case cs=Orld_TestDataFactory.createCase(guestOrlandoRecTypeId);
        cs.Status = 'Open';
        cs.ContactId = con.id;
        insert cs;
        
        Orld_BuzzWord__c bz = Orld_TestDataFactory.createBuzzword();
        Insert bz;
        
        Orld_Buzzword_distribution__c bzd = Orld_TestDataFactory.createBuzzwordDist(bz.Id);
        Insert bzd;
        
        
        
        Reason_Code__c rs = new Reason_Code__c();
        rs.Case_Lookup__c = cs.Id;
        rs.Orld_Resort__c = 'UOR';
        rs.Orld_Location__c = 'USF';
        rs.Orld_Land__c = 'Park-Wide';
        rs.Orld_Department__c = 'Attraction Operations';
        rs.Orld_Venue__c = 'Area-Wide';
        rs.Orld_Comment_Code__c = 'Team Member';
        rs.Sentiment__c = 'Positive';
        insert rs;
        
         Reason_Code__c rs1 = new Reason_Code__c();
        rs1.Case_Lookup__c = cs.Id;
        insert rs1;
        
         
        
        Test.startTest();
        BuzzWordController bzc = new BuzzWordController();
        BuzzWordController.getBuzzword();
        BuzzWordController.getDistributionList(bz.Id, cs.Id);
        BuzzWordController.sendAlertToDL(cs.Id);
        BuzzWordController.lastSelectedBuzzword(cs.Id);
        BuzzWordController.changeSendEmail(cs.Id,true);
        BuzzWordController.getMedicalForms(cs.id);
        Test.stopTest();
    }

}