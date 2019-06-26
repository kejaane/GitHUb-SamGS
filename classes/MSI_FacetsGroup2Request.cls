public with sharing class MSI_FacetsGroup2Request extends MSI_Message {
	
 	 public String groupID {get; set;}
	 	 
     public MSI_FacetsGroup2Request() {
	     super();
	     this.msgType = IntegrationMessage.REQUEST;
	     this.isValid = true;   // by default
    }
		
}