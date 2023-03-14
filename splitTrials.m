function task_trials = splitTrials(handles)
% SPLIT TRIALS
[idx_trial_EL, idx_trial_AH] = getTrialIndices(handles);
assignin('base','handles',handles)
if strcmp(handles.task, 'HMS')
    trig_per_trial = 3;
    trig_time = [0, 250, 500];
end
task_trials = struct;
for i=1:size(idx_trial_EL,1)
    task_trials(i).EL = handles.tbl_EL(idx_trial_EL(i,1):idx_trial_EL(i,2), :);
    task_trials(i).AH = handles.tbl_AH(idx_trial_AH(i,1):idx_trial_AH(i,2), :);
    % DATA QUALITY
    task_trials(i).check_EL = 1; % -1 - Flag; 0 - None; 1 - Both; 2 - Right; 3 - Left
    task_trials(i).check_AH = 1; % -1 - Flag; 0 - None; 1 - Both; 2 - Right; 3 - Left
end