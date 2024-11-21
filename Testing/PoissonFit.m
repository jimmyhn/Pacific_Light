clear; clc; close all;
ruptureData = readtable("Raw Rupture Values.xlsx");
t = ruptureData(:,1);
voltageData = ruptureData(:,2);
distanceData = ruptureData(:,3);
forceData = ruptureData(:,4);
fs = 1; 
t = table2array(t);
voltageData = table2array(voltageData);
distanceData = table2array(distanceData);
forceData = table2array(forceData);

%% Normalization

nForceData = (forceData - min(forceData)) / (max(forceData)- min(forceData));

%% Poisson Distribution Calculation
lambda = mean(forceData);
disp(['Estimated lambda: ', num2str(lambda)]);
x = 0:max(nForceData);

poissonPDF = poisspdf(x,lambda); 

%% Fit of Poisson Data to ForceData
pd = fitdist(nForceData, 'Poisson');
[h,p] = chi2gof(nForceData, 'CDF', pd);
if h==0
    disp("data follows Poisson Dist.")
else
    disp('Data does not follow Poisson Dist.')
end
disp(['p-value: ', num2str(p)]);

figure

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

figure
histogram(nForceData, 'Normalization', 'pdf');
hold on;
plot (x, poissonPDF, 'r-', 'LineWidth', 2);
title('Force(pN) vs. Poisson Distribution');
xlabel('Event Counts');
ylabel('Probability');
legend('ForceData', 'Poisson Distribution');
hold off;