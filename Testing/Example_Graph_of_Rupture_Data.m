ruptureData = readtable("Raw Rupture Values.xlsx");
t = ruptureData(:,1);
voltageData = ruptureData(:,2);
distanceData = ruptureData(:,3);
forceData = ruptureData(:,4);

t = table2array(t);
voltageData = table2array(voltageData);
distanceData = table2array(distanceData);
forceData = table2array(forceData);

figure
plot(t,voltageData)
title("Voltage Vs. Time")
figure
plot(t,distanceData)
title("Distance (nm) Vs. Time")
figure
plot(t,forceData)
title("Force (pN) Vs. Time")