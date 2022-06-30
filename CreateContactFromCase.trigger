/************************************************************************ 
* Created By      :  Mirketa Software                                   
* Created Date    :  12/05/2016                                           
* Purpose : This trigger is used to create a contact whenever a case is inserted and the email id is not present in any case.
* Related Class Name      : TEST_ContactFromCase                                                    
*************************************************************************/

trigger CreateContactFromCase on Case (before insert) {
    
    
    //only fire when the batch size is one. Should only be relevant when a case is created from the website
    if (trigger.new.size() == 1) {
        //process the created lead
        for (Case createdCase : Trigger.New) {
            //variable to hold the New Account Id
            Id newAccountId;
            //if an email is given, process the Contact info
            if(createdCase.SuppliedEmail!=null) {
                //look for a Contact that matches the email address
                Contact[] contactsMatched = [Select Id,AccountId,email from Contact where email =:createdCase.SuppliedEmail LIMIT 1];
                System.debug('********'+contactsMatched.size());
                //if we found a match, use it
                if (contactsMatched.size()>0) {
                    createdCase.ContactId = contactsMatched[0].Id;
                    
                } 
                else {
                    
                    //create the contact
                    Contact theContact = new Contact();
                    theContact.FirstName = createdCase.First_Name__c;                
                    theContact.LastName = createdCase.Last_Name__c;
                    theContact.Email = createdCase.SuppliedEmail;
                    theContact.Phone = createdCase.SuppliedPhone;
                    database.insert(theContact, false);
                    
                    //set the contact Id on the case
                    createdCase.ContactId = theContact.Id;                      
                }           
            }       
        }       
    }
    
}