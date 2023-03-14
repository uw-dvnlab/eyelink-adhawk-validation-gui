function plotPos(check, plt, time, deg)
linewidth = 2;
markersize = 6;
linestyle = '-';
marker = 'none';
if check==3
    plot(plt, time, deg(:,1) - deg(1,1), 'b', ...
        'linestyle', linestyle, 'linewidth', linewidth, ...
        'marker', marker, 'markersize', markersize)
elseif check==2
    plot(plt, time, deg(:,2) - deg(1,2), 'r', ...
        'linestyle', linestyle, 'linewidth', linewidth, ...
        'marker', marker, 'markersize', markersize)
else
    plot(plt, time, deg(:,1) - deg(1,1), 'b', ...
        'linestyle', linestyle, 'linewidth', linewidth, ...
        'marker', marker, 'markersize', markersize)
    plot(plt, time, deg(:,2) - deg(1,2), 'r', ...
        'linestyle', linestyle, 'linewidth', linewidth, ...
        'marker', marker, 'markersize', markersize)
    plot(plt, time, deg(:,3) - deg(1,3), 'k', ...
        'linestyle', linestyle, 'linewidth', linewidth, ...
        'marker', marker, 'markersize', markersize)
end