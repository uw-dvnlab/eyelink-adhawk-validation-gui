function [timeProcess, degProcess] = processData(deg, INIT, FPS, THRESH_POS, THRESH_VEL, REM_NAN)
    % Truncate
    degProcess = deg(INIT:end);    
    % Zero
    degProcess = degProcess - nanmean(degProcess(1:10));
    % Generate Time
    timeProcess = (1/FPS:(1/FPS):length(degProcess)/FPS)';
    % Get Velocity
    vel = gradient(degProcess) * FPS;
    % Filter for Position
    timeProcess(abs(degProcess)>THRESH_POS) = nan;
    vel(abs(degProcess)>THRESH_POS) = nan;
    degProcess(abs(degProcess)>THRESH_POS) = nan;
    % Filter for Velocity
    degProcess(abs(vel)>THRESH_VEL) = nan;
    timeProcess(abs(vel)>THRESH_VEL) = nan;
    if REM_NAN
        % Remove NaNs
        timeProcess(isnan(degProcess)) = [];
        degProcess(isnan(degProcess)) = [];
    end