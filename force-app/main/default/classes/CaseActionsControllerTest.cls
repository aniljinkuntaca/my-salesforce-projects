@IsTest
public class CaseActionsControllerTest {

    @TestSetup
    static void setup() {
        List<Case> caseList = new List<Case>();
        for(Integer i = 1; i <= 3; i++) {
            caseList.add(new Case(
                Subject = 'Action Test Case ' + i,
                Status = 'New',
                Priority = 'Medium',
                Predicted_Category__c = 'Technical',
                AI_Confidence__c = 60,
                Flagged__c = false
            ));
        }
        insert caseList;
    }

    @IsTest
    static void testReclassifyCase() {
        Case c = [SELECT Id, Predicted_Category__c FROM Case LIMIT 1];
        Test.startTest();
        CaseDashboardController.CaseWrapper updated = CaseActionsController.reclassifyCase(c.Id);
        Test.stopTest();

        System.assertNotEquals(c.Predicted_Category__c, updated.Predicted_Category, 'Category should be changed');
        System.assertNotEquals(null, updated.CategoryIcon, 'Category icon should be set');
    }

    @IsTest
    static void testFlagCase() {
        Case c = [SELECT Id, Flagged__c FROM Case LIMIT 1];
        System.assertEquals(false, c.Flagged__c, 'Initially not flagged');

        Test.startTest();
        Case updated = CaseActionsController.flagCase(c.Id);
        Test.stopTest();

        System.assertEquals(true, updated.Flagged__c, 'Case should be flagged');
    }

    @IsTest
    static void testUpdateCategory() {
        Case c = [SELECT Id, Predicted_Category__c FROM Case LIMIT 1];
        String oldCategory = c.Predicted_Category__c;
        String newCategory = 'Billing';

        Test.startTest();
        Case updated = CaseActionsController.updateCategory(c.Id, newCategory);
        Test.stopTest();

        System.assertEquals(newCategory, updated.Predicted_Category__c, 'Category should be updated');
        System.assertNotEquals(oldCategory, updated.Predicted_Category__c, 'Category should change from old value');
    }
}