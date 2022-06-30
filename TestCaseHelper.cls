@isTest
public class TestCaseHelper {
    
    @isTest static void testreasonCodeEmail() { 
        
        //create Test Contact
        Contact con = New Contact(
            LastName = 'Test',
            Email = 'Test32f@test.com'
        );
        insert con;

        //create new Cases
        List<RecordType> rt = [SELECT Id FROM RecordType WHERE Name != 'X1' AND SobjectType = 'Case'];
        Case c = new Case(
            RecordType = rt[0],
            Date_of_Visit__c = System.today(),
            Phone_Number__c = '8675309',
            Ticket_Number__c = '12345',
            Case_Experience_RC_Alert__c = '1234567'
        );
        insert c;
            
        Case c2 = new Case(
            RecordType = rt[0],
            Date_of_Visit__c = System.today(),
            Phone_Number__c = '8675309',
            Ticket_Number__c = '12345',
            Action_Required__c = 'No',
            Case_Experience_RC_Alert__c = '12345678'
        );
        insert c2;
        
        //create reason code
        Reason_Code__c rc = new Reason_Code__c(
            Venue__c = 'Attractions',
            Case_Lookup__c = c2.Id
        );
        insert rc;
        
        Test.startTest();
        
        //update the cases
        c.Action_Required__c = 'Yes';
        
        update c;
    
        c2.Status = 'Closed';
        
        update c2;  

        Test.stopTest();
    }
    
    /* @isTest static void testSetCaseEntitlement() {
        
        //Create Account
        Account a = New Account(Name = 'X1 Team');
        insert a;
        
        //Create Entitlements
        Entitlement e = new Entitlement(
            Name = 'X1 Entitlement',
            AccountID = a.Id);
        insert e;
        
        //Create Cases
        Group[] queueX1 = [SELECT Id FROM Group WHERE Name = 'X1 Case Queue' AND Type = 'Queue'];
        RecordType[] rt = [SELECT Id FROM RecordType WHERE Name = 'X1' AND SobjectType = 'Case'];
        
        Case c = new Case();
            if (queueX1.size() > 0){
                c.OwnerID = queueX1[0].Id; 
            }
            if (rt.size() > 0){
                c.RecordTypeID = rt[0].Id;   
            }           
        insert c;
             
        //Assert
        Case[] cList = [SELECT Id, EntitlementID FROM Case WHERE Id = :c.Id ORDER BY CaseNumber];
        System.assertEquals(cList[0].EntitlementID, e.Id);     
    } //testSetCaseEntitlement
    
    
    @isTest static void testCompleteMilestone() {
        //Create Account
        Account a = New Account(Name = 'X1 Team');
        insert a;
        
        //Create Entitlement
        SlaProcess[] lstEntitlementProcess = [SELECT Id, Name FROM SlaProcess 
                                                  WHERE Name='x1 entitlement process' and IsActive = true LIMIT 1];
        Entitlement e = new Entitlement(
            Name = 'X1 Entitlement', 
            AccountID = a.Id, SlaProcessId = lstEntitlementProcess[0].Id);
        insert e;
        
        //Create Case
        Group[] queueX1 = [SELECT Id FROM Group WHERE Name = 'X1 Case Queue' AND Type = 'Queue'];
        RecordType[] rt = [SELECT Id FROM RecordType WHERE Name = 'X1' AND SobjectType = 'Case'];
        
        Case c = new Case();
            if (queueX1.size() > 0){
                c.OwnerID = queueX1[0].Id; 
            }
            if (rt.size() > 0){
                c.RecordTypeID = rt[0].Id;   
            }           
        insert c;
    
        //Update Case Owner
        User[] u = [Select Id From User WHERE UserType = 'Standard' AND IsActive = True AND Profile.Name = 'Guest Services Supervisors'];        
        if (u.size() > 0){
            c.OwnerId = u[0].Id;
            c.Date_of_Visit__c = System.today();
            c.Ticket_Number__c = '2342';
            Update c;
        }    
        
        //Assert
        CaseMilestone[] cMilestone = [SELECT Id, CompletionDate FROM CaseMilestone WHERE CaseId = :c.Id];        
        System.assertNotEquals(cMilestone[0].completionDate, NULL);        
            
    } //testCompleteMilestone */
    
    @isTest static void setContactPhoneNum() {
        
            //create new Case
            List<RecordType> rt = [SELECT Id FROM RecordType WHERE Name != 'X1' AND SobjectType = 'Case'];
            Case c = new Case(
            RecordType = rt[0],
            Date_of_Visit__c = System.today(),
            Phone_Number__c = '8675309');
            insert c;
        
            //create Contact
            Contact con = New Contact(LastName = 'Test');
            insert con;
        
            //update Case ContactID
            c.ContactId = con.Id;
            update c;
        
            //assert
            Contact conAssert = [SELECT Id, Phone FROM Contact WHERE Id = :con.Id];
            System.assertNotEquals(conAssert.Phone, null); 
            
    }//setContactPhoneNum
    
    @isTest static void testRefundFormEmail() {
        
        User u = [SELECT Id FROM User WHERE Profile.name = 'System Administrator' and isActive = TRUE limit 1];
        System.runAs(u) {
            //create new Case
            Case c = new Case();
            c.Subject = 'TestSubject';
            c.Phone_Number__c = '7018675309';
            c.Status = 'Open';
            c.Date_of_Visit__c = System.today();
            c.Ticket_Number__c = '12345';
            insert c;
        
            //create new Refund Form
            Refund_Form__c rf = new Refund_Form__c();
            rf.Associate__c = 'TestAssociate';
            rf.Case__c = c.Id;
            insert rf;
        
            //update Case
            c.Status = 'Closed';
            update c;
        }
    }//testRefundFormEmail
    
    @IsTest
    public static void testCreateContactFromEmailToCase(){
        List<Case> cases=new List<Case>();
        String guestOrlandoRecTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Orld_Guest_Communications_Orlando').getRecordTypeId();
        Case c1=Orld_TestDataFactory.createCase(guestOrlandoRecTypeId);
        c1.OwnerId=Orld_TestDataFactory.getUnassignedQId();
        cases.add(c1);
        
        Case c2=Orld_TestDataFactory.createCase(guestOrlandoRecTypeId);
        c2.SuppliedName=null;
        c2.OwnerId=Orld_TestDataFactory.getUnassignedQId();
        c2.Description='Case Description Test';
        cases.add(c2);
        
        Case c3=Orld_TestDataFactory.createCase(guestOrlandoRecTypeId);
        c3.SuppliedName='LastnameTest';
        c3.OwnerId=Orld_TestDataFactory.getUnassignedQId();
        cases.add(c3);
        
        INSERT cases;
    }
    
    @IsTest
    public static void testcreateContactFromCase(){
    	String guestServicesRecTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guest_Services').getRecordTypeId();
       	Contact con=Orld_TestDataFactory.createContact(guestServicesRecTypeId);
        con.Email='FNameTest1.LNameTest1@test.test';
        INSERT con;
	        
        Case c=Orld_TestDataFactory.createCase(TestScheduledCreateContactFromCase.caseRecTypeId);
        c.First_Name__c='FNameTest';
        c.Last_Name__c='LNameTest';
        INSERT c;
        
        Case c1=Orld_TestDataFactory.createCase(TestScheduledCreateContactFromCase.caseRecTypeId);
        c1.First_Name__c='FNameTest1';
        c1.Last_Name__c='LNameTest1';
        c1.SuppliedEmail='FNameTest1.LNameTest1@test.test';
        
        INSERT c1;
        
    }
}