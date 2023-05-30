handles = struct;
for n=1:13
    subjectID(n,1) = string(['AE' sprintf( '%02d', n )]);
end

% Set Task
handles.task = 'VSP';
% Saccade Params
handles.SAC_DET = [0.01, 30, 800]; % amplitude, velocity, acceleration
% Filter Params
handles.CUT_FREQ = 80; % Hz

% Load Trial Info
[filename, pathname] = uigetfile('*.xlsx', 'Pick Trial Info file');
handles.file_trial = fullfile(pathname, filename);
handles.trial_info = readtable(handles.file_trial);

% Load Stimulus Info
[filename, pathname] = uigetfile('*.xlsx', 'Pick Stimulus Info file');
handles.file_tar = fullfile(pathname, filename);
info_target = loadTargetData(handles);

% Load Data
datapath = uigetdir('C:\', 'Select Data Directory');
subject_data = struct;

for n=1:length(subjectID)
    handles.subject = char(subjectID(n));
    
    % Eyelink data
    f = waitbar(0.2,['Loading Eyelink Data for: ' handles.subject]);
    fname_el = [handles.subject '_' handles.task '_SR.xls'];
    handles.file_el = fullfile(datapath, handles.subject, fname_el);
    handles.tbl_EL = readEyelinkData(handles);
    
    % AdHawk data
    waitbar(0.6,f,['Loading AdHawk Data for: ' handles.subject]);
    fname_ah = [handles.subject '_' handles.task '_gaze_per_eye.csv'];
    handles.file_ah = fullfile(datapath, handles.subject, fname_ah);
    handles.tbl_AH = readAdHawkData(handles.file_ah);
    
    % Arduino data
    waitbar(0.9,f,['Loading Arduino Data for: ' handles.subject]);
    fname_ard = ['Arduino ' handles.subject '.txt'];
    handles.file_ard = fullfile(datapath, handles.subject, fname_ard);
    handles.ard_time = readArduinoTimestamps(handles.file_ard);
    close(f);
    
    % Process data
    handles.trial_data = splitTrials(handles);
    handles = processTask(handles);
    
    if strcmp(handles.task, 'HSP')
        subject_data.(handles.subject).dva_EL = {handles.trial_data.degX_EL_filt}';
        subject_data.(handles.subject).dva_AH = {handles.trial_data.degX_AH_filt}';
    elseif strcmp(handles.task, 'VSP')
        subject_data.(handles.subject).dva_EL = {handles.trial_data.degY_EL_filt}';
        subject_data.(handles.subject).dva_AH = {handles.trial_data.degY_AH_filt}';
    end
end
