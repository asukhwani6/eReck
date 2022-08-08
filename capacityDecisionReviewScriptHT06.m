%% Capacity decision review script:
clear
clc
close all

% Load HT06 Simulation Result
load('results_HT06_Michigan_Derate.mat')

% Load HT06 Data
load('FSAEMichigan2022_HT06Data.mat')
% Filter data to fastest lap, convert time to seconds

timeHigh = 439400;
timeLow = 372600;

% Speed
speedTime = S.motor_speed(:,1);
speedData = -((S.motor_speed(:,2)/Parameters.nRear)/60)*2*pi*Parameters.r;
speedMask = (speedTime >= timeLow) & (speedTime <= timeHigh);

testSpeedTime = speedTime(speedMask)/1000;
testSpeedData = speedData(speedMask);
dist = cumtrapz(testSpeedTime,testSpeedData);
sim_distance = cumtrapz(t,v);
simDistScaled = sim_distance.*dist(end)./sim_distance(end);

figure
plot(dist,testSpeedData)
hold on
plot(simDistScaled,v)
legend('Raw Data HT06', 'Sim Data HT06');
xlabel('Distance [m]');
ylabel('Velocity [m/s]');

% Interpolate all time points back to dist indexes, use testSpeedTime as base

% Motor Torque:
testTorqueTime = S.torque_feedback(:,1)/1000;
testTorqueData = -S.torque_feedback(:,2);
% % Data uniqueness
for i = 1:length(testTorqueTime)
    testTorqueTime(i) = testTorqueTime(i) + i/100000000;
end
% Apply interpolation
testTorqueAdj = interp1(testTorqueTime,testTorqueData,testSpeedTime);
testSpeedRadSec = (testSpeedData/Parameters.r)*Parameters.nRear;
testPowerMechMotor = testTorqueAdj.*testSpeedRadSec;

% Accumulator current, voltage, power:
testVoltageTime = S.dc_bus_voltage(:,1)/1000;
testVoltageData = -S.dc_bus_voltage(:,2);
testCurrentTime = S.dc_bus_current(:,1)/1000;
testCurrentData = -S.dc_bus_current(:,2);
% % Data uniqueness
for i = 1:length(testVoltageTime)
    testVoltageTime(i) = testVoltageTime(i) + i/100000000;
end
for i = 1:length(testCurrentTime)
    testCurrentTime(i) = testCurrentTime(i) + i/100000000;
end
% Apply interpolation
testVoltageAdj = -interp1(testVoltageTime,testVoltageData,testSpeedTime);
% Apply interpolation
testCurrentAdj = -interp1(testCurrentTime,testCurrentData,testSpeedTime);

testPowerAccOutputAdj = testVoltageAdj.*testCurrentAdj;
testPowerAccLosses = 84.*0.0015.*testCurrentAdj.^2;
testPowerAll = testPowerAccLosses + testPowerAccOutputAdj;

% Instantaneous motor electrical power:

figure
hold on
plot(dist,testTorqueAdj)
plot(simDistScaled,movmean(movmin(T(:,1) + T(:,2),3),5))
legend({'HT06 Endurance Fastest Lap','HT06 Simulated'})

figure
hold on
plot(dist,movmean(testPowerMechMotor,5))
plot(dist,movmean(testPowerAccOutputAdj,5))
plot(simDistScaled,movmean(movmin(sum(elecPower,2),3),65))
title('HT06 Power Data and Simulated Motor Electrical Power Michigan 2022 Endurance','Rolling Average of 0.5 second window applied to all data')
legend({'HT06 Measured Motor Mechanical Power','HT06 Measured Inverter Power Consumption','HT06 Simulated Electrical Power Requirement'})
xlabel('Distance (m)')

dataCapacityAh = cumtrapz(testSpeedTime,testCurrentAdj)/3600;
simCapacityJankFixPlsAh = cumtrapz(t,sum(elecPower,2)/320)/3600;
figure
hold on
plot(dist,dataCapacityAh)
plot(simDistScaled, simCapacityJankFixPlsAh)
title('HT06 Measured and Simulated Charge Expended vs Distance Michigan 2022 Endurance')
legend({'HT06 Measured Charge','HT06 Simulated Charge'})
xlabel('Distance (m)')
ylabel('Capacity (As)')

% % Data uniqueness
% for i = 1:length(voltage(:,1))
%     voltage(i,1) = voltage(i,1) + i/100000000;
% end