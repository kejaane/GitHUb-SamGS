//=========================================================================================
//      Date: 04/21/2018
// Developer: Tom Barrett (TPB)
//   Purpose: This test class tests the SM_IntroductionController and SM_Introduction 
//            Visualforce page.         
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================
@isTest
private class SM_IntroductionController_Test {    
    @testSetup static void setup() {
        List<Document> documentList = new List<Document>();
        Document icon = new Document();
        Id folderId = [SELECT id FROM folder WHERE Name = 'Sandbox Manager' AND Type = 'Document' LIMIT 1].id;
        //Create Icon
        icon.Body = Blob.valueOf('Some Text');
        icon.ContentType = 'image/png';
        icon.DeveloperName = 'SandboxManagerIcon_TEST';
        icon.IsPublic = true;
        icon.Name = 'SMicon';
        icon.FolderId = folderId;
        documentList.add(icon);
        //Create User Guide
        Document doc = new Document();
        doc.Body = Blob.valueOf('Some Text');
        doc.ContentType = 'application/msword';
        doc.DeveloperName = 'Sandbox_Manager_App_User_and_Design_Guide_TEST';
        doc.IsPublic = true;
        doc.Name = 'SMdesignDoc';
        doc.FolderId = folderId;
        documentList.add(doc);
        //DML for document files
        insert documentList;
        
        //Create Demo Content File
        ContentVersion contentVersion = new ContentVersion(Title='Sandbox Manager Demo Test',
                                                           PathOnClient = 'Sandbox_Manager_Demo_Test.mp4',
                                                           VersionData = Blob.valueOf('Test Content Data'),
                                                           isMajorVersion = true
                                                          );
        //DML for content document
        insert contentVersion; 
    }
    
    private static testMethod void testAppIcon() {     
        Test.StartTest();         
            PageReference pageRef = Page.SM_Introduction;
            Test.setCurrentPage(pageRef);        
            SM_IntroductionController ss = new SM_IntroductionController();
            String appIcon = ss.appIcon;            
            //Get the Icon
            Document td = [SELECT id FROM Document WHERE DeveloperName = 'SandboxManagerIcon_TEST' LIMIT 1];
            String tdRetVal = '/servlet/servlet.FileDownload?file=' + td.id;
            System.assertEquals(appIcon, tdRetVal, 'No match on app Icon file!');
        Test.StopTest();                    
    }  

    private static testMethod void testDesignDoc() {     
        Test.StartTest();         
            PageReference pageRef = Page.SM_Introduction;
            Test.setCurrentPage(pageRef);        
            SM_IntroductionController ss = new SM_IntroductionController();
            String appDesignDoc = ss.userDesignDoc;
            Boolean userDesignDocExists = ss.userDesignDocExists;            
            //Get the Design Doc
            Document td = [SELECT id FROM Document WHERE DeveloperName = 'Sandbox_Manager_App_User_and_Design_Guide_TEST' LIMIT 1];
            String tdRetVal = '/servlet/servlet.FileDownload?file=' + td.id;
            System.assertEquals(appDesignDoc, tdRetVal, 'No match on document file!');
        Test.StopTest();                    
    }   

    private static testMethod void testDemoContentDoc() {     
        Test.StartTest();         
            PageReference pageRef = Page.SM_Introduction;
            Test.setCurrentPage(pageRef);        
            SM_IntroductionController ss = new SM_IntroductionController();
            String demo = ss.demo;
            Boolean demoExists = ss.demoExists;            
            //Get the Design Doc
            ContentVersion contentVersionSelect = [SELECT id, Title, ContentDocumentId 
                                                   FROM ContentVersion 
                                                   WHERE Title = 'Sandbox Manager Demo Test' LIMIT 1];
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId 
                                               FROM ContentDocument];
            System.assertEquals(documents.size(), 1, 'No match on demo file!');
        Test.StopTest();                    
    }   
}