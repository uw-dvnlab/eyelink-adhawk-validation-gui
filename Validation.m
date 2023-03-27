function varargout = Validation(varargin)
% VALIDATION MATLAB code for Validation.fig
%      VALIDATION, by itself, creates a new VALIDATION or raises the existing
%      singleton*.
%
%      H = VALIDATION returns the handle to a new VALIDATION or the handle to
%      the existing singleton*.
%
%      VALIDATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VALIDATION.M with the given input arguments.
%
%      VALIDATION('Property','Value',...) creates a new VALIDATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Validation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Validation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Validation

% Last Modified by GUIDE v2.5 28-Feb-2023 00:11:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Validation_OpeningFcn, ...
                   'gui_OutputFcn',  @Validation_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Validation is made visible.
function Validation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Validation (see VARARGIN)
% INIT
handles.task = -1;
% Saccade Params
handles.SAC_DET = [0.01, 30, 800]; % amplitude, velocity, acceleration
% Filter Params
handles.CUT_FREQ = 80; % Hz
% Window Params
handles.WIN = [600, 2400];
% Choose default command line output for Validation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Validation wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Validation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btn_trial.
function btn_trial_Callback(hObject, eventdata, handles)
% hObject    handle to btn_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.xlsx', 'Pick Trial Info file');
if isequal(filename,0)
    disp('User selected Cancel')
else
    disp(['User selected ', fullfile(pathname, filename)]); 
    handles.file_trial = fullfile(pathname, filename);
    handles.trial_info = readtable(handles.file_trial);
    % Update GUI
    set(handles.menu_task,'enable','on');
