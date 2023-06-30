function handles = processTrial(handles, tNo)
raw_EL = handles.trial_data(tNo).EL;
raw_AH = handles.trial_data(tNo).AH;

% Get DVA
[handles.trial_data(tNo).degX_EL, handles.trial_data(tNo).degX_AH] = getDVA(handles.task, raw_EL, raw_AH, 1);
[handles.trial_data(tNo).degY_EL, handles.trial_data(tNo).degY_AH] = getDVA(handles.task, raw_EL, raw_AH, 2);
% Get Filtered Data
handles.trial_data(tNo).degX_EL_filt = filterData(handles.trial_data(tNo).degX_EL, handles.CUT_FREQ);
handles.trial_data(tNo).degY_EL_filt = filterData(handles.trial_data(tNo).degY_EL, handles.CUT_FREQ);
handles.trial_data(tNo).degX_AH_filt = filterData(handles.trial_data(tNo).degX_AH, handles.CUT_FREQ);
handles.trial_data(tNo).degY_AH_filt = filterData(handles.trial_data(tNo).degY_AH, handles.CUT_FREQ);
% Get Saccades
% X
handles.trial_data(tNo).saccadesX_EL = detectSaccades(handles.trial_data(tNo).degX_EL_filt(:,end), ...
    handles.SAC_DET(1), handles.SAC_DET(2), handles.SAC_DET(3));
handles.trial_data(tNo).saccadesX_AH = detectSaccades(handles.trial_data(tNo).degX_AH_filt(:,end), ...
    handles.SAC_DET(1), handles.SAC_DET(2), handles.SAC_DET(3));
% Y
handles.trial_data(tNo).saccadesY_EL = detectSaccades(handles.trial_data(tNo).degY_EL_filt(:,end), ...
    handles.SAC_DET(1), handles.SAC_DET(2), handles.SAC_DET(3));
handles.trial_data(tNo).saccadesY_AH = detectSaccades(handles.trial_data(tNo).degY_AH_filt(:,end), ...
    handles.SAC_DET(1), handles.SAC_DET(2), handles.SAC_DET(3));
end