clear; clc; close all;
ruptureData = readtable("Raw Rupture Values.xlsx");
t = ruptureData(:,1);
voltageData = ruptureData(:,2);
distanceData = ruptureData(:,3);
forceData = ruptureData(:,4);

%% Control Rupture Data

t = table2array(t);
voltageData = table2array(voltageData);
distanceData = table2array(distanceData);
forceData = table2array(forceData);
posForceData = forceData(forceData>-1); % Could be normalized as well but it creates a field of smaller forces for some reason
% nForceData = (forceData - min(forceData)) / (max(forceData)- min(forceData)) * 50 ;
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

figure;
subplot(3,1,1)
plot(t,voltageData)
title("Voltage Vs. Time")
xlabel('Time(s)');
ylabel('Voltage');
subplot(3,1,2)
plot(t,distanceData)
title("Distance (um) Vs. Time")
xlabel('Time(s)');
ylabel('Distance(um)');
subplot(3,1,3)
plot(t,forceData)
title("Force (pN) Vs. Time")
xlabel('Time(s)');
ylabel('Force(pN)');

% Filtering using analysis of polynomial fit of histogram data

degree = 6;                                                                 % 6th degree polynomial fit of data for three curves
p = polyfit(bin_centers, prob_density, degree);                             % Polyfit parameters


densityFit = polyval(p, bin_centers);                                       % Generate polyfit curve

figure;
hold on

bar(bin_centers, prob_density, 'FaceColor', 'k');
plot(bin_centers, densityFit)
title("Polynomial fit of Force Data Histogram")
xlabel ('Rupture force(pN)')
ylabel ('Estimated probability density (1/pN)')

zeroIdx = find(densityFit(1:end-1) .* densityFit(2:end) < 0);               % Find indices of zeros in graph
limitIdx = zeros(1, length(bin_centers));
limitIdx(zeroIdx(2):zeroIdx(3)) = 1;                                        % Generate logical vector to isolate curve

zeroCross = bin_centers(zeroIdx);
binLimitValues = [zeroCross(2) zeroCross(3)];                               % For testing: output values of bin limits
fprintf("The desired curve lies between %2.2f and %2.2f pN.", binLimitValues(1), binLimitValues(2))

figure;

prob_density_filtered = prob_density .* limitIdx;

bar(bin_centers, prob_density_filtered, 'FaceColor', 'k');
xlim([0 40]);
ylim([0 0.1]);
title("Isolated Curve of Single Bond Rupture Events")
xlabel ('Rupture force(pN)')
ylabel ('Estimated probability density (1/pN)')

