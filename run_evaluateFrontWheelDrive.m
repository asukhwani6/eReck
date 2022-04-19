%% Lap Sim
track = "FSAE2021NevadaEndurance.csv";
HT06_vehicle_parameters;
% HT06_vehicle_parameters;
optim_number = 1000; %Optimization discretization for braking
vel_start = 13; %Starting velocity

run = {'Experimental Data','R: 1xEmrax208','R: 1xEmrax208 F: 2xNova30','R: 1xEmrax208 F: 2xNova15','R: 1xEmrax188','R: 1xEmrax188 F: 2xNova30','R: 1xEmrax188 F: 2xNova15', 'R: 2xNova30 F: 2xNova30', 'R: 2xNova30 F: 2xNova15','F: 2xNova30'};
motorMassDelta = [0 11.4 5 -3 8.4 3 18 11 2];
rearReduction = [4.44 4.44 4.44 5.5 5.5 5.5 3.4 3.4 0];
frontReduction = [0 3.4 4.53 0 3.4 4.53 3.4 4.53 3.4];
rearAxleMaxTorque = [140 140 140 90 90 90 140 140 140 0.1];
frontAxleMaxTorque = [0.1 140 60 0.1 140 60 140 60 140];

%% 75m Acceleration Event
for i = 1:length(motorMassDelta)
HT06_vehicle_parameters;
Parameters.mass = Parameters.mass + motorMassDelta(i);
Parameters.nRear = rearReduction(i);
Parameters.nFront = frontReduction(i);
Parameters.TmRear = rearAxleMaxTorque(i);
Parameters.TmFront = frontAxleMaxTorque(i);

% [v, t, locations] = runLapSimOptimized(vel_start,track,Parameters,optim_number);
[t, v, traveled_dis, FnormFront, FnormRear] = acceleration(0, realmax, 75,Parameters, 0);
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
figure(2)
hold on
title('Force on Front Axle vs Distance')
xlabel('Distance (m)')
ylabel('Force (N)')
plot(sim_distance,FnormFront)
figure(3)
hold on
plot(sim_distance,FnormRear)
title('Force on Rear Axle vs Distance')
xlabel('Distance (m)')
ylabel('Force (N)')
end
for i = 1:3
    figure(i)
    legend(run(2:end))
end

%% Skidpad Event

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
velLimit = cornerFunc(Parameters,t_radius,sa);

skidpadTime = t_length/velLimit;

fprintf('%s: %.3f seconds\n',run{i+1},skidpadTime)
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