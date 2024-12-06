%% Graph for Calibration Curve
clc; clear all;
ruptureData = readmatrix('Calibration_500nm.lvm','FileType', 'text','Delimiter','\t','Range', [22,2,2221,4]);

% Voltage 1
subplot(3,1,1);
plot(ruptureData(:, 1));
xlabel('Time (sec)');
ylabel('Voltage (V)');
title('Voltage One');

% Voltage 2
subplot(3,1,2);
plot(ruptureData(:, 2));
xlabel('Time (sec)');
ylabel('Voltage (V)');
title('Voltage Two');

% Voltage 3
subplot(3,1,3);
plot(ruptureData(:, 3));
xlabel('Time (sec)');
ylabel('Voltage (V)');
title('Voltage Three');


