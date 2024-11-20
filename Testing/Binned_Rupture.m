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
binWidth = 1;
binEdges = 0:binWidth:max(t) + binWidth;
avgForce = zeros(1,length(binEdges) - 1);

for i = 1: length(binEdges)-1
    binStart = binEdges(i);
    binEnd = binEdges(i+1);
    indicesInBin = find (t>= binStart & t<binEnd);

    forcesInBin = forceData(indicesInBin);
    if ~isempty(forcedInBin)
        avgForce(i) = mean(forcesInBin);
    else    
        avgForce(i) = NaN;
    end
end


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
bar(binEdges(1:end-1), avgForce, 'histc');
title("BinnedData");
xlabel('Time');
ylabel('Average Force(pN)');
