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
handles.trial_data(tNo).saccadesX_primary_EL = [];
handles.trial_data(tNo).saccadesX_primary_AH = [];
handles.trial_data(tNo).saccadesX_marked_EL = [];
handles.trial_data(tNo).saccadesX_marked_AH = [];
% Y
handles.trial_data(tNo).saccadesY_EL = detectSaccades(handles.trial_data(tNo).degY_EL_filt(:,end), ...
    handles.SAC_DET(1), handles.SAC_DET(2), handles.SAC_DET(3));
handles.trial_data(tNo).saccadesY_AH = detectSaccades(handles.trial_data(tNo).degY_AH_filt(:,end), ...
    handles.SAC_DET(1), handles.SAC_DET(2), handles.SAC_DET(3));
handles.trial_data(tNo).saccadesY_primary_EL = [];
handles.trial_data(tNo).saccadesY_primary_AH = [];
handles.trial_data(tNo).saccadesY_marked_EL = [];
handles.trial_data(tNo).saccadesY_marked_AH = [];
% Vergence
handles.trial_data(tNo).verg_win = handles.WIN;
% % Get Pursuit Timestamps
% if strcmp(handles.task, 'HSP')
%     % X
%     handles.trial_data(tNo).onsetX_EL = detectPursuitOnset_CG( ...
%         handles.trial_data(tNo).degX_EL_filt(:,3), 250, 250, handles.SAC_DET);
%     handles.trial_data(tNo).onsetX_AH = detectPursuitOnset_CG( ...
%         handles.trial_data(tNo).degX_AH_filt(:,3), 250, 250, handles.SAC_DET);
%     handles.trial_data(tNo).onsetX_EL_az = detectPursuitOnset_AZ( ...
%         handles.trial_data(tNo).degX_EL_filt(:,3), handles.target.phaseX(tNo), 250, 250, handles.SAC_DET);
%     handles.trial_data(tNo).onsetX_AH_az = detectPursuitOnset_AZ( ...
%         handles.trial_data(tNo).degX_AH_filt(:,3), handles.target.phaseX(tNo), 250, 250, handles.SAC_DET);
%     % Y
%     handles.trial_data(tNo).onsetY_EL = detectPursuitOnset_CG( ...
%         handles.trial_data(tNo).degY_EL_filt(:,3), 250, 250, handles.SAC_DET);
%     handles.trial_data(tNo).onsetY_AH = detectPursuitOnset_CG( ...
%         handles.trial_data(tNo).degY_AH_filt(:,3), 250, 250, handles.SAC_DET);
%     handles.trial_data(tNo).onsetY_EL_az = detectPursuitOnset_AZ( ...
%         handles.trial_data(tNo).degY_EL_filt(:,3), handles.target.phaseX(tNo), 250, 250, handles.SAC_DET);
%     handles.trial_data(tNo).onsetY_AH_az = detectPursuitOnset_AZ( ...
%         handles.trial_data(tNo).degY_AH_filt(:,3), handles.target.phaseX(tNo), 250, 250, handles.SAC_DET);
end