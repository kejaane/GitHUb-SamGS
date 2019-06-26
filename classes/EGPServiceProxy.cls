//Generated by wsdl2apex

public class EGPServiceProxy {
    public class SystemUnavailableFault_element {
        public String msg;
        public String msgCode;
        private String[] msg_type_info = new String[]{'msg','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] msgCode_type_info = new String[]{'msgCode','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapFault','true','false'};
        private String[] field_order_type_info = new String[]{'msg','msgCode'};
    }
    public class DataNotFound_element {
        public String msg;
        public String msgCode;
        private String[] msg_type_info = new String[]{'msg','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] msgCode_type_info = new String[]{'msgCode','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapFault','true','false'};
        private String[] field_order_type_info = new String[]{'msg','msgCode'};
    }
    public class AuthenticationException_element {
        public String msg;
        public String msgCode;
        private String[] msg_type_info = new String[]{'msg','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] msgCode_type_info = new String[]{'msgCode','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapFault','true','false'};
        private String[] field_order_type_info = new String[]{'msg','msgCode'};
    }
    public class InputDataInvalid_element {
        public String msg;
        public String msgCode;
        private String[] msg_type_info = new String[]{'msg','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] msgCode_type_info = new String[]{'msgCode','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapFault','true','false'};
        private String[] field_order_type_info = new String[]{'msg','msgCode'};
    }
    public class SourceSystemInvalid_element {
        public String msg;
        public String msgCode;
        private String[] msg_type_info = new String[]{'msg','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] msgCode_type_info = new String[]{'msgCode','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapFault','true','false'};
        private String[] field_order_type_info = new String[]{'msg','msgCode'};
    }
    public class fault_element {
        public EGPServiceProxy.faultType_element faultType;
        private String[] faultType_type_info = new String[]{'faultType','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapFault','true','false'};
        private String[] field_order_type_info = new String[]{'faultType'};
    }
    public class SystemTimeOutException_element {
        public String msg;
        public String msgCode;
        private String[] msg_type_info = new String[]{'msg','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] msgCode_type_info = new String[]{'msgCode','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapFault','true','false'};
        private String[] field_order_type_info = new String[]{'msg','msgCode'};
    }
    public class faultType_element {
        public EGPServiceProxy.SystemUnavailableFault_element SystemUnavailableFault;
        public EGPServiceProxy.SourceSystemInvalid_element SourceSystemInvalid;
        public EGPServiceProxy.DataNotFound_element DataNotFound;
        public EGPServiceProxy.ApplicationException_element ApplicationException;
        public EGPServiceProxy.SystemTimeOutException_element SystemTimeOutException;
        public EGPServiceProxy.PackageNotCompiled_element PackageNotCompiled;
        public EGPServiceProxy.AuthenticationException_element AuthenticationException;
        public EGPServiceProxy.InputDataInvalid_element InputDataInvalid;
        public EGPServiceProxy.DefaultFault_element DefaultFault;
        private String[] SystemUnavailableFault_type_info = new String[]{'SystemUnavailableFault','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] SourceSystemInvalid_type_info = new String[]{'SourceSystemInvalid','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] DataNotFound_type_info = new String[]{'DataNotFound','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] ApplicationException_type_info = new String[]{'ApplicationException','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] SystemTimeOutException_type_info = new String[]{'SystemTimeOutException','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] PackageNotCompiled_type_info = new String[]{'PackageNotCompiled','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] AuthenticationException_type_info = new String[]{'AuthenticationException','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] InputDataInvalid_type_info = new String[]{'InputDataInvalid','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] DefaultFault_type_info = new String[]{'DefaultFault','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapFault','true','false'};
        private String[] field_order_type_info = new String[]{'SystemUnavailableFault','SourceSystemInvalid','DataNotFound','ApplicationException','SystemTimeOutException','PackageNotCompiled','AuthenticationException','InputDataInvalid','DefaultFault'};
    }
    public class DefaultFault_element {
        public String faultCode;
        public String faultMsg;
        private String[] faultCode_type_info = new String[]{'faultCode','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] faultMsg_type_info = new String[]{'faultMsg','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapFault','true','false'};
        private String[] field_order_type_info = new String[]{'faultCode','faultMsg'};
    }
    public class PackageNotCompiled_element {
        public String msg;
        public String msgCode;
        private String[] msg_type_info = new String[]{'msg','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] msgCode_type_info = new String[]{'msgCode','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapFault','true','false'};
        private String[] field_order_type_info = new String[]{'msg','msgCode'};
    }
    public class ApplicationException_element {
        public String msg;
        public String msgCode;
        private String[] msg_type_info = new String[]{'msg','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] msgCode_type_info = new String[]{'msgCode','http://carefirst.com/Enterprise/Operations/SoapFault',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapFault','true','false'};
        private String[] field_order_type_info = new String[]{'msg','msgCode'};
    }
    public class accountUpdateRequest_element {
        public String entity;
        public String submittedById;
        public String action;
        public String accountName;
        public EGPServiceProxy.group_element[] group_x;
        public String asoInd;
        public String fspName;
        public String gpName;
        public String managerFirstName;
        public String managerLastName;
        public String managerEmailAddress;
        public String enrollmentVendor;
        public String vendorEffectiveDate;
        private String[] entity_type_info = new String[]{'entity','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] submittedById_type_info = new String[]{'submittedById','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] action_type_info = new String[]{'action','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] accountName_type_info = new String[]{'accountName','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] group_x_type_info = new String[]{'group','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','-1','false'};
        private String[] asoInd_type_info = new String[]{'asoInd','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] fspName_type_info = new String[]{'fspName','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] gpName_type_info = new String[]{'gpName','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] managerFirstName_type_info = new String[]{'managerFirstName','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] managerLastName_type_info = new String[]{'managerLastName','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] managerEmailAddress_type_info = new String[]{'managerEmailAddress','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] enrollmentVendor_type_info = new String[]{'enrollmentVendor','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] vendorEffectiveDate_type_info = new String[]{'vendorEffectiveDate','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema','true','false'};
        private String[] field_order_type_info = new String[]{'entity','submittedById','action','accountName','group_x','asoInd','fspName','gpName','managerFirstName','managerLastName','managerEmailAddress','enrollmentVendor','vendorEffectiveDate'};
    }
    public class manageUserRequest_element {
        public String entity;
        public String submittedById;
        public String action;
        public String firstName;
        public String lastName;
        public String emailAddress;
        public String accountName;
        public EGPServiceProxy.group_element[] group_x;
        public String managerFirstName;
        public String managerLastName;
        public String managerEmailAddress;
        public String enrollmentVendor;
        public String vendorEffectiveDate;
        public String asoInd;
        private String[] entity_type_info = new String[]{'entity','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] submittedById_type_info = new String[]{'submittedById','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] action_type_info = new String[]{'action','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] firstName_type_info = new String[]{'firstName','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] lastName_type_info = new String[]{'lastName','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] emailAddress_type_info = new String[]{'emailAddress','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] accountName_type_info = new String[]{'accountName','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] group_x_type_info = new String[]{'group','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','-1','false'};
        private String[] managerFirstName_type_info = new String[]{'managerFirstName','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] managerLastName_type_info = new String[]{'managerLastName','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] managerEmailAddress_type_info = new String[]{'managerEmailAddress','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] enrollmentVendor_type_info = new String[]{'enrollmentVendor','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] vendorEffectiveDate_type_info = new String[]{'vendorEffectiveDate','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] asoInd_type_info = new String[]{'asoInd','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema','true','false'};
        private String[] field_order_type_info = new String[]{'entity','submittedById','action','firstName','lastName','emailAddress','accountName','group_x','managerFirstName','managerLastName','managerEmailAddress','enrollmentVendor','vendorEffectiveDate','asoInd'};
    }
    public class manageUserResponse_element {
        public String status;
        public String statusCode;
        public String statusDescription;
        private String[] status_type_info = new String[]{'status','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] statusDescription_type_info = new String[]{'statusDescription','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema','true','false'};
        private String[] field_order_type_info = new String[]{'status','statusCode','statusDescription'};
    }
    public class group_element {
        public String groupId;
        public String enrollmentPlatform;
        private String[] groupId_type_info = new String[]{'groupId','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] enrollmentPlatform_type_info = new String[]{'enrollmentPlatform','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema','true','false'};
        private String[] field_order_type_info = new String[]{'groupId','enrollmentPlatform'};
    }
    public class accountUpdateResponse_element {
        public String status;
        public String statusCode;
        public String statusDescription;
        private String[] status_type_info = new String[]{'status','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] statusDescription_type_info = new String[]{'statusDescription','http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema','true','false'};
        private String[] field_order_type_info = new String[]{'status','statusCode','statusDescription'};
    }
    public class SOAPHeader_element {
        public String Timestamp;
        public String Source;
        public String Environment;
        public String UserID;
        public String Role;
        public String Destination;
        public String Version;
        public String TransactionID;
        public String EventID;
        public String ProcessType;
        public String EventType;
        public String Logging;
        public String ErrorListExists;
        public String IgnoreErrorList;
        public String SecurityInfo;
        public EGPServiceProxy.SourceSpecificFields_element[] SourceSpecificFields;
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] Source_type_info = new String[]{'Source','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] Environment_type_info = new String[]{'Environment','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] UserID_type_info = new String[]{'UserID','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] Role_type_info = new String[]{'Role','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] Destination_type_info = new String[]{'Destination','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] Version_type_info = new String[]{'Version','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] TransactionID_type_info = new String[]{'TransactionID','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] EventID_type_info = new String[]{'EventID','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] ProcessType_type_info = new String[]{'ProcessType','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] EventType_type_info = new String[]{'EventType','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] Logging_type_info = new String[]{'Logging','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] ErrorListExists_type_info = new String[]{'ErrorListExists','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] IgnoreErrorList_type_info = new String[]{'IgnoreErrorList','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] SecurityInfo_type_info = new String[]{'SecurityInfo','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] SourceSpecificFields_type_info = new String[]{'SourceSpecificFields','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapHeader','true','false'};
        private String[] field_order_type_info = new String[]{'Timestamp','Source','Environment','UserID','Role','Destination','Version','TransactionID','EventID','ProcessType','EventType','Logging','ErrorListExists','IgnoreErrorList','SecurityInfo','SourceSpecificFields'};
    }
    public class SourceSpecificFields_element {
        public String Name;
        public String Value;
        private String[] Name_type_info = new String[]{'Name','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://carefirst.com/Enterprise/Operations/SoapHeader',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapHeader','true','false'};
        private String[] field_order_type_info = new String[]{'Name','Value'};
    }
    public class SalesForceEndpoint1 {
        public String endpoint_x = 'http://localhost:12697/SalesForceEndpoint1';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public EGPServiceProxy.SOAPHeader_element header;
        private String header_hns = 'SOAPHeader=http://carefirst.com/Enterprise/Operations/SoapHeader';
        private String[] ns_map_type_info = new String[]{'http://carefirst.com/Enterprise/Operations/SoapFault', 'EGPServiceProxy', 'http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema', 'EGPServiceProxy', 'http://www.carefirst.com/Enterprise/Employer/SalesForceService', 'EGPServiceProxy', 'http://carefirst.com/Enterprise/Operations/SoapHeader', 'EGPServiceProxy'};
        public EGPServiceProxy.manageUserResponse_element ManageUser(String entity,String submittedById,String action,String firstName,String lastName,String emailAddress,String accountName,EGPServiceProxy.group_element[] group_x,String managerFirstName,String managerLastName,String managerEmailAddress,String enrollmentVendor,String vendorEffectiveDate,String asoInd) {
            EGPServiceProxy.manageUserRequest_element request_x = new EGPServiceProxy.manageUserRequest_element();
            request_x.entity = entity;
            request_x.submittedById = submittedById;
            request_x.action = action;
            request_x.firstName = firstName;
            request_x.lastName = lastName;
            request_x.emailAddress = emailAddress;
            request_x.accountName = accountName;
            request_x.group_x = group_x;
            request_x.managerFirstName = managerFirstName;
            request_x.managerLastName = managerLastName;
            request_x.managerEmailAddress = managerEmailAddress;
            request_x.enrollmentVendor = enrollmentVendor;
            request_x.vendorEffectiveDate = vendorEffectiveDate;
            request_x.asoInd = asoInd;
            EGPServiceProxy.manageUserResponse_element response_x;
            Map<String, EGPServiceProxy.manageUserResponse_element> response_map_x = new Map<String, EGPServiceProxy.manageUserResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'SalesForceEndpoint1/ManageUser',
              'http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',
              'manageUserRequest',
              'http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',
              'manageUserResponse',
              'EGPServiceProxy.manageUserResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EGPServiceProxy.accountUpdateResponse_element AccountUpdate(String entity,String submittedById,String action,String accountName,EGPServiceProxy.group_element[] group_x,String asoInd,String fspName,String gpName,String managerFirstName,String managerLastName,String managerEmailAddress,String enrollmentVendor,String vendorEffectiveDate) {
            EGPServiceProxy.accountUpdateRequest_element request_x = new EGPServiceProxy.accountUpdateRequest_element();
            request_x.entity = entity;
            request_x.submittedById = submittedById;
            request_x.action = action;
            request_x.accountName = accountName;
            request_x.group_x = group_x;
            request_x.asoInd = asoInd;
            request_x.fspName = fspName;
            request_x.gpName = gpName;
            request_x.managerFirstName = managerFirstName;
            request_x.managerLastName = managerLastName;
            request_x.managerEmailAddress = managerEmailAddress;
            request_x.enrollmentVendor = enrollmentVendor;
            request_x.vendorEffectiveDate = vendorEffectiveDate;
            EGPServiceProxy.accountUpdateResponse_element response_x;
            Map<String, EGPServiceProxy.accountUpdateResponse_element> response_map_x = new Map<String, EGPServiceProxy.accountUpdateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'SalesForceEndpoint1/AccountUpdate',
              'http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',
              'accountUpdateRequest',
              'http://www.carefirst.com/schemas/SalesForce_Service/SalesForceSchema',
              'accountUpdateResponse',
              'EGPServiceProxy.accountUpdateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}