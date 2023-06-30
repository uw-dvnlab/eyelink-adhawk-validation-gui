function t = timeSync(string)
if contains(string, 'T')
    tstamp = strsplit(string,'T');
else
    tstamp = strsplit(string,' ');
end
tstampT = strsplit(tstamp{2},':');
hour = str2double(tstampT{1});
minute = str2double(tstampT{2});
sec = str2double(tstampT{3});
t = hour*60*60 + minute*60 + sec;