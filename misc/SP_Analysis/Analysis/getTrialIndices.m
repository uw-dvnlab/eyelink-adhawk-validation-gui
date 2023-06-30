function [idx_trial_EL, idx_trial_AH] = getTrialIndices(handles)
ard_task = getTaskTriggers(handles);
time_AH = cell2mat(handles.tbl_AH.Timestamp);
idx_trig = 0*ard_task;
for i=1:length(ard_task)
    t_ard = ard_task(i);
    [~,id] = min(abs(time_AH-t_ard));
    idx_trig(i) = id;
end

% GET ADHAWK TRIAL INDICES
if strcmp(handles.task, 'HMS') || strcmp(handles.task, 'VMS')
    trig_per_trial = 3;
    trial_len = 750;
elseif strcmp(handles.task, 'VERG')
    trig_per_trial = 1;
    trial_len = 20000;
else
    trig_per_trial = 1;
    trial_len = 1500;
end
idx_trial_AH = [];
for i=1:trig_per_trial:length(idx_trig)
    idx_trial_AH = [idx_trial_AH; [idx_trig(i), idx_trig(i)+trial_len]];
end

% GET EYELINK TRIAL INDICES
trial_EL = handles.tbl_EL.TRIAL;
trial_No = unique(trial_EL);
idx_trial_EL = [];
for i=1:length(trial_No)
    idx_trial_EL = [idx_trial_EL; ...
        find(trial_EL==trial_No(i), 1 ), ...
        find(trial_EL==trial_No(i), 1, 'last' )];
end