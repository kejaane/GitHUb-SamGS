Public Class SBU_CaseFieldUpdate{
    public Static void CaseFieldUpdateOnEmailOrigin(List<Case> caseList){
        for (Case cs: caseList){
            if (cs.origin == 'Email: Broker Sales MD'){
                cs.SLA_Category__c = 'Broker Sales Support';
                cs.Broker_service_team__c ='Broker Sales MD';
            }
            if (cs.origin == 'Email: Broker Sales 4'){
                cs.SLA_Category__c = 'Broker Sales Support';
                cs.Broker_service_team__c ='Broker Sales 4';
            }
            if(cs.origin == 'Email: Retro activity Request'){
                cs.SLA_Category__c = 'Broker Sales Support';
                cs.Broker_service_team__c ='Retro activity Request';
            }
            if(cs.origin == 'Email: SBC Project'){
                cs.SLA_Category__c = 'Broker Sales Support';
                cs.Broker_service_team__c ='SBC Project';
            }
            if(cs.origin == 'Email: BCS Specialist'){
                cs.SLA_Category__c = 'Broker Sales Support';
                cs.Broker_service_team__c ='BCS Specialist';
            }
            if(cs.origin == 'Email: Small Medium Group'){
                cs.SLA_Category__c = 'Non-Platinum';
                cs.Broker_service_team__c ='Small Medium Group';
            }
            if(cs.origin == 'Email: Royal'){
                cs.SLA_Category__c = 'Platinum';
                cs.Broker_service_team__c ='Team Royal';
            }
            if(cs.origin == 'Email: Indigo'){
                cs.SLA_Category__c = 'Platinum';
                cs.Broker_service_team__c ='Team Indigo';
            }
            if(cs.origin == 'Email: Ocean'){
                cs.SLA_Category__c = 'Platinum';
                cs.Broker_service_team__c ='Team Ocean';
            }
            if(cs.origin == 'Email: Sapphire'){
                cs.SLA_Category__c = 'Platinum';
                cs.Broker_service_team__c ='Team Sapphire';
            }
            if(cs.origin == 'Email: Sky')
            {
                cs.SLA_Category__c = 'Platinum';
                cs.Broker_service_team__c ='Team Sky';
            }
            
            if(cs.origin == 'Email: Teal'){
                cs.SLA_Category__c = 'Platinum';
                cs.Broker_service_team__c ='Team Teal';
            }
            if(cs.origin == 'Email: Compliance'){
                cs.SLA_Category__c = 'Broker Compliance';
                cs.Broker_service_team__c ='Compliance';
            }
        }
    }
}