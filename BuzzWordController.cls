/*
 * Description: Apex class for BuzzWord Lightning component
 * */
public class BuzzWordController {
    
    public List<Orld_Buzzword__c> buzzList {get;set;}
    public List<Orld_Buzzword_distribution__c> buzzDislst {get;set;}
    public BuzzWordController(){
        this.buzzList = new List<Orld_Buzzword__c>();
        this.buzzDislst = new List<Orld_Buzzword_distribution__c>();
    }
    
    /*
     * Description: Method to pull all active Buzzword from Buzzword object
	*/
    @AuraEnabled(cacheable=true)
    public static list<Orld_Buzzword__c> getBuzzword(){
        system.debug('Inside Buzzword');
        List<Orld_Buzzword__c> lst = new List<Orld_Buzzword__c>([SELECT Id, Name FROM Orld_Buzzword__c Where Orld_Active__c = true]);
        system.debug('lst '+lst);
        return lst;
    }
    
    /*
     * Description: Method to update Send Email flag on case when send email is checked
	*/
    @AuraEnabled
    public static void changeSendEmail(String caseId,Boolean sendEmailFlag){
        system.debug('Inside Buzzword changeSendEmail'+caseId);
         List<Case> cases=new List<Case>([Select id,Orld_Send_Buzzword_Emails__c from case where id =: caseId]);
         Cases[0].Orld_Send_Buzzword_Emails__c = sendEmailFlag;
         Update cases;
    }
    
    /*
     * Description: Method to check if the current user is Manager or System Admin
	*/
    @AuraEnabled
    public static Boolean isManagerOrAdminUser(){
        List<String> allowedRoles=System.Label.Orld_Buzzword_Modification_Roles.split(',');
        List<UserRole> userRoles=[SELECT Name, Id, DeveloperName FROM UserRole WHERE DeveloperName IN :allowedRoles and Id=:UserInfo.getUserRoleId() ];
        Map<Id,Profile> sysAdmUser=new Map<Id,Profile>([SELECT Id, Name FROM Profile WHERE Name='System Administrator']);

        if(!userRoles.isEmpty() || sysAdmUser.get(UserInfo.getProfileId())!=null){
            return true;
        }
        return false;
    }

    /*
     * Description: Method to get last selected buzzword from case
	*/
    @AuraEnabled
    public static Map<String,String> lastSelectedBuzzword(String caseId){
        Map<String,String> resultMap=new Map<String,String>();
        List<String> allowedRoles=System.Label.Orld_Buzzword_Modification_Roles.split(',');
        List<UserRole> userRoles=[SELECT Name, Id, DeveloperName FROM UserRole WHERE DeveloperName IN :allowedRoles and Id=:UserInfo.getUserRoleId() ];
        List<Case> cases=[Select id,Orld_Buzzword__c,Orld_Send_Buzzword_Emails__c from case where id =: caseId];
        Map<Id,Profile> sysAdmUser=new Map<Id,Profile>([SELECT Id, Name FROM Profile WHERE Name='System Administrator']);

        if(isManagerOrAdminUser()){
            resultMap.put('AllowBuzzwordChange','Yes');
        }

        if(!cases.isEmpty() && cases[0].Orld_Buzzword__c!=null){
            resultMap.put('SelectedBuzzword',cases[0].Orld_Buzzword__c);
        }
        if(!cases.isEmpty() && cases[0].Orld_Send_Buzzword_Emails__c){
            resultMap.put('SendEmail','Yes');
        }
        //system.debug('pick Value '+caseId);
        return resultMap;
    }

    /*
     * Description: Method to get medical forms that are not yet completed
	*/
    @AuraEnabled
    public static Integer getMedicalForms(String caseId){
        List<Orld_Medical_Form__c> medicalForms=[SELECT Id, Orld_Case__c, Orld_Form_Details_Completed__c FROM Orld_Medical_Form__c WHERE Orld_Case__c=:caseId and Orld_Form_Details_Completed__c=false];
        if(!medicalForms.isEmpty()){
            return 1;
        }
        return 0;
    }
    
