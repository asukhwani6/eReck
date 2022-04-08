track = "david.csv";
vehicle_parameters;
optim_number = 500; %Optimization discretization for braking
vel_start = 15;
 [time,  v, t, locations] = runLapSim(vel_start,track, straight_parameters, cornering_parameters,optim_number);
 
 %TODO: better corner accel
 %TODO: slip angle selection = wheelbase/radius
%%

vehicle_parameters;


vary_length = 10;

cl_range = linspace(0,4,vary_length);
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
%% plot 
figure

test = smoothdata(time,'gaussian',10);
surf(X,Y,test);
xlabel('C_L','FontSize',14)
ylabel('C_d','FontSize',14)
zlabel('Time [s]','FontSize',14)
view(45,30)
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

mask = (vehicle_speed(:,1) >= 4987) & (vehicle_speed(:,1) <= 5058);
time_new = vehicle_speed(mask,1) - min(vehicle_speed(mask,1));
speed_new = vehicle_speed(mask,2);
figure
%subplot(2,1,1)
hold on

data_distance = cumtrapz(time_new, speed_new);
sim_distance = cumtrapz(t(2:end),v(2:end));

plot(time_new,speed_new);
plot(t,v,'.-');

grid on
box on
xlabel('Time [s]');
xlim([0 t(end)])
ylabel('Velocity [m/s]');

for i = 1:length(locations)
    
    penis = sprintf('Element %d',i);
    xline(t(locations(i)),'-',penis);
    
end
legend('Raw Data', 'Sim Data')

%% CumTrapz not working
%subplot(2,1,2)
figure
hold on

plot(data_distance,speed_new);
plot(sim_distance,v(1:end-1),'.-');
legend('Raw Data', 'Sim Data')
grid on
box on
xlabel('Distance [m]');
%xlim([0 t(end)])
ylabel('Velocity [m/s]');

%% Power Limited Test

for i = 1:100
    [~,a(i)] = powerLimited(i,straight_parameters);
end

figure
plot(a)

%% Tests

cock = 1000;

dist = linspace(1,20,cock);

for i = 1:cock
    [~,v] = acceleration(0,dist(i),straight_parameters);
    v_max(i) = v(end);
end

figure
plot(dist,v_max,'.')
