global class scheduleTop10PartnerPurge implements Schedulable{
   global void execute(SchedulableContext SC){
       Top10PartnerPurge t = new Top10PartnerPurge(); 
       t.purgeIt();
   }
}