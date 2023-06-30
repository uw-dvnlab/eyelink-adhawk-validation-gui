function T = readAdHawkData(fileName)
% fileName = 'AE01_HMS_gaze_per_eye.csv';
T = readtable(fileName);

TPC = T.Timestamp_PC;
TSYNC = cellfun(@(x) timeSync(x), ...
    TPC, 'UniformOutput', false);
T.Timestamp = TSYNC;