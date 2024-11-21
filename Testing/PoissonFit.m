clear; clc; close all;

%% "Calibration" Rupture Data 
ruptureControl = readtable('Rupture Data Control.xlsx');
time_exp = (3*60)+(53); 
tc = linspace(1,time_exp,11194); % Time extraction
yData = ruptureControl(:,2);
xData = ruptureControl(:,3);
sumData = ruptureControl(:,4);

xData = table2array(xData) .* (-1);
yData = table2array(yData) .* (-1);
sumData = table2array(sumData) .* (-1);

%% Experiment Rupture Data
ruptureData = readtable("Raw Rupture Values.xlsx"); % Uploaded Data
t = ruptureData(:,1); % Time extraction
voltageData = ruptureData(:,2); % Voltage extraction
distanceData = ruptureData(:,3); % Distance extraction
forceData = ruptureData(:,4); % Converted Force Data extraction
fs = 1; 

%% Array Conversion
t = table2array(t);
voltageData = table2array(voltageData); 
distanceData = table2array(distanceData);
forceData = table2array(forceData);

%% Normalization of Force Data

nForceData = (forceData - min(forceData)) / (max(forceData)- min(forceData));

%% Poisson Distribution Calculation
lambda = mean(nForceData);
disp(['Estimated lambda: ', num2str(lambda)]); % Displays our lambda value. Needs to be over 0 I believe
x = 0:max(nForceData);

poissonPDF = poisspdf(x,lambda); 

%% Poisson Distribution Check 

% This ensures that our data is following Poisson Distribution Rules
pd = fitdist(nForceData, 'Poisson');
[h,p] = chi2gof(nForceData, 'CDF', pd);
if h==0
    disp("data follows Poisson Dist.")
else
    disp('Data does not follow Poisson Dist.') 
end
disp(['p-value: ', num2str(p)]);

%% Raw Control Data

figure;

subplot(3,1,1)
plot(tc, xData);
title("Vx Data")
xlabel('Time(s)');
ylabel('Voltage(V)');
subplot(3,1,2)
plot(tc,yData);
title("Vy Data")
xlabel('Time(s)');
ylabel('Voltage(V)');
subplot(3,1,3)
plot(tc,sumData);
title("SumData")
xlabel('Time(s)');
ylabel('Voltage(V)');

%% Raw Data Graphs

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


%% Poisson Distribution Graph
figure
histogram(forceData, 'BinWidth', 5, 'Normalization', 'pdf');
hold on;

scaledPoissonPDF = poissonPDF * numel(forceData) * 5;
plot (x, scaledPoissonPDF, 'r-', 'LineWidth', 2);
title('Force Distribution w/ Poisson Fit');
xlabel('Force(pN)');
ylabel('Probability Density');
legend('Force Data', 'Poisson Fit');
hold off;

% Histogram Graph Individual
figure
subplot(2,1,1);
histogram(nForceData, 'Normalization', 'pdf');
title('Force Data Histogram')
xlabel('Event Counts');
ylabel('Probability Density');

% Fit Graph Individual
subplot(2,1,2);
plot (x, poissonPDF, 'r-', 'LineWidth', 2);
title('Force Data Fit');
xlabel('Event Counts');
ylabel('Probability Density');

