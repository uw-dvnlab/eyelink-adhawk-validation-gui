STREAM = 1; % 1: R, 2: L, 3: Both
FPS = 250; % Hz
TRIGGER = 1000; % milliseconds
DURATION = 6; % seconds
LEN = 256; % samples
INIT = 1.2*(TRIGGER/1000) * FPS;
LIMS = [-12, 12];
THRESH_POS = 30; % deg
THRESH_VEL = 30; % deg/s
THRESH_ACC = 800; % deg/s/s

% TABLE: trial, freqTAR, ampTAR, freqEL, freqAH, ampAH, ampEL, [nEL], [nAH], efEL, efAH
dataOut = [];
dataOutSin = [];
dataOutLine = [];
close all
for STREAM=1:2
    if STREAM==1
        EYE="right";
    else
        EYE="left";
    end
    for TRIAL = [1:30]
        % Get Target
        tarFREQ = handles.target.FrequencyX(TRIAL);
        tarAMP = 9;
        timeTAR = (1:DURATION*FPS)/FPS;
        degTAR = tarAMP*sin((2*pi*tarFREQ)*timeTAR)';
        if handles.target.phaseX(TRIAL)==180
            degTAR = -1*degTAR;
        end
        % Get Blinks
        blink = handles.trial_data(TRIAL).EL.blinkL(INIT:end);
        if ~any(blink)
            % Get Raw
            degEL = handles.trial_data(TRIAL).degX_EL(:,STREAM);
            degAH = handles.trial_data(TRIAL).degX_AH(:,STREAM);
            if ~checkData(degEL, INIT) && ~checkData(degAH, INIT)
                disp(num2str(TRIAL))
                % Line fit
                outTAR_slope = metricLinearFit(tarFREQ, degTAR, INIT, FPS, THRESH_POS, THRESH_VEL);
                [outEL_slope, linEL] = metricLinearFit(tarFREQ, degEL, INIT, FPS, THRESH_POS, THRESH_VEL);
                [outAH_slope, linAH] = metricLinearFit(tarFREQ, degAH, INIT, FPS, THRESH_POS, THRESH_VEL);
                labels_linear = ["target_slope", "el_slope", "ah_slope"];
                labels_linear_gain = ["el_slope_gain", "ah_slope_gain"];
                % Sin fit
                [outEL_freq, outEL_amp, tEL, dEL, sinEL] = metricSinFit(handles.target.FrequencyX(TRIAL), degEL, INIT, FPS, THRESH_POS, THRESH_VEL);
                [outAH_freq, outAH_amp, tAH, dAH, sinAH] = metricSinFit(handles.target.FrequencyX(TRIAL), degAH, INIT, FPS, THRESH_POS, THRESH_VEL);
                labels_sin_freq = ["target_freq", "el_freq", "ah_freq"];
                labels_sin_freq_gain = ["el_freq_gain", "ah_freq_gain"];
                labels_sin_amp = ["target_amp", "el_amp", "ah_amp"];
                labels_sin_amp_gain = ["el_amp_gain", "ah_amp_gain"];
                % Sac Counts
                bins = [0:0.25:1, 2:5];
                outEL_N = metricSacCounts(handles.trial_data(TRIAL).saccadesX_EL, bins);
                outAH_N = metricSacCounts(handles.trial_data(TRIAL).saccadesX_AH, bins);
                labels_sac = [];
                tracker = ["el", "ah"];
                for t=1:2
                    for i=2:length(bins)
                        labels_sac = [labels_sac, string([char(tracker(t)) '_n' strrep(num2str(bins(i)), '.', '_')])];
                    end
                end
                % Noise (FFT)
                start = getSPPeriod(handles.trial_data(TRIAL).saccadesX_EL, handles.trial_data(TRIAL).saccadesX_AH, ...
                    INIT, DURATION, FPS, LEN);
                outEL_Ef = metricFFTNoise(degEL, start, LEN, FPS);
                outAH_Ef = metricFFTNoise(degAH, start, LEN, FPS);
                labels_fft = ["el_meanfreq", "ah_meanfreq"];
            %     % Onsets
            %     phase = handles.target.phaseX(TRIAL);
            %     outEL_on = detectPursuitOnset(degEL, FPS, INIT, handles.SAC_DET);
            %     outAH_on = detectPursuitOnset(degAH, FPS, INIT, handles.SAC_DET);
            %     outEL_on_az = detectPursuitOnset_AZ(degEL, phase, INIT, FPS, handles.SAC_DET);
            %     outAH_on_az = detectPursuitOnset_AZ(degAH, phase, INIT, FPS, handles.SAC_DET);
            %     labels_onset = ["el_onset", "ah_onset", "el_onset_az", "ah_onset_az"];

                % Plot
                figure
                plottools
                hold on
                if (tarFREQ==0.01)
                    mdlEL = linEL;
                    mdlAH = linAH;
                    paramEL = num2str(outEL_slope);
                    paramAH = num2str(outAH_slope);
                    gainEL = num2str(round(1000 * outEL_slope / outTAR_slope)/1000);
                    gainAH = num2str(round(1000 * outAH_slope / outTAR_slope)/1000);
                else
                    mdlEL = sinEL;
                    mdlAH = sinAH;
                    paramEL = ['amp: ' num2str(outEL_amp) ', frq: '  num2str(outEL_freq)];
                    paramAH = ['amp: ' num2str(outAH_amp) ', frq: '  num2str(outAH_freq)];
                    gainEL = ['amp: ' num2str(round(1000 * outEL_amp / tarAMP)/1000) ...
                        ' frq: ' num2str(round(1000 * outEL_freq / tarFREQ)/1000)];
                    gainAH = ['amp: ' num2str(round(1000 * outAH_amp / tarAMP)/1000) ...
                        ' frq: ' num2str(round(1000 * outAH_freq / tarFREQ)/1000)];
                end
                pltEL = plot(mdlEL{1}, mdlEL{2}, mdlEL{3});
                pltAH = plot(mdlAH{1}, mdlAH{2}, mdlAH{3});
                set(pltEL(1),'Color','r','LineStyle',':','LineWidth',2,'Marker','none','DisplayName','');
                set(pltEL(2),'Color','r','LineStyle','-','LineWidth',2,'DisplayName',['fit: ' paramEL]);
                set(pltAH(1),'Color','b','LineStyle',':','LineWidth',2,'Marker','none','DisplayName','');
                set(pltAH(2),'Color','b','LineStyle','-','LineWidth',2,'DisplayName',['fit: ' paramAH]);
                title([num2str(TRIAL) ' : gainEL : ' gainEL ' : gainAH : ' gainAH])
                ylim([-15,15])
                filename = [handles.subject '_' char(EYE) '_trial' sprintf( '%02d', TRIAL ) '.png'];
                saveas(gcf,filename)

                % Compile Data
                dataOut = [dataOut; TRIAL, ...
                    outTAR_slope, outEL_slope, outAH_slope, ...
                    outEL_slope./outTAR_slope, outAH_slope./outTAR_slope, ...
                    tarFREQ, outEL_freq, outAH_freq, ...
                    outEL_freq./tarFREQ, outAH_freq./tarFREQ, ...
                    tarAMP, outEL_amp, outAH_amp, ...
                    outEL_amp./tarAMP, outAH_amp./tarAMP, ...
                    outEL_N, outAH_N, ...
                    outEL_Ef, outAH_Ef, ...
            %         4*(outEL_on - INIT), 4*(outAH_on - INIT), ...
            %         4*(outEL_on_az - INIT), 4*(outAH_on_az - INIT), ...
                    ];
                % Compile Data
                dataOutSin = [dataOutSin; TRIAL, ...
                    tarFREQ, outEL_freq, outAH_freq, ...
                    outEL_freq./tarFREQ, outAH_freq./tarFREQ, ...
                    tarAMP, outEL_amp, outAH_amp, ...
                    outEL_amp./tarAMP, outAH_amp./tarAMP, ...
                    ];
                dataOutLine = [dataOutLine; TRIAL, ...
                    outTAR_slope, outEL_slope, outAH_slope, ...
                    outEL_slope./outTAR_slope, outAH_slope./outTAR_slope, ...
                    ];
            end
        end
    end
