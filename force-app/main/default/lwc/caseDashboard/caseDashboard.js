import { LightningElement, wire, track } from 'lwc';
import getCases from '@salesforce/apex/CaseDashboardController.getCases';
import reclassifyCase from '@salesforce/apex/CaseActionsController.reclassifyCase';
import flagCase from '@salesforce/apex/CaseActionsController.flagCase';
import updateCategory from '@salesforce/apex/CaseActionsController.updateCategory';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseDashboard extends LightningElement {
    @track cases = [];
    @track filteredCases = [];
    @track pagedCases = [];
    @track sortedBy;
    @track sortedDirection = 'asc';
    @track selectedCategory = '';
    @track confidenceFilter = 0;
    @track searchKeyword = '';
    @track currentPage = 1;
    @track draftValues = [];
    pageSize = 10;
    totalPages = 1;

    categoryOptions = [
        { label: 'All', value: '' },
        { label: 'Billing', value: 'Billing' },
        { label: 'Technical', value: 'Technical' },
        { label: 'General', value: 'General' },
        { label: 'Other', value: 'Other' }
    ];

    columns = [
        { label: 'Case Number', fieldName: 'CaseURL', type: 'url', typeAttributes: { label: { fieldName: 'CaseNumber' }, target: '_blank' } },
        { label: 'Subject', fieldName: 'Subject', sortable: true },
        { label: 'Predicted Category', fieldName: 'Predicted_Category', type: 'text', editable: true,
          cellAttributes: { iconName: { fieldName: 'categoryIcon' }, iconPosition: 'left' }, sortable: true },
        { label: 'AI Confidence %', fieldName: 'AI_Confidence', type: 'number', cellAttributes: { class: { fieldName: 'rowClass' } }, sortable: true },
        { type: 'button', typeAttributes: { label: 'Reclassify', name: 'reclassify', variant: 'brand' } },
        { type: 'button', typeAttributes: { label: 'Flag', name: 'flag', variant: 'destructive' } }
    ];

    @wire(getCases)
    wiredCases({ data }) {
        if(data) {
            this.cases = data;
            this.applyFilters();
        }
    }

    get isPreviousDisabled() {
        return this.currentPage === 1;
    }

    get isNextDisabled() {
        return this.currentPage === this.totalPages || this.totalPages === 0;
    }

    handleCategoryChange(event) { this.selectedCategory = event.detail.value; this.applyFilters(); }
    handleConfidenceChange(event) { this.confidenceFilter = event.detail.value; this.applyFilters(); }
    handleSearch(event) { this.searchKeyword = event.target.value.toLowerCase(); this.applyFilters(); }

    applyFilters() {
        this.filteredCases = this.cases.filter(c =>
            (this.selectedCategory === '' || c.Predicted_Category === this.selectedCategory) &&
            c.AI_Confidence >= this.confidenceFilter &&
            c.Subject.toLowerCase().includes(this.searchKeyword)
        );
        this.currentPage = 1;
        this.totalPages = Math.ceil(this.filteredCases.length / this.pageSize);
        this.updatePagedData();
    }

    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
        let sortedData = [...this.filteredCases];
        sortedData.sort((a,b) => a[fieldName] > b[fieldName] ? 1 : a[fieldName] < b[fieldName] ? -1 : 0);
        if(sortDirection === 'desc') sortedData.reverse();
        this.filteredCases = sortedData;
        this.updatePagedData();
    }

    updatePagedData() {
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        this.pagedCases = this.filteredCases.slice(start, end);
    }

    previousPage() { if(this.currentPage > 1) { this.currentPage--; this.updatePagedData(); } }
    nextPage() { if(this.currentPage < this.totalPages) { this.currentPage++; this.updatePagedData(); } }

    handleRowAction(event) {
        const action = event.detail.action.name;
        const row = event.detail.row;
        if(action === 'reclassify') {
            reclassifyCase({ caseId: row.Id })
                .then(updated => { this.showToast('Success', `Case ${row.CaseNumber} reclassified to ${updated.Predicted_Category}`, 'success'); this.refreshCase(row.Id, updated); })
                .catch(err => this.showToast('Error', err.body.message, 'error'));
        }
        if(action === 'flag') {
            flagCase({ caseId: row.Id })
                .then(updated => { this.showToast('Success', `Case ${row.CaseNumber} flagged`, 'success'); this.refreshCase(row.Id, updated); })
                .catch(err => this.showToast('Error', err.body.message, 'error'));
        }
    }

    handleSave(event) {
         const updatedRows = event.detail.draftValues;
    updatedRows.forEach(row => {
        updateCategory({ caseId: row.Id, newCategory: row.Predicted_Category })
        .then(updated => this.refreshCase(row.Id, updated))
        .catch(err => this.showToast('Error', err.body.message, 'error'));
    });
    this.draftValues = [];
    }

    refreshCase(caseId, updatedCase) {
        this.cases = this.cases.map(c => c.Id === caseId ? {...c, Predicted_Category: updatedCase.Predicted_Category?updatedCase.Predicted_Category:updatedCase.Predicted_Category__c, Flagged: updatedCase.Flagged?updatedCase.Flagged:updatedCase.Flagged__c} : c);
        this.applyFilters();
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }


}