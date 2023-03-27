function saveData(handles)
if ~strcmp(handles.task, 'VERG')
    [file,path] = uiputfile('C:\', 'Save .mat File', '*.mat');
    if isequal(file,0) || isequal(path,0)
        disp('User clicked Cancel.')
    else
        disp(['User selected ',fullfile(path,file),...
             ' and then clicked Save.'])
        save(fullfile(path,file),'-struct','handles','trial_data')
    end
else
    el_fixation_data = cell2mat({handles.trial_data.fixation_EL}');
    ah_fixation_data = cell2mat({handles.trial_data.fixation_AH}');
    el_fixation_data = [repmat("EL", size(el_fixation_data, 1), 1), el_fixation_data];
    ah_fixation_data = [repmat("AH", size(ah_fixation_data, 1), 1), ah_fixation_data];
    fixation_data = [el_fixation_data; ah_fixation_data];
    if size(el_fixation_data, 1)>0
        labels = ["tracker", "trial", "win_start", "win_end", "r_mu_x", "r_mu_y", "r_std_x", "r_std_y", "l_mu_x", "l_mu_y", "l_std_x", "l_std_y"];
        tbl_fix = array2table(fixation_data, 'VariableNames', cellstr(labels));

        [file,path] = uiputfile('C:\', 'Save .csv File', '*.csv');
        if isequal(file,0) || isequal(path,0)
            disp('User clicked Cancel.')
        else
            disp(['User selected ',fullfile(path,file),...
                 ' and then clicked Save.'])
            writetable(tbl_fix, fullfile(path,file));
        end
    end
end