end
    
% Array to table
tableOut = array2table(dataOut,...
    'VariableNames', cellstr(...
    ["trial", labels_linear, labels_linear_gain, ...
    labels_sin_freq, labels_sin_freq_gain, ...
    labels_sin_amp, labels_sin_amp_gain, ...
    labels_sac, labels_fft]));

tableOutSin = array2table(dataOutSin,...
    'VariableNames', cellstr(...
    ["trial", ...
    labels_sin_freq, labels_sin_freq_gain, ...
    labels_sin_amp, labels_sin_amp_gain, ...
    ]));

tableOutLine = array2table(dataOutLine,...
    'VariableNames', cellstr(...
    ["trial", labels_linear, labels_linear_gain, ...
    ]));

tableOutSin(tableOutSin.el_freq==-1, :) = [];
tableOutLine(tableOutLine.el_slope==-1, :) = [];

tableOutSin = [array2table(repmat(string(handles.subject), height(tableOutSin), 1), 'VariableNames', {'subject'}), ...
    array2table(repmat(string(EYE), height(tableOutSin), 1), 'VariableNames', {'eye'}), tableOutSin];
tableOutLine = [array2table(repmat(string(handles.subject), height(tableOutLine), 1), 'VariableNames', {'subject'}), ...
    array2table(repmat(string(EYE), height(tableOutLine), 1), 'VariableNames', {'eye'}), tableOutLine];

