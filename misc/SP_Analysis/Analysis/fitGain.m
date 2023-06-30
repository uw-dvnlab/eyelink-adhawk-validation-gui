function mdl = fitGain(time, dva)
    VALID = 200; % ms
    DT = 4; % ms

    % correspond nan
    time(isnan(dva)) = NaN;
    dva(isnan(time)) = NaN;
    % remove nan
    time(isnan(time)) = [];
    dva(isnan(dva)) = [];
    
    if length(dva) > (VALID/DT)
        % fit slope
        mdl = fit(time, dva, 'poly1');
    else
        mdl = struct;
        mdl.p1 = NaN;
    end