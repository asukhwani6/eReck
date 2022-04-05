track = "2021.csv";
vehicle_parameters;

optim_number = 1000; %Optimization discretization for braking

%parametrize any vehicle parameters in this loop:
for i = 1:1
    
    straight_parameters(1) = straight_parameters(1) - 10;
    cornering_parameters(1) = cornering_parameters(1) - 10;
    
    [time(i),  v, t, locations] = runLapSim(track, straight_parameters, cornering_parameters,optim_number);
    fprintf("For vehicle weight of %.1fkg, the lap time is: %.3fs\n",straight_parameters(1), time(i));
end

%% Data plot

figure
hold on
plot(t(2:end),v(2:end),'.-');

% This is for debugging
for i = 1:length(locations)
    
    penis = sprintf('Element %d',i);
    xline(t(locations(i)),'-',penis);
    
end

%% overlay


load('6_19_21_data.mat');
motor_speed = S.motor_speed;
vehicle_speed_mph = motor_speed;
vehicle_speed_mph(:,2) = -motor_speed(:,2).*0.225.*0.000284091.*pi.*60;

mask = (vehicle_speed_mph(:,1) >= 4987) & (vehicle_speed_mph(:,1) <= 5058);
time_new = vehicle_speed_mph(mask,1) - min(vehicle_speed_mph(mask,1));
speed_new = vehicle_speed_mph(mask,2)./2.237; %Convert to [m/s]

subplot(2,1,1)
hold on

data_distance = cumtrapz(time_new, speed_new);
sim_distance = cumtrapz(t(2:end),v(2:end));

plot(time_new,speed_new);
plot(t(2:end),v(2:end),'.-');
legend('Raw Data', 'Sim Data')
grid on
box on
xlabel('Time [s]');
xlim([0 t(end)])
ylabel('Velocity [m/s]');

subplot(2,1,2)
hold on

plot(data_distance,speed_new);
plot(sim_distance,v(2:end),'.-');
legend('Raw Data', 'Sim Data')
grid on
box on
xlabel('Distance [m]');
%xlim([0 t(end)])
ylabel('Velocity [m/s]');