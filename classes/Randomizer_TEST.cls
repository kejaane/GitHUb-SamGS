@isTEST
private class Randomizer_TEST {
    static testMethod void testRandomizer() {               
        test.startTest();
        
        Integer testInt = Randomizer.getRandomNumber(10); 
               
        testInt = Randomizer.getRandomNumber(10, 20);

        
        Boolean testBool;
        do {         
            testBool = Randomizer.getRandomBoolean();
            if ( testBool ) { break; }        
        } while (true);
        do {
            testBool = Randomizer.getRandomBoolean();
            if ( !testBool ) { break; }
        } while (true);
        
        List<String> testStringList = new List<String>();
        testStringList.add('one');
        testStringList.add('two');
        testStringList.add('three');
        String testString = Randomizer.getRandomString(testStringList);
        
        String testString2 = Randomizer.getRandomPickListValue(new Account(), 'Industry', true);
        String testString3 = Randomizer.getRandomPickListValue(new Account(), 'Industry', false);
        
        Map<String,List<String>> testMap = Randomizer.getPicVals(new Account());
        
        test.stopTest();
        
        String testString4 = Randomizer.getPlaceholderText(300);
    }
}