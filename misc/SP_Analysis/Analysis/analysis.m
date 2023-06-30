FPS = 250; % Hz
TRIGGER = 1000; % milliseconds
INIT = 1.2*(TRIGGER/1000) * FPS;

for n=1%:13
    subjectID = string(['AE' sprintf( '%02d', n )]);
    dataEL = subject_data.(subjectID).dva_EL;
    dataAH = subject_data.(subjectID).dva_AH;
    
    for trial=1%:30
        tarFREQ = info_target.FrequencyX(trial);
        tarAMP = 9;
        
        for stream=1%:2 % 1: Right, 2: Left
            dvaEL = dataEL{trial}(INIT:end,stream);
            dvaAH = dataAH{trial}(INIT:end,stream);
            % Vertically Zero
            dvaEL = dvaEL - mean(dvaEL,"omitmissing");
            dvaAH = dvaAH - mean(dvaAH,"omitmissing");
            
            timeEL = (1/FPS:(1/FPS):length(dvaEL)/FPS)';
            timeAH = (1/FPS:(1/FPS):length(dvaAH)/FPS)';
            
            hold on
            plot(timeEL, dvaEL)
            plot(timeAH, dvaAH)
            
            mdl = 'sin1';
            options = fitoptions(mdl, 'Robust', 'Bisquare');
            options.Lower = [tarAMP tarFREQ*2*pi -Inf];
            options.Upper = [tarAMP tarFREQ*2*pi Inf];
            options.StartPoint = [tarAMP tarFREQ*2*pi 0];
            mdlEL = fit(timeEL, dvaEL, mdl, options);
            mdlAH = fit(timeAH, dvaAH, mdl, options);
            
            plot(mdlEL)
            plot(mdlAH)
        end
    end
end