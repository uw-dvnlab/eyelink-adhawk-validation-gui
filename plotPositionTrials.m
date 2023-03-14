function plotPositionTrials(handles)
pltX = handles.ax_x;
pltY = handles.ax_y;
plt = [pltX, pltY];
trialNo = handles.trialNo;
% PLOT TRIAL
FS = 250;
lim_lines = [-15, 15];
time = 1000*(1:length(handles.trial_data(trialNo).degX_EL(:,1)))/FS;
time_ah = 1000*(1:length(handles.trial_data(trialNo).degX_AH(:,1)))/FS;

cla(pltX)
hold(pltX, 'on')
cla(pltY)
hold(pltY, 'on')

% Stimulus
if strcmp(handles.task, 'HSP')
    f = handles.target.FrequencyX(trialNo);
    plot(pltX, time, 10*sin((2*pi*f)*((time-1000)/1000)), 'k:', 'linewidth', 2)
elseif strcmp(handles.task, 'VSP')
    f = handles.target.FrequencyX(trialNo);
    plot(pltY, time, 10*sin((2*pi*f)*((time-1000)/1000)), 'k:', 'linewidth', 2)
end

% CHECK REGION
for i=1:2
    patch(plt(i), [handles.trial_data(trialNo).verg_win(1), handles.trial_data(trialNo).verg_win(1), ...
        handles.trial_data(trialNo).verg_win(2), handles.trial_data(trialNo).verg_win(2)], ...
        [lim_lines(1), lim_lines(2), lim_lines(2), lim_lines(1)], ...
        'g', 'facealpha', 0.1)
end

% Triggers
if strcmp(handles.task, 'HMS') || strcmp(handles.task, 'VMS')
    trig_shift = handles.target.Time(handles.trialNo) / (1000/FS);
    for i=1:2
        plot(plt(i), ...
            1000*[handles.trig_times(2), ...
            handles.trig_times(2)]/FS, lim_lines, 'k-', 'linewidth', 1.5)
        plot(plt(i), ...
            1000*[handles.trig_times(3) + trig_shift, ...
            handles.trig_times(3) + trig_shift]/FS, lim_lines, 'k-', 'linewidth', 1.5)
    end
elseif strcmp(handles.task, 'HSP') || strcmp(handles.task, 'VSP')
    for i=1:2
        plot(plt(i), ...
            [1000, 1000], lim_lines, 'k:', 'linewidth', 1.5)
    end
end
% Raw
% Eyelink
if get(handles.chk_el_raw,'Value')
    plotPos(handles.trial_data(trialNo).check_EL, pltX, time, handles.trial_data(trialNo).degX_EL)
    plotPos(handles.trial_data(trialNo).check_EL, pltY, time, handles.trial_data(trialNo).degY_EL)
end
% AdHawk
if get(handles.chk_ah_raw,'Value')
    plotPos(handles.trial_data(trialNo).check_EL, pltX, time_ah, handles.trial_data(trialNo).degX_AH)
    plotPos(handles.trial_data(trialNo).check_EL, pltY, time_ah, handles.trial_data(trialNo).degY_AH)
end

% Filt
% Eyelink
if get(handles.chk_el_filt,'Value')
    plotPos(handles.trial_data(trialNo).check_EL, pltX, time, handles.trial_data(trialNo).degX_EL_filt)
    plotPos(handles.trial_data(trialNo).check_EL, pltY, time, handles.trial_data(trialNo).degY_EL_filt)
end
% AdHawk
if get(handles.chk_ah_filt,'Value')
    plotPos(handles.trial_data(trialNo).check_EL, pltX, time_ah, handles.trial_data(trialNo).degX_AH_filt)
    plotPos(handles.trial_data(trialNo).check_EL, pltY, time_ah, handles.trial_data(trialNo).degY_AH_filt)
end
% Saccades
% Eyelink
if strcmp(handles.task, 'HMS') || strcmp(handles.task, 'VMS')
    if get(handles.chk_el_sac,'Value')
        plotSac(handles.trial_data(trialNo).saccadesX_EL, ...
            handles.trial_data(trialNo).saccadesX_primary_EL, ...
            handles.trial_data(trialNo).saccadesX_marked_EL, ...
            pltX, handles, lim_lines)
        plotSac(handles.trial_data(trialNo).saccadesY_EL, ...
            handles.trial_data(trialNo).saccadesY_primary_EL, ...
            handles.trial_data(trialNo).saccadesY_marked_EL, ...
            pltY, handles, lim_lines)
    end
    % AdHawk
    if get(handles.chk_ah_sac,'Value')
        plotSac(handles.trial_data(trialNo).saccadesX_AH, ...
            handles.trial_data(trialNo).saccadesX_primary_AH, ...
            handles.trial_data(trialNo).saccadesX_marked_AH, ...
            pltX, handles, lim_lines)
        plotSac(handles.trial_data(trialNo).saccadesY_AH, ...
            handles.trial_data(trialNo).saccadesY_primary_AH, ...
            handles.trial_data(trialNo).saccadesY_marked_AH, ...
            pltY, handles, lim_lines)
    end
end
grid(pltX, 'off')
grid(pltX, 'minor')
xlim(pltX, [0 max(time)])
ylim(pltX, [-15 15])
xlabel(pltX, 'Time (ms)')

grid(pltY, 'off')
grid(pltY, 'minor')
xlim(pltY, [0 max(time)])
ylim(pltY, [-15 15])
xlabel(pltY, 'Time (ms)')
end