%%
STREAM = 1; % 1: R, 2: L, 3: Both
FPS = 250; % Hz
TRIGGER = 1000; % milliseconds
DURATION = 6; % seconds
LEN = 256; % samples
INIT = 1.2*(TRIGGER/1000) * FPS;
LIMS = [-12, 12];
THRESH_POS = 30; % deg
THRESH_VEL = 30; % deg/s
THRESH_ACC = 800; % deg/s/s

% TABLE: trial, freqTAR, ampTAR, freqEL, freqAH, ampAH, ampEL, [nEL], [nAH], efEL, efAH
dataOut = [];
dataOutSin = [];
dataOutLine = [];
close all
for STREAM=1:2
    if STREAM==1
        EYE="right";
    else
        EYE="left";
    end
    for TRIAL = [1:length(handles.trial_data)]
        % Get Target
        tarFREQ = handles.target.FrequencyY(TRIAL);
        tarAMP = 9;
        timeTAR = (1:DURATION*FPS)/FPS;
        degTAR = tarAMP*sin((2*pi*tarFREQ)*timeTAR)';
        if handles.target.phaseY(TRIAL)==180
            degTAR = -1*degTAR;
        end
        % Get Blinks
        blink = handles.trial_data(TRIAL).EL.blinkL(INIT:end);
        if ~any(blink)
            % Get Raw
            degEL = -1*handles.trial_data(TRIAL).degY_EL(:,STREAM);
            degAH = -1*handles.trial_data(TRIAL).degY_AH(:,STREAM);
            if ~checkData(degEL, INIT) && ~checkData(degAH, INIT)
                disp(num2str(TRIAL))
                % Line fit
                outTAR_slope = metricLinearFit(tarFREQ, degTAR, INIT, FPS, THRESH_POS, THRESH_VEL);
                [outEL_slope, linEL] = metricLinearFit(tarFREQ, degEL, INIT, FPS, THRESH_POS, THRESH_VEL);
                [outAH_slope, linAH] = metricLinearFit(tarFREQ, degAH, INIT, FPS, THRESH_POS, THRESH_VEL);
                labels_linear = ["target_slope", "el_slope", "ah_slope"];
                labels_linear_gain = ["el_slope_gain", "ah_slope_gain"];
                % Sin fit
                [outEL_freq, outEL_amp, tEL, dEL, sinEL] = metricSinFit(handles.target.FrequencyY(TRIAL), degEL, INIT, FPS, THRESH_POS, THRESH_VEL);
                [outAH_freq, outAH_amp, tAH, dAH, sinAH] = metricSinFit(handles.target.FrequencyY(TRIAL), degAH, INIT, FPS, THRESH_POS, THRESH_VEL);
                labels_sin_freq = ["target_freq", "el_freq", "ah_freq"];
                labels_sin_freq_gain = ["el_freq_gain", "ah_freq_gain"];
                labels_sin_amp = ["target_amp", "el_amp", "ah_amp"];
                labels_sin_amp_gain = ["el_amp_gain", "ah_amp_gain"];
                % Sac Counts
                bins = [0:0.25:1, 2:5];
                outEL_N = metricSacCounts(handles.trial_data(TRIAL).saccadesY_EL, bins);
                outAH_N = metricSacCounts(handles.trial_data(TRIAL).saccadesY_AH, bins);
                labels_sac = [];
                tracker = ["el", "ah"];
                for t=1:2
                    for i=2:length(bins)
                        labels_sac = [labels_sac, string([char(tracker(t)) '_n' strrep(num2str(bins(i)), '.', '_')])];
                    end
                end
                % Noise (FFT)
                start = getSPPeriod(handles.trial_data(TRIAL).saccadesY_EL, handles.trial_data(TRIAL).saccadesY_AH, ...
                    INIT, DURATION, FPS, LEN);
                outEL_Ef = metricFFTNoise(degEL, start, LEN, FPS);
                outAH_Ef = metricFFTNoise(degAH, start, LEN, FPS);
                labels_fft = ["el_meanfreq", "ah_meanfreq"];