end
% Update handles structure
guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_loaddata.
function btn_loaddata_Callback(hObject, eventdata, handles)
% hObject    handle to btn_loaddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.task~=-1
    pathname = uigetdir('C:\', 'Select Subject Folder');
    if isequal(pathname,0)
        disp('User selected Cancel')
    else
%         try
            disp(['User selected ', pathname]);
            handles.subject = pathname(end-3:end);
            % Load Eyelink Data
            tic
            f = waitbar(0.2,['Loading Eyelink Data for: ' handles.subject]);
            fname_el = [handles.subject '_' handles.task '_SR.xls'];
            handles.file_el = fullfile(pathname, fname_el);
            handles.tbl_EL = readEyelinkData(handles);
            % Load AdHawk Data
            waitbar(0.6,f,['Loading AdHawk Data for: ' handles.subject]);
            if strcmp(handles.task, 'Pupil')
                fname_ah = [handles.subject '_' handles.task '_gaze_pupil.csv'];
            else
                fname_ah = [handles.subject '_' handles.task '_gaze_per_eye.csv'];
            end
            handles.file_ah = fullfile(pathname, fname_ah);
            handles.tbl_AH = readAdHawkData(handles.file_ah);
            % Load Arduino Data
            waitbar(0.9,f,['Loading Arduino Data for: ' handles.subject]);
            fname_ard = ['Arduino ' handles.subject '.txt'];
            handles.file_ard = fullfile(pathname, fname_ard);
            handles.ard_time = readArduinoTimestamps(handles.file_ard);
            close(f);
            toc
            % Process Data
            guidata(hObject, handles);
            assignin('base','handles',handles)
            handles.trial_data = splitTrials(handles);
            handles.trig_times = getTrigTimes(handles.task);
            handles = processTask(handles);
            handles.trialNo = 1;
            % Plot Data
            handles = plotData(handles);
            setQualityButtons(handles)
            % SET FIGURE LABELS WITH SUBJECT ID
            set(handles.txt_sub_pos, 'String', ['SUBJECT: ' handles.subject]);
            set(handles.txt_sub_vel, 'String', ['SUBJECT: ' handles.subject]);
%         catch
%             ferr = errordlg('Could not load data','File Error');
%         end
    end
else
    disp('CHOOSE TASK FIRST')
end
% Update handles structure
guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on selection change in menu_task.
function menu_task_Callback(hObject, eventdata, handles)
% hObject    handle to menu_task (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_task contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_task
contents = cellstr(get(hObject,'String'));
if strcmp(contents{get(hObject,'Value')}, 'Select Task')
    disp('Please select a task')
    % Update GUI
    set(handles.btn_loaddata,'enable','off');
    set(handles.btn_targetdata,'enable','off');
    set(handles.btn_next,'enable','off');
    set(handles.btn_last,'enable','off');
else
    handles.task = contents{get(hObject,'Value')};
    set(handles.btn_loaddata,'enable','on');
    set(handles.btn_targetdata,'enable','on')
    if strcmp(handles.task, 'HSP') || strcmp(handles.task, 'VSP')
        set(handles.et_win_lo, 'String', 1000);
        set(handles.et_win_hi, 'String', 2000);
        handles.WIN(1)=1000;
        handles.WIN(2)=2000;
    end
end
% Update handles structure
guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_next.
function btn_next_Callback(hObject, eventdata, handles)
% hObject    handle to btn_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = saveSaccades(handles);
if handles.trialNo+1 <= length(handles.trial_data)
    handles.trialNo = handles.trialNo + 1;
else
    disp('End of Trials')
end
% Plot Data
handles.WIN = handles.trial_data(handles.trialNo).verg_win;
setQualityButtons(handles)
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_last.
function btn_last_Callback(hObject, eventdata, handles)
% hObject    handle to btn_last (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = saveSaccades(handles);
if handles.trialNo-1 > 0
    handles.trialNo = handles.trialNo - 1;
else
    disp('Beginning of Trials')
end
% Plot Data
setQualityButtons(handles)
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_process.
function btn_process_Callback(hObject, eventdata, handles)
% hObject    handle to btn_process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.trial_data = splitTrials(handles);
handles.trig_times = getTrigTimes(handles.task);
handles = processTask(handles);
handles = processTask(handles);
handles.trialNo = 1;
% Plot Data
setQualityButtons(handles)
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

function et_filter_Callback(hObject, eventdata, handles)
% hObject    handle to et_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>0 && str2double(get(hObject,'String'))<125
    handles.CUT_FREQ = str2double(get(hObject,'String'));
    handles = processTrial(handles, handles.trialNo);
    % Plot Data
    handles = plotData(handles);
end
guidata(hObject, handles);
assignin('base','handles',handles)

function et_amplitude_Callback(hObject, eventdata, handles)
% hObject    handle to et_amplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SAC_DET(1) = str2double(get(hObject,'String'));
handles = processTrial(handles, handles.trialNo);
% Plot Data
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

function et_velocity_Callback(hObject, eventdata, handles)
% hObject    handle to et_velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SAC_DET(2) = str2double(get(hObject,'String'));
handles = processTrial(handles, handles.trialNo);
% Plot Data
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in chk_el_raw.
function chk_el_raw_Callback(hObject, eventdata, handles)
% hObject    handle to chk_el_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plotData(handles);

% --- Executes on button press in chk_ah_raw.
function chk_ah_raw_Callback(hObject, eventdata, handles)
% hObject    handle to chk_ah_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plotData(handles);

% --- Executes on button press in chk_el_filt.
function chk_el_filt_Callback(hObject, eventdata, handles)
% hObject    handle to chk_el_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plotData(handles);

% --- Executes on button press in chk_ah_filt.
function chk_ah_filt_Callback(hObject, eventdata, handles)
% hObject    handle to chk_ah_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plotData(handles);

% --- Executes on button press in chk_el_sac.
function chk_el_sac_Callback(hObject, eventdata, handles)
% hObject    handle to chk_el_sac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.chk_ah_sac, 'Value', 0);
if handles.chk_el_sac.Value==1
    set(handles.chk_ah_filt, 'Value', 0);
    set(handles.chk_el_filt, 'Value', 1);
end
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in chk_ah_sac.
function chk_ah_sac_Callback(hObject, eventdata, handles)
% hObject    handle to chk_ah_sac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.chk_el_sac, 'Value', 0);
if handles.chk_ah_sac.Value==1
    set(handles.chk_el_filt, 'Value', 0);
    set(handles.chk_ah_filt, 'Value', 1);
end
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

function et_win_hi_Callback(hObject, eventdata, handles)
% hObject    handle to et_win_hi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.WIN(2) = str2double(get(hObject,'String'));
handles = processTrial(handles, handles.trialNo);
guidata(hObject, handles);
% Plot Data
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

function et_win_lo_Callback(hObject, eventdata, handles)
% hObject    handle to et_win_lo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.WIN(1) = str2double(get(hObject,'String'));
handles = processTrial(handles, handles.trialNo);
guidata(hObject, handles);
% Plot Data
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_qnone.
function btn_qnone_Callback(hObject, eventdata, handles)
% hObject    handle to btn_qnone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.rad_el,'Value')==1
    handles.trial_data(handles.trialNo).check_EL = 0;
elseif get(handles.rad_ah,'Value')==1
    handles.trial_data(handles.trialNo).check_AH = 0;
end
setQualityButtons(handles)
handles = processTrial(handles, handles.trialNo);
% Plot Data
handles = plotData(handles);
guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_qboth.
function btn_qboth_Callback(hObject, eventdata, handles)
% hObject    handle to btn_qboth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.rad_el,'Value')==1
    handles.trial_data(handles.trialNo).check_EL = 1;
elseif get(handles.rad_ah,'Value')==1
    handles.trial_data(handles.trialNo).check_AH = 1;
