@isTEST
private class RandomUsers_Controller_TEST {
    static testMethod void test1() { 
        List<User> uList = new List<User>();              
        test.startTest();        
        RandomUsers_Controller ru = new RandomUsers_Controller();
        String howManyUsers = ru.getHowManyUsers();
        ru.setHowManyUsers('5'); 
        ru.buildRandomUserList();
        uList = ru.getRandomUsers();               
        test.stopTest();
    }
}