function [time, dva] = truncateWindow(tarFREQ, time, dva)
    WINDOW = [
        0,1;
        0.25,1.25;
        2,3]; % 0.01, 0.1, 0.2
    
    if tarFREQ==0.01
        win = WINDOW(1,:);
    elseif tarFREQ==0.1
        win = WINDOW(2,:);
    elseif tarFREQ==0.2
        win = WINDOW(3,:);
    end
    
    dva(time<win(1)) = NaN;
    dva(time>win(2)) = NaN;
    time(time<win(1)) = NaN;
    time(time>win(2)) = NaN;