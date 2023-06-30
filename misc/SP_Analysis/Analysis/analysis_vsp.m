clc
clearvars
load('data_vsp.mat')

FPS = 250; % Hz
TRIGGER = 1000; % milliseconds
INIT = 1.2*(TRIGGER/1000) * FPS;
DURATION = 6; % seconds
EYE_STREAM = ["right", "left"];

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
        
        for stream=1:2 % 1: Right, 2: Left
            disp([char(subjectID) '_' num2str(trial) '_' num2str(stream)])

            dvaEL = dataEL{trial}(INIT:end,stream);
            dvaAH = dataAH{trial}(INIT:end,stream);
            % Vertically Zero
            dvaEL = dvaEL - dvaEL(1);
            dvaAH = dvaAH - dvaAH(1);
            
            timeEL = (1/FPS:(1/FPS):length(dvaEL)/FPS)';
            timeAH = (1/FPS:(1/FPS):length(dvaAH)/FPS)';

            % Create target data
            timeTAR = (1:(DURATION*FPS))'/FPS;
            dvaTAR = tarAMP*sin((2*pi*tarFREQ)*timeTAR);
            
            % Truncate target + stream data to same length
            dataLen = min([length(dvaEL), length(dvaAH), length(dvaTAR)]);

            % Find cross-correlation between target and streams
            [cEL,lagsEL] = xcorr(dvaTAR(1:dataLen),dvaEL(1:dataLen),FPS,'normalized');
            [cAH,lagsAH] = xcorr(dvaTAR(1:dataLen),dvaAH(1:dataLen),FPS,'normalized');
            [cMaxEL, idMaxEL] = max(cEL);
            [cMaxAH, idMaxAH] = max(cAH);
            lagEL = lagsEL(idMaxEL);
            lagAH = lagsAH(idMaxAH);

            % Shift stream data by lag amount
            timeEL = timeEL + lagEL/FPS;
            timeAH = timeAH + lagAH/FPS;

            % Remove saccades
            [timeEL, dvaEL] = removeSaccades(timeEL, dvaEL);
            [timeAH, dvaAH] = removeSaccades(timeAH, dvaAH);

            % Get analysis window
            [timeEL, dvaEL] = truncateWindow(tarFREQ, timeEL, dvaEL);
            [timeAH, dvaAH] = truncateWindow(tarFREQ, timeAH, dvaAH);
            [timeTAR, dvaTAR] = truncateWindow(tarFREQ, timeTAR, dvaTAR);

            % Get linear fit
            mdlEL = fitGain(timeEL, dvaEL);
            mdlAH = fitGain(timeAH, dvaAH);
            mdlTAR = fitGain(timeTAR, dvaTAR);


            % Store data
            struct_out(index).subject = n;
            struct_out(index).id = string(subjectID);
            struct_out(index).trial = trial;
            struct_out(index).stream = EYE_STREAM(stream);
            struct_out(index).freq = tarFREQ;
            struct_out(index).amp = tarAMP;
            struct_out(index).coeff_el = cMaxEL;
            struct_out(index).coeff_ah = cMaxAH;
            struct_out(index).slope_el = mdlEL.p1;
            struct_out(index).slope_ah = mdlAH.p1;
            struct_out(index).slope_tar = mdlTAR.p1;
            struct_out(index).gain_el = mdlEL.p1 / mdlTAR.p1;
            struct_out(index).gain_ah = mdlAH.p1 / mdlTAR.p1;

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

% Create table
table_out = struct2table(struct_out);

% Export table
writetable(table_out, './export/gains_vsp.csv')