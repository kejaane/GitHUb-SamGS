global class UpdateSurveyContactsToNullSch implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        UpdateSurveyContactsToNull Tonull = new UpdateSurveyContactsToNull();
        database.executebatch(Tonull);
    }
}