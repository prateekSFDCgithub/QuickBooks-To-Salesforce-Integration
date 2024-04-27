global class CaptureEmailReply implements messaging.InboundEmailHandler {
    
    global messaging.InboundEmailResult handleInboundEmail(messaging.InboundEmail email, messaging.InboundEnvelope envelope) {
        
        // Extract email address from the inbound email
        String senderEmail = email.fromAddress;
        
        system.debug('SendwerEmail: '+senderEmail);
        
        // Query contacts with the matching email address
        List<contact> conList = [SELECT name, Id, Email FROM contact WHERE email = :senderEmail];
        system.debug('AccList: '+conLIst);
        for(contact con:conlist){
            system.debug('contacts: '+con.email +con.name);
        }
        
        if (!conList.isEmpty()) {
            // Create EmailMessage records for each Contact found
            for (contact con : conList) {
                // Create a new EmailMessage
                EmailMessage newEmailMessage = new EmailMessage();
                newEmailMessage.Subject = email.subject;
                newEmailMessage.HtmlBody = email.htmlBody;
                newEmailMessage.TextBody = email.plainTextBody;
                newEmailMessage.FromAddress = senderEmail;
                newEmailMessage.contact__c = con.Id; // Assigning Contact Id to ToIds
                newEmailMessage.Status = '0'; // Set status as per your requirement
                newEmailMessage.ToIds = new list<string>{con.Id};
                    
                    //create task record
                    Task newTask = new Task();
                newTask.Subject = email.subject;
                newTask.Description = email.plainTextBody; // You may choose to use either plainTextBody or htmlBody as the description
                newTask.WhoId = con.Id; // Assigning Contact Id to WhoId
                newTask.ActivityDate = Date.today(); // Set the activity date as per your requirement
                newTask.Status = 'Completed'; // Set the status as per your requirement
                try {
                    insert newEmailMessage;
                    insert newTask;
                   
                    
                } catch (DmlException e) {
                    System.debug('Error Message: ' + e.getMessage());
                    // Handle the error appropriately
                }
            }
        } else {
            // Handle scenario where no matching contact is found
            // For example, you might want to create a new contact or handle it differently
        }
        
        return null;
    }
}