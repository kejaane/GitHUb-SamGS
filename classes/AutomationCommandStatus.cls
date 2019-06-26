public with sharing class AutomationCommandStatus {
	public Integer status {get; set;}	// 0 - not-complete, 1 - complete
	public String   statusMessage {get; set;}
	
	public AutomationCommandStatus() {
		status = 0;
		statusMessage = ' ';
	}
}