%% Capacity decision review script:
% clear
clc
close all

% Load HT06 Simulation Result
load('results_HT06_Michigan_Derate.mat')
% Load HT06 Data
load('FSAEMichigan2022_HT06Data.mat')
% Load Energy Meter Data
emData = readtable('Endurance1EM.csv');

timeHigh = 439.4;
timeLow = 372.6;
% timeHigh = 100000000;
% timeLow = 0;

emTime = (emData.Time_s_-58.6)/1.0162 + 60.52; % Scale/shift time so data is aligned
emVoltage = emData.Voltage_V_;
emCurrent = emData.Current_A_;
emMask = emTime >= timeLow & emTime <= timeHigh;

emTimeBase = emTime(emMask);
emVoltageAdj = emVoltage(emMask);
emCurrentAdj = emCurrent(emMask);
emPowerAdj = emVoltageAdj.*emCurrentAdj;

% Speed
testSpeedTime = S.motor_speed(:,1)/1000;
testSpeedData = -((S.motor_speed(:,2)/Parameters.nRear)/60)*2*pi*Parameters.r;

for i = 1:length(testSpeedTime)
    testSpeedTime(i) = testSpeedTime(i) + i/100000000;
end

testSpeedMPS = interp1(testSpeedTime,testSpeedData,emTimeBase);
dist = cumtrapz(emTimeBase,testSpeedMPS);
sim_distance = cumtrapz(t,v);
simDistScaled = sim_distance.*dist(end)./sim_distance(end);

figure
plot(dist,testSpeedMPS)
hold on
plot(simDistScaled,v)
legend('Raw Data HT06', 'Sim Data HT06');
xlabel('Distance [m]');
ylabel('Velocity [m/s]');

% Interpolate all time points back to dist indexes, use emTime as base

% Motor Torque:
testTorqueTime = S.torque_feedback(:,1)/1000;
testTorqueData = -S.torque_feedback(:,2);
testLongAccelTime = S.long_accel(:,1)/1000;
testLongAccelData = S.long_accel(:,2);
testLatAccelTime = S.lat_accel(:,1)/1000;
testLatAccelData = S.lat_accel(:,2);

% % Data uniqueness
for i = 1:length(testTorqueTime)
    testTorqueTime(i) = testTorqueTime(i) + i/100000000;
end
for i = 1:length(testLongAccelTime)
    testLongAccelTime(i) = testLongAccelTime(i) + i/100000000;
end
for i = 1:length(testLatAccelTime)
    testLatAccelTime(i) = testLatAccelTime(i) + i/100000000;
end
% Apply interpolation
testTorqueMotorAdj = interp1(testTorqueTime,testTorqueData,emTimeBase);
testSpeedRadSec = (testSpeedMPS/Parameters.r)*Parameters.nRear;
testPowerMechMotorAdj = testTorqueMotorAdj.*testSpeedRadSec;
vehicleMass = 250;

% IMU torque model
testLongAccelAdj = interp1(testLongAccelTime,testLongAccelData,emTimeBase);
testLatAccelAdj = interp1(testLatAccelTime,testLatAccelData,emTimeBase);
testForceIMUCalcAdj = testLongAccelAdj.*vehicleMass;
testAeroForceAdj = 1.5*1.22*0.5*testSpeedMPS.^2;
testRollForceAdj = 0.028*(vehicleMass.*9.81 + 2.4*1.22*0.5*testSpeedMPS.^2);
testLatTireDragForceAdj = abs(testLatAccelAdj.*vehicleMass.*sind(7));
testDriveTrainForceAdj = testForceIMUCalcAdj + testAeroForceAdj + testRollForceAdj + testLatTireDragForceAdj;

brakeMask = testDriveTrainForceAdj < 0;
testDriveTrainForceAdj(brakeMask) = 0;
testTorqueMotorIMUCalcAdj = (testDriveTrainForceAdj*0.2)/4.4;
testPowerMechVehicle = testDriveTrainForceAdj.*testSpeedMPS;

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
testVoltageAdj = -interp1(testVoltageTime,testVoltageData,emTimeBase);
% Apply interpolation
testCurrentAdj = -interp1(testCurrentTime,testCurrentData,emTimeBase);

