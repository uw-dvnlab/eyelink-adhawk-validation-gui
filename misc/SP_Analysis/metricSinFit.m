function [freq, amp, timeProcess, degProcess, sinMDL] = metricSinFit(tarFreq, deg, INIT, FPS, ...
    THRESH_POS, THRESH_VEL)

if tarFreq==0.01
    freq = -1;
    amp = -1;
    timeProcess = -1;
    degProcess = -1;
    sinMDL = {};
else
    [timeProcess, degProcess] = processData(deg, INIT, FPS, THRESH_POS, THRESH_VEL, 1);
        assignin('base', 'degProcess', degProcess)
        assignin('base', 'timeProcess', timeProcess)
    mdl = fit(timeProcess, degProcess, 'sin1');
    freq = mdl.b1 / (2*pi);
    amp = mdl.a1;
    
    sinMDL = {mdl, timeProcess, degProcess};
end