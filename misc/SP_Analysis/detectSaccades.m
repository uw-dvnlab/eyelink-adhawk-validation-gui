function saccades = detectSaccades(xPos, tDist, tVelocity, tAcceleration)
% xPos = handles.trial_data(tNo).deg_EL;
% tVelocity = 30; %threshold velocity for saccades (deg/s)
% tAcceleration = 800; %threshold acceleration for saccades (deg/s^2)
% tDist = 0.01; %threshold (Euclidean) distance for saccades (deg)
sample_window = 0.004; %4ms i.e., 250Hz tracking
 
% calculate velocity/acceleration using 5-sample window. See
% Engbert and Kliegl, 2003. Denominator accounts for the
% six sample 'differences' used in numerator (i.e., n-2 to
% n+2 = 4 samples, n-1 to n+1 = 2 samples).
xVel = zeros(size(xPos));
for ii = 3:(length(xPos) - 2) % 2 additional samples chopped off either end (see ~line 230 above)
    xVel(ii) = (xPos(ii + 2) + xPos(ii + 1) - xPos(ii - 1) - xPos(ii - 2))/(6*sample_window);
end
euclidVel = sqrt(xVel.^2);

xAcc = zeros(size(xPos));
for ii = 3:(length(xVel) - 2) % 2 additional samples chopped off either end (see ~line 230 above)
    xAcc(ii) = (xVel(ii + 2) + xVel(ii + 1) - xVel(ii - 1) - xVel(ii - 2))/(6*sample_window);
end
euclidAcc = sqrt(xAcc.^2);

% saccade detection
saccades = [];
candidates = find(euclidVel > tVelocity);
if candidates
    % check for multiple candidate saccades in single
    % trial, using threshold parameters defined at top
    % (see Engbert & Kliegl papers, and Eyelink manual)
    diffCandidates = diff(candidates);
    breaks = [0 find(diffCandidates > 1)' length(candidates)];
    for jj = 1:(size(breaks, 2) - 1)
        % find individual candidate saccades
        saccade = [candidates(breaks(jj) + 1) candidates(breaks(jj + 1))];
        % exceeds acceleration threshold?
        peakAcceleration = max(euclidAcc(saccade(1):saccade(2)));
        if peakAcceleration > tAcceleration
            % exceeds amplitude threshold?
            xDist = xPos(saccade(2)) - xPos(saccade(1));
            euclidDist = abs(xDist);
            if euclidDist > tDist
                % store saccade info
                peakVelocity = max(euclidVel(saccade(1):saccade(2)));
                saccades = [saccades; saccade euclidDist peakVelocity];
            end
        end

    end
end