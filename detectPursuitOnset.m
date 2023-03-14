function pursuit_on = detectPursuitOnset(tNo,handles)
% Method from:
% Carl & Gellman (1987)
warning('off')
FS = 250; %Hz
DT = 1000/FS; % ms
CF_POS = 50; % Hz
CF_VEL = 50; % Hz
STIM_ON = 250; % Samples
WIN = 12/DT; % Samples
RANGE = [100/DT, 80/DT, 40/DT]; % Samples

if handles.trial_data(tNo).check_EL>0
    if handles.trial_data(tNo).check_EL==1
        xPos = handles.trial_data(tNo).deg_EL(:,3); % DVA Both
    elseif handles.trial_data(tNo).check_EL==2
        xPos = handles.trial_data(tNo).deg_EL(:,1); % DVA Right
    elseif handles.trial_data(tNo).check_EL==3
        xPos = handles.trial_data(tNo).deg_EL(:,2); % DVA Left
    end
    % Truncate
    xPos = xPos(STIM_ON-RANGE(1):end);
    time = (1:length(xPos))';% * DT / 1000; % Seconds
    % Get Saccades
    xSac = detectSaccades(xPos, ...
            handles.SAC_DET(1), handles.SAC_DET(2), handles.SAC_DET(3));
    xFilt = filterData(xPos, CF_POS); % DVA
    vFilt = filterData(FS*gradient(xFilt), CF_VEL); % DVA/s    

    if ~isempty(xSac)
        for i=1:size(xSac,1)
            sacOn = xSac(i,1)-WIN;
            sacOff = xSac(i,2)+WIN;
            if sacOn<1
                sacOn = 1;
            end
            if sacOff>length(vFilt)
                sacOff = length(vFilt);
            end
            xFilt(sacOn:sacOff) = NaN;
            vFilt(sacOn:sacOff) = NaN;
        end
    end

    % GET BASELINE WINDOW
    winBase = vFilt(1:RANGE(1)+RANGE(2));
    tBase = time(1:RANGE(1)+RANGE(2));
    coeff_B = polyfit(tBase, winBase, 1);
    fitBase = polyval(coeff_B, tBase);

    % GET STD BASELINE VEL
    sdBase = std(winBase);
    threshBase = 3*sdBase;

    % GET THRESHOLD INSTANT
    idResp = find(abs(vFilt(RANGE(1)+RANGE(2)+1:end)) > threshBase, 1 ) + RANGE(1)+RANGE(2);
    winResp = vFilt(idResp:idResp+RANGE(3));
    tResp = time(idResp:idResp+RANGE(3));
    coeff_R = polyfit(tResp, winResp, 1);
    fitResp = polyval(coeff_R, tResp);

    [x_int,~] = line_intersection(coeff_B,coeff_R);
    pursuit_on = round(x_int) + STIM_ON-RANGE(1);
else
    pursuit_on = NaN;
end