load('MichiganEnduranceOutput.mat')
%% Interpolate to like timestamps
current = S.dc_bus_current; %Amps
voltage = S.dc_bus_voltage; %Volts

% Data uniqueness
for i = 1:length(voltage(:,1))
    voltage(i,1) = voltage(i,1) + i/100000000;
end
for i = 1:length(current(:,1))
    current(i,1) = current(i,1) + i/100000000;
end

time = 1:100:max(current(:,1)); %ms
adjVoltage = interp1(voltage(:,1),voltage(:,2),time);
adjCurrent = interp1(current(:,1),current(:,2),time);

%remove noise-producing data points
% mask = adjCurrent>1 & adjVoltage>50;
% adjCurrent(~mask) = [];
% adjVoltage(~mask) = [];

IR = nan(1,length(adjCurrent));
temp = nan(1,length(adjCurrent));

%% Find temperature and calculate IR at timestamps
for i = 1:25:length(adjCurrent)
    
    interval = 50;
    [~,tempIndex] = min(abs(time(i) - S.BMS_average_temperature(:,1)));
    if i > interval && i < length(adjCurrent) - interval
        testInd = i-interval:i+interval;
    elseif i < length(adjCurrent) - interval
        testInd = i:i+interval;
    else
        testInd = i-interval:i;
    end
    [p,stat] = polyfit(adjCurrent(testInd),adjVoltage(testInd),1); 
    IR(i) = -p(1);
    temp(i) = S.BMS_average_temperature(tempIndex,2);
end

IR = 1000*IR./84; %cell normalized mOhms

%% Plot
figure
IR(IR <= 0) = nan;
temp(IR <= 0) = nan;
plot(temp,IR,'.')
ylim([0,4])
xlabel('Temperature (C)')
ylabel('Cell Normalized Pack Internal Resistance (mOhms)')
title('Cell Internal Resistance vs Cell Tab Temperature')

%% Accumulator Voltage Drop
mask = adjCurrent>1 & adjVoltage>50;
adjCurrent(~mask) = [];
adjVoltage(~mask) = [];

voltageDrop = cat(1, adjCurrent, adjVoltage);
voltageDrop = round(voltageDrop, 2); % Smooth out, only use two decimal places

% Credit: https://www.mathworks.com/matlabcentral/answers/151709-how-can-i-average-points-with-just-the-same-x-coordinate
[uniqueCurrent,~,idx] = unique(voltageDrop(1,:));
averageVoltage = accumarray(idx,voltageDrop(2,:),[],@mean);

% figure
% plot(uniqueCurrent, averageVoltage,'.')
% xlabel('Current')
% ylabel('Voltage')
% title('Accumulator Voltage Drop Analysis')