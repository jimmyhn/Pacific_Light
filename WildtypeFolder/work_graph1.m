clc; close all; clear all;
%% Load Data
matlab = pwd;
vscode = 'C:\Users\theon\.vscode\Pacific_Light';
histogramData = load('histograms.mat')

rawData = dir('WT_FI');
dataSheet = load('WT_BB94\WT_BB94_1.mat');
data = dataSheet.F;
forceLimit = histogramData.histograms(1).limits;
forceMin = forceLimit(1);
forceMax = forceLimit(2);
forceRange = forceMax - forceMin;

%{
% Loads all names
for i = 1:length(histogramData.histograms)
    folderName = histogramData.histograms(i).name;
end
% Loads all limits
for i = 1:length(histogramData.histograms)
    forceLimit = histogramData.histograms(i).limits;
end
%}


%% Force Conversion
trapStiffness = 32.5; % Factor from paper
force = data.*(trapStiffness);
cleanForce = [force, repmat(forceRange, size(force))];
sortedForce = sort(cleanForce);

%% Extention Conversion
k = dataSheet.k;
extention = abs(force/k);

%% Graph
figure;
plot(extention,force);
xlabel('Extention (nm)');
ylabel('Force (pN)');

%% Calculating Work
Work = trapz(extention, force);
fprintf('Work: %.4f Hz\n', Work);
