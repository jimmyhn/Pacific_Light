format long
ruptureData = readmatrix('Rupture Data.lvm','FileType', 'text','Delimiter','\t','Range', [22,2,11221,4]);
N = length(ruptureData);
x = 1:N; % number of data points
T = ((3*60)+53)+0.2; % the time in seconds stated on the spreadsheet ~ 03:53.2
fs = N/T; % sampling frequency
voltageData = ruptureData(:,1).*-1;
bData = ruptureData(:,2).*-1;
cData= ruptureData(:,3).*-1;

f = (0:N-1)*(fs/N); % frequency vector

figure
plot(x,voltageData) % graph of raw voltage data over time points

figure
plot(x,bData)

figure
plot(x,cData)

Xf = fft(voltageData);
magnitudes = abs(Xf);
%{
figure
plot(f(1:N),magnitudes(1:N)) % graph including DC component, and not adjusting for spectrum symmetry (Frequency domain graph)

figure
plot(f(2:N/2+1),magnitudes(2:N/2+1)) % graph excluding DC component, and adjusting for spectrum symmetry (Frequency domain graph)


% in this graph it looks like there were a lot more peaks than we think there were, so which ones are the Van der Waals, 1 bond, 2 
% since the professor already provided it us with force (pN), maybe do the fft of the force data instead?

forceData = ruptureData(:,3);

f = (0:N-1)*(fs/N); % frequency vector

figure
plot(x,forceData) % graph of raw voltage data over time points

Xf = fft(forceData);
magnitudes = abs(Xf);

figure
plot(f(1:N),magnitudes(1:N)) % graph including DC component, and not adjusting for spectrum symmetry (Frequency domain graph)

figure
plot(f(2:N/2+1),magnitudes(2:N/2+1)) % graph excluding DC component, and adjusting for spectrum symmetry (Frequency domain graph)

% what does it mean?!?!?

%}