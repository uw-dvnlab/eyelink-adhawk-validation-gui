function handles = saveSaccades(handles)
    if strcmp(handles.task, 'HMS')
        h = findobj(handles.ax_x,'Type','line');
    elseif strcmp(handles.task, 'VMS')
        h = findobj(handles.ax_y,'Type','line');
    end
    for i=1:length(h)
        LW(i) = h(i).LineWidth;
        LC(i) = strjoin(string(h(i).Color));
        LX(i) = h(i).XData(1);
    end
    sacA = LX(and(LW==2.5, strcmpi(LC, "1 0 1")));
    if handles.chk_el_sac.Value==1
        sacP = LX(and(LW==2.5, strcmpi(LC, "1 0 0")));
        handles.trial_data(handles.trialNo).saccades_primary_EL = sacP;
        handles.trial_data(handles.trialNo).saccades_marked_EL = sacA;
    elseif handles.chk_ah_sac.Value==1
        sacP = LX(and(LW==2.5, strcmpi(LC, "0 0 1")));
        handles.trial_data(handles.trialNo).saccades_primary_AH = sacP;
        handles.trial_data(handles.trialNo).saccades_marked_AH = sacA;
    end
end