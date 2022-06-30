/*
 *Description: Test class for Orld_ResaonCodeTrigger 
*/
@IsTest
public class Orld_ReasonCodeTrigger_Test {
	
    @TestSetup
    public static void createTestData(){
        String guestOrlandoRecTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Orld_Guest_Communications_Orlando').getRecordTypeId();
        Case c=Orld_TestDataFactory.createCase(guestOrlandoRecTypeId);
        INSERT c;
        
        String orlandoRecordTypeId=Schema.SObjectType.Reason_Code__c.getRecordTypeInfosByDeveloperName().get('Orld_Guest_Communications_Orlando').getRecordTypeId();
        List<Reason_Code__c> reasonCodes=new List<Reason_Code__c>();
        for(Integer i=0;i<5;i++){
            reasonCodes.add(Orld_TestDataFactory.createReasonCode(orlandoRecordTypeId,c.Id));
        }
        INSERT reasonCodes;
        
    }
    
    @IsTest
    public static void test_preventMoreThanFiveReasonCodes(){
        Case c=[Select Id FROM Case Limit 1];
        String orlandoRecordTypeId=Schema.SObjectType.Reason_Code__c.getRecordTypeInfosByDeveloperName().get('Orld_Guest_Communications_Orlando').getRecordTypeId();
        
        Test.startTest();
        	Reason_Code__c reasonCode=Orld_TestDataFactory.createReasonCode(orlandoRecordTypeId,c.Id);
        try{
            INSERT reasonCode;
        }catch(Exception e){
            System.assert(e.getMessage().contains('Only five reason codes are allowed for a case'));
        }
        	
        Test.stopTest();
    }
}