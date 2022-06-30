/*
*Author: Mirketa
*Date: 23-03-2022 
*Description: Trigger Handler for Orld_ContactTrigger  
*/
public class Orld_ContactTriggerHandler {
    public static String conRecTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guest_Services').getRecordTypeId();
    public static Integer counter;
    /*
*Description: Method to create Guest Services account for a Guest Services Contact 
*/
    public static void creatGuestServicesAccount(List<Contact> newContacts){
        Counter=0;
        Map<Integer,Account> accMap=new Map<Integer,Account>();
        Map<Integer,Contact> contMap=new Map<Integer,Contact>();
        
        String accRecTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Guest_Services').getRecordTypeId();
        
        for(Contact con:newContacts){
            if(con.RecordTypeId==conRecTypeId){
                Account guesServicesAcct=new Account(RecordTypeId=accRecTypeId,Name=con.FirstName+' '+con.LastName,Account_email__c=con.Email);
                accMap.put(Counter,guesServicesAcct);
                contMap.put(Counter, con);
                Counter++;
            }
        }
        
        if(!accMap.isEmpty()){
            INSERT accMap.values();
        }
        
        for(Integer key:accMap.keySet()){
            contMap.get(key).AccountId=accMap.get(key).Id;
        }
    }
    
    /*
*Description: Method to update Guest Services Account whenever Contact data is updated
*/
    public static void updateGuestServicesAccount(List<Contact> newContacts,Map<Id,Contact> oldConMap){
        Set<Account> accountToUpdateList=new Set<Account>();
        for(Contact con:newContacts){
            if(con.RecordTypeId==conRecTypeId && (con.FirstName!=oldConMap.get(con.Id).FirstName || Con.LastName!=oldConMap.get(con.Id).LastName || Con.Email!=oldConMap.get(con.Id).Email)){
                String fName = '';
                if(con.FirstName != null){
                    fName = con.FirstName;
                }
                if(con.AccountId != null){
                Account acctToUpdate=new Account(Id=con.AccountId,Name=fName+' '+Con.LastName,Account_email__c=Con.Email);
                accountToUpdateList.add(acctToUpdate);
                }
            }
        }
        
        if(!accountToUpdateList.isEmpty()){
            Update new List<Account>(accountToUpdateList);
        }
        
    }
    
    public static void deleteGuestServicesAccount(List<Contact> oldContacts){
        Map<Id,Account> acctMap=new  Map<Id,Account>();
        
        for(Contact con:oldContacts){
            if(con.RecordTypeId==conRecTypeId && con.AccountId!=null){
                acctMap.put(con.AccountId, new Account(Id=con.AccountId));
            }
        }
        
        if(!acctMap.isEmpty()){
            Delete  acctMap.values();
        }
    }
    
    /*
*Description: Existing code from ContactGradventure migrated to Handler as part of Code Refactoring
*/
    public static void updateSpecialEvents(Map<Id,Contact> oldConMap,Map<Id,Contact> newConMap){
        Set<Id> conIds=new Set<Id>();
        for(Contact newCon:newConMap.values())
        {		
            if(oldConMap.get(newCon.Id).Email != newCon.Email){
                conIds.add(newCon.Id);
            }
        }
        
        if(!conIds.isEmpty()){
            List<SpecialEvent__c> specialEvts=[select id,Event_Contact_Email__c,Event_Contact__c from SpecialEvent__c where Event_Contact__c IN :conIds];
            for(SpecialEvent__c specialEvt:specialEvts){
                specialEvt.Event_Contact_Email__c=newConMap.get(specialEvt.Event_Contact__c).Email;
            }
            
            if(!specialEvts.isEmpty()){
                Update specialEvts;
            }
        }
    }
    
    /*
*Description: Existing code from ContactGradventure migrated to Handler as part of Code Refactoring
*/
    public static void insertCampaignTeamMember(List<Contact> newContacts){
        List<CampaignMember> lstCampaignMember = new List<CampaignMember>();
        List<Campaign> lstCampaign = [select id,name from Campaign where name='Gradventure'];
        Campaign campaign;
        
        if(lstCampaign != null && lstCampaign.size() > 0){
            campaign = lstCampaign[0];
            //Get Youth & Ed view RecordType Id.
            List<RecordType> lstRecordType = [select id from RecordType where SobjectType = 'Contact' AND Name = 'Youth & Ed view'];
            
            for(Contact contact : newContacts){
                String accountCampaign = contact.AccountCampaign__c;
                
                if(accountCampaign != null && accountCampaign == 'Gradventure'){
                    CampaignMember campMember = new CampaignMember();
                    campMember.campaignId = campaign.id;
                    campMember.contactId = contact.id;
                    
                    lstCampaignMember.add(campMember);
                    System.debug('Added To list : ');
                    
                    if(Trigger.isBefore){
                        if(lstRecordType!=null && lstRecordType.size()>0){
                            contact.RecordTypeId = lstRecordType[0].id;
                        }
                    }
                }
            }
            try{
                if(lstCampaignMember.size()>0){
                    insert lstCampaignMember;
                    System.debug('Contact inserted to campaign team');
                }
            }catch(Exception ex){
                String error = ex.getMessage();
                System.debug(error);
            }
        }
    }
    
}