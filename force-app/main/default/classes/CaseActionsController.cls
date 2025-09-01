public with sharing class CaseActionsController {

   @AuraEnabled
public static CaseDashboardController.CaseWrapper reclassifyCase(Id caseId) {
    List<String> categories = new List<String>{'Billing', 'Technical', 'General', 'Other'};
    String newCategory = categories[Math.mod(Math.abs(Crypto.getRandomInteger()), categories.size())];

    Case c = [SELECT Id, CaseNumber, Subject, Predicted_Category__c, AI_Confidence__c, Flagged__c FROM Case WHERE Id = :caseId LIMIT 1];
    c.Predicted_Category__c = newCategory;
    update c;

    // Return wrapper
    String icon = 'utility:question';
    if(c.Predicted_Category__c == 'Billing') icon = 'standard:currency';
    else if(c.Predicted_Category__c == 'Technical') icon = 'standard:case';
    else if(c.Predicted_Category__c == 'General') icon = 'standard:account';
    else if(c.Predicted_Category__c == 'Other') icon = 'standard:task';

    return new CaseDashboardController.CaseWrapper(
        c.Id, c.CaseNumber, c.Subject, c.Predicted_Category__c, c.AI_Confidence__c,
        '/' + c.Id, '', c.Flagged__c, icon, '', '', ''
    );
}

    @AuraEnabled
    public static Case flagCase(Id caseId) {
        Case c = [SELECT Id, Flagged__c,Predicted_Category__c,AI_Confidence__c FROM Case WHERE Id = :caseId LIMIT 1];
        c.Flagged__c = true;
        update c;
        return c;
    }

    @AuraEnabled
    public static Case updateCategory(Id caseId, String newCategory) {
        Case c = [SELECT Id, Flagged__c,Predicted_Category__c,AI_Confidence__c FROM Case WHERE Id = :caseId LIMIT 1];
        c.Predicted_Category__c = newCategory;
        update c;
        return c;
    }
}