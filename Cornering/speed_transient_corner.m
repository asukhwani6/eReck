%TODO: might still be fucked up need more testing

function [time,  v] = speed_transient_corner(straight_parameters,track_length, av_next, allowed_v, optim_number, entry_vel)

threshold = 0.01;
braking_a = -1.5 * 9.81; %max braking deceleration [m/s^2]

if (track_length > 40) %For effciency purposes
    d = linspace(track_length/3, track_length,optim_number);
else
    d = linspace(0.5, track_length,optim_number);
end

%fprintf("Allowed Cornering Velocity %3f\n",allowed_v);

%Optimization loop to calculate best brake balance
for i = 1:optim_number %always sweep from braking entire distance
    
    braking_distance = track_length - d(i);
    
    [accel_time, traveled_dis, accel_v] = acceleration_target(entry_vel, allowed_v,straight_parameters, d(i));
       
    [brake_time, exit_v] = brake_calculator(braking_a,braking_distance, accel_v(end));
    
    
    if (i ~=optim_number)
        if (abs(av_next - exit_v(end))<threshold || (exit_v(end) > av_next))
            break %end optimization
        end
    end
    
end

d_temp = traveled_dis + braking_distance; %Total distance from accel/brake

if d_temp < track_length
    t_c = (track_length - d_temp)/accel_v(end); %Time under steady state corner
    t_c = linspace(0,t_c,30);
    v_c = ones(30,1) .* accel_v(end);
    
    v = [accel_v; v_c; exit_v'];
    t_c = t_c + accel_time(end);
    brake_time = brake_time + t_c(end);
    
    time = [accel_time, t_c, brake_time];
else
    v = [accel_v; exit_v'];
    brake_time = brake_time + accel_time(end);
    time = [accel_time, brake_time];
end

% figure;
% hold on
% plot(braking_distance)
% plot(traveled_dis)
% plot(braking_distance + traveled_dis)
% yline(track_length)
% legend('Braking Dis', 'Traveled Dis', 'Brake + Travel')


%fprintf("End Velocity %3f\n",final_v);
