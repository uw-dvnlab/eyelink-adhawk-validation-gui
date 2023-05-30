function [time, dva] = removeSaccades(time, dva)
saccades = detectSaccades(dva, 0.01, 30, 800);
for s=1:size(saccades,1)
    id1 = saccades(s,1);
    id2 = saccades(s,2);
    dva(id1:id2) = NaN;
    time(id1:id2) = NaN;
end