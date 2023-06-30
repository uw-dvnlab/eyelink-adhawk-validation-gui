function [slope, linMDL] = metricLinearFit(tarFreq, deg, INIT, FPS, THRESH_POS, THRESH_VEL)
if tarFreq==0.01
    [timeProcess, degProcess] = processData(deg, INIT, FPS, THRESH_POS, THRESH_VEL, 1);
    assignin('base', 'degProcess', degProcess)
    assignin('base', 'timeProcess', timeProcess)
    mdl = fit(timeProcess, degProcess, 'poly1');
    slope = mdl.p1;
    
    linMDL = {mdl, timeProcess, degProcess};
else
    slope = -1;
    linMDL = {};
end