%% Initialize Parameters
track = "FSAE2021NevadaEndurance.csv";
HT06_vehicle_parameters;
% HT06_vehicle_parameters;

run = {'Experimental Data',...
    'R: 1xEmrax208',...
    'R: 1xEmrax208 F: 2xNova30',...
    'R: 1xEmrax208 F: 2xNova15',...
    'R: 1xEmrax188',...
    'R: 1xEmrax188 F: 2xNova30',...
    'R: 1xEmrax188 F: 2xNova15',...
    'R: 2xNova30 F: 2xNova30',...
    'R: 2xNova30 F: 2xNova15',...
    'F: 2xNova30'};
motorMassDelta = [0 11.4 5 -3 8.4 3 18 11 2];
rearReduction = [4.44 4.44 4.44 5.5 5.5 5.5 3.4 3.4 0];
frontReduction = [0 3.4 4.53 0 3.4 4.53 3.4 4.53 3.4];
rearAxleMaxTorque = [140 140 140 90 90 90 140 140 140 0.1];
frontAxleMaxTorque = [0.1 140 60 0.1 140 60 140 60 140];
frontMotorTopSpeed = [0, 5000, 8700, 0, 5000, 8700, 5000, 8700, 5000];
rearMotorTopSpeed = [6500, 6500, 6500, 7500, 7500, 7500, 6500, 6500, 0];

%% Skidpad Transient
ssLoadTransferVec = [];
tSkidpadVec = [];
for i = 1:length(motorMassDelta)
HT06_vehicle_parameters;
Parameters.mass = Parameters.mass + motorMassDelta(i);
Parameters.nRear = rearReduction(i);
Parameters.nFront = frontReduction(i);
Parameters.TmRear = rearAxleMaxTorque(i);
Parameters.TmFront = frontAxleMaxTorque(i);

r = 8.25;
t_length = r*2*pi;

% [v, t, locations] = runLapSimOptimized(vel_start,track,Parameters,optim_number);
[t, v, AxVec, AyVec, FzTiresMat] = accel(r,75,0,0,Parameters);
if (i ~= length(run))
tSkidpad = t_length/v(end);
fprintf('%s: %.3f seconds\n',run{i+1},tSkidpad)
end
sim_distance = cumtrapz(t(2:end),v(2:end))*1.0242;
figure(1)
hold on
title('Velocity vs Distance')
xlabel('Distance (m)')
ylabel('Velocity (m/s)')
plot(sim_distance,v(1:end-1))
% figure(2)
% hold on
% plot([0,sim_distance],FzTiresMat(:,1))
% title('Force on Rear Inside vs Distance')
% xlabel('Distance (m)')
% ylabel('Force (N)')
% figure(3)
% hold on
% plot([0,sim_distance],FzTiresMat(:,2))
% title('Force on Rear Outside vs Distance')
% xlabel('Distance (m)')
% ylabel('Force (N)')
% plot(sim_distance,v(1:end-1))
% figure(4)
% hold on
% plot([0,sim_distance],FzTiresMat(:,3))
% title('Force on Front Inside vs Distance')
% xlabel('Distance (m)')
% ylabel('Force (N)')
% figure(5)
% hold on
% plot([0,sim_distance],FzTiresMat(:,4))
% title('Force on Front Outside vs Distance')
% xlabel('Distance (m)')
% ylabel('Force (N)')
% tSkidpadVec = [tSkidpadVec,tSkidpad];
% ssLoadTransferVec = [ssLoadTransferVec, ssLoadTransfer];

end
for i = 1
    figure(i)
    legend(run(2:end))
end
% figure
% plot(ssLoadTransferVec,tSkidpadVec,'.');
% title('Skidpad Time vs Total Lateral Load Transfer')

%% Accel Transient
close all
for i = 1:length(motorMassDelta)
HT06_vehicle_parameters;
Parameters.mass = Parameters.mass + motorMassDelta(i);
Parameters.nRear = rearReduction(i);
Parameters.nFront = frontReduction(i);
Parameters.TmRear = rearAxleMaxTorque(i);
Parameters.TmFront = frontAxleMaxTorque(i);
Parameters.mRearTopSpeed = rearMotorTopSpeed(i);
Parameters.mFrontTopSpeed = frontMotorTopSpeed(i);
[t, v, AxVec, AyVec, FxTiresMat, FzTiresMat] = accel(realmax,75,0,0,Parameters);
if (i ~= length(run))
fprintf('%s: %.3f seconds\n',run{i+1},t(end))
end
sim_distance = cumtrapz(t(2:end),v(2:end));
figure(1)
hold on
title('Velocity vs Distance')
xlabel('Distance (m)')
ylabel('Velocity (m/s)')
plot(sim_distance,v(1:end-1))
figure(2)
hold on
plot([0,sim_distance],sum(FxTiresMat,2).*v'/1000)
title('Drivetrain Instantaneous Power Output')
xlabel('Distance (m)')
ylabel('Power (kW)')
end
for i = 1:2
    figure(i)
    legend(run(2:end))
end

%% Skidpad velLimit
for i = 1:length(motorMassDelta)
HT06_vehicle_parameters;
% overwrite driver mass with lowest mass driver
Parameters.driverMass = 50; %kg
Parameters.mass = Parameters.driverMass + Parameters.curbMass;
Parameters.mass = Parameters.mass + motorMassDelta(i);
Parameters.nRear = rearReduction(i);
Parameters.nFront = frontReduction(i);
Parameters.TmRear = rearAxleMaxTorque(i);
Parameters.TmFront = frontAxleMaxTorque(i);

% assume 28 foot radius skidpad
t_radius = 8.53; % m
t_length = t_radius*2*pi;
sa = rad2deg(Parameters.L/t_radius);
vSkidpad = velLimit(t_radius,Parameters);

tSkidpad = t_length/vSkidpad;

fprintf('%s: %.3f seconds\n',run{i+1},tSkidpad)
end

%% load FSAE Nevada Data
load('6_19_21_data.mat');
motor_speed = S.motor_speed;
vehicle_speed = motor_speed;
vehicle_speed(:,2) = -motor_speed(:,2).*0.004792579784;
mask = (vehicle_speed(:,1) >= 5061.98) & (vehicle_speed(:,1) <= 5132.97);
time_new = vehicle_speed(mask,1) - min(vehicle_speed(mask,1));
speed_new = vehicle_speed(mask,2);
data_distance = cumtrapz(time_new, speed_new);
plot(data_distance,speed_new);

%% FSAE 2021 Nevada Endurance Event
for i = 1:length(motorMassDelta)
HT06_vehicle_parameters;
Parameters.mass = Parameters.mass + motorMassDelta(i);
Parameters.nRear = rearReduction(i);
Parameters.nFront = frontReduction(i);
Parameters.TmRear = rearAxleMaxTorque(i);
Parameters.TmFront = frontAxleMaxTorque(i);

[v, t, locations] = runLapSimOptimized(vel_start,track,Parameters,optim_number);
if (i ~= length(run))
fprintf('%s: %.3f seconds\n',run{i+1},t(end))
end
sim_distance = cumtrapz(t(2:end),v(2:end))*1.0242;
figure(1)
hold on
title('Velocity vs Distance')
xlabel('Distance (m)')
ylabel('Velocity (m/s)')
plot(sim_distance,v(1:end-1))
end
legend(run(2:end))