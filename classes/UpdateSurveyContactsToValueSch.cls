global class UpdateSurveyContactsToValueSch implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        UpdateSurveyContactsToValue ToValue = new UpdateSurveyContactsToValue();
        database.executebatch(ToValue);
    }
}