function out_onset = detectPursuitOnset_AZ(deg, phase, INIT, FPS, SAC_DET)
% tNo = 7;
% deg = handles.trial_data(tNo).deg_EL_filt(:,3);
% phase = handles.target.phaseX(tNo);
% INIT = 250;
% FPS = 250;
% SAC_DET = handles.SAC_DET;
if phase==180
    deg = deg*-1;
end

warning('off')
close all
DT = 1000/FPS; % ms
CF_POS = 1; % Hz
BASE = 200; % ms
RANGE = (BASE:10*DT:1000) / DT; % Samples

% Truncate
xPos = deg(INIT-BASE/DT:end);
% Get Saccades
xSac = detectSaccades(xPos, ...
        SAC_DET(1), SAC_DET(2), SAC_DET(3));
% Remove Saccades
for i=1:size(xSac,1)
    xPos(xSac(i,1:2)) = NaN;
end
% Get Filtered Data
xFilt = filterData(xPos, CF_POS); % DVA
time = (1:length(xFilt))';% * DT / 1000; % Seconds

figure
hold on
plot(xFilt)
plot(xPos)
%
% xFilt = xPos;
% TRIANGLE METHOD - FIND ONSET + OFFSET
projSz1 = [];
onset = [];
project = [];
% FIND REGION START
for j=1:length(RANGE)
    id = RANGE(j);
    vector = [time(1),xFilt(1); time(id),xFilt(id)];
    plot([time(1), time(id)], [xFilt(1), xFilt(id)], 'm')
    warning('off')
    for i=1:id
        q = [time(i),xFilt(i)];
        p0 = vector(1,:);
        p1 = vector(2,:);
        a = [-q(1)*(p1(1)-p0(1)) - q(2)*(p1(2)-p0(2)); ...
            -p0(2)*(p1(1)-p0(1)) + p0(1)*(p1(2)-p0(2))]; 
        b = [p1(1) - p0(1), p1(2) - p0(2);...
            p0(2) - p1(2), p1(1) - p0(1)];
        projP = -(b\a);
        projP1(i,:) = projP.';
        if diff([q(2) projP(2)])>0
            projSz1(i,1) = sqrt(diff([q(1) projP(1)]).^2+diff([q(2) projP(2)]).^2);
        else
            projSz1(i,1) = 0;
        end
    end

    [szM1,idM1] = max(projSz1);
    plot([time(idM1) projP1(idM1,1)],[xFilt(idM1) projP1(idM1,2)],'r','LineWidth',4)
    scatter(time(idM1),xFilt(idM1),'filled','b')
    onset(j) = idM1;
    project(j) = szM1;
end
out_onset = (max(onset) + INIT - BASE/DT);