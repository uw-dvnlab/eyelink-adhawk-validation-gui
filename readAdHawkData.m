function T = readAdHawkData(fileName)
% fileName = 'AE01_HMS_gaze_per_eye.csv';
% fileName = handles.file_ah;
T = readtable(fileName);

TPC = cellstr(T.Timestamp_PC);
TSYNC = cellfun(@(x) timeSync(x), ...
    TPC, 'UniformOutput', false);
T.Timestamp = TSYNC;