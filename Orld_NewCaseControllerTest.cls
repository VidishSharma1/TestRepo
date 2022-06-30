@isTest
public class Orld_NewCaseControllerTest {

    @isTest static void testAccountOpportunity(){    
         
        Case cs = new Case();
        cs.First_Name__c = 'fname';
        cs.Last_Name__c = 'LName';
        cs.SuppliedEmail = 'vidish@gmail.com';
        cs.Recordtypeid = '012E0000000g2l9IAA';
        insert cs; 
        
        contact con = new contact();
        con.LastName = 'last name';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guest_Services').getRecordTypeId();

        insert con;
      //AccountNew is the Visualforce page created
       PageReference testPage = Page.NewCaseVisualforce; 
       Test.setCurrentPage(testPage);
       testPage.getParameters().put('Id', String.valueOf(con.Id));
       ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, First_Name__c,Last_Name__c,SuppliedEmail,Recordtypeid FROM Case where id=: cs.id]));
	   
            
       Orld_NewCaseController ext = new Orld_NewCaseController(setCon);  
       ext.createCase();
    }
    
}