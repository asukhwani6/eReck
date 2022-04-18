track = "david.csv";
% HT05_vehicle_parameters;
HT06_vehicle_parameters;
optim_number = 500; %Optimization discretization for braking
vel_start = 13; %Starting velocity
[v, t, locations] = runLapSimOptimized(vel_start,track,Parameters,optim_number);
 
%TODO: lateral tire drag in corner accels
 
%% Cl/Cd sweep

vehicle_parameters;
track = "david.csv";
vel_start = 13; %Starting velocity
optim_number = 500; %Optimization discretization for braking
vary_length = 10;

cl_range = linspace(2,4,vary_length);
cd_range = linspace(1,4,vary_length);
[X,Y] = meshgrid(cl_range,cd_range);

%parametrize any cl/cd parameters in this loop:
for i = 1:vary_length
    for j = 1:vary_length
        
    fprintf("Running Cl, Cd: %.3f %.3f\n",cl_range(i),cd_range(j));    
    cornering_parameters(11) = cl_range(i); %coefficient of lift
    straight_parameters(12) = cd_range(j); %Coeffcient of drag     
    
    [time(j,i),  v, t, ~] = runLapSim(vel_start,track, straight_parameters, cornering_parameters,optim_number);
    %fprintf("For vehicle weight of %.1fkg, the lap time is: %.3fs\n",straight_parameters(1), time(i));
    

    end
end

figure

test = smoothdata(time,'gaussian',10);
contourf(X,Y,time);
colorbar
title('Cl/Cd Sweep of Nevada Endurance')
xlabel('C_L','FontSize',14)
ylabel('C_d','FontSize',14)

%zlabel('Time [s]','FontSize',14)
%view(45,30)
%plot(w,time,'.');

%% Data plot

figure
hold on
plot(t,v,'.-');

% This is for debugging
for i = 1:length(locations)-1
    
    penis = sprintf('Element %d',i);
    xline(t(locations(i)),'-',penis);
    
end

%% overlay

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
legend('Raw Data', 'Sim Data')
grid on
box on
xlabel('Distance [m]');
%xlim([0 t(end)])
ylabel('Velocity [m/s]');
xlim([0 max(sim_distance*1.028)])
ylim([0 30])


%% Accel Script Tests
vehicle_parameters;

cock = 100;

dist = linspace(1,75,cock);

for i = 1:100
    %coeff = FYcalc(dist(i),520.9687);
    %penis(i) = coeff(1);
    %cock(i) = coeff(2);
    [~,v] = acceleration(0,dist(i),straight_parameters,cock);
    v_max(i) = v(end);
end

figure
hold on
box on
plot(dist,v_max);
xlabel('Distance [m]');
ylabel('Max Speed [m]');

%% Brake script test

vehicle_parameters;

dist = linspace(1,75,cock);

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
%legend('Constant \mu','Weight Transfer');
%plot(dist,cock,'.');
%yyaxis right
%plot(dist,penis,'.')
%legend('1st Coeff','2nd Coeff');

