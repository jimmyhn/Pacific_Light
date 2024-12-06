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
subfolder = listFolder(2).name;
listDataset = dir(fullfile(subfolder,'*.mat'));
oldDir2 = cd(subfolder);
% Second Loop Starts

j=1;
selectedFile = listDataset(34).name;
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

master(j).ForceVsProbabilityHistogram = imgData;
%% 

binForces = [binCenters;probDensity];
binForces(:,1:12) = []; % in the research paper found that generally 12 pN was where unspecified force peak ends
% probably can susbstitute for kaitlyn's filter

maxIndexes = [];

start = 1;
k = start;
a = 1;
while k ~= length(binForces)-1
    for k = start:length(binForces)-1
        if binForces(2,k)>binForces(2,k+1) % if current PD is greater than the next then...
            maxIndexes(a) = k;
            peakIndex = k;
            a = a + 1;
            break
        end
    end
    for k = peakIndex:length(binForces)-1
        if binForces(2,k) < binForces(2,k+1) % if current PD is less than the next then...
            start = k;
            break
        end
    end
end

%find the biggest PD after unspecified PD peak is filtered
for k = 1:length(maxIndexes)
    peakPD(k) = binForces(2,maxIndexes(k));
end

maxPD = max(peakPD);

%find the the force PD that is half the value as the biggest PD (with 0-30
% error)
MarginsMin =  [0,-0.05,0,-0.1,0,-0.15];
MarginsMax = [0.05,0,0.1,0,0.15,0];
y = 0;
for m = 1:length(MarginsMin)
    for k = 1:length(peakPD)
        x = peakPD(k)/maxPD;
        if x <= 0.5+MarginsMin(m) && x >= 0.5+MarginsMax(m)
            firstBondPeakPD = peakPD(k);
            y = 1;
            break
        end
        % there should be another if here accounting for if none of the PD
        % matches with 0.5 with a 0-30% error; may cause problems
    end
    if y == 1
        break
    end
end
% won't work cause historgrams are too different 

for k = 1:length(DFdata)
    if DFdata(k,2) < minFirstBondForce
        DFdata(k,:) = [];
    end
    if DFdata(k,2) > maxFirstBondForce
        DFdata(k,:) = [];
    end
end