    /*
     * Description: Method to get distribution list related to the buzzword
	*/
    @AuraEnabled
    public static void getDistributionList(string picklistVal,String caseId){
        system.debug('pick Value '+picklistVal);
        if(picklistVal != ''){
            String buzzName = [Select Id,Name from Orld_Buzzword__c where id =:picklistVal limit 1].Name;
            system.debug('after query'+buzzName);
            List<Orld_Buzzword_distribution__c> buzzlst = new List<Orld_Buzzword_distribution__c>([SELECT Id, Name, Orld_Email__c FROM Orld_Buzzword_distribution__c WHERE Orld_Active__c = true AND Orld_Buzzword__c = :picklistVal ]);
            system.debug('caseId '+caseId);
            Case cs = [Select id,createddate,Orld_Buzzword__c,subject,origin, Description,Contact.Name,contact.email,contact.MailingAddress,contact.phone,contact.orld_Social_Media_Handle_ID__c from case where id=: caseId limit 1];
            case c = new case();
            c.id= caseId;
            c.Orld_Buzzword__c = buzzName;
            update c;
        }else if(picklistVal==''){
            case c = new case();
            c.id= caseId;
            c.Orld_Buzzword__c = null;
            update c;
        }
        //UpdateCase(picklistVal, String.valueof(caseId));
        //if(caseUrl!= '' && caseUrl != null){
        
        
        
        // }
        /*
List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

// String theTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Purchase_Order_With_Items'].Id;
//  User theUser = [SELECT Id FROM User WHERE Name = 'user name goes here'];
List<String> toAddress = new List<String>();
String NA = 'Not Available';
String Subject = 'Guest Interaction Alert - '+buzzName;
String emailbody = 'Hi, </br></br>';
emailbody += 'This is an executive alert for '+buzzName+' sent by Guest Communication Team , Orlando.</br></br>';
emailbody += 'Date/Time : '+cs.CreatedDate+'</br></br>';
emailbody += '<b>Guest Contact Detail:</b> </br>';
if(cs.contact.Name != null){
emailbody += 'Name: '+cs.contact.Name +'</br>';
}
else{
emailbody += 'Name: '+NA +'</br>';   
}
if(cs.contact.email != null){
emailbody += 'Email: '+cs.contact.email +'</br>';
}
else{
emailbody += 'Email: '+NA +'</br>';   
}
if(cs.contact.MailingAddress != null){
emailbody += 'Address: '+cs.contact.MailingAddress.getCountry() ;

}
else{
emailbody += 'Address: '+NA +'</br>';   
}
if(cs.contact.Phone != null){
emailbody += '</br>Phone: '+cs.contact.Phone +'</br>';
}
else{
emailbody += '</br>Phone: '+NA +'</br>';   
}
if(cs.contact.orld_Social_Media_Handle_ID__c != null){
emailbody += 'Social Media Tag: '+cs.contact.orld_Social_Media_Handle_ID__c +'</br>';
}
else{
emailbody += 'Social Media Tag: '+NA +'</br>';   
}

emailbody += '<b></br>Case Details: </br></b>';

if(cs.origin != null){
emailbody += 'Case Origin: '+cs.origin +'</br>';
}
else{
emailbody += 'Case Origin: '+NA +'</br>';   
}
if(cs.subject != null){
emailbody += 'Case Subject: '+cs.subject +'</br>';
}
else{
emailbody += 'Case Subject: '+NA +'</br>';   
}
if(cs.Description != null){
emailbody += 'Case Description: '+cs.Description +'</br>';
}
else{
emailbody += 'Case Description: '+NA +'</br>';   
}
if(cs.Description != null){
emailbody += 'Case Description: '+cs.Description +'</br>';
}
else{
emailbody += 'Case Description: '+NA +'</br>';   
}

emailbody += '</br> Regards,</br>';
emailbody += 'Management Team </br>';
emailbody += 'Orlando Guest Communications </br>';

for(Buzzword_distribution__c bz : buzzlst){
if(bz.Orld_Email__c != null ){
if(bz.Orld_Email__c.contains(';')){
toAddress = bz.orld_email__c.split(';');
}
else{
toAddress.add(bz.Orld_Email__c);    
}
}
}
system.debug('Toaddress Before '+toAddress);
List<String> finalToaddress = new List<String>();
for(String checkEmail : toAddress){
system.debug('checkEmail '+checkEmail);
checkEmail = checkEmail.trim();
if(validateEmail(checkEmail)){
finalToaddress.add(checkEmail);
}
}
system.debug('Final toAddress '+finalToaddress);
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

mail.setSaveAsActivity(false);
mail.setHtmlBody(emailbody);
mail.setSubject(Subject);
// mail.setTemplateId(theTemplate);
// mail.setWhatId(poId);
//  mail.setTargetObjectId(theUser.Id);
if(toAddress.size()>0){
mail.setToAddresses(finalToaddress);  //add other emails here.
}    
else{
mail.setToAddresses(new String[] { 'vidish@mirketa.com'});  //add other emails here.  
}
emails.add(mail);

Messaging.sendEmail(emails);      
return buzzlst;
}
else {
return null;
}
*/
    }
    
