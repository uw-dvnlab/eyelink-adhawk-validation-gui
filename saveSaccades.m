function handles = saveSaccades(handles)
    h = findobj(handles.ax_x,'Type','line');
    for i=1:length(h)
        LW(i) = h(i).LineWidth;
        LC(i) = strjoin(string(h(i).Color));
        LX(i) = h(i).XData(1);
    end
    sacA = LX(and(LW==2.5, strcmpi(LC, "1 0 1")));
    if handles.chk_el_sac.Value==1
        sacP = LX(and(LW==2.5, strcmpi(LC, "1 0 0")));
        handles.trial_data(handles.trialNo).saccadesX_primary_EL = sacP;
        handles.trial_data(handles.trialNo).saccadesX_marked_EL = sacA;
    elseif handles.chk_ah_sac.Value==1
        sacP = LX(and(LW==2.5, strcmpi(LC, "0 0 1")));
        handles.trial_data(handles.trialNo).saccadesX_primary_AH = sacP;
        handles.trial_data(handles.trialNo).saccadesX_marked_AH = sacA;
    end
    %
    h = findobj(handles.ax_y,'Type','line');
    for i=1:length(h)
        LW(i) = h(i).LineWidth;
        LC(i) = strjoin(string(h(i).Color));
        LX(i) = h(i).XData(1);
    end
    sacA = LX(and(LW==2.5, strcmpi(LC, "1 0 1")));
    if handles.chk_el_sac.Value==1
        sacP = LX(and(LW==2.5, strcmpi(LC, "1 0 0")));
        handles.trial_data(handles.trialNo).saccadesY_primary_EL = sacP;
        handles.trial_data(handles.trialNo).saccadesY_marked_EL = sacA;
    elseif handles.chk_ah_sac.Value==1
        sacP = LX(and(LW==2.5, strcmpi(LC, "0 0 1")));
        handles.trial_data(handles.trialNo).saccadesY_primary_AH = sacP;
        handles.trial_data(handles.trialNo).saccadesY_marked_AH = sacA;
    end
end