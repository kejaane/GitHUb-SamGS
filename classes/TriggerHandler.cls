/*=========================================================================================
 * Date			: 10/21/2014
 * Developer	: Ken Gill
 * Purpose   	: This is the base class for the Trigger framework and defines the interface methods that need
 *                to be implemented by specific trigger handlers that extend the framework. It provides a default
 *                no-operation (NOP) implementation of all the extension methods so that trigger handler classes 
 *                only have to implement methods that they care to define behavior for. The class defines a common run()
 *                method that should be invoked from the trigger class. For example:
 *               
 *                trigger ContactTrigger on Contact (after delete, after insert, after undelete, 
 *                              after update, before delete, before insert, before update) {
 *						new ContactTriggerHandler().run();
 * 				  }
 *
 *                This class implements recursion protection and implements a 5-level nesting which can be custom set to 
 *                an arbitrary level on a case by case basis if needed.
 *                Further the class allows handlers to be bypassed by configuring bypass by passing in name of handler to be
 *                bypassed. This can be useful for deployments and testing.
 *                
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/21/14  |  KG	  |	Initial Version                                         
 * 11/15/16  |  KG    |	Add framework methods **Processed() to provide a mechanism to mark records processed in a Transaction
 *           |        | context so if needed certain logic like future calls can be prevented from duplication if the intent
 *           |        | is to have the logic only run once in a transaction/trigger context.
 *           |  	  |	
 *===========+============+================================================================
 */
 
 public virtual class TriggerHandler {

  // static map of handlername, times run() was invoked
  private static Map<String, LoopCount> loopCountMap;
  private static Set<String> bypassedHandlers;

  // the current context of the trigger, overridable in tests
  @TestVisible
  private TriggerContext context;

  // the current context of the trigger, overridable in tests
  @TestVisible
  private Boolean isTriggerExecuting;

  private static Set <Id> idSet = new Set <Id>();
  // static initialization
  static {
    loopCountMap = new Map<String, LoopCount>();
    bypassedHandlers = new Set<String>();
  }
  
  // constructor
  public TriggerHandler() {
    this.setTriggerContext();
  }

  /***************************************
   * public instance methods
   ***************************************/

/*   
 * The following  *AlreadyProcessed() methods can be used to prevent certain code from being run more 
 * than once in a single transaction context where a Trigger fires multiple times scenarios.
 * Example: Prevent a future call being made twice when a trigger fires twice in same context- first based on record update and second time
 * based on a workflow that updates a field on the record causing a re-trigger.
 
 * Note - this logic aims to prevent repeat execution of code logic on a per record basis which is fine
 * grained control and does not block at a trigger level (i.e. does not block all records from)
 * being processed, just the ones that are already processed).
 * 
 * Code credit: Code based on example idioms outlined by Rajat Paharia, Others at:  
 * http://salesforce.stackexchange.com/questions/109/workflow-rule-causing-trigger-to-fire-twice
 *
 *                Example Use:
 *                 if (!TriggerHandler.isAlreadyProcessed(Obj.Id)) {
 *                    // do your processing
 *                     TriggerHandler.setAlreadyProcessed(Obj.Id, Obj);
 *                 }
 */ 
 
	// static map to store records marked as processed 
   @TestVisible
  private static Map <Id,SObject> recordMap = new Map <Id, SObject>();

    // has this record Id been processed? 
    public static boolean isAlreadyProcessed(Id objectId) {
        return (recordMap.get(objectId) != null);
    }
    
    public static SObject getAlreadyProcessed( Id objectId) {
    	return (SObject) (recordMap.get( objectId ));
    }

	public static void removeAlreadyProcessed( Id objectId) {
		recordMap.remove( objectId );
	}
	
    // set that this Id has been processed.
    public static void setAlreadyProcessed(Id objectId, SObject processedRecord) {
        recordMap.put(objectId, processedRecord);
    }
 
 /* --- end methods for processing specific records only once in a transcation context with multiple retriggers */
   

  // main method that will be called during execution
  public void run() {

    if(!validateRun()) return;

    addToLoopCount();

    // dispatch to the correct handler method
    if(this.context == TriggerContext.BEFORE_INSERT) {
      this.beforeInsert();
    } else if(this.context == TriggerContext.BEFORE_UPDATE) {
      this.beforeUpdate();
    } else if(this.context == TriggerContext.BEFORE_DELETE) {
      this.beforeDelete();
    } else if(this.context == TriggerContext.AFTER_INSERT) {
      this.afterInsert();
    } else if(this.context == TriggerContext.AFTER_UPDATE) {
      this.afterUpdate();
    } else if(this.context == TriggerContext.AFTER_DELETE) {
      this.afterDelete();
    } else if(this.context == TriggerContext.AFTER_UNDELETE) {
      this.afterUndelete();
    }

  }

  public void setMaxLoopCount(Integer max) {
    String handlerName = getHandlerName();
    if(!TriggerHandler.loopCountMap.containsKey(handlerName)) {
      TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
    } else {
      TriggerHandler.loopCountMap.get(handlerName).setMax(max);
    }
  }

  public void clearMaxLoopCount() {
    this.setMaxLoopCount(-1);
  }

  /***************************************
   * public static methods
   ***************************************/

  public static void bypass(String handlerName) {
    TriggerHandler.bypassedHandlers.add(handlerName);
  }

  public static void clearBypass(String handlerName) {
    TriggerHandler.bypassedHandlers.remove(handlerName);
  }

  public static Boolean isBypassed(String handlerName) {
    return TriggerHandler.bypassedHandlers.contains(handlerName);
  }

  public static void clearAllBypasses() {
    TriggerHandler.bypassedHandlers.clear();
  }

  /***************************************
   * private instancemethods
   ***************************************/

  @TestVisible
  private void setTriggerContext() {
    this.setTriggerContext(null, false);
  }

  @TestVisible
  private void setTriggerContext(String ctx, Boolean testMode) {
    if(!Trigger.isExecuting && !testMode) {
      this.isTriggerExecuting = false;
      return;
    } else {
      this.isTriggerExecuting = true;
    }
    
    if((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
        (ctx != null && ctx == 'before insert')) {
      this.context = TriggerContext.BEFORE_INSERT;
    } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
        (ctx != null && ctx == 'before update')){
      this.context = TriggerContext.BEFORE_UPDATE;
    } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
        (ctx != null && ctx == 'before delete')) {
      this.context = TriggerContext.BEFORE_DELETE;
    } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
        (ctx != null && ctx == 'after insert')) {
      this.context = TriggerContext.AFTER_INSERT;
    } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
        (ctx != null && ctx == 'after update')) {
      this.context = TriggerContext.AFTER_UPDATE;
    } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
        (ctx != null && ctx == 'after delete')) {
      this.context = TriggerContext.AFTER_DELETE;
    } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
        (ctx != null && ctx == 'after undelete')) {
      this.context = TriggerContext.AFTER_UNDELETE;
    }
  }

  // increment the loop count
  @TestVisible
  private void addToLoopCount() {
    String handlerName = getHandlerName();
    if(TriggerHandler.loopCountMap.containsKey(handlerName)) {
      Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();
      if(exceeded) {
        Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
        throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
      }
    }
  }

  // make sure this trigger should continue to run
  @TestVisible
  private Boolean validateRun() {
    if(!this.isTriggerExecuting || this.context == null) {
      throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
    }
    if(TriggerHandler.bypassedHandlers.contains(getHandlerName())) {
      return false;
    }
    return true;
  }

  @TestVisible
  public String getHandlerName() {
    return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
  }

  /***************************************
   * context methods
   ***************************************/

  // context-specific methods for override
  @TestVisible
  protected virtual void beforeInsert(){}
  @TestVisible
  protected virtual void beforeUpdate(){}
  @TestVisible
  protected virtual void beforeDelete(){}
  @TestVisible
  protected virtual void afterInsert(){}
  @TestVisible
  protected virtual void afterUpdate(){}
  @TestVisible
  protected virtual void afterDelete(){}
  @TestVisible
  protected virtual void afterUndelete(){}

  /***************************************
   * inner classes
   ***************************************/

  // inner class for managing the loop count per handler
  @TestVisible
  private class LoopCount {
    private Integer max;
    private Integer count;

    public LoopCount() {
      this.max = 5;
      this.count = 0;
    }

    public LoopCount(Integer max) {
      this.max = max;
      this.count = 0;
    }

    public Boolean increment() {
      this.count++;
      return this.exceeded();
    }

    public Boolean exceeded() {
      if(this.max < 0) return false;
      if(this.count > this.max) {
        return true;
      }
      return false;
    }

    public Integer getMax() {
      return this.max;
    }

    public Integer getCount() {
      return this.count;
    }

    public void setMax(Integer max) {
      this.max = max;
    }
  }

  // possible trigger contexts
  @TestVisible
  private enum TriggerContext {
    BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
    AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
    AFTER_UNDELETE
  }

  // exception class
  public class TriggerHandlerException extends Exception {}

}