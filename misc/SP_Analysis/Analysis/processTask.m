function handles = processTask(handles)
for tNo = 1:length(handles.trial_data)
    handles = processTrial(handles, tNo);
end