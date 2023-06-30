function exclude = checkData(deg, INIT)
    % Truncate
    deg = deg(INIT:end);
    if (sum(isnan(deg)) / length(deg)) > 0.25
        exclude = true;
    else
        exclude = false;
    end
    