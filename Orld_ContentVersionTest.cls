@isTest
public class Orld_ContentVersionTest {

    @isTest 
    public static void TestMethod1(){
        /**
    Integer i = 0;
    i++;
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    UserRole role = [SELECT Id, Name FROM UserRole where Name='Guest Services Coordinator Orlando'];
      User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com',
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com'+i,UserRoleId = role.id);

      System.runAs(u2) {
         // The following code runs as user u2.
         System.debug('Current User: ' + UserInfo.getUserName());
         System.debug('Current Profile: ' + UserInfo.getProfileId());

    
        **/
        
    orld_res_file_type__c ftype = new orld_res_file_type__c();
    ftype.Name = 'File to Restrict';
    ftype.File_Type__c = '.text,';
    ftype.File_Type2__c = '.jpg,';
    insert ftype;
    
        /**
    Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'); 
            
            ContentVersion contentVersion_1 = new ContentVersion(
                Title='SampleTitle', 
                PathOnClient ='SampleTitle.jpg',
                VersionData = bodyBlob, 
                origin = 'H'
            );
            insert contentVersion_1;

**/
        
        Case cs = new Case();
        cs.status = 'Open';
        cs.subject = 'Test';
        insert cs;
        
        /**
        
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                            FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
            system.debug('case id'+cs.id);
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = cs.id;
            contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
            contentlink.ShareType = 'H';
        
        
        **/
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=cs.id;
        content.origin = 'H';
        insert content; 
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=cs.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        ContentDocument cd = new ContentDocument();
        cd.id = [select contentdocumentid from contentversion where id =: content.id].contentdocumentid;//contentVersion_2.contentdocumentid;
   
        
        
        Test.StartTest();
           // insert contentlink;
       Delete cd;
        Test.stopTest(); 
        
        
    }
  //  }
}