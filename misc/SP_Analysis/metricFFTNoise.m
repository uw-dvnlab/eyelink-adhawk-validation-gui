function E = metricFFTNoise(deg, start, LEN, FPS)
    if start>0
        X = deg(start:start+LEN);
        if ~any(isnan(X))
            % Detrend
            X = X - mean(X);

            L = length(X);             % Length of signal
            if mod(L,2)
                L = length(X)-1;
                X = X(1:L);
            end

            Y = fft(X);

            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            % Norm
            P1 = P1./sum(P1);
            f = (FPS*(0:(L/2))/L)';

        %         hold on
        %     plot(f,P1) 
        %     title("Single-Sided Amplitude Spectrum of X(t)")
        %     xlabel("f(Hz)")
        %     ylabel("|P1(f)|")

            % Expected Value
            E = sum(f.*P1);
        else
            E = -1;
        end
    else
        E = -1;
    end