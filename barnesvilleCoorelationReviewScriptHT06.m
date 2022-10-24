%% Capacity decision review script:
% clear
clc
close all

% Load HT06 Simulation Result
load('results_HT06_Barnesville.mat')
% Load HT06 Data
load('BarnesvilleShootout_HT06Data.mat')

timeHigh = 6508.9;
timeLow = 6484.9;
time = timeLow:0.1:timeHigh;

% Speed
testSpeedTime = S.motor_speed(:,1)/1000;
testSpeedData = -((S.motor_speed(:,2)/Parameters.nRear)/60)*2*pi*Parameters.r;

for i = 1:length(testSpeedTime)
    testSpeedTime(i) = testSpeedTime(i) + i/100000000;
end

testSpeedMPS = interp1(testSpeedTime,testSpeedData,time);
dist = cumtrapz(time,testSpeedMPS);
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
testTorqueMotorAdj = interp1(testTorqueTime,testTorqueData,time);
testSpeedRadSec = (testSpeedMPS/Parameters.r)*Parameters.nRear;
testPowerMechMotorAdj = testTorqueMotorAdj.*testSpeedRadSec;
vehicleMass = 250;

% IMU torque model
testLongAccelAdj = interp1(testLongAccelTime,testLongAccelData,time);
testLatAccelAdj = interp1(testLatAccelTime,testLatAccelData,time);
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
testVoltageAdj = -interp1(testVoltageTime,testVoltageData,time);
% Apply interpolation
testCurrentAdj = -interp1(testCurrentTime,testCurrentData,time);

testPowerAccOutputAdj = testVoltageAdj.*testCurrentAdj;
testPowerAccLosses = 84.*0.0015.*testCurrentAdj.^2;
testPowerAll = testPowerAccLosses + testPowerAccOutputAdj;

%% Torques
figure
hold on
plot(dist,movmean(testTorqueMotorAdj,5))
plot(dist,movmean(testTorqueMotorIMUCalcAdj,5))
plot(simDistScaled,movmean(movmin(T(:,1) + T(:,2),3),65))
legend({'HT06 Track Data Feedback Torque','HT06 Track Data Calculated from IMU','HT06 Simulated'})
xlabel('Distance (m)')
ylabel('Torque (Nm)')
title('Torque vs Distance HT06 Barnesville Shootout')

%% Powers
figure
hold on
% plot(dist,movmean(testPowerMechMotor,5))
plot(dist,movmean(testPowerAccOutputAdj,5))
plot(simDistScaled,movmean(movmin(sum(elecPower,2),3),65))
title('HT06 Electrical Power Data and Simulated Power HT06 Barnesville Shootout','Rolling Average of 0.5 second window applied to all data')
legend({'Inverter Measured Power Draw','HT06 Simulated Electrical Power Requirement'})
xlabel('Distance (m)')
ylabel('Power (W)')
figure
hold on
plot(dist,movmean(testPowerMechVehicle,5))
plot(simDistScaled,movmean(movmin(sum(T.*Parameters.nRear.*v'./Parameters.r,2),3),65))
title('HT06 Mechanical Power Data and Simulated Power HT06 Barnesville Shootout','Rolling Average of 0.5 second window applied to all data')
legend({'IMU Estimated Powertrain Mechanical Output','HT06 Simulated Mechanical Power Output'})
xlabel('Distance (m)')
ylabel('Power (W)')

%% Efficiency Calculation
testEff = movmean(testPowerMechVehicle,20)./movmean(testPowerAccOutputAdj,20);
testEff(testEff > 1.25 | testEff < 0) = nan;
simEff = movmin(sum(T.*Parameters.nRear.*v'./Parameters.r,2),3)./movmin(sum(elecPower,2),3);
figure
hold on
plot(dist,movmean(testEff,1))
plot(simDistScaled,movmean(simEff,1))
title('HT06 Measured and Simulated Power HT06 Barnesville Shootout','Rolling Average of 0.5 second window applied to all data')
legend({'IMU Estimated Powertrain Efficiency','HT06 Simulated Powertrain Efficiency'})

%% Energy Capacity
dataCapacitykWh = cumtrapz(time,testPowerAccOutputAdj)/3600000;
simCapacitykWh = cumtrapz(t,sum(elecPower,2))/3600000;
figure
hold on
plot(dist,dataCapacitykWh)
plot(simDistScaled, simCapacitykWh)
title('HT06 Measured and Simulated Charge Expended vs Distance HT06 Barnesville Shootout')
legend({'HT06 Measured Charge Motor Controller','HT06 Simulated Charge'})
xlabel('Distance (m)')
ylabel('Capacity (kWh)')

%% Motor Torque
figure
hold on
plot(movmean(testTorqueMotorAdj,5),movmean(testTorqueMotorIMUCalcAdj,5),'.')
linRegTorqueTorque = fit(testTorqueMotorAdj', testTorqueMotorIMUCalcAdj','poly1');
plot(linRegTorqueTorque)
ylabel('IMU Calculated Torque (Nm)')
xlabel('Motor Feedback Torque (Nm)')

% % Data uniqueness
% for i = 1:length(voltage(:,1))
%     voltage(i,1) = voltage(i,1) + i/100000000;
% end