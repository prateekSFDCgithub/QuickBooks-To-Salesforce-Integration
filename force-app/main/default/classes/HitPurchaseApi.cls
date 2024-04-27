public class HitPurchaseApi {
    public static void getPurchase(string txnId) {
         HttpRequest request = new HttpRequest();
        String endpoint = 'callout:TestApp2/v3/company/9341451923767519/purchase/' + txnId;
        request.setEndpoint(endpoint);
        request.setheader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/text');
        request.setMethod('GET');
        
        Http httpsss = new Http();
        HttpResponse response = httpsss.send(request);
        string AccountNAmeToMAtch;
        list<Account>TxnListToInsert = new list<account>();
        
        if(response.getStatusCode() == 200){
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            system.debug('jsonResponse@@321: '+jsonResponse);
            Map<String, Object> purchase = (Map<String, Object>) jsonResponse.get('Purchase');
            
            // Parsing AccountRef name
            Map<String, Object> accountRef = (Map<String, Object>) purchase.get('AccountRef');
            String accountName = (String) accountRef.get('name');
            System.debug('Account Name: ' + accountName);
            
            // Parsing EntityRef name
            Map<String, Object> entityRef = (Map<String, Object>) purchase.get('EntityRef');
            String entityName = (String) entityRef.get('name');
            System.debug('Entity Name: ' + entityName);
            
            // Parsing TotalAmt
            Double totalAmt = (Double) purchase.get('TotalAmt');
            System.debug('Total Amount: ' + totalAmt);
            
            // Parsing Id
            String purchaseId = (String) purchase.get('Id');
            System.debug('Purchase Id: ' + purchaseId);
            
            // Parsing Metadata CreateTime
            Map<String, Object> metaData = (Map<String, Object>) purchase.get('MetaData');
            String createTime = (String) metaData.get('CreateTime');
            System.debug('Create Time: ' + createTime);
            
             Transaction__c tc = new Transaction__c();
            tc.To_Account__c = entityName;
            tc.From_Account__c = accountName;
            tc.Amount__c = totalAmt;
            tc.Transaction_Id__c = purchaseId;
            tc.Email_Sent__c = true;
            tc.Transaction_Created_Date__c = createTime;
            list<string>ConEmail = new list<string>();
            list<account>AccList =[select id,name,Email_Address__c from account where name =:entityName];
            if(!AccList.isEmpty()){
                tc.Account__c = Acclist[0].id;
               insert tc;
            }
           string AccId =[select id,name,Email_Address__c from account where name =:entityName].id;
            List<Contact> conList = [SELECT Id, AccountId, Email, Name, Send_Email__c FROM Contact WHERE AccountId = :AccId AND Send_Email__c = true];
            for(contact con: Conlist){
                system.debug('conemail:@@ '+con.email);
            }
            
            for(contact con :ConList){
                ConEmail.add(con.email);
            }
            for(string con :conEmail){
                system.debug('conEmail22@: '+con);
            }
            if(!ConEmail.isEmpty()){
                EmailSender.sendEmail(conEmail,Acclist[0].id,tc.id);
            }
              
            
    }
        
        else{
             System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        }
        
        

}
}