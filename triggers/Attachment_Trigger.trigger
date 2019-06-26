trigger Attachment_Trigger on Attachment(after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    new AttachmentTriggerHandler().run();
}