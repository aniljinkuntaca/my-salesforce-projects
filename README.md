# 🚀 My Salesforce Projects Playground  

![Salesforce](https://img.shields.io/badge/Salesforce-00A1E0?style=for-the-badge&logo=salesforce&logoColor=white)  
![Apex](https://img.shields.io/badge/Apex-Developer-blue?style=for-the-badge) 
![LWC](https://img.shields.io/badge/Lightning%20Web%20Components-orange?style=for-the-badge)  
![OmniStudio](https://img.shields.io/badge/OmniStudio-Vlocity-purple?style=for-the-badge)  

---

Hey there 👋  
This repo is my personal collection of Salesforce projects — dashboards, utilities, and apps I built while exploring and preparing for interviews.  

Instead of keeping them scattered, I wanted one place where I can showcase them all.  

---

## 📂 Projects

### 1. AI Case Dashboard
The AI Case Dashboard is a Salesforce Lightning Web Component (LWC) project that simulates how AI can automatically classify and prioritize cases in a Service Cloud environment. It is designed to showcase real-world Salesforce development skills (Apex, LWC, data tables, filtering, and AI-like logic) in a portfolio-ready format.

✨ Key Features

- **Dynamic Case Classification**

   - Uses an Apex service (CaseClassificationService) to classify cases as **Billing**, **Technical**, or **General** based on description text.
   
   - Each classification includes a confidence score to mimic an AI prediction.
   
- **Interactive Case Dashboard (LWC)**

   - **Filters**: Search by subject, filter by category, and apply a minimum confidence % threshold.
   
   - **Sortable & Paginated Table**: Lightning Datatable with server-side sorting and client-side pagination.
   
   - **Inline Editing & Reclassification**: Update priority directly in the table or reclassify cases with one click.
   
   - **Case Flagging**: Flag problematic cases for follow-up.
   
   - **CSV Export**: Download the current filtered case list for reporting or analysis.
     
   - **Clear Filter**: Resets all the filters

👉 [Check the code here](https://github.com/aniljinkuntaca/my-salesforce-projects/tree/ai-case-dashboard)

📸 [Check the Screenshots here](https://github.com/aniljinkuntaca/my-salesforce-projects/blob/ai-case-dashboard/Screenshots.pdf)


### 2. *(coming soon 🚧)* 

---

## 🛠️ Tech I Play With
- Salesforce Apex & Triggers  
- Lightning Web Components (LWC)  
- OmniStudio (OmniScripts, FlexCards, Integration Procedures)  
- SOQL/SOSL & REST/SOAP Integrations  
- Salesforce DX for source-driven dev  

---

## ⚡ How to Try It Out
1. Clone this repo  
2. Jump into a project folder (example: `cd ai-case-dashboard`)  
3. Authorize your Salesforce org:  
   ```sh
   sfdx auth:web:login -a myOrg
4. Push the code:
   ```sh
   sfdx force:source:push -u myOrg
5.Assign any needed permission sets and you’re good to go 🚀

✨ Why This Repo?
I wanted to keep my hands dirty with Salesforce and also have a neat portfolio of projects that show what I can build — from Apex utilities to full dashboards.

💡 If you’re a fellow dev or recruiter checking this out — welcome! Feedback and ideas are always appreciated 😄

