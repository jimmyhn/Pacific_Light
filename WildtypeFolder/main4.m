            selectedFile = "WT_BB94_9.mat";
            data = load(selectedFile);
            forceData = data.F;  % Assuming 'F' is the force data
            time = 0:(length(forceData) - 1);  % Generate time points
            N = length(forceData);
            forceData = data.F;
            ts = 0.01;
            fs = 1/ts;
            X = fft(forceData);
            X = abs(X/N);

            fc = 5/fs; 
            [b, a] = butter(4, fc/(fs/2), 'low');
            y = filter(b, a, forceData); 

            figure
            plot(time, forceData);
            xlabel('Time (s)');
            ylabel('Force (pN)');
            title(['Force Data - ', selectedFile]);

            figure
            plot(time, y);
            xlabel('Time (s)');
            ylabel('Force (pN)');
            title(['Filtered Force Data - ', selectedFile]);

            posForceData = forceData(forceData > 0); % Filter negative forces
            normalizedForce = (posForceData - min(posForceData)) / range(posForceData) * max(posForceData);
            binWidth = 1;
            binEdges = min(posForceData):binWidth:max(posForceData);
            binCounts = histcounts(normalizedForce, binEdges);
            probDensity = binCounts / (sum(binCounts) * binWidth);
            binCenters = binEdges(1:end-1);
            
            binForces = [binCenters;probDensity];
            k = 1;
            a = 1;
            maxIndexes = [];
            lookingForPeak = true;
            
            while k < length(binForces) - 1
                if lookingForPeak
                    % Look for a peak
                    if binForces(2, k) > binForces(2, k + 1)
                        maxIndexes(a) = k;
                        a = a + 1;
                        lookingForPeak = false; % Switch to looking for a trough
                    end
                else
                    % Look for a trough
                    if binForces(2, k) < binForces(2, k + 1)
                        lookingForPeak = true; % Switch to looking for a peak
                    end
                end
                k = k + 1;
            end
