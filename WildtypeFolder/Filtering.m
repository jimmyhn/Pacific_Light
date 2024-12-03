clear; clc; close all;

%% Loading data

files = dir('*.mat');
fileNo = 3; % HERE: can change which file to analyze, eventually turn into for loop
dataFile = load(files(fileNo).name);
forceData = dataFile.F;
%% FFT filtering

N = length(forceData);
ts = 0.01;
fs = 1/ts;
t = 0:ts:ts*(N-1);

X = fft(forceData);
X = abs(X/N);
X = X(1:N/2+1);
f = (0:(N/2))*(fs/N);

fc = 5/fs; 
[b, a] = butter(4, fc/(fs/2), 'low');
y = filter(b, a, forceData);

figure;
title('Raw and Filtered Force Data')
xlabel('Time(s)')
ylabel('Force(pN)')
subplot(2,1,1)
plot(t, forceData)
subplot(2,1,2)
plot(t, y)

%% Histogram generation

posForceData = forceData(forceData>-5);
nForceData = (posForceData - min(posForceData)) / (max(posForceData)- min(posForceData)) * max(forceData) ;
binWidth = .3;
binEdges = 0:binWidth:max(forceData);

bin_counts = histcounts(nForceData,binEdges);
prob_density = bin_counts / (sum(bin_counts) * binWidth);
bin_centers = binEdges(1:end-1) + binWidth / 2;

figure;
bar(bin_centers, prob_density, 'FaceColor', 'k');
xlabel ('Rupture force(pN)')
ylabel ('Estimated probability density (1/pN)')
xlim([0 max(forceData)]);
ylim([0 max(prob_density)*1.1]);

%% Filtering using analysis of polynomial fit of histogram data

% Maybe try filtering out the bars with a probability density of >0.05??
degree = 9; % HERE: adjust polyfit for a more accurate fit
p = polyfit(bin_centers, prob_density, degree);


densityFit = polyval(p, bin_centers);

figure;
hold on

bar(bin_centers, prob_density, 'FaceColor', 'k');
plot(bin_centers, densityFit)
title("Polynomial fit of Force Data Histogram")
xlabel ('Rupture force(pN)')
ylabel ('Estimated probability density (1/pN)')

zeroIdx = find(densityFit(1:end-1) .* densityFit(2:end) < 0);
limitIdx = ones(1, length(bin_centers));
limitIdx(1:zeroIdx(2)) = 0;

zeroCross = bin_centers(zeroIdx);
binLimitValues = [zeroCross(4) zeroCross(5)];
fprintf("The desired curve lies between %2.2f and %2.2f pN.", binLimitValues(1), binLimitValues(2))

figure;

prob_density_filtered = prob_density .* limitIdx;

bar(bin_centers, prob_density_filtered, 'FaceColor', 'k');
xlim([0 40]);
ylim([0 0.1]);
title("Isolated Curve of Single Bond Rupture Events")
xlabel ('Rupture force(pN)')
ylabel ('Estimated probability density (1/pN)')
