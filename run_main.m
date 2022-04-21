%% Lap Sim
track = "FSAE2021NevadaEndurance.csv";
% HT05_vehicle_parameters;
HT06_vehicle_parameters;
optim_number = 1000; %Optimization discretization for braking
vel_start = 13; %Starting velocity

% RUN LAP SIMULATION
[v, t, locations, Ax, Ay] = runLapSimOptimized(vel_start,track,Parameters);
 
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

figure
hold on

plot(data_distance,speed_new);
plot(sim_distance*1.028,v(1:end-1),'.-');
legend('Raw Data', 'Sim Data')
grid on
box on
xlabel('Distance [m]');
%xlim([0 t(end)])
ylabel('Velocity [m/s]');
xlim([0 max(sim_distance*1.028)])
ylim([0 30])

%% Plot g-g diagram
% figure
hold on
plot(Ay/9.81,Ax/9.81,'.')
xlabel('Lateral Acceleration (g)')
ylabel('Longitudinal Acceleration (g)')
title('g-g Diagram FSAE Nevada 2021 Simulated')
figure
%vAdj = v(1:6222)';
%AyAdj = Ay'/9.81;
%AxAdj = Ax'/9.81;
%scatter3(AyAdj,AxAdj,vAdj)

%% Accel Script Tests
HT06_vehicle_parameters;

num = 100;

dist = linspace(1,75,num);

for i = 1:100
    [~,v,~,~] = accel(0,dist(i),0,Parameters);
    v_max(i) = v(end);
end

hold on
box on
plot(dist,v_max);
xlabel('Distance [m]');
ylabel('Max Speed [m]');

%% Brake script test

vehicle_parameters;

dist = linspace(1,75,num);

[t,v] = braking(30,100,straight_parameters);
% [tt,vv] = brake_calculator(-1.5*9.81,30,30);
figure
hold on
box on
% plot(dist,v_max);
% plot(dist,v_maxt);
plot(t,v)
a = diff(v)/diff(t)

% plot(tt,vv)
legend('ODE','-1.5g braking');
xlabel('Time [s]');
ylabel('Max Speed [m]');

