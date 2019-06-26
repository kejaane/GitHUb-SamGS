//=========================================================================================
//      Date: 04/21/2018
// Developer: Tom Barrett (TPB)
//   Purpose: This class controller supports the SM_Introduction Visualforce page which is
//            used as part of the unmanaged package install.                                    
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================
public class SM_IntroductionController {
    public String appIcon{get; set;}
    public Boolean appIconExists{get; set;}
    public String userDesignDoc{get; set;}
    public Boolean userDesignDocExists{get; set;}
    public String demo{get; set;}
    public Boolean demoExists{get; set;}
      
    //setup default values
    public SM_IntroductionController() { 
    System.debug('testing');
        userDesignDoc = getUserDesignDoc();
        if (userDesignDoc != null) userDesignDocExists = true;
        
        demo = getAppDemo();
        if (demo != null) demoExists = true; 
        
        appIcon = getAppIcon();
        if (appIcon != null) appIconExists = true;
    } 


    /*************************************
     * get the apps icon image           *
     * returns path if document is found *
     * otherwise, returns null           *
     *************************************/
    public String getUserDesignDoc() { 
        String userDesignDoc = null;
        List<Document> docList = new List<Document>();
        docList = [SELECT id FROM Document WHERE DeveloperName LIKE 'Sandbox_Manager_App_User_and_Design_Guide%' LIMIT 1];          
        if(!docList.isEmpty()) {           
            userDesignDoc = '/servlet/servlet.FileDownload?file=' + docList[0].id; 
        }
        return userDesignDoc;
    }   

    /*****************************************
     * get the link to the demo file         *
     * returns the path if the file is found *
     * otherwise, returns null               *
     *****************************************/
    public static String getAppDemo() {
        String demo = null;
        List<ContentVersion> ContentDocLinkList = new List<ContentVersion>();
        contentDocLinkList = [SELECT Id, ContentDocument.title
                              FROM ContentVersion
                              WHERE isLatest = true and ContentDocument.title LIKE 'Sandbox_Manager_Demo%' LIMIT 1]; 
        if(!contentDocLinkList.isEmpty()) {            
            demo = '/sfc/servlet.shepherd/version/download/' + contentDocLinkList[0].Id;
        }
        return demo;
    }
    
    /*****************************************
     * get the link to the apps icon         *
     * returns the link if the file is found *
     * otherwise, returns null               *
     *****************************************/
    private String getAppIcon() {
        String appIcon = null;
        List<Document> docList = new List<Document>();
        docList = [SELECT id FROM Document WHERE DeveloperName LIKE 'SandboxManagerIcon%' LIMIT 1];  
        System.debug('DOC ICON: ' + docList);        
        if(!docList.isEmpty()) {           
            appIcon = '/servlet/servlet.FileDownload?file=' + docList[0].id; 
        }
        return appIcon;
     }      
    
}