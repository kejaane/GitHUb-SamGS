/*
 * 04-25-2017    Bill Dodson  |T01|  Modify to use allow test classes to reset the flag.
 */
public Class checkRecursive{
    @testVisible // T01
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}