%                 % Plot
%                 figure
%                 plottools
%                 hold on
%                 if (tarFREQ==0.01)
%                     mdlEL = linEL;
%                     mdlAH = linAH;
%                     paramEL = num2str(outEL_slope);
%                     paramAH = num2str(outAH_slope);
%                     gainEL = num2str(round(1000 * outEL_slope / outTAR_slope)/1000);
%                     gainAH = num2str(round(1000 * outAH_slope / outTAR_slope)/1000);
%                 else
%                     mdlEL = sinEL;
%                     mdlAH = sinAH;
%                     paramEL = ['amp: ' num2str(outEL_amp) ', frq: '  num2str(outEL_freq)];
%                     paramAH = ['amp: ' num2str(outAH_amp) ', frq: '  num2str(outAH_freq)];
%                     gainEL = ['amp: ' num2str(round(1000 * outEL_amp / tarAMP)/1000) ...
%                         ' frq: ' num2str(round(1000 * outEL_freq / tarFREQ)/1000)];
%                     gainAH = ['amp: ' num2str(round(1000 * outAH_amp / tarAMP)/1000) ...
%                         ' frq: ' num2str(round(1000 * outAH_freq / tarFREQ)/1000)];
%                 end
%                 pltEL = plot(mdlEL{1}, mdlEL{2}, mdlEL{3});
%                 pltAH = plot(mdlAH{1}, mdlAH{2}, mdlAH{3});
%                 set(pltEL(1),'Color','r','LineStyle',':','LineWidth',2,'Marker','none','DisplayName','');
%                 set(pltEL(2),'Color','r','LineStyle','-','LineWidth',2,'DisplayName',['fit: ' paramEL]);
%                 set(pltAH(1),'Color','b','LineStyle',':','LineWidth',2,'Marker','none','DisplayName','');
%                 set(pltAH(2),'Color','b','LineStyle','-','LineWidth',2,'DisplayName',['fit: ' paramAH]);
%                 title([num2str(TRIAL) ' : gainEL : ' gainEL ' : gainAH : ' gainAH])
%                 ylim([-15,15])
%                 filename = [handles.subject '_' char(EYE) '_trial' sprintf( '%02d', TRIAL ) '.png'];
%                 saveas(gcf,filename)

                % Compile Data
                dataOut = [dataOut; TRIAL, ...
                    outTAR_slope, outEL_slope, outAH_slope, ...
                    outEL_slope./outTAR_slope, outAH_slope./outTAR_slope, ...
                    tarFREQ, outEL_freq, outAH_freq, ...
                    outEL_freq./tarFREQ, outAH_freq./tarFREQ, ...
                    tarAMP, outEL_amp, outAH_amp, ...
                    outEL_amp./tarAMP, outAH_amp./tarAMP, ...
                    outEL_N, outAH_N, ...
                    outEL_Ef, outAH_Ef, ...
            %         4*(outEL_on - INIT), 4*(outAH_on - INIT), ...
            %         4*(outEL_on_az - INIT), 4*(outAH_on_az - INIT), ...
                    ];
                % Compile Data
                dataOutSin = [dataOutSin; TRIAL, ...
                    tarFREQ, outEL_freq, outAH_freq, ...
                    outEL_freq./tarFREQ, outAH_freq./tarFREQ, ...
                    tarAMP, outEL_amp, outAH_amp, ...
                    outEL_amp./tarAMP, outAH_amp./tarAMP, ...
                    ];
                dataOutLine = [dataOutLine; TRIAL, ...
                    outTAR_slope, outEL_slope, outAH_slope, ...
                    outEL_slope./outTAR_slope, outAH_slope./outTAR_slope, ...
                    ];
            end
        end
    end
    tableOutSin{STREAM} = array2table(dataOutSin,...
        'VariableNames', cellstr(...
        ["trial", ...
        labels_sin_freq, labels_sin_freq_gain, ...
        labels_sin_amp, labels_sin_amp_gain, ...
        ]));

    tableOutLine{STREAM} = array2table(dataOutLine,...
        'VariableNames', cellstr(...
        ["trial", labels_linear, labels_linear_gain, ...
        ]));

    tableOutSin{STREAM}(tableOutSin{STREAM}.el_freq==-1, :) = [];
    tableOutLine{STREAM}(tableOutLine{STREAM}.el_slope==-1, :) = [];

    tableOutSin{STREAM} = [array2table(repmat(string(handles.subject), height(tableOutSin{STREAM}), 1), 'VariableNames', {'subject'}), ...
        array2table(repmat(string(EYE), height(tableOutSin{STREAM}), 1), 'VariableNames', {'eye'}), tableOutSin{STREAM}];
    tableOutLine{STREAM} = [array2table(repmat(string(handles.subject), height(tableOutLine{STREAM}), 1), 'VariableNames', {'subject'}), ...
        array2table(repmat(string(EYE), height(tableOutLine{STREAM}), 1), 'VariableNames', {'eye'}), tableOutLine{STREAM}];
