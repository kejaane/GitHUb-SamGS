//=========================================================================================
//      Date: 06/24/2012
// Developer: Tom Barrett (TPB)
//   Purpose: This controller is used with the RandomUsers VF Page.
//            Currently, it is used to generate a list of random users//            
//
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================

public class RandomUsers_Controller {
    private List<User> returnUsers = new User[]{};
    private integer randomNum;
    private integer totalUsers;
    private integer totRnd = 10; // default value
    
    public ApexPages.StandardSetController ssc { 
       get;
       set; 
    }  
        
    public void buildRandomUserList() { 
        integer count = 0;                 
        Map<integer, User> usersMap = new Map<integer, User>();  
        Map<integer, integer> trackRndNum = new Map<integer, integer>();
        returnUsers.clear();       
        for ( List<User> userList : [ Select u.id, u.FirstName, u.LastName From User u
                                      Where u.isActive = True and u.Profile.UserLicense.Name = 'Salesforce' and
                                            u.Profile.Name <> 'System Administrator' ] ) {   
            for ( User user : userList ) {
                count++;
                usersMap.put(count, user);
            }
        }
        totalUsers = usersMap.size();         
        
        for ( integer i=0; i < totRnd; i++ ) {    
            // We need to loop until we get a random number that has not already been used.
            while ( true ) {
                randomNum = Randomizer.getRandomNumber(1, totalUsers);                 
                if ( trackRndNum.get(randomNum) == null ) {
                    break;
                }            
            } 
            
            trackRndNum.put(randomNum, randomNum);
              
            User u = new User(FirstName = usersMap.get(randomNum).FirstName, 
                              LastName = usersMap.get(randomNum).LastName);
            returnUsers.add(u);
        } 
    }
     
    public List<User> getRandomUsers() { 
        return returnUsers;
    }   
    
    public String getHowManyUsers() {    
            return string.valueOf(totRnd);
    }  

    public void setHowManyUsers(String hmu) {
        totRnd = integer.valueOf(hmu);
    } 
}