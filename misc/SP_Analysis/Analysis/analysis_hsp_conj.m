clc
clearvars
load('data_hsp.mat')

FPS = 250; % Hz
TRIGGER = 1000; % milliseconds
INIT = 1.2*(TRIGGER/1000) * FPS;
DURATION = 6; % seconds
DATA_STREAM = ["eyelink", "adhawk", "target"];

struct_out = struct;

index = 1;
for n=1:13
    subjectID = string(['AE' sprintf( '%02d', n )]);
    dataEL = subject_data.(subjectID).dva_EL;
    dataAH = subject_data.(subjectID).dva_AH;

    close('all')

    for trial=1:length(dataEL)
        disp([char(subjectID) '_' num2str(trial)])

        tarFREQ = info_target.FrequencyX(trial);
        tarPHASE = info_target.phaseX(trial);
        if tarPHASE==180
            tarAMP = -9;
        else
            tarAMP = 9;
        end

        % get trial data
        dvaEL = dataEL{trial}(INIT:end,1:2);
        dvaAH = dataAH{trial}(INIT:end,1:2);

        dvaALL = {dvaEL, dvaAH, 0*dvaEL};

        for s=1:length(DATA_STREAM)
            stream = DATA_STREAM(s);
            dva = dvaALL{s};

            % zero data
            dva = dva - dva(1,:);
            
            % get conjugacy
            conj = mean(dva(:,1) - dva(:,2), 'omitmissing');
    
            % store data
            struct_out(index).subject = n;
            struct_out(index).id = string(subjectID);
            struct_out(index).trial = trial;
            struct_out(index).stream = stream;
            struct_out(index).freq = tarFREQ;
            struct_out(index).amp = tarAMP;
            struct_out(index).conj = conj;

            % increment index
            index = index + 1;
        end
    end
end

% Create table
table_out = struct2table(struct_out);

% Export table
writetable(table_out, './export/conj_hsp.csv')