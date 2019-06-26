/*=========================================================================================
 * Date         : 08/20/2016
 * Developer    : Rajesh Pennam
 * Purpose      : This class contains the logic for CaseTrigger Handler.Functionality of this 
 *                class is when a case is created/updated with GroupId,populate the Acccount,Contact,
 *                Broker Agent and Broker Agency lookup fields with 2-50 and 51+ related contacts when they 
 *                match the Agent Agency Id in Group Object with Agent Agency Id in Contact object. 
 *                Also populates the FSP/GP ID from 2-50/51+ Accounts to Case Object.
 *                
 *               
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 07/31/16  |  Rajesh Pennam    | Initial Version                                         
 *           |        | 
 *===========+============================================================================
 */
 
 //Variable initialization 
public class UpdateContactOnCaseByGroup{
  
  public static List<Account> FSPGPAccLst = new List<Account>();
  public static List<Account> GRPAccLst = new List<Account>();
  public static Case UpCasLst = new Case(); // List to update the case
  public static List<Group__c> GrpLst = new List<Group__c>(); // List to hold the group fields which match the groupID(GIDs)
  public static List<Contact> ConLst = new List<Contact>();// List to hold the contact fields which match the groupID(GIDs)
  public static Contact Con = new Contact();
  public static set<String> Gids = new set<String>();// Set to hold all the Groups selected in the Cases
  public static String GRPIds = ''; // Set to hold the id's of Agent_Agency__c field selected in the Group object
  public static String FSPGPIds = ''; // Set to hold the id's of FSP_GP_ID field selected in the Group object
  public static String GrpAI = '';// Set to hold the id's of Group_ID__c field selected in the Group object
  public static List<Account> AccLst = new List<Account>();// List to hold the required Account fields which match the entity id with GrpFSPGPIds
  public static List<Account> AccLst2 = new List<Account>();// List to hold the required Account fields which match the Facets Account Number with GrpIds2
  
