close all; clear

ruptureData = readtable("Raw Rupture Values.xlsx"); % Uploaded Data
ruptureData = table2array(ruptureData);

time = ruptureData(:,1); % potential feature to add: figuring out the time from the spreadsheet automatically
voltage = ruptureData(:,2); % potential feature to add: figuring out the voltageX from the spreadsheet automatically

% Conversion to Force(pN)
distance = voltage.*(0.7); % 0.7 nm/volt conversion factor was found through experimental data (we can say was found in botvinick's paper)
% create a function here to find the conversion factor from distance(nm) to force(pN); would need to follow up with botvinick for the method
convertFactor = 32.5; % this conversion factor was found through botvinick's signal anaylsis (a good oppurtunity for someone to code)
force = distance.*(convertFactor);


posForceData = force(force>-0.5); % need to tinker around with 0.5
nForceData = (posForceData - min(posForceData)) / (max(posForceData)- min(posForceData)) * max(force); % normalization of force data
binWidth = 0.2;
binEdges = 0:binWidth:max(force);
bin_counts = histcounts(nForceData,binEdges);
prob_density = bin_counts / (sum(bin_counts) * binWidth);
bin_centers = binEdges(1:end-1) + binWidth / 2;

figure;
bar(bin_centers, prob_density, 'FaceColor', 'k');
xlabel ('Rupture force(pN)')
ylabel ('Estimated probability density (1/pN)')
xlim([0 max(force)]);
ylim([0 max(prob_density)*1.1]); % need to tinker around with 1.1

