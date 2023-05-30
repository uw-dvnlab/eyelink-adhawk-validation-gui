function start = getSPPeriod(sac_EL, sac_AH, INIT, DURATION, FPS, LEN)
    saccades = [sac_EL; sac_AH];
    saccades = [saccades; [INIT, INIT, 0, 0]; [DURATION*FPS, DURATION*FPS, 0, 0]];
    saccades = sortrows(saccades, 1);
    saccades(saccades(:,1)<INIT, :) = [];
    saccades(saccades(:,1)>DURATION*FPS, :) = [];
    inter_time = saccades(2:size(saccades,1),1) - saccades(1:size(saccades,1)-1,2);
    [~,id] = max(inter_time);
    if inter_time(id) > LEN % 1024ms
        start = saccades(id,2);
    else
        start = -1;
    end