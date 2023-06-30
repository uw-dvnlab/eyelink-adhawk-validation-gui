%%
STREAM = 1; % 1: R, 2: L, 3: Both
FPS = 250; % Hz
TRIGGER = 1000; % milliseconds
DURATION = 6; % seconds
LEN = 256; % samples
INIT = 1*(TRIGGER/1000) * FPS;
LIMS = [-12, 12];
THRESH_POS = 30; % deg
THRESH_VEL = 30; % deg/s
THRESH_ACC = 800; % deg/s/s

WINDOW = [1/FPS,2; 0.25,1.25; 2,3]; % 0.01, 0.1, 0.2

% TABLE: trial, freqTAR, ampTAR, freqEL, freqAH, ampAH, ampEL, [nEL], [nAH], efEL, efAH
dataOutLine = [];
close all
for STREAM=2%1:2
    dataOutLine = [];
    if STREAM==1
        EYE="right";
    else
        EYE="left";
    end
    for TRIAL = 1:20%25:30%[1:21, 23:30] %[1:25] %1:length(handles.trial_data) %
        % Get Target
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CHANGE X/Y
        tarFREQ = handles.target.FrequencyX(TRIAL);
%         tarFREQ = handles.target.FrequencyY(TRIAL);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tarAMP = 9;
        timeTAR = (1:(DURATION)*FPS)/FPS;
        degTAR = tarAMP*sin((2*pi*tarFREQ)*timeTAR)';
        degTAR = [zeros(FPS, 1);degTAR];
        timeTAR = (1:(DURATION+1)*FPS)/FPS;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CHANGE X/Y
        if handles.target.phaseX(TRIAL)==0
%         if handles.target.phaseX(TRIAL)==180
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            degTAR = -1*degTAR;
        end
        % Get Blinks
        blink = handles.trial_data(TRIAL).EL.blinkL(INIT:end);
        if ~any(blink)
            % Get Raw
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CHANGE X/Y
            degEL = -1*handles.trial_data(TRIAL).degX_EL(:,STREAM);
            degAH = -1*handles.trial_data(TRIAL).degX_AH(:,STREAM);
%             degEL = -1*handles.trial_data(TRIAL).degY_EL(:,STREAM);
%             degAH = -1*handles.trial_data(TRIAL).degY_AH(:,STREAM);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if ~checkData(degEL, INIT) && ~checkData(degAH, INIT)
                disp(num2str(TRIAL))
                % Line fit
                [outTAR_slope, linTAR] = metricLinearFitWin(tarFREQ, degTAR, INIT, FPS, THRESH_POS, THRESH_VEL, WINDOW);
                [outEL_slope, linEL] = metricLinearFitWin(tarFREQ, degEL, INIT, FPS, THRESH_POS, THRESH_VEL, WINDOW);
                [outAH_slope, linAH] = metricLinearFitWin(tarFREQ, degAH, INIT, FPS, THRESH_POS, THRESH_VEL, WINDOW);
                labels_linear = ["target_slope", "el_slope", "ah_slope"];
                labels_linear_gain = ["el_slope_gain", "ah_slope_gain"];

                % Plot
                figure
                plottools
                hold on

                mdlTAR = linTAR;
                mdlEL = linEL;
                mdlAH = linAH;
                paramEL = num2str(outEL_slope);
                paramAH = num2str(outAH_slope);
                gainEL = num2str(round(1000 * outEL_slope / outTAR_slope)/1000);
                gainAH = num2str(round(1000 * outAH_slope / outTAR_slope)/1000);

                pltTRAW = plot(timeTAR(FPS:end)-1, degTAR(FPS:end), 'k');
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
                dataOutLine = [dataOutLine; TRIAL, tarFREQ, ...
                    outTAR_slope, outEL_slope, outAH_slope, ...
                    outEL_slope./outTAR_slope, outAH_slope./outTAR_slope, ...
                    ];
            end
        end
    end
    tableOutLine{STREAM} = array2table(dataOutLine,...
        'VariableNames', cellstr(...
        ["trial", "freq", labels_linear, labels_linear_gain, ...
        ]));

    tableOutLine{STREAM}(tableOutLine{STREAM}.el_slope==-1, :) = [];

    tableOutLine{STREAM} = [array2table(repmat(string(handles.subject), height(tableOutLine{STREAM}), 1), 'VariableNames', {'subject'}), ...
        array2table(repmat(string(EYE), height(tableOutLine{STREAM}), 1), 'VariableNames', {'eye'}), tableOutLine{STREAM}];
end

finalOutLine = [tableOutLine{1};tableOutLine{2}];