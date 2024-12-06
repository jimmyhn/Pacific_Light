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
binCenters = binEdges(1:end-1) + binWidth / 100;

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


X = fft(forceData);
X = abs(X/N);
X = X(1:N/2+1);
f = (0:(N/2))*(fs/N);

fc = 5/fs; 
[b, a] = butter(4, fc/(fs/2), 'low');
y = filter(b, a, forceData);

% Plot Force Data
figureImage = figure;
plot(t, y);
xlabel('Time (s)');
ylabel('Force (pN)');
title(['Force Data - ', selectedFile]);

posForceData = y(y > 0); % Filter negative forces
normalizedForce = (posForceData - min(posForceData)) / range(posForceData) * max(posForceData);
binWidth = 1;
binEdges = min(posForceData):binWidth:max(posForceData);
binCounts = histcounts(normalizedForce, binEdges);
probDensity = binCounts / (sum(binCounts) * binWidth);
binCenters = binEdges(1:end-1) + binWidth / 100;

figureImage = figure;
bar(binCenters, probDensity, 'FaceColor', 'k');
xlabel('Force (pN)');
ylabel('Estimated Probability Density');
title(['Histogram - ', selectedFile]);
xlim([0 max(y)]);
ylim([0 max(probDensity)*1.1]);