testPowerAccOutputAdj = testVoltageAdj.*testCurrentAdj;
testPowerAccLosses = 84.*0.0015.*testCurrentAdj.^2;
testPowerAll = testPowerAccLosses + testPowerAccOutputAdj;

%% Torques
figure
hold on
plot(dist,movmean(testTorqueMotorAdj,5))
plot(dist,movmean(testTorqueMotorIMUCalcAdj,5))
plot(simDistScaled,movmean(movmin(T(:,1) + T(:,2),3),65))
legend({'HT06 Endurance Feedback Torque','HT06 Endurance Calculated from IMU','HT06 Simulated'})
xlabel('Distance (m)')
ylabel('Torque (Nm)')
title('Torque vs Distance Endurance Michigan 2022')

%% Powers
figure
hold on
% plot(dist,movmean(testPowerMechMotor,5))
% plot(dist,movmean(testPowerAccOutputAdj,5))
plot(dist,movmean(emPowerAdj,5))
plot(simDistScaled,movmean(movmin(sum(elecPower,2),3),65))
title('HT06 Electrical Power Data and Simulated Power Michigan 2022 Endurance','Rolling Average of 0.5 second window applied to all data')
legend({'Energy Meter Measured Inverter Consumption','HT06 Simulated Electrical Power Requirement'})
xlabel('Distance (m)')
ylabel('Power (W)')
figure
hold on
plot(dist,movmean(testPowerMechVehicle,5))
plot(simDistScaled,movmean(movmin(sum(T.*Parameters.nRear.*v'./Parameters.r,2),3),65))
title('HT06 Mechanical Power Data and Simulated Power Michigan 2022 Endurance','Rolling Average of 0.5 second window applied to all data')
legend({'IMU Estimated Powertrain Mechanical Output','HT06 Simulated Mechanical Power Output'})
xlabel('Distance (m)')
ylabel('Power (W)')

%% Efficiency Calculation
testEff = movmean(testPowerMechVehicle,20)./movmean(emPowerAdj,20);
testEff(testEff > 1.25 | testEff < 0) = nan;
simEff = movmin(sum(T.*Parameters.nRear.*v'./Parameters.r,2),3)./movmin(sum(elecPower,2),3);
figure
hold on
plot(dist,movmean(testEff,1))
plot(simDistScaled,movmean(simEff,1))
title('HT06 Measured and Simulated Power Michigan 2022 Endurance','Rolling Average of 0.5 second window applied to all data')
legend({'IMU Estimated Powertrain Efficiency','HT06 Simulated Powertrain Efficiency'})

%% Capacity
dataCapacityAh = cumtrapz(emTimeBase,testCurrentAdj)/3600;
emDataCapacityAh = cumtrapz(emTimeBase,emCurrentAdj)/3600;
simCapacityJankFixPlsAh = cumtrapz(t,sum(elecPower,2)/320)/3600;
figure
hold on
plot(dist,dataCapacityAh)
plot(dist,emDataCapacityAh)
plot(simDistScaled, simCapacityJankFixPlsAh)
title('HT06 Measured and Simulated Charge Expended vs Distance Michigan 2022 Endurance')
legend({'HT06 Measured Charge Motor Controller','HT06 Measured Charge Energy Meter','HT06 Simulated Charge'})
xlabel('Distance (m)')
ylabel('Capacity (Ah)')

%% Motor Torque
figure
hold on
plot(movmean(testTorqueMotorAdj,5),movmean(testTorqueMotorIMUCalcAdj,5),'.')
linRegTorqueTorque = fit(testTorqueMotorAdj, testTorqueMotorIMUCalcAdj,'poly1');
plot(linRegTorqueTorque)
ylabel('IMU Calculated Torque (Nm)')
xlabel('Motor Feedback Torque (Nm)')

% % Data uniqueness
% for i = 1:length(voltage(:,1))
%     voltage(i,1) = voltage(i,1) + i/100000000;
% end