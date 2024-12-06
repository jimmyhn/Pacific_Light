close all; clear
% Creating Structure To Store Everything
master = struct();
%%
% Define the the folder datasets to analyze
subfolder = "WildtypeFolder";
listFolder = dir(subfolder);
listFolder = listFolder([listFolder.isdir]);
listFolder = listFolder(~ismember({listFolder.name},{'.','..'}));

% Loops Starts
oldDir1 = cd(subfolder);
subfolder = listFolder(1).name;
listDataset = dir(fullfile(subfolder,'*.mat'));
oldDir2 = cd(subfolder);
% Second Loop Starts

j=1;
selectedFile = listDataset(1).name;
master(j).name = selectedFile;

data = load(selectedFile);
forceData = data.F;

N = length(forceData);
ts = 0.01;
fs = 1/ts;
t = 0:ts:ts*(N-1);

% Plot Force Data
figureImage = figure;
plot(t, forceData);
xlabel('Time (s)');
ylabel('Force (pN)');
title(['Force Data - ', selectedFile]);
frame = getframe(figureImage);
imgData = frame.cdata;

master(j).TimeVsForceGraph = imgData;


% Plot Histogram
posForceData = forceData(forceData > 0); % Filter negative forces
normalizedForce = (posForceData - min(posForceData)) / range(posForceData) * max(posForceData);
binWidth = 1;
binEdges = min(posForceData):binWidth:max(posForceData);
binCounts = histcounts(normalizedForce, binEdges);
probDensity = binCounts / (sum(binCounts) * binWidth);
binCenters = binEdges(1:end-1);

figureImage = figure;
bar(binCenters, probDensity, 'FaceColor', 'k');
xlabel('Force (pN)');
ylabel('Estimated Probability Density');
title(['Histogram - ', selectedFile]);
xlim([0 max(forceData)]);
ylim([0 max(probDensity)*1.1]);
frame = getframe(figureImage);
imgData = frame.cdata;

%% 
binForces = [binCenters;probDensity];
binForces(:,1:12) = []; % in the research paper found that generally 12 pN was where unspecified force peak ends
% probably can susbstitute for kaitlyn's filter

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

%find the biggest PD after unspecified PD peak is filtered
for k = 1:length(maxIndexes)
    peakPD(k) = binForces(2,maxIndexes(k));
end

% i give up
% this section as was suppose to highlight the bins with the max peaks
% after the unspecified filter had gotten rid of the big peak

%from their the app would let you see max peaks, and you would decide which
% one was first bond, and enter in the bin number of that peak
%% 
binNumber = 8; 
firstBondForcePeak = binForces(1,binNumber);

for k = binNumber:-1:2 %finding the min limit of the first bond peak
    if binForces(2,k)<binForces(2,k-1) %if current is less than the previous (going left)
        minFirstBondForce = binForces(1,k);
        break
    end
end

for k = binNumber:length(binForces)-1 %finding the max limit of the first bond peak
    if binForces(2,k)<binForces(2,k+1) %if current is less than the next (going right)
        maxFirstBondForce = binForces(1,k);
        break
    end
end

% filtering out forces not in bounds
DFdata = posForceData;
%{
DFdata(DFdata(:,1)<minFirstBondForce)= [];
DFdata(DFdata(:,1)>maxFirstBondForce)= [];
%}
%coverting force data to distance (x = -F/k)
distanceData = DFdata./data.k;
DFdata = [distanceData,DFdata];
            DFdata = sortrows(DFdata,1);
            
            xData = DFdata(:,1);
            yData = DFdata(:,2);
            
            % Find the intersection points with y = firstBondPDPeak
            intersectionIndex = find(yData >= firstBondForcePeak,1);
            
            % Plot the main data
            figure
            plot(app.Work, xData, yData);
            xlabel(app.Work, 'Extension (um)');
            ylabel(app.Work, 'Force (pN)');
            title(app.Work, "Extension Vs Force Graph");
