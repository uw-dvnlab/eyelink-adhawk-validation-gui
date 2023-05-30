function tbl_EL = readEyelinkData(handles)
fileName = handles.file_el;
fileID = fopen(fileName,'r');
A = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','Delimiter',{'\t'});
fclose(fileID);

% Trial
trial = A{2};
trialNo = cellfun(@(x) strrep(x, 'Trial: ', ''), ...
    trial, 'UniformOutput', false);

% Left Gaze
if strcmp(handles.subject, 'AE01') || strcmp(handles.subject, 'AE02') ...
        || strcmp(handles.subject, 'AE98') || strcmp(handles.subject, 'AE99')
    gazeLX = A{5};
    gazeLY = A{6};
    gazeLP = A{9};
    % Right Gaze
    gazeRX = A{10};
    gazeRY = A{11};
    gazeRP = A{14};
    % Blink
    gazeBlinkL = A{7};
    gazeBlinkR = A{12};
elseif strcmp(handles.subject, 'AE12') || strcmp(handles.subject, 'AE13')
    gazeLX = A{5};
    gazeLY = A{6};
    gazeLP = A{5};
    % Right Gaze
    gazeRX = A{7};
    gazeRY = A{8};
    gazeRP = A{7};
    % Blink
    gazeBlinkL = A{9};
    gazeBlinkR = A{10};        
else 
    gazeLX = A{4};
    gazeLY = A{5};
    gazeLP = A{4};
    % Right Gaze
    gazeRX = A{6};
    gazeRY = A{7};
    gazeRP = A{6};
    % Blink
    gazeBlinkL = A{8};
    gazeBlinkR = A{9};
end
cellGaze = [trialNo, gazeLX, gazeLY, gazeLP, gazeRX, gazeRY, gazeRP, gazeBlinkL, gazeBlinkR];
matELGaze = cell2mat( ...
    cellfun(@(x) str2double(x), ...
    cellGaze(2:end, :), 'UniformOutput', false));

tbl_EL = array2table(matELGaze, 'VariableNames', cellstr(["TRIAL", "LX", "LY", "LP", "RX", "RY", "RP", "blinkL", "blinkR"]));