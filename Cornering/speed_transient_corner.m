function [time,  v] = speed_transient_corner(Parameters,track_length, av_next, allowed_v, optim_number, entry_vel)

if (track_length > 40) %For efficiency purposes
    d = linspace(track_length/3, track_length,optim_number);
else
    d = linspace(0.5, track_length,optim_number);
end

%fprintf("Allowed Cornering Velocity %3f\n",allowed_v);

%Optimization loop to calculate best brake balance
for i = 1:optim_number %always sweep from braking entire distance
    
    braking_distance = track_length - d(i);
    
    [accel_time, accel_v, traveled_dis] = acceleration(entry_vel, allowed_v,d(i), Parameters,0);
    [brake_time, exit_v, ~] = braking(accel_v(end),braking_distance,Parameters);   
    %[brake_time, exit_v] = brake_calculator(braking_a,braking_distance, accel_v(end));
    
    if (i ~=1 && i ~=optim_number)
        if (exit_v(end) > av_next)
            exit_v = tempVec_v;
            brake_time = tempVec_t;
            traveled_dis = tempDistance;
            break %end optimization
        end
    end
    tempVec_v = exit_v;
    tempVec_t = brake_time;
    tempDistance = traveled_dis;
end

d_temp = traveled_dis + braking_distance; %Total distance from accel/brake

if d_temp < track_length
    t_c = (track_length - d_temp)/accel_v(end); %Time under steady state corner
    t_c = linspace(0,t_c,30);
    v_c = ones(30,1) .* accel_v(end);
    
    v = [accel_v; v_c; exit_v];
    t_c = t_c + accel_time(end);
    brake_time = brake_time + t_c(end);
    
    time = [accel_time, t_c, brake_time];
else
    v = [accel_v; exit_v];
    brake_time = brake_time + accel_time(end);
    time = [accel_time, brake_time];
end
