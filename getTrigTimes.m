function trig_times = getTrigTimes(task)
if strcmp(task, 'HMS') || strcmp(task, 'VMS')
    trig_times = [0, 250, 500];
else
    trig_times = [0];
end