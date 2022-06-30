/*
 *Description: Test class for Orld_CaseCommentController class 
*/
@isTest
public class orld_CaseCommentControllerTest {

    @isTest
    public static void testMethod1(){
        QuickText qt =  new QuickText();
        qt.Name = 'Test Quick';
        qt.Message = 'Test Message';
        qt.Category = 'Greetings';
        qt.Channel = 'Email';
        qt.IsInsertable = True;
        Insert qt;
        
        Case cs = new Case();
        cs.Status = 'Open';
        cs.Subject = 'Test';
        insert cs;
        
        Test.startTest();
        orld_CaseCommentController.getQuickText();
        orld_CaseCommentController.getQuickMessage(qt.id);
        orld_CaseCommentController.postComment(cs.Id, '<strong><em><strike>Test <br>Comment</strike></em></strong>');
        Test.stopTest();
    }
}