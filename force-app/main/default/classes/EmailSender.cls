public class EmailSender {
    
    public static void sendEmail(list<string>emailList, string AccId, string txnId){
        list<emailMessage>emailMessageToInsert = new list<emailMessage>();
        list<contact>ConList =[select id,accountId,email from contact where email=:emailList and accountid =:accid];
       decimal  Amount = [select id,amount__c from transaction__c where id =:txnId].amount__c;
        string ToAccount = [select id,Amount__c,to_account__c from transaction__c where id =:txnId].To_Account__c;   
        string FromAccount = [select id,From_Account__c,Amount__c,to_account__c from transaction__c where id =:txnId].From_Account__c;    
       // system.debug('ConList: '+ConList.size() + 'COnlist[0]: '+ConList[0].email + 'ConList[1]: '+ ConList[1].email);
        
        for (string st : emailList){
            system.debug('st@@: '+st);
        }
        
        for(contact con :ConList){
            
           messaging.singleEmailMessage mail = new messaging.singleEmailMEssage();
            mail.setSubject('Transaction Successfull');
            mail.setPlainTextBody('Transaction of amount '+ Amount + ' is successfully sended from ' + FromAccount +' to ' + ToAccount);
          //  mail.setToAddresses(new list<string>{con.email});
            mail.setReplyTo('testemailservice@1fe9p7y2je70d6ppqm3x47w01ymmi6f6zhkkfen8m2iws3r345.56-msxbeaw.cs341.apex.sandbox.salesforce.com');
            mail.setSenderDisplayName('GlobalGlow@@');
            mail.setSaveAsActivity(true);
            mail.setTargetObjectId(con.id);
            
            messaging.sendEmail(new list<messaging.singleEmailMessage>{mail});
            
            EmailMessage newEmailMessage = new EmailMessage();
            newEmailMessage.Subject = 'Transaction Successfull';
            newEmailMessage.TextBody = 'Transaction of amount '+ Amount + ' is successfully sended from ' + FromAccount +' to ' + ToAccount;
            newEmailMessage.FromAddress = 'testemailservice@1fe9p7y2je70d6ppqm3x47w01ymmi6f6zhkkfen8m2iws3r345.56-msxbeaw.cs341.apex.sandbox.salesforce.com';
            newEmailMessage.Contact__c = con.id; 
            newEmailMessage.toAddress = con.email;
            newEmailMessage.Status = '0'; 
            
            emailMessageToInsert.add(newEmailMessage);
        }
        insert emailMessageToInsert;
        
    }
    
}