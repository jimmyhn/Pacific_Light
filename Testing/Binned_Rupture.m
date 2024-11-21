clear; clc; close all;
ruptureData = readtable("Raw Rupture Values.xlsx");
t = ruptureData(:,1);
voltageData = ruptureData(:,2);
distanceData = ruptureData(:,3);
forceData = ruptureData(:,4);

t = table2array(t);
voltageData = table2array(voltageData);
distanceData = table2array(distanceData);
forceData = table2array(forceData);
posForceData = forceData(forceData>-0.5); % Could be normalized as well but it creates a field of smaller forces for some reason
nForceData = (posForceData - min(posForceData)) / (max(posForceData)- min(posForceData)) * 50 ;
binWidth = .1;
binEdges = 0:binWidth:40;

bin_counts = histcounts(nForceData,binEdges);
prob_density = bin_counts / (sum(bin_counts) * binWidth);
bin_centers = binEdges(1:end-1) + binWidth / 2;

figure;
bar(bin_centers, prob_density, 'FaceColor', 'k');
xlabel ('Rupture force(pN)')
ylabel ('Estimated probability density (1/pN)')
xlim([0 40]);
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
