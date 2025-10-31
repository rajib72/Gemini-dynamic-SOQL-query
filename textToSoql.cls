public class textToSoql {
    @AuraEnabled(cacheable=false)
    public static List<SObject> convertToSoql(String queryString){
        String GEMINI_API_KEY = 'AIzaSyAUFAVWUVoKcqBnjcsDFCeFmomt13mF6P0';

        // Set up the endpoint
        String endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

        // Create HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('x-goog-api-key', GEMINI_API_KEY);
		req.setTimeout(60000);

        // Prepare the request body
        // 
        String query = 'Create a soql query : '+queryString;
        String body = '{' +
            '"contents": [{' +
                '"parts": [{' +
                    '"text": "' + query.replaceAll('"', '\\"') + '"' +
                '}]' +
            '}]' +
        '}';
        req.setBody(body);

        // Send the request
        Http http = new Http();
        HTTPResponse res = http.send(req);

        // Handle the response
        System.debug('Status: ' + res.getStatus());
        System.debug('Response: ' + res.getBody());
        
        String responseBody = res.getBody(); // response from Gemini API

        // Parse the JSON
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        
        // Navigate into candidates
        List<SObject> records = new List<SObject>();
        List<Object> candidates = (List<Object>) responseMap.get('candidates');
        if (candidates != null && !candidates.isEmpty()) {
            Map<String, Object> firstCandidate = (Map<String, Object>) candidates[0];
            Map<String, Object> content = (Map<String, Object>) firstCandidate.get('content');
            List<Object> parts = (List<Object>) content.get('parts');
            Map<String, Object> firstPart = (Map<String, Object>) parts[0];
            String text = (String) firstPart.get('text');
        
            System.debug('Full text: ' + text);
        
            Pattern p = Pattern.compile('(?i)```soql\\s*([\\s\\S]*?)```');
            Matcher m = p.matcher(text);
            
            String soqlQuery;
            if (m.find()) {
                soqlQuery = m.group(1).trim();
        		System.debug('Extracted SOQL: ' + soqlQuery);
                
                records = Database.query(soqlQuery);
        		System.debug('Results: ' + records);
            }
            else {
                System.debug('No SOQL found in the response.');
            }
			
            
    	}
        return records;
    }
}