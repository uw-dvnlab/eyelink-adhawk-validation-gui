function [time, dva] = removeOutliers(time, dva)
    % remove outliers
    [dva,idRM] = rmoutliers(dva, "quartiles");
    time(idRM) = [];