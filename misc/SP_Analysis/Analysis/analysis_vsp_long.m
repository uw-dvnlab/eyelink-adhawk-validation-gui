clc
clearvars
load('data_vsp.mat')

FPS = 250; % Hz
TRIGGER = 1000; % milliseconds
INIT = 1.2*(TRIGGER/1000) * FPS;
DURATION = 6; % seconds
EYE_STREAM = ["right", "left"];
DATA_STREAM = ["eyelink", "adhawk"];

struct_out = struct;

index = 1;
for n=1:13
    subjectID = string(['AE' sprintf( '%02d', n )]);
    dataEL = subject_data.(subjectID).dva_EL;
    dataAH = subject_data.(subjectID).dva_AH;
    
    close('all')

    for trial=1:length(dataEL)
        tarFREQ = info_target.FrequencyY(trial);
        tarPHASE = info_target.phaseY(trial);
        if tarPHASE==180
            tarAMP = 9;
        else
            tarAMP = -9;
        end
        
        dvaEL = dataEL{trial}(INIT:end,:);
        dvaAH = dataAH{trial}(INIT:end,:);
        dvaALL = {dvaEL, dvaAH};

        for d=1:2
            datasrc = DATA_STREAM(d);
            for stream=1:2 % 1: Right, 2: Left
                disp([char(subjectID) '_' num2str(trial) '_' char(datasrc) '_' num2str(stream)])
    
                dva = dvaALL{d}(:, stream);
                % Vertically Zero
                dva = dva - dva(1);
                
                time = (1/FPS:(1/FPS):length(dva)/FPS)';
    
                % Create target data
                timeTAR = (1:(DURATION*FPS))'/FPS;
                dvaTAR = tarAMP*sin((2*pi*tarFREQ)*timeTAR);
                
                % Truncate target + stream data to same length
                dataLen = min([length(dva), length(dvaTAR)]);
    
                % Find cross-correlation between target and streams
                [c,lags] = xcorr(dvaTAR(1:dataLen),dva(1:dataLen),FPS/5,'normalized');
                [cMax, idMax] = max(c);
                lag = lags(idMax);
    
                % Shift stream data by lag amount
                time = time + lag/FPS;
    
                % Remove saccades
                [time, dva] = removeSaccades(time, dva);
    
                % Get analysis window
                [time, dva] = truncateWindow(tarFREQ, time, dva);
                [timeTAR, dvaTAR] = truncateWindow(tarFREQ, timeTAR, dvaTAR);
    
                % Remove outliers
                [time, dva] = removeOutliers(time, dva);
    
                % Get linear fit
                mdl = fitGain(time, dva);
                mdlTAR = fitGain(timeTAR, dvaTAR);
    
    
                % Store data
                struct_out(index).subject = n;
                struct_out(index).id = string(subjectID);
                struct_out(index).trial = trial;
                struct_out(index).source = datasrc;
                struct_out(index).stream = EYE_STREAM(stream);
                struct_out(index).freq = tarFREQ;
                struct_out(index).amp = tarAMP;
                struct_out(index).coeff = cMax;
                struct_out(index).slope = mdl.p1;
                struct_out(index).slope_tar = mdlTAR.p1;
                struct_out(index).gain = mdl.p1 / mdlTAR.p1;
    
                % % VISUALS
                % figure
                % plottools
                % hold on
                % plot(timeEL, dvaEL, 'r')
                % plot(timeAH, dvaAH, 'b')
                % plot(timeTAR, dvaTAR, 'k')
                % 
                % plot(mdlEL)
                % plot(mdlAH)
    
                % Iterate
                index = index + 1;
            end
        end
    end
end

% Create table
table_out = struct2table(struct_out);

% Export table
writetable(table_out, './export/gains_vsp_long.csv')