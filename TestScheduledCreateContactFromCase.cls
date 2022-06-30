@isTest
public class TestScheduledCreateContactFromCase {
    public static String caseRecTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Guest_Communications').getRecordTypeId();
    public static String conRecTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guest_Services').getRecordTypeId();
    
    private static testmethod void test_scheduledCreateContactFromCasePositive(){
        List <Case> cases = new List<Case>();
        
        for(integer i = 0; i<20; i++){
            Case c = new case( First_Name__c = 'FNTest' + i,
                              Last_Name__c = 'LNTest' + i,
                              SuppliedEmail = 'Test' + i + '@gmail.com',
                              Phone_Number__c = '555-555-5555',
                              Address_1__c = i + 'Test Lane',
                              City__c = 'Los Angeles',
                              State__c = 'CA',
                              Zip_Code__c = '90004',
                              Country__c = 'United States',
                              RecordTypeId = caseRecTypeId); 
            
            cases.add(c);
        }
        
        INSERT cases;
        
        Test.startTest();
        ScheduledCreateContactFromCase schCreateCon=new ScheduledCreateContactFromCase();
        schCreateCon.errors='Test Error';
        System.schedule('Test Job','0 0 0 ? * * *', schCreateCon);
        Test.stopTest();
        
    }
    
    private static testmethod void test_scheduledCreateContactFromCaseNegative(){
        List <Case> cases = new List<Case>();
        
        Contact con=new Contact(FirstName='FNTest0',LastName='LNTest0',Email='Test@gmail.com',RecordTypeId=conRecTypeId);
        INSERT con;
        
        for(integer i = 0; i<20; i++){
            Case c = new case( First_Name__c = 'FNTest' + i,
                              Last_Name__c = 'LNTest' + i,
                              SuppliedEmail = 'Test@gmail.com',
                              Phone_Number__c = '555-555-5555',
                              Address_1__c = i + 'Test Lane',
                              City__c = 'Los Angeles',
                              State__c = 'CA',
                              Zip_Code__c = '90004',
                              Country__c = 'United States',
                              RecordTypeId = caseRecTypeId); 
            
            cases.add(c);
        }
        INSERT cases;
                
        Test.startTest();
        ScheduledCreateContactFromCase schCreateCon=new ScheduledCreateContactFromCase();
        System.schedule('Test Job','0 0 0 ? * * *', schCreateCon);
        Test.stopTest();
        
    }
    
}