end

finalOutSin = [tableOutSin{1};tableOutSin{2}];
finalOutLine = [tableOutLine{1};tableOutLine{2}];

%%
close all
hold on
plot(degEL(20:end)-degEL(1), 'g')
plot(degAH-degAH(1), 'r')

%%

%%
plot([outEL_on, outEL_on], [-10,10], 'r')
plot([outAH_on, outAH_on], [-10,10], 'b')
plot([outEL_on_az, outEL_on_az], [-10,10], 'r--')
plot([outAH_on_az, outAH_on_az], [-10,10], 'b--')
plot([INIT, INIT], [-10,10], 'k')
%%
% Zero
degEL = degEL - nanmean(degEL(1:INIT));
degAH = degAH - nanmean(degAH(1:INIT));
% Truncate
degEL = degEL(INIT:end);
degAH = degAH(INIT:end);
% Generate Time
timeTAR = (1:length(degEL))/FPS;
timeEL = (1/FPS:(1/FPS):length(degEL)/FPS)';
timeAH = (1/FPS:(1/FPS):length(degAH)/FPS)';
% Get Velocity
velEL = gradient(degEL) * FPS;
velAH = gradient(degAH) * FPS;
% Filter for Position
timeEL(abs(degEL)>THRESH_POS) = [];
timeAH(abs(degAH)>THRESH_POS) = [];
velEL(abs(degEL)>THRESH_POS) = [];
velAH(abs(degAH)>THRESH_POS) = [];
degEL(abs(degEL)>THRESH_POS) = [];
degAH(abs(degAH)>THRESH_POS) = [];

% Remove NaNs
timeEL(isnan(degEL)) = [];
degEL(isnan(degEL)) = [];
timeAH(isnan(degAH)) = [];
degAH(isnan(degAH)) = [];


mdlEL = fit(timeEL, degEL, 'sin1');
mdlAH = fit(timeAH, degAH, 'sin1');

freqEL = mdlEL.b1 / (2*pi);
freqAH = mdlAH.b1 / (2*pi);
%
% Frequency Gain
freqTAR = handles.target.FrequencyX(TRIAL);
res_fgain_EL = freqEL / freqTAR;
res_fgain_AH = freqAH / freqTAR;

% Get Target Trace
degTAR = 10*sin((2*pi*freqTAR)*timeTAR);
if handles.target.phaseX(TRIAL)==180
    degTAR = -1*degTAR;
end

% Get STRAIGHT (60-120 deg : 3/8 - 5/8 of period)
PERIOD = 1/freqTAR;
TS_LOW = 3*PERIOD/8;
TS_HI = 5*PERIOD/8;
degTARS = degTAR(and(timeTAR>=TS_LOW, timeTAR<TS_HI));
timeTARS = timeTAR(and(timeTAR>=TS_LOW, timeTAR<TS_HI));

close all
hold on
plot(timeEL, degEL, 'b')
plot(timeAH + 0.04, degAH, 'r')
plot(timeTAR, degTAR, 'k:', 'linewidth', 2)
plot(timeTARS, degTARS, 'g', 'linewidth', 2)
%area([TS_LOW, TS_HI], [LIMS(2), LIMS(2)], 'basevalue', LIMS(1), 'alpha', 0.1)
ylim(LIMS)