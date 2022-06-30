public class Orld_NewCaseController {

    private final Case caseRec;
    public String caseId{set;get;}
    public String recTypeId{set;get;}

   public Orld_NewCaseController(ApexPages.StandardSetController stdController)
        
    {
        this.caseRec = (Case)stdController.getRecord();
        system.debug('cont' + this.caseRec);   
        
        List<RecordType> recordTypes=[Select Id from RecordType WHERE DeveloperName='Orld_Guest_Communications_Orlando' and SobjectType='Case' and IsActive=true ];
        recTypeId=recordTypes[0].Id;
    }
    
    /* Method: createCase 
    Return Type: PageReference: redirects to case created
	*/  
    
    public PageReference createCase()
    {
        Map<String, String> pageParams = ApexPages.CurrentPage().getParameters();
        Id contactId = pageParams.get('id');        
        Case caseRecord = new Case();
        caseRecord.ContactId = contactId;
        insert caseRecord;
       
        caseId=caseRecord.Id;
        return null;
         
    } 
    
}