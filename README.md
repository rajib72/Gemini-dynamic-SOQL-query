# Gemini-dynamic-SOQL-query

🚀 Built a Smart SOQL Query Runner using Google Gemini + Salesforce LWC

🧠 How it works:

    I send a natural language prompt (like “Get the first 10 Opportunities that are Closed Won”) to Google Gemini API from Apex.
    
    Gemini responds with a generated SOQL query.
    
    My Apex class extracts the query, executes it dynamically using Database.query(), and returns the results.
    
    A custom Lightning Web Component (LWC) takes the input, calls Apex, shows a spinner while loading, and displays results dynamically.
    
    You can even click any record to navigate directly to its Salesforce record page! ⚡


🎨 Tech Stack:

    Apex Callout to Google Gemini API
    
    JSON Parsing & Regex for SOQL extraction
    
    Dynamic SOQL Execution
    
    LWC front-end with Spinner + Dynamic Iterable UI

NavigationMixin for record navigation
