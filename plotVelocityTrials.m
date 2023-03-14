function plotVelocityTrials(handles)
plt_handle = handles.ax_vel;
trialNo = handles.trialNo;
% PLOT TRIAL
FS = 250;
lim_lines = [0, 100];
time = 1000*(1:length(handles.trial_data(trialNo).deg_EL(:,1)))/FS;
time_ah = 1000*(1:length(handles.trial_data(trialNo).deg_AH(:,1)))/FS;

cla(plt_handle)
hold(plt_handle, 'on')
% Triggers
for i=1:length(handles.trig_times)
    plot(plt_handle, ...
        1000*[handles.trig_times(i), handles.trig_times(i)]/FS, lim_lines, 'k-')
end

% Raw
% Eyelink
if get(handles.chk_el_raw,'Value')
    plot(plt_handle, time, abs(FS*gradient(handles.trial_data(trialNo).deg_EL(:,1))), 'b')
    plot(plt_handle, time, abs(FS*gradient(handles.trial_data(trialNo).deg_EL(:,2))), 'r')
    plot(plt_handle, time, abs(FS*gradient(handles.trial_data(trialNo).deg_EL(:,3))), 'k')
end
% AdHawk
if get(handles.chk_ah_raw,'Value')
    plot(plt_handle, time_ah, abs(FS*gradient(handles.trial_data(trialNo).deg_AH(:,1))), 'b')
    plot(plt_handle, time_ah, abs(FS*gradient(handles.trial_data(trialNo).deg_AH(:,2))), 'r')
    plot(plt_handle, time_ah, abs(FS*gradient(handles.trial_data(trialNo).deg_AH(:,3))), 'k')
end

% Filt
% Eyelink
if get(handles.chk_el_filt,'Value')
    plot(plt_handle, time, abs(FS*gradient(handles.trial_data(trialNo).deg_EL_filt(:,1))), 'b')
    plot(plt_handle, time, abs(FS*gradient(handles.trial_data(trialNo).deg_EL_filt(:,2))), 'r')
    plot(plt_handle, time, abs(FS*gradient(handles.trial_data(trialNo).deg_EL_filt(:,3))), 'k')
end
% AdHawk
if get(handles.chk_ah_filt,'Value')
    plot(plt_handle, time_ah, abs(FS*gradient(handles.trial_data(trialNo).deg_AH_filt(:,1))), 'b')
    plot(plt_handle, time_ah, abs(FS*gradient(handles.trial_data(trialNo).deg_AH_filt(:,2))), 'r')
    plot(plt_handle, time_ah, abs(FS*gradient(handles.trial_data(trialNo).deg_AH_filt(:,3))), 'k')
end

% Saccades
% Eyelink
if get(handles.chk_el_sac,'Value')
    if ~isempty(handles.trial_data(trialNo).saccades_EL)
        for i=1:size(handles.trial_data(trialNo).saccades_EL,1)
            sacOn = handles.trial_data(trialNo).saccades_EL(i,1);
            plot(plt_handle, ...
                1000*[sacOn, sacOn]/FS, lim_lines, 'r--')
        end
    end
    if strcmp(handles.task, 'HSP')
        purOn = handles.trial_data(trialNo).onset_EL;
        plot(plt_handle, ...
            1000*[purOn, purOn]/FS, lim_lines, 'g', 'linewidth', 2)
    end
end
% AdHawk
if get(handles.chk_ah_sac,'Value')
    if ~isempty(handles.trial_data(trialNo).saccades_AH)
        for i=1:size(handles.trial_data(trialNo).saccades_AH,1)
            sacOn = handles.trial_data(trialNo).saccades_AH(i,1);
            plot(plt_handle, ...
                1000*[sacOn, sacOn]/FS, lim_lines, 'b--')
        end
    end
end

grid(plt_handle, 'off')
grid(plt_handle, 'minor')
xlim(plt_handle, [0 max(time)])
xlabel(plt_handle, 'Time (ms)')