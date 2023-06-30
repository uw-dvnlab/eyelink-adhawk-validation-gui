function Y = filterData(X, cF)
% Filter
Fs = 250;
Wn = cF/(Fs/2);
[b,a] = butter(2,Wn);
for c=1:size(X,2)
    % Spline interpolation
    data = fillmissing(X(:,c),'linear');
    Y(:,c) = filtfilt(b,a,data);
end