public with sharing class EGPServiceFault {
		public static final EGPServiceFault SystemUnavailableFault = new EGPServiceFault('F00001', 'SystemUnavailableFault', 'Unknown error occurred during execution. System not available.');
		public static final EGPServiceFault DatabaseFault = new EGPServiceFault('F00002', 'DatabaseFault', 'Unable to Connect SOR Data store');
		public static final EGPServiceFault SystemTimeoutFault = new EGPServiceFault('F00003', 'SystemTimeoutFault',	'System Timeout Exception occurred.');
		public static final EGPServiceFault InputRequestDataInvalid = new EGPServiceFault('F00004', 'Input Request Data invalid', 'Error Message ERR001 will be sent');
		public static final EGPServiceFault DefaultFault =  new EGPServiceFault('F00005', 'DefaultFault', 'Unknown system error');
		public static final EGPServiceFault DataNotFound = new EGPServiceFault('F00006', 'DataNotFound', 'No Data Found.');
		
		public String code {get; set;} 
		public String faultType {get; set;} 
		public String description {get; set;} 

		public EGPServiceFault( String faultCode, String faultType, String description) {
			this.code = faultCode;
			this.faultType = faultType;
			this.description = description;
		}
	}