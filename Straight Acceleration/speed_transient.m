function [time,  v, Ax, Ay] = speed_transient(track_length, track_radius, entry_vel, allowed_v, Ax_in, Parameters)

optim_number = Parameters.optim_number;

d = linspace(0.5, track_length,optim_number);

%fprintf("Allowed Cornering Velocity %3f\n",allowed_v);

%Optimization loop to calculate best brake balance
for i = 1:optim_number %always sweep from braking entire distance
    %fprintf("Optimizing brake/accel balance, Iteration %d\n",i);
    
    braking_distance = track_length - d(i);
    
    [accel_time, accel_v, accel_Ax, accel_Ay] = accel(track_radius, d(i), entry_vel, Ax_in, Parameters);
    
    %[brake_time, exit_v] = brake_calculator(braking_a,braking_distance, accel_v(end));
    [brake_time, brake_v, brake_Ax, brake_Ay] = braking(track_radius, braking_distance, accel_v(end), accel_Ax(end), Parameters);
    %fprintf("End Velocity %3f\n",final_v);
    if (i ~=1 && i ~=optim_number)
        if ((brake_v(end) > allowed_v(end)))
            brake_v = tempBrake_v;
            brake_time = tempBrake_time;
            break %end optimization
        end
    end
    tempBrake_v = brake_v;
    tempBrake_time = brake_time;
end

v = [accel_v, brake_v];
Ax = [accel_Ax, brake_Ax];
Ay = [accel_Ay, brake_Ay];
brake_time = brake_time + accel_time(end);

%fprintf("End Velocity %3f\n",final_v);
time = [accel_time,  brake_time];