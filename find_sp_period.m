data = handles.trial_data;
target = handles.target.FrequencyX;
trial_times = [];
sp_data = struct;
FS = 250;
for i=1:length(data)
    time = 1000*(1:length(data(i).deg_EL(:,1)))/FS;
    if (~isempty(data(i).saccades_EL))
        sac_id = sort([250; data(i).saccades_EL(:,1); 1500]);
    else
        sac_id = [250;1500];
    end
    sac_id(sac_id<250) = [];
    inter_time = diff(sac_id) * 4;
    [~,id] = max(inter_time);
    trial_times(i,:) = [sac_id(id), sac_id(id+1)];
    
    sp_data(i).data = data(i).deg_EL(trial_times(i,1):trial_times(i,2),3) - data(i).deg_EL(1,3);
    sp_data(i).time = time(trial_times(i,1):trial_times(i,2))';
    if length(sp_data(i).data)>0
        X = sp_data(i).time(1:125)/1000;
        Y = sp_data(i).data(1:125);
        X(isnan(Y)) = [];
        Y(isnan(Y)) = [];
        mdl = fit(X,Y,'sin1');
        X2 = sp_data(i).time(1:end)/1000;
        Y2 = sp_data(i).data(1:end);
        X2(isnan(Y2)) = [];
        Y2(isnan(Y2)) = [];
        mdl2 = fit(X2,Y2,'sin1');

        f = target(i);
%         subplot(1,2,1)
%         hold on
%         plot(mdl,X,Y,'predfunc')
%         plot(time/1000, feval(mdl, time/1000))
%         plot(time/1000, 10*sin((2*pi*f)*(time/1000-1)), 'k', 'linewidth', 2)
%         subplot(1,2,2)
%         hold on
%         plot(mdl2,X2,Y2,'predfunc')
%         plot(time/1000, feval(mdl2, time/1000))
%         plot(time/1000, 10*sin((2*pi*f)*(time/1000-1)), 'k', 'linewidth', 2)
        
        results(i,:) = [mdl.b1/(2*pi), mdl2.b1/(2*pi), target(i)];
    else
        results(i,:) = [-1, -1, target(i)];
    end
end

%%
t_invalid = trial_times;
t_invalid(t_invalid>1000) = NaN;
t_invalid2 = trial_times;
t_invalid2(t_invalid2>500) = NaN;

% close all
figure
plottools
title('AE06')
hold on
bar(trial_times)
bar(t_invalid)
bar(t_invalid2)
plot([0,30],[1000,1000],'k','linewidth',2)
plot([0,30],[500,500],'k','linewidth',2)
ylabel('Longest SP Period (ms)')
xlabel('Trial #')