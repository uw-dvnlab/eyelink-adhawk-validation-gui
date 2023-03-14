function T = loadTargetData(handles)
fileName = handles.file_tar;
if strcmp(handles.task, 'HMS') || strcmp(handles.task, 'VMS')
    T = readtable(fileName, 'Sheet', handles.task);
elseif strcmp(handles.task, 'HSP') || strcmp(handles.task, 'VSP')
    T = readtable(fileName, 'Sheet', handles.task);
else
    T = -1;
end