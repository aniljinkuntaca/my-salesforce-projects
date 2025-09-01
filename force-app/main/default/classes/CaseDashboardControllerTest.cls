@IsTest
public class CaseDashboardControllerTest {

    @TestSetup
    static void setup() {
        List<Case> caseList = new List<Case>();
        for(Integer i = 1; i <= 5; i++) {
            caseList.add(new Case(
                Subject = 'Test Case ' + i,
                Status = 'New',
                Priority = 'Medium',
                Predicted_Category__c = 'Billing',
                AI_Confidence__c = 75,
                Flagged__c = false
            ));
        }
        insert caseList;
    }

    @IsTest
    static void testGetCases() {
        Test.startTest();
        List<CaseDashboardController.CaseWrapper> wrappers = CaseDashboardController.getCases();
        Test.stopTest();

        System.assertEquals(5, wrappers.size(), 'Should return 5 case wrappers');
        for(CaseDashboardController.CaseWrapper w : wrappers) {
            System.assertNotEquals(null, w.CaseNumber, 'CaseNumber should not be null');
            System.assertNotEquals(null, w.CaseURL, 'CaseURL should not be null');
        }
    }
}