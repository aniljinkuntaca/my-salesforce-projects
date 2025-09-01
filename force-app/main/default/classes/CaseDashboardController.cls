public with sharing class CaseDashboardController {

    @AuraEnabled(cacheable=true)
    public static List<CaseWrapper> getCases() {
        List<CaseWrapper> wrapperList = new List<CaseWrapper>();
        
        List<Case> caseList = [
            SELECT Id, CaseNumber, Subject, Predicted_Category__c, AI_Confidence__c, Flagged__c, Description, Priority, Status
            FROM Case
            ORDER BY CreatedDate DESC
            LIMIT 200
        ];
        
        for(Case c : caseList) {
            system.debug(c.AI_Confidence__c);
            String rowClass = 'slds-text-color_default';
            if(c.AI_Confidence__c<40) rowClass = 'slds-text-color_error';
            else if(c.AI_Confidence__c < 50) rowClass = 'slds-text-color_error';
            else if(c.AI_Confidence__c < 80) rowClass = 'slds-text-color_destructive';
            else rowClass = 'slds-text-color_success';
            
            String icon = 'utility:question';
            if(c.Predicted_Category__c == 'Billing') icon = 'standard:currency';
            else if(c.Predicted_Category__c == 'Technical') icon = 'standard:case';
            else if(c.Predicted_Category__c == 'General') icon = 'standard:account';
            else if(c.Predicted_Category__c == 'Other') icon = 'standard:task';

            wrapperList.add(new CaseWrapper(
                c.Id,
                c.CaseNumber,
                c.Subject,
                c.Predicted_Category__c,
                c.AI_Confidence__c,
                '/' + c.Id,
                rowClass,
                c.Flagged__c,
                icon,
                c.Description,
                c.Priority,
                c.Status
            ));
        }
        return wrapperList;
    }

    public class CaseWrapper {
        @AuraEnabled public Id Id;
        @AuraEnabled public String CaseNumber;
        @AuraEnabled public String Subject;
        @AuraEnabled public String Predicted_Category;
        @AuraEnabled public Decimal AI_Confidence;
        @AuraEnabled public String CaseURL;
        @AuraEnabled public String rowClass;
        @AuraEnabled public Boolean Flagged;
        @AuraEnabled public String categoryIcon;
        @AuraEnabled public String Description;
        @AuraEnabled public String Priority;
        @AuraEnabled public String Status;

        public CaseWrapper(Id Id, String CaseNumber, String Subject, String Predicted_Category,
                           Decimal AI_Confidence, String CaseURL, String rowClass, Boolean Flagged,
                           String categoryIcon, String Description, String Priority, String Status){
            this.Id = Id;
            this.CaseNumber = CaseNumber;
            this.Subject = Subject;
            this.Predicted_Category = Predicted_Category;
            this.AI_Confidence = AI_Confidence;
            this.CaseURL = CaseURL;
            this.rowClass = rowClass;
            this.Flagged = Flagged;
            this.categoryIcon = categoryIcon;
            this.Description = Description;
            this.Priority = Priority;
            this.Status = Status;
        }
    }
}