@IsTest
public class CaseClassificationServiceTest {

    @IsTest
    static void testClassifyCase_NullDescription() {
        CaseClassificationService.Prediction result = CaseClassificationService.classifyCase(null);

        System.assertEquals('General', result.category, 'Null description should return General category');
        System.assertEquals(0.50, result.confidence, 'Null description should return 0.50 confidence');
    }

    @IsTest
    static void testClassifyCase_Billing() {
        String descr = 'Customer has a payment issue';
        CaseClassificationService.Prediction result = CaseClassificationService.classifyCase(descr);

        System.assertEquals('Billing', result.category, 'Description with "payment" should return Billing');
        System.assertEquals(0.92, result.confidence, 'Confidence should be 0.92 for payment-related case');
    }

    @IsTest
    static void testClassifyCase_Technical() {
        List<String> techDescriptions = new List<String>{
            'There is an error on login',
            'Found a bug in the system',
            'Customer reported an issue with account'
        };

        for(String descr : techDescriptions) {
            CaseClassificationService.Prediction result = CaseClassificationService.classifyCase(descr);
            System.assertEquals('Technical', result.category, 'Description should return Technical');
            System.assertEquals(0.87, result.confidence, 'Confidence should be 0.87 for technical cases');
        }
    }

    @IsTest
    static void testClassifyCase_General() {
        String descr = 'Customer wants information about product';
        CaseClassificationService.Prediction result = CaseClassificationService.classifyCase(descr);

        System.assertEquals('General', result.category, 'Unmatched description should return General');
        System.assertEquals(0.75, result.confidence, 'Confidence should be 0.75 for general cases');
    }
}