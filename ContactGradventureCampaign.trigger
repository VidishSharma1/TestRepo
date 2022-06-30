/**
  @Author       : Persistent Systems Ltd.
  @Date         : 3/22/2012
  @Description  : Trigger to insert Contact to Gradventure Campaign Team.
*/

trigger ContactGradventureCampaign on Contact (after insert, before insert,after update) {
        
    if(Trigger.isUpdate && trigger.isAfter)
    {
         List<Contact> cOld=trigger.new;
         List<Contact> cNew=trigger.old;
            System.debug('-------------Enter to After Update Trigger-------');
            System.debug('-------------Enter to loop of old Trigger-------'+cOld);
            System.debug('-------------Enter to loop of New Trigger-------'+cNew);
            for(Integer i=0;i<cOld.size();i++)
            {       
                System.debug('-------------Enter to loop of old Trigger-------'+cOld.size());
                System.debug('-------------Enter to loop of old Trigger-------'+cOld[i].id+'-------------Enter to loop of New Trigger-------'+cNew[i].id);          
                    if(cOld[i].Email != cNew[i].Email)
                    {
                        System.debug('-------------Enter to loop of old Trigger-------'+cOld[i].id+'-------------Enter to loop of New Trigger-------'+cNew[i].id);
                            System.debug('-------------Enter to loop of old Trigger Email-------'+cOld[i].email+'-------------Enter to loop of New Trigger Email-------'+cNew[i].email);
                            for(specialEvent__c s:[select id,Event_Contact_Email__c from SpecialEvent__c where Event_Contact__c =: cNew[i].Id])
                            {
                                System.debug('-------------Enter to Special Event Email-------'+s.Event_Contact_Email__c);
                                s.Event_Contact_Email__c=cNew[i].Email;
                                update s;
                                System.debug('-------------Enter to Special Event Email-------'+s.Event_Contact_Email__c);
                            }
                            System.debug('-------------New Trigger Email-------'+cNew[i].Email);    
                    }
            }
        }   
    if(trigger.isInsert)
        {
            List<Campaign> lstCampaign = [select id,name from Campaign where name='Gradventure'];
            Campaign campaign;
            if(lstCampaign != null && lstCampaign.size() > 0){
                campaign = lstCampaign[0];
            }
            
            List<CampaignMember> lstCampaignMember = new List<CampaignMember>();
            
            //Get Youth & Ed view RecordType Id.
            List<RecordType> lstRecordType = [select id from RecordType where SobjectType = 'Contact' AND Name = 'Youth & Ed view'];
            
            for(Contact contact : Trigger.new){
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
            }
            catch(Exception ex){
                String error = ex.getMessage();
                System.debug(error);
            }
        }
}