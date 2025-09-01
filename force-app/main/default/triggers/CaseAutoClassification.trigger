trigger CaseAutoClassification on Case (before insert) {
    for(Case c : Trigger.new) {
        if(String.isNotBlank(c.Description)) {
            CaseClassificationService.Prediction p = 
            CaseClassificationService.classifyCase(c.Description);
            c.Predicted_Category__c = p.category;
            c.AI_Confidence__c = p.confidence * 100;
        }
    }
}