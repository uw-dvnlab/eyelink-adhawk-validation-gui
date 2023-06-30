function ard_task = getTaskTriggers(handles)
subject = handles.subject;
trialOrder = string(handles.trial_info.(subject));
blockID = trialOrder==string(handles.task);

ard_task = handles.ard_time(blockID).time;