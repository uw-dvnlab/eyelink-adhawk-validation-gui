function timeStamps = readArduinoTimestamps(fileName)
fileID = fopen(fileName,'r');
A = textscan(fileID,'%s %s','Delimiter',{' -> '});
fclose(fileID);

taskNo = 1;
timeStamps = struct;
timeStamps(taskNo).time = [];
for i=1:length(A{1})
    tidx = A{2}{i};
    tstamp = A{1}{i};
    if strcmp(tidx, '1')
        timeStr = strsplit(tstamp, ':');
        hour = str2double(timeStr{1});
        minute = str2double(timeStr{2});
        sec = str2double(timeStr{3});
        timeStamps(taskNo).time = [timeStamps(taskNo).time; ...
            hour*60*60 + minute*60 + sec];
    elseif strcmp(tidx, '')
        taskNo = taskNo + 1;
        timeStamps(taskNo).time = [];
    end
end