    /*
     * Description: Method to prepare and send Executive email alert on case submit
	*/
    @AuraEnabled
    public static String sendAlertToDL(String caseId){
        FeedItem fItem = new FeedItem();
        
        
        try{
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            List<Case> cases=[Select Id,Orld_Send_Buzzword_Emails__c,contact.Name,contact.orld_Social_Media_Handle_ID__c,Origin,Subject,Description,contact.Phone,contact.MailingAddress,contact.email,CreatedDate,Orld_Buzzword__c FROM Case WHERE Id=:caseId];
            if(!cases.isEmpty() && cases[0].Orld_Buzzword__c!=null){
                Case cs=cases[0];
                fItem.ParentID = cs.Id;
                List<Orld_Buzzword__c> buzzwords=[select Id,Name,Orld_Buzzword_Description__c From Orld_Buzzword__c WHERE Name=:cs.Orld_Buzzword__c];
                
                
                List<Orld_Buzzword_distribution__c> buzzlst = new List<Orld_Buzzword_distribution__c>([SELECT Id, Name, Orld_Email__c FROM Orld_Buzzword_distribution__c WHERE Orld_Active__c = true AND Orld_Buzzword__c = :buzzwords[0].Id ]);
                fItem.Body=buzzwords[0].Name+' Buzzword Alert Sent'; 
				if(!buzzlst.isEmpty()){
                    List<String> toAddress = new List<String>();
                    String NA = 'Not Available';
                    String Subject = 'Guest Interaction Alert - '+cs.Orld_Buzzword__c;
                    String emailBody=CustomTemplateController.prepareData(caseId,buzzwords[0]);
                    if(emailBody==null || emailBody==''){
                        return 'Email Template not configured for buzzword';
                    }
                    /*
                    String emailbody = 'Hi, </br></br>';
                    emailbody += 'This is an executive alert for '+cs.Buzzword__c+' sent by Guest Communication Team , Orlando.</br></br>';
                    emailbody += 'Date/Time : '+cs.CreatedDate+'</br></br>';
                    emailbody += '<b>Guest Contact Detail:</b> </br>';
                    if(cs.contact.Name != null){
                        emailbody += 'Name: '+cs.contact.Name +'</br>';
                    }else{
                        emailbody += 'Name: '+NA +'</br>';   
                    }
                    if(cs.contact.email != null){
                        emailbody += 'Email: '+cs.contact.email +'</br>';
                    }else{
                        emailbody += 'Email: '+NA +'</br>';   
                    }
                    if(cs.contact.MailingAddress != null){
                        emailbody += 'Address: '+cs.contact.MailingAddress.getCountry() ;
                        
                    }else{
                        emailbody += 'Address: '+NA +'</br>';   
                    }
                    if(cs.contact.Phone != null){
                        emailbody += '</br>Phone: '+cs.contact.Phone +'</br>';
                    }else{
                        emailbody += '</br>Phone: '+NA +'</br>';   
                    }
                    if(cs.contact.orld_Social_Media_Handle_ID__c != null){
                        emailbody += 'Social Media Tag: '+cs.contact.orld_Social_Media_Handle_ID__c +'</br>';
                    }else{
                        emailbody += 'Social Media Tag: '+NA +'</br>';   
                    }
                    
                    emailbody += '<b></br>Case Details: </br></b>';
                    
                    if(cs.origin != null){
                        emailbody += 'Case Origin: '+cs.origin +'</br>';
                    }else{
                        emailbody += 'Case Origin: '+NA +'</br>';   
                    }
                    if(cs.subject != null){
                        emailbody += 'Case Subject: '+cs.subject +'</br>';
                    }else{
                        emailbody += 'Case Subject: '+NA +'</br>';   
                    }
                    if(cs.Description != null){
                        emailbody += 'Case Description: '+cs.Description +'</br>';
                    }else{
                        emailbody += 'Case Description: '+NA +'</br>';   
                    }
                    if(cs.Description != null){
                        emailbody += 'Case Description: '+cs.Description +'</br>';
                    }else{
                        emailbody += 'Case Description: '+NA +'</br>';   
                    }
                    
                    emailbody += '</br> Regards,</br>';
                    emailbody += 'Management Team </br>';
                    emailbody += 'Orlando Guest Communications </br>';
                    */
                    for(Orld_Buzzword_distribution__c bz : buzzlst){
                        if(bz.Orld_Email__c != null ){
                            if(bz.Orld_Email__c.contains(';')){
                                toAddress = bz.orld_email__c.split(';');
                            }
                            else{
                                toAddress.add(bz.Orld_Email__c);    
                            }
                        }
                    }
                    system.debug('Toaddress Before '+toAddress);
                    List<String> finalToaddress = new List<String>();
                    for(String checkEmail : toAddress){
                        system.debug('checkEmail '+checkEmail);
                        checkEmail = checkEmail.trim();
                        if(validateEmail(checkEmail)){
                            finalToaddress.add(checkEmail);
                        }
                    }
                    system.debug('Final toAddress '+finalToaddress);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    if(!Test.isRunningTest()){
                    String emailAddress=System.Label.Orld_Buzzword_From_Email;
                    List<OrgWideEmailAddress> owas=[select Id,Address from OrgWideEmailAddress WHERE Address=:emailAddress];
                    
                    mail.orgwideemailaddressid=owas[0].Id;
                    }
                    mail.setSaveAsActivity(false);
                    mail.setHtmlBody(emailbody);
                    mail.setSubject(Subject);
                    
                    if(toAddress.size()>0){
                        mail.setToAddresses(finalToaddress);  //add other emails here.
                    }    
                    
                    if(!finalToaddress.isEmpty()){
                         emails.add(mail);
                        if(cs.Orld_Send_Buzzword_Emails__c){
                         Messaging.sendEmail(emails);  
                            system.debug('Emails Sent');
                         cs.Orld_Send_Buzzword_Emails__c = false;
                         Update cs;
                            Insert fItem;
                            return 'success';
                        }
                    }
                   
                }
            }
            return null;
        }catch(Exception e){
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    
    /*
     * Description: Method validate entered email address format
	*/
    public static Boolean validateEmail(String email) {
        Boolean res = true;
        
        
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: http://www.regular-expressions.info/email.html
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        
        if (!MyMatcher.matches()) 
            res = false;
        return res;	
    }
    
    /* public static void UpdateCase(String buzzName, String caseId){
case c = new case();
c.id= caseId;
c.Buzzword__c = buzzName;
// update c;

} */
    
    
}