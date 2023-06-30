function task_trials = splitTrials(handles)
% SPLIT TRIALS
[idx_trial_EL, idx_trial_AH] = getTrialIndices(handles);

if idx_trial_AH(end, 2) > height(handles.tbl_AH)
    idx_trial_AH(end, 2) = height(handles.tbl_AH);
end

task_trials = struct;
for i=1:min([size(idx_trial_EL,1), size(idx_trial_AH,1)])
    task_trials(i).EL = handles.tbl_EL(idx_trial_EL(i,1):idx_trial_EL(i,2), :);
    task_trials(i).AH = handles.tbl_AH(idx_trial_AH(i,1):idx_trial_AH(i,2), :);
end