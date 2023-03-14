function pursuit_on = detectPursuitOnset_CG(deg, FPS, INIT, SAC_DET)
% Method from:
% Carl & Gellman (1987)
warning('off')
DT = 1000/FPS; % ms
CF_POS = 50; % Hz
CF_VEL = 50; % Hz
WIN = 12/DT; % Samples
RANGE = [100/DT, 80/DT, 40/DT]; % Samples

% Truncate
deg = deg(INIT-RANGE(1):end);
time = (1:length(deg))';% * DT / 1000; % Seconds
% Get Saccades
xSac = detectSaccades(deg, ...
        SAC_DET(1), SAC_DET(2), SAC_DET(3));
xFilt = filterData(deg, CF_POS); % DVA
vFilt = filterData(FPS*gradient(xFilt), CF_VEL); % DVA/s    

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

% GET STD BASELINE VEL
sdBase = std(winBase);
threshBase = 3*sdBase;

% GET THRESHOLD INSTANT
idResp = find(abs(vFilt(RANGE(1)+RANGE(2)+1:end)) > threshBase, 1 ) + RANGE(1)+RANGE(2);
winResp = vFilt(idResp:idResp+RANGE(3));
tResp = time(idResp:idResp+RANGE(3));
coeff_R = polyfit(tResp, winResp, 1);

[x_int,~] = line_intersection(coeff_B,coeff_R);
pursuit_on = round(x_int) + INIT-RANGE(1);