  public static void updateContactByGrp(Case newCase){
      system.debug('CaseList'+newCase);
      if(newCase !=null){
          UpCasLst = [select Id,ContactId ,X2_50_Account__c,X2_50_Contact__c,X51_Account__c,X51_Contact__c,FSPGP__c,FSP_GP_ID__c,Broker_Agency__c,Broker_Agent__c,Group_Name__c,X51_Group_Name__c from Case where Id = :newCase.Id LIMIT 1];
          system.debug('Update Case Lst '+UpCasLst);
          system.debug('Case List '+newCase);
          if(newCase.Group__c != null){
              Gids.add(newCase.Group__c); // Set to hold all the Groups selected in the Cases
          }
          
          //This is used to get the requried fields from Group Object depending on the Group ID in the Case Object
          
          if(Gids != null && Gids.size()>0){
              GrpLst = [select Id,Name,Agency_Agent_Id__c,Market_Segment__c,FSP_GP_ID__c,FSP_GP_Name__c,Group_ID__c from Group__c where Id IN :Gids];
              system.debug('Group List'+GrpLst);
              if(GrpLst != null && GrpLst.size()>0){
                  system.debug('GrpIDs '+GrpIds);
                  GrpAI = GrpLst[0].Agency_Agent_Id__c;  // Set to hold the id's of Group_ID__c field selected in the Group object
                  system.debug('GrpIDs '+GrpIds);
                  FSPGPIds = GrpLst[0].FSP_GP_ID__c; // Set to hold the id's of FSP_GP_ID field selected in the Group object
                  GRPIds = GrpLst[0].Group_ID__c;    // Set to hold the id's of Agent_Agency__c field selected in the Group object
              }
              
              //This is used to get the details for the contacts depending on the Agency Agent ID from the Group Object
              
              if(GrpAI != null && GrpAI != ''){
                    string temp = '\''+GrpAI+'\'';
                    system.debug(temp);
                    string queryy = 'select Id,Name,Agency_Agent_Id__c,RecordType.Name,X2_50_Account__c,X2_50_Contact__c,X51_Account__c,X51_Contact__c from Contact where RecordType.Name = \'Community User Contact\' AND Agency_Agent_Id__c  ='+temp+' LIMIT 1';
                    system.debug('Query is: '+queryy);
                    ConLst = Database.query(queryy);
                  system.debug('Contact List '+ConLst);
              }
              
              //This is used the populate the lookup fields in case from Contact Object (Community User Contact )
              
              if(ConLst != null && ConLst.size()>0){
                  for(Group__c gl:GrpLst){
                      for(Contact c: ConLst){
                          system.debug('Group '+gl.Agency_Agent_Id__c);
                          system.debug('contact '+c.Agency_Agent_Id__c);
                          if(gl.Agency_Agent_Id__c == c.Agency_Agent_Id__c){
                              UpCasLst.X2_50_Account__c = c.X2_50_Account__c; // Assign the 2-50 Account of the Community Contact to 2-50 Account lookup in Case
                              UpCasLst.X2_50_Contact__c = c.X2_50_Contact__c; // Assign the 2-50 Contact of the Community Contact to 2-50 Contact lookup in Case
                              UpCasLst.X51_Account__c = c.X51_Account__c;     // Assign the 51 Account of the Community Contact to 2-50 Account lookup in Case
                              UpCasLst.X51_Contact__c = c.X51_Contact__c;     // Assign the 51 Contact of the Community Contact to 51 Contact lookup in Case
                              
                              //This is used the update the Broker Agency/Agnet of case depeding on the Market Segment of the Community Contact
                              
                              if(gl.Market_Segment__c == '2-50'){
                                  UpCasLst.Broker_Agency__c = c.X2_50_Account__c;
                                  UpCasLst.Broker_Agent__c = c.X2_50_Contact__c;
                                  
                              }else if(gl.Market_Segment__c == '51+'){
                                  UpCasLst.Broker_Agency__c = c.X51_Account__c;
                                  UpCasLst.Broker_Agent__c = c.X51_Contact__c;
                                  
                              }
                          }
                      }
                  }
              }
              
              //This is used to make the case lookup fields null if values doesnot exists 
              
              else{
                  system.debug('In Else');
                  UpCasLst.X2_50_Account__c = null;
                  UpCasLst.X2_50_Contact__c = null;
                  UpCasLst.X51_Account__c = null;
                  UpCasLst.X51_Contact__c = null;    
                  UpCasLst.Broker_Agency__c = null;
                  UpCasLst.Broker_Agent__c = null;
              }
              
                         
              if(FSPGPIds != null && FSPGPIds != ''){
                  FSPGPAccLst = [select Id,Name,RecType_Entity_ID__c,Entity_ID__c from Account where Entity_ID__c = :FSPGPIds];
                  system.debug('Account List '+FSPGPAccLst);
              }
              
              //This is used to update FSP/GP fields in cases if the FSP/GP ID in Group Object with Entity ID in Accounts, if doesnot match make the fields null
              
              if(FSPGPAccLst != null && FSPGPAccLst.size()>0){
                  UpCasLst.FSPGP_2_50__c = null;
                  UpCasLst.FSP_GP_51__c = null;
                  for(Account a:FSPGPAccLst){
                      if(a.RecType_Entity_ID__c == '2-50_'+FSPGPIds){
                          UpCasLst.FSPGP_2_50__c = a.Id;
                      }else if(UpCasLst.FSPGP_2_50__c == null){
                          UpCasLst.FSPGP_2_50__c = null;
                      }    
                      if(a.RecType_Entity_ID__c == '51+_'+FSPGPIds){
                          UpCasLst.FSP_GP_51__c = a.id;
                      }else if(UpCasLst.FSP_GP_51__c == null){
                          UpCasLst.FSP_GP_51__c = null;
                      }
                  }
              }else{
                  system.debug('In Else');
                  UpCasLst.FSPGP_2_50__c = null;
                  UpCasLst.FSP_GP_51__c = null;
              }
              if(GRPIds != null && GRPIds != ''){
                  GRPAccLst = [select Id,Name,RecType_Facets_Account_Number__c from Account where Facets_Account_Number__c = :GRPIds];
                  system.debug('Account List '+GRPAccLst);
              }
              
              //This is used to update GroupName field in cases if the Group ID in Group Object matches with Facets Account Number in Accounts, if doesnot match make the fields null
              
              if(GRPAccLst != null && GRPAccLst.size()>0){
                  UpCasLst.Group_Name__c = null;
                  UpCasLst.X51_Group_Name__c = null;
                  for(Account a:GRPAccLst){
                      if(a.RecType_Facets_Account_Number__c == '2-50_'+GRPIds){
                          UpCasLst.Group_Name__c = a.Id;
                      }else if(UpCasLst.Group_Name__c == null){
                          UpCasLst.Group_Name__c = null;
                      }                            
                      if(a.RecType_Facets_Account_Number__c == '51+_'+GRPIds){
                          UpCasLst.X51_Group_Name__c = a.id;                         
                      }else if(UpCasLst.X51_Group_Name__c == null){
                          UpCasLst.X51_Group_Name__c = null;                         
                      }
                  }
              }else{
                  system.debug('In Else');
                  UpCasLst.Group_Name__c = null;
                  UpCasLst.X51_Group_Name__c = null;
              }
              if(FSPGPAccLst != null && FSPGPAccLst.size()>0){
                  UpCasLst.FSPGP__c = null;
                  for(Group__c gl:GrpLst){
                      for(Account a:FSPGPAccLst){
                          if(a.RecType_Entity_ID__c == '2-50_'+FSPGPIds && gl.Market_Segment__c == '2-50'){
                              UpCasLst.FSPGP__c = a.Id;
                          }else if(UpCasLst.FSPGP__c == null){
                              UpCasLst.FSPGP__c = null;
                          }    
                          if(a.RecType_Entity_ID__c == '51+_'+FSPGPIds && gl.Market_Segment__c == '51+'){
                              UpCasLst.FSPGP__c = a.id;
                          }else if(UpCasLst.FSPGP__c == null){
                              UpCasLst.FSPGP__c = null;
                          }
                      }
                  }
              }else{
                  system.debug('In Else');
                  UpCasLst.FSPGP__c = null;   
              }   
          }else{
              UpCasLst.X2_50_Account__c = null;
              UpCasLst.X2_50_Contact__c = null;
              UpCasLst.X51_Account__c = null;
              UpCasLst.X51_Contact__c = null;    
              UpCasLst.Broker_Agency__c = null;
              UpCasLst.Broker_Agent__c = null;
              UpCasLst.FSPGP_2_50__c = null;
              UpCasLst.FSP_GP_51__c = null;
              UpCasLst.Group_Name__c = null;
              UpCasLst.X51_Group_Name__c = null;
              UpCasLst.FSPGP__c = null;  
              
              if(UpCasLst.ContactId != null){
                  try{
                      Con = [select Id,Name,RecordType.Name,X2_50_Account__c,X2_50_Contact__c,X51_Account__c,X51_Contact__c from Contact Where Id = :UpCasLst.ContactId];
                      system.debug('contact details '+Con);
                  }catch(QueryException ex){
                      system.debug(ex+'');
                  }
              }
              if(ConLst != null){
                  UpCasLst.X2_50_Account__c = Con.X2_50_Account__c;
                  UpCasLst.X2_50_Contact__c = Con.X2_50_Contact__c;
                  UpCasLst.X51_Account__c = Con.X51_Account__c;
                  UpCasLst.X51_Contact__c = Con.X51_Contact__c;
                  if(Con.X2_50_Contact__c != null){
                      UpCasLst.Broker_Agency__c = Con.X2_50_Account__c;
                      UpCasLst.Broker_Agent__c = Con.X2_50_Contact__c;
                  }else if(Con.X51_Contact__c != null){
                      UpCasLst.Broker_Agency__c = Con.X51_Account__c;
                      UpCasLst.Broker_Agent__c = Con.X51_Contact__c;
                  }else{
                      UpCasLst.Broker_Agency__c = null;
                      UpCasLst.Broker_Agent__c = null;
                  }
              }
          }
          Boolean RecursiveCheck = RecursiveForUpdateCase.runOnce();
          try{
              system.debug('Before Update '+UpCasLst);
              if(UpCasLst != null && RecursiveCheck)
                  update UpCasLst;
                 system.debug('After Update '+UpCasLst);
          }catch(DMLException ex){
              system.debug(''+ex);
          } 
      }
      
   } 
}