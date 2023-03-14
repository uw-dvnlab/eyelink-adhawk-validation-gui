function [muR, muL, stdR, stdL] = computeFixationSTD(handles)
    % Right
    dataXR = handles.trial_data(handles.trialNo).degX_EL_filt(:,1);
    dataYR = handles.trial_data(handles.trialNo).degY_EL_filt(:,1);
    if handles.chk_ah_sac.Value==1
        dataXR = handles.trial_data(handles.trialNo).degX_AH_filt(:,1);
        dataYR = handles.trial_data(handles.trialNo).degY_AH_filt(:,1);
    end
    win = handles.trial_data(handles.trialNo).verg_win;
    datXR = dataXR(round(win(1)/4):round(win(2)/4));
    datYR = dataYR(round(win(1)/4):round(win(2)/4));
    muR = round(100*[3*nanmean(datXR), 3*nanmean(datYR)])/100;
    stdR = round(100*[3*nanstd(datXR), 3*nanstd(datYR)])/100;
    % Left
    dataXL = handles.trial_data(handles.trialNo).degX_EL_filt(:,2);
    dataYL = handles.trial_data(handles.trialNo).degY_EL_filt(:,2);
    if handles.chk_ah_sac.Value==1
        dataXL = handles.trial_data(handles.trialNo).degX_AH_filt(:,2);
        dataYL = handles.trial_data(handles.trialNo).degY_AH_filt(:,2);
    end
    win = handles.trial_data(handles.trialNo).verg_win;
    datXL = dataXL(round(win(1)/4):round(win(2)/4));
    datYL = dataYL(round(win(1)/4):round(win(2)/4));
    muL = round(100*[3*nanmean(datXL), 3*nanmean(datYL)])/100;
    stdL = round(100*[3*nanstd(datXL), 3*nanstd(datYL)])/100;
end