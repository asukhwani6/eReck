%% USAGE:

%% Lap Sim
track = "FSAE2022MichiganEndurance.csv";
% HT05_vehicle_parameters;
HT06_vehicle_parameters;
% HT07_AMK_hubs_vehicle_parameters;

vel_start = 13.6; %Starting velocity

Parameters.driverFactorLong = .6;
Parameters.driverFactorLat = 1;

% RUN LAP SIMULATION

[v, t, locations, Ax, Ay, Fx, Fz, T, elecPower, eff, q] = runLapSimOptimized(vel_start,track,Parameters);

dist = cumtrapz(t,v);
lapDistance = dist(end);
lapEnergy = cumtrapz(t,elecPower); %Joules
lapEnergykWh = sum(lapEnergy(end,:))*2.77778e-7;
raceEnergy = lapEnergykWh*22000/lapDistance;
fprintf('Total Energy Expenditure During Race: %.2f kWh\n',raceEnergy)
fprintf('Simulated Lap Time: %.2f seconds\n',t(end))

%% Overlay With FSAE Michigan Fastest Recorded Lap Data

load('FSAEMichigan2022_HT06Data.mat');
motor_speed = S.motor_speed;
vehicle_speed = motor_speed./1000; %convert to seconds
vehicle_speed(:,2) = -((S.motor_speed(:,2)/4.4)/60)*.4*pi;

mask = (vehicle_speed(:,1) >= 372.6) & (vehicle_speed(:,1) <= 439.4);
time_new = vehicle_speed(mask,1) - min(vehicle_speed(mask,1));
speed_new = vehicle_speed(mask,2);

data_distance = cumtrapz(time_new, speed_new);
sim_distance = cumtrapz(t(2:end),v(2:end));

figure
hold on

plot(data_distance,speed_new);

plot(sim_distance*data_distance(end)/sim_distance(end),v(1:end-1),'.-');
legend('Raw Data HT06', 'Sim Data HT06');
grid on
box on
xlabel('Distance [m]');
%xlim([0 t(end)])
ylabel('Velocity [m/s]');
xlim([0 max(data_distance)])
ylim([0 33])

%% Plot g-g diagram
figure
hold on

load('FSAEMichigan2022_HT06Data.mat');
plot(movmean(S.lat_accel(:,2),5)/9.81,movmean(S.long_accel(:,2),5)/9.81,'.')
plot(Ay/9.81,Ax/9.81,'.')
xlabel('Lateral Acceleration (g)')
ylabel('Longitudinal Acceleration (g)')
title('g-g Diagram FSAE Nevada 2021 Simulated')
legend({'HT06 Collected Data','HT06 Simulated Data'})

%% Accel Script Test
% HT07_AMK_hubs_vehicle_parameters;
HT06_vehicle_parameters;
Parameters.mass = Parameters.AccumulatorMass + Parameters.curbMass + Parameters.driverMass;
Parameters.mass = Parameters.mass;

accelLength = 75; %m
entry_vel = 0; %start from standstill

[accel_t, accel_v, accel_Ax, accel_Ay, accel_Fx, accel_Fz, accel_T, accel_elecPower, accel_eff, accel_q] = speed_transient(accelLength, realmax, entry_vel, realmax, 0, Parameters);
accel_motorSpeed = [(accel_v'./Parameters.r).*Parameters.nRear,(accel_v'./Parameters.r).*Parameters.nFront].*9.5493;

figure
subplot(4,1,1)
hold on
box on
plot(accel_t,accel_v)
xlabel('Time (s)')
ylabel('Velocity (m/s)')
subplot(4,1,2)
plot(accel_t,accel_elecPower)
xlabel('Time (s)');
ylabel('Motor Electrical Consumption (W)')
subplot(4,1,3)
plot(accel_t, accel_T)
xlabel('Time (s)');
ylabel('Motor Torque (Nm)')
subplot(4,1,4)
plot(accel_t, accel_motorSpeed)
xlabel('Time (s)');
ylabel('Motor Speed (RPM)')

fprintf('Acceleration Simulated Time: %.3f\n',accel_t(end))

%% Brake Script Test
HT07_AMK_hubs_vehicle_parameters;

[tVec, vVec, AxVec, AyVec, FxVec, FzVec] = braking(realmax,100,30,0,Parameters);

figure
hold on
box on
plot(tVec,vVec)

xlabel('Time (s)');
ylabel('Speed (m/s)');

%% Skidpad Script Test
HT07_AMK_hubs_vehicle_parameters;
% skidpad radius estimated from cone radius + 1/2 track width + some
% clearance to the cones
rSkidpad = 8.5; % m

vSkidpad = velLimit(8.5,Parameters);
tSkidpad = 2.*rSkidpad.*pi./vSkidpad;

fprintf('Skidpad Simulated Time: %.3f\n',tSkidpad)