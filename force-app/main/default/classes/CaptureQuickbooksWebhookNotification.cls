@RestResource(urlMapping='/api/webhooks/transactions/*')
global class CaptureQuickbooksWebhookNotification {
    @HttpPost
    global static void createTransaction() {
        RestRequest request = RestContext.request;
        Blob body = request.requestBody;
        
        String bodyString = body.toString();
        system.debug('BOdy========9'+bodyString);
        // Deserialize the JSON request body

        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(bodyString);
        List<Object> eventNotifications = (List<Object>)jsonResponse.get('eventNotifications');
        
        // Map to store entities
        Map<String, Object> entityMap = new Map<String, Object>();
        
        // Iterate through eventNotifications
        for (Object notification : eventNotifications) {
            Map<String, Object> notificationMap = (Map<String, Object>)notification;
            Map<String, Object> dataChangeEvent = (Map<String, Object>)notificationMap.get('dataChangeEvent');
            List<Object> entities = (List<Object>)dataChangeEvent.get('entities');
            
            // Iterate through entities
            for (Object entity : entities) {
                Map<String, Object> entityMapEntry = (Map<String, Object>)entity;
                entityMap.put((String) entityMapEntry.get('id'), entityMapEntry);
                system.debug('=====EN27'+entityMapEntry);
                if((string)entityMapEntry.get('operation')=='Create'|| (string)entityMapEntry.get('operation') == 'Update'){
                     GetPurchases.getPurchase((string)entityMapEntry.get('id'));
                }
             

            }
        }
        system.debug('=====EN30'+entityMap);
    }
}