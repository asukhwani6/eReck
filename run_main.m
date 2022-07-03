%% USAGE:

%% Lap Sim
track = "FSAE2021NevadaEndurance.csv";
% HT05_vehicle_parameters;
% HT06_vehicle_parameters;
HT07_AMK_hubs_vehicle_parameters;

vel_start = 12; %Starting velocity

Parameters.driverFactorLong = .8;
Parameters.driverFactorLat = .8;

% RUN LAP SIMULATION

[v, t, locations, Ax, Ay, Fx, Fz, T, elecPower, eff, q] = runLapSimOptimized(vel_start,track,Parameters);

dist = cumtrapz(t,v);
lapDistance = dist(end);
lapEnergy = cumtrapz(t,elecPower); %Joules
lapEnergykWh = sum(lapEnergy(end,:))*2.77778e-7;
raceEnergy = lapEnergykWh*22000/lapDistance;
fprintf('Total Energy Expenditure During Race: %.2f kWh\n',raceEnergy)
fprintf('Simulated Lap Time: %.2f seconds\n',t(end))

%% Duplicate code cleanup

lengthLoop = length(t) - 1;

for i = 1:lengthLoop
    if t(i) == t(i+1)
        lengthLoop = lengthLoop - 1;
        t = [t(1:i) t(i+2:end)];       
        v_average = (v(i) + v(i+1))/2; 
        disp(v_average);
        v = [v(1:i-1) v_average v(i+2:end)];      
    end
    
end

%% Overlay With FSAE Nevada Fastest Recorded Lap Data

load('6_19_21_data.mat');
motor_speed = S.motor_speed;
vehicle_speed = motor_speed;
vehicle_speed(:,2) = -motor_speed(:,2).*0.004792579784;

mask = (vehicle_speed(:,1) >= 5061.98) & (vehicle_speed(:,1) <= 5132.97);
time_new = vehicle_speed(mask,1) - min(vehicle_speed(mask,1));
speed_new = vehicle_speed(mask,2);

data_distance = cumtrapz(time_new, speed_new);
sim_distance = cumtrapz(t(2:end),v(2:end));

% figure
hold on

% plot(data_distance,speed_new);

plot(sim_distance*1.028,v(1:end-1),'.-');
legend('Raw Data HT05', 'Sim Data HT05', 'Sim Data HT06','Sim Data Hub Motor Architecture');
grid on
box on
xlabel('Distance [m]');
%xlim([0 t(end)])
ylabel('Velocity [m/s]');
xlim([0 max(sim_distance*1.028)])
ylim([0 30])

figure
hold on
plot(t,v)
for i = 1:length(locations)-1
    xline(t(locations(i)));
end
%% Plot g-g diagram
% figure
hold on
plot(Ay/9.81,Ax/9.81,'.')
xlabel('Lateral Acceleration (g)')
ylabel('Longitudinal Acceleration (g)')
title('g-g Diagram FSAE Nevada 2021 Simulated')
%vAdj = v(1:6222)';
%AyAdj = Ay'/9.81;
%AxAdj = Ax'/9.81;
%scatter3(AyAdj,AxAdj,vAdj)

%% Accel Script Test
HT07_AMK_hubs_vehicle_parameters;
Parameters.mass = Parameters.AccumulatorMass + Parameters.curbMass + Parameters.driverMass;

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

fprintf('Acceleration Simulated Time: %.3f\n',accel_time(end))

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