end
setQualityButtons(handles)
handles = processTrial(handles, handles.trialNo);
% Plot Data
handles = plotData(handles);
guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_qright.
function btn_qright_Callback(hObject, eventdata, handles)
% hObject    handle to btn_qright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.rad_el,'Value')==1
    handles.trial_data(handles.trialNo).check_EL = 2;
elseif get(handles.rad_ah,'Value')==1
    handles.trial_data(handles.trialNo).check_AH = 2;
end
setQualityButtons(handles)
handles = processTrial(handles, handles.trialNo);
% Plot Data
handles = plotData(handles);
guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_qleft.
function btn_qleft_Callback(hObject, eventdata, handles)
% hObject    handle to btn_qleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.rad_el,'Value')==1
    handles.trial_data(handles.trialNo).check_EL = 3;
elseif get(handles.rad_ah,'Value')==1
    handles.trial_data(handles.trialNo).check_AH = 3;
end
setQualityButtons(handles)
handles = processTrial(handles, handles.trialNo);
% Plot Data
handles = plotData(handles);
guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_flag.
function btn_flag_Callback(hObject, eventdata, handles)
% hObject    handle to btn_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.rad_el,'Value')==1
    handles.trial_data(handles.trialNo).check_EL = -1;
elseif get(handles.rad_ah,'Value')==1
    handles.trial_data(handles.trialNo).check_AH = -1;
end
setQualityButtons(handles)
handles = processTrial(handles, handles.trialNo);
% Plot Data
handles = plotData(handles);
guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = saveSaccades(handles);
handles = plotData(handles);
guidata(hObject, handles);
saveData(handles);

% --- Executes on button press in rad_el.
function rad_el_Callback(hObject, eventdata, handles)
% hObject    handle to rad_el (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = saveSaccades(handles);
if get(hObject,'Value')==1
    set(handles.rad_ah, 'Value', 0)
    set(handles.chk_ah_filt, 'Value', 0);
    set(handles.chk_ah_sac, 'Value', 0);
    set(handles.chk_el_filt, 'Value', 1);
    set(handles.chk_el_sac, 'Value', 1);
else
    set(hObject, 'Value', 1);
end
setQualityButtons(handles)
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in rad_ah.
function rad_ah_Callback(hObject, eventdata, handles)
% hObject    handle to rad_ah (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = saveSaccades(handles);
if get(hObject,'Value')==1
    set(handles.rad_el, 'Value', 0);
    set(handles.chk_el_filt, 'Value', 0);
    set(handles.chk_el_sac, 'Value', 0);
    set(handles.chk_ah_filt, 'Value', 1);
    set(handles.chk_ah_sac, 'Value', 1);
else
    set(hObject, 'Value', 1);
end
setQualityButtons(handles)
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_targetdata.
function btn_targetdata_Callback(hObject, eventdata, handles)
% hObject    handle to btn_targetdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.task~=-1
    [filename, pathname] = uigetfile('*.xlsx', 'Pick Stimulus Info file');
    if isequal(filename,0)
        disp('User selected Cancel')
    else
        disp(['User selected ', fullfile(pathname, filename)]); 
        handles.file_tar = fullfile(pathname, filename);
        handles.target = loadTargetData(handles);
    end
else
    disp('CHOOSE TASK FIRST')
end
% Update handles structure
guidata(hObject, handles);
assignin('base','handles',handles)

function txt_trial_Callback(hObject, eventdata, handles)
% hObject    handle to txt_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_trial as text
%        str2double(get(hObject,'String')) returns contents of txt_trial as a double
trialNo = str2double(get(hObject,'String'));
if ~isnan(trialNo)
    if trialNo > 0 && trialNo <= length(handles.trial_data)
        handles.trialNo = trialNo;
    else
        disp('Please enter valid trial number')
    end
else
    disp('Please enter valid trial number')
end
% Plot Data
handles = plotData(handles);
% Update handles structure
guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in chk_linestyle.
function chk_linestyle_Callback(hObject, eventdata, handles)
% hObject    handle to chk_linestyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Plot Data
handles = plotData(handles);
guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_save_sac.
function btn_save_sac_Callback(hObject, eventdata, handles)
% hObject    handle to btn_save_sac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = saveSaccades(handles);
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

% --- Executes on button press in btn_fixwin.
function btn_fixwin_Callback(hObject, eventdata, handles)
% hObject    handle to btn_fixwin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plotData(handles);

guidata(hObject, handles);
assignin('base','handles',handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes during object creation, after setting all properties.
function menu_task_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_task (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function et_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function et_amplitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_amplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function et_velocity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function et_win_hi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_win_hi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function et_win_lo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_win_lo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function txt_trial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_plot.
function menu_plot_Callback(hObject, eventdata, handles)
% hObject    handle to menu_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_plot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_plot


% --- Executes during object creation, after setting all properties.
function menu_plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
