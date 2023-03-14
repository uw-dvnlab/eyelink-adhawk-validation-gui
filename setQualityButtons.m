function setQualityButtons(handles)
    resetQualityButtons(handles);
    if get(handles.rad_el,'Value')==1
        if handles.trial_data(handles.trialNo).check_EL==0
            set(handles.btn_qnone, 'BackgroundColor', [0.93,0.69,0.13])
        elseif handles.trial_data(handles.trialNo).check_EL==1
            set(handles.btn_qboth, 'BackgroundColor', [0.93,0.69,0.13])
        elseif handles.trial_data(handles.trialNo).check_EL==2
            set(handles.btn_qright, 'BackgroundColor', [0.93,0.69,0.13])
        elseif handles.trial_data(handles.trialNo).check_EL==3
            set(handles.btn_qleft, 'BackgroundColor', [0.93,0.69,0.13])
        elseif handles.trial_data(handles.trialNo).check_EL==-1
            set(handles.btn_flag, 'BackgroundColor', [0.93,0.69,0.13])
        end
    elseif get(handles.rad_ah,'Value')==1
        if handles.trial_data(handles.trialNo).check_AH==0
            set(handles.btn_qnone, 'BackgroundColor', [0.93,0.69,0.13])
        elseif handles.trial_data(handles.trialNo).check_AH==1
            set(handles.btn_qboth, 'BackgroundColor', [0.93,0.69,0.13])
        elseif handles.trial_data(handles.trialNo).check_AH==2
            set(handles.btn_qright, 'BackgroundColor', [0.93,0.69,0.13])
        elseif handles.trial_data(handles.trialNo).check_AH==3
            set(handles.btn_qleft, 'BackgroundColor', [0.93,0.69,0.13])
        elseif handles.trial_data(handles.trialNo).check_AH==-1
            set(handles.btn_flag, 'BackgroundColor', [0.93,0.69,0.13])
        end
    end
end
function resetQualityButtons(handles)
    set(handles.btn_qnone, 'BackgroundColor', [0.94,0.94,0.94])
    set(handles.btn_qboth, 'BackgroundColor', [0.94,0.94,0.94])
    set(handles.btn_qright, 'BackgroundColor', [0.94,0.94,0.94])
    set(handles.btn_qleft, 'BackgroundColor', [0.94,0.94,0.94])
    set(handles.btn_flag, 'BackgroundColor', [0.94,0.94,0.94])
end