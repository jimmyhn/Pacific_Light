clear; clc; close all

%% HOW TO USE
%{
Run the program and analyze the given curve.
Enter the the lower and upper limits for the single bonding curve
in units of pN.
The script will output a new histogram showing only the specified curve.
Each time you filter a histogram, its data will be saved into the structure
'histograms.mat'. To terminate the program and save your progress,
hit Ctrl + C and then enter the following command into the command window:
save('histograms.mat', 'histograms');
This will save the data for all the histograms you've completed so far
and next time you run the program it will skip those data sets.
%}
%% Loading data

files = dir('*.mat');
load 'histograms.mat';
analyzeData = find(arrayfun(@(x) isempty(x.name), histograms));

for k = analyzeData
clc; close all

fileNo = k;
dataFile = load(files(fileNo).name);
fileMessage = ['Now analyzing ' dataFile.cond];
disp(fileMessage)
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
subplot(2,1,1)
plot(t, forceData)
title('Raw Force Data')
xlabel('Time(s)')
ylabel('Force(pN)')

subplot(2,1,2)
plot(t, y)
title('Filtered Force Data')
xlabel('Time(s)')
ylabel('Force(pN)')

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
title("Force Data Histogram")
xlabel ('Rupture force(pN)')
ylabel ('Estimated probability density (1/pN)')

%% Filtering using user input bin center ranges

LL = input('Enter the number for the lower limit of the desired curve: ');
if isempty(LL)
    continue;
end
UL = input('Enter the number for the upper limit of the desired curve: ');
binLimitValues = [LL UL];

limitIdx = zeros(1, length(bin_centers));
[~, lowerIdx] = min(abs(bin_centers - LL));
[~, upperIdx] = min(abs(bin_centers - UL));
limitIdx(lowerIdx:upperIdx) = 1;

forceLimits = [bin_centers(lowerIdx) bin_centers(upperIdx)];
fprintf("The desired curve lies between %2.2f and %2.2f pN.\n", forceLimits(1), forceLimits(2))

prob_density_filtered = prob_density .* limitIdx;

figure;
hold on

bar(bin_centers, prob_density_filtered, 'FaceColor', 'k');
xlim([0 40]);
ylim([0 0.1]);
title("Isolated Curve of Single Bond Rupture Events")
xlabel ('Rupture force(pN)')
ylabel ('Estimated probability density (1/pN)')

histograms(k).name = dataFile.cond;
histograms(k).binCenters = bin_centers;
histograms(k).probDensity = prob_density_filtered;
histograms(k).limits = forceLimits;

%% Normal distribution fit to the filtered curve

bin_counts_filtered = bin_counts .* limitIdx;
avg = sum(bin_centers .* bin_counts_filtered) / sum(bin_counts_filtered);
variance = sum(bin_counts_filtered .* (bin_centers - avg).^2) / sum(bin_counts_filtered);
stdDev = sqrt(variance);

% HERE: Normalization for standard curve is a bit off, not sure what factor
% to multiply by
pdfValues = 0.015*normpdf(bin_centers, avg, stdDev);
plot(bin_centers, pdfValues)

histograms(k).pdfVals = pdfValues;

input('Press enter to continue: ', 's')
end
