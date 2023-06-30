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
        tarFREQ = info_target.FrequencyX(trial);
        tarPHASE = info_target.phaseX(trial);
        if tarPHASE==180
            tarAMP = 9;
        else
            tarAMP = -9;
        end
        
        % get trial data
        dvaEL = dataEL{trial}(INIT:end,1:2);
        dvaAH = dataAH{trial}(INIT:end,1:2);

        dvaALL = {dvaEL, dvaAH, 0*dvaEL};
        for d=1:2
            datastream = DATA_STREAM(d);
            dva = dvaALL{d};

            for stream=1:2 % 1: Right, 2: Left
                disp([char(subjectID) '_' char(datastream) '_' num2str(trial) '_' num2str(stream)])
    
                dva_eye = dva(INIT:end,stream);
       
                % detect saccades
                saccades = detectSaccades(dva_eye, 0.01, 30, 800);
    
                for sac=1:size(saccades,1)
                    % Store data
                    struct_out(index).subject = n;
                    struct_out(index).id = string(subjectID);
                    struct_out(index).trial = trial;
                    struct_out(index).source = datastream;
                    struct_out(index).stream = EYE_STREAM(stream);
                    struct_out(index).freq = tarFREQ;
                    struct_out(index).amp = tarAMP;
                    struct_out(index).sac_amp = saccades(sac,3);

                    % Iterate
                    index = index + 1;
                end
            end
        end
    end
end

% Create table
table_out = struct2table(struct_out);

% Export table
writetable(table_out, './export/sac_vsp.csv')