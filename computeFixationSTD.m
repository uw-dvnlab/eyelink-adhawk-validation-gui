function [muR, muL, stdR, stdL, handles] = computeFixationSTD(handles)
    % Right
    dataXR = handles.trial_data(handles.trialNo).degX_EL_filt(:,1);
    dataYR = handles.trial_data(handles.trialNo).degY_EL_filt(:,1);
    if handles.rad_ah.Value==1
        dataXR = handles.trial_data(handles.trialNo).degX_AH_filt(:,1);
        dataYR = handles.trial_data(handles.trialNo).degY_AH_filt(:,1);
    end
    win = handles.trial_data(handles.trialNo).verg_win;
    datXR = dataXR(round(win(1)/4):round(win(2)/4));
    datYR = dataYR(round(win(1)/4):round(win(2)/4));
    datXR = datXR - datXR(1);
    datYR = datYR - datYR(1);
    muR = round(100*[3*nanmean(datXR), 3*nanmean(datYR)])/100;
    stdR = round(100*[3*nanstd(datXR), 3*nanstd(datYR)])/100;
    % Left
    dataXL = handles.trial_data(handles.trialNo).degX_EL_filt(:,2);
    dataYL = handles.trial_data(handles.trialNo).degY_EL_filt(:,2);
    if handles.rad_ah.Value==1
        dataXL = handles.trial_data(handles.trialNo).degX_AH_filt(:,2);
        dataYL = handles.trial_data(handles.trialNo).degY_AH_filt(:,2);
    end
    win = handles.trial_data(handles.trialNo).verg_win;
    datXL = dataXL(round(win(1)/4):round(win(2)/4));
    datYL = dataYL(round(win(1)/4):round(win(2)/4));
    datXL = datXL - datXL(1);
    datYL = datYL - datYL(1);
    muL = round(100*[3*nanmean(datXL), 3*nanmean(datYL)])/100;
    stdL = round(100*[3*nanstd(datXL), 3*nanstd(datYL)])/100;
    % Save Data
    if handles.rad_el.Value==1
        handles.trial_data(handles.trialNo).fixation_EL = [handles.trialNo, win(1), win(2), muR, stdR, muL, stdL];
    else
        handles.trial_data(handles.trialNo).fixation_AH = [handles.trialNo, win(1), win(2), muR, stdR, muL, stdL];
    end
end