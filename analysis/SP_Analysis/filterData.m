function Y = filterData(X, cF)
nanWin = 25;
Fs = 250;
Wn = cF/(Fs/2);
[b,a] = butter(2,Wn);
% % Remove window about non-finite values
% nanID = find(isnan(X));
% for i=1:length(nanID)
%     if nanID(i)-nanWin<=0
%         X(1:nanID(i)+nanWin) = NaN;
%     elseif nanID(i)+nanWin>=length(X)
%         X(nanID(i)-nanWin:end) = NaN;
%     else
%         X(nanID(i)-nanWin:nanID(i)+nanWin) = NaN;
%     end
% end
for c=1:size(X,2)
    % Spline interpolation
    data = fillmissing(X(:,c),'linear');
    % Filter
    Y(:,c) = filtfilt(b,a,data);
end