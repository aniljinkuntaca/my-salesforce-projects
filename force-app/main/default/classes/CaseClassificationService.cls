public with sharing class CaseClassificationService {
    public class Prediction {
        @AuraEnabled public String category;
        @AuraEnabled public Decimal confidence;
    }

    public static Prediction classifyCase(String caseDescription) {
        Prediction p = new Prediction();
        if(caseDescription == null) {
            p.category = 'General';
            p.confidence = 0.50;
            return p;
        }

        if(caseDescription.containsIgnoreCase('payment')) {
            p.category = 'Billing';
            p.confidence = 0.92;
        } else if(caseDescription.containsIgnoreCase('error') 
               || caseDescription.containsIgnoreCase('bug') 
               || caseDescription.containsIgnoreCase('issue')) {
            p.category = 'Technical';
            p.confidence = 0.87;
        } else {
            p.category = 'General';
            p.confidence = 0.75;
        }
        return p;
    }
}