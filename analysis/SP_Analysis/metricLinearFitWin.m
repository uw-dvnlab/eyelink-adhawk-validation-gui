function [slope, linMDL] = metricLinearFitWin(tarFreq, deg, INIT, FPS, THRESH_POS, THRESH_VEL, WINDOW)
if tarFreq==0.01
    win = WINDOW(1,:);
elseif tarFreq==0.1
    win = WINDOW(2,:);
elseif tarFreq==0.2
    win = WINDOW(3,:);
end

[timeProcess, degProcess] = processData(deg, INIT, FPS, THRESH_POS, THRESH_VEL, 1);

timeProcess = timeProcess(round(win(1)*FPS):round(win(2)*FPS));
degProcess = degProcess(round(win(1)*FPS):round(win(2)*FPS));

assignin('base', 'degProcess', degProcess)
assignin('base', 'timeProcess', timeProcess)
mdl = fit(timeProcess, degProcess, 'poly1');
slope = mdl.p1;

linMDL = {mdl, timeProcess, degProcess};
end