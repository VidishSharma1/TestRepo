public class ScheduledCreateContactFromCase implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    
    public static final String BATCH_JOB_TITLE = 'My Batch Job';
    public static String conRecTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guest_Services').getRecordTypeId();
    @TestVisible String errors = '';
    
    //Query Cases needing Contacts. Case Record Types include: Front Desk, Guest Call Center, and Guest Communications	 
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, First_Name__c, Last_Name__c,SuppliedEmail, Guest_Email__c, Phone_Number__c, Address_1__c, City__c, State__c, Zip_Code__c, Country__c FROM Case WHERE ContactId = NULL AND First_name__c != NULL AND last_name__c != NULL AND (RecordTypeId = \'012E0000000g2l9IAA\' OR RecordTypeId = \'01244000000kMuVAAU\' OR RecordTypeId = \'012E0000000g325IAA\')');
    }
    
    public void execute(Database.BatchableContext bc, List<SObject> scope){
        
        
        if( scope.isEmpty() ) return;
        List<Case> cases = (List<Case>) scope;
        List<Contact> contactsToCreate = new List<Contact>();
        List<Case> caseUpdates = new List<Case>();
        Map<String,Contact> caseIdToContactMap=new Map<String,Contact>();
        Map<String,case> emailAddressMap=new Map<String,case>();
        
        //Loop through the Case List and create new Contacts in buildContactsToCreate()
        try{   
            for( Case aCase : cases ){
                //Contact newContact = buildContactsToCreate(aCase);
                if(aCase.SuppliedEmail!=null){
                    emailAddressMap.put(aCase.SuppliedEmail.toLowerCase(),aCase);
                }
                
                //caseIdToContactMap.put(aCase.Id,buildContactsToCreate(aCase));
                //Set Contact on Case
                //aCase.contactId = newContact.id;
                //caseUpdates.add(aCase);
            }
            List<Contact> contsToUpdate=new List<Contact>();
            List<Contact> contacts=[Select Id,Email,FirstName, LastName,Orld_Extra_Details__c,Orld_Duplicate_Email_Flag__c from Contact WHERE Email IN :emailAddressMap.keySet()];
            
            for(Contact con:contacts){
                
                if(con.Email!=null){
                    String key=con.Email.toLowerCase();
                    if(emailAddressMap.get(key)!=null && emailAddressMap.get(key).First_Name__c.equalsIgnoreCase(con.FirstName) && emailAddressMap.get(key).Last_Name__c.equalsIgnoreCase(con.LastName)){
                        caseUpdates.add(new Case(Id=emailAddressMap.get(key).Id,ContactId=con.Id));
                        emailAddressMap.remove(key);
                    }else if(emailAddressMap.get(key)!=null && (!emailAddressMap.get(key).First_Name__c.equalsIgnoreCase(con.FirstName) || !emailAddressMap.get(key).Last_Name__c.equalsIgnoreCase(con.LastName))){
                        Case currentCase=emailAddressMap.get(key);
                        caseUpdates.add(new Case(Id=emailAddressMap.get(key).Id,ContactId=con.Id));
                        con.Orld_Duplicate_Email_Flag__c=true;
                        if(con.Orld_Extra_Details__c!=null){
                            con.Orld_Extra_Details__c+='\n'+currentCase.First_Name__c+' '+currentCase.Last_Name__c+', '+currentCase.Phone_Number__c;    
                        }else{
                            con.Orld_Extra_Details__c=currentCase.First_Name__c+' '+currentCase.Last_Name__c+', '+currentCase.Phone_Number__c;    
                        }
                        
                        contsToUpdate.add(con);
                        emailAddressMap.remove(con.Email);
                    }
                }
                
            }
            
            if(!contsToUpdate.isEmpty()){
                Database.update(contsToUpdate,false);
            }
            
            for(String key:emailAddressMap.keySet()){
                Case currentCase=emailAddressMap.get(key);
                caseIdToContactMap.put(currentCase.Id,buildContactsToCreate(currentCase));
            }
            
            if(!caseIdToContactMap.isEmpty()){
                Database.SaveResult[] contactSaveResult=Database.insert(caseIdToContactMap.values(),false);
                
                for(Database.SaveResult sr:contactSaveResult){
                    if(!sr.isSuccess()){
                        errors+=sr.getErrors()[0].getMessage();
                        System.debug(sr.getErrors()[0].getMessage());
                    }
                }
            }
            
            for(String key:caseIdToContactMap.keySet()){
                if(caseIdToContactMap.get(key).Id!=null){
                    caseUpdates.add(new Case(Id=key,ContactId=caseIdToContactMap.get(key).Id));
                }
            }
            //Update Cases
            if(!caseUpdates.isEmpty()){
                Database.SaveResult[] caseSaveResult=Database.update(caseUpdates,false);
                
                for(Database.SaveResult sr:caseSaveResult){
                    if(!sr.isSuccess()){
                        errors+=sr.getErrors()[0].getMessage();
                        System.debug(sr.getErrors()[0].getMessage());
                    }
                }
                //update caseUpdates; 
            }
            
            
        }
        catch( Exception ex ){
            this.errors += ex.getMessage();
        }
    }
    
    //Create and Insert new Conacts for the Cases    
    private Contact buildContactsToCreate( Case aCase ){
        Contact contactFoCase = new Contact(
            FirstName=aCase.First_Name__c,
            LastName=aCase.Last_Name__c,
            Phone=aCase.Phone_Number__c,
            MailingStreet=aCase.Address_1__c,
            MailingCity=aCase.City__c,
            MailingState=aCase.State__c,
            MailingPostalCode=aCase.Zip_Code__c,
            MailingCountry=aCase.Country__c,
            RecordTypeId = conRecTypeId, // Guest Services Record Type
            OwnerId = '005E0000005xcMeIAI'); // Tiffany Hamby-Harthcock
        //AccountId = '0014400001j0wr3AAA'); // Guest Services
        Boolean validEmail = BuzzWordController.validateEmail(aCase.SuppliedEmail);
        if(validEmail){
            contactFoCase.Email =  aCase.SuppliedEmail;
        }
        else{
            contactFoCase.Orld_Extra_Details__c = aCase.SuppliedEmail;
        }
        
        //insert contactFoCase;   
        return contactFoCase;
    }
    
    //Send email to notify the job creator of any errors
    public void finish(Database.BatchableContext bc){
        if( this.errors != '' )
        {
            AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                                FROM AsyncApexJob
                                WHERE Id = :bc.getJobId()];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(new String[] {job.CreatedBy.Email});
            mail.setSaveAsActivity( false );
            mail.setSubject(BATCH_JOB_TITLE + job.Status);
            
            String emailBody = BATCH_JOB_TITLE + ' processed ' + job.TotalJobItems + ' batches with '+ job.NumberOfErrors + ' failures.';
            emailBody += '\n\n\nThe following errors occured:\n'+ errors;
            
            mail.setPlainTextBody(emailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    public void execute(SchedulableContext sc)
    {
        ScheduledCreateContactFromCase theBatch = new ScheduledCreateContactFromCase();
        Database.executeBatch(theBatch, 20);
    }
}