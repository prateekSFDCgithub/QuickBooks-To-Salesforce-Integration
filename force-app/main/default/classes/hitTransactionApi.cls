public class hitTransactionApi implements Database.AllowsCallouts {
    
    public static void createInvoice(string txnId) {
        
        HttpRequest request = new HttpRequest();
        String endpoint = 'callout:TestApp2/v3/company/9341451923767519/transfer/' + txnId;
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
            System.debug('jsonResponse: ' + jsonResponse);
            Map<String, Object> transferObject = (Map<String, Object>)jsonResponse.get('Transfer');
            
            String toAccountRefName = (String) ((Map<String, Object>)transferObject.get('ToAccountRef')).get('name');
            AccountNAmeToMAtch = toAccountRefName;
            system.debug('toAccountRefName: '+ toAccountRefName ) ;
            String toAccountRefValue = (String) ((Map<String, Object>)transferObject.get('ToAccountRef')).get('value');
            system.debug('toAccountRefValue: '+ toAccountRefValue ) ;
            String fromAccountRefName = (String) ((Map<String, Object>)transferObject.get('FromAccountRef')).get('name');
            system.debug('fromAccountRefName: '+ fromAccountRefName ) ;
            String fromAccountRefValue = (String) ((Map<String, Object>)transferObject.get('FromAccountRef')).get('value');
            system.debug('fromAccountRefValue: '+ fromAccountRefValue ) ;
            String transactionId = (String) transferObject.get('Id');
            Decimal amount = (Decimal) transferObject.get('Amount');
            system.debug('amount: '+ amount ) ;
            String createTimeString = (String)((Map<String, Object>)transferObject.get('MetaData')).get('CreateTime');
            
            
            
            
            
            
            Transaction__c tc = new Transaction__c();
            tc.To_Account__c = toAccountRefName;
            tc.From_Account__c = fromAccountRefName;
            tc.Amount__c = amount;
            tc.Transaction_Id__c = transactionId;
            tc.Email_Sent__c = true;
            tc.Transaction_Created_Date__c = createTimeString;
            list<string>AccEmail = new list<string>();
            list<account>AccList =[select id,name,Email_Address__c from account where name =:toAccountRefName];
            
            for(account acc :AccList){
                AccEmail.add(Acc.Email_Address__c);
            }
            if(!AccList.isEmpty()){
                tc.Account__c = Acclist[0].id;
                
                EmailSender.sendEmail(AccEmail);
                insert tc;
            }
        } else {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        }
    }
    
}